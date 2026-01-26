-- Create databases
CREATE DATABASE IF NOT EXISTS user_db;
CREATE DATABASE IF NOT EXISTS message_db;

-- Use user_db
USE user_db;

-- Create users table
CREATE TABLE IF NOT EXISTS users (
    user_id INT AUTO_INCREMENT PRIMARY KEY,
    first_name VARCHAR(50) NOT NULL,
    last_name VARCHAR(50) NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    password VARCHAR(255) NOT NULL,
    active BOOLEAN DEFAULT TRUE,
    email_verified BOOLEAN DEFAULT FALSE,
    verification_token VARCHAR(255) DEFAULT NULL,
    token_expires_at DATETIME DEFAULT NULL,
    date_joined DATETIME DEFAULT CURRENT_TIMESTAMP,
    type ENUM('visitor', 'unverified', 'normal', 'admin', 'super_admin') DEFAULT 'unverified',
    profile_image_url VARCHAR(500) DEFAULT NULL,
    INDEX idx_email (email),
    INDEX idx_type (type),
    INDEX idx_active (active)
);

-- Insert super admin (password: SuperAdmin123!)
INSERT INTO users (first_name, last_name, email, password, active, email_verified, type) 
VALUES (
    'Super', 
    'Admin', 
    'superadmin@forum.com', 
    '$2b$12$DBmFpG8b9HkIOQQQNN5V0egvy2XauN3Y5EXeGsyPqwX/I8D4FJ3me',
    TRUE, 
    TRUE, 
    'super_admin'
);

-- Use message_db
USE message_db;

-- Create messages table
CREATE TABLE IF NOT EXISTS messages (
    message_id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT DEFAULT NULL,
    email VARCHAR(100) NOT NULL,
    subject VARCHAR(200) NOT NULL,
    message TEXT NOT NULL,
    date_created DATETIME DEFAULT CURRENT_TIMESTAMP,
    status ENUM('open', 'closed') DEFAULT 'open',
    INDEX idx_status (status),
    INDEX idx_date_created (date_created)
);
