package com.elecstore.dao;

import com.elecstore.model.User;
import com.elecstore.utils.DatabaseConnection;
import com.elecstore.utils.PasswordUtil;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

public class UserDAOImpl implements UserDAO {
    @Override
    public User login(String email, String password) throws SQLException {
        String sql = "SELECT * FROM users WHERE email = ? AND password = ?";
        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;

        try {
            conn = DatabaseConnection.getConnection();
            pstmt = conn.prepareStatement(sql);
            pstmt.setString(1, email);
            pstmt.setString(2, password); // Lưu ý: Nên dùng PasswordUtil.verify() thay vì raw password

            rs = pstmt.executeQuery();
            if (rs.next()) {
                return mapResultSetToUser(rs);
            }
            return null;
        } catch (SQLException e) {
            System.err.println("[UserDAOImpl] ❌ Login error: " + e.getMessage());
            e.printStackTrace();
            throw e;
        } finally {
            // Cleanup code...
            if (rs != null) try { rs.close(); } catch (SQLException e) { e.printStackTrace(); }
            if (pstmt != null) try { pstmt.close(); } catch (SQLException e) { e.printStackTrace(); }
            if (conn != null) try { conn.close(); } catch (SQLException e) { e.printStackTrace(); }
        }
    }

    @Override
    public boolean save(User user) throws SQLException {
        String sql = "INSERT INTO users (email, password, first_name, last_name, phone, address, city, country, created_at, role, status) "
                + "VALUES (?, ?, ?, ?, ?, ?, ?, ?,NOW(), ?, ?)";

        Connection conn = null;
        PreparedStatement pstmt = null;

        try {
            conn = DatabaseConnection.getConnection();
            System.out.println("[UserDAOImpl] Connection: " + (conn != null ? "✓ OK" : "✗ NULL"));

            pstmt = conn.prepareStatement(sql);

            // Set parameters
            pstmt.setString(1, user.getEmail());
            pstmt.setString(2, user.getPassword());
            pstmt.setString(3, user.getFirstName());
            pstmt.setString(4, user.getLastName());
            pstmt.setString(5, user.getPhone());
            pstmt.setString(6, user.getAddress());
            pstmt.setString(7, user.getCity());
            pstmt.setString(8, user.getCountry());
            pstmt.setString(9, user.getRole());
            pstmt.setString(10, user.getStatus());

            System.out.println("[UserDAOImpl] SQL: " + sql);
            System.out.println("[UserDAOImpl] Email: " + user.getEmail());
            System.out.println("[UserDAOImpl] FirstName: " + user.getFirstName());
            System.out.println("[UserDAOImpl] LastName: " + user.getLastName());

            // Execute UPDATE
            int rowsAffected = pstmt.executeUpdate();
            System.out.println("[UserDAOImpl] Rows affected: " + rowsAffected);

            if (rowsAffected > 0) {
                System.out.println("[UserDAOImpl] ✓ Save successful!");
                return true;
            } else {
                System.out.println("[UserDAOImpl] ✗ Save failed - no rows affected");
                return false;
            }

        } catch (SQLException e) {
            System.err.println("[UserDAOImpl] ❌ SQLException in save(): " + e.getMessage());
            e.printStackTrace();
            throw e;

        } finally {
            if (pstmt != null) {
                try {
                    pstmt.close();
                } catch (SQLException e) {
                    e.printStackTrace();
                }
            }
            if (conn != null) {
                try {
                    conn.close();
                } catch (SQLException e) {
                    e.printStackTrace();
                }
            }
        }
    }

    @Override
    public User getById(int userId) throws SQLException {
        String sql = "SELECT * FROM users WHERE id = ?";
        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;

        try {
            conn = DatabaseConnection.getConnection();
            pstmt = conn.prepareStatement(sql);
            pstmt.setInt(1, userId);

            rs = pstmt.executeQuery();

            if (rs.next()) {
                return mapResultSetToUser(rs);
            }
            return null;

        } catch (SQLException e) {
            System.err.println("[UserDAOImpl] ❌ SQLException in getById(): " + e.getMessage());
            e.printStackTrace();
            throw e;

        } finally {
            if (rs != null) try { rs.close(); } catch (SQLException e) { e.printStackTrace(); }
            if (pstmt != null) try { pstmt.close(); } catch (SQLException e) { e.printStackTrace(); }
            if (conn != null) try { conn.close(); } catch (SQLException e) { e.printStackTrace(); }
        }
    }

