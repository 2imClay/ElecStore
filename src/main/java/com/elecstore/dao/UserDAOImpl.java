package com.elecstore.dao;

import com.elecstore.model.User;

import java.sql.SQLException;
import java.util.List;

public class UserDAOImpl implements UserDAO {
    @Override
    public boolean save(User user) throws SQLException {
        return false;
    }

    @Override
    public User getById(int id) throws SQLException {
        return null;
    }

    @Override
    public User findByEmail(String email) throws SQLException {
        return null;
    }

    @Override
    public boolean update(User user) throws SQLException {
        return false;
    }

    @Override
    public boolean delete(int id) throws SQLException {
        return false;
    }

    @Override
    public List<User> getAll() throws SQLException {
        return List.of();
    }

    @Override
    public boolean isEmailExists(String email) throws SQLException {
        return false;
    }
}
