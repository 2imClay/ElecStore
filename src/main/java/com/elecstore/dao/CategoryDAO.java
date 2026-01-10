package com.elecstore.dao;

import com.elecstore.model.Category;

import java.util.List;

public interface CategoryDAO {
    Category findById(int id);
    List<Category> findAll();
    void insert(Category c);
    void update(Category c);
    void delete(int id);
    public void updateStatus(int id, String status);
}
