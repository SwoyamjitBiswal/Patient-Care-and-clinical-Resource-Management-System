<%@ page import="com.entity.Admin" %>
<%@ page import="com.dao.AppointmentDao" %>
<%@ page import="com.entity.Appointment" %>
<%@ page import="java.util.List" %>
<%@ page import="java.util.Set" %>
<%@ page import="java.util.HashSet" %>
<%@ page import="java.text.SimpleDateFormat" %>
<%
    // All action logic (update, delete) has been moved to the AdminManagementServlet.
    // This scriptlet now only prepares data for display.

    // Admin authentication
    Admin currentAdmin = (Admin) session.getAttribute("adminObj");
    if (currentAdmin == null) {
        response.sendRedirect(request.getContextPath() + "/admin/login.jsp");
        return;
    }

    // Get messages from servlet (if any)
    String successMsg = (String) request.getAttribute("successMsg");
    String errorMsg = (String) request.getAttribute("errorMsg");

    AppointmentDao appointmentDao = new AppointmentDao();
    List<Appointment> appointments = appointmentDao.getAllAppointments();

    long pendingCount = appointments.stream().filter(a -> "Pending".equals(a.getStatus())).count();
    long confirmedCount = appointments.stream().filter(a -> "Confirmed".equals(a.getStatus())).count();
    long completedCount = appointments.stream().filter(a -> "Completed".equals(a.getStatus())).count();
    long cancelledCount = appointments.stream().filter(a -> "Cancelled".equals(a.getStatus())).count();
    long followUpCount = appointments.stream().filter(Appointment::isFollowUpRequired).count();

    String currentUserRole = "admin";
    
    // Create date formatter for displaying timestamps
    SimpleDateFormat dateFormat = new SimpleDateFormat("yyyy-MM-dd");
    SimpleDateFormat timeFormat = new SimpleDateFormat("HH:mm");
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Patient Care System - Manage Appointments</title>

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

        /* --- REFINEMENT: CSS-driven mobile toggle --- */
        .mobile-menu-toggle {
            display: none; /* Hidden by default on desktop */
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
                display: flex; /* Show toggle button on mobile */
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
        
        /* --- Dashboard Specific Styles --- */
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
        
        /* UPDATED: Enhanced Input Group Styles */
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
        
        /* Textarea specific styling */
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
        
        /* UPDATED: Enhanced Button Variants */
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
        
        /* UPDATED: Enhanced Clear Filter Button */
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
        }
        
        .stats-card:hover {
            transform: translateY(-5px);
            box-shadow: var(--shadow-lg);
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
        .icon-success { background-color: #d1fae5; color: #065f46); }
        
        /* Alert Styles */
        .alert-modern {
            border-radius: 10px;
            border: none;
            box-shadow: var(--shadow-sm);
            padding: 1rem 1.5rem;
        }
        
        /* --- REFINEMENT: Alert auto-fade animation --- */
        @keyframes fadeOut {
            from { opacity: 1; }
            to { opacity: 0; transform: translateY(-10px); visibility: hidden; }
        }
        
        .alert-fading {
            animation: fadeOut 0.5s ease-out forwards;
            animation-delay: 4.5s; /* Start fading after 4.5s */
        }
        
        /* Modal Styles */
        .modal-overlay {
            position: fixed;
            top: 0;
            left: 0;
            right: 0;
            bottom: 0;
            background: rgba(0, 0, 0, 0.5);
            display: flex;
            align-items: center;
            justify-content: center;
            z-index: 1050;
            padding: 1rem;
            opacity: 0;
            visibility: hidden;
            transition: var(--transition);
        }
        
        .modal-overlay.active {
            opacity: 1;
            visibility: visible;
        }
        
        .modal-content {
            background: white;
            border-radius: var(--border-radius);
            box-shadow: var(--shadow-lg);
            width: 100%;
            max-width: 800px;
            max-height: 90vh;
            overflow-y: auto;
            transform: translateY(-20px);
            transition: var(--transition);
        }
        
        .modal-overlay.active .modal-content {
            transform: translateY(0);
        }
        
        .modal-header {
            padding: 1.5rem;
            border-bottom: 1px solid var(--gray-200);
            display: flex;
            align-items: center;
            justify-content: space-between;
        }
        
        .modal-title {
            font-size: 1.5rem;
            font-weight: 600;
            color: var(--gray-800);
            display: flex;
            align-items: center;
            gap: 0.5rem;
        }
        
        .modal-close {
            background: none;
            border: none;
            font-size: 1.5rem;
            color: var(--gray-500);
            cursor: pointer;
            width: 40px;
            height: 40px;
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
            transition: var(--transition);
        }
        
        .modal-close:hover {
            background: var(--gray-100);
            color: var(--danger);
        }
        
        .modal-body {
            padding: 1.5rem;
        }
        
        .modal-footer {
            padding: 1.5rem;
            border-top: 1px solid var(--gray-200);
            display: flex;
            justify-content: flex-end;
            gap: 0.75rem;
        }
        
        /* UPDATED: Compact Appointment Details Layout */
        .appointment-details {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(280px, 1fr));
            gap: 1rem;
        }
        
        .detail-section {
            background: var(--gray-50);
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
        
        /* Bootstrap utilities */
        .row { display: flex; flex-wrap: wrap; margin-right: -15px; margin-left: -15px; }
        .col-lg-8, .col-lg-4, .col-md-6, .col-md-4, .col-md-3, .col-md-2, .col-12 { position: relative; width: 100%; padding-right: 15px; padding-left: 15px; }
        @media (min-width: 768px) {
            .col-md-6 { flex: 0 0 50%; max-width: 50%; }
            .col-md-4 { flex: 0 0 33.333333%; max-width: 33.333333%; }
            .col-md-3 { flex: 0 0 25%; max-width: 25%; }
            .col-md-2 { flex: 0 0 16.666667%; max-width: 16.666667%; }
        }
        @media (min-width: 992px) {
            .col-lg-8 { flex: 0 0 66.666667%; max-width: 66.666667%; }
            .col-lg-4 { flex: 0 0 33.333333%; max-width: 33.333333%; }
        }
        .col-12 { flex: 0 0 100%; max-width: 100%; }
        .mb-0 { margin-bottom: 0 !important; }
        .mb-1 { margin-bottom: 0.25rem !important; }
        .mb-2 { margin-bottom: 0.5rem !important; }
        .mb-3 { margin-bottom: 1rem !important; }
        .mb-4 { margin-bottom: 1.5rem !important; }
        .mt-1 { margin-top: 0.25rem !important; }
        .mt-2 { margin-top: 0.5rem !important; }
        .mt-4 { margin-top: 1.5rem !important; }
        .p-4 { padding: 1.5rem !important; }
        .py-3 { padding-top: 1rem !important; padding-bottom: 1rem !important; }
        .py-4 { padding-top: 1.5rem !important; padding-bottom: 1.5rem !important; }
        .d-flex { display: flex !important; }
        .d-grid { display: grid !important; }
        .d-block { display: block !important; }
        .d-inline { display: inline !important; }
        .justify-content-between { justify-content: space-between !important; }
        .align-items-center { align-items: center !important; }
        .align-items-end { align-items: flex-end !important; }
        .text-center { text-align: center !important; }
        .text-muted { color: var(--gray-600) !important; }
        .text-primary { color: var(--primary) !important; }
        .h2 { font-size: 2rem; font-weight: 600; }
        .h4 { font-size: 1.5rem; }
        .h5 { font-size: 1.1rem; }
        .fs-5 { font-size: 1.25rem !important; }
        .fw-bold { font-weight: 700 !important; }
        .fw-medium { font-weight: 500 !important; }
        .me-1 { margin-right: 0.25rem !important; }
        .me-2 { margin-right: 0.5rem !important; }
        .me-3 { margin-right: 1rem !important; }
        .gap-1 { gap: 0.25rem !important; }
        .gap-2 { gap: 0.5rem !important; }
        .g-3 { gap: 1rem !important; }
        .w-100 { width: 100% !important; }
        /* REFINEMENT: Add btn-sm utility for action buttons */
        .btn-sm {
            padding: 0.25rem 0.5rem;
            font-size: 0.875rem;
            border-radius: 0.2rem;
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
                        <a class="nav-link <%= request.getRequestURI().contains("dashboard.jsp") ? "active" : "" %>" 
                           href="${pageContext.request.contextPath}/admin/dashboard.jsp">
                            <i class="fas fa-tachometer-alt"></i>
                            <span>Dashboard</span>
                        </a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link <%= request.getRequestURI().contains("profile.jsp") ? "active" : "" %>" 
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
            <%
                // Display success/error messages
                if (successMsg != null) {
            %>
                <div class="alert alert-success alert-modern alert-autofade alert-dismissible fade show mb-4" role="alert">
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
                <div class="alert alert-danger alert-modern alert-autofade alert-dismissible fade show mb-4" role="alert">
                    <div class="d-flex align-items-center">
                        <i class="fas fa-exclamation-triangle me-3 fs-5"></i>
                        <div class="flex-grow-1"><%= errorMsg %></div>
                    </div>
                    <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                </div>
            <%
                }
            %>

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

            <div class="card card-modern">
                <div class="card-header-modern">
                    <i class="fas fa-list"></i>
                    <span>All Appointments</span>
                    <span class="badge bg-primary ms-2"><%= appointments.size() %> Total</span>
                </div>
                <div class="card-body p-4">
                    <%
                        if (appointments.isEmpty()) {
                    %>
                        <div class="text-center py-5">
                            <i class="fas fa-calendar-times fa-4x text-muted mb-3"></i>
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

                                            // ======================================================
                                            // START OF FIX (v2): Default null/invalid status to "Pending"
                                            // ======================================================
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
                                                // Default to "Pending" if status is null, "Pending", or anything else
                                                status = "Pending"; // This is the key change
                                                statusBadgeClass = "badge-pending";
                                                statusIcon = "fas fa-clock";
                                            }
                                            // ======================================================
                                            // END OF FIX
                                            // ======================================================
                                            
                                            // Format createdAt timestamp
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
                                                <span class="badge <%= statusBadgeClass %>">
                                                    <i class="<%= statusIcon %> me-1"></i>
                                                    <%= status %>
                                                </span>
                                                <%
                                                    if (appointment.isFollowUpRequired()) {
                                                %>
                                                    <br>
                                                    <small class="text-warning d-block mt-1">
                                                        <i class="fas fa-redo me-1"></i>Follow-up
                                                    </small>
                                                <%
                                                    }
                                                %>
                                            </td>
                                            <td>
                                                <div class="d-flex gap-1" role="group">
                                                    <button type="button" class="btn btn-sm btn-outline-primary view-appointment"
                                                            data-bs-toggle="tooltip" title="View Details"
                                                            data-appt-id="<%= appointment.getId() %>"
                                                            data-patient-name="<%= appointment.getPatientName() %>"
                                                            data-patient-id="<%= appointment.getPatientId() %>"
                                                            data-doctor-name="<%= appointment.getDoctorName() %>"
                                                            data-doctor-specialization="<%= appointment.getDoctorSpecialization() %>"
                                                            data-date="<%= appointment.getAppointmentDate() %>"
                                                            data-time="<%= appointment.getAppointmentTime() %>"
                                                            data-type="<%= appointment.getAppointmentType() %>"
                                                            data-reason="<%= appointment.getReason() %>"
                                                            data-notes="<%= appointment.getNotes() != null ? appointment.getNotes() : "" %>"
                                                            data-status="<%= status %>"
                                                            data-created-at="<%= createdAtFormatted %>"
                                                            data-follow-up="<%= appointment.isFollowUpRequired() %>">
                                                        <i class="fas fa-eye"></i>
                                                    </button>
                                                    <button type="button" class="btn btn-sm btn-outline-warning edit-appointment"
                                                            data-bs-toggle="tooltip" title="Edit Appointment"
                                                            data-appt-id="<%= appointment.getId() %>"
                                                            data-patient-name="<%= appointment.getPatientName() %>"
                                                            data-patient-id="<%= appointment.getPatientId() %>"
                                                            data-doctor-name="<%= appointment.getDoctorName() %>"
                                                            data-doctor-specialization="<%= appointment.getDoctorSpecialization() %>"
                                                            data-date="<%= appointment.getAppointmentDate() %>"
                                                            data-time="<%= appointment.getAppointmentTime() %>"
                                                            data-type="<%= appointment.getAppointmentType() %>"
                                                            data-reason="<%= appointment.getReason() %>"
                                                            data-notes="<%= appointment.getNotes() != null ? appointment.getNotes() : "" %>"
                                                            data-status="<%= status %>"
                                                            data-follow-up="<%= appointment.isFollowUpRequired() %>">
                                                        <i class="fas fa-edit"></i>
                                                    </button>
                                                    
                                                    <form action="${pageContext.request.contextPath}/admin/management" method="post" class="d-inline">
                                                        <input type="hidden" name="action" value="delete">
                                                        <input type="hidden" name="type" value="appointment">
                                                        <input type="hidden" name="id" value="<%= appointment.getId() %>">
                                                        <button type="submit" class="btn btn-sm btn-outline-danger delete-appointment"
                                                                data-bs-toggle="tooltip" title="Delete Appointment">
                                                            <i class="fas fa-trash"></i>
                                                        </button>
                                                    </form>
                                                </div>
                                            </td>
                                        </tr>
                                    <%
                                        }
                                    %>
                                </tbody>
                            </table>
                        </div>

                        <div class="row mt-4">
                            <div class="col-6 col-md-2">
                                <div class="stats-card stats-card-primary">
                                    <h4 class="mb-1"><%= appointments.size() %></h4>
                                    <small>Total</small>
                                </div>
                            </div>
                            <div class="col-6 col-md-2">
                                <div class="stats-card stats-card-warning">
                                    <h4 class="mb-1"><%= pendingCount %></h4>
                                    <small>Pending</small>
                                </div>
                            </div>
                            <div class="col-6 col-md-2">
                                <div class="stats-card stats-card-success">
                                    <h4 class="mb-1"><%= confirmedCount %></h4>
                                    <small>Confirmed</small>
                                </div>
                            </div>
                            <div class="col-6 col-md-2">
                                <div class="stats-card stats-card-info">
                                    <h4 class="mb-1"><%= completedCount %></h4>
                                    <small>Completed</small>
                                </div>
                            </div>
                            <div class="col-6 col-md-2">
                                <div class="stats-card stats-card-secondary">
                                    <h4 class="mb-1"><%= cancelledCount %></h4>
                                    <small>Cancelled</small>
                                </div>
                            </div>
                            <div class="col-6 col-md-2">
                                <div class="stats-card stats-card-danger">
                                    <h4 class="mb-1"><%= followUpCount %></h4>
                                    <small>Follow-up</small>
                                </div>
                            </div>
                        </div>
                    <%
                        }
                    %>
                </div>
            </div>
        </div>
    </main>

    <div class="modal-overlay" id="viewModal">
        <div class="modal-content">
            <div class="modal-header">
                <h3 class="modal-title">
                    <i class="fas fa-calendar-alt text-primary"></i>
                    Appointment Details
                </h3>
                <button type="button" class="modal-close" id="closeViewModal">
                    <i class="fas fa-times"></i>
                </button>
            </div>
            <div class="modal-body">
                <div class="appointment-details">
                    <div class="detail-section">
                        <h5><i class="fas fa-info-circle"></i> Basic Information</h5>
                        <div class="detail-item">
                            <span class="detail-label">Appointment ID:</span>
                            <span class="detail-value" id="viewApptId">#12345</span>
                        </div>
                        <div class="detail-item">
                            <span class="detail-label">Status:</span>
                            <span class="detail-value" id="viewStatus">
                                <span class="badge badge-pending">Pending</span>
                            </span>
                        </div>
                        <div class="detail-item">
                            <span class="detail-label">Appointment Type:</span>
                            <span class="detail-value" id="viewType">In-person</span>
                        </div>
                        <div class="detail-item">
                            <span class="detail-label">Follow-up Required:</span>
                            <span class="detail-value" id="viewFollowUp">No</span>
                        </div>
                        <div class="detail-item">
                            <span class="detail-label">Created On:</span>
                            <span class="detail-value" id="viewCreatedAt">2023-10-15</span>
                        </div>
                    </div>
                    
                    <div class="detail-section">
                        <h5><i class="fas fa-user"></i> Patient Information</h5>
                        <div class="detail-item">
                            <span class="detail-label">Patient Name:</span>
                            <span class="detail-value" id="viewPatientName">John Doe</span>
                        </div>
                        <div class="detail-item">
                            <span class="detail-label">Patient ID:</span>
                            <span class="detail-value" id="viewPatientId">PAT001</span>
                        </div>
                    </div>
                    
                    <div class="detail-section">
                        <h5><i class="fas fa-user-md"></i> Doctor Information</h5>
                        <div class="detail-item">
                            <span class="detail-label">Doctor Name:</span>
                            <span class="detail-value" id="viewDoctorName">Dr. Smith</span>
                        </div>
                        <div class="detail-item">
                            <span class="detail-label">Specialization:</span>
                            <span class="detail-value" id="viewDoctorSpecialization">Cardiology</span>
                        </div>
                    </div>
                    
                    <div class="detail-section">
                        <h5><i class="fas fa-clock"></i> Schedule</h5>
                        <div class="detail-item">
                            <span class="detail-label">Date:</span>
                            <span class="detail-value" id="viewDate">2023-11-20</span>
                        </div>
                        <div class="detail-item">
                            <span class="detail-label">Time:</span>
                            <span class="detail-value" id="viewTime">10:30 AM</span>
                        </div>
                    </div>
                    
                    <div class="detail-section">
                        <h5><i class="fas fa-sticky-note"></i> Additional Information</h5>
                        <div class="detail-item">
                            <span class="detail-label">Reason:</span>
                            <span class="detail-value" id="viewReason">Regular checkup</span>
                        </div>
                        <div class="detail-item">
                            <span class="detail-label">Notes:</span>
                            <span class="detail-value" id="viewNotes">No specific notes</span>
                        </div>
                    </div>
                </div>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-secondary" id="closeViewModalBtn">Close</button>
            </div>
        </div>
    </div>

    <div class="modal-overlay" id="editModal">
        <div class="modal-content">
            <div class="modal-header">
                <h3 class="modal-title">
                    <i class="fas fa-edit text-primary"></i>
                    Edit Appointment
                </h3>
                <button type="button" class="modal-close" id="closeEditModal">
                    <i class="fas fa-times"></i>
                </button>
            </div>
            <form action="${pageContext.request.contextPath}/admin/management" method="post" id="editForm">
                <input type="hidden" name="action" value="update">
                <input type="hidden" name="type" value="appointment">
                <input type="hidden" name="id" id="editApptId">
                
                <div class="modal-body">
                    <div class="form-section">
                        <h4 class="section-title">Appointment Information</h4>
                        <div class="row form-row-spaced">
                            <div class="col-md-6">
                                <label for="editStatus" class="form-label">Status</label>
                                <div class="input-group">
                                    <span class="input-group-text">
                                        <i class="fas fa-tag text-primary"></i>
                                    </span>
                                    <select class="form-select" id="editStatus" name="status" required>
                                        <option value="Pending">Pending</option>
                                        <option value="Confirmed">Confirmed</option>
                                        <option value="Completed">Completed</option>
                                        <option value="Cancelled">Cancelled</option>
                                    </select>
                                </div>
                            </div>
                            <div class="col-md-6">
                                <label for="editType" class="form-label">Appointment Type</label>
                                <div class="input-group">
                                    <span class="input-group-text">
                                        <i class="fas fa-calendar text-primary"></i>
                                    </span>
                                    <select class="form-select" id="editType" name="appointmentType" required>
                                        <option value="In-person">In-person</option>
                                        <option value="Online">Online</option>
                                    </select>
                                </div>
                            </div>
                        </div>
                        
                        <div class="row form-row-spaced">
                            <div class="col-md-6">
                                <label for="editDate" class="form-label">Appointment Date</label>
                                <div class="input-group">
                                    <span class="input-group-text">
                                        <i class="fas fa-calendar-day text-primary"></i>
                                    </span>
                                    <input type="date" class="form-control" id="editDate" name="appointmentDate" required>
                                </div>
                            </div>
                            <div class="col-md-6">
                                <label for="editTime" class="form-label">Appointment Time</label>
                                <div class="input-group">
                                    <span class="input-group-text">
                                        <i class="fas fa-clock text-primary"></i>
                                    </span>
                                    <input type="time" class="form-control" id="editTime" name="appointmentTime" required>
                                </div>
                            </div>
                        </div>
                        
                        <div class="mb-3">
                            <div class="form-check">
                                <input class="form-check-input" type="checkbox" id="editFollowUp" name="followUpRequired">
                                <label class="form-check-label" for="editFollowUp">
                                    Follow-up Required
                                </label>
                            </div>
                        </div>
                    </div>
                    
                    <div class="form-section">
                        <h4 class="section-title">Additional Information</h4>
                        <div class="mb-3">
                            <label for="editReason" class="form-label">Reason for Visit</label>
                            <div class="input-group">
                                <span class="input-group-text align-items-start">
                                    <i class="fas fa-sticky-note text-primary"></i>
                                </span>
                                <textarea class="form-control" id="editReason" name="reason" rows="3" required></textarea>
                            </div>
                        </div>
                        
                        <div class="mb-3">
                            <label for="editNotes" class="form-label">Additional Notes</label>
                            <div class="input-group">
                                <span class="input-group-text align-items-start">
                                    <i class="fas fa-file-medical text-primary"></i>
                                </span>
                                <textarea class="form-control" id="editNotes" name="notes" rows="3"></textarea>
                            </div>
                        </div>
                    </div>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-secondary" id="closeEditModalBtn">Cancel</button>
                    <button type="submit" class="btn btn-primary-modern">Update Appointment</button>
                </div>
            </form>
        </div>
    </div>

    <script>
        document.addEventListener('DOMContentLoaded', function() {
            const mobileMenuToggle = document.getElementById('mobileMenuToggle');
            const sidebar = document.getElementById('sidebar');
            
            // Mobile toggle click listener remains
            mobileMenuToggle.addEventListener('click', function() {
                sidebar.classList.toggle('mobile-open');
            });
            
            // Close sidebar on nav link click on mobile
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
            // Initialize tooltips
            const tooltipTriggerList = [].slice.call(document.querySelectorAll('[data-bs-toggle="tooltip"]'));
            const tooltipList = tooltipTriggerList.map(function (tooltipTriggerEl) {
                if (typeof bootstrap !== 'undefined' && bootstrap.Tooltip) {
                    return new bootstrap.Tooltip(tooltipTriggerEl);
                }
                return null;
            }).filter(tooltip => tooltip !== null);

            // REFINEMENT: Auto-fade alerts
            const autoFadeAlerts = document.querySelectorAll('.alert-autofade');
            autoFadeAlerts.forEach(alert => {
                alert.classList.add('alert-fading');
                // Remove from DOM after fade-out to prevent layout shifts
                alert.addEventListener('animationend', () => {
                    // We check for Bootstrap's 'dispose' method to safely remove it
                    const bsAlert = bootstrap.Alert.getInstance(alert);
                    if (bsAlert) {
                        bsAlert.close();
                    } else {
                        alert.remove();
                    }
                });
            });

            // Filter functionality
            const statusFilter = document.getElementById('statusFilter');
            const doctorFilter = document.getElementById('doctorFilter');
            const dateFilter = document.getElementById('dateFilter');
            const clearFilters = document.getElementById('clearFilters');
            const tableBody = document.querySelector('#appointmentsTable tbody');
            const tableRows = tableBody ? tableBody.querySelectorAll('tr') : [];

            function filterAppointments() {
                const statusValue = statusFilter.value;
                const doctorValue = doctorFilter.value;
                const dateValue = dateFilter.value;

                tableRows.forEach(row => {
                    const status = row.getAttribute('data-status');
                    const doctor = row.getAttribute('data-doctor');
                    const date = row.getAttribute('data-date');

                    const statusMatch = statusValue === 'all' || status === statusValue;
                    const doctorMatch = doctorValue === 'all' || doctor === doctorValue;
                    const dateMatch = dateValue === '' || date === dateValue;

                    if (statusMatch && doctorMatch && dateMatch) {
                        row.style.display = '';
                    } else {
                        row.style.display = 'none';
                    }
                });
            }

            if(statusFilter) statusFilter.addEventListener('change', filterAppointments);
            if(doctorFilter) doctorFilter.addEventListener('change', filterAppointments);
            if(dateFilter) dateFilter.addEventListener('change', filterAppointments);
            if(clearFilters) {
                clearFilters.addEventListener('click', function() {
                    if(statusFilter) statusFilter.value = 'all';
                    if(doctorFilter) doctorFilter.value = 'all';
                    if(dateFilter) dateFilter.value = '';
                    filterAppointments();
                });
            }

            // Modal functionality
            const viewModal = document.getElementById('viewModal');
            const editModal = document.getElementById('editModal');
            
            // View Modal Elements
            const closeViewModal = document.getElementById('closeViewModal');
            const closeViewModalBtn = document.getElementById('closeViewModalBtn');
            
            // Edit Modal Elements
            const closeEditModal = document.getElementById('closeEditModal');
            const closeEditModalBtn = document.getElementById('closeEditModalBtn');
            
            // Open View Modal
            const viewButtons = document.querySelectorAll('.view-appointment');
            viewButtons.forEach(button => {
                button.addEventListener('click', function() {
                    const appointmentId = this.getAttribute('data-appt-id');
                    const patientName = this.getAttribute('data-patient-name');
                    const patientId = this.getAttribute('data-patient-id');
                    const doctorName = this.getAttribute('data-doctor-name');
                    const doctorSpecialization = this.getAttribute('data-doctor-specialization');
                    const date = this.getAttribute('data-date');
                    const time = this.getAttribute('data-time');
                    const type = this.getAttribute('data-type');
                    const reason = this.getAttribute('data-reason');
                    const notes = this.getAttribute('data-notes');
                    const status = this.getAttribute('data-status');
                    const createdAt = this.getAttribute('data-created-at');
                    const followUp = this.getAttribute('data-follow-up');
                    
                    // Populate view modal
                    document.getElementById('viewApptId').textContent = '#' + appointmentId;
                    document.getElementById('viewPatientName').textContent = patientName;
                    document.getElementById('viewPatientId').textContent = 'PAT' + patientId;
                    document.getElementById('viewDoctorName').textContent = 'Dr. ' + doctorName;
                    document.getElementById('viewDoctorSpecialization').textContent = doctorSpecialization;
                    document.getElementById('viewDate').textContent = date;
                    document.getElementById('viewTime').textContent = time;
                    document.getElementById('viewType').textContent = type;
                    document.getElementById('viewReason').textContent = reason;
                    document.getElementById('viewNotes').textContent = notes || 'No notes available';
                    document.getElementById('viewCreatedAt').textContent = createdAt;
                    document.getElementById('viewFollowUp').textContent = followUp === 'true' ? 'Yes' : 'No';
                    
                    // Update status badge
                    const statusElement = document.getElementById('viewStatus');
                    statusElement.innerHTML = '';
                    let statusBadgeClass = '';
                    let statusIcon = '';
                    
                    // ======================================================
                    // START OF JAVASCRIPT FIX: Add default case
                    // ======================================================
                    switch(status) {
                        case 'Confirmed':
                            statusBadgeClass = 'badge-confirmed';
                            statusIcon = 'fas fa-check-circle';
                            break;
                        case 'Completed':
                            statusBadgeClass = 'badge-completed';
                            statusIcon = 'fas fa-calendar-check';
                            break;
                        case 'Cancelled':
                            statusBadgeClass = 'badge-cancelled';
                            statusIcon = 'fas fa-times-circle';
                            break;
                        case 'Pending':
                        default: // This handles "Pending" and any unexpected cases
                            statusBadgeClass = 'badge-pending';
                            statusIcon = 'fas fa-clock';
                            break;
                    }
                    // ======================================================
                    // END OF JAVASCRIPT FIX
                    // ======================================================
                    
                    const badge = document.createElement('span');
                    badge.className = `badge ${statusBadgeClass}`;
                    badge.innerHTML = `<i class="${statusIcon} me-1"></i>${status}`;
                    statusElement.appendChild(badge);
                    
                    // Show modal
                    viewModal.classList.add('active');
                    document.body.style.overflow = 'hidden';
                });
            });
            
            // Open Edit Modal
            const editButtons = document.querySelectorAll('.edit-appointment');
            editButtons.forEach(button => {
                button.addEventListener('click', function() {
                    const appointmentId = this.getAttribute('data-appt-id');
                    const date = this.getAttribute('data-date');
                    const time = this.getAttribute('data-time');
                    const type = this.getAttribute('data-type');
                    const reason = this.getAttribute('data-reason');
                    const notes = this.getAttribute('data-notes');
                    const status = this.getAttribute('data-status');
                    const followUp = this.getAttribute('data-follow-up');
                    
                    // Populate edit form
                    document.getElementById('editApptId').value = appointmentId;
                    document.getElementById('editStatus').value = status;
                    document.getElementById('editType').value = type;
                    document.getElementById('editDate').value = date;
                    
                    // Format time for input[type="time"]
                    let timeValue = time;
                    if (timeValue && timeValue.length > 5) {
                        timeValue = timeValue.substring(0, 5);
                    }
                    document.getElementById('editTime').value = timeValue;
                    
                    document.getElementById('editReason').value = reason;
                    document.getElementById('editNotes').value = notes || '';
                    document.getElementById('editFollowUp').checked = followUp === 'true';
                    
                    // Show modal
                    editModal.classList.add('active');
                    document.body.style.overflow = 'hidden';
                });
            });
            
            // Close View Modal
            function closeViewModalFunc() {
                if (viewModal.classList.contains('active')) {
                    viewModal.classList.remove('active');
                    document.body.style.overflow = 'auto';
                }
            }
            
            if(closeViewModal) closeViewModal.addEventListener('click', closeViewModalFunc);
            if(closeViewModalBtn) closeViewModalBtn.addEventListener('click', closeViewModalFunc);
            
            // Close Edit Modal
            function closeEditModalFunc() {
                if (editModal.classList.contains('active')) {
                    editModal.classList.remove('active');
                    document.body.style.overflow = 'auto';
                }
            }
            
            if(closeEditModal) closeEditModal.addEventListener('click', closeEditModalFunc);
            if(closeEditModalBtn) closeEditModalBtn.addEventListener('click', closeEditModalFunc);
            
            // Close modals when clicking outside
            window.addEventListener('click', function(event) {
                if (event.target === viewModal) {
                    closeViewModalFunc();
                }
                if (event.target === editModal) {
                    closeEditModalFunc();
                }
            });

            // REFINEMENT: Add Escape key listener for modals
            document.addEventListener('keydown', function(event) {
                if (event.key === 'Escape') {
                    if (viewModal.classList.contains('active')) {
                        closeViewModalFunc();
                    }
                    if (editModal.classList.contains('active')) {
                        closeEditModalFunc();
                    }
                }
            });

            // Confirm delete actions
            const deleteButtons = document.querySelectorAll('.delete-appointment');
            deleteButtons.forEach(button => {
                // Find the parent form
                const form = button.closest('form');
                if (form) {
                    form.addEventListener('submit', function(e) {
                        if (!confirm('Are you sure you want to PERMANENTLY DELETE this appointment? This action cannot be undone.')) {
                            e.preventDefault(); // Stop the form from submitting
                        }
                    });
                }
            });
        });
    </script>
</body>
</html>