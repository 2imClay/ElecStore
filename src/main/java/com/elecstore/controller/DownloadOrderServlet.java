package com.elecstore.controller;

import com.elecstore.dao.OrderDAO;
import com.elecstore.dao.OrderDAOImpl;
import com.elecstore.model.Order;
import com.elecstore.model.OrderDetail;
import com.elecstore.model.User;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import java.io.IOException;
import java.text.SimpleDateFormat;
import java.util.List;

@WebServlet("/download-order")
public class DownloadOrderServlet extends HttpServlet {

    private final OrderDAO orderDAO =
            new OrderDAOImpl();

    @Override
    protected void doGet(
            HttpServletRequest request,
            HttpServletResponse response)
            throws ServletException, IOException {

        try {

            User user =
                    (User) request.getSession()
                            .getAttribute("user");

            if (user == null) {

                response.sendRedirect(
                        request.getContextPath()
                                + "/login");

                return;
            }

            int orderId =
                    Integer.parseInt(
                            request.getParameter("id"));

            Order order =
                    orderDAO.getOrderById(orderId);

            if (order == null) {

                response.sendError(
                        HttpServletResponse.SC_NOT_FOUND,
                        "Không tìm thấy đơn hàng");

                return;
            }

            // Chỉ cho phép tải đơn của chính mình

            if (order.getUserId()
                    != user.getId()) {

                response.sendError(
                        HttpServletResponse.SC_FORBIDDEN,
                        "Bạn không có quyền tải đơn hàng này");

                return;
            }

            List<OrderDetail> details =
                    order.getItems();

            SimpleDateFormat sdf =
                    new SimpleDateFormat(
                            "yyyy-MM-dd HH:mm:ss");

            StringBuilder txt = new StringBuilder();

            txt.append("===== THONG TIN DON HANG =====\n\n");

            txt.append("Ma don hang: ")
                    .append(order.getId())
                    .append("\n");

            txt.append("Khach hang: ")
                    .append(order.getCustomerName())
                    .append("\n");

            txt.append("Ngay dat: ")
                    .append(sdf.format(order.getOrderDate()))
                    .append("\n");

            txt.append("Trang thai: ")
                    .append(order.getStatus())
                    .append("\n");

            txt.append("Phuong thuc thanh toan: ")
                    .append(order.getPaymentMethod())
                    .append("\n");

            txt.append("Tong tien: ")
                    .append(order.getTotalAmount())
                    .append(" VNĐ\n\n");

            txt.append("===== DANH SACH SAN PHAM =====\n\n");

            for (OrderDetail item : details) {

                txt.append("San pham: ")
                        .append(item.getProductName())
                        .append("\n");

                txt.append("So luong: ")
                        .append(item.getQuantity())
                        .append("\n");

                txt.append("Don gia: ")
                        .append(item.getPrice())
                        .append(" VNĐ\n");

                txt.append("-----------------------------\n");
            }

            response.setContentType("text/plain");

            response.setCharacterEncoding("UTF-8");

            response.setHeader(
                    "Content-Disposition",
                    "attachment; filename=order_"
                            + orderId
                            + ".txt");

            response.getWriter().write(txt.toString());

        } catch (Exception e) {

            e.printStackTrace();

            response.sendError(
                    HttpServletResponse.SC_INTERNAL_SERVER_ERROR,
                    "Lỗi khi tải đơn hàng");
        }
    }
}