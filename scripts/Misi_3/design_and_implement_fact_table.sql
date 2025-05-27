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
