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
        --light: #f9fafb;
        --transition: all 0.3s ease;
        --border-radius: 12px;
        --shadow: 0 4px 6px -1px rgba(0, 0, 0, 0.1), 0 2px 4px -1px rgba(0, 0, 0, 0.06);
        --shadow-lg: 0 10px 15px -3px rgba(0, 0, 0, 0.1), 0 4px 6px -2px rgba(0, 0, 0, 0.05);
    }

    .navbar {
        background: linear-gradient(135deg, #ffffff 0%, #f8fafc 100%) !important;
        backdrop-filter: blur(20px);
        border-bottom: 1px solid rgba(229, 231, 235, 0.8);
        padding: 0.5rem 0 !important;
        box-shadow: 0 4px 20px rgba(0, 0, 0, 0.08);
        transition: var(--transition);
        position: sticky;
        top: 0;
        z-index: 1030;
    }

    .navbar-brand {
        font-weight: 700;
        font-size: 1.5rem;
        color: var(--dark) !important;
        display: flex;
        align-items: center;
        gap: 0.5rem;
        transition: var(--transition);
        text-decoration: none;
    }

    .navbar-brand:hover {
        transform: translateY(-1px);
        color: var(--primary) !important;
    }

    .navbar-brand i {
        color: var(--primary);
        font-size: 1.75rem;
        transition: var(--transition);
    }

    .navbar-brand:hover i {
        transform: scale(1.1);
    }

    .nav-link {
        font-weight: 500;
        color: #6b7280 !important;
        padding: 0.75rem 1.25rem !important;
        border-radius: var(--border-radius);
        transition: var(--transition);
        position: relative;
        text-decoration: none;
        margin: 0.125rem 0.25rem;
    }

    .nav-link:hover {
        color: var(--primary) !important;
        background: var(--primary-light);
        transform: translateY(-1px);
        box-shadow: var(--shadow);
    }

    .nav-link.active {
        color: var(--primary) !important;
        background: var(--primary-light);
        font-weight: 600;
    }

    .navbar-toggler {
        border: none;
        padding: 0.5rem;
        border-radius: var(--border-radius);
        transition: var(--transition);
        background: transparent;
    }

    .navbar-toggler:hover {
        background: var(--primary-light);
    }

    .navbar-toggler:focus {
        box-shadow: none;
        background: var(--primary-light);
    }

    .navbar-toggler-icon {
        background-image: url("data:image/svg+xml,%3csvg xmlns='http://www.w3.org/2000/svg' viewBox='0 0 30 30'%3e%3cpath stroke='rgba%2879, 70, 229, 0.8%29' stroke-linecap='round' stroke-miterlimit='10' stroke-width='2' d='M4 7h22M4 15h22M4 23h22'/%3e%3c/svg%3e");
        width: 1.25em;
        height: 1.25em;
    }

    .dropdown-menu {
        border: none;
        border-radius: var(--border-radius);
        box-shadow: var(--shadow-lg);
        padding: 0.5rem;
        margin-top: 0.5rem !important;
        background: white;
        border: 1px solid #f3f4f6;
        min-width: 200px;
    }

    .dropdown-item {
        border-radius: 8px;
        padding: 0.75rem 1rem;
        font-weight: 500;
        transition: var(--transition);
        display: flex;
        align-items: center;
        gap: 0.5rem;
        color: #6b7280;
        text-decoration: none;
    }

    .dropdown-item:hover {
        background: var(--primary-light);
        color: var(--primary);
        transform: translateX(3px);
    }

    .dropdown-item.text-danger {
        color: var(--danger) !important;
    }

    .dropdown-item.text-danger:hover {
        background: var(--danger-light);
        color: var(--danger) !important;
    }

    .dropdown-divider {
        margin: 0.5rem 0;
        opacity: 0.3;
    }

    .btn-primary {
        background: linear-gradient(135deg, var(--primary), var(--primary-dark));
        border: none;
        border-radius: 50px;
        font-weight: 600;
        padding: 0.625rem 1.5rem;
        transition: var(--transition);
        text-decoration: none;
        display: inline-flex;
        align-items: center;
        gap: 0.5rem;
    }

    .btn-primary:hover {
        transform: translateY(-2px);
        box-shadow: 0 7px 14px rgba(79, 70, 229, 0.25);
        color: white;
    }

    .user-avatar {
        width: 40px;
        height: 40px;
        border-radius: 50%;
        background: linear-gradient(135deg, var(--primary), #6366f1);
        display: flex;
        align-items: center;
        justify-content: center;
        color: white;
        font-size: 1rem;
        font-weight: 600;
        margin-right: 0.5rem;
        transition: var(--transition);
    }

    .user-avatar:hover {
        transform: scale(1.05);
    }

    /* Mobile responsiveness */
    @media (max-width: 991.98px) {
        .navbar-collapse {
            margin-top: 1rem;
            padding: 1rem;
            background: white;
            border-radius: var(--border-radius);
            box-shadow: var(--shadow-lg);
            border: 1px solid #e5e7eb;
        }

        .nav-link {
            padding: 0.75rem 1rem !important;
            margin: 0.25rem 0;
        }

        .dropdown-menu {
            border: none;
            box-shadow: none;
            margin: 0.5rem 0 !important;
            background: var(--light);
        }

        .btn-primary {
            width: 100%;
            margin-top: 0.5rem;
            justify-content: center;
        }

        .navbar-nav {
            gap: 0.5rem;
        }
    }

    /* Animation for dropdown */
    @keyframes slideDown {
        from {
            opacity: 0;
            transform: translateY(-10px);
        }
        to {
            opacity: 1;
            transform: translateY(0);
        }
    }

    .dropdown-menu {
        animation: slideDown 0.2s ease-out;
    }

    /* Badge for user role */
    .user-role-badge {
        background: var(--primary-light);
        color: var(--primary);
        padding: 0.25rem 0.75rem;
        border-radius: 50px;
        font-size: 0.75rem;
        font-weight: 600;
        margin-left: 0.5rem;
    }

    /* Login dropdown specific styles */
    .login-dropdown .dropdown-item i {
        width: 20px;
        text-align: center;
    }

    .patient-login { color: var(--primary); }
    .doctor-login { color: var(--success); }
    .admin-login { color: var(--warning); }

    /* User info styles */
    .user-info {
        display: flex;
        flex-direction: column;
        align-items: flex-start;
        line-height: 1.2;
    }

    .user-name {
        font-weight: 600;
        font-size: 0.9rem;
        color: var(--dark);
    }

    .user-role {
        font-size: 0.75rem;
        color: var(--secondary);
    }

    /* Fix for dropdown toggle arrow */
    .dropdown-toggle::after {
        transition: var(--transition);
    }

    .dropdown-toggle.show::after {
        transform: rotate(180deg);
    }

    /* Navbar scroll effect */
    .navbar-scrolled {
        background: rgba(255, 255, 255, 0.95) !important;
        backdrop-filter: blur(20px);
        box-shadow: 0 4px 20px rgba(0, 0, 0, 0.1);
    }
</style>

<nav class="navbar navbar-expand-lg navbar-light">
    <div class="container">
        <a class="navbar-brand" href="${pageContext.request.contextPath}/index.jsp">
            <i class="fas fa-heartbeat"></i>   
            <span>PatientCare</span>
        </a>

        <button class="navbar-toggler" type="button" data-bs-toggle="collapse"
            data-bs-target="#navbarNav" aria-controls="navbarNav" aria-expanded="false"
            aria-label="Toggle navigation">
            <span class="navbar-toggler-icon"></span>
        </button>

        <div class="collapse navbar-collapse" id="navbarNav">
            <ul class="navbar-nav ms-auto align-items-lg-center">
                <%
                    String currentUserRole = "";
                    String currentUserName = "";
                    
                    if (session.getAttribute("patientObj") != null) {
                        currentUserRole = "patient";
                        Object patientObj = session.getAttribute("patientObj");
                        if (patientObj != null) {
                            try {
                                currentUserName = (String) patientObj.getClass().getMethod("getFullName").invoke(patientObj);
                            } catch (Exception e) {
                                currentUserName = "Patient";
                            }
                        }
                    } else if (session.getAttribute("doctorObj") != null) {
                        currentUserRole = "doctor";
                        Object doctorObj = session.getAttribute("doctorObj");
                        if (doctorObj != null) {
                            try {
                                currentUserName = (String) doctorObj.getClass().getMethod("getFullName").invoke(doctorObj);
                            } catch (Exception e) {
                                currentUserName = "Doctor";
                            }
                        }
                    } else if (session.getAttribute("adminObj") != null) {
                        currentUserRole = "admin";
                        Object adminObj = session.getAttribute("adminObj");
                        if (adminObj != null) {
                            try {
                                currentUserName = (String) adminObj.getClass().getMethod("getFullName").invoke(adminObj);
                            } catch (Exception e) {
                                currentUserName = "Administrator";
                            }
                        }
                    }
                %>

                <% if (currentUserRole.isEmpty()) { %>
                <li class="nav-item">
                    <a class="nav-link" href="${pageContext.request.contextPath}/index.jsp">
                        <i class="fas fa-home me-1"></i>Home
                    </a>
                </li>
                <li class="nav-item">
                    <a class="nav-link" href="${pageContext.request.contextPath}/about.jsp">
                        <i class="fas fa-info-circle me-1"></i>About
                    </a>
                </li>
                <li class="nav-item">
                    <a class="nav-link" href="${pageContext.request.contextPath}/contact.jsp">
                        <i class="fas fa-envelope me-1"></i>Contact
                    </a>
                </li>

                <li class="nav-item dropdown">
                    <a class="nav-link dropdown-toggle d-flex align-items-center" href="#" id="loginDropdown"
                        role="button" data-bs-toggle="dropdown" aria-expanded="false">
                        <i class="fas fa-sign-in-alt me-2"></i>
                        <span>Login</span>
                    </a>
                    <ul class="dropdown-menu dropdown-menu-end login-dropdown" aria-labelledby="loginDropdown">
                        <li>
                            <a class="dropdown-item" href="${pageContext.request.contextPath}/patient/login.jsp">
                                <i class="fas fa-user patient-login me-2"></i>Patient Login
                            </a>
                        </li>
                        <li><hr class="dropdown-divider"></li>
                        <li>
                            <a class="dropdown-item" href="${pageContext.request.contextPath}/doctor/login.jsp">
                                <i class="fas fa-user-md doctor-login me-2"></i>Doctor Login
                            </a>
                        </li>
                        <li><hr class="dropdown-divider"></li>
                        <li>
                            <a class="dropdown-item" href="${pageContext.request.contextPath}/admin/login.jsp">
                                <i class="fas fa-cogs admin-login me-2"></i>Admin Login
                            </a>
                        </li>
                    </ul>
                </li>

                <li class="nav-item">
                    <a class="btn btn-primary"
                        href="${pageContext.request.contextPath}/patient/register.jsp">
                        <i class="fas fa-user-plus me-2"></i>Get Started
                    </a>
                </li>

                <% } else { %>
                <li class="nav-item">
                    <a class="nav-link" href="${pageContext.request.contextPath}/<%= currentUserRole %>/dashboard.jsp">
                        <i class="fas fa-tachometer-alt me-1"></i>Dashboard
                    </a>
                </li>
                
                <% if ("patient".equals(currentUserRole)) { %>
                <li class="nav-item">
                    <%-- --- START: FIX --- --%>
                    <a class="nav-link" href="${pageContext.request.contextPath}/patient/appointment?action=view">
                    <%-- --- END: FIX --- --%>
                        <i class="fas fa-calendar-alt me-1"></i>Appointments
                    </a>
                </li>
                <% } else if ("doctor".equals(currentUserRole)) { %>
                <li class="nav-item">
                    <%-- --- START: FIX --- --%>
                    <a class="nav-link" href="${pageContext.request.contextPath}/doctor/appointment?action=view">
                    <%-- --- END: FIX --- --%>
                        <i class="fas fa-calendar-check me-1"></i>My Appointments
                    </a>
                </li>
                <% } else if ("admin".equals(currentUserRole)) { %>
                <li class="nav-item dropdown">
                    <a class="nav-link dropdown-toggle" href="#" id="managementDropdown" role="button" 
                       data-bs-toggle="dropdown" aria-expanded="false">
                        <i class="fas fa-cog me-1"></i>Management
                    </a>
                    <ul class="dropdown-menu" aria-labelledby="managementDropdown">
                        <li>
                            <a class="dropdown-item" href="${pageContext.request.contextPath}/admin/management?action=view&type=doctors">
                                <i class="fas fa-user-md me-2"></i>Manage Doctors
                            </a>
                        </li>
                        <li>
                            <a class="dropdown-item" href="${pageContext.request.contextPath}/admin/management?action=view&type=patients">
                                <i class="fas fa-users me-2"></i>Manage Patients
                            </a>
                        </li>
                        <li>
                            <%-- This link was already correct --%>
                            <a class="dropdown-item" href="${pageContext.request.contextPath}/admin/management?action=view&type=appointments">
                                <i class="fas fa-calendar-alt me-2"></i>Manage Appointments
                            </a>
                        </li>
                    </ul>
                </li>
                <% } %>

                <li class="nav-item">
                    <a class="nav-link" href="${pageContext.request.contextPath}/<%= currentUserRole %>/profile.jsp">
                        <i class="fas fa-user me-1"></i>Profile
                    </a>
                </li>

                <li class="nav-item dropdown">
                    <a class="nav-link dropdown-toggle d-flex align-items-center" href="#" id="userDropdown"
                        role="button" data-bs-toggle="dropdown" aria-expanded="false">
                        <div class="user-avatar">
                            <%= currentUserName.substring(0, 1).toUpperCase() %>
                        </div>
                        <div class="user-info d-none d-lg-block">
                            <span class="user-name"><%= currentUserName %></span>
                            <span class="user-role"><%= currentUserRole.substring(0, 1).toUpperCase() + currentUserRole.substring(1) %></span>
                        </div>
                    </a>
                    <ul class="dropdown-menu dropdown-menu-end" aria-labelledby="userDropdown">
                        <li>
                            <a class="dropdown-item" href="${pageContext.request.contextPath}/<%= currentUserRole %>/profile.jsp">
                                <i class="fas fa-user me-2 text-primary"></i>My Profile
                            </a>
                        </li>
                        <li>
                            <a class="dropdown-item" href="${pageContext.request.contextPath}/<%= currentUserRole %>/dashboard.jsp">
                                <i class="fas fa-tachometer-alt me-2 text-info"></i>Dashboard
                            </a>
                        </li>
                        <li><hr class="dropdown-divider"></li>
                        <li>
                            <a class="dropdown-item text-danger" href="${pageContext.request.contextPath}/<%= currentUserRole %>/auth?action=logout">
                                <i class="fas fa-sign-out-alt me-2"></i>Logout
                            </a>
                        </li>
                    </ul>
                </li>
                <% } %>
            </ul>
        </div>
    </div>
</nav>


<script>
    // Add active class to current page link
    document.addEventListener('DOMContentLoaded', function() {
        const currentLocation = window.location.pathname + window.location.search;
        const navLinks = document.querySelectorAll('.nav-link, .dropdown-item');
        
        let bestMatch = null;
        
        navLinks.forEach(link => {
            const linkHref = link.getAttribute('href');
            if (!linkHref || linkHref === '#') return;
            
            // Create a URL object to easily get the pathname and search
            let linkPath;
            try {
                linkPath = new URL(link.href).pathname + new URL(link.href).search;
            } catch (e) {
                return; // Invalid URL
            }

            // Exact match
            if (linkPath === currentLocation) {
                bestMatch = link;
            }
            
            // Partial match for dashboard/profile, etc.
            if (currentLocation.startsWith(linkPath) && linkPath.length > (bestMatch ? bestMatch.getAttribute('href').length : 0)) {
                 // Check if it's not just the root
                if(linkPath !== "${pageContext.request.contextPath}/") {
                    bestMatch = link;
                }
            }
        });
        
        // Handle special case for index.jsp
        if (currentLocation === "${pageContext.request.contextPath}/" || currentLocation === "${pageContext.request.contextPath}/index.jsp") {
             document.querySelector('a[href$="index.jsp"]').classList.add('active');
        }

        if (bestMatch) {
            bestMatch.classList.add('active');
            // If it's a dropdown item, also activate the parent nav-link
            const parentDropdown = bestMatch.closest('.dropdown');
            if (parentDropdown) {
                parentDropdown.querySelector('.nav-link.dropdown-toggle').classList.add('active');
            }
        }

        // Navbar background on scroll
        window.addEventListener('scroll', function() {
            const navbar = document.querySelector('.navbar');
            if (navbar) { // Check if navbar exists
                if (window.scrollY > 10) {
                    navbar.classList.add('navbar-scrolled');
                } else {
                    navbar.classList.remove('navbar-scrolled');
                }
            }
        });

        // Initialize scroll effect on page load
        if (window.scrollY > 10) {
            const navbar = document.querySelector('.navbar');
            if (navbar) {
                navbar.classList.add('navbar-scrolled');
            }
        }

        // Close mobile menu when clicking on a link
        const navLinksMobile = document.querySelectorAll('.nav-link, .dropdown-item');
        const navbarCollapse = document.querySelector('.navbar-collapse');
        
        if (navbarCollapse) {
            navLinksMobile.forEach(link => {
                link.addEventListener('click', () => {
                    if (window.innerWidth < 992) {
                        const bsCollapse = bootstrap.Collapse.getInstance(navbarCollapse);
                        if (bsCollapse && navbarCollapse.classList.contains('show')) {
                            bsCollapse.hide();
                        }
                    }
                });
            });
        }

        // Smooth scrolling for anchor links
        document.querySelectorAll('a[href^="#"]').forEach(anchor => {
            anchor.addEventListener('click', function (e) {
                e.preventDefault();
                const target = document.querySelector(this.getAttribute('href'));
                if (target) {
                    target.scrollIntoView({
                        behavior: 'smooth',
                        block: 'start'
                    });
                }
            });
        });

        // Handle dropdown animations
        const dropdownToggles = document.querySelectorAll('.dropdown-toggle');
        dropdownToggles.forEach(toggle => {
            toggle.addEventListener('show.bs.dropdown', function () {
                this.classList.add('show');
            });
            
            toggle.addEventListener('hide.bs.dropdown', function () {
                this.classList.remove('show');
            });
        });
    });
</script>