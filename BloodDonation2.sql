-- Create Database
CREATE DATABASE IF NOT EXISTS blood_donation;
USE blood_donation;

-- User Roles Table
CREATE TABLE IF NOT EXISTS user_roles (
    role_id INT AUTO_INCREMENT PRIMARY KEY,
    role_name VARCHAR(50) NOT NULL UNIQUE
);
INSERT INTO user_roles (role_name) VALUES ('Admin'), ('Donor'), ('Hospital Staff');

-- Blood Groups Table
CREATE TABLE IF NOT EXISTS blood (
    blood_id INT AUTO_INCREMENT PRIMARY KEY,
    blood_group VARCHAR(10) NOT NULL UNIQUE
);
INSERT INTO blood (blood_group)
VALUES ("B+"),("B-"),("A+"),("O+"),("O-"),("A-"),("AB+"),("AB-");

-- Donor Details Table
CREATE TABLE IF NOT EXISTS donor_details (
    donor_id INT AUTO_INCREMENT PRIMARY KEY,
    donor_name VARCHAR(50) NOT NULL,
    donor_number VARCHAR(15) NOT NULL UNIQUE,
    donor_mail VARCHAR(50),
    donor_age INT NOT NULL,
    donor_gender ENUM('Male', 'Female', 'Other') NOT NULL,
    donor_blood VARCHAR(10) NOT NULL,
    donor_address VARCHAR(100) NOT NULL,
    role_id INT,
    FOREIGN KEY (role_id) REFERENCES user_roles(role_id) ON DELETE SET NULL,
    FOREIGN KEY (donor_blood) REFERENCES blood(blood_group) ON DELETE RESTRICT
);

-- Admin Info Table
CREATE TABLE IF NOT EXISTS admin_info (
    admin_id INT AUTO_INCREMENT PRIMARY KEY,
    admin_name VARCHAR(50) NOT NULL,
    admin_username VARCHAR(50) NOT NULL UNIQUE,
    admin_password VARCHAR(255) NOT NULL -- Storing hashed password
);
INSERT INTO admin_info (admin_name, admin_username, admin_password)
VALUES ("Varun", "varunsardana004", '$2y$10$N9qo8uLOickgx2ZMRZoMy.MQDq5phQYVXg6I5tV7pPx9W7RT7yzKO'); -- Example hashed password

-- Contact Info Table
CREATE TABLE IF NOT EXISTS contact_info (
    contact_id INT AUTO_INCREMENT PRIMARY KEY,
    contact_address VARCHAR(100) NOT NULL,
    contact_mail VARCHAR(50) NOT NULL,
    contact_phone VARCHAR(20) NOT NULL
);
INSERT INTO contact_info (contact_address, contact_mail, contact_phone)
VALUES ("Hisar,Haryana(125001)", "bloodbank@gmail.com", "7056550477");

-- Pages Info Table
CREATE TABLE IF NOT EXISTS pages (
    page_id INT AUTO_INCREMENT PRIMARY KEY,
    page_name VARCHAR(255) NOT NULL,
    page_type VARCHAR(50) NOT NULL UNIQUE,
    page_data LONGTEXT NOT NULL
);

-- Query Status Table
CREATE TABLE IF NOT EXISTS query_stat (
    id INT PRIMARY KEY,
    query_type VARCHAR(45) NOT NULL
);
INSERT INTO query_stat(id, query_type)
VALUES (1, "Read"), (2, "Pending");

-- Contact Query Table
CREATE TABLE IF NOT EXISTS contact_query (
    query_id INT AUTO_INCREMENT PRIMARY KEY,
    query_name VARCHAR(100) NOT NULL,
    query_mail VARCHAR(120) NOT NULL,
    query_number CHAR(15) NOT NULL,
    query_message LONGTEXT NOT NULL,
    query_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    query_status INT DEFAULT 2, -- Default to Pending
    FOREIGN KEY (query_status) REFERENCES query_stat(id) ON DELETE SET NULL
);

-- Blood Inventory Table
CREATE TABLE IF NOT EXISTS blood_inventory (
    inventory_id INT AUTO_INCREMENT PRIMARY KEY,
    blood_group VARCHAR(10) NOT NULL,
    units_available INT NOT NULL DEFAULT 0,
    last_updated TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    expiry_date DATE NOT NULL,
    FOREIGN KEY (blood_group) REFERENCES blood(blood_group) ON DELETE CASCADE
);

