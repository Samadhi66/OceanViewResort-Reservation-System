<%@ page session="true" %>
<%
    if (session == null || session.getAttribute("username") == null) {
        response.sendRedirect(request.getContextPath() + "/login.jsp?msg=pleaselogin");
        return;
    }

    String role = (String) session.getAttribute("role");

    if (!"RECEPTION".equalsIgnoreCase(role)) {
        response.sendRedirect(request.getContextPath() + "/dashboard");
        return;
    }
%>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Reception Dashboard</title>
    <style>
        body {
            font-family: Arial;
            background: #f6f7fb;
            margin: 0;
            padding: 20px;
        }

        .top {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 20px;
            flex-wrap: wrap;
        }

        .card-container {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(220px, 1fr));
            gap: 15px;
        }

        .card {
            background: white;
            padding: 20px;
            border-radius: 12px;
            box-shadow: 0 3px 10px rgba(0,0,0,0.08);
            text-align: center;
        }

        .card h3 {
            margin-top: 0;
        }

        .btn {
            display: inline-block;
            margin-top: 10px;
            padding: 8px 14px;
            background: #6f2dbd;
            color: white;
            text-decoration: none;
            border-radius: 8px;
        }

        .btn:hover {
            background: #5a189a;
        }
    </style>
</head>
<body>

<div class="top">
    <div>
        <h2>Reception Dashboard</h2>
        <p>Logged in as: <b><%= session.getAttribute("username") %></b> 
           (<%= session.getAttribute("role") %>)</p>
    </div>
    <div>
        <a class="btn" href="<%=request.getContextPath()%>/logout">Logout</a>
    </div>
</div>

<div class="card-container">

    <div class="card">
        <h3>View Reservations</h3>
        <p>Check all booking details</p>
        <a class="btn" href="<%=request.getContextPath()%>/viewReservations">Open</a>
    </div>

    <div class="card">
        <h3>Add New Reservation</h3>
        <p>Create new booking</p>
        <a class="btn" href="<%=request.getContextPath()%>/reservation.jsp">Open</a>
    </div>

    <div class="card">
        <h3>Room Calendar</h3>
        <p>Check room availability</p>
        <a class="btn" href="<%=request.getContextPath()%>/roomCalendar">Open</a>
    </div>

</div>

</body>
</html>