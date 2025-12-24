package com.elecstore.controller;

import com.elecstore.dao.*;
import com.elecstore.model.Category;
import com.elecstore.model.Product;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;

public class ProductDetailServlet extends HttpServlet {

    ProductDAO productDAO = DAOFactory.getInstance().getProductDAO();
    CategoryDAO categoryDAO = DAOFactory.getInstance().getCategoryDAO();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {

        String id = req.getParameter("id");

        if (id == null || id.isEmpty()) {
            resp.sendRedirect(req.getContextPath() + "/home");
            return;
        }

        try {

            int productId = Integer.parseInt(id);

            Product product = productDAO.findById(productId);

            System.out.println("Product tìm được: " + product);

            if (product == null) {
                resp.sendRedirect(req.getContextPath() + "/home");
                return;
            }

            Category  category = categoryDAO.findById(product.getCategoryId());

            req.setAttribute("category", category);
            req.setAttribute("product", product);

            req.getRequestDispatcher("/WEB-INF/views/product-detail.jsp").forward(req,resp);

        } catch (NumberFormatException e) {
            resp.sendRedirect(req.getContextPath() + "/home");
        }


    }
}
