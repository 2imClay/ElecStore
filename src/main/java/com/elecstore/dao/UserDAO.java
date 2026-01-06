package com.elecstore.dao;

import com.elecstore.model.User;

import java.sql.SQLException;
import java.util.List;

public interface UserDAO {

    public User login(String email, String password) throws SQLException;

    boolean save(User user) throws SQLException;

    User getById(int id) throws SQLException;

    User findByEmail(String email) throws SQLException;

    boolean update(User user) throws SQLException;

    boolean delete(int id) throws SQLException;

    List<User> getAll() throws SQLException;

    boolean isEmailExists(String email) throws SQLException;

}
