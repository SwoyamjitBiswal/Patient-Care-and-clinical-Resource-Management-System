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
    <title>Patient Care System - Change Password</title>

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

        .main-content {
            flex-grow: 1;
            min-height: 100vh;
            overflow-y: auto;
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
        .btn-outline-secondary {
            color: #6c757d;
            border-color: #6c757d;
        }
        .btn-outline-secondary:hover {
            color: #fff;
            background-color: #6c757d;
            border-color: #6c757d;
        }

        /* --- Updated Input Group Styles --- */
        .input-group {
            position: relative;
            display: flex;
            flex-wrap: wrap;
            align-items: stretch;
            width: 100%;
            border-radius: var(--border-radius);
            overflow: hidden;
            border: 1px solid var(--border-color);
            transition: var(--transition);
        }

        .input-group:focus-within {
            border-color: var(--primary);
            box-shadow: 0 0 0 3px rgba(67, 97, 238, 0.15);
        }

        .input-group-text {
            background: var(--primary-light);
            border: none;
            color: var(--primary);
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

        /* Password toggle button */
        .password-toggle {
            background: transparent;
            border: none;
            color: var(--secondary);
            padding: 0.75rem 1rem;
            cursor: pointer;
            transition: var(--transition);
            display: flex;
            align-items: center;
            justify-content: center;
            min-width: 50px;
        }

        .password-toggle:hover {
            color: var(--primary);
            background: var(--primary-light);
        }

        /* Password strength meter */
        .password-strength {
            margin-top: 0.5rem;
        }

        .strength-meter {
            height: 4px;
            background: var(--border-color);
            border-radius: 2px;
            margin-bottom: 0.5rem;
            overflow: hidden;
        }

        .strength-meter-fill {
            height: 100%;
            width: 0%;
            transition: all 0.3s ease;
            border-radius: 2px;
        }

        .strength-weak { background: var(--danger); width: 25%; }
        .strength-fair { background: var(--warning); width: 50%; }
        .strength-good { background: #17a2b8; width: 75%; }
        .strength-strong { background: var(--success); width: 100%; }

        .strength-text {
            font-size: 0.8rem;
            font-weight: 500;
        }

        .strength-requirements {
            margin-top: 0.75rem;
            font-size: 0.8rem;
        }

        .requirement {
            display: flex;
            align-items: center;
            margin-bottom: 0.25rem;
            color: var(--secondary);
        }

        .requirement.valid {
            color: var(--success);
        }

        .requirement i {
            margin-right: 0.5rem;
            font-size: 0.7rem;
        }

        .requirement.valid i {
            color: var(--success);
        }

        /* Enhanced Password Requirements */
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

        /* Password Strength Meter */
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

        /* Form Styles */
         .form-label {
            font-weight: 500;
            margin-bottom: 0.5rem;
            color: #4a5568;
            font-size: 0.9rem;
        }

        textarea.form-control {
            min-height: calc(1.5em + 1.5rem + 2px);
        }

        /* Bootstrap utilities */
        .container-fluid { width: 100%; padding-right: 15px; padding-left: 15px; margin-right: auto; margin-left: auto; }
        .row { display: flex; flex-wrap: wrap; margin-right: -15px; margin-left: -15px; }
        .col-lg-6 { position: relative; width: 100%; padding-right: 15px; padding-left: 15px; }
        .justify-content-center { justify-content: center !important; }
        @media (min-width: 992px) {
            .col-lg-6 { flex: 0 0 50%; max-width: 50%; }
        }
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
        .d-flex { display: flex !important; }
        .d-grid { display: grid !important; }
        .justify-content-between { justify-content: space-between !important; }
        .align-items-center { align-items: center !important; }
        .border-bottom { border-bottom: 1px solid var(--border-color) !important; }
        .h2 { font-size: 1.75rem; font-weight: 600; }
        .h5 { font-size: 1.1rem; }
        .me-2 { margin-right: 0.5rem !important; }
        .me-1 { margin-right: 0.25rem !important; }
        .text-primary { color: var(--primary) !important; }
        .text-success { color: var(--success) !important; }
        .text-danger { color: var(--danger) !important; }
        .text-warning { color: var(--warning) !important; }
        .card { position: relative; display: flex; flex-direction: column; min-width: 0; word-wrap: break-word; background-color: #fff; background-clip: border-box; border: 1px solid var(--border-color); border-radius: 0.5rem; }
        .card-body { flex: 1 1 auto; padding: 1.5rem; }
        .list-unstyled { padding-left: 0; list-style: none; }

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
        .form-text { margin-top: 0.25rem; font-size: 0.875em; color: #6c757d; }
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
                <i class="fas fa-key me-2 text-primary"></i>
                Change Password
            </h1>
            <div class="btn-toolbar mb-2 mb-md-0">
                <a href="${pageContext.request.contextPath}/doctor/dashboard.jsp" class="btn btn-sm btn-outline-secondary">
                    <i class="fas fa-arrow-left me-1"></i>Back to Dashboard
                </a>
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

        <div class="row justify-content-center">
            <div class="col-lg-6">
                <div class="card shadow-custom">
                    <div class="card-header">
                        <h5 class="mb-0">
                            <i class="fas fa-lock me-2"></i>Update Your Password
                        </h5>
                    </div>
                    <div class="card-body">
                        <form action="${pageContext.request.contextPath}/doctor/profile?action=changePassword" method="post" class="needs-validation" novalidate id="passwordForm">
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
                                
                                <!-- Password Strength Meter -->
                                <div class="password-strength mt-2">
                                    <div class="strength-meter">
                                        <div class="strength-meter-fill" id="passwordStrengthBar"></div>
                                    </div>
                                    <div class="strength-text" id="passwordStrengthText">
                                        Password strength: None
                                    </div>
                                    
                                    <div class="password-requirements mt-2">
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

                            <div class="d-grid mt-4">
                                <button type="submit" class="btn btn-primary btn-lg" id="submitButton" disabled>
                                    <i class="fas fa-save me-2"></i>Update Password
                                </button>
                            </div>
                        </form>
                    </div>
                </div>

                <div class="card shadow-custom mt-4">
                    <div class="card-header">
                        <h5 class="mb-0">
                            <i class="fas fa-shield-alt me-2"></i>Password Security Tips
                        </h5>
                    </div>
                    <div class="card-body">
                        <ul class="list-unstyled mb-0">
                            <li class="mb-2 d-flex align-items-center">
                                <i class="fas fa-check text-success me-2"></i>
                                <span>Use at least 8 characters with mixed case</span>
                            </li>
                            <li class="mb-2 d-flex align-items-center">
                                <i class="fas fa-check text-success me-2"></i>
                                <span>Include numbers and special characters</span>
                            </li>
                            <li class="mb-2 d-flex align-items-center">
                                <i class="fas fa-check text-success me-2"></i>
                                <span>Avoid using personal information</span>
                            </li>
                            <li class="mb-0 d-flex align-items-center">
                                <i class="fas fa-check text-success me-2"></i>
                                <span>Change your password regularly</span>
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
            const passwordStrength = document.getElementById('passwordStrengthBar');
            const strengthText = document.getElementById('passwordStrengthText');
            const lengthIcon = document.getElementById('lengthIcon');
            const uppercaseIcon = document.getElementById('uppercaseIcon');
            const lowercaseIcon = document.getElementById('lowercaseIcon');
            const numberIcon = document.getElementById('numberIcon');
            const specialIcon = document.getElementById('specialIcon');
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
                updateRequirement(lengthIcon, requirements.length);
                updateRequirement(uppercaseIcon, requirements.uppercase);
                updateRequirement(lowercaseIcon, requirements.lowercase);
                updateRequirement(numberIcon, requirements.number);
                updateRequirement(specialIcon, requirements.special);
                
                // Enable/disable submit button based on all requirements
                const allMet = Object.values(requirements).every(Boolean);
                submitButton.disabled = !allMet;
            }
            
            function updateRequirement(icon, met) {
                if (met) {
                    icon.innerHTML = '<i class="fas fa-check"></i>';
                    icon.className = 'requirement-icon requirement-met';
                    icon.nextElementSibling.className = 'requirement-met';
                } else {
                    icon.innerHTML = '<i class="fas fa-times"></i>';
                    icon.className = 'requirement-icon requirement-unmet';
                    icon.nextElementSibling.className = 'requirement-unmet';
                }
            }
            
            function updatePasswordStrength(strength) {
                passwordStrength.className = 'strength-meter-fill';
                
                if (strength <= 25) {
                    passwordStrength.classList.add('strength-weak');
                    strengthText.textContent = 'Password strength: Weak';
                    strengthText.className = 'strength-text text-danger';
                } else if (strength <= 50) {
                    passwordStrength.classList.add('strength-fair');
                    strengthText.textContent = 'Password strength: Fair';
                    strengthText.className = 'strength-text text-warning';
                } else if (strength <= 75) {
                    passwordStrength.classList.add('strength-good');
                    strengthText.textContent = 'Password strength: Good';
                    strengthText.className = 'strength-text text-info';
                } else {
                    passwordStrength.classList.add('strength-strong');
                    strengthText.textContent = 'Password strength: Strong';
                    strengthText.className = 'strength-text text-success';
                }
            }
            
            if (newPassword) {
                newPassword.addEventListener('input', function() {
                    const password = newPassword.value;
                    
                    // Reset if empty
                    if (password.length === 0) {
                        passwordStrength.className = 'strength-meter-fill';
                        strengthText.textContent = 'Password strength: None';
                        strengthText.className = 'strength-text text-muted';
                        updatePasswordRequirements({
                            length: false,
                            uppercase: false,
                            lowercase: false,
                            number: false,
                            special: false
                        });
                        return;
                    }
                    
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