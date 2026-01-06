package com.elecstore.dao;

import com.elecstore.model.Order;
import com.elecstore.model.OrderDetail;
import com.elecstore.utils.DatabaseConnection;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class OrderDAOImpl implements OrderDAO {

    @Override
    public List<Order> getAllOrders() {
        List<Order> list = new ArrayList<>();
        // Join với bảng Users để lấy tên khách hàng
        String sql = "SELECT o.*, CONCAT(u.first_name, ' ', u.last_name) as customer_name " +
                "FROM orders o " +
                "LEFT JOIN users u ON o.user_id = u.id " +
                "ORDER BY o.order_date DESC";

        try (Connection conn = new DatabaseConnection().getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                Order o = new Order();
                o.setId(rs.getInt("id"));
                o.setUserId(rs.getInt("user_id"));
                o.setCustomerName(rs.getString("customer_name"));
                o.setOrderDate(rs.getTimestamp("order_date"));
                o.setTotalAmount(rs.getDouble("total_amount"));
                o.setStatus(rs.getString("status"));
                o.setAddress(rs.getString("address"));
                o.setPhone(rs.getString("phone"));
                list.add(o);
            }
        } catch (Exception e) { e.printStackTrace(); }
        return list;
    }

    @Override
    public Order getOrderById(int id) {
        String sqlOrder = "SELECT o.*, u.full_name FROM orders o " +
                "LEFT JOIN users u ON o.user_id = u.id WHERE o.id = ?";
        String sqlDetails = "SELECT od.*, p.name, p.image_url FROM order_details od " +
                "JOIN products p ON od.product_id = p.id WHERE od.order_id = ?";
        Order order = null;

        try (Connection conn = new DatabaseConnection().getConnection()) {
            // 1. Lấy thông tin đơn hàng
            try (PreparedStatement ps = conn.prepareStatement(sqlOrder)) {
                ps.setInt(1, id);
                ResultSet rs = ps.executeQuery();
                if (rs.next()) {
                    order = new Order();
                    order.setId(rs.getInt("id"));
                    order.setUserId(rs.getInt("user_id"));
                    order.setCustomerName(rs.getString("full_name"));
                    order.setOrderDate(rs.getTimestamp("order_date"));
                    order.setTotalAmount(rs.getDouble("total_amount"));
                    order.setStatus(rs.getString("status"));
                    order.setAddress(rs.getString("address"));
                    order.setPhone(rs.getString("phone"));
                    order.setNote(rs.getString("note"));
                }
            }

            // 2. Lấy danh sách sản phẩm
            if (order != null) {
                List<OrderDetail> items = new ArrayList<>();
                try (PreparedStatement ps = conn.prepareStatement(sqlDetails)) {
                    ps.setInt(1, id);
                    ResultSet rs = ps.executeQuery();
                    while (rs.next()) {
                        OrderDetail item = new OrderDetail();
                        item.setId(rs.getInt("id"));
                        item.setProductId(rs.getInt("product_id"));
                        item.setProductName(rs.getString("name"));
                        item.setProductImage(rs.getString("image_url"));
                        item.setQuantity(rs.getInt("quantity"));
                        item.setPrice(rs.getDouble("price"));
                        items.add(item);
                    }
                }
                order.setItems(items);
            }

        } catch (Exception e) { e.printStackTrace(); }
        return order;
    }

    @Override
    public void updateStatus(int id, String status) {
        String sql = "UPDATE orders SET status = ? WHERE id = ?";
        try (Connection conn = new DatabaseConnection().getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, status);
            ps.setInt(2, id);
            ps.executeUpdate();
        } catch (Exception e) { e.printStackTrace(); }
    }

    @Override
    public double calculateTotalRevenue() {
        String sql = "SELECT SUM(total_amount) FROM orders WHERE status = 'completed'";
        try (Connection conn = new DatabaseConnection().getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            if (rs.next()) return rs.getDouble(1);
        } catch (Exception e) { e.printStackTrace(); }
        return 0;
    }
}
