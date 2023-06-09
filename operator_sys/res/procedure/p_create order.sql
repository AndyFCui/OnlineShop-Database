use rbstore;
##########################################################################
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
SELECT * from customer;
CALL order_create('2018-09-01', 'test', 'test', 6, 'him');
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