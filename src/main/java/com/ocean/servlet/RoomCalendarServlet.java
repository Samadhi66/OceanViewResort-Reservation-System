package com.ocean.servlet;

import com.ocean.db.ReservationDBUtil;
import com.ocean.model.Reservation;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;

import java.io.IOException;
import java.sql.Date;
import java.time.LocalDate;
import java.util.List;

@WebServlet("/roomCalendar")
public class RoomCalendarServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("username") == null) {
            response.sendRedirect(request.getContextPath() + "/login.jsp?msg=pleaselogin");
            return;
        }

        int year;
        int month; // 1-12
        LocalDate now = LocalDate.now();

        try {
            year = Integer.parseInt(request.getParameter("year"));
            month = Integer.parseInt(request.getParameter("month"));
        } catch (Exception e) {
            year = now.getYear();
            month = now.getMonthValue();
        }

        if (month < 1) month = 1;
        if (month > 12) month = 12;

        LocalDate first = LocalDate.of(year, month, 1);
        LocalDate last = first.withDayOfMonth(first.lengthOfMonth());

        // Load reservations that overlap this month
        List<Reservation> list = ReservationDBUtil.getReservationsForRange(Date.valueOf(first), Date.valueOf(last));

        request.setAttribute("year", year);
        request.setAttribute("month", month);
        request.setAttribute("first", first);
        request.setAttribute("last", last);
        request.setAttribute("list", list);

        request.getRequestDispatcher("/WEB-INF/roomCalendar.jsp").forward(request, response);
    }
}