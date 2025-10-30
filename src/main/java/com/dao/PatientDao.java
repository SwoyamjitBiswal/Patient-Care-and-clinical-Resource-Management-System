package com.dao;

import com.db.DBConnect;
import com.entity.Patient;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class PatientDao {
    
    public boolean registerPatient(Patient patient) {
        boolean success = false;
        try (Connection conn = DBConnect.getConn();
             PreparedStatement ps = conn.prepareStatement(
                 "INSERT INTO patients(full_name, email, password, phone, address, gender, blood_group, date_of_birth, emergency_contact, medical_history) VALUES(?,?,?,?,?,?,?,?,?,?)")) {
            
            ps.setString(1, patient.getFullName());
            ps.setString(2, patient.getEmail());
            ps.setString(3, patient.getPassword());
            ps.setString(4, patient.getPhone());
            ps.setString(5, patient.getAddress());
            ps.setString(6, patient.getGender());
            ps.setString(7, patient.getBloodGroup());
            ps.setDate(8, patient.getDateOfBirth());
            ps.setString(9, patient.getEmergencyContact());
            ps.setString(10, patient.getMedicalHistory());
            success = ps.executeUpdate() > 0;
            
        } catch (Exception e) {
            e.printStackTrace();
        }
        return success;
    }

    public Patient login(String email, String password) {
        Patient patient = null;
        try (Connection conn = DBConnect.getConn();
             PreparedStatement ps = conn.prepareStatement(
                 "SELECT * FROM patients WHERE email = ? AND password = ?")) {
            
            ps.setString(1, email);
            ps.setString(2, password);
            
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    patient = new Patient();
                    mapPatientFromResultSet(patient, rs);
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return patient;
    }

    public Patient getPatientById(int id) {
        Patient patient = null;
        try (Connection conn = DBConnect.getConn();
             PreparedStatement ps = conn.prepareStatement(
                 "SELECT * FROM patients WHERE id = ?")) {
            
            ps.setInt(1, id);
            
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    patient = new Patient();
                    mapPatientFromResultSet(patient, rs);
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return patient;
    }

    public boolean updatePatient(Patient patient) {
        boolean success = false;
        try (Connection conn = DBConnect.getConn();
             PreparedStatement ps = conn.prepareStatement(
                 "UPDATE patients SET full_name=?, phone=?, address=?, gender=?, blood_group=?, date_of_birth=?, emergency_contact=?, medical_history=? WHERE id=?")) {
            
            ps.setString(1, patient.getFullName());
            ps.setString(2, patient.getPhone());
            ps.setString(3, patient.getAddress());
            ps.setString(4, patient.getGender());
            ps.setString(5, patient.getBloodGroup());
            ps.setDate(6, patient.getDateOfBirth());
            ps.setString(7, patient.getEmergencyContact());
            ps.setString(8, patient.getMedicalHistory());
            ps.setInt(9, patient.getId());
            success = ps.executeUpdate() > 0;
            
        } catch (Exception e) {
            e.printStackTrace();
        }
        return success;
    }

    public boolean changePassword(int patientId, String newPassword) {
        boolean success = false;
        try (Connection conn = DBConnect.getConn();
             PreparedStatement ps = conn.prepareStatement(
                 "UPDATE patients SET password=? WHERE id=?")) {
            
            ps.setString(1, newPassword);
            ps.setInt(2, patientId);
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
                 "SELECT id FROM patients WHERE email = ?")) {
            
            ps.setString(1, email);
            try (ResultSet rs = ps.executeQuery()) {
                exists = rs.next();
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return exists;
    }

    public List<Patient> getAllPatients() {
        List<Patient> patients = new ArrayList<>();
        try (Connection conn = DBConnect.getConn();
             PreparedStatement ps = conn.prepareStatement(
                 "SELECT * FROM patients ORDER BY created_at DESC");
             ResultSet rs = ps.executeQuery()) {
            
            while (rs.next()) {
                Patient patient = new Patient();
                mapPatientFromResultSet(patient, rs);
                patients.add(patient);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return patients;
    }
    
    public boolean deletePatient(int id) {
        boolean success = false;
        try (Connection conn = DBConnect.getConn();
             PreparedStatement ps = conn.prepareStatement(
                 "DELETE FROM patients WHERE id = ?")) {
            
            ps.setInt(1, id);
            success = ps.executeUpdate() > 0;
            
        } catch (Exception e) {
            e.printStackTrace();
        }
        return success;
    }
    
    public int getTotalPatients() {
        int count = 0;
        try (Connection conn = DBConnect.getConn();
             PreparedStatement ps = conn.prepareStatement(
                 "SELECT COUNT(*) FROM patients");
             ResultSet rs = ps.executeQuery()) {
            
            if (rs.next()) {
                count = rs.getInt(1);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return count;
    }
    
    // Helper method to map ResultSet to Patient object
    private void mapPatientFromResultSet(Patient patient, ResultSet rs) throws SQLException {
        patient.setId(rs.getInt("id"));
        patient.setFullName(rs.getString("full_name"));
        patient.setEmail(rs.getString("email"));
        patient.setPassword(rs.getString("password"));
        patient.setPhone(rs.getString("phone"));
        patient.setAddress(rs.getString("address"));
        patient.setGender(rs.getString("gender"));
        patient.setBloodGroup(rs.getString("blood_group"));
        patient.setDateOfBirth(rs.getDate("date_of_birth"));
        patient.setEmergencyContact(rs.getString("emergency_contact"));
        patient.setMedicalHistory(rs.getString("medical_history"));
        patient.setCreatedAt(rs.getTimestamp("created_at"));
    }
}