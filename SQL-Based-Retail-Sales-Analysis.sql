-- SQL-Based-Retail-Sales-Analysis-Insights-into-Transactions-Customer-Behavior-and-Sales-Trends - P1
CREATE DATABASE sql_project_p2;

-- Create TABLE
CREATE TABLE retail_sales
            (
                transaction_id INT PRIMARY KEY,	
                sale_date DATE,	 
                sale_time TIME,	
                customer_id	INT,
                gender	VARCHAR(15),
                age	INT,
                category VARCHAR(15),	
                quantity	INT,
                price_per_unit FLOAT,	
                cogs	FLOAT,
                total_sale FLOAT
            );

SELECT * FROM retail_sales
LIMIT 10


    

SELECT 
    COUNT(*) 
FROM retail_sales

-- Data Cleaning
SELECT * FROM retail_sales
WHERE transactions_id IS NULL

SELECT * FROM retail_sales
WHERE sale_date IS NULL

SELECT * FROM retail_sales
WHERE sale_time IS NULL

SELECT * FROM retail_sales
WHERE 
    transaction_id IS NULL
    OR
    sale_date IS NULL
    OR 
    sale_time IS NULL
    OR
    gender IS NULL
    OR
    category IS NULL
    OR
    quantity IS NULL
    OR
    cogs IS NULL
    OR
    total_sale IS NULL;
    
-- 
DELETE FROM retail_sales
WHERE 
    transaction_id IS NULL
    OR
    sale_date IS NULL
    OR 
    sale_time IS NULL
    OR
    gender IS NULL
    OR
    category IS NULL
    OR
    quantity IS NULL
    OR
    cogs IS NULL
    OR
    total_sale IS NULL;
    
-- Data Exploration

-- How many sales we have?
SELECT COUNT(*) as total_sale FROM retail_sales

-- How many uniuque customers we have ?

SELECT COUNT(DISTINCT customer_id) as total_sale FROM retail_sales



SELECT DISTINCT category FROM retail_sales


-- Key Data Analysis Queries & Insights

-- 1. Sales on specific date: Retrieve all columns for sales made on '2022-11-05'.
-- 2. Category-based transactions: Retrieve transactions for the 'Clothing' category with more than 10 items sold in November 2022.
-- 3. Sales by category: Calculate the total sales for each product category.
-- 4. Customer age analysis: Find the average age of customers who purchased from the 'Beauty' category.
-- 5. High-value transactions: Identify all transactions where total sales exceed 1000.
-- 6. Gender-based transaction count: Find the number of transactions made by each gender for each category.
-- 7. Monthly sales trends: Calculate the average sale per month and identify the best-selling month in each year.
-- 8. Top customers: Identify the top 5 customers based on total sales.
-- 9. Unique customers per category: Find the number of unique customers who purchased from each category.
-- 10. Order shifts: Calculate the number of orders in different shifts (Morning, Afternoon, Evening).



-- 1. Sales on specific date: Retrieve all columns for sales made on '2022-11-05'.

SELECT *
FROM retail_sales
WHERE sale_date = '2022-11-05';


-- 2. Category-based transactions: Retrieve transactions for the 'Clothing' category with more than 10 items sold in November 2022.

SELECT 
  *
FROM retail_sales
WHERE 
    category = 'Clothing'
    AND 
    TO_CHAR(sale_date, 'YYYY-MM') = '2022-11'
    AND
    quantity >= 4


-- 3. Sales by category: Calculate the total sales for each product category.

SELECT 
    category,
    SUM(total_sale) as net_sale,
    COUNT(*) as total_orders
FROM retail_sales
GROUP BY 1

-- 4. Customer age analysis: Find the average age of customers who purchased from the 'Beauty' category.

SELECT
    ROUND(AVG(age), 2) as avg_age
FROM retail_sales
WHERE category = 'Beauty'


-- 5. High-value transactions: Identify all transactions where total sales exceed 1000.

SELECT * FROM retail_sales
WHERE total_sale > 1000


-- 6.Gender-based transaction count: Find the number of transactions made by each gender for each category.

SELECT 
    category,
    gender,
    COUNT(*) as total_trans
FROM retail_sales
GROUP 
    BY 
    category,
    gender
ORDER BY 1


-- 7. Monthly sales trends: Calculate the average sale per month and identify the best-selling month in each year.

SELECT 
       year,
       month,
    avg_sale
FROM 
(    
SELECT 
    EXTRACT(YEAR FROM sale_date) as year,
    EXTRACT(MONTH FROM sale_date) as month,
    AVG(total_sale) as avg_sale,
    RANK() OVER(PARTITION BY EXTRACT(YEAR FROM sale_date) ORDER BY AVG(total_sale) DESC) as rank
FROM retail_sales
GROUP BY 1, 2
) as t1
WHERE rank = 1
    
-- ORDER BY 1, 3 DESC

-- 8. Top customers: Identify the top 5 customers based on total sales.

SELECT 
    customer_id,
    SUM(total_sale) as total_sales
FROM retail_sales
GROUP BY 1
ORDER BY 2 DESC
LIMIT 5

-- 9. Unique customers per category: Find the number of unique customers who purchased from each category.

SELECT 
    category,    
    COUNT(DISTINCT customer_id) as cnt_unique_cs
FROM retail_sales
GROUP BY category


-- 10. Order shifts: Calculate the number of orders in different shifts (Morning, Afternoon, Evening).

WITH hourly_sale
AS
(
SELECT *,
    CASE
        WHEN EXTRACT(HOUR FROM sale_time) < 12 THEN 'Morning'
        WHEN EXTRACT(HOUR FROM sale_time) BETWEEN 12 AND 17 THEN 'Afternoon'
        ELSE 'Evening'
    END as shift
FROM retail_sales
)
SELECT 
    shift,
    COUNT(*) as total_orders    
FROM hourly_sale
GROUP BY shift

-- End of project

