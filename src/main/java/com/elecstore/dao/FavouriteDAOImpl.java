package com.elecstore.dao;

import com.elecstore.model.Cart;
import com.elecstore.model.Favourite;
import com.elecstore.model.Product;
import com.elecstore.utils.DatabaseConnection;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class FavouriteDAOImpl implements FavouriteDAO{


    @Override
    public Favourite createFavourite(int userId) {
        String sql = "INSERT INTO favourite (user_id) VALUES (?)";
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {

            stmt.setInt(1, userId);
            stmt.executeUpdate();

            try (ResultSet rs = stmt.getGeneratedKeys()) {
                if (rs.next()) {
                    Favourite favourite = new Favourite(userId);
                    favourite.setId(rs.getInt(1));
                    return favourite;
                }
            }
        } catch (SQLException e) {
            System.err.println("Error creating favourite: " + e.getMessage());
            e.printStackTrace();
        }
        return null;
    }

    @Override
    public Favourite findByUserId(int userId) {
        String sql = "SELECT id, user_id, created_at, updated_at FROM favourite WHERE user_id = ?";
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setInt(1, userId);
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    Favourite favourite = new Favourite();
                    favourite.setId(rs.getInt("id"));
                    favourite.setUserId(rs.getInt("user_id"));
                    favourite.setCreatedAt(rs.getTimestamp("created_at"));
                    favourite.setUpdatedAt(rs.getTimestamp("updated_at"));
                    return favourite;
                }
            }
        } catch (SQLException e) {
            System.err.println("Error finding favourite by user ID: " + e.getMessage());
            e.printStackTrace();
        }
        return null;
    }

    @Override
    public Favourite findById(int favouriteId) {
        String sql = "SELECT id, user_id, created_at, updated_at FROM favourite WHERE id = ?";
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setInt(1, favouriteId);
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    Favourite favourite = new Favourite();
                    favourite.setId(rs.getInt("id"));
                    favourite.setUserId(rs.getInt("user_id"));
                    favourite.setCreatedAt(rs.getTimestamp("created_at"));
                    favourite.setUpdatedAt(rs.getTimestamp("updated_at"));
                    return favourite;
                }
            }
        } catch (SQLException e) {
            System.err.println("Error finding favourite by ID: " + e.getMessage());
            e.printStackTrace();
        }
        return null;
    }

    @Override
    public boolean updateFavourite(Favourite favourite) {
        String sql = "UPDATE favourite SET updated_at = CURRENT_TIMESTAMP WHERE id = ?";
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setInt(1, favourite.getId());
            int result = stmt.executeUpdate();
            return result > 0;
        } catch (SQLException e) {
            System.err.println("Error updating favourite: " + e.getMessage());
            e.printStackTrace();
        }
        return false;
    }

    @Override
    public boolean deleteFavourite(int favouriteId) {
        String sql = "DELETE FROM favourite WHERE id = ?";
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setInt(1, favouriteId);
            int result = stmt.executeUpdate();
            return result > 0;
        } catch (SQLException e) {
            System.err.println("Error deleting favourite: " + e.getMessage());
            e.printStackTrace();
        }
        return false;
    }
}
