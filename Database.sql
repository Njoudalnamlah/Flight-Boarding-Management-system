-- =========================
-- DATABASE: Flight Boarding Management System
-- =========================

-- CREATE USERS
CREATE USER Njoud_Alnamlah IDENTIFIED BY nj442000029;


-- GRANT PRIVILEGES
GRANT ALL PRIVILEGES TO Njoud_Alnamlah;


-- CREATE TABLESPACES
CREATE TABLESPACE Project_Table DATAFILE 'c:\\project_datafile.dbf' SIZE 28M;
CREATE TABLESPACE Project_INDEX DATAFILE 'c:\\UserIndexDataFile.dbf' SIZE 33M;

-- SET DEFAULT TABLESPACE
ALTER USER Njoud_Alnamlah DEFAULT TABLESPACE Project_Table;


-- DROP TABLES IF EXIST
DROP TABLE BoardingPass CASCADE CONSTRAINTS;
DROP TABLE Passenger CASCADE CONSTRAINTS;
DROP TABLE Flight CASCADE CONSTRAINTS;
DROP TABLE Airplain CASCADE CONSTRAINTS;
DROP TABLE Airline CASCADE CONSTRAINTS;
DROP TABLE Pilot CASCADE CONSTRAINTS;

-- CREATE TABLES
CREATE TABLE Pilot (
    pilot_id NUMBER(9) PRIMARY KEY,
    Pilot_name VARCHAR2(50) NOT NULL,
    license VARCHAR2(10) NOT NULL,
    phone NUMBER(13),
    CONSTRAINT PilotUNIQUE UNIQUE (license, phone)
) TABLESPACE Project_Table;

CREATE TABLE Airline (
    airline_id NUMBER(4) PRIMARY KEY,
    AirLine_name VARCHAR2(50) NOT NULL,
    email VARCHAR2(50)
) TABLESPACE Project_Table;

CREATE TABLE Airplain (
    airplain_id NUMBER(12) PRIMARY KEY,
    airline_id NUMBER(4),
    model VARCHAR2(30),
    manufacturer VARCHAR2(30),
    CONSTRAINT FK_air_con FOREIGN KEY (airline_id)
        REFERENCES Airline(airline_id) ON DELETE CASCADE
) TABLESPACE Project_Table;

CREATE TABLE Flight (
    Flight_id NUMBER(5) PRIMARY KEY,
    departure_date DATE,
    departure_time TIMESTAMP,
    arrival_date DATE,
    arrival_time TIMESTAMP,
    flight_from VARCHAR2(20),
    flight_to VARCHAR2(20),
    pilot_id NUMBER(9),
    airplain_id NUMBER(12),
    CONSTRAINT pilot_id_con FOREIGN KEY (pilot_id) REFERENCES Pilot(pilot_id),
    CONSTRAINT airplain_id_con FOREIGN KEY (airplain_id) REFERENCES Airplain(airplain_id) ON DELETE CASCADE
) TABLESPACE Project_Table;

CREATE TABLE Passenger (
    passenger_id NUMBER(10) PRIMARY KEY,
    fname VARCHAR2(10),
    lname VARCHAR2(15),
    email VARCHAR2(50),
    phone NUMBER(13),
    DATE_OF_BIRTH DATE,
    CONSTRAINT UNIQUEQNESS UNIQUE (email, phone)
) TABLESPACE Project_Table;

CREATE TABLE BoardingPass (
    ID CHAR(5) PRIMARY KEY,
    gate NUMBER(3),
    hascheckedin VARCHAR2(3) CHECK (hascheckedin IN ('yes', 'no')),
    hasboarded VARCHAR2(3) CHECK (hasboarded IN ('yes', 'no')),
    number_baggage NUMBER(2),
    Flight_id NUMBER(5),
    passenger_id NUMBER(10),
    CONSTRAINT FK_A_con FOREIGN KEY (passenger_id) REFERENCES Passenger(passenger_id),
    CONSTRAINT FK_F1_con FOREIGN KEY (Flight_id) REFERENCES Flight(Flight_id)
) TABLESPACE Project_Table;

