package com.patient.servlet;

import java.io.IOException;
import javax.servlet.*;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;

@WebServlet("/patient/bookAppointment")
public class BookAppointmentServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        HttpSession session = request.getSession(false); // don't create new
        if (session == null || session.getAttribute("userObj") == null) {
            // User not logged in → redirect to login page
            response.sendRedirect(request.getContextPath() + "/patient/patient_login.jsp");
            return;
        }

        // User logged in → forward to JSP
        RequestDispatcher rd = request.getRequestDispatcher("/patient/book_appointment.jsp");
        rd.forward(request, response);
    }

    // POST method for saving appointment (optional)
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // Handle appointment booking logic here
    }
}
