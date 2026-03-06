package com.ocean.servlet;

import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;

import com.ocean.db.DBConnection;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;

@WebServlet("/LoginServlet")
public class LoginServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");
        response.setCharacterEncoding("UTF-8");

        String username = request.getParameter("username");
        String password = request.getParameter("password");

        if (username == null || username.trim().isEmpty() ||
            password == null || password.trim().isEmpty()) {

            response.sendRedirect(request.getContextPath() + "/login.jsp?msg=empty");
            return;
        }

        String sql = "SELECT user_id, username, role, password FROM users WHERE username=?";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, username);

            try (ResultSet rs = ps.executeQuery()) {

                if (rs.next()) {

                    String dbUsername = rs.getString("username");
                    String dbRole = rs.getString("role");
                    String dbPassword = rs.getString("password");

                    if (password.equals(dbPassword)) {

                        HttpSession session = request.getSession(true);
                        session.setAttribute("username", dbUsername);
                        session.setAttribute("role", dbRole);

                        // ⭐ LOGIN SUCCESS MESSAGE
                        session.setAttribute("loginSuccess", "Login successful! Welcome back.");

                        if ("ADMIN".equalsIgnoreCase(dbRole)) {
                            response.sendRedirect(request.getContextPath() + "/dashboard");
                        } 
                        else if ("RECEPTION".equalsIgnoreCase(dbRole)) {
                            response.sendRedirect(request.getContextPath() + "/receptionDashboard.jsp");
                        }
                        else {
                            response.sendRedirect(request.getContextPath() + "/login.jsp?msg=invalid");
                        }

                        return;
                    }
                }
            }

            response.sendRedirect(request.getContextPath() + "/login.jsp?msg=invalid");

        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect(request.getContextPath() + "/login.jsp?msg=error");
        }
    }
}