<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.sql.*, com.db.DBConnect" %>
<%@ page import="javax.servlet.http.*, javax.servlet.*" %>

<%
    Integer patientId = (Integer) session.getAttribute("patientId");

    if (patientId == null) {
        session.setAttribute("errorMsg", "Please login first to book an appointment.");
        response.sendRedirect(request.getContextPath() + "/patient/patient_login.jsp");
        return;
    }
%>

<!DOCTYPE html>
<html lang="en">

<head>
    <meta charset="UTF-8">
    <title>Book Appointment - Hospital Management System</title>
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

        .appointment-container {
            width: 100%;
            max-width: 900px;
            margin: 0 auto;
            padding-top: 100px;
        }

        .appointment-header {
            text-align: center;
            margin-bottom: 30px;
        }

        .appointment-header h1 {
            color: var(--primary);
            font-weight: 700;
            margin-bottom: 10px;
            font-size: 2.2rem;
        }

        .appointment-header p {
            color: var(--text-light);
            font-size: 1.1rem;
        }

        .appointment-card {
            background: var(--white);
            border-radius: var(--radius);
            box-shadow: var(--shadow-lg);
            overflow: hidden;
            transition: all 0.3s ease;
        }

        .appointment-card:hover {
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
            margin-bottom: 20px;
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
            padding: 12px 15px 12px 45px;
            transition: all 0.3s ease;
            font-size: 1rem;
            width: 100%;
            appearance: none;
            background-image: url("data:image/svg+xml,%3csvg xmlns='http://www.w3.org/2000/svg' fill='none' viewBox='0 0 20 20'%3e%3cpath stroke='%236b7280' stroke-linecap='round' stroke-linejoin='round' stroke-width='1.5' d='m6 8 4 4 4-4'/%3e%3c/svg%3e");
            background-position: right 15px center;
            background-repeat: no-repeat;
            background-size: 16px 12px;
        }

        .form-select:focus {
            border-color: var(--primary);
            box-shadow: 0 0 0 3px rgba(37, 99, 235, 0.1);
            outline: none;
        }

        textarea.form-control {
            padding-left: 45px;
            resize: vertical;
            min-height: 80px;
        }

        .btn-appointment {
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

        .btn-appointment:hover {
            background: linear-gradient(135deg, var(--primary-dark) 0%, var(--primary) 100%);
            transform: translateY(-2px);
            box-shadow: 0 8px 20px rgba(37, 99, 235, 0.3);
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
        .was-validated .form-select:invalid ~ .invalid-feedback {
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

            .appointment-header h1 {
                font-size: 1.8rem;
            }

            .appointment-container {
                padding-top: 20px;
            }
        }
    </style>
</head>

<body>
    <%@include file="../component/navbar.jsp" %>

    <div class="appointment-container">
        <div class="appointment-header">
            <h1><i class="fas fa-calendar-check me-2"></i>Book Appointment</h1>
            <p>Schedule your visit with our healthcare specialists</p>
        </div>

        <div class="appointment-card">
            <div class="form-section">
                <!-- Success/Error Message -->
                <% 
                   String successMsg = (String) session.getAttribute("successMsg");
                   String errorMsg = (String) session.getAttribute("errorMsg");
                   if (successMsg != null) { %>
                       <div class="text-success">
                           <i class="fas fa-check-circle me-2"></i><%= successMsg %>
                       </div>
                   <% session.removeAttribute("successMsg"); } 
                   if (errorMsg != null) { %>
                       <div class="text-danger">
                           <i class="fas fa-exclamation-circle me-2"></i><%= errorMsg %>
                       </div>
                   <% session.removeAttribute("errorMsg"); } 
                %>

                <!-- ✅ Full Appointment Form (always visible for logged-in users) -->
                <form action="<%= request.getContextPath() %>/patient/bookAppointment" method="post" class="needs-validation" novalidate>

                    <!-- Doctor Information -->
                    <div class="section-title">
                        <i class="fas fa-user-md"></i>Doctor Information
                    </div>

                    <div class="form-group">
                        <label class="form-label"><i class="fas fa-stethoscope"></i>Select Doctor</label>
                        <div class="input-group">
                            <select class="form-select" name="doctorId" required>
                                <option value="">-- Select Doctor --</option>
                                <%
                                    try (Connection con = DBConnect.getConnection()) {
                                        PreparedStatement ps = con.prepareStatement("SELECT id, fullname, specialization FROM doctor ORDER BY fullname");
                                        ResultSet rs = ps.executeQuery();
                                        while (rs.next()) {
                                %>
                                    <option value="<%= rs.getInt("id") %>">
                                        Dr. <%= rs.getString("fullname") %> - <%= rs.getString("specialization") %>
                                    </option>
                                <%
                                        }
                                    } catch (Exception e) { e.printStackTrace(); }
                                %>
                            </select>
                            <i class="input-icon fas fa-user-md"></i>
                            <div class="invalid-feedback">
                                Please select a doctor.
                            </div>
                        </div>
                    </div>

                    <!-- Appointment Details -->
                    <div class="section-title"><i class="fas fa-calendar-alt"></i>Appointment Details</div>

                    <div class="form-row">
                        <div class="form-group">
                            <label class="form-label"><i class="fas fa-calendar-day"></i>Appointment Date</label>
                            <div class="input-group">
                                <input type="date" class="form-control" name="appointmentDate" required min="<%= java.time.LocalDate.now() %>">
                                <i class="input-icon fas fa-calendar-day"></i>
                                <div class="invalid-feedback">
                                    Please select a valid appointment date.
                                </div>
                            </div>
                        </div>

                        <div class="form-group">
                            <label class="form-label"><i class="fas fa-clock"></i>Preferred Time</label>
                            <div class="input-group">
                                <select class="form-select" name="appointmentTime" required>
                                    <option value="">-- Select Time --</option>
                                    <option value="09:00">09:00 AM</option>
                                    <option value="10:00">10:00 AM</option>
                                    <option value="11:00">11:00 AM</option>
                                    <option value="12:00">12:00 PM</option>
                                    <option value="14:00">02:00 PM</option>
                                    <option value="15:00">03:00 PM</option>
                                    <option value="16:00">04:00 PM</option>
                                    <option value="17:00">05:00 PM</option>
                                </select>
                                <i class="input-icon fas fa-clock"></i>
                                <div class="invalid-feedback">
                                    Please select a preferred time.
                                </div>
                            </div>
                        </div>
                    </div>

                    <div class="form-group">
                        <label class="form-label"><i class="fas fa-file-medical-alt"></i>Reason for Visit / Symptoms</label>
                        <div class="input-group">
                            <textarea class="form-control" name="description" required minlength="10" maxlength="500" placeholder="Describe your symptoms or reason for this appointment..."></textarea>
                            <i class="input-icon fas fa-file-medical-alt"></i>
                            <div class="invalid-feedback">
                                Please provide a description (10-500 characters).
                            </div>
                        </div>
                    </div>

                    <!-- Identification -->
                    <div class="section-title"><i class="fas fa-id-card"></i>Identification Details</div>

                    <div class="form-row">
                        <div class="form-group">
                            <label class="form-label"><i class="fas fa-id-card"></i>Government ID Type</label>
                            <div class="input-group">
                                <select class="form-select" name="govIdType" required>
                                    <option value="">-- Select ID Type --</option>
                                    <option value="Aadhaar">Aadhaar Card</option>
                                    <option value="PAN">PAN Card</option>
                                    <option value="Voter ID">Voter ID</option>
                                    <option value="Driving License">Driving License</option>
                                    <option value="Passport">Passport</option>
                                </select>
                                <i class="input-icon fas fa-id-card"></i>
                                <div class="invalid-feedback">
                                    Please select an ID type.
                                </div>
                            </div>
                        </div>

                        <div class="form-group">
                            <label class="form-label"><i class="fas fa-id-card-alt"></i>Government ID Number</label>
                            <div class="input-group">
                                <input type="text" class="form-control" name="govIdNumber" required maxlength="20" placeholder="Enter your government ID number">
                                <i class="input-icon fas fa-id-card-alt"></i>
                                <div class="invalid-feedback">
                                    Please provide a valid Government ID number.
                                </div>
                            </div>
                        </div>
                    </div>

                    <!-- Insurance -->
                    <div class="section-title"><i class="fas fa-shield-alt"></i>Insurance Information</div>

                    <div class="form-row">
                        <div class="form-group">
                            <label class="form-label"><i class="fas fa-hospital-user"></i>Health Insurance / Yojana</label>
                            <div class="input-group">
                                <select class="form-select" name="insuranceProvider">
                                    <option value="">-- Select Provider / Scheme --</option>
                                    <option value="Ayushman Bharat">Ayushman Bharat</option>
                                    <option value="CGHS">CGHS</option>
                                    <option value="ESI">ESI</option>
                                    <option value="Private Insurance">Private Insurance</option>
                                    <option value="Other">Other</option>
                                    <option value="None">No Insurance</option>
                                </select>
                                <i class="input-icon fas fa-hospital-user"></i>
                            </div>
                        </div>

                        <div class="form-group">
                            <label class="form-label"><i class="fas fa-file-invoice"></i>Insurance / Yojana Number</label>
                            <div class="input-group">
                                <input type="text" class="form-control" name="insuranceNumber" maxlength="25" placeholder="Enter your insurance or yojana number">
                                <i class="input-icon fas fa-file-invoice"></i>
                            </div>
                        </div>
                    </div>

                    <div class="section-title"><i class="fas fa-info-circle"></i>Additional Information</div>
                    <div class="form-group">
                        <label class="form-label"><i class="fas fa-notes-medical"></i>Additional Notes (Optional)</label>
                        <div class="input-group">
                            <textarea class="form-control" name="additionalNotes" maxlength="300" placeholder="Any additional information you'd like to share with the doctor..."></textarea>
                            <i class="input-icon fas fa-notes-medical"></i>
                        </div>
                    </div>

                    <!-- ✅ Always show Book Appointment (only for logged-in) -->
                    <button type="submit" class="btn-appointment">
                        <i class="fas fa-calendar-plus"></i>Book Appointment
                    </button>
                </form>
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
                    }
                    
                    form.classList.add('was-validated');
                }, false);
            });
        })();

        // Set minimum date to today
        window.onload = function() {
            const today = new Date();
            const formattedDate = today.toISOString().split('T')[0];
            document.querySelector('input[name="appointmentDate"]').min = formattedDate;
            
            // Set default date to tomorrow
            const tomorrow = new Date(today);
            tomorrow.setDate(tomorrow.getDate() + 1);
            const tomorrowFormatted = tomorrow.toISOString().split('T')[0];
            document.querySelector('input[name="appointmentDate"]').value = tomorrowFormatted;
        };

        // Dynamic ID pattern based on selected ID type
        document.querySelector('select[name="govIdType"]').addEventListener('change', function() {
            const idType = this.value;
            const idNumberInput = document.querySelector('input[name="govIdNumber"]');
            
            switch(idType) {
                case 'Aadhaar':
                    idNumberInput.pattern = '[0-9]{12}';
                    idNumberInput.title = 'Aadhaar number must be 12 digits';
                    idNumberInput.placeholder = 'Enter 12-digit Aadhaar number';
                    break;
                case 'PAN':
                    idNumberInput.pattern = '[A-Z]{5}[0-9]{4}[A-Z]{1}';
                    idNumberInput.title = 'PAN must be 10 characters (5 letters, 4 digits, 1 letter)';
                    idNumberInput.placeholder = 'Enter PAN (e.g., ABCDE1234F)';
                    break;
                case 'Passport':
                    idNumberInput.pattern = '[A-Z]{1}[0-9]{7}';
                    idNumberInput.title = 'Passport number must be 1 letter followed by 7 digits';
                    idNumberInput.placeholder = 'Enter Passport number';
                    break;
                default:
                    idNumberInput.pattern = '[A-Za-z0-9]{4,20}';
                    idNumberInput.title = 'Enter a valid Government ID number (4–20 characters)';
                    idNumberInput.placeholder = 'Enter your government ID number';
            }
        });
    </script>
</body>
</html>