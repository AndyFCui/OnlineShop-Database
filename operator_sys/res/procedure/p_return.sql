use rbstore;
##########################################################################
-- return payment
DROP PROCEDURE IF EXISTS return_payment;
DELIMITER  //
CREATE PROCEDURE return_payment(
	IN return_order_id int,
    IN return_goods_id int
)
BEGIN
	DECLARE nowdate, buy_date date;
    DECLARE message varchar(50);
    DECLARE gap int;
    SELECT CURDATE() into nowdate;
    SELECT order_date from robot_order where order_id = return_order_id into buy_date;
    SELECT TIMESTAMPDIFF(DAY, buy_date, now_date) into gap;
    IF gap <16 THEN
    UPDATE order_detail SET return_status = "payment return" where order_id = return_order_id and goods_id = return_goods_id;
    UPDATE robot_order SET order_status = "has goods to return" WHERE order_id = return_order_id;
	SET message = 'Return request success';
    ELSE
	UPDATE order_detail SET return_status = "return denied" where order_id = return_order_id and goods_id = return_goods_id;
    UPDATE robot_order SET order_status = "return denied" WHERE order_id = return_order_id;
    SET message = 'Return request expired';
    END IF;
    SELECT message;
END//
DELIMITER ;
-- TEST 
-- DELIMITER  //
-- -- CALL order_create('2023-04-15', 'Order', 'regular', 1, 'Tom');
-- -- CALL order_fill(2, 3000, 500);
-- CALL return_payment(1, 4000);
-- SELECT * FROM order_detail;
-- SELECT * FROM robot_order//
-- DELIMITER ;
-- SELECT * from robot;

-- return payment and goods
DROP PROCEDURE IF EXISTS return_payment_and_goods;
DELIMITER  //
CREATE PROCEDURE return_payment_and_goods(
	IN return_order_id int,
    IN return_goods_id int
)
BEGIN
	DECLARE nowdate, buy_date date;
	DECLARE message varchar(50);
    DECLARE gap int;
    SELECT CURDATE() into nowdate;
    SELECT order_date from robot_order where order_id = return_order_id into buy_date;
    SELECT TIMESTAMPDIFF(DAY, buy_date, now_date) into gap;
    IF gap <16 THEN
    UPDATE order_detail SET return_status = "payment and goods return" where order_id = return_order_id and goods_id = return_goods_id;
    UPDATE robot_order SET order_status = "has goods and payment to return" WHERE order_id = return_order_id;
	SET message = 'Return request success';
    ELSE
	UPDATE order_detail SET return_status = "return denied" where order_id = return_order_id and goods_id = return_goods_id;
    UPDATE robot_order SET order_status = "return denied" WHERE order_id = return_order_id;
    SET message = 'Return request expired';
    END IF;
    SELECT message;
END//
DELIMITER ;
-- TEST
-- CALL return_payment_and_goods(1,4000);
-- DELIMITER  //
-- SELECT * FROM order_detail;
-- SELECT * FROM robot_order//
-- DELIMITER ;

-- exchange
DROP PROCEDURE IF EXISTS return_exchange;
DELIMITER  //
CREATE PROCEDURE return_exchange(
	IN return_order_id int,
    IN return_goods_id int
)
BEGIN
	DECLARE nowdate, buy_date date;
	DECLARE message varchar(50);
    DECLARE gap int;
    SELECT CURDATE() into nowdate;
    SELECT order_date from robot_order where order_id = return_order_id into buy_date;
    SELECT TIMESTAMPDIFF(DAY, buy_date, now_date) into gap;
    IF gap <16 THEN
    UPDATE order_detail SET return_status = "need to exchange" where order_id = return_order_id and goods_id = return_goods_id;
    UPDATE robot_order SET order_status = "has goods to exchange" WHERE order_id = return_order_id;
	SET message = 'Return request success';
    ELSE
	UPDATE order_detail SET return_status = "return denied" where order_id = return_order_id and goods_id = return_goods_id;
    UPDATE robot_order SET order_status = "return denied" WHERE order_id = return_order_id;
    SET message = 'Return request expired';
    END IF;
    SELECT message;
END//
DELIMITER ;
-- TEST
-- CALL return_exchange(1,4000);
-- DELIMITER  //
-- SELECT * FROM order_detail;
-- SELECT * FROM robot_order//
-- DELIMITER ;
