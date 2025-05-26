CREATE TABLE silver.crm_customer_info (
	customer_id INT,
	full_name NVARCHAR(50),
	email NVARCHAR(50),
	phone NVARCHAR(50),
	user_type NVARCHAR(50),
	account_status NVARCHAR(50),
	dwh_create_date DATETIME2 DEFAULT GETDATE()
);

CREATE TABLE silver.crm_payment_transaction_detail (
	transaction_id INT,
	customer_id INT,
	payment_method NVARCHAR(50),
	amount DECIMAL(10, 2),
	promo_id NVARCHAR(50),
	time_id INT,
	dwh_create_date DATETIME2 DEFAULT GETDATE()
);

CREATE TABLE silver.erp_driver_info (
	driver_id INT,
	full_name NVARCHAR(50),
	phone NVARCHAR(50),
	license_number NVARCHAR(50),
	status NVARCHAR(50),
	dwh_create_date DATETIME2 DEFAULT GETDATE()
);

CREATE TABLE silver.erp_location_info (
	location_id INT,
	location_name NVARCHAR(50),
	latitude DECIMAL(9, 6),
	longitude DECIMAL(9, 6),
	dwh_create_date DATETIME2 DEFAULT GETDATE()
);

CREATE TABLE silver.erp_time_info (
	time_id INT,
	full_date DATE,
	day_num INT,
	month_num INT,
	year_num INT,
	weekday_name NVARCHAR(50),
	dwh_create_date DATETIME2 DEFAULT GETDATE()
);

CREATE TABLE silver.erp_trip_detail (
	trip_id INT,
	customer_id INT,
	driver_id INT,
	vehicle_id INT,
	origin_location_id INT,
	destination_location_id INT,
	time_id INT,
	duration_minutes INT,
	distance_km DECIMAL(5, 2),
	dwh_create_date DATETIME2 DEFAULT GETDATE()
);

CREATE TABLE silver.erp_vehicle_info (
	vehicle_id INT,
	driver_id INT,
	vehicle_type NVARCHAR(50),
	brand NVARCHAR(50),
	plate_number NVARCHAR(50),
	dwh_create_date DATETIME2 DEFAULT GETDATE()
);