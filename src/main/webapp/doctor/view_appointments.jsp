<%@ page import="com.entity.Doctor" %>
<%@ page import="com.dao.AppointmentDao" %>
<%@ page import="com.entity.Appointment" %>
<%@ page import="com.dao.PatientDao" %>
<%@ page import="com.entity.Patient" %>
<%@ page import="java.util.List" %>
<%@ page import="java.util.stream.Collectors" %>
<%@ page import="java.util.HashMap" %>
<%@ page import="java.util.Map" %>
<%
    Doctor currentDoctor = (Doctor) session.getAttribute("doctorObj");
    if (currentDoctor == null) {
        response.sendRedirect(request.getContextPath() + "/doctor/login.jsp"); 
        return;
    }

    AppointmentDao appointmentDao = new AppointmentDao();
    PatientDao patientDao = new PatientDao();
    List<Appointment> appointments = appointmentDao.getAppointmentsByDoctorId(currentDoctor.getId());

    Map<Integer, Patient> patientMap = new HashMap<>();
    for (Appointment appointment : appointments) {
        if (!patientMap.containsKey(appointment.getPatientId())) {
            Patient patient = patientDao.getPatientById(appointment.getPatientId());
            patientMap.put(appointment.getPatientId(), patient);
        }
    }

    long pendingCount = appointments.stream().filter(a -> "Pending".equals(a.getStatus()) || a.getStatus() == null).count();
    long confirmedCount = appointments.stream().filter(a -> "Confirmed".equals(a.getStatus())).count();
    long completedCount = appointments.stream().filter(a -> "Completed".equals(a.getStatus())).count();
    long cancelledCount = appointments.stream().filter(a -> "Cancelled".equals(a.getStatus())).count();

    String currentUserRole = "doctor";
    
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
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Doctor Appointments | Patient Care System</title>

    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" rel="stylesheet">
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700&display=swap" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</head>
<body>
    <!-- Mobile Menu Toggle -->
    <button class="mobile-menu-toggle" id="mobileMenuToggle" style="display: none;">
        <i class="fas fa-bars"></i>
    </button>
    
    <!-- Sidebar Overlay for Mobile -->
    <div class="sidebar-overlay" id="sidebarOverlay"></div>

    <!-- Enhanced Sidebar -->
    <div class="sidebar" id="sidebar">
        <div class="sidebar-sticky">
            <div class="user-section">
                <div class="user-avatar">
                    <i class="fas fa-user-md"></i>
                </div>
                <div class="user-info">
                   <% if (currentDoctor != null) { %>
                    <h6>Dr. <%= currentDoctor.getFullName() %></h6>
                    <small><%= currentDoctor.getSpecialization() %></small>
                   <% } %>
                </div>
            </div>

            <div class="nav-main">
                <ul class="nav">
                    <li class="nav-item">
                        <a class="nav-link <%= request.getRequestURI().contains("dashboard.jsp") ? "active" : "" %>"
                           href="${pageContext.request.contextPath}/doctor/dashboard.jsp">
                            <i class="fas fa-tachometer-alt"></i>
                            <span>Dashboard</span>
                        </a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link <%= request.getRequestURI().contains("profile") ? "active" : "" %>"
                           href="${pageContext.request.contextPath}/doctor/profile">
                            <i class="fas fa-user"></i>
                            <span>My Profile</span>
                        </a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link <%= request.getRequestURI().contains("change_password") ? "active" : "" %>"
                           href="${pageContext.request.contextPath}/doctor/change_password.jsp">
                            <i class="fas fa-key"></i>
                            <span>Change Password</span>
                        </a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link <%= request.getRequestURI().contains("appointment") ? "active" : "" %>"
                           href="${pageContext.request.contextPath}/doctor/appointment?action=view">
                            <i class="fas fa-calendar-check"></i>
                            <span>My Appointments</span>
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
                        <a class="nav-link nav-link-logout" href="${pageContext.request.contextPath}/<%= currentUserRole %>/auth?action=logout">
                            <i class="fas fa-sign-out-alt"></i>
                            <span>Logout</span>
                        </a>
                    </li>
                 </ul>
            </div>
        </div>
    </div>

    <!-- Main Content -->
