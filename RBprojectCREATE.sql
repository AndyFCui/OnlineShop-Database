DROP DATABASE IF EXISTS rbstore;
CREATE DATABASE rbstore;
USE rbstore;
DROP TABLE IF EXISTS operator;
CREATE TABLE operator
(
	operator_id int primary key,
    name varchar(50) not null,
    address varchar(50) not null,
    phone_number varchar(50) not null,
    legal_sex varchar (50) not null,
    date_of_birth date not null,
    user_id varchar(50),
    user_password varchar(50)
);
DROP TABLE IF EXISTS customer;
CREATE TABLE customer
(
	customer_id int primary key,
    name varchar(50) not null,
    address varchar(50) not null,
    phone_number varchar(50) not null,
    legal_sex varchar (50) not null,
    date_of_birth date not null
);
DROP TABLE IF EXISTS robot_order;
CREATE TABLE robot_order
(
	order_id int primary key,
    order_date date not null,
    order_status varchar(50) not null,
    order_completion_status varchar(50) not null,
    deliver_preference varchar(50) default 'ship',
    operator_id int not null,
    customer_id int not null,
	CONSTRAINT order_foreign_customer FOREIGN KEY (customer_id) REFERENCES customer(customer_id)
    ON DELETE CASCADE ON UPDATE RESTRICT,    
	CONSTRAINT order_foreign_operator FOREIGN KEY (operator_id) REFERENCES operator(operator_id)
    ON DELETE CASCADE ON UPDATE RESTRICT
);
DROP TABLE IF EXISTS credit_card;
CREATE TABLE credit_card
(
	card_number int primary key,
    type varchar(50) not null,
    expiration_date date not null,
    customer_id int not null,
    CONSTRAINT card_foreign_customer FOREIGN KEY (customer_id) REFERENCES customer(customer_id)
    ON DELETE CASCADE ON UPDATE RESTRICT
);
DROP TABLE IF EXISTS software_edition;
CREATE TABLE software_edition
(
	edition varchar(50) primary key,
    description varchar(50) not null,
    release_date date not null
);
DROP TABLE IF EXISTS robot_model;
CREATE TABLE robot_model
(
	model_id int primary key,
    model_name varchar(50) not null
);
DROP TABLE IF EXISTS robot;
CREATE TABLE robot
(
	goods_id  int primary key,
    instock varchar(50) not null,
    produced_date date not null,
    software_edition varchar(50) default '0',
    purchased_cost int not null,
    model_id int not null,
    CONSTRAINT rbot_foreign_software FOREIGN KEY (software_edition) REFERENCES software_edition(edition)
    ON DELETE CASCADE ON UPDATE RESTRICT,
    CONSTRAINT rbot_foreign_model FOREIGN KEY (model_id) REFERENCES robot_model(model_id)
    ON DELETE CASCADE ON UPDATE RESTRICT
);
DROP TABLE IF EXISTS order_detail;
CREATE TABLE order_detail
(
	order_id int not null,
    goods_id int not null,
    sales_price int not null,
    primary key(order_id, goods_id),
    CONSTRAINT detail_foreign_order FOREIGN KEY (order_id) REFERENCES robot_order(order_id)
    ON DELETE CASCADE ON UPDATE RESTRICT,
	CONSTRAINT detail_foreign_good FOREIGN KEY (goods_id) REFERENCES robot(goods_id)
    ON DELETE CASCADE ON UPDATE RESTRICT
);








