package com.elecstore.model;

import java.sql.Timestamp;

public class RSAKey {

    private int id;
    private int userId;
    private int keySize;
    private String publicKey;
    private Timestamp createdAt;
    private String status;
    private Timestamp revokedAt;
    private String revokedReason;
    private Integer replacedByKeyId;

    public RSAKey() {
    }

    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public int getUserId() {
        return userId;
    }

    public void setUserId(int userId) {
        this.userId = userId;
    }

    public int getKeySize() {
        return keySize;
    }

    public void setKeySize(int keySize) {
        this.keySize = keySize;
    }

    public String getPublicKey() {
        return publicKey;
    }

    public void setPublicKey(String publicKey) {
        this.publicKey = publicKey;
    }


    public Timestamp getCreatedAt() {
        return createdAt;
    }

    public void setCreatedAt(Timestamp createdAt) {
        this.createdAt = createdAt;
    }

    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status;
    }

    public Timestamp getRevokedAt() {
        return revokedAt;
    }

    public void setRevokedAt(Timestamp revokedAt) {
        this.revokedAt = revokedAt;
    }

    public String getRevokedReason() {
        return revokedReason;
    }

    public void setRevokedReason(String revokedReason) {
        this.revokedReason = revokedReason;
    }

    public Integer getReplacedByKeyId() {
        return replacedByKeyId;
    }

    public void setReplacedByKeyId(Integer replacedByKeyId) {
        this.replacedByKeyId = replacedByKeyId;
    }
}
