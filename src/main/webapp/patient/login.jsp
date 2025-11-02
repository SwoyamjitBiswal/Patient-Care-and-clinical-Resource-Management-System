<%@ include file="../includes/header.jsp" %>
<title>Patient Care System - Patient Login</title>
<link rel="stylesheet" href="${pageContext.request.contextPath}/css/auth.css">
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
                                boolean rememberMe = false; // This will be true if we find the email cookie

                                if (cookies != null) {
                                    for (Cookie cookie : cookies) {
                                        if ("patientEmail".equals(cookie.getName())) {
                                            patientEmail = cookie.getValue();
                                            rememberMe = true; 
                                        }
                                        // **FIX:** Removed the part that looks for "patientPassword"
                                    }
                                }
                                
                                // --- SUCCESS ALERT BLOCK ---
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
                                               autocomplete="current-password">
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
        // **FIX:** Store only the email value from the cookie.
        const patientEmailValue = '<%= patientEmail %>';
        
        document.addEventListener('DOMContentLoaded', function() {
            const passwordToggle = document.getElementById('passwordToggle');
            const passwordInput = document.getElementById('password');
            const emailInput = document.getElementById('email');
            
            // **FIX:** Removed the JavaScript that tried to set the password.
            // The value is already set in the HTML for the email input.
            // This JS block is good to have in case the browser autofill is aggressive.
            if (patientEmailValue && emailInput) {
                 emailInput.value = patientEmailValue;
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