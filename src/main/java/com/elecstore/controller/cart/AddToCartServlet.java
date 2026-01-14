package com.elecstore.controller.cart;

import com.elecstore.dao.CartDAO;
import com.elecstore.dao.CartItemDAO;
import com.elecstore.dao.ProductDAO;
import com.elecstore.dao.CartDAOImpl;
import com.elecstore.dao.CartItemDAOImpl;
import com.elecstore.dao.ProductDAOImpl;
import com.elecstore.model.Cart;
import com.elecstore.model.CartItem;
import com.elecstore.model.Product;
import com.elecstore.model.User;

import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.io.PrintWriter;

public class AddToCartServlet extends HttpServlet {

    private CartDAO cartDAO = new CartDAOImpl();
    private CartItemDAO cartItemDAO = new CartItemDAOImpl();
    private ProductDAO productDAO = new ProductDAOImpl();

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

            // 2. Get user info
            User user = (User) session.getAttribute("user");
            int userId = user.getId();
            int productId = Integer.parseInt(request.getParameter("productId"));
            int quantity = Integer.parseInt(request.getParameter("quantity") != null ?
                    request.getParameter("quantity") : "1");

            // 3. Get or create cart for user
            Cart cart = cartDAO.findByUserId(userId);
            if (cart == null) {
                cart = cartDAO.createCart(userId);
                System.out.println("[AddToCart] Created new cart for user " + userId);
            }

            // 4. Get product info
            Product product = productDAO.findById(productId);
            if (product == null) {
                response.setStatus(HttpServletResponse.SC_NOT_FOUND);
                out.println("{\"success\": false, \"message\": \"Sản phẩm không tồn tại\"}");
                return;
            }

            // 5. Check if product already in cart
            CartItem existingItem = cartItemDAO.findByCartAndProduct(cart.getId(), productId);

            if (existingItem != null) {
                // Update quantity if product already in cart
                int newQuantity = existingItem.getQuantity() + quantity;
                boolean updated = cartItemDAO.updateQuantity(existingItem.getId(), newQuantity);

                if (updated) {
                    out.println("{\"success\": true, \"message\": \"Đã cập nhật sản phẩm trong giỏ\"}");
                    System.out.println("[AddToCart] Updated quantity for product " + productId +
                            " in cart " + cart.getId());
                } else {
                    response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
                    out.println("{\"success\": false, \"message\": \"Lỗi cập nhật giỏ hàng\"}");
                }
            } else {
                // Add new item to cart
                CartItem newItem = new CartItem(cart.getId(), productId, quantity, product.getPrice());
                CartItem savedItem = cartItemDAO.addItem(newItem);

                if (savedItem != null) {
                    out.println("{\"success\": true, \"message\": \"Đã thêm vào giỏ hàng\", " +
                            "\"cartItemId\": " + savedItem.getId() + "}");
                    System.out.println("[AddToCart] Added new item to cart " + cart.getId());
                } else {
                    response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
                    out.println("{\"success\": false, \"message\": \"Lỗi thêm vào giỏ hàng\"}");
                }
            }

        } catch (NumberFormatException e) {
            response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
            out.println("{\"success\": false, \"message\": \"Tham số không hợp lệ\"}");
            System.err.println("[AddToCart] Invalid parameters: " + e.getMessage());
        } catch (Exception e) {
            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            out.println("{\"success\": false, \"message\": \"Lỗi server\"}");
            System.err.println("[AddToCart] Error: " + e.getMessage());
            e.printStackTrace();
        }
    }
}
