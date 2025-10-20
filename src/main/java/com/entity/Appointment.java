package com.entity;

public class Appointment {
    private int id;
    private int patientId;
    private int doctorId;
    private String appointmentDate;
    private String description;
    private String govIdType;
    private String govIdNumber;
    private String insuranceProvider;
    private String insuranceNumber;
    private String status;

    public Appointment() {}

    public Appointment(int patientId, int doctorId, String appointmentDate, String description,
                       String govIdType, String govIdNumber,
                       String insuranceProvider, String insuranceNumber, String status) {
        this.patientId = patientId;
        this.doctorId = doctorId;
        this.appointmentDate = appointmentDate;
        this.description = description;
        this.govIdType = govIdType;
        this.govIdNumber = govIdNumber;
        this.insuranceProvider = insuranceProvider;
        this.insuranceNumber = insuranceNumber;
        this.status = status;
    }

    // Getters and Setters
    public int getId() { return id; }
    public void setId(int id) { this.id = id; }

    public int getPatientId() { return patientId; }
    public void setPatientId(int patientId) { this.patientId = patientId; }

    public int getDoctorId() { return doctorId; }
    public void setDoctorId(int doctorId) { this.doctorId = doctorId; }

    public String getAppointmentDate() { return appointmentDate; }
    public void setAppointmentDate(String appointmentDate) { this.appointmentDate = appointmentDate; }

    public String getDescription() { return description; }
    public void setDescription(String description) { this.description = description; }

    public String getGovIdType() { return govIdType; }
    public void setGovIdType(String govIdType) { this.govIdType = govIdType; }

    public String getGovIdNumber() { return govIdNumber; }
    public void setGovIdNumber(String govIdNumber) { this.govIdNumber = govIdNumber; }

    public String getInsuranceProvider() { return insuranceProvider; }
    public void setInsuranceProvider(String insuranceProvider) { this.insuranceProvider = insuranceProvider; }

    public String getInsuranceNumber() { return insuranceNumber; }
    public void setInsuranceNumber(String insuranceNumber) { this.insuranceNumber = insuranceNumber; }

    public String getStatus() { return status; }
    public void setStatus(String status) { this.status = status; }
}
