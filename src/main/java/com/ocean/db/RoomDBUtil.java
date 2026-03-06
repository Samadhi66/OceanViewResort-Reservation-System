package com.ocean.db;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;

public class RoomDBUtil {

    public static int getRatePerNight(String roomType) {
        if (roomType == null) return 0;

        String sql = "SELECT price_per_day FROM rooms WHERE room_type = ?";

        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setString(1, roomType);

            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return (int) Math.round(rs.getDouble(1));
                }
            }
        } catch (Exception ignored) {
            // fallback below
        }

        // fallback (if rooms table not filled yet)
        switch (roomType.toLowerCase()) {
            case "single": return 5000;
            case "double": return 8000;
            case "family": return 12000;
            default: return 0;
        }
    }
}