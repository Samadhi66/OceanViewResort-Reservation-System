#Ocean View Resort Reservation System
##Project Overview

The Ocean View Resort Reservation System is a web-based hotel reservation management system developed using Java, JSP, Servlets, Apache Tomcat, and MySQL.
This system helps hotel administrators and receptionists manage reservations, generate invoices, and maintain guest records efficiently

##Technologies Used

The following technologies were used in the development of this system:

-Java (Backend Programming)
-JSP – Java Server Pages
-Servlets – Request Handling
-Apache Tomcat – Application Server
=MySQL – Database Management System
-MySQL Workbench – Database Design Tool
-Bootstrap – User Interface Design
-Eclipse IDE – Development Environment
-Git & GitHub – Version Control

##System Features

The system includes the following features:

-Secure User Login Authentication
-Role-based access control
-Add new reservations
-Edit reservation details
-Delete reservations
-View reservation list
-Generate billing invoices
-Calculate room charges automatically
-Export reservation data to CSV
-Search reservations by guest name or date

##System Architecture

The system follows the MVC (Model–View–Controller) architecture.

Model
-Represents database entities
-Example: Reservation, User, Bill classes

View
-JSP pages used to display the user interface

Controller
-Java Servlets used to handle user requests and application logic

##Database Design

The system database contains the following tables:

users
-user_id
-username
-password
-role

rooms
-room_id
-room_type
-price_per_night
-availability_status

reservations
-reservation_no
-guest_name
-address
-contact_number
-room_type
-check_in
-check_out
-status

bills
-bill_id
-reservation_no
-room_charge
-service_charge
-total_amount
-generated_date

##How to Run the Project

Follow these steps to run the project:
-Install Java JDK
-Install Eclipse IDE for Enterprise Java
-Install Apache Tomcat Server
-Install MySQL Server
-Open MySQL Workbench and create the database
-Import the project into Eclipse
-Configure the database connection
-Deploy the project to Apache Tomcat
-Open the system in a web browser

URL:
http://localhost:8087/OceanViewResort/login.jsp

##Version Control

This project uses Git and GitHub for version control.

-Development commits include:
-Initial project setup
-Database connection configuration
-User login functionality
-Reservation management implementation
-Billing generation feature
-Export reservation data functionality
-Authentication and admin access filters
-User interface improvements
-Final system integration and testing
