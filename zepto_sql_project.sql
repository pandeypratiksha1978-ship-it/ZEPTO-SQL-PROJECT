DROP TABLE if exists zepto;

CREATE TABLE zepto(
sku_id SERIAL PRIMARY KEY,
category VARCHAR(120),
name VARCHAR(150) NOT NULL,
mrp NUMERIC(8,2),
discountPercent NUMERIC(5,2),
availableQuantity INTEGER,
discountedSellingPrice NUMERIC(8,2),
weightInGms INTEGER,
outofStock BOOLEAN,
quantity INTEGER
);

--DATA EXPLORATION

-- count of rows
SELECT COUNT(*) FROM zepto;

--sample data
SELECT * FROM zepto
LIMIT 10;

--null values
SELECT * FROM zepto
WHERE name IS NULL
OR
category IS NULL
OR
mrp IS NULL
OR
discountPercent IS NULL
OR
discountedSellingPrice IS NULL
OR
weightInGms IS NULL
OR
availableQuantity IS NULL
OR
outofStock IS NULL
OR
quantity IS NULL;

--different product categories
SELECT DISTINCT category
FROM zepto
ORDER BY category;

--products in stock vs outofStock
SELECT outofStock,COUNT(sku_id)
FROM zepto
GROUP BY outofStock;

--products names present multiple times
SELECT name,COUNT(sku_id) AS "Number of SKUs"
FROM zepto 
GROUP BY name
HAVING COUNT(sku_id)>1
ORDER BY COUNT(sku_id) DESC;

--DATA CLEANING

--products with price=0
SELECT * FROM zepto
WHERE mrp=0 OR discountedSellingPrice=0;

DELETE FROM zepto
WHERE mrp=0;

--convert paisa to rupees 
UPDATE zepto
SET mrp=mrp/100.0,
discountedSellingPrice=discountedSellingPrice/100.0;

SELECT 	mrp,discountedSellingPrice FROM zepto;

--DATA ANALYSIS

--Q1.find the top 10 best value products based on the discount percent 
SELECT DISTINCT name,mrp,discountPercent
FROM zepto
ORDER BY discountPercent DESC
LIMIT 10;

--Q2.what are the products with high mrp but outofStock 
SELECT DISTINCT name,mrp
FROM zepto
WHERE outofStock=true AND mrp>300
ORDER BY mrp DESC;

--Q3.calculate estimated revenue for each category
SELECT category,
SUM(discountedSellingPrice * availableQuantity) AS total_revenue
FROM zepto
GROUP BY category
ORDER BY total_revenue;

--Q4.find the products where mrp is greater than 500 and discount is less than 10%.
SELECT DISTINCT name,mrp,discountPercent 
FROM zepto
WHERE mrp>500 AND discountPercent<10
ORDER BY mrp DESC,discountPercent DESC;

--Q5.identity the top 5 categories offering the hightest average discount percentage.
SELECT category,
ROUND(AVG(discountPercent),0) AS avg_discount
FROM zepto
GROUP BY category
ORDER BY avg_discount DESC
LIMIT 5;

--Q6.find the price per gram for products above 100g and sort by best value.
SELECT DISTINCT name,weightInGms,discountedSellingPrice,
ROUND(discountedSellingPrice/weightInGms,2) AS price_per_gram
FROM zepto
WHERE weightInGms>=100
ORDER BY price_per_gram;

--Q7.group the products into categories like low,medium,bulk.
SELECT DISTINCT name,weightInGms,
CASE WHEN weightInGms<1000 THEN 'low'
WHEN weightInGms<5000 THEN 'medium'
ELSE 'bulk'
END AS weight_category
FROM zepto;

--Q8.what is the Total inventory weight per category.
SELECT category,
SUM(weightInGms * availableQuantity) AS total_weight
FROM zepto
GROUP BY category
ORDER BY total_weight;






















