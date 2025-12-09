package com.elecstore.controller;

import com.elecstore.dao.DAOFactory;
import com.elecstore.dao.ProductDAO;
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

        List<Product> products = productDAO.findAll();

        req.setAttribute("products",products);

        req.getRequestDispatcher("/WEB-INF/views/store.jsp").forward(req,resp);
    }
}
