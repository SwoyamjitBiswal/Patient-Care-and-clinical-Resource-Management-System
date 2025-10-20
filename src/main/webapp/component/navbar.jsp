<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ page isELIgnored="false" %>

<c:set var="userObj" value="${sessionScope.userObj}" />

<nav class="navbar navbar-expand-lg navbar-light bg-white shadow-sm sticky-top">
    <div class="container-fluid px-4">

        <a class="navbar-brand fw-bold d-flex align-items-center" href="${pageContext.request.contextPath}/index.jsp">
            <i class="fa-solid fa-hospital me-2 text-primary"></i>
            <span class="text-dark">MedCare</span>
        </a>

        <button class="navbar-toggler border-0" type="button" data-bs-toggle="collapse" data-bs-target="#navbarContent"
                aria-controls="navbarContent" aria-expanded="false" aria-label="Toggle navigation">
            <span class="navbar-toggler-icon"></span>
        </button>

        <div class="collapse navbar-collapse" id="navbarContent">
            <ul class="navbar-nav mx-auto align-items-lg-center">
                <li class="nav-item px-2">
                    <a class="nav-link fw-medium text-dark position-relative"
                       href="${pageContext.request.contextPath}/index.jsp">
                        <i class="fa-solid fa-house me-1 fa-fw"></i> Home
                    </a>
                </li>
                <li class="nav-item px-2">
                    <a class="nav-link fw-medium text-dark position-relative" href="#section-header">
                        <i class="fa-solid fa-stethoscope me-1 fa-fw"></i> Services
                    </a>
                </li>
                <li class="nav-item px-2">
                    <a class="nav-link fw-medium text-dark position-relative"
                       href="${pageContext.request.contextPath}/doctors_dashboard.jsp">
                        <i class="fa-solid fa-user-doctor me-1 fa-fw"></i> Doctors
                    </a>
                </li>
                <li class="nav-item px-2">
                    <a class="nav-link fw-medium text-dark position-relative"
                       href="${pageContext.request.contextPath}/patient/book_appointment.jsp">
                        <i class="fa-solid fa-calendar-check me-1 fa-fw"></i> Appointment
                    </a>
                </li>
                <li class="nav-item px-2">
                    <a class="nav-link fw-medium text-dark position-relative"
                       href="${pageContext.request.contextPath}/contact.jsp">
                        <i class="fa-solid fa-phone me-1 fa-fw"></i> Contact
                    </a>
                </li>
            </ul>

            <ul class="navbar-nav ms-auto align-items-lg-center">
                <!-- Guest User -->
                <c:if test="${empty userObj}">
                    <li class="nav-item px-2">
                        <a class="btn btn-primary fw-medium text-white d-flex align-items-center join-btn"
                           href="${pageContext.request.contextPath}/role_selection.jsp">
                            <i class="fa-solid fa-user-plus me-2"></i> Join Now
                        </a>
                    </li>

                    <li class="nav-item dropdown px-2">
                        <a class="nav-link dropdown-toggle fw-medium text-dark d-flex align-items-center position-relative login-dropdown"
                           href="#" id="loginDropdown" role="button" data-bs-toggle="dropdown" aria-expanded="false">
                            <i class="fa-solid fa-right-to-bracket me-2"></i> Login
                        </a>
                        <ul class="dropdown-menu dropdown-menu-end shadow-lg border-0 rounded-3 p-3"
                            aria-labelledby="loginDropdown">
                            <li class="dropdown-header fw-bold text-primary mb-2">Choose Your Role</li>

                            <li>
                                <a class="dropdown-item d-flex align-items-center p-3 rounded-3 mb-2 patient-login"
                                   href="${pageContext.request.contextPath}/patient/patient_login.jsp">
                                    <div class="role-icon bg-primary bg-opacity-10 rounded-circle d-flex align-items-center justify-content-center me-3"
                                         style="width: 40px; height: 40px;">
                                        <i class="fa-solid fa-user-injured fa-fw"></i>
                                    </div>
                                    <div>
                                        <div class="fw-semibold">Patient Login</div>
                                        <small class="text-muted">Access your medical records</small>
                                    </div>
                                </a>
                            </li>

                            <li>
                                <a class="dropdown-item d-flex align-items-center p-3 rounded-3 mb-2 doctor-login"
                                   href="${pageContext.request.contextPath}/doctor/doctor_login.jsp">
                                    <div class="role-icon bg-success bg-opacity-10 rounded-circle d-flex align-items-center justify-content-center me-3"
                                         style="width: 40px; height: 40px;">
                                        <i class="fa-solid fa-user-md fa-fw"></i>
                                    </div>
                                    <div>
                                        <div class="fw-semibold">Doctor Login</div>
                                        <small class="text-muted">Manage patients & appointments</small>
                                    </div>
                                </a>
                            </li>

                            <li>
                                <a class="dropdown-item d-flex align-items-center p-3 rounded-3 admin-login"
                                   href="${pageContext.request.contextPath}/admin/admin_login.jsp">
                                    <div class="role-icon bg-warning bg-opacity-10 rounded-circle d-flex align-items-center justify-content-center me-3"
                                         style="width: 40px; height: 40px;">
                                        <i class="fa-solid fa-user-shield fa-fw"></i>
                                    </div>
                                    <div>
                                        <div class="fw-semibold">Admin Login</div>
                                        <small class="text-muted">System administration</small>
                                    </div>
                                </a>
                            </li>

                            <li>
                                <hr class="dropdown-divider my-3">
                            </li>
                            <li>
                                <a class="dropdown-item text-center text-primary fw-semibold"
                                   href="${pageContext.request.contextPath}/role_selection.jsp">
                                    <i class="fa-solid fa-user-plus me-1 fa-fw"></i> Create New Account
                                </a>
                            </li>
                        </ul>
                    </li>
                </c:if>

                <!-- Logged-in User -->
                <c:if test="${not empty userObj}">
                    <li class="nav-item px-2">
                        <a class="btn btn-outline-primary fw-medium d-flex align-items-center"
                           href="${pageContext.request.contextPath}/user_appointment.jsp">
                            <i class="fa-solid fa-calendar-plus me-2 fa-fw"></i> Book Appointment
                        </a>
                    </li>
                    <li class="nav-item px-2">
                        <a class="nav-link fw-medium text-dark position-relative"
                           href="${pageContext.request.contextPath}/view_appointment.jsp">
                            <i class="fa-solid fa-eye me-1 fa-fw"></i> My Appointments
                        </a>
                    </li>

                    <li class="nav-item dropdown px-2">
                        <a class="nav-link dropdown-toggle fw-medium text-dark d-flex align-items-center position-relative user-dropdown"
                           href="#" id="userDropdown" role="button" data-bs-toggle="dropdown" aria-expanded="false">
                            <div class="user-avatar bg-primary rounded-circle d-flex align-items-center justify-content-center me-2"
                                 style="width: 32px; height: 32px;">
                                <i class="fa-regular fa-user text-white small fa-fw"></i>
                            </div>
                            <span class="user-name">${userObj.fullname}</span>
                        </a>
                        <ul class="dropdown-menu dropdown-menu-end shadow-lg border-0 rounded-3 p-2"
                            aria-labelledby="userDropdown">
                            <li class="dropdown-header p-3">
                                <div class="d-flex align-items-center">
                                    <div class="user-avatar bg-primary rounded-circle d-flex align-items-center justify-content-center me-3"
                                         style="width: 40px; height: 40px;">
                                        <i class="fa-regular fa-user text-white fa-fw"></i>
                                    </div>
                                    <div>
                                        <div class="fw-bold">${userObj.fullname}</div>
                                        <small class="text-muted">Patient</small>
                                    </div>
                                </div>
                            </li>
                            <li>
                                <hr class="dropdown-divider my-2">
                            </li>
                            <li>
                                <a class="dropdown-item d-flex align-items-center text-dark p-2"
                                   href="${pageContext.request.contextPath}/profile.jsp">
                                    <i class="fa-regular fa-user me-2 fa-fw"></i> My Profile
                                </a>
                            </li>
                            <li>
                                <a class="dropdown-item d-flex align-items-center text-dark p-2"
                                   href="${pageContext.request.contextPath}/medical_records.jsp">
                                    <i class="fa-regular fa-file-alt me-2 fa-fw"></i> Medical Records
                                </a>
                            </li>
                            <li>
                                <a class="dropdown-item d-flex align-items-center text-dark p-2"
                                   href="${pageContext.request.contextPath}/prescriptions.jsp">
                                    <i class="fa-solid fa-prescription me-2 fa-fw"></i> Prescriptions
                                </a>
                            </li>
                            <li>
                                <hr class="dropdown-divider my-2">
                            </li>
                            <li>
                                <a class="dropdown-item d-flex align-items-center text-dark p-2"
                                   href="${pageContext.request.contextPath}/change_password.jsp">
                                    <i class="fa-solid fa-key me-2 fa-fw"></i> Change Password
                                </a>
                            </li>
                            <li>
                                <hr class="dropdown-divider my-2">
                            </li>
                            <li>
                                <a class="dropdown-item d-flex align-items-center text-danger p-2"
                                   href="${pageContext.request.contextPath}/userLogout">
                                    <i class="fa-solid fa-right-from-bracket me-2 fa-fw"></i> Logout
                                </a>
                            </li>
                        </ul>
                    </li>
                </c:if>
            </ul>
        </div>
    </div>
