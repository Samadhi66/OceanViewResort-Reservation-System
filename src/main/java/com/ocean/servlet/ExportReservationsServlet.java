package com.ocean.servlet;

import java.io.IOException;
import java.io.PrintWriter;
import java.sql.Date;
import java.util.List;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import com.ocean.db.ReservationDBUtil;
import com.ocean.model.Reservation;

@WebServlet("/exportReservations")
public class ExportReservationsServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);

        if (session == null || session.getAttribute("username") == null) {
            response.sendRedirect(request.getContextPath() + "/login.jsp?msg=pleaselogin");
            return;
        }

        String type = request.getParameter("type");
        if (type == null || type.trim().isEmpty()) {
            type = "csv";
        }

        String q = request.getParameter("q");
        String fromStr = request.getParameter("from");
        String toStr = request.getParameter("to");

        Date from = null;
        Date to = null;

        try {
            if (fromStr != null && !fromStr.trim().isEmpty()) {
                from = Date.valueOf(fromStr);
            }
            if (toStr != null && !toStr.trim().isEmpty()) {
                to = Date.valueOf(toStr);
            }
        } catch (Exception ignored) {}

        boolean hasSearch =
                (q != null && !q.trim().isEmpty()) ||
                (fromStr != null && !fromStr.trim().isEmpty()) ||
                (toStr != null && !toStr.trim().isEmpty());

        String qq = hasSearch ? q : null;

        // Export all matching UPCOMING reservations
        List<Reservation> list = ReservationDBUtil.getReservationsPaged(qq, from, to, 1, 1000);

        // ===================== PRINT MODE =====================
        if ("print".equalsIgnoreCase(type)) {

            response.setContentType("text/html; charset=UTF-8");
            PrintWriter out = response.getWriter();

            out.println("<!DOCTYPE html>");
            out.println("<html><head><meta charset='UTF-8'>");
            out.println("<title>Reservations Report</title>");
            out.println("<style>");
            out.println("body{font-family:Arial;}");
            out.println("table{width:100%;border-collapse:collapse;}");
            out.println("th,td{border:1px solid #ddd;padding:8px;}");
            out.println("th{background:#f0f2f8;}");
            out.println(".top{display:flex;justify-content:space-between;align-items:center;}");
            out.println("</style>");
            out.println("</head><body>");

            out.println("<div class='top'>");
            out.println("<h2>Reservations Report</h2>");
            out.println("<button onclick='window.print()'>Print / Save as PDF</button>");
            out.println("</div>");

            out.println("<p><strong>Filters:</strong> q=" + esc(q)
                    + " | from=" + esc(fromStr)
                    + " | to=" + esc(toStr) + "</p>");

            out.println("<table>");
            out.println("<tr>");
            out.println("<th>No</th>");
            out.println("<th>Guest</th>");
            out.println("<th>Contact</th>");
            out.println("<th>Room</th>");
            out.println("<th>Check-in</th>");
            out.println("<th>Check-out</th>");
            out.println("</tr>");

            for (Reservation r : list) {
                out.println("<tr>");
                out.println("<td>" + esc(r.getReservationNo()) + "</td>");
                out.println("<td>" + esc(r.getGuestName()) + "</td>");
                out.println("<td>" + esc(r.getContactNo()) + "</td>");
                out.println("<td>" + esc(r.getRoomType()) + "</td>");
                out.println("<td>" + esc(String.valueOf(r.getCheckIn())) + "</td>");
                out.println("<td>" + esc(String.valueOf(r.getCheckOut())) + "</td>");
                out.println("</tr>");
            }

            out.println("</table>");
            out.println("</body></html>");
            return;
        }

        // ===================== CSV MODE =====================
        response.setContentType("text/csv; charset=UTF-8");
        response.setHeader("Content-Disposition", "attachment; filename=\"reservations.csv\"");

        try (PrintWriter out = response.getWriter()) {

            out.println("reservation_no,guest_name,contact_number,room_type,check_in,check_out");

            for (Reservation r : list) {
                out.println(
                        csv(r.getReservationNo()) + "," +
                        csv(r.getGuestName()) + "," +
                        csv(r.getContactNo()) + "," +
                        csv(r.getRoomType()) + "," +
                        csv(String.valueOf(r.getCheckIn())) + "," +
                        csv(String.valueOf(r.getCheckOut()))
                );
            }
        }
    }

    // ===================== CSV SAFE =====================
    private String csv(String s) {
        if (s == null) s = "";
        s = s.replace("\"", "\"\"");
        return "\"" + s + "\"";
    }

    // ===================== HTML ESCAPE =====================
    private String esc(String s) {
        if (s == null) return "";
        return s.replace("&", "&amp;")
                .replace("<", "&lt;")
                .replace(">", "&gt;");
    }
}