-- =====================================================================
-- 2.2 DESIGN STORAGE
-- =====================================================================

PRINT '===========================================================';
PRINT 'STORAGE DESIGN - FILEGROUPS AND COMPRESSION';
PRINT '===========================================================';

-- Create FileGroups for Data Warehouse (Physical Design)
IF NOT EXISTS (SELECT * FROM sys.filegroups WHERE name = 'FG_DW_DIMENSIONS')
BEGIN
    ALTER DATABASE RHDataWarehouse 
    ADD FILEGROUP FG_DW_DIMENSIONS;
END

IF NOT EXISTS (SELECT * FROM sys.filegroups WHERE name = 'FG_DW_FACTS')
BEGIN
    ALTER DATABASE RHDataWarehouse 
    ADD FILEGROUP FG_DW_FACTS;
END

IF NOT EXISTS (SELECT * FROM sys.filegroups WHERE name = 'FG_DW_INDEXES')
BEGIN
    ALTER DATABASE RHDataWarehouse 
    ADD FILEGROUP FG_DW_INDEXES;
END

-- Add Files to FileGroups
IF NOT EXISTS (SELECT * FROM sys.master_files WHERE name = 'DW_Dimensions_Data')
BEGIN
    ALTER DATABASE RHDataWarehouse
    ADD FILE (
        NAME = 'DW_Dimensions_Data',
        FILENAME = 'C:\data_warehouse_project26\data\dw_dimensions.ndf',
        SIZE = 100MB,
        MAXSIZE = 1GB,
        FILEGROWTH = 10MB
    ) TO FILEGROUP FG_DW_DIMENSIONS;
END

IF NOT EXISTS (SELECT * FROM sys.master_files WHERE name = 'DW_Facts_Data')
BEGIN
    ALTER DATABASE RHDataWarehouse
    ADD FILE (
        NAME = 'DW_Facts_Data',
        FILENAME = 'C:\data_warehouse_project26\data\dw_facts.ndf',
        SIZE = 500MB,
        MAXSIZE = 5GB,
        FILEGROWTH = 50MB
    ) TO FILEGROUP FG_DW_FACTS;
END

IF NOT EXISTS (SELECT * FROM sys.master_files WHERE name = 'DW_Indexes_Data')
BEGIN
    ALTER DATABASE RHDataWarehouse 
    ADD FILE (
        NAME = 'DW_Indexes_Data',
        FILENAME = 'C:\data_warehouse_project26\data\dw_indexes.ndf',
        SIZE = 200MB,
        MAXSIZE = 2GB,
        FILEGROWTH = 20MB
    ) TO FILEGROUP FG_DW_INDEXES;
END

-- Enable Data Compression for large tables
ALTER TABLE silver.erp_trip_detail REBUILD WITH (DATA_COMPRESSION = PAGE);
ALTER TABLE silver.crm_payment_transaction_detail REBUILD WITH (DATA_COMPRESSION = PAGE);
GO