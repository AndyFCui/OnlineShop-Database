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

-- Create guest acount for creating account
DROP PROCEDURE IF EXISTS default_account;
DELIMITER $$
CREATE PROCEDURE default_account() 
BEGIN
	CREATE USER 'default_account'@'localhost' IDENTIFIED BY 'rbstore_guest';
	GRANT CREATE USER ON *.* TO 'default_account'@'localhost';
    GRANT SELECT ON *.* TO 'default_account'@'localhost';
    FLUSH PRIVILEGES;
END$$
DELIMITER ;

-- Test
CALL default_account();
SELECT user, host FROM mysql.user;
-- DROP USER 'default_account'@'localhost';
