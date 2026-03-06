<%@ page import="com.ocean.model.Reservation" %>
<%@ page import="java.text.NumberFormat" %>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page session="true" %>

<%
if (session == null || session.getAttribute("username") == null) {
    response.sendRedirect(request.getContextPath() + "/login.jsp?msg=pleaselogin");
    return;
}

Reservation r = (Reservation) request.getAttribute("r");
String error = (String) request.getAttribute("error");

Long nights = (Long) request.getAttribute("nights");
Integer rate = (Integer) request.getAttribute("rate");
Long subtotal = (Long) request.getAttribute("subtotal");
Long serviceCharge = (Long) request.getAttribute("serviceCharge");
Long total = (Long) request.getAttribute("total");

NumberFormat nf = NumberFormat.getNumberInstance();
nf.setMinimumFractionDigits(2);
nf.setMaximumFractionDigits(2);
%>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Invoice</title>

<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">

<style>
body{
    min-height:100vh;
    background: linear-gradient(135deg,#b06ab3,#4568dc);
    font-family:'Segoe UI',sans-serif;
}

.invoice-card{
    background:white;
    border-radius:18px;
    padding:40px;
    box-shadow:0 25px 50px rgba(0,0,0,0.25);
}

.invoice-header{
    display:flex;
    justify-content:space-between;
    align-items:flex-start;
}

.invoice-title{
    font-size:28px;
    font-weight:700;
}

.invoice-sub{
    color:#6c757d;
    font-size:14px;
}

.section-title{
    font-weight:600;
    margin-top:25px;
    margin-bottom:15px;
}

.table thead{
    background:#2c3e50;
    color:white;
}

.table td, .table th{
    vertical-align:middle;
}

.total-row{
    font-size:18px;
}

.total-box{
    background: linear-gradient(135deg,#4568dc,#5f2c82);
    color:white;
    padding:25px;
    border-radius:18px;
    text-align:center;
    box-shadow:0 10px 30px rgba(0,0,0,0.2);
}

.total-box h3{
    margin:5px 0 0 0;
    font-size:30px;
}

.footer-note{
    margin-top:30px;
    font-size:13px;
    color:#6c757d;
}

@media print{
    body{background:white;}
    .no-print{display:none;}
    .invoice-card{box-shadow:none;}
}
</style>
</head>

<body>

<div class="container py-5">
<div class="invoice-card">

<% if(error != null){ %>
<div class="alert alert-danger"><%= error %></div>
<% } %>

<% if(r != null){ %>

<div class="invoice-header mb-4">
    <div>
        <div class="invoice-title">Ocean View Resort</div>
        <div class="invoice-sub">Galle, Sri Lanka</div>
    </div>
    <div class="text-end">
        <div><strong>Invoice #:</strong> <%= r.getReservationNo() %></div>
        <div><strong>Date:</strong> <%= java.time.LocalDate.now() %></div>
    </div>
</div>

<hr>

<div class="section-title">Guest Details</div>

<div class="row mb-4">
    <div class="col-md-2"><strong>Name:</strong><br><%= r.getGuestName() %></div>
    <div class="col-md-2"><strong>Contact:</strong><br><%= r.getContactNo() %></div>
    <div class="col-md-2"><strong>Room:</strong><br><%= r.getRoomType() %></div>
    <div class="col-md-2"><strong>Check-in:</strong><br><%= r.getCheckIn() %></div>
    <div class="col-md-2"><strong>Check-out:</strong><br><%= r.getCheckOut() %></div>
    <div class="col-md-2"><strong>Nights:</strong><br><%= nights %></div>
</div>

<div class="section-title">Charges</div>

<table class="table table-bordered">
<thead>
<tr>
<th>Description</th>
<th class="text-end">Amount (LKR)</th>
</tr>
</thead>
<tbody>
<tr>
<td>Room Charge (<%= nights %> nights × LKR <%= nf.format(rate) %>)</td>
<td class="text-end">LKR <%= nf.format(subtotal) %></td>
</tr>
<tr>
<td>Service Charge (10%)</td>
<td class="text-end">LKR <%= nf.format(serviceCharge) %></td>
</tr>
<tr class="fw-bold total-row">
<td>Total</td>
<td class="text-end">LKR <%= nf.format(total) %></td>
</tr>
</tbody>
</table>

<div class="row mt-4 align-items-center">
    <div class="col-md-6">
        <div class="footer-note">
            Thank you for choosing Ocean View Resort.<br>
            This is a computer-generated invoice. No signature required.
        </div>
    </div>
    <div class="col-md-6">
        <div class="total-box">
            <div>Total Payable</div>
            <h3>LKR <%= nf.format(total) %></h3>
        </div>
    </div>
</div>

<div class="mt-4 no-print">
    <button class="btn btn-primary" onclick="window.print()">Print</button>
    <a class="btn btn-secondary" href="viewReservations">Back</a>
</div>

<% } %>

</div>
</div>

</body>
</html>