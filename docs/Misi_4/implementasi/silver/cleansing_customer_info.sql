INSERT INTO silver.crm_customer_info (
	customer_id,
	full_name,
	email,
	phone,
	user_type,
	account_status
)

SELECT * FROM bronze.crm_customer_info

/*cek nilai null*/
SELECT *
FROM bronze.crm_customer_info
WHERE full_name IS NULL
   OR email IS NULL
   OR phone IS NULL
   OR user_type IS NULL
   OR account_status IS NULL;

SELECT 
phone
FROM bronze.crm_customer_info

/*hapus tanda baca dan ubah ke format +62*/
UPDATE bronze.crm_customer_info
SET phone = '+62' + REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(phone, '+62', ''), ' ', ''), '-', ''), '(', ''), ')', '')
WHERE phone IS NOT NULL

-- Ubah email menjadi huruf kecil dan hapus tanda baca yang salah
WHILE EXISTS (SELECT 1 FROM bronze.crm_customer_info WHERE email LIKE '%..%')
BEGIN
    UPDATE bronze.crm_customer_info
    SET email = REPLACE(email, '..', '.')
    WHERE email LIKE '%..%';
END;

SELECT email FROM bronze.crm_customer_info

UPDATE bronze.crm_customer_info
SET email = REPLACE(email, ',', '.');

-- Cek duplikat
SELECT email, COUNT(*)
FROM bronze.crm_customer_info
GROUP BY email
HAVING COUNT(*) > 1;

WITH Duplicates AS (
    SELECT *,
           ROW_NUMBER() OVER (PARTITION BY email ORDER BY customer_id DESC) AS rn
    FROM bronze.crm_customer_info
)
DELETE FROM Duplicates
WHERE rn > 1;

-- Ubah kapitalisasi
UPDATE bronze.crm_customer_info
SET user_type = UPPER(user_type),
    account_status = UPPER(account_status);

SELECT *
FROM bronze.crm_customer_info;

SELECT * FROM silver.crm_customer_info