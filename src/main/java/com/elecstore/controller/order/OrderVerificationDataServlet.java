package com.elecstore.controller.order;

import com.elecstore.dao.OrderDAO;
import com.elecstore.dao.OrderDAOImpl;
import com.elecstore.dao.OrderSignatureDAO;
import com.elecstore.dao.OrderSignatureDAOImpl;
import com.elecstore.model.Order;
import com.elecstore.model.OrderSignature;
import com.elecstore.model.RSAKey;
import com.elecstore.model.User;
import com.elecstore.service.RSAService;
import com.elecstore.utils.OrderDocumentUtil;

import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import java.io.IOException;

@WebServlet("/get-order-verification-data")
public class OrderVerificationDataServlet extends HttpServlet {

    private final OrderDAO orderDAO = new OrderDAOImpl();
    private final RSAService rsaService = new RSAService();
    private final OrderSignatureDAO orderSignatureDAO = new OrderSignatureDAOImpl();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws IOException {

        response.setContentType("application/json;charset=UTF-8");

        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("user");

        if (user == null) {
            response.getWriter().write("{\"success\":false,\"message\":\"Vui lòng đăng nhập\"}");
            return;
        }

        try {
            int orderId;
            try {
                orderId = Integer.parseInt(request.getParameter("orderId"));
            } catch (Exception e) {
                response.getWriter().write("{\"success\":false,\"message\":\"orderId không hợp lệ\"}");
                return;
            }

            Order order = orderDAO.getOrderById(orderId);

            if (order == null) {
                response.getWriter().write("{\"success\":false,\"message\":\"Không tìm thấy đơn hàng\"}");
                return;
            }

            // Chỉ cho phép chủ đơn hàng xác thực lại đơn của chính họ
            if (order.getUserId() != user.getId()) {
                response.getWriter().write("{\"success\":false,\"message\":\"Bạn không có quyền với đơn hàng này\"}");
                return;
            }

            RSAKey rsaKey = rsaService.getLatestKey(user.getId());

            if (rsaKey == null) {
                response.getWriter().write(
                        "{\"success\":false,\"message\":\"Bạn chưa tạo khóa RSA. Vui lòng tạo khóa tại trang Checkout trước khi xác thực\"}");
                return;
            }

            String documentContent = OrderDocumentUtil.buildOrderSnapshotContent(order);

            // Lấy nội dung snapshot đã ký LẦN GẦN NHẤT (nếu có) để FE diff với dữ liệu hiện tại
            OrderSignature latestSignature = orderSignatureDAO.getLatestByOrderId(orderId);
            String originalDocumentContent =
                    latestSignature != null ? latestSignature.getOrderSnapshotContent() : null;

            StringBuilder json = new StringBuilder();
            json.append("{")
                    .append("\"success\":true,")
                    .append("\"orderId\":").append(order.getId()).append(",")
                    .append("\"documentContent\":\"").append(escapeJson(documentContent)).append("\",")
                    .append("\"originalDocumentContent\":")
                    .append(originalDocumentContent != null ? "\"" + escapeJson(originalDocumentContent) + "\"" : "null")
                    .append(",")
                    .append("\"publicKey\":\"").append(escapeJson(rsaKey.getPublicKey())).append("\",")
                    .append("\"keySize\":").append(rsaKey.getKeySize())
                    .append("}");

            response.getWriter().write(json.toString());

        } catch (Exception e) {
            e.printStackTrace();
            response.getWriter().write("{\"success\":false,\"message\":\"Lỗi hệ thống khi lấy dữ liệu xác thực\"}");
        }
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