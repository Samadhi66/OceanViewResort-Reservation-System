<%@ page session="true" %>

<%
if (session == null || session.getAttribute("username") == null) {
    response.sendRedirect(request.getContextPath() + "/login.jsp?msg=pleaselogin");
    return;
}

String role = (String) session.getAttribute("role");

int totalReservations = (request.getAttribute("totalReservations") != null) ? (Integer)request.getAttribute("totalReservations") : 0;
int todayCheckIns = (request.getAttribute("todayCheckIns") != null) ? (Integer)request.getAttribute("todayCheckIns") : 0;
long revenueEstimate = (request.getAttribute("revenueEstimate") != null) ? (Long)request.getAttribute("revenueEstimate") : 0L;

String loginMsg = (String) session.getAttribute("loginSuccess");
%>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Dashboard</title>

<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
<link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css" rel="stylesheet">

<style>

body{
    min-height:100vh;
    background: linear-gradient(135deg,#b06ab3,#4568dc);
    font-family:'Segoe UI',sans-serif;
}

.topbar{
    background: rgba(255,255,255,0.15);
    backdrop-filter: blur(12px);
    padding:15px 25px;
    color:white;
}

.dashboard-card{
    background: rgba(255,255,255,0.95);
    border-radius:20px;
    padding:25px;
    box-shadow:0 20px 40px rgba(0,0,0,0.2);
    text-align:center;
    transition:0.3s;
}

.dashboard-card:hover{
    transform:translateY(-5px);
}

.number{
    font-size:28px;
    font-weight:bold;
}

</style>
</head>

<body>

<div class="container-fluid">
<div class="row">

<jsp:include page="/WEB-INF/includes/sidebar.jsp" />

<div class="col-md-10 p-0">

<!-- TOPBAR -->
<div class="topbar d-flex justify-content-between align-items-center">

<h4 class="mb-0">Dashboard</h4>

<div>
Welcome, <b><%=session.getAttribute("username")%></b> 
(<%=role%>)
</div>

</div>

<!-- LOGIN SUCCESS MESSAGE -->
<%
if(loginMsg != null){
%>

<div class="container mt-3">
<div class="alert alert-success alert-dismissible fade show" role="alert">

<i class="bi bi-check-circle"></i>
<%= loginMsg %>

<button type="button" class="btn-close" data-bs-dismiss="alert"></button>

</div>
</div>

<%
session.removeAttribute("loginSuccess");
}
%>

<!-- DASHBOARD CONTENT -->

<div class="container py-4">

<div class="row g-4">

<div class="col-md-4">
<div class="dashboard-card">

<h4>Total Reservations</h4>
<div class="number"><%= totalReservations %></div>

</div>
</div>

<div class="col-md-4">
<div class="dashboard-card">

<h4>Today Check-ins</h4>
<div class="number"><%= todayCheckIns %></div>

</div>
</div>

<div class="col-md-4">
<div class="dashboard-card">

<h4>Revenue Estimate</h4>
<div class="number"><%= revenueEstimate %></div>

</div>
</div>

</div>

</div>

</div>
</div>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>

</body>
</html>