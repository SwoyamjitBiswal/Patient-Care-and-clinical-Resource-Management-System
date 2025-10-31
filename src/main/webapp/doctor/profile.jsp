<%@ page import="com.entity.Doctor" %>
<%
    // Renamed 'doctor' to 'currentDoctor'
    Doctor currentDoctor = (Doctor) session.getAttribute("doctorObj");
    if (currentDoctor == null) {
        response.sendRedirect(request.getContextPath() + "/doctor/login.jsp"); // Added context path
        return;
    }
    // Variable needed for the sidebar's logout button
    String currentUserRole = "doctor";
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Patient Care System - Doctor Profile</title>

    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" rel="stylesheet">
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700&display=swap" rel="stylesheet">

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>

    <style>
        /* --- Light Mode Variables & Base Styles --- */
        :root {
            --primary: #4361ee;
            --primary-light: #eef2ff;
            --primary-dark: #3a56d4;
            --secondary: #6c757d;
            --danger: #dc3545;
            --danger-light: #fbebee;
            --success: #28a745;
            --warning: #ffc107;
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
        
        /* --- Profile Page Specific Styles --- */
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
        
        .form-label {
            font-weight: 500;
            margin-bottom: 0.5rem;
            color: var(--gray-700);
            display: block;
        }
        
        /* Updated Input Group Styles - Fixed Positioning */
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

        /* Textarea specific styles */
        .input-group-text.align-items-start {
            align-items: flex-start;
            padding-top: 0.75rem;
        }

        /* Focus state for the entire input group */
        .input-group:focus-within .input-group-text {
            background: var(--primary-light);
            color: var(--primary);
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
        
        /* Back link styling - removed button appearance */
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
        
        .profile-avatar {
            width: 120px;
            height: 120px;
            border-radius: 50%;
            background: linear-gradient(135deg, var(--primary), #5a6ff0);
            display: flex;
            align-items: center;
            justify-content: center;
            margin: 0 auto 1.5rem;
            color: white;
            font-size: 2.5rem;
            box-shadow: var(--shadow-md);
        }
        
        .info-item {
            display: flex;
            align-items: center;
            padding: 1rem 0;
            border-bottom: 1px solid var(--gray-200);
        }
        
        .info-item:last-child {
            border-bottom: none;
        }
        
        .info-icon {
            width: 40px;
            height: 40px;
            border-radius: 10px;
            background: var(--primary-light);
            display: flex;
            align-items: center;
            justify-content: center;
            margin-right: 1rem;
            color: var(--primary);
            flex-shrink: 0;
        }
        
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
        
        .alert-modern {
            border-radius: 10px;
            border: none;
            box-shadow: var(--shadow-sm);
            padding: 1rem 1.5rem;
        }
        
        /* Bootstrap-like utility classes */
        .row { display: flex; flex-wrap: wrap; margin-right: -15px; margin-left: -15px; }
        .col-lg-8, .col-lg-4, .col-md-6, .col-md-4 { position: relative; width: 100%; padding-right: 15px; padding-left: 15px; }
        @media (min-width: 768px) {
            .col-md-6 { flex: 0 0 50%; max-width: 50%; }
            .col-md-4 { flex: 0 0 33.333333%; max-width: 33.333333%; }
        }
        @media (min-width: 992px) {
            .col-lg-8 { flex: 0 0 66.666667%; max-width: 66.666667%; }
            .col-lg-4 { flex: 0 0 33.333333%; max-width: 33.333333%; }
        }
        .mb-0 { margin-bottom: 0 !important; }
        .mb-1 { margin-bottom: 0.25rem !important; }
        .mb-2 { margin-bottom: 0.5rem !important; }
        .mb-3 { margin-bottom: 1rem !important; }
        .mb-4 { margin-bottom: 1.5rem !important; }
        .mt-2 { margin-top: 0.5rem !important; }
        .p-4 { padding: 1.5rem !important; }
        .pt-3 { padding-top: 1rem !important; }
        .h2 { font-size: 2rem; font-weight: 600; }
        .h4 { font-size: 1.5rem; }
        .fs-5 { font-size: 1.25rem !important; }
        .fw-bold { font-weight: 700 !important; }
        .fw-medium { font-weight: 500 !important; }
        .fw-normal { font-weight: 400 !important; }
        .opacity-75 { opacity: 0.75 !important; }
        .d-flex { display: flex !important; }
        .d-grid { display: grid !important; }
        .d-block { display: block !important; }
        .justify-content-between { justify-content: space-between !important; }
        .align-items-center { align-items: center !important; }
        .align-items-start { align-items: flex-start !important; }
        .text-center { text-align: center !important; }
        .text-muted { color: var(--gray-600) !important; }
        .text-primary { color: var(--primary) !important; }
        .flex-grow-1 { flex-grow: 1 !important; }
        .me-1 { margin-right: 0.25rem !important; }
        .me-2 { margin-right: 0.5rem !important; }
        .me-3 { margin-right: 1rem !important; }
        .btn { display: inline-block; font-weight: 500; color: #212529; text-align: center; vertical-align: middle; cursor: pointer; user-select: none; background-color: transparent; border: 1px solid transparent; padding: 0.5rem 1rem; font-size: 0.9rem; border-radius: 0.375rem; transition: var(--transition); text-decoration: none; }
        .btn-light { color: var(--gray-700); background-color: white; border-color: var(--gray-300); }
        .btn-light:hover { background-color: var(--gray-100); border-color: var(--gray-400); }
        .alert { position: relative; padding: 1rem 1rem; margin-bottom: 1rem; border: 1px solid transparent; border-radius: 0.375rem; }
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
        .was-validated .form-control:invalid ~ .invalid-feedback { display: block; }
        .small { font-size: 0.875rem; }
        
        /* Improved form styling */
        .form-section {
            margin-bottom: 2rem;
        }
        
        .section-title {
            font-size: 1.1rem;
            font-weight: 600;
            color: var(--gray-800);
            margin-bottom: 1rem;
            padding-bottom: 0.5rem;
            border-bottom: 1px solid var(--gray-200);
        }
        
        /* Status badges */
        .status-badge {
            display: inline-flex;
            align-items: center;
            padding: 0.35rem 0.75rem;
            border-radius: 50px;
            font-size: 0.8rem;
            font-weight: 500;
        }
        
        .status-active {
            background: rgba(40, 167, 69, 0.1);
            color: var(--success);
        }
        
        /* Improved spacing for form rows */
        .form-row-spaced > [class*="col-"] {
            margin-bottom: 1.25rem;
        }

        /* Enhanced form field styling */
        .form-field {
            margin-bottom: 1.5rem;
        }
        
        .form-field:last-child {
            margin-bottom: 0;
        }
        
        .form-helper {
            font-size: 0.875rem;
            color: var(--gray-600);
            margin-top: 0.5rem;
            display: block;
        }
        
        /* Form group improvements */
        .form-group {
            margin-bottom: 1.5rem;
        }
        
        .form-actions {
            margin-top: 2rem;
            padding-top: 1.5rem;
            border-top: 1px solid var(--gray-200);
        }

        /* Form switch styling */
        .form-check.form-switch {
            padding-left: 3.5rem;
        }
        
        .form-check-input {
            width: 3rem;
            height: 1.5rem;
            margin-left: -3.5rem;
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
                        <i class="fas fa-user-md me-2"></i>
                        My Profile
                    </h1>
                    <p class="mb-0 opacity-75">Manage your professional information and settings</p>
                </div>
                <div>
                    <a href="${pageContext.request.contextPath}/doctor/dashboard.jsp" class="back-link">
                        <i class="fas fa-arrow-left me-2"></i>Back to Dashboard
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
                <div class="col-lg-8">
                    <div class="card card-modern mb-4">
                        <div class="card-header-modern">
                            <i class="fas fa-edit"></i>
                            <span>Update Profile Information</span>
                        </div>
                        <div class="card-body p-4">
                            <form action="${pageContext.request.contextPath}/doctor/profile?action=update" method="post" class="needs-validation" novalidate>
                                <div class="form-section">
                                    <h3 class="section-title">Personal Information</h3>
                                    <div class="row form-row-spaced">
                                        <div class="col-md-6 form-field">
                                            <label for="fullName" class="form-label">Full Name</label>
                                            <div class="input-group">
                                                <span class="input-group-text">
                                                    <i class="fas fa-user text-primary"></i>
                                                </span>
                                                <input type="text" class="form-control" id="fullName" name="fullName" 
                                                       value="<%= currentDoctor.getFullName() %>" required>
                                            </div>
                                            <div class="invalid-feedback">Please enter your full name.</div>
                                        </div>
                                        
                                        <div class="col-md-6 form-field">
                                            <label for="email" class="form-label">Email Address</label>
                                            <div class="input-group">
                                                <span class="input-group-text">
                                                    <i class="fas fa-envelope text-primary"></i>
                                                </span>
                                                <input type="email" class="form-control" id="email" 
                                                       value="<%= currentDoctor.getEmail() %>" readonly>
                                            </div>
                                            <span class="form-helper">Email cannot be changed</span>
                                        </div>
                                    </div>

                                    <div class="row form-row-spaced">
                                        <div class="col-md-6 form-field">
                                            <label for="phone" class="form-label">Phone Number</label>
                                            <div class="input-group">
                                                <span class="input-group-text">
                                                    <i class="fas fa-phone text-primary"></i>
                                                </span>
                                                <input type="tel" class="form-control" id="phone" name="phone" 
                                                       value="<%= currentDoctor.getPhone() != null ? currentDoctor.getPhone() : "" %>" required>
                                            </div>
                                            <div class="invalid-feedback">Please enter your phone number.</div>
                                        </div>
                                        
                                        <div class="col-md-6 form-field">
                                            <label for="specialization" class="form-label">Specialization</label>
                                            <div class="input-group">
                                                <span class="input-group-text">
                                                    <i class="fas fa-stethoscope text-primary"></i>
                                                </span>
                                                <select class="form-select" id="specialization" name="specialization" required>
                                                    <option value="">Select Specialization</option>
                                                    <option value="Cardiology" <%= "Cardiology".equals(currentDoctor.getSpecialization()) ? "selected" : "" %>>Cardiology</option>
                                                    <option value="Neurology" <%= "Neurology".equals(currentDoctor.getSpecialization()) ? "selected" : "" %>>Neurology</option>
                                                    <option value="Pediatrics" <%= "Pediatrics".equals(currentDoctor.getSpecialization()) ? "selected" : "" %>>Pediatrics</option>
                                                    <option value="Dermatology" <%= "Dermatology".equals(currentDoctor.getSpecialization()) ? "selected" : "" %>>Dermatology</option>
                                                    <option value="Orthopedics" <%= "Orthopedics".equals(currentDoctor.getSpecialization()) ? "selected" : "" %>>Orthopedics</option>
                                                    <option value="Gynecology" <%= "Gynecology".equals(currentDoctor.getSpecialization()) ? "selected" : "" %>>Gynecology</option>
                                                    <option value="Psychiatry" <%= "Psychiatry".equals(currentDoctor.getSpecialization()) ? "selected" : "" %>>Psychiatry</option>
                                                    <option value="Dentistry" <%= "Dentistry".equals(currentDoctor.getSpecialization()) ? "selected" : "" %>>Dentistry</option>
                                                    <option value="Ophthalmology" <%= "Ophthalmology".equals(currentDoctor.getSpecialization()) ? "selected" : "" %>>Ophthalmology</option>
                                                    <option value="General Medicine" <%= "General Medicine".equals(currentDoctor.getSpecialization()) ? "selected" : "" %>>General Medicine</option>
                                                </select>
                                            </div>
                                            <div class="invalid-feedback">Please select your specialization.</div>
                                        </div>
                                    </div>
                                </div>

                                <div class="form-section">
                                    <h3 class="section-title">Professional Information</h3>
                                    <div class="row form-row-spaced">
                                        <div class="col-md-6 form-field">
                                            <label for="department" class="form-label">Department</label>
                                            <div class="input-group">
                                                <span class="input-group-text">
                                                    <i class="fas fa-building text-primary"></i>
                                                </span>
                                                <input type="text" class="form-control" id="department" name="department"
                                                       value="<%= currentDoctor.getDepartment() != null ? currentDoctor.getDepartment() : "" %>" required>
                                            </div>
                                            <div class="invalid-feedback">Please enter your department.</div>
                                        </div>
                                        
                                        <div class="col-md-6 form-field">
                                            <label for="qualification" class="form-label">Qualifications</label>
                                            <div class="input-group">
                                                <span class="input-group-text">
                                                    <i class="fas fa-graduation-cap text-primary"></i>
                                                </span>
                                                <input type="text" class="form-control" id="qualification" name="qualification"
                                                       value="<%= currentDoctor.getQualification() != null ? currentDoctor.getQualification() : "" %>" required>
                                            </div>
                                            <div class="invalid-feedback">Please enter your qualifications.</div>
                                        </div>
                                    </div>

                                    <div class="row form-row-spaced">
                                        <div class="col-md-6 form-field">
                                            <label for="experience" class="form-label">Experience (Years)</label>
                                            <div class="input-group">
                                                <span class="input-group-text">
                                                    <i class="fas fa-briefcase text-primary"></i>
                                                </span>
                                                <input type="number" class="form-control" id="experience" name="experience"
                                                       value="<%= currentDoctor.getExperience() %>" required min="0" max="50">
                                            </div>
                                            <div class="invalid-feedback">Please enter your experience in years.</div>
                                        </div>
                                        
                                        <div class="col-md-6 form-field">
                                            <label for="visitingCharge" class="form-label">Visiting Charge</label>
                                            <div class="input-group">
                                                <span class="input-group-text">
                                                    <i class="fa-solid fa-inr"></i>
                                                </span>
                                                <input type="number" class="form-control" id="visitingCharge" name="visitingCharge"
                                                       value="<%= currentDoctor.getVisitingCharge() %>" required min="0" step="0.01">
                                            </div>
                                            <div class="invalid-feedback">Please enter your visiting charge.</div>
                                        </div>
                                    </div>

                                    <div class="form-field">
                                        <div class="form-check form-switch ps-0 d-flex align-items-center">
                                            <div class="me-3">
                                                <input class="form-check-input" type="checkbox" id="availability" name="availability"
                                                       <%= currentDoctor.isAvailability() ? "checked" : "" %>>
                                            </div>
                                            <label class="form-check-label fw-medium" for="availability">
                                                Available for appointments
                                            </label>
                                        </div>
                                        <span class="form-helper">When turned off, patients won't be able to book appointments with you.</span>
                                    </div>
                                </div>

                                <div class="form-actions">
                                    <div class="d-grid">
                                        <button type="submit" class="btn btn-primary-modern btn-modern py-2">
                                            <i class="fas fa-save me-2"></i>Update Profile
                                        </button>
                                    </div>
                                </div>
                            </form>
                        </div>
                    </div>
                </div>

                <div class="col-lg-4">
                    <div class="card card-modern mb-4">
                        <div class="card-header-modern">
                            <i class="fas fa-info-circle"></i>
                            <span>Profile Summary</span>
                        </div>
                        <div class="card-body p-4">
                            <div class="text-center mb-4">
                                <div class="profile-avatar">
                                    <i class="fas fa-user-md"></i>
                                </div>
                                <h4 class="fw-bold mb-1">Dr. <%= currentDoctor.getFullName() %></h4>
                                <p class="text-muted mb-3"><%= currentDoctor.getSpecialization() %></p>
                                <span class="status-badge status-active">
                                    <i class="fas fa-circle me-1 small"></i> 
                                    <%= currentDoctor.isAvailability() ? "Available" : "Not Available" %>
                                </span>
                            </div>
                            
                            <div class="mb-4">
                                <div class="info-item">
                                    <div class="info-icon">
                                        <i class="fas fa-envelope"></i>
                                    </div>
                                    <div class="flex-grow-1">
                                        <div class="fw-medium">Email</div>
                                        <div class="text-muted"><%= currentDoctor.getEmail() %></div>
                                    </div>
                                </div>
                                <div class="info-item">
                                    <div class="info-icon">
                                        <i class="fas fa-phone"></i>
                                    </div>
                                    <div class="flex-grow-1">
                                        <div class="fw-medium">Phone</div>
                                        <div class="text-muted"><%= currentDoctor.getPhone() != null ? currentDoctor.getPhone() : "Not set" %></div>
                                    </div>
                                </div>
                                <div class="info-item">
                                    <div class="info-icon">
                                        <i class="fas fa-building"></i>
                                    </div>
                                    <div class="flex-grow-1">
                                        <div class="fw-medium">Department</div>
                                        <div class="text-muted"><%= currentDoctor.getDepartment() != null ? currentDoctor.getDepartment() : "Not set" %></div>
                                    </div>
                                </div>
                                <div class="info-item">
                                    <div class="info-icon">
                                        <i class="fas fa-briefcase"></i>
                                    </div>
                                    <div class="flex-grow-1">
                                        <div class="fw-medium">Experience</div>
                                        <div class="text-muted"><%= currentDoctor.getExperience() %> years</div>
                                    </div>
                                </div>
                                <div class="info-item">
                                    <div class="info-icon">
                                        <i class="fas fa-calendar"></i>
                                    </div>
                                    <div class="flex-grow-1">
                                        <div class="fw-medium">Member Since</div>
<div class="text-muted"><%= currentDoctor.getCreatedAt() != null ? currentDoctor.getCreatedAt().toString().split(" ")[0] : "N/A" %></div>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>

                    <div class="card card-modern">
                        <div class="card-header-modern">
                            <i class="fas fa-link"></i>
                            <span>Quick Actions</span>
                        </div>
                        <div class="card-body p-4">
                            <a href="${pageContext.request.contextPath}/doctor/change_password.jsp" class="quick-link">
                                <i class="fas fa-key"></i>
                                <span>Change Password</span>
                            </a>
                            <a href="${pageContext.request.contextPath}/doctor/appointment?action=view" class="quick-link">
                                <i class="fas fa-list"></i>
                                <span>View Appointments</span>
                            </a>
                            <a href="${pageContext.request.contextPath}/doctor/dashboard.jsp" class="quick-link">
                                <i class="fas fa-tachometer-alt"></i>
                                <span>Dashboard</span>
                            </a>
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
        });
    </script>
</body>
</html>