<main class="main-content main-content-flush">
        <!-- Enhanced Header -->
        <div class="page-header">
            <div class="container-fluid">
                <div class="row align-items-center">
                    <div class="col-md-8">
                        <h1 class="page-title">
                            <i class="fas fa-calendar-check"></i>
                            My Appointments
                        </h1>
                        <p class="text-muted mb-0">Manage and track all your patient appointments</p>
                    </div>
                    <div class="col-md-4 text-md-end mt-3 mt-md-0">
                        <span class="badge bg-primary fs-6 p-3">
                            <i class="fas fa-calendar-check me-2"></i>
                            <%= appointments.size() %> Total Appointments
                        </span>
                    </div>
                </div>
            </div>
        </div>

        <!-- Main Content Area -->
        <div class="container-fluid py-4">
            <!-- Messages -->
            <% if (successMsg != null && !successMsg.isEmpty()) { %>
                <div class="alert alert-success alert-dismissible fade show fade-in" role="alert">
                    <div class="d-flex align-items-center">
                        <i class="fas fa-check-circle me-3 fs-5"></i>
                        <div class="flex-grow-1">
                            <strong>Success!</strong> <%= successMsg %>
                        </div>
                    </div>
                    <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                </div>
            <% } %>
            
            <% if (errorMsg != null && !errorMsg.isEmpty()) { %>
                <div class="alert alert-danger alert-dismissible fade show fade-in" role="alert">
                    <div class="d-flex align-items-center">
                        <i class="fas fa-exclamation-triangle me-3 fs-5"></i>
                        <div class="flex-grow-1">
                            <strong>Attention!</strong> <%= errorMsg %>
                        </div>
                    </div>
                    <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                </div>
            <% } %>

            <!-- Stats Cards -->
            <div class="row g-4 mb-4 fade-in">
                <div class="col-xl-3 col-md-6">
                    <div class="stat-card pending">
                        <div class="stat-number"><%= pendingCount %></div>
                        <div class="stat-label">Pending</div>
                        <i class="fas fa-clock mt-3 fs-2 text-warning"></i>
                    </div>
                </div>
                <div class="col-xl-3 col-md-6">
                    <div class="stat-card confirmed">
                        <div class="stat-number"><%= confirmedCount %></div>
                        <div class="stat-label">Confirmed</div>
                        <i class="fas fa-check-circle mt-3 fs-2 text-info"></i>
                    </div>
                </div>
                <div class="col-xl-3 col-md-6">
                    <div class="stat-card completed">
                        <div class="stat-number"><%= completedCount %></div>
                        <div class="stat-label">Completed</div>
                        <i class="fas fa-calendar-check mt-3 fs-2 text-success"></i>
                    </div>
                </div>
                <div class="col-xl-3 col-md-6">
                    <div class="stat-card cancelled">
                        <div class="stat-number"><%= cancelledCount %></div>
                        <div class="stat-label">Cancelled</div>
                        <i class="fas fa-times-circle mt-3 fs-2 text-danger"></i>
                    </div>
                </div>
            </div>

            <!-- Filters Card -->
            <div class="card fade-in mb-4">
                <div class="card-body">
                    <div class="row g-3 align-items-end">
                        <div class="col-lg-4 col-md-6">
                            <label class="form-label fw-semibold">Filter by Status</label>
                            <div class="input-group">
                                <span class="input-group-text bg-light border-end-0">
                                    <i class="fas fa-filter text-primary"></i>
                                </span>
                                <select class="form-select border-start-0" id="statusFilter">
                                    <option value="all" selected>All Statuses</option>
                                    <option value="Pending">Pending</option>
                                    <option value="Confirmed">Confirmed</option>
                                    <option value="Completed">Completed</option>
                                    <option value="Cancelled">Cancelled</option>
                                </select>
                            </div>
                        </div>
                        <div class="col-lg-4 col-md-6">
                            <label class="form-label fw-semibold">Search Patient</label>
                            <div class="input-group">
                                <span class="input-group-text bg-light border-end-0">
                                    <i class="fas fa-search text-primary"></i>
                                </span>
                                <input type="text" class="form-control border-start-0" id="searchPatient" 
                                       placeholder="Search by patient name...">
                            </div>
                        </div>
                        <div class="col-lg-4 col-md-12">
                            <button type="button" id="clearFilters" class="btn btn-outline-primary w-100">
                                <i class="fas fa-eraser me-2"></i>Clear Filters
                            </button>
                        </div>
                    </div>
                </div>
            </div>

            <!-- Appointments Table -->
            <div class="card fade-in">
                <div class="card-header">
                    <div class="row align-items-center">
                        <div class="col">
                            <h5 class="mb-0">
                                <i class="fas fa-list me-2 text-primary"></i>Appointment List
                            </h5>
                        </div>
                        <div class="col-auto">
                            <span class="badge bg-light text-dark fs-6">
                                <i class="fas fa-user-md me-2 text-primary"></i>Dr. <%= currentDoctor.getFullName() %>
                            </span>
                        </div>
                    </div>
                </div>
                <div class="card-body p-0">
                    <%
                        if (appointments.isEmpty()) {
                    %>
                        <div class="text-center py-5">
                            <i class="fas fa-calendar-times fa-4x text-muted mb-4"></i>
                            <h4 class="text-muted mb-3">No Appointments Found</h4>
                            <p class="text-muted mb-4">You don't have any appointments scheduled yet.</p>
                            <a href="${pageContext.request.contextPath}/doctor/dashboard.jsp" class="btn btn-primary">
                                <i class="fas fa-tachometer-alt me-2"></i>Back to Dashboard
                            </a>
                        </div>
                    <%
                        } else {
                    %>
                        <div class="table-container">
                            <div class="table-responsive">
                                <table class="table table-hover mb-0" id="appointmentsTable">
                                    <thead>
                                        <tr>
                                            <th>Patient Details</th>
                                            <th>Contact Info</th>
                                            <th>Date & Time</th>
                                            <th>Type</th>
                                            <th>Reason</th>
                                            <th>Status</th>
                                            <th>Actions</th>
                                        </tr>
                                    </thead>
                                    <tbody>
                                        <%
                                            for (Appointment appointment : appointments) {
                                                String status = appointment.getStatus();
                                                if (status == null) {
                                                    status = "Pending";
                                                }

                                                String statusBadgeClass;
                                                String statusIcon;

                                                switch (status) {
                                                    case "Pending":
                                                        statusBadgeClass = "badge-pending";
                                                        statusIcon = "fas fa-clock";
                                                        break;
                                                    case "Confirmed":
                                                        statusBadgeClass = "badge-confirmed";
                                                        statusIcon = "fas fa-check-circle";
                                                        break;
                                                    case "Completed":
                                                        statusBadgeClass = "badge-completed";
                                                        statusIcon = "fas fa-calendar-check";
                                                        break;
                                                    case "Cancelled":
                                                        statusBadgeClass = "badge-cancelled";
                                                        statusIcon = "fas fa-times-circle";
                                                        break;
                                                    default:
                                                        statusBadgeClass = "badge-pending";
                                                        statusIcon = "fas fa-clock";
                                                }
                                                
                                                Patient patient = patientMap.get(appointment.getPatientId());
                                                String patientPhone = "N/A";
                                                String patientEmail = "N/A";
                                                
                                                if (patient != null) {
                                                    patientPhone = patient.getPhone() != null ? patient.getPhone() : "N/A";
                                                    patientEmail = patient.getEmail() != null ? patient.getEmail() : "N/A";
                                                }
                                        %>
                                            <tr data-status="<%= status.toLowerCase() %>" data-patient="<%= appointment.getPatientName().toLowerCase() %>">
                                                <td>
                                                    <div class="d-flex align-items-center">
                                                        <div class="icon-box icon-primary me-3">
                                                            <i class="fas fa-user"></i>
                                                        </div>
                                                        <div>
                                                            <strong class="d-block"><%= appointment.getPatientName() %></strong>
                                                            <small class="text-muted">ID: PAT<%= appointment.getPatientId() %></small>
                                                        </div>
                                                    </div>
                                                </td>
                                                <td>
                                                    <div class="text-muted">
                                                        <div class="mb-1">
                                                            <i class="fas fa-phone me-2"></i> 
                                                            <span class="small"><%= patientPhone %></span>
                                                        </div>
                                                        <div>
                                                            <i class="fas fa-envelope me-2"></i> 
                                                            <span class="small"><%= patientEmail %></span>
                                                        </div>
                                                    </div>
                                                </td>
                                                <td>
                                                    <strong class="d-block"><%= appointment.getAppointmentDate() %></strong>
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
                                                    <span class="text-truncate d-inline-block" style="max-width: 200px;" 
                                                          data-bs-toggle="tooltip" title="<%= appointment.getReason() %>">
                                                        <%= appointment.getReason().length() > 50 ? appointment.getReason().substring(0, 50) + "..." : appointment.getReason() %>
                                                    </span>
                                                </td>
                                                <td>
                                                    <span class="badge <%= statusBadgeClass %> mb-1">
                                                        <i class="<%= statusIcon %> me-1"></i>
                                                        <%= status %>
                                                    </span>
                                                    <%
                                                        if (appointment.isFollowUpRequired()) {
                                                    %>
                                                        <br>
                                                        <small class="text-warning d-block mt-1">
                                                            <i class="fas fa-redo me-1"></i>Follow-up Required
                                                        </small>
                                                    <%
                                                        }
                                                    %>
                                                </td>
                                                <td>
                                                    <div class="action-buttons">
                                                        <a href="${pageContext.request.contextPath}/doctor/appointment?action=details&id=<%= appointment.getId() %>"
                                                           class="btn btn-outline-primary btn-sm" data-bs-toggle="tooltip" title="View Details">
                                                            <i class="fas fa-eye"></i>
                                                        </a>
                                                        <%
                                                            if (!"Completed".equals(status) && !"Cancelled".equals(status)) {
                                                        %>
                                                            <div class="dropdown">
                                                                <button class="btn btn-outline-warning btn-sm dropdown-toggle" type="button"
                                                                        id="dropdownMenuButton<%= appointment.getId() %>" data-bs-toggle="dropdown" 
                                                                        aria-expanded="false" data-bs-toggle="tooltip" title="Update Status">
                                                                    <i class="fas fa-edit"></i>
                                                                </button>
                                                                <ul class="dropdown-menu dropdown-menu-end" aria-labelledby="dropdownMenuButton<%= appointment.getId() %>">
                                                                    <%
                                                                        if (!"Confirmed".equals(status)) {
                                                                    %>
                                                                        <li>
                                                                            <form action="${pageContext.request.contextPath}/doctor/appointment?action=updateStatus" method="post" class="d-inline">
                                                                                <input type="hidden" name="appointmentId" value="<%= appointment.getId() %>">
                                                                                <input type="hidden" name="status" value="Confirmed">
                                                                                <button type="submit" class="dropdown-item text-success">
                                                                                    <i class="fas fa-check me-2"></i>Confirm Appointment
                                                                                </button>
                                                                            </form>
                                                                        </li>
                                                                    <%
                                                                        }
                                                                        if (!"Completed".equals(status)) {
                                                                    %>
                                                                        <li>
                                                                            <form action="${pageContext.request.contextPath}/doctor/appointment?action=updateStatus" method="post" class="d-inline">
                                                                                <input type="hidden" name="appointmentId" value="<%= appointment.getId() %>">
                                                                                <input type="hidden" name="status" value="Completed">
                                                                                <button type="submit" class="dropdown-item text-info">
                                                                                    <i class="fas fa-calendar-check me-2"></i>Mark as Completed
                                                                                </button>
                                                                            </form>
                                                                        </li>
                                                                    <%
                                                                        }
                                                                    %>
                                                                    <li>
                                                                        <form action="${pageContext.request.contextPath}/doctor/appointment?action=updateStatus" method="post" class="d-inline" id="cancelForm<%= appointment.getId() %>">
                                                                            <input type="hidden" name="appointmentId" value="<%= appointment.getId() %>">
                                                                            <input type="hidden" name="status" value="Cancelled">
                                                                            <button type="button" class="dropdown-item text-danger cancel-appointment-btn"
                                                                                    data-bs-toggle="modal"
                                                                                    data-bs-target="#deleteConfirmModal"
                                                                                    data-form-id="cancelForm<%= appointment.getId() %>"
                                                                                    data-item-name="Appointment #<%= appointment.getId() %>">
                                                                                <i class="fas fa-times me-2"></i>Cancel Appointment
                                                                            </button>
                                                                        </form>
                                                                    </li>
                                                                    <li><hr class="dropdown-divider"></li>
                                                                    <li>
                                                                        <form action="${pageContext.request.contextPath}/doctor/appointment?action=updateFollowUp" method="post" class="d-inline">
                                                                            <input type="hidden" name="appointmentId" value="<%= appointment.getId() %>">
                                                                            <input type="hidden" name="followUpRequired" value="<%= !appointment.isFollowUpRequired() %>">
                                                                            <button type="submit" class="dropdown-item text-warning">
                                                                                <i class="fas fa-redo me-2"></i>
                                                                                <%= appointment.isFollowUpRequired() ? "Remove Follow-up" : "Mark for Follow-up" %>
                                                                            </button>
                                                                        </form>
                                                                    </li>
                                                                </ul>
                                                            </div>
                                                        <%
                                                        }
                                                    %>
                                                </td>
                                            </tr>
                                        <%
                                            }
                                        %>
                                    </tbody>
                                </table>
                            </div>
                        </div>
                    <%
                    }
                %>
                </div>
            </div>
        </div>
    </main>

    <!-- Enhanced Modal -->
    <div class="modal fade" id="deleteConfirmModal" tabindex="-1" aria-labelledby="deleteModalLabel" aria-hidden="true">
        <div class="modal-dialog modal-dialog-centered">
            <div class="modal-content">
                <div class="modal-header">
                    <h5 class="modal-title text-danger" id="deleteModalLabel">
                        <i class="fas fa-exclamation-triangle me-2"></i>Confirm Cancellation
                    </h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                </div>
                <div class="modal-body text-center py-4">
                    <div class="delete-modal-icon mb-3">
                        <i class="fas fa-exclamation-triangle fa-3x text-danger"></i>
                    </div>
                    <h4 class="mb-3">Cancel Appointment?</h4>
                    <p class="text-muted">Are you sure you want to cancel <strong id="itemNameToDelete" class="text-danger">this appointment</strong>?</p>
                    <p class="text-muted small">This action cannot be undone and will notify the patient.</p>
                </div>
                <div class="modal-footer justify-content-center">
                    <button type="button" class="btn btn-outline-secondary px-4" data-bs-dismiss="modal">
                        <i class="fas fa-times me-2"></i>Keep Appointment
                    </button>
                    <button type="button" class="btn btn-danger px-4" id="modalConfirmDeleteButton">
                        <i class="fas fa-check me-2"></i>Yes, Cancel
                    </button>
                </div>
            </div>
        </div>
    </div>

    <script>
        document.addEventListener('DOMContentLoaded', function() {
            // Mobile menu functionality
            const mobileMenuToggle = document.getElementById('mobileMenuToggle');
            const sidebar = document.getElementById('sidebar');
            const sidebarOverlay = document.getElementById('sidebarOverlay');

            function checkScreenSize() {
                if (window.innerWidth <= 768) {
                    mobileMenuToggle.style.display = 'flex';
                    sidebar.classList.remove('mobile-open');
                    sidebarOverlay.classList.remove('active');
                } else {
                    mobileMenuToggle.style.display = 'none';
                    sidebar.classList.remove('mobile-open');
                    sidebarOverlay.classList.remove('active');
                }
            }

            checkScreenSize();
            window.addEventListener('resize', checkScreenSize);

            mobileMenuToggle.addEventListener('click', function() {
                sidebar.classList.toggle('mobile-open');
                sidebarOverlay.classList.toggle('active');
                this.innerHTML = sidebar.classList.contains('mobile-open') ? 
                    '<i class="fas fa-times"></i>' : '<i class="fas fa-bars"></i>';
            });
            
            sidebarOverlay.addEventListener('click', function() {
                sidebar.classList.remove('mobile-open');
                sidebarOverlay.classList.remove('active');
                mobileMenuToggle.innerHTML = '<i class="fas fa-bars"></i>';
            });

            // Auto-hide alerts
            const alerts = document.querySelectorAll('.alert');
            alerts.forEach(alert => {
                setTimeout(() => {
                    const bsAlert = new bootstrap.Alert(alert);
                    bsAlert.close();
                }, 5000);
            });

            // Initialize tooltips
            const tooltipTriggerList = [].slice.call(document.querySelectorAll('[data-bs-toggle="tooltip"]'));
            const tooltipList = tooltipTriggerList.map(function (tooltipTriggerEl) {
                return new bootstrap.Tooltip(tooltipTriggerEl);
            });

            // Filter functionality
            const statusFilter = document.getElementById('statusFilter');
            const searchPatient = document.getElementById('searchPatient');
            const clearFilters = document.getElementById('clearFilters');
            const tableRows = document.querySelectorAll('#appointmentsTable tbody tr');

            function filterAppointments() {
                const statusValue = statusFilter.value;
                const searchValue = searchPatient.value.toLowerCase();

                tableRows.forEach(row => {
                    const status = row.getAttribute('data-status');
                    const patient = row.getAttribute('data-patient');

                    const statusMatch = statusValue === 'all' || status === statusValue.toLowerCase();
                    const searchMatch = patient.includes(searchValue);

                    if (statusMatch && searchMatch) {
                        row.style.display = '';
                    } else {
                        row.style.display = 'none';
                    }
                });
            }

            if (statusFilter) statusFilter.addEventListener('change', filterAppointments);
            if (searchPatient) searchPatient.addEventListener('input', filterAppointments);
            if (clearFilters) {
                clearFilters.addEventListener('click', function() {
                    statusFilter.value = 'all';
                    searchPatient.value = '';
                    filterAppointments();
                });
            }

            // Enhanced modal functionality
            const deleteConfirmModal = document.getElementById('deleteConfirmModal');
            let formToSubmit = null;

            if (deleteConfirmModal) {
                deleteConfirmModal.addEventListener('show.bs.modal', function (event) {
                    const button = event.relatedTarget;
                    const formId = button.getAttribute('data-form-id');
                    const itemName = button.getAttribute('data-item-name');
                    
                    formToSubmit = document.getElementById(formId);
                    
                    const modalItemNameElement = document.getElementById('itemNameToDelete');
                    modalItemNameElement.textContent = itemName ? `${itemName}` : 'this appointment';
                });

                const modalConfirmDeleteButton = document.getElementById('modalConfirmDeleteButton');
                if (modalConfirmDeleteButton) {
                    modalConfirmDeleteButton.addEventListener('click', function () {
                        if (formToSubmit) {
                            formToSubmit.submit();
                        }
                    });
                }
            }

            // Add smooth animations
            const observerOptions = {
                threshold: 0.1,
                rootMargin: '0px 0px -50px 0px'
            };

            const observer = new IntersectionObserver((entries) => {
                entries.forEach(entry => {
                    if (entry.isIntersecting) {
                        entry.target.style.opacity = '1';
                        entry.target.style.transform = 'translateY(0)';
                    }
                });
            }, observerOptions);

            // Observe elements for animation
            document.querySelectorAll('.card, .stat-card').forEach(el => {
                el.style.opacity = '0';
                el.style.transform = 'translateY(20px)';
                el.style.transition = 'opacity 0.6s ease, transform 0.6s ease';
                observer.observe(el);
            });
        });
    </script>
</body>
</html>