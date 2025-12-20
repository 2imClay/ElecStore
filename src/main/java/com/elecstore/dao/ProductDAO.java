package com.elecstore.dao;

import com.elecstore.model.Product;

import java.util.List;

public interface ProductDAO {
    Product findById(int id);
    List<Product> findAll();
    List<Product> findByCategoryId(int categoryId);
    List<Product> searchByName(String keyword);
    void insert(Product p);
    void update(Product p);
    void delete(int id);
}
