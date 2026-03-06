package com.ocean.servlet;

import com.ocean.db.DBConnection;
import com.ocean.db.RoomDBUtil;
import com.ocean.model.Reservation;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;

import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.time.LocalDate;
import java.time.temporal.ChronoUnit;

@WebServlet("/bill")
public class BillServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("username") == null) {
            response.sendRedirect(request.getContextPath() + "/login.jsp?msg=pleaselogin");
            return;
        }

        String resNo = request.getParameter("resNo");
        if (resNo == null || resNo.trim().isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/viewReservations");
            return;
        }

        Reservation r = null;

        String sql = "SELECT reservation_no, guest_name, address, contact_number, room_type, check_in, check_out " +
                "FROM reservations WHERE reservation_no = ?";

        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setString(1, resNo);

            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    r = new Reservation();
                    r.setReservationNo(rs.getString("reservation_no"));
                    r.setGuestName(rs.getString("guest_name"));
                    r.setAddress(rs.getString("address"));
                    r.setContactNo(rs.getString("contact_number"));
                    r.setRoomType(rs.getString("room_type"));
                    r.setCheckIn(rs.getDate("check_in"));
                    r.setCheckOut(rs.getDate("check_out"));
                }
            }

        } catch (Exception e) {
            throw new ServletException(e);
        }

        if (r == null) {
            request.setAttribute("error", "Reservation not found for: " + resNo);
            request.getRequestDispatcher("/bill.jsp").forward(request, response);
            return;
        }

        LocalDate in = r.getCheckIn().toLocalDate();
        LocalDate out = r.getCheckOut().toLocalDate();
        long nights = ChronoUnit.DAYS.between(in, out);
        if (nights <= 0) nights = 1;

        int rate = RoomDBUtil.getRatePerNight(r.getRoomType());
        long subtotal = rate * nights;

        double serviceRate = 0.10; // 10%
        long serviceCharge = Math.round(subtotal * serviceRate);
        long total = subtotal + serviceCharge;

        request.setAttribute("r", r);
        request.setAttribute("nights", nights);
        request.setAttribute("rate", rate);
        request.setAttribute("subtotal", subtotal);
        request.setAttribute("serviceCharge", serviceCharge);
        request.setAttribute("total", total);

        request.getRequestDispatcher("/bill.jsp").forward(request, response);
    }
}