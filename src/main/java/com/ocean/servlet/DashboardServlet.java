package com.ocean.servlet;

import com.ocean.db.DBConnection;
import com.ocean.db.RoomDBUtil;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;

import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.time.LocalDate;
import java.time.temporal.ChronoUnit;

@WebServlet("/dashboard")
public class DashboardServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("username") == null) {
            response.sendRedirect(request.getContextPath() + "/login.jsp?msg=pleaselogin");
            return;
        }

        int totalReservations = 0;
        int todayCheckIns = 0;
        long revenueEstimate = 0;

        try (Connection con = DBConnection.getConnection()) {

            try (PreparedStatement ps = con.prepareStatement("SELECT COUNT(*) FROM reservations");
                 ResultSet rs = ps.executeQuery()) {
                if (rs.next()) totalReservations = rs.getInt(1);
            }

            try (PreparedStatement ps = con.prepareStatement("SELECT COUNT(*) FROM reservations WHERE check_in = CURDATE()");
                 ResultSet rs = ps.executeQuery()) {
                if (rs.next()) todayCheckIns = rs.getInt(1);
            }

            // Revenue estimate (sum rooms rate * nights + 10% service)
            String sql = "SELECT room_type, check_in, check_out FROM reservations";
            try (PreparedStatement ps = con.prepareStatement(sql);
                 ResultSet rs = ps.executeQuery()) {

                while (rs.next()) {
                    String roomType = rs.getString("room_type");
                    java.sql.Date inD = rs.getDate("check_in");
                    java.sql.Date outD = rs.getDate("check_out");
                    if (inD == null || outD == null) continue;

                    LocalDate in = inD.toLocalDate();
                    LocalDate out = outD.toLocalDate();
                    long nights = ChronoUnit.DAYS.between(in, out);
                    if (nights <= 0) nights = 1;

                    int rate = RoomDBUtil.getRatePerNight(roomType);
                    long subtotal = rate * nights;
                    long service = Math.round(subtotal * 0.10);
                    revenueEstimate += (subtotal + service);
                }
            }

        } catch (Exception e) {
            throw new ServletException(e);
        }

        request.setAttribute("totalReservations", totalReservations);
        request.setAttribute("todayCheckIns", todayCheckIns);
        request.setAttribute("revenueEstimate", revenueEstimate);

        request.getRequestDispatcher("/WEB-INF/dashboard.jsp").forward(request, response);
    }
}