/*
database for an Education Institute. The system stores information about students, courses, enrollments, instructors, and grades. You are required to create tables, insert data, and run queries ranging from basic SELECTs to advanced aggregations and window functions
Students (student_id, name, email, dob, gender)
Instructors (instructor_id, name, email, department)
Courses (course_id, course_name, instructor_id, credits)
Enrollments (enrollment_id, student_id, course_id, enroll_date)
Grades (grade_id, enrollment_id, grade)
Add relevant constraints like NOT NULL, UNIQUE, and FOREIGN KEY
*/


----------

CREATE DATABASE EducationInstitute;

use EducationInstitute;

# create student table
CREATE TABLE Students (
student_id INT PRIMARY KEY AUTO_INCREMENT, 
name VARCHAR(100), 
email VARCHAR (100) UNIQUE, 
dob DATE, 
gender VARCHAR (10)
);

# create instructor table
CREATE TABLE Instructors (
instructor_id INT PRIMARY KEY AUTO_INCREMENT, 
name VARCHAR(100), 
email VARCHAR(100) UNIQUE, 
department VARCHAR (100)
);

# create course table
CREATE TABLE Courses (
course_id INT PRIMARY KEY AUTO_INCREMENT, 
course_name VARCHAR(200), 
instructor_id INT, 
credits INT,
FOREIGN KEY (instructor_id) references Instructors (instructor_id)
);

# create enrollement table 
CREATE TABLE Enrollments (
enrollment_id INT PRIMARY KEY auto_increment,  
student_id INT, 
course_id INT, 
enroll_date DATE,
FOREIGN KEY (student_id) references Students (student_id),
FOREIGN KEY (course_id) references Courses (course_id)
);

# create grade table
CREATE TABLE Grades (
grade_id int primary key auto_increment, 
enrollment_id int, 
grade DECIMAL (3,2),
FOREIGN KEY(enrollment_id) references enrollments (enrollment_id)
);

show tables;

#### Insert Data
# Insert sample data into Students
INSERT INTO Students (name, email, dob, gender) VALUES
    ('Jarshana s', 'jarshana@gmail.com', '2000-05-12', 'Female'),
     ('Ben b', 'ben@gmail.com', '2001-03-11', 'Male'),
    ('Alex a', 'alex@gmail.com', '2003-07-21', 'Male'),
    ('Diana D', 'diana@example.com', '2001-12-01', 'Female'),
    ('Charlie C', 'charlie@gmail.com', '2004-09-09', 'Male');
    
# Insert sample data into Instructors
INSERT INTO Instructors (name, email, department) VALUES
    ('Ram', 'ram@bu.edu', 'Analyst'),
    ('Dr. J', 'j@neu.edu', 'Math'),
    ('Richa', 'richa@uni.com', 'Computer'),
    ('Emily', 'emily@bc.edu', 'Physics'),
    ('Kevin', 'kevin@bcc.com', 'Math');
    
# Insert sample data into Courses
INSERT INTO Courses (course_name, instructor_id, credits) VALUES
    ('Intro to Python', 1, 4),
    ('Algebra', 2, 3),
    ('Computer', 3, 5),
    ('Mechanics', 4, 3),
    ('Stats', 5, 4);
    
# Insert sample data into Enrollments
INSERT INTO Enrollments (student_id, course_id, enroll_date) VALUES
    (1, 1, '2025-01-10'),
    (2, 2, '2025-02-12'),
    (3, 3, '2025-01-15'),
    (4, 4, '2025-01-20'),
    (5, 5, '2025-02-05');

# Insert sample data into Grades
INSERT INTO Grades (enrollment_id, grade) VALUES
    (1, 3.5),
    (2, 4.0),
    (3, 3.8),
    (4, 2.9),
    (5, 3.2);
    
# Basic SQL Queries
# Show the names of all students.
SELECT name FROM students;

# List all students born after 2002.
SELECT name FROM students
WHERE dob > '2002-12-31';

# Display all courses taught by instructors from the "Computer" department.
SELECT c.course_name, i.name AS instructor_name
FROM Courses c
JOIN Instructors i ON c.instructor_id = i.instructor_id
WHERE i.department = 'Computer';

