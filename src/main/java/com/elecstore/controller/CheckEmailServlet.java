package com.elecstore.controller;

import com.elecstore.dao.DAOFactory;
import com.elecstore.dao.UserDAO;
import com.google.gson.JsonObject;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;

@WebServlet("/check-mail")
public class CheckEmailServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        resp.setContentType("application/json; charset=UTF-8");
        req.setCharacterEncoding("UTF-8");

        try {
            String email = req.getParameter("email");
            JsonObject json = new JsonObject();

            if (email == null || email.trim().isEmpty()) {
                json.addProperty("exists", false);
                resp.getWriter().print(json);
                return;
            }

            email = email.trim().toLowerCase();

            // Check email in database
            UserDAO userDAO = DAOFactory.getInstance().getUserDAO();
            boolean exists = userDAO.isEmailExists(email);

            json.addProperty("exists", exists);
            resp.getWriter().print(json);

        } catch (Exception e) {
            System.err.println("Error checking email: " + e.getMessage());
            resp.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Server error");
        }
    }
}
