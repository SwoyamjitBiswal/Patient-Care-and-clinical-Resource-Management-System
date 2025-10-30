<div class="sidebar">
    <div class="sidebar-sticky">
        <div class="text-center py-4">
            <i class="fas fa-user-shield fa-3x text-white mb-2"></i>
            <%
                // Use a different variable name to avoid conflict
                com.entity.Admin sidebarAdmin = (com.entity.Admin) session.getAttribute("adminObj");
                if (sidebarAdmin != null) {
            %>
            <h6 class="text-white mb-1"><%= sidebarAdmin.getFullName() %></h6>
            <small class="text-light">Administrator</small>
            <% } %>
        </div>
        
        <ul class="nav flex-column">
            <li class="nav-item">
                <a class="nav-link <%= request.getRequestURI().contains("dashboard.jsp") ? "active" : "" %>" 
                   href="${pageContext.request.contextPath}/admin/dashboard.jsp">
                    <i class="fas fa-tachometer-alt"></i> Dashboard
                </a>
            </li>
            <li class="nav-item">
                <a class="nav-link <%= request.getRequestURI().contains("profile") ? "active" : "" %>" 
                   href="${pageContext.request.contextPath}/admin/profile.jsp">
                    <i class="fas fa-user"></i> My Profile
                </a>
            </li>
            <li class="nav-item">
                <a class="nav-link <%= request.getRequestURI().contains("manage_doctors") ? "active" : "" %>" 
                   href="${pageContext.request.contextPath}/admin/management?action=view&type=doctors">
                    <i class="fas fa-user-md"></i> Manage Doctors
                </a>
            </li>
            <li class="nav-item">
                <a class="nav-link <%= request.getRequestURI().contains("manage_patients") ? "active" : "" %>" 
                   href="${pageContext.request.contextPath}/admin/management?action=view&type=patients">
                    <i class="fas fa-users"></i> Manage Patients
                </a>
            </li>
            <li class="nav-item">
                <a class="nav-link <%= request.getRequestURI().contains("manage_appointments") ? "active" : "" %>" 
                   href="${pageContext.request.contextPath}/admin/management?action=view&type=appointments">
                    <i class="fas fa-calendar-alt"></i> Manage Appointments
                </a>
            </li>
        </ul>
    </div>
</div>