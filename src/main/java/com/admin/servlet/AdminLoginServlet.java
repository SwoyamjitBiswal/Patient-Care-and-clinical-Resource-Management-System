package com.admin.servlet;

import com.dao.AdminDao;
import com.entity.Admin;
import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

@WebServlet("/admin_login")
public class AdminLoginServlet extends HttpServlet {
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        String email = request.getParameter("email");
        String password = request.getParameter("password");

        AdminDao dao = new AdminDao();
        Admin admin = dao.adminLogin(email, password);

        if (admin != null) {
            HttpSession session = request.getSession();
            session.setAttribute("adminObj", admin);
            session.setAttribute("userName", admin.getFullName());
            session.setAttribute("userRole", "Admin");
            response.sendRedirect("admin/index.jsp"); // redirect to admin dashboard
        } else {
            response.sendRedirect("admin_login.jsp?error=Invalid+email+or+password");
        }
    }
}
