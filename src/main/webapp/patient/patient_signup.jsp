<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@page isELIgnored="false" %>

<!DOCTYPE html>
<html lang="en">

<head>
    <meta charset="UTF-8">
    <title>Patient Registration - Hospital Management System</title>
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

        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
        }

        body {
            background: linear-gradient(135deg, #f8fafc 0%, #e2e8f0 100%);
            color: var(--text);
            min-height: 100vh;
            display: flex;
            align-items: center;
            justify-content: center;
            padding: 20px;
        }

        .signup-container {
            width: 100%;
            max-width: 800px;
            margin: 0 auto;
            padding-top: 100px;
        }

        .signup-header {
            text-align: center;
            margin-bottom: 30px;
        }

        .signup-header h1 {
            color: var(--primary);
            font-weight: 700;
            margin-bottom: 10px;
            font-size: 2.2rem;
        }

        .signup-header p {
            color: var(--text-light);
            font-size: 1.1rem;
        }

        .signup-card {
            background: var(--white);
            border-radius: var(--radius);
            box-shadow: var(--shadow-lg);
            overflow: hidden;
            transition: all 0.3s ease;
        }

        .signup-card:hover {
            box-shadow: 0 20px 40px rgba(0, 0, 0, 0.15);
        }

        .form-section {
            padding: 30px;
        }

        .section-title {
            font-size: 1.3rem;
            font-weight: 600;
            color: var(--primary);
            margin-bottom: 20px;
            padding-bottom: 10px;
            border-bottom: 2px solid var(--gray-light);
            display: flex;
            align-items: center;
            gap: 10px;
        }

        .section-title i {
            font-size: 1.1rem;
        }

        .form-row {
            display: grid;
            grid-template-columns: 1fr 1fr;
            gap: 15px;
            margin-bottom: 15px;
        }

        .form-group {
            margin-bottom: 15px;
        }

        .form-label {
            font-weight: 600;
            margin-bottom: 8px;
            color: var(--dark);
            display: flex;
            align-items: center;
            gap: 8px;
        }

        .form-label i {
            color: var(--primary);
            font-size: 1rem;
        }

        .input-group {
            position: relative;
            display: flex;
            align-items: center;
        }

        .form-control {
            background: var(--light);
            border: 2px solid var(--gray-light);
            border-radius: 8px;
            color: var(--text);
            padding: 12px 15px 12px 45px;
            transition: all 0.3s ease;
            font-size: 1rem;
            width: 100%;
        }

        .form-control:focus {
            border-color: var(--primary);
            box-shadow: 0 0 0 3px rgba(37, 99, 235, 0.1);
            outline: none;
            background: var(--white);
        }

        .input-icon {
            position: absolute;
            left: 15px;
            top: 50%;
            transform: translateY(-50%);
            color: var(--secondary);
            font-size: 1.1rem;
            transition: all 0.3s ease;
            z-index: 5;
            pointer-events: none;
            background: transparent;
        }

        .form-control:focus+.input-icon,
        .input-group:focus-within .input-icon {
            color: var(--primary) !important;
        }

        .form-select {
            background: var(--light);
            border: 2px solid var(--gray-light);
            border-radius: 8px;
            color: var(--text);
            padding: 12px 15px;
            transition: all 0.3s ease;
            font-size: 1rem;
            width: 100%;
        }

        .form-select:focus {
            border-color: var(--primary);
            box-shadow: 0 0 0 3px rgba(37, 99, 235, 0.1);
            outline: none;
        }

        .btn-signup {
            background: linear-gradient(135deg, var(--primary) 0%, var(--primary-light) 100%);
            border: none;
            border-radius: 8px;
            color: white;
            padding: 15px 30px;
            font-size: 1.1rem;
            font-weight: 600;
            transition: all 0.3s ease;
            width: 100%;
            margin-top: 20px;
            display: flex;
            align-items: center;
            justify-content: center;
            gap: 10px;
        }

        .btn-signup:hover {
            background: linear-gradient(135deg, var(--primary-dark) 0%, var(--primary) 100%);
            transform: translateY(-2px);
            box-shadow: 0 8px 20px rgba(37, 99, 235, 0.3);
        }

        .login-link {
            display: block;
            text-align: center;
            margin-top: 25px;
            color: var(--primary);
            font-weight: 500;
            text-decoration: none;
            transition: all 0.3s ease;
        }

        .login-link:hover {
            text-decoration: underline;
            color: var(--primary-dark);
        }

        .text-success,
        .text-danger {
            font-size: 1rem;
            margin-bottom: 20px;
            text-align: center;
            padding: 10px;
            border-radius: 8px;
        }

        .text-success {
            background: rgba(34, 197, 94, 0.1);
            color: #16a34a;
            border: 1px solid rgba(34, 197, 94, 0.2);
        }

        .text-danger {
            background: rgba(239, 68, 68, 0.1);
            color: #dc2626;
            border: 1px solid rgba(239, 68, 68, 0.2);
        }

        .password-toggle {
            position: absolute;
            right: 15px;
            top: 50%;
            transform: translateY(-50%);
            background: none;
            border: none;
            color: var(--secondary);
            cursor: pointer;
            font-size: 1.1rem;
            z-index: 5;
        }

        .input-group:focus-within .password-toggle {
            color: var(--primary);
        }

        textarea.form-control {
            padding-left: 45px;
            resize: vertical;
            min-height: 80px;
        }

        .password-strength {
            margin-top: 8px;
            height: 6px;
            border-radius: 3px;
            overflow: hidden;
            background-color: #e5e7eb;
        }

        .password-strength-bar {
            height: 100%;
            width: 0;
            transition: width 0.3s ease;
        }

        .password-strength-text {
            font-size: 0.8rem;
            margin-top: 4px;
            text-align: right;
        }

        /* Validation feedback styling */
        .was-validated .form-control:valid,
        .was-validated .form-select:valid {
            border-color: #198754;
            background-image: url("data:image/svg+xml,%3csvg xmlns='http://www.w3.org/2000/svg' viewBox='0 0 8 8'%3e%3cpath fill='%23198754' d='M2.3 6.73.6 4.53c-.4-1.04.46-1.4 1.1-.8l1.1 1.4 3.4-3.8c.6-.63 1.6-.27 1.2.7l-4 4.6c-.43.5-.8.4-1.1.1z'/%3e%3c/svg%3e");
            background-repeat: no-repeat;
            background-position: right calc(.375em + .1875rem) center;
            background-size: calc(.75em + .375rem) calc(.75em + .375rem);
        }

        .was-validated .form-control:invalid,
        .was-validated .form-select:invalid {
            border-color: #dc3545;
            background-image: url("data:image/svg+xml,%3csvg xmlns='http://www.w3.org/2000/svg' viewBox='0 0 12 12' width='12' height='12' fill='none' stroke='%23dc3545'%3e%3ccircle cx='6' cy='6' r='4.5'/%3e%3cpath d='m5.8 3.6.4.4.4-.4'/%3e%3cpath d='M6 7v1'/%3e%3c/svg%3e");
            background-repeat: no-repeat;
            background-position: right calc(.375em + .1875rem) center;
            background-size: calc(.75em + .375rem) calc(.75em + .375rem);
        }
        
        /* Adjust background position for password fields with toggle button */
        .was-validated .form-control[type="password"]:valid,
        .was-validated .form-control[type="text"]:valid {
             background-position: right calc(2.375em + .1875rem) center; /* 1.5em (button) + .375em + .1875rem */
        }
        
        .was-validated .form-control[type="password"]:invalid,
        .was-validated .form-control[type="text"]:invalid {
            background-position: right calc(2.375em + .1875rem) center;
        }


        .was-validated .form-check-input:valid {
            border-color: #198754;
        }

        .was-validated .form-check-input:invalid {
            border-color: #dc3545;
        }

        .form-control:valid:focus,
        .form-select:valid:focus {
            border-color: #198754;
            box-shadow: 0 0 0 0.25rem rgba(25, 135, 84, 0.25);
        }

        .form-control:invalid:focus,
        .form-select:invalid:focus {
            border-color: #dc3545;
            box-shadow: 0 0 0 0.25rem rgba(220, 53, 69, 0.25);
        }

        .invalid-feedback {
            display: none;
            width: 100%;
            margin-top: 0.25rem;
            font-size: 0.875em;
            color: #dc3545;
        }

        .was-validated .form-control:invalid~.invalid-feedback,
        .was-validated .form-select:invalid~.invalid-feedback,
        .was-validated .form-check-input:invalid~.invalid-feedback {
            display: block;
        }

        @media (max-width: 768px) {
            .form-row {
                grid-template-columns: 1fr;
                gap: 0;
            }

            .form-section {
                padding: 20px 15px;
            }

            .signup-header h1 {
                font-size: 1.8rem;
            }

            .signup-container {
                padding-top: 20px;
            }
        }
    </style>
</head>

<body>
    <%@include file="../component/navbar.jsp" %>
        <div class="signup-container">
            <div class="signup-header">
                <h1><i class="fas fa-hospital-user me-2"></i>Patient Registration</h1>
                <p>Create your account to access our healthcare services</p>
            </div>

            <div class="signup-card">
                <div class="form-section">
                    <c:if test="${not empty sucMsg}">
                        <div class="text-success">
                            <i class="fas fa-check-circle me-2"></i>${sucMsg}
                        </div>
                        <c:remove var="sucMsg" scope="session" />
                    </c:if>

                    <c:if test="${not empty errorMsg}">
                        <div class="text-danger">
                            <i class="fas fa-exclamation-circle me-2"></i>${errorMsg}
                        </div>
                        <c:remove var="errorMsg" scope="session" />
                    </c:if>

                    <form action="<%=request.getContextPath()%>/register" method="post" id="patientForm"
                        class="needs-validation" novalidate>
                        <div class="section-title">
                            <i class="fas fa-user"></i>
                            Personal Information
                        </div>

                        <div class="form-row">
                            <div class="form-group">
                                <label for="fullname" class="form-label">
                                    <i class="fas fa-user-circle"></i>Full Name
                                </label>
                                <div class="input-group">
                                    <input type="text" class="form-control" id="fullname" name="fullname"
                                        placeholder="Enter your full name" required minlength="3"
                                        maxlength="50">
                                    <i class="input-icon fas fa-user"></i>
                                    <div class="invalid-feedback">
                                        Please provide a valid name (3-50 characters).
                                    </div>
                                </div>
                            </div>

                            <div class="form-group">
                                <label for="email" class="form-label">
                                    <i class="fas fa-envelope"></i>Email Address
                                </label>
                                <div class="input-group">
                                    <input type="email" class="form-control" id="email" name="email"
                                        placeholder="Enter your email" required
                                        pattern="[a-z0-9._%+-]+@[a-z0-9.-]+\.[a-z]{2,}$">
                                    <i class="input-icon fas fa-envelope"></i>
                                    <div class="invalid-feedback">
                                        Please provide a valid email address.
                                    </div>
                                </div>
                            </div>
                        </div>

                        <div class="form-row">
                            <div class="form-group">
                                <label for="password" class="form-label">
                                    <i class="fas fa-lock"></i>Password
                                </label>
                                <div class="input-group">
                                    <input type="password" class="form-control" id="password"
                                        name="password" placeholder="Create a password" required
                                        minlength="8"
                                        pattern="^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[@$!%*?&])[A-Za-z\d@$!%*?&]{8,}$">
                                    <i class="input-icon fas fa-lock"></i>
                                    <button type="button" class="password-toggle" id="togglePassword">
                                        <i class="fas fa-eye"></i>
                                    </button>
                                    <div class="invalid-feedback">
                                        Password must be at least 8 characters with uppercase, lowercase,
                                        number, and special character.
                                    </div>
                                </div>
                                <div class="password-strength">
                                    <div class="password-strength-bar" id="passwordStrengthBar"></div>
                                </div>
                                <div class="password-strength-text" id="passwordStrengthText"></div>
                            </div>

                            <div class="form-group">
                                <label for="confirmPassword" class="form-label">
                                    <i class="fas fa-lock"></i>Confirm Password
                                </label>
                                <div class="input-group">
                                    <input type="password" class="form-control" id="confirmPassword"
                                        name="confirmPassword" placeholder="Confirm your password" required>
                                    <i class="input-icon fas fa-lock"></i>
                                    
                                    <button type="button" class="password-toggle" id="toggleConfirmPassword">
                                        <i class="fas fa-eye"></i>
                                    </button>
                                    <div class="invalid-feedback">
                                        Passwords do not match.
                                    </div>
                                </div>
                            </div>
                        </div>

                        <div class="form-row">
                            <div class="form-group">
                                <label for="dob" class="form-label">
                                    <i class="fas fa-calendar-alt"></i>Date of Birth
                                </label>
                                <div class="input-group">
                                    <input type="date" class="form-control" id="dob" name="dob" required>
                                    <i class="input-icon fas fa-calendar-alt"></i>
                                    <div class="invalid-feedback">
                                        Please provide a valid date of birth (must be at least 18 years
                                        old).
                                    </div>
                                </div>
                            </div>

                            <div class="form-group">
                                <label for="gender" class="form-label">
                                    <i class="fas fa-venus-mars"></i>Gender
                                </label>
                                <select class="form-select" id="gender" name="gender" required>
                                    <option value="" disabled selected>Select your gender</option>
                                    <option value="male">Male</option>
                                    <option value="female">Female</option>
                                    <option value="other">Other</option>
                                    <option value="prefer_not_to_say">Prefer not to say</option>
                                </select>
                                <div class="invalid-feedback">
                                    Please select a gender.
                                </div>
                            </div>
                        </div>

                        <div class="section-title">
                            <i class="fas fa-address-book"></i>
                            Contact Information
                        </div>

                        <div class="form-row">
                            <div class="form-group">
                                <label for="phone" class="form-label">
                                    <i class="fas fa-phone"></i>Phone Number
                                </label>
                                <div class="input-group">
                                    <input type="tel" class="form-control" id="phone" name="phone"
                                        placeholder="Enter your phone number" required pattern="[0-9]{10}">
                                    <i class="input-icon fas fa-phone"></i>
                                    <div class="invalid-feedback">
                                        Please provide a valid 10-digit phone number.
                                    </div>
                                </div>
                            </div>

                            <div class="form-group">
                                <label for="bloodGroup" class="form-label">
                                    <i class="fas fa-tint"></i>Blood Group
                                </label>
                                <select class="form-select" id="bloodGroup" name="bloodGroup">
                                    <option value="" selected>Select blood group</option>
                                    <option value="A+">A+</option>
                                    <option value="A-">A-</option>
                                    <option value="B+">B+</option>
                                    <option value="B-">B-</option>
                                    <option value="AB+">AB+</option>
                                    <option value="AB-">AB-</option>
                                    <option value="O+">O+</option>
                                    <option value="O-">O-</option>
                                </select>
                            </div>
                        </div>

                        <div class="form-group">
                            <label for="address" class="form-label">
                                <i class="fas fa-home"></i>Address
                            </label>
                            <div class="input-group">
                                <textarea class="form-control" id="address" name="address" rows="3"
                                    placeholder="Enter your complete address" required minlength="10"
                                    maxlength="200"></textarea>
                                <i class="input-icon fas fa-home"></i>
                                <div class="invalid-feedback">
                                    Please provide a valid address (10-200 characters).
                                </div>
                            </div>
                        </div>

                        <div class="section-title">
                            <i class="fas fa-first-aid"></i>
                            Emergency Contact
                        </div>

                        <div class="form-row">
                            <div class="form-group">
                                <label for="emergencyContactName" class="form-label">
                                    <i class="fas fa-user-friends"></i>Emergency Contact Name
                                </label>
                                <div class="input-group">
                                    <input type="text" class="form-control" id="emergencyContactName"
                                        name="emergencyContactName"
                                        placeholder="Full name of emergency contact" required minlength="3"
                                        maxlength="50">
                                    <i class="input-icon fas fa-user-friends"></i>
                                    <div class="invalid-feedback">
                                        Please provide a valid name (3-50 characters).
                                    </div>
                                </div>
                            </div>

                            <div class="form-group">
                                <label for="emergencyContactPhone" class="form-label">
                                    <i class="fas fa-phone-alt"></i>Emergency Contact Phone
                                </label>
                                <div class="input-group">
                                    <input type="tel" class="form-control" id="emergencyContactPhone"
                                        name="emergencyContactPhone"
                                        placeholder="Phone number of emergency contact" required
                                        pattern="[0-9]{10}">
                                    <i class="input-icon fas fa-phone-alt"></i>
                                    <div class="invalid-feedback">
                                        Please provide a valid 10-digit phone number.
                                    </div>
                                </div>
                            </div>
                        </div>

                        <div class="form-group">
                            <div class="form-check">
                                <input class="form-check-input" type="checkbox" id="terms" name="terms"
                                    required>
                                <label class="form-check-label" for="terms">
                                    I agree to the <a href="#" class="text-primary">Terms of Service</a> and
                                    <a href="#" class="text-primary">Privacy Policy</a>
                                </label>
                                <div class="invalid-feedback">
                                    You must agree before submitting.
                                </div>
                            </div>
                        </div>

                        <button type="submit" class="btn-signup">
                            <i class="fas fa-user-plus"></i>Create Account
                        </button>
                    </form>

                    <a href="patient_login.jsp" class="login-link">
                        <i class="fas fa-sign-in-alt me-2"></i>Already have an account? Login here
                    </a>
                </div>
            </div>
        </div>

        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
        <script>
            // Bootstrap Form Validation
            (function () {
                'use strict';

                const forms = document.querySelectorAll('.needs-validation');

                Array.from(forms).forEach(function (form) {
                    form.addEventListener('submit', function (event) {
                        if (!form.checkValidity()) {
                            event.preventDefault();
                            event.stopPropagation();
                        }

                        form.classList.add('was-validated');
                    }, false);
                });
            })();

            
            // ==== START: UPDATED JAVASCRIPT ====
            /**
             * Sets up a password visibility toggle for a given button and input field.
             * @param {string} toggleButtonId - The ID of the button element.
             * @param {string} passwordInputId - The ID of the password input element.
             */
            function setupPasswordToggle(toggleButtonId, passwordInputId) {
                const toggleButton = document.getElementById(toggleButtonId);
                const passwordInput = document.getElementById(passwordInputId);

                if (!toggleButton || !passwordInput) {
                    return;
                }

                toggleButton.addEventListener('click', function () {
                    const icon = this.querySelector('i');
                    if (passwordInput.type === 'password') {
                        passwordInput.type = 'text';
                        icon.classList.remove('fa-eye');
                        icon.classList.add('fa-eye-slash');
                    } else {
                        passwordInput.type = 'password';
                        icon.classList.remove('fa-eye-slash');
                        icon.classList.add('fa-eye');
                    }
                });
            }

            // Initialize both password toggles
            setupPasswordToggle('togglePassword', 'password');
            setupPasswordToggle('toggleConfirmPassword', 'confirmPassword');
            // ==== END: UPDATED JAVASCRIPT ====


            // Password strength indicator
            document.getElementById('password').addEventListener('input', function () {
                const password = this.value;
                const strengthBar = document.getElementById('passwordStrengthBar');
                const strengthText = document.getElementById('passwordStrengthText');

                let strength = 0;
                let text = '';
                let color = '';

                if (password.length >= 8) strength += 25;
                if (/[a-z]/.test(password)) strength += 25;
                if (/[A-Z]/.test(password)) strength += 25;
                // Updated check: one point for number OR special char
                if (/[0-9]/.test(password) || /[@$!%*?&]/.test(password)) strength += 25;


                if (strength === 0) {
                    text = '';
                    color = 'transparent';
                } else if (strength <= 25) {
                    text = 'Very Weak';
                    color = '#dc3545';
                } else if (strength <= 50) {
                    text = 'Weak';
                    color = '#fd7e14';
                } else if (strength <= 75) {
                    text = 'Medium';
                    color = '#ffc107';
                } else {
                    text = 'Strong';
                    color = '#198754';
                }

                strengthBar.style.width = strength + '%';
                strengthBar.style.backgroundColor = color;
                strengthText.textContent = text;
                strengthText.style.color = color;
            });

            // Confirm password validation
            document.getElementById('confirmPassword').addEventListener('input', function () {
                const password = document.getElementById('password').value;
                const confirmPassword = this.value;
                const form = document.getElementById('patientForm');

                if (confirmPassword !== password) {
                    this.setCustomValidity('Passwords do not match.');
                } else {
                    this.setCustomValidity('');
                }

                if (form.classList.contains('was-validated')) {
                    this.reportValidity();
                }
            });

            // Age validation for date of birth (must be at least 18 years old)
            document.getElementById('dob').addEventListener('change', function () {
                const dob = new Date(this.value);
                const today = new Date();
                const minDate = new Date(today.getFullYear() - 18, today.getMonth(), today.getDate());
                const maxDate = new Date(today.getFullYear() - 120, today.getMonth(), today.getDate());

                if (dob > minDate) {
                    this.setCustomValidity('You must be at least 18 years old.');
                } else if (dob < maxDate) {
                    this.setCustomValidity('Please enter a valid date of birth.');
                } else {
                    this.setCustomValidity('');
                }

                const form = document.getElementById('patientForm');
                if (form.classList.contains('was-validated')) {
                    this.reportValidity();
                }
            });

            // Set max date for date of birth (18 years ago)
            window.onload = function () {
                const today = new Date();
                const maxDate = new Date(today.getFullYear() - 18, today.getMonth(), today.getDate());
                document.getElementById('dob').max = maxDate.toISOString().split('T')[0];

                const minDate = new Date(today.getFullYear() - 120, today.getMonth(), today.getDate());
                document.getElementById('dob').min = minDate.toISOString().split('T')[0];
            };
        </script>
</body>

</html>