-- INSERT DATA
INSERT INTO Pilot VALUES(314145241,'fahad','f314145241',966588282919);
INSERT INTO Pilot VALUES(415415145,'hamad','h415415145',966578364589);
INSERT INTO Pilot VALUES(862938993,'saif','s862938993',966539374647);
INSERT INTO Pilot VALUES(938784787,'ali','a938784787',966584738748);
INSERT INTO Pilot VALUES(989899733,'naif','n989899733',966573784939);
INSERT INTO Pilot VALUES(827287263,'rashed','r827287263',966584938995);

INSERT INTO Airline VALUES(1001,'Flynas','CustomerService@flynas.com');
INSERT INTO Airline VALUES(1004,'Flynas','CustomerService@flynas.com');
INSERT INTO Airline VALUES(1005,'kuwaitairways','customerrelation@kuwaitairways.com');
INSERT INTO Airline VALUES(1006,'Oman Airline','OmanAirline@OmanAirline.com');
INSERT INTO Airline VALUES(1000,'qatar airline','qatarr@qatarr.com');
INSERT INTO Airline VALUES(1002,'Fly dubai','skywards@flydubai.com');

INSERT INTO Airplain VALUES(100000000999,1001,'Boeing777','United States');
INSERT INTO Airplain VALUES(100000000998,1004,'Boeing707','United States');
INSERT INTO Airplain VALUES(100000000997,1005,'Airbus A380','United Kingdom');
INSERT INTO Airplain VALUES(100000000966,1006,'Airbus A321','France');
INSERT INTO Airplain VALUES(100000000123,1000,'Boeing-77A','United States');
INSERT INTO Airplain VALUES(100000000766,1002,'AIRBUS A320','United Kingdom');

INSERT INTO Flight VALUES(111,TO_DATE('01-12-2022','dd-mm-yyyy'),TO_TIMESTAMP('07:00:00','HH24:MI:SS'),TO_DATE('01-12-2022','dd-mm-yyyy'),TO_TIMESTAMP('09:00:00','HH24:MI:SS'),'Riyadh','dubia',314145241,100000000999);

INSERT INTO Passenger VALUES(10,'Njoud','Alnamlah','Njoudalnmlah1@gmail.com',0501188686,TO_DATE('15-05-2002','dd-mm-yyyy'));

INSERT INTO BoardingPass VALUES('OKL20',1,'yes','no',5,111,10);

-- PROCEDURES
CREATE OR REPLACE PROCEDURE CheckAge(a IN Passenger.passenger_id%TYPE)
IS
    DOB DATE := TO_DATE('01-01-2004','DD-MM-YYYY');
    DateOfBirth DATE;
BEGIN
    SELECT DATE_OF_BIRTH INTO DateOfBirth FROM Passenger WHERE passenger_id = a;
    IF DOB < DateOfBirth THEN
        DBMS_OUTPUT.PUT_LINE('this passenger is kid that needs guardian');
    ELSE
        DBMS_OUTPUT.PUT_LINE('this passenger is an adult');
    END IF;
END;
/

CREATE OR REPLACE PROCEDURE passengerInfo(passengerid IN Passenger.passenger_id%TYPE)
IS
    idd Passenger.passenger_id%TYPE;
    first_name Passenger.fname%TYPE;
    last_name Passenger.lname%TYPE;
    passenger_email Passenger.email%TYPE;
    passenger_phone Passenger.phone%TYPE;
    passenger_DOB Passenger.DATE_OF_BIRTH%TYPE;
BEGIN
    SELECT passenger_id, fname, lname, email, phone, DATE_OF_BIRTH
    INTO idd, first_name, last_name, passenger_email, passenger_phone, passenger_DOB
    FROM Passenger
    WHERE passenger_id = passengerid;

    DBMS_OUTPUT.PUT_LINE('Passenger ID: ' || idd || ' Name: ' || first_name || ' ' || last_name || 
                         ' Email: ' || passenger_email || ' Phone: ' || passenger_phone || 
                         ' DOB: ' || passenger_DOB);
END;
/
44
CREATE OR REPLACE PROCEDURE Price(Airlineid IN Airline.airline_id%TYPE)
IS
    AirLinename Airline.AirLine_name%TYPE;
