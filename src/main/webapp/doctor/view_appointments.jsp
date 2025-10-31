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
    Doctor currentDoctor = (Doctor) session.getAttribute("doctorObj");
    if (currentDoctor == null) {
        response.sendRedirect(request.getContextPath() + "/doctor/login.jsp"); 
        return;
    }

    AppointmentDao appointmentDao = new AppointmentDao();
    PatientDao patientDao = new PatientDao();
    List<Appointment> appointments = appointmentDao.getAppointmentsByDoctorId(currentDoctor.getId());

    Map<Integer, Patient> patientMap = new HashMap<>();
    for (Appointment appointment : appointments) {
        if (!patientMap.containsKey(appointment.getPatientId())) {
            Patient patient = patientDao.getPatientById(appointment.getPatientId());
            patientMap.put(appointment.getPatientId(), patient);
        }
    }

    long pendingCount = appointments.stream().filter(a -> "Pending".equals(a.getStatus()) || a.getStatus() == null).count();
    long confirmedCount = appointments.stream().filter(a -> "Confirmed".equals(a.getStatus())).count();
    long completedCount = appointments.stream().filter(a -> "Completed".equals(a.getStatus())).count();
    long cancelledCount = appointments.stream().filter(a -> "Cancelled".equals(a.getStatus())).count();

    String currentUserRole = "doctor";
    
    // Message handling
    String successMsg = (String) session.getAttribute("successMsg");
    String errorMsg = (String) session.getAttribute("errorMsg");

    if (successMsg != null) {
        session.removeAttribute("successMsg");
    }
    if (errorMsg != null) {
        session.removeAttribute("errorMsg");
    }

    if (request.getAttribute("successMsg") != null) {
        successMsg = (String) request.getAttribute("successMsg");
    }
    if (request.getAttribute("errorMsg") != null) {
        errorMsg = (String) request.getAttribute("errorMsg");
    }
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Doctor Appointments | Patient Care System</title>

    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" rel="stylesheet">
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700&display=swap" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>

    <style>
        :root {
            --primary: #4361ee;
            --primary-light: #eef2ff;
            --primary-dark: #3a56d4;
            --secondary: #6c757d;
            --success: #10b981;
            --info: #0ea5e9;
            --warning: #f59e0b;
            --danger: #ef4444;
            --danger-light: #fef2f2;
            --dark: #1e293b;
            --darker: #0f172a;
            --light: #f8fafc;
            --sidebar-width: 280px;
            --transition: all 0.3s cubic-bezier(0.4, 0, 0.2, 1);
            --border-color: #e2e8f0;
            --border-radius: 12px;
            --shadow-sm: 0 1px 2px 0 rgba(0, 0, 0, 0.05);
            --shadow-md: 0 4px 6px -1px rgba(0, 0, 0, 0.1), 0 2px 4px -1px rgba(0, 0, 0, 0.06);
            --shadow-lg: 0 10px 15px -3px rgba(0, 0, 0, 0.1), 0 4px 6px -2px rgba(0, 0, 0, 0.05);
            --shadow-xl: 0 20px 25px -5px rgba(0, 0, 0, 0.1), 0 10px 10px -5px rgba(0, 0, 0, 0.04);
        }

        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }

        body {
            font-family: 'Inter', sans-serif;
            background: linear-gradient(135deg, #f8fafc 0%, #f1f5f9 100%);
            color: var(--dark);
            line-height: 1.6;
            display: flex;
            min-height: 100vh;
            overflow-x: hidden;
        }

        /* Enhanced Sidebar */
        .sidebar {
            width: var(--sidebar-width);
            flex-shrink: 0;
            background: linear-gradient(180deg, #ffffff 0%, #f8fafc 100%);
            color: var(--dark);
            height: 100vh;
            position: fixed;
            left: 0;
            top: 0;
            overflow-y: auto;
            transition: var(--transition);
            border-right: 1px solid var(--border-color);
            display: flex;
            flex-direction: column;
            z-index: 1000;
            box-shadow: var(--shadow-md);
        }

        .sidebar-sticky {
            display: flex;
            flex-direction: column;
            min-height: 100%;
            padding: 1.5rem 0;
        }

        /* Enhanced User Section */
        .user-section {
            text-align: center;
            padding: 2rem 1.5rem 1.5rem;
            border-bottom: 1px solid var(--border-color);
            margin-bottom: 1rem;
            background: linear-gradient(135deg, var(--primary-light) 0%, #ffffff 100%);
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
            border: 4px solid white;
            box-shadow: var(--shadow-lg);
            transition: var(--transition);
        }

        .user-avatar:hover {
            transform: scale(1.05);
            box-shadow: var(--shadow-xl);
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
        
        .user-info small {
            font-size: 0.85rem;
            color: var(--secondary);
            background: var(--primary-light);
            padding: 0.25rem 0.75rem;
            border-radius: 20px;
            display: inline-block;
        }

        /* Enhanced Navigation */
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
            padding: 0.85rem 1rem;
            color: #64748b;
            text-decoration: none;
            border-radius: var(--border-radius);
            transition: var(--transition);
            font-weight: 500;
            font-size: 0.95rem;
            position: relative;
            overflow: hidden;
            border: 1px solid transparent;
        }

        .nav-link::before {
            content: '';
            position: absolute;
            left: 0;
            top: 50%;
            height: 80%;
            width: 4px;
            background: var(--primary);
            transform: translateY(-50%) scaleY(0);
            transition: var(--transition);
            border-radius: 0 4px 4px 0;
        }

        .nav-link:hover {
            color: var(--primary);
            background: var(--primary-light);
            border-color: var(--primary-light);
            transform: translateX(4px);
        }

        .nav-link.active {
            color: var(--primary);
            background: var(--primary-light);
            font-weight: 600;
            border-color: var(--primary-light);
            box-shadow: var(--shadow-sm);
        }

        .nav-link.active::before {
            transform: translateY(-50%) scaleY(1);
        }

        .nav-link i {
            width: 20px;
            text-align: center;
            font-size: 1.1rem;
            transition: var(--transition);
            color: #94a3b8;
        }

        .nav-link:hover i,
        .nav-link.active i {
            color: var(--primary);
            transform: scale(1.1);
        }

        /* Enhanced Logout Link */
        .nav-link-logout {
            color: var(--danger);
            border: 1px solid transparent;
        }

        .nav-link-logout i {
            color: var(--danger);
        }

        .nav-link-logout:hover {
            background: var(--danger-light);
            color: var(--danger);
            border-color: var(--danger-light);
        }

        /* Main Content Area */
        .main-content {
            flex-grow: 1;
            margin-left: var(--sidebar-width);
            min-height: 100vh;
            overflow-y: auto;
            background: transparent;
            padding-bottom: 2rem;
        }

        /* Enhanced Header */
        .page-header {
            background: linear-gradient(135deg, #ffffff 0%, #f8fafc 100%);
            padding: 2rem 2.5rem;
            border-bottom: 1px solid var(--border-color);
            position: sticky;
            top: 0;
            z-index: 100;
            backdrop-filter: blur(10px);
        }

        .page-title {
            font-weight: 700;
            color: var(--dark);
            font-size: 1.75rem;
            display: flex;
            align-items: center;
            gap: 1rem;
        }

        .page-title i {
            background: linear-gradient(135deg, var(--primary), #5a6ff0);
            -webkit-background-clip: text;
            -webkit-text-fill-color: transparent;
            background-clip: text;
        }

        /* Enhanced Cards */
        .card {
            border: none;
            border-radius: var(--border-radius);
            box-shadow: var(--shadow-sm);
            transition: var(--transition);
            background: white;
        }

        .card:hover {
            box-shadow: var(--shadow-lg);
            transform: translateY(-2px);
        }

        .card-header {
            background: white;
            border-bottom: 1px solid var(--border-color);
            padding: 1.5rem;
            font-weight: 600;
            color: var(--dark);
            border-radius: var(--border-radius) var(--border-radius) 0 0 !important;
        }

        /* Enhanced Stats Cards */
        .stat-card {
            background: linear-gradient(135deg, #ffffff 0%, #f8fafc 100%);
            border: 1px solid var(--border-color);
            border-radius: var(--border-radius);
            padding: 1.5rem;
            text-align: center;
            transition: var(--transition);
            position: relative;
            overflow: hidden;
            height: 100%;
        }

        .stat-card::before {
            content: '';
            position: absolute;
            top: 0;
            left: 0;
            right: 0;
            height: 4px;
            background: var(--primary);
        }

        .stat-card.pending::before { background: var(--warning); }
        .stat-card.confirmed::before { background: var(--info); }
        .stat-card.completed::before { background: var(--success); }
        .stat-card.cancelled::before { background: var(--danger); }

        .stat-card:hover {
            transform: translateY(-4px);
            box-shadow: var(--shadow-lg);
        }

        .stat-number {
            font-size: 2.5rem;
            font-weight: 700;
            margin-bottom: 0.5rem;
            background: linear-gradient(135deg, var(--dark), var(--secondary));
            -webkit-background-clip: text;
            -webkit-text-fill-color: transparent;
            background-clip: text;
        }

        .stat-label {
            color: var(--secondary);
            font-weight: 500;
            font-size: 0.9rem;
            text-transform: uppercase;
            letter-spacing: 0.05em;
        }

        /* Enhanced Buttons */
        .btn {
            display: inline-flex;
            align-items: center;
            justify-content: center;
            gap: 0.5rem;
            padding: 0.75rem 1.5rem;
            font-weight: 600;
            border-radius: var(--border-radius);
            text-decoration: none;
            transition: var(--transition);
            border: none;
            cursor: pointer;
            font-size: 0.95rem;
            position: relative;
            overflow: hidden;
        }

        .btn::before {
            content: '';
            position: absolute;
            top: 50%;
            left: 50%;
            width: 0;
            height: 0;
            background: rgba(255, 255, 255, 0.2);
            border-radius: 50%;
            transition: var(--transition);
            transform: translate(-50%, -50%);
        }

        .btn:hover::before {
            width: 300px;
            height: 300px;
        }

        .btn-primary {
            background: linear-gradient(135deg, var(--primary), #5a6ff0);
            color: white;
            box-shadow: 0 4px 15px rgba(67, 97, 238, 0.3);
        }

        .btn-primary:hover {
            transform: translateY(-2px);
            box-shadow: 0 8px 25px rgba(67, 97, 238, 0.4);
        }

        /* Enhanced Table */
        .table-container {
            background: white;
            border-radius: var(--border-radius);
            box-shadow: var(--shadow-sm);
            overflow: hidden;
            margin: 0;
        }

        .table {
            margin: 0;
            border-collapse: separate;
            border-spacing: 0;
            width: 100%;
        }

        .table thead th {
            background: linear-gradient(135deg, #f8fafc 0%, #f1f5f9 100%);
            border-bottom: 2px solid var(--border-color);
            padding: 1.25rem 1rem;
            font-weight: 600;
            color: var(--dark);
            text-transform: uppercase;
            font-size: 0.8rem;
            letter-spacing: 0.05em;
            position: sticky;
            top: 0;
            z-index: 10;
        }

        .table tbody tr {
            transition: var(--transition);
        }

        .table tbody tr:hover {
            background: linear-gradient(135deg, #f8fafc 0%, #f1f5f9 100%);
        }

        .table tbody td {
            padding: 1.25rem 1rem;
            border-bottom: 1px solid var(--border-color);
            vertical-align: middle;
        }

        /* Enhanced Badges */
        .badge {
            padding: 0.5rem 1rem;
            font-weight: 600;
            border-radius: 20px;
            font-size: 0.8rem;
            display: inline-flex;
            align-items: center;
            gap: 0.25rem;
            border: 1px solid transparent;
        }

        .badge-pending {
            background: linear-gradient(135deg, #fef3c7, #f59e0b);
            color: #92400e;
            border-color: #f59e0b;
        }

        .badge-confirmed {
            background: linear-gradient(135deg, #d1fae5, #10b981);
            color: #065f46;
            border-color: #10b981;
        }

        .badge-completed {
            background: linear-gradient(135deg, #dbeafe, #3b82f6);
            color: #1e40af;
            border-color: #3b82f6;
        }

        .badge-cancelled {
            background: linear-gradient(135deg, #fee2e2, #ef4444);
            color: #991b1b;
            border-color: #ef4444;
        }

        /* Enhanced Modal */
        .modal-content {
            border: none;
            border-radius: var(--border-radius);
            box-shadow: var(--shadow-xl);
            overflow: hidden;
        }

        .modal-header {
            background: linear-gradient(135deg, #f8fafc 0%, #f1f5f9 100%);
            border-bottom: 1px solid var(--border-color);
            padding: 1.5rem;
        }

        .modal-body {
            padding: 2rem;
        }

        /* Responsive Design */
        @media (max-width: 992px) {
            .page-header {
                padding: 1.5rem;
            }
            
            .table-container {
                overflow-x: auto;
            }
            
            .table {
                min-width: 900px;
            }
        }

        @media (max-width: 768px) {
            .sidebar {
                transform: translateX(-100%);
                z-index: 1050;
            }
            .sidebar.mobile-open {
                transform: translateX(0);
            }
            .main-content {
                margin-left: 0;
                width: 100%;
            }
            .page-header {
                padding: 1.5rem;
            }
            .mobile-menu-toggle {
                display: flex !important;
                position: fixed;
                top: 1.5rem;
                left: 1.5rem;
                z-index: 999;
                background: var(--primary);
                color: white;
                border: none;
                width: 50px;
                height: 50px;
                border-radius: var(--border-radius);
                align-items: center;
                justify-content: center;
                font-size: 1.25rem;
                cursor: pointer;
                box-shadow: var(--shadow-lg);
                transition: var(--transition);
            }
            .mobile-menu-toggle:hover {
                transform: scale(1.1);
            }
            
            .stat-card {
                margin-bottom: 1rem;
            }
            
            .card-header {
                padding: 1rem;
            }
            
            .btn-group .btn {
                margin-bottom: 0.25rem;
            }
        }

        @media (max-width: 576px) {
            .container-fluid {
                padding-left: 1rem;
                padding-right: 1rem;
            }
            
            .page-header {
                padding: 1rem;
            }
            
            .page-title {
                font-size: 1.5rem;
            }
            
            .card-body {
                padding: 1rem;
            }
        }

        /* Loading Animation */
        @keyframes fadeIn {
            from { opacity: 0; transform: translateY(20px); }
            to { opacity: 1; transform: translateY(0); }
        }

        .fade-in {
            animation: fadeIn 0.6s ease-out;
        }

        /* Scrollbar Styling */
        ::-webkit-scrollbar {
            width: 6px;
        }

        ::-webkit-scrollbar-track {
            background: #f1f5f9;
        }

        ::-webkit-scrollbar-thumb {
            background: #cbd5e1;
            border-radius: 3px;
        }

        ::-webkit-scrollbar-thumb:hover {
            background: #94a3b8;
        }
        
        /* Action buttons styling */
        .action-buttons {
            display: flex;
            gap: 0.5rem;
            flex-wrap: wrap;
        }
        
        .action-buttons .btn {
            white-space: nowrap;
        }
        
        /* Status dropdown improvements */
        .dropdown-menu {
            border: none;
            box-shadow: var(--shadow-lg);
            border-radius: var(--border-radius);
            padding: 0.5rem;
        }
        
        .dropdown-item {
            padding: 0.75rem 1rem;
            border-radius: 8px;
            margin-bottom: 0.25rem;
            transition: var(--transition);
        }
        
        .dropdown-item:hover {
            background: var(--primary-light);
        }
        
        /* Icon box for table */
        .icon-box {
            width: 40px;
            height: 40px;
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
        }
        
        .icon-primary {
            background: var(--primary-light);
            color: var(--primary);
        }
        
        /* Overlay for mobile sidebar */
        .sidebar-overlay {
            display: none;
            position: fixed;
            top: 0;
            left: 0;
            right: 0;
            bottom: 0;
            background: rgba(0, 0, 0, 0.5);
            z-index: 1040;
        }
        
        .sidebar-overlay.active {
            display: block;
        }
    </style>
</head>
<body>
    <!-- Mobile Menu Toggle -->
    <button class="mobile-menu-toggle" id="mobileMenuToggle" style="display: none;">
        <i class="fas fa-bars"></i>
    </button>
    
    <!-- Sidebar Overlay for Mobile -->
    <div class="sidebar-overlay" id="sidebarOverlay"></div>

    <!-- Enhanced Sidebar -->
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
                            <i class="fas fa-calendar-check"></i>
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

    <!-- Main Content -->
    <main class="main-content">
        <!-- Enhanced Header -->
        <div class="page-header">
            <div class="container-fluid">
                <div class="row align-items-center">
                    <div class="col-md-8">
                        <h1 class="page-title">
                            <i class="fas fa-calendar-check"></i>
                            My Appointments
                        </h1>
                        <p class="text-muted mb-0">Manage and track all your patient appointments</p>
                    </div>
                    <div class="col-md-4 text-md-end mt-3 mt-md-0">
                        <span class="badge bg-primary fs-6 p-3">
                            <i class="fas fa-calendar-check me-2"></i>
                            <%= appointments.size() %> Total Appointments
                        </span>
                    </div>
                </div>
            </div>
        </div>

        <!-- Main Content Area -->
        <div class="container-fluid py-4">
            <!-- Messages -->
            <% if (successMsg != null && !successMsg.isEmpty()) { %>
                <div class="alert alert-success alert-dismissible fade show fade-in" role="alert">
                    <div class="d-flex align-items-center">
                        <i class="fas fa-check-circle me-3 fs-5"></i>
                        <div class="flex-grow-1">
                            <strong>Success!</strong> <%= successMsg %>
                        </div>
                    </div>
                    <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                </div>
            <% } %>
            
            <% if (errorMsg != null && !errorMsg.isEmpty()) { %>
                <div class="alert alert-danger alert-dismissible fade show fade-in" role="alert">
                    <div class="d-flex align-items-center">
                        <i class="fas fa-exclamation-triangle me-3 fs-5"></i>
                        <div class="flex-grow-1">
                            <strong>Attention!</strong> <%= errorMsg %>
                        </div>
                    </div>
                    <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                </div>
            <% } %>

            <!-- Stats Cards -->
            <div class="row g-4 mb-4 fade-in">
                <div class="col-xl-3 col-md-6">
                    <div class="stat-card pending">
                        <div class="stat-number"><%= pendingCount %></div>
                        <div class="stat-label">Pending</div>
                        <i class="fas fa-clock mt-3 fs-2 text-warning"></i>
                    </div>
                </div>
                <div class="col-xl-3 col-md-6">
                    <div class="stat-card confirmed">
                        <div class="stat-number"><%= confirmedCount %></div>
                        <div class="stat-label">Confirmed</div>
                        <i class="fas fa-check-circle mt-3 fs-2 text-info"></i>
                    </div>
                </div>
                <div class="col-xl-3 col-md-6">
                    <div class="stat-card completed">
                        <div class="stat-number"><%= completedCount %></div>
                        <div class="stat-label">Completed</div>
                        <i class="fas fa-calendar-check mt-3 fs-2 text-success"></i>
                    </div>
                </div>
                <div class="col-xl-3 col-md-6">
                    <div class="stat-card cancelled">
                        <div class="stat-number"><%= cancelledCount %></div>
                        <div class="stat-label">Cancelled</div>
                        <i class="fas fa-times-circle mt-3 fs-2 text-danger"></i>
                    </div>
                </div>
            </div>

            <!-- Filters Card -->
            <div class="card fade-in mb-4">
                <div class="card-body">
                    <div class="row g-3 align-items-end">
                        <div class="col-lg-4 col-md-6">
                            <label class="form-label fw-semibold">Filter by Status</label>
                            <div class="input-group">
                                <span class="input-group-text bg-light border-end-0">
                                    <i class="fas fa-filter text-primary"></i>
                                </span>
                                <select class="form-select border-start-0" id="statusFilter">
                                    <option value="all" selected>All Statuses</option>
                                    <option value="Pending">Pending</option>
                                    <option value="Confirmed">Confirmed</option>
                                    <option value="Completed">Completed</option>
                                    <option value="Cancelled">Cancelled</option>
                                </select>
                            </div>
                        </div>
                        <div class="col-lg-4 col-md-6">
                            <label class="form-label fw-semibold">Search Patient</label>
                            <div class="input-group">
                                <span class="input-group-text bg-light border-end-0">
                                    <i class="fas fa-search text-primary"></i>
                                </span>
                                <input type="text" class="form-control border-start-0" id="searchPatient" 
                                       placeholder="Search by patient name...">
                            </div>
                        </div>
                        <div class="col-lg-4 col-md-12">
                            <button type="button" id="clearFilters" class="btn btn-outline-primary w-100">
                                <i class="fas fa-eraser me-2"></i>Clear Filters
                            </button>
                        </div>
                    </div>
                </div>
            </div>

            <!-- Appointments Table -->
            <div class="card fade-in">
                <div class="card-header">
                    <div class="row align-items-center">
                        <div class="col">
                            <h5 class="mb-0">
                                <i class="fas fa-list me-2 text-primary"></i>Appointment List
                            </h5>
                        </div>
                        <div class="col-auto">
                            <span class="badge bg-light text-dark fs-6">
                                <i class="fas fa-user-md me-2 text-primary"></i>Dr. <%= currentDoctor.getFullName() %>
                            </span>
                        </div>
                    </div>
                </div>
                <div class="card-body p-0">
                    <%
                        if (appointments.isEmpty()) {
                    %>
                        <div class="text-center py-5">
                            <i class="fas fa-calendar-times fa-4x text-muted mb-4"></i>
                            <h4 class="text-muted mb-3">No Appointments Found</h4>
                            <p class="text-muted mb-4">You don't have any appointments scheduled yet.</p>
                            <a href="${pageContext.request.contextPath}/doctor/dashboard.jsp" class="btn btn-primary">
                                <i class="fas fa-tachometer-alt me-2"></i>Back to Dashboard
                            </a>
                        </div>
                    <%
                        } else {
                    %>
                        <div class="table-container">
                            <div class="table-responsive">
                                <table class="table table-hover mb-0" id="appointmentsTable">
                                    <thead>
                                        <tr>
                                            <th>Patient Details</th>
                                            <th>Contact Info</th>
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
                                                String status = appointment.getStatus();
                                                if (status == null) {
                                                    status = "Pending";
                                                }

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
                                                    default:
                                                        statusBadgeClass = "badge-pending";
                                                        statusIcon = "fas fa-clock";
                                                }
                                                
                                                Patient patient = patientMap.get(appointment.getPatientId());
                                                String patientPhone = "N/A";
                                                String patientEmail = "N/A";
                                                
                                                if (patient != null) {
                                                    patientPhone = patient.getPhone() != null ? patient.getPhone() : "N/A";
                                                    patientEmail = patient.getEmail() != null ? patient.getEmail() : "N/A";
                                                }
                                        %>
                                            <tr data-status="<%= status.toLowerCase() %>" data-patient="<%= appointment.getPatientName().toLowerCase() %>">
                                                <td>
                                                    <div class="d-flex align-items-center">
                                                        <div class="icon-box icon-primary me-3">
                                                            <i class="fas fa-user"></i>
                                                        </div>
                                                        <div>
                                                            <strong class="d-block"><%= appointment.getPatientName() %></strong>
                                                            <small class="text-muted">ID: PAT<%= appointment.getPatientId() %></small>
                                                        </div>
                                                    </div>
                                                </td>
                                                <td>
                                                    <div class="text-muted">
                                                        <div class="mb-1">
                                                            <i class="fas fa-phone me-2"></i> 
                                                            <span class="small"><%= patientPhone %></span>
                                                        </div>
                                                        <div>
                                                            <i class="fas fa-envelope me-2"></i> 
                                                            <span class="small"><%= patientEmail %></span>
                                                        </div>
                                                    </div>
                                                </td>
                                                <td>
                                                    <strong class="d-block"><%= appointment.getAppointmentDate() %></strong>
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
                                                    <span class="text-truncate d-inline-block" style="max-width: 200px;" 
                                                          data-bs-toggle="tooltip" title="<%= appointment.getReason() %>">
                                                        <%= appointment.getReason().length() > 50 ? appointment.getReason().substring(0, 50) + "..." : appointment.getReason() %>
                                                    </span>
                                                </td>
                                                <td>
                                                    <span class="badge <%= statusBadgeClass %> mb-1">
                                                        <i class="<%= statusIcon %> me-1"></i>
                                                        <%= status %>
                                                    </span>
                                                    <%
                                                        if (appointment.isFollowUpRequired()) {
                                                    %>
                                                        <br>
                                                        <small class="text-warning d-block mt-1">
                                                            <i class="fas fa-redo me-1"></i>Follow-up Required
                                                        </small>
                                                    <%
                                                        }
                                                    %>
                                                </td>
                                                <td>
                                                    <div class="action-buttons">
                                                        <a href="${pageContext.request.contextPath}/doctor/appointment?action=details&id=<%= appointment.getId() %>"
                                                           class="btn btn-outline-primary btn-sm" data-bs-toggle="tooltip" title="View Details">
                                                            <i class="fas fa-eye"></i>
                                                        </a>
                                                        <%
                                                            if (!"Completed".equals(status) && !"Cancelled".equals(status)) {
                                                        %>
                                                            <div class="dropdown">
                                                                <button class="btn btn-outline-warning btn-sm dropdown-toggle" type="button"
                                                                        id="dropdownMenuButton<%= appointment.getId() %>" data-bs-toggle="dropdown" 
                                                                        aria-expanded="false" data-bs-toggle="tooltip" title="Update Status">
                                                                    <i class="fas fa-edit"></i>
                                                                </button>
                                                                <ul class="dropdown-menu dropdown-menu-end" aria-labelledby="dropdownMenuButton<%= appointment.getId() %>">
                                                                    <%
                                                                        if (!"Confirmed".equals(status)) {
                                                                    %>
                                                                        <li>
                                                                            <form action="${pageContext.request.contextPath}/doctor/appointment?action=updateStatus" method="post" class="d-inline">
                                                                                <input type="hidden" name="appointmentId" value="<%= appointment.getId() %>">
                                                                                <input type="hidden" name="status" value="Confirmed">
                                                                                <button type="submit" class="dropdown-item text-success">
                                                                                    <i class="fas fa-check me-2"></i>Confirm Appointment
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
                                                                                    <i class="fas fa-calendar-check me-2"></i>Mark as Completed
                                                                                </button>
                                                                            </form>
                                                                        </li>
                                                                    <%
                                                                        }
                                                                    %>
                                                                    <li>
                                                                        <form action="${pageContext.request.contextPath}/doctor/appointment?action=updateStatus" method="post" class="d-inline" id="cancelForm<%= appointment.getId() %>">
                                                                            <input type="hidden" name="appointmentId" value="<%= appointment.getId() %>">
                                                                            <input type="hidden" name="status" value="Cancelled">
                                                                            <button type="button" class="dropdown-item text-danger cancel-appointment-btn"
                                                                                    data-bs-toggle="modal"
                                                                                    data-bs-target="#deleteConfirmModal"
                                                                                    data-form-id="cancelForm<%= appointment.getId() %>"
                                                                                    data-item-name="Appointment #<%= appointment.getId() %>">
                                                                                <i class="fas fa-times me-2"></i>Cancel Appointment
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
                                                                                <%= appointment.isFollowUpRequired() ? "Remove Follow-up" : "Mark for Follow-up" %>
                                                                            </button>
                                                                        </form>
                                                                    </li>
                                                                </ul>
                                                            </div>
                                                        <%
                                                        }
                                                    %>
                                                </td>
                                            </tr>
                                        <%
                                            }
                                        %>
                                    </tbody>
                                </table>
                            </div>
                        </div>
                    <%
                    }
                %>
                </div>
            </div>
        </div>
    </main>

    <!-- Enhanced Modal -->
    <div class="modal fade" id="deleteConfirmModal" tabindex="-1" aria-labelledby="deleteModalLabel" aria-hidden="true">
        <div class="modal-dialog modal-dialog-centered">
            <div class="modal-content">
                <div class="modal-header">
                    <h5 class="modal-title text-danger" id="deleteModalLabel">
                        <i class="fas fa-exclamation-triangle me-2"></i>Confirm Cancellation
                    </h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                </div>
                <div class="modal-body text-center py-4">
                    <div class="delete-modal-icon mb-3">
                        <i class="fas fa-exclamation-triangle fa-3x text-danger"></i>
                    </div>
                    <h4 class="mb-3">Cancel Appointment?</h4>
                    <p class="text-muted">Are you sure you want to cancel <strong id="itemNameToDelete" class="text-danger">this appointment</strong>?</p>
                    <p class="text-muted small">This action cannot be undone and will notify the patient.</p>
                </div>
                <div class="modal-footer justify-content-center">
                    <button type="button" class="btn btn-outline-secondary px-4" data-bs-dismiss="modal">
                        <i class="fas fa-times me-2"></i>Keep Appointment
                    </button>
                    <button type="button" class="btn btn-danger px-4" id="modalConfirmDeleteButton">
                        <i class="fas fa-check me-2"></i>Yes, Cancel
                    </button>
                </div>
            </div>
        </div>
    </div>

    <script>
        document.addEventListener('DOMContentLoaded', function() {
            // Mobile menu functionality
            const mobileMenuToggle = document.getElementById('mobileMenuToggle');
            const sidebar = document.getElementById('sidebar');
            const sidebarOverlay = document.getElementById('sidebarOverlay');

            function checkScreenSize() {
                if (window.innerWidth <= 768) {
                    mobileMenuToggle.style.display = 'flex';
                    sidebar.classList.remove('mobile-open');
                    sidebarOverlay.classList.remove('active');
                } else {
                    mobileMenuToggle.style.display = 'none';
                    sidebar.classList.remove('mobile-open');
                    sidebarOverlay.classList.remove('active');
                }
            }

            checkScreenSize();
            window.addEventListener('resize', checkScreenSize);

            mobileMenuToggle.addEventListener('click', function() {
                sidebar.classList.toggle('mobile-open');
                sidebarOverlay.classList.toggle('active');
                this.innerHTML = sidebar.classList.contains('mobile-open') ? 
                    '<i class="fas fa-times"></i>' : '<i class="fas fa-bars"></i>';
            });
            
            sidebarOverlay.addEventListener('click', function() {
                sidebar.classList.remove('mobile-open');
                sidebarOverlay.classList.remove('active');
                mobileMenuToggle.innerHTML = '<i class="fas fa-bars"></i>';
            });

            // Auto-hide alerts
            const alerts = document.querySelectorAll('.alert');
            alerts.forEach(alert => {
                setTimeout(() => {
                    const bsAlert = new bootstrap.Alert(alert);
                    bsAlert.close();
                }, 5000);
            });

            // Initialize tooltips
            const tooltipTriggerList = [].slice.call(document.querySelectorAll('[data-bs-toggle="tooltip"]'));
            const tooltipList = tooltipTriggerList.map(function (tooltipTriggerEl) {
                return new bootstrap.Tooltip(tooltipTriggerEl);
            });

            // Filter functionality
            const statusFilter = document.getElementById('statusFilter');
            const searchPatient = document.getElementById('searchPatient');
            const clearFilters = document.getElementById('clearFilters');
            const tableRows = document.querySelectorAll('#appointmentsTable tbody tr');

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
                    statusFilter.value = 'all';
                    searchPatient.value = '';
                    filterAppointments();
                });
            }

            // Enhanced modal functionality
            const deleteConfirmModal = document.getElementById('deleteConfirmModal');
            let formToSubmit = null;

            if (deleteConfirmModal) {
                deleteConfirmModal.addEventListener('show.bs.modal', function (event) {
                    const button = event.relatedTarget;
                    const formId = button.getAttribute('data-form-id');
                    const itemName = button.getAttribute('data-item-name');
                    
                    formToSubmit = document.getElementById(formId);
                    
                    const modalItemNameElement = document.getElementById('itemNameToDelete');
                    modalItemNameElement.textContent = itemName ? `${itemName}` : 'this appointment';
                });

                const modalConfirmDeleteButton = document.getElementById('modalConfirmDeleteButton');
                if (modalConfirmDeleteButton) {
                    modalConfirmDeleteButton.addEventListener('click', function () {
                        if (formToSubmit) {
                            formToSubmit.submit();
                        }
                    });
                }
            }

            // Add smooth animations
            const observerOptions = {
                threshold: 0.1,
                rootMargin: '0px 0px -50px 0px'
            };

            const observer = new IntersectionObserver((entries) => {
                entries.forEach(entry => {
                    if (entry.isIntersecting) {
                        entry.target.style.opacity = '1';
                        entry.target.style.transform = 'translateY(0)';
                    }
                });
            }, observerOptions);

            // Observe elements for animation
            document.querySelectorAll('.card, .stat-card').forEach(el => {
                el.style.opacity = '0';
                el.style.transform = 'translateY(20px)';
                el.style.transition = 'opacity 0.6s ease, transform 0.6s ease';
                observer.observe(el);
            });
        });
    </script>
</body>
</html>