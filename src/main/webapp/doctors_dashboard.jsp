<%@ page import="java.util.*, com.dao.DoctorDao, com.entity.Doctor" %>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page session="true" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Doctors Dashboard | HealthCare</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/bootstrap/5.3.0/css/bootstrap.min.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <style>
        :root {
            --primary-color: #1a73e8;
            --primary-dark: #0d47a1;
            --primary-light: #64b5f6;
            --accent-color: #42a5f5;
            --secondary-color: #7e57c2;
            --success-color: #2ecc71;
            --warning-color: #f39c12;
            --danger-color: #e74c3c;
            --light-bg: #f8fbff;
            --text-dark: #2c3e50;
            --text-light: #566573;
            --white: #ffffff;
            --card-shadow: 0 10px 30px rgba(0, 0, 0, 0.08);
            --hover-shadow: 0 20px 40px rgba(0, 0, 0, 0.12);
            --transition: all 0.4s cubic-bezier(0.175, 0.885, 0.32, 1.275);
        }

        body {
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            background: linear-gradient(135deg, #f5f7fa 0%, #e4edf5 100%);
            color: var(--text-dark);
            display: flex;
            flex-direction: column;
            min-height: 100vh;
            line-height: 1.6;
        }

        .navbar {
            background: linear-gradient(135deg, var(--primary-color), var(--primary-dark));
            box-shadow: 0 4px 18px rgba(26, 115, 232, 0.25);
            padding: 0.8rem 0;
            backdrop-filter: blur(10px);
        }

        .navbar-brand {
            font-weight: 800;
            font-size: 1.8rem;
            color: var(--white) !important;
            letter-spacing: -0.5px;
        }

        .navbar-nav .nav-link {
            color: rgba(255, 255, 255, 0.9) !important;
            font-weight: 500;
            margin: 0 5px;
            padding: 10px 18px !important;
            border-radius: 8px;
            transition: var(--transition);
            position: relative;
            overflow: hidden;
        }

        .navbar-nav .nav-link::before {
            content: '';
            position: absolute;
            top: 0;
            left: -100%;
            width: 100%;
            height: 100%;
            background: rgba(255, 255, 255, 0.15);
            transition: left 0.4s ease;
            z-index: -1;
        }

        .navbar-nav .nav-link:hover::before {
            left: 0;
        }

        .navbar-nav .nav-link:hover {
            color: var(--white) !important;
            transform: translateY(-2px);
        }

        .navbar-nav .nav-link.active {
            background: rgba(255, 255, 255, 0.15);
            color: var(--white) !important;
        }

        .user-info {
            color: white;
            font-weight: 500;
            margin-right: 15px;
        }

        .page-header {
            background: linear-gradient(135deg, var(--primary-color), var(--primary-dark));
            color: white;
            padding: 4rem 0 3rem;
            margin-bottom: 3rem;
            border-radius: 0 0 30px 30px;
            position: relative;
            overflow: hidden;
        }

        .page-header::before {
            content: '';
            position: absolute;
            top: 0;
            left: 0;
            width: 100%;
            height: 100%;
            background: url('data:image/svg+xml;utf8,<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 1440 320"><path fill="%23ffffff" fill-opacity="0.1" d="M0,96L48,112C96,128,192,160,288,160C384,160,480,128,576,112C672,96,768,96,864,112C960,128,1056,160,1152,160C1248,160,1344,128,1392,112L1440,96L1440,320L1392,320C1344,320,1248,320,1152,320C1056,320,960,320,864,320C768,320,672,320,576,320C480,320,384,320,288,320C192,320,96,320,48,320L0,320Z"></path></svg>');
            background-size: cover;
            background-position: center;
        }

        .page-title {
            font-weight: 800;
            margin-bottom: 0.5rem;
            font-size: 2.8rem;
            position: relative;
        }

        .page-subtitle {
            font-weight: 400;
            opacity: 0.9;
            font-size: 1.2rem;
            max-width: 600px;
            margin: 0 auto;
        }

        .doctor-count {
            background: rgba(255, 255, 255, 0.2);
            backdrop-filter: blur(10px);
            border-radius: 50px;
            padding: 12px 25px;
            font-weight: 600;
            box-shadow: 0 4px 15px rgba(0, 0, 0, 0.1);
            border: 1px solid rgba(255, 255, 255, 0.2);
        }

        /* Filter Section Styles */
        .filter-section {
            background: var(--white);
            border-radius: 20px;
            box-shadow: var(--card-shadow);
            padding: 2rem;
            margin-bottom: 3rem;
            transition: var(--transition);
        }

        .filter-section:hover {
            box-shadow: var(--hover-shadow);
        }

        .filter-header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 1.5rem;
            border-bottom: 1px solid rgba(0, 0, 0, 0.05);
            padding-bottom: 1rem;
        }

        .filter-title {
            font-weight: 700;
            font-size: 1.5rem;
            color: var(--primary-dark);
            margin: 0;
        }

        .filter-reset {
            background: transparent;
            border: 2px solid var(--text-light);
            color: var(--text-light);
            border-radius: 8px;
            padding: 8px 16px;
            font-weight: 600;
            transition: var(--transition);
        }

        .filter-reset:hover {
            background: var(--text-light);
            color: var(--white);
            transform: translateY(-2px);
        }

        .filter-group {
            margin-bottom: 1.5rem;
        }

        .filter-label {
            font-weight: 600;
            color: var(--text-dark);
            margin-bottom: 0.5rem;
            display: block;
        }

        .filter-select, .filter-input {
            width: 100%;
            padding: 12px 16px;
            border: 2px solid #e0e0e0;
            border-radius: 10px;
            background: var(--white);
            font-size: 1rem;
            transition: var(--transition);
        }

        .filter-select:focus, .filter-input:focus {
            border-color: var(--primary-color);
            box-shadow: 0 0 0 3px rgba(26, 115, 232, 0.2);
            outline: none;
        }

        .range-inputs {
            display: flex;
            gap: 15px;
        }

        .range-inputs .filter-input {
            flex: 1;
        }

        .range-slider {
            width: 100%;
            margin: 15px 0;
        }

        .filter-checkbox {
            display: flex;
            align-items: center;
            margin-bottom: 0.5rem;
        }

        .filter-checkbox input {
            margin-right: 10px;
            transform: scale(1.2);
        }

        .filter-checkbox label {
            font-weight: 500;
            color: var(--text-dark);
        }

        .filter-actions {
            display: flex;
            justify-content: flex-end;
            gap: 15px;
            margin-top: 1.5rem;
        }

        /* Card Styles */
        .card {
            border: none;
            border-radius: 20px;
            overflow: hidden;
            transition: var(--transition);
            height: 100%;
            box-shadow: var(--card-shadow);
            background: var(--white);
            position: relative;
        }

        .card::before {
            content: '';
            position: absolute;
            top: 0;
            left: 0;
            width: 100%;
            height: 5px;
            background: linear-gradient(135deg, var(--primary-color), var(--secondary-color));
        }

        .card:hover {
            transform: translateY(-12px);
            box-shadow: var(--hover-shadow);
        }

        .card-header {
            background: linear-gradient(135deg, var(--primary-color), var(--primary-dark));
            color: white;
            padding: 1.8rem 1.5rem;
            border-bottom: none;
            position: relative;
            overflow: hidden;
        }

        .card-header::after {
            content: '';
            position: absolute;
            bottom: 0;
            left: 0;
            width: 100%;
            height: 1px;
            background: rgba(255, 255, 255, 0.2);
        }

        .doctor-name {
            font-weight: 700;
            margin-bottom: 0.3rem;
            font-size: 1.5rem;
            letter-spacing: -0.3px;
        }

        .doctor-department {
            font-weight: 500;
            opacity: 0.9;
            font-size: 1rem;
            display: flex;
            align-items: center;
        }

        .card-body {
            padding: 2rem 1.5rem;
        }

        .doctor-details {
            margin-bottom: 1.5rem;
        }

        .detail-item {
            display: flex;
            margin-bottom: 1rem;
            align-items: flex-start;
        }

        .detail-icon {
            color: var(--primary-color);
            width: 24px;
            margin-right: 12px;
            margin-top: 3px;
            font-size: 1.1rem;
        }

        .detail-text {
            flex: 1;
        }

        .detail-label {
            font-weight: 600;
            font-size: 0.85rem;
            color: var(--text-light);
            text-transform: uppercase;
            letter-spacing: 0.5px;
            margin-bottom: 2px;
        }

        .detail-value {
            font-weight: 500;
            color: var(--text-dark);
            font-size: 1rem;
        }

        .availability-badge {
            display: inline-flex;
            align-items: center;
            padding: 8px 16px;
            border-radius: 50px;
            font-size: 0.85rem;
            font-weight: 600;
            box-shadow: 0 4px 10px rgba(0, 0, 0, 0.08);
        }

        .available {
            background: rgba(46, 204, 113, 0.15);
            color: var(--success-color);
            border: 1px solid rgba(46, 204, 113, 0.3);
        }

        .not-available {
            background: rgba(231, 76, 60, 0.15);
            color: var(--danger-color);
            border: 1px solid rgba(231, 76, 60, 0.3);
        }

        .card-footer {
            background-color: transparent;
            border-top: 1px solid rgba(0, 0, 0, 0.05);
            padding: 1.5rem;
            display: flex;
            justify-content: space-between;
            align-items: center;
        }

        /* Updated Button Styles */
        .btn {
            border: none;
            border-radius: 12px;
            padding: 12px 24px;
            font-weight: 600;
            font-size: 0.95rem;
            transition: var(--transition);
            display: inline-flex;
            align-items: center;
            justify-content: center;
            position: relative;
            overflow: hidden;
            box-shadow: 0 4px 15px rgba(0, 0, 0, 0.1);
        }

        .btn::before {
            content: '';
            position: absolute;
            top: 0;
            left: -100%;
            width: 100%;
            height: 100%;
            background: linear-gradient(90deg, transparent, rgba(255, 255, 255, 0.3), transparent);
            transition: left 0.7s ease;
        }

        .btn:hover::before {
            left: 100%;
        }

        .btn-info {
            background: linear-gradient(135deg, #3498db, #2980b9);
            color: var(--white);
        }

        .btn-info:hover {
            transform: translateY(-3px);
            box-shadow: 0 8px 20px rgba(52, 152, 219, 0.4);
        }

        .btn-success {
            background: linear-gradient(135deg, var(--success-color), #27ae60);
            color: var(--white);
        }

        .btn-success:hover {
            transform: translateY(-3px);
            box-shadow: 0 8px 20px rgba(46, 204, 113, 0.4);
        }

        .btn-primary {
            background: linear-gradient(135deg, var(--primary-color), var(--primary-dark));
            color: var(--white);
        }

        .btn-primary:hover {
            transform: translateY(-3px);
            box-shadow: 0 8px 20px rgba(26, 115, 232, 0.4);
        }

        .btn-warning {
            background: linear-gradient(135deg, var(--warning-color), #e67e22);
            color: var(--white);
        }

        .btn-warning:hover {
            transform: translateY(-3px);
            box-shadow: 0 8px 20px rgba(243, 156, 18, 0.4);
        }

        .btn-outline-secondary {
            background: transparent;
            color: var(--text-light);
            border: 2px solid #bdc3c7;
        }

        .btn-outline-secondary:hover {
            background: #bdc3c7;
            color: var(--white);
            transform: translateY(-3px);
            box-shadow: 0 8px 20px rgba(189, 195, 199, 0.4);
        }

        .btn i {
            margin-right: 8px;
            font-size: 1rem;
        }

        .main-content {
            flex: 1;
        }
        .no-doctors i {
            font-size: 5rem;
            color: #ddd;
            margin-bottom: 2rem;
        }

        .no-doctors h3 {
            color: var(--text-dark);
            margin-bottom: 1rem;
        }

        .no-doctors p {
            color: var(--text-light);
            max-width: 500px;
            margin: 0 auto;
        }

        @media (max-width: 768px) {
            .page-header {
                padding: 3rem 0 2rem;
                border-radius: 0 0 20px 20px;
            }
            
            .page-title {
                font-size: 2.2rem;
            }
            
            .card {
                margin-bottom: 2rem;
            }
            
            .card-footer {
                flex-direction: column;
                gap: 12px;
            }
            
            .card-footer .btn {
                width: 100%;
            }

            .filter-actions {
                flex-direction: column;
            }

            .range-inputs {
                flex-direction: column;
                gap: 10px;
            }
        }

        /* Animation for cards when they appear */
        @keyframes fadeInUp {
            from {
                opacity: 0;
                transform: translateY(30px);
            }
            to {
                opacity: 1;
                transform: translateY(0);
            }
        }

        .doctor-card {
            animation: fadeInUp 0.6s ease forwards;
            opacity: 0;
        }

        /* Stagger animation for cards */
        .doctor-card:nth-child(1) { animation-delay: 0.1s; }
        .doctor-card:nth-child(2) { animation-delay: 0.2s; }
        .doctor-card:nth-child(3) { animation-delay: 0.3s; }
        .doctor-card:nth-child(4) { animation-delay: 0.4s; }
        .doctor-card:nth-child(5) { animation-delay: 0.5s; }
        .doctor-card:nth-child(6) { animation-delay: 0.6s; }

        /* Filter results count */
        .filter-results {
            margin-bottom: 1.5rem;
            font-weight: 600;
            color: var(--text-dark);
            font-size: 1.1rem;
        }
    </style>
</head>
<body>
    <%
        DoctorDao dao = new DoctorDao();
        List<Doctor> doctors = dao.getAllDoctors();
        
        // Check if patient is logged in
        Boolean isPatientLoggedIn = false;
        String patientName = "";
        if (session.getAttribute("patientId") != null) {
            isPatientLoggedIn = true;
            patientName = (String) session.getAttribute("patientName");
        }

        // Get unique departments for filter
        Set<String> departments = new HashSet<>();
        // Get unique locations for filter
        Set<String> locations = new HashSet<>();
        // Get fee range for filter
        double minFeeValue = Double.MAX_VALUE;
        double maxFeeValue = 0;
        
        for (Doctor doctor : doctors) {
            departments.add(doctor.getDepartment());
            locations.add(doctor.getClinicAddress());
            
            // Calculate fee range - FIXED: Use double instead of int
            double fee = doctor.getVisitingCharge();
            if (fee < minFeeValue) minFeeValue = fee;
            if (fee > maxFeeValue) maxFeeValue = fee;
        }
        
        // Set default min/max if no doctors
        if (doctors.isEmpty()) {
            minFeeValue = 0;
            maxFeeValue = 1000;
        }
    %>

    <!-- Navigation Bar -->
    <nav class="navbar navbar-expand-lg navbar-dark sticky-top">
        <div class="container">
            <a class="navbar-brand" href="index.jsp">
                <i class="fas fa-heartbeat me-2"></i>HealthCare
            </a>
            <button class="navbar-toggler" type="button" data-bs-toggle="collapse" data-bs-target="#navbarNav">
                <span class="navbar-toggler-icon"></span>
            </button>
            <div class="collapse navbar-collapse" id="navbarNav">
                <ul class="navbar-nav me-auto">
                    <li class="nav-item">
                        <a class="nav-link" href="index.jsp"><i class="fas fa-home me-1"></i> Home</a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link active" href="doctors.jsp"><i class="fas fa-user-md me-1"></i> Doctors</a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link" href="departments.jsp"><i class="fas fa-stethoscope me-1"></i> Departments</a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link" href="about.jsp"><i class="fas fa-info-circle me-1"></i> About</a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link" href="contact.jsp"><i class="fas fa-envelope me-1"></i> Contact</a>
                    </li>
                </ul>
                <div class="d-flex align-items-center">
                    <% if (isPatientLoggedIn) { %>
                        <span class="user-info"><i class="fas fa-user me-1"></i> Welcome, <%= patientName %></span>
                        <a href="patientLogout.jsp" class="btn btn-outline-light btn-sm">
                            <i class="fas fa-sign-out-alt me-1"></i> Logout
                        </a>
                    <% } else { %>
                        <a href="patientLogin.jsp" class="btn btn-outline-light btn-sm me-2">
                            <i class="fas fa-sign-in-alt me-1"></i> Login
                        </a>
                        <a href="patientRegister.jsp" class="btn btn-light btn-sm">
                            <i class="fas fa-user-plus me-1"></i> Register
                        </a>
                    <% } %>
                </div>
            </div>
        </div>
    </nav>

    <!-- Page Header -->
    <div class="page-header">
        <div class="container">
            <div class="row align-items-center">
                <div class="col-lg-8 text-center text-lg-start">
                    <h1 class="page-title">Our Medical Experts</h1>
                    <p class="page-subtitle">Find and book appointments with our qualified healthcare professionals committed to your well-being</p>
                </div>
                <div class="col-lg-4 text-center text-lg-end mt-4 mt-lg-0">
                    <span class="doctor-count"><i class="fas fa-user-md me-2"></i><span id="doctorCount"><%= doctors.size() %></span> Doctors Available</span>
                </div>
            </div>
        </div>
    </div>

    <!-- Main Content -->
    <div class="main-content">
        <div class="container">
            <!-- Filter Section -->
            <div class="filter-section">
                <div class="filter-header">
                    <h2 class="filter-title"><i class="fas fa-filter me-2"></i>Find Your Doctor</h2>
                    <button class="filter-reset" id="resetFilters"><i class="fas fa-redo me-1"></i> Reset Filters</button>
                </div>
                
                <div class="row">
                    <div class="col-md-6 col-lg-3">
                        <div class="filter-group">
                            <label class="filter-label">Department</label>
                            <select class="filter-select" id="departmentFilter">
                                <option value="">All Departments</option>
                                <% for (String department : departments) { %>
                                    <option value="<%= department %>"><%= department %></option>
                                <% } %>
                            </select>
                        </div>
                    </div>
                    
                    <div class="col-md-6 col-lg-3">
                        <div class="filter-group">
                            <label class="filter-label">Location</label>
                            <select class="filter-select" id="locationFilter">
                                <option value="">All Locations</option>
                                <% for (String location : locations) { %>
                                    <option value="<%= location %>"><%= location %></option>
                                <% } %>
                            </select>
                        </div>
                    </div>
                    
                    <div class="col-md-6 col-lg-3">
                        <div class="filter-group">
                            <label class="filter-label">Consultation Fee (₹<span id="minFeeDisplay"><%= String.format("%.0f", minFeeValue) %></span> - ₹<span id="maxFeeDisplay"><%= String.format("%.0f", maxFeeValue) %></span>)</label>
                            <div class="range-inputs">
                                <input type="number" class="filter-input" id="minFee" placeholder="Min" min="0" value="<%= (int)minFeeValue %>">
                                <input type="number" class="filter-input" id="maxFee" placeholder="Max" min="0" value="<%= (int)maxFeeValue %>">
                            </div>
                        </div>
                    </div>
                    
                    <div class="col-md-6 col-lg-3">
                        <div class="filter-group">
                            <label class="filter-label">Experience</label>
                            <select class="filter-select" id="experienceFilter">
                                <option value="">Any Experience</option>
                                <option value="5">5+ years</option>
                                <option value="10">10+ years</option>
                                <option value="15">15+ years</option>
                                <option value="20">20+ years</option>
                            </select>
                        </div>
                    </div>
                </div>
                
                <div class="row mt-3">
                    <div class="col-md-6">
                        <div class="filter-group">
                            <label class="filter-label">Availability</label>
                            <div class="d-flex flex-wrap gap-3">
                                <div class="filter-checkbox">
                                    <input type="checkbox" id="availableNow" value="Available">
                                    <label for="availableNow">Available Now</label>
                                </div>
                                <div class="filter-checkbox">
                                    <input type="checkbox" id="availableToday" value="Today">
                                    <label for="availableToday">Available Today</label>
                                </div>
                            </div>
                        </div>
                    </div>
                    
                    <div class="col-md-6">
                        <div class="filter-actions">
                            <button class="btn btn-primary" id="applyFilters">
                                <i class="fas fa-search me-1"></i> Apply Filters
                            </button>
                            <button class="btn btn-warning" id="clearFilters">
                                <i class="fas fa-times me-1"></i> Clear All
                            </button>
                        </div>
                    </div>
                </div>
            </div>

            <!-- Results Count -->
            <div class="filter-results">
                Showing <span id="resultsCount"><%= doctors.size() %></span> doctors
            </div>

            <!-- Doctors Grid -->
            <% if (doctors.isEmpty()) { %>
                <div class="no-doctors">
                    <i class="fas fa-user-md"></i>
                    <h3>No Doctors Available</h3>
                    <p class="text-muted">We're currently updating our doctor database. Please check back later or contact our support for assistance.</p>
                    <a href="contact.jsp" class="btn btn-info mt-3"><i class="fas fa-headset me-2"></i>Contact Support</a>
                </div>
            <% } else { %>
                <div class="row" id="doctorsContainer">
                    <% for (Doctor doctor : doctors) { %>
                        <div class="col-xl-4 col-lg-6 col-md-6 mb-4 doctor-card" 
                             data-department="<%= doctor.getDepartment() %>"
                             data-location="<%= doctor.getClinicAddress() %>"
                             data-fee="<%= doctor.getVisitingCharge() %>"
                             data-experience="<%= doctor.getYearsOfExperience() %>"
                             data-availability="<%= doctor.getAvailability() %>">
                            <div class="card h-100">
                                <div class="card-header">
                                    <h4 class="doctor-name"><%= doctor.getFullName() %></h4>
                                    <p class="doctor-department mb-0"><i class="fas fa-stethoscope me-2"></i> <%= doctor.getDepartment() %></p>
                                </div>
                                <div class="card-body">
                                    <div class="doctor-details">
                                        <div class="detail-item">
                                            <div class="detail-icon">
                                                <i class="fas fa-graduation-cap"></i>
                                            </div>
                                            <div class="detail-text">
                                                <div class="detail-label">Qualification</div>
                                                <div class="detail-value"><%= doctor.getQualification() %></div>
                                            </div>
                                        </div>
                                        
                                        <div class="detail-item">
                                            <div class="detail-icon">
                                                <i class="fas fa-briefcase"></i>
                                            </div>
                                            <div class="detail-text">
                                                <div class="detail-label">Experience</div>
                                                <div class="detail-value"><%= doctor.getYearsOfExperience() %> years</div>
                                            </div>
                                        </div>
                                        
										<div class="detail-item">
										        <div class="detail-icon">
										            <i class="fas fa-money-bill-wave"></i>
										        </div>
										        <div class="detail-text">
										            <div class="detail-label">Consultation Fee</div>
										            <div class="detail-value">₹<%= doctor.getVisitingCharge() %></div>
										        </div>
										    </div>
                                        
                                        <div class="detail-item">
                                            <div class="detail-icon">
                                                <i class="fas fa-map-marker-alt"></i>
                                            </div>
                                            <div class="detail-text">
                                                <div class="detail-label">Clinic Address</div>
                                                <div class="detail-value"><%= doctor.getClinicAddress() %></div>
                                            </div>
                                        </div>
                                        
                                        <div class="detail-item">
                                            <div class="detail-icon">
                                                <i class="fas fa-phone"></i>
                                            </div>
                                            <div class="detail-text">
                                                <div class="detail-label">Contact</div>
                                                <div class="detail-value"><%= doctor.getPhone() %></div>
                                            </div>
                                        </div>
                                        
                                        <div class="detail-item">
                                            <div class="detail-icon">
                                                <i class="fas fa-clock"></i>
                                            </div>
                                            <div class="detail-text">
                                                <div class="detail-label">Availability</div>
                                                <div class="detail-value">
                                                    <span class="availability-badge <%= doctor.getAvailability().toLowerCase().contains("available") ? "available" : "not-available" %>">
                                                        <i class="fas <%= doctor.getAvailability().toLowerCase().contains("available") ? "fa-check-circle" : "fa-times-circle" %> me-1"></i>
                                                        <%= doctor.getAvailability() %>
                                                    </span>
                                                </div>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                                <div class="card-footer">
                                    <a href="doctorInfo.jsp?doctorId=<%= doctor.getId() %>" class="btn btn-info">
                                        <i class="fas fa-info-circle me-1"></i> View Profile
                                    </a>
                                    <% if (isPatientLoggedIn) { %>
                                        <a href="bookAppointment.jsp?doctorId=<%= doctor.getId() %>" class="btn btn-success">
                                            <i class="fas fa-calendar-check me-1"></i> Book Now
                                        </a>
                                    <% } else { %>
                                        <a href="patientLogin.jsp" class="btn btn-outline-secondary">
                                            <i class="fas fa-sign-in-alt me-1"></i> Login to Book
                                        </a>
                                    <% } %>
                                </div>
                            </div>
                        </div>
                    <% } %>
                </div>
            <% } %>
        </div>
    </div>

    <!-- Footer -->
    <footer>
            <%@include file="../component/footer.jsp"%>
    </footer>

    <script src="https://cdnjs.cloudflare.com/ajax/libs/bootstrap/5.3.0/js/bootstrap.bundle.min.js"></script>
    <script>
        document.addEventListener('DOMContentLoaded', function() {
            // Get filter elements
            const departmentFilter = document.getElementById('departmentFilter');
            const locationFilter = document.getElementById('locationFilter');
            const minFee = document.getElementById('minFee');
            const maxFee = document.getElementById('maxFee');
            const experienceFilter = document.getElementById('experienceFilter');
            const availableNow = document.getElementById('availableNow');
            const availableToday = document.getElementById('availableToday');
            const applyFilters = document.getElementById('applyFilters');
            const clearFilters = document.getElementById('clearFilters');
            const resetFilters = document.getElementById('resetFilters');
            const doctorCards = document.querySelectorAll('.doctor-card');
            const doctorCount = document.getElementById('doctorCount');
            const resultsCount = document.getElementById('resultsCount');
            const minFeeDisplay = document.getElementById('minFeeDisplay');
            const maxFeeDisplay = document.getElementById('maxFeeDisplay');

            // Apply filters function
            function applyDoctorFilters() {
                let visibleCount = 0;
                
                doctorCards.forEach(card => {
                    const department = card.getAttribute('data-department');
                    const location = card.getAttribute('data-location');
                    const fee = parseFloat(card.getAttribute('data-fee')); // Use parseFloat for double values
                    const experience = parseInt(card.getAttribute('data-experience'));
                    const availability = card.getAttribute('data-availability');
                    
                    let isVisible = true;
                    
                    // Department filter
                    if (departmentFilter.value && department !== departmentFilter.value) {
                        isVisible = false;
                    }
                    
                    // Location filter
                    if (locationFilter.value && location !== locationFilter.value) {
                        isVisible = false;
                    }
                    
                    // Fee filter - use parseFloat for comparison
                    const minFeeValue = minFee.value ? parseFloat(minFee.value) : 0;
                    const maxFeeValue = maxFee.value ? parseFloat(maxFee.value) : Infinity;
                    
                    if (fee < minFeeValue || fee > maxFeeValue) {
                        isVisible = false;
                    }
                    
                    // Experience filter
                    if (experienceFilter.value && experience < parseInt(experienceFilter.value)) {
                        isVisible = false;
                    }
                    
                    // Availability filters
                    if (availableNow.checked && !availability.toLowerCase().includes('available')) {
                        isVisible = false;
                    }
                    
                    if (availableToday.checked && !availability.toLowerCase().includes('today')) {
                        isVisible = false;
                    }
                    
                    // Show or hide card based on filters
                    if (isVisible) {
                        card.style.display = 'block';
                        visibleCount++;
                    } else {
                        card.style.display = 'none';
                    }
                });
                
                // Update counts
                resultsCount.textContent = visibleCount;
            }

            // Clear all filters
            function clearAllFilters() {
                departmentFilter.value = '';
                locationFilter.value = '';
                minFee.value = '<%= (int)minFeeValue %>';
                maxFee.value = '<%= (int)maxFeeValue %>';
                experienceFilter.value = '';
                availableNow.checked = false;
                availableToday.checked = false;
                
                applyDoctorFilters();
            }

            // Reset to default state
            function resetToDefault() {
                clearAllFilters();
                doctorCount.textContent = '<%= doctors.size() %>';
            }

            // Event listeners
            applyFilters.addEventListener('click', applyDoctorFilters);
            clearFilters.addEventListener('click', clearAllFilters);
            resetFilters.addEventListener('click', resetToDefault);

            // Apply filters on Enter key in fee inputs
            [minFee, maxFee].forEach(input => {
                input.addEventListener('keyup', function(event) {
                    if (event.key === 'Enter') {
                        applyDoctorFilters();
                    }
                });
            });

            // Update fee display when inputs change
            [minFee, maxFee].forEach(input => {
                input.addEventListener('input', function() {
                    minFeeDisplay.textContent = minFee.value || '<%= (int)minFeeValue %>';
                    maxFeeDisplay.textContent = maxFee.value || '<%= (int)maxFeeValue %>';
                });
            });
        });
    </script>
</body>
</html>