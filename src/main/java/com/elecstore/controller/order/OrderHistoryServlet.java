package com.elecstore.controller.order;

import com.elecstore.dao.OrderDAO;
import com.elecstore.dao.OrderDAOImpl;
import com.elecstore.dao.OrderSignatureDAO;
import com.elecstore.dao.OrderSignatureDAOImpl;
import com.elecstore.model.Order;
import com.elecstore.model.OrderSignature;
import com.elecstore.model.User;
import com.elecstore.utils.OrderDocumentUtil;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.util.List;

public class OrderHistoryServlet extends HttpServlet {

    private final OrderSignatureDAO orderSignatureDAO = new OrderSignatureDAOImpl();

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

            for (Order order : orders) {
                attachVerificationStatus(order);
            }

            request.setAttribute("orders", orders);
            request.getRequestDispatcher("/WEB-INF/views/order-history.jsp").forward(request, response);
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    /**
     * Tính lại hash từ dữ liệu đơn hàng HIỆN TẠI trong DB và so với hash đã lưu lúc ký.
     * - Không có bản ghi order_signatures -> đơn chưa từng được xác thực ("NOT_SIGNED")
     * - Hash khớp -> dữ liệu còn nguyên vẹn, chữ ký còn hợp lệ ("VALID")
     * - Hash lệch -> dữ liệu đã bị thay đổi sau khi ký (ví dụ sửa trực tiếp trong DB) -> cần xác thực lại ("TAMPERED")
     */
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

        if (currentHash.equals(signature.getOrderDataHash())) {
            order.setVerificationStatus("VALID");
        } else {
            order.setVerificationStatus("TAMPERED");
        }
        order.setSignedAt(signature.getVerifiedAt());
    }
}
