use rbstore;
-- check all procedure
SHOW PROCEDURE STATUS where db = 'rbstore';

DROP PROCEDURE IF EXISTS register_customer;

DELIMITER //
CREATE PROCEDURE register_customer(
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
  INSERT INTO customer (
    customer_id, name, address, phone_number, legal_sex, date_of_birth, user_id, user_password
  ) VALUES (
    p_customer_id, p_name, p_address, p_phone_number, p_legal_sex, p_date_of_birth, p_user_id, p_user_password
  );
END //

DELIMITER ;
-- TEST
-- Call register_customer(1, 'John Smith', '123 Main St', 5551234, 'Male', '1980-01-01', 1, 123456);
-- SELECT * from customer;
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
DROP PROCEDURE IF EXISTS insert_robot;

DELIMITER //
CREATE PROCEDURE insert_robot (
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
-- CALL insert_robot ('3000','Spot', '2018-09-02', 'Falcon 0.1', 300, 336200);
-- SELECT * FROM robot;
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