<%@ page session="true" %>
<%@ page import="com.ocean.model.Reservation" %>

<%
    response.setHeader("Cache-Control", "no-cache, no-store, must-revalidate");
    response.setHeader("Pragma", "no-cache");
    response.setDateHeader("Expires", 0);

    if (session == null || session.getAttribute("username") == null) {
        response.sendRedirect(request.getContextPath() + "/login.jsp?msg=pleaselogin");
        return;
    }

    Reservation r = (Reservation) request.getAttribute("reservation");

    String errField = (String) request.getAttribute("errField");
    String errMsg = (String) request.getAttribute("errMsg");

    String resNo = (r != null ? r.getReservationNo() : "");

    String dGuest = (r != null ? r.getGuestName() : "");
    String dAddr = (r != null ? r.getAddress() : "");
    String dContact = (r != null ? r.getContactNo() : "");
    String dRoom = (r != null ? r.getRoomType() : "");
    String dIn = (r != null && r.getCheckIn()!=null ? r.getCheckIn().toString() : "");
    String dOut = (r != null && r.getCheckOut()!=null ? r.getCheckOut().toString() : "");
%>

<!DOCTYPE html>
<html>
<head>
    <title>Edit Reservation</title>
    <style>
      body { font-family: Arial, sans-serif; background: #f6f7fb; margin: 0; }

      .topbar{
        background:#fff;
        padding:12px 18px;
        border-bottom:1px solid #ddd;
        display:flex;
        justify-content:space-between;
        align-items:center;
      }
      .topbar a { text-decoration: none; font-weight: bold; }

      .container {
        max-width: 760px;
        margin: 25px auto;
        background: #fff;
        padding: 22px;
        border-radius: 10px;
        box-shadow: 0 2px 10px rgba(0,0,0,.08);
      }

      .form-title{
        text-align:center;
        margin: 0 0 18px 0;
      }

      .row {
        display: grid;
        grid-template-columns: 170px 1fr;
        gap: 12px;
        align-items: start;
        margin: 12px 0;
      }
      input, select {
        width: 100%;
        padding: 8px 10px;
        border: 1px solid #ccc;
        border-radius: 6px;
      }

      .btn {
        background: #1f6feb;
        color: #fff;
        border: none;
        padding: 10px 14px;
        border-radius: 8px;
        cursor: pointer;
        text-decoration:none;
        display:inline-block;
      }
      .btn:hover { opacity: .92; }

      .btn-secondary{ background:#6c757d; }
      .btn-bill{ background:#198754; }

      .field-error {
        color: #b00020;
        font-size: 12px;
        margin-top: 6px;
      }
      .input-error {
        border: 1.5px solid #b00020 !important;
        outline: none;
      }

      .actions { margin-top: 14px; display:flex; gap:10px; flex-wrap:wrap; }
    </style>
</head>

<body>

<div class="topbar">
    <div>Welcome, <b><%= session.getAttribute("username") %></b></div>
    <div>
        <a href="<%=request.getContextPath()%>/viewReservations">Back</a> |
        <a class="logout" href="<%=request.getContextPath()%>/logout">Logout</a>
    </div>
</div>

<div class="container">
    <h2 class="form-title">Edit Reservation (<%= resNo %>)</h2>

    <form action="<%=request.getContextPath()%>/reservation/edit" method="post" novalidate>

        <input type="hidden" name="reservation_no" value="<%= resNo %>">

        <div class="row">
            <label>Guest Name:</label>
            <div>
                <input type="text" name="guest_name"
                       value="<%= dGuest %>"
                       class="<%= ("guest_name".equals(errField) ? "input-error" : "") %>">
                <% if ("guest_name".equals(errField)) { %>
                    <div class="field-error"><%= errMsg %></div>
                <% } %>
            </div>
        </div>

        <div class="row">
            <label>Address:</label>
            <div>
                <input type="text" name="address" value="<%= dAddr %>">
            </div>
        </div>

        <div class="row">
            <label>Contact Number:</label>
            <div>
                <input type="text" name="contact_number"
                       value="<%= dContact %>"
                       class="<%= ("contact_number".equals(errField) ? "input-error" : "") %>">
                <% if ("contact_number".equals(errField)) { %>
                    <div class="field-error"><%= errMsg %></div>
                <% } %>
            </div>
        </div>

        <div class="row">
            <label>Room Type:</label>
            <div>
                <select name="room_type" class="<%= ("room_type".equals(errField) ? "input-error" : "") %>">
                    <option <%= ("Single".equals(dRoom) ? "selected" : "") %>>Single</option>
                    <option <%= ("Double".equals(dRoom) ? "selected" : "") %>>Double</option>
                    <option <%= ("Family".equals(dRoom) ? "selected" : "") %>>Family</option>
                </select>
                <% if ("room_type".equals(errField)) { %>
                    <div class="field-error"><%= errMsg %></div>
                <% } %>
            </div>
        </div>

        <div class="row">
            <label>Check-in Date:</label>
            <div>
                <input type="date" name="checkin_date"
                       value="<%= dIn %>"
                       class="<%= ("checkin_date".equals(errField) ? "input-error" : "") %>">
                <% if ("checkin_date".equals(errField)) { %>
                    <div class="field-error"><%= errMsg %></div>
                <% } %>
            </div>
        </div>

        <div class="row">
            <label>Check-out Date:</label>
            <div>
                <input type="date" name="checkout_date"
                       value="<%= dOut %>"
                       class="<%= ("checkout_date".equals(errField) ? "input-error" : "") %>">
                <% if ("checkout_date".equals(errField)) { %>
                    <div class="field-error"><%= errMsg %></div>
                <% } %>
            </div>
        </div>

        <div class="actions">
            <button class="btn" type="submit">Update Reservation</button>
            <a class="btn btn-secondary" href="<%=request.getContextPath()%>/viewReservations">Cancel</a>
            <a class="btn btn-bill" href="<%=request.getContextPath()%>/bill?resNo=<%= resNo %>">View Bill</a>
        </div>
    </form>
</div>

</body>
</html>