    @Override
    public User findByEmail(String email) throws SQLException {
        String sql = "SELECT * FROM users WHERE email = ?";
        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;

        try {
            conn = DatabaseConnection.getConnection();
            pstmt = conn.prepareStatement(sql);
            pstmt.setString(1, email);

            rs = pstmt.executeQuery();

            if (rs.next()) {
                return mapResultSetToUser(rs);
            }
            return null;

        } catch (SQLException e) {
            System.err.println("[UserDAOImpl] ❌ SQLException in findByEmail(): " + e.getMessage());
            e.printStackTrace();
            throw e;

        } finally {
            if (rs != null) try { rs.close(); } catch (SQLException e) { e.printStackTrace(); }
            if (pstmt != null) try { pstmt.close(); } catch (SQLException e) { e.printStackTrace(); }
            if (conn != null) try { conn.close(); } catch (SQLException e) { e.printStackTrace(); }
        }
    }

    @Override
    public boolean update(User user) throws SQLException {
        String sql = "UPDATE users SET email=?, password=?, first_name=?, last_name=?, phone=?, address=?, city=?, country=?, role=?, status=?, updated_at=NOW() WHERE id=?";

        Connection conn = null;
        PreparedStatement pstmt = null;

        try {
            conn = DatabaseConnection.getConnection();
            pstmt = conn.prepareStatement(sql);

            pstmt.setString(1, user.getEmail());
            pstmt.setString(2, user.getPassword());
            pstmt.setString(3, user.getFirstName());
            pstmt.setString(4, user.getLastName());
            pstmt.setString(5, user.getPhone());
            pstmt.setString(6, user.getAddress());
            pstmt.setString(7, user.getCity());
            pstmt.setString(8, user.getCountry());
            pstmt.setString(9, user.getRole());
            pstmt.setString(10, user.getStatus());
            pstmt.setInt(11, user.getId());

            int rowsAffected = pstmt.executeUpdate();
            return rowsAffected > 0;

        } catch (SQLException e) {
            System.err.println("[UserDAOImpl] ❌ SQLException in update(): " + e.getMessage());
            e.printStackTrace();
            throw e;

        } finally {
            if (pstmt != null) try { pstmt.close(); } catch (SQLException e) { e.printStackTrace(); }
            if (conn != null) try { conn.close(); } catch (SQLException e) { e.printStackTrace(); }
        }
    }

    @Override
    public boolean delete(int userId) throws SQLException {
        String sql = "DELETE FROM users WHERE id = ?";
        Connection conn = null;
        PreparedStatement pstmt = null;

        try {
            conn = DatabaseConnection.getConnection();
            pstmt = conn.prepareStatement(sql);
            pstmt.setInt(1, userId);

            int rowsAffected = pstmt.executeUpdate();
            return rowsAffected > 0;

        } catch (SQLException e) {
            System.err.println("[UserDAOImpl] ❌ SQLException in delete(): " + e.getMessage());
            e.printStackTrace();
            throw e;

        } finally {
            if (pstmt != null) try { pstmt.close(); } catch (SQLException e) { e.printStackTrace(); }
            if (conn != null) try { conn.close(); } catch (SQLException e) { e.printStackTrace(); }
        }
    }

    @Override
    public List<User> getAll() throws SQLException {
        String sql = "SELECT * FROM users ORDER BY created_at DESC";
        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        List<User> users = new ArrayList<>();

        try {
            conn = DatabaseConnection.getConnection();
            pstmt = conn.prepareStatement(sql);

            rs = pstmt.executeQuery();

            while (rs.next()) {
                users.add(mapResultSetToUser(rs));
            }
            return users;

        } catch (SQLException e) {
            System.err.println("[UserDAOImpl] ❌ SQLException in getAll(): " + e.getMessage());
            e.printStackTrace();
            throw e;

        } finally {
            if (rs != null) try { rs.close(); } catch (SQLException e) { e.printStackTrace(); }
            if (pstmt != null) try { pstmt.close(); } catch (SQLException e) { e.printStackTrace(); }
            if (conn != null) try { conn.close(); } catch (SQLException e) { e.printStackTrace(); }
        }
    }

