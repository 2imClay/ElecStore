package com.elecstore.utils;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;

public class DatabaseConnection {

    private static String driverClass = "com.mysql.cj.jdbc.Driver";
    private static String url = "jdbc:mysql://localhost:3306/electronics";
    private static String username = "root";
    private static String password = "";

    static {
        try {
            Class.forName(driverClass);
        } catch (ClassNotFoundException e) {
            e.printStackTrace();
        }
    }

    public static Connection getConnection() throws SQLException {
        return DriverManager.getConnection(url, username, password);
    }

}
