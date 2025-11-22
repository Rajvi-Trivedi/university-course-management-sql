SET FOREIGN_KEY_CHECKS = 0;
DROP TABLE IF EXISTS Enrollments;
DROP TABLE IF EXISTS Courses;
DROP TABLE IF EXISTS Instructors;
DROP TABLE IF EXISTS Students;
DROP TABLE IF EXISTS Departments;
SET FOREIGN_KEY_CHECKS = 1;

-- ================================
-- CREATE TABLES
-- ================================

CREATE TABLE Departments (
    DepartmentID INT PRIMARY KEY,
    DepartmentName VARCHAR(100) NOT NULL
);

CREATE TABLE Students (
    StudentID INT PRIMARY KEY,
    FirstName VARCHAR(50),
    LastName VARCHAR(50),
    Email VARCHAR(150),
    BirthDate DATE,
    EnrollmentDate DATE
);

CREATE TABLE Courses (
    CourseID INT PRIMARY KEY,
    CourseName VARCHAR(150),
    DepartmentID INT,
    Credits INT,
    CONSTRAINT fk_courses_dept FOREIGN KEY (DepartmentID) REFERENCES Departments(DepartmentID)
);

CREATE TABLE Instructors (
    InstructorID INT PRIMARY KEY,
    FirstName VARCHAR(50),
    LastName VARCHAR(50),
    Email VARCHAR(150),
    DepartmentID INT,
    CONSTRAINT fk_instructors_dept FOREIGN KEY (DepartmentID) REFERENCES Departments(DepartmentID)
);

CREATE TABLE Enrollments (
    EnrollmentID INT PRIMARY KEY,
    StudentID INT,
    CourseID INT,
    EnrollmentDate DATE,
    CONSTRAINT fk_enrollments_student FOREIGN KEY (StudentID) REFERENCES Students(StudentID),
    CONSTRAINT fk_enrollments_course FOREIGN KEY (CourseID) REFERENCES Courses(CourseID)
);

-- ================================
-- INSERT NEW MODIFIED DATA
-- ================================

INSERT INTO Departments (DepartmentID, DepartmentName) VALUES
(10, 'Information Technology'),
(20, 'Data Analytics');

INSERT INTO Students (StudentID, FirstName, LastName, Email, BirthDate, EnrollmentDate) VALUES
(101, 'Aarav', 'Sharma', 'aarav.sharma101@uni.com', '2001-04-12', '2023-07-15'),
(102, 'Meera', 'Joshi', 'meera.joshi102@uni.com', '2000-09-30', '2022-06-05');

INSERT INTO Courses (CourseID, CourseName, DepartmentID, Credits) VALUES
(501, 'Database Fundamentals', 10, 4),
(502, 'Statistical Computing', 20, 3);

INSERT INTO Instructors (InstructorID, FirstName, LastName, Email, DepartmentID) VALUES
(201, 'Ritika', 'Mehta', 'ritika.mehta@faculty.com', 10),
(202, 'Karan', 'Patel', 'karan.patel@faculty.com', 20);

INSERT INTO Enrollments (EnrollmentID, StudentID, CourseID, EnrollmentDate) VALUES
(9001, 101, 501, '2023-07-15'),
(9002, 102, 502, '2022-06-05');

INSERT INTO Students (StudentID, FirstName, LastName, Email, BirthDate, EnrollmentDate)
VALUES (103, 'Siddharth', 'Kapoor', 'sid.kapoor103@uni.com', '2002-10-22', '2024-01-11');

SELECT * FROM Students;

UPDATE Students SET Email = 'aarav.updated@uni.com' WHERE StudentID = 101;

INSERT INTO Courses (CourseID, CourseName, DepartmentID, Credits) VALUES (503, 'Machine Learning Basics', 10, 5);
SELECT * FROM Courses;
UPDATE Courses SET Credits = 6 WHERE CourseID = 503;

INSERT INTO Instructors (InstructorID, FirstName, LastName, Email, DepartmentID) 
VALUES (203,'Nisha','Rao','nisha.rao@faculty.com',10);
SELECT * FROM Instructors;
UPDATE Instructors SET Email = 'ritika.m@faculty.com' WHERE InstructorID = 201;

