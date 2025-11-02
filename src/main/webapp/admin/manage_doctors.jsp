<%@ page import="com.entity.Admin" %>
<%@ page import="com.dao.DoctorDao" %>
<%@ page import="com.entity.Doctor" %>
<%@ page import="java.util.List" %>
<%
    Admin currentAdmin = (Admin) session.getAttribute("adminObj");
    if (currentAdmin == null) {
        response.sendRedirect(request.getContextPath() + "/admin/login.jsp");
        return;
    }

    DoctorDao doctorDao = new DoctorDao();
    List<Doctor> doctors = doctorDao.getAllDoctors();

    String currentUserRole = "admin";
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Patient Care System - Manage Doctors</title>

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
                        <a class="nav-link" href="${pageContext.request.contextPath}/admin/profile.jsp">
                            <i class="fas fa-user"></i>
                            <span>My Profile</span>
                        </a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link active" href="${pageContext.request.contextPath}/admin/management?action=view&type=doctors">
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
            <div class="d-flex justify-content-between align-items-center flex-wrap">
                <div class="mb-2 mb-md-0">
                    <h1 class="h2 mb-2">
                        <i class="fas fa-user-md me-2"></i>
                        Manage Doctors
                    </h1>
                    <p class="mb-0 opacity-75">View and manage all healthcare professionals</p>
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
                String successMsg = (String) session.getAttribute("successMsg");
                String errorMsg = (String) session.getAttribute("errorMsg");
                
                if (successMsg != null) {
                    session.removeAttribute("successMsg");
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
                    session.removeAttribute("errorMsg");
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

            <%-- Stats Cards --%>
            <div class="row mb-4">
                <div class="col-xl-3 col-md-6 mb-4">
                    <div class="stats-card stats-card-primary">
                        <h4 class="mb-1"><%= doctors.size() %></h4>
                        <small>Total Doctors</small>
                    </div>
                </div>
                <div class="col-xl-3 col-md-6 mb-4">
                    <div class="stats-card stats-card-success">
                        <h4 class="mb-1"><%= doctors.stream().filter(Doctor::isApproved).count() %></h4>
                        <small>Approved</small>
                    </div>
                </div>
                <div class="col-xl-3 col-md-6 mb-4">
                    <div class="stats-card stats-card-warning">
                        <h4 class="mb-1"><%= doctors.stream().filter(d -> !d.isApproved()).count() %></h4>
                        <small>Pending Approval</small>
                    </div>
                </div>
                <div class="col-xl-3 col-md-6 mb-4">
                    <div class="stats-card stats-card-info">
                        <h4 class="mb-1"><%= doctors.stream().filter(Doctor::isAvailability).count() %></h4>
                        <small>Available</small>
                    </div>
                </div>
            </div>

            <%-- Doctors Table Card --%>
            <div class="card card-modern">
                <div class="card-header-modern card-header-flex">
                    <div class="d-flex align-items-center">
                        <i class="fas fa-list"></i>
                        <span class="ms-2">Doctors List</span>
                        <span class="badge bg-primary ms-3"><%= doctors.size() %> Total</span>
                    </div>
                    <div class="search-container">
                        <div class="input-group search-input">
                            <span class="input-group-text">
                                <i class="fas fa-search"></i>
                            </span>
                            <input type="text" class="form-control" id="doctorSearchInput" placeholder="Search doctors...">
                        </div>
                        <button type="button" class="btn btn-primary-modern" data-bs-toggle="modal" data-bs-target="#addDoctorModal">
                            <i class="fas fa-plus me-2"></i>Add New Doctor
                        </button>
                    </div>
                </div>
                <div class="card-body p-4">
                    <%
                        if (doctors.isEmpty()) {
                    %>
                        <div class="empty-state">
                            <i class="fas fa-user-md"></i>
                            <h4 class="text-muted">No Doctors Found</h4>
                            <p class="text-muted mb-4">No doctors have been registered yet.</p>
                            <button type="button" class="btn btn-primary-modern btn-lg" data-bs-toggle="modal" data-bs-target="#addDoctorModal">
                                <i class="fas fa-plus me-2"></i>Add First Doctor
                            </button>
                        </div>
                    <%
                        } else {
                    %>
                        <div class="table-responsive">
                            <table class="table table-hover" id="doctorsTable">
                                <thead>
                                    <tr>
                                        <th>Doctor Info</th>
                                        <th>Specialization</th>
                                        <th>Department</th>
                                        <th>Experience</th>
                                        <th>Fee</th>
                                        <th>Status</th>
                                        <th>Actions</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <%
                                        for (Doctor doctor : doctors) {
                                    %>
                                        <tr>
                                            <td>
                                                <div class="d-flex align-items-center">
                                                    <div class="icon-box icon-primary me-3">
                                                        <i class="fas fa-user-md"></i>
                                                    </div>
                                                    <div>
                                                        <strong>Dr. <%= doctor.getFullName() %></strong><br>
                                                        <small class="text-muted">
                                                            <i class="fas fa-envelope me-1"></i><%= doctor.getEmail() %>
                                                        </small><br>
                                                        <small class="text-muted">
                                                            <i class="fas fa-phone me-1"></i><%= doctor.getPhone() != null ? doctor.getPhone() : "N/A" %>
                                                        </small>
                                                    </div>
                                                </div>
                                            </td>
                                            <td>
                                                <span class="badge badge-info">
                                                    <i class="fas fa-stethoscope me-1"></i>
                                                    <%= doctor.getSpecialization() %>
                                                </span>
                                            </td>
                                            <td>
                                                <span class="badge bg-light text-dark">
                                                    <i class="fas fa-building me-1"></i>
                                                    <%= doctor.getDepartment() %>
                                                </span>
                                            </td>
                                            <td>
                                                <strong><%= doctor.getExperience() %> years</strong>
                                            </td>
                                            <td>
                                                <strong class="text-success"><span>&#8377;</span><%= doctor.getVisitingCharge() %></strong>
                                            </td>
                                            <td>
                                                <div class="status-indicator">
                                                    <% if (doctor.isApproved()) { %>
                                                        <span class="badge <%= doctor.isAvailability() ? "badge-success" : "badge-danger" %>">
                                                            <i class="fas fa-circle me-1"></i>
                                                            <%= doctor.isAvailability() ? "Available" : "Not Available" %>
                                                        </span>
                                                        <small class="text-success fw-bold">Approved</small>
                                                    <% } else { %>
                                                        <span class="badge badge-warning">
                                                            <i class="fas fa-exclamation-triangle me-1"></i>Pending
                                                        </span>
                                                    <% } %>
                                                </div>
                                            </td>
                                            <td>
                                                <div class="action-buttons">
                                                    <button type="button" class="btn btn-sm btn-outline-primary"
                                                            data-bs-toggle="modal" data-bs-target="#viewDoctorModal<%= doctor.getId() %>"
                                                            title="View Details">
                                                        <i class="fas fa-eye"></i>
                                                    </button>
                                                    
                                                    <button type="button" class="btn btn-sm btn-outline-warning"
                                                            data-bs-toggle="modal" data-bs-target="#editDoctorModal<%= doctor.getId() %>"
                                                            title="Edit Doctor">
                                                        <i class="fas fa-edit"></i>
                                                    </button>
                                                    
                                                    <% if (!doctor.isApproved()) { %>
                                                        <button type="button" class="btn btn-sm btn-success"
                                                                data-bs-toggle="modal"
                                                                data-bs-target="#approveModal<%= doctor.getId() %>"
                                                                title="Approve Doctor">
                                                            <i class="fas fa-check"></i>
                                                        </button>
                                                    <% } %>

                                                    <button type="button" class="btn btn-sm btn-outline-danger"
                                                            data-bs-toggle="modal" data-bs-target="#deleteDoctorModal<%= doctor.getId() %>"
                                                            title="Delete Doctor">
                                                        <i class="fas fa-trash"></i>
                                                    </button>
                                                </div>
                                            </td>
                                        </tr>
                                    <%
                                        }
                                    %>
                                </tbody>
                            </table>
                        </div>
                    <%
                        }
                    %>
                </div>
            </div>
        </div>
    </main>

    <%-- Modals --%>
    <%
        for (Doctor doctor : doctors) {
    %>
        <%-- View Doctor Modal --%>
        <div class="modal fade" id="viewDoctorModal<%= doctor.getId() %>" tabindex="-1" aria-labelledby="viewDoctorModalLabel<%= doctor.getId() %>" aria-hidden="true">
            <div class="modal-dialog modal-dialog-centered modal-lg">
                <div class="modal-content">
                    <div class="modal-header">
                        <h3 class="modal-title">
                            <i class="fas fa-user-md text-primary me-2"></i>
                            Doctor Details
                        </h3>
                        <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                    </div>
                    <div class="modal-body">
                        <div class="doctor-details">
                            <div class="detail-section">
                                <h5><i class="fas fa-info-circle"></i> Basic Information</h5>
                                <div class="detail-item">
                                    <span class="detail-label">Full Name:</span>
                                    <span class="detail-value">Dr. <%= doctor.getFullName() %></span>
                                </div>
                                <div class="detail-item">
                                    <span class="detail-label">Email:</span>
                                    <span class="detail-value"><%= doctor.getEmail() %></span>
                                </div>
                                <div class="detail-item">
                                    <span class="detail-label">Phone:</span>
                                    <span class="detail-value"><%= doctor.getPhone() != null ? doctor.getPhone() : "N/A" %></span>
                                </div>
                                <div class="detail-item">
                                    <span class="detail-label">Approval Status:</span>
                                    <span class="detail-value">
                                        <% if (doctor.isApproved()) { %>
                                            <span class="badge badge-success">Approved</span>
                                        <% } else { %>
                                            <span class="badge badge-warning">Pending Approval</span>
                                        <% } %>
                                    </span>
                                </div>
                            </div>
                            
                            <div class="detail-section">
                                <h5><i class="fas fa-briefcase-medical"></i> Professional Information</h5>
                                <div class="detail-item">
                                    <span class="detail-label">Specialization:</span>
                                    <span class="detail-value"><%= doctor.getSpecialization() %></span>
                                </div>
                                <div class="detail-item">
                                    <span class="detail-label">Department:</span>
                                    <span class="detail-value"><%= doctor.getDepartment() %></span>
                                </div>
                                <div class="detail-item">
                                    <span class="detail-label">Qualification:</span>
                                    <span class="detail-value"><%= doctor.getQualification() %></span>
                                </div>
                                <div class="detail-item">
                                    <span class="detail-label">Experience:</span>
                                    <span class="detail-value"><%= doctor.getExperience() %> years</span>
                                </div>
                            </div>
                            
                            <div class="detail-section">
                                <h5><i class="fa-solid fa-indian-rupee-sign"></i> Practice Information</h5>
                                <div class="detail-item">
                                    <span class="detail-label">Visiting Charge:</span>
                                    <span class="detail-value text-success"><span>&#8377;</span><%= doctor.getVisitingCharge() %></span>
                                </div>
                                <div class="detail-item">
                                    <span class="detail-label">Availability:</span>
                                    <span class="detail-value">
                                        <span class="badge <%= doctor.isAvailability() ? "badge-success" : "badge-danger" %>">
                                            <i class="fas fa-circle me-1"></i>
                                            <%= doctor.isAvailability() ? "Available" : "Not Available" %>
                                        </span>
                                    </span>
                                </div>
                            </div>
                        </div>
                    </div>
                    <div class="modal-footer">
                        <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Close</button>
                    </div>
                </div>
            </div>
        </div>

        <%-- Edit Doctor Modal --%>
        <div class="modal fade" id="editDoctorModal<%= doctor.getId() %>" tabindex="-1" aria-labelledby="editDoctorModalLabel<%= doctor.getId() %>" aria-hidden="true">
            <div class="modal-dialog modal-dialog-centered modal-lg">
                <div class="modal-content">
                    <div class="modal-header">
                        <h3 class="modal-title">
                            <i class="fas fa-edit text-primary me-2"></i>
                            Edit Doctor Details
                        </h3>
                        <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                    </div>
                    <form action="${pageContext.request.contextPath}/admin/management?action=update&type=doctor" method="post" class="needs-validation" novalidate>
                        <input type="hidden" name="doctorId" value="<%= doctor.getId() %>">
                        <input type="hidden" name="isApproved" value="<%= doctor.isApproved() %>"> 
                        <div class="modal-body">
                            <div class="form-section">
                                <h4 class="section-title">Personal Information</h4>
                                <div class="row form-row-spaced">
                                    <div class="col-md-6">
                                        <label class="form-label" for="editFullName<%= doctor.getId() %>">Full Name</label>
                                        <div class="input-group">
                                            <span class="input-group-text">
                                                <i class="fas fa-user"></i>
                                            </span>
                                            <input type="text" class="form-control" id="editFullName<%= doctor.getId() %>" name="fullName"
                                                   value="<%= doctor.getFullName() %>" required>
                                        </div>
                                         <div class="invalid-feedback">Please enter doctor's name.</div>
                                    </div>
                                    <div class="col-md-6">
                                        <label class="form-label" for="editPhone<%= doctor.getId() %>">Phone</label>
                                        <div class="input-group">
                                            <span class="input-group-text">
                                                <i class="fas fa-phone"></i>
                                            </span>
                                            <input type="tel" class="form-control" id="editPhone<%= doctor.getId() %>" name="phone"
                                                   value="<%= doctor.getPhone() != null ? doctor.getPhone() : "" %>" required>
                                        </div>
                                         <div class="invalid-feedback">Please enter phone number.</div>
                                    </div>
                                </div>
                            </div>
                            
                            <div class="form-section">
                                <h4 class="section-title">Professional Information</h4>
                                <div class="row form-row-spaced">
                                    <div class="col-md-6">
                                        <label class="form-label" for="editSpecialization<%= doctor.getId() %>">Specialization</label>
                                        <div class="input-group">
                                            <span class="input-group-text">
                                                <i class="fas fa-stethoscope"></i>
                                            </span>
                                            <select class="form-select" id="editSpecialization<%= doctor.getId() %>" name="specialization" required>
                                                <option value="Cardiology" <%= "Cardiology".equals(doctor.getSpecialization()) ? "selected" : "" %>>Cardiology</option>
                                                <option value="Neurology" <%= "Neurology".equals(doctor.getSpecialization()) ? "selected" : "" %>>Neurology</option>
                                                <option value="Pediatrics" <%= "Pediatrics".equals(doctor.getSpecialization()) ? "selected" : "" %>>Pediatrics</option>
                                                <option value="Dermatology" <%= "Dermatology".equals(doctor.getSpecialization()) ? "selected" : "" %>>Dermatology</option>
                                                <option value="Orthopedics" <%= "Orthopedics".equals(doctor.getSpecialization()) ? "selected" : "" %>>Orthopedics</option>
                                                <option value="Gynecology" <%= "Gynecology".equals(doctor.getSpecialization()) ? "selected" : "" %>>Gynecology</option>
                                                <option value="Psychiatry" <%= "Psychiatry".equals(doctor.getSpecialization()) ? "selected" : "" %>>Psychiatry</option>
                                                <option value="Dentistry" <%= "Dentistry".equals(doctor.getSpecialization()) ? "selected" : "" %>>Dentistry</option>
                                                <option value="Ophthalmology" <%= "Ophthalmology".equals(doctor.getSpecialization()) ? "selected" : "" %>>Ophthalmology</option>
                                                <option value="General Medicine" <%= "General Medicine".equals(doctor.getSpecialization()) ? "selected" : "" %>>General Medicine</option>
                                            </select>
                                        </div>
                                        <div class="invalid-feedback">Please select specialization.</div>
                                    </div>
                                    <div class="col-md-6">
                                        <label class="form-label" for="editDepartment<%= doctor.getId() %>">Department</label>
                                        <div class="input-group">
                                            <span class="input-group-text">
                                                <i class="fas fa-building"></i>
                                            </span>
                                            <input type="text" class="form-control" id="editDepartment<%= doctor.getId() %>" name="department"
                                                   value="<%= doctor.getDepartment() %>" required>
                                        </div>
                                         <div class="invalid-feedback">Please enter department.</div>
                                    </div>
                                    <div class="col-md-6">
                                        <label class="form-label" for="editQualification<%= doctor.getId() %>">Qualification</label>
                                        <div class="input-group">
                                            <span class="input-group-text">
                                                <i class="fas fa-graduation-cap"></i>
                                            </span>
                                            <input type="text" class="form-control" id="editQualification<%= doctor.getId() %>" name="qualification"
                                                   value="<%= doctor.getQualification() %>" required>
                                        </div>
                                        <div class="invalid-feedback">Please enter qualifications.</div>
                                    </div>
                                    <div class="col-md-6">
                                        <label class="form-label" for="editExperience<%= doctor.getId() %>">Experience (Years)</label>
                                        <div class="input-group">
                                            <span class="input-group-text">
                                                <i class="fas fa-briefcase"></i>
                                            </span>
                                            <input type="number" class="form-control" id="editExperience<%= doctor.getId() %>" name="experience"
                                                   value="<%= doctor.getExperience() %>" min="0" max="60" required>
                                        </div>
                                         <div class="invalid-feedback">Please enter valid experience (0-60).</div>
                                    </div>
                                    <div class="col-md-6">
                                        <label class="form-label" for="editVisitingCharge<%= doctor.getId() %>">Visiting Charge (<span>&#8377;</span>)</label>
                                        <div class="input-group">
                                            <span class="input-group-text">
                                                <i class="fa-solid fa-indian-rupee-sign"></i>
                                            </span>
                                            <input type="number" class="form-control" id="editVisitingCharge<%= doctor.getId() %>" name="visitingCharge"
                                                   value="<%= doctor.getVisitingCharge() %>" min="0" step="0.01" required>
                                        </div>
                                        <div class="invalid-feedback">Please enter visiting charge.</div>
                                    </div>
                                    <div class="col-md-6 d-flex align-items-center">
                                        <div class="form-check form-switch mt-3">
                                            <input class="form-check-input" type="checkbox" id="editAvailability<%= doctor.getId() %>" name="availability"
                                                   <%= doctor.isAvailability() ? "checked" : "" %> value="true">
                                            <label class="form-check-label" for="editAvailability<%= doctor.getId() %>">Available for appointments</label>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>
                        <div class="modal-footer">
                            <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cancel</button>
                            <button type="submit" class="btn btn-primary">
                                 <i class="fas fa-save me-1"></i>Update Doctor
                            </button>
                        </div>
                    </form>
                </div>
            </div>
        </div>

        <%-- Approve Doctor Modal --%>
        <% if (!doctor.isApproved()) { %>
            <div class="modal fade" id="approveModal<%= doctor.getId() %>" tabindex="-1" aria-labelledby="approveModalLabel<%= doctor.getId() %>" aria-hidden="true">
                <div class="modal-dialog modal-dialog-centered modal-sm">
                    <div class="modal-content">
                        <div class="modal-header">
                            <h5 class="modal-title">
                                <i class="fas fa-check-circle text-success me-2"></i>Confirm Approval
                            </h5>
                            <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                        </div>
                        <div class="modal-body text-center">
                            <div class="mb-3">
                                <i class="fas fa-user-md fa-3x text-success mb-3"></i>
                            </div>
                            <h5 class="mb-3">Approve Doctor?</h5>
                            <p class="text-muted">Are you sure you want to approve <strong>Dr. <%= doctor.getFullName() %></strong>?</p>
                            <small class="text-muted">This action will allow them to log in and be marked as "Approved".</small>
                        </div>
                        <div class="modal-footer justify-content-center">
                            <button type="button" class="btn btn-outline-secondary" data-bs-dismiss="modal">Cancel</button>
                            <form action="${pageContext.request.contextPath}/admin/management?action=approve&type=doctor"
                                  method="post" class="d-inline">
                                <input type="hidden" name="id" value="<%= doctor.getId() %>">
                                <button type="submit" class="btn btn-success">
                                    <i class="fas fa-check me-1"></i>Yes, Approve
                                </button>
                            </form>
                        </div>
                    </div>
                </div>
            </div>
        <% } %>

        <%-- Delete Doctor Modal --%>
        <div class="modal fade" id="deleteDoctorModal<%= doctor.getId() %>" tabindex="-1" aria-labelledby="deleteDoctorModalLabel<%= doctor.getId() %>" aria-hidden="true">
            <div class="modal-dialog modal-dialog-centered modal-sm">
                <div class="modal-content">
                    <div class="modal-header">
                        <h5 class="modal-title">
                            <i class="fas fa-exclamation-triangle text-danger me-2"></i>Confirm Deletion
                        </h5>
                        <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                    </div>
                    <div class="modal-body text-center">
                        <div class="mb-3">
                            <i class="fas fa-trash fa-3x text-danger mb-3"></i>
                        </div>
                        <h5 class="mb-3">Delete Doctor?</h5>
                        <p class="text-muted">Are you sure you want to <strong>PERMANENTLY DELETE</strong> Dr. <%= doctor.getFullName() %>?</p>
                        <small class="text-danger">This action cannot be undone and may affect all associated appointments.</small>
                    </div>
                    <div class="modal-footer justify-content-center">
                        <button type="button" class="btn btn-outline-secondary" data-bs-dismiss="modal">Cancel</button>
                        <form action="${pageContext.request.contextPath}/admin/management?action=delete&type=doctor"
                              method="post" class="d-inline">
                            <input type="hidden" name="id" value="<%= doctor.getId() %>">
                            <button type="submit" class="btn btn-danger">
                                <i class="fas fa-trash me-1"></i>Yes, Delete
                            </button>
                        </form>
                    </div>
                </div>
            </div>
        </div>
    <%
        }
    %>

    <%-- Add Doctor Modal --%>
    <div class="modal fade" id="addDoctorModal" tabindex="-1" aria-labelledby="addDoctorModalLabel" aria-hidden="true">
        <div class="modal-dialog modal-dialog-centered modal-lg">
            <div class="modal-content">
                <div class="modal-header">
                    <h3 class="modal-title">
                        <i class="fas fa-user-plus text-primary me-2"></i>
                        Add New Doctor
                    </h3>
                    <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                </div>
                <form action="${pageContext.request.contextPath}/admin/management?action=add&type=doctor" method="post" class="needs-validation" novalidate>
                    <div class="modal-body">
                        <div class="form-section">
                            <h4 class="section-title">Personal Information</h4>
                            <div class="row form-row-spaced">
                                <div class="col-md-6">
                                    <label class="form-label" for="addFullName">Full Name</label>
                                    <div class="input-group">
                                        <span class="input-group-text">
                                            <i class="fas fa-user"></i>
                                        </span>
                                        <input type="text" class="form-control" id="addFullName" name="fullName" required placeholder="Dr. Full Name">
                                    </div>
                                    <div class="invalid-feedback">Please enter doctor's name.</div>
                                </div>
                                <div class="col-md-6">
                                    <label class="form-label" for="addEmail">Email Address</label>
                                    <div class="input-group">
                                        <span class="input-group-text">
                                            <i class="fas fa-envelope"></i>
                                        </span>
                                        <input type="email" class="form-control" id="addEmail" name="email" required placeholder="doctor@hospital.com">
                                    </div>
                                    <div class="invalid-feedback">Please enter valid email.</div>
                                </div>
                                
                                <div class="col-md-6">
                                    <label class="form-label" for="addPassword">Password</label>
                                    <div class="input-group" style="position: relative;">
                                        <span class="input-group-text">
                                            <i class="fas fa-lock"></i>
                                        </span>
                                        <input type="password" class="form-control" id="addPassword" name="password" 
                                               required 
                                               minlength="8" 
                                               pattern="(?=.*\d)(?=.*[a-z])(?=.*[A-Z])(?=.*[!@#$%^&*]).{8,}"
                                               placeholder="Create a strong password"
                                               title="Must be 8+ chars, with uppercase, lowercase, number, and special character.">
                                        <span class="password-toggle-icon" id="toggleAddPassword">
                                            <i class="fas fa-eye"></i>
                                        </span>
                                    </div>
                                    
                                    <div id="password-strength-criteria" class="mt-2">
                                        <h6 class="fs-6 fw-medium">Password strength</h6>
                                        <ul class="list-unstyled">
                                            <li id="pass-length" class="criterion invalid">
                                                <i class="fas fa-circle"></i>
                                                <span>At least 8 characters</span>
                                            </li>
                                            <li id="pass-lower" class="criterion invalid">
                                                <i class="fas fa-circle"></i>
                                                <span>One lowercase letter</span>
                                            </li>
                                            <li id="pass-upper" class="criterion invalid">
                                                <i class="fas fa-circle"></i>
                                                <span>One uppercase letter</span>
                                            </li>
                                            <li id="pass-num" class="criterion invalid">
                                                <i class="fas fa-circle"></i>
                                                <span>One number</span>
                                            </li>
                                            <li id="pass-special" class="criterion invalid">
                                                <i class="fas fa-circle"></i>
                                                <span>One special character</span>
                                            </li>
                                        </ul>
                                    </div>
                                
                                    <div class="invalid-feedback">
                                        Password does not meet all requirements. Please check the list above.
                                    </div>
                                </div>
                                
                                <div class="col-md-6">
                                    <label class="form-label" for="addPhone">Phone Number</label>
                                    <div class="input-group">
                                        <span class="input-group-text">
                                            <i class="fas fa-phone"></i>
                                        </span>
                                        <input type="tel" class="form-control" id="addPhone" name="phone" required placeholder="Phone number">
                                    </div>
                                    <div class="invalid-feedback">Please enter phone number.</div>
                                </div>
                            </div>
                        </div>
                        
                        <div class="form-section">
                            <h4 class="section-title">Professional Information</h4>
                            <div class="row form-row-spaced">
                                <div class="col-md-6">
                                    <label class="form-label" for="addSpecialization">Specialization</label>
                                    <div class="input-group">
                                        <span class="input-group-text">
                                            <i class="fas fa-stethoscope"></i>
                                        </span>
                                        <select class="form-select" id="addSpecialization" name="specialization" required>
                                            <option value="" selected disabled>Select Specialization</option>
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
                                        </select>
                                    </div>
                                    <div class="invalid-feedback">Please select specialization.</div>
                                </div>
                                <div class="col-md-6">
                                    <label class="form-label" for="addDepartment">Department</label>
                                    <div class="input-group">
                                        <span class="input-group-text">
                                            <i class="fas fa-building"></i>
                                        </span>
                                        <input type="text" class="form-control" id="addDepartment" name="department" required placeholder="Department name">
                                    </div>
                                    <div class="invalid-feedback">Please enter department.</div>
                                </div>
                                <div class="col-12">
                                    <label class="form-label" for="addQualification">Qualifications</label>
                                    <div class="input-group">
                                        <span class="input-group-text">
                                            <i class="fas fa-graduation-cap"></i>
                                        </span>
                                        <input type="text" class="form-control" id="addQualification" name="qualification" required placeholder="MD, MBBS, etc.">
                                    </div>
                                    <div class="invalid-feedback">Please enter qualifications.</div>
                                </div>
                                <div class="col-md-6">
                                    <label class="form-label" for="addExperience">Experience (Years)</label>
                                    <div class="input-group">
                                        <span class="input-group-text">
                                            <i class="fas fa-briefcase"></i>
                                        </span>
                                        <input type="number" class="form-control" id="addExperience" name="experience" required min="0" max="60" placeholder="Years of experience">
                                    </div>
                                    <div class="invalid-feedback">Please enter valid experience (0-60).</div>
                                </div>
                                <div class="col-md-6">
                                    <label class="form-label" for="addVisitingCharge">Visiting Charge (<span>&#8377;</span>)</label>
                                    <div class="input-group">
                                        <span class="input-group-text">
                                            <i class="fa-solid fa-indian-rupee-sign"></i>
                                        </span>
                                        <input type="number" class="form-control" id="addVisitingCharge" name="visitingCharge" required min="0" step="0.01" placeholder="Consultation fee">
                                    </div>
                                    <div class="invalid-feedback">Please enter visiting charge.</div>
                                </div>
                            </div>
                        </div>
                    </div>
                    <div class="modal-footer">
                        <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cancel</button>
                        <button type="submit" class="btn btn-primary">
                             <i class="fas fa-plus me-1"></i>Add Doctor
                        </button>
                    </div>
                </form>
            </div>
        </div>
    </div>

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

            // Search functionality
            const searchInput = document.getElementById('doctorSearchInput');
            const tableBody = document.querySelector('#doctorsTable tbody');
            const rows = tableBody ? tableBody.querySelectorAll('tr') : [];

            if (searchInput) {
                searchInput.addEventListener('input', function() {
                    const searchTerm = this.value.toLowerCase().trim();

                    rows.forEach(row => {
                        const doctorInfoCell = row.cells[0];
                        const text = doctorInfoCell ? doctorInfoCell.textContent.toLowerCase() : '';

                        if (text.includes(searchTerm)) {
                            row.style.display = '';
                        } else {
                            row.style.display = 'none';
                        }
                    });
                });
            }
            
            // Password Strength Checker & Toggle
            const passField = document.getElementById('addPassword');
            const passToggle = document.getElementById('toggleAddPassword');
            
            const critLength = document.getElementById('pass-length');
            const critLower = document.getElementById('pass-lower');
            const critUpper = document.getElementById('pass-upper');
            const critNum = document.getElementById('pass-num');
            const critSpecial = document.getElementById('pass-special');

            const criteria = [
                { el: critLength,  regex: /.{8,}/ },
                { el: critLower,   regex: /[a-z]/ },
                { el: critUpper,   regex: /[A-Z]/ },
                { el: critNum,     regex: /\d/ },
                { el: critSpecial, regex: /[!@#$%^&*]/ }
            ];

            if (passField) {
                passField.addEventListener('input', function() {
                    const password = passField.value;

                    criteria.forEach(item => {
                        if (!item.el) return;
                        const icon = item.el.querySelector('i');
                        if (!icon) return;
                        
                        if (item.regex.test(password)) {
                            item.el.classList.remove('invalid');
                            item.el.classList.add('valid');
                            icon.classList.remove('fa-circle');
                            icon.classList.add('fa-check-circle');
                        } else {
                            item.el.classList.remove('valid');
                            item.el.classList.add('invalid');
                            icon.classList.remove('fa-check-circle');
                            icon.classList.add('fa-circle');
                        }
                    });
                });
            }

            if (passToggle) {
                passToggle.addEventListener('click', function() {
                    const icon = this.querySelector('i');
                    if (passField.type === 'password') {
                        passField.type = 'text';
                        icon.classList.remove('fa-eye');
                        icon.classList.add('fa-eye-slash');
                    } else {
                        passField.type = 'password';
                        icon.classList.remove('fa-eye-slash');
                        icon.classList.add('fa-eye');
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

            // Fix for checkbox in Edit Modal
            const editForms = document.querySelectorAll('form[action*="action=update&type=doctor"]');
            editForms.forEach(form => {
                form.addEventListener('submit', function(event) {
                    const availabilityCheckbox = form.querySelector('input[name="availability"][type="checkbox"]');
                    const existingHiddenInput = form.querySelector('input[name="availability"][type="hidden"]');

                    if (existingHiddenInput) {
                        existingHiddenInput.remove();
                    }

                    if (availabilityCheckbox && !availabilityCheckbox.checked) {
                        const hiddenInput = document.createElement('input');
                        hiddenInput.type = 'hidden';
                        hiddenInput.name = 'availability';
                        hiddenInput.value = 'false';
                        form.appendChild(hiddenInput);
                    }
                });
            });

            // Initialize tooltips
            const tooltipTriggerList = [].slice.call(document.querySelectorAll('[title]'));
            const tooltipList = tooltipTriggerList.map(function (tooltipTriggerEl) {
                return new bootstrap.Tooltip(tooltipTriggerEl);
            });
        });
    </script>
</body>
</html>