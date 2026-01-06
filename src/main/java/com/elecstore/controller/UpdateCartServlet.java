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

public class UpdateCartServlet extends HttpServlet {

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

            // 2. Get parameters
            int cartItemId = Integer.parseInt(request.getParameter("cartItemId"));
            int newQuantity = Integer.parseInt(request.getParameter("quantity"));

            // 3. Validate quantity
            if (newQuantity < 1) {
                response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
                out.println("{\"success\": false, \"message\": \"Số lượng phải >= 1\"}");
                return;
            }

            // 4. Update quantity
            boolean updated = cartItemDAO.updateQuantity(cartItemId, newQuantity);

            if (updated) {
                out.println("{\"success\": true, \"message\": \"Cập nhật thành công\"}");
                System.out.println("[UpdateCart] Updated item " + cartItemId + " quantity to " + newQuantity);
            } else {
                response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
                out.println("{\"success\": false, \"message\": \"Lỗi cập nhật\"}");
            }

        } catch (NumberFormatException e) {
            response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
            out.println("{\"success\": false, \"message\": \"Tham số không hợp lệ\"}");
            System.err.println("[UpdateCart] Invalid parameters: " + e.getMessage());
        } catch (Exception e) {
            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            out.println("{\"success\": false, \"message\": \"Lỗi server\"}");
            System.err.println("[UpdateCart] Error: " + e.getMessage());
            e.printStackTrace();
        }
    }
}
