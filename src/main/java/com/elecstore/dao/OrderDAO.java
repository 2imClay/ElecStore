package com.elecstore.dao;

import com.elecstore.model.Order;
import com.elecstore.model.OrderDetail;

import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.List;

public interface OrderDAO {
    public int createOrder(Order order);
    public void addOrderDetail(OrderDetail detail);
    List<Order> getAllOrders();
    Order getOrderById(int id);
    public List<Order> getOrdersByUserId(int userId);
    public int getTotalOrders();
    void updateStatus(int id, String status);
    double calculateTotalRevenue();
    public Order mapResultSetToOrder(ResultSet rs) throws SQLException;
    public List<OrderDetail> getOrderDetails(int orderId);
}
