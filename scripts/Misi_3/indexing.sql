PRINT '===========================================================';
PRINT 'CREATING INDEXES - LOGICAL & PHYSICAL DESIGN';
PRINT '===========================================================';

-- Customer Info Indexes
IF EXISTS (SELECT * FROM sys.indexes WHERE name = 'IX_silver_customer_email' AND object_id = OBJECT_ID('silver.crm_customer_info'))
    DROP INDEX IX_silver_customer_email ON silver.crm_customer_info;
CREATE NONCLUSTERED INDEX IX_silver_customer_email 
ON silver.crm_customer_info (email);

IF EXISTS (SELECT * FROM sys.indexes WHERE name = 'IX_silver_customer_status' AND object_id = OBJECT_ID('silver.crm_customer_info'))
    DROP INDEX IX_silver_customer_status ON silver.crm_customer_info;
CREATE NONCLUSTERED INDEX IX_silver_customer_status 
ON silver.crm_customer_info (account_status)
INCLUDE (customer_id, full_name);

IF EXISTS (SELECT * FROM sys.indexes WHERE name = 'IX_silver_customer_type' AND object_id = OBJECT_ID('silver.crm_customer_info'))
    DROP INDEX IX_silver_customer_type ON silver.crm_customer_info;
CREATE NONCLUSTERED INDEX IX_silver_customer_type 
ON silver.crm_customer_info (user_type);

-- Driver Info Indexes
IF EXISTS (SELECT * FROM sys.indexes WHERE name = 'IX_silver_driver_status' AND object_id = OBJECT_ID('silver.erp_driver_info'))
    DROP INDEX IX_silver_driver_status ON silver.erp_driver_info;
CREATE NONCLUSTERED INDEX IX_silver_driver_status 
ON silver.erp_driver_info (status_driver)
INCLUDE (driver_id, full_name);

IF EXISTS (SELECT * FROM sys.indexes WHERE name = 'IX_silver_driver_license' AND object_id = OBJECT_ID('silver.erp_driver_info'))
    DROP INDEX IX_silver_driver_license ON silver.erp_driver_info;
CREATE NONCLUSTERED INDEX IX_silver_driver_license 
ON silver.erp_driver_info (license_number);

-- Location Info Indexes
IF EXISTS (SELECT * FROM sys.indexes WHERE name = 'IX_silver_location_coordinates' AND object_id = OBJECT_ID('silver.erp_location_info'))
    DROP INDEX IX_silver_location_coordinates ON silver.erp_location_info;
CREATE NONCLUSTERED INDEX IX_silver_location_coordinates 
ON silver.erp_location_info (latitude, longitude);

IF EXISTS (SELECT * FROM sys.indexes WHERE name = 'IX_silver_location_name' AND object_id = OBJECT_ID('silver.erp_location_info'))
    DROP INDEX IX_silver_location_name ON silver.erp_location_info;
CREATE NONCLUSTERED INDEX IX_silver_location_name 
ON silver.erp_location_info (location_name);

-- Time Info Indexes
IF EXISTS (SELECT * FROM sys.indexes WHERE name = 'IX_silver_time_date' AND object_id = OBJECT_ID('silver.erp_time_info'))
    DROP INDEX IX_silver_time_date ON silver.erp_time_info;
CREATE NONCLUSTERED INDEX IX_silver_time_date 
ON silver.erp_time_info (full_date);

IF EXISTS (SELECT * FROM sys.indexes WHERE name = 'IX_silver_time_month_year' AND object_id = OBJECT_ID('silver.erp_time_info'))
    DROP INDEX IX_silver_time_month_year ON silver.erp_time_info;
CREATE NONCLUSTERED INDEX IX_silver_time_month_year 
ON silver.erp_time_info (year_num, month_num);

IF EXISTS (SELECT * FROM sys.indexes WHERE name = 'IX_silver_time_weekday' AND object_id = OBJECT_ID('silver.erp_time_info'))
    DROP INDEX IX_silver_time_weekday ON silver.erp_time_info;
CREATE NONCLUSTERED INDEX IX_silver_time_weekday 
ON silver.erp_time_info (weekday_name);

-- Trip Detail Indexes
IF EXISTS (SELECT * FROM sys.indexes WHERE name = 'IX_silver_trip_customer' AND object_id = OBJECT_ID('silver.erp_trip_detail'))
    DROP INDEX IX_silver_trip_customer ON silver.erp_trip_detail;
CREATE NONCLUSTERED INDEX IX_silver_trip_customer 
ON silver.erp_trip_detail (customer_id)
INCLUDE (trip_id, driver_id, duration_minutes, distance_km);

