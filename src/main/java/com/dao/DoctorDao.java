package com.dao;

import com.db.DBConnect;
import com.entity.Doctor;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class DoctorDao {
    
    public boolean registerDoctor(Doctor doctor) {
        boolean success = false;
        try (Connection conn = DBConnect.getConn();
             PreparedStatement ps = conn.prepareStatement(
                 "INSERT INTO doctors(full_name, email, password, phone, specialization, department, qualification, experience, visiting_charge) VALUES(?,?,?,?,?,?,?,?,?)")) {
            
            ps.setString(1, doctor.getFullName());
            ps.setString(2, doctor.getEmail());
            ps.setString(3, doctor.getPassword());
            ps.setString(4, doctor.getPhone());
            ps.setString(5, doctor.getSpecialization());
            ps.setString(6, doctor.getDepartment());
            ps.setString(7, doctor.getQualification());
            ps.setInt(8, doctor.getExperience());
            ps.setDouble(9, doctor.getVisitingCharge());
            success = ps.executeUpdate() > 0;
            
        } catch (Exception e) {
            e.printStackTrace();
        }
        return success;
    }

    public Doctor login(String email, String password) {
        Doctor doctor = null;
        try (Connection conn = DBConnect.getConn();
             PreparedStatement ps = conn.prepareStatement(
                 "SELECT * FROM doctors WHERE email = ? AND password = ?")) {
            
            ps.setString(1, email);
            ps.setString(2, password);
            
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    doctor = new Doctor();
                    mapDoctorFromResultSet(doctor, rs);
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return doctor;
    }

    public Doctor getDoctorById(int id) {
        Doctor doctor = null;
        try (Connection conn = DBConnect.getConn();
             PreparedStatement ps = conn.prepareStatement(
                 "SELECT * FROM doctors WHERE id = ?")) {
            
            ps.setInt(1, id);
            
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    doctor = new Doctor();
                    mapDoctorFromResultSet(doctor, rs);
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return doctor;
    }

    public boolean updateDoctor(Doctor doctor) {
        boolean success = false;
        try (Connection conn = DBConnect.getConn();
             PreparedStatement ps = conn.prepareStatement(
                 "UPDATE doctors SET full_name=?, phone=?, specialization=?, department=?, qualification=?, experience=?, visiting_charge=?, availability=? WHERE id=?")) {
            
            ps.setString(1, doctor.getFullName());
            ps.setString(2, doctor.getPhone());
            ps.setString(3, doctor.getSpecialization());
            ps.setString(4, doctor.getDepartment());
            ps.setString(5, doctor.getQualification());
            ps.setInt(6, doctor.getExperience());
            ps.setDouble(7, doctor.getVisitingCharge());
            ps.setBoolean(8, doctor.isAvailability());
            ps.setInt(9, doctor.getId());
            success = ps.executeUpdate() > 0;
            
        } catch (Exception e) {
            e.printStackTrace();
        }
        return success;
    }

    public boolean changePassword(int doctorId, String newPassword) {
        boolean success = false;
        try (Connection conn = DBConnect.getConn();
             PreparedStatement ps = conn.prepareStatement(
                 "UPDATE doctors SET password=? WHERE id=?")) {
            
            ps.setString(1, newPassword);
            ps.setInt(2, doctorId);
            success = ps.executeUpdate() > 0;
            
        } catch (Exception e) {
            e.printStackTrace();
        }
        return success;
    }

    public List<Doctor> getAllDoctors() {
        List<Doctor> doctors = new ArrayList<>();
        try (Connection conn = DBConnect.getConn();
             PreparedStatement ps = conn.prepareStatement(
                 "SELECT * FROM doctors ORDER BY created_at DESC");
             ResultSet rs = ps.executeQuery()) {
            
            while (rs.next()) {
                Doctor doctor = new Doctor();
                mapDoctorFromResultSet(doctor, rs);
                doctors.add(doctor);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return doctors;
    }

    public List<Doctor> getAvailableDoctors() {
        List<Doctor> doctors = new ArrayList<>();
        try (Connection conn = DBConnect.getConn();
             PreparedStatement ps = conn.prepareStatement(
                 "SELECT * FROM doctors WHERE availability = true ORDER BY full_name");
             ResultSet rs = ps.executeQuery()) {
            
            while (rs.next()) {
                Doctor doctor = new Doctor();
                mapDoctorFromResultSet(doctor, rs);
                doctors.add(doctor);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return doctors;
    }

    public List<Doctor> getDoctorsBySpecialization(String specialization) {
        List<Doctor> doctors = new ArrayList<>();
        try (Connection conn = DBConnect.getConn();
             PreparedStatement ps = conn.prepareStatement(
                 "SELECT * FROM doctors WHERE specialization = ? AND availability = true")) {
            
            ps.setString(1, specialization);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Doctor doctor = new Doctor();
                    mapDoctorFromResultSet(doctor, rs);
                    doctors.add(doctor);
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return doctors;
    }
    
    public boolean deleteDoctor(int id) {
        boolean success = false;
        try (Connection conn = DBConnect.getConn();
             PreparedStatement ps = conn.prepareStatement(
                 "DELETE FROM doctors WHERE id = ?")) {
            
            ps.setInt(1, id);
            success = ps.executeUpdate() > 0;
            
        } catch (Exception e) {
            e.printStackTrace();
        }
        return success;
    }

    public boolean isEmailExists(String email) {
        boolean exists = false;
        try (Connection conn = DBConnect.getConn();
             PreparedStatement ps = conn.prepareStatement(
                 "SELECT id FROM doctors WHERE email = ?")) {
            
            ps.setString(1, email);
            try (ResultSet rs = ps.executeQuery()) {
                exists = rs.next();
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return exists;
    }
    
    public int getTotalDoctors() {
        int count = 0;
        try (Connection conn = DBConnect.getConn();
             PreparedStatement ps = conn.prepareStatement(
                 "SELECT COUNT(*) FROM doctors");
             ResultSet rs = ps.executeQuery()) {
            
            if (rs.next()) {
                count = rs.getInt(1);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return count;
    }
    
    // Helper method to map ResultSet to Doctor object
    private void mapDoctorFromResultSet(Doctor doctor, ResultSet rs) throws SQLException {
        doctor.setId(rs.getInt("id"));
        doctor.setFullName(rs.getString("full_name"));
        doctor.setEmail(rs.getString("email"));
        doctor.setPassword(rs.getString("password"));
        doctor.setPhone(rs.getString("phone"));
        doctor.setSpecialization(rs.getString("specialization"));
        doctor.setDepartment(rs.getString("department"));
        doctor.setQualification(rs.getString("qualification"));
        doctor.setExperience(rs.getInt("experience"));
        doctor.setVisitingCharge(rs.getDouble("visiting_charge"));
        doctor.setAvailability(rs.getBoolean("availability"));
        doctor.setCreatedAt(rs.getTimestamp("created_at"));
    }
}