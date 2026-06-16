package com.elecstore.controller;

import com.elecstore.model.RSAKey;
import com.elecstore.model.RSAKeyResponse;
import com.elecstore.model.User;
import com.elecstore.service.RSAService;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import java.io.IOException;

@WebServlet("/generate-rsa-key")
public class GenerateRSAKeyServlet extends HttpServlet {

    private final RSAService rsaService =
            new RSAService();

    @Override
    protected void doPost(
            HttpServletRequest request,
            HttpServletResponse response)
            throws ServletException, IOException {

        try {

            User user =
                    (User) request.getSession()
                            .getAttribute("user");

            int keySize =
                    Integer.parseInt(
                            request.getParameter("keySize"));

            RSAKeyResponse rsaKey =
                    rsaService.generateKey(
                            user.getId(),
                            keySize);

            response.setContentType("application/json");
            response.setCharacterEncoding("UTF-8");

            response.getWriter().write(
                    "{"
                            + "\"success\":true,"
                            + "\"publicKey\":\""
                            + rsaKey.getPublicKey()
                            + "\","
                            + "\"privateKey\":\""
                            + rsaKey.getPrivateKey()
                            + "\""
                            + "}"
            );

        } catch (Exception e) {

            response.setStatus(500);

            response.getWriter().write(
                    "{\"success\":false}"
            );
        }
    }
}