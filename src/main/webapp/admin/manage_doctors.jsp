<%@ page import="com.entity.Admin" %>
<%@ page import="com.dao.DoctorDao" %>
<%@ page import="com.entity.Doctor" %>
<%@ page import="java.util.List" %>
<%
    Admin currentAdmin = (Admin) session.getAttribute("adminObj");
    if (currentAdmin == null) {
        response.sendRedirect(request.getContextPath() + "/admin/login.jsp");
        return;
    }

    DoctorDao doctorDao = new DoctorDao();
    List<Doctor> doctors = doctorDao.getAllDoctors();

    String currentUserRole = "admin";
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Patient Care System - Manage Doctors</title>

    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" rel="stylesheet">
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700&display=swap" rel="stylesheet">
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>

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

        /* Dashboard Content Styles */
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

        /* Button Styles */
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
        
        .btn-outline-primary {
            border: 1px solid var(--primary);
            color: var(--primary);
            background-color: transparent;
        }
        
        .btn-outline-primary:hover {
            background-color: var(--primary);
            color: white;
        }
        
        .btn-secondary {
            background-color: var(--secondary);
            border-color: var(--secondary);
            color: white;
        }
        
        .btn-secondary:hover {
            background-color: #5a6268;
            border-color: #545b62;
        }
        
        .btn-danger { 
            background-color: var(--danger); 
            border-color: var(--danger); 
            color: white; 
        }
        
        .btn-danger:hover { 
            background-color: #c82333; 
            border-color: #bd2130; 
        }
        
        .btn-outline-danger { 
            border-color: var(--danger); 
            color: var(--danger); 
            background: transparent; 
        }
        
        .btn-outline-danger:hover { 
            background-color: var(--danger); 
            color: white; 
        }
        
        .btn-info {
            background-color: var(--info);
            border-color: var(--info);
            color: var(--dark);
        }
        
        .btn-info:hover {
            background-color: #0aa2c0;
            border-color: #0aa2c0;
            color: white;
        }
        
        .btn-outline-info {
            border: 1px solid var(--info);
            color: var(--info);
            background-color: transparent;
        }
        
        .btn-outline-info:hover {
            background-color: var(--info);
            color: var(--dark);
        }
        
        .btn-warning {
            background-color: var(--warning);
            border-color: var(--warning);
            color: var(--dark);
        }

        /* Input Group Styles - Fixed */
        .input-group {
            position: relative;
            display: flex;
            flex-wrap: wrap;
            align-items: stretch;
            width: 100%;
            border-radius: 10px;
            overflow: hidden;
            border: 1px solid var(--border-color);
            transition: var(--transition);
        }

        .input-group:focus-within {
            border-color: var(--primary);
            box-shadow: 0 0 0 3px rgba(67, 97, 238, 0.15);
        }

        .input-group-text {
            background: var(--light);
            border: none;
            color: var(--secondary);
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

        /* Focus state for the entire input group */
        .input-group:focus-within .input-group-text {
            background: var(--primary-light);
            color: var(--primary);
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
        
        .bg-primary { 
            background-color: var(--primary) !important; 
            color: white; 
        }
        
        .bg-light { 
            background-color: #e9ecef !important; 
        }
        
        .bg-success { 
            background-color: var(--success) !important; 
            color: white; 
        }
        
        .bg-danger { 
            background-color: var(--danger) !important; 
            color: white; 
        }
        
        .bg-info { 
            background-color: var(--info) !important; 
            color: var(--dark); 
        }
        
        .bg-warning {
             background-color: var(--warning) !important; 
             color: var(--dark);
        }

        .text-dark { 
            color: #343a40 !important; 
        }
        
        .text-white { 
            color: #fff !important; 
        }
        
        .text-success { 
            color: var(--success) !important; 
        }

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
            border-color: var(--border-color);
        }
         
         .table>thead th {
            font-weight: 600;
            color: #6b7280;
            text-transform: uppercase;
            font-size: 0.8rem;
            letter-spacing: 0.05em;
            border-bottom-width: 2px;
            border-color: var(--border-color);
         }
         
         .table>:not(:first-child) { 
             border-top: 2px solid var(--border-color); 
         }

        .table-hover>tbody>tr:hover>* {
            background-color: #f9fafb;
            color: #111827;
        }

        /* Form Styles */
         .form-label {
            font-weight: 500;
            margin-bottom: 0.5rem;
            color: #4a5568;
            font-size: 0.9rem;
        }
        
        .form-control, .form-select {
            display: block;
            width: 100%;
            border-radius: var(--border-radius);
            padding: 0.75rem 1rem;
            border: 1px solid var(--border-color);
            transition: all 0.3s;
            font-size: 0.9rem;
            color: var(--dark);
            background-color: #fff;
        }
        
        .form-control:focus, .form-select:focus {
            box-shadow: 0 0 0 3px rgba(67, 97, 238, 0.1);
            border-color: var(--primary);
            outline: 0;
        }
        
        .form-control-sm {
            padding: 0.5rem 0.8rem;
            font-size: 0.8rem;
        }
        
        .form-check { 
            display: block; 
            min-height: 1.5rem; 
            padding-left: 1.5em; 
            margin-bottom: 0.125rem; 
        }
        
        .form-check-input { 
            width: 1em; 
            height: 1em; 
            margin-top: 0.25em; 
            vertical-align: top; 
            background-color: #fff; 
            background-repeat: no-repeat; 
            background-position: center; 
            background-size: contain; 
            border: 1px solid rgba(0,0,0,.25); 
            appearance: none; 
        }
        
        .form-check-input[type=checkbox] { 
            border-radius: 0.25em; 
        }
        
        .form-check-input:focus { 
            border-color: #86b7fe; 
            outline: 0; 
            box-shadow: 0 0 0 0.25rem rgba(13,110,253,.25); 
        }
        
        .form-check-input:checked { 
            background-color: var(--primary); 
            border-color: var(--primary); 
        }
        
        .form-check-input:checked[type=checkbox] { 
            background-image: url("data:image/svg+xml,%3csvg xmlns='http://www.w3.org/2000/svg' viewBox='0 0 20 20'%3e%3cpath fill='none' stroke='%23fff' stroke-linecap='round' stroke-linejoin='round' stroke-width='3' d='m6 10 3 3 6-6'/%3e%3c/svg%3e"); 
        }
        
        .form-switch { 
            padding-left: 2.5em; 
        }
        
        .form-switch .form-check-input { 
            width: 2em; 
            margin-left: -2.5em; 
            background-image: url("data:image/svg+xml,%3csvg xmlns='http://www.w3.org/2000/svg' viewBox='-4 -4 8 8'%3e%3ccircle r='3' fill='rgba%280, 0, 0, 0.25%29'/%3e%3c/svg%3e"); 
            background-position: left center; 
            border-radius: 2em; 
            transition: background-position .15s ease-in-out; 
        }
        
        .form-switch .form-check-input:checked { 
            background-position: right center; 
            background-image: url("data:image/svg+xml,%3csvg xmlns='http://www.w3.org/2000/svg' viewBox='-4 -4 8 8'%3e%3ccircle r='3' fill='%23fff'/%3e%3c/svg%3e"); 
        }

        /* Modal Styles */
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
            background-color: rgba(0,0,0,0.5); 
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
        
        .modal-header { 
            display: flex; 
            flex-shrink: 0; 
            align-items: center; 
            justify-content: space-between; 
            padding: 1rem 1rem; 
            border-bottom: 1px solid #dee2e6; 
            border-top-left-radius: calc(.3rem - 1px); 
            border-top-right-radius: calc(.3rem - 1px); 
        }
        
        .modal-header .btn-close { 
            padding: .5rem .5rem; 
            margin: -.5rem -.5rem -.5rem auto; 
        }
        
        .modal-title { 
            margin-bottom: 0; 
            line-height: 1.5; 
            font-size: 1.25rem; 
        }
        
        .modal-body { 
            position: relative; 
            flex: 1 1 auto; 
            padding: 1rem; 
        }
        
        .modal-footer { 
            display: flex; 
            flex-wrap: wrap; 
            flex-shrink: 0; 
            align-items: center; 
            justify-content: flex-end; 
            padding: .75rem; 
            border-top: 1px solid #dee2e6; 
            border-bottom-right-radius: calc(.3rem - 1px); 
            border-bottom-left-radius: calc(.3rem - 1px); 
        }
        
        .modal-footer>:not(:first-child) { 
            margin-left: .25rem; 
        }
        
        .modal-footer>:not(:last-child) { 
            margin-right: .25rem; 
        }
        
        .modal-lg { 
            max-width: 800px; 
            margin: 1.75rem auto; 
        }
        
        .modal-sm { 
            max-width: 380px; 
            margin: 1.75rem auto; 
        }
        
        /* Specific modal body style for view */
        .modal-body hr {
            margin-top: 0.75rem;
            margin-bottom: 0.75rem;
            border-top: 1px solid var(--border-color);
        }
        
        .modal-body .row {
            align-items: center;
        }

        /* Bootstrap utilities */
        .container-fluid { 
            width: 100%; 
            padding-right: 15px; 
            padding-left: 15px; 
            margin-right: auto; 
            margin-left: auto; 
        }
        
        .row { 
            display: flex; 
            flex-wrap: wrap; 
            margin-right: -15px; 
            margin-left: -15px; 
        }
        
        .col-lg-8, .col-md-6, .col-12, .col-md-3, .col-md-2, .col-sm-4, .col-sm-8 { 
            position: relative; 
            width: 100%; 
            padding-right: 15px; 
            padding-left: 15px; 
        }
        
        .justify-content-center { 
            justify-content: center !important; 
        }
        
        .justify-content-md-end { 
            justify-content: flex-end !important; 
        }

        @media (min-width: 576px) {
            .col-sm-4 {
                flex: 0 0 auto;
                width: 33.33333333%;
            }
            .col-sm-8 {
                flex: 0 0 auto;
                width: 66.66666667%;
            }
        }
        
        @media (min-width: 768px) {
            .col-md-6 { 
                flex: 0 0 50%; 
                max-width: 50%; 
            }
            
            .col-md-3 { 
                flex: 0 0 25%; 
                max-width: 25%; 
            }
            
            .col-md-2 { 
                flex: 0 0 16.666667%; 
                max-width: 16.666667%; 
            }
            
            .me-md-2 { 
                margin-right: 0.5rem !important; 
            }
        }
        
        @media (min-width: 992px) {
            .col-lg-8 { 
                flex: 0 0 66.666667%; 
                max-width: 66.666667%; 
            }
        }
        
        .col-12 { 
            flex: 0 0 100%; 
            max-width: 100%; 
        }
        
        .w-100 { 
            width: 100% !important; 
        }
        
        .mb-0 { 
            margin-bottom: 0 !important; 
        }
        
        .mb-1 { 
            margin-bottom: 0.25rem !important; 
        }
        
        .mb-2 { 
            margin-bottom: 0.5rem !important; 
        }
        
        .mb-3 { 
            margin-bottom: 1rem !important; 
        }
        
        .mb-4 { 
            margin-bottom: 1.5rem !important; 
        }
        
        .mt-1 { 
            margin-top: 0.25rem !important; 
        }
        
        .mt-2 { 
            margin-top: 0.5rem !important; 
        }
        
        .mt-3 { 
            margin-top: 1rem !important; 
        }
        
        .mt-4 { 
            margin-top: 1.5rem !important; 
        }
        
        .mx-auto { 
            margin-left: auto !important; 
            margin-right: auto !important; 
        }
        
        .py-3 { 
            padding-top: 1rem !important; 
            padding-bottom: 1rem !important; 
        }
        
        .py-4 { 
            padding-top: 1.5rem !important; 
            padding-bottom: 1.5rem !important; 
        }
        
        .py-5 { 
            padding-top: 3rem !important; 
            padding-bottom: 3rem !important; 
        }
        
        .p-4 { 
            padding: 1.5rem !important; 
        }
        
        .pt-3 { 
            padding-top: 1rem !important; 
        }
        
        .d-flex { 
            display: flex !important; 
        }
        
        .d-md-flex { 
            display: flex !important; 
        }
        
        .d-grid { 
            display: grid !important; 
        }
        
        .d-block { 
            display: block !important; 
        }
        
        .d-inline { 
            display: inline !important; 
        }
        
        .d-none { 
            display: none !important; 
        }
        
        @media (min-width: 768px) { 
            .d-md-flex { 
                display: flex !important; 
            } 
            
            .d-md-table-cell { 
                display: table-cell !important; 
            } 
        }
        
        .justify-content-between { 
            justify-content: space-between !important; 
        }
        
        .align-items-center { 
            align-items: center !important; 
        }
        
        .border-bottom { 
            border-bottom: 1px solid var(--border-color) !important; 
        }
        
        hr { 
            margin-top: 1rem; 
            margin-bottom: 1rem; 
            border: 0; 
            border-top: 1px solid var(--border-color); 
        }
        
        .h2 { 
            font-size: 1.75rem; 
            font-weight: 600; 
        }
        
        .h4 { 
            font-size: 1.5rem; 
        }
        
        .h5 { 
            font-size: 1.1rem; 
        }
        
        .h6 { 
            font-size: 1rem; 
        }
        
        .fs-5 { 
            font-size: 1.25rem !important; 
        }
        
        .fs-6 { 
            font-size: 1rem !important; 
        }
        
        .fa-4x { 
            font-size: 4em; 
        }
        
        .fw-bold { 
            font-weight: 700 !important; 
        }
        
        .fw-medium { 
            font-weight: 500 !important; 
        }
        
        .me-2 { 
            margin-right: 0.5rem !important; 
        }
        
        .me-1 { 
            margin-right: 0.25rem !important; 
        }
        
        .me-3 { 
            margin-right: 1rem !important; 
        }
        
        .text-primary { 
            color: var(--primary) !important; 
        }

        .text-info {
            color: var(--info) !important;
        }
        
        .card { 
            position: relative; 
            display: flex; 
            flex-direction: column; 
            min-width: 0; 
            word-wrap: break-word; 
            background-color: #fff; 
            background-clip: border-box; 
            border: 1px solid var(--border-color); 
            border-radius: 0.5rem; 
        }
        
        .card-body { 
            flex: 1 1 auto; 
            padding: 1.5rem; 
        }
        
        .text-center { 
            text-align: center !important; 
        }
        
        .text-muted { 
            color: #6c757d !important; 
        }
        
        .gap-2 { 
            gap: 0.5rem !important; 
        }
        
        .g-3 { 
            gap: 1rem !important; 
        }

        /* Validation Styles */
        .alert { 
            position: relative; 
            padding: 1rem 1rem; 
            margin-bottom: 1rem; 
            border: 1px solid transparent; 
            border-radius: var(--border-radius); 
        }
        
        .alert-success { 
            color: #0f5132; 
            background-color: #d1e7dd; 
            border-color: #badbcc; 
        }
        
        .alert-danger { 
            color: #842029; 
            background-color: #f8d7da; 
            border-color: #f5c2c7; 
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
        
        .fade { 
            transition: opacity 0.15s linear; 
        }
        
        .show { 
            opacity: 1; 
        }
        
        .was-validated .form-control:invalid, .form-control.is-invalid { 
            border-color: #dc3545; 
        }
        
        .was-validated .form-control:invalid:focus, .form-control.is-invalid:focus { 
            border-color: #dc3545; 
            box-shadow: 0 0 0 0.25rem rgba(220,53,69,.25); 
        }
        
        .invalid-feedback { 
            display: none; 
            width: 100%; 
            margin-top: 0.25rem; 
            font-size: .875em; 
            color: #dc3545; 
        }
        
        .was-validated .form-control:invalid ~ .invalid-feedback,
        .was-validated .form-select:invalid ~ .invalid-feedback { 
            display: block; 
        }
        
        .form-control.is-invalid ~ .invalid-feedback {
            display: block;
        }

        /* --- Icon Box --- */
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
        
        .icon-primary { 
            background-color: var(--primary-light); 
            color: var(--primary); 
        }

        /* Form field spacing */
        .form-field {
            margin-bottom: 1.5rem;
        }
        
        .form-field:last-child {
            margin-bottom: 0;
        }
        
        .form-helper {
            font-size: 0.875rem;
            color: var(--secondary);
            margin-top: 0.5rem;
            display: block;
        }
        
        .form-actions {
            margin-top: 2rem;
            padding-top: 1.5rem;
            border-top: 1px solid var(--border-color);
        }
        
        /* --- Password Strength Criteria --- */
        #password-strength-criteria {
            padding-left: 0.5rem;
        }
        #password-strength-criteria h6 {
            color: var(--dark);
            font-weight: 500; /* Use 500 to match form-label */
            font-size: 0.9rem; /* Match form-label */
            margin-bottom: 0.75rem;
        }
        #password-strength-criteria .list-unstyled {
            padding-left: 0;
            margin-bottom: 0;
            list-style: none;
        }
        .criterion {
            font-size: 0.875rem;
            margin-bottom: 0.35rem;
            transition: var(--transition);
            display: flex;
            align-items: center;
            gap: 0.5rem;
        }
        .criterion i {
            font-size: 0.8rem; /* Consistent icon size */
            transition: var(--transition);
            width: 16px; /* Align icons */
            text-align: center;
        }
        .criterion.invalid {
            color: var(--secondary);
        }
        .criterion.invalid i {
            color: #adb5bd; /* Lighter grey for inactive dot */
        }
        .criterion.valid {
            color: var(--success);
            font-weight: 500;
        }
        .criterion.valid i {
            color: var(--success);
        }
        
        /* --- Show/Hide Password Toggle --- */
        .password-toggle-icon {
            position: absolute;
            right: 0;
            top: 0;
            height: 100%;
            width: 50px; /* Same as input-group-text */
            display: flex;
            align-items: center;
            justify-content: center;
            color: var(--secondary);
            cursor: pointer;
            z-index: 5;
            transition: var(--transition);
        }
        .password-toggle-icon:hover {
            color: var(--primary);
        }
        /* Adjust form-control padding to not overlap with icon */
        .form-control[type="password"] {
            padding-right: 50px !important;
        }
        /* The .form-control class from .input-group was overriding this */
        .input-group > .form-control[type="password"] {
             padding-right: 50px !important;
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
                   <i class="fas fa-user-shield"></i>
                </div>
                <div class="user-info">
                   <% if (currentAdmin != null) { %>
                    <h6><%= currentAdmin.getFullName() %></h6>
                    <small>Administrator</small>
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
                        <a class="nav-link <%= request.getRequestURI().contains("profile") ? "active" : "" %>"
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
                <i class="fas fa-user-md me-2 text-primary"></i>
                Manage Doctors
            </h1>
            <div class="btn-toolbar mb-2 mb-md-0">
                <button type="button" class="btn btn-primary" data-bs-toggle="modal" data-bs-target="#addDoctorModal">
                    <i class="fas fa-plus me-1"></i>Add New Doctor
                </button>
            </div>
        </div>

        <%
            String successMsg = (String) session.getAttribute("successMsg");
            String errorMsg = (String) session.getAttribute("errorMsg");
            
            // Clear session attributes after retrieval
            session.removeAttribute("successMsg");
            session.removeAttribute("errorMsg");

            if (successMsg != null) {
        %>
            <div class="alert alert-success alert-dismissible fade show" role="alert">
                <i class="fas fa-check-circle me-2"></i><%= successMsg %>
                <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
            </div>
        <%
            }
            if (errorMsg != null) {
        %>
            <div class="alert alert-danger alert-dismissible fade show" role="alert">
                <i class="fas fa-exclamation-triangle me-2"></i><%= errorMsg %>
                <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
            </div>
        <%
            }
        %>

        <div class="card shadow-custom">
            <div class="card-header d-flex justify-content-between align-items-center flex-wrap">
                <h5 class="mb-0 me-3">
                    <i class="fas fa-list me-2"></i>Doctors List
                </h5>
                 <div class="d-flex align-items-center mt-2 mt-md-0">
                    <span class="badge bg-primary me-3">
                        <i class="fas fa-user-md me-1"></i>
                        <%= doctors.size() %> Doctors
                    </span>
                    <div class="input-group" style="max-width: 250px;">
                        <span class="input-group-text">
                            <i class="fas fa-search"></i>
                        </span>
                        <input type="text" class="form-control form-control-sm" id="doctorSearchInput" placeholder="Search doctors...">
                    </div>
                 </div>
            </div>
            <div class="card-body">
                <%
                    if (doctors.isEmpty()) {
                %>
                    <div class="text-center py-5">
                        <i class="fas fa-user-md fa-4x text-muted mb-3"></i>
                        <h4 class="text-muted">No Doctors Found</h4>
                        <p class="text-muted mb-4">No doctors have been registered yet.</p>
                        <button type="button" class="btn btn-primary btn-lg" data-bs-toggle="modal" data-bs-target="#addDoctorModal">
                            <i class="fas fa-plus me-2"></i>Add First Doctor
                        </button>
                    </div>
                <%
                    } else {
                %>
                    <div class="table-responsive">
                        <table class="table table-hover" id="doctorsTable">
                            <thead>
                                <tr>
                                    <th>Doctor Info</th>
                                    <th>Specialization</th>
                                    <th>Department</th>
                                    <th>Experience</th>
                                    <th>Fee</th>
                                    <th>Status</th>
                                    <th>Actions</th>
                                </tr>
                            </thead>
                            <tbody>
                                <%
                                    for (Doctor doctor : doctors) {
                                %>
                                    <tr>
                                        <td>
                                            <div class="d-flex align-items-center">
                                                <div class="icon-box icon-primary me-3 d-none d-md-flex">
                                                    <i class="fas fa-user-md"></i>
                                                </div>
                                                <div>
                                                    <strong>Dr. <%= doctor.getFullName() %></strong><br>
                                                    <small class="text-muted">
                                                        <i class="fas fa-envelope me-1"></i><%= doctor.getEmail() %>
                                                    </small><br>
                                                    <small class="text-muted">
                                                        <i class="fas fa-phone me-1"></i><%= doctor.getPhone() != null ? doctor.getPhone() : "N/A" %>
                                                    </small>
                                                </div>
                                            </div>
                                        </td>
                                        <td>
                                            <span class="badge bg-light text-dark">
                                                <i class="fas fa-stethoscope me-1"></i>
                                                <%= doctor.getSpecialization() %>
                                            </span>
                                        </td>
                                        <td>
                                            <span class="badge bg-info text-dark">
                                                <i class="fas fa-building me-1"></i>
                                                <%= doctor.getDepartment() %>
                                            </span>
                                        </td>
                                        <td>
                                            <strong><%= doctor.getExperience() %> years</strong>
                                        </td>
                                        <td>
                                            <strong class="text-success">$<%= doctor.getVisitingCharge() %></strong>
                                        </td>
                                        <td>
                                            <% if (doctor.isApproved()) { %>
                                                <span class="badge <%= doctor.isAvailability() ? "bg-success" : "bg-danger" %> text-white">
                                                    <i class="fas fa-circle me-1"></i>
                                                    <%= doctor.isAvailability() ? "Available" : "Not Available" %>
                                                </span>
                                                <br>
                                                <small class="text-success fw-bold">Approved</small>
                                            <% } else { %>
                                                <span class="badge bg-warning text-dark">
                                                    <i class="fas fa-exclamation-triangle me-1"></i>Pending
                                                </span>
                                            <% } %>
                                            </td>
                                        <td>
                                            <div class="btn-group btn-group-sm" role="group">
                                                <button type="button" class="btn btn-outline-info"
                                                        data-bs-toggle="modal" data-bs-target="#viewDoctorModal<%= doctor.getId() %>"
                                                        data-bs-toggle="tooltip" title="View Details">
                                                    <i class="fas fa-eye"></i>
                                                </button>
                                                
                                                <button type="button" class="btn btn-outline-primary"
                                                        data-bs-toggle="modal" data-bs-target="#editDoctorModal<%= doctor.getId() %>"
                                                        data-bs-toggle="tooltip" title="Edit Doctor">
                                                    <i class="fas fa-edit"></i>
                                                </button>
                                                
                                                
                                                <% if (!doctor.isApproved()) { %>
                                                    <span data-bs-toggle="tooltip" title="Approve Doctor">
                                                        <button type="button" class="btn btn-sm btn-success"
                                                                data-bs-toggle="modal"
                                                                data-bs-target="#approveModal<%= doctor.getId() %>">
                                                            <i class="fas fa-check"></i>
                                                        </button>
                                                    </span>
                                                <% } %>

                                                <span data-bs-toggle="tooltip" title="Delete Doctor">
                                                    <button type="button" class="btn btn-outline-danger"
                                                            data-bs-toggle="modal" data-bs-target="#deleteDoctorModal<%= doctor.getId() %>">
                                                        <i class="fas fa-trash"></i>
                                                    </button>
                                                </span>
                                                </div>
                                            
                                            
                                            <% if (!doctor.isApproved()) { %>
                                                <div class="modal fade" id="approveModal<%= doctor.getId() %>" tabindex="-1" aria-labelledby="approveModalLabel<%= doctor.getId() %>" aria-hidden="true">
                                                    <div class="modal-dialog modal-dialog-centered modal-sm">
                                                        <div class="modal-content">
                                                            <div class="modal-header">
                                                                <h5 class="modal-title" id="approveModalLabel<%= doctor.getId() %>">
                                                                    <i class="fas fa-check-circle me-2 text-success"></i>Confirm Approval
                                                                </h5>
                                                                <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                                                            </div>
                                                            <div class="modal-body">
                                                                Are you sure you want to approve <strong>Dr. <%= doctor.getFullName() %></strong>?
                                                                <br><br>
                                                                <small class="text-muted">This action will allow them to log in and be marked as "Approved".</small>
                                                            </div>
                                                            <div class="modal-footer">
                                                                <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cancel</button>
                                                                
                                                                <form action="${pageContext.request.contextPath}/admin/management?action=approve&type=doctor"
                                                                      method="post" class="d-inline">
                                                                    <input type="hidden" name="id" value="<%= doctor.getId() %>">
                                                                    <button type="submit" class="btn btn-success">
                                                                        <i class="fas fa-check me-1"></i>Yes, Approve
                                                                    </button>
                                                                </form>
                                                            </div>
                                                        </div>
                                                    </div>
                                                </div>
                                            <% } %>

                                            <div class="modal fade" id="deleteDoctorModal<%= doctor.getId() %>" tabindex="-1" aria-labelledby="deleteDoctorModalLabel<%= doctor.getId() %>" aria-hidden="true">
                                                <div class="modal-dialog modal-dialog-centered modal-sm">
                                                    <div class="modal-content">
                                                        <div class="modal-header">
                                                            <h5 class="modal-title" id="deleteDoctorModalLabel<%= doctor.getId() %>">
                                                                <i class="fas fa-exclamation-triangle me-2 text-danger"></i>Confirm Deletion
                                                            </h5>
                                                            <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                                                        </div>
                                                        <div class="modal-body">
                                                            Are you sure you want to <strong>PERMANENTLY DELETE</strong> Dr. <%= doctor.getFullName() %>?
                                                            <br><br>
                                                            <small class="text-danger">This action cannot be undone and may affect all associated appointments.</small>
                                                        </div>
                                                        <div class="modal-footer">
                                                            <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cancel</button>
                                                            
                                                            <form action="${pageContext.request.contextPath}/admin/management?action=delete&type=doctor"
                                                                  method="post" class="d-inline">
                                                                <input type="hidden" name="id" value="<%= doctor.getId() %>">
                                                                <button type="submit" class="btn btn-danger">
                                                                    <i class="fas fa-trash me-1"></i>Yes, Delete
                                                                </button>
                                                            </form>
                                                        </div>
                                                    </div>
                                                </div>
                                            </div>
                                            <div class="modal fade" id="editDoctorModal<%= doctor.getId() %>" tabindex="-1" aria-labelledby="editDoctorModalLabel<%= doctor.getId() %>" aria-hidden="true">
                                                <div class="modal-dialog modal-lg modal-dialog-centered">
                                                    <div class="modal-content">
                                                        <div class="modal-header">
                                                            <h5 class="modal-title" id="editDoctorModalLabel<%= doctor.getId() %>">
                                                                <i class="fas fa-edit me-2 text-primary"></i>Edit Doctor Details
                                                            </h5>
                                                            <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                                                        </div>
                                                        <form action="${pageContext.request.contextPath}/admin/management?action=update&type=doctor" method="post" class="needs-validation" novalidate>
                                                            <input type="hidden" name="doctorId" value="<%= doctor.getId() %>">
                                                            <input type="hidden" name="isApproved" value="<%= doctor.isApproved() %>"> 
                                                            <div class="modal-body">
                                                                <div class="row g-3">
                                                                    <div class="col-md-6 form-field">
                                                                        <label class="form-label" for="editFullName<%= doctor.getId() %>">Full Name</label>
                                                                        <div class="input-group">
                                                                            <span class="input-group-text">
                                                                                <i class="fas fa-user"></i>
                                                                            </span>
                                                                            <input type="text" class="form-control" id="editFullName<%= doctor.getId() %>" name="fullName"
                                                                                   value="<%= doctor.getFullName() %>" required>
                                                                        </div>
                                                                         <div class="invalid-feedback">Please enter doctor's name.</div>
                                                                    </div>
                                                                    <div class="col-md-6 form-field">
                                                                        <label class="form-label" for="editPhone<%= doctor.getId() %>">Phone</label>
                                                                        <div class="input-group">
                                                                            <span class="input-group-text">
                                                                                <i class="fas fa-phone"></i>
                                                                            </span>
                                                                            <input type="tel" class="form-control" id="editPhone<%= doctor.getId() %>" name="phone"
                                                                                   value="<%= doctor.getPhone() != null ? doctor.getPhone() : "" %>" required>
                                                                        </div>
                                                                         <div class="invalid-feedback">Please enter phone number.</div>
                                                                    </div>
                                                                    <div class="col-md-6 form-field">
                                                                        <label class="form-label" for="editSpecialization<%= doctor.getId() %>">Specialization</label>
                                                                        <div class="input-group">
                                                                            <span class="input-group-text">
                                                                                <i class="fas fa-stethoscope"></i>
                                                                            </span>
                                                                            <select class="form-select" id="editSpecialization<%= doctor.getId() %>" name="specialization" required>
                                                                                <option value="Cardiology" <%= "Cardiology".equals(doctor.getSpecialization()) ? "selected" : "" %>>Cardiology</option>
                                                                                <option value="Neurology" <%= "Neurology".equals(doctor.getSpecialization()) ? "selected" : "" %>>Neurology</option>
                                                                                <option value="Pediatrics" <%= "Pediatrics".equals(doctor.getSpecialization()) ? "selected" : "" %>>Pediatrics</option>
                                                                                <option value="Dermatology" <%= "Dermatology".equals(doctor.getSpecialization()) ? "selected" : "" %>>Dermatology</option>
                                                                                <option value="Orthopedics" <%= "Orthopedics".equals(doctor.getSpecialization()) ? "selected" : "" %>>Orthopedics</option>
                                                                                <option value="Gynecology" <%= "Gynecology".equals(doctor.getSpecialization()) ? "selected" : "" %>>Gynecology</option>
                                                                                <option value="Psychiatry" <%= "Psychiatry".equals(doctor.getSpecialization()) ? "selected" : "" %>>Psychiatry</option>
                                                                                <option value="Dentistry" <%= "Dentistry".equals(doctor.getSpecialization()) ? "selected" : "" %>>Dentistry</option>
                                                                                <option value="Ophthalmology" <%= "Ophthalmology".equals(doctor.getSpecialization()) ? "selected" : "" %>>Ophthalmology</option>
                                                                                <option value="General Medicine" <%= "General Medicine".equals(doctor.getSpecialization()) ? "selected" : "" %>>General Medicine</option>
                                                                            </select>
                                                                        </div>
                                                                        <div class="invalid-feedback">Please select specialization.</div>
                                                                    </div>
                                                                    <div class="col-md-6 form-field">
                                                                        <label class="form-label" for="editDepartment<%= doctor.getId() %>">Department</label>
                                                                        <div class="input-group">
                                                                            <span class="input-group-text">
                                                                                <i class="fas fa-building"></i>
                                                                            </span>
                                                                            <input type="text" class="form-control" id="editDepartment<%= doctor.getId() %>" name="department"
                                                                                   value="<%= doctor.getDepartment() %>" required>
                                                                        </div>
                                                                         <div class="invalid-feedback">Please enter department.</div>
                                                                    </div>
                                                                    <div class="col-md-6 form-field">
                                                                        <label class="form-label" for="editQualification<%= doctor.getId() %>">Qualification</label>
                                                                        <div class="input-group">
                                                                            <span class="input-group-text">
                                                                                <i class="fas fa-graduation-cap"></i>
                                                                            </span>
                                                                            <input type="text" class="form-control" id="editQualification<%= doctor.getId() %>" name="qualification"
                                                                                   value="<%= doctor.getQualification() %>" required>
                                                                        </div>
                                                                        <div class="invalid-feedback">Please enter qualifications.</div>
                                                                    </div>
                                                                    <div class="col-md-6 form-field">
                                                                        <label class="form-label" for="editExperience<%= doctor.getId() %>">Experience (Years)</label>
                                                                        <div class="input-group">
                                                                            <span class="input-group-text">
                                                                                <i class="fas fa-briefcase"></i>
                                                                            </span>
                                                                            <input type="number" class="form-control" id="editExperience<%= doctor.getId() %>" name="experience"
                                                                                   value="<%= doctor.getExperience() %>" min="0" max="60" required>
                                                                        </div>
                                                                         <div class="invalid-feedback">Please enter valid experience (0-60).</div>
                                                                    </div>
                                                                    <div class="col-md-6 form-field">
                                                                        <label class="form-label" for="editVisitingCharge<%= doctor.getId() %>">Visiting Charge ($)</label>
                                                                        <div class="input-group">
                                                                            <span class="input-group-text">
                                                                                <i class="fas fa-dollar-sign"></i>
                                                                            </span>
                                                                            <input type="number" class="form-control" id="editVisitingCharge<%= doctor.getId() %>" name="visitingCharge"
                                                                                   value="<%= doctor.getVisitingCharge() %>" min="0" step="0.01" required>
                                                                        </div>
                                                                        <div class="invalid-feedback">Please enter visiting charge.</div>
                                                                    </div>
                                                                    <div class="col-md-6 d-flex align-items-center form-field">
                                                                        <div class="form-check form-switch mt-3">
                                                                            <input class="form-check-input" type="checkbox" id="editAvailability<%= doctor.getId() %>" name="availability"
                                                                                   <%= doctor.isAvailability() ? "checked" : "" %> value="true">
                                                                            <label class="form-check-label" for="editAvailability<%= doctor.getId() %>">Available for appointments</label>
                                                                        </div>
                                                                    </div>
                                                                </div>
                                                            </div>
                                                            <div class="modal-footer">
                                                                <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cancel</button>
                                                                <button type="submit" class="btn btn-primary">
                                                                     <i class="fas fa-save me-1"></i>Update Doctor
                                                                </button>
                                                            </div>
                                                        </form>
                                                    </div>
                                                </div>
                                            </div>
                                            
                                            <div class="modal fade" id="viewDoctorModal<%= doctor.getId() %>" tabindex="-1" aria-labelledby="viewDoctorModalLabel<%= doctor.getId() %>" aria-hidden="true">
                                                <div class="modal-dialog modal-lg modal-dialog-centered">
                                                    <div class="modal-content">
                                                        <div class="modal-header">
                                                            <h5 class="modal-title" id="viewDoctorModalLabel<%= doctor.getId() %>">
                                                                <i class="fas fa-user-md me-2 text-info"></i>Doctor Details
                                                            </h5>
                                                            <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                                                        </div>
                                                        <div class="modal-body">
                                                            <div class="row mb-3">
                                                                <div class="col-sm-4">
                                                                    <strong class="text-muted"><i class="fas fa-shield-alt me-2"></i>Approval Status</strong>
                                                                </div>
                                                                <div class="col-sm-8">
                                                                    <% if (doctor.isApproved()) { %>
                                                                        <span class="badge bg-success">Approved</span>
                                                                    <% } else { %>
                                                                        <span class="badge bg-warning text-dark">Pending Admin Approval</span>
                                                                    <% } %>
                                                                </div>
                                                            </div>
                                                            <hr>
                                                            <div class="row mb-3">
                                                                <div class="col-sm-4">
                                                                    <strong class="text-muted"><i class="fas fa-user me-2"></i>Full Name</strong>
                                                                </div>
                                                                <div class="col-sm-8">
                                                                    Dr. <%= doctor.getFullName() %>
                                                                </div>
                                                            </div>
                                                            <hr>
                                                            <div class="row mb-3">
                                                                <div class="col-sm-4">
                                                                    <strong class="text-muted"><i class="fas fa-envelope me-2"></i>Email</strong>
                                                                </div>
                                                                <div class="col-sm-8">
                                                                    <%= doctor.getEmail() %>
                                                                </div>
                                                            </div>
                                                            <hr>
                                                            <div class="row mb-3">
                                                                <div class="col-sm-4">
                                                                    <strong class="text-muted"><i class="fas fa-phone me-2"></i>Phone</strong>
                                                                </div>
                                                                <div class="col-sm-8">
                                                                    <%= doctor.getPhone() != null ? doctor.getPhone() : "N/A" %>
                                                                </div>
                                                            </div>
                                                            <hr>
                                                            <div class="row mb-3">
                                                                <div class="col-sm-4">
                                                                    <strong class="text-muted"><i class="fas fa-stethoscope me-2"></i>Specialization</strong>
                                                                </div>
                                                                <div class="col-sm-8">
                                                                    <%= doctor.getSpecialization() %>
                                                                </div>
                                                            </div>
                                                            <hr>
                                                             <div class="row mb-3">
                                                                <div class="col-sm-4">
                                                                    <strong class="text-muted"><i class="fas fa-building me-2"></i>Department</strong>
                                                                </div>
                                                                <div class="col-sm-8">
                                                                    <%= doctor.getDepartment() %>
                                                                </div>
                                                            </div>
                                                            <hr>
                                                            <div class="row mb-3">
                                                                <div class="col-sm-4">
                                                                    <strong class="text-muted"><i class="fas fa-graduation-cap me-2"></i>Qualification</strong>
                                                                </div>
                                                                <div class="col-sm-8">
                                                                    <%= doctor.getQualification() %>
                                                                </div>
                                                            </div>
                                                            <hr>
                                                            <div class="row mb-3">
                                                                <div class="col-sm-4">
                                                                    <strong class="text-muted"><i class="fas fa-briefcase me-2"></i>Experience</strong>
                                                                </div>
                                                                <div class="col-sm-8">
                                                                    <%= doctor.getExperience() %> years
                                                                </div>
                                                            </div>
                                                            <hr>
                                                            <div class="row mb-3">
                                                                <div class="col-sm-4">
                                                                    <strong class="text-muted"><i class="fas fa-dollar-sign me-2"></i>Visiting Charge</strong>
                                                                </div>
                                                                <div class="col-sm-8">
                                                                    <strong class="text-success">$<%= doctor.getVisitingCharge() %></strong>
                                                                </div>
                                                            </div>
                                                            <hr>
                                                            <div class="row mb-3">
                                                                <div class="col-sm-4">
                                                                    <strong class="text-muted"><i class="fas fa-toggle-on me-2"></i>Availability</strong>
                                                                </div>
                                                                <div class="col-sm-8">
                                                                     <span class="badge <%= doctor.isAvailability() ? "bg-success" : "bg-danger" %> text-white">
                                                                        <i class="fas fa-circle me-1"></i>
                                                                        <%= doctor.isAvailability() ? "Available" : "Not Available" %>
                                                                    </span>
                                                                </div>
                                                            </div>
                                                        </div>
                                                        <div class="modal-footer">
                                                            <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Close</button>
                                                        </div>
                                                    </div>
                                                </div>
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
    </main>

    <div class="modal fade" id="addDoctorModal" tabindex="-1" aria-labelledby="addDoctorModalLabel" aria-hidden="true">
        <div class="modal-dialog modal-lg modal-dialog-centered">
            <div class="modal-content">
                <div class="modal-header">
                    <h5 class="modal-title" id="addDoctorModalLabel">
                        <i class="fas fa-user-plus me-2 text-primary"></i>Add New Doctor
                    </h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                </div>
                <form action="${pageContext.request.contextPath}/admin/management?action=add&type=doctor" method="post" class="needs-validation" novalidate>
                    <div class="modal-body">
                        <div class="row g-3">
                            <div class="col-md-6 form-field">
                                <label class="form-label" for="addFullName">Full Name</label>
                                <div class="input-group">
                                    <span class="input-group-text">
                                        <i class="fas fa-user"></i>
                                    </span>
                                    <input type="text" class="form-control" id="addFullName" name="fullName" required placeholder="Dr. Full Name">
                                </div>
                                <div class="invalid-feedback">Please enter doctor's name.</div>
                            </div>
                            <div class="col-md-6 form-field">
                                <label class="form-label" for="addEmail">Email Address</label>
                                <div class="input-group">
                                    <span class="input-group-text">
                                        <i class="fas fa-envelope"></i>
                                    </span>
                                    <input type="email" class="form-control" id="addEmail" name="email" required placeholder="doctor@hospital.com">
                                </div>
                                <div class="invalid-feedback">Please enter valid email.</div>
                            </div>
                            
                            <div class="col-md-6 form-field">
                                <label class="form-label" for="addPassword">Password</label>
                                <div class="input-group" style="position: relative;">
                                    <span class="input-group-text">
                                        <i class="fas fa-lock"></i>
                                    </span>
                                    <input type="password" class="form-control" id="addPassword" name="password" 
                                           required 
                                           minlength="8" 
                                           pattern="(?=.*\d)(?=.*[a-z])(?=.*[A-Z])(?=.*[!@#$%^&*]).{8,}"
                                           placeholder="Create a strong password"
                                           title="Must be 8+ chars, with uppercase, lowercase, number, and special character.">
                                    <span class="password-toggle-icon" id="toggleAddPassword">
                                        <i class="fas fa-eye"></i>
                                    </span>
                                </div>
                                
                                <div id="password-strength-criteria" class="mt-2">
                                    <h6 class="fs-6 fw-medium">Password strength</h6>
                                    <ul class="list-unstyled">
                                        <li id="pass-length" class="criterion invalid">
                                            <i class="fas fa-circle"></i>
                                            <span>At least 8 characters</span>
                                        </li>
                                        <li id="pass-lower" class="criterion invalid">
                                            <i class="fas fa-circle"></i>
                                            <span>One lowercase letter</span>
                                        </li>
                                        <li id="pass-upper" class="criterion invalid">
                                            <i class="fas fa-circle"></i>
                                            <span>One uppercase letter</span>
                                        </li>
                                        <li id="pass-num" class="criterion invalid">
                                            <i class="fas fa-circle"></i>
                                            <span>One number</span>
                                        </li>
                                        <li id="pass-special" class="criterion invalid">
                                            <i class="fas fa-circle"></i>
                                            <span>One special character</span>
                                        </li>
                                    </ul>
                                </div>
                            
                                <div class="invalid-feedback">
                                    Password does not meet all requirements. Please check the list above.
                                </div>
                            </div>
                            
                            <div class="col-md-6 form-field">
                                <label class="form-label" for="addPhone">Phone Number</label>
                                <div class="input-group">
                                    <span class="input-group-text">
                                        <i class="fas fa-phone"></i>
                                    </span>
                                    <input type="tel" class="form-control" id="addPhone" name="phone" required placeholder="Phone number">
                                </div>
                                <div class="invalid-feedback">Please enter phone number.</div>
                            </div>
                            <div class="col-md-6 form-field">
                                <label class="form-label" for="addSpecialization">Specialization</label>
                                <div class="input-group">
                                    <span class="input-group-text">
                                        <i class="fas fa-stethoscope"></i>
                                    </span>
                                    <select class="form-select" id="addSpecialization" name="specialization" required>
                                        <option value="" selected disabled>Select Specialization</option>
                                        <option value="Cardiology">Cardiology</option>
                                        <option value="Neurology">Neurology</option>
                                        <option value="Pediatrics">Pediatrics</option>
                                        <option value="Dermatology">Dermatology</option>
                                        <option value="Orthopedics">Orthopedics</option>
                                        <option value="Gynecology">Gynecology</option>
                                        <option value="Psychiatry">Psychiatry</option>
                                        <option value="Dentistry">Dentistry</option>
                                        <option value="Ophthalmology">Ophthalmology</option>
                                        <option value="General Medicine">General Medicine</option>
                                    </select>
                                </div>
                                <div class="invalid-feedback">Please select specialization.</div>
                            </div>
                            <div class="col-md-6 form-field">
                                <label class="form-label" for="addDepartment">Department</label>
                                <div class="input-group">
                                    <span class="input-group-text">
                                        <i class="fas fa-building"></i>
                                    </span>
                                    <input type="text" class="form-control" id="addDepartment" name="department" required placeholder="Department name">
                                </div>
                                <div class="invalid-feedback">Please enter department.</div>
                            </div>
                            <div class="col-12 form-field">
                                <label class="form-label" for="addQualification">Qualifications</label>
                                <div class="input-group">
                                    <span class="input-group-text">
                                        <i class="fas fa-graduation-cap"></i>
                                    </span>
                                    <input type="text" class="form-control" id="addQualification" name="qualification" required placeholder="MD, MBBS, etc.">
                                </div>
                                <div class="invalid-feedback">Please enter qualifications.</div>
                            </div>
                            <div class="col-md-6 form-field">
                                <label class="form-label" for="addExperience">Experience (Years)</label>
                                <div class="input-group">
                                    <span class="input-group-text">
                                        <i class="fas fa-briefcase"></i>
                                    </span>
                                    <input type="number" class="form-control" id="addExperience" name="experience" required min="0" max="60" placeholder="Years of experience">
                                </div>
                                <div class="invalid-feedback">Please enter valid experience (0-60).</div>
                            </div>
                            <div class="col-md-6 form-field">
                                <label class="form-label" for="addVisitingCharge">Visiting Charge ($)</label>
                                <div class="input-group">
                                    <span class="input-group-text">
                                        <i class="fas fa-dollar-sign"></i>
                                    </span>
                                    <input type="number" class="form-control" id="addVisitingCharge" name="visitingCharge" required min="0" step="0.01" placeholder="Consultation fee">
                                </div>
                                <div class="invalid-feedback">Please enter visiting charge.</div>
                            </div>
                        </div>
                    </div>
                    <div class="modal-footer">
                        <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cancel</button>
                        <button type="submit" class="btn btn-primary">
                             <i class="fas fa-plus me-1"></i>Add Doctor
                        </button>
                    </div>
                </form>
            </div>
        </div>
    </div>
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
            // Initialize tooltips
            const tooltipTriggerList = [].slice.call(document.querySelectorAll('[data-bs-toggle="tooltip"]'));
            const tooltipList = tooltipTriggerList.map(function (tooltipTriggerEl) {
                if (typeof bootstrap !== 'undefined' && bootstrap.Tooltip) {
                     return new bootstrap.Tooltip(tooltipTriggerEl);
                }
                 return null;
            }).filter(tooltip => tooltip !== null);

            // Form validation (for modals)
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

             // Fix for checkbox in Edit Modal (Robust Version)
             const editForms = document.querySelectorAll('form[action*="action=update&type=doctor"]');
             editForms.forEach(form => {
                 form.addEventListener('submit', function(event) {
                     // Find the actual checkbox and any "stale" hidden input
                     const availabilityCheckbox = form.querySelector('input[name="availability"][type="checkbox"]');
                     const existingHiddenInput = form.querySelector('input[name="availability"][type="hidden"]');
 
                     // 1. ALWAYS remove any hidden input that might exist from a previous failed submit
                     if (existingHiddenInput) {
                         existingHiddenInput.remove();
                     }
 
                     // 2. If the checkbox is currently unchecked, add a new hidden input with "false"
                     if (availabilityCheckbox && !availabilityCheckbox.checked) {
                         const hiddenInput = document.createElement('input');
                         hiddenInput.type = 'hidden';
                         hiddenInput.name = 'availability';
                         hiddenInput.value = 'false';
                         form.appendChild(hiddenInput);
                     }
                     
                     // 3. We also need to explicitly ensure the isApproved status is sent correctly
                     // (Handled by the hidden input in the form, which is correct.)
                 });
             });

            // ========== REMOVED OLD DELETE CONFIRM JAVASCRIPT ==========
            // const deleteButtons = document.querySelectorAll('.delete-doctor'); ...
            // This is no longer needed as the modal handles the confirmation.

            // Search functionality
            const searchInput = document.getElementById('doctorSearchInput');
            const tableBody = document.querySelector('#doctorsTable tbody');
            const rows = tableBody ? tableBody.querySelectorAll('tr') : [];

            if (searchInput) {
                searchInput.addEventListener('input', function() {
                    const searchTerm = this.value.toLowerCase().trim();

                    rows.forEach(row => {
                        const doctorInfoCell = row.cells[0];
                        const text = doctorInfoCell ? doctorInfoCell.textContent.toLowerCase() : '';

                        if (text.includes(searchTerm)) {
                            row.style.display = '';
                        } else {
                            row.style.display = 'none';
                        }
                    });
                });
            }
            
            // === Password Strength Checker & Toggle ===
            const passField = document.getElementById('addPassword');
            const passToggle = document.getElementById('toggleAddPassword');
            
            const critLength = document.getElementById('pass-length');
            const critLower = document.getElementById('pass-lower');
            const critUpper = document.getElementById('pass-upper');
            const critNum = document.getElementById('pass-num');
            const critSpecial = document.getElementById('pass-special');

            const criteria = [
                { el: critLength,  regex: /.{8,}/ },
                { el: critLower,   regex: /[a-z]/ },
                { el: critUpper,   regex: /[A-Z]/ },
                { el: critNum,     regex: /\d/ },
                { el: critSpecial, regex: /[!@#$%^&*]/ }
            ];

            if (passField) {
                passField.addEventListener('input', function() {
                    const password = passField.value;

                    criteria.forEach(item => {
                        if (!item.el) return; // Guard clause
                        const icon = item.el.querySelector('i');
                        if (!icon) return; // Guard clause
                        
                        if (item.regex.test(password)) {
                            item.el.classList.remove('invalid');
                            item.el.classList.add('valid');
                            icon.classList.remove('fa-circle');
                            icon.classList.add('fa-check-circle'); // Use checkmark icon
                        } else {
                            item.el.classList.remove('valid');
                            item.el.classList.add('invalid');
                            icon.classList.remove('fa-check-circle');
                            icon.classList.add('fa-circle'); // Use circle icon
                        }
                    });
                });
            }

            if (passToggle) {
                passToggle.addEventListener('click', function() {
                    const icon = this.querySelector('i');
                    if (passField.type === 'password') {
                        passField.type = 'text';
                        icon.classList.remove('fa-eye');
                        icon.classList.add('fa-eye-slash');
                    } else {
                        passField.type = 'password';
                        icon.classList.remove('fa-eye-slash');
                        icon.classList.add('fa-eye');
                    }
                });
            }
            // === End Password Strength Checker ===
            
        });
    </script>
</body>
</html>