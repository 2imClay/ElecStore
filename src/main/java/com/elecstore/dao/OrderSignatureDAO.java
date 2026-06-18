package com.elecstore.dao;

import com.elecstore.model.OrderSignature;

public interface OrderSignatureDAO {

    boolean save(OrderSignature signature);

    // Lấy chữ ký hiện hành (mới nhất) của 1 đơn hàng
    OrderSignature getLatestByOrderId(int orderId);
}