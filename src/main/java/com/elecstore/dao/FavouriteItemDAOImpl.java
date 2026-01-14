package com.elecstore.dao;

import com.elecstore.model.CartItem;
import com.elecstore.model.FavouriteItem;
import com.elecstore.model.Product;
import com.elecstore.utils.DatabaseConnection;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class FavouriteItemDAOImpl implements FavouriteItemDAO {
    @Override
    public FavouriteItem addItem(FavouriteItem item) {
        String sql = "INSERT INTO favourite_item (favourite_id, product_id, quantity, price) VALUES (?, ?, ?, ?)";
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {

            stmt.setInt(1, item.getFavouriteId());
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
            System.err.println("Error adding item: " + e.getMessage());
            e.printStackTrace();
        }
        return null;
    }

    @Override
    public List<FavouriteItem> getFavouriteItems(int favouriteId) {
        List<FavouriteItem> items = new ArrayList<>();
        String sql = "SELECT fi.id, fi.favourite_id, fi.product_id, fi.quantity, fi.price, fi.created_at, " +
                "p.id, p.name, p.price as prod_price, p.image_url, p.description " +
                "FROM favourite_item fi " +
                "JOIN products p ON fi.product_id = p.id " +
                "WHERE fi.favourite_id = ? " +
                "ORDER BY fi.created_at DESC";

        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setInt(1, favouriteId);
            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    FavouriteItem item = new FavouriteItem();
                    item.setId(rs.getInt("fi.id"));
                    item.setFavouriteId(rs.getInt("fi.favourite_id"));
                    item.setProductId(rs.getInt("fi.product_id"));
                    item.setQuantity(rs.getInt("fi.quantity"));
                    item.setPrice(rs.getFloat("fi.price"));
                    item.setCreatedAt(rs.getTimestamp("fi.created_at"));

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
            System.err.println("Error getting favourite items: " + e.getMessage());
            e.printStackTrace();
        }
        return items;
    }

    @Override
    public boolean updateQuantity(int itemId, int quantity) {
        String sql = "UPDATE favourite_item SET quantity = ?, updated_at = CURRENT_TIMESTAMP WHERE id = ?";
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setInt(1, quantity);
            stmt.setInt(2, itemId);
            int result = stmt.executeUpdate();
            return result > 0;
        } catch (SQLException e) {
            System.err.println("Error updating quantity: " + e.getMessage());
            e.printStackTrace();
        }
        return false;
    }

    @Override
    public boolean removeItem(int itemId) {
        String sql = "DELETE FROM favourite_item WHERE id = ?";
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setInt(1, itemId);
            int result = stmt.executeUpdate();
            return result > 0;
        } catch (SQLException e) {
            System.err.println("Error removing item: " + e.getMessage());
            e.printStackTrace();
        }
        return false;
    }

    @Override
    public FavouriteItem findById(int itemId) {
        String sql = "SELECT id, favourite_id, product_id, quantity, price, created_at FROM favourite_item WHERE id = ?";
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setInt(1, itemId);
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    FavouriteItem item = new FavouriteItem();
                    item.setId(rs.getInt("id"));
                    item.setFavouriteId(rs.getInt("cart_id"));
                    item.setProductId(rs.getInt("product_id"));
                    item.setQuantity(rs.getInt("quantity"));
                    item.setPrice(rs.getFloat("price"));
                    item.setCreatedAt(rs.getTimestamp("created_at"));
                    return item;
                }
            }
        } catch (SQLException e) {
            System.err.println("Error finding item: " + e.getMessage());
            e.printStackTrace();
        }
        return null;
    }

    @Override
    public FavouriteItem findByFavouriteAndProduct(int favouriteId, int productId) {
        String sql = "SELECT id, favourite_id, product_id, quantity, price FROM favourite_item WHERE favourite_id = ? AND product_id = ?";
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setInt(1, favouriteId);
            stmt.setInt(2, productId);
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    FavouriteItem item = new FavouriteItem();
                    item.setId(rs.getInt("id"));
                    item.setFavouriteId(rs.getInt("favourite_id"));
                    item.setProductId(rs.getInt("product_id"));
                    item.setQuantity(rs.getInt("quantity"));
                    item.setPrice(rs.getFloat("price"));
                    return item;
                }
            }
        } catch (SQLException e) {
            System.err.println("Error finding item by favourite and product: " + e.getMessage());
            e.printStackTrace();
        }
        return null;
    }

    @Override
    public boolean clearFavourite(int favouriteId) {
        String sql = "DELETE FROM favourite_item WHERE favourite_id = ?";
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setInt(1, favouriteId);
            stmt.executeUpdate();
            return true;
        } catch (SQLException e) {
            System.err.println("Error clearing favourite: " + e.getMessage());
            e.printStackTrace();
        }
        return false;
    }
}
