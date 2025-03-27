CREATE TABLE Fact_Patient_Care (
    Fact_ID INT PRIMARY KEY AUTO_INCREMENT,
    Patient_ID INT,
    Provider_ID INT,
    Diagnosis_ID INT,
    Date_ID INT,
    Total_Cost DECIMAL(10, 2),
    Outcome VARCHAR(50),
    Length_of_Stay INT,
    FOREIGN KEY (Patient_ID) REFERENCES Dim_Patient(Patient_ID),
    FOREIGN KEY (Provider_ID) REFERENCES Dim_Provider(Provider_ID),
    FOREIGN KEY (Diagnosis_ID) REFERENCES Dim_Diagnosis(Diagnosis_ID),
    FOREIGN KEY (Date_ID) REFERENCES Dim_Date(Date_ID)
);

CREATE TABLE Dim_Patient (
    Patient_ID INT PRIMARY KEY AUTO_INCREMENT,
    First_Name VARCHAR(100),
    Last_Name VARCHAR(100),
    DOB DATE,
    Gender VARCHAR(10),
    Address VARCHAR(255),
    Phone VARCHAR(20),
    Admission_Date DATE,
    Discharge_Date DATE
);

CREATE TABLE Dim_Provider (
    Provider_ID INT PRIMARY KEY AUTO_INCREMENT,
    Provider_Name VARCHAR(200),
    Specialty VARCHAR(100)
);

CREATE TABLE Dim_Diagnosis (
    Diagnosis_ID INT PRIMARY KEY AUTO_INCREMENT,
    Diagnosis_Code VARCHAR(20),
    Diagnosis_Description VARCHAR(255)
);

CREATE TABLE Dim_Date (
    Date_ID INT PRIMARY KEY AUTO_INCREMENT,
    Day INT,
    Month INT,
    Year INT
);
