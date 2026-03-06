<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.*, java.net.URLEncoder, com.ocean.model.Reservation" %>
<%@ page session="true" %>

<%
if (session == null || session.getAttribute("username") == null) {
    response.sendRedirect(request.getContextPath() + "/login.jsp?msg=pleaselogin");
    return;
}

List<Reservation> list = (List<Reservation>) request.getAttribute("list");

String msg = request.getParameter("msg");
String resNo = request.getParameter("resNo");

String q = request.getParameter("q");
String from = request.getParameter("from");
String to = request.getParameter("to");

Integer pageObj = (Integer) request.getAttribute("page");
Integer sizeObj = (Integer) request.getAttribute("size");
Integer totalPagesObj = (Integer) request.getAttribute("totalPages");
Integer totalObj = (Integer) request.getAttribute("total");

int pageNo = (pageObj != null ? pageObj : 1);
int size = (sizeObj != null ? sizeObj : 10);
int totalPages = (totalPagesObj != null ? totalPagesObj : 1);
int total = (totalObj != null ? totalObj : 0);

String qsQ = (q != null ? q : "");
String qsFrom = (from != null ? from : "");
String qsTo = (to != null ? to : "");

String base = request.getContextPath() + "/viewReservations"
        + "?q=" + URLEncoder.encode(qsQ, "UTF-8")
        + "&from=" + URLEncoder.encode(qsFrom, "UTF-8")
        + "&to=" + URLEncoder.encode(qsTo, "UTF-8")
        + "&size=" + size;
%>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Reservations</title>

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

.form-control{
    height:45px;
    border-radius:12px;
}

.table thead{
    background:#4568dc;
    color:white;
}

.table tbody tr:hover{
    background:#f3f0ff;
    transition:0.2s;
}

.btn-gradient{
    background: linear-gradient(135deg,#b06ab3,#4568dc);
    border:none;
    color:white;
    border-radius:10px;
    padding:8px 16px;
}

.btn-gradient:hover{
    opacity:0.9;
}
</style>
</head>

<body>

<div class="container-fluid">
<div class="row">

<jsp:include page="/WEB-INF/includes/sidebar.jsp" />

<div class="col-md-10 p-0">

<div class="topbar d-flex justify-content-between align-items-center">
    <h4 class="mb-0">All Reservations</h4>
    <div>
        Welcome, <b><%=session.getAttribute("username")%></b>
    </div>
</div>

<div class="container py-4">
<div class="content-card">

<!-- Alerts -->
<% if ("updated".equals(msg) && resNo != null) { %>
<div class="alert alert-success">Reservation <%= resNo %> updated successfully ✅</div>
<% } else if ("deleted".equals(msg) && resNo != null) { %>
<div class="alert alert-success">Reservation <%= resNo %> deleted successfully ✅</div>
<% } else if ("notfound".equals(msg)) { %>
<div class="alert alert-danger">Reservation not found ❌</div>
<% } %>

<!-- Search -->
<form class="row g-3 mb-3" action="<%=request.getContextPath()%>/viewReservations" method="get">
    <div class="col-md-3">
        <input type="text" name="q" class="form-control" placeholder="Guest or R001" value="<%=qsQ%>">
    </div>
    <div class="col-md-2">
        <input type="date" name="from" class="form-control" value="<%=qsFrom%>">
    </div>
    <div class="col-md-2">
        <input type="date" name="to" class="form-control" value="<%=qsTo%>">
    </div>
    <div class="col-md-2">
        <button class="btn btn-gradient w-100">Search</button>
    </div>
    <div class="col-md-2">
        <a href="<%=request.getContextPath()%>/viewReservations" class="btn btn-secondary w-100">Reset</a>
    </div>
</form>

<!-- Action Buttons -->
<div class="mb-3">
    <a class="btn btn-gradient" href="<%= request.getContextPath() %>/reservation.jsp">+ New</a>
    <a class="btn btn-secondary" href="<%= request.getContextPath() %>/exportReservations?type=csv&q=<%=URLEncoder.encode(qsQ,"UTF-8")%>&from=<%=URLEncoder.encode(qsFrom,"UTF-8")%>&to=<%=URLEncoder.encode(qsTo,"UTF-8")%>">Export CSV</a>
    <a class="btn btn-secondary" href="<%= request.getContextPath() %>/exportReservations?type=print&q=<%=URLEncoder.encode(qsQ,"UTF-8")%>&from=<%=URLEncoder.encode(qsFrom,"UTF-8")%>&to=<%=URLEncoder.encode(qsTo,"UTF-8")%>">Print</a>
</div>

<!-- Table -->
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
<th>Bill</th>
<th>Action</th>
</tr>
</thead>
<tbody>

<%
if (list != null && !list.isEmpty()) {
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
<a class="btn btn-success btn-sm"
href="<%=request.getContextPath()%>/bill?resNo=<%=r.getReservationNo()%>">Bill</a>
</td>

<td>
<a class="btn btn-warning btn-sm"
href="<%=request.getContextPath()%>/reservation/edit?id=<%=r.getReservationNo()%>">Edit</a>

<form class="d-inline"
action="<%=request.getContextPath()%>/reservation/delete"
method="post"
onsubmit="return confirm('Delete <%=r.getReservationNo()%>?');">
<input type="hidden" name="id" value="<%=r.getReservationNo()%>"/>
<button class="btn btn-danger btn-sm">Delete</button>
</form>
</td>
</tr>
<%
}
} else {
%>
<tr>
<td colspan="8" class="text-center text-muted">No reservations found.</td>
</tr>
<%
}
%>

</tbody>
</table>
</div>

<!-- Pagination -->
<div class="d-flex justify-content-between align-items-center mt-3">
<div>
Page <b><%=pageNo%></b> of <b><%=totalPages%></b> | Total: <b><%=total%></b>
</div>

<div>
<% if (pageNo > 1) { %>
<a class="btn btn-secondary btn-sm" href="<%= base + "&page=1" %>">First</a>
<a class="btn btn-secondary btn-sm" href="<%= base + "&page=" + (pageNo-1) %>">Prev</a>
<% } %>

<% if (pageNo < totalPages) { %>
<a class="btn btn-secondary btn-sm" href="<%= base + "&page=" + (pageNo+1) %>">Next</a>
<a class="btn btn-secondary btn-sm" href="<%= base + "&page=" + totalPages %>">Last</a>
<% } %>
</div>
</div>

</div>
</div>
</div>
</div>
</div>

</body>
</html>