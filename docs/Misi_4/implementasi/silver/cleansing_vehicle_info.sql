TRUNCATE TABLE silver.erp_vehicle_info
INSERT INTO silver.erp_vehicle_info (
	vehicle_id,
	driver_id,
	vehicle_type,
	brand,
	plate_number
)

SELECT * FROM bronze.erp_vehicle_info

SELECT 
    SUM(CASE WHEN vehicle_id IS NULL THEN 1 ELSE 0 END) AS null_vehicle_id,
    SUM(CASE WHEN driver_id IS NULL THEN 1 ELSE 0 END) AS null_driver_id,
    SUM(CASE WHEN vehicle_type IS NULL THEN 1 ELSE 0 END) AS null_vehicle_type,
    SUM(CASE WHEN brand IS NULL THEN 1 ELSE 0 END) AS null_brand,
    SUM(CASE WHEN plate_number IS NULL THEN 1 ELSE 0 END) AS null_plate_number
FROM bronze.erp_vehicle_info;

-- Cek duplikat berdasarkan vehicle_id
SELECT vehicle_id, COUNT(*) AS jumlah
FROM bronze.erp_vehicle_info
GROUP BY vehicle_id
HAVING COUNT(*) > 1;

-- Hapus spasi berlebih, kapitalisasi teks
UPDATE bronze.erp_vehicle_info
SET vehicle_type = UPPER(LTRIM(RTRIM(vehicle_type))),
    brand = UPPER(LTRIM(RTRIM(brand))),
    plate_number = UPPER(LTRIM(RTRIM(plate_number)))
WHERE 1 = 1;

-- Cek data duplikat (semua kolom sama)
SELECT vehicle_id, driver_id, vehicle_type, brand, plate_number, COUNT(*) AS cnt
FROM bronze.erp_vehicle_info
GROUP BY vehicle_id, driver_id, vehicle_type, brand, plate_number
HAVING COUNT(*) > 1;

SELECT * FROM silver.erp_vehicle_info