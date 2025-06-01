# ✈️ Flight Boarding Management System

## 📄 Description

A simple Oracle SQL project to manage flight boarding operations, including passengers, flights, pilots, airlines, and boarding passes.

## 🛠️ Setup Instructions

1. **Create User and Grant Privileges:**

   ```sql
   CREATE USER Njoud_Alnamlah IDENTIFIED BY nj2333;
   GRANT ALL PRIVILEGES TO Njoud_Alnamlah;
   ```

2. **Create Tablespaces:**

   ```sql
   CREATE TABLESPACE Project_Table DATAFILE 'c:\\project_datafile.dbf' SIZE 28M;
   CREATE TABLESPACE Project_INDEX DATAFILE 'c:\\UserIndexDataFile.dbf' SIZE 33M;
   ```

3. **Set Default Tablespace:**

   ```sql
   ALTER USER Njoud_Alnamlah DEFAULT TABLESPACE Project_Table;
   ```

4. **Run the SQL Script:**

   Execute the provided SQL script to create tables, insert sample data, and define procedures, functions, and triggers.

## 🗃️ Database Tables and ERD

- **Pilot:** Stores pilot information.
- **Airline:** Contains airline details.
- **Airplain:** Details about airplanes.
- **Flight:** Flight schedules and details.
- **Passenger:** Passenger personal information.
- **BoardingPass:** Boarding pass details linking passengers to flights.

![ERD Diagram](https://raw.githubusercontent.com/your-username/your-repository/main/images/erd-diagram.png)

*Note: Replace `your-username`, `your-repository`, and the image path with your actual GitHub username, repository name, and image location.*

## 🔧 Features

- **Stored Procedures:**
  - `CheckAge`: Determines if a passenger is a minor.
  - `passengerInfo`: Retrieves passenger details.
  - `Price`: Displays ticket pricing based on airline.

- **Functions:**
  - `CountPilot`: Returns the total number of pilots.
  - `Flight_From_To`: Shows flight route information.

- **Triggers:**
  - `number_baggage`: Limits baggage to 5 pieces.
  - `CheckDate`: Restricts flight bookings beyond a certain date.
  - `NoOfPassenger`: Limits passengers per flight to 30.
  - `CheckOnBoarding`: Prevents deletion of checked-in boarding passes.
  - `CheckGate`: Validates gate numbers between 1 and 10.
