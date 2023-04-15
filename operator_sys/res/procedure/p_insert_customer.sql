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
-- CALL insert_customer(1,'Tom', 'address', '123456', 'male', '2222-2-22');
-- SELECT * FROM customer;