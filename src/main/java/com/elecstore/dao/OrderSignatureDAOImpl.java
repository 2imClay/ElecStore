package com.elecstore.dao;

import com.elecstore.model.OrderSignature;
import com.elecstore.utils.DatabaseConnection;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.Statement;

public class OrderSignatureDAOImpl implements OrderSignatureDAO {

    @Override
    public boolean save(OrderSignature signature) {

        String sql =
                "INSERT INTO order_signatures(order_id, key_id, signature, document_hash, order_data_hash) " +
                        "VALUES(?,?,?,?,?)";

        try (
                Connection conn = DatabaseConnection.getConnection();
                PreparedStatement ps = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)
        ) {

            ps.setInt(1, signature.getOrderId());
            ps.setInt(2, signature.getKeyId());
            ps.setString(3, signature.getSignature());
            ps.setString(4, signature.getDocumentHash());
            ps.setString(5, signature.getOrderDataHash());

            int rows = ps.executeUpdate();

            if (rows > 0) {
                ResultSet keys = ps.getGeneratedKeys();
                if (keys.next()) {
                    signature.setId(keys.getInt(1));
                }
                return true;
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return false;
    }

    @Override
    public OrderSignature getLatestByOrderId(int orderId) {

        String sql =
                "SELECT id, order_id, key_id, signature, document_hash, order_data_hash, verified_at " +
                        "FROM order_signatures WHERE order_id = ? " +
                        "ORDER BY id DESC LIMIT 1";

        try (
                Connection conn = DatabaseConnection.getConnection();
                PreparedStatement ps = conn.prepareStatement(sql)
        ) {

            ps.setInt(1, orderId);

            ResultSet rs = ps.executeQuery();

            if (rs.next()) {

                OrderSignature signature = new OrderSignature();
                signature.setId(rs.getInt("id"));
                signature.setOrderId(rs.getInt("order_id"));
                signature.setKeyId(rs.getInt("key_id"));
                signature.setSignature(rs.getString("signature"));
                signature.setDocumentHash(rs.getString("document_hash"));
                signature.setOrderDataHash(rs.getString("order_data_hash"));
                signature.setVerifiedAt(rs.getTimestamp("verified_at"));

                return signature;
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return null;
    }
}