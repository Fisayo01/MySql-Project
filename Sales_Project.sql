create database Sales_analysis;
    use sales_analysis;

-- creating table Customer_info
CREATE TABLE IF NOT EXISTS `Customer_info` (
  `Customer_ID` INT NOT NULL,
  `Customer_Name` VARCHAR(45) NOT NULL,
  PRIMARY KEY (`Customer_ID`));

-- creating table PaymentMode_details  
CREATE TABLE IF NOT EXISTS `PaymentMode_details` (
  `PaymentMode_ID` INT NOT NULL,
  `PaymentMode` VARCHAR(45) NOT NULL,
  PRIMARY KEY (`PaymentMode_ID`));
  
  -- creating table CreditCard_details  
  CREATE TABLE IF NOT EXISTS `CreditCard_details` (
  `CreditCard_ID` INT NOT NULL,
  `CreditCard_Number` VARCHAR(45) NOT NULL,
  PRIMARY KEY (`CreditCard_ID`));

 -- creating table DeditCard_details  
  CREATE TABLE IF NOT EXISTS `DebitCard_details` (
  `DebitCard_ID` INT NOT NULL,
  `DebitCard_Number` VARCHAR(45) NOT NULL,
  PRIMARY KEY (`DebitCard_ID`));
 
  -- creating table Card_Provider
 CREATE TABLE IF NOT EXISTS `Card_Provider` (
  `Card_ProviderID` INT NOT NULL,
  `Card_Provider` VARCHAR(45) NOT NULL,
  PRIMARY KEY (`Card_ProviderID`)); 


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

-- creating table Category_details
CREATE TABLE IF NOT EXISTS `Category_details` (
  `Category_ID` INT NOT NULL,
  `Category` VARCHAR(45) NOT NULL,
  PRIMARY KEY (`Category_ID`));

-- creating table Store_details
CREATE TABLE IF NOT EXISTS `Store_details` (
  `Store_Id` INT NOT NULL,
  `Store` VARCHAR(45) NOT NULL,
  PRIMARY KEY (`Store_Id`));

-- creating table Restaurant
CREATE TABLE IF NOT EXISTS `Restaurant` (
  `Restaurant_ID` INT NOT NULL,
  `Restaurant_Name` VARCHAR(45) NOT NULL,
  `Manager` VARCHAR(45) NOT NULL,
  `Years_as_manager` INT NOT NULL,
  `Email` VARCHAR(45) NOT NULL,
  `Address` VARCHAR(45) NOT NULL,
  `Zone_ID` INT NOT NULL,
  `Cuisine_ID` INT NOT NULL,
  `Category_ID` INT NOT NULL,
  `Store_Id` INT NOT NULL,
  PRIMARY KEY (`Restaurant_ID`));

-- creating table alter Order_info
CREATE TABLE IF NOT EXISTS `Order_info` (
  `Order_ID` varchar(10) NOT NULL,
  `Order_Date` VARCHAR(45) NOT NULL,
  `Order_quantity` INT NOT NULL,
  `Order_Amount` INT NOT NULL,
  `Delivery_Time_mins` INT NOT NULL,
  `Customer_Rating_Food` INT NOT NULL,
  `Customer_Rating_Delivery` INT NOT NULL,
  `Customer_ID` INT NOT NULL,
  `Restaurant_ID` INT NOT NULL,
  `PaymentMode_ID` INT NOT NULL,
  `CreditCard_ID` INT NOT NULL,
  `DebitCard_ID` INT NOT NULL,
  `Card_ProviderID` INT NOT NULL,
  PRIMARY KEY (`Order_ID`));

-- Alter table restaurant to add foreign keys
alter table restaurant 
add constraint Fk_zone_id foreign key (zone_id) references zone_info(zone_id),
add constraint Fk_cuisine_id foreign key (cuisine_id) references cuisine (cuisine_id),
add constraint Fk_category_id foreign key (category_id) references category_details (category_id),
add constraint Fk_store_id foreign key (store_id) references store_details (Store_id);

-- Alter table order_info to add foreign keys
alter table order_info
add constraint Fk_customer_id foreign key (zone_id) references zone_info(customer_id),
add constraint Fk_restaurant_id foreign key (restaurant_id) references restaurant (restaurant_id),
add constraint Fk_PaymentMode_id foreign key (PaymentMode_id) references paymentmode_details (paymentMode_id),
add constraint Fk_CreditCard_id foreign key (CreditCard_id) references creditcard_details (Creditcard_id),
add constraint Fk_DebitCard_id foreign key (DebitCard_id) references Debitcard_details (Debitcard_id);

-- create a joint table for the four tables
create table Order_info as 
select orders.order_id, orders.sale_date, orders.sale_channel, sales_team.sales_team, sales_team.region, product.product_name, 
product.product_category, store.store_name, store.state, orders.order_quantity, orders.unit_cost, orders.unit_price
from orders
left join sales_team on orders.salesteam_id = sales_team.salesteam_id
left join product on orders.product_id = product.product_id
left join store on orders.store_id = store.store_id;


-- Top-rated restaurant based on food      
    select restaurant_name, customer_rating_food
    from restaurant
    inner join order_info on restaurant.restaurant_id=order_info.restaurant_id
    order by customer_rating_food desc;
    
    -- Top-rated restaurant based o delivery
  select restaurant_name, customer_rating_delivery
    from restaurant
    inner join order_info on restaurant.restaurant_id=order_info.restaurant_id
    order by customer_rating_delivery desc;
    
    -- Total order amount for each restaurant in descending order of order_amount
	select restaurant_name, sum(order_amount) as total_order_amount
    from restaurant
    inner join order_info on order_info.restaurant_id=restaurant.restaurant_id
    group by restaurant_name order by sum(order_amount) desc;
    
    -- Average delivery time for each restaurant in descending order of average delivery time
    select Restaurant_name, round(avg(Delivery_Time_mins)) as Average_delivery_time
    from restaurant
    inner join order_info on order_info.restaurant_id=restaurant.restaurant_id
    group by restaurant_name order by round(avg(Delivery_Time_mins)) desc;
    
    -- Compare the performance of chinese-cuisine and continental restaurants based on customer food rating
    select cuisine, customer_rating_food
    from order_info
    inner join restaurant on order_info.restaurant_ID= Restaurant.restaurant_ID inner join cuisine_details on restaurant.cuisine_ID=cuisine_details.cuisine_ID
    where cuisine in ("Chinese","Continental")
     order by customer_rating_food;
    
