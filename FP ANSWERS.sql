USE MySkill_FinalProject


-- NOMOR 1
--Selama transaksi yang terjadi selama 2021, pada bulan apa total nilai transaksi (after_discount) paling besar? Gunakan is_valid = 1 untuk memfilter data transaksi.
SELECT TOP 1
	DATEPART(MONTH, order_date) AS bulan,
	SUM(after_discount) AS total_sales
FROM order_detail
WHERE is_valid = 1 AND  DATEPART(YEAR, order_date) = '2021'
GROUP BY  DATEPART(MONTH, order_date)
ORDER BY total_sales DESC


-- NOMOR 2
-- Selama transaksi pada tahun 2022, kategori apa yang menghasilkan nilai transaksi paling besar? Gunakan is_valid = 1 untuk memfilter data transaksi.
SELECT TOP 1
	sd.category,
	SUM(od.after_discount) AS total_sales
FROM order_detail od
JOIN sku_detail sd ON od.sku_id = sd.id
WHERE DATEPART(YEAR, od.order_date) = '2022' 
AND od.is_valid = 1
GROUP BY sd.category
ORDER BY 2 DESC


-- NOMOR 3
-- Bandingkan nilai transaksi dari masing-masing kategori pada tahun 2021 dengan 2022. 
-- Sebutkan kategori apa saja yang mengalami peningkatan dan kategori apa yang mengalami penurunan nilai transaksi dari tahun 2021 ke 2022. Gunakan is_valid = 1 untuk memfilter datatransaksi.
WITH transaksi_2021 (category,tsales, tyear) AS (
SELECT 
	sd.category,
	SUM(od.after_discount) AS total_sales,
	DATEPART(YEAR, od.order_date) AS tahun
FROM order_detail od
JOIN sku_detail sd ON od.sku_id = sd.id
WHERE DATEPART(YEAR, od.order_date) = '2021' AND od.is_valid = 1
GROUP BY sd.category, DATEPART(YEAR, od.order_date)
), transaksi_2022 (category,tsales, tyear) AS (
SELECT 
	sd.category,
	SUM(od.after_discount) AS total_sales,
	DATEPART(YEAR, od.order_date) AS tahun
FROM order_detail od
JOIN sku_detail sd ON od.sku_id = sd.id
WHERE DATEPART(YEAR, od.order_date) = '2022' AND od.is_valid = 1
GROUP BY sd.category, DATEPART(YEAR, od.order_date)
)
SELECT
	transaksi_2021.category, 
	transaksi_2021.tsales AS sales_for_2021,
	transaksi_2022.tsales AS sales_for_2022,
	transaksi_2022.tsales - transaksi_2021.tsales AS growth,
	CONCAT (ROUND((transaksi_2022.tsales - transaksi_2021.tsales) / transaksi_2021.tsales * 100, 2), '%') 
AS growth_percentage,
	CASE 
		WHEN transaksi_2022.tsales > transaksi_2021.tsales THEN 'INCREASE'
		WHEN transaksi_2022.tsales < transaksi_2021.tsales THEN 'DECREASE'
		ELSE 'STUCK' 
	END AS growth_indicator
FROM transaksi_2021 JOIN transaksi_2022 ON transaksi_2021.category = transaksi_2022.category
ORDER BY growth DESC


EXEC sp_help payment_detail


-- NOMOR 4
-- Tampilkan top 5 metode pembayaran yang paling populer digunakan selama 2022 (berdasarkan total unique order). Gunakan is_valid = 1 untuk memfilter data transaksi

SELECT TOP 5
	pd.id,
	pd.payment_method,
	COUNT(DISTINCT od.id) AS total_used
FROM order_detail od
JOIN payment_detail pd ON od.payment_id = pd.id
WHERE od.is_valid = 1 AND DATEPART(YEAR, order_date) = '2022'
GROUP BY pd.id, pd.payment_method
ORDER BY total_used DESC


-- NOMOR 5
-- Q: Urutkan dari ke-5 produk ini berdasarkan nilai transaksinya.
-- 1. Samsung
-- 2. Apple
-- 3. Sony
-- 4. Huawei
-- 5. Lenovo

WITH top_brand_sales AS (
SELECT 
	CASE
	WHEN LOWER(sku_name) LIKE LOWER('%Samsung%') THEN 'Samsung' 
	WHEN LOWER(sku_name) LIKE LOWER('%Apple%')  THEN 'Apple' 
	WHEN LOWER(sku_name) LIKE LOWER('%Iphone%') THEN 'Apple' 
	WHEN LOWER(sku_name) LIKE LOWER('%Macbook%') THEN 'Apple'
	WHEN LOWER(sku_name) LIKE LOWER('%Ipad%') THEN 'Apple' 
	WHEN LOWER(sku_name) LIKE LOWER('%Sony%') THEN 'Sony' 
	WHEN LOWER(sku_name) LIKE LOWER('%Huawei%') THEN 'Huawei' 
	WHEN LOWER(sku_name) LIKE LOWER('%Lenovo%') THEN 'Lenovo' 
	END AS brand,
	SUM(od.after_discount) as total_sales
FROM sku_detail sd
JOIN order_detail od ON sd.id = od.sku_id
WHERE od.is_valid = 1
GROUP BY 
	CASE
	WHEN LOWER(sku_name) LIKE LOWER('%Samsung%') THEN 'Samsung' 
	WHEN LOWER(sku_name) LIKE LOWER('%Apple%') THEN 'Apple' 
	WHEN LOWER(sku_name) LIKE LOWER('%Iphone%') THEN 'Apple' 
	WHEN LOWER(sku_name) LIKE LOWER('%Macbook%') THEN 'Apple'
	WHEN LOWER(sku_name) LIKE LOWER('%Ipad%') THEN 'Apple' 
	WHEN LOWER(sku_name) LIKE LOWER('%Sony%') THEN 'Sony' 
	WHEN LOWER(sku_name) LIKE LOWER('%Huawei%') THEN 'Huawei' 
	WHEN LOWER(sku_name) LIKE LOWER('%Lenovo%') THEN 'Lenovo' 
	END 
)
SELECT * 
FROM top_brand_sales
WHERE brand IS NOT NULL
ORDER BY total_sales DESC


