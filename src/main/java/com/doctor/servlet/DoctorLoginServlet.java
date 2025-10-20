package com.doctor.servlet;

import com.dao.DoctorDao;
import com.entity.Doctor;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;

@WebServlet("/loginDoctor")
public class DoctorLoginServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String email = request.getParameter("email");
        String password = request.getParameter("password");

        DoctorDao dao = new DoctorDao();
        Doctor doctor = dao.loginDoctor(email, password);

        HttpSession session = request.getSession();
        if (doctor != null) {
            // ✅ Successful login
            session.setAttribute("doctorObj", doctor);
            session.setAttribute("userName", doctor.getFullName());
            session.setAttribute("userRole", "Doctor");
            session.setAttribute("successMsg", "Login successful!");
            response.sendRedirect("doctor/doctors_dashboard.jsp"); // <-- fixed redirect
        } else {
            // ❌ Failed login
            session.setAttribute("errorMsg", "Invalid Email & Password or account not approved!");
            response.sendRedirect("doctor_login.jsp");
        }
    }
}
