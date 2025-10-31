<%@ page import="com.entity.Admin" %>
<%@ page import="java.text.SimpleDateFormat" %>
<%
    Admin currentAdmin = (Admin) session.getAttribute("adminObj");
    if (currentAdmin == null) {
        response.sendRedirect(request.getContextPath() + "/admin/login.jsp");
        return;
    }
    String currentUserRole = "admin";
    
    SimpleDateFormat dateFormat = new SimpleDateFormat("yyyy-MM-dd");
    String memberSince = "N/A";
    if (currentAdmin.getCreatedAt() != null) {
        memberSince = dateFormat.format(currentAdmin.getCreatedAt());
    }
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Patient Care System - Admin Profile</title>

    <!-- Bootstrap 5 CSS -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" rel="stylesheet">
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700&display=swap" rel="stylesheet">
    
    <style>
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
            --shadow-xl: 0 20px 25px -5px rgba(0, 0, 0, 0.1), 0 10px 10px -5px rgba(0, 0, 0, 0.04);
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
            min-height: 100vh;
            overflow-x: hidden;
        }
        
        /* Sidebar Styles */
        .sidebar {
            width: var(--sidebar-width);
            flex-shrink: 0;
            background: linear-gradient(135deg, #ffffff, #f8fafc);
            color: var(--gray-700);
            height: 100vh;
            position: fixed;
            left: 0;
            top: 0;
            overflow-y: auto;
            transition: var(--transition);
            box-shadow: var(--shadow-md);
            display: flex;
            flex-direction: column;
            border-right: 1px solid var(--gray-200);
            z-index: 1000;
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
            margin-left: var(--sidebar-width);
            padding: 0;
            min-height: 100vh;
            overflow-y: auto;
            background: var(--gray-100);
            transition: var(--transition);
        }

        .mobile-menu-toggle {
            display: none;
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
            align-items: center;
            justify-content: center;
            font-size: 1.25rem;
            cursor: pointer;
            box-shadow: var(--shadow-lg);
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
        
        /* Scrollbar styling */
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
            background: var(--gray-400);
            border-radius: 3px;
        }
        
        .sidebar::-webkit-scrollbar-thumb:hover,
        .main-content::-webkit-scrollbar-thumb:hover {
            background: var(--gray-500);
        }
        
        /* Dashboard Specific Styles */
        .main-content-dashboard {
            padding: 2.5rem;
        }
        
        @media (max-width: 768px) {
            .main-content-dashboard {
                padding: 1.5rem;
                padding-top: 6rem;
            }
        }
        
        .profile-header {
            background: linear-gradient(135deg, var(--primary), #5a6ff0);
            color: white;
            padding: 2.5rem 2.5rem;
            margin-bottom: 2rem;
            box-shadow: var(--shadow-md);
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
        }
        
        .input-group {
            position: relative;
            display: flex;
            align-items: stretch;
            width: 100%;
            border-radius: 10px;
            overflow: hidden;
            border: 1px solid var(--gray-300);
            transition: var(--transition);
            background: white;
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
            border-right: 1px solid var(--gray-300);
        }
        
        .form-control, .form-select {
            border: none;
            padding: 0.75rem 1rem;
            transition: var(--transition);
            font-size: 0.95rem;
            width: 100%;
            flex: 1;
            background: transparent;
        }
        
        .form-control:focus, .form-select:focus {
            box-shadow: none;
            outline: none;
            background: transparent;
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
        
        .btn-outline-secondary {
            border: 2px solid var(--gray-400);
            color: var(--gray-600);
            background: transparent;
            font-weight: 500;
            transition: all 0.3s ease;
        }
        
        .btn-outline-secondary:hover {
            background: var(--gray-600);
            color: white;
            border-color: var(--gray-600);
            transform: translateY(-2px);
            box-shadow: 0 4px 12px rgba(108, 117, 125, 0.2);
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
        
        .badge-success { color: #065f46; background-color: #d1fae5; }
        
        /* Back link styling */
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
        
        /* Icon Box */
        .icon-box {
            width: 80px;
            height: 80px;
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 2rem;
            flex-shrink: 0;
        }
        
        .icon-primary { background-color: var(--primary-light); color: var(--primary); }
        
        /* Alert Styles */
        .alert-modern {
            border-radius: 10px;
            border: none;
            box-shadow: var(--shadow-sm);
            padding: 1rem 1.5rem;
        }
        
        /* Password toggle */
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
            width: 45px;
            height: 100%;
            display: flex;
            align-items: center;
            justify-content: center;
        }
        
        .password-toggle:hover {
            color: var(--primary);
        }
        
        /* Password strength meter */
        .password-strength-meter {
            height: 6px;
            margin-top: 8px;
            border-radius: 3px;
            background-color: var(--gray-200);
            overflow: hidden;
        }
        
        .password-strength-meter-fill {
            height: 100%;
            width: 0%;
            transition: width 0.3s ease;
            border-radius: 3px;
        }
        
        .strength-weak {
            background-color: var(--danger);
            width: 25%;
        }
        
        .strength-fair {
            background-color: var(--warning);
            width: 50%;
        }
        
        .strength-good {
            background-color: #17a2b8;
            width: 75%;
        }
        
        .strength-strong {
            background-color: var(--success);
            width: 100%;
        }
        
        /* Password requirements list */
        .password-requirements {
            margin-top: 10px;
        }
        
        .requirement-item {
            display: flex;
            align-items: center;
            margin-bottom: 6px;
            font-size: 0.85rem;
        }
        
        .requirement-icon {
            margin-right: 8px;
            width: 16px;
            text-align: center;
        }
        
        .requirement-met {
            color: var(--success);
        }
        
        .requirement-unmet {
            color: var(--gray-500);
        }
        
        /* Profile info styles */
        .profile-info-item {
            display: flex;
            justify-content: space-between;
            align-items: center;
            padding: 0.75rem 0;
            border-bottom: 1px solid var(--gray-200);
        }
        
        .profile-info-item:last-child {
            border-bottom: none;
        }
        
        .info-label {
            font-weight: 500;
            color: var(--gray-700);
            display: flex;
            align-items: center;
            gap: 0.5rem;
        }
        
        .info-value {
            color: var(--gray-600);
            text-align: right;
        }
        
        /* Security tips */
        .security-tips {
            list-style: none;
            padding: 0;
            margin: 0;
        }
        
        .security-tips li {
            padding: 0.5rem 0;
            display: flex;
            align-items: center;
            gap: 0.75rem;
        }
        
        .security-tips i {
            color: var(--success);
            font-size: 0.9rem;
        }
        
        /* Header improvements */
        .page-header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            flex-wrap: wrap;
            gap: 1rem;
        }
        
        @media (max-width: 768px) {
            .page-header {
                flex-direction: column;
                align-items: flex-start;
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
                   <i class="fas fa-user-shield"></i>
                </div>
                <div class="user-info">
                   <% if (currentAdmin != null) { %>
                    <h6><%= currentAdmin.getFullName() %></h6>
                    <span class="badge">Administrator</span>
                   <% } %>
                </div>
            </div>

            <div class="nav-main">
                <ul class="nav">
                    <li class="nav-item">
                        <a class="nav-link" href="${pageContext.request.contextPath}/admin/dashboard.jsp">
                            <i class="fas fa-tachometer-alt"></i>
                            <span>Dashboard</span>
                        </a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link active" href="${pageContext.request.contextPath}/admin/profile.jsp">
                            <i class="fas fa-user"></i>
                            <span>My Profile</span>
                        </a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link" href="${pageContext.request.contextPath}/admin/management?action=view&type=doctors">
                            <i class="fas fa-user-md"></i>
                            <span>Manage Doctors</span>
                        </a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link" href="${pageContext.request.contextPath}/admin/management?action=view&type=patients">
                            <i class="fas fa-users"></i>
                            <span>Manage Patients</span>
                        </a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link" href="${pageContext.request.contextPath}/admin/management?action=view&type=appointments">
                            <i class="fas fa-calendar-alt"></i>
                            <span>Manage Appointments</span>
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
                        <a class="nav-link nav-link-logout" href="${pageContext.request.contextPath}/admin/auth?action=logout">
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
            <div class="page-header">
                <div>
                    <h1 class="h2 mb-2">
                        <i class="fas fa-user-shield me-2"></i>
                        Admin Profile
                    </h1>
                    <p class="mb-0 opacity-75">Manage your account settings and security preferences</p>
                </div>
                <div>
                    <a href="${pageContext.request.contextPath}/admin/dashboard.jsp" class="back-link">
                        <i class="fas fa-arrow-left me-2"></i>Back to Dashboard
                    </a>
                </div>
            </div>
        </div>

        <div class="main-content-dashboard">
            <%-- Success/Error Messages --%>
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
                    <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
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
                    <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
                </div>
            <%
                }
            %>

            <div class="row">
                <div class="col-lg-6 mb-4">
                    <div class="card card-modern h-100">
                        <div class="card-header-modern">
                            <i class="fas fa-user-shield"></i>
                            <span>Admin Information</span>
                        </div>
                        <div class="card-body">
                            <div class="text-center mb-4">
                                <div class="icon-box icon-primary mx-auto mb-3">
                                    <i class="fas fa-user-shield"></i>
                                </div>
                                <h4 class="mb-2"><%= currentAdmin.getFullName() %></h4>
                                <p class="text-muted mb-0">System Administrator</p>
                            </div>

                            <div class="profile-info-list">
                                <div class="profile-info-item">
                                    <span class="info-label">
                                        <i class="fas fa-envelope text-primary"></i>
                                        Email Address
                                    </span>
                                    <span class="info-value"><%= currentAdmin.getEmail() %></span>
                                </div>
                                <div class="profile-info-item">
                                    <span class="info-label">
                                        <i class="fas fa-calendar text-primary"></i>
                                        Member Since
                                    </span>
                                    <span class="info-value"><%= memberSince %></span>
                                </div>
                                <div class="profile-info-item">
                                    <span class="info-label">
                                        <i class="fas fa-key text-primary"></i>
                                        Last Password Change
                                    </span>
                                    <span class="info-value">Never</span>
                                </div>
                                <div class="profile-info-item">
                                    <span class="info-label">
                                        <i class="fas fa-shield-alt text-primary"></i>
                                        Account Status
                                    </span>
                                    <span class="badge badge-success">Active</span>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>

                <div class="col-lg-6">
                    <div class="card card-modern mb-4">
                        <div class="card-header-modern">
                            <i class="fas fa-key"></i>
                            <span>Change Password</span>
                        </div>
                        <div class="card-body">
                            <form action="${pageContext.request.contextPath}/admin/profile?action=changePassword" method="post" class="needs-validation" novalidate id="passwordForm">
                                <div class="mb-3">
                                    <label for="currentPassword" class="form-label">Current Password</label>
                                    <div class="input-group">
                                        <span class="input-group-text">
                                            <i class="fas fa-lock"></i>
                                        </span>
                                        <input type="password" class="form-control" id="currentPassword" name="currentPassword" required>
                                        <button type="button" class="password-toggle" id="toggleCurrentPassword">
                                            <i class="fas fa-eye"></i>
                                        </button>
                                    </div>
                                    <div class="invalid-feedback">Please enter your current password.</div>
                                </div>

                                <div class="mb-3">
                                    <label for="newPassword" class="form-label">New Password</label>
                                    <div class="input-group">
                                        <span class="input-group-text">
                                            <i class="fas fa-key"></i>
                                        </span>
                                        <input type="password" class="form-control" id="newPassword" name="newPassword" required minlength="8">
                                        <button type="button" class="password-toggle" id="toggleNewPassword">
                                            <i class="fas fa-eye"></i>
                                        </button>
                                    </div>
                                    <div class="password-strength-meter mt-2">
                                        <div class="password-strength-meter-fill" id="passwordStrength"></div>
                                    </div>
                                    <div class="password-requirements mt-3">
                                        <small class="text-muted d-block mb-2">Password must contain:</small>
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

                                <div class="mb-3">
                                    <label for="confirmPassword" class="form-label">Confirm New Password</label>
                                    <div class="input-group">
                                        <span class="input-group-text">
                                            <i class="fas fa-key"></i>
                                        </span>
                                        <input type="password" class="form-control" id="confirmPassword" name="confirmPassword" required minlength="8">
                                        <button type="button" class="password-toggle" id="toggleConfirmPassword">
                                            <i class="fas fa-eye"></i>
                                        </button>
                                    </div>
                                    <div class="invalid-feedback" id="confirmPasswordFeedback">Passwords do not match.</div>
                                </div>

                                <div class="d-grid">
                                    <button type="submit" class="btn btn-primary-modern" id="submitButton" disabled>
                                        <i class="fas fa-save me-2"></i>Update Password
                                    </button>
                                </div>
                            </form>
                        </div>
                    </div>

                    <div class="card card-modern">
                        <div class="card-header-modern">
                            <i class="fas fa-shield-alt"></i>
                            <span>Security Tips</span>
                        </div>
                        <div class="card-body">
                            <ul class="security-tips">
                                <li>
                                    <i class="fas fa-check"></i>
                                    <span>Use a strong, unique password</span>
                                </li>
                                <li>
                                    <i class="fas fa-check"></i>
                                    <span>Change password regularly</span>
                                </li>
                                <li>
                                    <i class="fas fa-check"></i>
                                    <span>Never share your credentials</span>
                                </li>
                                <li>
                                    <i class="fas fa-check"></i>
                                    <span>Log out when not using the system</span>
                                </li>
                            </ul>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </main>

    <!-- Bootstrap 5 JS -->
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    
    <script>
        document.addEventListener('DOMContentLoaded', function() {
            // Mobile menu toggle
            const mobileMenuToggle = document.getElementById('mobileMenuToggle');
            const sidebar = document.getElementById('sidebar');
            
            if (mobileMenuToggle && sidebar) {
                mobileMenuToggle.addEventListener('click', function() {
                    sidebar.classList.toggle('mobile-open');
                });
            }

            // Auto-hide alerts
            const alerts = document.querySelectorAll('.alert');
            alerts.forEach(alert => {
                setTimeout(() => {
                    if (alert && alert.classList.contains('show')) {
                        const bsAlert = new bootstrap.Alert(alert);
                        bsAlert.close();
                    }
                }, 5000);
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