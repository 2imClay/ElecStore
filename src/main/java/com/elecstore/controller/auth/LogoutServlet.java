// ===== LogoutServlet.java - ĐĂNG XUẤT =====
package com.elecstore.controller.auth;

import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

public class LogoutServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        response.setCharacterEncoding("UTF-8");

        HttpSession session = request.getSession();

        Object userEmail = session.getAttribute("userEmail");
        System.out.println("[LOGOUT] ✓ User logged out: " + (userEmail != null ? userEmail : "Unknown"));

        session.invalidate();

        request.getSession().setAttribute("logoutSuccess", "✓ Đã đăng xuất thành công");

        response.sendRedirect("login");
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        doGet(request, response);
    }
}
