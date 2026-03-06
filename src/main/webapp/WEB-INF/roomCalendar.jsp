<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.*, java.time.*, com.ocean.model.Reservation" %>
<%@ page session="true" %>

<%
if (session == null || session.getAttribute("username") == null) {
    response.sendRedirect(request.getContextPath() + "/login.jsp?msg=pleaselogin");
    return;
}

Integer yearObj = (Integer) request.getAttribute("year");
Integer monthObj = (Integer) request.getAttribute("month");

int year = (yearObj != null ? yearObj : LocalDate.now().getYear());
int month = (monthObj != null ? monthObj : LocalDate.now().getMonthValue());

List<Reservation> list = (List<Reservation>) request.getAttribute("list");
if (list == null) list = new ArrayList<>();

LocalDate start = LocalDate.of(year, month, 1);
int daysInMonth = start.lengthOfMonth();
int startDow = start.getDayOfWeek().getValue();

LocalDate prev = start.minusMonths(1);
LocalDate next = start.plusMonths(1);
LocalDate today = LocalDate.now();

Map<LocalDate, List<Reservation>> map = new HashMap<>();
for (Reservation r : list) {
    if (r.getCheckIn() == null || r.getCheckOut() == null) continue;
    LocalDate in = new java.sql.Date(r.getCheckIn().getTime()).toLocalDate();
    LocalDate outDate = new java.sql.Date(r.getCheckOut().getTime()).toLocalDate().minusDays(1);

    for (LocalDate d = in; !d.isAfter(outDate); d = d.plusDays(1)) {
        if (d.getMonthValue() == month && d.getYear() == year) {
            map.computeIfAbsent(d, k -> new ArrayList<>()).add(r);
        }
    }
}
%>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Calendar</title>

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

.calendar-grid{
    display:grid;
    grid-template-columns:repeat(7,1fr);
    gap:12px;
}

.cell{
    background:white;
    border-radius:15px;
    padding:10px;
    min-height:120px;
    box-shadow:0 4px 15px rgba(0,0,0,0.08);
    transition:0.2s;
}

.cell:hover{
    transform:translateY(-3px);
}

.today{
    border:2px solid #4568dc;
}

.dow{
    text-align:center;
    font-weight:bold;
    padding:8px;
    color:#4568dc;
}

.day{
    font-weight:bold;
    margin-bottom:6px;
}

.tag{
    display:block;
    background:#e9e4ff;
    border-radius:8px;
    padding:4px 6px;
    font-size:12px;
    margin:3px 0;
    white-space:nowrap;
    overflow:hidden;
    text-overflow:ellipsis;
}
</style>
</head>

<body>

<div class="container-fluid">
<div class="row">

<jsp:include page="/WEB-INF/includes/sidebar.jsp" />

<div class="col-md-10 p-0">

<div class="topbar d-flex justify-content-between align-items-center">
    <h4 class="mb-0">
        Calendar - <%= year %>/<%= (month<10?"0"+month:month) %>
    </h4>
    <div>
        <a class="btn btn-light btn-sm"
           href="<%=request.getContextPath()%>/roomCalendar?year=<%=prev.getYear()%>&month=<%=prev.getMonthValue()%>">
           <i class="bi bi-chevron-left"></i>
        </a>

        <a class="btn btn-light btn-sm"
           href="<%=request.getContextPath()%>/roomCalendar?year=<%=next.getYear()%>&month=<%=next.getMonthValue()%>">
           <i class="bi bi-chevron-right"></i>
        </a>

        <a class="btn btn-secondary btn-sm"
           href="<%=request.getContextPath()%>/viewReservations">
           Back
        </a>
    </div>
</div>

<div class="container py-4">
<div class="content-card">

<div class="calendar-grid mb-3">
<div class="dow">Mon</div>
<div class="dow">Tue</div>
<div class="dow">Wed</div>
<div class="dow">Thu</div>
<div class="dow">Fri</div>
<div class="dow">Sat</div>
<div class="dow">Sun</div>
</div>

<div class="calendar-grid">

<%
for (int i = 1; i < startDow; i++) {
%>
<div class="cell"></div>
<%
}

for (int day = 1; day <= daysInMonth; day++) {
LocalDate d = LocalDate.of(year, month, day);
List<Reservation> dayList = map.getOrDefault(d, new ArrayList<>());
boolean isToday = d.equals(today);
%>

<div class="cell <%= isToday ? "today" : "" %>">
<div class="day"><%= day %></div>

<%
if (dayList.isEmpty()) {
%>
<div class="text-muted small">No bookings</div>
<%
} else {
for (Reservation r : dayList) {
%>
<span class="tag">
<%= r.getReservationNo() %> - <%= r.getGuestName() %>
</span>
<%
}
}
%>

</div>

<%
}

int cellsUsed = (startDow - 1) + daysInMonth;
int remainder = cellsUsed % 7;
if (remainder != 0) {
int toAdd = 7 - remainder;
for (int i = 0; i < toAdd; i++) {
%>
<div class="cell"></div>
<%
}
}
%>

</div>

</div>
</div>

</div>
</div>
</div>

</body>
</html>