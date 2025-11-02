<%@ page import="com.entity.Admin" %>
<%@ page import="com.dao.AppointmentDao" %>
<%@ page import="com.dao.DoctorDao" %>
<%@ page import="com.dao.PatientDao" %>
<%@ page import="com.entity.Appointment" %>
<%@ page import="com.entity.Doctor" %>
<%@ page import="com.entity.Patient" %>
<%@ page import="java.util.List" %>
<%@ page import="java.util.Set" %>
<%@ page import="java.util.HashSet" %>
<%@ page import="java.text.SimpleDateFormat" %>
<%@ page import="java.util.Map" %>
<%@ page import="java.util.LinkedHashMap" %>
<%
    // Admin authentication
    Admin currentAdmin = (Admin) session.getAttribute("adminObj");
    if (currentAdmin == null) {
        response.sendRedirect(request.getContextPath() + "/admin/login.jsp");
        return;
    }

    // Message handling
    String successMsg = (String) session.getAttribute("successMsg");
    String errorMsg = (String) session.getAttribute("errorMsg");

    if (successMsg != null) {
        session.removeAttribute("successMsg");
    }
    if (errorMsg != null) {
        session.removeAttribute("errorMsg");
    }

    if (request.getAttribute("successMsg") != null) {
        successMsg = (String) request.getAttribute("successMsg");
    }
    if (request.getAttribute("errorMsg") != null) {
        errorMsg = (String) request.getAttribute("errorMsg");
    }

    // Data initialization
    AppointmentDao appointmentDao = new AppointmentDao();
    DoctorDao doctorDao = new DoctorDao();
    PatientDao patientDao = new PatientDao();

    int[] appointmentStats = appointmentDao.getAppointmentStats();
    int totalDoctors = doctorDao.getTotalDoctors();
    int totalPatients = patientDao.getTotalPatients();
    
    List<Appointment> appointments = appointmentDao.getAllAppointments();

    // Calculate counts
    long pendingCount = appointments.stream().filter(a -> a.getStatus() == null || "Pending".equals(a.getStatus())).count();
    long confirmedCount = appointments.stream().filter(a -> "Confirmed".equals(a.getStatus())).count();
    long completedCount = appointments.stream().filter(a -> "Completed".equals(a.getStatus())).count();
    long cancelledCount = appointments.stream().filter(a -> "Cancelled".equals(a.getStatus())).count();
    long followUpCount = appointments.stream().filter(Appointment::isFollowUpRequired).count();

    String currentUserRole = "admin";
    
    SimpleDateFormat dateFormat = new SimpleDateFormat("yyyy-MM-dd");
    SimpleDateFormat timeFormat = new SimpleDateFormat("HH:mm");
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Patient Care System - Manage Appointments</title>

    <!-- Bootstrap 5 CSS -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" rel="stylesheet">
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
</head>
<body>
    <button class="mobile-menu-toggle" id="mobileMenuToggle">
        <i class="fas fa-bars"></i>
    </button>
    
    <div class="sidebar" id="sidebar">
        <div class="sidebar-sticky">
            <div class="user-section">
                <div class="user-avatar">
                   <i class="fas fa-user-shield"></i>
                </div>
                <div class="user-info">
                   <% if (currentAdmin != null) { %>
                    <h6><%= currentAdmin.getFullName() %></h6>
                    <span class="badge">Administrator</span>
                   <% } %>
                </div>
            </div>

            <div class="nav-main">
                <ul class="nav">
                    <li class="nav-item">
                        <a class="nav-link" href="${pageContext.request.contextPath}/admin/dashboard.jsp">
                            <i class="fas fa-tachometer-alt"></i>
                            <span>Dashboard</span>
                        </a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link" href="${pageContext.request.contextPath}/admin/profile.jsp">
                            <i class="fas fa-user"></i>
                            <span>My Profile</span>
                        </a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link" href="${pageContext.request.contextPath}/admin/management?action=view&type=doctors">
                            <i class="fas fa-user-md"></i>
                            <span>Manage Doctors</span>
                        </a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link" href="${pageContext.request.contextPath}/admin/management?action=view&type=patients">
                            <i class="fas fa-users"></i>
                            <span>Manage Patients</span>
                        </a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link active" href="${pageContext.request.contextPath}/admin/management?action=view&type=appointments">
                            <i class="fas fa-calendar-alt"></i>
                            <span>Manage Appointments</span>
                        </a>
                    </li>
                </ul>
            </div>

            <div class="nav-bottom">
                 <ul class="nav">
                     <li class="nav-item">
                        <a class="nav-link" href="${pageContext.request.contextPath}/index.jsp">
                            <i class="fas fa-home"></i>
                            <span>Back to Home</span>
                        </a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link nav-link-logout" href="${pageContext.request.contextPath}/admin/auth?action=logout">
                            <i class="fas fa-sign-out-alt"></i>
                            <span>Logout</span>
                        </a>
                    </li>
                 </ul>
            </div>
        </div>
    </div>
    
    <main class="main-content main-content-flush">
        <div class="profile-header">
            <div class="d-flex justify-content-between align-items-center">
                <div>
                    <h1 class="h2 mb-2">
                        <i class="fas fa-calendar-alt me-2"></i>
                        Manage Appointments
                    </h1>
                    <p class="mb-0 opacity-75">View and manage all patient appointments</p>
                </div>
                <div>
                    <a href="${pageContext.request.contextPath}/admin/dashboard.jsp" class="back-link">
                        <i class="fas fa-arrow-left me-2"></i>Back to Dashboard
                    </a>
                </div>
            </div>
        </div>

        <div class="main-content-dashboard">
            <%-- Success/Error Messages --%>
            <%
                if (successMsg != null && !successMsg.isEmpty()) {
            %>
                <div class="alert alert-success alert-modern alert-dismissible fade show mb-4" role="alert">
                    <div class="d-flex align-items-center">
                        <i class="fas fa-check-circle me-3 fs-5"></i>
                        <div class="flex-grow-1"><%= successMsg %></div>
                    </div>
                    <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
                </div>
            <%
                }
                if (errorMsg != null && !errorMsg.isEmpty()) {
            %>
                <div class="alert alert-danger alert-modern alert-dismissible fade show mb-4" role="alert">
                    <div class="d-flex align-items-center">
                        <i class="fas fa-exclamation-triangle me-3 fs-5"></i>
                        <div class="flex-grow-1"><%= errorMsg %></div>
                    </div>
                    <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
                </div>
            <%
                }
            %>

            <%-- Stats Cards --%>
            <div class="row mb-4">
                <div class="col-xl-3 col-md-6 mb-4">
                    <div class="stats-card stats-card-primary">
                        <h4 class="mb-1"><%= appointments.size() %></h4>
                        <small>Total Appointments</small>
                    </div>
                </div>
                <div class="col-xl-3 col-md-6 mb-4">
                    <div class="stats-card stats-card-warning">
                        <h4 class="mb-1"><%= pendingCount %></h4>
                        <small>Pending</small>
                    </div>
                </div>
                <div class="col-xl-3 col-md-6 mb-4">
                    <div class="stats-card stats-card-success">
                        <h4 class="mb-1"><%= confirmedCount %></h4>
                        <small>Confirmed</small>
                    </div>
                </div>
                <div class="col-xl-3 col-md-6 mb-4">
                    <div class="stats-card stats-card-info">
                        <h4 class="mb-1"><%= completedCount %></h4>
                        <small>Completed</small>
                    </div>
                </div>
            </div>

            <%-- Filter Card --%>
            <div class="card card-modern mb-4">
                <div class="card-header-modern">
                    <i class="fas fa-filter"></i>
                    <span>Filter Appointments</span>
                </div>
                <div class="card-body p-4">
                    <div class="row align-items-end">
                        <div class="col-md-3">
                            <label class="form-label" for="statusFilter">Status</label>
                            <div class="input-group">
                                <span class="input-group-text">
                                    <i class="fas fa-tag text-primary"></i>
                                </span>
                                <select class="form-select" id="statusFilter">
                                    <option value="all" selected>All Statuses</option>
                                    <option value="pending">Pending</option>
                                    <option value="confirmed">Confirmed</option>
                                    <option value="completed">Completed</option>
                                    <option value="cancelled">Cancelled</option>
                                </select>
                            </div>
                        </div>
                        <div class="col-md-3">
                            <label class="form-label" for="doctorFilter">Doctor</label>
                            <div class="input-group">
                                <span class="input-group-text">
                                    <i class="fas fa-user-md text-primary"></i>
                                </span>
                                <select class="form-select" id="doctorFilter">
                                    <option value="all" selected>All Doctors</option>
                                    <%
                                        Set<String> doctorNames = new HashSet<>();
                                        for (Appointment app : appointments) {
                                            doctorNames.add(app.getDoctorName());
                                        }
                                        for (String doctorName : doctorNames) {
                                    %>
                                        <option value="<%= doctorName.toLowerCase() %>">Dr. <%= doctorName %></option>
                                    <%
                                        }
                                    %>
                                </select>
                            </div>
                        </div>
                        <div class="col-md-3">
                            <label class="form-label" for="dateFilter">Date</label>
                            <div class="input-group">
                                <span class="input-group-text">
                                    <i class="fas fa-calendar text-primary"></i>
                                </span>
                                <input type="date" class="form-control" id="dateFilter">
                            </div>
                        </div>
                        <div class="col-md-3">
                            <button type="button" id="clearFilters" class="btn btn-outline-secondary w-100 py-2">
                                <i class="fas fa-eraser me-2"></i>Clear Filters
                            </button>
                        </div>
                    </div>
                </div>
            </div>

            <%-- Appointments Table --%>
            <div class="card card-modern">
                <div class="card-header-modern d-flex justify-content-between align-items-center">
                    <div>
                        <i class="fas fa-list"></i>
                        <span>All Appointments</span>
                        <span class="badge bg-primary ms-2"><%= appointments.size() %> Total</span>
                    </div>
                    <div>
                        <button class="btn btn-sm btn-outline-primary" id="exportBtn">
                            <i class="fas fa-download me-1"></i>Export
                        </button>
                    </div>
                </div>
                <div class="card-body p-4">
                    <%
                        if (appointments.isEmpty()) {
                    %>
                        <div class="empty-state">
                            <i class="fas fa-calendar-times"></i>
                            <h4 class="text-muted">No Appointments Found</h4>
                            <p class="text-muted">No appointments match the current filters or none exist.</p>
                        </div>
                    <%
                        } else {
                    %>
                        <div class="table-responsive">
                            <table class="table table-hover" id="appointmentsTable">
                                <thead>
                                    <tr>
                                        <th>Appt. ID</th>
                                        <th>Patient</th>
                                        <th>Doctor</th>
                                        <th>Date & Time</th>
                                        <th>Type</th>
                                        <th>Status</th>
                                        <th>Actions</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <%
                                        for (Appointment appointment : appointments) {
                                            String statusBadgeClass = "";
                                            String statusIcon = "";
                                            String status = appointment.getStatus();

                                            if ("Confirmed".equals(status)) {
                                                statusBadgeClass = "badge-confirmed";
                                                statusIcon = "fas fa-check-circle";
                                            } else if ("Completed".equals(status)) {
                                                statusBadgeClass = "badge-completed";
                                                statusIcon = "fas fa-calendar-check";
                                            } else if ("Cancelled".equals(status)) {
                                                statusBadgeClass = "badge-cancelled";
                                                statusIcon = "fas fa-times-circle";
                                            } else {
                                                status = "Pending";
                                                statusBadgeClass = "badge-pending";
                                                statusIcon = "fas fa-clock";
                                            }
                                            
                                            String createdAtFormatted = "";
                                            if (appointment.getCreatedAt() != null) {
                                                createdAtFormatted = dateFormat.format(appointment.getCreatedAt());
                                            }
                                    %>
                                        <tr data-status="<%= status.toLowerCase() %>"
                                            data-doctor="<%= appointment.getDoctorName().toLowerCase() %>"
                                            data-date="<%= appointment.getAppointmentDate() %>">
                                            <td>
                                                <strong>#<%= appointment.getId() %></strong><br>
                                                <small class="text-muted"><%= createdAtFormatted %></small>
                                            </td>
                                            <td>
                                                <div class="d-flex align-items-center">
                                                    <div class="icon-box icon-primary me-3 d-none d-md-flex">
                                                        <i class="fas fa-user"></i>
                                                    </div>
                                                    <div>
                                                        <strong><%= appointment.getPatientName() %></strong><br>
                                                        <small class="text-muted">ID: PAT<%= appointment.getPatientId() %></small>
                                                    </div>
                                                </div>
                                            </td>
                                            <td>
                                                <div class="d-flex align-items-center">
                                                    <div class="icon-box icon-success me-3 d-none d-md-flex">
                                                        <i class="fas fa-user-md"></i>
                                                    </div>
                                                    <div>
                                                        <strong>Dr. <%= appointment.getDoctorName() %></strong><br>
                                                        <small class="text-muted"><%= appointment.getDoctorSpecialization() %></small>
                                                    </div>
                                                </div>
                                            </td>
                                            <td>
                                                <strong><%= appointment.getAppointmentDate() %></strong><br>
                                                <small class="text-muted">
                                                    <i class="fas fa-clock me-1"></i>
                                                    <%= appointment.getAppointmentTime() %>
                                                </small>
                                            </td>
                                            <td>
                                                <span class="badge bg-light text-dark">
                                                    <i class="<%= "In-person".equals(appointment.getAppointmentType()) ? "fas fa-hospital-user" : "fas fa-laptop-medical" %> me-1"></i>
                                                    <%= appointment.getAppointmentType() %>
                                                </span>
                                            </td>
                                            <td>
                                                <div class="status-indicator">
                                                    <span class="badge <%= statusBadgeClass %>">
                                                        <i class="<%= statusIcon %> me-1"></i>
                                                        <%= status %>
                                                    </span>
                                                    <%
                                                        if (appointment.isFollowUpRequired()) {
                                                    %>
                                                        <i class="fas fa-redo text-warning" title="Follow-up Required"></i>
                                                    <%
                                                        }
                                                    %>
                                                </div>
                                            </td>
                                            <td>
                                                <div class="action-buttons">
                                                    <button type="button" class="btn btn-sm btn-outline-primary view-btn"
                                                            data-bs-toggle="modal" 
                                                            data-bs-target="#viewModal<%= appointment.getId() %>"
                                                            title="View Details">
                                                        <i class="fas fa-eye"></i>
                                                    </button>
                                                    
                                                    <button type="button" class="btn btn-sm btn-outline-warning edit-btn"
                                                            data-bs-toggle="modal" 
                                                            data-bs-target="#editModal<%= appointment.getId() %>"
                                                            title="Edit Appointment">
                                                        <i class="fas fa-edit"></i>
                                                    </button>

                                                    <button type="button" class="btn btn-sm btn-outline-danger delete-btn"
                                                            data-bs-toggle="modal" 
                                                            data-bs-target="#deleteConfirmModal"
                                                            data-appointment-id="<%= appointment.getId() %>"
                                                            data-patient-name="<%= appointment.getPatientName() %>"
                                                            data-doctor-name="<%= appointment.getDoctorName() %>"
                                                            title="Delete Appointment">
                                                        <i class="fas fa-trash"></i>
                                                    </button>
                                                </div>
                                            </td>
                                        </tr>
                                    <%
                                        }
                                    %>
                                </tbody>
                            </table>
                        </div>
                    <%
                        }
                    %>
                </div>
            </div>
        </div>
    </main>

    <%-- Modals --%>
    <%
        for (Appointment appointment : appointments) {
            String status = appointment.getStatus();
            if (status == null) status = "Pending";
            
            String createdAtFormatted = "";
            if (appointment.getCreatedAt() != null) {
                createdAtFormatted = dateFormat.format(appointment.getCreatedAt());
            }
    %>
        <%-- View Modal --%>
        <div class="modal fade" id="viewModal<%= appointment.getId() %>" tabindex="-1" aria-labelledby="viewModalLabel<%= appointment.getId() %>" aria-hidden="true">
            <div class="modal-dialog modal-dialog-centered modal-lg">
                <div class="modal-content">
                    <div class="modal-header">
                        <h3 class="modal-title">
                            <i class="fas fa-calendar-alt text-primary me-2"></i>
                            Appointment Details
                        </h3>
                        <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                    </div>
                    <div class="modal-body">
                        <div class="appointment-details">
                            <div class="detail-section">
                                <h5><i class="fas fa-info-circle"></i> Basic Information</h5>
                                <div class="detail-item">
                                    <span class="detail-label">Appointment ID:</span>
                                    <span class="detail-value">#<%= appointment.getId() %></span>
                                </div>
                                <div class="detail-item">
                                    <span class="detail-label">Status:</span>
                                    <span class="detail-value">
                                        <span class="badge <%= "Pending".equals(status) ? "badge-pending" : "Confirmed".equals(status) ? "badge-confirmed" : "Completed".equals(status) ? "badge-completed" : "badge-cancelled" %>">
                                            <i class="fas <%= "Pending".equals(status) ? "fa-clock" : "Confirmed".equals(status) ? "fa-check-circle" : "Completed".equals(status) ? "fa-calendar-check" : "fa-times-circle" %> me-1"></i>
                                            <%= status %>
                                        </span>
                                    </span>
                                </div>
                                <div class="detail-item">
                                    <span class="detail-label">Appointment Type:</span>
                                    <span class="detail-value"><%= appointment.getAppointmentType() %></span>
                                </div>
                                <div class="detail-item">
                                    <span class="detail-label">Follow-up Required:</span>
                                    <span class="detail-value"><%= appointment.isFollowUpRequired() ? "Yes" : "No" %></span>
                                </div>
                                <div class="detail-item">
                                    <span class="detail-label">Created On:</span>
                                    <span class="detail-value"><%= createdAtFormatted %></span>
                                </div>
                            </div>
                            
                            <div class="detail-section">
                                <h5><i class="fas fa-user"></i> Patient Information</h5>
                                <div class="detail-item">
                                    <span class="detail-label">Patient Name:</span>
                                    <span class="detail-value"><%= appointment.getPatientName() %></span>
                                </div>
                                <div class="detail-item">
                                    <span class="detail-label">Patient ID:</span>
                                    <span class="detail-value">PAT<%= appointment.getPatientId() %></span>
                                </div>
                            </div>
                            
                            <div class="detail-section">
                                <h5><i class="fas fa-user-md"></i> Doctor Information</h5>
                                <div class="detail-item">
                                    <span class="detail-label">Doctor Name:</span>
                                    <span class="detail-value">Dr. <%= appointment.getDoctorName() %></span>
                                </div>
                                <div class="detail-item">
                                    <span class="detail-label">Specialization:</span>
                                    <span class="detail-value"><%= appointment.getDoctorSpecialization() %></span>
                                </div>
                            </div>
                            
                            <div class="detail-section">
                                <h5><i class="fas fa-clock"></i> Schedule</h5>
                                <div class="detail-item">
                                    <span class="detail-label">Date:</span>
                                    <span class="detail-value"><%= appointment.getAppointmentDate() %></span>
                                </div>
                                <div class="detail-item">
                                    <span class="detail-label">Time:</span>
                                    <span class="detail-value"><%= appointment.getAppointmentTime() %></span>
                                </div>
                            </div>
                            
                            <div class="detail-section">
                                <h5><i class="fas fa-sticky-note"></i> Additional Information</h5>
                                <div class="detail-item">
                                    <span class="detail-label">Reason:</span>
                                    <span class="detail-value"><%= appointment.getReason() %></span>
                                </div>
                                <div class="detail-item">
                                    <span class="detail-label">Notes:</span>
                                    <span class="detail-value"><%= appointment.getNotes() != null ? appointment.getNotes() : "No notes available" %></span>
                                </div>
                            </div>
                        </div>
                    </div>
                    <div class="modal-footer">
                        <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Close</button>
                    </div>
                </div>
            </div>
        </div>

        <%-- Edit Modal --%>
        <div class="modal fade" id="editModal<%= appointment.getId() %>" tabindex="-1" aria-labelledby="editModalLabel<%= appointment.getId() %>" aria-hidden="true">
            <div class="modal-dialog modal-dialog-centered modal-lg">
                <div class="modal-content">
                    <div class="modal-header">
                        <h3 class="modal-title">
                            <i class="fas fa-edit text-primary me-2"></i>
                            Edit Appointment
                        </h3>
                        <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                    </div>
                    <form action="${pageContext.request.contextPath}/admin/management" method="post" id="editForm<%= appointment.getId() %>">
                        <input type="hidden" name="action" value="update">
                        <input type="hidden" name="type" value="appointment">
                        <input type="hidden" name="id" value="<%= appointment.getId() %>">
                        
                        <div class="modal-body">
                            <div class="form-section">
                                <h4 class="section-title">Appointment Information</h4>
                                <div class="row form-row-spaced">
                                    <div class="col-md-6">
                                        <label for="editStatus<%= appointment.getId() %>" class="form-label">Status</label>
                                        <div class="input-group">
                                            <span class="input-group-text">
                                                <i class="fas fa-tag text-primary"></i>
                                            </span>
                                            <select class="form-select" id="editStatus<%= appointment.getId() %>" name="status" required>
                                                <option value="Pending" <%= "Pending".equals(status) ? "selected" : "" %>>Pending</option>
                                                <option value="Confirmed" <%= "Confirmed".equals(status) ? "selected" : "" %>>Confirmed</option>
                                                <option value="Completed" <%= "Completed".equals(status) ? "selected" : "" %>>Completed</option>
                                                <option value="Cancelled" <%= "Cancelled".equals(status) ? "selected" : "" %>>Cancelled</option>
                                            </select>
                                        </div>
                                    </div>
                                    <div class="col-md-6">
                                        <label for="editType<%= appointment.getId() %>" class="form-label">Appointment Type</label>
                                        <div class="input-group">
                                            <span class="input-group-text">
                                                <i class="fas fa-calendar text-primary"></i>
                                            </span>
                                            <select class="form-select" id="editType<%= appointment.getId() %>" name="appointmentType" required>
                                                <option value="In-person" <%= "In-person".equals(appointment.getAppointmentType()) ? "selected" : "" %>>In-person</option>
                                                <option value="Online" <%= "Online".equals(appointment.getAppointmentType()) ? "selected" : "" %>>Online</option>
                                            </select>
                                        </div>
                                    </div>
                                </div>
                                
                                <div class="row form-row-spaced">
                                    <div class="col-md-6">
                                        <label for="editDate<%= appointment.getId() %>" class="form-label">Appointment Date</label>
                                        <div class="input-group">
                                            <span class="input-group-text">
                                                <i class="fas fa-calendar-day text-primary"></i>
                                            </span>
                                            <input type="date" class="form-control" id="editDate<%= appointment.getId() %>" name="appointmentDate" value="<%= appointment.getAppointmentDate() %>" required>
                                        </div>
                                    </div>
                                    <div class="col-md-6">
                                        <label for="editTime<%= appointment.getId() %>" class="form-label">Appointment Time</label>
                                        <div class="input-group">
                                            <span class="input-group-text">
                                                <i class="fas fa-clock text-primary"></i>
                                            </span>
                                            <input type="time" class="form-control" id="editTime<%= appointment.getId() %>" name="appointmentTime" value="<%= timeFormat.format(appointment.getAppointmentTime()) %>" required>
                                        </div>
                                    </div>
                                </div>
                                
                                <div class="mb-3">
                                    <div class="form-check">
                                        <input class="form-check-input" type="checkbox" id="editFollowUp<%= appointment.getId() %>" name="followUpRequired" <%= appointment.isFollowUpRequired() ? "checked" : "" %>>
                                        <label class="form-check-label" for="editFollowUp<%= appointment.getId() %>">
                                            Follow-up Required
                                        </label>
                                    </div>
                                </div>
                            </div>
                            
                            <div class="form-section">
                                <h4 class="section-title">Additional Information</h4>
                                <div class="mb-3">
                                    <label for="editReason<%= appointment.getId() %>" class="form-label">Reason for Visit</label>
                                    <div class="input-group">
                                        <span class="input-group-text align-items-start">
                                            <i class="fas fa-sticky-note text-primary"></i>
                                        </span>
                                        <textarea class="form-control" id="editReason<%= appointment.getId() %>" name="reason" rows="3" required><%= appointment.getReason() %></textarea>
                                    </div>
                                </div>
                                
                                <div class="mb-3">
                                    <label for="editNotes<%= appointment.getId() %>" class="form-label">Additional Notes</label>
                                    <div class="input-group">
                                        <span class="input-group-text align-items-start">
                                            <i class="fas fa-file-medical text-primary"></i>
                                        </span>
                                        <textarea class="form-control" id="editNotes<%= appointment.getId() %>" name="notes" rows="3"><%= appointment.getNotes() != null ? appointment.getNotes() : "" %></textarea>
                                    </div>
                                </div>
                            </div>
                        </div>
                        <div class="modal-footer">
                            <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cancel</button>
                            <button type="submit" class="btn btn-primary">Update Appointment</button>
                        </div>
                    </form>
                </div>
            </div>
        </div>
    <%
        }
    %>

    <%-- Delete Confirmation Modal --%>
    <div class="modal fade" id="deleteConfirmModal" tabindex="-1" aria-labelledby="deleteModalLabel" aria-hidden="true">
        <div class="modal-dialog modal-dialog-centered">
            <div class="modal-content">
                <div class="modal-header border-bottom-0">
                    <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                </div>
                <div class="modal-body text-center">
                    <div class="delete-modal-icon">
                        <i class="fas fa-exclamation-triangle fa-2x"></i>
                    </div>
                    <h4 class="mb-3">Are you sure?</h4>
                    <p class="mb-3">You are about to delete an appointment for <strong id="deletePatientName" class="text-danger"></strong> with <strong id="deleteDoctorName" class="text-danger"></strong>.</p>
                    <p class="text-muted small">This action cannot be undone.</p>
                </div>
                <div class="modal-footer border-top-0 justify-content-center">
                    <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cancel</button>
                    <form id="deleteForm" method="post" action="${pageContext.request.contextPath}/admin/management" style="display: inline;">
                        <input type="hidden" name="action" value="delete">
                        <input type="hidden" name="type" value="appointment">
                        <input type="hidden" name="id" id="deleteAppointmentId">
                        <button type="submit" class="btn btn-danger">
                            <i class="fas fa-trash me-1"></i>Delete Appointment
                        </button>
                    </form>
                </div>
            </div>
        </div>
    </div>

    <!-- Bootstrap 5 JS -->
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    
    <script>
        document.addEventListener('DOMContentLoaded', function() {
            // Mobile menu toggle
            const mobileMenuToggle = document.getElementById('mobileMenuToggle');
            const sidebar = document.getElementById('sidebar');
            
            if (mobileMenuToggle && sidebar) {
                mobileMenuToggle.addEventListener('click', function() {
                    sidebar.classList.toggle('mobile-open');
                });
            }

            // Auto-hide alerts
            const alerts = document.querySelectorAll('.alert');
            alerts.forEach(alert => {
                setTimeout(() => {
                    if (alert && alert.classList.contains('show')) {
                        const bsAlert = new bootstrap.Alert(alert);
                        bsAlert.close();
                    }
                }, 5000);
            });

            // Filter functionality
            const statusFilter = document.getElementById('statusFilter');
            const doctorFilter = document.getElementById('doctorFilter');
            const dateFilter = document.getElementById('dateFilter');
            const clearFilters = document.getElementById('clearFilters');
            const tableRows = document.querySelectorAll('#appointmentsTable tbody tr');

            function filterAppointments() {
                const statusValue = statusFilter ? statusFilter.value : 'all';
                const doctorValue = doctorFilter ? doctorFilter.value : 'all';
                const dateValue = dateFilter ? dateFilter.value : '';

                tableRows.forEach(row => {
                    const status = row.getAttribute('data-status');
                    const doctor = row.getAttribute('data-doctor');
                    const date = row.getAttribute('data-date');

                    const statusMatch = statusValue === 'all' || status === statusValue.toLowerCase();
                    const doctorMatch = doctorValue === 'all' || doctor === doctorValue;
                    const dateMatch = dateValue === '' || date === dateValue;

                    if (statusMatch && doctorMatch && dateMatch) {
                        row.style.display = '';
                    } else {
                        row.style.display = 'none';
                    }
                });
            }

            if (statusFilter) statusFilter.addEventListener('change', filterAppointments);
            if (doctorFilter) doctorFilter.addEventListener('change', filterAppointments);
            if (dateFilter) dateFilter.addEventListener('change', filterAppointments);
            if (clearFilters) {
                clearFilters.addEventListener('click', function() {
                    if (statusFilter) statusFilter.value = 'all';
                    if (doctorFilter) doctorFilter.value = 'all';
                    if (dateFilter) dateFilter.value = '';
                    filterAppointments();
                });
            }

            // Delete confirmation modal
            const deleteModal = document.getElementById('deleteConfirmModal');
            const deleteButtons = document.querySelectorAll('.delete-btn');
            
            if (deleteModal) {
                deleteButtons.forEach(button => {
                    button.addEventListener('click', function() {
                        const appointmentId = this.getAttribute('data-appointment-id');
                        const patientName = this.getAttribute('data-patient-name');
                        const doctorName = this.getAttribute('data-doctor-name');
                        
                        document.getElementById('deleteAppointmentId').value = appointmentId;
                        document.getElementById('deletePatientName').textContent = patientName;
                        document.getElementById('deleteDoctorName').textContent = 'Dr. ' + doctorName;
                    });
                });
            }

            // Export functionality
            const exportBtn = document.getElementById('exportBtn');
            if (exportBtn) {
                exportBtn.addEventListener('click', function() {
                    // Simple export implementation - could be enhanced with CSV/Excel export
                    const table = document.getElementById('appointmentsTable');
                    const rows = Array.from(table.querySelectorAll('tr'));
                    const csvContent = rows.map(row => {
                        const cells = Array.from(row.querySelectorAll('th, td'));
                        return cells.map(cell => {
                            // Remove action buttons and icons for export
                            if (cell.querySelector('.action-buttons')) {
                                return '';
                            }
                            return '"' + cell.textContent.replace(/"/g, '""') + '"';
                        }).join(',');
                    }).join('\n');
                    
                    const blob = new Blob([csvContent], { type: 'text/csv' });
                    const url = window.URL.createObjectURL(blob);
                    const a = document.createElement('a');
                    a.href = url;
                    a.download = 'appointments.csv';
                    a.click();
                    window.URL.revokeObjectURL(url);
                });
            }

            // Form validation
            const forms = document.querySelectorAll('form');
            forms.forEach(form => {
                form.addEventListener('submit', function(e) {
                    const requiredFields = form.querySelectorAll('[required]');
                    let valid = true;
                    
                    requiredFields.forEach(field => {
                        if (!field.value.trim()) {
                            valid = false;
                            field.classList.add('is-invalid');
                        } else {
                            field.classList.remove('is-invalid');
                        }
                    });
                    
                    if (!valid) {
                        e.preventDefault();
                        // Show error message
                        const alertDiv = document.createElement('div');
                        alertDiv.className = 'alert alert-danger alert-modern mt-3';
                        alertDiv.innerHTML = '<i class="fas fa-exclamation-circle me-2"></i>Please fill in all required fields.';
                        form.insertBefore(alertDiv, form.firstChild);
                    }
                });
            });

            // Initialize tooltips
            const tooltipTriggerList = [].slice.call(document.querySelectorAll('[title]'));
            const tooltipList = tooltipTriggerList.map(function (tooltipTriggerEl) {
                return new bootstrap.Tooltip(tooltipTriggerEl);
            });
        });
    </script>
</body>
</html>