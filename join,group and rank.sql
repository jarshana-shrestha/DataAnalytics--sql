CREATE DATABASE company;
USE company;


#### Create tables

CREATE TABLE employee(
employee_id INT PRIMARY KEY AUTO_INCREMENT,
name VARCHAR (50),
position VARCHAR (50),
salary INT,
hire_date DATE
);


CREATE TABLE departments (
    dept_id INT PRIMARY KEY AUTO_INCREMENT,
    dept_name VARCHAR(50) NOT NULL
);

## iNSERT VALUES
INSERT INTO employee (name, position, salary, hire_date) VALUES
('Alice', 'Engineer', 80000, '2022-05-10'),
('Bob', 'Manager', 95000, '2021-06-20'),
('Charlie', 'Analyst', 70000, '2023-02-15'),
('David', 'Engineer', 85000, '2020-08-30'),
('Emma', 'HR', 60000, '2021-11-05');

INSERT INTO departments (dept_name) VALUES
('Engineering'),
('Accounting'),
('HR'),
('Finance'),
('Marketing');



### Retreive DATA (select) # * selects all 
SELECT * FROM employee;

# employees earning more than 75,000
SELECT * FROM employee WHERE salary > 75000;

# Updating Data
UPDATE employee SET salary = 100000 WHERE name = 'Alice';

##### Temporarily Disable Safe Update Mode
SET SQL_SAFE_UPDATES = 0;

#Delete Data
DELETE FROM employee WHERE name = 'Bob';

#Adding a dept_id column in employee and making a relationship
ALTER TABLE employee ADD COLUMN dept_id INT;

# Assigning employees in department
UPDATE employee SET dept_id = 4 WHERE position = 'Engineer';
UPDATE employee SET dept_id = 1 WHERE position = 'Engineer';
UPDATE employee SET dept_id = 3 WHERE position = 'HR';
UPDATE employee SET dept_id = 2 WHERE position = 'Analyst';
UPDATE employee SET dept_id = 5 WHERE position = 'Manager';


SELECT * FROM departments;

### combine employee and departmnets table
SELECT e.name, e.position, e.salary, d.dept_name
FROM employee e
JOIN departments d ON e.dept_id = d.dept_id;

## Average Salary Per Department
SELECT d.dept_name, AVG(e.salary) AS avg_salary
FROM employee e
JOIN departments d ON e.dept_id = d.dept_id
GROUP BY d.dept_name;

## Rank Employees by Salary
SELECT name, position, salary
FROM employee
ORDER BY salary DESC;


