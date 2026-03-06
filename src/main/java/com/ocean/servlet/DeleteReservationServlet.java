package com.ocean.servlet;

import com.ocean.db.DBConnection;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;

import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;

@WebServlet("/reservation/delete")
public class DeleteReservationServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
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

        String sql = "UPDATE reservations SET status='CANCELLED' WHERE reservation_no=?";
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setString(1, id);
            int rows = ps.executeUpdate();

            if (rows > 0) {
                response.sendRedirect(request.getContextPath() + "/viewReservations?msg=deleted&resNo=" + id);
            } else {
                response.sendRedirect(request.getContextPath() + "/viewReservations?msg=notfound");
            }

        } catch (Exception e) {
            throw new ServletException(e);
        }
    }
}