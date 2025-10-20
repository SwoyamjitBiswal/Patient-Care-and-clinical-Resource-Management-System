package com.doctor.servlet;

import com.dao.DoctorDao;
import com.entity.Doctor;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;

@WebServlet("/registerDoctor")
public class DoctorRegisterServlet extends HttpServlet {
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {

        // Fetch form parameters
        String fullName = request.getParameter("fullname");
        String email = request.getParameter("email");
        String password = request.getParameter("password");
        String specialization = request.getParameter("specialization");
        String licenseNumber = request.getParameter("licenseNumber");
        int years = Integer.parseInt(request.getParameter("yearsOfExperience"));
        String qualification = request.getParameter("qualification");
        String phone = request.getParameter("phone");
        String department = request.getParameter("department");
        String clinicAddress = request.getParameter("clinicAddress");
        String availability = request.getParameter("availability");

        // New field: Consulting fee / visiting charge
        double visitingCharge = 0.0;
        String visitingChargeStr = request.getParameter("visitingCharge");
        if (visitingChargeStr != null && !visitingChargeStr.isEmpty()) {
            try {
                visitingCharge = Double.parseDouble(visitingChargeStr);
            } catch (NumberFormatException e) {
                visitingCharge = 0.0; // default if parsing fails
            }
        }

        // Create Doctor object including visiting charge
        Doctor doctor = new Doctor(fullName, email, password, specialization, licenseNumber,
                years, qualification, phone, department, clinicAddress, availability);
        doctor.setVisitingCharge(visitingCharge); // set the consulting fee

        DoctorDao dao = new DoctorDao();
        HttpSession session = request.getSession();

        // Save doctor
        if(dao.registerDoctor(doctor)) {
            session.setAttribute("successMsg", "Registration successful! Wait for admin approval.");
            response.sendRedirect("doctor/doctor_register.jsp");
        } else {
            session.setAttribute("errorMsg", "Something went wrong. Try again.");
            response.sendRedirect("doctor/doctor_register.jsp");
        }
    }
}
