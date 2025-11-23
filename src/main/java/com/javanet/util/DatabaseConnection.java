package com.javanet.util;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;

public class DatabaseConnection {
    private static final String URL = "jdbc:mysql://localhost:3306/javanet_shop?useUnicode=true&characterEncoding=UTF-8&useSSL=false&serverTimezone=Asia/Shanghai&allowPublicKeyRetrieval=true";
    private static final String USERNAME = "javanet_user";
    private static final String PASSWORD = "JavaNet123!";
    
    public static Connection getConnection() throws SQLException {
        try {
            System.out.println("DEBUG: Loading MySQL driver...");
            Class.forName("com.mysql.cj.jdbc.Driver");
            
            System.out.println("DEBUG: Attempting to connect to database...");
            System.out.println("DEBUG: URL=" + URL);
            System.out.println("DEBUG: USERNAME=" + USERNAME);
            
            Connection conn = DriverManager.getConnection(URL, USERNAME, PASSWORD);
            System.out.println("DEBUG: Database connection established successfully!");
            
            return conn;
        } catch (ClassNotFoundException e) {
            System.err.println("ERROR: MySQL Driver not found: " + e.getMessage());
            throw new SQLException("MySQL Driver not found", e);
        } catch (SQLException e) {
            System.err.println("ERROR: Database connection failed: " + e.getMessage());
            System.err.println("ERROR: SQL State: " + e.getSQLState());
            System.err.println("ERROR: Error Code: " + e.getErrorCode());
            throw e;
        }
    }
}