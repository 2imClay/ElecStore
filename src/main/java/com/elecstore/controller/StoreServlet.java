package com.elecstore.controller;

import com.elecstore.dao.CategoryDAO;
import com.elecstore.dao.DAOFactory;
import com.elecstore.dao.ProductDAO;
import com.elecstore.model.Category;
import com.elecstore.model.Product;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.util.List;

@WebServlet("/store")
public class StoreServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {

        ProductDAO productDAO = DAOFactory.getInstance().getProductDAO();
        CategoryDAO categoryDAO = DAOFactory.getInstance().getCategoryDAO();

        String keyword = req.getParameter("keyword");
        String categoryIdStr = req.getParameter("categoryId");

        List<Product> products = productDAO.findAll();
        List<Category> categories = categoryDAO.findAll();

        if (keyword != null && !keyword.trim().isEmpty()) {
            products = productDAO.searchByName(keyword.trim());
            req.setAttribute("keyword", keyword);
        } else if (categoryIdStr != null && !categoryIdStr.isEmpty()) {
            try {
                int categoryId = Integer.parseInt(categoryIdStr);
                products = productDAO.findByCategoryId(categoryId);
                req.setAttribute("categoryId", categoryId);
            } catch (NumberFormatException e) {
                products = productDAO.findAll();
            }
        } else {
            products = productDAO.findAll();
        }

        String sort = req.getParameter("sort");

        if ("price-asc".equals(sort)) {
            products = productDAO.getProductsByPriceAsc();
        } else if ("price-desc".equals(sort)) {
            products = productDAO.getProductsByPriceDesc();
        }

        req.setAttribute("products",products);
        req.setAttribute("categories",categories);
        req.setAttribute("selectedSort", sort);

        req.getRequestDispatcher("/WEB-INF/views/store.jsp").forward(req,resp);
    }
}
