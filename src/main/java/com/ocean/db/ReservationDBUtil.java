package com.ocean.db;

import java.sql.Connection;
import java.sql.Date;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;

import com.ocean.model.Reservation;

public class ReservationDBUtil {

    // ===================== COUNT (UPCOMING only) =====================
    public static int countReservations(String q, Date from, Date to) {

        StringBuilder sql = new StringBuilder(
                "SELECT COUNT(*) FROM reservations WHERE status='UPCOMING'");
        List<Object> params = new ArrayList<>();

        if (q != null && !q.trim().isEmpty()) {
            q = q.trim();
            sql.append(" AND (reservation_no = ? OR guest_name LIKE ?)");
            params.add(q);
            params.add("%" + q + "%");
        }

        if (from != null) {
            sql.append(" AND check_in >= ?");
            params.add(from);
        }
        if (to != null) {
            sql.append(" AND check_out <= ?");
            params.add(to);
        }

        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql.toString())) {

            bindParams(ps, params);

            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) return rs.getInt(1);
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return 0;
    }

    // ===================== LIST (UPCOMING only, paged) =====================
    public static List<Reservation> getReservationsPaged(String q, Date from, Date to, int page, int size) {

        List<Reservation> list = new ArrayList<>();
        int offset = (page - 1) * size;

        StringBuilder sql = new StringBuilder(
                "SELECT * FROM reservations WHERE status='UPCOMING'");
        List<Object> params = new ArrayList<>();

        if (q != null && !q.trim().isEmpty()) {
            q = q.trim();
            sql.append(" AND (reservation_no = ? OR guest_name LIKE ?)");
            params.add(q);
            params.add("%" + q + "%");
        }

        if (from != null) {
            sql.append(" AND check_in >= ?");
            params.add(from);
        }
        if (to != null) {
            sql.append(" AND check_out <= ?");
            params.add(to);
        }

        sql.append(" ORDER BY created_at DESC LIMIT ? OFFSET ?");
        params.add(size);
        params.add(offset);

        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql.toString())) {

            bindParams(ps, params);

            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    list.add(mapReservation(rs));
                }
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return list;
    }

    // ===================== CANCELLED RESERVATIONS (ADMIN ONLY) =====================
    public static List<Reservation> getCancelledReservations() {

        List<Reservation> list = new ArrayList<>();

        String sql = "SELECT * FROM reservations WHERE status='CANCELLED' ORDER BY created_at DESC";

        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                list.add(mapReservation(rs));
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return list;
    }

    // ===================== ROOM AVAILABILITY (UPCOMING only) =====================
    public static boolean isRoomAvailable(String roomType, Date newCheckIn, Date newCheckOut, String excludeReservationNo) {

        String sql = "SELECT COUNT(*) FROM reservations " +
                "WHERE status='UPCOMING' " +
                "AND room_type = ? " +
                "AND NOT (check_out <= ? OR check_in >= ?) " +
                (excludeReservationNo != null ? "AND reservation_no <> ? " : "");

        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            int i = 1;
            ps.setString(i++, roomType);
            ps.setDate(i++, newCheckIn);
            ps.setDate(i++, newCheckOut);
            if (excludeReservationNo != null) {
                ps.setString(i++, excludeReservationNo);
            }

            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt(1) == 0;
                }
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return false;
    }

    // ===================== EXPORT / CALENDAR (UPCOMING only) =====================
    public static List<Reservation> getReservationsForRange(Date from, Date to) {

        List<Reservation> list = new ArrayList<>();

        String sql = "SELECT * FROM reservations " +
                "WHERE status='UPCOMING' " +
                "AND check_in <= ? AND check_out >= ? " +
                "ORDER BY created_at DESC";

        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setDate(1, to);
            ps.setDate(2, from);

            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    list.add(mapReservation(rs));
                }
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return list;
    }

    // ===================== MAPPING =====================
    private static Reservation mapReservation(ResultSet rs) throws Exception {
        Reservation r = new Reservation();
        r.setReservationNo(rs.getString("reservation_no"));
        r.setGuestName(rs.getString("guest_name"));
        r.setAddress(rs.getString("address"));
        r.setContactNo(rs.getString("contact_number"));
        r.setRoomType(rs.getString("room_type"));
        r.setCheckIn(rs.getDate("check_in"));
        r.setCheckOut(rs.getDate("check_out"));
        return r;
    }

    private static void bindParams(PreparedStatement ps, List<Object> params) throws Exception {
        for (int i = 0; i < params.size(); i++) {
            Object p = params.get(i);
            int idx = i + 1;

            if (p instanceof Date) ps.setDate(idx, (Date) p);
            else if (p instanceof Integer) ps.setInt(idx, (Integer) p);
            else ps.setString(idx, String.valueOf(p));
        }
    }
}