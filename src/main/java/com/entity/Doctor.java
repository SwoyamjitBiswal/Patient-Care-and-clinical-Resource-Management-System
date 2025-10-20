package com.entity;

public class Doctor {
    private int id;
    private String fullname;
    private String email;
    private String password;
    private String specialization;
    private String licenseNumber;
    private int yearsOfExperience;
    private String qualification;
    private String phone;
    private String department;
    private String clinicAddress;
    private String availability;
    private String status;
    
    // New field: Consulting fee / visiting charge
    private double visitingCharge;

    public Doctor() {}

    public Doctor(String fullname, String email, String password, String specialization, 
                  String licenseNumber, int yearsOfExperience, String qualification, 
                  String phone, String department, String clinicAddress, String availability) {
        this.fullname = fullname;
        this.email = email;
        this.password = password;
        this.specialization = specialization;
        this.licenseNumber = licenseNumber;
        this.yearsOfExperience = yearsOfExperience;
        this.qualification = qualification;
        this.phone = phone;
        this.department = department;
        this.clinicAddress = clinicAddress;
        this.availability = availability;
        this.status = "pending"; // default pending
        this.visitingCharge = 0.0; // default 0
    }

    // Getters & Setters (all fields)
    public int getId() { return id; }
    public void setId(int id) { this.id = id; }

    public String getFullName() { return fullname; }
    public void setFullName(String fullname) { this.fullname = fullname; }

    public String getEmail() { return email; }
    public void setEmail(String email) { this.email = email; }

    public String getPassword() { return password; }
    public void setPassword(String password) { this.password = password; }

    public String getSpecialization() { return specialization; }
    public void setSpecialization(String specialization) { this.specialization = specialization; }

    public String getLicenseNumber() { return licenseNumber; }
    public void setLicenseNumber(String licenseNumber) { this.licenseNumber = licenseNumber; }

    public int getYearsOfExperience() { return yearsOfExperience; }
    public void setYearsOfExperience(int yearsOfExperience) { this.yearsOfExperience = yearsOfExperience; }

    public String getQualification() { return qualification; }
    public void setQualification(String qualification) { this.qualification = qualification; }

    public String getPhone() { return phone; }
    public void setPhone(String phone) { this.phone = phone; }

    public String getDepartment() { return department; }
    public void setDepartment(String department) { this.department = department; }

    public String getClinicAddress() { return clinicAddress; }
    public void setClinicAddress(String clinicAddress) { this.clinicAddress = clinicAddress; }

    public String getAvailability() { return availability; }
    public void setAvailability(String availability) { this.availability = availability; }

    public String getStatus() { return status; }
    public void setStatus(String status) { this.status = status; }

    // Getter & Setter for visitingCharge
    public double getVisitingCharge() { return visitingCharge; }
    public void setVisitingCharge(double visitingCharge) { this.visitingCharge = visitingCharge; }
}