IF EXISTS (SELECT * FROM sys.indexes WHERE name = 'IX_silver_trip_driver' AND object_id = OBJECT_ID('silver.erp_trip_detail'))
    DROP INDEX IX_silver_trip_driver ON silver.erp_trip_detail;
CREATE NONCLUSTERED INDEX IX_silver_trip_driver 
ON silver.erp_trip_detail (driver_id)
INCLUDE (trip_id, customer_id, duration_minutes, distance_km);

IF EXISTS (SELECT * FROM sys.indexes WHERE name = 'IX_silver_trip_time' AND object_id = OBJECT_ID('silver.erp_trip_detail'))
    DROP INDEX IX_silver_trip_time ON silver.erp_trip_detail;
CREATE NONCLUSTERED INDEX IX_silver_trip_time 
ON silver.erp_trip_detail (time_id)
INCLUDE (trip_id, customer_id, driver_id, duration_minutes, distance_km);

IF EXISTS (SELECT * FROM sys.indexes WHERE name = 'IX_silver_trip_locations' AND object_id = OBJECT_ID('silver.erp_trip_detail'))
    DROP INDEX IX_silver_trip_locations ON silver.erp_trip_detail;
CREATE NONCLUSTERED INDEX IX_silver_trip_locations 
ON silver.erp_trip_detail (origin_location_id, destination_location_id);

IF EXISTS (SELECT * FROM sys.indexes WHERE name = 'IX_silver_trip_analysis' AND object_id = OBJECT_ID('silver.erp_trip_detail'))
    DROP INDEX IX_silver_trip_analysis ON silver.erp_trip_detail;
CREATE NONCLUSTERED INDEX IX_silver_trip_analysis 
ON silver.erp_trip_detail (time_id, driver_id, customer_id)
INCLUDE (duration_minutes, distance_km, origin_location_id, destination_location_id);

-- Payment Transaction Indexes
IF EXISTS (SELECT * FROM sys.indexes WHERE name = 'IX_silver_payment_customer' AND object_id = OBJECT_ID('silver.crm_payment_transaction_detail'))
    DROP INDEX IX_silver_payment_customer ON silver.crm_payment_transaction_detail;
CREATE NONCLUSTERED INDEX IX_silver_payment_customer 
ON silver.crm_payment_transaction_detail (customer_id)
INCLUDE (transaction_id, amount, payment_method);

IF EXISTS (SELECT * FROM sys.indexes WHERE name = 'IX_silver_payment_time' AND object_id = OBJECT_ID('silver.crm_payment_transaction_detail'))
    DROP INDEX IX_silver_payment_time ON silver.crm_payment_transaction_detail;
CREATE NONCLUSTERED INDEX IX_silver_payment_time 
ON silver.crm_payment_transaction_detail (time_id)
INCLUDE (transaction_id, customer_id, amount);

IF EXISTS (SELECT * FROM sys.indexes WHERE name = 'IX_silver_payment_method' AND object_id = OBJECT_ID('silver.crm_payment_transaction_detail'))
    DROP INDEX IX_silver_payment_method ON silver.crm_payment_transaction_detail;
CREATE NONCLUSTERED INDEX IX_silver_payment_method 
ON silver.crm_payment_transaction_detail (payment_method);

IF EXISTS (SELECT * FROM sys.indexes WHERE name = 'IX_silver_payment_amount' AND object_id = OBJECT_ID('silver.crm_payment_transaction_detail'))
    DROP INDEX IX_silver_payment_amount ON silver.crm_payment_transaction_detail;
CREATE NONCLUSTERED INDEX IX_silver_payment_amount 
ON silver.crm_payment_transaction_detail (amount DESC);

-- Vehicle Info Indexes
IF EXISTS (SELECT * FROM sys.indexes WHERE name = 'IX_silver_vehicle_driver' AND object_id = OBJECT_ID('silver.erp_vehicle_info'))
    DROP INDEX IX_silver_vehicle_driver ON silver.erp_vehicle_info;
CREATE NONCLUSTERED INDEX IX_silver_vehicle_driver 
ON silver.erp_vehicle_info (driver_id);

IF EXISTS (SELECT * FROM sys.indexes WHERE name = 'IX_silver_vehicle_type' AND object_id = OBJECT_ID('silver.erp_vehicle_info'))
    DROP INDEX IX_silver_vehicle_type ON silver.erp_vehicle_info;
CREATE NONCLUSTERED INDEX IX_silver_vehicle_type 
ON silver.erp_vehicle_info (vehicle_type);
GO