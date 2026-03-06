<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>Login</title>

<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
<link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css" rel="stylesheet">

<style>
body{
    height:100vh;
    display:flex;
    justify-content:center;
    align-items:center;
    background: linear-gradient(135deg,#b06ab3,#4568dc);
    font-family:'Segoe UI',sans-serif;
}

.login-card{
    background:#f8f8f8;
    padding:40px 30px;
    border-radius:25px;
    width:380px;
    position:relative;
    box-shadow:0 25px 50px rgba(0,0,0,0.3);
}

.login-icon{
    width:80px;
    height:80px;
    background:#1c2b4a;
    border-radius:50%;
    display:flex;
    justify-content:center;
    align-items:center;
    position:absolute;
    top:-40px;
    left:50%;
    transform:translateX(-50%);
    color:white;
    font-size:28px;
}

.form-control{
    background:#445a77;
    border:none;
    color:white;
    border-radius:10px;
    padding:12px;
}

.form-control::placeholder{
    color:#ddd;
}

.form-control:focus{
    background:#3c516c;
    color:white;
    box-shadow:none;
}

.login-btn{
    background:linear-gradient(135deg,#b06ab3,#4568dc);
    border:none;
    border-radius:10px;
    padding:12px;
    font-weight:600;
    color:white;
}

.login-btn:hover{
    opacity:0.9;
}

.remember-row{
    font-size:14px;
}
</style>
</head>

<body>

<%
String ctx = request.getContextPath();
String msg = request.getParameter("msg");
%>

<div class="login-card text-center">

<div class="login-icon">
<i class="bi bi-person"></i>
</div>

<h4 class="mt-4 mb-3 fw-bold">Login</h4>

<% if("pleaselogin".equals(msg)){ %>
<div class="alert alert-warning">Please login first</div>
<% } else if("invalid".equals(msg)){ %>
<div class="alert alert-danger">Invalid username or password</div>
<% } %>

<form action="<%=ctx%>/LoginServlet" method="post">

<div class="mb-3 text-start">
<label class="form-label fw-semibold">Username</label>
<div class="input-group">
<span class="input-group-text bg-dark text-white border-0">
<i class="bi bi-person"></i>
</span>
<input type="text" name="username" class="form-control" placeholder="Enter username" required>
</div>
</div>

<div class="mb-2 text-start">
<label class="form-label fw-semibold">Password</label>
<div class="input-group">
<span class="input-group-text bg-dark text-white border-0">
<i class="bi bi-lock"></i>
</span>
<input type="password" name="password" class="form-control" placeholder="Enter password" required>
</div>
</div>

<div class="d-flex justify-content-between align-items-center my-3 remember-row">
<div>
<input type="checkbox" name="rememberMe"> Remember me
</div>
<a href="#" class="text-decoration-none small">Forgot Password?</a>
</div>

<button type="submit" class="login-btn w-100">
LOGIN
</button>

</form>

</div>

</body>
</html>