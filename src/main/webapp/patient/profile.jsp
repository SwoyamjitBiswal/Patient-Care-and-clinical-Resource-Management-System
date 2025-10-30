<%@ page import="com.entity.Patient" %>
<%@ page import="java.util.List" %> <%-- Keeping imports just in case --%>
<%@ page import="com.entity.Appointment" %>

<%
    // This is the main user check for the page
    Patient currentPatient = (Patient) session.getAttribute("patientObj");

    // --- FIX START ---
    // If the patient is null, send redirect and stop.
    // The 'else' block (below) now wraps the ENTIRE HTML page.
    if (currentPatient == null) {
        response.sendRedirect(request.getContextPath() + "/patient/login.jsp");
        return;
    } else {
    
    // This variable is only needed if the patient exists, so it's moved inside the 'else'.
    String currentUserRole = "patient";
%>
<%-- --- FIX END --- --%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Patient Care System - Patient Profile</title>
    
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
            padding: 0;
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
        
        /* Profile Header */
        .profile-header {
            background: linear-gradient(135deg, var(--primary), #6366f1);
            color: white;
            padding: 2.5rem 2.5rem;
            margin-bottom: 2rem;
            box-shadow: var(--shadow);
        }
        
        .profile-body-wrapper {
             padding: 0 2.5rem 2.5rem;
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
        
        /* Form Styles */
        .form-label {
            font-weight: 500;
            margin-bottom: 0.5rem;
            color: var(--dark);
            display: block;
        }
        
        /* Updated Input Group Styles */
        .input-group {
            position: relative;
            display: flex;
            flex-wrap: wrap;
            align-items: stretch;
            width: 100%;
            border-radius: 10px;
            overflow: hidden;
            border: 1px solid #d1d5db;
            transition: var(--transition);
        }
        
        .input-group:focus-within {
            border-color: var(--primary);
            box-shadow: 0 0 0 3px rgba(79, 70, 229, 0.15);
        }
        
        .input-group-text {
            background: #f9fafb;
            border: none;
            color: #6b7280;
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
        
        /* Back Link */
        .back-link {
            color: rgba(255, 255, 255, 0.9);
            text-decoration: none;
            font-weight: 500;
            padding: 0.75rem 1.25rem;
            border-radius: var(--border-radius);
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
        
        /* Profile Avatar */
        .profile-avatar {
            width: 120px;
            height: 120px;
            border-radius: 50%;
            background: linear-gradient(135deg, var(--primary), #6366f1);
            display: flex;
            align-items: center;
            justify-content: center;
            margin: 0 auto 1.5rem;
            color: white;
            font-size: 2.5rem;
            box-shadow: var(--shadow-lg);
        }
        
        /* Info Items */
        .info-item {
            display: flex;
            align-items: center;
            padding: 1rem 0;
            border-bottom: 1px solid #f3f4f6;
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
        
        /* Quick Links */
        .quick-link {
            display: flex;
            align-items: center;
            padding: 1rem;
            border-radius: 10px;
            margin-bottom: 0.75rem;
            background: white;
            border: 1px solid #f3f4f6;
            transition: var(--transition);
            text-decoration: none;
            color: var(--dark);
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
        
        /* Status Badge */
        .status-badge {
            display: inline-flex;
            align-items: center;
            padding: 0.35rem 0.75rem;
            border-radius: 50px;
            font-size: 0.8rem;
            font-weight: 500;
        }
        
        .status-active {
            background: rgba(16, 185, 129, 0.1);
            color: var(--success);
        }
        
        /* Form Sections */
        .form-section {
            margin-bottom: 2rem;
        }
        
        .section-title {
            font-size: 1.1rem;
            font-weight: 600;
            color: var(--dark);
            margin-bottom: 1rem;
            padding-bottom: 0.5rem;
            border-bottom: 1px solid #f3f4f6;
        }
        
        .form-field {
            margin-bottom: 1.5rem;
        }
        
        .form-helper {
            font-size: 0.875rem;
            color: #6b7280;
            margin-top: 0.5rem;
            display: block;
        }
        
        .form-actions {
            margin-top: 2rem;
            padding-top: 1.5rem;
            border-top: 1px solid #f3f4f6;
        }
        
        /* Utility Classes */
        .d-flex { display: flex !important; }
        .d-grid { display: grid !important; }
        .justify-content-between { justify-content: space-between !important; }
        .align-items-center { align-items: center !important; }
        .text-center { text-align: center !important; }
        .mb-0 { margin-bottom: 0 !important; }
        .mb-1 { margin-bottom: 0.25rem !important; }
        .mb-2 { margin-bottom: 0.5rem !important; }
        .mb-3 { margin-bottom: 1rem !important; }
        .mb-4 { margin-bottom: 1.5rem !important; }
        .mt-2 { margin-top: 0.5rem !important; }
        .p-4 { padding: 1.5rem !important; }
        .h2 { font-size: 2rem; font-weight: 700; }
        .h4 { font-size: 1.5rem; }
        .fs-5 { font-size: 1.25rem !important; }
        .fw-bold { font-weight: 700 !important; }
        .fw-medium { font-weight: 500 !important; }
        .fw-normal { font-weight: 400 !important; }
        .opacity-75 { opacity: 0.75 !important; }
        .text-muted { color: #6b7280 !important; }
        .text-primary { color: var(--primary) !important; }
        .flex-grow-1 { flex-grow: 1 !important; }
        .me-1 { margin-right: 0.25rem !important; }
        .me-2 { margin-right: 0.5rem !important; }
        .me-3 { margin-right: 1rem !important; }
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
        
        /* Validation */
        .was-validated .form-control:invalid, 
        .form-control.is-invalid,
        .was-validated .form-select:invalid,
        .form-select.is-invalid {
            border-color: #ef4444;
        }
        
        .was-validated .form-control:invalid:focus, 
        .form-control.is-invalid:focus,
        .was-validated .form-select:invalid:focus,
        .form-select.is-invalid:focus {
            border-color: #ef4444;
            box-shadow: 0 0 0 3px rgba(239, 68, 68, 0.1);
        }
        
        .invalid-feedback {
            display: none;
            width: 100%;
            margin-top: 0.25rem;
            font-size: .875em;
            color: #ef4444;
        }
        
        .was-validated .form-control:invalid ~ .invalid-feedback,
        .was-validated .form-select:invalid ~ .invalid-feedback {
            display: block;
        }
        
        @media (max-width: 576px) {
            .input-group-text {
                min-width: 45px;
                padding: 0.75rem 0.75rem;
            }
            
            .form-control, .form-select {
                padding: 0.75rem 0.75rem;
            }
            
            .profile-header {
                padding: 1.5rem !important;
            }
            
            .profile-body-wrapper {
                padding: 1.5rem !important;
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
                        <a class="nav-link active" 
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
                        <a class="nav-link" 
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
        <div class="profile-header">
            <div class="d-flex justify-content-between align-items-center">
                <div>
                    <h1 class="h2 mb-2">
                        <i class="fas fa-user me-2"></i>
                        My Profile
                    </h1>
                    <p class="mb-0 opacity-75">Manage your personal information and health details</p>
                </div>
                <div>
                    <a href="${pageContext.request.contextPath}/patient/dashboard.jsp" class="back-link">
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
                <div class="alert alert-success alert-dismissible fade show mb-4" role="alert">
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
                <div class="alert alert-danger alert-dismissible fade show mb-4" role="alert">
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
                    <div class="card mb-4">
                        <div class="card-header">
                            <h2 class="card-title">
                                <i class="fas fa-edit"></i>
                                Update Profile Information
                            </h2>
                        </div>
                        <div class="card-body">
                            <form action="${pageContext.request.contextPath}/patient/profile?action=update" method="post" class="needs-validation" novalidate>
                                <div class="form-section">
                                    <h3 class="section-title">Personal Information</h3>
                                    <div class="row">
                                        <div class="col-md-6 form-field">
                                            <label for="fullName" class="form-label">Full Name</label>
                                            <div class="input-group">
                                                <span class="input-group-text">
                                                    <i class="fas fa-user text-primary"></i>
                                                </span>
                                                <input type="text" class="form-control" id="fullName" name="fullName" 
                                                       value="<%= currentPatient.getFullName() %>" required>
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
                                                       value="<%= currentPatient.getEmail() %>" readonly>
                                            </div>
                                            <span class="form-helper">Email cannot be changed</span>
                                        </div>
                                    </div>

                                    <div class="row">
                                        <div class="col-md-6 form-field">
                                            <label for="phone" class="form-label">Phone Number</label>
                                            <div class="input-group">
                                                <span class="input-group-text">
                                                    <i class="fas fa-phone text-primary"></i>
                                                </span>
                                                <input type="tel" class="form-control" id="phone" name="phone" 
                                                       value="<%= currentPatient.getPhone() != null ? currentPatient.getPhone() : "" %>" required>
                                            </div>
                                            <div class="invalid-feedback">Please enter your phone number.</div>
                                        </div>
                                        
                                        <div class="col-md-6 form-field">
                                            <label for="gender" class="form-label">Gender</label>
                                            <div class="input-group">
                                                <span class="input-group-text">
                                                    <i class="fas fa-venus-mars text-primary"></i>
                                                </span>
                                                <select class="form-select" id="gender" name="gender" required>
                                                    <option value="">Select Gender</option>
                                                    <option value="Male" <%= "Male".equals(currentPatient.getGender()) ? "selected" : "" %>>Male</option>
                                                    <option value="Female" <%= "Female".equals(currentPatient.getGender()) ? "selected" : "" %>>Female</option>
                                                    <option value="Other" <%= "Other".equals(currentPatient.getGender()) ? "selected" : "" %>>Other</option>
                                                </select>
                                            </div>
                                            <div class="invalid-feedback">Please select your gender.</div>
                                        </div>
                                    </div>

                                    <div class="form-field">
                                        <label for="address" class="form-label">Address</label>
                                        <div class="input-group">
                                            <span class="input-group-text align-items-start pt-3">
                                                <i class="fas fa-home text-primary"></i>
                                            </span>
                                            <textarea class="form-control" id="address" name="address" rows="3" required><%= currentPatient.getAddress() != null ? currentPatient.getAddress() : "" %></textarea>
                                        </div>
                                        <div class="invalid-feedback">Please enter your address.</div>
                                    </div>
                                </div>

                                <div class="form-section">
                                    <h3 class="section-title">Medical Information</h3>
                                    <div class="row">
                                        <div class="col-md-4 form-field">
                                            <label for="bloodGroup" class="form-label">Blood Group</label>
                                            <div class="input-group">
                                                <span class="input-group-text">
                                                    <i class="fas fa-tint text-primary"></i>
                                                </span>
                                                <select class="form-select" id="bloodGroup" name="bloodGroup" required>
                                                    <option value="">Select Blood Group</option>
                                                    <option value="A+" <%= "A+".equals(currentPatient.getBloodGroup()) ? "selected" : "" %>>A+</option>
                                                    <option value="A-" <%= "A-".equals(currentPatient.getBloodGroup()) ? "selected" : "" %>>A-</option>
                                                    <option value="B+" <%= "B+".equals(currentPatient.getBloodGroup()) ? "selected" : "" %>>B+</option>
                                                    <option value="B-" <%= "B-".equals(currentPatient.getBloodGroup()) ? "selected" : "" %>>B-</option>
                                                    <option value="AB+" <%= "AB+".equals(currentPatient.getBloodGroup()) ? "selected" : "" %>>AB+</option>
                                                    <option value="AB-" <%= "AB-".equals(currentPatient.getBloodGroup()) ? "selected" : "" %>>AB-</option>
                                                    <option value="O+" <%= "O+".equals(currentPatient.getBloodGroup()) ? "selected" : "" %>>O+</option>
                                                    <option value="O-" <%= "O-".equals(currentPatient.getBloodGroup()) ? "selected" : "" %>>O-</option>
                                                </select>
                                            </div>
                                            <div class="invalid-feedback">Please select your blood group.</div>
                                        </div>
                                        
                                        <div class="col-md-4 form-field">
                                            <label for="dateOfBirth" class="form-label">Date of Birth</label>
                                            <div class="input-group">
                                                <span class="input-group-text">
                                                    <i class="fas fa-calendar text-primary"></i>
                                                </span>
                                                <input type="date" class="form-control" id="dateOfBirth" name="dateOfBirth" 
                                                       value="<%= currentPatient.getDateOfBirth() != null ? currentPatient.getDateOfBirth().toString() : "" %>" required>
                                            </div>
                                            <div class="invalid-feedback">Please enter your date of birth.</div>
                                        </div>
                                        
                                        <div class="col-md-4 form-field">
                                            <label for="emergencyContact" class="form-label">Emergency Contact</label>
                                            <div class="input-group">
                                                <span class="input-group-text">
                                                    <i class="fas fa-phone-alt text-primary"></i>
                                                </span>
                                                <input type="tel" class="form-control" id="emergencyContact" name="emergencyContact" 
                                                       value="<%= currentPatient.getEmergencyContact() != null ? currentPatient.getEmergencyContact() : "" %>" required>
                                            </div>
                                            <div class="invalid-feedback">Please enter emergency contact.</div>
                                        </div>
                                    </div>

                                    <div class="form-field">
                                        <label for="medicalHistory" class="form-label">Medical History</label>
                                        <div class="input-group">
                                            <span class="input-group-text align-items-start pt-3">
                                                <i class="fas fa-file-medical text-primary"></i>
                                            </span>
                                            <textarea class="form-control" id="medicalHistory" name="medicalHistory" rows="3"
                                                      placeholder="Any pre-existing conditions, allergies, or medical history"><%= currentPatient.getMedicalHistory() != null ? currentPatient.getMedicalHistory() : "" %></textarea>
                                        </div>
                                        <span class="form-helper">Optional: Include any relevant medical information for better care</span>
                                    </div>
                                </div>

                                <div class="form-actions">
                                    <div class="d-grid">
                                        <button type="submit" class="btn btn-primary">
                                            <i class="fas fa-save me-2"></i>Update Profile
                                        </button>
                                    </div>
                                </div>
                            </form>
                        </div>
                    </div>
                </div>

                <div class="col-lg-4">
                    <div class="card mb-4">
                        <div class="card-header">
                            <h2 class="card-title">
                                <i class="fas fa-info-circle"></i>
                                Profile Summary
                            </h2>
                        </div>
                        <div class="card-body">
                            <div class="text-center mb-4">
                                <div class="profile-avatar">
                                    <i class="fas fa-user"></i>
                                </div>
                                <h4 class="fw-bold mb-1"><%= currentPatient.getFullName() %></h4>
                                <p class="text-muted mb-3">Patient</p>
                                <span class="status-badge status-active">
                                    <i class="fas fa-circle me-1 small"></i> Active
                                </span>
                            </div>
                            
                            <div class="mb-4">
                                <div class="info-item">
                                    <div class="info-icon">
                                        <i class="fas fa-envelope"></i>
                                    </div>
                                    <div class="flex-grow-1">
                                        <div class="fw-medium">Email</div>
                                        <div class="text-muted"><%= currentPatient.getEmail() %></div>
                                    </div>
                                </div>
                                <div class="info-item">
                                    <div class="info-icon">
                                        <i class="fas fa-phone"></i>
                                    </div>
                                    <div class="flex-grow-1">
                                        <div class="fw-medium">Phone</div>
                                        <div class="text-muted"><%= currentPatient.getPhone() != null ? currentPatient.getPhone() : "Not set" %></div>
                                    </div>
                                </div>
                                <div class="info-item">
                                    <div class="info-icon">
                                        <i class="fas fa-venus-mars"></i>
                                    </div>
                                    <div class="flex-grow-1">
                                        <div class="fw-medium">Gender</div>
                                        <div class="text-muted"><%= currentPatient.getGender() != null ? currentPatient.getGender() : "Not set" %></div>
                                    </div>
                                </div>
                                <div class="info-item">
                                    <div class="info-icon">
                                        <i class="fas fa-tint"></i>
                                    </div>
                                    <div class="flex-grow-1">
                                        <div class="fw-medium">Blood Group</div>
                                        <div class="text-muted"><%= currentPatient.getBloodGroup() != null ? currentPatient.getBloodGroup() : "Not set" %></div>
                                    </div>
                                </div>
                                <div class="info-item">
                                    <div class="info-icon">
                                        <i class="fas fa-calendar"></i>
                                    </div>
                                    <div class="flex-grow-1">
                                        <div class="fw-medium">Member Since</div>
                                        <div class="text-muted"><%= currentPatient.getCreatedAt() != null ? currentPatient.getCreatedAt().toString().split(" ")[0] : "N/A" %></div>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>

                    <div class="card">
                        <div class="card-header">
                            <h2 class="card-title">
                                <i class="fas fa-link"></i>
                                Quick Actions
                            </h2>
                        </div>
                        <div class="card-body">
                            <a href="${pageContext.request.contextPath}/patient/change_password.jsp" class="quick-link">
                                <i class="fas fa-key"></i>
                                <span>Change Password</span>
                            </a>
                            <a href="${pageContext.request.contextPath}/patient/appointment?action=book" class="quick-link">
                                <i class="fas fa-calendar-plus"></i>
                                <span>Book Appointment</span>
                            </a>
                            <a href="${pageContext.request.contextPath}/patient/appointment?action=view" class="quick-link">
                                <i class="fas fa-list"></i>
                                <span>View Appointments</span>
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

            // Set max date for date of birth
            const dobInput = document.getElementById('dateOfBirth');
            if (dobInput) {
                const today = new Date();
                // Set max date to today (or 18 years ago, as you had it)
                // Let's stick to your original logic of 18 years ago
                const maxDate = new Date(today.getFullYear() - 18, today.getMonth(), today.getDate());
                
                // But also set a reasonable min date (e.g., 100 years ago)
                const minDate = new Date(today.getFullYear() - 100, today.getMonth(), today.getDate());

                dobInput.max = maxDate.toISOString().split('T')[0];
                dobInput.min = minDate.toISOString().split('T')[0];
            }
        });
    </script>
</body>
</html>
<%-- --- FIX START --- --%>
<%
    } // This closing brace ends the 'else' block from the top
%>
<%-- --- FIX END --- --%>