IF OBJECT_ID('silver.erp_trip_detail', 'U') IS NOT NULL
    DROP TABLE silver.erp_trip_detail;

CREATE TABLE silver.erp_trip_detail (
    trip_id INT,
    customer_id INT,
    driver_id INT,
    vehicle_id INT,
    origin_location_id INT,
    destination_location_id INT,
    time_id INT,
    duration_minutes INT,
    distance_km DECIMAL(5, 2),
    speed_kmh DECIMAL(10, 2),
    dwh_create_date DATETIME2 DEFAULT GETDATE()
);

-- Cek NULL
SELECT 
    SUM(CASE WHEN trip_id IS NULL THEN 1 ELSE 0 END) AS null_trip_id,
    SUM(CASE WHEN customer_id IS NULL THEN 1 ELSE 0 END) AS null_customer_id,
    SUM(CASE WHEN driver_id IS NULL THEN 1 ELSE 0 END) AS null_driver_id,
    SUM(CASE WHEN vehicle_id IS NULL THEN 1 ELSE 0 END) AS null_vehicle_id,
    SUM(CASE WHEN origin_location_id IS NULL THEN 1 ELSE 0 END) AS null_origin_location_id,
    SUM(CASE WHEN destination_location_id IS NULL THEN 1 ELSE 0 END) AS null_destination_location_id,
    SUM(CASE WHEN time_id IS NULL THEN 1 ELSE 0 END) AS null_time_id,
    SUM(CASE WHEN duration_minutes IS NULL THEN 1 ELSE 0 END) AS null_duration_minutes,
    SUM(CASE WHEN distance_km IS NULL THEN 1 ELSE 0 END) AS null_distance_km
FROM bronze.erp_trip_detail;

-- Cek duplikat trip_id
SELECT trip_id, COUNT(*) AS total
FROM bronze.erp_trip_detail
GROUP BY trip_id
HAVING COUNT(*) > 1;

-- Cek nilai durasi/jarak tidak valid
SELECT *
FROM bronze.erp_trip_detail
WHERE duration_minutes <= 0 OR distance_km <= 0;

-- Tandai outlier kecepatan (> 120 km/h)
SELECT *, 
    ROUND(distance_km / (duration_minutes / 60.0), 2) AS calc_speed_kmh
FROM bronze.erp_trip_detail
WHERE duration_minutes > 0 
  AND (distance_km / (duration_minutes / 60.0)) > 120;

-- CLEANSING DATA di bronze

-- Buat nilai NULL untuk data tidak valid
UPDATE bronze.erp_trip_detail
SET distance_km = NULL
WHERE distance_km <= 0;

UPDATE bronze.erp_trip_detail
SET duration_minutes = NULL
WHERE duration_minutes <= 0;

-- Pembulatan jarak ke 2 desimal
UPDATE bronze.erp_trip_detail
SET distance_km = ROUND(distance_km, 2)
WHERE distance_km IS NOT NULL;

-- Tambah kolom speed_kmh 
IF COL_LENGTH('bronze.erp_trip_detail', 'speed_kmh') IS NOT NULL
BEGIN
    ALTER TABLE bronze.erp_trip_detail DROP COLUMN speed_kmh;
END;

ALTER TABLE bronze.erp_trip_detail
ADD speed_kmh DECIMAL(10, 2);

-- Hitung kecepatan
UPDATE bronze.erp_trip_detail
SET speed_kmh = ROUND(distance_km / (duration_minutes / 60.0), 2)
WHERE duration_minutes > 0 AND distance_km IS NOT NULL;

-- INSERT data ke silver layer
INSERT INTO silver.erp_trip_detail (
    trip_id,
    customer_id,
    driver_id,
    vehicle_id,
    origin_location_id,
    destination_location_id,
    time_id,
    duration_minutes,
    distance_km,
    speed_kmh
)
SELECT
    trip_id,
    customer_id,
    driver_id,
    vehicle_id,
    origin_location_id,
    destination_location_id,
    time_id,
    duration_minutes,
    distance_km,
    speed_kmh
FROM bronze.erp_trip_detail;

SELECT * FROM silver.erp_trip_detail
