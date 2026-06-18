package com.elecstore.dao;

import com.elecstore.model.RSAKey;

public interface RSAKeyDAO {
    boolean save(RSAKey key);
    boolean hasKey(int userId);
    RSAKey getLatestKeyByUserId(int userId);
}