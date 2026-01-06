package com.elecstore.dao;

import com.elecstore.model.CartItem;
import java.util.List;

public interface CartItemDAO {
    // Add item to cart
    CartItem addItem(CartItem item);

    // Get all items in cart
    List<CartItem> getCartItems(int cartId);

    // Update item quantity
    boolean updateQuantity(int itemId, int quantity);

    // Remove item from cart
    boolean removeItem(int itemId);

    // Find item by id
    CartItem findById(int itemId);

    // Find item by cart_id & product_id
    CartItem findByCartAndProduct(int cartId, int productId);

    // Clear cart (remove all items)
    boolean clearCart(int cartId);
}
