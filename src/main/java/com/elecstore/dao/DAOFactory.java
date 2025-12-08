package com.elecstore.dao;

public class DAOFactory {

    private static DAOFactory instance = new DAOFactory();

    private DAOFactory() {
    }

    public static DAOFactory getInstance() {
        return instance;
    }

    public ProductDAO getProductDAO() {
        return new ProductDAOImpl();
    }

    public CategoryDAO getCategoryDAO() {
        return new CategoryDAOImpl();
    }

}
