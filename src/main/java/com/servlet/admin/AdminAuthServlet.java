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