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

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>

    <style>
        :root {
            --primary: #4361ee;
            --primary-light: #eef2ff;
            --primary-dark: #3a56d4;
            --secondary: #6c757d;
            --success: #28a745;
            --warning: #ffc107;
            --danger: #dc3545;
            --danger-light: #fbebee;
            --light: #f8f9fa;
            --lighter: #fdfdfe;
            --dark: #1a1d29;
            --darker: #12141c;
            --gray-100: #f8f9fa;
            --gray-200: #e9ecef;
            --gray-300: #dee2e6;
            --gray-400: #ced4da;
            --gray-500: #adb5bd;
            --gray-600: #6c757d;
            --gray-700: #495057;
            --gray-800: #343a40;
            --gray-900: #212529;
            --sidebar-width: 280px;
            --transition: all 0.3s ease;
            --border-radius: 12px;
            --shadow-sm: 0 2px 4px rgba(0,0,0,0.05);
            --shadow-md: 0 4px 12px rgba(0,0,0,0.08);
            --shadow-lg: 0 10px 30px rgba(0,0,0,0.12);
        }
        
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }
        
        body {
            font-family: 'Inter', sans-serif;
            background-color: var(--gray-100);
            color: var(--gray-800);
            line-height: 1.6;
            display: flex;
            height: 100vh;
            overflow: hidden;
        }
        
        .sidebar {
            width: var(--sidebar-width);
            flex-shrink: 0;
            background: linear-gradient(135deg, #ffffff, #f8fafc);
            color: var(--gray-700);
            height: 100vh;
            left: 0;
            top: 0;
            overflow-y: auto;
            transition: var(--transition);
            box-shadow: var(--shadow-md);
            display: flex;
            flex-direction: column;
            border-right: 1px solid var(--gray-200);
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
            border-bottom: 1px solid var(--gray-200);
            margin-bottom: 1rem;
        }
        
        .user-avatar {
            width: 80px;
            height: 80px;
            border-radius: 50%;
            background: linear-gradient(135deg, var(--primary), #5a6ff0);
            display: flex;
            align-items: center;
            justify-content: center;
            margin: 0 auto 1rem;
            border: 3px solid var(--primary-light);
            box-shadow: var(--shadow-sm);
        }
        
        .user-avatar i {
            font-size: 2.5rem;
            color: white;
        }
        
        .user-info h6 {
            font-size: 1.1rem;
            font-weight: 600;
            margin-bottom: 0.25rem;
            color: var(--gray-800);
        }
        
        .user-info .badge {
            background: var(--primary-light);
            color: var(--primary);
            padding: 0.25rem 0.75rem;
            border-radius: 20px;
            font-size: 0.75rem;
            font-weight: 500;
            border: 1px solid rgba(67, 97, 238, 0.2);
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
            border-top: 1px solid var(--gray-200);
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
            color: var(--gray-600);
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
            padding: 0;
            min-height: 100vh;
            overflow-y: auto;
            background: var(--gray-100);
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
                box-shadow: var(--shadow-lg);
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
            background: var(--gray-400);
            border-radius: 3px;
        }
        .main-content::-webkit-scrollbar-thumb {
            background: var(--gray-400);
            border-radius: 3px;
        }
        
        .sidebar::-webkit-scrollbar-thumb:hover {
            background: var(--gray-500);
        }
        .main-content::-webkit-scrollbar-thumb:hover {
            background: var(--gray-500);
        }
        
        .profile-header {
            background: linear-gradient(135deg, var(--primary), #5a6ff0);
            color: white;
            padding: 2.5rem 2.5rem;
            margin-bottom: 2rem;
            box-shadow: var(--shadow-md);
        }
        
        .profile-body-wrapper {
             padding: 0 2.5rem 2.5rem;
        }

        .card-modern {
            border: none;
            border-radius: var(--border-radius);
            box-shadow: var(--shadow-md);
            transition: var(--transition);
            overflow: hidden;
            background: white;
        }
        
        .card-modern:hover {
            box-shadow: var(--shadow-lg);
            transform: translateY(-3px);
        }
        
        .card-header-modern {
            background: white;
            border-bottom: 1px solid var(--gray-200);
            padding: 1.5rem;
            font-weight: 600;
            display: flex;
            align-items: center;
            color: var(--gray-800);
        }
        
        .card-header-modern i {
            color: var(--primary);
            margin-right: 10px;
            font-size: 1.1rem;
        }
        
        .btn-modern {
            border-radius: 10px;
            padding: 0.75rem 1.5rem;
            font-weight: 500;
            transition: var(--transition);
            font-size: 0.95rem;
            text-decoration: none;
            display: inline-flex;
            align-items: center;
            justify-content: center;
            gap: 0.5rem;
            border: none;
            cursor: pointer;
        }
        
        .btn-primary-modern {
            background: linear-gradient(135deg, var(--primary), var(--primary-dark));
            color: white;
        }
        
        .btn-primary-modern:hover {
            transform: translateY(-2px);
            box-shadow: 0 7px 14px rgba(67, 97, 238, 0.25);
        }

        .back-link {
            color: rgba(255, 255, 255, 0.9);
            text-decoration: none;
            font-weight: 500;
            padding: 0.5rem 1rem;
            border-radius: 8px;
            transition: var(--transition);
            display: inline-flex;
            align-items: center;
            gap: 0.5rem;
            background: rgba(255, 255, 255, 0.15);
            border: 1px solid rgba(255, 255, 255, 0.2);
        }
        
        .back-link:hover {
            color: white;
            background: rgba(255, 255, 255, 0.25);
            transform: translateY(-1px);
            text-decoration: none;
        }

        .icon-box {
            width: 45px;
            height: 45px;
            border-radius: 12px;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 1.2rem;
            flex-shrink: 0;
        }
        
        .icon-primary { background-color: var(--primary-light); color: var(--primary); }
        .icon-success { background-color: #d1fae5; color: #065f46; }
        .icon-warning { background-color: #fef3c7; color: #92400e; }
        .icon-info { background-color: #dbeafe; color: #1e40af; }
        .icon-danger { background-color: var(--danger-light); color: var(--danger); }
        
        .badge {
            display: inline-flex;
            align-items: center;
            padding: 0.4em 0.75em;
            font-size: 0.8rem;
            font-weight: 600;
            line-height: 1;
            text-align: center;
            white-space: nowrap;
            vertical-align: baseline;
            border-radius: 50px;
        }
        
        .badge-pending { color: #92400e; background-color: #fef3c7; }
        .badge-confirmed { color: #065f46; background-color: #d1fae5; }
        .badge-completed { color: #1e40af; background-color: #dbeafe; }
        .badge-cancelled { color: #991b1b; background-color: #fee2e2; }
        .badge-secondary { color: var(--gray-700); background-color: var(--gray-200); } /* Added */
        
        .alert-modern {
            border-radius: 10px;
            border: none;
            box-shadow: var(--shadow-sm);
            padding: 1rem 1.5rem;
        }
        
        .row { display: flex; flex-wrap: wrap; margin-right: -15px; margin-left: -15px; }
        .col-lg-8, .col-lg-4, .col-md-6, .col-12, .col-md-3 { position: relative; width: 100%; padding-right: 15px; padding-left: 15px; }
        .justify-content-center { justify-content: center !important; }
        .justify-content-md-end { justify-content: flex-end !important; }
        @media (min-width: 768px) {
            .col-md-6 { flex: 0 0 50%; max-width: 50%; }
            .col-md-3 { flex: 0 0 25%; max-width: 25%; }
            .me-md-2 { margin-right: 0.5rem !important; }
        }
        @media (min-width: 992px) {
            .col-lg-8 { flex: 0 0 66.666667%; max-width: 66.666667%; }
            .col-lg-4 { flex: 0 0 33.333333%; max-width: 33.333333%; }
        }
        .col-12 { flex: 0 0 100%; max-width: 100%; }
        .mb-0 { margin-bottom: 0 !important; }
        .mb-1 { margin-bottom: 0.25rem !important; }
        .mb-2 { margin-bottom: 0.5rem !important; }
        .mb-3 { margin-bottom: 1rem !important; }
        .mb-4 { margin-bottom: 1.5rem !important; }
        .mt-1 { margin-top: 0.25rem !important; }
        .mt-4 { margin-top: 1.5rem !important; }
        .mx-auto { margin-left: auto !important; margin-right: auto !important; }
        .py-3 { padding-top: 1rem !important; padding-bottom: 1rem !important; }
        .py-4 { padding-top: 1.5rem !important; padding-bottom: 1.5rem !important; }
        .p-4 { padding: 1.5rem !important; }
        .pt-3 { padding-top: 1rem !important; }
        .d-flex { display: flex !important; }
        .d-md-flex { display: flex !important; }
        .d-grid { display: grid !important; }
        .d-block { display: block !important; }
        .d-inline { display: inline !important; }
        .justify-content-between { justify-content: space-between !important; }
        .align-items-center { align-items: center !important; }
        .border-bottom { border-bottom: 1px solid var(--gray-200) !important; }
        hr { margin-top: 1rem; margin-bottom: 1rem; border: 0; border-top: 1px solid var(--gray-200); }
        .h2 { font-size: 1.75rem; font-weight: 600; }
        .h4 { font-size: 1.5rem; }
        .h5 { font-size: 1.1rem; }
        .h6 { font-size: 1rem; }
        .me-2 { margin-right: 0.5rem !important; }
        .me-1 { margin-right: 0.25rem !important; }
        .me-3 { margin-right: 1rem !important; }
        .text-primary { color: var(--primary) !important; }
        .text-success { color: #198754 !important; }
        .card { position: relative; display: flex; flex-direction: column; min-width: 0; word-wrap: break-word; background-color: #fff; background-clip: border-box; border: 1px solid var(--gray-200); border-radius: 0.5rem; }
        .card-body { flex: 1 1 auto; padding: 1.5rem; }
        .text-center { text-align: center !important; }
        .text-muted { color: #6c757d !important; }
        .gap-2 { gap: 0.5rem !important; }
        .list-group { display: flex; flex-direction: column; padding-left: 0; margin-bottom: 0; border-radius: .25rem; }
        .list-group-flush { border-radius: 0; }
        .list-group-flush>.list-group-item { border-width: 0 0 1px; }
        .list-group-flush>.list-group-item:last-child { border-bottom-width: 0; }
        .list-group-item { position: relative; display: block; padding: .5rem 1rem; color: #212529; text-decoration: none; background-color: #fff; border: 1px solid rgba(0,0,0,.125); }
        
        .btn {
            display: inline-flex;
            align-items: center;
            justify-content: center;
            gap: 0.5rem;
            padding: 0.6rem 1.2rem;
            font-weight: 500;
            border-radius: var(--border-radius);
            text-decoration: none;
            transition: var(--transition);
            border: none;
            cursor: pointer;
            font-size: 0.9rem;
        }
        
        .btn-sm {
            padding: 0.375rem 0.75rem;
            font-size: 0.8rem;
        }
        
        .btn-primary {
            background-color: var(--primary);
            border-color: var(--primary);
            color: white;
        }
        
        .btn-primary:hover {
            background-color: var(--primary-dark);
            border-color: var(--primary-dark);
            transform: translateY(-2px);
            box-shadow: 0 4px 8px rgba(79, 70, 229, 0.2);
        }
        
        .btn-outline-primary {
            border: 1px solid var(--primary);
            color: var(--primary);
            background-color: transparent;
        }
        
        .btn-outline-primary:hover {
            background-color: var(--primary);
            color: white;
        }
        
        .btn-secondary {
            background-color: var(--secondary);
            border-color: var(--secondary);
            color: white;
        }
        
        .btn-secondary:hover {
            background-color: #5a6268;
            border-color: #545b62;
        }
        
        .btn-outline-secondary {
            color: #6c757d;
            border-color: #6c757d;
        }
        
        .btn-outline-secondary:hover {
            color: #fff;
            background-color: #6c757d;
            border-color: #6c757d;
        }
        
        .btn-danger { 
            background-color: var(--danger); 
            border-color: var(--danger); 
            color: white; 
        }
        
        .btn-danger:hover { 
            background-color: #c82333; 
            border-color: #bd2130; 
        }
        
        .btn-warning { 
            background-color: var(--warning); 
            border-color: var(--warning); 
            color: #212529; 
        }
        
        .btn-warning:hover { 
            background-color: #e0a800; 
            border-color: #d39e00; 
        }
        
        .btn-outline-warning { 
            border-color: var(--warning); 
            color: var(--warning); 
            background-color: transparent; 
        }
        
        .btn-outline-warning:hover { 
            background-color: var(--warning); 
            color: #212529; 
        }
        
        .btn-success { 
            background-color: var(--success); 
            border-color: var(--success); 
            color: white; 
        }
        
        .btn-success:hover { 
            background-color: #157347; 
            border-color: #146c43; 
        }
        
        .btn-info { 
            background-color: var(--info); 
            border-color: var(--info); 
            color: #000; 
        }
        
        .btn-info:hover { 
            background-color: #31d2f2; 
            border-color: #25cff2; 
        }
        
        .w-100 { width: 100% !important; }

        .alert { 
            position: relative; 
            padding: 1rem 1rem; 
            margin-bottom: 1rem; 
            border: 1px solid transparent; 
            border-radius: var(--border-radius); 
        }
        
        .alert-success { 
            color: #0f5132; 
            background-color: #d1e7dd; 
            border-color: #badbcc; 
        }
        
        .alert-danger { 
            color: #842029; 
            background-color: #f8d7da; 
            border-color: #f5c2c7; 
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
        
        .fade { 
            transition: opacity 0.15s linear; 
        }
        
        .show { 
            opacity: 1; 
        }

        .form-label {
            font-weight: 500;
            margin-bottom: 0.5rem;
            color: var(--gray-700);
            display: block;
        }
        
        .input-group {
            position: relative;
            display: flex;
            flex-wrap: wrap;
            align-items: stretch;
            width: 100%;
            border-radius: 10px;
            overflow: hidden;
            border: 1px solid var(--gray-300);
            transition: var(--transition);
        }

        .input-group:focus-within {
            border-color: var(--primary);
            box-shadow: 0 0 0 3px rgba(67, 97, 238, 0.15);
        }

        .input-group-text {
            background: var(--gray-100);
            border: none;
            color: var(--gray-600);
            padding: 0.75rem 1rem;
            display: flex;
            align-items: center;
            justify-content: center;
            min-width: 50px;
            flex-shrink: 0;
        }

        .form-control, .form-select {
            border-radius: 0;
            padding: 0.75rem 1rem;
            border: none;
            transition: var(--transition);
            font-size: 0.95rem;
            width: 100%;
            flex: 1;
        }

        .form-control:focus, .form-select:focus {
            box-shadow: none;
            border: none;
            outline: none;
        }

        .input-group:focus-within .input-group-text {
            background: var(--primary-light);
            color: var(--primary);
        }
    </style>
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

    <main class="main-content">
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