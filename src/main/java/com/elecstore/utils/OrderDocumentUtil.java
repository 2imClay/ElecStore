package com.elecstore.utils;

import java.util.List;
public class OrderDocumentUtil {

    public static final double SHIPPING_FEE = 30000;

    public static class LineItem {
        public final String productName;
        public final int quantity;
        public final double price;

        public LineItem(String productName, int quantity, double price) {
            this.productName = productName;
            this.quantity = quantity;
            this.price = price;
        }
    }

    public static String buildDocumentContent(
            String fullName,
            String phone,
            String email,
            String address,
            String city,
            String country,
            List<LineItem> items) {

        double subtotal = 0;
        for (LineItem item : items) {
            subtotal += item.price * item.quantity;
        }
        double total = subtotal + SHIPPING_FEE;

        StringBuilder content = new StringBuilder();

        content.append("========== DON HANG ==========\n\n");

        content.append("===== THONG TIN GIAO HANG =====\n");
        content.append("Ho ten: ").append(nullToEmpty(fullName).trim()).append("\n");
        content.append("So dien thoai: ").append(nullToEmpty(phone)).append("\n");
        content.append("Email: ").append(nullToEmpty(email)).append("\n");
        content.append("Dia chi: ").append(nullToEmpty(address)).append("\n");
        content.append("Thanh pho: ").append(nullToEmpty(city)).append("\n");
        content.append("Quoc gia: ").append(nullToEmpty(country)).append("\n");
        content.append("Thanh toan: cod\n");
        content.append("Ghi chu: \n\n");

        content.append("===== SAN PHAM =====\n");

        int index = 1;
        for (LineItem item : items) {

            double itemTotal = item.price * item.quantity;

            content.append("San pham ").append(index).append("\n");
            content.append("Ten: ").append(nullToEmpty(item.productName)).append("\n");
            content.append("So luong: ").append(item.quantity).append("\n");
            content.append("Don gia: ").append(formatNumber(item.price)).append(" VND\n");
            content.append("Thanh tien: ").append(formatNumber(itemTotal)).append(" VND\n");
            content.append("--------------------------\n");

            index++;
        }

        content.append("\n===== TONG TIEN =====\n");
        content.append("Tam tinh: ").append(formatNumber(subtotal)).append(" VND\n");
        content.append("Phi van chuyen: ").append(formatNumber(SHIPPING_FEE)).append(" VND\n");
        content.append("Tong thanh toan: ").append(formatNumber(total)).append(" VND\n");

        return content.toString();
    }

    public static String buildOrderSnapshotContent(
            int orderId,
            String customerName,
            String address,
            String phone,
            String paymentMethod,
            String note,
            double totalAmount,
            List<com.elecstore.model.OrderDetail> items) {

        StringBuilder content = new StringBuilder();

        content.append("========== ORDER SNAPSHOT ==========\n");
        content.append("OrderId: ").append(orderId).append("\n");
        content.append("Ho ten: ").append(nullToEmpty(customerName).trim()).append("\n");
        content.append("Dia chi: ").append(nullToEmpty(address).trim()).append("\n");
        content.append("So dien thoai: ").append(nullToEmpty(phone).trim()).append("\n");
        content.append("Thanh toan: ").append(nullToEmpty(paymentMethod).trim()).append("\n");
        content.append("Ghi chu: ").append(nullToEmpty(note).trim()).append("\n");

        content.append("===== SAN PHAM =====\n");

        // Sắp xếp theo product_id để đảm bảo thứ tự ổn định, không phụ thuộc thứ tự trả về của query
        List<com.elecstore.model.OrderDetail> sorted = new java.util.ArrayList<>(items);
        sorted.sort((a, b) -> Integer.compare(a.getProductId(), b.getProductId()));

        for (com.elecstore.model.OrderDetail item : sorted) {
            content.append("ProductId: ").append(item.getProductId()).append("\n");
            content.append("So luong: ").append(item.getQuantity()).append("\n");
            content.append("Don gia: ").append(formatNumber(item.getPrice())).append(" VND\n");
            content.append("--------------------------\n");
        }

        content.append("Tong thanh toan: ").append(formatNumber(totalAmount)).append(" VND\n");

        return content.toString();
    }

    public static String buildOrderSnapshotContent(com.elecstore.model.Order order) {
        return buildOrderSnapshotContent(
                order.getId(),
                order.getCustomerName(),
                order.getAddress(),
                order.getPhone(),
                order.getPaymentMethod(),
                order.getNote(),
                order.getTotalAmount(),
                order.getItems()
        );
    }

    public static String sha256Hex(String content) {
        try {
            java.security.MessageDigest digest = java.security.MessageDigest.getInstance("SHA-256");
            byte[] hashBytes = digest.digest(content.getBytes("UTF-8"));

            StringBuilder hex = new StringBuilder();
            for (byte b : hashBytes) {
                hex.append(String.format("%02x", b));
            }
            return hex.toString();

        } catch (Exception e) {
            throw new RuntimeException("Không thể tính hash SHA-256", e);
        }
    }

    private static String nullToEmpty(String s) {
        return s == null ? "" : s;
    }

    private static String formatNumber(double value) {
        if (value == Math.floor(value)) {
            return String.valueOf((long) value);
        }
        return String.valueOf(value);
    }
}