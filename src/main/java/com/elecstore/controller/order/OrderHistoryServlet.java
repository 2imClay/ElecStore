package com.elecstore.controller.order;

import com.elecstore.dao.OrderDAO;
import com.elecstore.dao.OrderDAOImpl;
import com.elecstore.model.Order;
import com.elecstore.model.User;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.util.List;

public class OrderHistoryServlet extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("user");

        if (user == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        try {
            OrderDAO orderDAO = new OrderDAOImpl();
            List<Order> orders = orderDAO.getOrdersByUserId(user.getId());

            request.setAttribute("orders", orders);
            request.getRequestDispatcher("/WEB-INF/views/order-history.jsp").forward(request, response);
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
}
