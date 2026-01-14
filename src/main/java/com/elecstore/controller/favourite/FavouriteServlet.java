package com.elecstore.controller.favourite;

import com.elecstore.dao.*;
import com.elecstore.model.*;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.util.List;

public class FavouriteServlet extends HttpServlet {

    private FavouriteDAO favouriteDAO = new FavouriteDAOImpl();
    private FavouriteItemDAO favouriteItemDAO = new FavouriteItemDAOImpl();
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

            Favourite favourite = favouriteDAO.findByUserId(userId);

            // If no cart exists, create one
            if (favourite == null) {
                favourite = favouriteDAO.createFavourite(userId);
            }

            // 3. Get cart items
            List<FavouriteItem> favouriteItems = favouriteItemDAO.getFavouriteItems(favourite.getId());

            // 4. Set request attributes
            request.setAttribute("favourite", favourite);
            request.setAttribute("favouriteItems", favouriteItems);
            request.setAttribute("favouriteItemCount", favouriteItems.size());

            // 6. Forward to JSP
            request.getRequestDispatcher("/WEB-INF/views/favourite.jsp").forward(request, response);

        } catch (Exception e) {
            System.err.println("Error: " + e.getMessage());
            e.printStackTrace();
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Error loading favourite");
        }
    }
    
}
