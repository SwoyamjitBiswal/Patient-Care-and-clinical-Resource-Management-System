<%@ include file="../includes/header.jsp" %>
<title>Patient Care System - Doctor Login</title>
<link rel="stylesheet" href="${pageContext.request.contextPath}/css/auth.css">
</head>
<body>
    <%@ include file="../includes/navbar.jsp" %>

    <div class="auth-container">
        <div class="container">
            <div class="row justify-content-center">
                <div class="col-md-6">
                    <div class="auth-card">
                        <div class="auth-header">
                            <h2><i class="fas fa-sign-in-alt me-2"></i>Doctor Login</h2>
                            <p class="mb-0">Access your doctor dashboard</p>
                        </div>
                        <div class="auth-body">
                            <%
                                // Retrieve messages from session (set by DoctorAuthServlet)
                                String successMsg = (String) session.getAttribute("successMsg");
                                String errorMsg = (String) session.getAttribute("errorMsg");
                                
                                // Clear session attributes immediately after retrieval
                                if (successMsg != null || errorMsg != null) {
                                    session.removeAttribute("successMsg");
                                    session.removeAttribute("errorMsg");
                                }

                                if (successMsg != null) {
                            %>
                                <div class="alert alert-success alert-dismissible fade show" role="alert">
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
                                <div class="alert alert-danger alert-dismissible fade show" role="alert">
                                    <div class="d-flex align-items-center">
                                        <i class="fas fa-exclamation-triangle me-3 fs-5"></i>
                                        <div class="flex-grow-1"><%= errorMsg %></div>
                                    </div>
                                    <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
                                </div>
                            <%
                                }
                            %>

                            <form action="${pageContext.request.contextPath}/doctor/auth?action=login" method="post" class="needs-validation" novalidate>
                                <div class="mb-4">
                                    <label for="email" class="form-label">Email Address</label>
                                    <div class="input-group">
                                        <span class="input-group-text">
                                            <i class="fas fa-envelope text-primary"></i>
                                        </span>
                                        <input type="email" class="form-control" id="email" name="email" required 
                                               placeholder="Enter your email address"
                                               value="<%
                                                   Cookie[] cookies = request.getCookies();
                                                   if (cookies != null) {
                                                       for (Cookie cookie : cookies) {
                                                           if ("doctorEmail".equals(cookie.getName())) {
                                                               out.print(cookie.getValue());
                                                           }
                                                       }
                                                   }
                                               %>">
                                    </div>
                                    <div class="invalid-feedback">Please enter your email address.</div>
                                </div>

                                <div class="mb-4">
                                    <label for="password" class="form-label">Password</label>
                                    <div class="input-group">
                                        <span class="input-group-text">
                                            <i class="fas fa-lock text-primary"></i>
                                        </span>
                                        <input type="password" class="form-control" id="password" name="password" required 
                                               placeholder="Enter your password"
                                               value="<%
                                                   if (cookies != null) {
                                                       for (Cookie cookie : cookies) {
                                                           if ("doctorPassword".equals(cookie.getName())) {
                                                               out.print(cookie.getValue());
                                                           }
                                                       }
                                                   }
                                               %>">
                                        <button type="button" class="password-toggle" id="passwordToggle">
                                            <i class="fas fa-eye"></i>
                                        </button>
                                    </div>
                                    <div class="invalid-feedback">Please enter your password.</div>
                                </div>

                                <div class="mb-4 d-flex align-items-center">
                                    <input type="checkbox" class="form-check-input" id="rememberMe" name="rememberMe"
                                        <%
                                            if (cookies != null) {
                                                for (Cookie cookie : cookies) {
                                                    if ("doctorEmail".equals(cookie.getName()) && !cookie.getValue().isEmpty()) {
                                                        out.print("checked");
                                                    }
                                                }
                                            }
                                        %>>
                                    <label class="form-check-label" for="rememberMe">Remember me</label>
                                </div>

                                <div class="d-grid mb-4">
                                    <button type="submit" class="btn btn-primary btn-lg">
                                        <i class="fas fa-sign-in-alt me-2"></i>Login to Dashboard
                                    </button>
                                </div>

                                <div class="text-center">
                                    <p class="mb-2">
                                        <a href="${pageContext.request.contextPath}/doctor/register.jsp" class="auth-link">
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

    <%@ include file="../includes/footer.jsp" %>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    <script>
        document.addEventListener('DOMContentLoaded', function() {
            // Password toggle functionality
            const passwordToggle = document.getElementById('passwordToggle');
            const passwordInput = document.getElementById('password');
            
            if (passwordToggle && passwordInput) {
                passwordToggle.addEventListener('click', function() {
                    const type = passwordInput.getAttribute('type') === 'password' ? 'text' : 'password';
                    passwordInput.setAttribute('type', type);
                    this.innerHTML = type === 'password' ? '<i class="fas fa-eye"></i>' : '<i class="fas fa-eye-slash"></i>';
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