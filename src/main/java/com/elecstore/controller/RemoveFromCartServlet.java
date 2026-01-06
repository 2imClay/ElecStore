package com.elecstore.controller;

import com.elecstore.dao.CartItemDAO;
import com.elecstore.dao.CartItemDAOImpl;

import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.io.PrintWriter;

public class RemoveFromCartServlet extends HttpServlet {

    private CartItemDAO cartItemDAO = new CartItemDAOImpl();

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        response.setContentType("application/json;charset=UTF-8");
        PrintWriter out = response.getWriter();

        try {
            // 1. Check login
            HttpSession session = request.getSession(false);
            if (session == null || session.getAttribute("user") == null) {
                response.setStatus(HttpServletResponse.SC_UNAUTHORIZED);
                out.println("{\"success\": false, \"message\": \"Vui lòng đăng nhập\"}");
                return;
            }

            // 2. Get parameter
            int cartItemId = Integer.parseInt(request.getParameter("cartItemId"));

            // 3. Remove item
            boolean removed = cartItemDAO.removeItem(cartItemId);

            if (removed) {
                out.println("{\"success\": true, \"message\": \"Đã xóa sản phẩm\"}");
                System.out.println("[RemoveFromCart] Removed item " + cartItemId);
            } else {
                response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
                out.println("{\"success\": false, \"message\": \"Lỗi xóa sản phẩm\"}");
            }

        } catch (NumberFormatException e) {
            response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
            out.println("{\"success\": false, \"message\": \"Tham số không hợp lệ\"}");
            System.err.println("[RemoveFromCart] Invalid parameters: " + e.getMessage());
        } catch (Exception e) {
            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            out.println("{\"success\": false, \"message\": \"Lỗi server\"}");
            System.err.println("[RemoveFromCart] Error: " + e.getMessage());
            e.printStackTrace();
        }
    }
}
