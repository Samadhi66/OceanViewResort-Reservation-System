<%@ page isErrorPage="true" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
  <meta charset="UTF-8">
  <title>Error</title>
  <style>
    body{font-family:Arial;background:#f6f7fb;margin:0;padding:20px;}
    .card{background:#fff;border-radius:12px;padding:18px;box-shadow:0 2px 10px rgba(0,0,0,.06);}
    a{color:#1f6feb;text-decoration:none;font-weight:700;}
  </style>
</head>
<body>
  <div class="card">
    <h2>Something went wrong ❌</h2>
    <p>Please try again.</p>
    <p style="color:#777;font-size:12px;">
      <%= (exception != null ? exception.toString() : "No details") %>
    </p>
    <p><a href="<%=request.getContextPath()%>/viewReservations">Back to Reservations</a></p>
  </div>
</body>
</html>