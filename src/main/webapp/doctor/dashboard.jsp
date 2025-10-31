<%@ page import="com.entity.Doctor" %>
<%@ page import="com.dao.AppointmentDao" %>
<%@ page import="java.util.List" %>
<%@ page import="com.entity.Appointment" %>
<%@ page import="java.util.stream.Collectors" %> <%-- For Stream API --%>
<%
    // Renamed 'doctor' to 'currentDoctor' for clarity
    Doctor currentDoctor = (Doctor) session.getAttribute("doctorObj");
    if (currentDoctor == null) {
        response.sendRedirect(request.getContextPath() + "/doctor/login.jsp"); // Added context path
        return;
    }

    AppointmentDao appointmentDao = new AppointmentDao();
    List<Appointment> appointments = appointmentDao.getAppointmentsByDoctorId(currentDoctor.getId());
    int[] stats = appointmentDao.getDoctorAppointmentStats(currentDoctor.getId());

    // Get recent appointments (handle potential empty list)
    List<Appointment> recentAppointments = appointments.isEmpty() ?
                                            new java.util.ArrayList<>() :
                                            appointments.subList(0, Math.min(10, appointments.size())); // Increased to 10

    // Variable needed for the sidebar's logout button
    String currentUserRole = "doctor";
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Patient Care System - Doctor Dashboard</title>

    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" rel="stylesheet">
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700&display=swap" rel="stylesheet">

    <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>

     <style>
        /* --- Light Mode Variables & Base Styles --- */
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
        
        /* --- Light Mode Sidebar --- */
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
        
        /* Mobile responsiveness */
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
        
        /* Scrollbar styling */
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
        
        /* --- Dashboard Header --- */
        .dashboard-header {
            background: linear-gradient(135deg, var(--primary), #5a6ff0);
            color: white;
            padding: 2.5rem 2.5rem;
            margin-bottom: 2rem;
            box-shadow: var(--shadow-md);
        }
        
        .dashboard-body {
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
            color: #fff;
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
        
        /* Welcome badge styling */
        .welcome-badge {
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
        
        .welcome-badge:hover {
            color: white;
            background: rgba(255, 255, 255, 0.25);
            transform: translateY(-1px);
            text-decoration: none;
        }
        
        /* Stats Cards */
        .stats-card {
            color: white;
            padding: 1.5rem;
            display: flex;
            align-items: center;
            justify-content: space-between;
            border-radius: var(--border-radius);
            box-shadow: var(--shadow-md);
            transition: all 0.3s ease;
            position: relative;
            overflow: hidden;
        }
        
        .stats-card::before {
            content: '';
            position: absolute;
            top: 0; left: 0; width: 100%; height: 100%;
            background: linear-gradient(135deg, rgba(255,255,255,0.1), rgba(255,255,255,0));
            z-index: 1;
        }
        
        .stats-card > * {
            position: relative;
            z-index: 2;
        }
        
        .stats-card:hover {
            transform: translateY(-5px);
            box-shadow: var(--shadow-lg);
        }
        
        .stats-card i {
            font-size: 2.5rem;
            opacity: 0.9;
        }
        
        .stats-card > div {
             text-align: right;
        }
        
        .stats-card .number {
            font-size: 2rem;
            font-weight: 700;
            margin-bottom: 0.1rem;
        }
        
        .stats-card .label {
            font-size: 0.9rem;
            font-weight: 500;
            opacity: 0.9;
        }
        
        .stats-total { background: linear-gradient(135deg, #0d6efd, #0a58ca); }
        .stats-pending { background: linear-gradient(135deg, #ffc107, #d39e00); }
        .stats-confirmed { background: linear-gradient(135deg, #198754, #146c43); }
        .stats-completed { background: linear-gradient(135deg, #0dcaf0, #0aa3c2); }

        /* Table Styles */
        .table-responsive {
            overflow-x: auto;
            -webkit-overflow-scrolling: touch;
        }
        
        .table {
            width: 100%;
            margin-bottom: 1rem;
            color: #212529;
            vertical-align: middle;
            border-collapse: collapse;
        }
        
        .table>:not(caption)>*>* {
            padding: 0.8rem 0.8rem;
            background-color: transparent;
            border-bottom-width: 1px;
            box-shadow: inset 0 0 0 9999px transparent;
            border-color: var(--gray-300);
        }
        
        .table>thead th {
            font-weight: 600;
            color: var(--gray-600);
            text-transform: uppercase;
            font-size: 0.8rem;
            letter-spacing: 0.05em;
            border-bottom-width: 2px;
            border-color: var(--gray-300);
        }
        
        .table-hover>tbody>tr:hover>* {
            background-color: #f9fafb;
            color: #111827;
        }

        /* Badge styling */
        .badge {
            display: inline-block;
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
        .badge-secondary { color: var(--gray-700); background-color: var(--gray-200); } /* Added for null status */
        
        .bg-light { background-color: #e9ecef !important; }
        .text-dark { color: #343a40 !important; }
        .text-white { color: #fff !important; }
        .text-warning { color: #ffc107 !important; }

        /* Quick Actions */
        .quick-link {
            display: flex;
            align-items: center;
            padding: 1rem;
            border-radius: 10px;
            margin-bottom: 0.75rem;
            background: white;
            border: 1px solid var(--gray-200);
            transition: var(--transition);
            text-decoration: none;
            color: var(--gray-700);
        }
        
        .quick-link:hover {
            background: var(--primary-light);
            border-color: var(--primary);
            color: var(--primary);
            transform: translateX(5px);
            text-decoration: none;
        }
        
        .quick-link i {
            margin-right: 0.75rem;
            width: 20px;
            text-align: center;
            color: var(--primary);
        }

        /* Icon Box */
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
        .icon-danger { background-color: var(--danger-light); color: var(--danger); }
        
        .chart-container { 
            position: relative; 
            height: 250px; 
            width: 100%; 
        }
        
        canvas { 
            display: block; 
            height: 250px; 
            width: 100%; 
        }

        /* Recent Appointments Section - Extended Height */
        .recent-appointments-section {
            min-height: 650px; /* Increased height to fill the gap */
        }

        .recent-appointments-table {
            max-height: 500px;
            overflow-y: auto;
        }

        /* Bootstrap-like utility classes */
        .row { display: flex; flex-wrap: wrap; margin-right: -15px; margin-left: -15px; }
        .col-xl-3, .col-lg-8, .col-lg-4, .col-md-6, .col-12, .col-md-3 { position: relative; width: 100%; padding-right: 15px; padding-left: 15px; }
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
        @media (min-width: 1200px) {
            .col-xl-3 { flex: 0 0 25%; max-width: 25%; }
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
        .py-5 { padding-top: 3rem !important; padding-bottom: 3rem !important; }
        .p-4 { padding: 1.5rem !important; }
        .pt-3 { padding-top: 1rem !important; }
        .d-flex { display: flex !important; }
        .d-md-flex { display: flex !important; }
        .d-grid { display: grid !important; }
        .d-block { display: block !important; }
        .d-inline { display: inline !important; }
        .justify-content-between { justify-content: space-between !important; }
        .align-items-center { align-items: center !important; }
        .border-bottom { border-bottom: 1px solid var(--gray-300) !important; }
        hr { margin-top: 1rem; margin-bottom: 1rem; border: 0; border-top: 1px solid var(--gray-300); }
        .h2 { font-size: 1.75rem; font-weight: 600; }
        .h4 { font-size: 1.5rem; }
        .h5 { font-size: 1.1rem; }
        .h6 { font-size: 1rem; }
        .fs-5 { font-size: 1.25rem !important; }
        .fa-3x { font-size: 3em; }
        .fa-4x { font-size: 4em; }
        .fw-bold { font-weight: 700 !important; }
        .fw-medium { font-weight: 500 !important; }
        .me-2 { margin-right: 0.5rem !important; }
        .me-1 { margin-right: 0.25rem !important; }
        .me-3 { margin-right: 1rem !important; }
        .text-primary { color: var(--primary) !important; }
        .text-success { color: #198754 !important; }
        .card { position: relative; display: flex; flex-direction: column; min-width: 0; word-wrap: break-word; background-color: #fff; background-clip: border-box; border: 1px solid var(--gray-300); border-radius: 0.5rem; }
        .card-body { flex: 1 1 auto; padding: 1.5rem; }
        .text-center { text-align: center !important; }
        .text-muted { color: #6c757d !important; }
        .gap-2 { gap: 0.5rem !important; }

        /* Button styles */
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
        
        .btn-lg {
             padding: 0.8rem 1.8rem;
             font-size: 1rem;
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
                    <i class="fas fa-user-md"></i>
                </div>
                <div class="user-info">
                    <% if (currentDoctor != null) { %>
                    <h6>Dr. <%= currentDoctor.getFullName() %></h6>
                    <span class="badge">Doctor</span>
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
        <div class="dashboard-header">
            <div class="d-flex justify-content-between align-items-center">
                <div>
                    <h1 class="h2 mb-2">
                        <i class="fas fa-tachometer-alt me-2"></i>
                        Doctor Dashboard
                    </h1>
                    <p class="mb-0 opacity-75">Welcome to your practice management dashboard</p>
                </div>
                <div>
                    <span class="welcome-badge">
                        <i class="fas fa-user-md me-2"></i>Dr. <%= currentDoctor.getFullName() %>
                    </span>
                </div>
            </div>
        </div>

        <div class="dashboard-body">
            <div class="row mb-4">
                <div class="col-xl-3 col-md-6 mb-4">
                    <div class="stats-card stats-total">
                        <i class="fas fa-calendar-check"></i>
                        <div>
                            <div class="number"><%= stats[0] %></div>
                            <div class="label">Total Appointments</div>
                        </div>
                    </div>
                </div>
                <div class="col-xl-3 col-md-6 mb-4">
                    <div class="stats-card stats-pending">
                        <i class="fas fa-clock"></i>
                         <div>
                            <div class="number"><%= stats[1] %></div>
                            <div class="label">Pending</div>
                        </div>
                    </div>
                </div>
                <div class="col-xl-3 col-md-6 mb-4">
                    <div class="stats-card stats-confirmed">
                        <i class="fas fa-check-circle"></i>
                         <div>
                            <div class="number"><%= stats[2] %></div>
                            <div class="label">Confirmed</div>
                        </div>
                    </div>
                </div>
                <div class="col-xl-3 col-md-6 mb-4">
                    <div class="stats-card stats-completed">
                        <i class="fas fa-calendar-check"></i>
                        <div>
                            <div class="number"><%= stats[3] %></div>
                            <div class="label">Completed</div>
                        </div>
                    </div>
                </div>
            </div>

            <div class="row">
                <div class="col-lg-8 mb-4">
                    <div class="card card-modern recent-appointments-section"> <div class="card-header-modern d-flex justify-content-between align-items-center">
                            <div>
                                <i class="fas fa-list-alt"></i>
                                <span>Recent Appointments</span>
                            </div>
                            <a href="${pageContext.request.contextPath}/doctor/appointment?action=view" class="btn btn-sm btn-primary">
                                <i class="fas fa-eye me-1"></i>View All
                            </a>
                        </div>
                        <div class="card-body p-4">
                            <%
                                if (appointments.isEmpty()) {
                            %>
                                <div class="text-center py-4">
                                    <i class="fas fa-calendar-times fa-3x text-muted mb-3"></i>
                                    <h5 class="text-muted">No Appointments Yet</h5>
                                    <p class="text-muted">You don't have any appointments scheduled.</p>
                                </div>
                            <%
                                } else {
                            %>
                                <div class="table-responsive recent-appointments-table"> <table class="table table-hover">
                                        <thead>
                                            <tr>
                                                <th>Patient</th>
                                                <th>Date & Time</th>
                                                <th>Type</th>
                                                <th>Status</th>
                                                <th>Action</th>
                                            </tr>
                                        </thead>
                                        <tbody>
                                            
                                            <%-- ▼▼▼ THIS IS THE CORRECTED CODE BLOCK ▼▼▼ --%>
                                            <%
                                                for (Appointment app : recentAppointments) {
                                                    
                                                    String status = app.getStatus();

                                                    // If status is null, default it to "Pending"
                                                    if (status == null) {
                                                        status = "Pending";
                                                    }
                                                    
                                                    String statusBadgeClass;
                                                    switch (status) {
                                                        case "Pending": 
                                                            statusBadgeClass = "badge-pending"; 
                                                            break;
                                                        case "Confirmed": 
                                                            statusBadgeClass = "badge-confirmed"; 
                                                            break;
                                                        case "Completed": 
                                                            statusBadgeClass = "badge-completed"; 
                                                            break;
                                                        case "Cancelled": 
                                                            statusBadgeClass = "badge-cancelled"; 
                                                            break;
                                                        default:
                                                            statusBadgeClass = "badge-secondary";
                                                            break;
                                                    }
                                            %>
                                                <tr>
                                                    <td>
                                                        <strong><%= app.getPatientName() %></strong><br>
                                                        <small class="text-muted">ID: PAT<%= app.getPatientId() %></small>
                                                    </td>
                                                    <td>
                                                        <strong><%= app.getAppointmentDate() %></strong><br>
                                                        <small class="text-muted"><%= app.getAppointmentTime() %></small>
                                                    </td>
                                                    <td>
                                                        <span class="badge bg-light text-dark"><%= app.getAppointmentType() %></span>
                                                    </td>
                                                    <td>
                                                        <%-- 'status' can no longer be null here, so we print it directly --%>
                                                        <span class="badge <%= statusBadgeClass %>">
                                                            <%= status %>
                                                        </span>
                                                        <%
                                                            if (app.isFollowUpRequired()) {
                                                        %>
                                                            <br>
                                                            <small class="text-warning d-block mt-1">
                                                                <i class="fas fa-redo me-1"></i>Follow-up
                                                            </small>
                                                        <%
                                                            }
                                                        %>
                                                    </td>
                                                    <td>
                                                        <a href="${pageContext.request.contextPath}/doctor/appointment?action=details&id=<%= app.getId() %>"
                                                           class="btn btn-sm btn-outline-primary">
                                                            <i class="fas fa-eye"></i>
                                                        </a>
                                                    </td>
                                                </tr>
                                            <%
                                                } // End of for loop
                                            %>
                                            <%-- ▲▲▲ END OF THE CORRECTED CODE BLOCK ▲▲▲ --%>

                                        </tbody>
                                    </table>
                                </div>
                            <%
                                }
                            %>
                        </div>
                    </div>
                </div>

                <div class="col-lg-4">
                    <div class="card card-modern mb-4">
                        <div class="card-header-modern">
                            <i class="fas fa-bolt"></i>
                            <span>Quick Actions</span>
                        </div>
                        <div class="card-body p-4">
                            <div class="d-grid gap-2">
                                <a href="${pageContext.request.contextPath}/doctor/appointment?action=view"
                                   class="btn btn-primary-modern btn-modern">
                                    <i class="fas fa-list me-2"></i>View All Appointments
                                </a>
                                <a href="${pageContext.request.contextPath}/doctor/profile"
                                   class="btn btn-outline-primary">
                                    <i class="fas fa-user me-2"></i>Update Profile
                                </a>
                                <a href="${pageContext.request.contextPath}/doctor/change_password.jsp"
                                   class="btn btn-outline-primary">
                                    <i class="fas fa-key me-2"></i>Change Password
                                </a>
                            </div>
                        </div>
                    </div>

                    <div class="card card-modern">
                        <div class="card-header-modern">
                            <i class="fas fa-chart-pie"></i>
                            <span>Appointment Status</span>
                        </div>
                        <div class="card-body p-4">
                            <div class="chart-container">
                                 <canvas id="statusChart"></canvas>
                            </div>
                        </div>
                    </div>
                </div>
            </div>

            <div class="row mt-4">
                <div class="col-12">
                    <div class="card card-modern">
                        <div class="card-header-modern">
                            <i class="fas fa-user-md"></i>
                            <span>Profile Summary</span>
                        </div>
                        <div class="card-body p-4">
                            <div class="row">
                                <div class="col-md-3 text-center mb-3 mb-md-0">
                                    <div class="icon-box icon-primary mx-auto mb-2">
                                        <i class="fas fa-stethoscope"></i>
                                    </div>
                                    <h6>Specialization</h6>
                                    <p class="text-muted mb-0"><%= currentDoctor.getSpecialization() %></p>
                                </div>
                                <div class="col-md-3 text-center mb-3 mb-md-0">
                                    <div class="icon-box icon-success mx-auto mb-2">
                                        <i class="fas fa-building"></i>
                                    </div>
                                    <h6>Department</h6>
                                    <p class="text-muted mb-0"><%= currentDoctor.getDepartment() %></p>
                                </div>
                                <div class="col-md-3 text-center mb-3 mb-md-0">
                                    <div class="icon-box icon-warning mx-auto mb-2">
                                        <i class="fas fa-briefcase"></i>
                                    </div>
                                    <h6>Experience</h6>
                                    <p class="text-muted mb-0"><%= currentDoctor.getExperience() %> years</p>
                                </div>
                                <div class="col-md-3 text-center">
                                    <div class="icon-box icon-danger mx-auto mb-2">
                                       <span>&#8377;</span>
                                    </div>
                                    <h6>Fee</h6>
                                    <p class="text-muted mb-0"><span>&#8377;</span><%= currentDoctor.getVisitingCharge() %></p>
                                </div>
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
            const canvas = document.getElementById('statusChart');
            if (canvas) {
                 const ctx = canvas.getContext('2d');
                 new Chart(ctx, {
                    type: 'doughnut',
                    data: {
                        labels: ['Pending', 'Confirmed', 'Completed'],
                        datasets: [{
                            data: [<%= stats[1] %>, <%= stats[2] %>, <%= stats[3] %>],
                            backgroundColor: [
                                'rgba(255, 193, 7, 0.8)',
                                'rgba(25, 135, 84, 0.8)',
                                'rgba(13, 202, 240, 0.8)'
                            ],
                            borderColor: [
                                'rgba(255, 193, 7, 1)',
                                'rgba(25, 135, 84, 1)',
                                'rgba(13, 202, 240, 1)'
                            ],
                            borderWidth: 1
                        }]
                    },
                    options: {
                        responsive: true,
                        maintainAspectRatio: false,
                        plugins: {
                            legend: {
                                position: 'bottom'
                            }
                        },
                         cutout: '60%'
                    }
                 });
            } else {
                console.error("Canvas element with ID 'statusChart' not found.");
            }
        });
    </script>
</body>
</html>