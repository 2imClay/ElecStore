package com.elecstore.controller;

import com.elecstore.dao.RSAKeyDAOImpl;
import com.elecstore.model.RSAKey;
import com.elecstore.model.User;

import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import java.io.IOException;

@WebServlet("/save-rsa-key")
public class SaveRSAKeyServlet
        extends HttpServlet {

    @Override
    protected void doPost(
            HttpServletRequest request,
            HttpServletResponse response)
            throws IOException {

        try {

            User user =
                    (User) request
                            .getSession()
                            .getAttribute("user");

            String publicKey =
                    request.getParameter(
                            "publicKey");

            int keySize =
                    Integer.parseInt(
                            request.getParameter(
                                    "keySize"));

            RSAKey rsaKey =
                    new RSAKey();

            rsaKey.setUserId(
                    user.getId());

            rsaKey.setKeySize(
                    keySize);

            rsaKey.setPublicKey(
                    publicKey);

            RSAKeyDAOImpl dao =
                    new RSAKeyDAOImpl();

            boolean success =
                    dao.save(rsaKey);

            response.setContentType(
                    "application/json");

            response.getWriter().write(
                    "{\"success\":"
                            + success
                            + "}");

        } catch (Exception e) {

            response.getWriter().write(
                    "{\"success\":false}");
        }
    }
}