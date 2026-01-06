package com.elecstore.dao;

import com.elecstore.model.Cart;

public interface CartDAO {
    // Create cart for user
    Cart createCart(int userId);

    // Find cart by user ID
    Cart findByUserId(int userId);

    // Find cart by cart ID
    Cart findById(int cartId);

    // Update cart
    boolean updateCart(Cart cart);

    // Delete cart
    boolean deleteCart(int cartId);
}
