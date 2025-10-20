package com.dao;

import java.sql.*;
import com.entity.Appointment;

public class AppointmentDAO {
    private Connection con;

    public AppointmentDAO(Connection con) {
        this.con = con;
    }

    public boolean bookAppointment(Appointment appt) {
        boolean success = false;
        String sql = "INSERT INTO appointment(patient_id, doctor_id, appointment_date, description, gov_id_type, gov_id_number, insurance_provider, insurance_number, status) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?)";
        try {
            PreparedStatement ps = con.prepareStatement(sql);
            ps.setInt(1, appt.getPatientId());
            ps.setInt(2, appt.getDoctorId());
            ps.setString(3, appt.getAppointmentDate());
            ps.setString(4, appt.getDescription());
            ps.setString(5, appt.getGovIdType());
            ps.setString(6, appt.getGovIdNumber());
            ps.setString(7, appt.getInsuranceProvider());
            ps.setString(8, appt.getInsuranceNumber());
            ps.setString(9, appt.getStatus());
            success = (ps.executeUpdate() == 1);
        } catch (Exception e) {
            e.printStackTrace();
        }
        return success;
    }
}
