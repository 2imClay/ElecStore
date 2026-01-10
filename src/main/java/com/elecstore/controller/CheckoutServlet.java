package com.elecstore.controller;

import com.elecstore.dao.*;
import com.elecstore.model.*;
import com.google.gson.JsonObject;
import jakarta.servlet.*;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.io.PrintWriter;
import java.sql.SQLException;
import java.util.*;

public class CheckoutServlet extends HttpServlet {

    private CartDAO cartDAO = new CartDAOImpl();
    private CartItemDAO cartItemDAO = new CartItemDAOImpl();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("user");

        if (user == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        String path = request.getServletPath();

        if ("/checkout".equals(path)) {
            // Lấy giỏ hàng từ session hoặc DB
            int userId = user.getId();

            Cart cart = cartDAO.findByUserId(userId);

            // If no cart exists, create one
            if (cart == null) {
                cart = cartDAO.createCart(userId);
            }

            // 3. Get cart items
            List<CartItem> cartItems = cartItemDAO.getCartItems(cart.getId());
            if (cartItems == null) cartItems = new ArrayList<>();

            double subtotal = cartItems.stream()
                    .mapToDouble(item -> item.getPrice() * item.getQuantity())
                    .sum();

            request.setAttribute("cartItems", cartItems);
            request.setAttribute("subtotal", subtotal);
            request.getRequestDispatcher("/WEB-INF/views/checkout.jsp").forward(request, response);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        response.setContentType("application/json;charset=UTF-8");
        PrintWriter out = response.getWriter();
        JsonObject result = new JsonObject();

        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("user");

        if (user == null) {
            result.addProperty("success", false);
            result.addProperty("message", "Vui lòng đăng nhập!");
            out.print(result);
            return;
        }

        String path = request.getServletPath();

        if ("/checkout/create-order".equals(path)) {
            try {
                // Lấy dữ liệu từ form
                String fullName = request.getParameter("fullName");
                String phone = request.getParameter("phone");
                String email = request.getParameter("email");
                String address = request.getParameter("address");
                String city = request.getParameter("city");
                String country = request.getParameter("country");
                String paymentMethod = request.getParameter("paymentMethod");
                String note = request.getParameter("note");

                // Lấy giỏ hàng
                int userId = user.getId();

                Cart cart = cartDAO.findByUserId(userId);

                // If no cart exists, create one
                if (cart == null) {
                    cart = cartDAO.createCart(userId);
                }

                // 3. Get cart items
                List<CartItem> cartItems = cartItemDAO.getCartItems(cart.getId());
                if (cartItems == null || cartItems.isEmpty()) {
                    result.addProperty("success", false);
                    result.addProperty("message", "Giỏ hàng trống!");
                    out.print(result);
                    return;
                }

                // Tính tổng tiền
                double subtotal = cartItems.stream()
                        .mapToDouble(item -> item.getPrice() * item.getQuantity())
                        .sum();
                double shippingFee = 30000;
                double totalAmount = subtotal + shippingFee;

                // TẠO ĐƠN HÀNG
                Order order = new Order();
                order.setUserId(user.getId());
                order.setCustomerName(fullName);
                order.setOrderDate(new java.util.Date());
                order.setTotalAmount(totalAmount);
                order.setStatus("pending");
                order.setAddress(address);
                order.setPhone(phone);
                order.setNote(note);
                order.setPaymentMethod(paymentMethod);

                OrderDAO orderDAO = new OrderDAOImpl();
                int orderId = orderDAO.createOrder(order);

                if (orderId > 0) {
                    // TẠO CHI TIẾT ĐƠN HÀNG
                    for (CartItem item : cartItems) {
                        OrderDetail detail = new OrderDetail();
                        detail.setOrderId(orderId);
                        detail.setProductId(item.getId());
                        detail.setQuantity(item.getQuantity());
                        detail.setPrice(item.getPrice());
                        orderDAO.addOrderDetail(detail);
                    }

                    // XÓA GIỎ HÀNG
                    session.removeAttribute("cart");

                    result.addProperty("success", true);
                    result.addProperty("message", "Đặt hàng thành công!");
                    result.addProperty("orderId", orderId);
                } else {
                    result.addProperty("success", false);
                    result.addProperty("message", "Lỗi khi tạo đơn hàng!");
                }

            } catch (Exception e) {
                e.printStackTrace();
                result.addProperty("success", false);
                result.addProperty("message", "Lỗi hệ thống: " + e.getMessage());
            }

            out.print(result);
        }
    }
}
