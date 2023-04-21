use rbstore;
##########################################################################
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
-- CALL insert_customer(100,'Tom', 'address', '123456', 'male', '2222-02-22');
-- SELECT * FROM customer;
##################################################
-- Update

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
		UPDATE customer SET name = new_name WHERE name = customer_name LIMIT 1;
    END IF;
END//
DELIMITER ;
-- TEST
-- CALL update_customer_name('Tom', 'Jack') ;
-- SELECT * FROM customer;
-- CALL update_customer_name('Jack', 'Tom') ;

-- update customer phone_number
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
		UPDATE customer SET address = new_address WHERE name = customer_name LIMIT 1;
    END IF;
END//
DELIMITER ;
-- TEST
-- CALL update_customer_address('Tom', 'newaddress');
-- SELECT * FROM customer;
-- CALL update_customer_address('Tom', 'address');

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
		UPDATE customer SET phone_number = new_number WHERE name = customer_name LIMIT 1;
    END IF;
END//
DELIMITER ;
-- TEST
-- CALL update_customer_phone_number('Tom', '123123');
-- SELECT * FROM customer;
-- CALL update_customer_phone_number('Tom', '123456');

##################################################
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
-- TEST
CALL delete_customer('1');
SELECT * FROM customer where customer_id = 100;
################################################
-- view customer
DROP PROCEDURE IF EXISTS view_customer;
DELIMITER  //
CREATE PROCEDURE view_customer(
    IN for_view_name varchar(50)
)
BEGIN
	Select * from customer
    where name = for_view_name;
END//
-- TEST
-- CALL view_customer('Tom');