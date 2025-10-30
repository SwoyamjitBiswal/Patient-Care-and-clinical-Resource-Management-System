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
    
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>

    <style>
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
        
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }
        
        body {
            font-family: 'Inter', sans-serif;
            background-color: #f9fafb;
            color: var(--dark);
            line-height: 1.6;
            display: flex;
            height: 100vh;
            overflow: hidden;
        }
        
        /* Light Mode Sidebar */
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
        
        .user-avatar i {
            font-size: 2.5rem;
            color: white;
        }
        
        .user-info h6 {
            font-size: 1.1rem;
            font-weight: 600;
            margin-bottom: 0.25rem;
            color: var(--dark);
        }
        
        .user-info .badge {
            background: var(--primary-light);
            color: var(--primary);
            padding: 0.25rem 0.75rem;
            border-radius: 20px;
            font-size: 0.75rem;
            font-weight: 500;
            border: 1px solid rgba(79, 70, 229, 0.2);
        }
        
        .nav {
            display: flex;
            flex-direction: column;
            gap: 0.5rem;
            padding: 0 1rem;
            list-style: none;
        }
        
        .nav-main {
            flex-grow: 1;
        }
        
        .nav-bottom {
            margin-top: auto;
            padding-top: 1rem;
            border-top: 1px solid #e5e7eb;
            margin: 1.5rem 0 0 0;
        }

        .nav-item {
            margin-bottom: 0.25rem;
        }
        
        .nav-link {
            display: flex;
            align-items: center;
            gap: 1rem;
            padding: 0.875rem 1.25rem;
            color: #6b7280;
            text-decoration: none;
            border-radius: var(--border-radius);
            transition: var(--transition);
            font-weight: 500;
            position: relative;
            overflow: hidden;
        }
        
        .nav-link::before {
            content: '';
            position: absolute;
            left: 0;
            top: 0;
            height: 100%;
            width: 4px;
            background: var(--primary);
            transform: scaleY(0);
            transition: var(--transition);
            border-radius: 0 4px 4px 0;
        }
        
        .nav-link:hover {
            color: var(--primary);
            background: var(--primary-light);
            transform: translateX(5px);
        }
        
        .nav-link:hover::before {
            transform: scaleY(1);
        }
        
        .nav-link.active {
            color: var(--primary);
            background: var(--primary-light);
        }
        
        .nav-link.active::before {
            transform: scaleY(1);
        }
        
        .nav-link i {
            width: 20px;
            text-align: center;
            font-size: 1.1rem;
            transition: var(--transition);
        }
        
        .nav-link.active i {
            color: var(--primary);
        }
        
        .nav-link:hover i {
            transform: scale(1.1);
        }
        
        .nav-link-logout {
            color: var(--danger);
        }
        
        .nav-link-logout:hover {
            background: var(--danger-light);
            color: var(--danger);
            transform: translateX(5px);
        }
        
        .nav-link-logout:hover i {
            color: var(--danger);
        }
        
        .nav-link-logout i {
            color: var(--danger);
        }

        .main-content {
            flex-grow: 1;
            padding: 2rem;
            min-height: 100vh;
            overflow-y: auto;
            background-color: #f8fafc;
        }
        
        .mobile-menu-toggle {
            position: fixed;
            top: 1.5rem;
            left: 1.5rem;
            z-index: 999;
            background: var(--primary);
            color: white;
            border: none;
            width: 45px;
            height: 45px;
            border-radius: 10px;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 1.25rem;
            cursor: pointer;
            box-shadow: 0 4px 12px rgba(79, 70, 229, 0.3);
            display: none;
        }
        
        @media (max-width: 768px) {
            body {
                display: block;
                height: auto;
                overflow: visible;
            }
            .sidebar {
                transform: translateX(-100%);
                z-index: 1000;
                position: fixed;
            }
            
            .sidebar.mobile-open {
                transform: translateX(0);
            }
            
            .main-content {
                margin-left: 0;
                padding: 1.5rem;
                padding-top: 6rem;
            }
            
            .mobile-menu-toggle {
                display: flex;
            }
        }
        
        .sidebar::-webkit-scrollbar,
        .main-content::-webkit-scrollbar {
            width: 6px;
        }
        
        .sidebar::-webkit-scrollbar-track,
        .main-content::-webkit-scrollbar-track {
            background: rgba(0, 0, 0, 0.05);
        }
        
        .sidebar::-webkit-scrollbar-thumb {
            background: #d1d5db;
            border-radius: 3px;
        }
        .main-content::-webkit-scrollbar-thumb {
            background: #d1d5db;
            border-radius: 3px;
        }
        
        .sidebar::-webkit-scrollbar-thumb:hover {
            background: #9ca3af;
        }
        .main-content::-webkit-scrollbar-thumb:hover {
            background: #9ca3af;
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
        
        .page-title i {
            color: var(--primary);
        }
        
        .back-link {
            display: inline-flex;
            align-items: center;
            gap: 0.5rem;
            padding: 0.75rem 1.25rem;
            background: white;
            border-radius: var(--border-radius);
            box-shadow: var(--shadow);
            font-weight: 500;
            color: var(--dark);
            text-decoration: none;
            border: 1px solid #e5e7eb;
            transition: var(--transition);
        }
        
        .back-link:hover {
            background: var(--primary-light);
            color: var(--primary);
            border-color: var(--primary);
            text-decoration: none;
            transform: translateY(-2px);
        }
        
        .back-link i {
            color: var(--primary);
        }
        
        /* Card Styles */
        .card {
            background: white;
            border-radius: var(--border-radius);
            box-shadow: var(--shadow);
            overflow: hidden;
            transition: var(--transition);
            border: 1px solid #f3f4f6;
        }
        
        .card:hover {
            box-shadow: var(--shadow-lg);
            transform: translateY(-2px);
        }
        
        .card-header {
            padding: 1.25rem 1.5rem;
            border-bottom: 1px solid #f3f4f6;
            display: flex;
            align-items: center;
            background: #fafafa;
        }
        
        .card-title {
            display: flex;
            align-items: center;
            gap: 0.5rem;
            font-weight: 600;
            color: var(--dark);
            margin: 0;
        }
        
        .card-title i {
            color: var(--primary);
        }
        
        .card-body {
            padding: 1.5rem;
        }
        
        /* Badge Styles */
        .badge {
            display: inline-flex;
            align-items: center;
            gap: 0.5rem;
            padding: 0.5rem 1rem;
            font-size: 0.875rem;
            font-weight: 600;
            border-radius: 50px;
            border: 1px solid transparent;
        }
        
        .badge-pending { 
            color: #92400e; 
            background-color: #fef3c7; 
            border-color: #f59e0b;
        }
        .badge-confirmed { 
            color: #065f46; 
            background-color: #d1fae5; 
            border-color: #10b981;
        }
        .badge-completed { 
            color: #1e40af; 
            background-color: #dbeafe; 
            border-color: #0ea5e9;
        }
        .badge-cancelled { 
            color: #991b1b; 
            background-color: #fee2e2; 
            border-color: #ef4444;
        }
        .badge-light { 
            color: #374151; 
            background-color: #f3f4f6; 
            border-color: #d1d5db;
        }
        
        /* Button Styles */
        .btn {
            display: inline-flex;
            align-items: center;
            gap: 0.5rem;
            padding: 0.75rem 1.5rem;
            font-weight: 500;
            border-radius: var(--border-radius);
            text-decoration: none;
            transition: var(--transition);
            border: none;
            cursor: pointer;
            font-size: 0.95rem;
        }
        
        .btn-primary {
            background: linear-gradient(135deg, var(--primary), var(--primary-dark));
            color: white;
        }
        
        .btn-primary:hover {
            transform: translateY(-2px);
            box-shadow: 0 7px 14px rgba(79, 70, 229, 0.25);
        }
        
        .btn-secondary {
            background: #6b7280;
            color: white;
        }
        
        .btn-secondary:hover {
            background: #4b5563;
            transform: translateY(-2px);
        }
        
        .btn-warning {
            background: var(--warning);
            color: #000;
        }
        
        .btn-warning:hover {
            background: #e0a800;
            transform: translateY(-2px);
        }
        
        .btn-danger {
            background: var(--danger);
            color: white;
        }
        
        .btn-danger:hover {
            background: #dc2626;
            transform: translateY(-2px);
        }
        
        .btn-outline-secondary {
            background: transparent;
            border: 1px solid #6b7280;
            color: #6b7280;
        }
        
        .btn-outline-secondary:hover {
            background: #6b7280;
            color: white;
        }
        
        /* Alert Styles */
        .alert {
            border-radius: var(--border-radius);
            border: none;
            box-shadow: var(--shadow);
            padding: 1rem 1.5rem;
            margin-bottom: 1.5rem;
        }
        
        .alert-success {
            color: #065f46;
            background-color: #d1fae5;
            border-left: 4px solid #10b981;
        }
        
        .alert-danger {
            color: #7f1d1d;
            background-color: #fef2f2;
            border-left: 4px solid #ef4444;
        }
        
        .alert-dismissible {
            padding-right: 3rem;
        }
        
        .btn-close {
            box-sizing: content-box;
            width: 1em;
            height: 1em;
            padding: 0.25em 0.25em;
            color: #000;
            background: transparent;
            border: 0;
            border-radius: 0.25rem;
            opacity: 0.5;
        }
        
        .alert-dismissible .btn-close {
            position: absolute;
            top: 0;
            right: 0;
            z-index: 2;
            padding: 1.25rem 1rem;
        }
        
        /* Icon Boxes */
        .icon-box {
            width: 50px;
            height: 50px;
            border-radius: var(--border-radius);
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 1.25rem;
            flex-shrink: 0;
        }
        
        .icon-primary {
            background-color: var(--primary-light);
            color: var(--primary);
        }
        
        .icon-success {
            background-color: #d1fae5;
            color: #065f46;
        }
        
        .icon-warning {
            background-color: #fef3c7;
            color: #92400e;
        }
        
        .icon-info {
            background-color: #dbeafe;
            color: #1e40af;
        }
        
        .icon-danger {
            background-color: #fee2e2;
            color: #991b1b;
        }
        
        /* Info Sections */
        .info-section {
            margin-bottom: 2rem;
        }
        
        .info-section:last-child {
            margin-bottom: 0;
        }
        
        .info-section-title {
            font-size: 1.1rem;
            font-weight: 600;
            color: var(--primary);
            margin-bottom: 1rem;
            display: flex;
            align-items: center;
            gap: 0.5rem;
        }
        
        .info-item {
            display: flex;
            align-items: center;
            gap: 1rem;
            padding: 1rem;
            border-radius: var(--border-radius);
            transition: var(--transition);
            margin-bottom: 0.75rem;
        }
        
        .info-item:hover {
            background: #f9fafb;
        }
        
        .info-item:last-child {
            margin-bottom: 0;
        }
        
        .info-content {
            flex: 1;
        }
        
        .info-label {
            font-weight: 600;
            color: var(--dark);
            margin-bottom: 0.25rem;
        }
        
        .info-value {
            color: #6b7280;
        }
        
        /* Status Guide */
        .status-guide {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(140px, 1fr));
            gap: 1rem;
        }
        
        .status-item {
            text-align: center;
            padding: 1.5rem 1rem;
            border-radius: var(--border-radius);
            transition: var(--transition);
        }
        
        .status-item:hover {
            background: #f9fafb;
            transform: translateY(-2px);
        }
        
        .status-icon {
            width: 60px;
            height: 60px;
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
            margin: 0 auto 1rem;
            font-size: 1.5rem;
        }
        
        .status-title {
            font-weight: 600;
            margin-bottom: 0.5rem;
            color: var(--dark);
        }
        
        .status-desc {
            font-size: 0.875rem;
            color: #6b7280;
        }
        
        /* Utility Classes */
        .d-flex { display: flex !important; }
        .d-grid { display: grid !important; }
        .justify-content-between { justify-content: space-between !important; }
        .justify-content-center { justify-content: center !important; }
        .align-items: center { align-items: center !important; }
        .text-center { text-align: center !important; }
        .mb-0 { margin-bottom: 0 !important; }
        .mb-1 { margin-bottom: 0.25rem !important; }
        .mb-2 { margin-bottom: 0.5rem !important; }
        .mb-3 { margin-bottom: 1rem !important; }
        .mb-4 { margin-bottom: 1.5rem !important; }
        .mt-4 { margin-top: 1.5rem !important; }
        .me-2 { margin-right: 0.5rem !important; }
        .me-3 { margin-right: 1rem !important; }
        .gap-2 { gap: 0.5rem !important; }
        .row { display: flex; flex-wrap: wrap; margin-right: -15px; margin-left: -15px; }
        .col-lg-8, .col-md-6, .col-12 { position: relative; width: 100%; padding-right: 15px; padding-left: 15px; }
        @media (min-width: 768px) {
            .col-md-6 { flex: 0 0 50%; max-width: 50%; }
        }
        @media (min-width: 992px) {
            .col-lg-8 { flex: 0 0 66.666667%; max-width: 66.666667%; }
        }
        
        hr {
            margin: 2rem 0;
            border: 0;
            border-top: 1px solid #e5e7eb;
        }
        
        @media (max-width: 576px) {
            .page-header {
                flex-direction: column;
                align-items: flex-start;
                gap: 1rem;
            }
            
            .back-link {
                align-self: stretch;
                text-align: center;
                justify-content: center;
            }
            
            .status-guide {
                grid-template-columns: 1fr;
            }
        }
    </style>
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