<%@ page import="com.entity.Admin" %>
<%@ page import="java.text.SimpleDateFormat" %>
<%
    Admin currentAdmin = (Admin) session.getAttribute("adminObj");
    if (currentAdmin == null) {
        response.sendRedirect(request.getContextPath() + "/admin/login.jsp");
        return;
    }
    String currentUserRole = "admin";
    
    SimpleDateFormat dateFormat = new SimpleDateFormat("yyyy-MM-dd");
    String memberSince = "N/A";
    if (currentAdmin.getCreatedAt() != null) {
        memberSince = dateFormat.format(currentAdmin.getCreatedAt());
    }
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Patient Care System - Admin Profile</title>

    <!-- Bootstrap 5 CSS -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" rel="stylesheet">
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
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
                        <a class="nav-link" href="${pageContext.request.contextPath}/admin/dashboard.jsp">
                            <i class="fas fa-tachometer-alt"></i>
                            <span>Dashboard</span>
                        </a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link active" href="${pageContext.request.contextPath}/admin/profile.jsp">
                            <i class="fas fa-user"></i>
                            <span>My Profile</span>
                        </a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link" href="${pageContext.request.contextPath}/admin/management?action=view&type=doctors">
                            <i class="fas fa-user-md"></i>
                            <span>Manage Doctors</span>
                        </a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link" href="${pageContext.request.contextPath}/admin/management?action=view&type=patients">
                            <i class="fas fa-users"></i>
                            <span>Manage Patients</span>
                        </a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link" href="${pageContext.request.contextPath}/admin/management?action=view&type=appointments">
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
    
    <main class="main-content main-content-flush">
        <div class="profile-header">
            <div class="page-header">
                <div>
                    <h1 class="h2 mb-2">
                        <i class="fas fa-user-shield me-2"></i>
                        Admin Profile
                    </h1>
                    <p class="mb-0 opacity-75">Manage your account settings and security preferences</p>
                </div>
                <div>
                    <a href="${pageContext.request.contextPath}/admin/dashboard.jsp" class="back-link">
                        <i class="fas fa-arrow-left me-2"></i>Back to Dashboard
                    </a>
                </div>
            </div>
        </div>

        <div class="main-content-dashboard">
            <%-- Success/Error Messages --%>
            <%
                String successMsg = (String) request.getAttribute("successMsg");
                String errorMsg = (String) request.getAttribute("errorMsg");

                if (successMsg != null) {
            %>
                <div class="alert alert-success alert-modern alert-dismissible fade show mb-4" role="alert">
                    <div class="d-flex align-items-center">
                        <i class="fas fa-check-circle me-3 fs-5"></i>
                        <div class="flex-grow-1"><%= successMsg %></div>
                    </div>
                    <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
                </div>
            <%
                }
                if (errorMsg != null) {
            %>
                <div class="alert alert-danger alert-modern alert-dismissible fade show mb-4" role="alert">
                    <div class="d-flex align-items-center">
                        <i class="fas fa-exclamation-triangle me-3 fs-5"></i>
                        <div class="flex-grow-1"><%= errorMsg %></div>
                    </div>
                    <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
                </div>
            <%
                }
            %>

            <div class="row">
                <div class="col-lg-6 mb-4">
                    <div class="card card-modern h-100">
                        <div class="card-header-modern">
                            <i class="fas fa-user-shield"></i>
                            <span>Admin Information</span>
                        </div>
                        <div class="card-body">
                            <div class="text-center mb-4">
                                <div class="icon-box icon-primary mx-auto mb-3">
                                    <i class="fas fa-user-shield"></i>
                                </div>
                                <h4 class="mb-2"><%= currentAdmin.getFullName() %></h4>
                                <p class="text-muted mb-0">System Administrator</p>
                            </div>

                            <div class="profile-info-list">
                                <div class="profile-info-item">
                                    <span class="info-label">
                                        <i class="fas fa-envelope text-primary"></i>
                                        Email Address
                                    </span>
                                    <span class="info-value"><%= currentAdmin.getEmail() %></span>
                                </div>
                                <div class="profile-info-item">
                                    <span class="info-label">
                                        <i class="fas fa-calendar text-primary"></i>
                                        Member Since
                                    </span>
                                    <span class="info-value"><%= memberSince %></span>
                                </div>
                                <div class="profile-info-item">
                                    <span class="info-label">
                                        <i class="fas fa-key text-primary"></i>
                                        Last Password Change
                                    </span>
                                    <span class="info-value">Never</span>
                                </div>
                                <div class="profile-info-item">
                                    <span class="info-label">
                                        <i class="fas fa-shield-alt text-primary"></i>
                                        Account Status
                                    </span>
                                    <span class="badge badge-success">Active</span>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>

                <div class="col-lg-6">
                    <div class="card card-modern mb-4">
                        <div class="card-header-modern">
                            <i class="fas fa-key"></i>
                            <span>Change Password</span>
                        </div>
                        <div class="card-body">
                            <form action="${pageContext.request.contextPath}/admin/profile?action=changePassword" method="post" class="needs-validation" novalidate id="passwordForm">
                                <div class="mb-3">
                                    <label for="currentPassword" class="form-label">Current Password</label>
                                    <div class="input-group">
                                        <span class="input-group-text">
                                            <i class="fas fa-lock"></i>
                                        </span>
                                        <input type="password" class="form-control" id="currentPassword" name="currentPassword" required>
                                        <button type="button" class="password-toggle" id="toggleCurrentPassword">
                                            <i class="fas fa-eye"></i>
                                        </button>
                                    </div>
                                    <div class="invalid-feedback">Please enter your current password.</div>
                                </div>

                                <div class="mb-3">
                                    <label for="newPassword" class="form-label">New Password</label>
                                    <div class="input-group">
                                        <span class="input-group-text">
                                            <i class="fas fa-key"></i>
                                        </span>
                                        <input type="password" class="form-control" id="newPassword" name="newPassword" required minlength="8">
                                        <button type="button" class="password-toggle" id="toggleNewPassword">
                                            <i class="fas fa-eye"></i>
                                        </button>
                                    </div>
                                    <div class="password-strength-meter mt-2">
                                        <div class="password-strength-meter-fill" id="passwordStrength"></div>
                                    </div>
                                    <div class="password-requirements mt-3">
                                        <small class="text-muted d-block mb-2">Password must contain:</small>
                                        <div class="requirement-item">
                                            <span class="requirement-icon" id="lengthIcon"><i class="fas fa-times"></i></span>
                                            <span id="lengthText">At least 8 characters</span>
                                        </div>
                                        <div class="requirement-item">
                                            <span class="requirement-icon" id="uppercaseIcon"><i class="fas fa-times"></i></span>
                                            <span id="uppercaseText">One uppercase letter</span>
                                        </div>
                                        <div class="requirement-item">
                                            <span class="requirement-icon" id="lowercaseIcon"><i class="fas fa-times"></i></span>
                                            <span id="lowercaseText">One lowercase letter</span>
                                        </div>
                                        <div class="requirement-item">
                                            <span class="requirement-icon" id="numberIcon"><i class="fas fa-times"></i></span>
                                            <span id="numberText">One number</span>
                                        </div>
                                        <div class="requirement-item">
                                            <span class="requirement-icon" id="specialIcon"><i class="fas fa-times"></i></span>
                                            <span id="specialText">One special character</span>
                                        </div>
                                    </div>
                                    <div class="invalid-feedback">Password does not meet requirements.</div>
                                </div>

                                <div class="mb-3">
                                    <label for="confirmPassword" class="form-label">Confirm New Password</label>
                                    <div class="input-group">
                                        <span class="input-group-text">
                                            <i class="fas fa-key"></i>
                                        </span>
                                        <input type="password" class="form-control" id="confirmPassword" name="confirmPassword" required minlength="8">
                                        <button type="button" class="password-toggle" id="toggleConfirmPassword">
                                            <i class="fas fa-eye"></i>
                                        </button>
                                    </div>
                                    <div class="invalid-feedback" id="confirmPasswordFeedback">Passwords do not match.</div>
                                </div>

                                <div class="d-grid">
                                    <button type="submit" class="btn btn-primary-modern" id="submitButton" disabled>
                                        <i class="fas fa-save me-2"></i>Update Password
                                    </button>
                                </div>
                            </form>
                        </div>
                    </div>

                    <div class="card card-modern">
                        <div class="card-header-modern">
                            <i class="fas fa-shield-alt"></i>
                            <span>Security Tips</span>
                        </div>
                        <div class="card-body">
                            <ul class="security-tips">
                                <li>
                                    <i class="fas fa-check"></i>
                                    <span>Use a strong, unique password</span>
                                </li>
                                <li>
                                    <i class="fas fa-check"></i>
                                    <span>Change password regularly</span>
                                </li>
                                <li>
                                    <i class="fas fa-check"></i>
                                    <span>Never share your credentials</span>
                                </li>
                                <li>
                                    <i class="fas fa-check"></i>
                                    <span>Log out when not using the system</span>
                                </li>
                            </ul>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </main>

    <!-- Bootstrap 5 JS -->
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    
    <script>
        document.addEventListener('DOMContentLoaded', function() {
            // Mobile menu toggle
            const mobileMenuToggle = document.getElementById('mobileMenuToggle');
            const sidebar = document.getElementById('sidebar');
            
            if (mobileMenuToggle && sidebar) {
                mobileMenuToggle.addEventListener('click', function() {
                    sidebar.classList.toggle('mobile-open');
                });
            }

            // Auto-hide alerts
            const alerts = document.querySelectorAll('.alert');
            alerts.forEach(alert => {
                setTimeout(() => {
                    if (alert && alert.classList.contains('show')) {
                        const bsAlert = new bootstrap.Alert(alert);
                        bsAlert.close();
                    }
                }, 5000);
            });
            
            // Password toggle functionality
            const toggleCurrentPassword = document.getElementById('toggleCurrentPassword');
            const toggleNewPassword = document.getElementById('toggleNewPassword');
            const toggleConfirmPassword = document.getElementById('toggleConfirmPassword');
            const currentPassword = document.getElementById('currentPassword');
            const newPassword = document.getElementById('newPassword');
            const confirmPassword = document.getElementById('confirmPassword');
            
            function togglePasswordVisibility(input, toggleButton) {
                if (input.type === 'password') {
                    input.type = 'text';
                    toggleButton.innerHTML = '<i class="fas fa-eye-slash"></i>';
                } else {
                    input.type = 'password';
                    toggleButton.innerHTML = '<i class="fas fa-eye"></i>';
                }
            }
            
            if (toggleCurrentPassword) {
                toggleCurrentPassword.addEventListener('click', function() {
                    togglePasswordVisibility(currentPassword, toggleCurrentPassword);
                });
            }
            
            if (toggleNewPassword) {
                toggleNewPassword.addEventListener('click', function() {
                    togglePasswordVisibility(newPassword, toggleNewPassword);
                });
            }
            
            if (toggleConfirmPassword) {
                toggleConfirmPassword.addEventListener('click', function() {
                    togglePasswordVisibility(confirmPassword, toggleConfirmPassword);
                });
            }
            
            // Password strength validation
            const passwordStrength = document.getElementById('passwordStrength');
            const lengthIcon = document.getElementById('lengthIcon');
            const uppercaseIcon = document.getElementById('uppercaseIcon');
            const lowercaseIcon = document.getElementById('lowercaseIcon');
            const numberIcon = document.getElementById('numberIcon');
            const specialIcon = document.getElementById('specialIcon');
            const lengthText = document.getElementById('lengthText');
            const uppercaseText = document.getElementById('uppercaseText');
            const lowercaseText = document.getElementById('lowercaseText');
            const numberText = document.getElementById('numberText');
            const specialText = document.getElementById('specialText');
            const submitButton = document.getElementById('submitButton');
            
            function checkPasswordStrength(password) {
                let strength = 0;
                let requirements = {
                    length: false,
                    uppercase: false,
                    lowercase: false,
                    number: false,
                    special: false
                };
                
                // Check length
                if (password.length >= 8) {
                    strength += 20;
                    requirements.length = true;
                }
                
                // Check uppercase
                if (/[A-Z]/.test(password)) {
                    strength += 20;
                    requirements.uppercase = true;
                }
                
                // Check lowercase
                if (/[a-z]/.test(password)) {
                    strength += 20;
                    requirements.lowercase = true;
                }
                
                // Check numbers
                if (/[0-9]/.test(password)) {
                    strength += 20;
                    requirements.number = true;
                }
                
                // Check special characters
                if (/[^A-Za-z0-9]/.test(password)) {
                    strength += 20;
                    requirements.special = true;
                }
                
                return { strength, requirements };
            }
            
            function updatePasswordRequirements(requirements) {
                // Update icons and text colors
                updateRequirement(lengthIcon, lengthText, requirements.length);
                updateRequirement(uppercaseIcon, uppercaseText, requirements.uppercase);
                updateRequirement(lowercaseIcon, lowercaseText, requirements.lowercase);
                updateRequirement(numberIcon, numberText, requirements.number);
                updateRequirement(specialIcon, specialText, requirements.special);
                
                // Enable/disable submit button based on all requirements
                const allMet = Object.values(requirements).every(Boolean);
                submitButton.disabled = !allMet;
            }
            
            function updateRequirement(icon, text, met) {
                if (met) {
                    icon.innerHTML = '<i class="fas fa-check"></i>';
                    icon.className = 'requirement-icon requirement-met';
                    text.className = 'requirement-met';
                } else {
                    icon.innerHTML = '<i class="fas fa-times"></i>';
                    icon.className = 'requirement-icon requirement-unmet';
                    text.className = 'requirement-unmet';
                }
            }
            
            function updatePasswordStrength(strength) {
                passwordStrength.className = 'password-strength-meter-fill';
                
                if (strength <= 25) {
                    passwordStrength.classList.add('strength-weak');
                } else if (strength <= 50) {
                    passwordStrength.classList.add('strength-fair');
                } else if (strength <= 75) {
                    passwordStrength.classList.add('strength-good');
                } else {
                    passwordStrength.classList.add('strength-strong');
                }
            }
            
            if (newPassword) {
                newPassword.addEventListener('input', function() {
                    const password = newPassword.value;
                    const { strength, requirements } = checkPasswordStrength(password);
                    
                    updatePasswordStrength(strength);
                    updatePasswordRequirements(requirements);
                    
                    // Validate password confirmation
                    validatePasswordConfirmation();
                });
            }
            
            // Password confirmation validation
            function validatePasswordConfirmation() {
                if (newPassword && confirmPassword) {
                    if (newPassword.value !== confirmPassword.value) {
                        confirmPassword.setCustomValidity("Passwords don't match");
                        document.getElementById('confirmPasswordFeedback').style.display = 'block';
                    } else {
                        confirmPassword.setCustomValidity('');
                        document.getElementById('confirmPasswordFeedback').style.display = 'none';
                    }
                }
            }
            
            if (confirmPassword) {
                confirmPassword.addEventListener('input', validatePasswordConfirmation);
            }
            
            // Form validation
            const forms = document.querySelectorAll('.needs-validation');
            
            Array.from(forms).forEach(form => {
                form.addEventListener('submit', function(event) {
                    // Re-validate password confirmation on submit
                    validatePasswordConfirmation();
                    
                    if (!form.checkValidity()) {
                        event.preventDefault();
                        event.stopPropagation();
                    }
                    form.classList.add('was-validated');
                }, false);
            });
        });
    </script>
</body>
</html>