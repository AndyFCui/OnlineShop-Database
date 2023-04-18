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