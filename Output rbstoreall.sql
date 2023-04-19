CREATE DATABASE  IF NOT EXISTS `rbstore` /*!40100 DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci */ /*!80016 DEFAULT ENCRYPTION='N' */;
USE `rbstore`;
-- MySQL dump 10.13  Distrib 8.0.28, for macos11 (x86_64)
--
-- Host: localhost    Database: rbstore
-- ------------------------------------------------------
-- Server version	8.0.28

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!50503 SET NAMES utf8 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Table structure for table `credit_card`
--

DROP TABLE IF EXISTS `credit_card`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `credit_card` (
  `card_number` varchar(50) NOT NULL,
  `type` varchar(50) NOT NULL,
  `expiration_date` date NOT NULL,
  `customer_id` int NOT NULL,
  PRIMARY KEY (`card_number`),
  KEY `card_foreign_customer` (`customer_id`),
  CONSTRAINT `card_foreign_customer` FOREIGN KEY (`customer_id`) REFERENCES `customer` (`customer_id`) ON DELETE CASCADE ON UPDATE RESTRICT
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `credit_card`
--

LOCK TABLES `credit_card` WRITE;
/*!40000 ALTER TABLE `credit_card` DISABLE KEYS */;
INSERT INTO `credit_card` VALUES ('1234554321','visa','2024-09-10',100),('123456789','visa','2024-09-10',100),('987654321','Mastercard','2024-11-10',100);
/*!40000 ALTER TABLE `credit_card` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `customer`
--

DROP TABLE IF EXISTS `customer`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `customer` (
  `customer_id` int NOT NULL,
  `name` varchar(50) NOT NULL,
  `address` varchar(50) NOT NULL,
  `phone_number` varchar(50) DEFAULT NULL,
  `legal_sex` varchar(50) NOT NULL,
  `date_of_birth` date NOT NULL,
  PRIMARY KEY (`customer_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `customer`
--

LOCK TABLES `customer` WRITE;
/*!40000 ALTER TABLE `customer` DISABLE KEYS */;
INSERT INTO `customer` VALUES (100,'Tom','address','123456','male','2222-02-22');
/*!40000 ALTER TABLE `customer` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `operator`
--

DROP TABLE IF EXISTS `operator`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `operator` (
  `operator_id` int NOT NULL,
  `name` varchar(50) NOT NULL,
  `address` varchar(50) NOT NULL,
  `phone_number` varchar(50) DEFAULT NULL,
  `legal_sex` varchar(50) NOT NULL,
  `date_of_birth` date NOT NULL,
  `user_id` varchar(50) NOT NULL,
  `user_password` varchar(50) NOT NULL,
  PRIMARY KEY (`operator_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `operator`
--

LOCK TABLES `operator` WRITE;
/*!40000 ALTER TABLE `operator` DISABLE KEYS */;
INSERT INTO `operator` VALUES (1,'tom','neu','123123','male','2023-02-16','tom','123123');
/*!40000 ALTER TABLE `operator` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `order_detail`
--

DROP TABLE IF EXISTS `order_detail`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `order_detail` (
  `order_id` int NOT NULL,
  `goods_id` int NOT NULL,
  `sales_price` int NOT NULL,
  `return_status` varchar(50) DEFAULT 'None',
  PRIMARY KEY (`order_id`,`goods_id`),
  KEY `detail_foreign_good` (`goods_id`),
  CONSTRAINT `detail_foreign_good` FOREIGN KEY (`goods_id`) REFERENCES `robot` (`goods_id`) ON DELETE CASCADE ON UPDATE RESTRICT,
  CONSTRAINT `detail_foreign_order` FOREIGN KEY (`order_id`) REFERENCES `robot_order` (`order_id`) ON DELETE CASCADE ON UPDATE RESTRICT
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `order_detail`
--

LOCK TABLES `order_detail` WRITE;
/*!40000 ALTER TABLE `order_detail` DISABLE KEYS */;
INSERT INTO `order_detail` VALUES (1,4000,500,'return denied');
/*!40000 ALTER TABLE `order_detail` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `robot`
--

DROP TABLE IF EXISTS `robot`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `robot` (
  `goods_id` int NOT NULL,
  `instock` varchar(50) NOT NULL,
  `produced_date` date NOT NULL,
  `software_edition` varchar(50) DEFAULT '0',
  `purchased_cost` int NOT NULL,
  `model_id` int NOT NULL,
  PRIMARY KEY (`goods_id`),
  KEY `rbot_foreign_software` (`software_edition`),
  KEY `rbot_foreign_model` (`model_id`),
  CONSTRAINT `rbot_foreign_model` FOREIGN KEY (`model_id`) REFERENCES `robot_model` (`model_id`) ON DELETE CASCADE ON UPDATE RESTRICT,
  CONSTRAINT `rbot_foreign_software` FOREIGN KEY (`software_edition`) REFERENCES `software_edition` (`edition`) ON DELETE CASCADE ON UPDATE RESTRICT
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `robot`
--

LOCK TABLES `robot` WRITE;
/*!40000 ALTER TABLE `robot` DISABLE KEYS */;
INSERT INTO `robot` VALUES (4000,'instock','2222-02-22','Galaxy 0.1',300,428910);
/*!40000 ALTER TABLE `robot` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `robot_model`
--

DROP TABLE IF EXISTS `robot_model`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `robot_model` (
  `model_id` int NOT NULL,
  `model_name` varchar(50) NOT NULL,
  PRIMARY KEY (`model_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `robot_model`
--

LOCK TABLES `robot_model` WRITE;
/*!40000 ALTER TABLE `robot_model` DISABLE KEYS */;
INSERT INTO `robot_model` VALUES (235870,'OKK'),(336200,'Spot'),(381932,'Dragon'),(428910,'Maru'),(729310,'Zurg'),(782410,'Snub'),(812031,'Mech'),(891036,'Solar'),(891301,'Nya');
/*!40000 ALTER TABLE `robot_model` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `robot_order`
--

DROP TABLE IF EXISTS `robot_order`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `robot_order` (
  `order_id` int NOT NULL,
  `order_date` date NOT NULL,
  `order_status` varchar(50) NOT NULL,
  `deliver_preference` varchar(50) DEFAULT 'regular',
  `operator_id` int NOT NULL,
  `customer_id` int NOT NULL,
  PRIMARY KEY (`order_id`),
  KEY `order_foreign_customer` (`customer_id`),
  KEY `order_foreign_operator` (`operator_id`),
  CONSTRAINT `order_foreign_customer` FOREIGN KEY (`customer_id`) REFERENCES `customer` (`customer_id`) ON DELETE CASCADE ON UPDATE RESTRICT,
  CONSTRAINT `order_foreign_operator` FOREIGN KEY (`operator_id`) REFERENCES `operator` (`operator_id`) ON DELETE CASCADE ON UPDATE RESTRICT
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `robot_order`
--

LOCK TABLES `robot_order` WRITE;
/*!40000 ALTER TABLE `robot_order` DISABLE KEYS */;
INSERT INTO `robot_order` VALUES (1,'2222-02-22','return denied','regular',1,100),(2,'2023-04-15','Order','regular',1,100);
/*!40000 ALTER TABLE `robot_order` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `software_edition`
--

DROP TABLE IF EXISTS `software_edition`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `software_edition` (
  `edition` varchar(50) NOT NULL,
  `description` varchar(50) NOT NULL,
  `release_date` date NOT NULL,
  PRIMARY KEY (`edition`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `software_edition`
--

LOCK TABLES `software_edition` WRITE;
/*!40000 ALTER TABLE `software_edition` DISABLE KEYS */;
INSERT INTO `software_edition` VALUES ('Falcon 0.1','First edition for robot','2018-09-01'),('Falcon 0.2','Update the hardware support','2018-09-03'),('Falcon 0.3','Fix some errors of connection','2018-09-10'),('Galaxy 0.1','New software designed for excellent robot','2022-02-22');
/*!40000 ALTER TABLE `software_edition` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2023-04-18 22:48:23