BEGIN
    SELECT AirLine_name INTO AirLinename FROM Airline WHERE airline_id = Airlineid;
    CASE
        WHEN AirLinename = 'Flynas' THEN
            DBMS_OUTPUT.PUT_LINE('SAR 2,157.96 per Adult | SAR 1,157.96 per Child');
        WHEN AirLinename = 'kuwaitairways' THEN
            DBMS_OUTPUT.PUT_LINE('SAR 1,200.12 per Adult | SAR 800 per Child');
        WHEN AirLinename = 'qatar airline' THEN
            DBMS_OUTPUT.PUT_LINE('SAR 1,200.96 per Adult | SAR 2,000.96 per Child');
        WHEN AirLinename = 'Oman Airline' THEN
            DBMS_OUTPUT.PUT_LINE('SAR 1,433.99 per Adult | SAR 1,000 per Child');
        WHEN AirLinename = 'Fly dubai' THEN
            DBMS_OUTPUT.PUT_LINE('SAR 1,200.22 per Adult | SAR 900 per Child');
        ELSE
            DBMS_OUTPUT.PUT_LINE('Not priced yet, will be priced soon.');
    END CASE;
END;
/

-- FUNCTIONS
CREATE OR REPLACE FUNCTION CountPilot
RETURN NUMBER
IS
    Total_Pilot NUMBER;
BEGIN
    SELECT COUNT(*) INTO Total_Pilot FROM Pilot;
    RETURN Total_Pilot;
END;
/

CREATE OR REPLACE FUNCTION Flight_From_To(Fid IN NUMBER)
RETURN VARCHAR2
IS
    ffrom Flight.flight_from%TYPE;
    fto Flight.flight_to%TYPE;
BEGIN
    SELECT flight_from, flight_to INTO ffrom, fto FROM Flight WHERE Flight_id = Fid;
    RETURN ('The Flight Schedule for Flight ' || Fid || ': ' || ffrom || ' -> ' || fto);
END;
/

-- TRIGGERS
CREATE OR REPLACE TRIGGER number_baggage
BEFORE INSERT OR UPDATE ON BoardingPass
FOR EACH ROW
BEGIN
    IF :new.number_baggage > 5 THEN
        RAISE_APPLICATION_ERROR(-20001,'More than 5 luggage – you’ll have to pay a fee.');
    END IF;
END;
/

CREATE OR REPLACE TRIGGER CheckDate
BEFORE INSERT OR UPDATE ON Flight
FOR EACH ROW
BEGIN
    IF :new.departure_date > TO_DATE('23-OCT-2023','DD-MON-YYYY') THEN
        RAISE_APPLICATION_ERROR(-20001, 'The airlines have not yet opened reservations for this date.');
    END IF;
END;
/

CREATE OR REPLACE TRIGGER NoOfPassenger
BEFORE INSERT ON BoardingPass
FOR EACH ROW
DECLARE
    passenger_count NUMBER;
BEGIN
    SELECT COUNT(*) INTO passenger_count FROM BoardingPass WHERE passenger_id = :new.passenger_id;
    IF passenger_count > 30 THEN
        RAISE_APPLICATION_ERROR(-20001, 'Passenger count exceeds number of available seats.');
    END IF;
END;
/

CREATE OR REPLACE TRIGGER CheckOnBoarding
BEFORE DELETE ON BoardingPass
FOR EACH ROW
BEGIN
    IF :old.hascheckedin = 'yes' THEN
        RAISE_APPLICATION_ERROR(-20001, 'Passenger has checked in. Cannot delete.');
    ELSE
        DBMS_OUTPUT.PUT_LINE('Canceled successfully. Refund will be issued.');
    END IF;
END;
/

CREATE OR REPLACE TRIGGER CheckGate
BEFORE INSERT OR UPDATE ON BoardingPass
FOR EACH ROW
BEGIN
    IF :new.gate NOT IN (1,2,3,4,5,6,7,8,9,10) THEN
        RAISE_APPLICATION_ERROR(-20001, 'Sorry! We only have 10 gates.');
    END IF;
END;
/