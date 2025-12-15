-- ID_Customer and Order_Date with 100 most recent transactions
SELECT ID_Customer, Order_date
FROM transactions
ORDER BY Order_date DESC
LIMIT 100;

-- Total quantity sold per Brand
SELECT Brand, 
SUM(Kuantitas) AS Total_Kuantitas
FROM transactions
GROUP BY Brand;

-- Top 10 ID_Customer with the highest total
SELECT ID_Customer, SUM(Grand_Total) AS Total_Terbanyak
FROM transactions
GROUP BY ID_Customer
ORDER BY 2 DESC
LIMIT 10

-- All product and price from Brand Scriba
SELECT Brand, Product, Harga
FROM transactions
WHERE Brand = 'Scriba'
GROUP BY Product;

-- Top 10 product with the cheapest price
SELECT Product, Harga
FROM transactions
GROUP BY Product
ORDER BY CAST(Harga AS INT) ASC
LIMIT 10;

-- Join transactions, payment, and status table
SELECT t.ID_Transaction, t.Order_date, t.ID_Customer, t.Product, t.Brand, t.Harga, t.Kuantitas, t.Harga_TotaL,
	t.Total_Diskon, t.Total_Sales, t.Biaya_Ongkir, t.Grand_Total, p.payment, s.status
FROM transactions t
JOIN payment p
ON t.ID_Transaction = p.ID_Transaction
JOIN status s
ON t.ID_Transaction = s.ID_Transaction


