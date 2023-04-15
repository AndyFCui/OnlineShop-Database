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

-- INSERT PART;


-- insert customer
DROP PROCEDURE IF EXISTS insert_customer;

DELIMITER //
CREATE PROCEDURE insert_customer(
  IN p_customer_id INT,
  IN p_name VARCHAR(50),
  IN p_address VARCHAR(50),
  IN p_phone_number VARCHAR(50),
  IN p_legal_sex VARCHAR(50),
  IN p_date_of_birth DATE
  )
BEGIN
  INSERT INTO customer (
    customer_id, name, address, phone_number, legal_sex, date_of_birth
  ) VALUES (
    p_customer_id, p_name, p_address, p_phone_number, p_legal_sex, p_date_of_birth
  );
END //

DELIMITER ;
-- TEST
-- Call register_customer(1, 'John Smith', '123 Main St', 5551234, 'Male', '1980-01-01', 1, 123456);
-- SELECT * from customer;

-- insert credit card
DROP PROCEDURE IF EXISTS insert_credit_card;

DELIMITER  //
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
    )
    VALUES (
    card_number,
    expiration_date,
    cardholder_name,
    billing_address,
    customer_id);
END//

DELIMITER ;
-- TEST
-- SELECT * FROM credit_card;

-- insert robot
DROP PROCEDURE IF EXISTS insert_goods;

DELIMITER //
CREATE PROCEDURE insert_goods (
    IN goods_id int,
    IN instock varchar(50),
    IN produced_date date,
    IN software_edition VARCHAR(50),
    IN purchased_cost int,
    IN model_id int
    )
BEGIN
    INSERT INTO robot (goods_id, instock, produced_date, software_edition, purchased_cost, model_id) 
    VALUES (goods_id, instock, produced_date, software_edition, purchased_cost, model_id);
END//

DELIMITER ;
-- TEST
-- CALL insert_robot ('3000','instock', '2018-09-02', 'Falcon 0.1', 300, 336200);
-- SELECT * FROM robot;

-- software 
DROP PROCEDURE IF EXISTS insert_software_edition;

DELIMITER  //
CREATE PROCEDURE insert_software_edition(
	IN edition VARCHAR(50),
    IN description VARCHAR(50),
    IN release_date date
    )
BEGIN
	INSERT INTO software_edition(edition, description, release_date)
    VALUES (edition, description, release_date);
END //
DELIMITER ;
-- TEST
-- CALL insert_software_edition('Galaxy 0.1', 'New software designed for excellent robot', '2018-12-01');
-- SELECT * FROM software_edition;

-- insert Robot model
DROP PROCEDURE IF EXISTS insert_robot_model;

DELIMITER  //
CREATE PROCEDURE insert_robot_model(
	IN model_id int,
    IN model_name varchar(50)
    )
BEGIN
	INSERT INTO robot_model(model_id, model_name)
    VALUES (model_id, model_name);
END//
DELIMITER ;
-- TEST
-- CALL insert_robot_model(428910, 'Maru');
-- SELECT * FROM robot;

-- Create Order
DROP PROCEDURE IF EXISTS order_create;

DELIMITER  //
CREATE PROCEDURE order_create(
    IN order_date date,
    IN order_status varchar(50),
    IN deliver_preference varchar(50),
    IN operator_id int, 
    IN customer_name VARCHAR(50)
    )
BEGIN
 DECLARE order_no, customer_no INT;
    SELECT COUNT(*)+1 FROM robot_order INTO order_no;
    SELECT customer_id FROM customer WHERE name = customer_name;
 INSERT INTO robot_order(order_id, order_date, order_status, deliver_preference, operator_id, customer_id)
    VALUES (order_no, order_date, order_status, deliver_preference, operator_id, customer_no);
END//
DELIMITER ;
-- TEST
-- SELECT * FROM robot_order

-- Fill Order detail
DROP PROCEDURE IF EXISTS order_fill;

DELIMITER  //
CREATE PROCEDURE order_fill(
	IN order_id int,
    IN goods_id int,
    IN sales_price int
    )
BEGIN
	INSERT INTO order_detail(order_id, goods_id, sales_price)
    VALUES (order_id, goods_id, sales_price);
