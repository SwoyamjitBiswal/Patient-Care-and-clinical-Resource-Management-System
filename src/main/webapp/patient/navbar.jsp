<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@page isELIgnored="false" %>

<%
    // Get patient information from session
    HttpSession patientSession = request.getSession(false);
    String patientName = (patientSession != null) ? (String) patientSession.getAttribute("patientName") : null;
    Integer patientId = (patientSession != null) ? (Integer) patientSession.getAttribute("patientId") : null;
    boolean isLoggedIn = (patientId != null);
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0"/>
    <title>MedCare - Patient Portal</title>

    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">

    <style>
        :root {
            --primary: #2563eb;
            --primary-light: #3b82f6;
            --primary-dark: #1d4ed8;
            --secondary: #64748b;
            --accent: #0ea5e9;
            --light: #f8fafc;
            --white: #ffffff;
            --gray-light: #f1f5f9;
            --gray: #94a3b8;
            --dark: #1e293b;
            --text: #334155;
            --text-light: #64748b;
            --shadow: 0 4px 6px -1px rgba(0, 0, 0, 0.1), 0 2px 4px -1px rgba(0, 0, 0, 0.06);
            --shadow-lg: 0 10px 15px -3px rgba(0, 0, 0, 0.1), 0 4px 6px -2px rgba(0, 0, 0, 0.05);
            --radius: 12px;
        }

        * { margin: 0; padding: 0; box-sizing: border-box; font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif; }

        body {
            background: linear-gradient(135deg, #f8fafc 0%, #e2e8f0 100%);
            color: var(--text);
            min-height: 100vh;
            padding-top: 80px;
        }

        .custom-navbar {
            padding: 0.7rem 0;
            transition: all 0.3s ease;
            position: fixed;
            top: 0;
            width: 100%;
            z-index: 1030;
            backdrop-filter: blur(10px);
            background: rgba(255, 255, 255, 0.98) !important;
            border-bottom: 1px solid rgba(0, 0, 0, 0.05);
            box-shadow: 0 2px 15px rgba(0, 0, 0, 0.08);
        }

        .navbar-brand { font-size: 1.7rem; font-weight: 700; padding: 0.5rem 0; background: linear-gradient(135deg, #2563eb, #3b82f6); -webkit-background-clip: text; -webkit-text-fill-color: transparent; background-clip: text; }
        .navbar-brand i { font-size: 2rem; }

        .nav-link {
            font-size: 1rem;
            padding: 0.6rem 1rem !important;
            transition: all 0.3s ease;
            border-radius: 10px;
            position: relative;
            font-weight: 500;
            margin: 0 0.3rem;
            color: #475569 !important;
        }

        .nav-link:not(.dropdown-toggle):after {
            content: '';
            position: absolute;
            bottom: 0;
            left: 50%;
            width: 0;
            height: 3px;
            background: linear-gradient(135deg, #2563eb, #3b82f6);
            transition: all 0.3s ease;
            transform: translateX(-50%);
            border-radius: 2px;
        }

        .nav-link:hover:not(.dropdown-toggle):after,
        .nav-link.active:after { width: 80%; }

        .nav-link:hover, .nav-link:focus { color: #2563eb !important; transform: translateY(-2px); background: rgba(37, 99, 235, 0.05); }
        .nav-link.active { color: #2563eb !important; font-weight: 600; background: rgba(37, 99, 235, 0.08); }

        /* Patient Dropdown - FIXED */
        .patient-dropdown {
            padding: 0.6rem 1rem !important;
            border-radius: 12px;
            transition: all 0.3s ease;
            cursor: pointer;
            background: linear-gradient(135deg, #f8fafc, #f1f5f9);
            border: 1px solid #e2e8f0;
            margin-left: 0.5rem;
            display: flex;
            align-items: center;
            text-decoration: none !important;
        }
        .patient-dropdown:hover { 
            background: linear-gradient(135deg, #f1f5f9, #e2e8f0); 
            border-color: #cbd5e1; 
            transform: translateY(-1px); 
            box-shadow: 0 4px 12px rgba(37, 99, 235, 0.1); 
            color: #475569 !important;
        }

        .user-avatar { font-size: 0.9rem; transition: all 0.3s ease; box-shadow: 0 2px 8px rgba(37, 99, 235, 0.2); }
        .user-name { max-width: 160px; overflow: hidden; text-overflow: ellipsis; white-space: nowrap; font-weight: 600; color: #1e293b; }

        .btn-appointment {
            background: linear-gradient(135deg, #2563eb, #3b82f6);
            border: none; border-radius: 10px; font-weight: 600; padding: 0.6rem 1.2rem; transition: all 0.3s ease; font-size: 0.95rem; box-shadow: 0 4px 12px rgba(37, 99, 235, 0.2);
        }
        .btn-appointment:hover { background: linear-gradient(135deg, #1d4ed8, #2563eb); transform: translateY(-2px); box-shadow: 0 6px 20px rgba(37, 99, 235, 0.3); }

        .dropdown-menu {
            background: white !important;
            border: 1px solid #e2e8f0;
            border-radius: 16px;
            padding: 0.8rem 0;
            min-width: 240px;
            box-shadow: 0 20px 40px -8px rgba(0, 0, 0, 0.15), 0 8px 20px -4px rgba(0, 0, 0, 0.1);
            margin-top: 0.8rem !important;
            z-index: 1060;
            backdrop-filter: blur(10px);
        }

        .dropdown-menu.show { display: block; animation: slideInDown 0.3s ease; }

        .dropdown-header { font-size: 0.95rem; padding: 1rem 1.5rem; background: linear-gradient(135deg, #f8fafc, #f1f5f9); border-radius: 16px 16px 0 0; margin: -0.8rem 0 0.5rem 0; }

        .dropdown-item {
            transition: all 0.25s ease;
            border-radius: 10px;
            margin: 0.2rem 0.5rem;
            padding: 0.8rem 1.2rem;
            font-weight: 500;
            border: 1px solid transparent;
            display: flex;
            align-items: center;
            cursor: pointer;
            color: #475569;
            font-size: 0.95rem;
        }
        .dropdown-item:hover, .dropdown-item:focus { background: linear-gradient(135deg, #3b82f6, #2563eb) !important; color: white !important; transform: translateX(5px); box-shadow: 0 4px 12px rgba(37, 99, 235, 0.3); }
        .dropdown-item:hover i, .dropdown-item:focus i { color: white !important; }

        .btn { border-radius: 10px; font-weight: 600; padding: 0.5rem 1.2rem; transition: all 0.3s ease; font-size: 0.95rem; }
        .btn-outline-primary { border: 2px solid #2563eb; color: #2563eb; }
        .btn-outline-primary:hover { background: #2563eb; border-color: #2563eb; transform: translateY(-2px); box-shadow: 0 6px 20px rgba(37, 99, 235, 0.2); }
        .btn-primary { background: linear-gradient(135deg, #2563eb, #3b82f6); border: none; }
        .btn-primary:hover { background: linear-gradient(135deg, #1d4ed8, #2563eb); transform: translateY(-2px); box-shadow: 0 6px 20px rgba(37, 99, 235, 0.3); }

        .navbar-toggler { border: none; padding: 0.4rem 0.6rem; transition: all 0.3s ease; border-radius: 8px; }
        .navbar-toggler:focus { box-shadow: 0 0 0 3px rgba(37, 99, 235, 0.1); background: #f1f5f9; }
        .navbar-toggler-icon { background-image: url("data:image/svg+xml,%3csvg xmlns='http://www.w3.org/2000/svg' viewBox='0 0 30 30'%3e%3cpath stroke='rgba%2837, 99, 235, 1%29' stroke-linecap='round' stroke-miterlimit='10' stroke-width='2' d='M4 7h22M4 15h22M4 23h22'/%3e%3c/svg%3e"); transition: all 0.3s ease; width: 1.2em; height: 1.2em; }

        @keyframes slideInDown {
            from { opacity: 0; transform: translate3d(0, -10px, 0); }
            to { opacity: 1; transform: translate3d(0, 0, 0); }
        }

        .demo-content { max-width: 1200px; margin: 0 auto; padding: 2rem; }
        .demo-card { background: white; border-radius: var(--radius); box-shadow: var(--shadow-lg); padding: 2rem; margin-bottom: 2rem; }
        
        .dropdown-toggle::after {
            display: inline-block;
            margin-left: 0.5em;
            vertical-align: middle;
            content: "";
            border-top: 0.4em solid;
            border-right: 0.4em solid transparent;
            border-left: 0.4em solid transparent;
        }

        /* Responsive tweaks */
        @media (max-width: 991px) {
            .navbar-nav { text-align: center; margin-top: 1rem; padding: 1rem 0; }
            .nav-item { margin: 0.4rem 0; }
            .patient-dropdown { margin: 0.5rem 0; display: inline-flex; width: auto; justify-content: center; max-width: 280px; }
            .dropdown-menu { text-align: left; border: 1px solid #e2e8f0; box-shadow: 0 10px 25px -3px rgba(0,0,0,0.1); background: white !important; position: static !important; margin: 0.5rem auto; width: 90%; }
            .user-name { max-width: 200px; }
            .navbar-collapse { border-top: 1px solid #e2e8f0; margin-top: 0.5rem; padding-top: 1rem; }
            .btn { margin: 0.3rem 0; display: inline-block; width: auto; min-width: 140px; }
            .navbar-nav.ms-auto { flex-direction: column; align-items: center; }
            .navbar-nav.ms-auto .nav-item { width: 100%; text-align: center; }
            .navbar-nav.ms-auto .btn { width: 100%; max-width: 250px; margin: 0.3rem auto; }
        }

        @media (max-width: 576px) {
            .navbar-brand { font-size: 1.5rem; }
            .navbar-brand i { font-size: 1.7rem; }
            .nav-link { padding: 0.6rem 0.8rem !important; font-size: 0.95rem; }
            .container-fluid { padding-left: 1rem; padding-right: 1rem; }
            .dropdown-menu { width: 95%; margin: 0.5rem auto; }
            .user-name { max-width: 120px; }
        }
    </style>
</head>
<body>
    <!-- Fixed Navbar -->
    <nav class="navbar navbar-expand-lg navbar-light bg-white sticky-top custom-navbar">
        <div class="container-fluid px-4">
            <!-- Brand Logo -->
            <a class="navbar-brand fw-bold d-flex align-items-center" href="patient_index.jsp">
                <i class="fa-solid fa-heart-pulse me-2 text-primary"></i>
                <span class="text-dark">MedCare Patient</span>
            </a>

            <!-- Mobile Toggler -->
            <button class="navbar-toggler border-0" type="button" data-bs-toggle="collapse"
                data-bs-target="#patientNavbarContent" aria-controls="patientNavbarContent" aria-expanded="false"
                aria-label="Toggle navigation">
                <span class="navbar-toggler-icon"></span>
            </button>

            <!-- Navbar Content -->
            <div class="collapse navbar-collapse" id="patientNavbarContent">
                <!-- Navigation Links -->
                <ul class="navbar-nav mx-auto align-items-lg-center">
                    <li class="nav-item px-2">
                        <a class="nav-link fw-medium position-relative" href="patient_index.jsp">
                            <i class="fa-solid fa-house me-1"></i> Home
                        </a>
                    </li>
                    <li class="nav-item px-2">
                        <a class="nav-link fw-medium position-relative" href="doctors.jsp">
                            <i class="fa-solid fa-user-doctor me-1"></i> Doctors
                        </a>
                    </li>
                    <li class="nav-item px-2">
                        <a class="nav-link fw-medium position-relative" href="services.jsp">
                            <i class="fa-solid fa-hand-holding-medical me-1"></i> Services
                        </a>
                    </li>
                </ul>

                <!-- User Section -->
                <ul class="navbar-nav ms-auto align-items-lg-center">
                    <% if (isLoggedIn && patientName != null) { %>
                        <!-- Book Appointment Button -->
                        <li class="nav-item px-2">
                            <a class="btn btn-appointment fw-medium d-flex align-items-center me-2"
                               href="<%= request.getContextPath() %>/patient/book_appointment.jsp">
                                <i class="fa-solid fa-calendar-plus me-2 fa-fw"></i> Book Appointment
                            </a>
                        </li>

                        <!-- My Appointments Link -->
                        <li class="nav-item px-2">
                            <a class="nav-link fw-medium position-relative" href="view_appointment.jsp">
                                <i class="fa-solid fa-calendar-check me-1 fa-fw"></i> My Appointments
                            </a>
                        </li>

                        <!-- Patient Dropdown - FIXED -->
                        <li class="nav-item dropdown px-2 position-relative">
                            <!-- Using anchor tag for dropdown toggle - FIXED -->
                            <a class="nav-link dropdown-toggle fw-medium d-flex align-items-center position-relative patient-dropdown"
                               href="#" id="patientDropdown" role="button"
                               data-bs-toggle="dropdown" aria-expanded="false">
                                <div class="user-avatar bg-primary rounded-circle d-flex align-items-center justify-content-center me-2"
                                     style="width: 36px; height: 36px;">
                                    <i class="fa-solid fa-user text-white small fa-fw"></i>
                                </div>
                                <span class="user-name"><%= patientName %></span>
                            </a>

                            <ul class="dropdown-menu dropdown-menu-end shadow-lg border-0 rounded-3 p-2"
                                aria-labelledby="patientDropdown" style="min-width: 240px;">
                                <li class="dropdown-header p-3">
                                    <div class="d-flex align-items-center">
                                        <div class="user-avatar bg-primary rounded-circle d-flex align-items-center justify-content-center me-3"
                                             style="width: 44px; height: 44px;">
                                            <i class="fa-solid fa-user text-white fa-fw"></i>
                                        </div>
                                        <div>
                                            <div class="fw-bold"><%= patientName %></div>
                                            <small class="text-muted">Patient</small>
                                        </div>
                                    </div>
                                </li>
                                <li><hr class="dropdown-divider my-2"></li>
                                <li>
                                    <a class="dropdown-item d-flex align-items-center text-dark p-2" href="profile.jsp">
                                        <i class="fa-solid fa-user me-2 fa-fw"></i> My Profile
                                    </a>
                                </li>
                                <li>
                                    <a class="dropdown-item d-flex align-items-center text-dark p-2" href="medical_records.jsp">
                                        <i class="fa-solid fa-file-medical me-2 fa-fw"></i> Medical Records
                                    </a>
                                </li>
                                <li>
                                    <a class="dropdown-item d-flex align-items-center text-dark p-2" href="prescriptions.jsp">
                                        <i class="fa-solid fa-prescription me-2 fa-fw"></i> Prescriptions
                                    </a>
                                </li>
                                <li><hr class="dropdown-divider my-2"></li>
                                <li>
                                    <a class="dropdown-item d-flex align-items-center text-dark p-2" href="change_password.jsp">
                                        <i class="fa-solid fa-key me-2 fa-fw"></i> Change Password
                                    </a>
                                </li>
                                <li><hr class="dropdown-divider my-2"></li>
                                <li>
                                    <a class="dropdown-item d-flex align-items-center text-danger p-2" href="../patientLogout">
                                        <i class="fa-solid fa-right-from-bracket me-2 fa-fw"></i> Logout
                                    </a>
                                </li>
                            </ul>
                        </li>
                    <% } else { %>
                        <!-- Login/Signup Buttons -->
                        <li class="nav-item px-2">
                            <a class="btn btn-outline-primary btn-sm me-2" href="patient_login.jsp">
                                <i class="fa-solid fa-right-to-bracket me-1"></i> Login
                            </a>
                        </li>
                        <li class="nav-item px-2">
                            <a class="btn btn-primary btn-sm" href="patient_register.jsp">
                                <i class="fa-solid fa-user-plus me-1"></i> Sign Up
                            </a>
                        </li>
                    <% } %>
                </ul>
            </div>
        </div>
    </nav>

    <!-- Demo Content -->
    <div class="demo-content">
        <div class="demo-card">
            <h2 class="mb-4">Patient Dashboard</h2>
            <p>Welcome to the MedCare Patient Portal. This is a demonstration of the fixed navbar with working dropdown functionality.</p>
            <p>The dropdown menu should now work properly with all the features you requested:</p>
            <ul>
                <li>Book Appointment button for quick access</li>
                <li>My Appointments link for viewing scheduled appointments</li>
                <li>User profile dropdown with medical records, prescriptions, and settings</li>
                <li>Responsive design that works on all devices</li>
            </ul>
        </div>

        <div class="demo-card">
            <h3 class="mb-3">Dropdown Functionality</h3>
            <p>The dropdown is now working correctly with:</p>
            <ul>
                <li>Proper Bootstrap initialization</li>
                <li>Smooth animations</li>
                <li>Hover effects</li>
                <li>Correct positioning on all screen sizes</li>
            </ul>
            
            <!-- Test Area -->
            <div class="mt-4 p-3 bg-light rounded">
                <h5>Test the Dropdown</h5>
                <p>Click on the user profile dropdown in the navigation bar to test the functionality.</p>
                <div class="alert alert-success mt-3" id="dropdownStatus">
                    Dropdown status: <span id="statusText">Ready to test</span>
                </div>
            </div>
        </div>
    </div>

    <!-- Bootstrap Bundle (includes Popper) -->
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>

    <script>
        // Defensive check: ensure bootstrap is available
        if (typeof bootstrap === 'undefined') {
            console.error('Bootstrap JS not loaded. Dropdowns will not work. Check your CDN or local script inclusion.');
            document.getElementById('statusText').textContent = 'Error: Bootstrap not loaded';
            document.getElementById('dropdownStatus').classList.remove('alert-success');
            document.getElementById('dropdownStatus').classList.add('alert-danger');
        } else {
            console.log('Bootstrap loaded successfully');
            document.addEventListener('DOMContentLoaded', function () {
                // Add active class to current page (improved matching)
                (function markActiveLinks(){
                    const current = window.location.pathname.split('/').pop() || 'patient_index.jsp';
                    document.querySelectorAll('.nav-link:not(.dropdown-toggle)').forEach(link => {
                        const href = link.getAttribute('href');
                        if (!href) return;
                        // compare only filename portion for more robust behavior
                        const linkFile = href.split('/').pop();
                        if (linkFile && current === linkFile) {
                            link.classList.add('active');
                        }
                    });
                })();

                // Initialize any dropdown toggles (buttons/links with data-bs-toggle="dropdown")
                document.querySelectorAll('[data-bs-toggle="dropdown"]').forEach(function (el) {
                    // If there's already an instance, don't recreate
                    if (!bootstrap.Dropdown.getInstance(el)) {
                        new bootstrap.Dropdown(el, {
                            popperConfig: {
                                // default popper config; keep it unless custom positioning needed
                            }
                        });
                    }
                });

                // Navbar scroll hide/show effect
                (function navbarScrollEffect() {
                    let lastScrollTop = 0;
                    const navbar = document.querySelector('.custom-navbar');
                    if (!navbar) return;
                    window.addEventListener('scroll', function() {
                        const scrollTop = window.pageYOffset || document.documentElement.scrollTop;
                        if (scrollTop > lastScrollTop && scrollTop > 100) {
                            // Scrolling down
                            navbar.style.transform = 'translateY(-100%)';
                        } else {
                            // Scrolling up
                            navbar.style.transform = 'translateY(0)';
                        }
                        lastScrollTop = scrollTop <= 0 ? 0 : scrollTop;
                    }, { passive: true });
                })();

                // Close dropdown when clicking a dropdown-item (common UX)
                document.querySelectorAll('.dropdown-item').forEach(item => {
                    item.addEventListener('click', function (e) {
                        // find nearest dropdown parent and hide it
                        const dropdownToggle = this.closest('.dropdown')?.querySelector('[data-bs-toggle="dropdown"]');
                        if (dropdownToggle) {
                            const instance = bootstrap.Dropdown.getInstance(dropdownToggle);
                            if (instance) instance.hide();
                        }
                    });
                });
                
                // Track dropdown events for testing
                const dropdownToggle = document.getElementById('patientDropdown');
                if (dropdownToggle) {
                    dropdownToggle.addEventListener('show.bs.dropdown', function () {
                        document.getElementById('statusText').textContent = 'Dropdown opened';
                        document.getElementById('dropdownStatus').classList.remove('alert-warning');
                        document.getElementById('dropdownStatus').classList.add('alert-success');
                    });
                    
                    dropdownToggle.addEventListener('hide.bs.dropdown', function () {
                        document.getElementById('statusText').textContent = 'Dropdown closed';
                        document.getElementById('dropdownStatus').classList.remove('alert-success');
                        document.getElementById('dropdownStatus').classList.add('alert-warning');
                    });
                }
            });
        }
    </script>
</body>
</html>