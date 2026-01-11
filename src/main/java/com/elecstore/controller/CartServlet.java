package com.elecstore.controller;

import com.elecstore.dao.*;
import com.elecstore.model.Cart;
import com.elecstore.model.CartItem;
import com.elecstore.model.User;

import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.util.List;

public class CartServlet extends HttpServlet {

    private CartDAO cartDAO = new CartDAOImpl();
    private CartItemDAO cartItemDAO = new CartItemDAOImpl();
    private UserDAO userDAO = new UserDAOImpl();

    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // 1. Check login
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        try {
            // 2. Get user and their cart
            User user = (User) session.getAttribute("user");
            int userId = user.getId();

            Cart cart = cartDAO.findByUserId(userId);

            // If no cart exists, create one
            if (cart == null) {
                cart = cartDAO.createCart(userId);
            }

            // 3. Get cart items
            List<CartItem> cartItems = cartItemDAO.getCartItems(cart.getId());

            double discount = userDAO.totalSpent(user.getId())/100;

            // 4. Set request attributes
            request.setAttribute("cart", cart);
            request.setAttribute("cartItems", cartItems);
            request.setAttribute("cartItemCount", cartItems.size());
            request.setAttribute("discount", discount);

            // 5. Calculate totals
            double subtotal = 0;
            for (CartItem item : cartItems) {
                subtotal += item.getPrice() * item.getQuantity();
            }
            request.setAttribute("subtotal", subtotal);

            // 6. Forward to JSP
            request.getRequestDispatcher("/WEB-INF/views/cart.jsp").forward(request, response);

        } catch (Exception e) {
            System.err.println("[CartServlet] Error: " + e.getMessage());
            e.printStackTrace();
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Error loading cart");
        }
    }
}