# Aggregations and GROUP BY
# Find the total number of students enrolled in each course.
SELECT c.course_name, COUNT(e.student_id) AS total_students
FROM Courses c
LEFT JOIN Enrollments e ON c.course_id = e.course_id
GROUP BY c.course_id, c.course_name;

# Find the average grade received per course.
SELECT c.course_name, ROUND(AVG(g.grade), 2) AS avg_grade
FROM Courses c
JOIN Enrollments e ON c.course_id = e.course_id
JOIN Grades g ON e.enrollment_id = g.enrollment_id
GROUP BY c.course_id, c.course_name;

# Show the number of male and female students.
SELECT gender, COUNT(student_id) AS total_students
FROM Students
GROUP BY gender;

# JOIN Queries
# List students with their enrolled course names.
SELECT s.name AS student_name, c.course_name
FROM Students s
JOIN Enrollments e ON s.student_id = e.student_id
JOIN Courses c ON e.course_id = c.course_id;

# Show course names along with the instructor who teaches them.
SELECT c.course_name, i.name AS instructor_name
FROM Courses c
JOIN Instructors i ON c.instructor_id = i.instructor_id;

# Display student names with the grade they received in each course.
SELECT s.name AS student_name, c.course_name, g.grade
FROM Students s
JOIN Enrollments e ON s.student_id = e.student_id
JOIN Courses c ON e.course_id = c.course_id
JOIN Grades g ON e.enrollment_id = g.enrollment_id;

# Subqueries
# Find students who are enrolled in all courses taught by a specific instructor.
SELECT s.name 
FROM Students s
WHERE NOT EXISTS (
    SELECT c.course_id 
    FROM Courses c
    WHERE c.instructor_id = 2 
    AND NOT EXISTS (
        SELECT 1 
        FROM Enrollments e 
        WHERE e.student_id = s.student_id 
        AND e.course_id = c.course_id
    )
);


# Find courses that have the highest number of students.
SELECT course_name, student_count
FROM (
    SELECT c.course_name, COUNT(e.student_id) AS student_count,
           RANK() OVER (ORDER BY COUNT(e.student_id) DESC) AS rnk
    FROM Courses c
    JOIN Enrollments e ON c.course_id = e.course_id
    GROUP BY c.course_id, c.course_name
) ranked
WHERE rnk = 1;

#List students who scored above the average grade in any course.
SELECT DISTINCT s.name, c.course_name, g.grade
FROM Students s
JOIN Enrollments e ON s.student_id = e.student_id
JOIN Courses c ON e.course_id = c.course_id
JOIN Grades g ON e.enrollment_id = g.enrollment_id
WHERE g.grade > (SELECT AVG(grade) FROM Grades);


# Window Functions
# Rank students in each course based on their grade (highest to lowest).
SELECT c.course_name, s.name AS student_name, g.grade,
       RANK() OVER (PARTITION BY c.course_id ORDER BY g.grade DESC) AS rank_in_course
FROM Students s
JOIN Enrollments e ON s.student_id = e.student_id
JOIN Courses c ON e.course_id = c.course_id
JOIN Grades g ON e.enrollment_id = g.enrollment_id;

# Calculate the cumulative number of enrollments over time.
SELECT enroll_date, COUNT(enrollment_id) AS daily_enrollments,
       SUM(COUNT(enrollment_id)) OVER (ORDER BY enroll_date) AS cumulative_enrollments
FROM Enrollments
GROUP BY enroll_date
ORDER BY enroll_date;

# Show the average grade of each student across courses, and 
# compare it with the overall average grade using LAG() or AVG() OVER().
SELECT s.name AS student_name, 
       ROUND(AVG(g.grade) OVER (PARTITION BY s.student_id), 2) AS avg_student_grade,
       ROUND(AVG(g.grade) OVER (), 2) AS overall_avg_grade
FROM Students s
JOIN Enrollments e ON s.student_id = e.student_id
JOIN Grades g ON e.enrollment_id = g.enrollment_id;
 