</nav>


<!-- Styles remain exactly the same -->
<style>
    /* Modern Light Theme Navbar */
    .navbar {
        padding: 0.6rem 0;
        transition: all 0.3s ease;
        position: fixed;
        top: 0;
        width: 100%;
        z-index: 1030;
        backdrop-filter: blur(10px);
        background: rgba(255, 255, 255, 0.98) !important;
        border-bottom: 1px solid rgba(0, 0, 0, 0.05);
    }


      .navbar-brand {
        font-size: 1.6rem;
        font-weight: 700;
        padding: 0.5rem 0;
      }

      .navbar-brand i {
        font-size: 1.8rem;
      }

      .nav-link {
        font-size: 0.95rem;
        padding: 0.5rem 0.9rem !important;
        transition: all 0.3s ease;
        border-radius: 8px;
        position: relative;
        font-weight: 500;
        margin: 0 0.2rem;
      }

      .nav-link:not(.dropdown-toggle):after {
        content: '';
        position: absolute;
        bottom: 0;
        left: 50%;
        width: 0;
        height: 2px;
        background: #2563eb;
        transition: all 0.3s ease;
        transform: translateX(-50%);
      }

      .nav-link:hover:not(.dropdown-toggle):after,
      .nav-link.active:after {
        width: 70%;
      }

      .nav-link:hover,
      .nav-link:focus {
        color: #2563eb !important;
        transform: translateY(-1px);
      }

      /* Join Now Button */
      .join-btn {
        background: linear-gradient(135deg, #2563eb, #3b82f6);
        color: white !important;
        border-radius: 8px;
        padding: 0.6rem 1.5rem !important;
        box-shadow: 0 4px 6px -1px rgba(37, 99, 235, 0.2);
        transition: all 0.3s ease;
        border: none;
        text-decoration: none;
        display: inline-flex;
        align-items: center;
      }

      .join-btn:hover {
        background: linear-gradient(135deg, #1d4ed8, #2563eb);
        transform: translateY(-2px);
        box-shadow: 0 6px 12px -1px rgba(37, 99, 235, 0.3);
        color: white !important;
      }

      /* Login Dropdown */
      .login-dropdown {
        background: #f8fafc;
        border: 1px solid #e2e8f0;
        border-radius: 8px;
        padding: 0.5rem 1rem !important;
        transition: all 0.3s ease;
      }

      .login-dropdown:hover {
        background: #f1f5f9;
        border-color: #cbd5e1;
      }

      /* Dropdown Menu Styling */
      .dropdown-menu {
        background: white !important;
        border: 1px solid #e2e8f0;
        border-radius: 12px;
        padding: 0.8rem 0;
        min-width: 280px;
        box-shadow: 0 10px 25px -3px rgba(0, 0, 0, 0.1), 0 4px 6px -2px rgba(0, 0, 0, 0.05);
        margin-top: 0.5rem !important;
      }

      .dropdown-header {
        font-size: 0.9rem;
        padding: 0.5rem 1.5rem;
      }

      .dropdown-item {
        transition: all 0.2s ease;
        border-radius: 8px;
        margin: 0.2rem 0.5rem;
        padding: 0.75rem 1rem;
        font-weight: 500;
        border: 1px solid transparent;
        display: flex;
        align-items: center;
      }

      .dropdown-item:hover,
      .dropdown-item:focus {
        background: #f8fafc !important;
        color: #1e293b !important;
        border-color: #e2e8f0;
        transform: translateX(5px);
      }

      /* Role-specific login items */
      .patient-login:hover {
        border-left: 3px solid #2563eb;
      }

      .doctor-login:hover {
        border-left: 3px solid #10b981;
      }

      .admin-login:hover {
        border-left: 3px solid #f59e0b;
      }

      /* User Dropdown */
      .user-dropdown {
        padding: 0.5rem 0.8rem !important;
        border-radius: 8px;
        transition: all 0.3s ease;
      }

      .user-dropdown:hover {
        background: #f8fafc;
      }

      .user-avatar {
        font-size: 0.8rem;
      }

      .user-name {
        max-width: 150px;
        overflow: hidden;
        text-overflow: ellipsis;
        white-space: nowrap;
      }

      /* Role Icons */
      .role-icon {
        transition: all 0.3s ease;
        flex-shrink: 0;
      }

      .role-icon i {
        font-size: 1.1rem;
        width: 1em;
        text-align: center;
      }

      .dropdown-item:hover .role-icon {
        transform: scale(1.1);
      }

      /* Ensure all icons have proper spacing and fixed width */
      .navbar .fa-fw {
        width: 1.25em;
        text-align: center;
      }

      /* Navbar Toggler */
      .navbar-toggler {
        border: none;
        padding: 0.25rem 0.5rem;
        transition: all 0.3s ease;
      }

      .navbar-toggler:focus {
        box-shadow: none;
        background: #f1f5f9;
        border-radius: 6px;
      }

      .navbar-toggler-icon {
        background-image: url("data:image/svg+xml,%3csvg xmlns='http://www.w3.org/2000/svg' viewBox='0 0 30 30'%3e%3cpath stroke='rgba%2837, 99, 235, 1%29' stroke-linecap='round' stroke-miterlimit='10' stroke-width='2' d='M4 7h22M4 15h22M4 23h22'/%3e%3c/svg%3e");
        transition: all 0.3s ease;
      }

      /* Responsive Design */
      @media (max-width: 991px) {
        .navbar-nav {
          text-align: center;
          margin-top: 1rem;
          padding: 1rem 0;
        }

        .nav-item {
          margin: 0.4rem 0;
        }

        .join-btn {
          margin: 0.5rem 0;
          display: inline-flex;
          width: auto;
          justify-content: center;
        }

        .login-dropdown {
          margin: 0.5rem 0;
          display: inline-flex;
          width: auto;
          justify-content: center;
        }

        .dropdown-menu {
          text-align: left;
          border: 1px solid #e2e8f0;
          box-shadow: 0 10px 25px -3px rgba(0, 0, 0, 0.1);
          background: white !important;
          position: static !important;
          margin: 0.5rem auto;
          width: 90%;
        }

        .user-name {
          max-width: 150px;
        }

        .navbar-collapse {
          border-top: 1px solid #e2e8f0;
          margin-top: 0.5rem;
        }
      }

      @media (max-width: 576px) {
        .navbar-brand {
          font-size: 1.4rem;
        }

        .navbar-brand i {
          font-size: 1.6rem;
        }

        .nav-link {
          padding: 0.5rem 0.7rem !important;
          font-size: 0.9rem;
        }

        .join-btn {
          padding: 0.5rem 1.2rem !important;
        }

        .container-fluid {
          padding-left: 1rem;
          padding-right: 1rem;
        }

        .dropdown-menu {
          width: 95%;
          margin: 0.5rem auto;
        }
      }

      /* Animation for dropdown */
      @keyframes fadeInUp {
        from {
          opacity: 0;
          transform: translate3d(0, 10px, 0);
        }

        to {
          opacity: 1;
          transform: translate3d(0, 0, 0);
        }
      }

      .dropdown-menu.show {
        animation: fadeInUp 0.3s ease;
      }


      /* Button styling */
      .btn-outline-primary {
        border-radius: 8px;
        padding: 0.5rem 1.2rem;
        transition: all 0.3s ease;
        display: inline-flex;
        align-items: center;
        text-decoration: none;
      }

      .btn-outline-primary:hover {
        transform: translateY(-1px);
        box-shadow: 0 4px 8px rgba(37, 99, 235, 0.2);
      }
    </style>