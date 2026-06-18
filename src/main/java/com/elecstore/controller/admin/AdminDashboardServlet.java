package com.elecstore.controller.admin;

import com.elecstore.dao.*;
import com.elecstore.model.*;
import com.elecstore.utils.OrderDocumentUtil;
import com.google.gson.JsonObject;
import jakarta.servlet.ServletException;
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
    private OrderSignatureDAO orderSignatureDAO = new OrderSignatureDAOImpl();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("user");

        if (user == null || !"admin".equalsIgnoreCase(user.getRole())) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        try {
            List<User> users = userDAO.getAll();
            List<Product> products = productDAO.findAll();
            List<Category> categories = categoryDAO.findAll();
            List<Order> orders = orderDAO.getAllOrders();

            for (Order order : orders) {
                attachVerificationStatus(order);
            }

            request.setAttribute("users", users);
            request.setAttribute("products", products);
            request.setAttribute("categories", categories);
            request.setAttribute("orders", orders);

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

    private RSAKeyDAO rsaKeyDAO = new RSAKeyDAOImpl();

    private void attachVerificationStatus(Order order) {
        OrderSignature signature = orderSignatureDAO.getLatestByOrderId(order.getId());

        if (signature == null) {
            order.setVerificationStatus("NOT_SIGNED");
            return;
        }

        String currentSnapshot = OrderDocumentUtil.buildOrderSnapshotContent(
                order.getId(),
                order.getCustomerName(),
                order.getAddress(),
                order.getPhone(),
                order.getPaymentMethod(),
                order.getNote(),
                order.getTotalAmount(),
                order.getItems()
        );

        String currentHash = OrderDocumentUtil.sha256Hex(currentSnapshot);

        if (!currentHash.equals(signature.getOrderDataHash())) {
            order.setVerificationStatus("TAMPERED");
            order.setSignedAt(signature.getVerifiedAt());
            return;
        }

        RSAKey keyUsedToSign = rsaKeyDAO.getById(signature.getKeyId());

        if (keyUsedToSign == null) {
            order.setVerificationStatus("KEY_NOT_FOUND");
            order.setSignedAt(signature.getVerifiedAt());
            return;
        }

        boolean validSignature = com.elecstore.utils.RSASignatureVerifier.verify(
                keyUsedToSign.getPublicKey(),
                signature.getDocumentHash(),
                signature.getSignature()
        );

        if (!validSignature) {
            order.setVerificationStatus("INVALID_SIGNATURE");
            order.setSignedAt(signature.getVerifiedAt());
            return;
        }

        if (keyUsedToSign.getRevokedAt() != null
                && signature.getVerifiedAt() != null
                && !signature.getVerifiedAt().before(keyUsedToSign.getRevokedAt())) {

            order.setVerificationStatus("SIGNED_AFTER_KEY_LOST");
            order.setSignedAt(signature.getVerifiedAt());
            return;
        }

        if ("LOST".equals(keyUsedToSign.getStatus()) || "REVOKED".equals(keyUsedToSign.getStatus())) {
            order.setVerificationStatus("VALID_WITH_OLD_KEY");
        } else {
            order.setVerificationStatus("VALID");
        }

        order.setSignedAt(signature.getVerifiedAt());
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
