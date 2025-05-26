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

PRINT '==========================================================='
-- view gold.fact_trip
PRINT '==========================================================='
CREATE VIEW gold.fact_trip AS
SELECT
    t.trip_id,
    t.customer_id,
    t.driver_id,
    t.vehicle_id,
    t.origin_location_id,
    ori.location_name AS origin_location_name,
    t.destination_location_id,
    dest.location_name AS destination_location_name,
    t.time_id,
    ti.full_date AS trip_date,
    t.duration_minutes,
    t.distance_km
FROM silver.erp_trip_detail t
LEFT JOIN gold.dim_location ori ON t.origin_location_id = ori.location_id
LEFT JOIN gold.dim_location dest ON t.destination_location_id = dest.location_id
LEFT JOIN gold.dim_time ti ON t.time_id = ti.time_id;

PRINT '==========================================================='
-- viiew gold.fact_payment
PRINT '==========================================================='
CREATE VIEW gold.fact_payment AS
SELECT
    pt.transaction_id,
    pt.customer_id,
    c.full_name AS customer_name,
    pt.payment_method,
    pt.amount,
    pt.promo_id,
    pt.time_id,
    ti.full_date AS payment_date
FROM silver.crm_payment_transaction_detail pt
LEFT JOIN gold.dim_customers c ON pt.customer_id = c.customer_key
LEFT JOIN gold.dim_time ti ON pt.time_id = ti.time_key;
