package com.elecstore.controller;

import com.elecstore.dao.*;
import com.elecstore.model.*;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.util.List;

public class AdminDashboardServlet extends HttpServlet {

    private UserDAO userDAO = new UserDAOImpl();
    private ProductDAO productDAO = new ProductDAOImpl();
    private CategoryDAO categoryDAO = new CategoryDAOImpl();
    private OrderDAO orderDAO = new OrderDAOImpl();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("user");

        // 1. Check Admin Role
        if (user == null || !"admin".equalsIgnoreCase(user.getRole())) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        // 2. Get Data Lists
        try {
            List<User> users = userDAO.getAll();
            List<Product> products = productDAO.findAll();
            List<Category> categories = categoryDAO.findAll();
            List<Order> orders = orderDAO.getAllOrders();

            // 3. Set Attributes for JSP
            request.setAttribute("users", users);
            request.setAttribute("products", products);
            request.setAttribute("categories", categories);
            request.setAttribute("orders", orders);

            // 4. Calculate Stats (Optional - if you want real numbers in cards)
            request.setAttribute("totalRevenue", orderDAO.calculateTotalRevenue());
            request.setAttribute("totalOrders", orders.size());
            request.setAttribute("totalProducts", products.size());
            request.setAttribute("totalUsers", users.size());

            request.getRequestDispatcher("/WEB-INF/views/admin-dashboard.jsp").forward(request, response);
        } catch (Exception e){
            System.err.println("[AdminServlet] Error: " + e.getMessage());
            e.printStackTrace();
        }
    }
}
