package com.patient.servlet;

import java.io.IOException;
import java.sql.*;
import javax.servlet.*;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import com.entity.Patient;

@WebServlet("/patient/patientLogin")
public class PatientLogin extends HttpServlet {
    private static final long serialVersionUID = 1L;

    // Database configuration
    private static final String DB_URL = "jdbc:mysql://localhost:3306/patient_care_crms";
    private static final String DB_USER = "root";
    private static final String DB_PASSWORD = "jagan12@";

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);

        // ✅ Check if user is already logged in
        if (session != null && session.getAttribute("patientId") != null) {
            session.setAttribute("warningMsg", "You are already logged in as " + session.getAttribute("patientName") + "!");
            response.sendRedirect(request.getContextPath() + "/patient/index.jsp");
            return;
        }

        String email = request.getParameter("email");
        String password = request.getParameter("password");

        try {
            Class.forName("com.mysql.cj.jdbc.Driver");

            try (Connection con = DriverManager.getConnection(DB_URL, DB_USER, DB_PASSWORD)) {

                String sql = "SELECT * FROM patient WHERE email=? AND password=?";
                PreparedStatement ps = con.prepareStatement(sql);
                ps.setString(1, email);
                ps.setString(2, password);

                ResultSet rs = ps.executeQuery();

                if (rs.next()) {
                    Patient patient = new Patient();
                    patient.setId(rs.getInt("id"));
                    patient.setFullname(rs.getString("fullname"));
                    patient.setEmail(rs.getString("email"));
                    patient.setPassword(rs.getString("password"));
                    patient.setDob(rs.getString("dob"));
                    patient.setGender(rs.getString("gender"));
                    patient.setPhone(rs.getString("phone"));
                    patient.setBloodGroup(rs.getString("bloodGroup"));
                    patient.setAddress(rs.getString("address"));
                    patient.setEmergencyContactName(rs.getString("emergencyContactName"));
                    patient.setEmergencyContactPhone(rs.getString("emergencyContactPhone"));

                    // ✅ Store Patient object in session
                    session = request.getSession();
                    session.setAttribute("patientId", patient.getId());
                    session.setAttribute("patientName", patient.getFullname());
                    session.setMaxInactiveInterval(30 * 60); // 30 mins
                    session.setAttribute("userName", patient.getFullname());
                    session.setAttribute("userRole", "Patient");
                    response.sendRedirect(request.getContextPath() + "/patient/index.jsp");
                } else {
                    request.setAttribute("errorMsg", "Invalid email or password! Please try again.");
                    RequestDispatcher rd = request.getRequestDispatcher("/patient/patient_login.jsp");
                    rd.forward(request, response);
                }
            }

        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("errorMsg", "Something went wrong! Please try again later.");
            RequestDispatcher rd = request.getRequestDispatcher("/patient/patient_login.jsp");
            rd.forward(request, response);
        }
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.getWriter().println("PatientLogin servlet working correctly!");
    }
}