-- Blood Request Table
CREATE TABLE IF NOT EXISTS blood_request (
    request_id INT AUTO_INCREMENT PRIMARY KEY,
    recipient_name VARCHAR(100) NOT NULL,
    recipient_blood_group VARCHAR(10) NOT NULL,
    units_required INT NOT NULL,
    hospital_name VARCHAR(100),
    request_status ENUM('Pending', 'Approved', 'Rejected', 'Fulfilled') DEFAULT 'Pending',
    request_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (recipient_blood_group) REFERENCES blood(blood_group) ON DELETE CASCADE
);

-- Donation History Table
CREATE TABLE IF NOT EXISTS donation_history (
    donation_id INT AUTO_INCREMENT PRIMARY KEY,
    donor_id INT,
    blood_group VARCHAR(10),
    donation_date DATE,
    units_donated INT NOT NULL DEFAULT 1,
    FOREIGN KEY (donor_id) REFERENCES donor_details(donor_id) ON DELETE CASCADE,
    FOREIGN KEY (blood_group) REFERENCES blood(blood_group) ON DELETE CASCADE
);

-- Upcoming Donation Events Table
CREATE TABLE IF NOT EXISTS donation_events (
    event_id INT AUTO_INCREMENT PRIMARY KEY,
    event_name VARCHAR(100),
    location VARCHAR(100),
    date DATE,
    time TIME,
    description TEXT,
    admin_id INT,
    FOREIGN KEY (admin_id) REFERENCES admin_info(admin_id) ON DELETE SET NULL
);

