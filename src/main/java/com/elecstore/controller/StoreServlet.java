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

@WebServlet("/home/store")
public class StoreServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {

        ProductDAO productDAO = DAOFactory.getInstance().getProductDAO();
        CategoryDAO categoryDAO = DAOFactory.getInstance().getCategoryDAO();

        List<Product> products = productDAO.findAll();
        List<Category> categories = categoryDAO.findAll();

        req.setAttribute("products",products);
        req.setAttribute("categories",categories);

        req.getRequestDispatcher("/WEB-INF/views/store.jsp").forward(req,resp);
    }
}
