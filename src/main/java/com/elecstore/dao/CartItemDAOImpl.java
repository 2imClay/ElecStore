package com.elecstore.dao;

import com.elecstore.model.CartItem;
import com.elecstore.model.Product;
import com.elecstore.utils.DatabaseConnection;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class CartItemDAOImpl implements CartItemDAO {

    @Override
    public CartItem addItem(CartItem item) {
        String sql = "INSERT INTO cart_item (cart_id, product_id, quantity, price) VALUES (?, ?, ?, ?)";
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {

            stmt.setInt(1, item.getCartId());
            stmt.setInt(2, item.getProductId());
            stmt.setInt(3, item.getQuantity());
            stmt.setFloat(4, item.getPrice());
            stmt.executeUpdate();

            try (ResultSet rs = stmt.getGeneratedKeys()) {
                if (rs.next()) {
                    item.setId(rs.getInt(1));
                    return item;
                }
            }
        } catch (SQLException e) {
            System.err.println("[CartItemDAO] Error adding item: " + e.getMessage());
            e.printStackTrace();
        }
        return null;
    }

    @Override
    public List<CartItem> getCartItems(int cartId) {
        List<CartItem> items = new ArrayList<>();
        String sql = "SELECT ci.id, ci.cart_id, ci.product_id, ci.quantity, ci.price, ci.created_at, " +
                "p.id, p.name, p.price as prod_price, p.image_url, p.description " +
                "FROM cart_item ci " +
                "JOIN products p ON ci.product_id = p.id " +
                "WHERE ci.cart_id = ? " +
                "ORDER BY ci.created_at DESC";

        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setInt(1, cartId);
            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    CartItem item = new CartItem();
                    item.setId(rs.getInt("ci.id"));
                    item.setCartId(rs.getInt("ci.cart_id"));
                    item.setProductId(rs.getInt("ci.product_id"));
                    item.setQuantity(rs.getInt("ci.quantity"));
                    item.setPrice(rs.getFloat("ci.price"));
                    item.setCreatedAt(rs.getTimestamp("ci.created_at"));

                    // Load product info
                    Product product = new Product();
                    product.setId(rs.getInt("p.id"));
                    product.setName(rs.getString("p.name"));
                    product.setPrice(rs.getFloat("prod_price"));
                    product.setImageUrl(rs.getString("p.image_url"));
                    product.setDescription(rs.getString("p.description"));
                    item.setProduct(product);

                    items.add(item);
                }
            }
        } catch (SQLException e) {
            System.err.println("[CartItemDAO] Error getting cart items: " + e.getMessage());
            e.printStackTrace();
        }
        return items;
    }

    @Override
    public boolean updateQuantity(int itemId, int quantity) {
        String sql = "UPDATE cart_item SET quantity = ?, updated_at = CURRENT_TIMESTAMP WHERE id = ?";
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setInt(1, quantity);
            stmt.setInt(2, itemId);
            int result = stmt.executeUpdate();
            return result > 0;
        } catch (SQLException e) {
            System.err.println("[CartItemDAO] Error updating quantity: " + e.getMessage());
            e.printStackTrace();
        }
        return false;
    }

    @Override
    public boolean removeItem(int itemId) {
        String sql = "DELETE FROM cart_item WHERE id = ?";
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setInt(1, itemId);
            int result = stmt.executeUpdate();
            return result > 0;
        } catch (SQLException e) {
            System.err.println("[CartItemDAO] Error removing item: " + e.getMessage());
            e.printStackTrace();
        }
        return false;
    }

    @Override
    public CartItem findById(int itemId) {
        String sql = "SELECT id, cart_id, product_id, quantity, price, created_at FROM cart_item WHERE id = ?";
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setInt(1, itemId);
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    CartItem item = new CartItem();
                    item.setId(rs.getInt("id"));
                    item.setCartId(rs.getInt("cart_id"));
                    item.setProductId(rs.getInt("product_id"));
                    item.setQuantity(rs.getInt("quantity"));
                    item.setPrice(rs.getFloat("price"));
                    item.setCreatedAt(rs.getTimestamp("created_at"));
                    return item;
                }
            }
        } catch (SQLException e) {
            System.err.println("[CartItemDAO] Error finding item: " + e.getMessage());
            e.printStackTrace();
        }
        return null;
    }

    @Override
    public CartItem findByCartAndProduct(int cartId, int productId) {
        String sql = "SELECT id, cart_id, product_id, quantity, price FROM cart_item WHERE cart_id = ? AND product_id = ?";
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setInt(1, cartId);
            stmt.setInt(2, productId);
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    CartItem item = new CartItem();
                    item.setId(rs.getInt("id"));
                    item.setCartId(rs.getInt("cart_id"));
                    item.setProductId(rs.getInt("product_id"));
                    item.setQuantity(rs.getInt("quantity"));
                    item.setPrice(rs.getFloat("price"));
                    return item;
                }
            }
        } catch (SQLException e) {
            System.err.println("[CartItemDAO] Error finding item by cart and product: " + e.getMessage());
            e.printStackTrace();
        }
        return null;
    }

    @Override
    public boolean clearCart(int cartId) {
        String sql = "DELETE FROM cart_item WHERE cart_id = ?";
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setInt(1, cartId);
            stmt.executeUpdate();
            return true;
        } catch (SQLException e) {
            System.err.println("[CartItemDAO] Error clearing cart: " + e.getMessage());
            e.printStackTrace();
        }
        return false;
    }
}
