package com.servlet.patient;

import com.dao.PatientDao;
import com.entity.Patient;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;
import java.sql.Date;

@WebServlet("/patient/profile")
public class PatientProfileServlet extends HttpServlet {
    private PatientDao patientDao;

    @Override
    public void init() throws ServletException {
        patientDao = new PatientDao();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        HttpSession session = request.getSession();
        Patient patient = (Patient) session.getAttribute("patientObj");
        
        if (patient != null) {
            // Get fresh data from database
            Patient freshPatient = patientDao.getPatientById(patient.getId());
            session.setAttribute("patientObj", freshPatient);
        }
        
        request.getRequestDispatcher("profile.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        String action = request.getParameter("action");
        
        if ("update".equals(action)) {
            updateProfile(request, response);
        } else if ("changePassword".equals(action)) {
            changePassword(request, response);
        }
    }

    // Update patient profile
    private void updateProfile(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        try {
            HttpSession session = request.getSession();
            Patient patient = (Patient) session.getAttribute("patientObj");
            
            String fullName = request.getParameter("fullName");
            String phone = request.getParameter("phone");
            String address = request.getParameter("address");
            String gender = request.getParameter("gender");
            String bloodGroup = request.getParameter("bloodGroup");
            Date dateOfBirth = Date.valueOf(request.getParameter("dateOfBirth"));
            String emergencyContact = request.getParameter("emergencyContact");
            String medicalHistory = request.getParameter("medicalHistory");
            
            patient.setFullName(fullName);
            patient.setPhone(phone);
            patient.setAddress(address);
            patient.setGender(gender);
            patient.setBloodGroup(bloodGroup);
            patient.setDateOfBirth(dateOfBirth);
            patient.setEmergencyContact(emergencyContact);
            patient.setMedicalHistory(medicalHistory);
            
            boolean success = patientDao.updatePatient(patient);
            
            if (success) {
                session.setAttribute("patientObj", patient);
                request.setAttribute("successMsg", "Profile updated successfully!");
            } else {
                request.setAttribute("errorMsg", "Failed to update profile. Please try again.");
            }
            
            request.getRequestDispatcher("profile.jsp").forward(request, response);
            
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("errorMsg", "An error occurred while updating profile.");
            request.getRequestDispatcher("profile.jsp").forward(request, response);
        }
    }

    // Change patient password
    private void changePassword(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        try {
            HttpSession session = request.getSession();
            Patient patient = (Patient) session.getAttribute("patientObj");
            
            String currentPassword = request.getParameter("currentPassword");
            String newPassword = request.getParameter("newPassword");
            String confirmPassword = request.getParameter("confirmPassword");
            
            // Verify current password
            if (!patient.getPassword().equals(currentPassword)) {
                request.setAttribute("errorMsg", "Current password is incorrect.");
                request.getRequestDispatcher("change_password.jsp").forward(request, response);
                return;
            }
            
            // Check if new password matches confirmation
            if (!newPassword.equals(confirmPassword)) {
                request.setAttribute("errorMsg", "New password and confirm password do not match.");
                request.getRequestDispatcher("change_password.jsp").forward(request, response);
                return;
            }
            
            boolean success = patientDao.changePassword(patient.getId(), newPassword);
            
            if (success) {
                patient.setPassword(newPassword);
                session.setAttribute("patientObj", patient);
                request.setAttribute("successMsg", "Password changed successfully!");
            } else {
                request.setAttribute("errorMsg", "Failed to change password. Please try again.");
            }
            
            request.getRequestDispatcher("change_password.jsp").forward(request, response);
            
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("errorMsg", "An error occurred while changing password.");
            request.getRequestDispatcher("change_password.jsp").forward(request, response);
        }
    }
}