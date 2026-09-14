create database E_Commerce_risk_analysis;
use E_Commerce_risk_analysis;
CREATE TABLE `customers` (
   `Customer_ID` int NOT NULL,
   `Customer_Name` text,
   `Gender` text,
   `City` text,
   `Customer_Type` text,
   `Signup_Date` text,
   PRIMARY KEY (`Customer_ID`)
 ) 
CREATE TABLE `orders_clean` (
   `Order_ID` int NOT NULL,
   `Customer_ID` int DEFAULT NULL,
   `Product_ID` int DEFAULT NULL,
   `Order_Date` text,
   `Quantity` int DEFAULT NULL,
   `Unit_Price` double DEFAULT NULL,
   `Discount_Pct` int DEFAULT NULL,
   `Payment_Method` text,
   `Shipping_Method` text,
   `Order_Status` text,
   `rn` bigint unsigned NOT NULL DEFAULT '0',
   PRIMARY KEY (`Order_ID`),
   KEY `fk_order_product` (`Product_ID`),
   KEY `fk_order_customer` (`Customer_ID`),
   CONSTRAINT `fk_order_customer` FOREIGN KEY (`Customer_ID`) REFERENCES `customers` (`Customer_ID`),
   CONSTRAINT `fk_order_product` FOREIGN KEY (`Product_ID`) REFERENCES `products` (`Product_ID`)
 ) 
CREATE TABLE `products` (
   `Product_ID` int NOT NULL,
   `Product_Name` text,
   `Category` text,
   `Subcategory` text,
   `Unit_Price` double DEFAULT NULL,
   PRIMARY KEY (`Product_ID`)
 ) 
CREATE TABLE `returns` (
   `Return_ID` int DEFAULT NULL,
   `Order_ID` int DEFAULT NULL,
   `Return_Date` text,
   `Return_Reason` text,
   `Return_Status` text,
   `Refund_Method` text,
   `Refund_Amount` double DEFAULT NULL,
   KEY `fk_return_order` (`Order_ID`),
   CONSTRAINT `fk_return_order` FOREIGN KEY (`Order_ID`) REFERENCES `orders_clean` (`Order_ID`)
 ) 
CREATE TABLE `refunds` (
   `Refund_ID` int NOT NULL,
   `Return_ID` int DEFAULT NULL,
   `Refund_Date` text,
   `Refund_Amount` double DEFAULT NULL,
   `Refund_Status` text,
   PRIMARY KEY (`Refund_ID`)
 ) 
