use rbstore;
##########################################################################
-- insert Robot model
DROP PROCEDURE IF EXISTS insert_robot_model;

DELIMITER  //
CREATE PROCEDURE insert_robot_model(
	IN in_model_id int,
    IN in_model_name varchar(50)
    )
BEGIN
	DECLARE indicate_model INT;
    SELECT COUNT(*)
    FROM robot_model
    where model_id = in_model_id
    INTO indicate_model;
    IF indicate_model <> 0 THEN
		SIGNAL SQLSTATE '60001' SET MESSAGE_TEXT = 'This model already exists';
	ELSE
		INSERT INTO robot_model(model_id, model_name)
		VALUES (in_model_id, in_model_name);
	END IF;
END//
DELIMITER ;
-- TEST
-- CALL insert_robot_model(428910, 'Maru');
-- SELECT * FROM robot_model;
##########################################################################
-- delete model
DROP PROCEDURE IF EXISTS delete_robot_model;
DELIMITER  //
CREATE PROCEDURE delete_robot_model(
    IN delete_model_id int
)
BEGIN
	DELETE FROM robot_model
    where model_id = delete_model_id;
END//
DELIMITER ;
-- TEST
-- CALL delete_robot_model(428910);
-- SELECT COUNT(*) FROM robot_model where model_id = 428910;