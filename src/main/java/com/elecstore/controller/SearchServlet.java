package com.elecstore.controller;

import com.elecstore.dao.CategoryDAO;
import com.elecstore.dao.DAOFactory;
import com.elecstore.dao.ProductDAO;
import com.elecstore.dao.ProductDAOImpl;
import com.elecstore.model.Product;
import com.google.gson.Gson;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.util.List;

@WebServlet("/search")
public class SearchServlet extends HttpServlet {

    ProductDAO productDAO = DAOFactory.getInstance().getProductDAO();
    CategoryDAO categoryDAO = DAOFactory.getInstance().getCategoryDAO();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {

        String keyword = req.getParameter("keyword");

        resp.setContentType("application/json; charset=UTF-8");

        if (keyword == null && !keyword.trim().isEmpty()) {
            resp.getWriter().println("[]");
            return;
        }

        List<Product> products = productDAO.searchByName(keyword.trim());

        if (products.size() > 10) {
            products = products.subList(0, 10);
        }

        String json = new Gson().toJson(products);
        resp.getWriter().println(json);


    }
}
