#Create Database
CREATE DATABASE Salesreporting;

USE Salesreporting;

# Create Fact table
CREATE TABLE fact_sales(
sale_id INT PRIMARY KEY,
product_id INT,
customer_id INT,
date_id INT,
sales_amount DECIMAL(10,2)
);

# Create product dimaneion table
CREATE TABLE dim_product ( 
product_id INT PRIMARY KEY,
product_name VARCHAR(50),
category VARCHAR(50)
);

# Create customer dimension table
CREATE Table dim_customer (
customer_id INT PRIMARY KEY,
customer_name VARCHAR(100),
region VARCHAR (50)
);

#Create DATE dimension table
CREATE TABLE dim_date (
date_id INT PRIMARY KEY,
date DATE,
month INT, 
year INT
);

------------------------------------
##### Converting to snowflake schema #####
# Normalize dim_product table 
# Step 1: Create a Category Dimension Table

CREATE TABLE dim_category(
category_id INT PRIMARY KEY,
category_name VARCHAR (100)
);

# Modify product dimension table
ALTER TABLE dim_product
ADD category_id INT;

# Step 2:  Add Foreign Key Constraints Using ALTER TABLE
# Add Foreign Key to dim_product (category_id → dim_category)
ALTER TABLE dim_product
ADD CONSTRAINT fk_category FOREIGN KEY (category_id) REFERENCES dim_category(category_id);

# Add Foreign Keys to fact_sales
ALTER TABLE fact_sales
ADD CONSTRAINT fk_product FOREIGN KEY (product_id) REFERENCES dim_product(product_id);

ALTER TABLE fact_sales
ADD CONSTRAINT fk_customer FOREIGN KEY (customer_id) REFERENCES dim_customer(customer_id);

ALTER TABLE fact_sales
ADD CONSTRAINT fk_date FOREIGN KEY (date_id) REFERENCES dim_date(date_id);

-------------------------
### Insert Values to dim tables first, if you put in the fact table first the referenced record does not exist in the parent table

# Insert into dim_category 
INSERT INTO dim_category (category_id, category_name) 
VALUES 
    (1, 'Electronics'), 
    (2, 'Mobile Devices'), 
    (3, 'Tablets');

-- Insert into dim_product (since fact_sales references it)
INSERT INTO dim_product (product_id, product_name, category_id) 
VALUES 
    (100, 'Laptop', 1), 
    (101, 'Smartphone', 2), 
    (102, 'Tablet', 3);

-- Insert into dim_customer (since fact_sales references it)
INSERT INTO dim_customer (customer_id, customer_name, region) 
VALUES 
    (201, 'Jarshana', 'North America'), 
    (202, 'Ben', 'Europe'), 
    (203, 'Alice', 'Asia');

-- Insert into dim_date (since fact_sales references it)
INSERT INTO dim_date (date_id, date, month, year) 
VALUES 
    (301, '2024-10-01', 10, 2024), 
    (302, '2024-10-02', 10, 2024), 
    (303, '2024-10-03', 10, 2024);

-- Step 2: Now insert into fact_sales
INSERT INTO fact_sales (sale_id, product_id, customer_id, date_id, sales_amount) 
VALUES 
    (1, 100, 201, 301, 150.50), 
    (2, 101, 202, 302, 250.75), 
    (3, 102, 203, 303, 99.99);


