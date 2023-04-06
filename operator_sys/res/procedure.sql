use rbstore;

DELIMITER //
DROP PROCEDURE IF EXISTS signup_customer;
CREATE PROCEDURE signup_customer(
  IN p_customer_id INT,
  IN p_name VARCHAR(50),
  IN p_address VARCHAR(50),
  IN p_phone_number INT,
  IN p_legal_sex VARCHAR(50),
  IN p_date_of_birth DATE,
  IN p_user_id INT,
  IN p_user_password INT
)
BEGIN
  INSERT INTO Customer (
    customer_id, name, address, phone_number, legal_sex, date_of_birth, user_id, user_password
  ) VALUES (
    p_customer_id, p_name, p_address, p_phone_number, p_legal_sex, p_date_of_birth, p_user_id, p_user_password
  );
END //

DELIMITER ;
-- TEST
-- Call signup_customer(1, 'John Smith', '123 Main St', 5551234, 'Male', '1980-01-01', 1, 123456);
-- SELECT * from Customer;

DELIMITER  //
DROP PROCEDURE IF EXISTS insert_credit_card;
CREATE PROCEDURE insert_credit_card (
  IN card_number VARCHAR(16),
  IN expiration_date DATE,
  IN cardholder_name VARCHAR(255),
  IN billing_address VARCHAR(255),
  IN customer_id INT
)
BEGIN
  INSERT INTO credit_cards (
    card_number,
    expiration_date,
    cardholder_name,
    billing_address,
    customer_id
  ) VALUES (
    card_number,
    expiration_date,
    cardholder_name,
    billing_address,
    customer_id
  );
END//
DELIMITER ;

-- ##########################################################################
-- ##########################################################################
-- Create guest acount for creating account
DROP PROCEDURE IF EXISTS default_account;
DELIMITER $$
CREATE PROCEDURE default_account() 
BEGIN
	-- Create user 
	CREATE USER 'default_account'@'localhost' IDENTIFIED BY 'rbstore_guest';
	-- Grant privileges
    GRANT CREATE USER ON *.* TO 'default_account'@'localhost';
    GRANT SELECT ON *.* TO 'default_account'@'localhost';
    FLUSH PRIVILEGES;
    
    -- Insert the username into the user_info table
    INSERT INTO operator_id VALUES ('default_account');
END$$
DELIMITER ;

-- Test
CALL default_account();

SELECT user, host FROM mysql.user;
SELECT * FROM Operator;
DROP USER 'test'@'localhost';


/*
Signup a new account. 
*/
-- Create the new user_id
DROP PROCEDURE IF EXISTS create_account;

DELIMITER $$
CREATE PROCEDURE create_account(
    IN user_id VARCHAR(50),
    IN user_password VARCHAR(50),
    IN operator_name VARCHAR(50),
    IN operator_address VARCHAR(50),
    IN operator_phone_number VARCHAR(50),
    IN operator_legal_sex VARCHAR(50),
    IN operator_date_of_birth DATE
)
BEGIN
	DECLARE operator_no INT;
    SELECT COUNT(*)+1 FROM Operator INTO operator_no;
    
	-- Create user 
    SET @sql = CONCAT(
		"CREATE USER '", 
        user_id, 
        "'@'localhost' IDENTIFIED BY '", 
        user_password, 
        "';"
        );
    PREPARE stmt FROM @sql;
    EXECUTE stmt;
    DEALLOCATE PREPARE stmt;
    
    -- Grant privileges
    SET @sql_grant = CONCAT("GRANT SELECT, INSERT, UPDATE, DELETE ON rbstore.* TO '", user_id, "'@'localhost';");
    PREPARE stmt_grant FROM @sql_grant;
    EXECUTE stmt_grant;
    DEALLOCATE PREPARE stmt_grant;
    
	FLUSH PRIVILEGES;
    
    -- Insert the new user into the Operator table
    INSERT INTO Operator (
		operator_id,
        name, 
        address, 
        phone_number, 
        legal_sex, 
        date_of_birth, 
        user_id, 
        user_password
    ) VALUES (
		operator_no,
        operator_name, 
        operator_address, 
        operator_phone_number, 
        operator_legal_sex, 
        operator_date_of_birth, 
        user_id, 
        user_password
    );
END$$
DELIMITER ;
-- ##################################################


-- ##################################################
-- # Delete account by operator_id                  #
-- ##################################################
DROP PROCEDURE IF EXISTS delete_account_by_operator_id;

DELIMITER $$
CREATE PROCEDURE delete_account_by_operator_id(IN target_operator_id INT)
BEGIN
    -- Find the corresponding user_id
    DECLARE target_user_id VARCHAR(50);
    SELECT user_id INTO target_user_id FROM Operator WHERE operator_id = target_operator_id;

    -- Delete the record from the Operator table
    DELETE FROM Operator WHERE operator_id = target_operator_id;

    -- Drop the user
    SET @sql = CONCAT(
        "DROP USER '", 
        target_user_id, 
        "'@'localhost';"
        );
    PREPARE stmt FROM @sql;
    EXECUTE stmt;
    DEALLOCATE PREPARE stmt;

    FLUSH PRIVILEGES;
END$$
DELIMITER ;
-- ##################################################


CALL delete_account_by_operator_id(0);

-- CALL create_account('andy', '123123')
-- SHOW GRANTS FOR 'test'@'localhost';

-- Check the user exist or not
-- DROP FUNCTION IF EXISTS check_user();

SHOW PROCEDURE STATUS where db = 'rbstore';
SELECT * FROM Operator;
