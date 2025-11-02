<%@ page import="com.entity.Patient" %>
<%@ page import="com.entity.Appointment" %>
<%@ page import="com.entity.Doctor" %>
<%@ page import="java.util.List" %>
<%@ page import="java.text.SimpleDateFormat" %>
<%
    // 1. Check if patient is logged in
    Patient currentPatient = (Patient) session.getAttribute("patientObj");
    if (currentPatient == null) {
        response.sendRedirect(request.getContextPath() + "/patient/login.jsp");
        return;
    }
    
    // 2. Get the appointment object set by the servlet
    Appointment appointment = (Appointment) request.getAttribute("appointment");
    
    // 3. If no appointment, redirect (this is a fallback)
    if (appointment == null) {
        session.setAttribute("errorMsg", "Could not load appointment to edit.");
        response.sendRedirect(request.getContextPath() + "/patient/appointment?action=view");
        return;
    }
    
    // This variable is needed for the sidebar
    String currentUserRole = "patient";
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Patient Care System - Edit Appointment</title>
    
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" rel="stylesheet">
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>

    
</head>
<body>
    
    <div class="sidebar" id="sidebar">
        <div class="sidebar-sticky">
            <div class="user-section">
                <div class="user-avatar"><i class="fas fa-user-circle"></i></div>
                <div class="user-info">
                    <% if (currentPatient != null) { %>
                    <h6><%= currentPatient.getFullName() %></h6>
                    <span class="badge">Patient</span>
                    <% } %>
                </div>
            </div>
            
            <div class="nav-main">
                <ul class="nav">
                    <li class="nav-item"><a class="nav-link" href="${pageContext.request.contextPath}/patient/dashboard.jsp"><i class="fas fa-tachometer-alt"></i><span>Dashboard</span></a></li>
                    <li class="nav-item"><a class="nav-link" href="${pageContext.request.contextPath}/patient/profile"><i class="fas fa-user"></i><span>My Profile</span></a></li>
                    <li class="nav-item"><a class="nav-link" href="${pageContext.request.contextPath}/patient/change_password.jsp"><i class="fas fa-key"></i><span>Change Password</span></a></li>
                    <li class="nav-item"><a class="nav-link" href="${pageContext.request.contextPath}/patient/appointment?action=book"><i class="fas fa-calendar-plus"></i><span>Book Appointment</span></a></li>
                    <li class="nav-item"><a class="nav-link active" href="${pageContext.request.contextPath}/patient/appointment?action=view"><i class="fas fa-list-alt"></i><span>My Appointments</span></a></li>
                </ul>
            </div>
            
            <div class="nav-bottom">
                 <ul class="nav">
                     <li class="nav-item"><a class="nav-link" href="${pageContext.request.contextPath}/index.jsp"><i class="fas fa-home"></i><span>Back to Home</span></a></li>
                    <li class="nav-item"><a class="nav-link nav-link-logout" href="${pageContext.request.contextPath}/<%= currentUserRole %>/auth?action=logout"><i class="fas fa-sign-out-alt"></i><span>Logout</span></a></li>
                 </ul>
            </div>
        </div>
    </div>
    
    <main class="main-content">
        <div class="page-header">
            <h1 class="page-title">
                <i class="fas fa-edit"></i>
                Edit Appointment
            </h1>
            <a href="${pageContext.request.contextPath}/patient/appointment?action=details&id=<%= appointment.getId() %>" class="back-link">
                <i class="fas fa-arrow-left me-2"></i>Back to Details
            </a>
        </div>

        <div class="row">
            <div class="col-lg-8">
                <div class="card">
                    <div class="card-header">
                        <h2 class="card-title">
                            <i class="fas fa-calendar-alt"></i>
                            Update Your Appointment
                        </h2>
                    </div>
                    <div class="card-body">
                        
                        <form action="${pageContext.request.contextPath}/patient/appointment?action=update" method="POST">
                            
                            <input type="hidden" name="action" value="update">
                            <input type="hidden" name="appointmentId" value="<%= appointment.getId() %>">

                            <div class="row">
                                <div class="col-md-6 mb-3">
                                    <label class="form-label">Doctor Name</label>
                                    <div class="input-group">
                                        <span class="input-group-text"><i class="fas fa-user-md text-primary"></i></span>
                                        <input type="text" class="form-control" 
                                               value="Dr. <%= appointment.getDoctorName() %>" readonly>
                                    </div>
                                    <span class="form-helper">Doctor cannot be changed. Please cancel and rebook if needed.</span>
                                </div>
                                
                                <div class="col-md-6 mb-3">
                                    <label class="form-label">Specialization</label>
                                    <div class="input-group">
                                        <span class="input-group-text"><i class="fas fa-stethoscope text-primary"></i></span>
                                        <input type="text" class="form-control" 
                                               value="<%= appointment.getDoctorSpecialization() %>" readonly>
                                    </div>
                                </div>
                            </div>

                            <div class="row">
                                <div class="col-md-6 mb-3">
                                    <label for="appointmentDate" class="form-label">Appointment Date</label>
                                    <div class="input-group">
                                        <span class="input-group-text"><i class="fas fa-calendar-day text-primary"></i></span>
                                        <input type="date" class="form-control" id="appointmentDate" name="appointmentDate"
                                               value="<%= appointment.getAppointmentDate() %>" required>
                                    </div>
                                </div>
                                <div class="col-md-6 mb-3">
                                    <label for="appointmentTime" class="form-label">Appointment Time</label>
                                    <div class="input-group">
                                        <span class="input-group-text"><i class="fas fa-clock text-primary"></i></span>
                                        <input type="time" class="form-control" id="appointmentTime" name="appointmentTime"
                                               value="<%= new SimpleDateFormat("HH:mm").format(appointment.getAppointmentTime()) %>" required>
                                    </div>
                                </div>
                            </div>
                            
                            <div class="mb-3">
                                <label for="appointmentType" class="form-label">Appointment Type</label>
                                <div class="input-group">
                                    <span class="input-group-text"><i class="fas fa-laptop-medical text-primary"></i></span>
                                    <select class="form-select" id="appointmentType" name="appointmentType" required>
                                        <option value="Online" <%= "Online".equals(appointment.getAppointmentType()) ? "selected" : "" %>>Online Consultation</option>
                                        <option value="In-Person" <%= "In-Person".equals(appointment.getAppointmentType()) ? "selected" : "" %>>In-Person Visit</option>
                                    </select>
                                </div>
                            </div>

                            <div class="mb-3">
                                <label for="reason" class="form-label">Reason for Visit</label>
                                <div class="input-group">
                                    <span class="input-group-text"><i class="fas fa-comment-medical text-primary"></i></span>
                                    <textarea class="form-control" id="reason" name="reason" rows="3" required><%= appointment.getReason() %></textarea>
                                </div>
                            </div>
                            
                            <div class="mb-4">
                                <label for="notes" class="form-label">Additional Notes</label>
                                <div class="input-group">
                                    <span class="input-group-text"><i class="fas fa-notes-medical text-primary"></i></span>
                                    <textarea class="form-control" id="notes" name="notes" rows="3"><%= appointment.getNotes() != null ? appointment.getNotes() : "" %></textarea>
                                </div>
                            </div>
                            
                            <div class="d-grid gap-2">
                                <button type="submit" class="btn btn-primary">
                                    <i class="fas fa-save me-2"></i>Update Appointment
                                </button>
                            </div>

                        </form>
                    </div>
                </div>
            </div>
        </div>
    </main>
</body>
</html>