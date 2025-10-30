package com.db;

import java.io.InputStream;
import java.sql.Connection;
import java.sql.DriverManager;
import java.util.Properties;
import java.sql.SQLException;

public class DBConnect {
    // The connection instance is made private and static to be a singleton
    private static Connection conn = null;
    
    // Key names for the properties file for clarity
    private static final String DB_DRIVER = "com.mysql.cj.jdbc.Driver";
    private static final String PROPERTIES_FILE = "database.properties";

    /**
     * Attempts to establish a database connection. If connection fails, 
     * it prints the stack trace and returns null.
     * * @return A java.sql.Connection object, or null if connection fails.
     */
    public static Connection getConn() {
        // 1. Check if an active connection already exists
        try {
            if (conn != null && !conn.isClosed()) {
                // Connection is valid and open, return existing instance
                return conn; 
            }
        } catch (SQLException e) {
            System.err.println("Error checking existing connection status. Re-attempting connection...");
            e.printStackTrace();
            conn = null; // Ensure conn is null before re-attempt
        }

        // 2. Load properties and establish new connection
        try {
            // Load the JDBC Driver class
            Class.forName(DB_DRIVER);
            System.out.println("JDBC Driver Loaded Successfully.");
            
            Properties props = new Properties();
            
            // Use try-with-resources to ensure InputStream is closed
            try (InputStream input = DBConnect.class.getClassLoader()
                    .getResourceAsStream(PROPERTIES_FILE)) {
                
                if (input == null) {
                    // Critical failure: Configuration file is missing.
                    throw new RuntimeException("FATAL ERROR: '" + PROPERTIES_FILE + 
                                               "' file not found in classpath (src/main/resources).");
                }
                props.load(input);
            }
            
            String url = props.getProperty("db.url");
            String username = props.getProperty("db.username");
            String password = props.getProperty("db.password");
            
            if (url == null || username == null || password == null) {
                throw new RuntimeException("FATAL ERROR: Missing db.url, db.username, or db.password in " + PROPERTIES_FILE);
            }

            // Establish the connection
            conn = DriverManager.getConnection(url, username, password);
            System.out.println("Database Connection Successful!");
            
        } catch (Exception e) {
            // This catch block will catch ClassNotFoundException, RuntimeException (from missing file/props), and SQLException.
            System.err.println("--- FATAL: Database Connection Failed ---");
            System.err.println("Please check: 1) database.properties file. 2) Database server status. 3) Credentials/URL.");
            e.printStackTrace();
            conn = null; // Explicitly set to null on failure
        }
        
        return conn;
    }

    /**
     * Closes the connection object if it is not null.
     */
    public static void closeConn() {
        if (conn != null) {
            try {
                conn.close();
                conn = null; // Set to null after closing
                System.out.println("Database Connection Closed.");
            } catch (SQLException e) {
                e.printStackTrace();
            }
        }
    }
}