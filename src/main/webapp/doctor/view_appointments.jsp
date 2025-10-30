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
    // Renamed 'doctor' to 'currentDoctor' for consistency
    Doctor currentDoctor = (Doctor) session.getAttribute("doctorObj");
    if (currentDoctor == null) {
        response.sendRedirect(request.getContextPath() + "/doctor/login.jsp"); // Added context path
        return;
    }

    AppointmentDao appointmentDao = new AppointmentDao();
    PatientDao patientDao = new PatientDao();
    List<Appointment> appointments = appointmentDao.getAppointmentsByDoctorId(currentDoctor.getId());

    // Pre-load all patients data to avoid multiple database calls
    Map<Integer, Patient> patientMap = new HashMap<>();
    for (Appointment appointment : appointments) {
        if (!patientMap.containsKey(appointment.getPatientId())) {
            Patient patient = patientDao.getPatientById(appointment.getPatientId());
            patientMap.put(appointment.getPatientId(), patient);
        }
    }

    // Calculate counts for stats section
    // This logic is safe for nulls because it uses .equals() on a string literal
    long pendingCount = appointments.stream().filter(a -> "Pending".equals(a.getStatus()) || a.getStatus() == null).count();
    long confirmedCount = appointments.stream().filter(a -> "Confirmed".equals(a.getStatus())).count();
    long completedCount = appointments.stream().filter(a -> "Completed".equals(a.getStatus())).count();
    long cancelledCount = appointments.stream().filter(a -> "Cancelled".equals(a.getStatus())).count();

    // Variable needed for the sidebar's logout button
    String currentUserRole = "doctor";
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Patient Care System - Doctor Appointments</title>

    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" rel="stylesheet">
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700&display=swap" rel="stylesheet">

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>

    <style>
        /* --- Base Layout & Color Definitions --- */
        :root {
            --primary: #4361ee;
            --primary-light: #eef2ff;
            --primary-dark: #3a56d4;
            --secondary: #6c757d;
            --success: #198754;
            --info: #0dcaf0;
            --warning: #ffc107;
            --danger: #dc3545;
            --danger-light: #fbebee;
            --dark: #1a1d29;
            --darker: #12141c;
            --light: #f8f9fa;
            --sidebar-width: 280px;
            --transition: all 0.3s ease;
            --border-color: #e2e8f0;
            --border-radius: 8px;
        }

        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }

        body {
            font-family: 'Inter', sans-serif;
            background-color: var(--light);
            color: var(--dark);
            line-height: 1.6;
            display: flex;
            height: 100vh;
            overflow: hidden;
        }

        /* --- Light Mode Sidebar --- */
        .sidebar {
            width: var(--sidebar-width);
            flex-shrink: 0;
            background-color: #ffffff;
            color: var(--dark);
            height: 100vh;
            left: 0;
            top: 0;
            overflow-y: auto;
            transition: var(--transition);
            border-right: 1px solid var(--border-color);
            display: flex;
            flex-direction: column;
        }

        .sidebar-sticky {
            display: flex;
            flex-direction: column;
            min-height: 100%;
            padding: 1.5rem 0;
        }

        /* --- User Section --- */
        .user-section {
            text-align: center;
            padding: 1.5rem 1.5rem 2rem;
            border-bottom: 1px solid var(--border-color);
            margin-bottom: 1rem;
        }

        .user-avatar {
            width: 70px;
            height: 70px;
            border-radius: 50%;
            background: linear-gradient(135deg, var(--primary), #5a6ff0);
            display: flex;
            align-items: center;
            justify-content: center;
            margin: 0 auto 1rem;
            border: 3px solid var(--primary-light);
        }

        .user-avatar i {
            font-size: 2rem;
            color: white;
        }

        .user-info h6 {
            font-size: 1rem;
            font-weight: 600;
            margin-bottom: 0.25rem;
            color: var(--dark);
        }
        
        .user-info small {
            font-size: 0.8rem;
            color: var(--secondary);
        }

        /* --- Navigation --- */
        .nav {
            display: flex;
            flex-direction: column;
            gap: 0.3rem;
            padding: 0 1rem;
            list-style: none;
        }

        .nav-main {
            flex-grow: 1;
        }

        .nav-bottom {
            margin-top: auto;
            padding-top: 1rem;
            border-top: 1px solid var(--border-color);
            margin: 1.5rem 0 0 0;
        }

        .nav-item {
            margin-bottom: 0.15rem;
        }

        .nav-link {
            display: flex;
            align-items: center;
            gap: 0.8rem;
            padding: 0.75rem 1rem;
            color: #4a5568;
            text-decoration: none;
            border-radius: var(--border-radius);
            transition: var(--transition);
            font-weight: 500;
            font-size: 0.9rem;
            position: relative;
            overflow: hidden;
        }

        .nav-link::before {
            content: '';
            position: absolute;
            left: 0;
            top: 50%;
            height: 80%;
            width: 3px;
            background: var(--primary);
            transform: translateY(-50%) scaleY(0);
            transition: var(--transition);
            border-radius: 0 4px 4px 0;
        }

        .nav-link:hover {
            color: var(--primary);
            background: var(--primary-light);
        }

        .nav-link:hover::before {
             transform: translateY(-50%) scaleY(1);
        }

        .nav-link.active {
            color: var(--primary);
            background: var(--primary-light);
            font-weight: 600;
        }

        .nav-link.active::before {
            transform: translateY(-50%) scaleY(1);
        }

        .nav-link i {
            width: 18px;
            text-align: center;
            font-size: 1rem;
            transition: var(--transition);
            color: #9ca3af;
        }

        .nav-link:hover i,
        .nav-link.active i {
            color: var(--primary);
        }

        /* --- Logout Link --- */
        .nav-link-logout {
            color: var(--danger);
        }

        .nav-link-logout i {
            color: var(--danger);
        }

        .nav-link-logout:hover {
            background: var(--danger-light);
            color: var(--danger);
        }

        .nav-link-logout:hover i {
            color: var(--danger);
        }

        /* --- Main Content Area --- */
        .main-content {
            flex-grow: 1;
            min-height: 100vh;
            overflow-y: auto;
        }

        /* --- Enhanced Input Group Styles --- */
        .input-group {
            position: relative;
            display: flex;
            flex-wrap: wrap;
            align-items: stretch;
            width: 100%;
            border-radius: 10px;
            overflow: hidden;
            border: 1px solid var(--border-color);
            transition: var(--transition);
            background: white;
        }

        .input-group:focus-within {
            border-color: var(--primary);
            box-shadow: 0 0 0 3px rgba(67, 97, 238, 0.15);
        }

        .input-group-text {
            background: var(--light);
            border: none;
            color: var(--secondary);
            padding: 0.75rem 1rem;
            display: flex;
            align-items: center;
            justify-content: center;
            min-width: 50px;
            flex-shrink: 0;
            border-right: 1px solid var(--border-color);
        }

        .form-control, .form-select {
            border-radius: 0;
            padding: 0.75rem 1rem;
            border: none;
            transition: var(--transition);
            font-size: 0.95rem;
            width: 100%;
            flex: 1;
            background: transparent;
        }

        .form-control:focus, .form-select:focus {
            box-shadow: none;
            border: none;
            outline: none;
            background: transparent;
        }

        .input-group:focus-within .input-group-text {
            background: var(--primary-light);
            color: var(--primary);
            border-right-color: var(--primary);
        }

        /* Form label improvements */
        .form-label {
            font-weight: 500;
            margin-bottom: 0.5rem;
            color: #4a5568;
            font-size: 0.9rem;
            display: block;
        }

        /* Form field container */
        .form-field {
            margin-bottom: 1.5rem;
        }

        /* Helper text */
        .form-helper {
            font-size: 0.875rem;
            color: var(--secondary);
            margin-top: 0.5rem;
            display: block;
        }

        /* Responsive adjustments */
        @media (max-width: 576px) {
            .input-group-text {
                min-width: 45px;
                padding: 0.75rem 0.75rem;
            }
            
            .form-control, .form-select {
                padding: 0.75rem 0.75rem;
            }
        }

        /* Responsive styles */
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
                box-shadow: 0 4px 12px rgba(67, 97, 238, 0.3);
            }
        }

        /* --- Light Mode Scrollbar --- */
        .sidebar::-webkit-scrollbar,
        .main-content::-webkit-scrollbar {
            width: 6px;
        }

        .sidebar::-webkit-scrollbar-track,
        .main-content::-webkit-scrollbar-track {
            background: rgba(0, 0, 0, 0.05);
        }

        .sidebar::-webkit-scrollbar-thumb,
        .main-content::-webkit-scrollbar-thumb {
            background: rgba(0, 0, 0, 0.2);
            border-radius: 3px;
        }

        .sidebar::-webkit-scrollbar-thumb:hover,
        .main-content::-webkit-scrollbar-thumb:hover {
            background: rgba(0, 0, 0, 0.3);
        }

        /* =================================================== */
        /* === STYLES FOR DASHBOARD/TABLES (like this page) === */
        /* =================================================== */

        .main-content-dashboard {
            padding: 2.5rem;
        }
        @media (max-width: 768px) {
            .main-content-dashboard {
                padding: 1.5rem;
                padding-top: 6rem;
            }
        }

        .shadow-custom {
             box-shadow: 0 0.5rem 1rem rgba(0, 0, 0, 0.05) !important;
             border: 1px solid var(--border-color);
             border-radius: var(--border-radius);
             background-color: #ffffff;
        }
        .card-header {
            background-color: #ffffff;
            border-bottom: 1px solid var(--border-color);
            padding: 1rem 1.5rem;
        }
        .card-header h5 {
            font-weight: 600;
            font-size: 1.1rem;
            color: var(--dark);
        }
        .card-body {
            padding: 1.5rem;
        }
        /* Style for the small stats cards */
        .card.bg-primary, .card.bg-success, .card.bg-info, .card.bg-secondary {
            border: none;
            color: white;
        }
        .card.bg-primary { background-color: var(--primary) !important; }
        .card.bg-success { background-color: var(--success) !important; }
        .card.bg-info    { background-color: var(--info) !important; }
        .card.bg-secondary{ background-color: var(--secondary) !important; }

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
        .btn-danger { background-color: var(--danger); border-color: var(--danger); color: white; }
        .btn-danger:hover { background-color: #c82333; border-color: #bd2130; }
        .btn-outline-danger { border-color: var(--danger); color: var(--danger); background: transparent; }
        .btn-outline-danger:hover { background-color: var(--danger); color: white; }
        .btn-warning { background-color: #ffc107; border-color: #ffc107; color: #212529; }
        .btn-warning:hover { background-color: #e0a800; border-color: #d39e00; }
        .btn-outline-warning { border-color: #ffc107; color: #ffc107; background: transparent; }
        .btn-outline-warning:hover { background-color: #ffc107; color: #212529; }
        .btn-group, .btn-group-vertical { position: relative; display: inline-flex; vertical-align: middle; }
        .btn-group-sm>.btn, .btn-sm { padding: .25rem .5rem; font-size: .875rem; border-radius: .2rem; }
        .btn-group>.btn:not(:first-child), .btn-group>.btn-group:not(:first-child) { margin-left: -1px; }
        .btn-group>.btn:not(:last-child):not(.dropdown-toggle), .btn-group>.btn-group:not(:last-child)>.btn { border-top-right-radius: 0; border-bottom-right-radius: 0; }
        .btn-group>.btn:not(:first-child), .btn-group>.btn-group:not(:first-child)>.btn { border-top-left-radius: 0; border-bottom-left-radius: 0; }
        .dropdown-toggle { white-space: nowrap; }
        .dropdown-menu {
            position: absolute;
            z-index: 1000;
            display: none;
            min-width: 10rem;
            padding: .5rem 0;
            margin: 0;
            font-size: 1rem;
            color: #212529;
            text-align: left;
            list-style: none;
            background-color: #fff;
            background-clip: padding-box;
            border: 1px solid rgba(0,0,0,.15);
            border-radius: .25rem;
        }
        .dropdown-menu.show { display: block; }
        .dropdown-item { display: block; width: 100%; padding: .25rem 1rem; clear: both; font-weight: 400; color: #212529; text-align: inherit; text-decoration: none; white-space: nowrap; background-color: transparent; border: 0; }
        .dropdown-item:hover, .dropdown-item:focus { color: #1e2125; background-color: #e9ecef; }
        .dropdown-item.active, .dropdown-item:active { color: #fff; text-decoration: none; background-color: var(--primary); }
        .dropdown-item.disabled, .dropdown-item:disabled { color: #adb5bd; pointer-events: none; background-color: transparent; }
        .dropdown-divider { height: 0; margin: .5rem 0; overflow: hidden; border-top: 1px solid rgba(0,0,0,.15); }

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
        .badge-secondary { color: var(--gray-700); background-color: var(--gray-200); } /* Added */
        .bg-primary { background-color: var(--primary) !important; }
        .bg-light { background-color: #e9ecef !important; }
        .text-dark { color: #343a40 !important; }
        .text-white { color: #fff !important; }
        .text-warning { color: #ffc107 !important; }
        .text-success { color: #198754 !important; }
        .text-info { color: #0dcaf0 !important; }
        .text-danger { color: #dc3545 !important; }

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
            border-color: var(--border-color);
        }
         .table>tbody { vertical-align: inherit; }
         .table>thead { vertical-align: bottom; }
         .table>thead th {
            font-weight: 600;
            color: #6b7280;
            text-transform: uppercase;
            font-size: 0.8rem;
            letter-spacing: 0.05em;
            border-bottom-width: 2px;
            border-color: var(--border-color);
         }
         .table>:not(:first-child) { border-top: 2px solid var(--border-color); }

        .table-hover>tbody>tr:hover>* {
            background-color: #f9fafb;
            color: #111827;
        }

        /* Bootstrap utilities */
        .container-fluid { width: 100%; padding-right: 15px; padding-left: 15px; margin-right: auto; margin-left: auto; }
        .row { display: flex; flex-wrap: wrap; margin-right: -15px; margin-left: -15px; }
        .col-lg-8, .col-md-6, .col-12, .col-md-3, .col-md-4 { position: relative; width: 100%; padding-right: 15px; padding-left: 15px; }
        .justify-content-center { justify-content: center !important; }
        .justify-content-md-end { justify-content: flex-end !important; }
        @media (min-width: 768px) {
            .col-md-6 { flex: 0 0 50%; max-width: 50%; }
            .col-md-3 { flex: 0 0 25%; max-width: 25%; }
             .col-md-4 { flex: 0 0 33.333333%; max-width: 33.333333%; }
            .me-md-2 { margin-right: 0.5rem !important; }
        }
        @media (min-width: 992px) {
            .col-lg-8 { flex: 0 0 66.666667%; max-width: 66.666667%; }
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
        .border-bottom { border-bottom: 1px solid var(--border-color) !important; }
        hr { margin-top: 1rem; margin-bottom: 1rem; border: 0; border-top: 1px solid var(--border-color); }
        .h2 { font-size: 1.75rem; font-weight: 600; }
        .h4 { font-size: 1.5rem; }
        .h5 { font-size: 1.1rem; }
        .h6 { font-size: 1rem; }
        .fs-5 { font-size: 1.25rem !important; }
        .fa-4x { font-size: 4em; }
        .fw-bold { font-weight: 700 !important; }
        .fw-medium { font-weight: 500 !important; }
        .me-2 { margin-right: 0.5rem !important; }
        .me-1 { margin-right: 0.25rem !important; }
        .me-3 { margin-right: 1rem !important; }
        .text-primary { color: var(--primary) !important; }
        .card { position: relative; display: flex; flex-direction: column; min-width: 0; word-wrap: break-word; background-color: #fff; background-clip: border-box; border: 1px solid var(--border-color); border-radius: 0.5rem; }
        .card-body { flex: 1 1 auto; padding: 1.5rem; }
        .text-center { text-align: center !important; }
        .text-muted { color: #6c757d !important; }
        .gap-2 { gap: 0.5rem !important; }
        .g-3 { gap: 1rem !important; }

        /* Validation Styles */
        .alert { position: relative; padding: 1rem 1rem; margin-bottom: 1rem; border: 1px solid transparent; border-radius: var(--border-radius); }
        .alert-success { color: #0f5132; background-color: #d1e7dd; border-color: #badbcc; }
        .alert-danger { color: #842029; background-color: #f8d7da; border-color: #f5c2c7; }
        .alert-dismissible { padding-right: 3rem; }
        .btn-close { box-sizing: content-box; width: 1em; height: 1em; padding: 0.25em 0.25em; color: #000; background: transparent; border: 0; border-radius: 0.25rem; opacity: 0.5; }
        .alert-dismissible .btn-close { position: absolute; top: 0; right: 0; z-index: 2; padding: 1.25rem 1rem; }
        .fade { transition: opacity 0.15s linear; }
        .show { opacity: 1; }

        /* --- Styles for Appointment Details Page --- */
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

    <main class="main-content main-content-dashboard">
        <div class="d-flex justify-content-between flex-wrap flex-md-nowrap align-items-center py-3 mb-4 border-bottom">
            <h1 class="h2">
                <i class="fas fa-list-alt me-2 text-primary"></i>
                My Appointments
            </h1>
            <div class="btn-toolbar mb-2 mb-md-0">
                <span class="badge bg-primary fs-6">
                    <i class="fas fa-calendar-check me-1"></i>
                    <%= appointments.size() %> Total Appointments
                </span>
            </div>
        </div>

        <%
            String successMsg = (String) request.getAttribute("successMsg");
            String errorMsg = (String) request.getAttribute("errorMsg");

            if (successMsg != null) {
        %>
            <div class="alert alert-success alert-dismissible fade show" role="alert">
                <i class="fas fa-check-circle me-2"></i><%= successMsg %>
                <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
            </div>
        <%
            }
            if (errorMsg != null) {
        %>
            <div class="alert alert-danger alert-dismissible fade show" role="alert">
                <i class="fas fa-exclamation-triangle me-2"></i><%= errorMsg %>
                <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
            </div>
        <%
            }
        %>

        <div class="card shadow-custom mb-4">
            <div class="card-body">
                <div class="row g-3 align-items-end">
                    <div class="col-md-4 form-field">
                        <label class="form-label" for="statusFilter">Filter by Status</label>
                        <div class="input-group">
                            <span class="input-group-text">
                                <i class="fas fa-filter"></i>
                            </span>
                            <select class="form-select" id="statusFilter">
                                <option value="all" selected>All Statuses</option>
                                <option value="Pending">Pending</option>
                                <option value="Confirmed">Confirmed</option>
                                <option value="Completed">Completed</option>
                                <option value="Cancelled">Cancelled</option>
                            </select>
                        </div>
                    </div>
                    <div class="col-md-4 form-field">
                        <label class="form-label" for="searchPatient">Search Patient</label>
                        <div class="input-group">
                            <span class="input-group-text">
                                <i class="fas fa-search"></i>
                            </span>
                            <input type="text" class="form-control" id="searchPatient" placeholder="Search by patient name...">
                        </div>
                    </div>
                    <div class="col-md-4 form-field">
                        <button type="button" id="clearFilters" class="btn btn-outline-secondary w-100">
                            <i class="fas fa-times me-1"></i>Clear Filters
                        </button>
                    </div>
                </div>
            </div>
        </div>

        <div class="card shadow-custom">
            <div class="card-header d-flex justify-content-between align-items-center">
                <h5 class="mb-0">
                    <i class="fas fa-calendar me-2"></i>Appointment List
                </h5>
                 <span class="badge bg-light text-dark fs-6">
                     <i class="fas fa-user-md me-1 text-primary"></i>Dr. <%= currentDoctor.getFullName() %>
                 </span>
            </div>
            <div class="card-body">
                <%
                    if (appointments.isEmpty()) {
                %>
                    <div class="text-center py-5">
                        <i class="fas fa-calendar-times fa-4x text-muted mb-3"></i>
                        <h4 class="text-muted">No Appointments Found</h4>
                        <p class="text-muted">You don't have any appointments scheduled yet.</p>
                    </div>
                <%
                    } else {
                %>
                    <div class="table-responsive">
                        <table class="table table-hover" id="appointmentsTable">
                            <thead>
                                <tr>
                                    <th>Patient</th>
                                    <th>Contact</th>
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
                                        
                                        // --- ▼▼▼ CORRECTED CODE BLOCK ▼▼▼ ---
                                        String status = appointment.getStatus();

                                        // If status is null, default it to "Pending"
                                        if (status == null) {
                                            status = "Pending";
                                        }

                                        // Set defaults based on the (now non-null) status
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
                                            default: // Should only be "Pending" if it was null
                                                statusBadgeClass = "badge-pending";
                                                statusIcon = "fas fa-clock";
                                        }
                                        // --- ▲▲▲ END OF CORRECTED CODE BLOCK ▲▲▲ ---
                                        
                                        // Get patient details for contact information
                                        Patient patient = patientMap.get(appointment.getPatientId());
                                        String patientPhone = "N/A";
                                        String patientEmail = "N/A";
                                        
                                        if (patient != null) {
                                            patientPhone = patient.getPhone() != null ? patient.getPhone() : "N/A";
                                            patientEmail = patient.getEmail() != null ? patient.getEmail() : "N/A";
                                        }
                                %>
                                    <%-- Use the non-null status variable --%>
                                    <tr data-status="<%= status.toLowerCase() %>" data-patient="<%= appointment.getPatientName().toLowerCase() %>">
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
                                            <small class="text-muted">
                                                <i class="fas fa-phone me-1"></i> <%= patientPhone %><br>
                                                <i class="fas fa-envelope me-1"></i> <%= patientEmail %>
                                            </small>
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
                                            <small class="text-truncate d-block" style="max-width: 150px;">
                                                <%= appointment.getReason().length() > 50 ? appointment.getReason().substring(0, 50) + "..." : appointment.getReason() %>
                                            </small>
                                        </td>
                                        <td>
                                            <%-- We no longer need a null check here --%>
                                            <span class="badge <%= statusBadgeClass %>">
                                                <i class="<%= statusIcon %> me-1"></i>
                                                <%= status %>
                                            </span>
                                            <%
                                                if (appointment.isFollowUpRequired()) {
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
                                            <div class="btn-group btn-group-sm" role="group">
                                                <a href="${pageContext.request.contextPath}/doctor/appointment?action=details&id=<%= appointment.getId() %>"
                                                   class="btn btn-outline-primary" data-bs-toggle="tooltip" title="View Details">
                                                    <i class="fas fa-eye"></i>
                                                </a>
                                                <%
                                                    // Use the non-null 'status' variable for logic
                                                    if (!"Completed".equals(status) && !"Cancelled".equals(status)) {
                                                %>
                                                    <div class="dropdown">
                                                        <button class="btn btn-outline-warning dropdown-toggle" type="button"
                                                                id="dropdownMenuButton<%= appointment.getId() %>" data-bs-toggle="dropdown" aria-expanded="false" data-bs-toggle="tooltip" title="Update Status">
                                                            <i class="fas fa-edit"></i>
                                                        </button>
                                                        <ul class="dropdown-menu" aria-labelledby="dropdownMenuButton<%= appointment.getId() %>">
                                                            <%
                                                                if (!"Confirmed".equals(status)) {
                                                            %>
                                                                <li>
                                                                    <form action="${pageContext.request.contextPath}/doctor/appointment?action=updateStatus" method="post" class="d-inline">
                                                                        <input type="hidden" name="appointmentId" value="<%= appointment.getId() %>">
                                                                        <input type="hidden" name="status" value="Confirmed">
                                                                        <button type="submit" class="dropdown-item text-success">
                                                                            <i class="fas fa-check me-2"></i>Confirm
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
                                                                            <i class="fas fa-calendar-check me-2"></i>Complete
                                                                        </button>
                                                                    </form>
                                                                </li>
                                                            <%
                                                                }
                                                            %>
                                                            <li>
                                                                <form action="${pageContext.request.contextPath}/doctor/appointment?action=updateStatus" method="post" class="d-inline">
                                                                    <input type="hidden" name="appointmentId" value="<%= appointment.getId() %>">
                                                                    <input type="hidden" name="status" value="Cancelled">
                                                                    <button type="submit" class="dropdown-item text-danger" onclick="return confirm('Are you sure you want to cancel this appointment?')">
                                                                        <i class="fas fa-times me-2"></i>Cancel
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
                                                                        <%= appointment.isFollowUpRequired() ? "Remove Follow-up" : "Mark Follow-up" %>
                                                                    </button>
                                                                </form>
                                                            </li>
                                                        </ul>
                                                    </div>
                                                <%
                                                    }
                                                %>
                                            </div>
                                        </td>
                                    </tr>
                                <%
                                    }
                                %>
                            </tbody>
                        </table>
                    </div>

                    <div class="row mt-4 gy-3">
                        <div class="col-6 col-md-3">
                            <div class="card bg-primary text-white h-100">
                                <div class="card-body text-center py-3">
                                    <h4 class="mb-1"><%= pendingCount %></h4>
                                    <small>Pending</small>
                                </div>
                            </div>
                        </div>
                        <div class="col-6 col-md-3">
                            <div class="card bg-success text-white h-100">
                                <div class="card-body text-center py-3">
                                    <h4 class="mb-1"><%= confirmedCount %></h4>
                                    <small>Confirmed</small>
                                </div>
                            </div>
                        </div>
                        <div class="col-6 col-md-3">
                            <div class="card bg-info text-white h-100">
                                <div class="card-body text-center py-3">
                                    <h4 class="mb-1"><%= completedCount %></h4>
                                    <small>Completed</small>
                                </div>
                            </div>
                        </div>
                        <div class="col-6 col-md-3">
                            <div class="card bg-secondary text-white h-100">
                                <div class="card-body text-center py-3">
                                    <h4 class="mb-1"><%= cancelledCount %></h4>
                                    <small>Cancelled</small>
                                </div>
                            </div>
                        </div>
                    </div>
                <%
                    }
                %>
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
            // Initialize tooltips
            const tooltipTriggerList = [].slice.call(document.querySelectorAll('[data-bs-toggle="tooltip"]'));
            const tooltipList = tooltipTriggerList.map(function (tooltipTriggerEl) {
                 if (typeof bootstrap !== 'undefined' && bootstrap.Tooltip) {
                    return new bootstrap.Tooltip(tooltipTriggerEl);
                }
                return null;
            }).filter(tooltip => tooltip !== null);

            // Filter functionality
            const statusFilter = document.getElementById('statusFilter');
            const searchPatient = document.getElementById('searchPatient');
            const clearFilters = document.getElementById('clearFilters');
            const tableBody = document.querySelector('#appointmentsTable tbody');
            const tableRows = tableBody ? tableBody.querySelectorAll('tr') : [];

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
                    if (statusFilter) statusFilter.value = 'all';
                    if (searchPatient) searchPatient.value = '';
                    filterAppointments();
                 });
            }
        });
    </script>
</body>
</html>