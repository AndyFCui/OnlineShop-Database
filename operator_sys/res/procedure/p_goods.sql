use rbstore;
##########################################################################
-- insert robot
DROP PROCEDURE IF EXISTS insert_goods;

DELIMITER //
CREATE PROCEDURE insert_goods (
    IN in_goods_id int,
    IN in_instock varchar(50),
    IN in_produced_date date,
    IN in_software_edition VARCHAR(50),
    IN in_purchased_cost int,
    IN in_model_id int
    )
BEGIN
	DECLARE indicate_goods INT;
    SELECT COUNT(*)
    FROM robot
    where goods_id = in_goods_id
    INTO indicate_goods;
    IF indicate_goods <> 0 THEN
		SIGNAL SQLSTATE '60002' SET MESSAGE_TEXT = 'This goods already exists';
	ELSE    
		INSERT INTO robot (goods_id, instock, produced_date, software_edition, purchased_cost, model_id) 
		VALUES (in_goods_id, in_instock, in_produced_date, in_software_edition, in_purchased_cost, in_model_id);
    END IF;
END//

DELIMITER ;
-- TEST
-- CALL insert_goods ('4000','instock', '2222-02-22', 'Galaxy 0.1', 300, 428910);
-- SELECT * FROM robot;
###########################################################
-- View goods
DELIMITER  //
DROP PROCEDURE IF EXISTS view_goods_status;
CREATE PROCEDURE view_goods_status(
	IN in_goods_id int,
    OUT status varchar(50)
)
BEGIN
    SELECT instock 
    FROM robot 
    where goods_id = in_goods_id
    into status;
END//
DELIMITER ;
-- TEST
-- DELIMITER  //
-- SET @statusn = 'None';
-- CALL view_goods_status(3000, @statusn);
-- SELECT @statusn//
-- DELIMITER ;

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
SELECT * FROM robot;
CALL update_goods_stock(3000,'instock');

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
-- TEST
CALL delete_goods(3000);