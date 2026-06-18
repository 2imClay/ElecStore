package com.elecstore.dao;

import com.elecstore.model.RSAKey;
import com.elecstore.utils.DatabaseConnection;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.Statement;

public class RSAKeyDAOImpl implements RSAKeyDAO {

    @Override
    public boolean save(RSAKey key) {
        return saveAndReturnId(key) > 0;
    }

    @Override
    public int saveAndReturnId(RSAKey key) {
        String sql = """
            INSERT INTO rsa_keys(user_id, key_size, public_key, status)
            VALUES (?, ?, ?, 'ACTIVE')
        """;

        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {

            ps.setInt(1, key.getUserId());
            ps.setInt(2, key.getKeySize());
            ps.setString(3, key.getPublicKey());

            int rows = ps.executeUpdate();

            if (rows > 0) {
                try (ResultSet keys = ps.getGeneratedKeys()) {
                    if (keys.next()) {
                        int id = keys.getInt(1);
                        key.setId(id);
                        key.setStatus("ACTIVE");
                        return id;
                    }
                }
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return 0;
    }

    @Override
    public boolean hasKey(int userId) {
        String sql = "SELECT COUNT(*) FROM rsa_keys WHERE user_id = ?";

        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, userId);

            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt(1) > 0;
                }
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return false;
    }

    @Override
    public boolean hasActiveKey(int userId) {
        String sql = """
            SELECT COUNT(*)
            FROM rsa_keys
            WHERE user_id = ?
              AND status = 'ACTIVE'
        """;

        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, userId);

            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt(1) > 0;
                }
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return false;
    }

    @Override
    public RSAKey getLatestKeyByUserId(int userId) {
        String sql = """
            SELECT id, user_id, key_size, public_key, created_at,
                   status, revoked_at, revoked_reason, replaced_by_key_id
            FROM rsa_keys
            WHERE user_id = ?
            ORDER BY id DESC
            LIMIT 1
        """;

        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, userId);

            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return mapResultSetToRSAKey(rs);
                }
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return null;
    }

    @Override
    public RSAKey getActiveKeyByUserId(int userId) {
        String sql = """
            SELECT id, user_id, key_size, public_key, created_at,
                   status, revoked_at, revoked_reason, replaced_by_key_id
            FROM rsa_keys
            WHERE user_id = ?
              AND status = 'ACTIVE'
            ORDER BY id DESC
            LIMIT 1
        """;

        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, userId);

            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return mapResultSetToRSAKey(rs);
                }
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return null;
    }

    @Override
    public RSAKey getById(int keyId) {
        String sql = """
            SELECT id, user_id, key_size, public_key, created_at,
                   status, revoked_at, revoked_reason, replaced_by_key_id
            FROM rsa_keys
            WHERE id = ?
        """;

        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, keyId);

            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return mapResultSetToRSAKey(rs);
                }
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return null;
    }

    @Override
    public int replaceLostKey(int userId, int oldKeyId, RSAKey newKey, String reason) {
        String insertSql = """
            INSERT INTO rsa_keys(user_id, key_size, public_key, status)
            VALUES (?, ?, ?, 'ACTIVE')
        """;

        String revokeSql = """
            UPDATE rsa_keys
            SET status = 'LOST',
                revoked_at = CURRENT_TIMESTAMP,
                revoked_reason = ?,
                replaced_by_key_id = ?
            WHERE id = ?
              AND user_id = ?
              AND status = 'ACTIVE'
        """;

        Connection conn = null;

        try {
            conn = DatabaseConnection.getConnection();
            conn.setAutoCommit(false);

            int newKeyId = 0;

            try (PreparedStatement ps = conn.prepareStatement(insertSql, Statement.RETURN_GENERATED_KEYS)) {
                ps.setInt(1, userId);
                ps.setInt(2, newKey.getKeySize());
                ps.setString(3, newKey.getPublicKey());

                int insertRows = ps.executeUpdate();

                if (insertRows <= 0) {
                    conn.rollback();
                    return 0;
                }

                try (ResultSet keys = ps.getGeneratedKeys()) {
                    if (keys.next()) {
                        newKeyId = keys.getInt(1);
                    }
                }
            }

            if (newKeyId <= 0) {
                conn.rollback();
                return 0;
            }

            try (PreparedStatement ps = conn.prepareStatement(revokeSql)) {
                ps.setString(1, reason);
                ps.setInt(2, newKeyId);
                ps.setInt(3, oldKeyId);
                ps.setInt(4, userId);

                int revokeRows = ps.executeUpdate();

                if (revokeRows <= 0) {
                    conn.rollback();
                    return 0;
                }
            }

            conn.commit();

            newKey.setId(newKeyId);
            newKey.setStatus("ACTIVE");

            return newKeyId;

        } catch (Exception e) {
            e.printStackTrace();

            if (conn != null) {
                try {
                    conn.rollback();
                } catch (Exception rollbackException) {
                    rollbackException.printStackTrace();
                }
            }

            return 0;

        } finally {
            if (conn != null) {
                try {
                    conn.setAutoCommit(true);
                    conn.close();
                } catch (Exception closeException) {
                    closeException.printStackTrace();
                }
            }
        }
    }

    private RSAKey mapResultSetToRSAKey(ResultSet rs) throws Exception {
        RSAKey key = new RSAKey();

        key.setId(rs.getInt("id"));
        key.setUserId(rs.getInt("user_id"));
        key.setKeySize(rs.getInt("key_size"));
        key.setPublicKey(rs.getString("public_key"));
        key.setCreatedAt(rs.getTimestamp("created_at"));
        key.setStatus(rs.getString("status"));
        key.setRevokedAt(rs.getTimestamp("revoked_at"));
        key.setRevokedReason(rs.getString("revoked_reason"));

        int replacedByKeyId = rs.getInt("replaced_by_key_id");
        if (rs.wasNull()) {
            key.setReplacedByKeyId(null);
        } else {
            key.setReplacedByKeyId(replacedByKeyId);
        }

        return key;
    }
}