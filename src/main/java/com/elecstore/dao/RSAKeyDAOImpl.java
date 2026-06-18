package com.elecstore.dao;

import com.elecstore.model.RSAKey;
import com.elecstore.utils.DatabaseConnection;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;

public class RSAKeyDAOImpl implements RSAKeyDAO {

    @Override
    public boolean save(RSAKey key) {

        String sql =
                "INSERT INTO rsa_keys(user_id,key_size,public_key) " +
                        "VALUES(?,?,?)";

        try (
                Connection conn = DatabaseConnection.getConnection();
                PreparedStatement ps = conn.prepareStatement(sql)
        ) {

            ps.setInt(1, key.getUserId());
            ps.setInt(2, key.getKeySize());
            ps.setString(3, key.getPublicKey());

            return ps.executeUpdate() > 0;

        } catch (Exception e) {
            e.printStackTrace();
        }

        return false;
    }
    @Override
    public boolean hasKey(int userId) {

        String sql =
                "SELECT COUNT(*) FROM rsa_keys WHERE user_id = ?";

        try (
                Connection conn = DatabaseConnection.getConnection();

                PreparedStatement ps =
                        conn.prepareStatement(sql)
        ) {

            ps.setInt(1, userId);

            ResultSet rs = ps.executeQuery();

            if (rs.next()) {

                return rs.getInt(1) > 0;
            }

        } catch (Exception e) {

            e.printStackTrace();
        }

        return false;
    }

    @Override
    public RSAKey getLatestKeyByUserId(int userId) {

        String sql =
                "SELECT id, user_id, key_size, public_key, created_at " +
                        "FROM rsa_keys WHERE user_id = ? " +
                        "ORDER BY id DESC LIMIT 1";

        try (
                Connection conn = DatabaseConnection.getConnection();
                PreparedStatement ps = conn.prepareStatement(sql)
        ) {

            ps.setInt(1, userId);

            ResultSet rs = ps.executeQuery();

            if (rs.next()) {

                RSAKey key = new RSAKey();
                key.setId(rs.getInt("id"));
                key.setUserId(rs.getInt("user_id"));
                key.setKeySize(rs.getInt("key_size"));
                key.setPublicKey(rs.getString("public_key"));
                key.setCreatedAt(rs.getTimestamp("created_at"));

                return key;
            }

        } catch (Exception e) {

            e.printStackTrace();
        }

        return null;
    }
}