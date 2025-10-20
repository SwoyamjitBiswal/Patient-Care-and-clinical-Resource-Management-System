<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>MediCare - Patient Dashboard</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/fullcalendar@5.11.3/main.min.css" rel="stylesheet">
    <style>
        :root {
            --primary: #1e40af;
            --primary-light: #3b82f6;
            --primary-lighter: #dbeafe;
            --primary-dark: #1e3a8a;
            --secondary: #64748b;
            --accent: #0ea5e9;
            --success: #10b981;
            --warning: #f59e0b;
            --danger: #ef4444;
            --light: #f8fafc;
            --white: #ffffff;
            --gray-light: #f1f5f9;
            --gray: #94a3b8;
            --dark: #1e293b;
            --text: #334155;
            --text-light: #64748b;
            --shadow: 0 1px 3px 0 rgba(0, 0, 0, 0.1), 0 1px 2px 0 rgba(0, 0, 0, 0.06);
            --shadow-md: 0 4px 6px -1px rgba(0, 0, 0, 0.1), 0 2px 4px -1px rgba(0, 0, 0, 0.06);
            --shadow-lg: 0 10px 15px -3px rgba(0, 0, 0, 0.1), 0 4px 6px -2px rgba(0, 0, 0, 0.05);
            --radius: 12px;
            --radius-sm: 8px;
        }

        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
            font-family: 'Inter', 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
        }

        body {
            background-color: #f8fafc;
            color: var(--text);
            line-height: 1.6;
        }

        /* Enhanced Sidebar */
        .sidebar {
            background: linear-gradient(180deg, var(--primary) 0%, var(--primary-dark) 100%);
            color: white;
            height: 100vh;
            position: fixed;
            width: 280px;
            transition: all 0.3s;
            z-index: 1000;
            box-shadow: var(--shadow-lg);
            display: flex;
            flex-direction: column;
        }

        .sidebar-header {
            padding: 24px 20px;
            text-align: center;
            border-bottom: 1px solid rgba(255, 255, 255, 0.1);
            background-color: rgba(255, 255, 255, 0.05);
        }

        .sidebar-header h3 {
            font-weight: 700;
            margin-bottom: 0;
            font-size: 1.5rem;
            display: flex;
            align-items: center;
            justify-content: center;
            gap: 10px;
        }

        .sidebar-header p {
            opacity: 0.8;
            font-size: 0.9rem;
            margin-bottom: 0;
            margin-top: 5px;
        }

        .sidebar-menu {
            padding: 20px 0;
            flex: 1;
            display: flex;
            flex-direction: column;
        }

        .nav-link {
            color: rgba(255, 255, 255, 0.85);
            padding: 14px 20px;
            margin: 4px 12px;
            border-radius: var(--radius-sm);
            transition: all 0.3s;
            display: flex;
            align-items: center;
            gap: 14px;
            font-weight: 500;
            position: relative;
        }

        .nav-link:hover, .nav-link.active {
            background-color: rgba(255, 255, 255, 0.15);
            color: white;
            transform: translateX(5px);
        }

        .nav-link i {
            width: 20px;
            text-align: center;
            font-size: 1.1rem;
        }

        /* Main Content Area */
        .main-content {
            margin-left: 280px;
            padding: 24px;
            transition: all 0.3s;
            min-height: 100vh;
        }

        /* Enhanced Header */
        .header {
            background: white;
            border-radius: var(--radius);
            padding: 20px 30px;
            margin-bottom: 30px;
            box-shadow: var(--shadow-md);
            display: flex;
            justify-content: space-between;
            align-items: center;
            border-left: 4px solid var(--primary);
        }

        .header-title h1 {
            color: var(--primary);
            font-weight: 700;
            margin-bottom: 5px;
            font-size: 1.8rem;
        }

        .header-title p {
            color: var(--text-light);
            margin-bottom: 0;
            font-size: 1rem;
        }

        .user-info {
            display: flex;
            align-items: center;
            gap: 15px;
            background: var(--primary-lighter);
            padding: 10px 18px;
            border-radius: var(--radius-sm);
        }

        .user-avatar {
            width: 48px;
            height: 48px;
            border-radius: 50%;
            background: var(--primary);
            color: white;
            display: flex;
            align-items: center;
            justify-content: center;
            font-weight: bold;
            font-size: 1.3rem;
            box-shadow: var(--shadow);
        }

        /* Enhanced Dashboard Cards */
        .dashboard-cards {
            display: grid;
            grid-template-columns: repeat(auto-fill, minmax(300px, 1fr));
            gap: 24px;
            margin-bottom: 30px;
        }

        .dashboard-card {
            background: white;
            border-radius: var(--radius);
            padding: 24px;
            box-shadow: var(--shadow-md);
            transition: all 0.3s;
            border-left: 4px solid var(--primary);
            position: relative;
            overflow: hidden;
        }

        .dashboard-card::before {
            content: '';
            position: absolute;
            top: 0;
            left: 0;
            width: 100%;
            height: 4px;
            background: var(--primary);
            transform: scaleX(0);
            transform-origin: left;
            transition: transform 0.3s;
        }

        .dashboard-card:hover {
            transform: translateY(-5px);
            box-shadow: var(--shadow-lg);
        }

        .dashboard-card:hover::before {
            transform: scaleX(1);
        }

        .dashboard-card.appointments {
            border-left-color: var(--primary);
        }

        .dashboard-card.prescriptions {
            border-left-color: var(--success);
        }

        .dashboard-card.bills {
            border-left-color: var(--warning);
        }

        .dashboard-card.doctors {
            border-left-color: var(--accent);
        }

        .card-icon {
            width: 60px;
            height: 60px;
            border-radius: 12px;
            display: flex;
            align-items: center;
            justify-content: center;
            margin-bottom: 18px;
            font-size: 1.6rem;
        }

        .card-icon.appointments {
            background: rgba(37, 99, 235, 0.1);
            color: var(--primary);
        }

        .card-icon.prescriptions {
            background: rgba(16, 185, 129, 0.1);
            color: var(--success);
        }

        .card-icon.bills {
            background: rgba(245, 158, 11, 0.1);
            color: var(--warning);
        }

        .card-icon.doctors {
            background: rgba(14, 165, 233, 0.1);
            color: var(--accent);
        }

        .card-value {
            font-size: 2rem;
            font-weight: 700;
            margin-bottom: 5px;
            color: var(--dark);
        }

        .card-label {
            color: var(--text-light);
            font-size: 0.95rem;
        }

        /* Enhanced Content Sections */
        .content-section {
            background: white;
            border-radius: var(--radius);
            padding: 28px;
            margin-bottom: 30px;
            box-shadow: var(--shadow-md);
            border: 1px solid var(--gray-light);
        }

        .section-header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 24px;
            padding-bottom: 16px;
            border-bottom: 1px solid var(--gray-light);
        }

        .section-title {
            font-size: 1.4rem;
            font-weight: 600;
            color: var(--primary);
            display: flex;
            align-items: center;
            gap: 12px;
        }

        .section-title i {
            font-size: 1.2rem;
        }

        .btn-primary {
            background: linear-gradient(135deg, var(--primary) 0%, var(--primary-light) 100%);
            border: none;
            border-radius: var(--radius-sm);
            padding: 10px 22px;
            font-weight: 600;
            transition: all 0.3s;
            box-shadow: 0 2px 4px rgba(37, 99, 235, 0.2);
        }

        .btn-primary:hover {
            background: linear-gradient(135deg, var(--primary-dark) 0%, var(--primary) 100%);
            transform: translateY(-2px);
            box-shadow: 0 4px 8px rgba(37, 99, 235, 0.3);
        }

        /* Enhanced Table Styles */
        .table {
            width: 100%;
            border-collapse: separate;
            border-spacing: 0;
        }

        .table th {
            background-color: var(--light);
            color: var(--dark);
            font-weight: 600;
            padding: 14px 16px;
            border-bottom: 2px solid var(--gray-light);
        }

        .table td {
            padding: 14px 16px;
            border-bottom: 1px solid var(--gray-light);
            vertical-align: middle;
        }

        .table tr:last-child td {
            border-bottom: none;
        }

        .table tr:hover td {
            background-color: var(--primary-lighter);
        }

        .status-badge {
            padding: 6px 14px;
            border-radius: 20px;
            font-size: 0.85rem;
            font-weight: 600;
        }

        .status-scheduled {
            background: rgba(37, 99, 235, 0.1);
            color: var(--primary);
        }

        .status-completed {
            background: rgba(16, 185, 129, 0.1);
            color: var(--success);
        }

        .status-cancelled {
            background: rgba(239, 68, 68, 0.1);
            color: var(--danger);
        }

        .status-pending {
            background: rgba(245, 158, 11, 0.1);
            color: var(--warning);
        }

        /* Enhanced Modal Styles */
        .modal-content {
            border-radius: var(--radius);
            border: none;
            box-shadow: var(--shadow-lg);
        }

        .modal-header {
            background: var(--light);
            border-bottom: 1px solid var(--gray-light);
            border-radius: var(--radius) var(--radius) 0 0;
            padding: 18px 24px;
        }

        .modal-title {
            font-weight: 600;
            color: var(--primary);
            display: flex;
            align-items: center;
            gap: 10px;
        }

        /* Enhanced Form Styles */
        .form-label {
            font-weight: 600;
            margin-bottom: 8px;
            color: var(--dark);
        }

        .form-control, .form-select {
            border: 2px solid var(--gray-light);
            border-radius: var(--radius-sm);
            padding: 10px 15px;
            transition: all 0.3s;
        }

        .form-control:focus, .form-select:focus {
            border-color: var(--primary);
            box-shadow: 0 0 0 3px rgba(37, 99, 235, 0.1);
        }

        /* Enhanced Calendar Styles */
        #calendar {
            background: white;
            border-radius: var(--radius);
            padding: 20px;
            box-shadow: var(--shadow);
        }

        .fc .fc-toolbar {
            padding: 10px;
        }

        .fc .fc-button {
            background-color: var(--primary);
            border: none;
            border-radius: var(--radius-sm);
        }

        .fc .fc-button:hover {
            background-color: var(--primary-dark);
        }

        /* Enhanced Footer Styles */
        .footer {
            background: white;
            padding: 24px;
            margin-top: 40px;
            border-radius: var(--radius);
            box-shadow: var(--shadow-md);
            text-align: center;
            color: var(--text-light);
            border-top: 1px solid var(--gray-light);
        }

        .footer-links {
            display: flex;
            justify-content: center;
            gap: 24px;
            margin-bottom: 18px;
        }

        .footer-links a {
            color: var(--text-light);
            text-decoration: none;
            transition: color 0.3s;
            font-weight: 500;
        }

        .footer-links a:hover {
            color: var(--primary);
        }

        /* Real-time notification */
        .notification-badge {
            position: absolute;
            top: 8px;
            right: 12px;
            background: var(--danger);
            color: white;
            border-radius: 50%;
            width: 20px;
            height: 20px;
            font-size: 0.75rem;
            display: flex;
            align-items: center;
            justify-content: center;
            font-weight: 600;
        }

        .nav-item {
            position: relative;
        }

        /* Doctor Cards */
        .doctor-card {
            background: white;
            border-radius: var(--radius);
            padding: 24px;
            box-shadow: var(--shadow-md);
            transition: all 0.3s;
            border: 1px solid var(--gray-light);
            text-align: center;
            height: 100%;
        }

        .doctor-card:hover {
            transform: translateY(-5px);
            box-shadow: var(--shadow-lg);
        }

        .doctor-avatar {
            width: 80px;
            height: 80px;
            border-radius: 50%;
            background: var(--primary-lighter);
            color: var(--primary);
            display: flex;
            align-items: center;
            justify-content: center;
            margin: 0 auto 16px;
            font-size: 2rem;
        }

        .doctor-rating {
            color: var(--warning);
            margin-bottom: 16px;
        }

        /* Responsive Styles */
        @media (max-width: 1200px) {
            .sidebar {
                width: 240px;
            }
            .main-content {
                margin-left: 240px;
            }
        }

        @media (max-width: 992px) {
            .sidebar {
                width: 80px;
                overflow: hidden;
            }
            
            .sidebar .menu-text {
                display: none;
            }
            
            .main-content {
                margin-left: 80px;
            }
            
            .sidebar-header h3, .sidebar-header p {
                display: none;
            }
            
            .dashboard-cards {
                grid-template-columns: repeat(auto-fill, minmax(250px, 1fr));
            }
        }

        @media (max-width: 768px) {
            .dashboard-cards {
                grid-template-columns: 1fr;
            }
            
            .header {
                flex-direction: column;
                align-items: flex-start;
                gap: 15px;
            }
            
            .user-info {
                align-self: flex-end;
            }
            
            .main-content {
                padding: 16px;
            }
        }

        /* Additional Enhancements */
        .card-trend {
            font-size: 0.85rem;
            display: flex;
            align-items: center;
            gap: 5px;
            margin-top: 8px;
        }

        .trend-up {
            color: var(--success);
        }

        .trend-down {
            color: var(--danger);
        }

        .action-buttons {
            display: flex;
            gap: 8px;
        }

        .btn-sm {
            padding: 6px 12px;
            font-size: 0.875rem;
        }

        .empty-state {
            text-align: center;
            padding: 40px 20px;
            color: var(--text-light);
        }

        .empty-state i {
            font-size: 3rem;
            margin-bottom: 16px;
            color: var(--gray);
        }

        .loading-spinner {
            display: inline-block;
            width: 20px;
            height: 20px;
            border: 3px solid rgba(255, 255, 255, 0.3);
            border-radius: 50%;
            border-top-color: #fff;
            animation: spin 1s ease-in-out infinite;
        }

        @keyframes spin {
            to { transform: rotate(360deg); }
        }

        .rating-stars i {
            cursor: pointer;
            transition: color 0.2s;
        }

        .rating-stars i:hover {
            color: var(--warning);
        }

        .star-active {
            color: var(--warning);
        }
    </style>
