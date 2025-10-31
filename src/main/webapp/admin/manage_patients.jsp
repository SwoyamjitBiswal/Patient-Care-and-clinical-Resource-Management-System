<%@ page import="com.entity.Admin" %>
<%@ page import="com.dao.PatientDao" %>
<%@ page import="com.entity.Patient" %>
<%@ page import="java.util.List" %>
<%@ page import="java.text.SimpleDateFormat" %>
<%
    // Renamed 'admin' to 'currentAdmin'
    Admin currentAdmin = (Admin) session.getAttribute("adminObj");
    if (currentAdmin == null) {
        response.sendRedirect(request.getContextPath() + "/admin/login.jsp"); // Added context path
        return;
    }

    PatientDao patientDao = new PatientDao();
    List<Patient> patients = patientDao.getAllPatients();

    // Variable needed for the sidebar's logout button
    String currentUserRole = "admin";
    
    // Date formatter
    SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Patient Care System - Manage Patients</title>

    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" rel="stylesheet">
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700&display=swap" rel="stylesheet">

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>

    <style>
        /* --- Base Layout & Color Definitions --- */
        :root {
            --primary: #4361ee;
            --primary-light: #eef2ff; /* Light background for hover/active */
            --primary-dark: #3a56d4;  /* Darker text for light backgrounds */
            --secondary: #6c757d;
            --success: #198754; /* Standard Bootstrap success */
            --info: #0dcaf0;    /* Standard Bootstrap info */
            --warning: #ffc107; /* Standard Bootstrap warning */
            --danger: #dc3545;
            --danger-light: #fbebee;
            --dark: #1a1d29;          /* Main text color */
            --darker: #12141c;
            --light: #f8f9fa;         /* Main content background */
            --sidebar-width: 280px;
            --transition: all 0.3s ease;
            --border-color: #e2e8f0;  /* Light border for separation */
            --border-radius: 8px; /* Slightly reduced border-radius */
        }

        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }

        body {
            font-family: 'Inter', sans-serif;
            background-color: var(--light); /* Light background for main area */
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
            background-color: #ffffff; /* Clean white background */
            color: var(--dark);
            height: 100vh;
            left: 0;
            top: 0;
            overflow-y: auto;
            transition: var(--transition);
            border-right: 1px solid var(--border-color); /* Clean separation */
            box-shadow: none; /* Removed dark shadow */
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
            border-bottom: 1px solid var(--border-color); /* Light border */
            margin-bottom: 1rem;
        }

        .user-avatar {
            width: 70px; /* Slightly smaller */
            height: 70px;
            border-radius: 50%;
            background: linear-gradient(135deg, var(--primary), #5a6ff0);
            display: flex;
            align-items: center;
            justify-content: center;
            margin: 0 auto 1rem;
            border: 3px solid var(--primary-light); /* Lighter border */
        }

        .user-avatar i {
            font-size: 2rem; /* Adjusted */
            color: white; /* Keep icon white on gradient */
        }

        .user-info h6 {
            font-size: 1rem; /* Adjusted */
            font-weight: 600;
            margin-bottom: 0.25rem;
            color: var(--dark); /* Dark text */
        }
        /* Role text */
        .user-info small {
            font-size: 0.8rem;
            color: var(--secondary); /* Grey text */
        }

        /* --- Navigation --- */
        .nav {
            display: flex;
            flex-direction: column;
            gap: 0.3rem; /* Reduced gap */
            padding: 0 1rem;
            list-style: none;
        }

        .nav-main {
            flex-grow: 1;
        }

        .nav-bottom {
            margin-top: auto;
            padding-top: 1rem;
            border-top: 1px solid var(--border-color); /* Light border */
            margin: 1.5rem 0 0 0;
        }

        .nav-item {
            margin-bottom: 0.15rem; /* Reduced margin */
        }

        .nav-link {
            display: flex;
            align-items: center;
            gap: 0.8rem; /* Reduced gap */
            padding: 0.75rem 1rem; /* Adjusted padding */
            color: #4a5568; /* Readable dark-gray text */
            text-decoration: none;
            border-radius: var(--border-radius);
            transition: var(--transition);
            font-weight: 500;
            font-size: 0.9rem; /* Slightly smaller font */
            position: relative;
            overflow: hidden;
        }

        .nav-link::before {
            content: '';
            position: absolute;
            left: 0;
            top: 50%;
            height: 80%;
            width: 3px; /* Thinner indicator */
            background: var(--primary);
            transform: translateY(-50%) scaleY(0);
            transition: var(--transition);
            border-radius: 0 4px 4px 0;
        }

        .nav-link:hover {
            color: var(--primary);            /* Primary color text */
            background: var(--primary-light); /* Light primary background */
        }

        .nav-link:hover::before {
             transform: translateY(-50%) scaleY(1);
        }

        .nav-link.active {
            color: var(--primary);            /* Primary color text */
            background: var(--primary-light); /* Light primary background */
            font-weight: 600;                 /* Bolder for active state */
        }

        .nav-link.active::before {
            transform: translateY(-50%) scaleY(1);
        }

        .nav-link i {
            width: 18px; /* Adjusted */
            text-align: center;
            font-size: 1rem; /* Adjusted */
            transition: var(--transition);
            color: #9ca3af; /* Lighter icon color by default */
        }

        .nav-link:hover i,
        .nav-link.active i {
            color: var(--primary); /* Primary color on hover/active */
        }

        /* --- Logout Link --- */
        .nav-link-logout {
            color: var(--danger); /* Red text */
        }

        .nav-link-logout i {
            color: var(--danger);
        }

        .nav-link-logout:hover {
            background: var(--danger-light); /* Light red background */
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
                padding-top: 6rem; /* Re-apply mobile padding top */
            }
        }

        .shadow-custom {
             box-shadow: 0 0.5rem 1rem rgba(0, 0, 0, 0.05) !important;
             border: 1px solid var(--border-color); /* Add light border to cards */
             border-radius: var(--border-radius);
             background-color: #ffffff;
        }
        .card-header {
            background-color: #ffffff;
            border-bottom: 1px solid var(--border-color);
            padding: 1rem 1.5rem; /* Adjusted padding */
        }
        .card-header h5 {
            font-weight: 600;
            font-size: 1.1rem; /* Adjusted size */
            color: var(--dark);
        }
        .card-body {
            padding: 1.5rem;
        }

        .btn {
            display: inline-flex; /* Use inline-flex for better alignment */
            align-items: center;
            justify-content: center; /* Center content */
            gap: 0.5rem;
            padding: 0.6rem 1.2rem; /* Adjusted padding */
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
            border-radius: 50px; /* Pill shape */
        }
        .bg-primary { background-color: var(--primary) !important; color: white; }
        .bg-light { background-color: #e9ecef !important; }
        .bg-danger { background-color: var(--danger) !important; color: white; }
        .bg-secondary { background-color: var(--secondary) !important; color: white; }
        .text-dark { color: #343a40 !important; }
        .text-white { color: #fff !important; }

        /* Table Styles */
        .table-responsive {
            overflow-x: auto;
            -webkit-overflow-scrolling: touch;
        }
        .table {
            width: 100%;
            margin-bottom: 1rem;
            color: #212529;
            vertical-align: middle; /* Align content vertically */
            border-collapse: collapse;
        }
        .table>:not(caption)>*>* {
            padding: 0.8rem 0.8rem; /* Consistent padding */
            background-color: transparent;
            border-bottom-width: 1px;
            box-shadow: inset 0 0 0 9999px transparent;
            border-color: var(--border-color); /* Light border color */
        }
         .table>tbody { vertical-align: inherit; }
         .table>thead { vertical-align: bottom; }
         .table>thead th {
            font-weight: 600;
            color: #6b7280; /* Header text color */
            text-transform: uppercase;
            font-size: 0.8rem;
            letter-spacing: 0.05em;
            border-bottom-width: 2px; /* Thicker header border */
            border-color: var(--border-color);
         }
         .table>:not(:first-child) { border-top: 2px solid var(--border-color); }

        .table-hover>tbody>tr:hover>* {
            background-color: #f9fafb; /* Subtle hover */
            color: #111827;
        }

        /* Form Styles for Modals */
         .form-label {
            font-weight: 500;
            margin-bottom: 0.5rem;
            color: #4a5568;
            font-size: 0.9rem;
        }
        .form-control, .form-select {
            display: block; /* Ensure block display */
            width: 100%;
            border-radius: var(--border-radius); /* Use root border-radius */
            padding: 0.75rem 1rem;
            border: 1px solid var(--border-color);
            transition: all 0.3s;
            font-size: 0.9rem; /* Consistent size */
            color: var(--dark);
            background-color: #fff;
        }
        .form-control:focus, .form-select:focus {
            box-shadow: 0 0 0 3px rgba(67, 97, 238, 0.1); /* Use primary color */
            border-color: var(--primary);
            outline: 0;
        }
        textarea.form-control {
             min-height: calc(1.5em + 1.5rem + 2px); /* Default textarea height */
        }
        
        /* Read-only styles for View Modal */
        .modal-body .form-label.text-muted {
            color: #6c757d !important;
            margin-bottom: 0.25rem;
        }
        .modal-body p.fs-6 {
            margin-bottom: 1rem; /* Spacing between view items */
        }

        /* Modal Styles */
        .modal { position: fixed; top: 0; left: 0; z-index: 1055; display: none; width: 100%; height: 100%; overflow-x: hidden; overflow-y: auto; outline: 0; background-color: rgba(0,0,0,0.5); }
        .modal-dialog { position: relative; width: auto; margin: .5rem; pointer-events: none; }
        .modal.fade .modal-dialog { transition: transform .3s ease-out; transform: translate(0,-50px); }
        .modal.show .modal-dialog { transform: none; }
        .modal-dialog-centered { display: flex; align-items: center; min-height: calc(100% - 1rem); }
        .modal-content { position: relative; display: flex; flex-direction: column; width: 100%; pointer-events: auto; background-color: #fff; background-clip: padding-box; border: 1px solid rgba(0,0,0,.2); border-radius: .3rem; outline: 0; }
        .modal-header { display: flex; flex-shrink: 0; align-items: center; justify-content: space-between; padding: 1rem 1rem; border-bottom: 1px solid #dee2e6; border-top-left-radius: calc(.3rem - 1px); border-top-right-radius: calc(.3rem - 1px); }
        .modal-header .btn-close { padding: .5rem .5rem; margin: -.5rem -.5rem -.5rem auto; }
        .modal-title { margin-bottom: 0; line-height: 1.5; font-size: 1.25rem; }
        .modal-body { position: relative; flex: 1 1 auto; padding: 1rem; }
        .modal-footer { display: flex; flex-wrap: wrap; flex-shrink: 0; align-items: center; justify-content: flex-end; padding: .75rem; border-top: 1px solid #dee2e6; border-bottom-right-radius: calc(.3rem - 1px); border-bottom-left-radius: calc(.3rem - 1px); }
        .modal-footer>:not(:first-child) { margin-left: .25rem; }
        .modal-footer>:not(:last-child) { margin-right: .25rem; }
        .modal-lg { max-width: 800px; margin: 1.75rem auto; }

        /* Bootstrap utilities */
        .container-fluid { width: 100%; padding-right: 15px; padding-left: 15px; margin-right: auto; margin-left: auto; }
        .row { display: flex; flex-wrap: wrap; margin-right: -15px; margin-left: -15px; }
        .col-lg-8, .col-md-6, .col-12, .col-md-3, .col-md-2, .col-md-4 { position: relative; width: 100%; padding-right: 15px; padding-left: 15px; }
        .justify-content-center { justify-content: center !important; }
        .justify-content-md-end { justify-content: flex-end !important; }
        @media (min-width: 768px) {
            .col-md-6 { flex: 0 0 50%; max-width: 50%; }
            .col-md-3 { flex: 0 0 25%; max-width: 25%; }
            .col-md-2 { flex: 0 0 16.666667%; max-width: 16.666667%; }
            .col-md-4 { flex: 0 0 33.333333%; max-width: 33.333333%; }
            .me-md-2 { margin-right: 0.5rem !important; }
        }
        @media (min-width: 992px) {
            .col-lg-8 { flex: 0 0 66.666667%; max-width: 66.666667%; }
        }
        .col-12 { flex: 0 0 100%; max-width: 100%; }
        .w-100 { width: 100% !important; }
        .mb-0 { margin-bottom: 0 !important; }
        .mb-1 { margin-bottom: 0.25rem !important; }
        .mb-2 { margin-bottom: 0.5rem !important; }
        .mb-3 { margin-bottom: 1rem !important; }
        .mb-4 { margin-bottom: 1.5rem !important; }
        .mt-1 { margin-top: 0.25rem !important; }
        .mt-2 { margin-top: 0.5rem !important; }
        .mt-3 { margin-top: 1rem !important; }
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
        .d-none { display: none !important; }
        @media (min-width: 768px) { .d-md-flex { display: flex !important; } .d-md-table-cell { display: table-cell !important; } }
        .justify-content-between { justify-content: space-between !important; }
        .align-items-center { align-items: center !important; }
        .border-bottom { border-bottom: 1px solid var(--border-color) !important; }
        hr { margin-top: 1rem; margin-bottom: 1rem; border: 0; border-top: 1px solid var(--border-color); }
        .h2 { font-size: 1.75rem; font-weight: 600; } /* Adjusted size */
        .h4 { font-size: 1.5rem; }
        .h5 { font-size: 1.1rem; }
        .h6 { font-size: 1rem; }
        .fs-5 { font-size: 1.25rem !important; }
        .fs-6 { font-size: 1rem !important; }
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
        .g-3 { gap: 1rem !important; } /* Bootstrap grid gap */

        /* Validation Styles */
        .alert { position: relative; padding: 1rem 1rem; margin-bottom: 1rem; border: 1px solid transparent; border-radius: var(--border-radius); }
        .alert-success { color: #0f5132; background-color: #d1e7dd; border-color: #badbcc; }
        .alert-danger { color: #842029; background-color: #f8d7da; border-color: #f5c2c7; }
        .alert-dismissible { padding-right: 3rem; }
        .btn-close { box-sizing: content-box; width: 1em; height: 1em; padding: 0.25em 0.25em; color: #000; background: transparent; border: 0; border-radius: 0.25rem; opacity: 0.5; }
        .alert-dismissible .btn-close { position: absolute; top: 0; right: 0; z-index: 2; padding: 1.25rem 1rem; }
        .fade { transition: opacity 0.15s linear; }
        .show { opacity: 1; }
        .was-validated .form-control:invalid, .form-control.is-invalid { border-color: #dc3545; }
        .was-validated .form-control:invalid:focus, .form-control.is-invalid:focus { border-color: #dc3545; box-shadow: 0 0 0 0.25rem rgba(220,53,69,.25); }
        .invalid-feedback { display: none; width: 100%; margin-top: 0.25rem; font-size: .875em; color: #dc3545; }
        .was-validated .form-control:invalid ~ .invalid-feedback,
        .was-validated .form-select:invalid ~ .invalid-feedback { display: block; }

        /* --- Icon Box --- */
        .icon-box {
            width: 45px;
            height: 45px;
            border-radius: 12px;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 1.2rem;
            flex-shrink: 0; /* Prevent shrinking */
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
                   <i class="fas fa-user-shield"></i> <%-- Admin Icon --%>
                </div>
                <div class="user-info">
                   <% if (currentAdmin != null) { %>
                    <h6><%= currentAdmin.getFullName() %></h6>
                    <small>Administrator</small>
                   <% } %>
                </div>
            </div>

            <div class="nav-main">
                <ul class="nav">
                    <li class="nav-item">
                        <a class="nav-link <%= request.getRequestURI().contains("dashboard.jsp") ? "active" : "" %>"
                           href="${pageContext.request.contextPath}/admin/dashboard.jsp">
                            <i class="fas fa-tachometer-alt"></i>
                            <span>Dashboard</span>
                        </a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link <%= request.getRequestURI().contains("profile") ? "active" : "" %>"
                           href="${pageContext.request.contextPath}/admin/profile.jsp">
                            <i class="fas fa-user"></i>
                            <span>My Profile</span>
                        </a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link <%= request.getRequestURI().contains("management") && request.getQueryString() != null && request.getQueryString().contains("type=doctors") ? "active" : "" %>"
                           href="${pageContext.request.contextPath}/admin/management?action=view&type=doctors">
                            <i class="fas fa-user-md"></i>
                            <span>Manage Doctors</span>
                        </a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link <%= request.getRequestURI().contains("management") && request.getQueryString() != null && request.getQueryString().contains("type=patients") ? "active" : "" %>"
                           href="${pageContext.request.contextPath}/admin/management?action=view&type=patients">
                            <i class="fas fa-users"></i>
                            <span>Manage Patients</span>
                        </a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link <%= request.getRequestURI().contains("management") && request.getQueryString() != null && request.getQueryString().contains("type=appointments") ? "active" : "" %>"
                           href="${pageContext.request.contextPath}/admin/management?action=view&type=appointments">
                            <i class="fas fa-calendar-alt"></i>
                            <span>Manage Appointments</span>
                        </a>
                    </li>
                    <%-- Add other admin-specific links here --%>
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
                <i class="fas fa-users me-2 text-primary"></i>
                Manage Patients
            </h1>
            <div class="btn-toolbar mb-2 mb-md-0">
                <span class="badge bg-primary fs-6"> <%-- Increased font size --%>
                    <i class="fas fa-users me-1"></i>
                    <%= patients.size() %> Total Patients
                </span>
            </div>
        </div>

        <%-- ===================================================================== --%>
        <%--         ROBUST MESSAGE HANDLING BLOCK                                 --%>
        <%-- ===================================================================== --%>
        <%
            // 1. Check SESSION (for messages from redirects, e.g., update/delete)
            String successMsg = (String) session.getAttribute("successMsg");
            String errorMsg = (String) session.getAttribute("errorMsg");

            // 2. Clear session messages after reading them
            if (successMsg != null) {
                session.removeAttribute("successMsg");
            }
            if (errorMsg != null) {
                session.removeAttribute("errorMsg");
            }

            // 3. Check REQUEST (for messages from a forward, e.g., failed validation)
            if (request.getAttribute("successMsg") != null) {
                successMsg = (String) request.getAttribute("successMsg");
            }
            if (request.getAttribute("errorMsg") != null) {
                errorMsg = (String) request.getAttribute("errorMsg");
            }
            
            // 4. Display any messages that were found
            if (successMsg != null && !successMsg.isEmpty()) {
        %>
            <div class="alert alert-success alert-dismissible fade show" role="alert">
                <i class="fas fa-check-circle me-2"></i><%= successMsg %>
                <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
            </div>
        <%
            }
            if (errorMsg != null && !errorMsg.isEmpty()) {
        %>
            <div class="alert alert-danger alert-dismissible fade show" role="alert">
                <i class="fas fa-exclamation-triangle me-2"></i><%= errorMsg %>
                <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
            </div>
        <%
            }
        %>
        <%-- ===================================================================== --%>
        <%--         END: ROBUST MESSAGE HANDLING BLOCK                          --%>
        <%-- ===================================================================== --%>


        <div class="card shadow-custom">
            <div class="card-header d-flex justify-content-between align-items-center flex-wrap"> <%-- Added flex-wrap --%>
                <h5 class="mb-0 me-3">
                    <i class="fas fa-list me-2"></i>Patients List
                </h5>
                <div class="mt-2 mt-md-0"> <%-- Wrap search --%>
                    <input type="text" class="form-control form-control-sm" id="patientSearchInput" placeholder="Search patients..." style="max-width: 300px;">
                </div>
            </div>
            <div class="card-body">
                <%
                    if (patients.isEmpty()) {
                %>
                    <div class="text-center py-5">
                        <i class="fas fa-users fa-4x text-muted mb-3"></i>
                        <h4 class="text-muted">No Patients Found</h4>
                        <p class="text-muted">No patients have registered yet.</p>
                        <%-- Maybe add a button to register a patient if needed --%>
                    </div>
                <%
                    } else {
                %>
                    <div class="table-responsive">
                        <table class="table table-hover" id="patientsTable">
                            <thead>
                                <tr>
                                    <th>Patient Info</th>
                                    <th>Contact</th>
                                    <th>Gender</th>
                                    <th>Blood Group</th>
                                    <th>Date of Birth</th>
                                    <th>Registered</th>
                                    <th>Actions</th>
                                </tr>
                            </thead>
                            <tbody>
                                <%
                                    for (Patient patient : patients) {
                                %>
                                    <tr>
                                        <td>
                                            <div class="d-flex align-items-center">
                                                <div class="icon-box icon-primary me-3 d-none d-md-flex">
                                                    <i class="fas fa-user"></i>
                                                </div>
                                                <div>
                                                    <strong><%= patient.getFullName() %></strong><br>
                                                    <small class="text-muted">
                                                        <i class="fas fa-envelope me-1"></i><%= patient.getEmail() %>
                                                    </small><br>
                                                    <small class="text-muted">ID: PAT<%= patient.getId() %></small>
                                                </div>
                                            </div>
                                        </td>
                                        <td>
                                            <small class="text-muted d-block"> <%-- Use d-block for wrapping --%>
                                                <i class="fas fa-phone me-1"></i><%= patient.getPhone() != null ? patient.getPhone() : "N/A" %>
                                            </small>
                                            <small class="text-muted d-block mt-1">
                                                <i class="fas fa-home me-1"></i>
                                                <%
                                                    if (patient.getAddress() != null && patient.getAddress().length() > 30) {
                                                        out.print(patient.getAddress().substring(0, 30) + "...");
                                                    } else if (patient.getAddress() != null) {
                                                        out.print(patient.getAddress());
                                                    } else {
                                                        out.print("N/A");
                                                    }
                                                %>
                                            </small>
                                        </td>
                                        <td>
                                            <span class="badge bg-light text-dark">
                                                <i class="fas fa-venus-mars me-1"></i>
                                                <%= patient.getGender() != null ? patient.getGender() : "N/A" %>
                                            </span>
                                        </td>
                                        <td>
                                            <%
                                                if (patient.getBloodGroup() != null && !patient.getBloodGroup().isEmpty()) {
                                            %>
                                                <span class="badge bg-danger text-white">
                                                    <i class="fas fa-tint me-1"></i>
                                                    <%= patient.getBloodGroup() %>
                                                </span>
                                            <%
                                                } else {
                                            %>
                                                <span class="badge bg-secondary text-white">N/A</span>
                                            <%
                                                }
                                            %>
                                        </td>
                                        <td>
                                            <small><%= patient.getDateOfBirth() != null ? patient.getDateOfBirth().toString() : "N/A" %></small>
                                        </td>
                                        <td>
                                            <small class="text-muted"><%= patient.getCreatedAt() != null ? sdf.format(patient.getCreatedAt()) : "N/A" %></small>
                                        </td>
                                        <td>
                                            <div class="btn-group btn-group-sm" role="group">
                                                
                                                <button type="button" class="btn btn-outline-primary"
                                                        data-bs-toggle="modal" data-bs-target="#viewPatientModal<%= patient.getId() %>"
                                                        data-bs-toggle="tooltip" title="View Details">
                                                    <i class="fas fa-eye"></i>
                                                </button>
                                                
                                                <button type="button" class="btn btn-outline-warning"
                                                        data-bs-toggle="modal" data-bs-target="#editPatientModal<%= patient.getId() %>"
                                                        data-bs-toggle="tooltip" title="Edit Patient">
                                                    <i class="fas fa-edit"></i>
                                                </button>
                                                
                                                <form action="${pageContext.request.contextPath}/admin/management?action=delete&type=patient"
                                                      method="post" class="d-inline">
                                                    <input type="hidden" name="id" value="<%= patient.getId() %>">
                                                    <button type="submit" class="btn btn-outline-danger delete-patient"
                                                            data-bs-toggle="tooltip" title="Delete Patient">
                                                        <i class="fas fa-trash"></i>
                                                    </button>
                                                </form>
                                            </div>

                                            <div class="modal fade" id="viewPatientModal<%= patient.getId() %>" tabindex="-1" aria-labelledby="viewPatientModalLabel<%= patient.getId() %>" aria-hidden="true">
                                                <div class="modal-dialog modal-lg modal-dialog-centered">
                                                    <div class="modal-content">
                                                        <div class="modal-header">
                                                            <h5 class="modal-title" id="viewPatientModalLabel<%= patient.getId() %>">
                                                                <i class="fas fa-eye me-2 text-primary"></i>View Patient Details
                                                            </h5>
                                                            <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                                                        </div>
                                                        <div class="modal-body">
                                                            <div class="row g-3">
                                                                <div class="col-md-6">
                                                                    <label class="form-label text-muted">Full Name</label>
                                                                    <p class="fs-6 fw-medium"><%= patient.getFullName() %></p>
                                                                </div>
                                                                <div class="col-md-6">
                                                                    <label class="form-label text-muted">Email</label>
                                                                    <p class="fs-6 fw-medium"><%= patient.getEmail() %></p>
                                                                </div>
                                                                <div class="col-md-6">
                                                                    <label class="form-label text-muted">Phone</label>
                                                                    <p class="fs-6 fw-medium"><%= patient.getPhone() != null ? patient.getPhone() : "N/A" %></p>
                                                                </div>
                                                                <div class="col-md-6">
                                                                    <label class="form-label text-muted">Gender</label>
                                                                    <p class="fs-6 fw-medium"><%= patient.getGender() != null ? patient.getGender() : "N/A" %></p>
                                                                </div>
                                                                <div class="col-12">
                                                                    <label class="form-label text-muted">Address</label>
                                                                    <p class="fs-6 fw-medium"><%= patient.getAddress() != null ? patient.getAddress() : "N/A" %></p>
                                                                </div>
                                                                <div class="col-md-4">
                                                                    <label class="form-label text-muted">Blood Group</label>
                                                                    <p class="fs-6 fw-medium"><%= patient.getBloodGroup() != null ? patient.getBloodGroup() : "N/A" %></p>
                                                                </div>
                                                                <div class="col-md-4">
                                                                    <label class="form-label text-muted">Date of Birth</label>
                                                                    <p class="fs-6 fw-medium"><%= patient.getDateOfBirth() != null ? patient.getDateOfBirth().toString() : "N/A" %></p>
                                                                </div>
                                                                <div class="col-md-4">
                                                                    <label class="form-label text-muted">Emergency Contact</label>
                                                                    <p class="fs-6 fw-medium"><%= patient.getEmergencyContact() != null ? patient.getEmergencyContact() : "N/A" %></p>
                                                                </div>
                                                                <div class="col-12">
                                                                    <label class="form-label text-muted">Medical History</label>
                                                                    <p class="fs-6 fw-medium" style="white-space: pre-wrap;"><%= patient.getMedicalHistory() != null && !patient.getMedicalHistory().isEmpty() ? patient.getMedicalHistory() : "N/A" %></p>
                                                                </div>
                                                            </div>
                                                        </div>
                                                        <div class="modal-footer">
                                                            <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Close</button>
                                                        </div>
                                                    </div>
                                                </div>
                                            </div>
                                            <div class="modal fade" id="editPatientModal<%= patient.getId() %>" tabindex="-1" aria-labelledby="editPatientModalLabel<%= patient.getId() %>" aria-hidden="true">
                                                <div class="modal-dialog modal-lg modal-dialog-centered">
                                                    <div class="modal-content">
                                                        <div class="modal-header">
                                                            <h5 class="modal-title" id="editPatientModalLabel<%= patient.getId() %>">
                                                                <i class="fas fa-edit me-2 text-primary"></i>Edit Patient Details
                                                            </h5>
                                                            <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                                                        </div>
                                                         <%-- ***** CORRECTED FORM ACTION ***** --%>
                                                        <form action="${pageContext.request.contextPath}/admin/management?action=update&type=patient" method="post" class="needs-validation" novalidate>
                                                            <input type="hidden" name="patientId" value="<%= patient.getId() %>">
                                                            <div class="modal-body">
                                                                <div class="row g-3">
                                                                    <div class="col-md-6">
                                                                        <label class="form-label" for="editFullName<%= patient.getId() %>">Full Name</label>
                                                                        <input type="text" class="form-control" id="editFullName<%= patient.getId() %>" name="fullName"
                                                                               value="<%= patient.getFullName() %>" required>
                                                                         <div class="invalid-feedback">Please enter patient's name.</div>
                                                                    </div>
                                                                    <div class="col-md-6">
                                                                        <label class="form-label">Email</label>
                                                                        <input type="email" class="form-control" value="<%= patient.getEmail() %>" readonly disabled>
                                                                        <small class="text-muted">Email cannot be changed by admin.</small>
                                                                    </div>
                                                                    <div class="col-md-6">
                                                                        <label class="form-label" for="editPhone<%= patient.getId() %>">Phone</label>
                                                                        <input type="tel" class="form-control" id="editPhone<%= patient.getId() %>" name="phone"
                                                                               value="<%= patient.getPhone() != null ? patient.getPhone() : "" %>" required>
                                                                        <div class="invalid-feedback">Please enter phone number.</div>
                                                                    </div>
                                                                    <div class="col-md-6">
                                                                        <label class="form-label" for="editGender<%= patient.getId() %>">Gender</label>
                                                                        <select class="form-select" id="editGender<%= patient.getId() %>" name="gender" required>
                                                                            <option value="">Select Gender</option>
                                                                            <option value="Male" <%= "Male".equals(patient.getGender()) ? "selected" : "" %>>Male</option>
                                                                            <option value="Female" <%= "Female".equals(patient.getGender()) ? "selected" : "" %>>Female</option>
                                                                            <option value="Other" <%= "Other".equals(patient.getGender()) ? "selected" : "" %>>Other</option>
                                                                        </select>
                                                                         <div class="invalid-feedback">Please select gender.</div>
                                                                    </div>
                                                                    <div class="col-12">
                                                                        <label class="form-label" for="editAddress<%= patient.getId() %>">Address</label>
                                                                        <textarea class="form-control" id="editAddress<%= patient.getId() %>" name="address" rows="2" required><%= patient.getAddress() != null ? patient.getAddress() : "" %></textarea>
                                                                         <div class="invalid-feedback">Please enter address.</div>
                                                                    </div>
                                                                    <div class="col-md-4">
                                                                        <label class="form-label" for="editBloodGroup<%= patient.getId() %>">Blood Group</label>
                                                                        <select class="form-select" id="editBloodGroup<%= patient.getId() %>" name="bloodGroup" required>
                                                                            <option value="">Select</option>
                                                                            <option value="A+" <%= "A+".equals(patient.getBloodGroup()) ? "selected" : "" %>>A+</option>
                                                                            <option value="A-" <%= "A-".equals(patient.getBloodGroup()) ? "selected" : "" %>>A-</option>
                                                                            <option value="B+" <%= "B+".equals(patient.getBloodGroup()) ? "selected" : "" %>>B+</option>
                                                                            <option value="B-" <%= "B-".equals(patient.getBloodGroup()) ? "selected" : "" %>>B-</option>
                                                                            <option value="AB+" <%= "AB+".equals(patient.getBloodGroup()) ? "selected" : "" %>>AB+</option>
                                                                            <option value="AB-" <%= "AB-".equals(patient.getBloodGroup()) ? "selected" : "" %>>AB-</option>
                                                                            <option value="O+" <%= "O+".equals(patient.getBloodGroup()) ? "selected" : "" %>>O+</option>
                                                                            <option value="O-" <%= "O-".equals(patient.getBloodGroup()) ? "selected" : "" %>>O-</option>
                                                                        </select>
                                                                         <div class="invalid-feedback">Please select blood group.</div>
                                                                    </div>
                                                                    <div class="col-md-4">
                                                                        <label class="form-label" for="editDateOfBirth<%= patient.getId() %>">Date of Birth</label>
                                                                        <input type="date" class="form-control" id="editDateOfBirth<%= patient.getId() %>" name="dateOfBirth"
                                                                               value="<%= patient.getDateOfBirth() != null ? patient.getDateOfBirth().toString() : "" %>" required>
                                                                         <div class="invalid-feedback">Please enter date of birth.</div>
                                                                    </div>
                                                                    <div class="col-md-4">
                                                                        <label class="form-label" for="editEmergencyContact<%= patient.getId() %>">Emergency Contact</label>
                                                                        <input type="tel" class="form-control" id="editEmergencyContact<%= patient.getId() %>" name="emergencyContact"
                                                                               value="<%= patient.getEmergencyContact() != null ? patient.getEmergencyContact() : "" %>" required>
                                                                         <div class="invalid-feedback">Please enter emergency contact.</div>
                                                                    </div>
                                                                    <div class="col-12">
                                                                        <label class="form-label" for="editMedicalHistory<%= patient.getId() %>">Medical History (Optional)</label>
                                                                        <textarea class="form-control" id="editMedicalHistory<%= patient.getId() %>" name="medicalHistory" rows="3"><%= patient.getMedicalHistory() != null ? patient.getMedicalHistory() : "" %></textarea>
                                                                    </div>
                                                                </div>
                                                            </div>
                                                            <div class="modal-footer">
                                                                <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cancel</button>
                                                                <button type="submit" class="btn btn-primary">
                                                                    <i class="fas fa-save me-1"></i>Update Patient
                                                                </button>
                                                            </div>
                                                        </form>
                                                    </div>
                                                </div>
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
                    sidebar.classList.add('mobile-open'); // Keep it open on desktop
                    sidebar.classList.remove('mobile-open'); // But don't use the mobile-open state logic
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
            
            // --- START: UPDATED AUTO-HIDE SCRIPT ---
            // Auto-hide success alerts after 5 seconds
            const successAlerts = document.querySelectorAll('.alert-success.alert-dismissible');
            
            successAlerts.forEach(function(alert) {
                setTimeout(function() {
                    // Check if Bootstrap's Alert component is loaded
                    if (typeof bootstrap !== 'undefined' && bootstrap.Alert) {
                        // Get the instance or create a new one, then close it
                        const bsAlert = bootstrap.Alert.getInstance(alert) || new bootstrap.Alert(alert);
                        if (bsAlert) {
                            bsAlert.close();
                        }
                    } else {
                        // Fallback if Bootstrap JS isn't loaded
                        alert.style.transition = 'opacity 0.5s ease';
                        alert.style.opacity = '0';
                        setTimeout(() => alert.style.display = 'none', 500);
                    }
                }, 5000); // 5000 milliseconds = 5 seconds
            });
            // --- END: UPDATED AUTO-HIDE SCRIPT ---

            // Initialize tooltips
            const tooltipTriggerList = [].slice.call(document.querySelectorAll('[data-bs-toggle="tooltip"]'));
            const tooltipList = tooltipTriggerList.map(function (tooltipTriggerEl) {
                 // Ensure bootstrap is loaded
                 if (typeof bootstrap !== 'undefined' && bootstrap.Tooltip) {
                     return new bootstrap.Tooltip(tooltipTriggerEl);
                 }
                 return null;
            }).filter(tooltip => tooltip !== null);

            // Form validation (for modals)
            const forms = document.querySelectorAll('.needs-validation');
            Array.from(forms).forEach(form => {
                form.addEventListener('submit', function(event) {
                    if (!form.checkValidity()) {
                        event.preventDefault();
                        event.stopPropagation();
                    }
                    form.classList.add('was-validated');
                }, false);
            });

            // Confirm delete actions
            const deleteButtons = document.querySelectorAll('.delete-patient');
            deleteButtons.forEach(button => {
                 const form = button.closest('form');
                 if(form) {
                     form.addEventListener('submit', function(e) {
                        if (!confirm('Are you sure you want to PERMANENTLY DELETE this patient? This action cannot be undone and will also delete all associated appointments.')) {
                            e.preventDefault();
                        }
                     });
                 }
            });

            // Search functionality
            const searchInput = document.getElementById('patientSearchInput'); // Use ID added in HTML
            const tableBody = document.querySelector('#patientsTable tbody');
            const rows = tableBody ? tableBody.querySelectorAll('tr') : [];

            if (searchInput) {
                searchInput.addEventListener('input', function() {
                    const searchTerm = this.value.toLowerCase().trim();

                    rows.forEach(row => {
                        // Search in first column's content (adjust if needed)
                        const patientInfoCell = row.cells[0];
                        const text = patientInfoCell ? patientInfoCell.textContent.toLowerCase() : '';

                        if (text.includes(searchTerm)) {
                            row.style.display = ''; // Show row
                        } else {
                            row.style.display = 'none'; // Hide row
                        }
                    });
                });
            } else {
                console.error("Search input with ID 'patientSearchInput' not found.");
            }
        });
    </script>
</body>
</html>