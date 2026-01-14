package com.elecstore.controller.mail;

import com.google.gson.JsonObject;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.io.PrintWriter;

@WebServlet("/verify-otp")
public class VerifyOtpServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        response.setContentType("application/json;charset=UTF-8");
        PrintWriter out = response.getWriter();
        JsonObject result = new JsonObject();

        try {
            String email = request.getParameter("email");
            String otpInput = request.getParameter("otp");

            HttpSession session = request.getSession();
            String storedOtp = (String) session.getAttribute("forgotOtp_" + email);

            if (storedOtp != null && storedOtp.equals(otpInput)) {
                // ✅ OTP đúng → Chuyển sang reset password
                session.setAttribute("resetEmail", email);
                result.addProperty("success", true);
                result.addProperty("message", "Xác thực thành công! Vui lòng tạo mật khẩu mới.");
            } else {
                result.addProperty("success", false);
                result.addProperty("message", "Mã xác thực không đúng!");
            }

        } catch (Exception e) {
            result.addProperty("success", false);
            result.addProperty("message", "Lỗi: " + e.getMessage());
        }

        out.print(result.toString());
    }
}
