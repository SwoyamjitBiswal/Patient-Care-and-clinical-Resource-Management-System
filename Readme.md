# Patient Care and Clinical Resource Management System

A **Java-based Web Application** built using **JSP, Servlets, and MySQL** to streamline patient care, doctor appointments, and admin management.  
This system efficiently handles **patients, doctors, and appointments** with **role-based dashboards, secure authentication, and data visualization** (charts/tables).


## ✨ Features

✅ **Role-based Access Control** – Separate dashboards for Patients, Doctors, and Admins  
✅ **Secure Authentication** – Session + Cookie-based “Remember Me” Login  
✅ **Dynamic Dashboard Visuals** – Charts and tables for easy data visualization  
✅ **Responsive Design** – Mobile-friendly JSP layouts  
✅ **Modular Architecture** – DAO, Entity, Servlet, and Filter layers  
✅ **MySQL Integration** – Persistent data management using JDBC  

---

## 🧩 1️⃣ Patient Module

### 🧍‍♀️ Basic Account Management
- **Registration:** Full name, email, password, phone, address, gender, blood group, DOB, emergency contact, medical history  
- **Validation:** Email format + uniqueness check  
- **Remember Me:** Cookie-based auto-login  
- **Login & Logout:** Session-based authentication + cookie auto-login  
- **Profile Management:** View and update personal details  
- **Change Password:** Verify old password before update  

### 📅 Appointment Management
- **Book Appointment:**  
  - Select doctor by department/specialization  
  - Choose date/time and appointment type (In-person / Online)  
  - Add reason/notes; default status = Pending  
- **View Appointments:**  
  - Separate sections for Upcoming and Past appointments  
  - Status indicators: Pending / Confirmed / Completed / Cancelled  
  - Priority color badges  
- **Edit or Cancel Appointment:** Modify before confirmation or cancel with confirmation modal  
- **Filter/Search:** By date, doctor, or status  

---

## 👨‍⚕️ 2️⃣ Doctor Module

### 👨‍⚕️ Doctor Account
- **Registration + Login/Logout:** Cookie & session-based  
- **Profile Management:** Update specialization, qualification, department, visiting charge, availability  
- **Change Password:** Old password verification  

### 🩺 Appointment Dashboard
- **View Appointments:** Filter by status (Pending / Completed / Cancelled / Upcoming)  
- **Manage Appointment:**  
  - Confirm, Complete, or Cancel appointments  
  - Add prescription & follow-up notes  
- **Search Patients:** By name or ID  
- **Dashboard Stats:** Total, Completed, Pending, and Upcoming Appointments + Charts  

---

## 🧍‍♂️ 3️⃣ Admin Module

### 🔐 Admin Account
- **Login** (Multi-admin supported)  
- **Change Password + Logout**

### 🗂️ Management Panel
- **Manage Doctors:** Add, Edit, Delete, View doctor details  and Approve Doctors
- **Manage Patients:** View/Edit/Delete patient profiles  
- **Manage Appointments:** View all appointments, update or delete any  
- **Admin Dashboard:** View all data with graphical charts and summary tables  

| Category          | Technology                             |
| ----------------- | -------------------------------------- |
| **Frontend**      | JSP, HTML5, CSS3, JavaScript           |
| **Backend**       | Java Servlets (JEE)                    |
| **Database**      | MySQL                                  |
| **Build Tool**    | Maven                                  |
| **Security**      | BCrypt password hashing                |
| **Server**        | Apache Tomcat                          |
| **Visualization** | Chart.js / DataTables (for dashboards) |


## ⚙️ Setup & Installation

### 1️⃣ Prerequisites
Make sure you have the following installed:

- **JDK 17+**
- **Apache Tomcat 9+**
- **MySQL 8.0+**
- **Maven**

### 2️⃣ Steps to Run

## Clone the repository
git clone https://github.com/your-username/Patient-Care-and-Clinical-Resource-Management-System.git

## Navigate into the project directory
cd Patient-Care-and-Clinical-Resource-Management-System

Configure database in src/main/resources/database.properties
- **Example:** <br>
db.url=jdbc:mysql://localhost:3306/patient_care <br>
db.user=root<br>
db.password=your_password<br>

## Build and deploy the WAR file
mvn clean install

## Deploy on Apache Tomcat and run the app at:
http://localhost:8080/Patient-Care-and-Clinical-Resource-Management-System/


🤝 Contributing

Pull requests are welcome!
If you’d like to contribute:

- **Fork the repository**

- **Create a new branch (feature/your-feature)**

- **Commit your changes**

- **Submit a Pull Request 🎉**


Developed with ❤️  by Jagan Parida, Sameer Jena, Swoyamjit Biswal, Biswajit Rout, Arpit Khatua

