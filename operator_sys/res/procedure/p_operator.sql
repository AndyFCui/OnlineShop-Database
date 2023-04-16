use rbstore;
##########################################################################
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
# CALL default_account();

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

-- Get id for operator
DROP PROCEDURE IF EXISTS get_id;
-- get id from name
DELIMITER //
CREATE PROCEDURE get_id(
	IN operator_name varchar(50),
    OUT get_operator_id INT
)
BEGIN
 SELECT operator_id 
    FROM operator
    where name = operator_name
    INTO get_operator_id;
END//
DELIMITER ;



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

-- GET ID FROM INPUT OPERATOR NAME
DROP PROCEDURE IF EXISTS get_id;
-- get id from name
DELIMITER //
CREATE PROCEDURE get_id(
	IN operator_name INT,
    OUT get_operator_id INT
)
BEGIN
	SELECT operator_id 
    FROM operator
    where name = operator_name
    INTO get_operator_id;
END//
DELIMITER ;
-- TEST
--     INSERT INTO Operator (
-- 		operator_id,
--         name, 
--         address, 
--         phone_number, 
--         legal_sex, 
--         date_of_birth, 
--         user_id, 
--         user_password
--     ) VALUES (1,
--         'tom', 
--         'neu', 
--         '123123', 
--         'male', 
--         '2023-02-16', 
--         'tom', 
--         '123123'
--     );
-- SELECT * FROM operator;

-- update name
DROP PROCEDURE IF EXISTS update_operator_name;
DELIMITER  //
CREATE PROCEDURE update_operator_name(
	IN operator_name varchar(50),
    IN new_name varchar(50)
)
BEGIN
	DECLARE indicate_operator INT;
    SELECT COUNT(*)
    FROM operator
    where name = operator_name
    INTO indicate_operator;
    IF indicate_operator = 0 THEN
		SIGNAL SQLSTATE '60000' SET MESSAGE_TEXT = 'There is no such operator';
	ELSE
		UPDATE operator SET name = new_name WHERE name = operator_name LIMIT 1;
    END IF;
END//
DELIMITER ;
-- TEST
-- CALL update_operator_name('tom', 'Jerry');
-- SELECT * from operator;
-- CALL update_operator_name('Jerry', 'tom');

-- update address
DROP PROCEDURE IF EXISTS update_operator_address;
DELIMITER  //
CREATE PROCEDURE update_operator_address(
	IN operator_name varchar(50),
    IN new_address varchar(50)
)
BEGIN
	DECLARE indicate_operator INT;
    SELECT COUNT(*)
    FROM operator
    where name = operator_name
    INTO indicate_operator;
    IF indicate_operator = 0 THEN
		SIGNAL SQLSTATE '60000' SET MESSAGE_TEXT = 'There is no such operator';
	ELSE
		UPDATE operator SET address = new_address WHERE name = operator_name LIMIT 1;
    END IF;
END//
DELIMITER ;
-- TEST
-- CALL update_operator_address('tom', 'mit');
-- SELECT * from operator;
-- CALL update_operator_address('tom', 'neu');

-- update phone number
DROP PROCEDURE IF EXISTS update_operator_phone;
DELIMITER  //
CREATE PROCEDURE update_operator_phone(
	IN operator_name varchar(50),
    IN new_phone varchar(50)
)
BEGIN
	DECLARE indicate_operator INT;
    SELECT COUNT(*)
    FROM operator
    where name = operator_name
    INTO indicate_operator;
    IF indicate_operator = 0 THEN
		SIGNAL SQLSTATE '60000' SET MESSAGE_TEXT = 'There is no such operator';
	ELSE
		UPDATE operator SET phone_number = new_phone WHERE name = operator_name LIMIT 1;
    END IF;
END//
DELIMITER ;
-- TEST
-- CALL update_operator_phone('tom', '321321');
-- SELECT * from operator;
-- CALL update_operator_phone('tom', '123123');

-- update user_id
DROP PROCEDURE IF EXISTS update_operator_user_id;
DELIMITER  //
CREATE PROCEDURE update_operator_user_id(
	IN operator_name varchar(50),
    IN new_user_id varchar(50)
)
BEGIN
	DECLARE indicate_operator INT;
    SELECT COUNT(*)
    FROM operator
    where name = operator_name
    INTO indicate_operator;
    IF indicate_operator = 0 THEN
		SIGNAL SQLSTATE '60000' SET MESSAGE_TEXT = 'There is no such operator';
	ELSE
		UPDATE operator SET user_id = new_user_id WHERE name = operator_name LIMIT 1;
    END IF;
END//
DELIMITER ;
-- TEST
-- CALL update_operator_user_id('tom', 'peter');
-- SELECT * from operator;
-- CALL update_operator_user_id('tom', 'tom');

-- update user_password
DROP PROCEDURE IF EXISTS update_operator_user_password;
DELIMITER  //
CREATE PROCEDURE update_operator_user_password(
	IN operator_name varchar(50),
    IN new_user_password varchar(50)
)
BEGIN
	DECLARE indicate_operator INT;
    SELECT COUNT(*)
    FROM operator
    where name = operator_name
    INTO indicate_operator;
    IF indicate_operator = 0 THEN
		SIGNAL SQLSTATE '60000' SET MESSAGE_TEXT = 'There is no such operator';
	ELSE
		UPDATE operator SET user_password = new_user_password WHERE name = operator_name LIMIT 1;
    END IF;
END//
DELIMITER ;
-- TEST
CALL update_operator_user_password('tom', 'Lucky');
SELECT * from operator;
CALL update_operator_user_password('tom', '123123');