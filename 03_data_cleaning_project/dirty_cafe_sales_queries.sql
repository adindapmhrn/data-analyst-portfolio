SELECT * FROM dirty_cafe_sales;
SELECT COUNT(*) FROM dirty_cafe_sales;

-- Replace ERROR and UNKNOWN to NULL
-- Payment Method
SELECT Payment_Method,
CASE WHEN Payment_Method IS NULL THEN 'UNKNOWN'
	WHEN Payment_Method = 'ERROR' THEN 'UNKNOWN'
	ELSE Payment_Method
END
FROM dirty_cafe_sales;
	
UPDATE dirty_cafe_sales
SET Payment_Method = CASE
	WHEN Payment_Method IS NULL THEN 'UNKNOWN'
	WHEN Payment_Method = 'ERROR' THEN 'UNKNOWN'
	ELSE Payment_Method
END;

SELECT DISTINCT Payment_Method
FROM dirty_cafe_sales;

-- Location
SELECT Location,
CASE
	WHEN Location IS NULL THEN 'UNKNOWN'
	WHEN Location = 'ERROR' THEN 'UNKNOWN'
	ELSE Location
END 
FROM dirty_cafe_sales;

UPDATE dirty_cafe_sales
SET Location = CASE
	WHEN Location IS NULL THEN 'UNKNOWN'
	WHEN Location = 'ERROR' THEN 'UNKNOWN'
	ELSE Location
END;

SELECT DISTINCT Location
FROM dirty_cafe_sales;

-- Item
SELECT Item,
CASE
	WHEN Item IS NULL THEN 'UNKNOWN'
	WHEN Item = 'ERROR' THEN 'UNKNOWN'
	ELSE Item
END 
FROM dirty_cafe_sales;

UPDATE dirty_cafe_sales
SET Item = CASE
	WHEN Item IS NULL THEN 'UNKNOWN'
	WHEN Item = 'ERROR' THEN 'UNKNOWN'
	ELSE Item
END; 

SELECT DISTINCT Item
FROM dirty_cafe_sales;

-- Check for any duplicate
WITH duplicate_cte AS
(
SELECT *,
ROW_NUMBER () OVER(
PARTITION BY Transaction_ID, Item, Quantity, Price_Per_Unit, Total_Spent, Payment_Method,
Location, Transaction_Date
ORDER BY Transaction_ID)
AS row_num
FROM dirty_cafe_sales
)
SELECT * FROM duplicate_cte
WHERE row_num>1;
-- no duplicate

-- Trim extra space
UPDATE dirty_cafe_sales
SET
Transaction_ID = TRIM(Transaction_ID),
Item = TRIM(Item),
Payment_Method = TRIM(Payment_Method),
Location = TRIM(Location);

-- NULL/Missing Value for the Item and Price_Per_Unit Columns
SELECT Item, Price_Per_Unit, COUNT(*) AS count_item
FROM dirty_cafe_sales
GROUP BY Item, Price_Per_Unit
ORDER BY 1;

SELECT Item,
       SUM(CASE WHEN Price_Per_Unit IS NULL THEN 1 ELSE 0 END) AS null_price,
       SUM(CASE WHEN Price_Per_Unit IS NOT NULL THEN 1 ELSE 0 END) AS non_null_price
FROM dirty_cafe_sales
GROUP BY Item
ORDER BY 1;

-- Use JOIN
-- Input Price_Per_Unit for Item that have not had price

WITH item_price AS
(
	SELECT Item, MAX(Price_Per_Unit) AS Price_Per_Unit
	FROM dirty_cafe_sales
	WHERE Price_Per_Unit IS NOT NULL
	AND Item <> 'UNKNOWN'
	GROUP BY Item
)
UPDATE t
SET Price_Per_Unit = ip.Price_Per_Unit
FROM dirty_cafe_sales t
JOIN item_price ip
ON t.Item = ip.Item
WHERE t.Price_Per_Unit IS NULL;

-- Input Item name based on Price_Per_Unit list (from dataset information) 
-- Because a few Items have same price, so only input the price that have unique value 
WITH price_item AS (
	SELECT Price_Per_Unit,
           MAX(Item) AS Item
    FROM dirty_cafe_sales
    WHERE Item IS NOT NULL
      AND Item <> 'UNKNOWN'
    GROUP BY Price_Per_Unit
    HAVING COUNT(DISTINCT Item) = 1  -- only prices that map to one item
)
UPDATE t
SET t.Item = p.Item
FROM dirty_cafe_sales t
JOIN price_item p
  ON t.Price_Per_Unit = p.Price_Per_Unit
WHERE t.Item IS NULL
   OR t.Item = 'UNKNOWN';

SELECT
    SUM(CASE WHEN Item IS NULL OR Item = 'UNKNOWN' THEN 1 ELSE 0 END) AS remaining_missing_items
FROM dirty_cafe_sales;

-- Total_Spent = Quantity * Price_Per_Unit
SELECT Transaction_ID, Item, Quantity, 
	Price_Per_Unit,Total_Spent 
FROM dirty_cafe_sales
WHERE Total_Spent IS NULL 
	OR Price_Per_Unit IS NULL
	OR Quantity IS NULL;

-- Total_Spent
SELECT Transaction_ID, Item, 
	Quantity, 
	Price_Per_Unit, 
	Quantity*Price_Per_Unit AS Total_Spent
FROM dirty_cafe_sales
WHERE Total_Spent IS NULL 
	AND Price_Per_Unit IS NOT NULL
	AND Quantity IS NOT NULL;

UPDATE dirty_cafe_sales
SET Total_Spent = Quantity*Price_Per_Unit
WHERE Total_Spent IS NULL 
	AND Price_Per_Unit IS NOT NULL
	AND Quantity IS NOT NULL;

-- Quantity
SELECT Transaction_ID, Item, 
	(Total_Spent/Price_Per_Unit) AS Quantity, 
	Price_Per_Unit, 
	Total_Spent
FROM dirty_cafe_sales
WHERE Total_Spent IS NOT NULL 
	AND Price_Per_Unit IS NOT NULL
	AND Quantity IS NULL;

UPDATE dirty_cafe_sales
SET Quantity = Total_Spent/Price_Per_Unit
WHERE Total_Spent IS NOT NULL
	AND Price_Per_Unit IS NOT NULL
	AND Quantity IS NULL;

-- Price_Per_Unit
SELECT Transaction_ID, Item, 
	Quantity, 
	(Total_Spent/Quantity) AS Price_Per_Unit, 
	Total_Spent
FROM dirty_cafe_sales
WHERE Total_Spent IS NOT NULL 
	AND Price_Per_Unit IS NULL
	AND Quantity IS NOT NULL;

UPDATE dirty_cafe_sales
SET Price_Per_Unit = Total_Spent/Quantity
WHERE Total_Spent IS NOT NULL
	AND Price_Per_Unit IS NULL
	AND Quantity IS NOT NULL;

-- Execute again the last query -> input Item name based on price list 

-- Data Exploration
SELECT SUM(Total_Spent) AS Revenue FROM dirty_cafe_sales;

SELECT SUM(Quantity) AS Total_Quantity FROM dirty_cafe_sales;

SELECT Item, Price_Per_Unit, SUM(Quantity) as Total_Quantity, SUM(Total_Spent) AS Revenue
FROM dirty_cafe_sales
GROUP BY Item, Price_Per_Unit
HAVING Item <> 'UNKNOWN'
ORDER BY Revenue DESC;

SELECT * FROM dirty_cafe_sales