package com.ocean.servlet;

import com.ocean.db.ReservationDBUtil;
import com.ocean.model.Reservation;

import javax.servlet.*;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;
import java.util.List;

@WebServlet("/admin/cancelledReservations")
public class CancelledReservationsServlet extends HttpServlet {

    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);

        if (session == null || session.getAttribute("role") == null ||
                !"ADMIN".equalsIgnoreCase((String) session.getAttribute("role"))) {

            response.sendRedirect(request.getContextPath() + "/viewReservations");
            return;
        }

        List<Reservation> list = ReservationDBUtil.getCancelledReservations();
        request.setAttribute("list", list);

        RequestDispatcher rd = request.getRequestDispatcher("/WEB-INF/cancelledReservations.jsp");
        rd.forward(request, response);
    }
}