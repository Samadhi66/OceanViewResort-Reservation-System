package com.ocean.servlet;

import com.ocean.db.DBConnection;
import com.ocean.db.ReservationDBUtil;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;

import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;

@WebServlet("/AddReservationServlet")
public class AddReservationServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String guestName = request.getParameter("guest_name");
        String address = request.getParameter("address");
        String contactNumber = request.getParameter("contact_number");
        String roomType = request.getParameter("room_type");
        String checkInStr = request.getParameter("checkin_date");
        String checkOutStr = request.getParameter("checkout_date");

        java.util.function.BiConsumer<String, String> fail = (field, message) -> {
            try {
                request.setAttribute("errField", field);
                request.setAttribute("errMsg", message);
                request.getRequestDispatcher("reservation.jsp").forward(request, response);
            } catch (Exception e) {
                throw new RuntimeException(e);
            }
        };

        // Validation
        if (guestName == null || guestName.trim().isEmpty()) {
            fail.accept("guest_name", "Guest name is required.");
            return;
        }

        if (contactNumber == null || !contactNumber.matches("\\d{10}")) {
            fail.accept("contact_number", "Contact number must be exactly 10 digits.");
            return;
        }

        if (roomType == null || roomType.trim().isEmpty()) {
            fail.accept("room_type", "Please select a room type.");
            return;
        }

        if (checkInStr == null || checkInStr.trim().isEmpty()) {
            fail.accept("checkin_date", "Please select a check-in date.");
            return;
        }

        if (checkOutStr == null || checkOutStr.trim().isEmpty()) {
            fail.accept("checkout_date", "Please select a check-out date.");
            return;
        }

        java.sql.Date checkInDate;
        java.sql.Date checkOutDate;

        try {
            checkInDate = java.sql.Date.valueOf(checkInStr);
            checkOutDate = java.sql.Date.valueOf(checkOutStr);
        } catch (Exception ex) {
            fail.accept("checkin_date", "Invalid date value. Please select dates again.");
            return;
        }

        if (!checkOutDate.after(checkInDate)) {
            fail.accept("checkout_date", "Check-out date must be after check-in date.");
            return;
        }

        // ✅ Step 3: Overlap validation
        boolean available = ReservationDBUtil.isRoomAvailable(roomType, checkInDate, checkOutDate, null);
        if (!available) {
            fail.accept("room_type", "This room type is already booked for the selected dates.");
            return;
        }

        // Insert into DB
        try (Connection con = DBConnection.getConnection()) {

            // Generate next reservation number: R001, R002, ...
            String nextResNo = "R001";
            String lastSql = "SELECT reservation_no FROM reservations ORDER BY reservation_no DESC LIMIT 1";

            try (PreparedStatement psLast = con.prepareStatement(lastSql);
                 ResultSet rsLast = psLast.executeQuery()) {

                if (rsLast.next()) {
                    String lastNo = rsLast.getString("reservation_no");
                    int num = Integer.parseInt(lastNo.substring(1)) + 1;
                    nextResNo = String.format("R%03d", num);
                }
            }

            String sql = "INSERT INTO reservations " +
                    "(reservation_no, guest_name, address, contact_number, room_type, check_in, check_out) " +
                    "VALUES (?, ?, ?, ?, ?, ?, ?)";

            try (PreparedStatement ps = con.prepareStatement(sql)) {
                ps.setString(1, nextResNo);
                ps.setString(2, guestName);
                ps.setString(3, address);
                ps.setString(4, contactNumber);
                ps.setString(5, roomType);
                ps.setDate(6, checkInDate);
                ps.setDate(7, checkOutDate);
                ps.executeUpdate();
            }

            response.sendRedirect(request.getContextPath() + "/viewReservations");

        } catch (Exception e) {
            throw new ServletException(e);
        }
    }
}