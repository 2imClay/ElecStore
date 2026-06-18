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
import com.elecstore.utils.RSASignatureVerifier;

import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import java.io.IOException;

@WebServlet("/order/re-verify")
public class ReVerifyOrderSignatureServlet extends HttpServlet {

    private final OrderDAO orderDAO = new OrderDAOImpl();
    private final RSAService rsaService = new RSAService();
    private final OrderSignatureDAO orderSignatureDAO = new OrderSignatureDAOImpl();

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws IOException {

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

            String signature = request.getParameter("signature");
            if (signature == null || signature.trim().isEmpty()) {
                response.getWriter().write("{\"success\":false,\"message\":\"Thiếu file chữ ký\"}");
                return;
            }

            Order order = orderDAO.getOrderById(orderId);
            if (order == null) {
                response.getWriter().write("{\"success\":false,\"message\":\"Không tìm thấy đơn hàng\"}");
                return;
            }

            if (order.getUserId() != user.getId()) {
                response.getWriter().write("{\"success\":false,\"message\":\"Bạn không có quyền với đơn hàng này\"}");
                return;
            }

            RSAKey rsaKey = rsaService.getLatestKey(user.getId());
            if (rsaKey == null) {
                response.getWriter().write(
                        "{\"success\":false,\"message\":\"Bạn chưa có khóa RSA. Vui lòng tạo khóa tại trang Checkout\"}");
                return;
            }

            // Tính lại hash từ dữ liệu HIỆN TẠI trong DB (không tin documentHash do client gửi lên)
            String currentSnapshot = OrderDocumentUtil.buildOrderSnapshotContent(order);
            String currentHash = OrderDocumentUtil.sha256Hex(currentSnapshot);

            boolean signatureValid = RSASignatureVerifier.verify(rsaKey.getPublicKey(), currentHash, signature);

            if (!signatureValid) {
                response.getWriter().write(
                        "{\"success\":false,\"message\":\"Chữ ký không hợp lệ hoặc không khớp với dữ liệu đơn hàng hiện tại\"}");
                return;
            }

            OrderSignature newSignature = new OrderSignature();
            newSignature.setOrderId(orderId);
            newSignature.setKeyId(rsaKey.getId());
            newSignature.setSignature(signature);
            newSignature.setDocumentHash(currentHash);
            newSignature.setOrderDataHash(currentHash);
            newSignature.setOrderSnapshotContent(currentSnapshot);

            boolean saved = orderSignatureDAO.save(newSignature);

            if (saved) {
                response.getWriter().write("{\"success\":true,\"message\":\"Xác thực lại đơn hàng thành công\"}");
            } else {
                response.getWriter().write("{\"success\":false,\"message\":\"Lỗi khi lưu chữ ký mới\"}");
            }

        } catch (Exception e) {
            e.printStackTrace();
            response.getWriter().write("{\"success\":false,\"message\":\"Lỗi hệ thống khi xác thực lại đơn hàng\"}");
        }
    }
}