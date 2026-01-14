package com.elecstore.controller.auth;

import com.elecstore.dao.UserDAO;
import com.elecstore.dao.UserDAOImpl;
import com.elecstore.model.User;
import com.elecstore.utils.PasswordUtil;
import com.google.gson.JsonObject;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.io.PrintWriter;

public class ChangePasswordServlet extends HttpServlet {

    private UserDAO userDAO = new UserDAOImpl();

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        response.setContentType("application/json;charset=UTF-8");
        PrintWriter out = response.getWriter();
        JsonObject result = new JsonObject();

        try {
            HttpSession session = request.getSession();
            User user = (User) session.getAttribute("user");

            if (user == null) {
                result.addProperty("success", false);
                result.addProperty("message", "Vui lòng đăng nhập!");
                out.print(result.toString());
                return;
            }

            String oldPassword = request.getParameter("oldPassword");
            String newPassword = request.getParameter("newPassword");
            String confirmPassword = request.getParameter("confirmPassword");

            User userInDB = userDAO.getById(user.getId());
            if (userInDB == null) {
                result.addProperty("success", false);
                result.addProperty("message", "Tài khoản không tồn tại!");
                out.print(result.toString());
                return;
            }

            boolean isOldPasswordCorrect;
            try {
                isOldPasswordCorrect = PasswordUtil.validatePassword(oldPassword, userInDB.getPassword());
            } catch (Exception e) {
                isOldPasswordCorrect = oldPassword.equals(userInDB.getPassword());
            }

            if (!isOldPasswordCorrect) {
                result.addProperty("success", false);
                result.addProperty("message", "Mật khẩu cũ không chính xác!");
                out.print(result.toString());
                return;
            }

            // Kiểm tra confirm password
            if (!newPassword.equals(confirmPassword)) {
                result.addProperty("success", false);
                result.addProperty("message", "Mật khẩu xác nhận không khớp!");
                out.print(result.toString());
                return;
            }

            // Kiểm tra độ dài
            if (newPassword.length() < 6) {
                result.addProperty("success", false);
                result.addProperty("message", "Mật khẩu phải từ 6 ký tự trở lên!");
                out.print(result.toString());
                return;
            }

            // Update password
            userDAO.updatePassword(user.getId(), newPassword);

            result.addProperty("success", true);
            result.addProperty("message", "Đổi mật khẩu thành công!");

        } catch (Exception e) {
            e.printStackTrace();
            result.addProperty("success", false);
            result.addProperty("message", "Lỗi: " + e.getMessage());
        }

        out.print(result.toString());
        out.flush();
    }
}
