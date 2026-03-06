<%@ page session="true" %>
<%
String uri = request.getRequestURI();
String role = (String) session.getAttribute("role");
%>

<style>
.sidebar{
    height:100vh;
    background: rgba(255,255,255,0.1);
    backdrop-filter: blur(12px);
    padding:25px 15px;
    color:white;
}

.sidebar a{
    display:flex;
    align-items:center;
    padding:12px 15px;
    border-radius:10px;
    margin-bottom:8px;
    transition:0.3s;
    font-weight:500;
    color:white;
    text-decoration:none;
}

.sidebar a:hover{
    background:rgba(255,255,255,0.2);
    transform:translateX(5px);
}

.active-link{
    background:rgba(255,255,255,0.3);
    font-weight:600;
    box-shadow:0 5px 15px rgba(0,0,0,0.2);
}
</style>

<div class="col-md-2 sidebar">
    <h4 class="mb-4 fw-bold">OceanView</h4>

    <a href="<%=request.getContextPath()%>/dashboard"
       class="<%= uri.contains("dashboard") ? "active-link" : "" %>">
        <i class="bi bi-speedometer2 me-2"></i> Dashboard
    </a>

    <a href="<%=request.getContextPath()%>/viewReservations"
       class="<%= uri.contains("viewReservations") ? "active-link" : "" %>">
        <i class="bi bi-calendar-check me-2"></i> Reservations
    </a>

    <a href="<%=request.getContextPath()%>/roomCalendar"
       class="<%= uri.contains("roomCalendar") ? "active-link" : "" %>">
        <i class="bi bi-calendar3 me-2"></i> Calendar
    </a>

    <% if("ADMIN".equalsIgnoreCase(role)){ %>
    <a href="<%=request.getContextPath()%>/admin/cancelledReservations"
       class="<%= uri.contains("cancelledReservations") ? "active-link" : "" %>">
        <i class="bi bi-x-circle me-2"></i> Cancelled
    </a>
    <% } %>

    <a href="<%=request.getContextPath()%>/logout">
        <i class="bi bi-box-arrow-right me-2"></i> Logout
    </a>
</div>