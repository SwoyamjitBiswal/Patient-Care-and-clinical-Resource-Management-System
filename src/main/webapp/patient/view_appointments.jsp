<%@ page import="com.entity.Patient" %>
<%@ page import="com.dao.AppointmentDao" %>
<%@ page import="com.entity.Appointment" %>
<%@ page import="java.util.List" %>
<%@ page import="java.util.stream.Collectors" %>
<%
    Patient currentPatient = (Patient) session.getAttribute("patientObj");
    if (currentPatient == null) {
        response.sendRedirect(request.getContextPath() + "/patient/login.jsp"); 
        return;
    }

    AppointmentDao appointmentDao = new AppointmentDao();
    List<Appointment> appointments = appointmentDao.getAppointmentsByPatientId(currentPatient.getId());

    long pendingCount = appointments.stream().filter(a -> a.getStatus() == null || "Pending".equals(a.getStatus())).count();
    long confirmedCount = appointments.stream().filter(a -> "Confirmed".equals(a.getStatus())).count();
    long completedCount = appointments.stream().filter(a -> "Completed".equals(a.getStatus())).count();
    long cancelledCount = appointments.stream().filter(a -> "Cancelled".equals(a.getStatus())).count();

    String currentUserRole = "patient";
    
    // --- ROBUST MESSAGE HANDLING ---
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
    // --- END MESSAGE HANDLING ---
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Patient Care System - My Appointments</title>

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
            --shadow-xl: 0 20px 25px -5px rgba(0, 0, 0, 0.1), 0 10px 10px -5px rgba(0, 0, 0, 0.04);
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
            justify-content: space-between;
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
        
        .btn-sm {
            padding: 0.5rem 1rem;
            font-size: 0.85rem;
        }
        
        .btn-primary {
            background: linear-gradient(135deg, var(--primary), var(--primary-dark));
            color: white;
        }
        
        .btn-primary:hover {
            transform: translateY(-2px);
            box-shadow: 0 7px 14px rgba(79, 70, 229, 0.25);
        }
        
        .btn-outline-primary {
            background-color: transparent;
            border: 1px solid var(--primary);
            color: var(--primary);
        }
        
        .btn-outline-primary:hover {
            background-color: var(--primary);
            color: white;
            transform: translateY(-2px);
        }
        
        .btn-outline-danger {
            background-color: transparent;
            border: 1px solid var(--danger);
            color: var(--danger);
        }
        
        .btn-outline-danger:hover {
            background-color: var(--danger);
            color: white;
        }
        
        .btn-outline-warning {
            background-color: transparent;
            border: 1px solid var(--warning);
            color: var(--warning);
        }
        
        .btn-outline-warning:hover {
            background-color: var(--warning);
            color: white;
        }
        
        .btn-outline-secondary {
            background-color: transparent;
            border: 1px solid var(--secondary);
            color: var(--secondary);
        }
        .btn-outline-secondary:hover {
            background-color: var(--secondary);
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
        
        /* Table Styles */
        .table-responsive {
            border-radius: var(--border-radius);
            overflow: hidden;
            border: 1px solid #f3f4f6;
        }
        
        .table {
            width: 100%;
            border-collapse: collapse;
        }
        
        .table th {
            background-color: #f9fafb;
            padding: 0.75rem 1rem;
            text-align: left;
            font-weight: 600;
            color: var(--dark);
            border-bottom: 1px solid #e5e7eb;
        }
        
        .table td {
            padding: 1rem;
            border-bottom: 1px solid #f3f4f6;
            vertical-align: middle;
        }
        
        .table tbody tr:hover {
            background-color: #f9fafb;
        }
        
        .table tbody tr:last-child td {
            border-bottom: none;
        }
        
        /* Badge Styles */
        .badge {
            display: inline-block;
            padding: 0.35rem 0.65rem;
            font-size: 0.75rem;
            font-weight: 600;
            line-height: 1;
            text-align: center;
            white-space: nowrap;
            vertical-align: baseline;
            border-radius: 50px;
        }
        
        .badge-pending { 
            color: #92400e; 
            background-color: #fef3c7; 
        }
        .badge-confirmed { 
            color: #065f46; 
            background-color: #d1fae5; 
        }
        .badge-completed { 
            color: #1e40af; 
            background-color: #dbeafe; 
        }
        .badge-cancelled { 
            color: #991b1b; 
            background-color: #fee2e2; 
        }
        .badge-light { 
            color: #374151; 
            background-color: #f3f4f6; 
        }
        
        /* Stats Cards */
        .stats-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
            gap: 1rem;
            margin-top: 1.5rem;
        }
        
        .stats-card {
            color: white;
            padding: 1.5rem;
            border-radius: var(--border-radius);
            text-align: center;
            transition: var(--transition);
        }
        
        .stats-card:hover {
            transform: translateY(-3px);
            box-shadow: var(--shadow-lg);
        }
        
        .stats-number {
            font-size: 2rem;
            font-weight: 700;
            margin-bottom: 0.25rem;
        }
        
        .stats-label {
            font-size: 0.9rem;
            font-weight: 500;
            opacity: 0.9;
        }
        
        .stats-pending { background: linear-gradient(135deg, var(--warning), #f59e0b); }
        .stats-confirmed { background: linear-gradient(135deg, var(--success), #10b981); }
        .stats-completed { background: linear-gradient(135deg, var(--info), #0ea5e9); }
        .stats-cancelled { background: linear-gradient(135deg, var(--secondary), #9ca3af); }
        
        /* Doctor Avatar */
        .doctor-avatar {
            width: 40px;
            height: 40px;
            border-radius: 50%;
            background: linear-gradient(135deg, var(--primary), #6366f1);
            display: flex;
            align-items: center;
            justify-content: center;
            color: white;
            font-size: 1rem;
            margin-right: 0.75rem;
            flex-shrink: 0;
        }
        
        /* Empty State */
        .empty-state {
            text-align: center;
            padding: 3rem 1rem;
        }
        
        .empty-state i {
            font-size: 4rem;
            color: #d1d5db;
            margin-bottom: 1rem;
        }
        
        .empty-state h4 {
            color: #6b7280;
            margin-bottom: 0.5rem;
        }
        
        .empty-state p {
            color: #9ca3af;
            margin-bottom: 1.5rem;
        }
        
        /* Button Group */
        .btn-group {
            display: flex;
            gap: 0.5rem;
        }
        
        /* --- Card-Style Delete Modal --- */
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
            margin: auto; /* Ensures horizontal centering */
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
            display:flex;
        }
        
        #deleteConfirmModal .modal-footer .btn {
            flex-grow: 1;
            padding: 0.6rem 1rem;
            font-weight: 500;
        }
        
        /* Utility Classes */
        .d-flex { display: flex !important; }
        .d-grid { display: grid !important; }
        .justify-content-between { justify-content: space-between !important; }
        .align-items: center { align-items: center !important; }
        .text-center { text-align: center !important; }
        .mb-0 { margin-bottom: 0 !important; }
        .mb-1 { margin-bottom: 0.25rem !important; }
        .mb-2 { margin-bottom: 0.5rem !important; }
        .mb-3 { margin-bottom: 1rem !important; }
        .mb-4 { margin-bottom: 1.5rem !important; }
        .mt-1 { margin-top: 0.25rem !important; }
        .mt-4 { margin-top: 1.5rem !important; }
        .me-1 { margin-right: 0.25rem !important; }
        .me-2 { margin-right: 0.5rem !important; }
        .d-inline { display: inline !important; }
        .d-block { display: block !important; }
        .text-muted { color: #6b7280 !important; }
        .text-warning { color: #f59e0b !important; }
        .text-danger { color: var(--danger) !important; }
        .row { display: flex; flex-wrap: wrap; margin-right: -15px; margin-left: -15px; }
        .col-lg-8, .col-md-6, .col-12, .col-md-3 { position: relative; width: 100%; padding-right: 15px; padding-left: 15px; }
        @media (min-width: 768px) {
            .col-md-6 { flex: 0 0 50%; max-width: 50%; }
            .col-md-3 { flex: 0 0 25%; max-width: 25%; }
        }
        @media (min-width: 992px) {
            .col-lg-8 { flex: 0 0 66.666667%; max-width: 66.666667%; }
        }
        
        @media (max-width: 768px) {
            .table-responsive {
                font-size: 0.875rem;
            }
            
            .btn-group {
                flex-direction: column;
            }
            
            .stats-grid {
                grid-template-columns: repeat(2, 1fr);
            }
        }
        
        @media (max-width: 576px) {
            .stats-grid {
                grid-template-columns: 1fr;
            }
            
            .page-header {
                flex-direction: column;
                align-items: flex-start;
                gap: 1rem;
            }
        }
        
        /* Modal Utilities */
        .modal {
            position: fixed;
            top: 0;
            left: 0;
            z-index: 1055;
            display: none;
            width: 100%;
            height: 100%;
            overflow-x: hidden;
            overflow-y: auto;
            outline: 0;
        }
        .modal.fade {
            transition: opacity .15s linear;
        }
        .modal-dialog {
            position: relative;
            width: auto;
            margin: .5rem;
            pointer-events: none;
        }
        .modal.fade .modal-dialog {
            transition: transform .3s ease-out;
            transform: translate(0,-50px);
        }
        .modal.show .modal-dialog {
            transform: none;
        }
        .modal-dialog-centered {
            display: flex;
            align-items: center;
            min-height: calc(100% - 1rem);
        }
        .modal-content {
            position: relative;
            display: flex;
            flex-direction: column;
            width: 100%;
            pointer-events: auto;
            background-color: #fff;
            background-clip: padding-box;
            border: 1px solid rgba(0,0,0,.2);
            border-radius: .3rem;
            outline: 0;
        }
        .modal-backdrop {
            position: fixed;
            top: 0;
            left: 0;
            z-index: 1050;
            width: 100vw;
            height: 100vh;
            background-color: #000;
        }
        .modal-backdrop.fade {
            opacity: 0;
        }
        .modal-backdrop.show {
            opacity: .5;
        }
        .fa-3x { font-size: 3em; }
    </style>
</head>
<body>
    <button class="mobile-menu-toggle" id="mobileMenuToggle">
        <i class="fas fa-bars"></i>
    </button>
    
    <div class="sidebar" id="sidebar">
        <%-- ... [Sidebar code remains unchanged] ... --%>
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
                        <a class="nav-link active" 
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
                <i class="fas fa-list-alt"></i>
                My Appointments
            </h1>
            <a href="${pageContext.request.contextPath}/patient/appointment?action=book" class="btn btn-primary">
                <i class="fas fa-calendar-plus me-2"></i>New Appointment
            </a>
        </div>

        <%-- --- START: UPDATED MESSAGE DISPLAY BLOCK --- --%>
        <%
            if (successMsg != null && !successMsg.isEmpty()) {
        %>
            <div class="alert alert-success alert-dismissible fade show" role="alert">
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
            <div class="alert alert-danger alert-dismissible fade show" role="alert">
                <div class="d-flex align-items-center">
                    <i class="fas fa-exclamation-triangle me-3 fs-5"></i>
                    <div class="flex-grow-1"><%= errorMsg %></div>
                </div>
                <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
            </div>
        <%
            }
        %>
        <%-- --- END: UPDATED MESSAGE DISPLAY BLOCK --- --%>


        <div class="card">
            <div class="card-header">
                <h2 class="card-title">
                    <i class="fas fa-calendar-check"></i>
                    Appointment History
                </h2>
                <span class="badge badge-light">
                    <i class="fas fa-calendar me-1"></i>
                    <%= appointments.size() %> Total Appointments
                </span>
            </div>
            <div class="card-body">
                <%
                    if (appointments.isEmpty()) {
                %>
                    <div class="empty-state">
                        <i class="fas fa-calendar-times"></i>
                        <h4>No Appointments Found</h4>
                        <p>You haven't booked any appointments yet.</p>
                        <a href="${pageContext.request.contextPath}/patient/appointment?action=book" class="btn btn-primary">
                            <i class="fas fa-calendar-plus me-2"></i>Book Your First Appointment
                        </a>
                    </div>
                <%
                    } else {
                %>
                    <div class="table-responsive">
                        <table class="table">
                            <thead>
                                <tr>
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
                                        if (status == null) {
                                            status = "Pending";
                                        }
                                        
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
                                                statusBadgeClass = "badge-light";
                                                statusIcon = "fas fa-question-circle";
                                                break;
                                        }
                                %>
                                    <tr>
                                        <td>
                                            <div class="d-flex align-items-center">
                                                <div class="doctor-avatar">
                                                    <i class="fas fa-user-md"></i>
                                                </div>
                                                <div>
                                                    <strong>Dr. <%= appointment.getDoctorName() %></strong>
                                                    <div class="text-muted" style="font-size: 0.875rem;">
                                                        <%= appointment.getDoctorSpecialization() %>
                                                    </div>
                                                </div>
                                            </div>
                                        </td>
                                        <td>
                                            <div>
                                                <strong><%= appointment.getAppointmentDate() %></strong>
                                                <div class="text-muted" style="font-size: 0.875rem;">
                                                    <i class="fas fa-clock me-1"></i>
                                                    <%= appointment.getAppointmentTime() %>
                                                </div>
                                            </div>
                                        </td>
                                        <td>
                                            <span class="badge badge-light">
                                                <i class="<%= "In-person".equals(appointment.getAppointmentType()) ? "fas fa-user" : "fas fa-laptop" %> me-1"></i>
                                                <%= appointment.getAppointmentType() %>
                                            </span>
                                        </td>
                                        <td>
                                            <span class="badge <%= statusBadgeClass %>">
                                                <i class="<%= statusIcon %> me-1"></i>
                                                <%= status %>
                                            </span>
                                            <%
                                                if (appointment.isFollowUpRequired()) {
                                            %>
                                                <div class="text-warning mt-1" style="font-size: 0.75rem;">
                                                    <i class="fas fa-redo me-1"></i>Follow-up required
                                                </div>
                                            <%
                                                }
                                            %>
                                        </td>
                                        <td>
                                            <div class="btn-group">
                                                <a href="${pageContext.request.contextPath}/patient/appointment?action=details&id=<%= appointment.getId() %>"
                                                   class="btn btn-outline-primary btn-sm">
                                                    <i class="fas fa-eye"></i>
                                                    View
                                                </a>
                                                <%
                                                    if ("Pending".equals(status)) {
                                                %>
                                                    <a href="${pageContext.request.contextPath}/patient/appointment?action=edit&id=<%= appointment.getId() %>"
                                                       class="btn btn-outline-warning btn-sm">
                                                        <i class="fas fa-edit"></i>
                                                        Edit
                                                    </a>
                                                    
                                                    <%-- --- START: UPDATED CANCEL BUTTON --- --%>
                                                    <form action="${pageContext.request.contextPath}/patient/appointment?action=cancel" method="post" class="d-inline" id="deleteForm<%= appointment.getId() %>">
                                                        <input type="hidden" name="id" value="<%= appointment.getId() %>">
                                                        <button type="button" class="btn btn-outline-danger btn-sm cancel-appointment-btn"
                                                                data-bs-toggle="modal" 
                                                                data-bs-target="#deleteConfirmModal"
                                                                data-form-id="deleteForm<%= appointment.getId() %>"
                                                                data-item-name="Appointment #<%= appointment.getId() %>">
                                                            <i class="fas fa-times"></i>
                                                            Cancel
                                                        </button>
                                                    </form>
                                                    <%-- --- END: UPDATED CANCEL BUTTON --- --%>
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

                    <div class="stats-grid">
                        <%-- ... [Stats cards remain unchanged] ... --%>
                        <div class="stats-card stats-pending">
                            <div class="stats-number"><%= pendingCount %></div>
                            <div class="stats-label">Pending</div>
                        </div>
                        <div class="stats-card stats-confirmed">
                            <div class="stats-number"><%= confirmedCount %></div>
                            <div class="stats-label">Confirmed</div>
                        </div>
                        <div class="stats-card stats-completed">
                            <div class="stats-number"><%= completedCount %></div>
                            <div class="stats-label">Completed</div>
                        </div>
                        <div class="stats-card stats-cancelled">
                            <div class="stats-number"><%= cancelledCount %></div>
                            <div class="stats-label">Cancelled</div>
                        </div>
                    </div>
                <%
                    }
                %>
            </div>
        </div>
    </main>

    <%-- --- START: NEW CARD-STYLE DELETE MODAL --- --%>
    <div class="modal fade" id="deleteConfirmModal" tabindex="-1" aria-labelledby="deleteModalLabel" aria-hidden="true">
        <div class="modal-dialog modal-dialog-centered" style="max-width: 400px; margin: auto;">
            <div class="modal-content">
                <div class="modal-header">
                    <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                </div>
                <div class="modal-body">
                    <div class="delete-modal-icon">
                        <i class="fas fa-exclamation-triangle fa-3x"></i>
                    </div>
                    <h4>Confirm Cancellation</h4>
                    <p class="mb-0">Are you sure you want to cancel <strong id="itemNameToDelete" class="text-danger">this appointment</strong>?</p>
                    <p class="text-muted small mt-2">This action cannot be undone.</p>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-outline-secondary" data-bs-dismiss="modal">Keep It</button>
                    <button type="button" class="btn btn-danger" id="modalConfirmDeleteButton">
                        <i class="fas fa-times me-1"></i>Yes, Cancel
                    </button>
                </div>
            </div>
        </div>
    </div>
    <%-- --- END: NEW CARD-STYLE DELETE MODAL --- --%>

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
    
    <%-- --- START: UPDATED JAVASCRIPT BLOCK --- --%>
    <script>
        document.addEventListener('DOMContentLoaded', function() {
            
            // --- Auto-hide success alerts (Task 1) ---
            const successAlerts = document.querySelectorAll('.alert-success.alert-dismissible');
            successAlerts.forEach(function(alert) {
                setTimeout(function() {
                    if (typeof bootstrap !== 'undefined' && bootstrap.Alert) {
                        const bsAlert = bootstrap.Alert.getInstance(alert) || new bootstrap.Alert(alert);
                        if (bsAlert) {
                            bsAlert.close();
                        }
                    } else {
                        // Fallback
                        alert.style.transition = 'opacity 0.5s ease';
                        alert.style.opacity = '0';
                        setTimeout(() => alert.style.display = 'none', 500);
                    }
                }, 5000); // 5 seconds
            });

            // --- New Card-Style Modal Logic (Task 2) ---
            const deleteConfirmModal = document.getElementById('deleteConfirmModal');
            let formToSubmit = null; 

            if (deleteConfirmModal) {
                // 1. Listen for the modal's "show" event (triggered by data-bs-toggle)
                deleteConfirmModal.addEventListener('show.bs.modal', function (event) {
                    // Get the button that triggered the modal
                    const button = event.relatedTarget;
                    
                    // Get the form ID and item name from the button's data attributes
                    const formId = button.getAttribute('data-form-id');
                    const itemName = button.getAttribute('data-item-name');
                    
                    // Store the form to be submitted
                    formToSubmit = document.getElementById(formId);
                    
                    // Update the modal's text
                    const modalItemNameElement = document.getElementById('itemNameToDelete');
                    modalItemNameElement.textContent = itemName ? `${itemName}` : 'this item';
                });

                // 2. Add click listener to the modal's *actual* confirm button
                const modalConfirmDeleteButton = document.getElementById('modalConfirmDeleteButton');
                if (modalConfirmDeleteButton) {
                    modalConfirmDeleteButton.addEventListener('click', function () {
                        // When clicked, submit the stored form
                        if (formToSubmit) {
                            formToSubmit.submit(); 
                        }
                    });
                }
            }
            
            // --- Old confirm() script removed ---
        });
    </script>
    <%-- --- END: UPDATED JAVASCRIPT BLOCK --- --%>
</body>
</html>