INSERT INTO Enrollments (EnrollmentID, StudentID, CourseID, EnrollmentDate) 
VALUES (9003,101,502,'2024-02-01');
SELECT * FROM Enrollments;
UPDATE Enrollments SET EnrollmentDate = '2024-02-02' WHERE EnrollmentID = 9003;

-- ================================
-- QUERIES (unchanged)
-- ================================

SELECT * FROM Departments;

SELECT StudentID, FirstName, LastName, EnrollmentDate
FROM Students
WHERE EnrollmentDate > '2022-12-31';

SELECT C.CourseID, C.CourseName, C.Credits
FROM Courses C
JOIN Departments D ON C.DepartmentID = D.DepartmentID
WHERE D.DepartmentName = 'Data Analytics'
LIMIT 5;

SELECT C.CourseID, C.CourseName, COUNT(E.StudentID) AS StudentCount
FROM Courses C
LEFT JOIN Enrollments E ON C.CourseID = E.CourseID
GROUP BY C.CourseID, C.CourseName
HAVING COUNT(E.StudentID) > 5;

SELECT S.StudentID, S.FirstName, S.LastName
FROM Students S
WHERE S.StudentID IN (
    SELECT StudentID
    FROM Enrollments
    WHERE CourseID IN (501, 502)
    GROUP BY StudentID
    HAVING COUNT(DISTINCT CourseID) = 2
);

SELECT DISTINCT S.StudentID, S.FirstName, S.LastName
FROM Students S
JOIN Enrollments E ON S.StudentID = E.StudentID
WHERE E.CourseID IN (501, 502);

SELECT ROUND(AVG(Credits),2) AS AvgCredits FROM Courses;

ALTER TABLE Instructors ADD COLUMN Salary DECIMAL(10,2) NULL;

UPDATE Instructors 
SET Salary = CASE 
                WHEN InstructorID = 201 THEN 90000 
                WHEN InstructorID = 202 THEN 75000 
                ELSE 68000 
             END;

SELECT MAX(I.Salary) AS MaxSalaryIT
FROM Instructors I
JOIN Departments D ON I.DepartmentID = D.DepartmentID
WHERE D.DepartmentName = 'Information Technology';

SELECT D.DepartmentID, D.DepartmentName, COUNT(DISTINCT E.StudentID) AS StudentsInDept
FROM Departments D
LEFT JOIN Courses C ON D.DepartmentID = C.DepartmentID
LEFT JOIN Enrollments E ON C.CourseID = E.CourseID
GROUP BY D.DepartmentID, D.DepartmentName;

SELECT S.StudentID, S.FirstName, S.LastName, C.CourseID, C.CourseName, E.EnrollmentDate
FROM Students S
INNER JOIN Enrollments E ON S.StudentID = E.StudentID
INNER JOIN Courses C ON E.CourseID = C.CourseID;

SELECT S.StudentID, S.FirstName, S.LastName, C.CourseID, C.CourseName, E.EnrollmentDate
FROM Students S
LEFT JOIN Enrollments E ON S.StudentID = E.StudentID
LEFT JOIN Courses C ON E.CourseID = C.CourseID;

SELECT DISTINCT S.StudentID, S.FirstName, S.LastName
FROM Students S
WHERE S.StudentID IN (
    SELECT E.StudentID
    FROM Enrollments E
    WHERE E.CourseID IN (
        SELECT CourseID
        FROM Enrollments
        GROUP BY CourseID
        HAVING COUNT(StudentID) > 10
    )
);

SELECT StudentID, FirstName, LastName, YEAR(EnrollmentDate) AS EnrollmentYear
FROM Students;

SELECT InstructorID, CONCAT(FirstName, ' ', LastName) AS FullName, Email
FROM Instructors;

SELECT EnrollmentID, EnrollmentDate, StudentID, CourseID,
       COUNT(*) OVER (ORDER BY EnrollmentDate, EnrollmentID 
                      ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) AS RunningEnrollmentCount
FROM Enrollments
ORDER BY EnrollmentDate, EnrollmentID;

SELECT StudentID, FirstName, LastName, EnrollmentDate,
       CASE
         WHEN TIMESTAMPDIFF(YEAR, EnrollmentDate, CURDATE()) > 4 THEN 'Senior'
         ELSE 'Junior'
       END AS StudentLevel
FROM Students;
