INSERT INTO silver.erp_time_info (
	time_id,
	full_date,
	day_num,
	month_num,
	year_num,
	weekday_name
)

SELECT * FROM bronze.erp_time_info

EXEC sp_help [bronze.erp_time_info];

-- cek nilai null
SELECT 
    SUM(CASE WHEN time_id IS NULL THEN 1 ELSE 0 END) AS null_time_id,
    SUM(CASE WHEN full_date IS NULL THEN 1 ELSE 0 END) AS null_full_date,
    SUM(CASE WHEN day_num IS NULL THEN 1 ELSE 0 END) AS null_day_num,
    SUM(CASE WHEN month_num IS NULL THEN 1 ELSE 0 END) AS null_month_num,
    SUM(CASE WHEN year_num IS NULL THEN 1 ELSE 0 END) AS null_year_num,
    SUM(CASE WHEN weekday_name IS NULL THEN 1 ELSE 0 END) AS null_weekday_name
FROM bronze.erp_time_info;

-- cek duplikat
SELECT 
    full_date, COUNT(*) AS jumlah
FROM bronze.erp_time_info
GROUP BY full_date
HAVING COUNT(*) > 1;

-- memastikan weekday sesuai dengan full_date 
SELECT 
    time_id, full_date, weekday_name,
    DATENAME(WEEKDAY, full_date) AS calculated_weekday
FROM bronze.erp_time_info
WHERE weekday_name <> DATENAME(WEEKDAY, full_date);

UPDATE bronze.erp_time_info
SET weekday_name = UPPER(LEFT(weekday_name, 1)) + LOWER(SUBSTRING(weekday_name, 2, LEN(weekday_name)));

SELECT *
FROM bronze.erp_time_info
WHERE 
    day_num <> DAY(full_date)
    OR month_num <> MONTH(full_date)
    OR year_num <> YEAR(full_date);

-- validasi range tanggal 
SELECT *
FROM bronze.erp_time_info
WHERE full_date < '2000-01-01' OR full_date > GETDATE();

-- validasi format weekday name
SELECT DISTINCT weekday_name
FROM bronze.erp_time_info;

SELECT * FROM silver.erp_time_info