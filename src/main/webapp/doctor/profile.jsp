<%@ page import="com.entity.Doctor" %>
<%
    // Renamed 'doctor' to 'currentDoctor'
    Doctor currentDoctor = (Doctor) session.getAttribute("doctorObj");
    if (currentDoctor == null) {
        response.sendRedirect(request.getContextPath() + "/doctor/login.jsp"); // Added context path
        return;
    }
    // Variable needed for the sidebar's logout button
    String currentUserRole = "doctor";
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Patient Care System - Doctor Profile</title>

    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" rel="stylesheet">
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700&display=swap" rel="stylesheet">
	<link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>

</head>
<body>
    <button class="mobile-menu-toggle" id="mobileMenuToggle" style="display: none;">
        <i class="fas fa-bars"></i>
    </button>
    
    <div class="sidebar" id="sidebar">
        <div class="sidebar-sticky">
            <div class="user-section">
                <div class="user-avatar">
                    <i class="fas fa-user-md"></i>
                </div>
                <div class="user-info">
                    <% if (currentDoctor != null) { %>
                    <h6>Dr. <%= currentDoctor.getFullName() %></h6>
                    <span class="badge"><%= currentDoctor.getSpecialization() %></span>
                    <% } %>
                </div>
            </div>
            
            <div class="nav-main">
                <ul class="nav">
                    <li class="nav-item">
                        <a class="nav-link <%= request.getRequestURI().contains("dashboard.jsp") ? "active" : "" %>" 
                           href="${pageContext.request.contextPath}/doctor/dashboard.jsp">
                            <i class="fas fa-tachometer-alt"></i>
                            <span>Dashboard</span>
                        </a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link <%= request.getRequestURI().contains("profile") ? "active" : "" %>" 
                           href="${pageContext.request.contextPath}/doctor/profile">
                            <i class="fas fa-user"></i>
                            <span>My Profile</span>
                        </a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link <%= request.getRequestURI().contains("change_password") ? "active" : "" %>" 
                           href="${pageContext.request.contextPath}/doctor/change_password.jsp">
                            <i class="fas fa-key"></i>
                            <span>Change Password</span>
                        </a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link <%= request.getRequestURI().contains("appointment") ? "active" : "" %>" 
                           href="${pageContext.request.contextPath}/doctor/appointment?action=view">
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
    
