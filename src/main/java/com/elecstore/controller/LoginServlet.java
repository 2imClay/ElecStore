package com.elecstore.controller;

import com.elecstore.dao.UserDAO;
import com.elecstore.dao.UserDAOImpl;
import com.elecstore.model.User;
import com.elecstore.utils.PasswordUtil;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
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

        // Nếu user đã đăng nhập, redirect tới trang chủ
        HttpSession session = request.getSession();
        if (session.getAttribute("user") != null) {
            response.sendRedirect("home");
            return;
        }

        // Lấy email từ query parameter (nếu có - từ register)
        String email = request.getParameter("email");
        if (email != null && !email.isEmpty()) {
            request.setAttribute("email", email);
            request.setAttribute("success", "✓ Đăng ký thành công! Vui lòng đăng nhập.");
        }

        // Forward tới login.jsp
        request.getRequestDispatcher("WEB-INF/views/login.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        response.setCharacterEncoding("UTF-8");

        UserDAO userDAO = null;

        try {
            // Lấy dữ liệu từ form
            String email = request.getParameter("email");
            String password = request.getParameter("password");
            String rememberMe = request.getParameter("remember");

            System.out.println("[LOGIN] === Form Data ===");
            System.out.println("Email: " + email);
            System.out.println("Password: " + (password != null ? "✓ có" : "✗ không"));
            System.out.println("RememberMe: " + rememberMe);

            // ===== VALIDATION =====
            if (email == null || email.trim().isEmpty()) {
                request.setAttribute("error", "❌ Email không được để trống");
                request.getRequestDispatcher("WEB-INF/views/login.jsp").forward(request, response);
                return;
            }

            if (password == null || password.isEmpty()) {
                request.setAttribute("error", "❌ Mật khẩu không được để trống");
                request.setAttribute("email", email);
                request.getRequestDispatcher("WEB-INF/views/login.jsp").forward(request, response);
                return;
            }

            email = email.trim().toLowerCase();

            // ===== FIND USER BY EMAIL =====
            userDAO = new UserDAOImpl();
            User user = userDAO.findByEmail(email);

            System.out.println("[LOGIN] Find user by email: " + (user != null ? "✓ FOUND" : "✗ NOT FOUND"));

            if (user == null) {
                request.setAttribute("error", "❌ Email hoặc mật khẩu không đúng");
                request.setAttribute("email", email);
                request.getRequestDispatcher("WEB-INF/views/login.jsp").forward(request, response);
                return;
            }

            // ===== CHECK IF ACCOUNT ACTIVE =====
            if (user.getIsActive() == 0) {
                System.out.println("[LOGIN] Account not active: " + email);
                request.setAttribute("error", "❌ Tài khoản của bạn chưa được kích hoạt. Vui lòng kiểm tra email.");
                request.setAttribute("email", email);
                request.getRequestDispatcher("WEB-INF/views/login.jsp").forward(request, response);
                return;
            }

            // ===== VERIFY PASSWORD =====
            boolean isPasswordCorrect = PasswordUtil.validatePassword(password, user.getPassword());
            System.out.println("[LOGIN] Password verification: " + (isPasswordCorrect ? "✓ CORRECT" : "✗ WRONG"));

            if (!isPasswordCorrect) {
                request.setAttribute("error", "❌ Email hoặc mật khẩu không đúng");
                request.setAttribute("email", email);
                request.getRequestDispatcher("WEB-INF/views/login.jsp").forward(request, response);
                return;
            }

            // ===== LOGIN SUCCESS =====
            System.out.println("[LOGIN] ✓ Login successful for: " + email);

            // Set session
            HttpSession session = request.getSession();
            session.setAttribute("user", user);
            session.setAttribute("userId", user.getId());
            session.setAttribute("userName", user.getFirstName() + " " + user.getLastName());
            session.setAttribute("userEmail", user.getEmail());
            session.setMaxInactiveInterval(30 * 60); // 30 minutes

            // Remember me (optional - tạo cookie)
            if ("on".equals(rememberMe) || "true".equals(rememberMe)) {
                System.out.println("[LOGIN] RememberMe enabled");
                // Có thể tạo cookie để nhớ email
                // Cookie emailCookie = new Cookie("rememberedEmail", email);
                // emailCookie.setMaxAge(7 * 24 * 60 * 60); // 7 days
                // response.addCookie(emailCookie);
            }

            // Redirect to home or dashboard
            String redirectURL = "home";
            if (request.getParameter("next") != null) {
                redirectURL = request.getParameter("next");
            }
            response.sendRedirect(redirectURL);

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
