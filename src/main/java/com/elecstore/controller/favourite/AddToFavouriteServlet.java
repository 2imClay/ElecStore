package com.elecstore.controller.favourite;

import com.elecstore.dao.*;
import com.elecstore.model.*;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.io.PrintWriter;

public class AddToFavouriteServlet extends HttpServlet {

    private FavouriteDAO favouriteDAO = new FavouriteDAOImpl();
    private FavouriteItemDAO favouriteItemDAO = new FavouriteItemDAOImpl();
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
            Favourite favourite = favouriteDAO.findByUserId(userId);
            if (favourite == null) {
                favourite = favouriteDAO.createFavourite(userId);
                System.out.println("Created new favourite for user " + userId);
            }

            // 4. Get product info
            Product product = productDAO.findById(productId);
            if (product == null) {
                response.setStatus(HttpServletResponse.SC_NOT_FOUND);
                out.println("{\"success\": false, \"message\": \"Sản phẩm không tồn tại\"}");
                return;
            }

            // 5. Check if product already in cart
            FavouriteItem existingItem = favouriteItemDAO.findByFavouriteAndProduct(favourite.getId(), productId);

            if (existingItem != null) {
                // Update quantity if product already in cart
                int newQuantity = existingItem.getQuantity() + quantity;
                boolean updated = favouriteItemDAO.updateQuantity(existingItem.getId(), newQuantity);

                if (updated) {
                    out.println("{\"success\": true, \"message\": \"Đã cập nhật sản phẩm trong yêu thích\"}");
                    System.out.println("Updated quantity for product " + productId +
                            " in favourite " + favourite.getId());
                } else {
                    response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
                    out.println("{\"success\": false, \"message\": \"Lỗi cập nhật yêu thích\"}");
                }
            } else {
                // Add new item to cart
                FavouriteItem newItem = new FavouriteItem(favourite.getId(), productId, quantity, product.getPrice());
                FavouriteItem savedItem = favouriteItemDAO.addItem(newItem);

                if (savedItem != null) {
                    out.println("{\"success\": true, \"message\": \"Đã thêm vào yêu thích\", " +
                            "\"favouriteItemId\": " + savedItem.getId() + "}");
                    System.out.println("Added new item to favourite " + favourite.getId());
                } else {
                    response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
                    out.println("{\"success\": false, \"message\": \"Lỗi thêm vào yêu thích\"}");
                }
            }

        } catch (NumberFormatException e) {
            response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
            out.println("{\"success\": false, \"message\": \"Tham số không hợp lệ\"}");
            System.err.println("Invalid parameters: " + e.getMessage());
        } catch (Exception e) {
            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            out.println("{\"success\": false, \"message\": \"Lỗi server\"}");
            System.err.println("Error: " + e.getMessage());
            e.printStackTrace();
        }
    }

}
