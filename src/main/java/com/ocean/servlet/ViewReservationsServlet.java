package com.ocean.servlet;

import java.io.IOException;
import java.sql.Date;
import java.util.List;

import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;

import com.ocean.db.ReservationDBUtil;
import com.ocean.model.Reservation;

@WebServlet("/viewReservations")
public class ViewReservationsServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");
        response.setCharacterEncoding("UTF-8");

        String q = request.getParameter("q");
        String fromStr = request.getParameter("from");
        String toStr = request.getParameter("to");

        // Pagination
        int page = 1;
        int size = 10;

        try {
            if (request.getParameter("page") != null) page = Integer.parseInt(request.getParameter("page"));
            if (request.getParameter("size") != null) size = Integer.parseInt(request.getParameter("size"));
        } catch (Exception ignored) {}

        if (page < 1) page = 1;
        if (size < 5) size = 5;
        if (size > 50) size = 50;

        Date from = null;
        Date to = null;
        try {
            if (fromStr != null && !fromStr.trim().isEmpty()) from = Date.valueOf(fromStr);
            if (toStr != null && !toStr.trim().isEmpty()) to = Date.valueOf(toStr);
        } catch (Exception ignored) {}

        // IMPORTANT: empty q=&from=&to= should NOT trigger search
        boolean hasSearch =
                (q != null && !q.trim().isEmpty()) ||
                (fromStr != null && !fromStr.trim().isEmpty()) ||
                (toStr != null && !toStr.trim().isEmpty());

        String qq = hasSearch ? q : null;

        int total = ReservationDBUtil.countReservations(qq, from, to);
        int totalPages = (int) Math.ceil(total / (double) size);
        if (totalPages <= 0) totalPages = 1;
        if (page > totalPages) page = totalPages;

        List<Reservation> list = ReservationDBUtil.getReservationsPaged(qq, from, to, page, size);

        request.setAttribute("list", list);
        request.setAttribute("page", page);
        request.setAttribute("size", size);
        request.setAttribute("totalPages", totalPages);
        request.setAttribute("total", total);

        RequestDispatcher rd = request.getRequestDispatcher("/WEB-INF/viewReservations.jsp");
        rd.forward(request, response);
    }
}