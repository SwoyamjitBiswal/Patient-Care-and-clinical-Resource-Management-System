<%@ page import="com.entity.Admin" %>
<%@ page import="com.dao.AppointmentDao" %>
<%@ page import="com.dao.DoctorDao" %>
<%@ page import="com.dao.PatientDao" %>
<%@ page import="java.util.List" %>
<%@ page import="com.entity.Doctor" %>
<%@ page import="com.entity.Patient" %>
<%@ page import="com.entity.Appointment" %>
<%@ page import="java.util.Date" %>
<%@ page import="java.text.SimpleDateFormat" %>
<%@ page import="java.util.Map" %>
<%@ page import="java.util.LinkedHashMap" %>
<%
    Admin currentAdmin = (Admin) session.getAttribute("adminObj");
    if (currentAdmin == null) {
        response.sendRedirect(request.getContextPath() + "/admin/login.jsp");
        return;
    }

    AppointmentDao appointmentDao = new AppointmentDao();
    DoctorDao doctorDao = new DoctorDao();
    PatientDao patientDao = new PatientDao();

    // Get real data from database
    int[] appointmentStats = appointmentDao.getAppointmentStats();
    int totalDoctors = doctorDao.getTotalDoctors();
    int totalPatients = patientDao.getTotalPatients();
    
    // Get real data for charts from database
    Map<String, Integer> weeklyAppointments = appointmentDao.getWeeklyAppointmentCounts();
    List<Appointment> recentAppointments = appointmentDao.getRecentAppointments(10);
    List<Appointment> todayAppointments = appointmentDao.getTodaysAppointments();
    Map<String, Integer> doctorAppointmentStats = appointmentDao.getDoctorAppointmentStats();

    String currentUserRole = "admin";
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Patient Care System - Admin Dashboard</title>

    <!-- Bootstrap 5 CSS -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" rel="stylesheet">
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700&display=swap" rel="stylesheet">
    <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
    
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
        
        .dashboard-header {
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
        
        /* Stats Cards */
        .stats-card {
            border-radius: var(--border-radius);
            padding: 1.5rem;
            color: white;
            text-align: center;
            transition: var(--transition);
            height: 100%;
            display: flex;
            flex-direction: column;
            justify-content: center;
            position: relative;
            overflow: hidden;
        }
        
        .stats-card::before {
            content: '';
            position: absolute;
            top: 0;
            left: 0;
            width: 100%;
            height: 100%;
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
        
        .stats-card h4 {
            font-size: 2rem;
            font-weight: 700;
            margin-bottom: 0.25rem;
        }
        
        .stats-card small {
            font-size: 0.9rem;
            font-weight: 500;
            opacity: 0.9;
        }
        
        .stats-card-primary { background: linear-gradient(135deg, var(--primary), #5a6ff0); }
        .stats-card-warning { background: linear-gradient(135deg, var(--warning), #ffd54f); color: var(--gray-800); }
        .stats-card-success { background: linear-gradient(135deg, var(--success), #20c997); }
        .stats-card-info { background: linear-gradient(135deg, var(--info), #0dcaf0); color: var(--gray-800); }
        .stats-card-secondary { background: linear-gradient(135deg, var(--secondary), #6c757d); }
        .stats-card-danger { background: linear-gradient(135deg, var(--danger), #e63946); }
        
        /* Button Styles */
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
        
        .btn-outline-primary {
            border: 2px solid var(--primary);
            color: var(--primary);
            background: transparent;
            font-weight: 500;
        }
        
        .btn-outline-primary:hover {
            background: var(--primary);
            color: white;
            transform: translateY(-2px);
            box-shadow: 0 4px 12px rgba(67, 97, 238, 0.2);
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
        .badge-success { color: #065f46; background-color: #d1fae5; }
        .badge-warning { color: #92400e; background-color: #fef3c7; }
        .badge-danger { color: #991b1b; background-color: #fee2e2; }
        .badge-info { color: #1e40af; background-color: #dbeafe; }
        
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
            background-color: var(--gray-100);
            color: var(--gray-900);
        }
        
        /* Alert Styles */
        .alert-modern {
            border-radius: 10px;
            border: none;
            box-shadow: var(--shadow-sm);
            padding: 1rem 1.5rem;
        }
        
        /* Chart containers */
        .chart-container { 
            position: relative; 
            height: 300px; 
            width: 100%; 
        }
        
        .small-chart-container {
            position: relative;
            height: 200px;
            width: 100%;
        }

        /* Activity items */
        .activity-item {
            padding: 0.75rem 0;
            border-bottom: 1px solid var(--gray-300);
        }

        .activity-item:last-child {
            border-bottom: none;
        }

        /* Status indicators */
        .status-indicator {
            display: flex;
            flex-direction: column;
            gap: 0.25rem;
        }
        
        /* Doctor rank */
        .doctor-rank {
            width: 30px;
            height: 30px;
            border-radius: 50%;
            background: var(--primary);
            color: white;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 0.8rem;
            font-weight: 600;
        }
        
        /* Quick actions grid */
        .quick-actions-grid {
            display: grid;
            gap: 1rem;
        }
        
        /* Empty state */
        .empty-state {
            text-align: center;
            padding: 2rem 1rem;
        }
        
        .empty-state i {
            font-size: 3rem;
            color: var(--gray-400);
            margin-bottom: 1rem;
        }
        
        /* Card header with flex layout */
        .card-header-flex {
            display: flex;
            justify-content: space-between;
            align-items: center;
            flex-wrap: wrap;
            gap: 1rem;
        }
        
        /* Welcome badge */
        .welcome-badge {
            background: rgba(255, 255, 255, 0.15);
            color: white;
            border: 1px solid rgba(255, 255, 255, 0.2);
            padding: 0.5rem 1rem;
            border-radius: 8px;
            font-weight: 500;
        }
        
        /* System info list */
        .system-info-list .list-group-item {
            border: none;
            padding: 0.75rem 0;
            background: transparent;
        }
        
        /* Responsive improvements */
        @media (max-width: 768px) {
            .table-responsive {
                border: 1px solid var(--gray-300);
                border-radius: var(--border-radius);
            }
            
            .card-header-flex {
                flex-direction: column;
                align-items: stretch;
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
                        <a class="nav-link active" href="${pageContext.request.contextPath}/admin/dashboard.jsp">
                            <i class="fas fa-tachometer-alt"></i>
                            <span>Dashboard</span>
                        </a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link" href="${pageContext.request.contextPath}/admin/profile.jsp">
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
        <div class="dashboard-header">
            <div class="d-flex justify-content-between align-items-center flex-wrap">
                <div class="mb-2 mb-md-0">
                    <h1 class="h2 mb-2">
                        <i class="fas fa-tachometer-alt me-2"></i>
                        Admin Dashboard
                    </h1>
                    <p class="mb-0 opacity-75">Welcome back, <%= currentAdmin.getFullName() %>. Here's what's happening today.</p>
                </div>
                <div>
                    <span class="welcome-badge">
                        <i class="fas fa-user-shield me-2"></i>Administrator
                    </span>
                </div>
            </div>
        </div>

        <div class="main-content-dashboard">
            <%-- Success/Error Messages --%>
            <%
                String successMsg = (String) session.getAttribute("successMsg");
                String errorMsg = (String) session.getAttribute("errorMsg");
                
                if (successMsg != null) {
                    session.removeAttribute("successMsg");
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
                    session.removeAttribute("errorMsg");
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

            <%-- Stats Cards --%>
            <div class="row mb-4">
                <div class="col-xl-3 col-md-6 mb-4">
                    <div class="stats-card stats-card-primary">
                        <h4 class="mb-1"><%= appointmentStats[0] %></h4>
                        <small>Total Appointments</small>
                    </div>
                </div>
                <div class="col-xl-3 col-md-6 mb-4">
                    <div class="stats-card stats-card-success">
                        <h4 class="mb-1"><%= totalDoctors %></h4>
                        <small>Total Doctors</small>
                    </div>
                </div>
                <div class="col-xl-3 col-md-6 mb-4">
                    <div class="stats-card stats-card-info">
                        <h4 class="mb-1"><%= totalPatients %></h4>
                        <small>Total Patients</small>
                    </div>
                </div>
                <div class="col-xl-3 col-md-6 mb-4">
                    <div class="stats-card stats-card-warning">
                        <h4 class="mb-1"><%= appointmentStats[1] %></h4>
                        <small>Pending Appointments</small>
                    </div>
                </div>
            </div>

            <div class="row">
                <div class="col-lg-8 mb-4">
                    <div class="card card-modern">
                        <div class="card-header-modern card-header-flex">
                            <div>
                                <i class="fas fa-chart-bar"></i>
                                <span>Appointment Analytics</span>
                            </div>
                        </div>
                        <div class="card-body">
                            <div class="row">
                                <div class="col-md-6 mb-4">
                                    <div class="chart-container">
                                        <h6 class="text-center mb-3">Weekly Appointments</h6>
                                        <canvas id="weeklyChart"></canvas>
                                    </div>
                                </div>
                                <div class="col-md-6 mb-4">
                                    <div class="chart-container">
                                        <h6 class="text-center mb-3">Status Distribution</h6>
                                        <canvas id="statusChart"></canvas>
                                    </div>
                                </div>
                            </div>
                            
                            <div class="mt-4">
                                <h6 class="mb-3">Top Performing Doctors</h6>
                                <div class="table-responsive">
                                    <table class="table table-sm">
                                        <thead>
                                            <tr>
                                                <th>Rank</th>
                                                <th>Doctor</th>
                                                <th>Specialization</th>
                                                <th>Appointments</th>
                                                <th>Rating</th>
                                            </tr>
                                        </thead>
                                        <tbody>
                                            <%
                                                int rank = 1;
                                                if (doctorAppointmentStats != null && !doctorAppointmentStats.isEmpty()) {
                                                    for (Map.Entry<String, Integer> entry : doctorAppointmentStats.entrySet()) {
                                                        if (rank > 5) break;
                                                        String[] doctorInfo = entry.getKey().split("\\|");
                                                        if (doctorInfo.length >= 2) {
                                            %>
                                            <tr>
                                                <td><div class="doctor-rank"><%= rank++ %></div></td>
                                                <td><strong><%= doctorInfo[0] %></strong></td>
                                                <td><%= doctorInfo[1] %></td>
                                                <td><span class="badge bg-primary"><%= entry.getValue() %></span></td>
                                                <td>
                                                    <%
                                                        // Calculate rating based on appointment count (4.0 to 5.0 scale)
                                                        double rating = 4.0 + (entry.getValue() / 100.0);
                                                        if (rating > 5.0) rating = 5.0;
                                                    %>
                                                    <span class="text-warning">
                                                        <i class="fas fa-star"></i> <%= String.format("%.1f", rating) %>
                                                    </span>
                                                </td>
                                            </tr>
                                            <%
                                                        }
                                                    }
                                                } else {
                                            %>
                                            <tr>
                                                <td colspan="5" class="text-center text-muted py-3">
                                                    <div class="empty-state">
                                                        <i class="fas fa-user-md"></i>
                                                        <p>No doctor data available</p>
                                                    </div>
                                                </td>
                                            </tr>
                                            <%
                                                }
                                            %>
                                        </tbody>
                                    </table>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>

                <div class="col-lg-4">
                    <div class="card card-modern mb-4">
                        <div class="card-header-modern">
                            <i class="fas fa-bolt"></i>
                            <span>Quick Actions</span>
                        </div>
                        <div class="card-body">
                            <div class="quick-actions-grid">
                                <a href="${pageContext.request.contextPath}/admin/management?action=view&type=doctors"
                                   class="btn btn-primary-modern">
                                    <i class="fas fa-user-md me-2"></i>Manage Doctors
                                </a>
                                <a href="${pageContext.request.contextPath}/admin/management?action=view&type=patients"
                                   class="btn btn-outline-primary">
                                    <i class="fas fa-users me-2"></i>Manage Patients
                                </a>
                                <a href="${pageContext.request.contextPath}/admin/management?action=view&type=appointments"
                                   class="btn btn-outline-primary">
                                    <i class="fas fa-calendar-alt me-2"></i>Manage Appointments
                                </a>
                            </div>
                        </div>
                    </div>

                    <div class="card card-modern mb-4">
                        <div class="card-header-modern">
                            <i class="fas fa-calendar-day"></i>
                            <span>Today's Appointments</span>
                        </div>
                        <div class="card-body">
                            <%
                                if (todayAppointments != null && !todayAppointments.isEmpty()) {
                                    // Limit to 5 appointments for display
                                    int displayCount = Math.min(todayAppointments.size(), 5);
                                    for (int i = 0; i < displayCount; i++) {
                                        Appointment appt = todayAppointments.get(i);
                                        
                                        // Status handling
                                        String statusToday = appt.getStatus();
                                        String badgeClassToday = "badge-secondary";
                                    
                                        if (statusToday == null || "Pending".equals(statusToday)) {
                                            statusToday = "Pending";
                                            badgeClassToday = "badge-warning";
                                        } else if ("Confirmed".equals(statusToday)) {
                                            badgeClassToday = "badge-success";
                                        } else if ("Completed".equals(statusToday)) {
                                            badgeClassToday = "badge-info";
                                        } else if ("Cancelled".equals(statusToday)) {
                                            badgeClassToday = "badge-danger";
                                        }
                            %>
                            <div class="activity-item">
                                <div class="d-flex justify-content-between align-items-start">
                                    <div>
                                        <strong><%= appt.getPatientName() != null ? appt.getPatientName() : "N/A" %></strong>
                                        <br>
                                        <small class="text-muted">With Dr. <%= appt.getDoctorName() != null ? appt.getDoctorName() : "N/A" %></small>
                                        <br>
                                        <small><%= appt.getAppointmentTime() != null ? appt.getAppointmentTime().toString().substring(0, 5) : "N/A" %></small>
                                    </div>
                                    <span class="badge <%= badgeClassToday %>">
                                        <%= statusToday %>
                                    </span>
                                </div>
                            </div>
                            <%
                                    }
                                } else {
                            %>
                            <div class="empty-state">
                                <i class="fas fa-calendar-times"></i>
                                <h6 class="text-muted">No Appointments</h6>
                                <p class="text-muted mb-0">No appointments scheduled for today</p>
                            </div>
                            <%
                                }
                            %>
                        </div>
                    </div>

                    <div class="card card-modern">
                        <div class="card-header-modern">
                            <i class="fas fa-info-circle"></i>
                            <span>System Information</span>
                        </div>
                        <div class="card-body">
                            <div class="system-info-list">
                                <div class="list-group list-group-flush">
                                    <div class="list-group-item d-flex justify-content-between align-items-center px-0">
                                        <span class="text-muted">System Version</span>
                                        <strong>v1.0.0</strong>
                                    </div>
                                    <div class="list-group-item d-flex justify-content-between align-items-center px-0">
                                        <span class="text-muted">Last Backup</span>
                                        <strong><%= new SimpleDateFormat("MMM dd, yyyy").format(new Date()) %></strong>
                                    </div>
                                    <div class="list-group-item d-flex justify-content-between align-items-center px-0">
                                        <span class="text-muted">Active Users</span>
                                        <strong><%= totalDoctors + totalPatients %></strong>
                                    </div>
                                    <div class="list-group-item d-flex justify-content-between align-items-center px-0">
                                        <span class="text-muted">System Status</span>
                                        <span class="badge badge-success">Online</span>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>

            <div class="row mt-4">
                <div class="col-12">
                    <div class="card card-modern">
                        <div class="card-header-modern card-header-flex">
                            <div>
                                <i class="fas fa-history"></i>
                                <span>Recent Activity</span>
                            </div>
                            <small class="text-muted">Latest 10 activities</small>
                        </div>
                        <div class="card-body">
                            <div class="table-responsive">
                                <table class="table table-sm table-hover">
                                    <thead>
                                        <tr>
                                            <th>Date & Time</th>
                                            <th>Patient</th>
                                            <th>Doctor</th>
                                            <th>Status</th>
                                            <th>Details</th>
                                        </tr>
                                    </thead>
                                    <tbody>
                                        <%
                                            if (recentAppointments != null && !recentAppointments.isEmpty()) {
                                                for (Appointment appt : recentAppointments) {
                                                    
                                                    // Status handling
                                                    String statusRecent = appt.getStatus();
                                                    String badgeClassRecent = "badge-secondary";
                                                
                                                    if (statusRecent == null || "Pending".equals(statusRecent)) {
                                                        statusRecent = "Pending";
                                                        badgeClassRecent = "badge-warning";
                                                    } else if ("Confirmed".equals(statusRecent)) {
                                                        badgeClassRecent = "badge-success";
                                                    } else if ("Completed".equals(statusRecent)) {
                                                        badgeClassRecent = "badge-info";
                                                    } else if ("Cancelled".equals(statusRecent)) {
                                                        badgeClassRecent = "badge-danger";
                                                    }
                                        %>
                                        <tr>
                                            <td>
                                                <small><%= appt.getAppointmentDate() != null ? appt.getAppointmentDate() : "N/A" %></small>
                                                <br>
                                                <small class="text-muted"><%= appt.getAppointmentTime() != null ? appt.getAppointmentTime().toString().substring(0, 5) : "N/A" %></small>
                                            </td>
                                            <td><%= appt.getPatientName() != null ? appt.getPatientName() : "N/A" %></td>
                                            <td>Dr. <%= appt.getDoctorName() != null ? appt.getDoctorName() : "N/A" %></td>
                                            <td>
                                                <span class="badge <%= badgeClassRecent %>">
                                                    <%= statusRecent %>
                                                </span>
                                            </td>
                                            <td>
                                                <small class="text-muted"><%= appt.getDoctorSpecialization() != null ? appt.getDoctorSpecialization() : "General" %></small>
                                            </td>
                                        </tr>
                                        <%
                                                }
                                            } else {
                                        %>
                                        <tr>
                                            <td colspan="5" class="text-center text-muted py-3">
                                                <div class="empty-state">
                                                    <i class="fas fa-inbox"></i>
                                                    <h6 class="text-muted">No Recent Activity</h6>
                                                    <p class="text-muted mb-0">No recent appointments found</p>
                                                </div>
                                            </td>
                                        </tr>
                                        <%
                                            }
                                        %>
                                    </tbody>
                                </table>
                            </div>
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

            // Weekly Appointments Chart - USING REAL DATA
            const weeklyCtx = document.getElementById('weeklyChart').getContext('2d');
            new Chart(weeklyCtx, {
                type: 'line',
                data: {
                    labels: ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'],
                    datasets: [{
                        label: 'Appointments',
                        data: [
                            <%= weeklyAppointments.getOrDefault("Monday", 0) %>,
                            <%= weeklyAppointments.getOrDefault("Tuesday", 0) %>,
                            <%= weeklyAppointments.getOrDefault("Wednesday", 0) %>,
                            <%= weeklyAppointments.getOrDefault("Thursday", 0) %>,
                            <%= weeklyAppointments.getOrDefault("Friday", 0) %>,
                            <%= weeklyAppointments.getOrDefault("Saturday", 0) %>,
                            <%= weeklyAppointments.getOrDefault("Sunday", 0) %>
                        ],
                        backgroundColor: 'rgba(67, 97, 238, 0.1)',
                        borderColor: 'rgba(67, 97, 238, 1)',
                        borderWidth: 2,
                        tension: 0.4,
                        fill: true
                    }]
                },
                options: {
                    responsive: true,
                    maintainAspectRatio: false,
                    plugins: {
                        legend: { display: false }
                    },
                    scales: {
                        y: {
                            beginAtZero: true,
                            grid: { color: 'rgba(0,0,0,0.1)' }
                        },
                        x: {
                            grid: { display: false }
                        }
                    }
                }
            });

            // Status Distribution Chart - USING REAL DATA
            const statusCtx = document.getElementById('statusChart').getContext('2d');
            new Chart(statusCtx, {
                type: 'doughnut',
                data: {
                    labels: ['Pending', 'Confirmed', 'Completed', 'Cancelled'],
                    datasets: [{
                        data: [
                            <%= appointmentStats[1] %>,
                            <%= appointmentStats[2] %>,
                            <%= appointmentStats[3] %>,
                            <%= appointmentStats[4] %>
                        ],
                        backgroundColor: [
                            'rgba(255, 193, 7, 0.8)',
                            'rgba(25, 135, 84, 0.8)',
                            'rgba(13, 202, 240, 0.8)',
                            'rgba(108, 117, 125, 0.8)'
                        ],
                        borderColor: '#fff',
                        borderWidth: 2
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
        });
    </script>
</body>
</html>