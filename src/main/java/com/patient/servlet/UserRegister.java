package com.patient.servlet;

import java.io.IOException;
import javax.servlet.*;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import com.dao.PatientDao;
import com.entity.Patient;
import com.db.DBConnect;

@WebServlet("/register")
public class UserRegister extends HttpServlet {
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String fullname = request.getParameter("fullname");
        String email = request.getParameter("email");
        String password = request.getParameter("password");
        String confirmPassword = request.getParameter("confirmPassword");
        String dob = request.getParameter("dob");
        String gender = request.getParameter("gender");
        String phone = request.getParameter("phone");
        String bloodGroup = request.getParameter("bloodGroup");
        String address = request.getParameter("address");
        String emergencyContactName = request.getParameter("emergencyContactName");
        String emergencyContactPhone = request.getParameter("emergencyContactPhone");

        HttpSession session = request.getSession();

        // Password match check
        if (!password.equals(confirmPassword)) {
            session.setAttribute("errorMsg", "Passwords do not match!");
            response.sendRedirect("patient/patient_signup.jsp");
            return;
        }

        Patient p = new Patient();
        p.setFullname(fullname);
        p.setEmail(email);
        p.setPassword(password);
        p.setDob(dob);
        p.setGender(gender);
        p.setPhone(phone);
        p.setBloodGroup(bloodGroup);
        p.setAddress(address);
        p.setEmergencyContactName(emergencyContactName);
        p.setEmergencyContactPhone(emergencyContactPhone);

        PatientDao dao = new PatientDao(DBConnect.getConnection());
        boolean f = dao.registerPatient(p);

        if (f) {
            session.setAttribute("sucMsg", "Registration Successful! You can now login.");
            response.sendRedirect("patient/patient_signup.jsp");
        } else {
            session.setAttribute("errorMsg", "Something went wrong on the server!");
            response.sendRedirect("patient/patient_signup.jsp");
        }
    }
}
