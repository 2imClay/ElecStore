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

            StringBuilder json =
                    new StringBuilder();

            json.append("{\n");

            json.append("\"orderId\":")
                    .append(order.getId())
                    .append(",\n");

            json.append("\"userId\":")
                    .append(order.getUserId())
                    .append(",\n");

            json.append("\"customerName\":\"")
                    .append(order.getCustomerName())
                    .append("\",\n");

            json.append("\"orderDate\":\"")
                    .append(
                            sdf.format(
                                    order.getOrderDate()))
                    .append("\",\n");

            json.append("\"totalAmount\":")
                    .append(order.getTotalAmount())
                    .append(",\n");

            json.append("\"status\":\"")
                    .append(order.getStatus())
                    .append("\",\n");

            json.append("\"paymentMethod\":\"")
                    .append(order.getPaymentMethod())
                    .append("\",\n");

            json.append("\"items\":[\n");

            for (int i = 0;
                 i < details.size();
                 i++) {

                OrderDetail item =
                        details.get(i);

                json.append("{");

                json.append("\"productId\":")
                        .append(item.getProductId())
                        .append(",");

                json.append("\"productName\":\"")
                        .append(item.getProductName())
                        .append("\",");

                json.append("\"quantity\":")
                        .append(item.getQuantity())
                        .append(",");

                json.append("\"price\":")
                        .append(item.getPrice());

                json.append("}");

                if (i < details.size() - 1) {
                    json.append(",");
                }

                json.append("\n");
            }

            json.append("]\n");

            json.append("}");

            response.setContentType(
                    "application/json");

            response.setCharacterEncoding(
                    "UTF-8");

            response.setHeader(
                    "Content-Disposition",
                    "attachment; filename=order_"
                            + orderId
                            + ".json");

            response.getWriter()
                    .write(json.toString());

        } catch (Exception e) {

            e.printStackTrace();

            response.sendError(
                    HttpServletResponse.SC_INTERNAL_SERVER_ERROR,
                    "Lỗi khi tải đơn hàng");
        }
    }
}