END//
DELIMITER ;


-- UPDATE PART;


-- Robot

-- update stock
DROP PROCEDURE IF EXISTS update_goods_stock;
DELIMITER  //
CREATE PROCEDURE update_goods_stock(
	IN u_goods_id int,
    IN instock_change varchar(50)
)
BEGIN
	DECLARE indicate_goods varchar(50);
    SELECT COUNT(*)
    FROM robot
    where goods_id = u_goods_id
    INTO indicate_goods;
    IF indicate_goods = 0 THEN
		SIGNAL SQLSTATE '59999' SET MESSAGE_TEXT = 'There is no such goods ';
	ELSEIF (SELECT instock from robot WHERE goods_id = u_goods_id) = instock_change THEN
		SIGNAL SQLSTATE '59998' SET MESSAGE_TEXT = 'The stock already has this new status';
    ELSE
		UPDATE robot SET instock = instock_change WHERE goods_id = u_goods_id;
    END IF;
END//
DELIMITER ;
-- TEST
-- SELECT * FROM robot;
-- CALL update_goods_stock(300,'sold out');

-- Customer

-- update customer name
DROP PROCEDURE IF EXISTS update_customer_name;
DELIMITER  //
CREATE PROCEDURE update_customer_name(
	IN customer_name varchar(50),
    IN new_name varchar(50)
)
BEGIN
	DECLARE indicate_customer INT;
    SELECT COUNT(*)
    FROM customer
    where name = customer_name
    INTO indicate_customer;
    IF indicate_customer = 0 THEN
		SIGNAL SQLSTATE '60000' SET MESSAGE_TEXT = 'There is no such customer';
	ELSE
		UPDATE customer SET name = new_name WHERE name = customer_name;
    END IF;
END//
DELIMITER ;

-- update customer address
DROP PROCEDURE IF EXISTS update_customer_address;
DELIMITER  //
CREATE PROCEDURE update_customer_address(
	IN customer_name varchar(50),
    IN new_address varchar(50)
)
BEGIN
	DECLARE indicate_customer INT;
    SELECT COUNT(*)
    FROM customer
    where name = customer_name
    INTO indicate_customer;
    IF indicate_customer = 0 THEN
		SIGNAL SQLSTATE '60000' SET MESSAGE_TEXT = 'There is no such customer';
	ELSE
		UPDATE customer SET address = new_address WHERE name = customer_name;
    END IF;
END//
DELIMITER ;

-- update customer phone_number
DROP PROCEDURE IF EXISTS update_customer_phone_number;
DELIMITER  //
CREATE PROCEDURE update_customer_phone_number(
	IN customer_name varchar(50),
    IN new_number varchar(50)
)
BEGIN
	DECLARE indicate_customer INT;
    SELECT COUNT(*)
    FROM customer
    where name = customer_name
    INTO indicate_customer;
    IF indicate_customer = 0 THEN
		SIGNAL SQLSTATE '60000' SET MESSAGE_TEXT = 'There is no such customer';
	ELSE
		UPDATE customer SET phone_number = new_number WHERE name = customer_name;
    END IF;
END//
DELIMITER ;

-- Operator

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
		UPDATE operator SET name = new_name WHERE name = operator_name;
    END IF;
END//
DELIMITER ;

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
		UPDATE operator SET address = new_address WHERE name = operator_name;
    END IF;
END//
DELIMITER ;

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
		UPDATE operator SET phone_number = new_phone WHERE name = operator_name;
    END IF;
END//
DELIMITER ;

