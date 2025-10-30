<%@ include file="../includes/header.jsp" %>

<title>Patient Care System - Doctor Registration</title>
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
    }

    .auth-card:hover {
        transform: translateY(-3px);
        box-shadow: 0 15px 40px rgba(0, 0, 0, 0.12);
    }

    .auth-header {
        background: linear-gradient(135deg, #4f46e5, #7c3aed);
        color: white;
        padding: 2.5rem 3rem;
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
        padding: 3rem;
    }

    /* Increased Form Width */
    .wide-form {
        max-width: 1000px;
        margin: 0 auto;
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

    .form-select {
        border: 2px solid #e5e7eb;
        border-radius: 12px;
        padding: 0.75rem 1rem;
        transition: all 0.3s ease;
    }

    .form-select:focus {
        border-color: #4f46e5;
        box-shadow: 0 0 0 3px rgba(79, 70, 229, 0.1);
    }

    /* Password Toggle */
    .password-toggle {
        background: none;
        border: none;
        color: #6b7280;
        padding: 0.75rem 1rem;
        cursor: pointer;
        transition: color 0.3s ease;
    }

    .password-toggle:hover {
        color: #4f46e5;
    }

    /* Password Strength Indicator */
    .password-strength {
        margin-top: 0.5rem;
    }

    .strength-bar {
        height: 4px;
        border-radius: 2px;
        background: #e5e7eb;
        margin-bottom: 0.5rem;
        overflow: hidden;
    }

    .strength-fill {
        height: 100%;
        width: 0%;
        transition: all 0.3s ease;
        border-radius: 2px;
    }

    .strength-weak { background: #ef4444; width: 25%; }
    .strength-fair { background: #f59e0b; width: 50%; }
    .strength-good { background: #10b981; width: 75%; }
    .strength-strong { background: #10b981; width: 100%; }

    .strength-text {
        font-size: 0.875rem;
        font-weight: 500;
    }

    .strength-requirements {
        margin-top: 0.75rem;
        font-size: 0.8rem;
    }

    .requirement {
        display: flex;
        align-items: center;
        margin-bottom: 0.25rem;
        color: #6b7280;
    }

    .requirement.met {
        color: #10b981;
    }

    .requirement i {
        margin-right: 0.5rem;
        font-size: 0.7rem;
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
        margin-bottom: 2rem;
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

    .was-validated .form-control:invalid ~ .invalid-feedback,
    .was-validated .form-select:invalid ~ .invalid-feedback {
        display: block;
    }

    /* Responsive */
    @media (max-width: 1200px) {
        .auth-body {
            padding: 2.5rem;
        }
        
        .auth-header {
            padding: 2rem 2.5rem;
        }
    }

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
        
        .wide-form {
            max-width: 100%;
        }
    }

    /* Utility Classes */
    .text-primary { color: #4f46e5 !important; }
    .mb-0 { margin-bottom: 0 !important; }
    .mb-3 { margin-bottom: 1rem !important; }
    .mb-4 { margin-bottom: 1.5rem !important; }
    .mt-2 { margin-top: 0.5rem !important; }
    .d-flex { display: flex !important; }
    .align-items-center { align-items: center !important; }
    .justify-content-center { justify-content: center !important; }
    .text-center { text-align: center !important; }
    .row { display: flex; flex-wrap: wrap; margin-right: -15px; margin-left: -15px; }
    .col-md-6, .col-md-4, .col-lg-6, .col-lg-4 { 
        position: relative; 
        width: 100%; 
        padding-right: 15px; 
        padding-left: 15px; 
    }
    @media (min-width: 768px) {
        .col-md-6 { flex: 0 0 50%; max-width: 50%; }
        .col-md-4 { flex: 0 0 33.333333%; max-width: 33.333333%; }
    }
    @media (min-width: 992px) {
        .col-lg-6 { flex: 0 0 50%; max-width: 50%; }
        .col-lg-4 { flex: 0 0 33.333333%; max-width: 33.333333%; }
    }
</style>
</head>
<body>
    <!-- Navbar Included -->
    <%@ include file="../includes/navbar.jsp" %>

    <div class="auth-container">
        <div class="container">
            <div class="row justify-content-center">
                <div class="col-12">
                    <div class="auth-card wide-form">
                        <div class="auth-header">
                            <h2><i class="fas fa-user-md me-2"></i>Doctor Registration</h2>
                            <p class="mb-0">Join our network of healthcare professionals</p>
                        </div>
                        <div class="auth-body">
                            <!-- Success/Error Messages -->
                            <%
                                String successMsg = (String) request.getAttribute("successMsg");
                                String errorMsg = (String) request.getAttribute("errorMsg");
                                
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

                            <form action="${pageContext.request.contextPath}/doctor/auth?action=register" method="post" class="needs-validation" novalidate id="registrationForm">
                                <div class="row">
                                    <div class="col-lg-6 mb-3">
                                        <label for="fullName" class="form-label">Full Name</label>
                                        <div class="input-group">
                                            <span class="input-group-text">
                                                <i class="fas fa-user text-primary"></i>
                                            </span>
                                            <input type="text" class="form-control" id="fullName" name="fullName" required 
                                                   placeholder="Dr. Full Name">
                                        </div>
                                        <div class="invalid-feedback">Please enter your full name.</div>
                                    </div>
                                    
                                    <div class="col-lg-6 mb-3">
                                        <label for="email" class="form-label">Email Address</label>
                                        <div class="input-group">
                                            <span class="input-group-text">
                                                <i class="fas fa-envelope text-primary"></i>
                                            </span>
                                            <input type="email" class="form-control" id="email" name="email" required 
                                                   placeholder="Enter your email address">
                                        </div>
                                        <div class="invalid-feedback">Please enter a valid email address.</div>
                                    </div>
                                </div>

                                <div class="row">
                                    <div class="col-lg-6 mb-3">
                                        <label for="password" class="form-label">Password</label>
                                        <div class="input-group">
                                            <span class="input-group-text">
                                                <i class="fas fa-lock text-primary"></i>
                                            </span>
                                            <input type="password" class="form-control" id="password" name="password" required 
                                                   placeholder="Create a strong password" minlength="6">
                                            <button type="button" class="password-toggle" id="passwordToggle">
                                                <i class="fas fa-eye"></i>
                                            </button>
                                        </div>
                                        <div class="password-strength">
                                            <div class="strength-bar">
                                                <div class="strength-fill" id="strengthFill"></div>
                                            </div>
                                            <div class="strength-text" id="strengthText">Password strength</div>
                                            <div class="strength-requirements">
                                                <div class="requirement" id="reqLength">
                                                    <i class="fas fa-circle"></i>
                                                    At least 6 characters
                                                </div>
                                                <div class="requirement" id="reqLowercase">
                                                    <i class="fas fa-circle"></i>
                                                    One lowercase letter
                                                </div>
                                                <div class="requirement" id="reqUppercase">
                                                    <i class="fas fa-circle"></i>
                                                    One uppercase letter
                                                </div>
                                                <div class="requirement" id="reqNumber">
                                                    <i class="fas fa-circle"></i>
                                                    One number
                                                </div>
                                                <div class="requirement" id="reqSpecial">
                                                    <i class="fas fa-circle"></i>
                                                    One special character
                                                </div>
                                            </div>
                                        </div>
                                        <div class="invalid-feedback" id="passwordFeedback">Password must meet all requirements.</div>
                                    </div>
                                    
                                    <div class="col-lg-6 mb-3">
                                        <label for="phone" class="form-label">Phone Number</label>
                                        <div class="input-group">
                                            <span class="input-group-text">
                                                <i class="fas fa-phone text-primary"></i>
                                            </span>
                                            <input type="tel" class="form-control" id="phone" name="phone" required 
                                                   placeholder="Enter your phone number">
                                        </div>
                                        <div class="invalid-feedback">Please enter your phone number.</div>
                                    </div>
                                </div>

                                <div class="row">
                                    <div class="col-lg-6 mb-3">
                                        <label for="specialization" class="form-label">Specialization</label>
                                        <div class="input-group">
                                            <span class="input-group-text">
                                                <i class="fas fa-stethoscope text-primary"></i>
                                            </span>
                                            <select class="form-select" id="specialization" name="specialization" required>
                                                <option value="">Select Specialization</option>
                                                <option value="Cardiology">Cardiology</option>
                                                <option value="Neurology">Neurology</option>
                                                <option value="Pediatrics">Pediatrics</option>
                                                <option value="Dermatology">Dermatology</option>
                                                <option value="Orthopedics">Orthopedics</option>
                                                <option value="Gynecology">Gynecology</option>
                                                <option value="Psychiatry">Psychiatry</option>
                                                <option value="Dentistry">Dentistry</option>
                                                <option value="Ophthalmology">Ophthalmology</option>
                                                <option value="General Medicine">General Medicine</option>
                                                <option value="Emergency Medicine">Emergency Medicine</option>
                                                <option value="Surgery">Surgery</option>
                                                <option value="Radiology">Radiology</option>
                                                <option value="Anesthesiology">Anesthesiology</option>
                                            </select>
                                        </div>
                                        <div class="invalid-feedback">Please select your specialization.</div>
                                    </div>
                                    
                                    <div class="col-lg-6 mb-3">
                                        <label for="department" class="form-label">Department</label>
                                        <div class="input-group">
                                            <span class="input-group-text">
                                                <i class="fas fa-building text-primary"></i>
                                            </span>
                                            <input type="text" class="form-control" id="department" name="department" required 
                                                   placeholder="Enter department name">
                                        </div>
                                        <div class="invalid-feedback">Please enter your department.</div>
                                    </div>
                                </div>

                                <div class="mb-3">
                                    <label for="qualification" class="form-label">Qualifications</label>
                                    <div class="input-group">
                                        <span class="input-group-text align-items-start pt-3">
                                            <i class="fas fa-graduation-cap text-primary"></i>
                                        </span>
                                        <textarea class="form-control" id="qualification" name="qualification" rows="2" required 
                                                  placeholder="MD, MBBS, MS, etc."></textarea>
                                    </div>
                                    <div class="invalid-feedback">Please enter your qualifications.</div>
                                </div>

                                <div class="row">
                                    <div class="col-lg-6 mb-3">
                                        <label for="experience" class="form-label">Experience (Years)</label>
                                        <div class="input-group">
                                            <span class="input-group-text">
                                                <i class="fas fa-briefcase text-primary"></i>
                                            </span>
                                            <input type="number" class="form-control" id="experience" name="experience" required 
                                                   min="0" max="50" placeholder="Years of experience">
                                        </div>
                                        <div class="invalid-feedback">Please enter your experience in years.</div>
                                    </div>
                                    
                                    <div class="col-lg-6 mb-3">
                                        <label for="visitingCharge" class="form-label">Consultation Fee</label>
                                        <div class="input-group">
                                            <span class="input-group-text">
                                                <i class="fas fa-dollar-sign text-primary"></i>
                                            </span>
                                            <input type="number" class="form-control" id="visitingCharge" name="visitingCharge" required 
                                                   min="0" step="0.01" placeholder="Consultation fee amount">
                                        </div>
                                        <div class="invalid-feedback">Please enter your consultation fee.</div>
                                    </div>
                                </div>

                                <div class="d-grid mb-3">
                                    <button type="submit" class="btn btn-primary btn-lg">
                                        <i class="fas fa-user-md me-2"></i>Register as Doctor
                                    </button>
                                </div>

                                <div class="text-center">
                                    <p class="mb-0">
                                        Already have an account? 
                                        <a href="${pageContext.request.contextPath}/doctor/login.jsp" class="auth-link">
                                            <i class="fas fa-sign-in-alt me-1"></i>Login here
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

    <!-- Footer Included -->
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

            // Password strength validation
            const passwordField = document.getElementById('password');
            const strengthFill = document.getElementById('strengthFill');
            const strengthText = document.getElementById('strengthText');
            const requirements = {
                length: document.getElementById('reqLength'),
                lowercase: document.getElementById('reqLowercase'),
                uppercase: document.getElementById('reqUppercase'),
                number: document.getElementById('reqNumber'),
                special: document.getElementById('reqSpecial')
            };

            if (passwordField) {
                passwordField.addEventListener('input', function() {
                    const password = this.value;
                    let strength = 0;
                    let metRequirements = 0;
                    const totalRequirements = 5;

                    // Check requirements
                    const hasLength = password.length >= 6;
                    const hasLowercase = /[a-z]/.test(password);
                    const hasUppercase = /[A-Z]/.test(password);
                    const hasNumber = /[0-9]/.test(password);
                    const hasSpecial = /[!@#$%^&*()_+\-=\[\]{};':"\\|,.<>\/?]/.test(password);

                    // Update requirement indicators
                    updateRequirement(requirements.length, hasLength);
                    updateRequirement(requirements.lowercase, hasLowercase);
                    updateRequirement(requirements.uppercase, hasUppercase);
                    updateRequirement(requirements.number, hasNumber);
                    updateRequirement(requirements.special, hasSpecial);

                    // Calculate strength
                    if (hasLength) strength += 20;
                    if (hasLowercase) strength += 20;
                    if (hasUppercase) strength += 20;
                    if (hasNumber) strength += 20;
                    if (hasSpecial) strength += 20;

                    // Count met requirements
                    metRequirements = [hasLength, hasLowercase, hasUppercase, hasNumber, hasSpecial].filter(Boolean).length;

                    // Update strength indicator
                    updateStrengthIndicator(strength, metRequirements, totalRequirements);
                });
            }

            function updateRequirement(element, isMet) {
                if (isMet) {
                    element.classList.add('met');
                    element.innerHTML = '<i class="fas fa-check-circle"></i>' + element.textContent.substring(element.textContent.indexOf(' ') + 1);
                } else {
                    element.classList.remove('met');
                    element.innerHTML = '<i class="fas fa-circle"></i>' + element.textContent.substring(element.textContent.indexOf(' ') + 1);
                }
            }

            function updateStrengthIndicator(strength, met, total) {
                if (strengthFill && strengthText) {
                    strengthFill.className = 'strength-fill';
                    
                    if (strength <= 25) {
                        strengthFill.classList.add('strength-weak');
                        strengthText.textContent = 'Weak password';
                        strengthText.style.color = '#ef4444';
                    } else if (strength <= 50) {
                        strengthFill.classList.add('strength-fair');
                        strengthText.textContent = 'Fair password';
                        strengthText.style.color = '#f59e0b';
                    } else if (strength <= 75) {
                        strengthFill.classList.add('strength-good');
                        strengthText.textContent = 'Good password';
                        strengthText.style.color = '#10b981';
                    } else {
                        strengthFill.classList.add('strength-strong');
                        strengthText.textContent = 'Strong password';
                        strengthText.style.color = '#10b981';
                    }
                }
            }

            // Enhanced form validation
            const forms = document.querySelectorAll('.needs-validation');
            Array.from(forms).forEach(form => {
                form.addEventListener('submit', function(event) {
                    if (!form.checkValidity()) {
                        event.preventDefault();
                        event.stopPropagation();
                    } else {
                        // Custom password validation
                        const password = document.getElementById('password').value;
                        const hasLength = password.length >= 6;
                        const hasLowercase = /[a-z]/.test(password);
                        const hasUppercase = /[A-Z]/.test(password);
                        const hasNumber = /[0-9]/.test(password);
                        const hasSpecial = /[!@#$%^&*()_+\-=\[\]{};':"\\|,.<>\/?]/.test(password);

                        if (!hasLength || !hasLowercase || !hasUppercase || !hasNumber || !hasSpecial) {
                            event.preventDefault();
                            event.stopPropagation();
                            document.getElementById('passwordFeedback').style.display = 'block';
                            passwordField.classList.add('is-invalid');
                        }
                    }
                    
                    form.classList.add('was-validated');
                }, false);
            });

            // Real-time password validation
            if (passwordField) {
                passwordField.addEventListener('blur', function() {
                    const password = this.value;
                    const hasLength = password.length >= 6;
                    const hasLowercase = /[a-z]/.test(password);
                    const hasUppercase = /[A-Z]/.test(password);
                    const hasNumber = /[0-9]/.test(password);
                    const hasSpecial = /[!@#$%^&*()_+\-=\[\]{};':"\\|,.<>\/?]/.test(password);

                    if (password && (!hasLength || !hasLowercase || !hasUppercase || !hasNumber || !hasSpecial)) {
                        this.classList.add('is-invalid');
                        document.getElementById('passwordFeedback').style.display = 'block';
                    } else if (password) {
                        this.classList.remove('is-invalid');
                        document.getElementById('passwordFeedback').style.display = 'none';
                    }
                });
            }

            // Phone number formatting
            const phoneInput = document.getElementById('phone');
            
            function formatPhoneNumber(input) {
                if (input) {
                    input.addEventListener('input', function(e) {
                        let value = e.target.value.replace(/\D/g, '');
                        if (value.length > 10) value = value.substring(0, 10);
                        
                        if (value.length > 6) {
                            value = value.replace(/(\d{3})(\d{3})(\d{4})/, '$1-$2-$3');
                        } else if (value.length > 3) {
                            value = value.replace(/(\d{3})(\d{1,3})/, '$1-$2');
                        }
                        
                        e.target.value = value;
                    });
                }
            }
            
            formatPhoneNumber(phoneInput);

            // Experience validation
            const experienceInput = document.getElementById('experience');
            if (experienceInput) {
                experienceInput.addEventListener('input', function() {
                    if (this.value < 0) this.value = 0;
                    if (this.value > 50) this.value = 50;
                });
            }

            // Fee validation
            const feeInput = document.getElementById('visitingCharge');
            if (feeInput) {
                feeInput.addEventListener('input', function() {
                    if (this.value < 0) this.value = 0;
                });
            }
        });
    </script>
</body>
</html>