</head>

<body>
    <div class="sidebar">
        <div class="sidebar-header">
            <h3><i class="fas fa-hospital-alt"></i> <span class="menu-text">MediCare</span></h3>
            <p class="menu-text">Patient Portal</p>
        </div>
        
        <div class="sidebar-menu">
            <ul class="nav flex-column">
                <li class="nav-item">
                    <a class="nav-link active" href="#" data-section="dashboard">
                        <i class="fas fa-tachometer-alt"></i>
                        <span class="menu-text">Dashboard</span>
                    </a>
                </li>
                <li class="nav-item">
                    <a class="nav-link" href="#" data-section="profile">
                        <i class="fas fa-user"></i>
                        <span class="menu-text">My Profile</span>
                    </a>
                </li>
                <li class="nav-item">
                    <a class="nav-link" href="#" data-section="appointments">
                        <i class="fas fa-calendar-check"></i>
                        <span class="menu-text">Appointments</span>
                        <span class="notification-badge" id="appointment-notification" style="display: none;">3</span>
                    </a>
                </li>
                <li class="nav-item">
                    <a class="nav-link" href="#" data-section="prescriptions">
                        <i class="fas fa-file-prescription"></i>
                        <span class="menu-text">Prescriptions</span>
                        <span class="notification-badge" id="prescription-notification" style="display: none;">2</span>
                    </a>
                </li>
                <li class="nav-item">
                    <a class="nav-link" href="#" data-section="doctors">
                        <i class="fas fa-user-md"></i>
                        <span class="menu-text">Doctors</span>
                    </a>
                </li>
                <li class="nav-item">
                    <a class="nav-link" href="#" data-section="bills">
                        <i class="fas fa-file-invoice-dollar"></i>
                        <span class="menu-text">Bills & Payments</span>
                    </a>
                </li>
                <li class="nav-item">
                    <a class="nav-link" href="#" data-section="feedback">
                        <i class="fas fa-comment-medical"></i>
                        <span class="menu-text">Feedback</span>
                    </a>
                </li>
            </ul>
            
            <div class="mt-auto">
                <ul class="nav flex-column">
                    <li class="nav-item">
                        <a class="nav-link" href="#" id="logout-btn">
                            <i class="fas fa-sign-out-alt"></i>
                            <span class="menu-text">Logout</span>
                        </a>
                    </li>
                </ul>
            </div>
        </div>
    </div>

    <div class="main-content">
        <div class="header">
            <div class="header-title">
                <h1 id="page-title">Patient Dashboard</h1>
                <p id="page-subtitle">Welcome back, John Doe</p>
            </div>
            <div class="user-info">
                <div class="user-avatar">
                    J
                </div>
                <div>
                    <div class="fw-bold">John Doe</div>
                    <div class="small text-muted">Patient ID: P1001</div>
                </div>
            </div>
        </div>

        <!-- Dashboard Content -->
        <div id="dashboard-content">
            <div class="dashboard-cards">
                <div class="dashboard-card appointments">
                    <div class="card-icon appointments">
                        <i class="fas fa-calendar-check"></i>
                    </div>
                    <div class="card-value" id="upcoming-appointments">0</div>
                    <div class="card-label">Upcoming Appointments</div>
                    <div class="card-trend trend-up">
                        <i class="fas fa-arrow-up"></i> 2 from last week
                    </div>
                </div>
                
                <div class="dashboard-card prescriptions">
                    <div class="card-icon prescriptions">
                        <i class="fas fa-file-prescription"></i>
                    </div>
                    <div class="card-value" id="recent-prescriptions">0</div>
                    <div class="card-label">Recent Prescriptions</div>
                    <div class="card-trend trend-down">
                        <i class="fas fa-arrow-down"></i> 1 from last month
                    </div>
                </div>
                
                <div class="dashboard-card bills">
                    <div class="card-icon bills">
                        <i class="fas fa-file-invoice-dollar"></i>
                    </div>
                    <div class="card-value" id="pending-bills">0</div>
                    <div class="card-label">Pending Bills</div>
                    <div class="card-trend trend-up">
                        <i class="fas fa-arrow-up"></i> 1 new bill
                    </div>
                </div>
                
                <div class="dashboard-card doctors">
                    <div class="card-icon doctors">
                        <i class="fas fa-user-md"></i>
                    </div>
                    <div class="card-value" id="available-doctors">0</div>
                    <div class="card-label">Available Doctors</div>
                    <div class="card-trend">
                        <i class="fas fa-minus"></i> No change
                    </div>
                </div>
            </div>

            <div class="row">
                <div class="col-lg-8">
                    <div class="content-section">
                        <div class="section-header">
                            <h3 class="section-title"><i class="fas fa-calendar-alt"></i>Upcoming Appointments</h3>
                            <button class="btn btn-primary" data-bs-toggle="modal" data-bs-target="#bookAppointmentModal">
                                <i class="fas fa-plus me-2"></i>Book Appointment
                            </button>
                        </div>
                        
                        <div class="table-responsive">
                            <table class="table">
                                <thead>
                                    <tr>
                                        <th>Doctor</th>
                                        <th>Date & Time</th>
                                        <th>Department</th>
                                        <th>Status</th>
                                        <th>Actions</th>
                                    </tr>
                                </thead>
                                <tbody id="appointments-table-body">
                                    <!-- Appointments will be loaded here -->
                                </tbody>
                            </table>
                        </div>
                        
                        <div class="empty-state d-none" id="no-appointments">
                            <i class="fas fa-calendar-times"></i>
                            <h4>No Upcoming Appointments</h4>
                            <p>You don't have any upcoming appointments scheduled.</p>
                            <button class="btn btn-primary mt-2" data-bs-toggle="modal" data-bs-target="#bookAppointmentModal">
                                <i class="fas fa-plus me-2"></i>Book Your First Appointment
                            </button>
                        </div>
                    </div>
                </div>
                
                <div class="col-lg-4">
                    <div class="content-section">
                        <div class="section-header">
                            <h3 class="section-title"><i class="fas fa-calendar-day"></i>Appointment Calendar</h3>
                        </div>
                        <div id="calendar"></div>
                    </div>
                </div>
            </div>

            <div class="content-section">
                <div class="section-header">
                    <h3 class="section-title"><i class="fas fa-file-prescription"></i>Recent Prescriptions</h3>
                    <a href="#" class="btn btn-outline-primary">View All</a>
                </div>
                
                <div class="table-responsive">
                    <table class="table">
                        <thead>
                            <tr>
                                <th>Date</th>
                                <th>Doctor</th>
                                <th>Medication</th>
                                <th>Dosage</th>
                                <th>Actions</th>
                            </tr>
                        </thead>
                        <tbody id="prescriptions-table-body">
                            <!-- Prescriptions will be loaded here -->
                        </tbody>
                    </table>
                </div>
                
                <div class="empty-state d-none" id="no-prescriptions">
                    <i class="fas fa-file-medical-alt"></i>
                    <h4>No Recent Prescriptions</h4>
                    <p>You don't have any recent prescriptions.</p>
                </div>
            </div>
        </div>

        <!-- Profile Content -->
        <div id="profile-content" class="d-none">
            <div class="content-section">
                <div class="section-header">
                    <h3 class="section-title"><i class="fas fa-user-edit"></i>Edit Profile</h3>
                </div>
                
                <form id="profile-form">
                    <input type="hidden" id="patientId" name="patientId" value="P1001">
                    <div class="row">
                        <div class="col-md-6">
                            <div class="mb-3">
                                <label for="fullName" class="form-label">Full Name</label>
                                <input type="text" class="form-control" id="fullName" name="fullName" value="John Doe" required>
                            </div>
                            
                            <div class="mb-3">
                                <label for="email" class="form-label">Email Address</label>
                                <input type="email" class="form-control" id="email" name="email" value="john.doe@example.com" required>
                            </div>
                            
                            <div class="mb-3">
                                <label for="phone" class="form-label">Phone Number</label>
                                <input type="tel" class="form-control" id="phone" name="phone" value="+1 (555) 123-4567" required>
                            </div>
                            
                            <div class="mb-3">
                                <label for="dob" class="form-label">Date of Birth</label>
                                <input type="date" class="form-control" id="dob" name="dob" value="1985-05-15">
                            </div>
                        </div>
                        
                        <div class="col-md-6">
                            <div class="mb-3">
                                <label for="gender" class="form-label">Gender</label>
                                <select class="form-select" id="gender" name="gender">
                                    <option value="male" selected>Male</option>
                                    <option value="female">Female</option>
                                    <option value="other">Other</option>
                                </select>
                            </div>
                            
                            <div class="mb-3">
                                <label for="bloodGroup" class="form-label">Blood Group</label>
                                <select class="form-select" id="bloodGroup" name="bloodGroup">
                                    <option value="">Select blood group</option>
                                    <option value="A+" selected>A+</option>
                                    <option value="A-">A-</option>
                                    <option value="B+">B+</option>
                                    <option value="B-">B-</option>
                                    <option value="AB+">AB+</option>
                                    <option value="AB-">AB-</option>
                                    <option value="O+">O+</option>
                                    <option value="O-">O-</option>
                                </select>
                            </div>
                            
                            <div class="mb-3">
                                <label for="address" class="form-label">Address</label>
                                <textarea class="form-control" id="address" name="address" rows="3">123 Main Street, New York, NY 10001</textarea>
                            </div>
                        </div>
                    </div>
                    
                    <div class="d-flex justify-content-end gap-2">
                        <button type="button" class="btn btn-outline-secondary" id="cancel-profile">Cancel</button>
                        <button type="submit" class="btn btn-primary">Update Profile</button>
                    </div>
                </form>
            </div>
            
            <div class="content-section">
                <div class="section-header">
                    <h3 class="section-title"><i class="fas fa-lock"></i>Change Password</h3>
                </div>
                
                <form id="password-form">
                    <input type="hidden" id="patientIdPassword" name="patientId" value="P1001">
                    <div class="row">
                        <div class="col-md-6">
                            <div class="mb-3">
                                <label for="currentPassword" class="form-label">Current Password</label>
                                <input type="password" class="form-control" id="currentPassword" name="currentPassword" required>
                            </div>
                            
                            <div class="mb-3">
                                <label for="newPassword" class="form-label">New Password</label>
                                <input type="password" class="form-control" id="newPassword" name="newPassword" required minlength="8">
                                <div class="form-text">Password must be at least 8 characters with uppercase, lowercase, number, and special character.</div>
                            </div>
                            
                            <div class="mb-3">
                                <label for="confirmPassword" class="form-label">Confirm New Password</label>
                                <input type="password" class="form-control" id="confirmPassword" name="confirmPassword" required>
                            </div>
                        </div>
                    </div>
                    
                    <div class="d-flex justify-content-end">
                        <button type="submit" class="btn btn-primary">Change Password</button>
                    </div>
                </form>
            </div>
        </div>

        <!-- Appointments Content -->
        <div id="appointments-content" class="d-none">
            <div class="content-section">
                <div class="section-header">
                    <h3 class="section-title"><i class="fas fa-calendar-check"></i>My Appointments</h3>
                    <button class="btn btn-primary" data-bs-toggle="modal" data-bs-target="#bookAppointmentModal">
                        <i class="fas fa-plus me-2"></i>Book New Appointment
                    </button>
                </div>
                
                <div class="table-responsive">
                    <table class="table">
                        <thead>
                            <tr>
                                <th>Appointment ID</th>
                                <th>Doctor</th>
                                <th>Department</th>
                                <th>Date & Time</th>
                                <th>Status</th>
                                <th>Actions</th>
                            </tr>
                        </thead>
                        <tbody id="all-appointments-table-body">
                            <!-- All appointments will be loaded here -->
                        </tbody>
                    </table>
                </div>
                
                <div class="empty-state d-none" id="no-all-appointments">
                    <i class="fas fa-calendar-times"></i>
                    <h4>No Appointments Found</h4>
                    <p>You don't have any appointments scheduled.</p>
                    <button class="btn btn-primary mt-2" data-bs-toggle="modal" data-bs-target="#bookAppointmentModal">
                        <i class="fas fa-plus me-2"></i>Book Your First Appointment
                    </button>
                </div>
            </div>
        </div>

        <!-- Prescriptions Content -->
        <div id="prescriptions-content" class="d-none">
            <div class="content-section">
                <div class="section-header">
                    <h3 class="section-title"><i class="fas fa-file-prescription"></i>My Prescriptions</h3>
                </div>
                
                <div class="table-responsive">
                    <table class="table">
                        <thead>
                            <tr>
                                <th>Prescription ID</th>
                                <th>Date</th>
                                <th>Doctor</th>
                                <th>Medication</th>
                                <th>Dosage</th>
                                <th>Instructions</th>
                                <th>Status</th>
                            </tr>
                        </thead>
                        <tbody id="all-prescriptions-table-body">
                            <!-- All prescriptions will be loaded here -->
                        </tbody>
                    </table>
                </div>
                
                <div class="empty-state d-none" id="no-all-prescriptions">
                    <i class="fas fa-file-medical-alt"></i>
                    <h4>No Prescriptions Found</h4>
                    <p>You don't have any prescriptions.</p>
                </div>
            </div>
        </div>

        <!-- Doctors Content -->
        <div id="doctors-content" class="d-none">
            <div class="content-section">
                <div class="section-header">
                    <h3 class="section-title"><i class="fas fa-user-md"></i>Available Doctors</h3>
                </div>
                
                <div class="row" id="doctors-grid">
                    <!-- Doctors will be loaded here -->
                </div>
                
                <div class="empty-state d-none" id="no-doctors">
                    <i class="fas fa-user-md"></i>
                    <h4>No Doctors Available</h4>
                    <p>There are currently no doctors available for appointments.</p>
                </div>
            </div>
        </div>

        <!-- Bills Content -->
        <div id="bills-content" class="d-none">
            <div class="content-section">
                <div class="section-header">
                    <h3 class="section-title"><i class="fas fa-file-invoice-dollar"></i>Bills & Payments</h3>
                </div>
                
                <div class="table-responsive">
                    <table class="table">
                        <thead>
                            <tr>
                                <th>Bill ID</th>
                                <th>Date</th>
                                <th>Service</th>
                                <th>Amount</th>
                                <th>Status</th>
                                <th>Due Date</th>
                                <th>Actions</th>
                            </tr>
                        </thead>
                        <tbody id="bills-table-body">
                            <!-- Bills will be loaded here -->
                        </tbody>
                    </table>
                </div>
                
                <div class="empty-state d-none" id="no-bills">
                    <i class="fas fa-file-invoice"></i>
                    <h4>No Bills Found</h4>
                    <p>You don't have any bills at the moment.</p>
                </div>
            </div>
        </div>

        <!-- Feedback Content -->
        <div id="feedback-content" class="d-none">
            <div class="content-section">
                <div class="section-header">
                    <h3 class="section-title"><i class="fas fa-comment-medical"></i>Feedback & Reviews</h3>
                </div>
                
                <form id="feedback-form">
                    <div class="mb-4">
                        <label for="feedback-type" class="form-label">Feedback Type</label>
                        <select class="form-select" id="feedback-type" name="feedbackType" required>
                            <option value="">Select feedback type</option>
                            <option value="general">General Feedback</option>
                            <option value="service">Service Quality</option>
                            <option value="doctor">Doctor Experience</option>
                            <option value="facility">Facility & Environment</option>
                            <option value="suggestion">Suggestion</option>
                            <option value="complaint">Complaint</option>
                        </select>
                    </div>
                    
                    <div class="mb-4">
                        <label for="feedback-rating" class="form-label">Overall Rating</label>
                        <div class="rating-stars">
                            <div class="d-flex gap-1">
                                <i class="fas fa-star text-muted" data-rating="1"></i>
                                <i class="fas fa-star text-muted" data-rating="2"></i>
                                <i class="fas fa-star text-muted" data-rating="3"></i>
                                <i class="fas fa-star text-muted" data-rating="4"></i>
                                <i class="fas fa-star text-muted" data-rating="5"></i>
                            </div>
                            <input type="hidden" id="feedback-rating" name="rating" value="0">
                        </div>
                    </div>
                    
                    <div class="mb-4">
                        <label for="feedback-message" class="form-label">Your Feedback</label>
                        <textarea class="form-control" id="feedback-message" name="message" rows="5" placeholder="Please share your experience, suggestions, or concerns..." required></textarea>
                    </div>
                    
                    <div class="d-flex justify-content-end">
                        <button type="submit" class="btn btn-primary">Submit Feedback</button>
                    </div>
                </form>
                
                <div class="mt-5">
                    <h4 class="mb-3">Previous Feedback</h4>
                    <div id="previous-feedback">
                        <!-- Previous feedback will be loaded here -->
                    </div>
                    
                    <div class="empty-state d-none" id="no-feedback">
                        <i class="fas fa-comments"></i>
                        <h4>No Feedback Submitted</h4>
                        <p>You haven't submitted any feedback yet.</p>
                    </div>
                </div>
            </div>
        </div>

        <div class="footer">
            <div class="footer-links">
                <a href="#">About Us</a>
                <a href="#">Contact</a>
                <a href="#">Privacy Policy</a>
                <a href="#">Terms of Service</a>
                <a href="#">Help Center</a>
            </div>
            <div class="copyright mt-2">
                &copy; 2023 MediCare Hospital Management System. All rights reserved.
            </div>
        </div>
    </div>

    <!-- Book Appointment Modal -->
    <div class="modal fade" id="bookAppointmentModal" tabindex="-1" aria-labelledby="bookAppointmentModalLabel" aria-hidden="true">
        <div class="modal-dialog modal-lg">
            <div class="modal-content">
                <div class="modal-header">
                    <h5 class="modal-title" id="bookAppointmentModalLabel"><i class="fas fa-calendar-plus me-2"></i>Book New Appointment</h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                </div>
                <div class="modal-body">
                    <form id="appointment-form">
                        <input type="hidden" id="patientIdAppointment" name="patientId" value="P1001">
                        <div class="row">
                            <div class="col-md-6">
                                <div class="mb-3">
                                    <label for="appointmentDoctor" class="form-label">Select Doctor</label>
                                    <select class="form-select" id="appointmentDoctor" name="doctorId" required>
                                        <option value="">Choose a doctor</option>
                                        <!-- Doctors will be loaded here -->
                                    </select>
                                </div>
                                
                                <div class="mb-3">
                                    <label for="appointmentDate" class="form-label">Appointment Date</label>
                                    <input type="date" class="form-control" id="appointmentDate" name="appointmentDate" required>
                                </div>
                            </div>
                            
                            <div class="col-md-6">
                                <div class="mb-3">
                                    <label for="appointmentTime" class="form-label">Preferred Time</label>
                                    <select class="form-select" id="appointmentTime" name="appointmentTime" required>
                                        <option value="">Select time slot</option>
                                        <option value="09:00">09:00 AM</option>
                                        <option value="10:00">10:00 AM</option>
                                        <option value="11:00">11:00 AM</option>
                                        <option value="14:00">02:00 PM</option>
                                        <option value="15:00">03:00 PM</option>
                                        <option value="16:00">04:00 PM</option>
                                    </select>
                                </div>
                                
                                <div class="mb-3">
                                    <label for="appointmentReason" class="form-label">Reason for Visit</label>
                                    <textarea class="form-control" id="appointmentReason" name="reason" rows="3" placeholder="Briefly describe your symptoms or reason for appointment"></textarea>
                                </div>
                            </div>
                        </div>
                    </form>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cancel</button>
                    <button type="button" class="btn btn-primary" id="submit-appointment">Book Appointment</button>
                </div>
            </div>
        </div>
    </div>

    <!-- Cancel Appointment Modal -->
    <div class="modal fade" id="cancelAppointmentModal" tabindex="-1" aria-labelledby="cancelAppointmentModalLabel" aria-hidden="true">
        <div class="modal-dialog">
            <div class="modal-content">
                <div class="modal-header">
                    <h5 class="modal-title" id="cancelAppointmentModalLabel"><i class="fas fa-calendar-times me-2"></i>Cancel Appointment</h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                </div>
                <div class="modal-body">
                    <p>Are you sure you want to cancel this appointment?</p>
                    <div id="cancel-appointment-details"></div>
                    <div class="mb-3 mt-3">
                        <label for="cancelReason" class="form-label">Reason for cancellation (optional)</label>
                        <textarea class="form-control" id="cancelReason" rows="2" placeholder="Please provide a reason for cancellation"></textarea>
                    </div>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Keep Appointment</button>
                    <button type="button" class="btn btn-danger" id="confirm-cancel">Cancel Appointment</button>
                </div>
            </div>
        </div>
    </div>

    <!-- View Prescription Modal -->
    <div class="modal fade" id="viewPrescriptionModal" tabindex="-1" aria-labelledby="viewPrescriptionModalLabel" aria-hidden="true">
        <div class="modal-dialog modal-lg">
            <div class="modal-content">
                <div class="modal-header">
                    <h5 class="modal-title" id="viewPrescriptionModalLabel"><i class="fas fa-file-prescription me-2"></i>Prescription Details</h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                </div>
                <div class="modal-body" id="prescription-details">
                    <!-- Prescription details will be loaded here -->
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Close</button>
                    <button type="button" class="btn btn-primary"><i class="fas fa-print me-2"></i>Print</button>
                </div>
            </div>
        </div>
    </div>

    <!-- Pay Bill Modal -->
    <div class="modal fade" id="payBillModal" tabindex="-1" aria-labelledby="payBillModalLabel" aria-hidden="true">
        <div class="modal-dialog">
            <div class="modal-content">
                <div class="modal-header">
                    <h5 class="modal-title" id="payBillModalLabel"><i class="fas fa-credit-card me-2"></i>Pay Bill</h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                </div>
                <div class="modal-body">
                    <div id="bill-details"></div>
                    <form id="payment-form" class="mt-3">
                        <div class="mb-3">
                            <label for="payment-method" class="form-label">Payment Method</label>
                            <select class="form-select" id="payment-method" required>
                                <option value="">Select payment method</option>
                                <option value="credit">Credit Card</option>
                                <option value="debit">Debit Card</option>
                                <option value="upi">UPI</option>
                                <option value="netbanking">Net Banking</option>
                            </select>
                        </div>
                        <div id="credit-card-fields" class="d-none">
                            <div class="mb-3">
                                <label for="card-number" class="form-label">Card Number</label>
                                <input type="text" class="form-control" id="card-number" placeholder="1234 5678 9012 3456">
                            </div>
                            <div class="row">
                                <div class="col-md-6">
                                    <div class="mb-3">
                                        <label for="expiry-date" class="form-label">Expiry Date</label>
                                        <input type="text" class="form-control" id="expiry-date" placeholder="MM/YY">
                                    </div>
                                </div>
                                <div class="col-md-6">
                                    <div class="mb-3">
                                        <label for="cvv" class="form-label">CVV</label>
                                        <input type="text" class="form-control" id="cvv" placeholder="123">
                                    </div>
                                </div>
                            </div>
                        </div>
                        <div id="upi-fields" class="d-none">
                            <div class="mb-3">
                                <label for="upi-id" class="form-label">UPI ID</label>
                                <input type="text" class="form-control" id="upi-id" placeholder="yourname@upi">
                            </div>
                        </div>
                    </form>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cancel</button>
                    <button type="button" class="btn btn-success" id="confirm-payment">Pay Now</button>
                </div>
            </div>
        </div>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/fullcalendar@5.11.3/main.min.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>
    
    <script>
        // Global variables
        let currentAppointmentId = null;
        let currentBillId = null;
        let appointments = [];
        let doctors = [];
        let prescriptions = [];
        let bills = [];
        let feedback = [];

        // Mock data for demonstration
        const mockAppointments = [
            { id: 'A1001', doctor: 'Dr. Smith', department: 'Cardiology', date: '2023-12-15', time: '10:00 AM', status: 'scheduled' },
            { id: 'A1002', doctor: 'Dr. Johnson', department: 'Dermatology', date: '2023-12-16', time: '02:00 PM', status: 'scheduled' },
            { id: 'A1003', doctor: 'Dr. Williams', department: 'Orthopedics', date: '2023-12-10', time: '11:00 AM', status: 'completed' }
        ];

        const mockDoctors = [
            { id: 'D101', name: 'Dr. Smith', department: 'Cardiology', availability: 'Mon, Wed, Fri', rating: 4.8 },
            { id: 'D102', name: 'Dr. Johnson', department: 'Dermatology', availability: 'Tue, Thu', rating: 4.6 },
            { id: 'D103', name: 'Dr. Williams', department: 'Orthopedics', availability: 'Mon, Tue, Thu, Fri', rating: 4.9 }
        ];

        const mockPrescriptions = [
            { id: 'P1001', date: '2023-12-01', doctor: 'Dr. Smith', medication: 'Amoxicillin', dosage: '500mg', instructions: 'Take three times daily for 7 days', status: 'Active' },
            { id: 'P1002', date: '2023-11-15', doctor: 'Dr. Johnson', medication: 'Ibuprofen', dosage: '200mg', instructions: 'Take as needed for pain', status: 'Completed' }
        ];

        const mockBills = [
            { id: 'B1001', date: '2023-12-01', service: 'Consultation', amount: 150, status: 'Paid', dueDate: '2023-12-01' },
            { id: 'B1002', date: '2023-12-10', service: 'X-Ray', amount: 200, status: 'Pending', dueDate: '2023-12-20' }
        ];

        const mockFeedback = [
            { type: 'service', rating: 5, message: 'Excellent service!', date: '2023-12-01' },
            { type: 'doctor', rating: 4, message: 'Dr. Smith was very helpful.', date: '2023-11-20' }
        ];

        // Initialize dashboard when page loads
        document.addEventListener('DOMContentLoaded', function() {
            initializeDashboard();
            loadAppointments();
            loadDoctors();
            loadPrescriptions();
            loadBills();
            loadFeedback();
            initializeCalendar();
            setupEventListeners();
            
            // Simulate real-time updates
            setInterval(updateDashboardData, 30000);
            
            // Add loading states for better UX
            simulateLoading();
        });
        
        function simulateLoading() {
            // Show loading state for cards
            document.querySelectorAll('.card-value').forEach(el => {
                el.innerHTML = '<div class="loading-spinner" style="border-top-color: var(--primary);"></div>';
            });
            
            // Simulate API delay
            setTimeout(() => {
                initializeDashboard();
            }, 1000);
        }
        
        function initializeDashboard() {
            // Set initial counts for dashboard cards
            document.getElementById('upcoming-appointments').textContent = mockAppointments.filter(a => a.status === 'scheduled').length;
            document.getElementById('recent-prescriptions').textContent = mockPrescriptions.length;
            document.getElementById('pending-bills').textContent = mockBills.filter(b => b.status === 'Pending').length;
            document.getElementById('available-doctors').textContent = mockDoctors.length;
            
            // Show notification badges
            document.getElementById('appointment-notification').style.display = 'flex';
            document.getElementById('prescription-notification').style.display = 'flex';
        }
        
        function loadAppointments() {
            appointments = mockAppointments;
            // Populate appointments table in dashboard
            const tbody = document.getElementById('appointments-table-body');
            tbody.innerHTML = '';
            const upcomingAppointments = appointments.filter(a => a.status === 'scheduled');
            if (upcomingAppointments.length === 0) {
                document.getElementById('no-appointments').classList.remove('d-none');
            } else {
                document.getElementById('no-appointments').classList.add('d-none');
                upcomingAppointments.forEach(appointment => {
                    const row = document.createElement('tr');
                    row.innerHTML = `
                        <td>${appointment.doctor}</td>
                        <td>${appointment.date} ${appointment.time}</td>
                        <td>${appointment.department}</td>
                        <td><span class="status-badge status-scheduled">Scheduled</span></td>
                        <td>
                            <div class="action-buttons">
                                <button class="btn btn-sm btn-outline-primary" onclick="viewAppointment('${appointment.id}')">View</button>
                                <button class="btn btn-sm btn-outline-danger" onclick="cancelAppointment('${appointment.id}')">Cancel</button>
                            </div>
                        </td>
                    `;
                    tbody.appendChild(row);
                });
            }
            
            // Also populate the all appointments table in the appointments section
            const allTbody = document.getElementById('all-appointments-table-body');
            allTbody.innerHTML = '';
            if (appointments.length === 0) {
                document.getElementById('no-all-appointments').classList.remove('d-none');
            } else {
                document.getElementById('no-all-appointments').classList.add('d-none');
                appointments.forEach(appointment => {
                    const row = document.createElement('tr');
                    row.innerHTML = `
                        <td>${appointment.id}</td>
                        <td>${appointment.doctor}</td>
                        <td>${appointment.department}</td>
                        <td>${appointment.date} ${appointment.time}</td>
                        <td><span class="status-badge status-${appointment.status}">${appointment.status.charAt(0).toUpperCase() + appointment.status.slice(1)}</span></td>
                        <td>
                            <div class="action-buttons">
                                <button class="btn btn-sm btn-outline-primary" onclick="viewAppointment('${appointment.id}')">View</button>
                                ${appointment.status === 'scheduled' ? `<button class="btn btn-sm btn-outline-danger" onclick="cancelAppointment('${appointment.id}')">Cancel</button>` : ''}
                            </div>
                        </td>
                    `;
                    allTbody.appendChild(row);
                });
            }
        }
        
        function loadDoctors() {
            doctors = mockDoctors;
            const doctorsGrid = document.getElementById('doctors-grid');
            doctorsGrid.innerHTML = '';
            if (doctors.length === 0) {
                document.getElementById('no-doctors').classList.remove('d-none');
            } else {
                document.getElementById('no-doctors').classList.add('d-none');
                doctors.forEach(doctor => {
                    const col = document.createElement('div');
                    col.className = 'col-md-6 col-lg-4 mb-4';
                    col.innerHTML = `
                        <div class="doctor-card">
                            <div class="doctor-avatar">
                                <i class="fas fa-user-md"></i>
                            </div>
                            <h5 class="card-title">${doctor.name}</h5>
                            <p class="card-text text-muted">${doctor.department}</p>
                            <p class="card-text"><small class="text-muted">Available: ${doctor.availability}</small></p>
                            <div class="doctor-rating mb-3">
                                ${generateStarRating(doctor.rating)}
                            </div>
                            <button class="btn btn-primary btn-sm" onclick="bookAppointmentWithDoctor('${doctor.id}')">Book Appointment</button>
                        </div>
                    `;
                    doctorsGrid.appendChild(col);
                });
            }
            
            // Also populate the doctor dropdown in the appointment modal
            const doctorSelect = document.getElementById('appointmentDoctor');
            doctorSelect.innerHTML = '<option value="">Choose a doctor</option>';
            doctors.forEach(doctor => {
                const option = document.createElement('option');
                option.value = doctor.id;
                option.textContent = `${doctor.name} - ${doctor.department}`;
                doctorSelect.appendChild(option);
            });
        }
        
        function generateStarRating(rating) {
            let stars = '';
            for (let i = 1; i <= 5; i++) {
                if (i <= rating) {
                    stars += '<i class="fas fa-star"></i>';
                } else {
                    stars += '<i class="far fa-star"></i>';
                }
            }
            return stars;
        }
        
        function loadPrescriptions() {
            prescriptions = mockPrescriptions;
            // Populate prescriptions table in dashboard
            const tbody = document.getElementById('prescriptions-table-body');
            tbody.innerHTML = '';
            if (prescriptions.length === 0) {
                document.getElementById('no-prescriptions').classList.remove('d-none');
            } else {
                document.getElementById('no-prescriptions').classList.add('d-none');
                prescriptions.forEach(prescription => {
                    const row = document.createElement('tr');
                    row.innerHTML = `
                        <td>${prescription.date}</td>
                        <td>${prescription.doctor}</td>
                        <td>${prescription.medication}</td>
                        <td>${prescription.dosage}</td>
                        <td>
                            <button class="btn btn-sm btn-outline-primary" onclick="viewPrescription('${prescription.id}')">View</button>
                        </td>
                    `;
                    tbody.appendChild(row);
                });
            }
            
            // Also populate the all prescriptions table in the prescriptions section
            const allTbody = document.getElementById('all-prescriptions-table-body');
            allTbody.innerHTML = '';
            if (prescriptions.length === 0) {
                document.getElementById('no-all-prescriptions').classList.remove('d-none');
            } else {
                document.getElementById('no-all-prescriptions').classList.add('d-none');
                prescriptions.forEach(prescription => {
                    const row = document.createElement('tr');
                    row.innerHTML = `
                        <td>${prescription.id}</td>
                        <td>${prescription.date}</td>
                        <td>${prescription.doctor}</td>
                        <td>${prescription.medication}</td>
                        <td>${prescription.dosage}</td>
                        <td>${prescription.instructions}</td>
                        <td><span class="status-badge status-${prescription.status.toLowerCase()}">${prescription.status}</span></td>
                    `;
                    allTbody.appendChild(row);
                });
            }
        }
        
        function loadBills() {
            bills = mockBills;
            const tbody = document.getElementById('bills-table-body');
            tbody.innerHTML = '';
            if (bills.length === 0) {
                document.getElementById('no-bills').classList.remove('d-none');
            } else {
                document.getElementById('no-bills').classList.add('d-none');
                bills.forEach(bill => {
                    const row = document.createElement('tr');
                    row.innerHTML = `
                        <td>${bill.id}</td>
                        <td>${bill.date}</td>
                        <td>${bill.service}</td>
                        <td>$${bill.amount}</td>
                        <td><span class="status-badge status-${bill.status.toLowerCase()}">${bill.status}</span></td>
                        <td>${bill.dueDate}</td>
                        <td>
                            <div class="action-buttons">
                                <button class="btn btn-sm btn-outline-primary" onclick="viewBill('${bill.id}')">View</button>
                                ${bill.status === 'Pending' ? `<button class="btn btn-sm btn-success" onclick="payBill('${bill.id}')">Pay</button>` : ''}
                            </div>
                        </td>
                    `;
                    tbody.appendChild(row);
                });
            }
        }
        
        function loadFeedback() {
            feedback = mockFeedback;
            const previousFeedback = document.getElementById('previous-feedback');
            previousFeedback.innerHTML = '';
            if (feedback.length === 0) {
                document.getElementById('no-feedback').classList.remove('d-none');
            } else {
                document.getElementById('no-feedback').classList.add('d-none');
                feedback.forEach(item => {
                    const feedbackItem = document.createElement('div');
                    feedbackItem.className = 'card mb-3';
                    feedbackItem.innerHTML = `
                        <div class="card-body">
                            <div class="d-flex justify-content-between">
                                <h6 class="card-title">${item.type.charAt(0).toUpperCase() + item.type.slice(1)} Feedback</h6>
                                <small class="text-muted">${item.date}</small>
                            </div>
                            <div class="rating mb-2">
                                ${generateStarRating(item.rating)}
                            </div>
                            <p class="card-text">${item.message}</p>
                        </div>
                    `;
                    previousFeedback.appendChild(feedbackItem);
                });
            }
        }
        
        function initializeCalendar() {
            const calendarEl = document.getElementById('calendar');
            const calendar = new FullCalendar.Calendar(calendarEl, {
                initialView: 'dayGridMonth',
                events: mockAppointments.filter(a => a.status === 'scheduled').map(a => ({
                    title: `Appointment with ${a.doctor}`,
                    start: a.date,
                    extendedProps: {
                        department: a.department
                    }
                })),
                eventClick: function(info) {
                    alert(`Appointment with ${info.event.title} on ${info.event.start.toLocaleDateString()}`);
                }
            });
            calendar.render();
        }
        
        function setupEventListeners() {
            // Section switching
            document.querySelectorAll('.nav-link').forEach(link => {
                link.addEventListener('click', function(e) {
                    e.preventDefault();
                    const section = this.getAttribute('data-section');
                    switchSection(section);
                });
            });
            
            // Profile form submission
            document.getElementById('profile-form').addEventListener('submit', function(e) {
                e.preventDefault();
                // In a real app, you would send the form data to the server
                Swal.fire('Success!', 'Your profile has been updated.', 'success');
            });
            
            // Password form submission
            document.getElementById('password-form').addEventListener('submit', function(e) {
                e.preventDefault();
                // In a real app, you would send the form data to the server
                Swal.fire('Success!', 'Your password has been changed.', 'success');
            });
            
            // Feedback form submission
            document.getElementById('feedback-form').addEventListener('submit', function(e) {
                e.preventDefault();
                // In a real app, you would send the form data to the server
                Swal.fire('Thank You!', 'Your feedback has been submitted.', 'success');
                // Reset the form
                document.getElementById('feedback-form').reset();
                // Reset stars
                document.querySelectorAll('.rating-stars .fas').forEach(star => {
                    star.classList.remove('text-warning');
                    star.classList.add('text-muted');
                });
                document.getElementById('feedback-rating').value = 0;
            });
            
            // Rating stars in feedback
            document.querySelectorAll('.rating-stars .fas').forEach(star => {
                star.addEventListener('click', function() {
                    const rating = this.getAttribute('data-rating');
                    document.getElementById('feedback-rating').value = rating;
                    // Update star display
                    document.querySelectorAll('.rating-stars .fas').forEach(s => {
                        if (s.getAttribute('data-rating') <= rating) {
                            s.classList.remove('text-muted');
                            s.classList.add('text-warning');
                        } else {
                            s.classList.remove('text-warning');
                            s.classList.add('text-muted');
                        }
                    });
                });
            });
            
            // Book appointment form submission
            document.getElementById('submit-appointment').addEventListener('click', function() {
                // In a real app, you would send the form data to the server
                Swal.fire('Success!', 'Your appointment has been booked.', 'success');
                // Close the modal
                bootstrap.Modal.getInstance(document.getElementById('bookAppointmentModal')).hide();
            });
            
            // Cancel appointment confirmation
            document.getElementById('confirm-cancel').addEventListener('click', function() {
                // In a real app, you would send the cancellation to the server
                Swal.fire('Cancelled!', 'Your appointment has been cancelled.', 'success');
                // Close the modal
                bootstrap.Modal.getInstance(document.getElementById('cancelAppointmentModal')).hide();
                // Reload appointments
                loadAppointments();
            });
            
            // Payment confirmation
            document.getElementById('confirm-payment').addEventListener('click', function() {
                // In a real app, you would process the payment
                Swal.fire('Success!', 'Your payment has been processed.', 'success');
                // Close the modal
                bootstrap.Modal.getInstance(document.getElementById('payBillModal')).hide();
                // Reload bills
                loadBills();
            });
            
            // Payment method change
            document.getElementById('payment-method').addEventListener('change', function() {
                const method = this.value;
                document.getElementById('credit-card-fields').classList.add('d-none');
                document.getElementById('upi-fields').classList.add('d-none');
                if (method === 'credit' || method === 'debit') {
                    document.getElementById('credit-card-fields').classList.remove('d-none');
                } else if (method === 'upi') {
                    document.getElementById('upi-fields').classList.remove('d-none');
                }
            });
            
            // Logout button
            document.getElementById('logout-btn').addEventListener('click', function(e) {
                e.preventDefault();
                Swal.fire({
                    title: 'Logout?',
                    text: 'Are you sure you want to logout?',
                    icon: 'question',
                    showCancelButton: true,
                    confirmButtonText: 'Yes, logout',
                    cancelButtonText: 'Cancel'
                }).then((result) => {
                    if (result.isConfirmed) {
                        // In a real app, you would redirect to logout page
                        Swal.fire('Logged Out', 'You have been successfully logged out.', 'success');
                    }
                });
            });
        }
        
        function switchSection(section) {
            // Hide all content sections
            document.querySelectorAll('[id$="-content"]').forEach(sec => {
                sec.classList.add('d-none');
            });
            
            // Show the selected section
            document.getElementById(section + '-content').classList.remove('d-none');
            
            // Update active link in sidebar
            document.querySelectorAll('.nav-link').forEach(link => {
                link.classList.remove('active');
            });
            document.querySelector(`[data-section="${section}"]`).classList.add('active');
            
            // Update page title and subtitle
            const titleMap = {
                dashboard: 'Patient Dashboard',
                profile: 'My Profile',
                appointments: 'My Appointments',
                prescriptions: 'My Prescriptions',
                doctors: 'Available Doctors',
                bills: 'Bills & Payments',
                feedback: 'Feedback & Reviews'
            };
            
            const subtitleMap = {
                dashboard: 'Welcome back, John Doe',
                profile: 'Manage your personal information',
                appointments: 'Schedule and manage your appointments',
                prescriptions: 'View your medication history',
                doctors: 'Find and book appointments with doctors',
                bills: 'View and pay your medical bills',
                feedback: 'Share your experience with us'
            };
            
            document.getElementById('page-title').textContent = titleMap[section];
            document.getElementById('page-subtitle').textContent = subtitleMap[section];
        }
        
        function viewAppointment(id) {
            const appointment = appointments.find(a => a.id === id);
            Swal.fire({
                title: 'Appointment Details',
                html: `
                    <p><strong>Doctor:</strong> ${appointment.doctor}</p>
                    <p><strong>Department:</strong> ${appointment.department}</p>
                    <p><strong>Date:</strong> ${appointment.date}</p>
                    <p><strong>Time:</strong> ${appointment.time}</p>
                    <p><strong>Status:</strong> ${appointment.status}</p>
                `,
                icon: 'info'
            });
        }
        
        function cancelAppointment(id) {
            currentAppointmentId = id;
            const appointment = appointments.find(a => a.id === id);
            document.getElementById('cancel-appointment-details').innerHTML = `
                <p><strong>Doctor:</strong> ${appointment.doctor}</p>
                <p><strong>Date:</strong> ${appointment.date}</p>
                <p><strong>Time:</strong> ${appointment.time}</p>
            `;
            const modal = new bootstrap.Modal(document.getElementById('cancelAppointmentModal'));
            modal.show();
        }
        
        function viewPrescription(id) {
            const prescription = prescriptions.find(p => p.id === id);
            document.getElementById('prescription-details').innerHTML = `
                <div class="row">
                    <div class="col-md-6">
                        <p><strong>Prescription ID:</strong> ${prescription.id}</p>
                        <p><strong>Date:</strong> ${prescription.date}</p>
                        <p><strong>Doctor:</strong> ${prescription.doctor}</p>
                    </div>
                    <div class="col-md-6">
                        <p><strong>Medication:</strong> ${prescription.medication}</p>
                        <p><strong>Dosage:</strong> ${prescription.dosage}</p>
                        <p><strong>Status:</strong> ${prescription.status}</p>
                    </div>
                </div>
                <div class="row mt-3">
                    <div class="col-12">
                        <p><strong>Instructions:</strong> ${prescription.instructions}</p>
                    </div>
                </div>
            `;
            const modal = new bootstrap.Modal(document.getElementById('viewPrescriptionModal'));
            modal.show();
        }
        
        function bookAppointmentWithDoctor(doctorId) {
            const doctor = doctors.find(d => d.id === doctorId);
            // Set the doctor in the appointment form
            document.getElementById('appointmentDoctor').value = doctorId;
            // Show the modal
            const modal = new bootstrap.Modal(document.getElementById('bookAppointmentModal'));
            modal.show();
        }
        
        function viewBill(id) {
            const bill = bills.find(b => b.id === id);
            Swal.fire({
                title: 'Bill Details',
                html: `
                    <p><strong>Bill ID:</strong> ${bill.id}</p>
                    <p><strong>Date:</strong> ${bill.date}</p>
                    <p><strong>Service:</strong> ${bill.service}</p>
                    <p><strong>Amount:</strong> $${bill.amount}</p>
                    <p><strong>Status:</strong> ${bill.status}</p>
                    <p><strong>Due Date:</strong> ${bill.dueDate}</p>
                `,
                icon: 'info'
            });
        }
        
        function payBill(id) {
            currentBillId = id;
            const bill = bills.find(b => b.id === id);
            document.getElementById('bill-details').innerHTML = `
                <p><strong>Bill ID:</strong> ${bill.id}</p>
                <p><strong>Service:</strong> ${bill.service}</p>
                <p><strong>Amount:</strong> $${bill.amount}</p>
            `;
            const modal = new bootstrap.Modal(document.getElementById('payBillModal'));
            modal.show();
        }
        
        function updateDashboardData() {
            // In a real app, this would fetch updated data from the server
            // For demonstration, we'll just update the counts with random values
            const upcomingCount = Math.max(0, Math.min(10, parseInt(document.getElementById('upcoming-appointments').textContent) + Math.floor(Math.random() * 3) - 1));
            const prescriptionCount = Math.max(0, Math.min(10, parseInt(document.getElementById('recent-prescriptions').textContent) + Math.floor(Math.random() * 2) - 0));
            const billCount = Math.max(0, Math.min(5, parseInt(document.getElementById('pending-bills').textContent) + Math.floor(Math.random() * 2) - 0));
            
            document.getElementById('upcoming-appointments').textContent = upcomingCount;
            document.getElementById('recent-prescriptions').textContent = prescriptionCount;
            document.getElementById('pending-bills').textContent = billCount;
            
            // Update notification badges
            document.getElementById('appointment-notification').textContent = upcomingCount;
            document.getElementById('prescription-notification').textContent = prescriptionCount;
        }
    </script>
</body>
</html>