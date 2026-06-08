package com.elecstore.controller.auth;

import com.elecstore.dao.UserDAO;
import com.elecstore.dao.UserDAOImpl;
import com.elecstore.model.User;
import com.elecstore.service.EmailService;
import com.google.gson.JsonObject;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.io.PrintWriter;

public class ForgotPasswordServlet extends HttpServlet {

    private UserDAO userDAO = new UserDAOImpl();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        request.getRequestDispatcher("/WEB-INF/views/forgot-password.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        response.setContentType("application/json;charset=UTF-8");
        PrintWriter out = response.getWriter();
        JsonObject result = new JsonObject();

        String action = request.getParameter("action");

        if ("sendCode".equals(action)) {
            try {
                String email = request.getParameter("email");
                User user = userDAO.getByEmail(email);

                if (user == null) {
                    result.addProperty("success", false);
                    result.addProperty("message", "Email không tồn tại trong hệ thống!");
                } else {
                    String otp = String.format("%06d", (int)(Math.random() * 1000000));

                    HttpSession session = request.getSession();
                    session.setAttribute("resetEmail", email);
                    session.setAttribute("resetCode", otp);
                    session.setAttribute("resetCodeExpiry", System.currentTimeMillis() + 5*60*1000); // 5 phút

                    sendResetCodeEmail(email, otp);

                    boolean emailSent = EmailService.sendOtpEmail(email, otp, user.getUserName());

                    if (emailSent) {
                        result.addProperty("success", true);
                        result.addProperty("message", "Mã xác thực đã được gửi đến " + email);
                        System.out.println("🔥 OTP gửi thành công: " + otp + " → " + email);
                    } else {
                        result.addProperty("success", false);
                        result.addProperty("message", "Lỗi gửi email. Vui lòng thử lại!");
                    }

                    result.addProperty("success", true);
                    result.addProperty("message", "Mã xác thực đã được gửi đến " + email);
                }
            } catch (Exception e) {
                result.addProperty("success", false);
                result.addProperty("message", "Lỗi: " + e.getMessage());
            }
        }
        else if ("verifyCode".equals(action)) {
            try {
                String code = request.getParameter("code");
                HttpSession session = request.getSession();

                String storedCode = (String) session.getAttribute("resetCode");
                Long expiry = (Long) session.getAttribute("resetCodeExpiry");

                if (storedCode == null || System.currentTimeMillis() > expiry) {
                    result.addProperty("success", false);
                    result.addProperty("message", "Mã xác thực đã hết hạn!");
                } else if (!code.equals(storedCode)) {
                    result.addProperty("success", false);
                    result.addProperty("message", "Mã xác thực không chính xác!");
                } else {
                    result.addProperty("success", true);
                    result.addProperty("message", "Mã xác thực chính xác!");
                    session.setAttribute("codeVerified", true);
                }
            } catch (Exception e) {
                result.addProperty("success", false);
                result.addProperty("message", "Lỗi: " + e.getMessage());
            }
        }
        else if ("resetPassword".equals(action)) {
            try {
                HttpSession session = request.getSession();
                Boolean verified = (Boolean) session.getAttribute("codeVerified");

                if (verified == null || !verified) {
                    result.addProperty("success", false);
                    result.addProperty("message", "Vui lòng xác thực code trước!");
                } else {
                    String email = (String) session.getAttribute("resetEmail");
                    String newPassword = request.getParameter("newPassword");

                    User user = userDAO.getByEmail(email);
                    userDAO.updatePassword(user.getId(), newPassword);

                    session.removeAttribute("resetEmail");
                    session.removeAttribute("resetCode");
                    session.removeAttribute("codeVerified");

                    result.addProperty("success", true);
                    result.addProperty("message", "✅ Đặt lại mật khẩu thành công!");
                }
            } catch (Exception e) {
                result.addProperty("success", false);
                result.addProperty("message", "Lỗi: " + e.getMessage());
            }
        }

        out.print(result.toString());
        out.flush();
    }

    private void sendResetCodeEmail(String email, String code) {
        // TODO: Implement email sending (use SMTP)
        System.out.println("Reset code for " + email + ": " + code);
    }
}