-- Notification Logs Table
CREATE TABLE IF NOT EXISTS notifications (
    notification_id INT AUTO_INCREMENT PRIMARY KEY,
    user_type VARCHAR(10),
    user_id INT,
    message TEXT,
    sent_on TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Feedback Table
CREATE TABLE IF NOT EXISTS feedback (
    feedback_id INT AUTO_INCREMENT PRIMARY KEY,
    donor_id INT,
    feedback_message TEXT,
    feedback_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (donor_id) REFERENCES donor_details(donor_id) ON DELETE CASCADE
);

-- Emergency Blood Request Table
CREATE TABLE IF NOT EXISTS emergency_requests (
    emergency_id INT AUTO_INCREMENT PRIMARY KEY,
    blood_group VARCHAR(10) NOT NULL,
    urgency_level VARCHAR(20) NOT NULL,
    request_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    fulfillment_status ENUM('Pending', 'Fulfilled') DEFAULT 'Pending',
    FOREIGN KEY (blood_group) REFERENCES blood(blood_group) ON DELETE CASCADE
);

-- Health Screening Table
CREATE TABLE IF NOT EXISTS health_screening (
    screening_id INT AUTO_INCREMENT PRIMARY KEY,
    donor_id INT,
    screening_date DATE,
    health_status VARCHAR(100),
    FOREIGN KEY (donor_id) REFERENCES donor_details(donor_id) ON DELETE CASCADE
);

-- Referral Program Table
CREATE TABLE IF NOT EXISTS referral_program (
    referral_id INT AUTO_INCREMENT PRIMARY KEY,
    referrer_id INT,
    referred_donor_id INT,
    referral_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (referrer_id) REFERENCES donor_details(donor_id) ON DELETE CASCADE,
    FOREIGN KEY (referred_donor_id) REFERENCES donor_details(donor_id) ON DELETE CASCADE
);

-- Drop Views if they exist
DROP VIEW IF EXISTS compatible_donors;
DROP VIEW IF EXISTS most_donated_blood_group;
DROP VIEW IF EXISTS monthly_donations;
DROP VIEW IF EXISTS critical_inventory;
DROP VIEW IF EXISTS top_donor_areas;

-- Compatible Donors View
CREATE VIEW compatible_donors AS
SELECT r.request_id, r.recipient_name, r.recipient_blood_group, d.donor_id, d.donor_name, d.donor_blood
FROM blood_request r
JOIN donor_details d ON (
    (r.recipient_blood_group = d.donor_blood) OR
    (r.recipient_blood_group = 'AB+' AND d.donor_blood IN ('A+', 'B+', 'O+', 'AB+', 'A-', 'B-', 'O-', 'AB-')) OR
    (r.recipient_blood_group = 'O+' AND d.donor_blood IN ('O+', 'O-')) OR
    (r.recipient_blood_group = 'A+' AND d.donor_blood IN ('A+', 'A-', 'O+', 'O-')) OR
    (r.recipient_blood_group = 'B+' AND d.donor_blood IN ('B+', 'B-', 'O+', 'O-')) OR
    (r.recipient_blood_group = 'AB-' AND d.donor_blood IN ('A-', 'B-', 'AB-', 'O-')) OR
    (r.recipient_blood_group = 'A-' AND d.donor_blood IN ('A-', 'O-')) OR
    (r.recipient_blood_group = 'B-' AND d.donor_blood IN ('B-', 'O-')) OR
    (r.recipient_blood_group = 'O-' AND d.donor_blood = 'O-')
);

-- Most Donated Blood Group View
CREATE VIEW most_donated_blood_group AS
SELECT blood_group, COUNT(*) AS total_donations
FROM donation_history
GROUP BY blood_group
ORDER BY total_donations DESC;

-- Monthly Donation Trends View
CREATE VIEW monthly_donations AS
SELECT MONTH(donation_date) AS month, COUNT(*) AS total
FROM donation_history
GROUP BY MONTH(donation_date);

-- Critical Inventory View
CREATE VIEW critical_inventory AS
SELECT blood_group, units_available
FROM blood_inventory
WHERE units_available < 5;

-- Top Donor Areas View
CREATE VIEW top_donor_areas AS
SELECT donor_address, COUNT(*) AS total_donors
FROM donor_details
GROUP BY donor_address
ORDER BY total_donors DESC;

-- CRUD Operations for Donation History

-- Create Donation
DELIMITER $$

CREATE PROCEDURE create_donation(
    IN donor_id INT, 
    IN blood_group VARCHAR(10), 
    IN units_donated INT
)
BEGIN
    INSERT INTO donation_history (donor_id, blood_group, donation_date, units_donated)
    VALUES (donor_id, blood_group, CURDATE(), units_donated);
END $$

DELIMITER ;

-- Read Donations by Donor
DELIMITER $$

CREATE PROCEDURE get_donations_by_donor(
    IN donor_id INT
)
BEGIN
    SELECT * FROM donation_history
    WHERE donor_id = donor_id
    ORDER BY donation_date DESC;
END $$

DELIMITER ;

-- Update Donation
DELIMITER $$

CREATE PROCEDURE update_donation(
    IN donation_id INT, 
    IN units_donated INT
)
BEGIN
    UPDATE donation_history
    SET units_donated = units_donated
    WHERE donation_id = donation_id;
END $$

DELIMITER ;

-- Delete Donation
DELIMITER $$

CREATE PROCEDURE delete_donation(
    IN donation_id INT
)
BEGIN
    DELETE FROM donation_history
    WHERE donation_id = donation_id;
END $$

DELIMITER ;

-- CRUD Operations for Blood Requests

-- Create Blood Request
DELIMITER $$

CREATE PROCEDURE create_blood_request(
    IN recipient_name VARCHAR(100), 
    IN recipient_blood_group VARCHAR(10), 
    IN units_required INT, 
    IN hospital_name VARCHAR(100)
)
BEGIN
    INSERT INTO blood_request (recipient_name, recipient_blood_group, units_required, hospital_name, request_status)
    VALUES (recipient_name, recipient_blood_group, units_required, hospital_name, 'Pending');
END $$

DELIMITER ;

-- Read Blood Requests by Status
DELIMITER $$

CREATE PROCEDURE get_blood_requests(
    IN status VARCHAR(10)
)
BEGIN
    SELECT * FROM blood_request
    WHERE request_status = status
    ORDER BY request_date DESC;
END $$

DELIMITER ;

-- Update Blood Request Status
DELIMITER $$

CREATE PROCEDURE update_blood_request_status(
    IN request_id INT, 
    IN status VARCHAR(10)
)
BEGIN
    UPDATE blood_request
    SET request_status = status
    WHERE request_id = request_id;
END $$

DELIMITER ;

-- Delete Blood Request
DELIMITER $$

CREATE PROCEDURE delete_blood_request(
    IN request_id INT
)
BEGIN
    DELETE FROM blood_request
    WHERE request_id = request_id;
END $$

DELIMITER ;