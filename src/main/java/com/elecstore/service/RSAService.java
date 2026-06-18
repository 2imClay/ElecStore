package com.elecstore.service;

import com.elecstore.dao.RSAKeyDAOImpl;
import com.elecstore.model.RSAKey;
import com.elecstore.model.RSAKeyResponse;

import java.security.KeyPair;
import java.security.KeyPairGenerator;
import java.util.Base64;

public class RSAService {

    private final RSAKeyDAOImpl rsaDAO =
            new RSAKeyDAOImpl();

    public RSAKeyResponse generateKey(
            int userId,
            int keySize)
            throws Exception {

        KeyPairGenerator generator = KeyPairGenerator.getInstance("RSA");
        generator.initialize(keySize);
        KeyPair pair = generator.generateKeyPair();
        String publicKey = Base64.getEncoder().encodeToString(pair.getPublic().getEncoded());

        String privateKey = Base64.getEncoder().encodeToString(pair.getPrivate().getEncoded());

        RSAKeyResponse response = new RSAKeyResponse();

        response.setPublicKey(publicKey);
        response.setPrivateKey(privateKey);

        return response;
    }
    public boolean hasKey(int userId) {

        return rsaDAO.hasKey(userId);
    }

    public RSAKey getLatestKey(int userId) {

        return rsaDAO.getLatestKeyByUserId(userId);
    }
}