package com.ocean.servlet;

import com.ocean.db.DBConnection;
import com.ocean.db.ReservationDBUtil;
import com.ocean.model.Reservation;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;

import java.io.IOException;
import java.sql.Connection;
import java.sql.Date;
import java.sql.PreparedStatement;
import java.sql.ResultSet;

@WebServlet("/reservation/edit")
public class EditReservationServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("username") == null) {
            response.sendRedirect(request.getContextPath() + "/login.jsp?msg=pleaselogin");
            return;
        }

        String id = request.getParameter("id");
        if (id == null || id.trim().isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/viewReservations");
            return;
        }

        String sql = "SELECT reservation_no, guest_name, address, contact_number, room_type, check_in, check_out " +
                     "FROM reservations WHERE reservation_no=?";

        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setString(1, id);

            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    Reservation r = new Reservation();
                    r.setReservationNo(rs.getString("reservation_no"));
                    r.setGuestName(rs.getString("guest_name"));
                    r.setAddress(rs.getString("address"));
                    r.setContactNo(rs.getString("contact_number"));
                    r.setRoomType(rs.getString("room_type"));
                    r.setCheckIn(rs.getDate("check_in"));
                    r.setCheckOut(rs.getDate("check_out"));

                    request.setAttribute("reservation", r);
                    request.getRequestDispatcher("/WEB-INF/editReservation.jsp")
                           .forward(request, response);
                    return;
                }
            }

            response.sendRedirect(request.getContextPath() + "/viewReservations?msg=notfound");

        } catch (Exception e) {
            throw new ServletException(e);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("username") == null) {
            response.sendRedirect(request.getContextPath() + "/login.jsp?msg=pleaselogin");
            return;
        }

        String reservationNo = request.getParameter("reservation_no");
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

                Reservation r = new Reservation();
                r.setReservationNo(reservationNo);
                r.setGuestName(guestName);
                r.setAddress(address);
                r.setContactNo(contactNumber);
                r.setRoomType(roomType);
                try { r.setCheckIn(Date.valueOf(checkInStr)); } catch (Exception ignored) {}
                try { r.setCheckOut(Date.valueOf(checkOutStr)); } catch (Exception ignored) {}

                request.setAttribute("reservation", r);
                request.getRequestDispatcher("/WEB-INF/editReservation.jsp").forward(request, response);
            } catch (Exception e) {
                throw new RuntimeException(e);
            }
        };

        if (reservationNo == null || reservationNo.trim().isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/viewReservations");
            return;
        }

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

        Date checkInDate;
        Date checkOutDate;

        try {
            checkInDate = Date.valueOf(checkInStr);
            checkOutDate = Date.valueOf(checkOutStr);
        } catch (Exception ex) {
            fail.accept("checkin_date", "Invalid date value. Please select dates again.");
            return;
        }

        if (!checkOutDate.after(checkInDate)) {
            fail.accept("checkout_date", "Check-out date must be after check-in date.");
            return;
        }

        // ✅ Step 3: Overlap validation (exclude current reservation)
        boolean available = ReservationDBUtil.isRoomAvailable(roomType, checkInDate, checkOutDate, reservationNo);
        if (!available) {
            fail.accept("room_type", "This room type is already booked for the selected dates.");
            return;
        }

        String sql = "UPDATE reservations SET guest_name=?, address=?, contact_number=?, room_type=?, check_in=?, check_out=? " +
                     "WHERE reservation_no=?";

        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setString(1, guestName);
            ps.setString(2, address);
            ps.setString(3, contactNumber);
            ps.setString(4, roomType);
            ps.setDate(5, checkInDate);
            ps.setDate(6, checkOutDate);
            ps.setString(7, reservationNo);

            ps.executeUpdate();

            response.sendRedirect(request.getContextPath() + "/viewReservations?msg=updated&resNo=" + reservationNo);

        } catch (Exception e) {
            throw new ServletException(e);
        }
    }
}