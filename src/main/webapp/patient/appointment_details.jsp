<%@ page import="com.entity.Patient" %>
<%@ page import="com.dao.AppointmentDao" %>
<%@ page import="com.entity.Appointment" %>
<%@ page import="java.text.SimpleDateFormat" %>
<%@ page import="java.util.Date" %>
<%
    Patient currentPatient = (Patient) session.getAttribute("patientObj");
    if (currentPatient == null) {
        response.sendRedirect(request.getContextPath() + "/patient/login.jsp");
        return;
    }
    
    int appointmentId = Integer.parseInt(request.getParameter("id"));
    AppointmentDao appointmentDao = new AppointmentDao();
    Appointment appointment = appointmentDao.getAppointmentById(appointmentId);
    
    if (appointment == null || appointment.getPatientId() != currentPatient.getId()) {
        response.sendRedirect(request.getContextPath() + "/patient/appointment?action=view");
        return;
    }
    
    String statusBadgeClass = "";
    String statusIcon = "";
    
    // --- START OF FIX (Replaced old logic) ---
    String status = appointment.getStatus();
    
    // Normalize the status. We want all "pending" variations (null, lowercase, with spaces)
    // to be treated as the single string "Pending" for the rest of the page's logic.
    if (status == null || status.trim().isEmpty() || status.trim().equalsIgnoreCase("pending")) {
        status = "Pending"; // This is the standard string the rest of the page expects
    } else {
        // For other statuses (Confirmed, Completed, etc.), just trim whitespace
        status = status.trim();
    }
    
    switch (status) {
    // --- END OF FIX (The rest of the switch is now correct) ---
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
            statusBadgeClass = "badge-light"; // Failsafe
            statusIcon = "fas fa-question-circle";
            break;
    }

    // Date formatting logic (correct from before)
    SimpleDateFormat dateTimeFormatter = new SimpleDateFormat("MMM dd, yyyy 'at' hh:mm a");
    String createdAtFormatted = "N/A"; 
    
    if (appointment.getCreatedAt() != null) {
        createdAtFormatted = dateTimeFormatter.format(appointment.getCreatedAt());
    }
    
    String currentUserRole = "patient";
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
    <button class="mobile-menu-toggle" id="mobileMenuToggle">
        <i class="fas fa-bars"></i>
    </button>
    
    <div class="sidebar" id="sidebar">
        <div class="sidebar-sticky">
            <div class="user-section">
                <div class="user-avatar">
                    <i class="fas fa-user-circle"></i>
                </div>
                <div class="user-info">
                    <% if (currentPatient != null) { %>
                    <h6><%= currentPatient.getFullName() %></h6>
                    <span class="badge">Patient</span>
                    <% } %>
                </div>
            </div>
            
            <div class="nav-main">
                <ul class="nav">
                    <li class="nav-item">
                        <a class="nav-link" 
                           href="${pageContext.request.contextPath}/patient/dashboard.jsp">
                            <i class="fas fa-tachometer-alt"></i>
                            <span>Dashboard</span>
                        </a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link" 
                           href="${pageContext.request.contextPath}/patient/profile">
                            <i class="fas fa-user"></i>
                            <span>My Profile</span>
                        </a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link" 
                           href="${pageContext.request.contextPath}/patient/change_password.jsp">
                            <i class="fas fa-key"></i>
                            <span>Change Password</span>
                        </a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link" 
                           href="${pageContext.request.contextPath}/patient/appointment?action=book">
                            <i class="fas fa-calendar-plus"></i>
                            <span>Book Appointment</span>
                        </a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link active" 
                           href="${pageContext.request.contextPath}/patient/appointment?action=view">
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
    
    <main class="main-content">
        <div class="page-header">
            <h1 class="page-title">
                <i class="fas fa-calendar-alt"></i>
                Appointment Details
            </h1>
            <a href="${pageContext.request.contextPath}/patient/appointment?action=view" class="back-link">
                <i class="fas fa-arrow-left me-2"></i>Back to Appointments
            </a>
        </div>

        <%
            String successMsg = (String) request.getAttribute("successMsg");
            String errorMsg = (String) request.getAttribute("errorMsg");
            
            if (successMsg != null) {
        %>
            <div class="alert alert-success alert-dismissible fade show" role="alert">
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
            <div class="alert alert-danger alert-dismissible fade show" role="alert">
                <div class="d-flex align-items-center">
                    <i class="fas fa-exclamation-triangle me-3 fs-5"></i>
                    <div class="flex-grow-1"><%= errorMsg %></div>
                </div>
                <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
            </div>
        <%
            }
        %>

        <div class="row justify-content-center">
            <div class="col-lg-8">
                <div class="card">
                    <div class="card-header d-flex justify-content-between align-items-center">
                        <h2 class="card-title">
                            <i class="fas fa-info-circle"></i>
                            Appointment Information
                        </h2>
                        <span class="badge <%= statusBadgeClass %>">
                            <i class="<%= statusIcon %> me-1"></i>
                            <%= status %>
                        </span>
                    </div>
                    <div class="card-body">
                        <div class="row">
                            <div class="col-md-6">
                                <div class="info-section">
                                    <h3 class="info-section-title">
                                        <i class="fas fa-user-md"></i>
                                        Doctor Information
                                    </h3>
                                    <div class="info-item">
                                        <div class="icon-box icon-primary">
                                            <i class="fas fa-user-md"></i>
                                        </div>
                                        <div class="info-content">
                                            <div class="info-label">Doctor Name</div>
                                            <div class="info-value">Dr. <%= appointment.getDoctorName() %></div>
                                        </div>
                                    </div>
                                    <div class="info-item">
                                        <div class="icon-box icon-info">
                                            <i class="fas fa-stethoscope"></i>
                                        </div>
                                        <div class="info-content">
                                            <div class="info-label">Specialization</div>
                                            <div class="info-value"><%= appointment.getDoctorSpecialization() %></div>
                                        </div>
                                    </div>
                                </div>

                                <div class="info-section">
                                    <h3 class="info-section-title">
                                        <i class="fas fa-calendar"></i>
                                        Appointment Schedule
                                    </h3>
                                    <div class="info-item">
                                        <div class="icon-box icon-success">
                                            <i class="fas fa-calendar-day"></i>
                                        </div>
                                        <div class="info-content">
                                            <div class="info-label">Date</div>
                                            <div class="info-value"><%= appointment.getAppointmentDate() %></div>
                                        </div>
                                    </div>
                                    <div class="info-item">
                                        <div class="icon-box icon-warning">
                                            <i class="fas fa-clock"></i>
                                        </div>
                                        <div class="info-content">
                                            <div class="info-label">Time</div>
                                            <div class="info-value"><%= appointment.getAppointmentTime() %></div>
                                        </div>
                                    </div>
                                </div>
                            </div>

                            <div class="col-md-6">
                                <div class="info-section">
                                    <h3 class="info-section-title">
                                        <i class="fas fa-info-circle"></i>
                                        Appointment Details
                                    </h3>
                                    <div class="info-item">
                                        <div class="icon-box icon-info">
                                            <i class="fas fa-laptop-medical"></i>
                                        </div>
                                        <div class="info-content">
                                            <div class="info-label">Appointment Type</div>
                                            <div class="info-value"><%= appointment.getAppointmentType() %></div>
                                        </div>
                                    </div>
                                    <div class="info-item">
                                        <div class="icon-box icon-primary">
                                            <i class="fas fa-calendar-plus"></i>
                                        </div>
                                        <div class="info-content">
                                            <div class="info-label">Booked On</div>
                                            <div class="info-value"><%= createdAtFormatted %></div>
                                        </div>
                                    </div>
                                    <%
                                        if (appointment.isFollowUpRequired()) {
                                    %>
                                        <div class="info-item">
                                            <div class="icon-box icon-warning">
                                                <i class="fas fa-redo"></i>
                                            </div>
                                            <div class="info-content">
                                                <div class="info-label">Follow-up</div>
                                                <div class="info-value text-warning">Follow-up required</div>
                                            </div>
                                        </div>
                                    <%
                                        }
                                    %>
                                </div>
                            </div>
                        </div>

                        <hr>

                        <div class="info-section">
                            <h3 class="info-section-title">
                                <i class="fas fa-stethoscope"></i>
                                Medical Information
                            </h3>
                            <div class="info-item">
                                <div class="icon-box icon-primary">
                                    <i class="fas fa-comment-medical"></i>
                                </div>
                                <div class="info-content">
                                    <div class="info-label">Reason for Visit</div>
                                    <div class="info-value"><%= appointment.getReason() %></div>
                                </div>
                            </div>
                            <%
                                if (appointment.getNotes() != null && !appointment.getNotes().isEmpty()) {
                            %>
                                <div class="info-item">
                                    <div class="icon-box icon-info">
                                        <i class="fas fa-notes-medical"></i>
                                    </div>
                                    <div class="info-content">
                                        <div class="info-label">Additional Notes</div>
                                        <div class="info-value"><%= appointment.getNotes() %></div>
                                    </div>
                                </div>
                            <%
                                }
                            %>
                        </div>

                        <hr>

                        <div class="d-flex justify-content-between flex-wrap gap-2">
                            <div class="d-flex flex-wrap gap-2">
                                <%
                                    // This 'if' block will now work correctly because
                                    // 'status' has been normalized to "Pending" at the top
                                    if ("Pending".equals(status)) {
                                %>
                                    <a href="${pageContext.request.contextPath}/patient/appointment?action=edit&id=<%= appointment.getId() %>" 
                                       class="btn btn-warning">
                                        <i class="fas fa-edit me-2"></i>Edit Appointment
                                    </a>
                                    <form action="${pageContext.request.contextPath}/patient/appointment?action=cancel" method="post" class="d-inline">
                                        <input type="hidden" name="id" value="<%= appointment.getId() %>">
                                        <button type="submit" class="btn btn-danger cancel-appointment">
                                            <i class="fas fa-times me-2"></i>Cancel Appointment
                                        </button>
                                    </form>
                                <%
                                    }
                                %>
                            </div>
                            <a href="${pageContext.request.contextPath}/patient/appointment?action=view" class="btn btn-outline-secondary">
                                <i class="fas fa-list me-2"></i>Back to List
                            </a>
                        </div>
                    </div>
                </div>

                <div class="card mt-4">
                    <div class="card-header">
                        <h2 class="card-title">
                            <i class="fas fa-question-circle"></i>
                            Appointment Status Guide
                        </h2>
                    </div>
                    <div class="card-body">
                        <div class="status-guide">
                            <div class="status-item">
                                <div class="status-icon icon-warning">
                                    <i class="fas fa-clock"></i>
                                </div>
                                <div class="status-title">Pending</div>
                                <div class="status-desc">Waiting for doctor confirmation</div>
                            </div>
                            <div class="status-item">
                                <div class="status-icon icon-success">
                                    <i class="fas fa-check-circle"></i>
                                </div>
                                <div class="status-title">Confirmed</div>
                                <div class="status-desc">Doctor has confirmed your appointment</div>
                            </div>
                            <div class="status-item">
                                <div class="status-icon icon-info">
                                    <i class="fas fa-calendar-check"></i>
                                </div>
                                <div class="status-title">Completed</div>
                                <div class="status-desc">Appointment has been completed</div>
                            </div>
                            <div class="status-item">
                                <div class="status-icon icon-danger">
                                    <i class="fas fa-times-circle"></i>
                                </div>
                                <div class="status-title">Cancelled</div>
                                <div class="status-desc">Appointment has been cancelled</div>
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
            // Confirm cancellation
            const cancelButtons = document.querySelectorAll('.cancel-appointment');
            cancelButtons.forEach(button => {
                button.addEventListener('click', function(e) {
                    if (!confirm('Are you sure you want to cancel this appointment? This action cannot be undone.')) {
                        e.preventDefault();
                    }
                });
            });
        });
    </script>
</body>
</html>