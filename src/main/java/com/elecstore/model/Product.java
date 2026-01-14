package com.elecstore.model;

import com.elecstore.dao.CategoryDAO;
import com.elecstore.dao.CategoryDAOImpl;

public class Product {
    private int id;
    private String name;
    private String imageUrl;
    private String description;
    private int categoryId;
    private String brand;
    private float price;
    private int stock;
    private String status;

    public Product() {
    }

    public Product(int id, String name, String imageUrl,
                   String description, int categoryId,
                   String brand, float price,int stock, String status) {
        this.id = id;
        this.name = name;
        this.imageUrl = imageUrl;
        this.description = description;
        this.categoryId = categoryId;
        this.brand = brand;
        this.price = price;
        this.stock = stock;
        this.status = status;
    }

    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public String getImageUrl() {
        return imageUrl;
    }

    public void setImageUrl(String imageUrl) {
        this.imageUrl = imageUrl;
    }

    public String getDescription() {
        return description;
    }

    public void setDescription(String description) {
        this.description = description;
    }

    public int getCategoryId() {
        return categoryId;
    }

    public void setCategoryId(int categoryId) {
        this.categoryId = categoryId;
    }

    public String getBrand() {
        return brand;
    }

    public void setBrand(String brand) {
        this.brand = brand;
    }

    public float getPrice() {
        return price;
    }

    public void setPrice(float price) {
        this.price = price;
    }

    public int getStock() {
        return stock;
    }

    public void setStock(int stock) {
        this.stock = stock;
    }

    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status;
    }

    public String getCategoryName() {
        if (categoryId <= 0) {
            return "Unknown";
        }

        CategoryDAO categoryDAO = new CategoryDAOImpl();
        Category category = categoryDAO.findById(categoryId);

        if (category != null) {
            return category.getName();
        }
        return "Unknown";
    }
}