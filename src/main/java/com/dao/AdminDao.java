package com.dao;

import com.db.DBConnect;
import com.entity.Admin;
import java.sql.*;

public class AdminDao {
    
    public boolean registerAdmin(Admin admin) {
        boolean success = false;
        try (Connection conn = DBConnect.getConn();
             PreparedStatement ps = conn.prepareStatement(
                 "INSERT INTO admins(full_name, email, password) VALUES(?,?,?)")) {
            
            ps.setString(1, admin.getFullName());
            ps.setString(2, admin.getEmail());
            ps.setString(3, admin.getPassword());
            success = ps.executeUpdate() > 0;
            
        } catch (Exception e) {
            e.printStackTrace();
        }
        return success;
    }

    public Admin login(String email, String password) {
        Admin admin = null;
        try (Connection conn = DBConnect.getConn();
             PreparedStatement ps = conn.prepareStatement(
                 "SELECT * FROM admins WHERE email = ? AND password = ?")) {
            
            ps.setString(1, email);
            ps.setString(2, password);
            
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    admin = new Admin();
                    admin.setId(rs.getInt("id"));
                    admin.setFullName(rs.getString("full_name"));
                    admin.setEmail(rs.getString("email"));
                    admin.setPassword(rs.getString("password"));
                    admin.setCreatedAt(rs.getTimestamp("created_at"));
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return admin;
    }

    public boolean changePassword(int adminId, String newPassword) {
        boolean success = false;
        try (Connection conn = DBConnect.getConn();
             PreparedStatement ps = conn.prepareStatement(
                 "UPDATE admins SET password=? WHERE id=?")) {
            
            ps.setString(1, newPassword);
            ps.setInt(2, adminId);
            success = ps.executeUpdate() > 0;
            
        } catch (Exception e) {
            e.printStackTrace();
        }
        return success;
    }

    // Added from your first file (and refactored)
    public Admin getAdminById(int id) {
        Admin admin = null;
        try (Connection conn = DBConnect.getConn();
             PreparedStatement ps = conn.prepareStatement("SELECT * FROM admins WHERE id = ?")) {
            
            ps.setInt(1, id);
            
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    admin = new Admin();
                    admin.setId(rs.getInt("id"));
                    admin.setFullName(rs.getString("full_name"));
                    admin.setEmail(rs.getString("email"));
                    admin.setPassword(rs.getString("password"));
                    admin.setCreatedAt(rs.getTimestamp("created_at"));
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return admin;
    }

    public boolean isEmailExists(String email) {
        boolean exists = false;
        try (Connection conn = DBConnect.getConn();
             PreparedStatement ps = conn.prepareStatement(
                 "SELECT id FROM admins WHERE email = ?")) {
            
            ps.setString(1, email);
            try (ResultSet rs = ps.executeQuery()) {
                exists = rs.next();
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return exists;
    }
}