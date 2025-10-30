package com.db;

import java.io.InputStream;
import java.sql.Connection;
import java.sql.DriverManager;
import java.util.Properties;
import java.sql.SQLException;

public class DBConnect {
    private static Connection conn = null;

    public static Connection getConn() {
        try {
            if (conn != null && !conn.isClosed()) {
                return conn; 
            }
        } catch (SQLException e) {
            System.err.println("Error checking existing connection status.");
            e.printStackTrace();
            conn = null; 
        }

        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            Properties props = new Properties();
            try (InputStream input = DBConnect.class.getClassLoader()
                    .getResourceAsStream("database.properties")) {
                
                if (input == null) {
                    throw new RuntimeException("FATAL: database.properties file not found in classpath!");
                }
                props.load(input);
            }
            
            String url = props.getProperty("db.url");
            String username = props.getProperty("db.username");
            String password = props.getProperty("db.password");

            conn = DriverManager.getConnection(url, username, password);
            
        } catch (Exception e) {
            System.err.println("Database connection failed in DBConnect.getConn():");
            e.printStackTrace();
            conn = null; 
        }
        
        return conn;
    }

    public static void closeConn() {
        if (conn != null) {
            try {
                conn.close();
            } catch (SQLException e) {
                e.printStackTrace();
            }
        }
    }
}