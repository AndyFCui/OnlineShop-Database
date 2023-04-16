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
	UPDATE order_detail SET return_status = "payment return" where order_id = return_order_id and goods_id = return_goods_id;
    UPDATE robot_order SET order_status = "has goods to return" WHERE order_id = return_order_id;
END//
DELIMITER ;
-- TEST
-- CALL return_payment(1,4000);
-- DELIMITER  //
-- SELECT * FROM order_detail;
-- SELECT * FROM robot_order//
-- DELIMITER ;

-- return payment and goods
DROP PROCEDURE IF EXISTS return_payment_and_goods;
DELIMITER  //
CREATE PROCEDURE return_payment_and_goods(
	IN return_order_id int,
    IN return_goods_id int
)
BEGIN
	UPDATE order_detail SET return_status = "payment and goods return" where order_id = return_order_id and goods_id = return_goods_id;
    UPDATE robot_order SET order_status = "has goods and payment to return" WHERE order_id = return_order_id;
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
	UPDATE order_detail SET return_status = "need to exchange" where order_id = return_order_id and goods_id = return_goods_id;
    UPDATE robot_order SET order_status = "has goods to exchange" WHERE order_id = return_order_id;
END//
DELIMITER ;
-- TEST
-- CALL return_exchange(1,4000);
-- DELIMITER  //
-- SELECT * FROM order_detail;
-- SELECT * FROM robot_order//
-- DELIMITER ;

-- return denied
DROP PROCEDURE IF EXISTS return_denied;
DELIMITER  //
CREATE PROCEDURE return_denied(
	IN return_order_id int,
    IN return_goods_id int
)
BEGIN
	UPDATE order_detail SET return_status = "return denied" where order_id = return_order_id and goods_id = return_goods_id;
    UPDATE robot_order SET order_status = "return denied" WHERE order_id = return_order_id;    
END//
DELIMITER ;
-- TEST
-- CALL return_denied(1,4000);
-- DELIMITER  //
-- SELECT * FROM order_detail;
-- SELECT * FROM robot_order//
-- DELIMITER ;

-- return cancel
DROP PROCEDURE IF EXISTS return_cancel;
DELIMITER  //
CREATE PROCEDURE return_cancel(
	IN return_order_id int,
    IN return_goods_id int
)
BEGIN
	UPDATE order_detail SET return_status = "None" where order_id = return_order_id and goods_id = return_goods_id;
    UPDATE robot_order SET order_status = "Order" WHERE order_id = return_order_id;    
END//
DELIMITER ;
-- TEST
-- CALL return_cancel(1,4000);
-- DELIMITER  //
-- SELECT * FROM order_detail;
-- SELECT * FROM robot_order//
-- DELIMITER ;