    @Override
    public boolean isEmailExists(String email) throws SQLException {
        String sql = "SELECT COUNT(*) as count FROM users WHERE email = ?";
        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;

        try {
            conn = DatabaseConnection.getConnection();
            pstmt = conn.prepareStatement(sql);
            pstmt.setString(1, email);

            rs = pstmt.executeQuery();

            if (rs.next()) {
                int count = rs.getInt("count");
                System.out.println("[UserDAOImpl] Email exists check - " + email + ": " + (count > 0 ? "YES" : "NO"));
                return count > 0;
            }
            return false;

        } catch (SQLException e) {
            System.err.println("[UserDAOImpl] ❌ SQLException in isEmailExists(): " + e.getMessage());
            e.printStackTrace();
            throw e;

        } finally {
            if (rs != null) try { rs.close(); } catch (SQLException e) { e.printStackTrace(); }
            if (pstmt != null) try { pstmt.close(); } catch (SQLException e) { e.printStackTrace(); }
            if (conn != null) try { conn.close(); } catch (SQLException e) { e.printStackTrace(); }
        }
    }

    private User mapResultSetToUser(ResultSet rs) throws SQLException {
        User user = new User();
        user.setId(rs.getInt("id"));
        user.setEmail(rs.getString("email"));
        user.setPassword(rs.getString("password"));
        user.setFirstName(rs.getString("first_name"));
        user.setLastName(rs.getString("last_name"));
        user.setPhone(rs.getString("phone"));
        user.setAddress(rs.getString("address"));
        user.setCity(rs.getString("city"));
        user.setCountry(rs.getString("country"));
        user.setRole(rs.getString("role"));
        user.setStatus(rs.getString("status"));
        user.setCreatedAt(rs.getTimestamp("created_at"));
        user.setUpdatedAt(rs.getTimestamp("updated_at"));
        return user;
    }

    // Cập nhật trạng thái active/inactive
    @Override
    public void updateUserStatus(int id, String status) {
        String sql = "UPDATE users SET status = ? WHERE id = ?";
        try (Connection conn = new DatabaseConnection().getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, status);
            ps.setInt(2, id);
            ps.executeUpdate();
        } catch (Exception e) { e.printStackTrace(); }
    }

    // Cập nhật quyền role (admin/user)
    public void updateUserRole(int id, String role) {
        String sql = "UPDATE users SET role = ? WHERE id = ?";
        try (Connection conn = new DatabaseConnection().getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, role);
            ps.setInt(2, id);
            ps.executeUpdate();
        } catch (Exception e) { e.printStackTrace(); }
    }

    public double totalSpent(int userId) {
        String sql = """
        SELECT COALESCE(SUM(total_amount), 0) as total_spent
        FROM orders 
        WHERE user_id = ? AND status = 'completed'
        """;

        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, userId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return rs.getDouble("total_spent");
                }
            }
        } catch (SQLException e) {
            System.err.println("Error calculating totalSpent for user " + userId + ": " + e.getMessage());
            e.printStackTrace();
        }
        return 0;
    }

    @Override
    public int getTotalOrdersCount(int userId) {
        String sql = "SELECT COUNT(*) as total_orders FROM orders WHERE user_id = ?";

        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, userId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt("total_orders");
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return 0;
    }

    @Override
    public User getByEmail(String email) {
        String sql = "SELECT * FROM users WHERE email = ?";

        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, email);
            ResultSet rs = ps.executeQuery();

            if (rs.next()) {
                return mapResultSetToUser(rs);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    @Override
    public void updatePassword(int userId, String newPassword) {
        String sql = """
        UPDATE users 
        SET password = ?, updated_at = NOW() 
        WHERE id = ?
        """;

        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, PasswordUtil.hashPassword(newPassword));
            ps.setInt(2, userId);

            int rowsAffected = ps.executeUpdate();

            if (rowsAffected > 0) {
                System.out.println("Updated password for userId: " + userId);
            } else {
                System.err.println("⚠No user found with ID: " + userId);
            }

        } catch (SQLException e) {
            System.err.println("Error updating password for userId " + userId + ": " + e.getMessage());
            e.printStackTrace();
        }
    }

}
