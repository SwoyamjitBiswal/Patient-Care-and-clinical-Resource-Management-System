package com.servlet.admin;

import com.dao.AdminDao;
import com.entity.Admin;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;

@WebServlet("/admin/auth")
public class AdminAuthServlet extends HttpServlet {
    private AdminDao adminDao;

    @Override
    public void init() throws ServletException {
        adminDao = new AdminDao();
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String action = request.getParameter("action");

        // Removed the 'register' block
        if ("login".equalsIgnoreCase(action)) {
            loginAdmin(request, response);
        } else if ("logout".equalsIgnoreCase(action)) {
            logoutAdmin(request, response);
        } else {
            // Default action if a POST request comes in without a valid action
            response.sendRedirect("login.jsp");
        }
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // Allow logout from GET request too
        String action = request.getParameter("action");
        if ("logout".equalsIgnoreCase(action)) {
            logoutAdmin(request, response);
        } else {
            response.sendRedirect("login.jsp");
        }
    }

    // ⛔ Removed: Admin registration logic is no longer allowed.
    /*
    private void registerAdmin(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // ... registration code was here ...
    }
    */

    // Admin login
    private void loginAdmin(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        try {
            String email = request.getParameter("email");
            String password = request.getParameter("password");

            Admin admin = adminDao.login(email, password);

            if (admin != null) {
                HttpSession session = request.getSession();
                session.setAttribute("adminObj", admin);
                response.sendRedirect("dashboard.jsp");
            } else {
                request.setAttribute("errorMsg", "Invalid email or password");
                request.getRequestDispatcher("login.jsp").forward(request, response);
            }

        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("errorMsg", "An error occurred during login.");
            request.getRequestDispatcher("login.jsp").forward(request, response);
        }
    }

    // Admin logout → Redirect to main index page
    private void logoutAdmin(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        if (session != null) {
            session.invalidate();
        }
        response.sendRedirect(request.getContextPath() + "/index.jsp");
    }
}