<%@ page import="com.entity.Patient" %>
<%@ page import="com.dao.AppointmentDao" %>
<%@ page import="com.entity.Appointment" %>
<%@ page import="java.util.List" %>
<%@ page import="java.util.stream.Collectors" %>
<%
    Patient currentPatient = (Patient) session.getAttribute("patientObj");
    if (currentPatient == null) {
        response.sendRedirect(request.getContextPath() + "/patient/login.jsp"); 
        return;
    }

    AppointmentDao appointmentDao = new AppointmentDao();
    List<Appointment> appointments = appointmentDao.getAppointmentsByPatientId(currentPatient.getId());

    long pendingCount = appointments.stream().filter(a -> a.getStatus() == null || "Pending".equals(a.getStatus())).count();
    long confirmedCount = appointments.stream().filter(a -> "Confirmed".equals(a.getStatus())).count();
    long completedCount = appointments.stream().filter(a -> "Completed".equals(a.getStatus())).count();
    long cancelledCount = appointments.stream().filter(a -> "Cancelled".equals(a.getStatus())).count();

    String currentUserRole = "patient";
    
    // --- ROBUST MESSAGE HANDLING ---
    String successMsg = (String) session.getAttribute("successMsg");
    String errorMsg = (String) session.getAttribute("errorMsg");

    if (successMsg != null) {
        session.removeAttribute("successMsg");
    }
    if (errorMsg != null) {
        session.removeAttribute("errorMsg");
    }

    if (request.getAttribute("successMsg") != null) {
        successMsg = (String) request.getAttribute("successMsg");
    }
    if (request.getAttribute("errorMsg") != null) {
        errorMsg = (String) request.getAttribute("errorMsg");
    }
    // --- END MESSAGE HANDLING ---
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Patient Care System - My Appointments</title>

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
        <%-- ... [Sidebar code remains unchanged] ... --%>
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
                        <a class="nav-link" 
                           href="${pageContext.request.contextPath}/patient/appointment?action=book">
                            <i class="fas fa-calendar-plus"></i>
                            <span>Book Appointment</span>
                        </a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link active" 
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
                <i class="fas fa-list-alt"></i>
                My Appointments
            </h1>
            <a href="${pageContext.request.contextPath}/patient/appointment?action=book" class="btn btn-primary">
                <i class="fas fa-calendar-plus me-2"></i>New Appointment
            </a>
        </div>

        <%-- --- START: UPDATED MESSAGE DISPLAY BLOCK --- --%>
        <%
            if (successMsg != null && !successMsg.isEmpty()) {
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
            }
        %>
        <%-- --- END: UPDATED MESSAGE DISPLAY BLOCK --- --%>


        <div class="card">
            <div class="card-header">
                <h2 class="card-title">
                    <i class="fas fa-calendar-check"></i>
                    Appointment History
                </h2>
                <span class="badge badge-light">
                    <i class="fas fa-calendar me-1"></i>
                    <%= appointments.size() %> Total Appointments
                </span>
            </div>
            <div class="card-body">
                <%
                    if (appointments.isEmpty()) {
                %>
                    <div class="empty-state">
                        <i class="fas fa-calendar-times"></i>
                        <h4>No Appointments Found</h4>
                        <p>You haven't booked any appointments yet.</p>
                        <a href="${pageContext.request.contextPath}/patient/appointment?action=book" class="btn btn-primary">
                            <i class="fas fa-calendar-plus me-2"></i>Book Your First Appointment
                        </a>
                    </div>
                <%
                    } else {
                %>
                    <div class="table-responsive">
                        <table class="table">
                            <thead>
                                <tr>
                                    <th>Doctor</th>
                                    <th>Date & Time</th>
                                    <th>Type</th>
                                    <th>Status</th>
                                    <th>Actions</th>
                                </tr>
                            </thead>
                            <tbody>
                                <%
                                    for (Appointment appointment : appointments) {
                                        String statusBadgeClass = "";
                                        String statusIcon = "";
                                        
                                        String status = appointment.getStatus();
                                        if (status == null) {
                                            status = "Pending";
                                        }
                                        
                                        switch (status) {
                                            case "Pending":
                                                statusBadgeClass = "badge-pending";
                                                statusIcon = "fas fa-clock";
                                                break;
                                            case "Confirmed":
                                                statusBadgeClass = "badge-confirmed";
                                                statusIcon = "fas fa-check-circle";
                                                break;
                                            case "Completed":
                                                statusBadgeClass = "badge-completed";
                                                statusIcon = "fas fa-calendar-check";
                                                break;
                                            case "Cancelled":
                                                statusBadgeClass = "badge-cancelled";
                                                statusIcon = "fas fa-times-circle";
                                                break;
                                            default:
                                                statusBadgeClass = "badge-light";
                                                statusIcon = "fas fa-question-circle";
                                                break;
                                        }
                                %>
                                    <tr>
                                        <td>
                                            <div class="d-flex align-items-center">
                                                <div class="doctor-avatar">
                                                    <i class="fas fa-user-md"></i>
                                                </div>
                                                <div>
                                                    <strong>Dr. <%= appointment.getDoctorName() %></strong>
                                                    <div class="text-muted" style="font-size: 0.875rem;">
                                                        <%= appointment.getDoctorSpecialization() %>
                                                    </div>
                                                </div>
                                            </div>
                                        </td>
                                        <td>
                                            <div>
                                                <strong><%= appointment.getAppointmentDate() %></strong>
                                                <div class="text-muted" style="font-size: 0.875rem;">
                                                    <i class="fas fa-clock me-1"></i>
                                                    <%= appointment.getAppointmentTime() %>
                                                </div>
                                            </div>
                                        </td>
                                        <td>
                                            <span class="badge badge-light">
                                                <i class="<%= "In-person".equals(appointment.getAppointmentType()) ? "fas fa-user" : "fas fa-laptop" %> me-1"></i>
                                                <%= appointment.getAppointmentType() %>
                                            </span>
                                        </td>
                                        <td>
                                            <span class="badge <%= statusBadgeClass %>">
                                                <i class="<%= statusIcon %> me-1"></i>
                                                <%= status %>
                                            </span>
                                            <%
                                                if (appointment.isFollowUpRequired()) {
                                            %>
                                                <div class="text-warning mt-1" style="font-size: 0.75rem;">
                                                    <i class="fas fa-redo me-1"></i>Follow-up required
                                                </div>
                                            <%
                                                }
                                            %>
                                        </td>
                                        <td>
                                            <div class="btn-group">
                                                <a href="${pageContext.request.contextPath}/patient/appointment?action=details&id=<%= appointment.getId() %>"
                                                   class="btn btn-outline-primary btn-sm">
                                                    <i class="fas fa-eye"></i>
                                                    View
                                                </a>
                                                <%
                                                    if ("Pending".equals(status)) {
                                                %>
                                                    <a href="${pageContext.request.contextPath}/patient/appointment?action=edit&id=<%= appointment.getId() %>"
                                                       class="btn btn-outline-warning btn-sm">
                                                        <i class="fas fa-edit"></i>
                                                        Edit
                                                    </a>
                                                    
                                                    <%-- --- START: UPDATED CANCEL BUTTON --- --%>
                                                    <form action="${pageContext.request.contextPath}/patient/appointment?action=cancel" method="post" class="d-inline" id="deleteForm<%= appointment.getId() %>">
                                                        <input type="hidden" name="id" value="<%= appointment.getId() %>">
                                                        <button type="button" class="btn btn-outline-danger btn-sm cancel-appointment-btn"
                                                                data-bs-toggle="modal" 
                                                                data-bs-target="#deleteConfirmModal"
                                                                data-form-id="deleteForm<%= appointment.getId() %>"
                                                                data-item-name="Appointment #<%= appointment.getId() %>">
                                                            <i class="fas fa-times"></i>
                                                            Cancel
                                                        </button>
                                                    </form>
                                                    <%-- --- END: UPDATED CANCEL BUTTON --- --%>
                                                <%
                                                    }
                                                %>
                                            </div>
                                        </td>
                                    </tr>
                                <%
                                    }
                                %>
                            </tbody>
                        </table>
                    </div>

                    <div class="stats-grid">
                        <%-- ... [Stats cards remain unchanged] ... --%>
                        <div class="stats-card stats-pending">
                            <div class="stats-number"><%= pendingCount %></div>
                            <div class="stats-label">Pending</div>
                        </div>
                        <div class="stats-card stats-confirmed">
                            <div class="stats-number"><%= confirmedCount %></div>
                            <div class="stats-label">Confirmed</div>
                        </div>
                        <div class="stats-card stats-completed">
                            <div class="stats-number"><%= completedCount %></div>
                            <div class="stats-label">Completed</div>
                        </div>
                        <div class="stats-card stats-cancelled">
                            <div class="stats-number"><%= cancelledCount %></div>
                            <div class="stats-label">Cancelled</div>
                        </div>
                    </div>
                <%
                    }
                %>
            </div>
        </div>
    </main>

    <%-- --- START: NEW CARD-STYLE DELETE MODAL --- --%>
    <div class="modal fade" id="deleteConfirmModal" tabindex="-1" aria-labelledby="deleteModalLabel" aria-hidden="true">
        <div class="modal-dialog modal-dialog-centered" style="max-width: 400px; margin: auto;">
            <div class="modal-content">
                <div class="modal-header">
                    <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                </div>
                <div class="modal-body">
                    <div class="delete-modal-icon">
                        <i class="fas fa-exclamation-triangle fa-3x"></i>
                    </div>
                    <h4>Confirm Cancellation</h4>
                    <p class="mb-0">Are you sure you want to cancel <strong id="itemNameToDelete" class="text-danger">this appointment</strong>?</p>
                    <p class="text-muted small mt-2">This action cannot be undone.</p>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-outline-secondary" data-bs-dismiss="modal">Keep It</button>
                    <button type="button" class="btn btn-danger" id="modalConfirmDeleteButton">
                        <i class="fas fa-times me-1"></i>Yes, Cancel
                    </button>
                </div>
            </div>
        </div>
    </div>
    <%-- --- END: NEW CARD-STYLE DELETE MODAL --- --%>

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
    
    <%-- --- START: UPDATED JAVASCRIPT BLOCK --- --%>
    <script>
        document.addEventListener('DOMContentLoaded', function() {
            
            // --- Auto-hide success alerts (Task 1) ---
            const successAlerts = document.querySelectorAll('.alert-success.alert-dismissible');
            successAlerts.forEach(function(alert) {
                setTimeout(function() {
                    if (typeof bootstrap !== 'undefined' && bootstrap.Alert) {
                        const bsAlert = bootstrap.Alert.getInstance(alert) || new bootstrap.Alert(alert);
                        if (bsAlert) {
                            bsAlert.close();
                        }
                    } else {
                        // Fallback
                        alert.style.transition = 'opacity 0.5s ease';
                        alert.style.opacity = '0';
                        setTimeout(() => alert.style.display = 'none', 500);
                    }
                }, 5000); // 5 seconds
            });

            // --- New Card-Style Modal Logic (Task 2) ---
            const deleteConfirmModal = document.getElementById('deleteConfirmModal');
            let formToSubmit = null; 

            if (deleteConfirmModal) {
                // 1. Listen for the modal's "show" event (triggered by data-bs-toggle)
                deleteConfirmModal.addEventListener('show.bs.modal', function (event) {
                    // Get the button that triggered the modal
                    const button = event.relatedTarget;
                    
                    // Get the form ID and item name from the button's data attributes
                    const formId = button.getAttribute('data-form-id');
                    const itemName = button.getAttribute('data-item-name');
                    
                    // Store the form to be submitted
                    formToSubmit = document.getElementById(formId);
                    
                    // Update the modal's text
                    const modalItemNameElement = document.getElementById('itemNameToDelete');
                    modalItemNameElement.textContent = itemName ? `${itemName}` : 'this item';
                });

                // 2. Add click listener to the modal's *actual* confirm button
                const modalConfirmDeleteButton = document.getElementById('modalConfirmDeleteButton');
                if (modalConfirmDeleteButton) {
                    modalConfirmDeleteButton.addEventListener('click', function () {
                        // When clicked, submit the stored form
                        if (formToSubmit) {
                            formToSubmit.submit(); 
                        }
                    });
                }
            }
            
            // --- Old confirm() script removed ---
        });
    </script>
    <%-- --- END: UPDATED JAVASCRIPT BLOCK --- --%>
</body>
</html>