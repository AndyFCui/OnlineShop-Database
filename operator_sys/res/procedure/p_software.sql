use rbstore;
##########################################################################
-- insert software 
DROP PROCEDURE IF EXISTS insert_software_edition;

DELIMITER  //
CREATE PROCEDURE insert_software_edition(
	IN in_edition VARCHAR(50),
    IN description VARCHAR(50),
    IN release_date date
    )
BEGIN
	DECLARE indicate_software INT;
    SELECT COUNT(*)
    FROM software_edition
    where edition = in_edition
    INTO indicate_software;
    IF indicate_software <> 0 THEN
		SIGNAL SQLSTATE '60002' SET MESSAGE_TEXT = 'This software already exists';
	ELSE
		INSERT INTO software_edition(edition, description, release_date)
		VALUES (in_edition, description, release_date);
    END IF;
END //
DELIMITER ;
-- TEST
-- CALL insert_software_edition('Galaxy 0.1', 'New software designed for excellent robot', '2022-02-22');
-- SELECT COUNT(*) FROM software_edition where edition = 'Galaxy 0.1';
#####################################################################
-- delete software
DROP PROCEDURE IF EXISTS delete_software;
DELIMITER  //
CREATE PROCEDURE delete_software(
    IN for_delete_edition varchar(50)
)
BEGIN
	DELETE FROM software_edition
    where edition = for_delete_edition;
END//
DELIMITER ;
-- TEST 
-- CALL delete_software('Galaxy 0.1');
-- SELECT COUNT(*) FROM software_edition where edition = 'Galaxy 0.1';
###################################################################
-- view software
DROP PROCEDURE IF EXISTS view_software;
DELIMITER  //
CREATE PROCEDURE view_software(
	IN in_edition varchar(50)
)
BEGIN
    SELECT * 
    FROM software_edition 
    where edition = in_edition;
END//
DELIMITER ;
-- TEST
-- CALL view_software('Galaxy 0.1');
