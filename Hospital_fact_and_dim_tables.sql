#### Creating Star Schema

/*
it consists of a central fact table (Fact_Patient_Care) that stores measurable healthcare-related events, 
such as total cost, outcome, and length of stay. Surrounding this fact table are multiple 
dimension tables—including Dim_Patient, Dim_Provider, Dim_Diagnosis, and Dim_Date—which provide 
descriptive details and context for the facts.
*/

CREATE DATABASE Hospitals;
USE Hospitals;

#### Creating Fact Table
CREATE TABLE Fact_Patient_Care (
    Fact_ID INT PRIMARY KEY AUTO_INCREMENT,
    Patient_ID INT,
    Provider_ID INT,
    Diagnosis_ID INT,
    Procedure_ID INT,
    Hospital_ID INT,
    Date_ID INT,
    Total_Cost DECIMAL(10,2),
    Outcome VARCHAR(50),
    Length_of_Stay INT
);

#### Create Dimension Tables
CREATE TABLE Dim_Patient (
    Patient_ID INT PRIMARY KEY AUTO_INCREMENT,
    First_Name VARCHAR(100),
    Last_Name VARCHAR(100),
    DOB DATE,
    Gender VARCHAR(10),
    Phone VARCHAR(20),
    Admission_Date DATE,
    Discharge_Date DATE
);

# For provider
CREATE TABLE Dim_Provider (
    Provider_ID INT PRIMARY KEY AUTO_INCREMENT,
    Provider_Name VARCHAR(200),
    Specialty VARCHAR(100)
);

# For Diagnosis
CREATE TABLE Dim_Diagnosis (
    Diagnosis_ID INT PRIMARY KEY AUTO_INCREMENT,
    Diagnosis_Code VARCHAR(20),
    Diagnosis_Description VARCHAR(255)
);

# For procedure
CREATE TABLE Dim_Procedure (
    Procedure_ID INT PRIMARY KEY AUTO_INCREMENT,
    Procedure_Name VARCHAR(200),
    Procedure_Code VARCHAR(20),
    Cost DECIMAL(10,2)
);

# For location
CREATE TABLE Dim_Location (
    Location_ID INT PRIMARY KEY AUTO_INCREMENT,
    City VARCHAR(100),
    State VARCHAR(50),
    Country VARCHAR(50),
    Zip_Code VARCHAR(10)
);

# For hospital Details
CREATE TABLE Dim_Hospital (
    Hospital_ID INT PRIMARY KEY AUTO_INCREMENT,
    Hospital_Name VARCHAR(200),
    Location_ID INT,
    FOREIGN KEY (Location_ID) REFERENCES Dim_Location(Location_ID)
);

# For storing Date
CREATE TABLE Dim_Date (
    Date_ID INT PRIMARY KEY AUTO_INCREMENT,
    Day INT,
    Month INT,
    Year INT
);

# Adding Foreign Key in Fact table using Alter Syntax
ALTER TABLE Fact_Patient_Care 
ADD CONSTRAINT fk_patient FOREIGN KEY (Patient_ID) REFERENCES Dim_Patient(Patient_ID),
ADD CONSTRAINT fk_provider FOREIGN KEY (Provider_ID) REFERENCES Dim_Provider(Provider_ID),
ADD CONSTRAINT fk_diagnosis FOREIGN KEY (Diagnosis_ID) REFERENCES Dim_Diagnosis(Diagnosis_ID),
ADD CONSTRAINT fk_procedure FOREIGN KEY (Procedure_ID) REFERENCES Dim_Procedure(Procedure_ID),
ADD CONSTRAINT fk_hospital FOREIGN KEY (Hospital_ID) REFERENCES Dim_Hospital(Hospital_ID),
ADD CONSTRAINT fk_date FOREIGN KEY (Date_ID) REFERENCES Dim_Date(Date_ID);

---------------------

# Insert Data Values in all tables

