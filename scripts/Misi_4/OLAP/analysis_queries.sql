-- Total Perjalanan per Bulan
SELECT 
    td.year_num,
    td.month_num,
    COUNT(tf.trip_id) AS total_trip
FROM gold.fact_trip AS tf
JOIN gold.dim_time AS td ON tf.time_id = td.time_key
GROUP BY td.year_num, td.month_num
ORDER BY td.year_num, td.month_num;

-- Rata-rata Durasi Trip per Tipe Kendaraan dalam menit
SELECT 
    vd.vehicle_type,
    AVG(tf.duration_minutes) AS avg_duration
FROM gold.fact_trip AS tf
JOIN gold.dim_vehicle AS vd ON tf.vehicle_id = vd.vehicle_key
GROUP BY vd.vehicle_type;

-- Total Pendapatan per Driver
SELECT 
    dd.driver_id,
    dd.full_name AS driver_name,
    SUM(pf.amount) AS total_income
FROM gold.fact_payment AS pf
JOIN gold.fact_trip AS tf 
    ON pf.customer_id = tf.customer_id AND pf.time_id = tf.time_id
JOIN gold.dim_driver AS dd 
    ON tf.driver_id = dd.driver_key
GROUP BY dd.driver_id, dd.full_name
ORDER BY total_income DESC;

-- Top 5 Lokasi Tujuan Terpopuler
SELECT TOP 5
    ld.location_name AS destination,
    COUNT(*) AS trip_count
FROM gold.fact_trip AS tf
JOIN gold.dim_location AS ld ON tf.destination_location_id = ld.location_key
GROUP BY ld.location_name
ORDER BY trip_count DESC;

-- 5. Persentase Penggunaan Metode Pembayaran
SELECT 
    payment_method,
    COUNT(*) AS jumlah,
    ROUND(100.0 * COUNT(*) / SUM(COUNT(*)) OVER(), 2) AS persen_penggunaan
FROM gold.fact_payment
GROUP BY payment_method;


