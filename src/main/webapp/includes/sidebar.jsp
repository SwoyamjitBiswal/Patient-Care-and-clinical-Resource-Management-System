<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
    String userRole = "";
    if (session.getAttribute("patientObj") != null) {
        userRole = "patient";
    } else if (session.getAttribute("doctorObj") != null) {
        userRole = "doctor";
    } else if (session.getAttribute("adminObj") != null) {
        userRole = "admin";
    }
%>

<!-- Sidebar -->
<div class="sidebar bg-primary text-white">
    <div class="sidebar-sticky">
        <div class="p-4">
            <h4 class="text-white text-center mb-4">
                <i class="fas fa-hospital-alt me-2"></i>MediCare
            </h4>
            
            <% if ("patient".equals(userRole)) { %>
                <ul class="nav flex-column">
                    <li class="nav-item">
                        <a class="nav-link text-white ${param.active == 'dashboard' ? 'active bg-dark' : ''}" 
                           href="${pageContext.request.contextPath}/patient/dashboard.jsp">
                            <i class="fas fa-tachometer-alt me-2"></i>Dashboard
                        </a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link text-white ${param.active == 'profile' ? 'active bg-dark' : ''}" 
                           href="${pageContext.request.contextPath}/patient/PatientProfile?action=view">
                            <i class="fas fa-user me-2"></i>My Profile
                        </a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link text-white ${param.active == 'book' ? 'active bg-dark' : ''}" 
                           href="${pageContext.request.contextPath}/patient/PatientAppointment?action=book">
                            <i class="fas fa-calendar-plus me-2"></i>Book Appointment
                        </a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link text-white ${param.active == 'appointments' ? 'active bg-dark' : ''}" 
                           href="${pageContext.request.contextPath}/patient/PatientAppointment?action=view">
                            <i class="fas fa-list-alt me-2"></i>My Appointments
                        </a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link text-white ${param.active == 'password' ? 'active bg-dark' : ''}" 
                           href="${pageContext.request.contextPath}/patient/change_password.jsp">
                            <i class="fas fa-key me-2"></i>Change Password
                        </a>
                    </li>
                </ul>
            <% } else if ("doctor".equals(userRole)) { %>
                <ul class="nav flex-column">
                    <li class="nav-item">
                        <a class="nav-link text-white ${param.active == 'dashboard' ? 'active bg-dark' : ''}" 
                           href="${pageContext.request.contextPath}/doctor/dashboard.jsp">
                            <i class="fas fa-tachometer-alt me-2"></i>Dashboard
                        </a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link text-white ${param.active == 'profile' ? 'active bg-dark' : ''}" 
                           href="${pageContext.request.contextPath}/doctor/DoctorProfile?action=view">
                            <i class="fas fa-user-md me-2"></i>My Profile
                        </a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link text-white ${param.active == 'appointments' ? 'active bg-dark' : ''}" 
                           href="${pageContext.request.contextPath}/doctor/DoctorAppointment?action=view">
                            <i class="fas fa-calendar-check me-2"></i>Appointments
                        </a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link text-white ${param.active == 'password' ? 'active bg-dark' : ''}" 
                           href="${pageContext.request.contextPath}/doctor/change_password.jsp">
                            <i class="fas fa-key me-2"></i>Change Password
                        </a>
                    </li>
                </ul>
            <% } else if ("admin".equals(userRole)) { %>
                <ul class="nav flex-column">
                    <li class="nav-item">
                        <a class="nav-link text-white ${param.active == 'dashboard' ? 'active bg-dark' : ''}" 
                           href="${pageContext.request.contextPath}/admin/dashboard.jsp">
                            <i class="fas fa-tachometer-alt me-2"></i>Dashboard
                        </a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link text-white ${param.active == 'profile' ? 'active bg-dark' : ''}" 
                           href="${pageContext.request.contextPath}/admin/AdminProfile?action=view">
                            <i class="fas fa-user-shield me-2"></i>My Profile
                        </a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link text-white ${param.active == 'doctors' ? 'active bg-dark' : ''}" 
                           href="${pageContext.request.contextPath}/admin/AdminManagement?action=view&entity=doctors">
                            <i class="fas fa-user-md me-2"></i>Manage Doctors
                        </a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link text-white ${param.active == 'patients' ? 'active bg-dark' : ''}" 
                           href="${pageContext.request.contextPath}/admin/AdminManagement?action=view&entity=patients">
                            <i class="fas fa-users me-2"></i>Manage Patients
                        </a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link text-white ${param.active == 'appointments' ? 'active bg-dark' : ''}" 
                           href="${pageContext.request.contextPath}/admin/AdminManagement?action=view&entity=appointments">
                            <i class="fas fa-calendar-alt me-2"></i>Manage Appointments
                        </a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link text-white ${param.active == 'password' ? 'active bg-dark' : ''}" 
                           href="${pageContext.request.contextPath}/admin/change_password.jsp">
                            <i class="fas fa-key me-2"></i>Change Password
                        </a>
                    </li>
                </ul>
            <% } %>
        </div>
    </div>
</div>