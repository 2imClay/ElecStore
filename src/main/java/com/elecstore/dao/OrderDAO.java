package com.elecstore.dao;

import com.elecstore.model.Order;
import java.util.List;

public interface OrderDAO {
    List<Order> getAllOrders();
    Order getOrderById(int id);
    void updateStatus(int id, String status);
    double calculateTotalRevenue();
}
