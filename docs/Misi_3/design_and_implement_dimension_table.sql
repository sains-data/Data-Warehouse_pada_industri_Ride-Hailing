PRINT '==========================================================='
-- view gold.dim_customers
PRINT '==========================================================='
CREATE VIEW gold.dim_customers AS
SELECT 
	ROW_NUMBER() OVER (ORDER BY customer_id) AS customer_key,
	customer_id,
	full_name,
	email,
	phone,
	user_type,
	account_status
FROM silver.crm_customer_info;


PRINT '==========================================================='
-- view gold.dim_driver
PRINT '==========================================================='
CREATE VIEW gold.dim_driver AS
SELECT
	ROW_NUMBER() OVER (ORDER BY driver_id) AS driver_key,
	driver_id,
	full_name,
	phone,
	license_number,
	status_driver
FROM silver.erp_driver_info;


PRINT '==========================================================='
-- view gold.dim_vehicle
PRINT '==========================================================='
CREATE VIEW gold.dim_vehicle AS
SELECT
	ROW_NUMBER() OVER (ORDER BY vehicle_id) AS vehicle_key,
    v.vehicle_id,
    v.vehicle_type,
    v.brand,
    v.plate_number,
    d.driver_id,
    d.full_name AS driver_name,
    d.phone AS driver_phone
FROM silver.erp_vehicle_info v
LEFT JOIN gold.dim_driver d
    ON v.driver_id = d.driver_id;

PRINT '==========================================================='
-- view gold.dim_location
PRINT '==========================================================='
CREATE VIEW gold.dim_location AS
SELECT
	ROW_NUMBER() OVER (ORDER BY location_id) AS location_key,
    location_id,
    location_name,
    latitude,
    longitude
FROM silver.erp_location_info;

PRINT '==========================================================='
-- view gold.dim_time
PRINT '==========================================================='
CREATE VIEW gold.dim_time AS
SELECT
	ROW_NUMBER() OVER (ORDER BY time_id) AS time_key,
	time_id,
	full_date,
	day_num,
	month_num,
	year_num,
	weekday_name
FROM silver.erp_time_info;