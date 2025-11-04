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

    // 1. Initialization: Instantiates the DAO once when the servlet starts.
    @Override
    public void init() throws ServletException {
        // Instantiate the DAO using the no-argument constructor
        adminDao = new AdminDao(); 
    }

    
    // 2. Handles POST requests (Login, Logout)
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String action = request.getParameter("action");

        if ("login".equalsIgnoreCase(action)) {
            loginAdmin(request, response);
        } else if ("logout".equalsIgnoreCase(action)) {
            logoutAdmin(request, response);
        } else {
            // Default action if an unknown POST request comes in
            response.sendRedirect("login.jsp");
        }
    }
    
    // 3. Handles GET requests (primarily for Logout)
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        String action = request.getParameter("action");
        if ("logout".equalsIgnoreCase(action)) {
            logoutAdmin(request, response);
        } else {
            response.sendRedirect("login.jsp");
        }
    }

