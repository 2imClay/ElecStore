package com.elecstore.dao;

import com.elecstore.model.Cart;
import com.elecstore.utils.DatabaseConnection;

import java.sql.*;

public class CartDAOImpl implements CartDAO {

    @Override
    public Cart createCart(int userId) {
        String sql = "INSERT INTO cart (user_id) VALUES (?)";
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {

            stmt.setInt(1, userId);
            stmt.executeUpdate();

            try (ResultSet rs = stmt.getGeneratedKeys()) {
                if (rs.next()) {
                    Cart cart = new Cart(userId);
                    cart.setId(rs.getInt(1));
                    return cart;
                }
            }
        } catch (SQLException e) {
            System.err.println("[CartDAO] Error creating cart: " + e.getMessage());
            e.printStackTrace();
        }
        return null;
    }

    @Override
    public Cart findByUserId(int userId) {
        String sql = "SELECT id, user_id, created_at, updated_at FROM cart WHERE user_id = ?";
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setInt(1, userId);
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    Cart cart = new Cart();
                    cart.setId(rs.getInt("id"));
                    cart.setUserId(rs.getInt("user_id"));
                    cart.setCreatedAt(rs.getTimestamp("created_at"));
                    cart.setUpdatedAt(rs.getTimestamp("updated_at"));
                    return cart;
                }
            }
        } catch (SQLException e) {
            System.err.println("[CartDAO] Error finding cart by user ID: " + e.getMessage());
            e.printStackTrace();
        }
        return null;
    }

    @Override
    public Cart findById(int cartId) {
        String sql = "SELECT id, user_id, created_at, updated_at FROM cart WHERE id = ?";
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setInt(1, cartId);
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    Cart cart = new Cart();
                    cart.setId(rs.getInt("id"));
                    cart.setUserId(rs.getInt("user_id"));
                    cart.setCreatedAt(rs.getTimestamp("created_at"));
                    cart.setUpdatedAt(rs.getTimestamp("updated_at"));
                    return cart;
                }
            }
        } catch (SQLException e) {
            System.err.println("[CartDAO] Error finding cart by ID: " + e.getMessage());
            e.printStackTrace();
        }
        return null;
    }

    @Override
    public boolean updateCart(Cart cart) {
        String sql = "UPDATE cart SET updated_at = CURRENT_TIMESTAMP WHERE id = ?";
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setInt(1, cart.getId());
            int result = stmt.executeUpdate();
            return result > 0;
        } catch (SQLException e) {
            System.err.println("[CartDAO] Error updating cart: " + e.getMessage());
            e.printStackTrace();
        }
        return false;
    }

    @Override
    public boolean deleteCart(int cartId) {
        String sql = "DELETE FROM cart WHERE id = ?";
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setInt(1, cartId);
            int result = stmt.executeUpdate();
            return result > 0;
        } catch (SQLException e) {
            System.err.println("[CartDAO] Error deleting cart: " + e.getMessage());
            e.printStackTrace();
        }
        return false;
    }
}
