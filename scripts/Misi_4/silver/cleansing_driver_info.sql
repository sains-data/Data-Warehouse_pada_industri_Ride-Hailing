/*sp_rename 'bronze.erp_driver_info.status', 'status_driver', 'COLUMN';
sp_rename 'silver.erp_driver_info.status', 'status_driver', 'COLUMN';*/

INSERT INTO silver.erp_driver_info (
	driver_id,
	full_name,
	phone,
	license_number,
	status_driver
)


SELECT * FROM bronze.erp_driver_info

-- Cek data NULL
SELECT *
FROM bronze.erp_driver_info
WHERE full_name IS NULL
   OR phone IS NULL
   OR license_number IS NULL
   OR status_driver IS NULL;

-- Standarisasi nomor telepon
UPDATE bronze.erp_driver_info
SET phone = '+62' + REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(phone, '+62', ''), ' ', ''), '-', ''), '(', ''), ')', '')
WHERE phone IS NOT NULL

-- Standarisasi status
UPDATE bronze.erp_driver_info
SET status_driver = UPPER(status_driver);

-- Cek duplikat berdasarkan phone dan license_number
SELECT phone, license_number, COUNT(*)
FROM bronze.erp_driver_info
GROUP BY phone, license_number
HAVING COUNT(*) > 1;


SELECT * FROM silver.erp_driver_info
