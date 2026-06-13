package com.elecstore.service;

import com.elecstore.dao.RSAKeyDAOImpl;
import com.elecstore.model.RSAKey;

import java.security.KeyPair;
import java.security.KeyPairGenerator;
import java.util.Base64;

public class RSAService {

    private final RSAKeyDAOImpl rsaDAO = new RSAKeyDAOImpl();

    public RSAKey generateKey(int userId, int keySize)
            throws Exception {

        KeyPairGenerator generator =
                KeyPairGenerator.getInstance("RSA");

        generator.initialize(keySize);

        KeyPair pair =
                generator.generateKeyPair();

        String publicKey =
                Base64.getEncoder()
                        .encodeToString(
                                pair.getPublic().getEncoded());

        String privateKey =
                Base64.getEncoder()
                        .encodeToString(
                                pair.getPrivate().getEncoded());

        RSAKey rsaKey = new RSAKey();

        rsaKey.setUserId(userId);
        rsaKey.setKeySize(keySize);
        rsaKey.setPublicKey(publicKey);
        rsaKey.setPrivateKey(privateKey);

        rsaDAO.save(rsaKey);

        return rsaKey;
    }
}