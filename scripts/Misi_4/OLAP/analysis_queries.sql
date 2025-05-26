-- Roll up Menganalisis data dari granularitas lebih rendah ke lebih tinggi (hari → bulan → tahun).

-- Total jumlah trip per bulan:

SELECT 
    dt.year_num,
    dt.month_num,
    COUNT(ft.trip_id) AS total_trip
FROM gold.fact_trip AS ft
JOIN gold.dim_time AS dt ON ft.time_id = dt.time_key
GROUP BY dt.year_num, dt.month_num
ORDER BY dt.year_num, dt.month_num;

-- DRILL-DOWN (agregat → detail.)
-- Detail jumlah trip per tanggal dalam bulan tertentu:

SELECT 
    dt.full_date,
    COUNT(ft.trip_id) AS total_trip
FROM gold.fact_trip AS ft
JOIN gold.dim_time AS dt ON ft.time_id = dt.time_key
WHERE dt.year_num = 2024 AND dt.month_num = 12
GROUP BY dt.full_date
ORDER BY dt.full_date;

-- SLICE (Memfilter data hanya pada satu dimensi.)
-- Total pendapatan dari metode pembayaran GoPay saja:

SELECT 
    dt.month_num,
    dt.year_num,
    SUM(fp.amount) AS total_amount
FROM gold.fact_payment AS fp
JOIN gold.dim_time AS dt ON fp.time_id = dt.time_key
WHERE fp.payment_method = 'cash'
GROUP BY dt.year_num, dt.month_num
ORDER BY dt.year_num, dt.month_num;

-- DICE (Filter lebih dari satu dimensi (kombinasi).)
-- Total jumlah trip untuk driver aktif ke lokasi “Kampus ITERA” pada bulan Desember 2024:

SELECT 
    d.full_name AS driver_name,
    COUNT(ft.trip_id) AS total_trip
FROM gold.fact_trip AS ft
JOIN gold.dim_driver AS d ON ft.driver_id = d.driver_key
JOIN gold.dim_location AS loc ON ft.destination_location_id = loc.location_key
JOIN gold.dim_time AS dt ON ft.time_id = dt.time_key
WHERE d.status_driver = 'SUSPENDED'
  AND loc.location_name = 'gang ahmad yani'
  AND dt.month_num = 12 AND dt.year_num = 2024
GROUP BY d.full_name
ORDER BY total_trip DESC;

-- PIVOT (Cross-tabulation) (Mengubah baris menjadi kolom untuk membandingkan antar kategori.)
SELECT 
    payment_method,
    SUM(CASE WHEN dt.month_num = 1 THEN fp.amount ELSE 0 END) AS Jan,
    SUM(CASE WHEN dt.month_num = 2 THEN fp.amount ELSE 0 END) AS Feb,
    SUM(CASE WHEN dt.month_num = 3 THEN fp.amount ELSE 0 END) AS Mar
FROM gold.fact_payment AS fp
JOIN gold.dim_time AS dt ON fp.time_id = dt.time_key
WHERE dt.year_num = 2024
GROUP BY payment_method;

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

-- Persentase Penggunaan Metode Pembayaran
SELECT 
    payment_method,
    COUNT(*) AS jumlah,
    ROUND(100.0 * COUNT(*) / SUM(COUNT(*)) OVER(), 2) AS persen_penggunaan
FROM gold.fact_payment
GROUP BY payment_method;






