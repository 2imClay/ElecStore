package com.elecstore.controller;

import com.elecstore.dao.CartDAO;
import com.elecstore.dao.CartDAOImpl;
import com.elecstore.dao.CartItemDAO;
import com.elecstore.dao.CartItemDAOImpl;
import com.elecstore.model.Cart;
import com.elecstore.model.CartItem;
import com.elecstore.model.RSAKey;
import com.elecstore.model.User;
import com.elecstore.service.RSAService;
import com.elecstore.utils.OrderDocumentUtil;

import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import java.io.IOException;
import java.util.ArrayList;
import java.util.List;

@WebServlet("/get-verification-data")
public class GetVerificationDataServlet extends HttpServlet {

    private final CartDAO cartDAO = new CartDAOImpl();
    private final CartItemDAO cartItemDAO = new CartItemDAOImpl();
    private final RSAService rsaService = new RSAService();

    @Override
    protected void doGet(
            HttpServletRequest request,
            HttpServletResponse response)
            throws IOException {

        response.setContentType("application/json;charset=UTF-8");

        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("user");

        if (user == null) {
            response.getWriter().write(
                    "{\"success\":false,\"message\":\"Vui lòng đăng nhập\"}");
            return;
        }

        try {

            int userId = user.getId();

            // 1. Lấy public key mới nhất của user từ bảng rsa_keys
            RSAKey rsaKey = rsaService.getLatestKey(userId);

            if (rsaKey == null) {
                response.getWriter().write(
                        "{\"success\":false,\"message\":\"Bạn chưa tạo khóa RSA. Vui lòng tạo khóa trước khi xác thực\"}");
                return;
            }

            // 2. Lấy giỏ hàng từ database (giống logic hiển thị ở trang checkout)
            Cart cart = cartDAO.findByUserId(userId);

            if (cart == null) {
                response.getWriter().write(
                        "{\"success\":false,\"message\":\"Không tìm thấy giỏ hàng\"}");
                return;
            }

            List<CartItem> cartItems = cartItemDAO.getCartItems(cart.getId());

            if (cartItems == null || cartItems.isEmpty()) {
                response.getWriter().write(
                        "{\"success\":false,\"message\":\"Giỏ hàng trống\"}");
                return;
            }

            // 3. Build nội dung document text từ dữ liệu DB
            String documentContent = buildDocumentContent(user, cartItems);

            // 4. Trả JSON kết quả
            String json = "{"
                    + "\"success\":true,"
                    + "\"documentContent\":\"" + escapeJson(documentContent) + "\","
                    + "\"publicKey\":\"" + escapeJson(rsaKey.getPublicKey()) + "\","
                    + "\"keySize\":" + rsaKey.getKeySize()
                    + "}";

            response.getWriter().write(json);

        } catch (Exception e) {

            e.printStackTrace();

            response.getWriter().write(
                    "{\"success\":false,\"message\":\"Lỗi hệ thống khi lấy dữ liệu xác thực\"}");
        }
    }

    private String buildDocumentContent(User user, List<CartItem> cartItems) {

        String fullName = (user.getFirstName() != null ? user.getFirstName() : "")
                + " " + (user.getLastName() != null ? user.getLastName() : "");

        List<OrderDocumentUtil.LineItem> lineItems = new ArrayList<>();

        for (CartItem item : cartItems) {
            String productName = item.getProduct() != null ? item.getProduct().getName() : "";
            lineItems.add(new OrderDocumentUtil.LineItem(productName, item.getQuantity(), item.getPrice()));
        }

        return OrderDocumentUtil.buildDocumentContent(
                fullName,
                user.getPhone(),
                user.getEmail(),
                user.getAddress(),
                user.getCity(),
                user.getCountry(),
                lineItems
        );
    }

    private String escapeJson(String s) {
        if (s == null) return "";
        StringBuilder sb = new StringBuilder();
        for (char c : s.toCharArray()) {
            switch (c) {
                case '"': sb.append("\\\""); break;
                case '\\': sb.append("\\\\"); break;
                case '\n': sb.append("\\n"); break;
                case '\r': sb.append("\\r"); break;
                case '\t': sb.append("\\t"); break;
                default:
                    if (c < 0x20) {
                        sb.append(String.format("\\u%04x", (int) c));
                    } else {
                        sb.append(c);
                    }
            }
        }
        return sb.toString();
    }
}