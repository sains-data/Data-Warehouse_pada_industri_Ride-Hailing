INSERT INTO silver.crm_payment_transaction_detail (
	transaction_id,
	customer_id,
	payment_method,
	amount,
	promo_id,
	time_id
)

SELECT * FROM bronze.crm_payment_transaction_detail

SELECT
promo_id
FROM bronze.crm_payment_transaction_detail
WHERE promo_id != TRIM(promo_id)

-- cek nilai null
SELECT *
FROM bronze.crm_payment_transaction_detail
WHERE customer_id IS NULL
   OR payment_method IS NULL
   OR amount IS NULL
   OR promo_id IS NULL
   OR time_id IS NULL;

-- Standarisasi payment_method
UPDATE bronze.crm_payment_transaction_detail
SET payment_method = LOWER(
    CASE 
        WHEN payment_method LIKE '%creditcard%' THEN 'credit card'
        WHEN payment_method LIKE '%e-wallet%' THEN 'e-wallet'
        WHEN payment_method LIKE '%e-cash%' THEN 'e-wallet' 
        ELSE payment_method
    END
);

SELECT payment_method FROM bronze.crm_payment_transaction_detail 

-- Cek nilai negatif atau NULL pada amount
SELECT transaction_id, customer_id, amount
FROM bronze.crm_payment_transaction_detail
WHERE amount <= 0 OR amount IS NULL;


-- Cek duplikat berdasarkan customer_id dan time_id
SELECT customer_id, time_id, COUNT(*)
FROM bronze.crm_payment_transaction_detail
GROUP BY customer_id, time_id
HAVING COUNT(*) > 1;

-- Hapus duplikat (simpan yang terbaru berdasarkan transaction_id)
WITH DuplicateCTE AS (
    SELECT *,
           ROW_NUMBER() OVER (PARTITION BY customer_id, time_id ORDER BY transaction_id DESC) AS rn
    FROM bronze.crm_payment_transaction_detail
)
DELETE FROM DuplicateCTE
WHERE rn > 1;

SELECT *
FROM bronze.crm_payment_transaction_detail;

SELECT *
FROM silver.crm_payment_transaction_detail;
