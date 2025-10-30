package com.entity;

import java.sql.Timestamp;

public class Doctor {
    private int id;
    private String fullName;
    private String email;
    private String password;
    private String phone;
    private String specialization;
    private String department;
    private String qualification;
    private int experience;
    private double visitingCharge;
    private boolean availability;
    private Timestamp createdAt;

    public Doctor() {}
    
    public Doctor(String fullName, String email, String password, String phone, 
                  String specialization, String department, String qualification, 
                  int experience, double visitingCharge) {
        this.fullName = fullName;
        this.email = email;
        this.password = password;
        this.phone = phone;
        this.specialization = specialization;
        this.department = department;
        this.qualification = qualification;
        this.experience = experience;
        this.visitingCharge = visitingCharge;
        this.availability = true;
    }
    
    public int getId() {
        return id;
    }
    
    public void setId(int id) {
        this.id = id;
    }
    
    public String getFullName() {
        return fullName;
    }
    
    public void setFullName(String fullName) {
        this.fullName = fullName;
    }
    
    public String getEmail() {
        return email;
    }
    
    public void setEmail(String email) {
        this.email = email;
    }
    
    public String getPassword() {
        return password;
    }
    
    public void setPassword(String password) {
        this.password = password;
    }
    
    public String getPhone() {
        return phone;
    }
    
    public void setPhone(String phone) {
        this.phone = phone;
    }
    
    public String getSpecialization() {
        return specialization;
    }
    
    public void setSpecialization(String specialization) {
        this.specialization = specialization;
    }
    
    public String getDepartment() {
        return department;
    }
    
    public void setDepartment(String department) {
        this.department = department;
    }
    
    public String getQualification() {
        return qualification;
    }
    
    public void setQualification(String qualification) {
        this.qualification = qualification;
    }
    
    public int getExperience() {
        return experience;
    }
    
    public void setExperience(int experience) {
        this.experience = experience;
    }
    
    public double getVisitingCharge() {
        return visitingCharge;
    }
    
    public void setVisitingCharge(double visitingCharge) {
        this.visitingCharge = visitingCharge;
    }
    
    public boolean isAvailability() {
        return availability;
    }
    
    public void setAvailability(boolean availability) {
        this.availability = availability;
    }
    
    public Timestamp getCreatedAt() {
        return createdAt;
    }
    
    public void setCreatedAt(Timestamp createdAt) {
        this.createdAt = createdAt;
    }
}