# Patients
INSERT INTO Dim_Patient (First_Name, Last_Name, DOB, Gender, Phone, Admission_Date, Discharge_Date)
VALUES 
('Jarshana', 'S', '2000-05-15', 'Female', '1234567890', '2024-07-01', '2024-07-05'),
('Kabin', 'Shrestha', '2015-08-22', 'Male', '9876543210',  '2024-08-10', '2024-08-14'),
('Bimisha', 'B', '2010-10-25', 'Female', '8765432100', '2025-01-10', '2025-01-10'),
('Jabila', 'Sakha', '1980-04-10', 'Female', '9876543456', '2025-03-15', '2025-03-20')
;

INSERT INTO Dim_Provider (Provider_Name, Specialty)
VALUES 
('Dr. Alice Brown', 'Cardiology'),
('Dr. Mark Green', 'Neurology'),
('Dr. Cathrine G', 'ER'),
('Dr. Devin Dyson', 'Physio')
;

INSERT INTO Dim_Diagnosis (Diagnosis_Code, Diagnosis_Description)
VALUES 
('I10', 'Hypertension'),
('E11', 'Type 2 Diabetes Mellitus'),
('E10', 'Thyroid'),
('E12', 'TB')
;

INSERT INTO Dim_Procedure (Procedure_Name, Procedure_Code, Cost)
VALUES 
('MRI Scan', 'MRI001', 1500.00),
('Blood Test', 'BT002', 100.00),
('CT scan', 'CT003', 200.00),
('ECG', 'ECG01', 500.00);

INSERT INTO Dim_Location (City, State, Country, Zip_Code) 
VALUES 
('Boston', 'MA', 'USA', '02118'),
('New York', 'NY', 'USA', '10001'),
('Boston', 'MA', 'USA', '02115'),
('Boston', 'MA', 'USA', '02116')
;


INSERT INTO Dim_Hospital (Hospital_Name, Location_ID)
VALUES 
('Massachusetts General Hospital', 1),
('New York Presbyterian Hospital', 2),
('Beth Israel', 3),
('Dana Faber', 4)
;

INSERT INTO Dim_Date (Day, Month, Year)
VALUES 
(1, 7, 2024),
(10, 8, 2024),
(10, 01, 2025),
(15, 03, 2025)
;

INSERT INTO Fact_Patient_Care (Patient_ID, Provider_ID, Diagnosis_ID, Procedure_ID, 
Hospital_ID, Date_ID, Total_Cost, Outcome, Length_of_Stay)
VALUES 
(1, 1, 1, 1, 1, 1, 5000.00, 'Recovered', 4),
(2, 2, 2, 2, 2, 2, 1200.00, 'Recovered', 3),
(2, 2, 2, 2, 2, 2, 8000.00, 'Stable', 0),
(4, 4, 4, 4, 4, 4, 2500.00, 'Under Treatment', 4)
;

-----------------------------
# Get patient records
SELECT * FROM Dim_Patient;

# Find patients admitted in 2025
SELECT First_Name, Last_Name, Admission_Date, Discharge_Date
FROM Dim_Patient
WHERE Admission_Date BETWEEN '2025-01-01' AND '2025-03-30';

# Count patients by gender
SELECT Gender, COUNT(*) AS Total_Patients
FROM Dim_Patient
GROUP BY Gender;

# Average Length of Stay for Each Diagnosis
SELECT d.Diagnosis_Description, AVG(f.Length_of_Stay) AS Avg_Stay
FROM Fact_Patient_Care f
JOIN Dim_Diagnosis d ON f.Diagnosis_ID = d.Diagnosis_ID
GROUP BY d.Diagnosis_Description;

# Total Cost of Treatment by Provider
SELECT p.Provider_Name, SUM(f.Total_Cost) AS Total_Cost
FROM Fact_Patient_Care f
JOIN Dim_Provider p ON f.Provider_ID = p.Provider_ID
GROUP BY p.Provider_Name;

#Number of Patients Treated Per Hospital
SELECT h.Hospital_Name, COUNT(f.Patient_ID) AS Patient_Count
FROM Fact_Patient_Care f
JOIN Dim_Hospital h ON f.Hospital_ID = h.Hospital_ID
GROUP BY h.Hospital_Name;




