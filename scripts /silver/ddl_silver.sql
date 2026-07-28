
/*==============================================================================
Stored Procedure: silver.load_silver
Schema          : Silver
Author          : Wiam Bensalah
Project         : SQL Data Warehouse Project

Description:
This stored procedure loads the Silver layer from the Bronze layer.

Main Tasks:
- Truncate existing data in Silver tables.
- Transform and clean data from the Bronze layer.
- Load cleaned data into the Silver layer.
- Print progress messages for each loading step.
- Measure and display the execution time of each table.
- Measure and display the total loading duration.
- Handle runtime errors using TRY...CATCH.

Source Tables:
- bronze.crm_cust_info
- bronze.crm_prd_info
- bronze.crm_sales_details
- bronze.erp_cust_az12
- bronze.erp_loc_a101
- bronze.erp_px_cat_g1v2

Target Tables:
- silver.crm_cust_info
- silver.crm_prd_info
- silver.crm_sales_details
- silver.erp_cust_az12
- silver.erp_loc_a101
- silver.erp_px_cat_g1v2
==============================================================================*/

CREATE OR ALTER PROCEDURE silver.load_silver
AS
BEGIN

    DECLARE @start_time DATETIME,
            @end_time DATETIME;

    DECLARE @batch_start_time DATETIME,
            @batch_end_time DATETIME;

    BEGIN TRY

        SET @batch_start_time = GETDATE();

        /*==========================================================
          Load CRM Customer Information
        ==========================================================*/

        SET @start_time = GETDATE();

        PRINT '>> Truncating Table: silver.crm_cust_info';
        TRUNCATE TABLE silver.crm_cust_info;

        PRINT '>> Inserting Data Into: silver.crm_cust_info';

        INSERT INTO silver.crm_cust_info
        (
            cst_id,
            cst_key,
            cst_firstname,
            cst_lastname,
            cst_marital_status,
            cst_gndr,
            cst_create_date
        )
        SELECT
            cst_id,
            cst_key,
            TRIM(cst_firstname),
            TRIM(cst_lastname),

            CASE
                WHEN UPPER(TRIM(cst_material_status)) = 'S' THEN 'Single'
                WHEN UPPER(TRIM(cst_material_status)) = 'M' THEN 'Married'
                ELSE 'N/A'
            END,

            CASE
                WHEN UPPER(TRIM(cst_gndr)) = 'M' THEN 'Male'
                WHEN UPPER(TRIM(cst_gndr)) = 'F' THEN 'Female'
                ELSE 'N/A'
            END,

            cst_create_date

        FROM bronze.crm_cust_info;

        SET @end_time = GETDATE();

        PRINT 'crm_cust_info loaded in '
            + CAST(DATEDIFF(SECOND,@start_time,@end_time) AS NVARCHAR)
            + ' seconds';


        /*==========================================================
          Load CRM Product Information
        ==========================================================*/

        SET @start_time = GETDATE();

        PRINT '>> Truncating Table: silver.crm_prd_info';
        TRUNCATE TABLE silver.crm_prd_info;

        PRINT '>> Inserting Data Into: silver.crm_prd_info';

        -- Your current INSERT...SELECT for crm_prd_info

        SET @end_time = GETDATE();

        PRINT 'crm_prd_info loaded in '
            + CAST(DATEDIFF(SECOND,@start_time,@end_time) AS NVARCHAR)
            + ' seconds';


        /*==========================================================
          Load CRM Sales Details
        ==========================================================*/

        SET @start_time = GETDATE();

        PRINT '>> Truncating Table: silver.crm_sales_details';
        TRUNCATE TABLE silver.crm_sales_details;

        PRINT '>> Inserting Data Into: silver.crm_sales_details';

        -- Your current INSERT...SELECT for crm_sales_details

        SET @end_time = GETDATE();

        PRINT 'crm_sales_details loaded in '
            + CAST(DATEDIFF(SECOND,@start_time,@end_time) AS NVARCHAR)
            + ' seconds';


        /*==========================================================
          Load ERP Customer Information
        ==========================================================*/

        SET @start_time = GETDATE();

        PRINT '>> Truncating Table: silver.erp_cust_az12';
        TRUNCATE TABLE silver.erp_cust_az12;

        PRINT '>> Inserting Data Into: silver.erp_cust_az12';

        -- Your current INSERT...SELECT for erp_cust_az12

        SET @end_time = GETDATE();

        PRINT 'erp_cust_az12 loaded in '
            + CAST(DATEDIFF(SECOND,@start_time,@end_time) AS NVARCHAR)
            + ' seconds';


        /*==========================================================
          Load ERP Location
        ==========================================================*/

        SET @start_time = GETDATE();

        PRINT '>> Truncating Table: silver.erp_loc_a101';
        TRUNCATE TABLE silver.erp_loc_a101;

        PRINT '>> Inserting Data Into: silver.erp_loc_a101';

        -- Your current INSERT...SELECT for erp_loc_a101

        SET @end_time = GETDATE();

        PRINT 'erp_loc_a101 loaded in '
            + CAST(DATEDIFF(SECOND,@start_time,@end_time) AS NVARCHAR)
            + ' seconds';


        /*==========================================================
          Load ERP Product Categories
        ==========================================================*/

        SET @start_time = GETDATE();

        PRINT '>> Truncating Table: silver.erp_px_cat_g1v2';
        TRUNCATE TABLE silver.erp_px_cat_g1v2;

        PRINT '>> Inserting Data Into: silver.erp_px_cat_g1v2';

        -- Your current INSERT...SELECT for erp_px_cat_g1v2

        SET @end_time = GETDATE();

        PRINT 'erp_px_cat_g1v2 loaded in '
            + CAST(DATEDIFF(SECOND,@start_time,@end_time) AS NVARCHAR)
            + ' seconds';


        SET @batch_end_time = GETDATE();

        PRINT '=========================================';
        PRINT 'SILVER LAYER LOADED';
        PRINT 'Total Duration: '
            + CAST(DATEDIFF(SECOND,@batch_start_time,@batch_end_time) AS NVARCHAR)
            + ' seconds';
        PRINT '=========================================';

    END TRY

    BEGIN CATCH

        PRINT '=========================================';
        PRINT 'ERROR OCCURRED DURING LOADING SILVER LAYER';
        PRINT '=========================================';
        PRINT ERROR_MESSAGE();

    END CATCH

END;
GO
