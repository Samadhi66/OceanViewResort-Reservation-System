<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.*, com.ocean.model.Reservation" %>
<%@ page session="true" %>

<%
if (session == null || session.getAttribute("username") == null) {
    response.sendRedirect(request.getContextPath() + "/login.jsp?msg=pleaselogin");
    return;
}

String role = (String) session.getAttribute("role");
if (!"ADMIN".equalsIgnoreCase(role)) {
    response.sendRedirect(request.getContextPath() + "/viewReservations?msg=notallowed");
    return;
}

List<Reservation> list = (List<Reservation>) request.getAttribute("list");
if (list == null) list = new ArrayList<>();

String msg = request.getParameter("msg");
%>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Cancelled Reservations</title>

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

.content-card{
    background: rgba(255,255,255,0.85);
    backdrop-filter: blur(10px);
    border-radius:20px;
    padding:25px;
    box-shadow:0 20px 40px rgba(0,0,0,0.2);
}

.table thead{
    background:#dc3545;
    color:white;
}

.table tbody tr:hover{
    background:#ffe9ec;
    transition:0.2s;
}
</style>
</head>

<body>

<div class="container-fluid">
<div class="row">

<jsp:include page="/WEB-INF/includes/sidebar.jsp" />

<div class="col-md-10 p-0">

<div class="topbar d-flex justify-content-between align-items-center">
    <h4 class="mb-0">Cancelled Reservations</h4>
    <div>
        Welcome, <b><%=session.getAttribute("username")%></b>
    </div>
</div>

<div class="container py-4">
<div class="content-card">

<% if ("restored".equals(msg)) { %>
<div class="alert alert-success">Reservation restored successfully ✅</div>
<% } %>

<div class="table-responsive">
<table class="table table-hover align-middle">
<thead>
<tr>
<th>No</th>
<th>Guest</th>
<th>Contact</th>
<th>Room</th>
<th>Check-in</th>
<th>Check-out</th>
<th>Action</th>
</tr>
</thead>
<tbody>

<%
if (!list.isEmpty()) {
for (Reservation r : list) {
%>
<tr>
<td><%=r.getReservationNo()%></td>
<td><%=r.getGuestName()%></td>
<td><%=r.getContactNo()%></td>
<td><%=r.getRoomType()%></td>
<td><%=r.getCheckIn()%></td>
<td><%=r.getCheckOut()%></td>

<td>
<form action="<%=request.getContextPath()%>/admin/restoreReservation"
      method="post"
      onsubmit="return confirm('Restore <%=r.getReservationNo()%>?');">
<input type="hidden" name="id" value="<%=r.getReservationNo()%>"/>
<button class="btn btn-success btn-sm">
<i class="bi bi-arrow-counterclockwise"></i> Restore
</button>
</form>
</td>
</tr>
<%
}
} else {
%>
<tr>
<td colspan="7" class="text-center text-muted">
No cancelled reservations found.
</td>
</tr>
<%
}
%>

</tbody>
</table>
</div>

</div>
</div>

</div>
</div>
</div>

</body>
</html>