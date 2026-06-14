package com.elecstore.dao;

import com.elecstore.model.RSAKey;
import com.elecstore.utils.DatabaseConnection;

import java.sql.Connection;
import java.sql.PreparedStatement;

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
}