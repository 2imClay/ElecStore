package com.elecstore.controller;

import com.elecstore.dao.*;
import com.elecstore.model.*;
import com.google.gson.JsonObject;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.io.PrintWriter;
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

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        resp.setContentType("application/json;charset=UTF-8");
        PrintWriter out = resp.getWriter();
        JsonObject result = new JsonObject();

        String action = req.getParameter("action");

        switch (action) {
            case "toggleUserStatus": {
                try {
                    int userId = Integer.parseInt(req.getParameter("userId"));
                    String status = req.getParameter("status");

                    User user = userDAO.getById(userId);

                    if (user == null) {
                        result.addProperty("success", false);
                        result.addProperty("message", "Không tìm thấy user!");
                    } else if ("admin".equals(user.getRole())) {
                        result.addProperty("success", false);
                        result.addProperty("message", "Không thể thay đổi trạng thái của admin!");
                    } else {
                        userDAO.updateUserStatus(userId, status);
                        result.addProperty("success", true);
                        result.addProperty("message", "Cập nhật thành công!");
                    }

                } catch (Exception e) {
                    e.printStackTrace();
                    result.addProperty("success", false);
                    result.addProperty("message", "Lỗi hệ thống: " + e.getMessage());
                }
                break;
            }
            case "toggleProductStatus": {
                try {
                    int productId = Integer.parseInt(req.getParameter("productId"));
                    String status = req.getParameter("status");

                    productDAO.updateStatus(productId, status);

                    result.addProperty("success", true);
                    result.addProperty("message", "Cập nhật thành công!");

                } catch (Exception e) {
                    e.printStackTrace();
                    result.addProperty("success", false);
                    result.addProperty("message", "Lỗi hệ thống: " + e.getMessage());
                }
                break;
            }
            case "toggleCategoryStatus": {
                try {
                    int categoryId = Integer.parseInt(req.getParameter("categoryId"));
                    String status = req.getParameter("status");

                    categoryDAO.updateStatus(categoryId, status);

                    result.addProperty("success", true);
                    result.addProperty("message", "Cập nhật thành công!");

                } catch (Exception e) {
                    e.printStackTrace();
                    result.addProperty("success", false);
                    result.addProperty("message", "Lỗi hệ thống: " + e.getMessage());
                }
                break;
            }
            case "updateOrderStatus": {
                try {
                    int orderId = Integer.parseInt(req.getParameter("orderId"));
                    String status = req.getParameter("status");

                    orderDAO.updateStatus(orderId, status);

                    result.addProperty("success", true);
                    result.addProperty("message", "Cập nhật thành công!");

                } catch (Exception e) {
                    e.printStackTrace();
                    result.addProperty("success", false);
                    result.addProperty("message", "Lỗi hệ thống: " + e.getMessage());
                }
                break;
            }
        }

        out.print(result.toString());
        out.flush();
    }
}
