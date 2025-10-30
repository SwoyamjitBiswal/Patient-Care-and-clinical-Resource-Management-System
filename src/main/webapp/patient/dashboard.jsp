<%@ page import="com.entity.Patient" %>
<%@ page import="com.dao.AppointmentDao" %>
<%@ page import="java.util.List" %>
<%@ page import="com.entity.Appointment" %>

<%
    // Use unique variable name
    Patient currentPatient = (Patient) session.getAttribute("patientObj");
    if (currentPatient == null) {
        response.sendRedirect(request.getContextPath() + "/patient/login.jsp");
        return;
    }
    
    AppointmentDao appointmentDao = new AppointmentDao();
    List<Appointment> appointments = appointmentDao.getAppointmentsByPatientId(currentPatient.getId());
    
    // Count appointments by status
    int totalAppointments = appointments.size();
    int pendingAppointments = 0;
    int confirmedAppointments = 0;
    int completedAppointments = 0;
    
    // --- START OF FIX 1 ---
    // This loop now treats null status as "Pending"
    for (Appointment app : appointments) {
        String status = app.getStatus();
        if (status == null) {
            status = "Pending"; // Treat null as Pending
        }
        
        switch (status) {
            case "Pending": pendingAppointments++; break;
            case "Confirmed": confirmedAppointments++; break;
            case "Completed": completedAppointments++; break;
        }
    }
    // --- END OF FIX 1 ---
