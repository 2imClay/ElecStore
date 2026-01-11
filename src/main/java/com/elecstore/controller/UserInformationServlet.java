package com.elecstore.controller;

import java.io.IOException;
import java.sql.SQLException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import com.elecstore.dao.UserDAO;
import com.elecstore.dao.UserDAOImpl;
import com.elecstore.model.User;

public class UserInformationServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        response.setCharacterEncoding("UTF-8");

        HttpSession session = request.getSession();

        // ===== CHECK USER LOGGED IN =====
        User user = (User) session.getAttribute("user");

        if (user == null) {
            System.out.println("[USER-INFO] ❌ User not logged in - redirect to login");
            response.sendRedirect("login");
            return;
        }

        System.out.println("[USER-INFO] ✓ User logged in: " + user.getEmail());

        // ===== GET FRESH USER DATA FROM DATABASE =====
        try {
            UserDAO userDAO = new UserDAOImpl();
            User updatedUser = userDAO.getById(user.getId());

            if (updatedUser != null) {
                System.out.println("[USER-INFO] ✓ Fresh user data loaded");
                // Set request attributes
                request.setAttribute("user", updatedUser);
                request.setAttribute("userName", updatedUser.getLastName() + " " + updatedUser.getFirstName());
                request.setAttribute("userEmail", updatedUser.getEmail());
                request.setAttribute("userPhone", updatedUser.getPhone() != null ? updatedUser.getPhone() : "Chưa cập nhật");
                request.setAttribute("userCity", updatedUser.getCity() != null ? updatedUser.getCity() : "Chưa cập nhật");
                request.setAttribute("userAddress", updatedUser.getAddress() != null ? updatedUser.getAddress() : "Chưa cập nhật");
                request.setAttribute("userCountry", updatedUser.getCountry() != null ? updatedUser.getCountry() : "Việt Nam");
                request.setAttribute("createdAt", updatedUser.getCreatedAt() != null ? updatedUser.getCreatedAt() : "");

                request.setAttribute("orderCount", userDAO.getTotalOrdersCount(user.getId()));
                request.setAttribute("totalSpent", userDAO.totalSpent(user.getId()));
                request.setAttribute("points", userDAO.totalSpent(user.getId())/100);

                // Forward to JSP
                request.getRequestDispatcher("WEB-INF/views/user-information.jsp").forward(request, response);
            } else {
                System.out.println("[USER-INFO] ❌ User not found in DB");
                session.invalidate();
                response.sendRedirect("login");
            }

        } catch (SQLException e) {
            System.err.println("[USER-INFO] ❌ SQLException: " + e.getMessage());
            e.printStackTrace();
            request.setAttribute("error", "Lỗi tải thông tin user: " + e.getMessage());
            request.getRequestDispatcher("WEB-INF/views/user-information.jsp").forward(request, response);
        } catch (Exception e) {
            System.err.println("[USER-INFO] ❌ Exception: " + e.getMessage());
            e.printStackTrace();
            request.setAttribute("error", "Đã xảy ra lỗi: " + e.getMessage());
            request.getRequestDispatcher("WEB-INF/views/user-information.jsp").forward(request, response);
        }
    }
}
