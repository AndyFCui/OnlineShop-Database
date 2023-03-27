DROP DATABASE IF EXISTS rbstore;
CREATE DATABASE rbstore;
USE rbstore;
CREATE TABLE Operator
(
	operator_id int primary key,
    name varchar(50) not null,
    address varchar(50) not null,
    phone_number int(10) not null,
    legal_sex varchar (50) not null,
    date_of_birth date not null,
    user_id int not null,
    user_password int not null
);

CREATE TABLE Customer
(
	customer_id int primary key,
    name varchar(50) not null,
    address varchar(50) not null,
    phone_number int(10) not null,
    legal_sex varchar (50) not null,
    date_of_birth date not null,
    user_id int not null,
    user_password int not null
);

CREATE TABLE RBorder
(
	order_id int primary key,
    order_date date not null,
    order_status varchar(50) not null,
    order_completion_status varchar(50) not null,
    deliver_preference varchar(50) default 'ship'
);

CREATE TABLE credit_card
(
	card_number int primary key,
    type varchar(50) not null,
    expiration_date date not null,
    customer_id int not null,
    CONSTRAINT card_foreign_customer FOREIGN KEY (customer_id) REFERENCES Customer(customer_id)
    ON DELETE CASCADE ON UPDATE RESTRICT
);

CREATE TABLE Software_edition
(
	edition varchar(50) primary key,
    description varchar(50) not null,
    release_date date not null
);

CREATE TABLE Rbot_model
(
	model_id int primary key,
    model_name varchar(50) not null
);

CREATE TABLE Robot
(
	goods_id int(10) primary key,
    instock varchar(50) not null,
    produced_date date not null,
    software_edition varchar(50) default '0',
    purchased_cost int not null,
    model_id int not null,
    CONSTRAINT rbot_foreign_software FOREIGN KEY (software_edition) REFERENCES Software_edition(edition)
    ON DELETE CASCADE ON UPDATE RESTRICT,
    CONSTRAINT rbot_foreign_model FOREIGN KEY (model_id) REFERENCES Rbot_model(model_id)
    ON DELETE CASCADE ON UPDATE RESTRICT
);

CREATE TABLE Order_detail
(
	order_id int not null,
    goods_id int not null,
    sales_price int not null,
    operator_id int not null,
    primary key(order_id, goods_id),
    CONSTRAINT detail_foreign_order FOREIGN KEY (order_id) REFERENCES RBorder(order_id)
    ON DELETE CASCADE ON UPDATE RESTRICT,
	CONSTRAINT detail_foreign_good FOREIGN KEY (goods_id) REFERENCES Robot(goods_id)
    ON DELETE CASCADE ON UPDATE RESTRICT,
	CONSTRAINT detail_foreign_operator FOREIGN KEY (operator_id) REFERENCES Operator(operator_id)
    ON DELETE CASCADE ON UPDATE RESTRICT 
);








