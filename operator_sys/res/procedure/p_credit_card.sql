use rbstore;
##########################################################################
-- Insert credit card
DROP PROCEDURE IF EXISTS insert_credit_card;
DELIMITER  //
CREATE PROCEDURE insert_credit_card(
	IN in_customername varchar(50),
    IN in_creditcard_no varchar(50),
    IN cardtype varchar(50),
    IN expiration_date date
)
BEGIN
	DECLARE custid int;
    SELECT customer_id
    FROM customer
    WHERE name = in_customername
    into custid;
    INSERT INTO credit_card(
    card_number, 
    type, 
    expiration_date, 
    customer_id)VALUES(
    in_creditcard_no,
    cardtype,
    expiration_date,
    custid
    );
END//
DELIMITER ;
-- TEST
-- CALL insert_credit_card('tom','1234554321', 'visa', '2024-09-10');
-- CALL insert_credit_card('tom','987654321', 'Mastercard', '2024-11-10');
-- SELECT * FROM credit_card;

-- view card
DROP PROCEDURE IF EXISTS view_card;
DELIMITER  //
CREATE PROCEDURE view_card(
	IN in_customername varchar(50)
)
BEGIN
	SELECT cr.*, cu.name
    FROM credit_card cr
    JOIN customer as cu on cr.customer_id = cu.customer_id
    where cu.name = in_customername;
    
END//
-- TEST
-- CALL view_card('tom');