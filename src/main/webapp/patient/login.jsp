<%@ include file="../includes/header.jsp" %>
<title>Patient Care System - Patient Login</title>
<style>
    /* Light Background Styles */
    .auth-container {
        background: #f8fafc;
        min-height: 100vh;
        display: flex;
        align-items: center;
        padding: 2rem 0;
    }

    .auth-card {
        background: white;
        border-radius: 20px;
        box-shadow: 0 10px 30px rgba(0, 0, 0, 0.08);
        overflow: hidden;
        transition: all 0.3s ease;
        border: 1px solid #e5e7eb;
        margin: 2rem auto;
        max-width: 500px;
    }

    .auth-card:hover {
        transform: translateY(-3px);
        box-shadow: 0 15px 40px rgba(0, 0, 0, 0.12);
    }

    .auth-header {
        background: linear-gradient(135deg, #4f46e5, #7c3aed);
        color: white;
        padding: 2.5rem 2rem;
        text-align: center;
    }

    .auth-header h2 {
        font-weight: 700;
        margin-bottom: 0.5rem;
        font-size: 2rem;
    }

    .auth-header p {
        opacity: 0.9;
        font-size: 1.1rem;
        margin-bottom: 0;
    }

    .auth-body {
        padding: 2.5rem;
    }

    /* Form Styles */
    .form-label {
        font-weight: 600;
        color: #374151;
        margin-bottom: 0.5rem;
        font-size: 0.95rem;
    }

    .input-group {
        position: relative;
        display: flex;
        flex-wrap: wrap;
        align-items: stretch;
        width: 100%;
        border-radius: 12px;
        overflow: hidden;
        border: 2px solid #e5e7eb;
        transition: all 0.3s ease;
    }

    .input-group:focus-within {
        border-color: #4f46e5;
        box-shadow: 0 0 0 3px rgba(79, 70, 229, 0.1);
    }

    .input-group-text {
        background: #f9fafb;
        border: none;
        color: #6b7280;
        padding: 0.75rem 1rem;
        display: flex;
        align-items: center;
        justify-content: center;
        min-width: 50px;
        flex-shrink: 0;
    }

    .form-control {
        border-radius: 0;
        padding: 0.75rem 1rem;
        border: none;
        transition: all 0.3s ease;
        font-size: 0.95rem;
        width: 100%;
        flex: 1;
    }

    .form-control:focus {
        box-shadow: none;
        border: none;
        outline: none;
    }

    /* Password Toggle */
    .password-toggle {
        background: none;
        border: none;
        color: #6b7280;
        padding: 0.75rem 1rem;
        cursor: pointer;
        transition: color 0.3s ease;
        display: flex;
        align-items: center;
        justify-content: center;
        min-width: 50px;
    }

    .password-toggle:hover {
        color: #4f46e5;
        background: #f9fafb;
    }

    /* Checkbox Styles */
    .form-check {
        margin-bottom: 1.5rem;
    }

    .form-check-input {
        width: 1.1em;
        height: 1.1em;
        margin-top: 0.15em;
        margin-right: 0.5rem;
        border: 2px solid #d1d5db;
        border-radius: 4px;
        transition: all 0.3s ease;
    }

    .form-check-input:checked {
        background-color: #4f46e5;
        border-color: #4f46e5;
    }

    .form-check-input:focus {
        box-shadow: 0 0 0 3px rgba(79, 70, 229, 0.1);
        border-color: #4f46e5;
    }

    .form-check-label {
        color: #374151;
        font-weight: 500;
        cursor: pointer;
    }

    /* Button Styles */
    .btn-primary {
        background: linear-gradient(135deg, #4f46e5, #7c3aed);
        border: none;
        padding: 1rem 2rem;
        font-weight: 600;
        border-radius: 12px;
        transition: all 0.3s ease;
        font-size: 1.1rem;
    }

    .btn-primary:hover {
        transform: translateY(-2px);
        box-shadow: 0 10px 25px rgba(79, 70, 229, 0.3);
    }

    /* Alert Styles */
    .alert {
        border-radius: 12px;
        border: none;
        padding: 1rem 1.5rem;
        margin-bottom: 1.5rem;
        border-left: 4px solid;
    }

    .alert-success {
        color: #065f46;
        background-color: #d1fae5;
        border-left-color: #10b981;
    }

    .alert-danger {
        color: #7f1d1d;
        background-color: #fef2f2;
        border-left-color: #ef4444;
    }

    .alert-dismissible {
        padding-right: 3rem;
    }

    .btn-close {
        background: transparent url("data:image/svg+xml,%3csvg xmlns='http://www.w3.org/2000/svg' viewBox='0 0 16 16' fill='%23000'%3e%3cpath d='M.293.293a1 1 0 0 1 1.414 0L8 6.586 14.293.293a1 1 0 1 1 1.414 1.414L9.414 8l6.293 6.293a1 1 0 0 1-1.414 1.414L8 9.414l-6.293 6.293a1 1 0 0 1-1.414-1.414L6.586 8 .293 1.707a1 1 0 0 1 0-1.414z'/%3e%3c/svg%3e") center/1em auto no-repeat;
        border: none;
        opacity: 0.7;
        width: 1.5rem;
        height: 1.5rem;
        padding: 0.25rem;
        margin: -0.5rem -0.5rem -0.5rem auto;
    }

    .btn-close:hover {
        opacity: 1;
    }
    
    /* Link Styles */
    .auth-link {
        color: #4f46e5;
        text-decoration: none;
        font-weight: 600;
        transition: color 0.3s ease;
    }

    .auth-link:hover {
        color: #7c3aed;
        text-decoration: underline;
    }

    .text-muted-link {
        color: #6b7280;
        text-decoration: none;
        transition: color 0.3s ease;
    }

    .text-muted-link:hover {
        color: #4f46e5;
        text-decoration: underline;
    }

    /* Validation Styles */
    .was-validated .form-control:invalid,
    .form-control.is-invalid {
        border-color: #ef4444;
    }

    .was-validated .form-control:invalid:focus,
    .form-control.is-invalid:focus {
        border-color: #ef4444;
        box-shadow: 0 0 0 3px rgba(239, 68, 68, 0.1);
    }

    .invalid-feedback {
        display: none;
        width: 100%;
        margin-top: 0.25rem;
        font-size: 0.875em;
        color: #ef4444;
        font-weight: 500;
    }

    .was-validated .form-control:invalid ~ .invalid-feedback {
        display: block;
    }

    /* Responsive */
    @media (max-width: 768px) {
        .auth-container {
            padding: 1rem;
        }
        
        .auth-header {
            padding: 2rem 1.5rem;
        }
        
        .auth-body {
            padding: 2rem 1.5rem;
        }
        
        .auth-header h2 {
            font-size: 1.5rem;
        }
        
        .auth-card {
            max-width: 100%;
            margin: 1rem auto;
        }
    }

    /* Utility Classes */
    .text-primary { color: #4f46e5 !important; }
    .mb-0 { margin-bottom: 0 !important; }
    .mb-2 { margin-bottom: 0.5rem !important; }
    .mb-3 { margin-bottom: 1rem !important; }
    .d-grid { display: grid !important; }
    .text-center { text-align: center !important; }
    .row { display: flex; flex-wrap: wrap; margin-right: -15px; margin-left: -15px; }
    .justify-content-center { justify-content: center !important; }
</style>
</head>
<body>
    <%@ include file="../includes/navbar.jsp" %>

    <div class="auth-container">
        <div class="container">
            <div class="row justify-content-center">
                <div class="col-12">
                    <div class="auth-card">
                        <div class="auth-header">
                            <h2><i class="fas fa-sign-in-alt me-2"></i>Patient Login</h2>
                            <p class="mb-0">Access your patient dashboard</p>
                        </div>
                        <div class="auth-body">
                            
                            <%
                                // Read success message from session (set after registration redirect)
                                String successMsg = (String) session.getAttribute("successMsg");
                                
                                // Read error message from request (set after failed login forward)
                                String errorMsg = (String) request.getAttribute("errorMsg");
                                
                                // --- Get Cookie data ---
                                Cookie[] cookies = request.getCookies();
                                String patientEmail = "";
                                String patientPassword = ""; // This is only used to prefill if cookie exists
                                boolean rememberMe = false;

                                if (cookies != null) {
                                    for (Cookie cookie : cookies) {
                                        if ("patientEmail".equals(cookie.getName())) {
                                            patientEmail = cookie.getValue();
                                            rememberMe = true; 
                                        }
                                        // We prefill password only if email is also remembered
                                        // Note: Your servlet code was corrected to NOT save passwords in cookies.
                                        // This code is kept for legacy/remember-me email functionality.
                                        if ("patientPassword".equals(cookie.getName())) {
                                            patientPassword = cookie.getValue();
                                        }
                                    }
                                }
                                
                                // --- NEW: SUCCESS ALERT BLOCK ---
                                if (successMsg != null && !successMsg.isEmpty()) {
                            %>
                                <div class="alert alert-success alert-dismissible fade show" role="alert">
                                    <div class="d-flex align-items-center">
                                        <i class="fas fa-check-circle me-3 fs-5"></i>
                                        <div class="flex-grow-1">
                                            <strong>You have successfully registered!</strong> Now you have to log in.
                                        </div>
                                    </div>
                                    <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
                                </div>
                            <%
                                    // CRITICAL: Remove from session so it doesn't show again on refresh
                                    session.removeAttribute("successMsg");
                                }
                                
                                // --- ERROR MESSAGE BLOCK ---
                                if (errorMsg != null && !errorMsg.isEmpty()) {
                            %>
                                <div class="alert alert-danger alert-dismissible fade show" role="alert">
                                    <div class="d-flex align-items-center">
                                        <i class="fas fa-exclamation-triangle me-3 fs-5"></i>
                                        <div class="flex-grow-1"><%= errorMsg %></div>
                                    </div>
                                    <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
                                </div>
                            <%
                                    // CRITICAL: Remove attribute after display
                                    request.removeAttribute("errorMsg");
                                }
                            %>


                            <form action="${pageContext.request.contextPath}/patient/auth?action=login" method="post" class="needs-validation" novalidate>
                                <div class="mb-3">
                                    <label for="email" class="form-label">Email Address</label>
                                    <div class="input-group"> 
                                        <span class="input-group-text">
                                            <i class="fas fa-envelope text-primary"></i>
                                        </span>
                                        <input type="email" class="form-control" id="email" name="email" required 
                                               placeholder="Enter your email address"
                                               value="<%= patientEmail %>" 
                                               autocomplete="username"> 
                                    </div>
                                    <div class="invalid-feedback">Please enter a valid email address.</div>
                                </div>

                                <div class="mb-3">
                                    <label for="password" class="form-label">Password</label>
                                    <div class="input-group">
                                        <span class="input-group-text">
                                            <i class="fas fa-lock text-primary"></i>
                                        </span>
                                        <input type="password" class="form-control" id="password" name="password" required 
                                               placeholder="Enter your password"
                                               autocomplete="current-password"
                                               value="<%= (rememberMe ? patientPassword : "") %>"> <%-- Prefill if remembered --%>
                                        <button type="button" class="password-toggle" id="passwordToggle">
                                            <i class="fas fa-eye"></i> 
                                        </button>
                                    </div>
                                    <div class="invalid-feedback">Please enter your password.</div>
                                </div>

                                <div class="mb-3 form-check">
                                    <input type="checkbox" class="form-check-input" id="rememberMe" name="rememberMe"
                                        <%= (rememberMe ? "checked" : "") %>>
                                    <label class="form-check-label" for="rememberMe">Remember me on this device</label>

                                </div>

                                <div class="d-grid mb-3">
                                    <button type="submit" class="btn btn-primary btn-lg">
                                        <i class="fas fa-sign-in-alt me-2"></i>Login to Dashboard
                                    </button>
                                </div>

                                <div class="text-center">
                                    <p class="mb-2">
                                        <a href="${pageContext.request.contextPath}/patient/register.jsp" class="auth-link">
                                            <i class="fas fa-user-plus me-1"></i>Create new account
                                        </a>
                                    </p>
                                    <p class="mb-0">
                                        <a href="${pageContext.request.contextPath}/index.jsp" class="text-muted-link">
                                            <i class="fas fa-home me-1"></i>Back to home
                                        </a>
                                    </p>
                                </div>
                            </form>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <%-- MODAL HTML HAS BEEN REMOVED --%>

    <%@ include file="../includes/footer.jsp" %>

    <script>
        // Store cookie values in JS variables for dynamic fill
        const patientEmailValue = '<%= patientEmail %>';
        const patientPasswordValue = '<%= (rememberMe ? patientPassword : "") %>'; // Only use if rememberMe is on
        
        document.addEventListener('DOMContentLoaded', function() {
            const passwordToggle = document.getElementById('passwordToggle');
            const passwordInput = document.getElementById('password');
            const emailInput = document.getElementById('email');
            
            // MODAL SCRIPT HAS BEEN REMOVED
            
            // Dynamic fill to beat aggressive browser autofill
            if (patientEmailValue && emailInput) {
                 emailInput.value = patientEmailValue;
            }
            if (patientPasswordValue && passwordInput) {
                 passwordInput.value = patientPasswordValue;
            }
            
            if (passwordToggle && passwordInput) {
                // Password Toggle Logic
                passwordToggle.addEventListener('click', function() {
                    const type = passwordInput.getAttribute('type') === 'password' ? 'text' : 'password';
                    passwordInput.setAttribute('type', type);
                    
                    const icon = this.querySelector('i');
                    if (type === 'password') {
                        icon.classList.remove('fa-eye-slash');
                        icon.classList.add('fa-eye');
                    } else {
                        icon.classList.remove('fa-eye');
                        icon.classList.add('fa-eye-slash');
                    }
                });
            }

            // Form validation
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
        });
    </script>
</body>
</html>