-- update user_id
DROP PROCEDURE IF EXISTS update_operator_user_id;
DELIMITER  //
CREATE PROCEDURE update_operator_user_id(
	IN operator_name varchar(50),
    IN new_user_id INT
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
		UPDATE operator SET user_id = new_user_id WHERE name = operator_name;
    END IF;
END//
DELIMITER ;

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
		UPDATE operator SET user_password = new_user_password WHERE name = operator_name;
    END IF;
END//
DELIMITER ;

-- DELETE PART

-- delete customer
DROP PROCEDURE IF EXISTS delete_customer;
DELIMITER  //
CREATE PROCEDURE delete_customer(
    IN for_delete_id int
)
BEGIN
	DELETE FROM customer
    where customer_id = for_delete_id;
END//
DELIMITER ;

-- delete operator
DROP PROCEDURE IF EXISTS operater_delete;
DELIMITER  //
CREATE PROCEDURE operater_delete(
    IN for_delete_id int
)
BEGIN
	DELETE FROM operator
    where operator_id = for_delete_id;
END//
DELIMITER ;

-- delete order_detail
DROP PROCEDURE IF EXISTS orderdetail_delete;
DELIMITER  //
CREATE PROCEDURE orderdetail_delete(
    IN delete_order_id int,
    IN delete_goods_id int
)
BEGIN
	DELETE FROM order_detail
    where order_id = delete_order_id 
    and goods_id = delete_goods_id;
END//
DELIMITER ;

-- delete robot
DROP PROCEDURE IF EXISTS delete_goods;
DELIMITER  //
CREATE PROCEDURE delete_goods(
	IN delete_goods_id INT
) 
BEGIN
	DELETE FROM robot
    where goods_id = delete_goods_id;
END//
DELIMITER ;

-- delete model
DROP PROCEDURE IF EXISTS delete_model;
DELIMITER  //
CREATE PROCEDURE delete_model(
    IN delete_model_id int
)
BEGIN
	DELETE FROM robot_model
    where model_id = delete_model_id;
END//
DELIMITER ;

-- delete order
DROP PROCEDURE IF EXISTS order_delete;
DELIMITER  //
CREATE PROCEDURE order_delete(
	IN delete_order_id INT
)
BEGIN
	DELETE FROM order_detail
    WHERE order_id = delete_order_id;    
    DELETE FROM robot_order
    WHERE order_id = delete_order_id;
END//
DELIMITER ;

-- delete software
DROP PROCEDURE IF EXISTS delete_software;
DELIMITER  //
CREATE PROCEDURE delete_software(
    IN for_delete_edition varchar(50)
)
BEGIN
	DELETE FROM software_edition
    where edition = for_delete_edition;
END//
DELIMITER ;

-- Return order Part


-- return payment
DROP PROCEDURE IF EXISTS return_payment;
DELIMITER  //
CREATE PROCEDURE return_confirm(
	IN return_order_id int,
    IN return_goods_id int
)
BEGIN
	UPDATE order_detail SET return_status = "payment return" where order_id = return_id and goods_id = return_goods_id;
    UPDATE robot_order SET order_status = "has goods to return" WHERE order_id = return_order_id;
END//
DELIMITER ;

-- return payment and goods
DROP PROCEDURE IF EXISTS return_payment_and_goods;
DELIMITER  //
CREATE PROCEDURE return_payment_and_goods(
	IN return_order_id int,
    IN return_goods_id int
)
BEGIN
	UPDATE order_detail SET return_status = "payment and goods return" where order_id = return_id and goods_id = return_goods_id;
    UPDATE robot_order SET order_status = "has goods and payment to return" WHERE order_id = return_order_id;
END//
DELIMITER ;

-- exchange
DROP PROCEDURE IF EXISTS exchange;
DELIMITER  //
CREATE PROCEDURE return_payment_and_goods(
	IN return_order_id int,
    IN return_goods_id int
)
BEGIN
	UPDATE order_detail SET return_status = "need to exchange" where order_id = return_id and goods_id = return_goods_id;
    UPDATE robot_order SET order_status = "has goods to exchange" WHERE order_id = return_order_id;
END//
DELIMITER ;


-- return denied
DROP PROCEDURE IF EXISTS return_denied;
DELIMITER  //
CREATE PROCEDURE return_denied(
	IN return_order_id int,
    IN return_goods_id int
)
BEGIN
	UPDATE order_detail SET return_status = "return denied" where order_id = return_id and goods_id = return_goods_id;
    UPDATE robot_order SET order_status = "return denied" WHERE order_id = return_order_id;    
END//
DELIMITER ;

-- check all procedure
SHOW PROCEDURE STATUS where db = 'rbstore';
