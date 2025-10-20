<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@page isELIgnored="false" %>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Doctor Registration - Hospital Management System</title>
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
            max-width: 900px;
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

        .form-control:focus + .input-icon,
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

        .text-success, .text-danger {
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

        .was-validated .form-control:invalid ~ .invalid-feedback,
        .was-validated .form-select:invalid ~ .invalid-feedback,
        .was-validated .form-check-input:invalid ~ .invalid-feedback {
            display: block;
        }

        /* Success Modal Styles */
        .success-modal .modal-content {
            border-radius: 15px;
            border: none;
            box-shadow: 0 10px 30px rgba(0, 0, 0, 0.2);
        }

        .success-modal .modal-header {
            border-bottom: none;
            padding: 25px 25px 0;
            justify-content: flex-end;
        }

        .success-modal .modal-body {
            padding: 15px 25px 25px;
            text-align: center;
        }

        .success-icon {
            font-size: 4rem;
            color: #28a745;
            margin-bottom: 20px;
        }

        .success-title {
            font-size: 1.5rem;
            font-weight: 600;
            color: #28a745;
            margin-bottom: 10px;
        }

        .success-message {
            color: #6c757d;
            margin-bottom: 20px;
        }

        .approval-note {
            background-color: #f8f9fa;
            border-radius: 8px;
            padding: 15px;
            margin-top: 15px;
            border-left: 4px solid #ffc107;
        }

        .approval-note i {
            color: #ffc107;
            margin-right: 8px;
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
    <%@include file="../component/navbar.jsp"%>
    <div class="signup-container">
        <div class="signup-header">
            <h1><i class="fas fa-user-md me-2"></i>Doctor Registration</h1>
            <p>Join our healthcare team and provide quality medical care</p>
        </div>

        <div class="signup-card">
            <div class="form-section">
                <!-- Success Message -->
                <c:if test="${not empty sucMsg}">
                    <div class="text-success">
                        <i class="fas fa-check-circle me-2"></i>${sucMsg}
                    </div>
                    <c:remove var="sucMsg" scope="session"/>
                </c:if>

                <!-- Error Message -->
                <c:if test="${not empty errorMsg}">
                    <div class="text-danger">
                        <i class="fas fa-exclamation-circle me-2"></i>${errorMsg}
                    </div>
                    <c:remove var="errorMsg" scope="session"/>
                </c:if>

                <form action="<%=request.getContextPath()%>/registerDoctor" method="post" id="doctorForm" class="needs-validation" novalidate>
                    <!-- Personal Information Section -->
                    <div class="section-title">
                        <i class="fas fa-user"></i>
                        Personal Information
                    </div>
                    
                    <div class="form-row">
                        <div class="form-group">
                            <label for="fullName" class="form-label">
                                <i class="fas fa-user-circle"></i>Full Name
                            </label>
                            <div class="input-group">
                                <input type="text" class="form-control" id="fullName" name="fullname" 
                                       placeholder="Enter your full name" required minlength="3" maxlength="50">
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
                                       placeholder="Enter your email" required pattern="[a-z0-9._%+-]+@[a-z0-9.-]+\.[a-z]{2,}$">
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
                                <input type="password" class="form-control" id="password" name="password" 
                                       placeholder="Create a password" required minlength="8" 
                                       pattern="^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[@$!%*?&])[A-Za-z\d@$!%*?&]{8,}$">
                                <i class="input-icon fas fa-lock"></i>
                                <button type="button" class="password-toggle" id="togglePassword">
                                    <i class="fas fa-eye"></i>
                                </button>
                                <div class="invalid-feedback">
                                    Password must be at least 8 characters with uppercase, lowercase, number, and special character.
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
                                <input type="password" class="form-control" id="confirmPassword" name="confirmPassword" 
                                       placeholder="Confirm your password" required>
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
                            <label for="qualification" class="form-label">
                                <i class="fas fa-graduation-cap"></i>Qualification
                            </label>
                            <div class="input-group">
                                <input type="text" class="form-control" id="qualification" name="qualification" 
                                       placeholder="e.g., MBBS, MD, MS" required minlength="2" maxlength="50">
                                <i class="input-icon fas fa-graduation-cap"></i>
                                <div class="invalid-feedback">
                                    Please provide a valid qualification.
                                </div>
                            </div>
                        </div>
                    </div>
                    
                    <!-- Professional Information Section -->
                    <div class="section-title">
                        <i class="fas fa-stethoscope"></i>
                        Professional Information
                    </div>
                    
                    <div class="form-row">
                        <div class="form-group">
                            <label for="specialization" class="form-label">
                                <i class="fas fa-user-md"></i>Specialization
                            </label>
                            <select class="form-select" id="specialization" name="specialization" required>
                                <option value="" disabled selected>Select your specialization</option>
                                <option value="Cardiology">Cardiology</option>
                                <option value="Dermatology">Dermatology</option>
                                <option value="Endocrinology">Endocrinology</option>
                                <option value="Gastroenterology">Gastroenterology</option>
                                <option value="Neurology">Neurology</option>
                                <option value="Oncology">Oncology</option>
                                <option value="Orthopedics">Orthopedics</option>
                                <option value="Pediatrics">Pediatrics</option>
                                <option value="Psychiatry">Psychiatry</option>
                                <option value="Radiology">Radiology</option>
                                <option value="Surgery">Surgery</option>
                                <option value="Other">Other</option>
                            </select>
                            <div class="invalid-feedback">
                                Please select a specialization.
                            </div>
                        </div>
                        
                        <div class="form-group">
                            <label for="department" class="form-label">
                                <i class="fas fa-hospital"></i>Department
                            </label>
                            <select class="form-select" id="department" name="department" required>
                                <option value="" disabled selected>Select department</option>
                                <option value="Emergency">Emergency</option>
                                <option value="ICU">ICU</option>
                                <option value="Surgery">Surgery</option>
                                <option value="Pediatrics">Pediatrics</option>
                                <option value="Cardiology">Cardiology</option>
                                <option value="Neurology">Neurology</option>
                                <option value="Orthopedics">Orthopedics</option>
                                <option value="Oncology">Oncology</option>
                                <option value="Other">Other</option>
                            </select>
                            <div class="invalid-feedback">
                                Please select a department.
                            </div>
                        </div>
                    </div>
                    
                    <div class="form-row">
                        <div class="form-group">
                            <label for="licenseNumber" class="form-label">
                                <i class="fas fa-id-card"></i>License Number
                            </label>
                            <div class="input-group">
                                <input type="text" class="form-control" id="licenseNumber" name="licenseNumber" 
                                       placeholder="Enter your medical license number" required minlength="5" maxlength="20">
                                <i class="input-icon fas fa-id-card"></i>
                                <div class="invalid-feedback">
                                    Please provide a valid license number.
                                </div>
                            </div>
                        </div>
                        
                        <div class="form-group">
                            <label for="yearsOfExperience" class="form-label">
                                <i class="fas fa-briefcase"></i>Years of Experience
                            </label>
                            <div class="input-group">
                                <input type="number" class="form-control" id="yearsOfExperience" name="yearsOfExperience" 
                                       placeholder="Years of experience" required min="0" max="50">
                                <i class="input-icon fas fa-briefcase"></i>
                                <div class="invalid-feedback">
                                    Please provide a valid number of years (0-50).
                                </div>
                            </div>
                        </div>
                    </div>
	                 <div class="form-group">
						    <label for="visitingCharge" class="form-label">
						        <i class="fas fa-money-bill-wave"></i>Consulting Fee (₹)
						    </label>
						    <div class="input-group">
						        <input type="number" class="form-control" id="visitingCharge" name="visitingCharge"
						               placeholder="Enter your consulting fee in INR" required min="0" step="0.01">
						        <i class="input-icon fas fa-money-bill-wave"></i>
						        <div class="invalid-feedback">
						            Please provide a valid consulting fee (non-negative value).
						        </div>
						    </div>
					</div>
                    
                    
                    <!-- Contact & Availability Section -->
                    <div class="section-title">
                        <i class="fas fa-address-book"></i>
                        Contact & Availability
                    </div>
                    
                    <div class="form-group">
                        <label for="clinicAddress" class="form-label">
                            <i class="fas fa-map-marker-alt"></i>Clinic/Hospital Address
                        </label>
                        <div class="input-group">
                            <textarea class="form-control" id="clinicAddress" name="clinicAddress" rows="3" 
                                      placeholder="Enter your clinic or hospital address" required minlength="10" maxlength="200"></textarea>
                            <i class="input-icon fas fa-map-marker-alt"></i>
                            <div class="invalid-feedback">
                                Please provide a valid address (10-200 characters).
                            </div>
                        </div>
                    </div>
                    
                    <div class="form-group">
                        <label for="availability" class="form-label">
                            <i class="fas fa-calendar-check"></i>Availability
                        </label>
                        <div class="input-group">
                            <input type="text" class="form-control" id="availability" name="availability" 
                                   placeholder="e.g., Mon-Fri 9am-5pm, Sat 9am-1pm" required minlength="5" maxlength="100">
                            <i class="input-icon fas fa-calendar-check"></i>
                            <div class="invalid-feedback">
                                Please provide your availability schedule.
                            </div>
                        </div>
                    </div>
                    
                    <!-- Terms and Conditions -->
                    <div class="form-group">
                        <div class="form-check">
                            <input class="form-check-input" type="checkbox" id="terms" name="terms" required>
                            <label class="form-check-label" for="terms">
                                I agree to the <a href="#" class="text-primary">Terms of Service</a> and <a href="#" class="text-primary">Privacy Policy</a>
                            </label>
                            <div class="invalid-feedback">
                                You must agree before submitting.
                            </div>
                        </div>
                    </div>
                    
                    <button type="submit" class="btn-signup">
                        <i class="fas fa-user-md"></i>Register as Doctor
                    </button>
                </form>

                <a href="doctor_login.jsp" class="login-link">
                    <i class="fas fa-sign-in-alt me-2"></i>Already have an account? Login here
                </a>
            </div>
        </div>
    </div>

    <!-- Success Modal -->
    <div class="modal fade success-modal" id="successModal" tabindex="-1" aria-labelledby="successModalLabel" aria-hidden="true" data-bs-backdrop="static" data-bs-keyboard="false">
        <div class="modal-dialog modal-dialog-centered">
            <div class="modal-content">
                <div class="modal-header">
                    <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                </div>
                <div class="modal-body">
                    <div class="success-icon">
                        <i class="fas fa-check-circle"></i>
                    </div>
                    <h3 class="success-title">Registration Successful!</h3>
                    <p class="success-message">Thank you for registering as a doctor with our hospital management system.</p>
                    <div class="approval-note">
                        <i class="fas fa-clock"></i>
                        <strong>Your account is pending approval.</strong> 
                        <p class="mb-0 mt-1">Our admin team will review your application and approve it shortly. You will receive a confirmation email once approved.</p>
                    </div>
                    <button type="button" class="btn btn-primary mt-4" data-bs-dismiss="modal">Continue</button>
                </div>
            </div>
        </div>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
    <script>
        // Bootstrap Form Validation
        (function() {
            'use strict';
            
            const forms = document.querySelectorAll('.needs-validation');
            
            Array.from(forms).forEach(function(form) {
                form.addEventListener('submit', function(event) {
                    if (!form.checkValidity()) {
                        event.preventDefault();
                        event.stopPropagation();
                    } else {
                        // If form is valid, show success modal and prevent default submission
                        event.preventDefault();
                        const successModal = new bootstrap.Modal(document.getElementById('successModal'));
                        successModal.show();
                        
                        // Optionally submit the form after showing modal
                        // Remove this if you want to handle form submission differently
                        setTimeout(() => {
                            form.submit();
                        }, 100);
                    }
                    
                    form.classList.add('was-validated');
                }, false);
            });
        })();

        // Password visibility toggle for password field
        document.getElementById('togglePassword').addEventListener('click', function() {
            const passwordInput = document.getElementById('password');
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

        // Password visibility toggle for confirm password field
        document.getElementById('toggleConfirmPassword').addEventListener('click', function() {
            const confirmPasswordInput = document.getElementById('confirmPassword');
            const icon = this.querySelector('i');
            
            if (confirmPasswordInput.type === 'password') {
                confirmPasswordInput.type = 'text';
                icon.classList.remove('fa-eye');
                icon.classList.add('fa-eye-slash');
            } else {
                confirmPasswordInput.type = 'password';
                icon.classList.remove('fa-eye-slash');
                icon.classList.add('fa-eye');
            }
        });

        // Password strength indicator
        document.getElementById('password').addEventListener('input', function() {
            const password = this.value;
            const strengthBar = document.getElementById('passwordStrengthBar');
            const strengthText = document.getElementById('passwordStrengthText');
            
            let strength = 0;
            let text = '';
            let color = '';
            
            if (password.length >= 8) strength += 25;
            if (/[a-z]/.test(password)) strength += 25;
            if (/[A-Z]/.test(password)) strength += 25;
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
        document.getElementById('confirmPassword').addEventListener('input', function() {
            const password = document.getElementById('password').value;
            const confirmPassword = this.value;
            const form = document.getElementById('doctorForm');
            
            if (confirmPassword !== password) {
                this.setCustomValidity('Passwords do not match.');
            } else {
                this.setCustomValidity('');
            }
            
            if (form.classList.contains('was-validated')) {
                this.reportValidity();
            }
        });

        // License number validation
        document.getElementById('licenseNumber').addEventListener('input', function() {
            const licenseNumber = this.value;
            
            if (licenseNumber.length < 5) {
                this.setCustomValidity('License number must be at least 5 characters.');
            } else {
                this.setCustomValidity('');
            }
            
            const form = document.getElementById('doctorForm');
            if (form.classList.contains('was-validated')) {
                this.reportValidity();
            }
        });

        // Years of experience validation
        document.getElementById('yearsOfExperience').addEventListener('input', function() {
            const years = parseInt(this.value);
            
            if (isNaN(years) || years < 0 || years > 50) {
                this.setCustomValidity('Please enter a valid number of years (0-50).');
            } else {
                this.setCustomValidity('');
            }
            
            const form = document.getElementById('doctorForm');
            if (form.classList.contains('was-validated')) {
                this.reportValidity();
            }
        });
    </script>
</body>
</html>