CREATE DATABASE mdtm;

use mdtm;
-- Step 1: Create Students table
CREATE TABLE Students (
	student_id INT PRIMARY KEY,
    name VARCHAR(100),
    credit_hours INT,
    gpa DECIMAL(3,2)
);

INSERT INTO Students (student_id, name, credit_hours, gpa)
VALUES 
 ('10001', 'Sam Carson', '12', '3.5'),
 ('10002', 'Rick Astley', '21', '2.5'),
 ('10003','Daby Balde', '56', '3.9'),
 ('10004', 'Uncle Ruckus', '104', '2.0');

-- Step 2: Create Professors table
CREATE TABLE Professors (
	professor_id INT PRIMARY KEY,
    name VARCHAR(100),
    salary DECIMAL(10,2)
);

-- Step 3: Create Courses table
CREATE TABLE Courses (
	course_id INT PRIMARY KEY,
    department VARCHAR(50),
    course_number VARCHAR(10),
    section CHAR(1),
    course_name VARCHAR(100),
    hours INT,
    description TEXT
);

INSERT INTO Courses (course_id, department, course_number, section, course_name, hours, description)
VALUES
    ('1001', 'Aqua', 'AQUA101', '5', 'Water', 3, 'Master the art of basket weaving, underwater!'),
    ('1002', 'Psychology', 'PSYCH110', '8','Procrastination', 4, 'Learn to procrastinate like a pro and still succeed!'),
    ('1003', 'Survival', 'SURV101', '2','Zombie Survival', 2, 'Surviving the zombie apocalypse 101.'),
    ('1004', 'Culinary Arts', 'CULIN202', '3','Tasting and Testing', 3, 'Experience the delicate science of savoring food.'),
    ('1005', 'AstroStudies', 'ASTRO303', '3', 'Extraterrestil Life',5, 'Understanding the universe from an alien perspective.');
    
-- Step 4: Create Enrollment table to track students enrollments
CREATE TABLE Enrollment (
	enrollment_id INT PRIMARY KEY,
    student_id INT,
    course_id INT,
    grade CHAR(1),
    FOREIGN KEY (student_id) REFERENCES Students(student_id),
    FOREIGN KEY (course_id) REFERENCES Courses(course_id)
);

INSERT INTO Enrollment (enrollment_id, student_id, course_id, grade)
VALUES
	(101, 10002, 1005, 'B');

-- Step 5: Create Teaches table to track professor-course assignments
CREATE TABLE Teaches (
	teach_id INT PRIMARY KEY,
    professor_id INT,
    course_id INT,
    FOREIGN KEY (professor_id) REFERENCES Professors(professor_id),
    FOREIGN KEY (course_id) REFERENCES Courses(course_id)
);

-- Insert three professors into the Professors table
INSERT INTO Professors (professor_id, name, salary)
VALUES
    ('1001','Professor Aquarius Waterloo', 75000),
    ('1002','Dr. Pro. Crastinator Psych', 80000),
    ('1003','Professor Zed Survivor', 70000);

INSERT INTO Teaches (teach_id, professor_id, course_id)
VALUES 
       (10001, 1002, 1002),
       (10002, 1001,1001),
       (10003, 1003, 1003);

-- Creating a New User and Granting Privileges
CREATE USER 'new_user'@'localhost' IDENTIFIED BY 'password';
GRANT SELECT, INSERT ON mdtm.* TO 'new_user'@'localhost';

-- Selecting All Students Currently Registered for a Specific Course
SELECT Students.name
FROM Students
JOIN Enrollment ON Students.student_id = Enrollment.student_id 
WHERE Enrollment.course_id = 1005;

-- Selecting the Grade a Specific Student Received in a Previously Taken Course
SELECT grade
FROM ENROLLMENT
WHERE student_id = 10002 AND course_id = 1005;

-- Adding a Student to a Course
INSERT INTO Enrollment (enrollment_id, student_id, course_id)
VALUES (102, 10004, 1002);

-- Dropping a Student from a Course (No "W")
DELETE FROM Enrollment 
WHERE student_id = 10004 and course_id = 1002;

-- Dropping a Student from a Course with a "W"
UPDATE Enrollment
SET grade = 'W'
WHERE student_id = 10002 and course_id = 1005;


-- EXTRA CREDIT
-- Updating All Students' Credit Hours
SET SQL_SAFE_UPDATES = 0;

UPDATE Students s
SET s.credit_hours = (
	SELECT SUM(Courses.hours)
    FROM Courses
    JOIN Enrollment ON Courses.course_id = Enrollment.course_id
    WHERE Enrollment.student_id = s.student_id AND Enrollment.grade IN ('A', 'B', 'C', 'D')
);    

SET SQL_SAFE_UPDATES = 0;

-- Selecting All Courses a Specific Student is Taking from a Specific Professor
SELECT Courses.course_name
FROM Courses
JOIN Enrollment ON Courses.course_id = Enrollment.course_id
JOIN Teaches ON Courses.course_id = Teaches.course_id
WHERE Enrollment.student_id = 101 AND Teaches.professor_id = 1003;
