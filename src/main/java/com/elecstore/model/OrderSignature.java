package com.elecstore.model;

import java.sql.Timestamp;

public class OrderSignature {

    private int id;
    private int orderId;
    private int keyId;
    private String signature;
    private String documentHash;
    private String orderDataHash; // Hash "snapshot" của dữ liệu đơn hàng (orders + order_details) tại thời điểm ký
    private String orderSnapshotContent; // Nội dung snapshot gốc (không phải hash) tại thời điểm ký, dùng để so sánh/diff
    private Timestamp verifiedAt;

    public OrderSignature() {
    }

    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public int getOrderId() {
        return orderId;
    }

    public void setOrderId(int orderId) {
        this.orderId = orderId;
    }

    public int getKeyId() {
        return keyId;
    }

    public void setKeyId(int keyId) {
        this.keyId = keyId;
    }

    public String getSignature() {
        return signature;
    }

    public void setSignature(String signature) {
        this.signature = signature;
    }

    public String getDocumentHash() {
        return documentHash;
    }

    public void setDocumentHash(String documentHash) {
        this.documentHash = documentHash;
    }

    public String getOrderDataHash() {
        return orderDataHash;
    }

    public void setOrderDataHash(String orderDataHash) {
        this.orderDataHash = orderDataHash;
    }

    public String getOrderSnapshotContent() {
        return orderSnapshotContent;
    }

    public void setOrderSnapshotContent(String orderSnapshotContent) {
        this.orderSnapshotContent = orderSnapshotContent;
    }

    public Timestamp getVerifiedAt() {
        return verifiedAt;
    }

    public void setVerifiedAt(Timestamp verifiedAt) {
        this.verifiedAt = verifiedAt;
    }
}