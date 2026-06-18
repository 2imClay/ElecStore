package com.elecstore.service;

import com.elecstore.dao.RSAKeyDAOImpl;
import com.elecstore.model.RSAKey;
import com.elecstore.model.RSAKeyResponse;

import java.security.KeyPair;
import java.security.KeyPairGenerator;
import java.util.Base64;

public class RSAService {

    private final RSAKeyDAOImpl rsaDAO = new RSAKeyDAOImpl();

    public RSAKeyResponse generateKey(int userId, int keySize) throws Exception {
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

    public boolean hasActiveKey(int userId) {
        return rsaDAO.hasActiveKey(userId);
    }

    public RSAKey getLatestKey(int userId) {
        return rsaDAO.getLatestKeyByUserId(userId);
    }

    public RSAKey getActiveKey(int userId) {
        return rsaDAO.getActiveKeyByUserId(userId);
    }

    public RSAKey getById(int keyId) {
        return rsaDAO.getById(keyId);
    }

    public int replaceLostKey(int userId, int oldKeyId, RSAKey newKey, String reason) {
        return rsaDAO.replaceLostKey(userId, oldKeyId, newKey, reason);
    }
}