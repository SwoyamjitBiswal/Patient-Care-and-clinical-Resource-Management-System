<%@ page import="com.entity.Doctor" %>
<%@ page import="com.dao.AppointmentDao" %>
<%@ page import="com.entity.Appointment" %>
<%
    Doctor currentDoctor = (Doctor) session.getAttribute("doctorObj");
    if (currentDoctor == null) {
        response.sendRedirect(request.getContextPath() + "/doctor/login.jsp");
        return;
    }

    int appointmentId = Integer.parseInt(request.getParameter("id"));
    AppointmentDao appointmentDao = new AppointmentDao();
    Appointment appointment = appointmentDao.getAppointmentById(appointmentId);

    // Check if appointment belongs to the doctor
    if (appointment == null || appointment.getDoctorId() != currentDoctor.getId()) {
        response.sendRedirect(request.getContextPath() + "/doctor/appointment?action=view");
        return;
    }

    // Get the status and make it null-safe
    String status = appointment.getStatus();
    if (status == null) {
        status = "Pending"; 
    }

    // Now, use the null-safe 'status' variable
    String statusBadgeClass = "badge-secondary";
    String statusIcon = "fas fa-question-circle";

    switch (status) { // Use the 'status' variable
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
    }
    
    String currentUserRole = "doctor";
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Patient Care System - Appointment Details</title>

    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" rel="stylesheet">
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700&display=swap" rel="stylesheet">
	<link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>

