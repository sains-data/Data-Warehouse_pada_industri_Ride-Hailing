INSERT INTO silver.erp_location_info (
	location_id,
	location_name,
	latitude,
	longitude
)

SELECT * FROM bronze.erp_location_info

-- Cek data NULL
SELECT 
    SUM(CASE WHEN location_name IS NULL THEN 1 ELSE 0 END) AS null_location_name,
    SUM(CASE WHEN latitude IS NULL THEN 1 ELSE 0 END) AS null_latitude,
    SUM(CASE WHEN longitude IS NULL THEN 1 ELSE 0 END) AS null_longitude
FROM bronze.erp_location_info;

-- Cek duplikat berdasarkan location_id 
SELECT location_id, COUNT(*)
FROM bronze.erp_location_info
GROUP BY location_id
HAVING COUNT(*) > 1;

-- Cek duplikat berdasarkan latitude dan longitude
SELECT latitude, longitude, COUNT(*)
FROM bronze.erp_location_info
GROUP BY latitude, longitude
HAVING COUNT(*) > 1;

-- Cek koordinat yang tidak valid
SELECT location_id, location_name, latitude, longitude
FROM bronze.erp_location_info
WHERE latitude < -90 OR latitude > 90
   OR longitude < -180 OR longitude > 180;

-- Cek duplikat atau variasi pada location_name
SELECT location_name, COUNT(*)
FROM bronze.erp_location_info
GROUP BY location_name
HAVING COUNT(*) > 1;

-- Standarisasi location_name (huruf kecil dan hapus karakter aneh)
UPDATE bronze.erp_location_info
SET location_name = LOWER(TRIM(location_name));

-- Hapus tanda baca yang tidak perlu pada location name
UPDATE bronze.erp_location_info
SET location_name = REPLACE(REPLACE(location_name, ',', ''), '.', '');

UPDATE bronze.erp_location_info
SET location_name = REPLACE(location_name, 'gg', 'gang ');

--validasi
SELECT COUNT(*) AS invalid_coords
FROM bronze.erp_location_info
WHERE latitude < -90 OR latitude > 90
   OR longitude < -180 OR longitude > 180;

SELECT latitude, longitude, COUNT(*)
FROM bronze.erp_location_info
GROUP BY latitude, longitude
HAVING COUNT(*) > 1;

SELECT * FROM silver.erp_location_info