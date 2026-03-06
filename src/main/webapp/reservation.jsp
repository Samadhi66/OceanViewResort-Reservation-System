<%@ page session="true" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%
    // Prevent back button cache after logout
    response.setHeader("Cache-Control", "no-cache, no-store, must-revalidate");
    response.setHeader("Pragma", "no-cache");
    response.setDateHeader("Expires", 0);

    if (session == null || session.getAttribute("username") == null) {
        response.sendRedirect(request.getContextPath() + "/login.jsp?msg=pleaselogin");
        return;
    }

    String msg = request.getParameter("msg");
    String resNo = request.getParameter("resNo");

    String errField = (String) request.getAttribute("errField");
    String errMsg = (String) request.getAttribute("errMsg");

    // Keep typed values after validation errors (from query params)
    String vGuest = request.getParameter("guest_name");
    String vAddr = request.getParameter("address");
    String vContact = request.getParameter("contact_number");
    String vRoom = request.getParameter("room_type");
    String vIn = request.getParameter("checkin_date");
    String vOut = request.getParameter("checkout_date");
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1" />
    <title>Ocean View Resort - Make Reservation</title>

    <!-- Bootstrap 5 -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">

    <!-- Bootstrap Icons -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css" rel="stylesheet">

    <style>
        :root{
            --ovr-primary: #6f2dbd;
            --ovr-primary-2: #7b2cbf;
            --ovr-bg: #f6f7fb;
        }

        body{ background: var(--ovr-bg); }

        /* Top gradient header */
        .page-hero{
            background: radial-gradient(1200px circle at 15% 20%, rgba(255,255,255,0.18), transparent 42%),
                        linear-gradient(135deg, var(--ovr-primary), #5a189a 55%, #3c096c);
            color:#fff;
            border-bottom-left-radius: 40px;
            border-bottom-right-radius: 40px;
            overflow:hidden;
        }

        .logo-badge{
            width: 42px; height: 42px;
            border-radius: 14px;
            display:inline-flex; align-items:center; justify-content:center;
            background: rgba(255,255,255,0.18);
            border: 1px solid rgba(255,255,255,0.25);
            backdrop-filter: blur(6px);
        }

        /* Card */
        .card-soft{
            border: 0;
            border-radius: 18px;
            box-shadow: 0 18px 45px rgba(18,16,32,0.14);
        }

        .btn-ovr{
            background: linear-gradient(135deg, var(--ovr-primary), var(--ovr-primary-2));
            border: none;
            font-weight: 600;
            padding: 12px 14px;
            border-radius: 12px;
            box-shadow: 0 10px 22px rgba(111,45,189,0.22);
        }
        .btn-ovr:hover{ filter: brightness(1.05); transform: translateY(-1px); }

        .form-control, .form-select{
            border-radius: 12px;
            padding: 12px 14px;
        }

        .pull-up{ margin-top: -90px; padding-bottom: 40px; }

        .text-muted-soft{ color: rgba(255,255,255,0.85) !important; }

        /* Make Bootstrap invalid message always visible when server gives errField */
        .server-error{ display:block; }
    </style>
</head>

<body>

<!-- Navbar (common layout) -->
<nav class="navbar navbar-expand-lg navbar-dark" style="background: transparent;">
    <div class="container py-3">
        <a class="navbar-brand d-flex align-items-center gap-2" href="<%=request.getContextPath()%>/">
            <span class="logo-badge"><i class="bi bi-waves"></i></span>
            <span class="fw-semibold">OceanViewResort</span>
        </a>

        <button class="navbar-toggler" type="button" data-bs-toggle="collapse" data-bs-target="#ovrNav">
            <span class="navbar-toggler-icon"></span>
        </button>

        <div class="collapse navbar-collapse" id="ovrNav">
            <ul class="navbar-nav ms-auto align-items-lg-center gap-lg-2">
                <li class="nav-item">
                    <span class="nav-link disabled text-white-50">
                        Welcome, <span class="text-white fw-semibold"><%= session.getAttribute("username") %></span>
                    </span>
                </li>
                <li class="nav-item">
                    <a class="nav-link active" href="<%=request.getContextPath()%>/reservation.jsp">
                        <i class="bi bi-plus-circle me-1"></i> New Reservation
                    </a>
                </li>
                <li class="nav-item">
                    <a class="nav-link" href="<%=request.getContextPath()%>/viewReservations">
                        <i class="bi bi-card-list me-1"></i> Reservations
                    </a>
                </li>
                <li class="nav-item">
                    <a class="btn btn-light btn-sm ms-lg-2" href="<%=request.getContextPath()%>/logout">
                        <i class="bi bi-box-arrow-right me-1"></i> Logout
                    </a>
                </li>
            </ul>
        </div>
    </div>
</nav>

<!-- Hero -->
<header class="page-hero">
    <div class="container pb-5">
        <div class="row align-items-center g-4">
            <div class="col-lg-8">
                <h1 class="h2 fw-bold mb-2">Room Reservation</h1>
                <p class="mb-0 text-muted-soft">Fill the form to reserve a room. All details can be edited later.</p>
            </div>
            <div class="col-lg-4 d-none d-lg-block text-end">
                <div class="d-inline-flex align-items-center justify-content-center"
                     style="width:110px;height:110px;border-radius:26px;background:rgba(255,255,255,0.14);border:1px solid rgba(255,255,255,0.22);">
                    <i class="bi bi-calendar2-check fs-1"></i>
                </div>
            </div>
        </div>
    </div>
</header>

<main class="pull-up">
    <div class="container">
        <div class="row justify-content-center">
            <div class="col-lg-9 col-xl-8">

                <!-- Success message -->
                <% if ("success".equals(msg) && resNo != null) { %>
                    <div class="alert alert-success alert-dismissible fade show mt-3" role="alert">
                        <div class="d-flex align-items-start gap-2">
                            <i class="bi bi-check-circle fs-5"></i>
                            <div>
                                <div class="fw-bold">Reservation Added Successfully!</div>
                                <div>Your Reservation Number: <span class="fw-bold"><%= resNo %></span></div>
                            </div>
                        </div>
                        <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
                    </div>
                <% } %>

                <div class="card card-soft mt-3">
                    <div class="card-body p-4 p-md-5">

                        <div class="d-flex align-items-center justify-content-between flex-wrap gap-2 mb-3">
                            <div>
                                <h2 class="h4 fw-bold mb-1">Make a Reservation</h2>
                                <p class="text-muted mb-0">Enter guest details and dates.</p>
                            </div>
                            <span class="badge text-bg-light border">
                                <i class="bi bi-shield-check me-1"></i> Secure Session
                            </span>
                        </div>

                        <form action="<%=request.getContextPath()%>/AddReservationServlet"
                              method="post"
                              class="needs-validation"
                              novalidate>

                            <div class="row g-3">
                                <!-- Guest Name -->
                                <div class="col-md-6">
                                    <label class="form-label fw-semibold">Guest Name</label>
                                    <input
                                            type="text"
                                            name="guest_name"
                                            value="<%= (vGuest != null ? vGuest : "") %>"
                                            class="form-control <%= ("guest_name".equals(errField) ? "is-invalid" : "") %>"
                                            placeholder="e.g. Nethma Samadhi"
                                            required>
                                    <div class="invalid-feedback <%= ("guest_name".equals(errField) ? "server-error" : "") %>">
                                        <%= ("guest_name".equals(errField) ? errMsg : "Please enter guest name.") %>
                                    </div>
                                </div>

                                <!-- Contact Number -->
                                <div class="col-md-6">
                                    <label class="form-label fw-semibold">Contact Number</label>
                                    <input
                                            type="text"
                                            name="contact_number"
                                            value="<%= (vContact != null ? vContact : "") %>"
                                            class="form-control <%= ("contact_number".equals(errField) ? "is-invalid" : "") %>"
                                            placeholder="0771234567"
                                            pattern="^[0-9]{10}$"
                                            required>
                                    <div class="invalid-feedback <%= ("contact_number".equals(errField) ? "server-error" : "") %>">
                                        <%= ("contact_number".equals(errField) ? errMsg : "Enter a valid 10 digit number.") %>
                                    </div>
                                </div>

                                <!-- Address -->
                                <div class="col-12">
                                    <label class="form-label fw-semibold">Address</label>
                                    <input
                                            type="text"
                                            name="address"
                                            value="<%= (vAddr != null ? vAddr : "") %>"
                                            class="form-control"
                                            placeholder="e.g. No 25, Galle Road, Galle">
                                </div>

                                <!-- Room Type -->
                                <div class="col-md-6">
                                    <label class="form-label fw-semibold">Room Type</label>
                                    <select
                                            name="room_type"
                                            class="form-select <%= ("room_type".equals(errField) ? "is-invalid" : "") %>"
                                            required>
                                        <option value="" disabled <%= (vRoom == null || vRoom.trim().isEmpty() ? "selected" : "") %>>Select a room type</option>
                                        <option value="Single" <%= ("Single".equals(vRoom) ? "selected" : "") %>>Single</option>
                                        <option value="Double" <%= ("Double".equals(vRoom) ? "selected" : "") %>>Double</option>
                                        <option value="Family" <%= ("Family".equals(vRoom) ? "selected" : "") %>>Family</option>
                                    </select>
                                    <div class="invalid-feedback <%= ("room_type".equals(errField) ? "server-error" : "") %>">
                                        <%= ("room_type".equals(errField) ? errMsg : "Please select a room type.") %>
                                    </div>
                                </div>

                                <!-- Check-in Date -->
                                <div class="col-md-6">
                                    <label class="form-label fw-semibold">Check-in Date</label>
                                    <input
                                            type="date"
                                            name="checkin_date"
                                            value="<%= (vIn != null ? vIn : "") %>"
                                            class="form-control <%= ("checkin_date".equals(errField) ? "is-invalid" : "") %>"
                                            required>
                                    <div class="invalid-feedback <%= ("checkin_date".equals(errField) ? "server-error" : "") %>">
                                        <%= ("checkin_date".equals(errField) ? errMsg : "Please choose a check-in date.") %>
                                    </div>
                                </div>

                                <!-- Check-out Date -->
                                <div class="col-md-6">
                                    <label class="form-label fw-semibold">Check-out Date</label>
                                    <input
                                            type="date"
                                            name="checkout_date"
                                            value="<%= (vOut != null ? vOut : "") %>"
                                            class="form-control <%= ("checkout_date".equals(errField) ? "is-invalid" : "") %>"
                                            required>
                                    <div class="invalid-feedback <%= ("checkout_date".equals(errField) ? "server-error" : "") %>">
                                        <%= ("checkout_date".equals(errField) ? errMsg : "Please choose a check-out date.") %>
                                    </div>
                                </div>

                                <div class="col-12 mt-2 d-flex flex-wrap gap-2">
                                    <button class="btn btn-ovr text-white px-4" type="submit">
                                        <i class="bi bi-check2-circle me-1"></i> Reserve Room
                                    </button>
                                    <a class="btn btn-outline-secondary px-4" href="<%=request.getContextPath()%>/viewReservations">
                                        <i class="bi bi-card-list me-1"></i> View Reservations
                                    </a>
                                </div>
                            </div>

                            <hr class="my-4">

                            <p class="text-muted small mb-0">
                                Tip: Use correct contact number and select valid dates to avoid validation errors.
                            </p>

                        </form>

                    </div>
                </div>

                <p class="text-center text-muted small mt-3 mb-0">
                    © <%=java.time.Year.now()%> Ocean View Resort
                </p>

            </div>
        </div>
    </div>
</main>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>

<!-- Bootstrap validation -->
<script>
    (() => {
        'use strict';
        const forms = document.querySelectorAll('.needs-validation');

        Array.from(forms).forEach(form => {
            form.addEventListener('submit', event => {
                if (!form.checkValidity()) {
                    event.preventDefault();
                    event.stopPropagation();
                }
                form.classList.add('was-validated');
            }, false);
        });
    })();

    // Small helper: auto-fix checkout >= checkin (optional UX)
    const inEl = document.querySelector('input[name="checkin_date"]');
    const outEl = document.querySelector('input[name="checkout_date"]');
    if (inEl && outEl) {
        inEl.addEventListener('change', () => {
            if (inEl.value) outEl.min = inEl.value;
            if (outEl.value && inEl.value && outEl.value < inEl.value) outEl.value = inEl.value;
        });
    }
</script>

</body>
</html>