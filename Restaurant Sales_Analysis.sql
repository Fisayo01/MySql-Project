create database Sales_analysis;
    use sales_analysis;

-- creating table Customer_info
CREATE TABLE IF NOT EXISTS `Customer_info` (
  `Customer_ID` INT NOT NULL,
  `Customer_Name` VARCHAR(45) NOT NULL,
  PRIMARY KEY (`Customer_ID`));
  
  CREATE TABLE IF NOT EXISTS `Paymentmode_details` (
  `Paymentmode_ID` INT NOT NULL,
  `PaymentMode` VARCHAR(45) NOT NULL,
  PRIMARY KEY (`Paymentmode_ID`));

-- creating table Zone_info
  CREATE TABLE IF NOT EXISTS `Zone_info` (
  `Zone_ID` INT NOT NULL,
  `Zone` VARCHAR(45) NOT NULL,
  PRIMARY KEY (`Zone_ID`));

-- creating table Cuisine_details
CREATE TABLE IF NOT EXISTS `Cuisine_details` (
  `Cuisine_ID` INT NOT NULL,
  `Cuisine` VARCHAR(45) NOT NULL,
  PRIMARY KEY (`Cuisine_ID`));
  select* from restaurant;

-- creating table Category_details
CREATE TABLE IF NOT EXISTS `Category_details` (
  `Category_ID` INT NOT NULL,
  `Category` VARCHAR(45) NOT NULL,
  PRIMARY KEY (`Category_ID`));

-- creating table Restaurant
CREATE TABLE IF NOT EXISTS `Restaurant` (
  `Restaurant_ID` INT NOT NULL,
  `Restaurant_Name` VARCHAR(45) NOT NULL,
  `Manager` VARCHAR(45) NOT NULL,
  `Years_as_manager` INT NOT NULL,
  `Email` VARCHAR(45) NOT NULL,
  `Address` VARCHAR(100) NOT NULL,
  `Cuisine_ID` INT NOT NULL,
  `Zone_ID` INT NOT NULL,
  `Category_ID` INT NOT NULL,
  PRIMARY KEY (`Restaurant_ID`));

-- creating table alter Order_info
CREATE TABLE IF NOT EXISTS `Orders_info` (
  `Order_ID` varchar(10) NOT NULL,
  `Order_Date` VARCHAR(45) NOT NULL,
  `Order_quantity` INT NOT NULL,
  `Order_Amount` INT NOT NULL,
  `Delivery_Time_mins` INT NOT NULL,
  `Customer_Rating_Food` INT NOT NULL,
  `Customer_Rating_Delivery` INT NOT NULL,
  `Customer_ID` INT NOT NULL,
  `PaymentMode_ID` INT NOT NULL,
  `Restaurant_ID` INT NOT NULL,
PRIMARY KEY (`Order_ID`));
  
-- update orders table to convert the date column from text to date
update orders_info set Order_Date = str_to_date(Order_Date, "%m/%d/%Y %H:%i");

-- Alter table restaurant to add foreign keys
alter table restaurant 
add constraint Fk_zone_id foreign key (zone_ID) references zone_info (Zone_ID),
add constraint Fk_cuisine_id foreign key (cuisine_id) references cuisine_details (cuisine_id),
add constraint Fk_category_id foreign key (category_id) references category_details (category_id);

-- Alter table orders_info to add foreign keys
alter table orders_info
add constraint Fk_customer_id foreign key (customer_id) references customer_info(customer_id),
add constraint Fk_PaymentMode_id foreign key (PaymentMode_id) references paymentmode_details (paymentMode_id),
add constraint Fk_restaurant_id foreign key (restaurant_id) references restaurant (restaurant_id);

-- Top-rated restaurant based on food      
    select restaurant_name, round(avg(customer_rating_food)) as Avg_food_rating
    from restaurant
    inner join orders_info on restaurant.restaurant_id=orders_info.restaurant_id
    group by restaurant_name
    order by Avg_food_rating desc;
    
-- Top-rated restaurant based on delivery
    select restaurant_name, round(avg(customer_rating_delivery)) as Avg_delivery_rating
    from restaurant
    inner join orders_info on restaurant.restaurant_id=orders_info.restaurant_id
    group by restaurant_name
    order by Avg_delivery_rating desc;
    
    -- Total order amount for each restaurant in descending order of order_amount
	select restaurant_name, sum(order_amount) as total_order_amount
    from restaurant
    inner join orders_info on orders_info.restaurant_id=restaurant.restaurant_id
    group by restaurant_name order by total_order_amount desc;
    
    -- Average delivery time for each restaurant in descending order of average delivery time
    select Restaurant_name, round(avg(Delivery_Time_mins)) as Average_delivery_time
    from restaurant
    inner join orders_info on orders_info.restaurant_id=restaurant.restaurant_id
    group by restaurant_name order by Average_delivery_time desc;
    
    -- Compare the performance of chinese-cuisine and continental-cuisine based on customer food rating
    select cuisine, round(avg(customer_rating_food)) as Avg_food_rating
    from orders_info
    inner join restaurant on orders_info.restaurant_ID= Restaurant.restaurant_ID inner join cuisine_details on restaurant.cuisine_ID=cuisine_details.cuisine_ID
    where cuisine in ("Chinese","Continental")
    group by cuisine
	order by Avg_food_rating desc;
    
