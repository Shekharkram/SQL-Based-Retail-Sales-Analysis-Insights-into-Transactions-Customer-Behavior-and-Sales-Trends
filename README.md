# SQL-Based-Retail-Sales-Analysis-Insights-into-Transactions-Customer-Behavior-and-Sales-Trends
SQL queries and analysis on retail sales data, covering key metrics like transactions, customer demographics, sales trends, and category performance to derive actionable insights.

# SQL Retail Sales Analysis

This repository contains a series of SQL queries and analysis on retail sales data. The project focuses on key metrics such as transactions, customer demographics, sales trends, and category performance to derive actionable insights.

## Project Overview

The SQL queries in this project cover the following analysis tasks:
- Retrieving sales data for specific dates and categories
- Analyzing total sales by category
- Calculating customer demographics and their purchase patterns
- Identifying the best-selling months and customer segmentation
- Analyzing transaction data based on various criteria like total sales and gender

### 1. Database Setup

- **Database Creation**: The project starts by creating a database named `SQL_retail_db`.
- **Table Creation**: A table named `retail_sales` is created to store the sales data. The table structure includes columns for transaction ID, sale date, sale time, customer ID, gender, age, product category, quantity sold, price per unit, cost of goods sold (COGS), and total sale amount.
- **SQL environmen**: PostGres SQL and VScode
```sql
CREATE DATABASE SQL_retail_db;

CREATE TABLE retail_sales
(
    transactions_id INT PRIMARY KEY,
    sale_date DATE,	
    sale_time TIME,
    customer_id INT,	
    gender VARCHAR(10),
    age INT,
    category VARCHAR(35),
    quantity INT,
    price_per_unit FLOAT,	
    cogs FLOAT,
    total_sale FLOAT
);
```
### 2. Data Exploration & Cleaning

- **Record Count**: Determine the total number of records in the dataset.
- **Customer Count**: Find out how many unique customers are in the dataset.
- **Category Count**: Identify all unique product categories in the dataset.
- **Null Value Check**: Check for any null values in the dataset and delete records with missing data.

```sql
SELECT COUNT(*) FROM retail_sales;
SELECT COUNT(DISTINCT customer_id) FROM retail_sales;
SELECT DISTINCT category FROM retail_sales;

SELECT * FROM retail_sales
WHERE 
    sale_date IS NULL OR sale_time IS NULL OR customer_id IS NULL OR 
    gender IS NULL OR age IS NULL OR category IS NULL OR 
    quantity IS NULL OR price_per_unit IS NULL OR cogs IS NULL;

DELETE FROM retail_sales
WHERE 
    sale_date IS NULL OR sale_time IS NULL OR customer_id IS NULL OR 
    gender IS NULL OR age IS NULL OR category IS NULL OR 
    quantity IS NULL OR price_per_unit IS NULL OR cogs IS NULL;
```


## Key Data Analysis Queries & Insights

1. **Sales on specific date:** Retrieve all columns for sales made on '2022-11-05'.
```sql
SELECT *
FROM retail_sales
WHERE sale_date = '2022-11-05';
```

2. **Category-based transactions:** Retrieve transactions for the 'Clothing' category with more than 10 items sold in November 2022.
```sql
SELECT 
  *
FROM retail_sales
WHERE 
    category = 'Clothing'
    AND 
    TO_CHAR(sale_date, 'YYYY-MM') = '2022-11'
    AND
    quantity >= 4
```

3. **Sales by category:** Calculate the total sales for each product category.
```sql
SELECT 
    category,
    SUM(total_sale) as net_sale,
    COUNT(*) as total_orders
FROM retail_sales
GROUP BY 1
```

4. **Customer age analysis:** Find the average age of customers who purchased from the 'Beauty' category.
```sql
SELECT
    ROUND(AVG(age), 2) as avg_age
FROM retail_sales
WHERE category = 'Beauty'
```

5. **High-value transactions:** Identify all transactions where total sales exceed 1000.
```sql
SELECT * FROM retail_sales
WHERE total_sale > 1000
```

6. **Gender-based transaction count:** Find the number of transactions made by each gender for each category.
```sql
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
```

7. **Monthly sales trends:** Calculate the average sale per month and identify the best-selling month in each year.
```sql
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
```

8. **Top customers:** Identify the top 5 customers based on total sales.
```sql
SELECT 
    customer_id,
    SUM(total_sale) as total_sales
FROM retail_sales
GROUP BY 1
ORDER BY 2 DESC
LIMIT 5
```

9. **Unique customers per category:** Find the number of unique customers who purchased from each category.
```sql
SELECT 
    category,    
    COUNT(DISTINCT customer_id) as cnt_unique_cs
FROM retail_sales
GROUP BY category
```

10. **Order shifts:** Calculate the number of orders in different shifts (Morning, Afternoon, Evening).
```sql
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
```

## Key Insights

1. **Diverse Customer Demographics**:  
   The dataset reveals a broad spectrum of customer age groups, indicating a wide-ranging appeal of the store's offerings across various demographics. Categories like Clothing and Beauty show varied sales distribution, suggesting a balanced interest across different product types.

2. **Premium Purchases**:  
   A significant number of high-value transactions (total sales greater than 1000) indicate the presence of premium or bulk-buying customers. This suggests opportunities for targeted marketing or loyalty programs to encourage repeat high-value purchases.

3. **Seasonal Sales Trends**:  
   The monthly sales analysis highlights fluctuations in sales volume, with certain months showing a clear peak in transactions. This information can help identify key sales seasons or periods of higher demand, enabling better inventory and marketing planning.

4. **Top-Spending Customers**:  
   By identifying the top-spending customers, businesses can prioritize customer retention strategies, such as personalized offers or exclusive promotions, to further drive high-value transactions.

5. **Popular Product Categories**:  
   The analysis highlights the most popular categories based on total sales, offering valuable insights into customer preferences. This information can help in product stocking decisions, ensuring high-demand items are always available.

