<%@ page import="com.entity.Patient" %>
<%
    // Use unique variable name
    Patient currentPatient = (Patient) session.getAttribute("patientObj");
    if (currentPatient == null) {
        response.sendRedirect(request.getContextPath() + "/patient/login.jsp");
        return;
    }
    
    // This variable is needed for the sidebar's logout button
    String currentUserRole = "patient";
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Patient Care System - Change Password</title>
    
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
        
        .form-control {
            border-radius: 0;
            padding: 0.75rem 1rem;
            border: none;
            transition: var(--transition);
            font-size: 0.95rem;
            width: 100%;
            flex: 1;
        }
        
        .form-control:focus {
            box-shadow: none;
            border: none;
            outline: none;
        }
        
        .form-text {
            font-size: 0.875rem;
            color: #6b7280;
            margin-top: 0.5rem;
            display: block;
        }
        
        /* Password toggle button */
        .password-toggle {
            position: absolute;
            right: 10px;
            top: 50%;
            transform: translateY(-50%);
            background: none;
            border: none;
            color: var(--secondary);
            cursor: pointer;
            z-index: 5;
        }
        
        .password-toggle:hover {
            color: var(--primary);
        }
        
        /* Password strength meter */
        .password-strength-meter {
            height: 5px;
            margin-top: 8px;
            border-radius: 3px;
            background-color: #e9ecef;
            overflow: hidden;
        }
        
        .password-strength-meter-fill {
            height: 100%;
            width: 0%;
            transition: width 0.3s ease;
            border-radius: 3px;
        }
        
        .strength-weak {
            background-color: #dc3545;
            width: 25%;
        }
        
        .strength-fair {
            background-color: #fd7e14;
            width: 50%;
        }
        
        .strength-good {
            background-color: #ffc107;
            width: 75%;
        }
        
        .strength-strong {
            background-color: #28a745;
            width: 100%;
        }
        
        /* Password requirements list */
        .password-requirements {
            margin-top: 10px;
            font-size: 0.8rem;
        }
        
        .requirement-item {
            display: flex;
            align-items: center;
            margin-bottom: 5px;
        }
        
        .requirement-icon {
            margin-right: 8px;
            width: 16px;
            text-align: center;
        }
        
        .requirement-met {
            color: #28a745;
        }
        
        .requirement-unmet {
            color: #6c757d;
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
        
        .btn-lg {
            padding: 0.875rem 2rem;
            font-size: 1.1rem;
        }
        
        .btn-primary {
            background: linear-gradient(135deg, var(--primary), var(--primary-dark));
            color: white;
        }
        
        .btn-primary:hover {
            transform: translateY(-2px);
            box-shadow: 0 7px 14px rgba(79, 70, 229, 0.25);
        }
        
        .btn-outline-secondary {
            background-color: transparent;
            border: 1px solid #6b7280;
            color: #6b7280;
        }
        
        .btn-outline-secondary:hover {
            background-color: #6b7280;
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
        
        /* Security Tips */
        .security-tips {
            list-style: none;
            padding: 0;
            margin: 0;
        }
        
        .security-tips li {
            display: flex;
            align-items: center;
            padding: 0.5rem 0;
            color: #374151;
        }
        
        .security-tips li i {
            color: var(--success);
            margin-right: 0.75rem;
            font-size: 0.875rem;
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
        .mt-4 { margin-top: 1.5rem !important; }
        .me-2 { margin-right: 0.5rem !important; }
        .row { display: flex; flex-wrap: wrap; margin-right: -15px; margin-left: -15px; }
        .col-lg-6 { position: relative; width: 100%; padding-right: 15px; padding-left: 15px; }
        @media (min-width: 992px) {
            .col-lg-6 { flex: 0 0 50%; max-width: 50%; }
        }
        .justify-content-center { justify-content: center !important; }
        
        /* Validation */
        .was-validated .form-control:invalid, 
        .form-control.is-invalid {
            border-color: #ef4444;
        }
        
        .was-validated .form-control:invalid:focus, 
        .form-control.is-invalid:focus {
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
        
        .was-validated .form-control:invalid ~ .invalid-feedback {
            display: block;
        }
        
        @media (max-width: 576px) {
            .input-group-text {
                min-width: 45px;
                padding: 0.75rem 0.75rem;
            }
            
            .form-control {
                padding: 0.75rem 0.75rem;
            }
            
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
                        <a class="nav-link active" 
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
        <div class="page-header">
            <h1 class="page-title">
                <i class="fas fa-key"></i>
                Change Password
            </h1>
            <a href="${pageContext.request.contextPath}/patient/dashboard.jsp" class="back-link">
                <i class="fas fa-arrow-left me-2"></i>Back to Dashboard
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
                    <div class="card-header">
                        <h2 class="card-title">
                            <i class="fas fa-lock"></i>
                            Update Your Password
                        </h2>
                    </div>
                    <div class="card-body">
                        <form action="${pageContext.request.contextPath}/patient/profile?action=changePassword" method="post" class="needs-validation" novalidate id="passwordForm">
                            <div class="mb-4">
                                <label for="currentPassword" class="form-label">
                                    <i class="fas fa-lock me-1 text-primary"></i>Current Password
                                </label>
                                <div class="input-group">
                                    <span class="input-group-text">
                                        <i class="fas fa-lock"></i>
                                    </span>
                                    <input type="password" class="form-control" id="currentPassword" name="currentPassword" required 
                                           placeholder="Enter your current password">
                                    <button type="button" class="password-toggle" id="toggleCurrentPassword">
                                        <i class="fas fa-eye"></i>
                                    </button>
                                </div>
                                <div class="invalid-feedback">Please enter your current password.</div>
                            </div>

                            <div class="mb-4">
                                <label for="newPassword" class="form-label">
                                    <i class="fas fa-key me-1 text-primary"></i>New Password
                                </label>
                                <div class="input-group">
                                    <span class="input-group-text">
                                        <i class="fas fa-key"></i>
                                    </span>
                                    <input type="password" class="form-control" id="newPassword" name="newPassword" required 
                                           placeholder="Enter new password" minlength="8">
                                    <button type="button" class="password-toggle" id="toggleNewPassword">
                                        <i class="fas fa-eye"></i>
                                    </button>
                                </div>
                                <div class="password-strength-meter mt-2">
                                    <div class="password-strength-meter-fill" id="passwordStrength"></div>
                                </div>
                                <div class="password-requirements">
                                    <p class="form-text mb-2">Password must contain:</p>
                                    <div class="requirement-item">
                                        <span class="requirement-icon" id="lengthIcon"><i class="fas fa-times"></i></span>
                                        <span id="lengthText">At least 8 characters</span>
                                    </div>
                                    <div class="requirement-item">
                                        <span class="requirement-icon" id="uppercaseIcon"><i class="fas fa-times"></i></span>
                                        <span id="uppercaseText">One uppercase letter</span>
                                    </div>
                                    <div class="requirement-item">
                                        <span class="requirement-icon" id="lowercaseIcon"><i class="fas fa-times"></i></span>
                                        <span id="lowercaseText">One lowercase letter</span>
                                    </div>
                                    <div class="requirement-item">
                                        <span class="requirement-icon" id="numberIcon"><i class="fas fa-times"></i></span>
                                        <span id="numberText">One number</span>
                                    </div>
                                    <div class="requirement-item">
                                        <span class="requirement-icon" id="specialIcon"><i class="fas fa-times"></i></span>
                                        <span id="specialText">One special character</span>
                                    </div>
                                </div>
                                <div class="invalid-feedback">Password does not meet requirements.</div>
                            </div>

                            <div class="mb-4">
                                <label for="confirmPassword" class="form-label">
                                    <i class="fas fa-key me-1 text-primary"></i>Confirm New Password
                                </label>
                                <div class="input-group">
                                    <span class="input-group-text">
                                        <i class="fas fa-key"></i>
                                    </span>
                                    <input type="password" class="form-control" id="confirmPassword" name="confirmPassword" required 
                                           placeholder="Confirm new password" minlength="8">
                                    <button type="button" class="password-toggle" id="toggleConfirmPassword">
                                        <i class="fas fa-eye"></i>
                                    </button>
                                </div>
                                <div class="invalid-feedback" id="confirmPasswordFeedback">Passwords do not match.</div>
                            </div>

                            <div class="d-grid">
                                <button type="submit" class="btn btn-primary btn-lg" id="submitButton" disabled>
                                    <i class="fas fa-save me-2"></i>Update Password
                                </button>
                            </div>
                        </form>
                    </div>
                </div>

                <div class="card mt-4">
                    <div class="card-header">
                        <h2 class="card-title">
                            <i class="fas fa-shield-alt"></i>
                            Password Security Tips
                        </h2>
                    </div>
                    <div class="card-body">
                        <ul class="security-tips">
                            <li>
                                <i class="fas fa-check"></i>
                                Use at least 8 characters for better security
                            </li>
                            <li>
                                <i class="fas fa-check"></i>
                                Include numbers, uppercase, and special characters
                            </li>
                            <li>
                                <i class="fas fa-check"></i>
                                Avoid using personal information like birthdays
                            </li>
                            <li>
                                <i class="fas fa-check"></i>
                                Don't reuse passwords from other websites
                            </li>
                            <li>
                                <i class="fas fa-check"></i>
                                Consider using a password manager
                            </li>
                            <li>
                                <i class="fas fa-check"></i>
                                Change your password regularly
                            </li>
                            <li>
                                <i class="fas fa-check"></i>
                                Never share your password with anyone
                            </li>
                        </ul>
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
            
            // Password toggle functionality
            const toggleCurrentPassword = document.getElementById('toggleCurrentPassword');
            const toggleNewPassword = document.getElementById('toggleNewPassword');
            const toggleConfirmPassword = document.getElementById('toggleConfirmPassword');
            const currentPassword = document.getElementById('currentPassword');
            const newPassword = document.getElementById('newPassword');
            const confirmPassword = document.getElementById('confirmPassword');
            
            function togglePasswordVisibility(input, toggleButton) {
                if (input.type === 'password') {
                    input.type = 'text';
                    toggleButton.innerHTML = '<i class="fas fa-eye-slash"></i>';
                } else {
                    input.type = 'password';
                    toggleButton.innerHTML = '<i class="fas fa-eye"></i>';
                }
            }
            
            if (toggleCurrentPassword) {
                toggleCurrentPassword.addEventListener('click', function() {
                    togglePasswordVisibility(currentPassword, toggleCurrentPassword);
                });
            }
            
            if (toggleNewPassword) {
                toggleNewPassword.addEventListener('click', function() {
                    togglePasswordVisibility(newPassword, toggleNewPassword);
                });
            }
            
            if (toggleConfirmPassword) {
                toggleConfirmPassword.addEventListener('click', function() {
                    togglePasswordVisibility(confirmPassword, toggleConfirmPassword);
                });
            }
            
            // Password strength validation
            const passwordStrength = document.getElementById('passwordStrength');
            const lengthIcon = document.getElementById('lengthIcon');
            const uppercaseIcon = document.getElementById('uppercaseIcon');
            const lowercaseIcon = document.getElementById('lowercaseIcon');
            const numberIcon = document.getElementById('numberIcon');
            const specialIcon = document.getElementById('specialIcon');
            const lengthText = document.getElementById('lengthText');
            const uppercaseText = document.getElementById('uppercaseText');
            const lowercaseText = document.getElementById('lowercaseText');
            const numberText = document.getElementById('numberText');
            const specialText = document.getElementById('specialText');
            const submitButton = document.getElementById('submitButton');
            
            function checkPasswordStrength(password) {
                let strength = 0;
                let requirements = {
                    length: false,
                    uppercase: false,
                    lowercase: false,
                    number: false,
                    special: false
                };
                
                // Check length
                if (password.length >= 8) {
                    strength += 20;
                    requirements.length = true;
                }
                
                // Check uppercase
                if (/[A-Z]/.test(password)) {
                    strength += 20;
                    requirements.uppercase = true;
                }
                
                // Check lowercase
                if (/[a-z]/.test(password)) {
                    strength += 20;
                    requirements.lowercase = true;
                }
                
                // Check numbers
                if (/[0-9]/.test(password)) {
                    strength += 20;
                    requirements.number = true;
                }
                
                // Check special characters
                if (/[^A-Za-z0-9]/.test(password)) {
                    strength += 20;
                    requirements.special = true;
                }
                
                return { strength, requirements };
            }
            
            function updatePasswordRequirements(requirements) {
                // Update icons and text colors
                updateRequirement(lengthIcon, lengthText, requirements.length);
                updateRequirement(uppercaseIcon, uppercaseText, requirements.uppercase);
                updateRequirement(lowercaseIcon, lowercaseText, requirements.lowercase);
                updateRequirement(numberIcon, numberText, requirements.number);
                updateRequirement(specialIcon, specialText, requirements.special);
                
                // Enable/disable submit button based on all requirements
                const allMet = Object.values(requirements).every(Boolean);
                submitButton.disabled = !allMet;
            }
            
            function updateRequirement(icon, text, met) {
                if (met) {
                    icon.innerHTML = '<i class="fas fa-check"></i>';
                    icon.className = 'requirement-icon requirement-met';
                    text.className = 'requirement-met';
                } else {
                    icon.innerHTML = '<i class="fas fa-times"></i>';
                    icon.className = 'requirement-icon requirement-unmet';
                    text.className = 'requirement-unmet';
                }
            }
            
            function updatePasswordStrength(strength) {
                passwordStrength.className = 'password-strength-meter-fill';
                
                if (strength <= 25) {
                    passwordStrength.classList.add('strength-weak');
                } else if (strength <= 50) {
                    passwordStrength.classList.add('strength-fair');
                } else if (strength <= 75) {
                    passwordStrength.classList.add('strength-good');
                } else {
                    passwordStrength.classList.add('strength-strong');
                }
            }
            
            if (newPassword) {
                newPassword.addEventListener('input', function() {
                    const password = newPassword.value;
                    const { strength, requirements } = checkPasswordStrength(password);
                    
                    updatePasswordStrength(strength);
                    updatePasswordRequirements(requirements);
                    
                    // Validate password confirmation
                    validatePasswordConfirmation();
                });
            }
            
            // Password confirmation validation
            function validatePasswordConfirmation() {
                if (newPassword && confirmPassword) {
                    if (newPassword.value !== confirmPassword.value) {
                        confirmPassword.setCustomValidity("Passwords don't match");
                        document.getElementById('confirmPasswordFeedback').style.display = 'block';
                    } else {
                        confirmPassword.setCustomValidity('');
                        document.getElementById('confirmPasswordFeedback').style.display = 'none';
                    }
                }
            }
            
            if (confirmPassword) {
                confirmPassword.addEventListener('input', validatePasswordConfirmation);
            }
            
            // Form validation
            const forms = document.querySelectorAll('.needs-validation');
            
            Array.from(forms).forEach(form => {
                form.addEventListener('submit', function(event) {
                    // Re-validate password confirmation on submit
                    validatePasswordConfirmation();
                    
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