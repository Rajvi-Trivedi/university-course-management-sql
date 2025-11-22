University Enrollment & Course Management System
SQL Project 
📌 Overview

The University Enrollment & Course Management System is a fully functional SQL-based project that demonstrates how a real academic database operates.
This system showcases key SQL concepts such as:

Database creation with proper constraints

Normalized relational table structures

CRUD operations

INNER, LEFT, RIGHT, FULL (via UNION) joins

Subqueries

GROUP BY & HAVING for analytical queries

Date, string, and numeric functions

Window functions (Running counts)

CASE expressions for classification

The project simulates the data workflow used in a modern university academic environment.

📂 Project Objectives

This project aims to:

Build a complete relational database for managing students, instructors, courses, and enrollments

Demonstrate all major SQL operations in a real-world education domain

Use foreign key constraints to maintain data integrity

Provide a ready-to-run .sql script for MySQL 8.x

Practice analysis queries on realistic academic data

🏛️ Database Entity Overview

The system consists of five main entities, connected through meaningful relationships:

1. Departments

Stores academic department names (ex: Information Technology, Data Analytics).

2. Students

Contains personal details, birth date, and enrollment date for each student.
(Your version includes: Aarav Sharma, Meera Joshi, Siddharth Kapoor.)

3. Courses

Represents academic courses offered under departments.
(E.g., Database Fundamentals, Statistical Computing.)

4. Instructors

Faculty details mapped to their departments.
(E.g., Ritika Mehta, Karan Patel.)

5. Enrollments

Maps each student to the courses they enroll in.
Includes enrollment date and supports window analysis.


✔ Table Creation & Constraints

Pri
