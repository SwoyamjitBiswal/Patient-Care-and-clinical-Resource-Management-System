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

        if ("register".equalsIgnoreCase(action)) {
            registerAdmin(request, response);
        } else if ("login".equalsIgnoreCase(action)) {
            loginAdmin(request, response);
        } else if ("logout".equalsIgnoreCase(action)) {
            logoutAdmin(request, response);
        } else {
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

    // Admin registration
    private void registerAdmin(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        try {
            String fullName = request.getParameter("fullName");
            String email = request.getParameter("email");
            String password = request.getParameter("password");

            if (adminDao.isEmailExists(email)) {
                request.setAttribute("errorMsg", "Email already exists. Please use a different email.");
                request.getRequestDispatcher("register.jsp").forward(request, response);
                return;
            }

            Admin admin = new Admin(fullName, email, password);

            boolean success = adminDao.registerAdmin(admin);

            if (success) {
                response.sendRedirect("login.jsp?success=1");
            } else {
                request.setAttribute("errorMsg", "Registration failed. Please try again.");
                request.getRequestDispatcher("register.jsp").forward(request, response);
            }

        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("errorMsg", "An error occurred during registration.");
            request.getRequestDispatcher("register.jsp").forward(request, response);
        }
    }

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
