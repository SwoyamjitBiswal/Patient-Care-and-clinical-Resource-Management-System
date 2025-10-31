<%@ page import="com.entity.Admin" %>
<%@ page import="com.dao.AppointmentDao" %>
<%@ page import="com.dao.DoctorDao" %>
<%@ page import="com.dao.PatientDao" %>
<%@ page import="com.entity.Appointment" %>
<%@ page import="com.entity.Doctor" %>
<%@ page import="com.entity.Patient" %>
<%@ page import="java.util.List" %>
<%@ page import="java.util.Set" %>
<%@ page import="java.util.HashSet" %>
<%@ page import="java.text.SimpleDateFormat" %>
<%@ page import="java.util.Map" %>
<%@ page import="java.util.LinkedHashMap" %>
<%
    // Admin authentication
    Admin currentAdmin = (Admin) session.getAttribute("adminObj");
    if (currentAdmin == null) {
        response.sendRedirect(request.getContextPath() + "/admin/login.jsp");
        return;
    }

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

    // Data initialization
    AppointmentDao appointmentDao = new AppointmentDao();
    DoctorDao doctorDao = new DoctorDao();
    PatientDao patientDao = new PatientDao();

    int[] appointmentStats = appointmentDao.getAppointmentStats();
    int totalDoctors = doctorDao.getTotalDoctors();
    int totalPatients = patientDao.getTotalPatients();
    
    List<Appointment> appointments = appointmentDao.getAllAppointments();

    // Calculate counts
    long pendingCount = appointments.stream().filter(a -> a.getStatus() == null || "Pending".equals(a.getStatus())).count();
    long confirmedCount = appointments.stream().filter(a -> "Confirmed".equals(a.getStatus())).count();
    long completedCount = appointments.stream().filter(a -> "Completed".equals(a.getStatus())).count();
    long cancelledCount = appointments.stream().filter(a -> "Cancelled".equals(a.getStatus())).count();
    long followUpCount = appointments.stream().filter(Appointment::isFollowUpRequired).count();

    String currentUserRole = "admin";
    
    SimpleDateFormat dateFormat = new SimpleDateFormat("yyyy-MM-dd");
    SimpleDateFormat timeFormat = new SimpleDateFormat("HH:mm");
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Patient Care System - Manage Appointments</title>

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
        
        .input-group-text.align-items-start {
            align-items: flex-start;
            padding-top: 0.875rem;
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
        
        .btn-outline-warning {
            border: 2px solid var(--warning);
            color: var(--warning);
            background: transparent;
            font-weight: 500;
        }
        
        .btn-outline-warning:hover {
            background: var(--warning);
            color: var(--gray-800);
            transform: translateY(-2px);
            box-shadow: 0 4px 12px rgba(255, 193, 7, 0.2);
        }
        
        .btn-outline-danger {
            border: 2px solid var(--danger);
            color: var(--danger);
            background: transparent;
            font-weight: 500;
        }
        
        .btn-outline-danger:hover {
            background: var(--danger);
            color: white;
            transform: translateY(-2px);
            box-shadow: 0 4px 12px rgba(220, 53, 69, 0.2);
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
        
        .badge-pending { color: #92400e; background-color: #fef3c7; }
        .badge-confirmed { color: #065f46; background-color: #d1fae5; }
        .badge-completed { color: #1e40af; background-color: #dbeafe; }
        .badge-cancelled { color: #991b1b; background-color: #fee2e2; }
        
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
        
        /* Alert Styles */
        .alert-modern {
            border-radius: 10px;
            border: none;
            box-shadow: var(--shadow-sm);
            padding: 1rem 1.5rem;
        }
        
        /* Modal Styles */
        .modal-content {
            border-radius: var(--border-radius);
            border: none;
            box-shadow: var(--shadow-lg);
        }
        
        .modal-header {
            padding: 1.5rem;
            border-bottom: 1px solid var(--gray-200);
        }
        
        .modal-title {
            font-size: 1.5rem;
            font-weight: 600;
            color: var(--gray-800);
        }
        
        .modal-body {
            padding: 1.5rem;
        }
        
        .modal-footer {
            padding: 1.5rem;
            border-top: 1px solid var(--gray-200);
            gap: 0.75rem;
        }
        
        /* Delete Modal */
        .delete-modal-icon {
            width: 70px; 
            height: 70px;
            background-color: var(--danger-light);
            color: var(--danger);
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
            margin: 0 auto 1.5rem;
        }

        #deleteConfirmModal .modal-content {
            border-radius: var(--border-radius);
            border: none;
            box-shadow: var(--shadow-xl);
            max-width: 400px;
            margin: auto;
            overflow: hidden;
        }
        
        #deleteConfirmModal .modal-header {
            border-bottom: none;
            padding: 1.5rem 1.5rem 0.5rem;
        }
        
        #deleteConfirmModal .modal-header .btn-close {
            position: absolute; 
            top: 1rem;
            right: 1rem;
        }

        #deleteConfirmModal .modal-body {
            padding: 0.5rem 2rem 1.5rem;
            text-align: center;
        }
        
        #deleteConfirmModal .modal-body h4 {
            font-weight: 600;
            color: var(--dark);
            margin-bottom: 0.75rem;
        }

        #deleteConfirmModal .modal-footer {
            border-top: none;
            padding: 0 2rem 2rem;
            justify-content: center;
            gap: 1rem;
        }
        
        #deleteConfirmModal .modal-footer .btn {
            flex-grow: 1;
            padding: 0.6rem 1rem;
            font-weight: 500;
        }
        
        /* Appointment Details Layout */
        .appointment-details {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(280px, 1fr));
            gap: 1rem;
        }
        
        .detail-section {
            background: var(--gray-100);
            border-radius: var(--border-radius);
            padding: 1.25rem;
        }
        
        .detail-section h5 {
            font-size: 1rem;
            font-weight: 600;
            margin-bottom: 0.75rem;
            color: var(--gray-800);
            display: flex;
            align-items: center;
            gap: 0.5rem;
            padding-bottom: 0.5rem;
            border-bottom: 1px solid var(--gray-200);
        }
        
        .detail-item {
            display: flex;
            justify-content: space-between;
            align-items: center;
            padding: 0.5rem 0;
            min-height: 2.5rem;
        }
        
        .detail-item:not(:last-child) {
            border-bottom: 1px solid var(--gray-200);
        }
        
        .detail-label {
            font-weight: 500;
            color: var(--gray-700);
            font-size: 0.9rem;
            flex-shrink: 0;
        }
        
        .detail-value {
            color: var(--gray-800);
            text-align: right;
            font-size: 0.9rem;
            flex: 1;
            margin-left: 1rem;
            display: flex;
            justify-content: flex-end;
            align-items: center;
            min-height: 1.5rem;
        }
        
        /* Edit Form Styles */
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
        
        .form-row-spaced > [class*="col-"] {
            margin-bottom: 1.25rem;
        }
        
        /* Action buttons container */
        .action-buttons {
            display: flex;
            gap: 0.5rem;
            flex-wrap: wrap;
        }
        
        /* Status indicator */
        .status-indicator {
            display: inline-flex;
            align-items: center;
            gap: 0.5rem;
        }
        
        /* Loading state */
        .loading {
            opacity: 0.7;
            pointer-events: none;
        }
        
        /* Empty state */
        .empty-state {
            text-align: center;
            padding: 3rem 1rem;
        }
        
        .empty-state i {
            font-size: 4rem;
            color: var(--gray-400);
            margin-bottom: 1rem;
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
                        <a class="nav-link active" href="${pageContext.request.contextPath}/admin/management?action=view&type=appointments">
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
            <div class="d-flex justify-content-between align-items-center">
                <div>
                    <h1 class="h2 mb-2">
                        <i class="fas fa-calendar-alt me-2"></i>
                        Manage Appointments
                    </h1>
                    <p class="mb-0 opacity-75">View and manage all patient appointments</p>
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
                if (successMsg != null && !successMsg.isEmpty()) {
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
                if (errorMsg != null && !errorMsg.isEmpty()) {
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
                        <h4 class="mb-1"><%= appointments.size() %></h4>
                        <small>Total Appointments</small>
                    </div>
                </div>
                <div class="col-xl-3 col-md-6 mb-4">
                    <div class="stats-card stats-card-warning">
                        <h4 class="mb-1"><%= pendingCount %></h4>
                        <small>Pending</small>
                    </div>
                </div>
                <div class="col-xl-3 col-md-6 mb-4">
                    <div class="stats-card stats-card-success">
                        <h4 class="mb-1"><%= confirmedCount %></h4>
                        <small>Confirmed</small>
                    </div>
                </div>
                <div class="col-xl-3 col-md-6 mb-4">
                    <div class="stats-card stats-card-info">
                        <h4 class="mb-1"><%= completedCount %></h4>
                        <small>Completed</small>
                    </div>
                </div>
            </div>

            <%-- Filter Card --%>
            <div class="card card-modern mb-4">
                <div class="card-header-modern">
                    <i class="fas fa-filter"></i>
                    <span>Filter Appointments</span>
                </div>
                <div class="card-body p-4">
                    <div class="row align-items-end">
                        <div class="col-md-3">
                            <label class="form-label" for="statusFilter">Status</label>
                            <div class="input-group">
                                <span class="input-group-text">
                                    <i class="fas fa-tag text-primary"></i>
                                </span>
                                <select class="form-select" id="statusFilter">
                                    <option value="all" selected>All Statuses</option>
                                    <option value="pending">Pending</option>
                                    <option value="confirmed">Confirmed</option>
                                    <option value="completed">Completed</option>
                                    <option value="cancelled">Cancelled</option>
                                </select>
                            </div>
                        </div>
                        <div class="col-md-3">
                            <label class="form-label" for="doctorFilter">Doctor</label>
                            <div class="input-group">
                                <span class="input-group-text">
                                    <i class="fas fa-user-md text-primary"></i>
                                </span>
                                <select class="form-select" id="doctorFilter">
                                    <option value="all" selected>All Doctors</option>
                                    <%
                                        Set<String> doctorNames = new HashSet<>();
                                        for (Appointment app : appointments) {
                                            doctorNames.add(app.getDoctorName());
                                        }
                                        for (String doctorName : doctorNames) {
                                    %>
                                        <option value="<%= doctorName.toLowerCase() %>">Dr. <%= doctorName %></option>
                                    <%
                                        }
                                    %>
                                </select>
                            </div>
                        </div>
                        <div class="col-md-3">
                            <label class="form-label" for="dateFilter">Date</label>
                            <div class="input-group">
                                <span class="input-group-text">
                                    <i class="fas fa-calendar text-primary"></i>
                                </span>
                                <input type="date" class="form-control" id="dateFilter">
                            </div>
                        </div>
                        <div class="col-md-3">
                            <button type="button" id="clearFilters" class="btn btn-outline-secondary w-100 py-2">
                                <i class="fas fa-eraser me-2"></i>Clear Filters
                            </button>
                        </div>
                    </div>
                </div>
            </div>

            <%-- Appointments Table --%>
            <div class="card card-modern">
                <div class="card-header-modern d-flex justify-content-between align-items-center">
                    <div>
                        <i class="fas fa-list"></i>
                        <span>All Appointments</span>
                        <span class="badge bg-primary ms-2"><%= appointments.size() %> Total</span>
                    </div>
                    <div>
                        <button class="btn btn-sm btn-outline-primary" id="exportBtn">
                            <i class="fas fa-download me-1"></i>Export
                        </button>
                    </div>
                </div>
                <div class="card-body p-4">
                    <%
                        if (appointments.isEmpty()) {
                    %>
                        <div class="empty-state">
                            <i class="fas fa-calendar-times"></i>
                            <h4 class="text-muted">No Appointments Found</h4>
                            <p class="text-muted">No appointments match the current filters or none exist.</p>
                        </div>
                    <%
                        } else {
                    %>
                        <div class="table-responsive">
                            <table class="table table-hover" id="appointmentsTable">
                                <thead>
                                    <tr>
                                        <th>Appt. ID</th>
                                        <th>Patient</th>
                                        <th>Doctor</th>
                                        <th>Date & Time</th>
                                        <th>Type</th>
                                        <th>Status</th>
                                        <th>Actions</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <%
                                        for (Appointment appointment : appointments) {
                                            String statusBadgeClass = "";
                                            String statusIcon = "";
                                            String status = appointment.getStatus();

                                            if ("Confirmed".equals(status)) {
                                                statusBadgeClass = "badge-confirmed";
                                                statusIcon = "fas fa-check-circle";
                                            } else if ("Completed".equals(status)) {
                                                statusBadgeClass = "badge-completed";
                                                statusIcon = "fas fa-calendar-check";
                                            } else if ("Cancelled".equals(status)) {
                                                statusBadgeClass = "badge-cancelled";
                                                statusIcon = "fas fa-times-circle";
                                            } else {
                                                status = "Pending";
                                                statusBadgeClass = "badge-pending";
                                                statusIcon = "fas fa-clock";
                                            }
                                            
                                            String createdAtFormatted = "";
                                            if (appointment.getCreatedAt() != null) {
                                                createdAtFormatted = dateFormat.format(appointment.getCreatedAt());
                                            }
                                    %>
                                        <tr data-status="<%= status.toLowerCase() %>"
                                            data-doctor="<%= appointment.getDoctorName().toLowerCase() %>"
                                            data-date="<%= appointment.getAppointmentDate() %>">
                                            <td>
                                                <strong>#<%= appointment.getId() %></strong><br>
                                                <small class="text-muted"><%= createdAtFormatted %></small>
                                            </td>
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
                                                <div class="d-flex align-items-center">
                                                    <div class="icon-box icon-success me-3 d-none d-md-flex">
                                                        <i class="fas fa-user-md"></i>
                                                    </div>
                                                    <div>
                                                        <strong>Dr. <%= appointment.getDoctorName() %></strong><br>
                                                        <small class="text-muted"><%= appointment.getDoctorSpecialization() %></small>
                                                    </div>
                                                </div>
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
                                                <div class="status-indicator">
                                                    <span class="badge <%= statusBadgeClass %>">
                                                        <i class="<%= statusIcon %> me-1"></i>
                                                        <%= status %>
                                                    </span>
                                                    <%
                                                        if (appointment.isFollowUpRequired()) {
                                                    %>
                                                        <i class="fas fa-redo text-warning" title="Follow-up Required"></i>
                                                    <%
                                                        }
                                                    %>
                                                </div>
                                            </td>
                                            <td>
                                                <div class="action-buttons">
                                                    <button type="button" class="btn btn-sm btn-outline-primary view-btn"
                                                            data-bs-toggle="modal" 
                                                            data-bs-target="#viewModal<%= appointment.getId() %>"
                                                            title="View Details">
                                                        <i class="fas fa-eye"></i>
                                                    </button>
                                                    
                                                    <button type="button" class="btn btn-sm btn-outline-warning edit-btn"
                                                            data-bs-toggle="modal" 
                                                            data-bs-target="#editModal<%= appointment.getId() %>"
                                                            title="Edit Appointment">
                                                        <i class="fas fa-edit"></i>
                                                    </button>

                                                    <button type="button" class="btn btn-sm btn-outline-danger delete-btn"
                                                            data-bs-toggle="modal" 
                                                            data-bs-target="#deleteConfirmModal"
                                                            data-appointment-id="<%= appointment.getId() %>"
                                                            data-patient-name="<%= appointment.getPatientName() %>"
                                                            data-doctor-name="<%= appointment.getDoctorName() %>"
                                                            title="Delete Appointment">
                                                        <i class="fas fa-trash"></i>
                                                    </button>
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
        </div>
    </main>

    <%-- Modals --%>
    <%
        for (Appointment appointment : appointments) {
            String status = appointment.getStatus();
            if (status == null) status = "Pending";
            
            String createdAtFormatted = "";
            if (appointment.getCreatedAt() != null) {
                createdAtFormatted = dateFormat.format(appointment.getCreatedAt());
            }
    %>
        <%-- View Modal --%>
        <div class="modal fade" id="viewModal<%= appointment.getId() %>" tabindex="-1" aria-labelledby="viewModalLabel<%= appointment.getId() %>" aria-hidden="true">
            <div class="modal-dialog modal-dialog-centered modal-lg">
                <div class="modal-content">
                    <div class="modal-header">
                        <h3 class="modal-title">
                            <i class="fas fa-calendar-alt text-primary me-2"></i>
                            Appointment Details
                        </h3>
                        <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                    </div>
                    <div class="modal-body">
                        <div class="appointment-details">
                            <div class="detail-section">
                                <h5><i class="fas fa-info-circle"></i> Basic Information</h5>
                                <div class="detail-item">
                                    <span class="detail-label">Appointment ID:</span>
                                    <span class="detail-value">#<%= appointment.getId() %></span>
                                </div>
                                <div class="detail-item">
                                    <span class="detail-label">Status:</span>
                                    <span class="detail-value">
                                        <span class="badge <%= "Pending".equals(status) ? "badge-pending" : "Confirmed".equals(status) ? "badge-confirmed" : "Completed".equals(status) ? "badge-completed" : "badge-cancelled" %>">
                                            <i class="fas <%= "Pending".equals(status) ? "fa-clock" : "Confirmed".equals(status) ? "fa-check-circle" : "Completed".equals(status) ? "fa-calendar-check" : "fa-times-circle" %> me-1"></i>
                                            <%= status %>
                                        </span>
                                    </span>
                                </div>
                                <div class="detail-item">
                                    <span class="detail-label">Appointment Type:</span>
                                    <span class="detail-value"><%= appointment.getAppointmentType() %></span>
                                </div>
                                <div class="detail-item">
                                    <span class="detail-label">Follow-up Required:</span>
                                    <span class="detail-value"><%= appointment.isFollowUpRequired() ? "Yes" : "No" %></span>
                                </div>
                                <div class="detail-item">
                                    <span class="detail-label">Created On:</span>
                                    <span class="detail-value"><%= createdAtFormatted %></span>
                                </div>
                            </div>
                            
                            <div class="detail-section">
                                <h5><i class="fas fa-user"></i> Patient Information</h5>
                                <div class="detail-item">
                                    <span class="detail-label">Patient Name:</span>
                                    <span class="detail-value"><%= appointment.getPatientName() %></span>
                                </div>
                                <div class="detail-item">
                                    <span class="detail-label">Patient ID:</span>
                                    <span class="detail-value">PAT<%= appointment.getPatientId() %></span>
                                </div>
                            </div>
                            
                            <div class="detail-section">
                                <h5><i class="fas fa-user-md"></i> Doctor Information</h5>
                                <div class="detail-item">
                                    <span class="detail-label">Doctor Name:</span>
                                    <span class="detail-value">Dr. <%= appointment.getDoctorName() %></span>
                                </div>
                                <div class="detail-item">
                                    <span class="detail-label">Specialization:</span>
                                    <span class="detail-value"><%= appointment.getDoctorSpecialization() %></span>
                                </div>
                            </div>
                            
                            <div class="detail-section">
                                <h5><i class="fas fa-clock"></i> Schedule</h5>
                                <div class="detail-item">
                                    <span class="detail-label">Date:</span>
                                    <span class="detail-value"><%= appointment.getAppointmentDate() %></span>
                                </div>
                                <div class="detail-item">
                                    <span class="detail-label">Time:</span>
                                    <span class="detail-value"><%= appointment.getAppointmentTime() %></span>
                                </div>
                            </div>
                            
                            <div class="detail-section">
                                <h5><i class="fas fa-sticky-note"></i> Additional Information</h5>
                                <div class="detail-item">
                                    <span class="detail-label">Reason:</span>
                                    <span class="detail-value"><%= appointment.getReason() %></span>
                                </div>
                                <div class="detail-item">
                                    <span class="detail-label">Notes:</span>
                                    <span class="detail-value"><%= appointment.getNotes() != null ? appointment.getNotes() : "No notes available" %></span>
                                </div>
                            </div>
                        </div>
                    </div>
                    <div class="modal-footer">
                        <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Close</button>
                    </div>
                </div>
            </div>
        </div>

        <%-- Edit Modal --%>
        <div class="modal fade" id="editModal<%= appointment.getId() %>" tabindex="-1" aria-labelledby="editModalLabel<%= appointment.getId() %>" aria-hidden="true">
            <div class="modal-dialog modal-dialog-centered modal-lg">
                <div class="modal-content">
                    <div class="modal-header">
                        <h3 class="modal-title">
                            <i class="fas fa-edit text-primary me-2"></i>
                            Edit Appointment
                        </h3>
                        <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                    </div>
                    <form action="${pageContext.request.contextPath}/admin/management" method="post" id="editForm<%= appointment.getId() %>">
                        <input type="hidden" name="action" value="update">
                        <input type="hidden" name="type" value="appointment">
                        <input type="hidden" name="id" value="<%= appointment.getId() %>">
                        
                        <div class="modal-body">
                            <div class="form-section">
                                <h4 class="section-title">Appointment Information</h4>
                                <div class="row form-row-spaced">
                                    <div class="col-md-6">
                                        <label for="editStatus<%= appointment.getId() %>" class="form-label">Status</label>
                                        <div class="input-group">
                                            <span class="input-group-text">
                                                <i class="fas fa-tag text-primary"></i>
                                            </span>
                                            <select class="form-select" id="editStatus<%= appointment.getId() %>" name="status" required>
                                                <option value="Pending" <%= "Pending".equals(status) ? "selected" : "" %>>Pending</option>
                                                <option value="Confirmed" <%= "Confirmed".equals(status) ? "selected" : "" %>>Confirmed</option>
                                                <option value="Completed" <%= "Completed".equals(status) ? "selected" : "" %>>Completed</option>
                                                <option value="Cancelled" <%= "Cancelled".equals(status) ? "selected" : "" %>>Cancelled</option>
                                            </select>
                                        </div>
                                    </div>
                                    <div class="col-md-6">
                                        <label for="editType<%= appointment.getId() %>" class="form-label">Appointment Type</label>
                                        <div class="input-group">
                                            <span class="input-group-text">
                                                <i class="fas fa-calendar text-primary"></i>
                                            </span>
                                            <select class="form-select" id="editType<%= appointment.getId() %>" name="appointmentType" required>
                                                <option value="In-person" <%= "In-person".equals(appointment.getAppointmentType()) ? "selected" : "" %>>In-person</option>
                                                <option value="Online" <%= "Online".equals(appointment.getAppointmentType()) ? "selected" : "" %>>Online</option>
                                            </select>
                                        </div>
                                    </div>
                                </div>
                                
                                <div class="row form-row-spaced">
                                    <div class="col-md-6">
                                        <label for="editDate<%= appointment.getId() %>" class="form-label">Appointment Date</label>
                                        <div class="input-group">
                                            <span class="input-group-text">
                                                <i class="fas fa-calendar-day text-primary"></i>
                                            </span>
                                            <input type="date" class="form-control" id="editDate<%= appointment.getId() %>" name="appointmentDate" value="<%= appointment.getAppointmentDate() %>" required>
                                        </div>
                                    </div>
                                    <div class="col-md-6">
                                        <label for="editTime<%= appointment.getId() %>" class="form-label">Appointment Time</label>
                                        <div class="input-group">
                                            <span class="input-group-text">
                                                <i class="fas fa-clock text-primary"></i>
                                            </span>
                                            <input type="time" class="form-control" id="editTime<%= appointment.getId() %>" name="appointmentTime" value="<%= timeFormat.format(appointment.getAppointmentTime()) %>" required>
                                        </div>
                                    </div>
                                </div>
                                
                                <div class="mb-3">
                                    <div class="form-check">
                                        <input class="form-check-input" type="checkbox" id="editFollowUp<%= appointment.getId() %>" name="followUpRequired" <%= appointment.isFollowUpRequired() ? "checked" : "" %>>
                                        <label class="form-check-label" for="editFollowUp<%= appointment.getId() %>">
                                            Follow-up Required
                                        </label>
                                    </div>
                                </div>
                            </div>
                            
                            <div class="form-section">
                                <h4 class="section-title">Additional Information</h4>
                                <div class="mb-3">
                                    <label for="editReason<%= appointment.getId() %>" class="form-label">Reason for Visit</label>
                                    <div class="input-group">
                                        <span class="input-group-text align-items-start">
                                            <i class="fas fa-sticky-note text-primary"></i>
                                        </span>
                                        <textarea class="form-control" id="editReason<%= appointment.getId() %>" name="reason" rows="3" required><%= appointment.getReason() %></textarea>
                                    </div>
                                </div>
                                
                                <div class="mb-3">
                                    <label for="editNotes<%= appointment.getId() %>" class="form-label">Additional Notes</label>
                                    <div class="input-group">
                                        <span class="input-group-text align-items-start">
                                            <i class="fas fa-file-medical text-primary"></i>
                                        </span>
                                        <textarea class="form-control" id="editNotes<%= appointment.getId() %>" name="notes" rows="3"><%= appointment.getNotes() != null ? appointment.getNotes() : "" %></textarea>
                                    </div>
                                </div>
                            </div>
                        </div>
                        <div class="modal-footer">
                            <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cancel</button>
                            <button type="submit" class="btn btn-primary">Update Appointment</button>
                        </div>
                    </form>
                </div>
            </div>
        </div>
    <%
        }
    %>

    <%-- Delete Confirmation Modal --%>
    <div class="modal fade" id="deleteConfirmModal" tabindex="-1" aria-labelledby="deleteModalLabel" aria-hidden="true">
        <div class="modal-dialog modal-dialog-centered">
            <div class="modal-content">
                <div class="modal-header border-bottom-0">
                    <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                </div>
                <div class="modal-body text-center">
                    <div class="delete-modal-icon">
                        <i class="fas fa-exclamation-triangle fa-2x"></i>
                    </div>
                    <h4 class="mb-3">Are you sure?</h4>
                    <p class="mb-3">You are about to delete an appointment for <strong id="deletePatientName" class="text-danger"></strong> with <strong id="deleteDoctorName" class="text-danger"></strong>.</p>
                    <p class="text-muted small">This action cannot be undone.</p>
                </div>
                <div class="modal-footer border-top-0 justify-content-center">
                    <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cancel</button>
                    <form id="deleteForm" method="post" action="${pageContext.request.contextPath}/admin/management" style="display: inline;">
                        <input type="hidden" name="action" value="delete">
                        <input type="hidden" name="type" value="appointment">
                        <input type="hidden" name="id" id="deleteAppointmentId">
                        <button type="submit" class="btn btn-danger">
                            <i class="fas fa-trash me-1"></i>Delete Appointment
                        </button>
                    </form>
                </div>
            </div>
        </div>
    </div>

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

            // Filter functionality
            const statusFilter = document.getElementById('statusFilter');
            const doctorFilter = document.getElementById('doctorFilter');
            const dateFilter = document.getElementById('dateFilter');
            const clearFilters = document.getElementById('clearFilters');
            const tableRows = document.querySelectorAll('#appointmentsTable tbody tr');

            function filterAppointments() {
                const statusValue = statusFilter ? statusFilter.value : 'all';
                const doctorValue = doctorFilter ? doctorFilter.value : 'all';
                const dateValue = dateFilter ? dateFilter.value : '';

                tableRows.forEach(row => {
                    const status = row.getAttribute('data-status');
                    const doctor = row.getAttribute('data-doctor');
                    const date = row.getAttribute('data-date');

                    const statusMatch = statusValue === 'all' || status === statusValue.toLowerCase();
                    const doctorMatch = doctorValue === 'all' || doctor === doctorValue;
                    const dateMatch = dateValue === '' || date === dateValue;

                    if (statusMatch && doctorMatch && dateMatch) {
                        row.style.display = '';
                    } else {
                        row.style.display = 'none';
                    }
                });
            }

            if (statusFilter) statusFilter.addEventListener('change', filterAppointments);
            if (doctorFilter) doctorFilter.addEventListener('change', filterAppointments);
            if (dateFilter) dateFilter.addEventListener('change', filterAppointments);
            if (clearFilters) {
                clearFilters.addEventListener('click', function() {
                    if (statusFilter) statusFilter.value = 'all';
                    if (doctorFilter) doctorFilter.value = 'all';
                    if (dateFilter) dateFilter.value = '';
                    filterAppointments();
                });
            }

            // Delete confirmation modal
            const deleteModal = document.getElementById('deleteConfirmModal');
            const deleteButtons = document.querySelectorAll('.delete-btn');
            
            if (deleteModal) {
                deleteButtons.forEach(button => {
                    button.addEventListener('click', function() {
                        const appointmentId = this.getAttribute('data-appointment-id');
                        const patientName = this.getAttribute('data-patient-name');
                        const doctorName = this.getAttribute('data-doctor-name');
                        
                        document.getElementById('deleteAppointmentId').value = appointmentId;
                        document.getElementById('deletePatientName').textContent = patientName;
                        document.getElementById('deleteDoctorName').textContent = 'Dr. ' + doctorName;
                    });
                });
            }

            // Export functionality
            const exportBtn = document.getElementById('exportBtn');
            if (exportBtn) {
                exportBtn.addEventListener('click', function() {
                    // Simple export implementation - could be enhanced with CSV/Excel export
                    const table = document.getElementById('appointmentsTable');
                    const rows = Array.from(table.querySelectorAll('tr'));
                    const csvContent = rows.map(row => {
                        const cells = Array.from(row.querySelectorAll('th, td'));
                        return cells.map(cell => {
                            // Remove action buttons and icons for export
                            if (cell.querySelector('.action-buttons')) {
                                return '';
                            }
                            return '"' + cell.textContent.replace(/"/g, '""') + '"';
                        }).join(',');
                    }).join('\n');
                    
                    const blob = new Blob([csvContent], { type: 'text/csv' });
                    const url = window.URL.createObjectURL(blob);
                    const a = document.createElement('a');
                    a.href = url;
                    a.download = 'appointments.csv';
                    a.click();
                    window.URL.revokeObjectURL(url);
                });
            }

            // Form validation
            const forms = document.querySelectorAll('form');
            forms.forEach(form => {
                form.addEventListener('submit', function(e) {
                    const requiredFields = form.querySelectorAll('[required]');
                    let valid = true;
                    
                    requiredFields.forEach(field => {
                        if (!field.value.trim()) {
                            valid = false;
                            field.classList.add('is-invalid');
                        } else {
                            field.classList.remove('is-invalid');
                        }
                    });
                    
                    if (!valid) {
                        e.preventDefault();
                        // Show error message
                        const alertDiv = document.createElement('div');
                        alertDiv.className = 'alert alert-danger alert-modern mt-3';
                        alertDiv.innerHTML = '<i class="fas fa-exclamation-circle me-2"></i>Please fill in all required fields.';
                        form.insertBefore(alertDiv, form.firstChild);
                    }
                });
            });

            // Initialize tooltips
            const tooltipTriggerList = [].slice.call(document.querySelectorAll('[title]'));
            const tooltipList = tooltipTriggerList.map(function (tooltipTriggerEl) {
                return new bootstrap.Tooltip(tooltipTriggerEl);
            });
        });
    </script>
</body>
</html>