CREATE PROCEDURE silver.load_silver
AS
BEGIN
    BEGIN TRY
        BEGIN TRANSACTION;

        ----------------------------
        -- CRM CUSTOMER INFO
        ----------------------------
        -- Normalisasi phone number
        UPDATE bronze.crm_customer_info
        SET phone = '+62' + REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(phone, '+62', ''), ' ', ''), '-', ''), '(', ''), ')', '')
        WHERE phone IS NOT NULL;

        -- Perbaiki email: hilangkan tanda baca ganda atau tidak valid
        WHILE EXISTS (SELECT 1 FROM bronze.crm_customer_info WHERE email LIKE '%..%')
        BEGIN
            UPDATE bronze.crm_customer_info
            SET email = REPLACE(email, '..', '.')
            WHERE email LIKE '%..%';
        END;

        UPDATE bronze.crm_customer_info
        SET email = REPLACE(email, ',', '.');

        -- Ubah user_type dan account_status menjadi kapital
        UPDATE bronze.crm_customer_info
        SET user_type = UPPER(user_type),
            account_status = UPPER(account_status);

        -- Hapus duplikat berdasarkan email
        WITH Duplicates AS (
            SELECT *, ROW_NUMBER() OVER (PARTITION BY email ORDER BY customer_id DESC) AS rn
            FROM bronze.crm_customer_info
        )
        DELETE FROM Duplicates WHERE rn > 1;

        -- Pindahkan ke tabel silver
        TRUNCATE TABLE silver.crm_customer_info;

        INSERT INTO silver.crm_customer_info (
            customer_id,
            full_name,
            email,
            phone,
            user_type,
            account_status
        )
        SELECT
            customer_id,
            TRIM(full_name),
            LOWER(email),
            phone,
            user_type,
            account_status
        FROM bronze.crm_customer_info
        WHERE full_name IS NOT NULL
          AND email IS NOT NULL
          AND phone IS NOT NULL
          AND user_type IS NOT NULL
          AND account_status IS NOT NULL;

        ----------------------------
        -- ERP DRIVER INFO
        ----------------------------
        -- Normalisasi nomor telepon
        UPDATE bronze.erp_driver_info
        SET phone = '+62' + REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(phone, '+62', ''), ' ', ''), '-', ''), '(', ''), ')', '')
        WHERE phone IS NOT NULL;

        -- Kapitalisasi status_driver
        UPDATE bronze.erp_driver_info
        SET status_driver = UPPER(status_driver);

        -- Hapus duplikat berdasarkan phone dan license_number
        WITH Duplicates AS (
            SELECT *, ROW_NUMBER() OVER (PARTITION BY phone, license_number ORDER BY driver_id DESC) AS rn
            FROM bronze.erp_driver_info
        )
        DELETE FROM Duplicates WHERE rn > 1;

        -- Pindahkan ke tabel silver
        TRUNCATE TABLE silver.erp_driver_info;

        INSERT INTO silver.erp_driver_info (
            driver_id,
            full_name,
            phone,
            license_number,
            status_driver
        )
        SELECT
            driver_id,
            TRIM(full_name),
            phone,
            license_number,
            status_driver
        FROM bronze.erp_driver_info
        WHERE full_name IS NOT NULL
          AND phone IS NOT NULL
          AND license_number IS NOT NULL
          AND status_driver IS NOT NULL;

        ----------------------------
        -- ERP LOCATION INFO
        ----------------------------
        -- Standarisasi location_name (huruf kecil dan hapus karakter aneh)
        UPDATE bronze.erp_location_info
        SET location_name = LOWER(TRIM(location_name));

        -- Hapus tanda baca yang tidak perlu pada location name
        UPDATE bronze.erp_location_info
        SET location_name = REPLACE(REPLACE(location_name, ',', ''), '.', '');

        UPDATE bronze.erp_location_info
        SET location_name = REPLACE(location_name, 'gg', 'gang ');

        -- Pindahkan ke tabel silver
        TRUNCATE TABLE silver.erp_location_info;

        INSERT INTO silver.erp_location_info (
            location_id,
            location_name,
            latitude,
            longitude
        )
        SELECT
            location_id,
            location_name,
            latitude,
            longitude
        FROM bronze.erp_location_info
        WHERE location_name IS NOT NULL
          AND latitude BETWEEN -90 AND 90
          AND longitude BETWEEN -180 AND 180;

        ----------------------------
        -- CRM PAYMENT TRANSACTION DETAIL
        ----------------------------
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

        -- Hapus duplikat (simpan yang terbaru berdasarkan transaction_id)
        WITH DuplicateCTE AS (
            SELECT *,
                   ROW_NUMBER() OVER (PARTITION BY customer_id, time_id ORDER BY transaction_id DESC) AS rn
            FROM bronze.crm_payment_transaction_detail
        )
        DELETE FROM DuplicateCTE
        WHERE rn > 1;

        -- Pindahkan ke tabel silver
        TRUNCATE TABLE silver.crm_payment_transaction_detail;

        INSERT INTO silver.crm_payment_transaction_detail (
            transaction_id,
            customer_id,
            payment_method,
            amount,
            promo_id,
            time_id
        )
        SELECT
            transaction_id,
            customer_id,
            payment_method,
            amount,
            promo_id,
            time_id
        FROM bronze.crm_payment_transaction_detail
        WHERE customer_id IS NOT NULL
          AND payment_method IS NOT NULL
          AND amount > 0
          AND promo_id IS NOT NULL
          AND time_id IS NOT NULL;

        ----------------------------
        -- ERP TIME INFO
        ----------------------------
        -- Perbaiki weekday_name kapitalisasi (contoh: Senin, Selasa)
        UPDATE bronze.erp_time_info
        SET weekday_name = UPPER(LEFT(weekday_name, 1)) + LOWER(SUBSTRING(weekday_name, 2, LEN(weekday_name)));

        -- Pindahkan ke tabel silver
        TRUNCATE TABLE silver.erp_time_info;

        INSERT INTO silver.erp_time_info (
            time_id,
            full_date,
            day_num,
            month_num,
            year_num,
            weekday_name
        )
        SELECT
            time_id,
            full_date,
            day_num,
            month_num,
            year_num,
            weekday_name
        FROM bronze.erp_time_info
        WHERE time_id IS NOT NULL
          AND full_date IS NOT NULL
          AND day_num = DAY(full_date)
          AND month_num = MONTH(full_date)
          AND year_num = YEAR(full_date)
          AND weekday_name = DATENAME(WEEKDAY, full_date)
          AND full_date >= '2000-01-01'
          AND full_date <= CAST(GETDATE() AS DATE);

        ----------------------------
        -- ERP TRIP DETAIL
        ----------------------------
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

        -- Drop kolom speed_kmh jika ada
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

        -- Pindahkan ke tabel silver
        TRUNCATE TABLE silver.erp_trip_detail;

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
        FROM bronze.erp_trip_detail
        WHERE trip_id IS NOT NULL
          AND customer_id IS NOT NULL
          AND driver_id IS NOT NULL
          AND vehicle_id IS NOT NULL
          AND origin_location_id IS NOT NULL
          AND destination_location_id IS NOT NULL
          AND time_id IS NOT NULL;

        ----------------------------
        -- ERP VEHICLE INFO
        ----------------------------
        -- Bersihkan spasi dan kapitalisasi
        UPDATE bronze.erp_vehicle_info
        SET vehicle_type = UPPER(LTRIM(RTRIM(vehicle_type))),
            brand = UPPER(LTRIM(RTRIM(brand))),
            plate_number = UPPER(LTRIM(RTRIM(plate_number)));

        -- Hapus duplikat yang seluruh kolom sama
        WITH DuplicateVehicles AS (
            SELECT vehicle_id,
                   ROW_NUMBER() OVER (PARTITION BY vehicle_id, driver_id, vehicle_type, brand, plate_number ORDER BY vehicle_id) AS rn
            FROM bronze.erp_vehicle_info
        )
        DELETE v
        FROM bronze.erp_vehicle_info v
        INNER JOIN DuplicateVehicles d ON v.vehicle_id = d.vehicle_id
        WHERE d.rn > 1;

        -- Pindahkan ke tabel silver
        TRUNCATE TABLE silver.erp_vehicle_info;

        INSERT INTO silver.erp_vehicle_info (
            vehicle_id,
            driver_id,
            vehicle_type,
            brand,
            plate_number
        )
        SELECT
            vehicle_id,
            driver_id,
            vehicle_type,
            brand,
            plate_number
        FROM bronze.erp_vehicle_info
        WHERE vehicle_id IS NOT NULL
          AND driver_id IS NOT NULL
          AND vehicle_type IS NOT NULL
          AND brand IS NOT NULL
          AND plate_number IS NOT NULL;

        ----------------------------

        COMMIT;
    END TRY
    BEGIN CATCH
        ROLLBACK;
        THROW;
    END CATCH
END;
