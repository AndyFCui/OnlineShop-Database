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
    SELECT customer_id FROM customer WHERE name = customer_name into customer_no;
 INSERT INTO robot_order(order_id, order_date, order_status, deliver_preference, operator_id, customer_id)
    VALUES (order_no, order_date, order_status, deliver_preference, operator_id, customer_no);
    SELECT order_no;
END//
DELIMITER ;
-- TEST
-- CALL order_create('2222-02-22', 'Order', 'regular', 1, 'Tom');
-- SELECT * FROM robot_order;

-- Fill Order detail
DROP PROCEDURE IF EXISTS order_fill;

DELIMITER  //
CREATE PROCEDURE order_fill(
	IN order_id int,
    IN in_goods_id int,
    IN sales_price int
    )
BEGIN
	INSERT INTO order_detail(order_id, goods_id, sales_price)
    VALUES (order_id, in_goods_id, sales_price);
    UPDATE robot SET instock = 'sold' where goods_id = in_goods_id LIMIT 1;
END//
DELIMITER ;
-- TEST
-- CALL order_fill(7, 4000, 500);
-- SELECT * from order_detail where order_id = 2;

-- View order
DROP PROCEDURE IF EXISTS view_order;
DELIMITER  //
CREATE PROCEDURE view_order(
	IN in_order_id int
)
BEGIN
    SELECT * 
    FROM robot_order 
    where order_id = in_order_id;
END//
DELIMITER ;
-- TEST
-- CALL view_order(1);