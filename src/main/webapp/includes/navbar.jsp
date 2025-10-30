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
            padding: 1rem 0 !important;
            box-shadow: 0 4px 20px rgba(0, 0, 0, 0.08);
            transition: var(--transition);
        }

    .navbar-brand {
        font-weight: 700;
        font-size: 1.5rem;
        color: var(--dark) !important;
        display: flex;
        align-items: center;
        gap: 0.5rem;
        transition: var(--transition);
    }

    .navbar-brand:hover {
        transform: translateY(-1px);
    }

    .navbar-brand i {
        color: var(--primary);
        font-size: 1.75rem;
    }

    .nav-link {
        font-weight: 500;
        color: #414449 !important;
        padding: 0.5rem 1rem !important;
        border-radius: var(--border-radius);
        transition: var(--transition);
        position: relative;
    }

    .nav-link:hover {
        color: var(--primary) !important;
        background: var(--primary-light);
        transform: translateY(-1px);
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
    }

    .navbar-toggler:hover {
        background: var(--primary-light);
    }

    .navbar-toggler:focus {
        box-shadow: none;
    }

    .dropdown-menu {
        border: none;
        border-radius: var(--border-radius);
        box-shadow: var(--shadow-lg);
        padding: 0.5rem;
        margin-top: 0.5rem !important;
        background: white;
        border: 1px solid #f3f4f6;
    }

    .dropdown-item {
        border-radius: 8px;
        padding: 0.75rem 1rem;
        font-weight: 500;
        transition: var(--transition);
        display: flex;
        align-items: center;
        gap: 0.5rem;
    }

    .dropdown-item:hover {
        background: var(--primary-light);
        color: var(--primary);
        transform: translateX(3px);
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
    }

    .btn-primary:hover {
        transform: translateY(-2px);
        box-shadow: 0 7px 14px rgba(79, 70, 229, 0.25);
    }

    .nav-user-icon {
        font-size: 1.75rem;
        color: var(--primary);
        transition: var(--transition);
    }

    .user-avatar {
        width: 36px;
        height: 36px;
        border-radius: 50%;
        background: linear-gradient(135deg, var(--primary), #6366f1);
        display: flex;
        align-items: center;
        justify-content: center;
        color: white;
        font-size: 1rem;
        margin-right: 0.5rem;
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
            margin: 0.125rem 0;
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
    
    
</style>

<nav class="navbar navbar-expand-lg navbar-light sticky-top">
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
                    if (session.getAttribute("patientObj") != null) {
                        currentUserRole = "patient";
                    } else if (session.getAttribute("doctorObj") != null) {
                        currentUserRole = "doctor";
                    } else if (session.getAttribute("adminObj") != null) {
                        currentUserRole = "admin";
                    }
                %>

                <% if (currentUserRole.isEmpty()) { %>
                <!-- Public Navigation -->
                <li class="nav-item">
                    <a class="nav-link" href="${pageContext.request.contextPath}/index.jsp">Home</a>
                </li>
                <li class="nav-item">
                    <a class="nav-link" href="${pageContext.request.contextPath}/about.jsp">About</a>
                </li>
                <li class="nav-item">
                    <a class="nav-link" href="${pageContext.request.contextPath}/contact.jsp">Contact</a>
                </li>

                <li class="nav-item dropdown ms-lg-2">
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

                <li class="nav-item ms-lg-2">
                    <a class="btn btn-primary"
                        href="${pageContext.request.contextPath}/patient/register.jsp">
                        <i class="fas fa-user-plus me-2"></i>Get Started
                    </a>
                </li>

                <% } else { %>
                <!-- Authenticated User Navigation -->
                <li class="nav-item">
                    <a class="nav-link" href="${pageContext.request.contextPath}/<%= currentUserRole %>/dashboard.jsp">
                        <i class="fas fa-tachometer-alt me-1"></i>Dashboard
                    </a>
                </li>
                <li class="nav-item">
                    <a class="nav-link" href="${pageContext.request.contextPath}/<%= currentUserRole %>/profile">
                        <i class="fas fa-user me-1"></i>Profile
                    </a>
                </li>

                <li class="nav-item dropdown ms-lg-2">
                    <a class="nav-link dropdown-toggle d-flex align-items-center" href="#" id="userDropdown"
                        role="button" data-bs-toggle="dropdown" aria-expanded="false">
                        <div class="user-avatar">
                            <i class="fas fa-user"></i>
                        </div>
                        <div class="d-none d-lg-flex flex-column align-items-start">
                            <span class="fw-semibold">
                                <%= currentUserRole.substring(0, 1).toUpperCase() + currentUserRole.substring(1) %>
                            </span>
                            <small class="text-muted">My Account</small>
                        </div>
                    </a>
                    <ul class="dropdown-menu dropdown-menu-end" aria-labelledby="userDropdown">
                        <li>
                            <a class="dropdown-item" href="${pageContext.request.contextPath}/<%= currentUserRole %>/profile">
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

<script src="https://cdn.jsdelivr.net/npm/@popperjs/core@2.11.8/dist/umd/popper.min.js"
    integrity="sha384-oBqDVmMz9ATKxIep9tiCxS/Z9fNfEXiDAYTujMAeBAsjFuCZSmKbSSUnQlmh/jp3"
    crossorigin="anonymous"></script>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.min.js"
    integrity="sha384-QFJH/2I/Ri7Z27vnOvwf1C/JfWrPytX5T6Gij8axWQzCwoDchzAhWutZAbc8K7wA"
    crossorigin="anonymous"></script>

<script>
    // Add active class to current page link
    document.addEventListener('DOMContentLoaded', function() {
        const currentLocation = window.location.pathname;
        const navLinks = document.querySelectorAll('.nav-link');
        
        navLinks.forEach(link => {
            if (link.getAttribute('href') === currentLocation) {
                link.classList.add('active');
            }
        });

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

        // Navbar background on scroll
        window.addEventListener('scroll', function() {
            const navbar = document.querySelector('.navbar');
            if (window.scrollY > 50) {
                navbar.style.background = 'rgba(255, 255, 255, 0.95)';
                navbar.style.backdropFilter = 'blur(20px)';
            } else {
                navbar.style.background = 'linear-gradient(135deg, #ffffff, #f8fafc)';
                navbar.style.backdropFilter = 'blur(10px)';
            }
        });
    });
</script>