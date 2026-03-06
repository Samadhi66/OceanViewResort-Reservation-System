**Ocean View Resort Reservation System
**
This project is a web-based hotel reservation management system developed using Java, JSP, Servlets, and MySQL.
The system allows administrators and receptionists to manage hotel reservations, generate billing invoices, and maintain reservation records efficiently.

Project Overview
The Ocean View Resort Reservation System was developed to simplify the process of managing hotel reservations.
The system replaces manual reservation handling with a digital solution that improves efficiency, accuracy, and data management.

Users can:

Log into the system securely
Create and manage reservations
Generate billing invoices automatically
Search and export reservation records
Manage system data using role-based access control
Technologies Used
The following technologies were used to develop the system:
Java – Core programming language
JSP (Java Server Pages) – Web interface development
Servlets – Backend request handling
MySQL – Database management system
Bootstrap – Responsive UI design
Git & GitHub – Version control and project management
Apache Tomcat – Web server for deployment

**System Features
**The system includes the following functionalities:

User Authentication
Secure login system

Role-based access control (Admin / Reception)

Reservation Management
Add new reservations
Edit reservation details
Delete reservations
View reservation records
Billing Management
Automatic bill generation
Calculation of room charges and service charges
Printable invoice generation
Data Management
Search reservations
Export reservation data to CSV
Filter reservations by date

System Architecture
The project follows the MVC (Model-View-Controller) architecture.

Model – Java classes representing data entities (Reservation, User, Bill)
View – JSP pages for user interface
Controller – Servlets that process user requests and manage business logic

This architecture improves code organization, maintainability, and scalability.

Database Design
The system database includes the following main tables:

Users – Stores login credentials and user roles
Rooms – Stores room details and pricing
Reservations – Stores reservation records
Bills – Stores billing information related to reservations

These tables are connected using relational database relationships to ensure data consistency and integrity.

System Screenshots

The system interface includes:

Login Page
Reservation Form
Reservation List Dashboard
Billing Invoice Page

Installation Guide

To run this project locally:

Install Java JDK
Install Apache Tomcat Server
Install MySQL Server
Import the project into Eclipse IDE
Configure the database connection
Run the project on Tomcat Server

GitHub Version Control

This project uses Git and GitHub for version control.

Development was tracked using multiple commits including:

Initial project setup
Database connection implementation
User authentication development
Reservation management implementation
Billing system development

UI improvements

Final system testing and integration
