<%@ page import="com.entity.Patient" %>
<%@ page import="com.dao.DoctorDao" %>
<%@ page import="com.entity.Doctor" %>
<%@ page import="java.util.List" %>
<%
    // Use unique variable name
    Patient currentPatient = (Patient) session.getAttribute("patientObj");
    if (currentPatient == null) {
        response.sendRedirect(request.getContextPath() + "/patient/login.jsp");
        return;
    }
    
    DoctorDao doctorDao = new DoctorDao();
    List<Doctor> doctors = doctorDao.getAllDoctors();
    
    // This variable is needed for the sidebar's logout button
    String currentUserRole = "patient";
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Patient Care System - Book Appointment</title>
    
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" rel="stylesheet">
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>

    
</head>
<body>
    <button class="mobile-menu-toggle" id="mobileMenuToggle">
        <i class="fas fa-bars"></i>
    </button>
    
    <div class="sidebar" id="sidebar">
        <div class="sidebar-sticky">
            <div class="user-section">
                <div class="user-avatar">
                    <i class="fas fa-user-circle"></i>
                </div>
                <div class="user-info">
                    <% if (currentPatient != null) { %>
                    <h6><%= currentPatient.getFullName() %></h6>
                    <span class="badge">Patient</span>
                    <% } %>
                </div>
            </div>
            
            <div class="nav-main">
                <ul class="nav">
                    <li class="nav-item">
                        <a class="nav-link" 
                           href="${pageContext.request.contextPath}/patient/dashboard.jsp">
                            <i class="fas fa-tachometer-alt"></i>
                            <span>Dashboard</span>
                        </a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link" 
                           href="${pageContext.request.contextPath}/patient/profile">
                            <i class="fas fa-user"></i>
                            <span>My Profile</span>
                        </a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link" 
                           href="${pageContext.request.contextPath}/patient/change_password.jsp">
                            <i class="fas fa-key"></i>
                            <span>Change Password</span>
                        </a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link active" 
                           href="${pageContext.request.contextPath}/patient/appointment?action=book">
                            <i class="fas fa-calendar-plus"></i>
                            <span>Book Appointment</span>
                        </a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link" 
                           href="${pageContext.request.contextPath}/patient/appointment?action=view">
                            <i class="fas fa-list-alt"></i>
                            <span>My Appointments</span>
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
                        <a class="nav-link nav-link-logout" href="${pageContext.request.contextPath}/<%= currentUserRole %>/auth?action=logout">
                            <i class="fas fa-sign-out-alt"></i>
                            <span>Logout</span>
                        </a>
                    </li>
                 </ul>
            </div>
        </div>
    </div>
    
    <main class="main-content">
        <div class="page-header">
            <h1 class="page-title">
                <i class="fas fa-calendar-plus"></i>
                Book New Appointment
            </h1>
            <a href="${pageContext.request.contextPath}/patient/dashboard.jsp" class="back-link">
                <i class="fas fa-arrow-left me-2"></i>Back to Dashboard
            </a>
        </div>

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
                <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
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
                <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
            </div>
        <%
            }
        %>

        <div class="row justify-content-center">
            <div class="col-lg-8">
                <div class="card">
                    <div class="card-header">
                        <h2 class="card-title">
                            <i class="fas fa-calendar-check"></i>
                            Appointment Details
                        </h2>
                    </div>
                    <div class="card-body">
                        <form action="${pageContext.request.contextPath}/patient/appointment?action=book" method="post" class="needs-validation" novalidate>
                            <div class="row mb-3">
                                <div class="col-md-6">
                                    <label for="doctorId" class="form-label">Select Doctor</label>
                                    <div class="input-group">
                                        <span class="input-group-text">
                                            <i class="fas fa-user-md text-primary"></i>
                                        </span>
                                        <select class="form-select" id="doctorId" name="doctorId" required>
                                            <option value="">Choose a Doctor...</option>
                                            <%
                                                for (Doctor doctor : doctors) {
                                                    if (doctor.isAvailability()) {
                                            %>
                                                <option value="<%= doctor.getId() %>">
                                                    Dr. <%= doctor.getFullName() %> - <%= doctor.getSpecialization() %>
                                                </option>
                                            <%
                                                    }
                                                }
                                            %>
                                        </select>
                                    </div>
                                    <div class="invalid-feedback">Please select a doctor.</div>
                                </div>
                                
                                <div class="col-md-6">
                                    <label for="appointmentType" class="form-label">Appointment Type</label>
                                    <div class="input-group">
                                        <span class="input-group-text">
                                            <i class="fas fa-laptop-medical text-primary"></i>
                                        </span>
                                        <select class="form-select" id="appointmentType" name="appointmentType" required>
                                            <option value="">Select Type</option>
                                            <option value="In-person">In-person Visit</option>
                                            <option value="Online">Online Consultation</option>
                                        </select>
                                    </div>
                                    <div class="invalid-feedback">Please select appointment type.</div>
                                </div>
                            </div>

                            <div class="row mb-3">
                                <div class="col-md-6">
                                    <label for="appointmentDate" class="form-label">Appointment Date</label>
                                    <div class="input-group">
                                        <span class="input-group-text">
                                            <i class="fas fa-calendar-day text-primary"></i>
                                        </span>
                                        <input type="date" class="form-control" id="appointmentDate" name="appointmentDate" required>
                                    </div>
                                    <div class="invalid-feedback">Please select a valid future date.</div>
                                </div>
                                
                                <div class="col-md-6">
                                    <label for="appointmentTime" class="form-label">Appointment Time</label>
                                    <div class="input-group">
                                        <span class="input-group-text">
                                            <i class="fas fa-clock text-primary"></i>
                                        </span>
                                        <input type="time" class="form-control" id="appointmentTime" name="appointmentTime" required>
                                    </div>
                                    <div class="invalid-feedback">Please select a valid future time.</div>
                                </div>
                            </div>

                            <div class="mb-3">
                                <label for="reason" class="form-label">Reason for Visit</label>
                                <div class="input-group">
                                    <span class="input-group-text align-items-start pt-3">
                                        <i class="fas fa-stethoscope text-primary"></i>
                                    </span>
                                    <textarea class="form-control" id="reason" name="reason" rows="3" required 
                                              placeholder="Please describe the reason for your appointment"></textarea>
                                </div>
                                <div class="invalid-feedback">Please provide reason for the appointment.</div>
                            </div>

                            <div class="mb-4">
                                <label for="notes" class="form-label">Additional Notes</label>
                                <div class="input-group">
                                    <span class="input-group-text align-items-start pt-3">
                                        <i class="fas fa-notes-medical text-primary"></i>
                                    </span>
                                    <textarea class="form-control" id="notes" name="notes" rows="3" 
                                              placeholder="Any additional information for the doctor (optional)"></textarea>
                                </div>
                            </div>

                            <div class="d-grid gap-2 d-md-flex justify-content-md-end">
                                <a href="${pageContext.request.contextPath}/patient/dashboard.jsp" class="btn btn-secondary me-md-2">
                                    <i class="fas fa-times me-2"></i>Cancel
                                </a>
                                <button type="submit" class="btn btn-primary">
                                    <i class="fas fa-calendar-plus me-2"></i>Book Appointment
                                </button>
                            </div>
                        </form>
                    </div>
                </div>

                <div class="card mt-4">
                    <div class="card-header">
                        <h2 class="card-title">
                            <i class="fas fa-user-md"></i>
                            Available Doctors
                        </h2>
                    </div>
                    <div class="card-body">
                        <div class="row">
                            <%
                                for (Doctor doctor : doctors) {
                                    if (doctor.isAvailability()) {
                            %>
                            <div class="col-md-6 mb-3">
                                <div class="doctor-card">
                                    <div class="doctor-name">Dr. <%= doctor.getFullName() %></div>
                                    <div class="doctor-specialty"><%= doctor.getSpecialization() %></div>
                                    <div class="doctor-detail">
                                        <i class="fas fa-building"></i>
                                        <span><%= doctor.getDepartment() %></span>
                                    </div>
                                    <div class="doctor-detail">
                                        <i class="fas fa-graduation-cap"></i>
                                        <span><%= doctor.getQualification() %></span>
                                    </div>
                                    <div class="doctor-detail">
                                        <i class="fas fa-clock"></i>
                                        <span><%= doctor.getExperience() %> years experience</span>
                                    </div>
                                    <div class="doctor-fee">
                                        <i class="fas fa-dollar-sign"></i>
                                        Consultation Fee: $<%= doctor.getVisitingCharge() %>
                                    </div>
                                </div>
                            </div>
                            <%
                                    }
                                }
                            %>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </main>

    <script>
        document.addEventListener('DOMContentLoaded', function() {
            const mobileMenuToggle = document.getElementById('mobileMenuToggle');
            const sidebar = document.getElementById('sidebar');
            
            function checkScreenSize() {
                if (window.innerWidth <= 768) {
                    mobileMenuToggle.style.display = 'flex';
                    sidebar.classList.remove('mobile-open');
                } else {
                    mobileMenuToggle.style.display = 'none';
                    sidebar.classList.remove('mobile-open');
                }
            }
            
            checkScreenSize();
            window.addEventListener('resize', checkScreenSize);
            
            mobileMenuToggle.addEventListener('click', function() {
                sidebar.classList.toggle('mobile-open');
            });
            
            const navLinks = document.querySelectorAll('.nav-link');
            navLinks.forEach(link => {
                link.addEventListener('click', function() {
                    if (window.innerWidth <= 768) {
                        sidebar.classList.remove('mobile-open');
                    }
                });
            });
        });
    </script>
    
    <script>
        document.addEventListener('DOMContentLoaded', function() {
            const forms = document.querySelectorAll('.needs-validation');
            const dateInput = document.getElementById('appointmentDate');
            const timeInput = document.getElementById('appointmentTime');
            
            // Set min date to today
            if (dateInput) {
                const today = new Date().toISOString().split('T')[0];
                dateInput.setAttribute('min', today);
            }

            // Function to update min time
            function updateMinTime() {
                if (dateInput && timeInput) {
                    const selectedDate = dateInput.value;
                    const today = new Date().toISOString().split('T')[0];
                    
                    if (selectedDate === today) {
                        const now = new Date();
                        const currentTime = now.getHours().toString().padStart(2, '0') + ':' + now.getMinutes().toString().padStart(2, '0');
                        timeInput.setAttribute('min', currentTime);
                    } else {
                        // If it's a future date, remove min time constraint
                        timeInput.removeAttribute('min');
                    }
                }
            }

            // Initial check
            updateMinTime();

            // Update min time whenever the date changes
            if (dateInput) {
                dateInput.addEventListener('change', updateMinTime);
            }
            
            // Bootstrap validation
            Array.from(forms).forEach(form => {
                form.addEventListener('submit', function(event) {
                    if (!form.checkValidity()) {
                        event.preventDefault();
                        event.stopPropagation();
                    }
                    form.classList.add('was-validated');
                }, false);
            });

            // Real-time validation for date and time
            if (dateInput) {
                dateInput.addEventListener('change', function() {
                    const selectedDate = new Date(this.value);
                    const today = new Date();
                    today.setHours(0, 0, 0, 0);
                    
                    if (selectedDate < today) {
                        this.setCustomValidity('Please select a future date');
                    } else {
                        this.setCustomValidity('');
                    }
                });
            }

            if (timeInput && dateInput) {
                timeInput.addEventListener('change', function() {
                    const today = new Date().toISOString().split('T')[0];
                    
                    if (dateInput.value === today) {
                        const selectedTime = this.value;
                        const now = new Date();
                        const currentTime = now.getHours().toString().padStart(2, '0') + ':' + now.getMinutes().toString().padStart(2, '0');
                        
                        if (selectedTime < currentTime) {
                            this.setCustomValidity('Please select a future time');
                        } else {
                            this.setCustomValidity('');
                        }
                    } else {
                        this.setCustomValidity('');
                    }
                });
            }
        });
    </script>
</body>
</html>