EXEC bronze.load_bronze

CREATE OR ALTER PROCEDURE bronze.load_bronze AS
BEGIN
	DECLARE @start_time DATETIME, @end_time DATETIME, @batch_start_time DATETIME, @batch_end_time DATETIME;
	BEGIN TRY
		SET @batch_start_time = GETDATE();
		PRINT '============================================================';
		PRINT 'Loading Broze Layer';
		PRINT '============================================================';

		PRINT '------------------------------------------------------------';
		PRINT 'Loading CRM Tables';
		PRINT '------------------------------------------------------------';

		SET @start_time = GETDATE();
		PRINT '>>> Truncate Table: bronze.crm_customer_info';
		TRUNCATE TABLE bronze.crm_customer_info
		PRINT '>>> Insert Data into: bronze.crm_customer_info';
		BULK INSERT bronze.crm_customer_info
		FROM 'C:\data_warehouse_project26\datasets\source_crm\customer_info.csv'
		WITH (
			FIRSTROW = 2,
			FIELDTERMINATOR = ';',
			TABLOCK
		);
		SET @end_time = GETDATE();
		PRINT '>> Load Duration: ' + CAST(DATEDIFF(second, @start_time, @end_time) AS NVARCHAR) + ' seconds';
		PRINT '>> -------------';

		SET @start_time = GETDATE();
		PRINT '>>> Truncate Table: bronze.crm_payment_transaction_detail';
		TRUNCATE TABLE bronze.crm_payment_transaction_detail
		PRINT '>>> Insert Data into: bronze.crm_payment_transaction_detail';
		BULK INSERT bronze.crm_payment_transaction_detail
		FROM 'C:\data_warehouse_project26\datasets\source_crm\payment_transaction_detail.csv'
		WITH (
			FIRSTROW = 2,
			FIELDTERMINATOR = ',',
			TABLOCK
		);
		SET @end_time = GETDATE();
		PRINT '>> Load Duration: ' + CAST(DATEDIFF(second, @start_time, @end_time) AS NVARCHAR) + ' seconds';
		PRINT '>> -------------';

		PRINT '------------------------------------------------------------';
		PRINT 'Loading ERP Tables';
		PRINT '------------------------------------------------------------';

		SET @start_time = GETDATE();
		PRINT '>>> Truncate Table: bronze.erp_driver_info';
		TRUNCATE TABLE bronze.erp_driver_info
		PRINT '>>> Insert Data into: bronze.erp_driver_info';
		BULK INSERT bronze.erp_driver_info
		FROM 'C:\data_warehouse_project26\datasets\source_erp\driver_info.csv'
		WITH (
			FIRSTROW = 2,
			FIELDTERMINATOR = ';',
			TABLOCK
		);
		SET @end_time = GETDATE();
		PRINT '>> Load Duration: ' + CAST(DATEDIFF(second, @start_time, @end_time) AS NVARCHAR) + ' seconds';
		PRINT '>> -------------';

		SET @start_time = GETDATE();
		PRINT '>>> Truncate Table: bronze.erp_location_info';
		TRUNCATE TABLE bronze.erp_location_info
		PRINT '>>> Insert Data into: bronze.erp_location_info';
		BULK INSERT bronze.erp_location_info
		FROM 'C:\data_warehouse_project26\datasets\source_erp\location_info.csv'
		WITH (
			FIRSTROW = 2,
			FIELDTERMINATOR = ',',
			TABLOCK
		);
		SET @end_time = GETDATE();
		PRINT '>> Load Duration: ' + CAST(DATEDIFF(second, @start_time, @end_time) AS NVARCHAR) + ' seconds';
		PRINT '>> -------------';

		SET @start_time = GETDATE();
		PRINT '>>> Truncate Table: bronze.erp_time_info';
		TRUNCATE TABLE bronze.erp_time_info
		PRINT '>>> Insert Data into: bronze.erp_time_info';
		BULK INSERT bronze.erp_time_info
		FROM 'C:\data_warehouse_project26\datasets\source_erp\time_info.csv'
		WITH (
			FIRSTROW = 2,
			FIELDTERMINATOR = ',',
			TABLOCK
		);
		SET @end_time = GETDATE();
		PRINT '>> Load Duration: ' + CAST(DATEDIFF(second, @start_time, @end_time) AS NVARCHAR) + ' seconds';
		PRINT '>> -------------';

		SET @start_time = GETDATE();
		PRINT '>>> Truncate Table: bronze.erp_trip_detail';
		TRUNCATE TABLE bronze.erp_trip_detail
		PRINT '>>> Insert Data into: bronze.erp_trip_detail';
		BULK INSERT bronze.erp_trip_detail
		FROM 'C:\data_warehouse_project26\datasets\source_erp\trip_detail.csv'
		WITH (
			FIRSTROW = 2,
			FIELDTERMINATOR = ',',
			TABLOCK
		);
		SET @end_time = GETDATE();
		PRINT '>> Load Duration: ' + CAST(DATEDIFF(second, @start_time, @end_time) AS NVARCHAR) + ' seconds';
		PRINT '>> -------------';

		SET @start_time = GETDATE();
		PRINT '>>> Truncate Table: bronze.erp_vehicle_info';
		TRUNCATE TABLE bronze.erp_vehicle_info
		PRINT '>>> Insert Data into: bronze.erp_vehicle_info';
		BULK INSERT bronze.erp_vehicle_info
		FROM 'C:\data_warehouse_project26\datasets\source_erp\vehicle_info.csv'
		WITH (
			FIRSTROW = 2,
			FIELDTERMINATOR = ',',
			TABLOCK
		);
		SET @end_time = GETDATE();
		PRINT '>> Load Duration: ' + CAST(DATEDIFF(second, @start_time, @end_time) AS NVARCHAR) + ' seconds';
		PRINT '>> -------------';

		SET @batch_end_time = GETDATE();
		PRINT '=========================================='
		PRINT 'Loading Bronze Layer is Completed';
        PRINT '   - Total Load Duration: ' + CAST(DATEDIFF(SECOND, @batch_start_time, @batch_end_time) AS NVARCHAR) + ' seconds';
		PRINT '=========================================='
	END TRY
	BEGIN CATCH
		PRINT '============================================================='
		PRINT 'ERROR OCCURED DURING LOADING BRONZE LAYER'
		PRINT 'Error Message' + ERROR_MESSAGE();
		PRINT 'Error Message' + CAST (ERROR_NUMBER() AS NVARCHAR);
		PRINT 'Error Message' + CAST (ERROR_STATE() AS NVARCHAR);
		PRINT '============================================================='
	END CATCH
END