<main class="main-content main-content-flush">
        <div class="profile-header">
            <div class="d-flex justify-content-between align-items-center">
                <div>
                    <h1 class="h2 mb-2">
                        <i class="fas fa-user-md me-2"></i>
                        My Profile
                    </h1>
                    <p class="mb-0 opacity-75">Manage your professional information and settings</p>
                </div>
                <div>
                    <a href="${pageContext.request.contextPath}/doctor/dashboard.jsp" class="back-link">
                        <i class="fas fa-arrow-left me-2"></i>Back to Dashboard
                    </a>
                </div>
            </div>
        </div>

        <div class="profile-body-wrapper">

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
                    <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
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
                    <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                </div>
            <%
                }
            %>

            <div class="row">
                <div class="col-lg-8">
                    <div class="card card-modern mb-4">
                        <div class="card-header-modern">
                            <i class="fas fa-edit"></i>
                            <span>Update Profile Information</span>
                        </div>
                        <div class="card-body p-4">
                            <form action="${pageContext.request.contextPath}/doctor/profile?action=update" method="post" class="needs-validation" novalidate>
                                <div class="form-section">
                                    <h3 class="section-title">Personal Information</h3>
                                    <div class="row form-row-spaced">
                                        <div class="col-md-6 form-field">
                                            <label for="fullName" class="form-label">Full Name</label>
                                            <div class="input-group">
                                                <span class="input-group-text">
                                                    <i class="fas fa-user text-primary"></i>
                                                </span>
                                                <input type="text" class="form-control" id="fullName" name="fullName" 
                                                       value="<%= currentDoctor.getFullName() %>" required>
                                            </div>
                                            <div class="invalid-feedback">Please enter your full name.</div>
                                        </div>
                                        
                                        <div class="col-md-6 form-field">
                                            <label for="email" class="form-label">Email Address</label>
                                            <div class="input-group">
                                                <span class="input-group-text">
                                                    <i class="fas fa-envelope text-primary"></i>
                                                </span>
                                                <input type="email" class="form-control" id="email" 
                                                       value="<%= currentDoctor.getEmail() %>" readonly>
                                            </div>
                                            <span class="form-helper">Email cannot be changed</span>
                                        </div>
                                    </div>

                                    <div class="row form-row-spaced">
                                        <div class="col-md-6 form-field">
                                            <label for="phone" class="form-label">Phone Number</label>
                                            <div class="input-group">
                                                <span class="input-group-text">
                                                    <i class="fas fa-phone text-primary"></i>
                                                </span>
                                                <input type="tel" class="form-control" id="phone" name="phone" 
                                                       value="<%= currentDoctor.getPhone() != null ? currentDoctor.getPhone() : "" %>" required>
                                            </div>
                                            <div class="invalid-feedback">Please enter your phone number.</div>
                                        </div>
                                        
                                        <div class="col-md-6 form-field">
                                            <label for="specialization" class="form-label">Specialization</label>
                                            <div class="input-group">
                                                <span class="input-group-text">
                                                    <i class="fas fa-stethoscope text-primary"></i>
                                                </span>
                                                <select class="form-select" id="specialization" name="specialization" required>
                                                    <option value="">Select Specialization</option>
                                                    <option value="Cardiology" <%= "Cardiology".equals(currentDoctor.getSpecialization()) ? "selected" : "" %>>Cardiology</option>
                                                    <option value="Neurology" <%= "Neurology".equals(currentDoctor.getSpecialization()) ? "selected" : "" %>>Neurology</option>
                                                    <option value="Pediatrics" <%= "Pediatrics".equals(currentDoctor.getSpecialization()) ? "selected" : "" %>>Pediatrics</option>
                                                    <option value="Dermatology" <%= "Dermatology".equals(currentDoctor.getSpecialization()) ? "selected" : "" %>>Dermatology</option>
                                                    <option value="Orthopedics" <%= "Orthopedics".equals(currentDoctor.getSpecialization()) ? "selected" : "" %>>Orthopedics</option>
                                                    <option value="Gynecology" <%= "Gynecology".equals(currentDoctor.getSpecialization()) ? "selected" : "" %>>Gynecology</option>
                                                    <option value="Psychiatry" <%= "Psychiatry".equals(currentDoctor.getSpecialization()) ? "selected" : "" %>>Psychiatry</option>
                                                    <option value="Dentistry" <%= "Dentistry".equals(currentDoctor.getSpecialization()) ? "selected" : "" %>>Dentistry</option>
                                                    <option value="Ophthalmology" <%= "Ophthalmology".equals(currentDoctor.getSpecialization()) ? "selected" : "" %>>Ophthalmology</option>
                                                    <option value="General Medicine" <%= "General Medicine".equals(currentDoctor.getSpecialization()) ? "selected" : "" %>>General Medicine</option>
                                                </select>
                                            </div>
                                            <div class="invalid-feedback">Please select your specialization.</div>
                                        </div>
                                    </div>
                                </div>

                                <div class="form-section">
                                    <h3 class="section-title">Professional Information</h3>
                                    <div class="row form-row-spaced">
                                        <div class="col-md-6 form-field">
                                            <label for="department" class="form-label">Department</label>
                                            <div class="input-group">
                                                <span class="input-group-text">
                                                    <i class="fas fa-building text-primary"></i>
                                                </span>
                                                <input type="text" class="form-control" id="department" name="department"
                                                       value="<%= currentDoctor.getDepartment() != null ? currentDoctor.getDepartment() : "" %>" required>
                                            </div>
                                            <div class="invalid-feedback">Please enter your department.</div>
                                        </div>
                                        
                                        <div class="col-md-6 form-field">
                                            <label for="qualification" class="form-label">Qualifications</label>
                                            <div class="input-group">
                                                <span class="input-group-text">
                                                    <i class="fas fa-graduation-cap text-primary"></i>
                                                </span>
                                                <input type="text" class="form-control" id="qualification" name="qualification"
                                                       value="<%= currentDoctor.getQualification() != null ? currentDoctor.getQualification() : "" %>" required>
                                            </div>
                                            <div class="invalid-feedback">Please enter your qualifications.</div>
                                        </div>
                                    </div>

                                    <div class="row form-row-spaced">
                                        <div class="col-md-6 form-field">
                                            <label for="experience" class="form-label">Experience (Years)</label>
                                            <div class="input-group">
                                                <span class="input-group-text">
                                                    <i class="fas fa-briefcase text-primary"></i>
                                                </span>
                                                <input type="number" class="form-control" id="experience" name="experience"
                                                       value="<%= currentDoctor.getExperience() %>" required min="0" max="50">
                                            </div>
                                            <div class="invalid-feedback">Please enter your experience in years.</div>
                                        </div>
                                        
                                        <div class="col-md-6 form-field">
                                            <label for="visitingCharge" class="form-label">Visiting Charge</label>
                                            <div class="input-group">
                                                <span class="input-group-text">
                                                    <i class="fa-solid fa-inr"></i>
                                                </span>
                                                <input type="number" class="form-control" id="visitingCharge" name="visitingCharge"
                                                       value="<%= currentDoctor.getVisitingCharge() %>" required min="0" step="0.01">
                                            </div>
                                            <div class="invalid-feedback">Please enter your visiting charge.</div>
                                        </div>
                                    </div>

                                    <div class="form-field">
                                        <div class="form-check form-switch ps-0 d-flex align-items-center">
                                            <div class="me-3">
                                                <input class="form-check-input" type="checkbox" id="availability" name="availability"
                                                       <%= currentDoctor.isAvailability() ? "checked" : "" %>>
                                            </div>
                                            <label class="form-check-label fw-medium" for="availability">
                                                Available for appointments
                                            </label>
                                        </div>
                                        <span class="form-helper">When turned off, patients won't be able to book appointments with you.</span>
                                    </div>
                                </div>

                                <div class="form-actions">
                                    <div class="d-grid">
                                        <button type="submit" class="btn btn-primary-modern btn-modern py-2">
                                            <i class="fas fa-save me-2"></i>Update Profile
                                        </button>
                                    </div>
                                </div>
                            </form>
                        </div>
                    </div>
                </div>

                <div class="col-lg-4">
                    <div class="card card-modern mb-4">
                        <div class="card-header-modern">
                            <i class="fas fa-info-circle"></i>
                            <span>Profile Summary</span>
                        </div>
                        <div class="card-body p-4">
                            <div class="text-center mb-4">
                                <div class="profile-avatar">
                                    <i class="fas fa-user-md"></i>
                                </div>
                                <h4 class="fw-bold mb-1">Dr. <%= currentDoctor.getFullName() %></h4>
                                <p class="text-muted mb-3"><%= currentDoctor.getSpecialization() %></p>
                                <span class="status-badge status-active">
                                    <i class="fas fa-circle me-1 small"></i> 
                                    <%= currentDoctor.isAvailability() ? "Available" : "Not Available" %>
                                </span>
                            </div>
                            
                            <div class="mb-4">
                                <div class="info-item">
                                    <div class="info-icon">
                                        <i class="fas fa-envelope"></i>
                                    </div>
                                    <div class="flex-grow-1">
                                        <div class="fw-medium">Email</div>
                                        <div class="text-muted"><%= currentDoctor.getEmail() %></div>
                                    </div>
                                </div>
                                <div class="info-item">
                                    <div class="info-icon">
                                        <i class="fas fa-phone"></i>
                                    </div>
                                    <div class="flex-grow-1">
                                        <div class="fw-medium">Phone</div>
                                        <div class="text-muted"><%= currentDoctor.getPhone() != null ? currentDoctor.getPhone() : "Not set" %></div>
                                    </div>
                                </div>
                                <div class="info-item">
                                    <div class="info-icon">
                                        <i class="fas fa-building"></i>
                                    </div>
                                    <div class="flex-grow-1">
                                        <div class="fw-medium">Department</div>
                                        <div class="text-muted"><%= currentDoctor.getDepartment() != null ? currentDoctor.getDepartment() : "Not set" %></div>
                                    </div>
                                </div>
                                <div class="info-item">
                                    <div class="info-icon">
                                        <i class="fas fa-briefcase"></i>
                                    </div>
                                    <div class="flex-grow-1">
                                        <div class="fw-medium">Experience</div>
                                        <div class="text-muted"><%= currentDoctor.getExperience() %> years</div>
                                    </div>
                                </div>
                                <div class="info-item">
                                    <div class="info-icon">
                                        <i class="fas fa-calendar"></i>
                                    </div>
                                    <div class="flex-grow-1">
                                        <div class="fw-medium">Member Since</div>
<div class="text-muted"><%= currentDoctor.getCreatedAt() != null ? currentDoctor.getCreatedAt().toString().split(" ")[0] : "N/A" %></div>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>

                    <div class="card card-modern">
                        <div class="card-header-modern">
                            <i class="fas fa-link"></i>
                            <span>Quick Actions</span>
                        </div>
                        <div class="card-body p-4">
                            <a href="${pageContext.request.contextPath}/doctor/change_password.jsp" class="quick-link">
                                <i class="fas fa-key"></i>
                                <span>Change Password</span>
                            </a>
                            <a href="${pageContext.request.contextPath}/doctor/appointment?action=view" class="quick-link">
                                <i class="fas fa-list"></i>
                                <span>View Appointments</span>
                            </a>
                            <a href="${pageContext.request.contextPath}/doctor/dashboard.jsp" class="quick-link">
                                <i class="fas fa-tachometer-alt"></i>
                                <span>Dashboard</span>
                            </a>
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