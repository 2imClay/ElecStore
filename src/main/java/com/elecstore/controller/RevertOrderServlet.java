package com.elecstore.controller;

import com.elecstore.dao.OrderDAO;
import com.elecstore.dao.OrderDAOImpl;
import com.elecstore.dao.OrderSignatureDAO;
import com.elecstore.dao.OrderSignatureDAOImpl;
import com.elecstore.model.Order;
import com.elecstore.model.OrderDetail;
import com.elecstore.model.OrderSignature;
import com.elecstore.model.OrderSnapshot;
import com.elecstore.model.User;
import com.google.gson.Gson;

import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.util.List;

@WebServlet("/order/revert")
public class RevertOrderServlet extends HttpServlet {

    private final OrderDAO orderDAO = new OrderDAOImpl();
    private final OrderSignatureDAO orderSignatureDAO =
            new OrderSignatureDAOImpl();

    @Override
    protected void doPost(
            HttpServletRequest request,
            HttpServletResponse response)
            throws IOException {

        response.setContentType(
                "application/json;charset=UTF-8");

        HttpSession session =
                request.getSession(false);

        User user =
                (User) session.getAttribute("user");

        if (user == null) {

            response.getWriter().write(
                    "{\"success\":false,"
                            + "\"message\":\"Vui lòng đăng nhập\"}");

            return;
        }

        try {

            int orderId = Integer.parseInt(
                    request.getParameter("orderId"));

            Order order =
                    orderDAO.getOrderById(orderId);

            if (order == null) {

                response.getWriter().write(
                        "{\"success\":false,"
                                + "\"message\":\"Không tìm thấy đơn hàng\"}");

                return;
            }

            if (order.getUserId() != user.getId()) {

                response.getWriter().write(
                        "{\"success\":false,"
                                + "\"message\":\"Bạn không có quyền với đơn hàng này\"}");

                return;
            }

            OrderSignature signature =
                    orderSignatureDAO
                            .getLatestByOrderId(orderId);

            if (signature == null) {

                response.getWriter().write(
                        "{\"success\":false,"
                                + "\"message\":\"Không tìm thấy snapshot đơn hàng\"}");

                return;
            }

            String snapshotJson =
                    signature.getOrderSnapshotJson();

            if (snapshotJson == null ||
                    snapshotJson.trim().isEmpty()) {

                response.getWriter().write(
                        "{\"success\":false,"
                                + "\"message\":\"Snapshot JSON không tồn tại\"}");

                return;
            }

            Gson gson = new Gson();

            OrderSnapshot snapshot =
                    gson.fromJson(
                            snapshotJson,
                            OrderSnapshot.class);

            Order oldOrder =
                    snapshot.getOrder();

            List<OrderDetail> details =
                    snapshot.getDetails();

            // Khôi phục bảng orders
            orderDAO.updateFromSnapshot(oldOrder);

            // Xóa toàn bộ order_details hiện tại
            orderDAO.deleteOrderDetails(orderId
            );

            // Insert lại order_details từ snapshot
            for (OrderDetail detail
                    : snapshot.getDetails()) {

                detail.setOrderId(orderId);

                orderDAO.insertOrderDetail(
                        detail
                );
            }

            response.getWriter().write(
                    "{\"success\":true,"
                            + "\"message\":\"Đã khôi phục đơn hàng cũ thành công\"}");

        } catch (Exception e) {

            e.printStackTrace();

            response.getWriter().write(
                    "{\"success\":false,"
                            + "\"message\":\"Lỗi khi khôi phục đơn hàng\"}");
        }
    }


}

