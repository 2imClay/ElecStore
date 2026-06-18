package com.elecstore.controller;

import com.elecstore.model.RSAKey;
import com.elecstore.model.RSAKeyResponse;
import com.elecstore.model.User;
import com.elecstore.service.RSAService;
import com.google.gson.JsonObject;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import java.io.IOException;

@WebServlet("/report-lost-private-key")
public class ReportLostPrivateKeyServlet extends HttpServlet {

    private final RSAService rsaService = new RSAService();

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws IOException {
        response.setContentType("application/json;charset=UTF-8");

        JsonObject result = new JsonObject();

        try {
            HttpSession session = request.getSession(false);
            User user = session == null ? null : (User) session.getAttribute("user");

            if (user == null) {
                result.addProperty("success", false);
                result.addProperty("message", "Vui lòng đăng nhập!");
                response.getWriter().write(result.toString());
                return;
            }

            int userId = user.getId();

            RSAKey oldActiveKey = rsaService.getActiveKey(userId);

            if (oldActiveKey == null) {
                result.addProperty("success", false);
                result.addProperty("message", "Không tìm thấy khóa đang hoạt động để báo mất.");
                response.getWriter().write(result.toString());
                return;
            }

            int keySize = oldActiveKey.getKeySize();

            String keySizeParam = request.getParameter("keySize");
            if (keySizeParam != null && !keySizeParam.trim().isEmpty()) {
                keySize = Integer.parseInt(keySizeParam);
            }

            RSAKeyResponse newKeyPair = rsaService.generateKey(userId, keySize);

            RSAKey newKey = new RSAKey();
            newKey.setUserId(userId);
            newKey.setKeySize(keySize);
            newKey.setPublicKey(newKeyPair.getPublicKey());
            newKey.setStatus("ACTIVE");

            String reason = request.getParameter("reason");
            if (reason == null || reason.trim().isEmpty()) {
                reason = "User reported lost private key";
            }

            int newKeyId = rsaService.replaceLostKey(
                    userId,
                    oldActiveKey.getId(),
                    newKey,
                    reason
            );

            if (newKeyId <= 0) {
                result.addProperty("success", false);
                result.addProperty("message", "Báo mất khóa thất bại. Vui lòng thử lại.");
                response.getWriter().write(result.toString());
                return;
            }

            result.addProperty("success", true);
            result.addProperty("message", "Đã thu hồi khóa cũ và tạo khóa mới thành công. Vui lòng tải private key mới về máy.");
            result.addProperty("oldKeyId", oldActiveKey.getId());
            result.addProperty("newKeyId", newKeyId);
            result.addProperty("publicKey", newKeyPair.getPublicKey());
            result.addProperty("privateKey", newKeyPair.getPrivateKey());

        } catch (Exception e) {
            e.printStackTrace();

            result.addProperty("success", false);
            result.addProperty("message", "Lỗi hệ thống: " + e.getMessage());
        }

        response.getWriter().write(result.toString());
    }
}