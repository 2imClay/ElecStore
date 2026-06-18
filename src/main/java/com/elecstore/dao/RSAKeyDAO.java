package com.elecstore.dao;

import com.elecstore.model.RSAKey;

public interface RSAKeyDAO {
    boolean save(RSAKey key);

    int saveAndReturnId(RSAKey key);

    boolean hasKey(int userId);

    boolean hasActiveKey(int userId);

    RSAKey getLatestKeyByUserId(int userId);

    RSAKey getActiveKeyByUserId(int userId);

    RSAKey getById(int keyId);

    int replaceLostKey(int userId, int oldKeyId, RSAKey newKey, String reason);
}