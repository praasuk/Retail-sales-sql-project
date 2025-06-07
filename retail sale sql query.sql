DROP TABLE IF EXISTS retail_sales;
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

-- Data Analysis & Business Key Problems & Answers

-- My Analysis & Findings



-- Q.1 Write a SQL query to retrieve all columns for sales made on '2022-11-05

select * from retail_sales where sale_date = '2022-11-05 '



-- Q.2 Write a SQL query to retrieve all transactions where the category is 'Clothing' and the quantity sold is more than 10 in the month of Nov-2022

SELECT 
  *
FROM retail_sales
WHERE 
    category = 'Clothing'
    AND 
    TO_CHAR(sale_date, 'YYYY-MM') = '2022-11'
    AND
    quantity >= 4




-- Q.3 Write a SQL query to calculate the total sales (total_sale) for each category.

select sum(total_sale) , category from retail_sales group by category




-- Q.4 Write a SQL query to find the average age of customers who purchased items from the 'Beauty' category.

select avg(age) from retail_sales where category = 'Beauty'





-- Q.5 Write a SQL query to find all transactions where the total_sale is greater than 1000.

select * from retail_sales where total_sale > 1000




-- Q.6 Write a SQL query to find the total number of transactions (transaction_id) made by each gender in each category.

select count (transaction_id) , category , gender from retail_sales  group by gender , category





-- Q.7 Write a SQL query to calculate the average sale for each month. Find out best selling month in each year

WITH sales_rank AS (
    SELECT 
        EXTRACT(YEAR FROM sale_date) AS year, 
        EXTRACT(MONTH FROM sale_date) AS month,  
        AVG(total_sale) AS avg_sales,
        RANK() OVER (PARTITION BY EXTRACT(YEAR FROM sale_date) ORDER BY avg(total_sale) DESC) AS ran
    FROM retail_sales  
    GROUP BY EXTRACT(YEAR FROM sale_date), EXTRACT(MONTH FROM sale_date)
)
SELECT * FROM sales_rank WHERE ran = 1;





-- Q.8 Write a SQL query to find the top 5 customers based on the highest total sales

select sum(total_sale), customer_id  from retail_sales group by customer_id  order by sum(total_sale) desc limit 5




-- Q.9 Write a SQL query to find the number of unique customers who purchased items from each category.

SELECT 
    category, 
    COUNT(DISTINCT customer_id) AS unique_customers
FROM retail_sales
GROUP BY category;




-- Q.10 Write a SQL query to create each shift and number of orders (Example Morning <=12, Afternoon Between 12 & 17, Evening >17)

SELECT 
    CASE 
        WHEN EXTRACT(HOUR FROM sale_time) <= 12 THEN 'Morning'
        WHEN EXTRACT(HOUR FROM sale_time) BETWEEN 13 AND 17 THEN 'Afternoon'
        WHEN EXTRACT(HOUR FROM sale_time) > 17 THEN 'Evening'
    END AS time_slot,
    COUNT(*) AS total_sales,
    SUM(total_sale) AS total_revenue
FROM retail_sales
GROUP BY time_slot;






