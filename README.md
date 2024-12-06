## 🔒 SQL Trigger for Employee Registration During Business Hours
This project demonstrates the use of SQL triggers to manage data insertion in a database, specifically focusing on ensuring that employee records are only inserted during business hours. The database is structured with two main tables: empleado (employee) and departamento (department). The trigger prevents the insertion of employee data outside the specified working hours, which are from Friday to Wednesday, between 2:00 PM and 10:00 PM.

## 🛠️ Features
* Employee Table: Stores employee details like ID, salary, name, and department number.
* Department Table: Contains department details including department number and name.
* Trigger Implementation: A trigger that prevents the insertion of an employee record if the operation happens outside of business hours.
* Error Handling: The trigger uses both SET NEW.id_emp = NULL and SIGNAL SQLSTATE to prevent unauthorized inserts and handle errors appropriately.
* Stored Procedure: A procedure VERIFICAR_HORARIO is used to validate if the current time and day are within the business hours before inserting an employee record.
## ⚙️ Technologies Used
* MySQL: Database management system.
* SQL Triggers: For controlling data insertion based on conditions.
* Stored Procedures: Used to encapsulate logic for time and day validation.
## 📥 Installation Instructions
1. Install MySQL:
Ensure MySQL is installed on your system. You can download it from MySQL's official website.

2. Import the SQL Script:
Clone or download the project, and run the SQL script to create the practica database, tables, and triggers.
   ```bash
    Copiar código
    mysql -u root -p < script.sql
3. Test the Trigger:
After importing, you can test the trigger by attempting to insert a record outside of the allowed time. If the insertion occurs outside the defined hours, it will be blocked.

