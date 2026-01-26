-- Migration script to add pending_email column to users table
-- This script is safe to run multiple times (idempotent)

USE user_db;

-- Check if column exists before adding (MySQL 8.0+)
-- If column doesn't exist, add it
SET @dbname = DATABASE();
SET @tablename = 'users';
SET @columnname = 'pending_email';
SET @preparedStatement = (SELECT IF(
    (
        SELECT COUNT(*) FROM INFORMATION_SCHEMA.COLUMNS
        WHERE
            (TABLE_SCHEMA = @dbname)
            AND (TABLE_NAME = @tablename)
            AND (COLUMN_NAME = @columnname)
    ) > 0,
    'SELECT 1', -- Column exists, do nothing
    CONCAT('ALTER TABLE ', @tablename, ' ADD COLUMN ', @columnname, ' VARCHAR(100) NULL')
));
PREPARE alterIfNotExists FROM @preparedStatement;
EXECUTE alterIfNotExists;
DEALLOCATE PREPARE alterIfNotExists;