</head>
<body>
    <button class="mobile-menu-toggle" id="mobileMenuToggle" style="display: none;">
        <i class="fas fa-bars"></i>
    </button>

    <div class="sidebar" id="sidebar">
        <div class="sidebar-sticky">
            <div class="user-section">
                <div class="user-avatar">
                   <i class="fas fa-user-md"></i> <%-- Doctor Icon --%>
                </div>
                <div class="user-info">
                   <% if (currentDoctor != null) { %>
                    <h6>Dr. <%= currentDoctor.getFullName() %></h6>
                    <span class="badge"><%= currentDoctor.getSpecialization() %></span>
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
                            <i class="fas fa-list-alt"></i>
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

    <main class="main-content main-content-flush">
        <div class="profile-header">
            <div class="d-flex justify-content-between align-items-center">
                <div>
                    <h1 class="h2 mb-2">
                        <i class="fas fa-calendar-alt me-2"></i>
                        Appointment Details
                    </h1>
                    <p class="mb-0 opacity-75">Manage appointment information and status</p>
                </div>
                <div>
                    <a href="${pageContext.request.contextPath}/doctor/appointment?action=view" class="back-link">
                        <i class="fas fa-arrow-left me-2"></i>Back to Appointments
                    </a>
                </div>
            </div>
        </div>

        <div class="profile-body-wrapper">
            <%
                String successMsg = (String) request.getAttribute("successMsg");
                String errorMsg = (String) request.getAttribute("errorMsg");

                if (successMsg != null) {
            %>
                <div class="alert alert-success alert-modern alert-dismissible fade show mb-4" role="alert">
                    <div class="d-flex align-items-center">
                        <i class="fas fa-check-circle me-3 fs-5"></i>
                        <div class="flex-grow-1"><%= successMsg %></div>
                    </div>
                    <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                </div>
            <%
                }
                if (errorMsg != null) {
            %>
                <div class="alert alert-danger alert-modern alert-dismissible fade show mb-4" role="alert">
                    <div class="d-flex align-items-center">
                        <i class="fas fa-exclamation-triangle me-3 fs-5"></i>
                        <div class="flex-grow-1"><%= errorMsg %></div>
                    </div>
                    <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                </div>
            <%
                }
            %>

            <div class="row">
                <div class="col-lg-8 mb-4 mb-lg-0">
                    <div class="card card-modern mb-4">
                        <div class="card-header-modern d-flex justify-content-between align-items-center">
                            <div>
                                <i class="fas fa-info-circle"></i>
                                <span>Appointment Information</span>
                            </div>
                            <%-- USE NULL-SAFE VARIABLES --%>
                            <span class="badge <%= statusBadgeClass %>">
                                <i class="<%= statusIcon %> me-1"></i>
                                <%= status %> 
                            </span>
                        </div>
                        <div class="card-body p-4">
                            <div class="row">
                                <div class="col-md-6">
                                    <div class="mb-4">
                                        <h6 class="text-primary mb-3">
                                            <i class="fas fa-user me-2"></i>Patient Information
                                        </h6>
                                        <div class="d-flex align-items-center mb-3">
                                            <div class="icon-box icon-primary me-3">
                                                <i class="fas fa-user"></i>
                                            </div>
                                            <div>
                                                <strong class="d-block"><%= appointment.getPatientName() %></strong>
                                                <small class="text-muted">Patient ID: PAT<%= appointment.getPatientId() %></small>
                                            </div>
                                        </div>
                                    </div>

                                    <div class="mb-4">
                                        <h6 class="text-primary mb-3">
                                            <i class="fas fa-calendar me-2"></i>Appointment Schedule
                                        </h6>
                                        <div class="d-flex align-items-center mb-2">
                                            <div class="icon-box icon-success me-3">
                                                <i class="fas fa-calendar-day"></i>
                                            </div>
                                            <div>
                                                <strong class="d-block">Date</strong>
                                                <span class="text-muted"><%= appointment.getAppointmentDate() %></span>
                                            </div>
                                        </div>
                                        <div class="d-flex align-items-center">
                                            <div class="icon-box icon-warning me-3">
                                                <i class="fas fa-clock"></i>
                                            </div>
                                            <div>
                                                <strong class="d-block">Time</strong>
                                                <span class="text-muted"><%= appointment.getAppointmentTime() %></span>
                                            </div>
                                        </div>
                                    </div>
                                </div>

                                <div class="col-md-6">
                                    <div class="mb-4">
                                        <h6 class="text-primary mb-3">
                                            <i class="fas fa-info-circle me-2"></i>Appointment Details
                                        </h6>
                                        <div class="d-flex align-items-center mb-2">
                                            <div class="icon-box icon-info me-3">
                                                 <i class="<%= "In-person".equals(appointment.getAppointmentType()) ? "fas fa-hospital-user" : "fas fa-laptop-medical" %>"></i>
                                            </div>
                                            <div>
                                                <strong class="d-block">Type</strong>
                                                <span class="text-muted"><%= appointment.getAppointmentType() %></span>
                                            </div>
                                        </div>
                                        <div class="d-flex align-items-center mb-2">
                                            <div class="icon-box icon-danger me-3">
                                                <i class="fas fa-calendar-plus"></i>
                                            </div>
                                            <div>
                                                <strong class="d-block">Booked On</strong>
                                                <span class="text-muted"><%= appointment.getCreatedAt() %></span>
                                            </div>
                                        </div>
                                        <%
                                            if (appointment.isFollowUpRequired()) {
                                        %>
                                            <div class="d-flex align-items-center">
                                                <div class="icon-box icon-warning me-3">
                                                    <i class="fas fa-redo"></i>
                                                </div>
                                                <div>
                                                    <strong class="d-block">Follow-up</strong>
                                                    <span class="text-warning">Required</span>
                                                </div>
                                            </div>
                                        <%
                                            }
                                        %>
                                    </div>
                                </div>
                            </div>

                            <hr>

                            <div class="row">
                                <div class="col-12">
                                    <h6 class="text-primary mb-3">
                                        <i class="fas fa-stethoscope me-2"></i>Medical Information
                                    </h6>
                                    <div class="mb-3">
                                        <strong>Reason for Visit:</strong>
                                        <p class="text-muted mt-1 bg-light p-3 rounded"><%= appointment.getReason() %></p>
                                    </div>
                                    <%
                                        if (appointment.getNotes() != null && !appointment.getNotes().isEmpty()) {
                                    %>
                                        <div class="mb-3">
                                            <strong>Patient Notes:</strong>
                                            <p class="text-muted mt-1 bg-light p-3 rounded"><%= appointment.getNotes() %></p>
                                        </div>
                                    <%
                                        }
                                    %>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>

                <div class="col-lg-4">
                    <div class="card card-modern mb-4">
                        <div class="card-header-modern">
                            <i class="fas fa-cogs"></i>
                            <span>Manage Appointment</span>
                        </div>
                        <div class="card-body p-4">
                            <%
                                if (!"Completed".equals(status) && !"Cancelled".equals(status)) {
                            %>
                                <div class="d-grid gap-2 mb-3">
                                    <%
                                        if (!"Confirmed".equals(status)) {
                                    %>
                                        <form action="${pageContext.request.contextPath}/doctor/appointment?action=updateStatus" method="post">
                                            <input type="hidden" name="appointmentId" value="<%= appointment.getId() %>">
                                            <input type="hidden" name="status" value="Confirmed">
                                            <button type="submit" class="btn btn-success w-100">
                                                <i class="fas fa-check me-2"></i>Confirm Appointment
                                            </button>
                                        </form>
                                    <%
                                        }
                                        if (!"Completed".equals(status)) {
                                    %>
                                        <form action="${pageContext.request.contextPath}/doctor/appointment?action=updateStatus" method="post">
                                            <input type="hidden" name="appointmentId" value="<%= appointment.getId() %>">
                                            <input type="hidden" name="status" value="Completed">
                                            <button type="submit" class="btn btn-info w-100">
                                                <i class="fas fa-calendar-check me-2"></i>Mark as Completed
                                            </button>
                                        </form>
                                    <%
                                        }
                                    %>
                                    <form action="${pageContext.request.contextPath}/doctor/appointment?action=updateStatus" method="post">
                                        <input type="hidden" name="appointmentId" value="<%= appointment.getId() %>">
                                        <input type="hidden" name="status" value="Cancelled">
                                        <button type="submit" class="btn btn-danger w-100" onclick="return confirm('Are you sure you want to cancel this appointment?')">
                                            <i class="fas fa-times me-2"></i>Cancel Appointment
                                        </button>
                                    </form>
                                </div>
                                 <hr>
                            <%
                               } else {
                            %>
                                <%-- USE NULL-SAFE 'status' VARIABLE --%>
                                <p class="text-muted text-center">This appointment is already <%= status.toLowerCase() %>.</p>
                                 <hr>
                            <%
                               }
                            %>

                            <form action="${pageContext.request.contextPath}/doctor/appointment?action=updateFollowUp" method="post">
                                <input type="hidden" name="appointmentId" value="<%= appointment.getId() %>">
                                <input type="hidden" name="followUpRequired" value="<%= !appointment.isFollowUpRequired() %>">
                                <button type="submit" class="btn <%= appointment.isFollowUpRequired() ? "btn-warning" : "btn-outline-warning" %> w-100">
                                    <i class="fas fa-redo me-2"></i>
                                    <%= appointment.isFollowUpRequired() ? "Remove Follow-up Req." : "Mark for Follow-up" %>
                                </button>
                            </form>
                        </div>
                    </div>

                    <div class="card card-modern">
                        <div class="card-header-modern">
                            <i class="fas fa-clipboard-list"></i>
                            <span>Quick Summary</span>
                        </div>
                        <div class="card-body p-4">
                            <div class="list-group list-group-flush">
                                <div class="list-group-item d-flex justify-content-between align-items-center px-0">
                                    <span class="text-muted"><i class="fas fa-hashtag me-2 text-primary"></i>Appt. ID</span>
                                    <strong>#<%= appointment.getId() %></strong>
                                </div>
                                <div class="list-group-item d-flex justify-content-between align-items-center px-0">
                                    <span class="text-muted"><i class="far fa-hourglass me-2 text-primary"></i>Duration</span>
                                    <strong>~30 mins</strong>
                                </div>
                                <div class="list-group-item d-flex justify-content-between align-items-center px-0">
                                    <span class="text-muted"><i class="fas fa-laptop-medical me-2 text-primary"></i>Type</span>
                                    <span class="badge bg-light text-dark"><%= appointment.getAppointmentType() %></span>
                                </div>
                                <div class="list-group-item d-flex justify-content-between align-items-center px-0">
                                    <span class="text-muted"><i class="fas fa-info-circle me-2 text-primary"></i>Status</span>
                                    <%-- USE NULL-SAFE VARIABLES --%>
                                    <span class="badge <%= statusBadgeClass %>"><%= status %></span>
                                </div>
                                <%
                                    if (appointment.isFollowUpRequired()) {
                                %>
                                    <div class="list-group-item d-flex justify-content-between align-items-center px-0">
                                        <span class="text-muted"><i class="fas fa-redo me-2 text-primary"></i>Follow-up</span>
                                        <span class="badge bg-warning text-dark">Required</span>
                                    </div>
                                <%
                                    }
                                %>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </main>

    <script>
        document.addEventListener('DOMContentLoaded', function() {
            const mobileMenuToggle = document.getElementById('mobileMenuToggle');
            const sidebar = document.getElementById('sidebar');
            
            function checkScreenSize() {
                if (window.innerWidth <= 768) {
                    mobileMenuToggle.style.display = 'flex';
                    sidebar.classList.remove('mobile-open');
                } else {
                    mobileMenuToggle.style.display = 'none';
                    sidebar.classList.remove('mobile-open');
                }
            }
            
            checkScreenSize();
            window.addEventListener('resize', checkScreenSize);
            
            mobileMenuToggle.addEventListener('click', function() {
                sidebar.classList.toggle('mobile-open');
            });
            
            const navLinks = document.querySelectorAll('.nav-link');
            navLinks.forEach(link => {
                link.addEventListener('click', function() {
                    if (window.innerWidth <= 768) {
                        sidebar.classList.remove('mobile-open');
                    }
                });
            });
        });
    </script>

    <script>
        document.addEventListener('DOMContentLoaded', function() {
        });
    </script>
</body>
</html>