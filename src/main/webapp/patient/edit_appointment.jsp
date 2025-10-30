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
    
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>

    <style>
        /* (Re-using the same CSS from your other pages) */
        :root {
            --primary: #4f46e5;
            --primary-light: #eef2ff;
            --primary-dark: #4338ca;
            --secondary: #6b7280;
            --success: #10b981;
            --warning: #f59e0b;
            --info: #0ea5e9;
            --danger: #ef4444;
            --danger-light: #fef2f2;
            --dark: #1f2937;
            --darker: #111827;
            --light: #f9fafb;
            --sidebar-width: 280px;
            --transition: all 0.3s ease;
            --border-radius: 12px;
            --shadow: 0 4px 6px -1px rgba(0, 0, 0, 0.1), 0 2px 4px -1px rgba(0, 0, 0, 0.06);
            --shadow-lg: 0 10px 15px -3px rgba(0, 0, 0, 0.1), 0 4px 6px -2px rgba(0, 0, 0, 0.05);
        }
        
        * { margin: 0; padding: 0; box-sizing: border-box; }
        
        body {
            font-family: 'Inter', sans-serif;
            background-color: #f9fafb;
            color: var(--dark);
            line-height: 1.6;
            display: flex;
            height: 100vh;
            overflow: hidden;
        }
        
        /* --- Sidebar Styles (Copied from your other files) --- */
        .sidebar {
            width: var(--sidebar-width);
            flex-shrink: 0;
            background: linear-gradient(135deg, #ffffff, #f8fafc);
            color: var(--dark);
            height: 100vh;
            overflow-y: auto;
            transition: var(--transition);
            box-shadow: var(--shadow-lg);
            display: flex;
            flex-direction: column;
            border-right: 1px solid #e5e7eb;
        }
        
        .sidebar-sticky {
            display: flex;
            flex-direction: column;
            min-height: 100%;
            padding: 1.5rem 0;
        }
        
        .user-section {
            text-align: center;
            padding: 1.5rem 1.5rem 2rem;
            border-bottom: 1px solid #e5e7eb;
            margin-bottom: 1rem;
        }
        
        .user-avatar {
            width: 80px;
            height: 80px;
            border-radius: 50%;
            background: linear-gradient(135deg, var(--primary), #6366f1);
            display: flex;
            align-items: center;
            justify-content: center;
            margin: 0 auto 1rem;
            border: 3px solid var(--primary-light);
            box-shadow: 0 4px 12px rgba(79, 70, 229, 0.2);
        }
        
        .user-avatar i { font-size: 2.5rem; color: white; }
        .user-info h6 { font-size: 1.1rem; font-weight: 600; margin-bottom: 0.25rem; color: var(--dark); }
        .user-info .badge {
            background: var(--primary-light);
            color: var(--primary);
            padding: 0.25rem 0.75rem;
            border-radius: 20px;
            font-size: 0.75rem;
            font-weight: 500;
            border: 1px solid rgba(79, 70, 229, 0.2);
        }
        
        .nav { display: flex; flex-direction: column; gap: 0.5rem; padding: 0 1rem; list-style: none; }
        .nav-main { flex-grow: 1; }
        .nav-bottom { margin-top: auto; padding-top: 1rem; border-top: 1px solid #e5e7eb; margin: 1.5rem 0 0 0; }
        .nav-item { margin-bottom: 0.25rem; }
        .nav-link {
            display: flex; align-items: center; gap: 1rem; padding: 0.875rem 1.25rem;
            color: #6b7280; text-decoration: none; border-radius: var(--border-radius);
            transition: var(--transition); font-weight: 500; position: relative; overflow: hidden;
        }
        .nav-link::before {
            content: ''; position: absolute; left: 0; top: 0; height: 100%;
            width: 4px; background: var(--primary); transform: scaleY(0);
            transition: var(--transition); border-radius: 0 4px 4px 0;
        }
        .nav-link:hover { color: var(--primary); background: var(--primary-light); transform: translateX(5px); }
        .nav-link:hover::before { transform: scaleY(1); }
        .nav-link.active { color: var(--primary); background: var(--primary-light); }
        .nav-link.active::before { transform: scaleY(1); }
        .nav-link i { width: 20px; text-align: center; font-size: 1.1rem; transition: var(--transition); }
        .nav-link.active i { color: var(--primary); }
        .nav-link:hover i { transform: scale(1.1); }
        .nav-link-logout { color: var(--danger); }
        .nav-link-logout:hover { background: var(--danger-light); color: var(--danger); transform: translateX(5px); }
        .nav-link-logout:hover i { color: var(--danger); }
        .nav-link-logout i { color: var(--danger); }
        /* --- End Sidebar Styles --- */

        .main-content {
            flex-grow: 1;
            padding: 2rem;
            min-height: 100vh;
            overflow-y: auto;
            background-color: #f8fafc;
        }
        
        /* Page Header */
        .page-header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 2rem;
            padding-bottom: 1rem;
            border-bottom: 1px solid #e5e7eb;
        }
        
        .page-title {
            display: flex;
            align-items: center;
            gap: 0.75rem;
            font-size: 1.75rem;
            font-weight: 700;
            color: var(--dark);
        }
        
        .page-title i { color: var(--primary); }
        
        .back-link {
            display: inline-flex; align-items: center; gap: 0.5rem; padding: 0.75rem 1.25rem;
            background: white; border-radius: var(--border-radius); box-shadow: var(--shadow);
            font-weight: 500; color: var(--dark); text-decoration: none;
            border: 1px solid #e5e7eb; transition: var(--transition);
        }
        
        .back-link:hover {
            background: var(--primary-light); color: var(--primary);
            border-color: var(--primary); text-decoration: none; transform: translateY(-2px);
        }
        
        .back-link i { color: var(--primary); }
        
        /* Card Styles */
        .card {
            background: white; border-radius: var(--border-radius);
            box-shadow: var(--shadow); border: 1px solid #f3f4f6;
        }
        .card-header {
            padding: 1.25rem 1.5rem; border-bottom: 1px solid #f3f4f6;
            display: flex; align-items: center; background: #fafafa;
        }
        .card-title {
            display: flex; align-items: center; gap: 0.5rem;
            font-weight: 600; color: var(--dark); margin: 0;
        }
        .card-title i { color: var(--primary); }
        .card-body { padding: 1.5rem; }
        
        /* Form Styles */
        .form-label { font-weight: 500; margin-bottom: 0.5rem; color: var(--dark); display: block; }
        .input-group {
            position: relative; display: flex; flex-wrap: wrap; align-items: stretch;
            width: 100%; border-radius: 10px; overflow: hidden;
            border: 1px solid #d1d5db; transition: var(--transition);
        }
        .input-group:focus-within { border-color: var(--primary); box-shadow: 0 0 0 3px rgba(79, 70, 229, 0.15); }
        .input-group-text {
            background: #f9fafb; border: none; color: #6b7280; padding: 0.75rem 1rem;
            display: flex; align-items: center; justify-content: center; min-width: 50px; flex-shrink: 0;
        }
        .form-control, .form-select {
            border-radius: 0; padding: 0.75rem 1rem; border: none;
            transition: var(--transition); font-size: 0.95rem; width: 100%; flex: 1;
        }
        .form-control:focus, .form-select:focus { box-shadow: none; border: none; outline: none; }
        .form-control[readonly] { background-color: #e9ecef; }
        .form-helper { font-size: 0.875rem; color: #6b7280; margin-top: 0.5rem; display: block; }
        
        /* Button Styles */
        .btn {
            display: inline-flex; align-items: center; gap: 0.5rem; padding: 0.75rem 1.5rem;
            font-weight: 500; border-radius: var(--border-radius); text-decoration: none;
            transition: var(--transition); border: none; cursor: pointer; font-size: 0.95rem;
        }
        .btn-primary { background: linear-gradient(135deg, var(--primary), var(--primary-dark)); color: white; }
        .btn-primary:hover { transform: translateY(-2px); box-shadow: 0 7px 14px rgba(79, 70, 229, 0.25); }
        .btn-outline-secondary {
            background: transparent; border: 1px solid #6b7280; color: #6b7280;
        }
        .btn-outline-secondary:hover { background: #6b7280; color: white; }
        
        .row { display: flex; flex-wrap: wrap; margin-right: -15px; margin-left: -15px; }
        .col-md-6, .col-lg-8 { position: relative; width: 100%; padding-right: 15px; padding-left: 15px; }
        @media (min-width: 768px) {
            .col-md-6 { flex: 0 0 50%; max-width: 50%; }
        }
        @media (min-width: 992px) {
            .col-lg-8 { flex: 0 0 66.666667%; max-width: 66.666667%; }
        }
        .mb-3 { margin-bottom: 1rem !important; }
        .mb-4 { margin-bottom: 1.5rem !important; }
        .mt-3 { margin-top: 1rem !important; }
        .me-2 { margin-right: 0.5rem !important; }
        .d-grid { display: grid !important; }
        .gap-2 { gap: 0.5rem !important; }
    </style>
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