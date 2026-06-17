package com.elecstore.controller;

import com.elecstore.model.User;
import com.elecstore.service.RSAService;

import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import java.io.IOException;

@WebServlet("/check-rsa-key")
public class CheckRSAKeyServlet
        extends HttpServlet {

    private final RSAService rsaService =
            new RSAService();

    @Override
    protected void doGet(
            HttpServletRequest request,
            HttpServletResponse response)
            throws IOException {

        try {

            User user =
                    (User) request
                            .getSession()
                            .getAttribute("user");

            boolean hasKey =
                    rsaService.hasKey(
                            user.getId());

            response.setContentType(
                    "application/json");

            response.getWriter().write(
                    "{\"hasKey\":"
                            + hasKey
                            + "}");

        } catch (Exception e) {

            response.getWriter().write(
                    "{\"hasKey\":false}");
        }
    }
}