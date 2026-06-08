package com.elecstore.controller.auth;

import com.elecstore.dao.UserDAO;
import com.elecstore.dao.UserDAOImpl;
import com.elecstore.model.User;
import com.elecstore.utils.PasswordUtil;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.sql.SQLException;

public class LoginServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        response.setCharacterEncoding("UTF-8");

        HttpSession session = request.getSession();
        if (session.getAttribute("user") != null) {
            response.sendRedirect("home");
            return;
        }

        String email = request.getParameter("email");
        if (email != null && !email.isEmpty()) {
            request.setAttribute("email", email);
            request.setAttribute("success", "✓ Đăng ký thành công! Vui lòng đăng nhập.");
        }

        request.getRequestDispatcher("WEB-INF/views/login.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        response.setCharacterEncoding("UTF-8");

        UserDAO userDAO = null;

        try {
            String email = request.getParameter("email");
            String password = request.getParameter("password");
            String rememberMe = request.getParameter("remember");

            System.out.println("[LOGIN] === Form Data ===");
            System.out.println("Email: " + email);
            System.out.println("Password: " + (password != null ? "✓ có" : "✗ không"));
            System.out.println("RememberMe: " + rememberMe);

            if (email == null || email.trim().isEmpty()) {
                request.setAttribute("error", "Email không được để trống");
                request.getRequestDispatcher("WEB-INF/views/login.jsp").forward(request, response);
                return;
            }

            if (password == null || password.isEmpty()) {
                request.setAttribute("error", "Mật khẩu không được để trống");
                request.setAttribute("email", email);
                request.getRequestDispatcher("WEB-INF/views/login.jsp").forward(request, response);
                return;
            }

            email = email.trim().toLowerCase();

            userDAO = new UserDAOImpl();
            User user = userDAO.findByEmail(email);

            System.out.println("[LOGIN] Find user by email: " + (user != null ? "✓ FOUND" : "✗ NOT FOUND"));

            if (user == null) {
                request.setAttribute("error", "Email hoặc mật khẩu không đúng");
                request.setAttribute("email", email);
                request.getRequestDispatcher("WEB-INF/views/login.jsp").forward(request, response);
                return;
            }

            if (user.getStatus().equals("inactive")) {
                System.out.println("[LOGIN] Account not active: " + email);
                request.setAttribute("error", "Tài khoản của bạn chưa được kích hoạt. Vui lòng kiểm tra email.");
                request.setAttribute("email", email);
                request.getRequestDispatcher("WEB-INF/views/login.jsp").forward(request, response);
                return;
            }

            boolean isPasswordCorrect = PasswordUtil.validatePassword(password, user.getPassword());
            System.out.println("[LOGIN] Password verification: " + (isPasswordCorrect ? "✓ CORRECT" : "✗ WRONG"));

            if (!isPasswordCorrect) {
                request.setAttribute("error", "Email hoặc mật khẩu không đúng");
                request.setAttribute("email", email);
                request.getRequestDispatcher("WEB-INF/views/login.jsp").forward(request, response);
                return;
            }

            HttpSession session = request.getSession();
            session.setAttribute("user", user);
            session.setAttribute("userId", user.getId());
            session.setAttribute("userName", user.getFirstName() + " " + user.getLastName());
            session.setAttribute("userEmail", user.getEmail());
            session.setAttribute("userRole", user.getRole());
            session.setMaxInactiveInterval(30 * 60);

            System.out.println("[LOGIN] ✓ Success for " + email + " (Role: " + user.getRole() + ")");


            if ("on".equals(rememberMe) || "true".equals(rememberMe)) {
                System.out.println("[LOGIN] RememberMe enabled");

            }


            if ("admin".equalsIgnoreCase(user.getRole())) {
                response.sendRedirect(request.getContextPath() + "/admin/dashboard");
            } else {
                response.sendRedirect(request.getContextPath() + "/home");
            }


        } catch (SQLException e) {
            System.err.println("[LOGIN] ❌ SQLException: " + e.getMessage());
            e.printStackTrace();
            request.setAttribute("error", "❌ Lỗi cơ sở dữ liệu: " + e.getMessage());
            try {
                request.getRequestDispatcher("WEB-INF/views/login.jsp").forward(request, response);
            } catch (ServletException | IOException e1) {
                e1.printStackTrace();
            }

        } catch (Exception e) {
            System.err.println("[LOGIN] ❌ Exception: " + e.getMessage());
            e.printStackTrace();
            request.setAttribute("error", "❌ Đã xảy ra lỗi: " + e.getMessage());
            try {
                request.getRequestDispatcher("WEB-INF/views/login.jsp").forward(request, response);
            } catch (ServletException | IOException e1) {
                e1.printStackTrace();
            }
        }
    }
}
