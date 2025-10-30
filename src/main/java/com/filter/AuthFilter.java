package com.filter;

import java.io.IOException;
import javax.servlet.Filter;
import javax.servlet.FilterChain;
import javax.servlet.FilterConfig;
import javax.servlet.ServletException;
import javax.servlet.ServletRequest;
import javax.servlet.ServletResponse;
import javax.servlet.annotation.WebFilter;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

@WebFilter("/*")
public class AuthFilter implements Filter {

    @Override
    public void doFilter(ServletRequest request, ServletResponse response, 
            FilterChain chain) throws IOException, ServletException {
        
        HttpServletRequest httpRequest = (HttpServletRequest) request;
        HttpServletResponse httpResponse = (HttpServletResponse) response;
        HttpSession session = httpRequest.getSession(false);
        
        String requestURI = httpRequest.getRequestURI();
        String contextPath = httpRequest.getContextPath();
        
        // Allow public resources
        if (requestURI.startsWith(contextPath + "/assets/") ||
            requestURI.startsWith(contextPath + "/includes/") ||
            requestURI.endsWith(".css") ||
            requestURI.endsWith(".js") ||
            requestURI.endsWith(".jpg") ||
            requestURI.endsWith(".png")) {
            chain.doFilter(request, response);
            return;
        }
        
        // Allow public pages
        if (requestURI.endsWith("index.jsp") ||
            requestURI.endsWith("login.jsp") ||
            requestURI.endsWith("register.jsp") ||
            requestURI.endsWith("about.jsp") ||
            requestURI.endsWith("contact.jsp") ||
            requestURI.endsWith("error.jsp") ||
            requestURI.contains("/patient/auth") ||
            requestURI.contains("/doctor/auth") ||
            requestURI.contains("/admin/auth") ||
            requestURI.equals(contextPath + "/")) {
            chain.doFilter(request, response);
            return;
        }
        
        // Check patient access
        if (requestURI.contains("/patient/")) {
            if (session != null && session.getAttribute("patientObj") != null) {
                chain.doFilter(request, response);
            } else {
                httpResponse.sendRedirect(contextPath + "/patient/login.jsp");
            }
            return;
        }
        
        // Check doctor access
        if (requestURI.contains("/doctor/")) {
            if (session != null && session.getAttribute("doctorObj") != null) {
                chain.doFilter(request, response);
            } else {
                httpResponse.sendRedirect(contextPath + "/doctor/login.jsp");
            }
            return;
        }
        
        // Check admin access
        if (requestURI.contains("/admin/")) {
            if (session != null && session.getAttribute("adminObj") != null) {
                chain.doFilter(request, response);
            } else {
                httpResponse.sendRedirect(contextPath + "/admin/login.jsp");
            }
            return;
        }
        
        chain.doFilter(request, response);
    }

    @Override
    public void init(FilterConfig filterConfig) throws ServletException {}

    @Override
    public void destroy() {}
}