%>
                <%
                    // This block is now correct and will set the variable
                    // for your logout link
                    String currentUserRole = "";
                    if (session.getAttribute("patientObj") != null) {
                        currentUserRole = "patient";
                    } else if (session.getAttribute("doctorObj") != null) {
                        currentUserRole = "doctor";
                    } else if (session.getAttribute("adminObj") != null) {
                        currentUserRole = "admin";
                    }
                %>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Patient Care System - Patient Dashboard</title>
    
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" rel="stylesheet">
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700&display=swap" rel="stylesheet">
    
    <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
    
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
        
        /* Dashboard Styles */
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
        
        .user-welcome {
            display: flex;
            align-items: center;
            gap: 0.5rem;
            padding: 0.75rem 1.25rem;
            background: white;
            border-radius: var(--border-radius);
            box-shadow: var(--shadow);
            font-weight: 500;
            color: var(--dark);
            border: 1px solid #e5e7eb;
        }
        
        .user-welcome i {
            color: var(--primary);
        }
        
        .stats-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(240px, 1fr));
            gap: 1.5rem;
            margin-bottom: 2rem;
        }
        
        .stats-card {
            color: white;
            padding: 1.5rem;
            display: flex;
            align-items: center;
            justify-content: space-between;
            border-radius: var(--border-radius);
            box-shadow: var(--shadow);
            transition: var(--transition);
            position: relative;
            overflow: hidden;
            min-height: 120px;
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
        
        .stats-card:hover {
            transform: translateY(-5px);
            box-shadow: var(--shadow-lg);
        }
        
        .stats-card-content {
            position: relative;
            z-index: 2;
            text-align: right;
        }
        
        .stats-card i {
            font-size: 2.5rem;
            opacity: 0.9;
            position: relative;
            z-index: 2;
        }
        
        .stats-card .number {
            font-size: 2rem;
            font-weight: 700;
            margin-bottom: 0.25rem;
        }
        
        .stats-card .label {
            font-size: 0.9rem;
            font-weight: 500;
            opacity: 0.9;
        }
        
        .stats-total { background: linear-gradient(135deg, var(--primary), #6366f1); }
        .stats-pending { background: linear-gradient(135deg, var(--warning), #f59e0b); }
        .stats-confirmed { background: linear-gradient(135deg, var(--success), #10b981); }
        .stats-completed { background: linear-gradient(135deg, var(--info), #0ea5e9); }

        .content-grid {
            display: grid;
            grid-template-columns: 2fr 1fr;
            gap: 1.5rem;
        }
        
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
        
        .btn {
            display: inline-flex;
            align-items: center;
            gap: 0.5rem;
            padding: 0.5rem 1rem;
            font-weight: 500;
            border-radius: var(--border-radius);
            text-decoration: none;
            transition: var(--transition);
            border: none;
            cursor: pointer;
            font-size: 0.9rem;
        }
        
        .btn-sm {
            padding: 0.375rem 0.75rem;
            font-size: 0.8rem;
        }
        
        .btn-primary {
            background-color: var(--primary);
            color: white;
        }
        
        .btn-primary:hover {
            background-color: var(--primary-dark);
            transform: translateY(-2px);
            box-shadow: 0 4px 12px rgba(79, 70, 229, 0.3);
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
        
        .empty-state {
            text-align: center;
            padding: 3rem 1rem;
        }
        
        .empty-state i {
            font-size: 4rem;
            color: #d1d5db;
            margin-bottom: 1rem;
        }
        
        .empty-state h5 {
            color: #6b7280;
            margin-bottom: 0.5rem;
            font-size: 1.25rem;
        }
        
        .empty-state p {
            color: #9ca3af;
            margin-bottom: 1.5rem;
        }
        
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
        }
        
        .table tbody tr:hover {
            background-color: #f9fafb;
        }
        
        .table tbody tr:last-child td {
            border-bottom: none;
        }
        
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
        
        .actions-grid {
            display: grid;
            gap: 0.75rem;
        }
        
        .chart-container {
            position: relative;
            height: 250px;
            width: 100%;
        }
        
        /* Enhanced Quick Actions */
        .quick-action-card {
            background: white;
            border-radius: var(--border-radius);
            padding: 1.5rem;
            text-align: center;
            border: 1px solid #f3f4f6;
            transition: var(--transition);
            text-decoration: none;
            color: inherit;
            display: block;
        }
        
        .quick-action-card:hover {
            transform: translateY(-3px);
            box-shadow: var(--shadow-lg);
            border-color: var(--primary);
            text-decoration: none;
            color: inherit;
        }
        
        .quick-action-icon {
            width: 60px;
            height: 60px;
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
            margin: 0 auto 1rem;
            font-size: 1.5rem;
            color: white;
        }
        
        .quick-action-primary .quick-action-icon {
            background: linear-gradient(135deg, var(--primary), #6366f1);
        }
        
        .quick-action-secondary .quick-action-icon {
            background: linear-gradient(135deg, var(--success), #10b981);
        }
        
        .quick-action-tertiary .quick-action-icon {
            background: linear-gradient(135deg, var(--info), #0ea5e9);
        }
        
        .quick-action-card h4 {
            font-size: 1rem;
            font-weight: 600;
            margin-bottom: 0.5rem;
            color: var(--dark);
        }
        
        .quick-action-card p {
            color: #6b7280;
            font-size: 0.875rem;
            margin: 0;
        }
        
        @media (max-width: 1024px) {
            .content-grid {
                grid-template-columns: 1fr;
            }
        }
        
        @media (max-width: 640px) {
            .stats-grid {
                grid-template-columns: 1fr;
            }
            
            .page-header {
                flex-direction: column;
                align-items: flex-start;
                gap: 1rem;
            }
            
            .user-welcome {
                align-self: stretch;
                text-align: center;
            }
        }

        /* Enhanced appointment table */
        .appointment-doctor {
            display: flex;
            align-items: center;
            gap: 0.75rem;
        }
        
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
            flex-shrink: 0;
        }
        
        .doctor-info {
            flex: 1;
        }
        
        .doctor-name {
            font-weight: 600;
            color: var(--dark);
            margin-bottom: 0.25rem;
        }
        
        .doctor-specialty {
            font-size: 0.875rem;
            color: #6b7280;
        }
        
        .appointment-time {
            font-weight: 600;
            color: var(--dark);
            margin-bottom: 0.25rem;
        }
        
        .appointment-date {
            font-size: 0.875rem;
            color: #6b7280;
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
                    <%
                        if (currentPatient != null) {
                    %>
                    <h6><%= currentPatient.getFullName() %></h6>
                    <span class="badge">Patient</span>
                    <% } %>
                </div>
            </div>
            
            <div class="nav-main">
                <ul class="nav">
                    <li class="nav-item">
                        <a class="nav-link active" 
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
                <i class="fas fa-tachometer-alt"></i>
                Patient Dashboard
            </h1>
            <div class="user-welcome">
                <i class="fas fa-user-circle"></i>
                <span>Welcome, <%= currentPatient.getFullName() %></span>
            </div>
        </div>

        <div class="stats-grid">
            <div class="stats-card stats-total">
                <i class="fas fa-calendar-check"></i>
                <div class="stats-card-content">
                    <div class="number"><%= totalAppointments %></div>
                    <div class="label">Total Appointments</div>
                </div>
            </div>
            <div class="stats-card stats-pending">
                <i class="fas fa-clock"></i>
                <div class="stats-card-content">
                    <div class="number"><%= pendingAppointments %></div>
                    <div class="label">Pending</div>
                </div>
            </div>
            <div class="stats-card stats-confirmed">
                <i class="fas fa-check-circle"></i>
                <div class="stats-card-content">
                    <div class="number"><%= confirmedAppointments %></div>
                    <div class="label">Confirmed</div>
                </div>
            </div>
            <div class="stats-card stats-completed">
                <i class="fas fa-calendar-check"></i>
                <div class="stats-card-content">
                    <div class="number"><%= completedAppointments %></div>
                    <div class="label">Completed</div>
                </div>
            </div>
        </div>

        <div class="content-grid">
            <div class="card">
                <div class="card-header">
                    <h2 class="card-title">
                        <i class="fas fa-list-alt"></i>
                        Recent Appointments
                    </h2>
                    <a href="${pageContext.request.contextPath}/patient/appointment?action=view" class="btn btn-primary btn-sm">
                        <i class="fas fa-eye"></i>
                        View All
                    </a>
                </div>
                <div class="card-body">
                    <%
                        if (appointments.isEmpty()) {
                    %>
                            <div class="empty-state">
                                <i class="fas fa-calendar-times"></i>
                                <h5>No Appointments Yet</h5>
                                <p>You haven't booked any appointments yet.</p>
                                <a href="${pageContext.request.contextPath}/patient/appointment?action=book" class="btn btn-primary">
                                    <i class="fas fa-calendar-plus"></i>
                                    Book Your First Appointment
                                </a>
                            </div>
                    <%
                        } else {
                            List<Appointment> recentAppointments = appointments.subList(0, Math.min(5, appointments.size()));
                    %>
                            <div class="table-responsive">
                                <table class="table">
                                    <thead>
                                        <tr>
                                            <th>Doctor</th>
                                            <th>Date & Time</th>
                                            <th>Type</th>
                                            <th>Status</th>
                                            <th>Action</th>
                                        </tr>
                                    </thead>
                                    <tbody>
                                    <%
                                        // --- START OF FIX 2 ---
                                        for (Appointment app : recentAppointments) {
                                            String statusBadgeClass = "";
                                            String status = app.getStatus(); 
                                            if (status == null) {
                                                status = "Pending"; // Treat null as Pending
                                            }

                                            switch (status) { 
                                                case "Pending": statusBadgeClass = "badge-pending"; break;
                                                case "Confirmed": statusBadgeClass = "badge-confirmed"; break;
                                                case "Completed": statusBadgeClass = "badge-completed"; break;
                                                case "Cancelled": statusBadgeClass = "badge-cancelled"; break;
                                                default: statusBadgeClass = "badge-light"; break;
                                            }
                                    %>
                                        <tr>
                                            <td>
                                                <div class="appointment-doctor">
                                                    <div class="doctor-avatar">
                                                        <i class="fas fa-user-md"></i>
                                                    </div>
                                                    <div class="doctor-info">
                                                        <div class="doctor-name"><%= app.getDoctorName() %></div>
                                                        <div class="doctor-specialty"><%= app.getDoctorSpecialization() %></div>
                                                    </div>
                                                </div>
                                            </td>
                                            <td>
                                                <div class="appointment-time"><%= app.getAppointmentTime() %></div>
                                                <div class="appointment-date"><%= app.getAppointmentDate() %></div>
                                            </td>
                                            <td>
                                                <span class="badge badge-light"><%= app.getAppointmentType() %></span>
                                            </td>
                                            <td>
                                                <span class="badge <%= statusBadgeClass %>"><%= status %></span>
                                            </td>
                                            <td>
                                                <a href="${pageContext.request.contextPath}/patient/appointment?action=details&id=<%= app.getId() %>" 
                                                   class="btn btn-outline-primary btn-sm">
                                                    <i class="fas fa-eye"></i>
                                                    View
                                                </a>
                                            </td>
                                        </tr>
                                    <%
                                        }
                                        // --- END OF FIX 2 ---
                                    %>
                                    </tbody>
                                </table>
                            </div>
                    <%
                        }
                    %>
                </div>
            </div>

            <div>
                                            <div class="card" >
                    <div class="card-header">
                        <h2 class="card-title">
                            <i class="fas fa-chart-pie"></i>
                            Appointment Status
                        </h2>
                    </div>
                    <div class="card-body">
                        <div class="chart-container">
                            <canvas id="statusChart"></canvas>
                        </div>
                    </div>
                </div>
                <div class="card" style="margin-top: 1.5rem;">
                
                    <div class="card-header" >
                        <h2 class="card-title">
                            <i class="fas fa-bolt"></i>
                            Quick Actions
                        </h2>
                    </div>
                    <div class="card-body" >
                        <div class="actions-grid">
                            <a href="${pageContext.request.contextPath}/patient/appointment?action=book" 
                               class="quick-action-card quick-action-primary">
                                <div class="quick-action-icon">
                                    <i class="fas fa-calendar-plus"></i>
                                </div>
                                <h4>Book Appointment</h4>
                                <p>Schedule a new appointment with a doctor</p>
                            </a>
                            
                            <a href="${pageContext.request.contextPath}/patient/profile" 
                               class="quick-action-card quick-action-secondary">
                                <div class="quick-action-icon">
                                    <i class="fas fa-user-edit"></i>
                                </div>
                                <h4>Update Profile</h4>
                                <p>Manage your personal information</p>
                            </a>
                            
                            <a href="${pageContext.request.contextPath}/patient/appointment?action=view" 
                               class="quick-action-card quick-action-tertiary">
                                <div class="quick-action-icon">
                                    <i class="fas fa-list"></i>
                                </div>
                                <h4>View Appointments</h4>
                                <p>See all your scheduled appointments</p>
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
            if (document.getElementById('statusChart')) {
                const ctx = document.getElementById('statusChart').getContext('2d');
                new Chart(ctx, {
                    type: 'doughnut',
                    data: {
                        labels: ['Pending', 'Confirmed', 'Completed'],
                        datasets: [{
                            data: [<%= pendingAppointments %>, <%= confirmedAppointments %>, <%= completedAppointments %>],
                            backgroundColor: [
                                'rgba(245, 158, 11, 0.8)',
                                'rgba(16, 185, 129, 0.8)',
                                'rgba(14, 165, 233, 0.8)'
                            ],
                            borderColor: [
                                'rgba(245, 158, 11, 1)',
                                'rgba(16, 185, 129, 1)',
                                'rgba(14, 165, 233, 1)'
                            ],
                            borderWidth: 1
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
            }
        });
    </script>
</body>
</html>