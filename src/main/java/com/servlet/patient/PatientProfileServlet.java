package com.servlet.patient;

import com.dao.PatientDao;
import com.entity.Patient;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;
import java.sql.Date;
import java.sql.SQLException; // Import SQLException for DAO call

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
        
        HttpSession session = request.getSession(false); // Use false to avoid creating a new session
        
        if (session == null || session.getAttribute("patientObj") == null) {
             // If session is null or patient object is missing, redirect to login
            response.sendRedirect(request.getContextPath() + "/patient/login.jsp");
            return;
        }
        
        Patient patient = (Patient) session.getAttribute("patientObj");
        
        // Get fresh data from database
        Patient freshPatient = patientDao.getPatientById(patient.getId());
        if (freshPatient != null) {
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
        } else if ("delete".equals(action)) { // **HANDLE DELETE ACTION**
            deleteAccount(request, response);
        } else {
             // Default action if an unknown action parameter is passed
            response.sendRedirect(request.getContextPath() + "/patient/dashboard.jsp");
        }
    }

    // Update patient profile
    private void updateProfile(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        try {
            HttpSession session = request.getSession(false);
            if (session == null || session.getAttribute("patientObj") == null) {
                response.sendRedirect(request.getContextPath() + "/patient/login.jsp");
                return;
            }
            
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
            HttpSession session = request.getSession(false);
            if (session == null || session.getAttribute("patientObj") == null) {
                response.sendRedirect(request.getContextPath() + "/patient/login.jsp");
                return;
            }
            
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

    /**
     * Handles the permanent deletion of the patient account and related data.
     */
    private void deleteAccount(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        HttpSession session = request.getSession(false);
        
        // 1. Authorization Check
        if (session == null || session.getAttribute("patientObj") == null) {
            response.sendRedirect(request.getContextPath() + "/patient/login.jsp");
            return;
        }

        Patient patient = (Patient) session.getAttribute("patientObj");
        int patientId = patient.getId();
        boolean success = false;
        
        try {
            // 2. Call transactional DAO method
            success = patientDao.deletePatient(patientId);

            if (success) {
                // 3. Deletion successful: Invalidate session and redirect to login
                session.invalidate(); 
                
                // Add success message to be picked up by the login page (via URL parameter)
                response.sendRedirect(request.getContextPath() + "/patient/login.jsp?successMsg=Your account has been permanently deleted.");
                
            } else {
                // 4. Deletion failed (e.g., patient ID not found, but transaction was clean)
                request.setAttribute("errorMsg", "Account deletion failed. No records were deleted.");
                request.getRequestDispatcher("profile.jsp").forward(request, response);
            }
            
        } catch (SQLException e) {
            // 5. Handle SQL Exception (usually means transaction rollback)
            e.printStackTrace();
            request.setAttribute("errorMsg", "An internal error occurred during deletion. No changes were made.");
            request.getRequestDispatcher("profile.jsp").forward(request, response);
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("errorMsg", "An unknown error occurred.");
            request.getRequestDispatcher("profile.jsp").forward(request, response);
        }
    }
}