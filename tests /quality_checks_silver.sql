/*
===============================================================================

Script: Data Quality Checks - Silver Layer

===============================================================================

Script Purpose:
    This script performs various data quality checks for data consistency,
    accuracy, completeness, and standardization across the Silver schema.

Quality Checks Performed:
    - Checks for NULL values or duplicate primary keys.
    - Checks for unwanted spaces in string fields.
    - Validates data standardization and consistency.
    - Checks for invalid data ranges and chronological order.
    - Verifies data consistency between related fields.

Instructions:
    - Run this script after loading the Silver layer.
    - Investigate and resolve any returned records.
    - A successful validation should return zero rows for most queries.

===============================================================================
*/

-- ============================================================================
-- CRM CUSTOMER INFORMATION
-- ============================================================================

-- Check for NULL or duplicate customer IDs
SELECT
    cst_id,
    COUNT(*) AS duplicate_count
FROM silver.crm_cust_info
GROUP BY cst_id
HAVING cst_id IS NULL
    OR COUNT(*) > 1;

-- Check for unwanted spaces
SELECT *
FROM silver.crm_cust_info
WHERE cst_firstname <> TRIM(cst_firstname)
   OR cst_lastname <> TRIM(cst_lastname);

-- Check gender values
SELECT DISTINCT cst_gndr
FROM silver.crm_cust_info;

-- Check marital status values
SELECT DISTINCT cst_marital_status
FROM silver.crm_cust_info;



-- ============================================================================
-- CRM PRODUCT INFORMATION
-- ============================================================================

-- Check for NULL or duplicate product IDs
SELECT
    prd_id,
    COUNT(*) AS duplicate_count
FROM silver.crm_prd_info
GROUP BY prd_id
HAVING prd_id IS NULL
    OR COUNT(*) > 1;

-- Check for negative product cost
SELECT *
FROM silver.crm_prd_info
WHERE prd_cost < 0;

-- Check product line standardization
SELECT DISTINCT prd_line
FROM silver.crm_prd_info;

-- Check invalid product dates
SELECT *
FROM silver.crm_prd_info
WHERE prd_end_dt < prd_start_dt;



-- ============================================================================
-- CRM SALES DETAILS
-- ============================================================================

-- Check for NULL or duplicate order numbers
SELECT
    sls_ord_num,
    COUNT(*) AS duplicate_count
FROM silver.crm_sales_details
GROUP BY sls_ord_num
HAVING sls_ord_num IS NULL
    OR COUNT(*) > 1;

-- Check invalid date order
SELECT *
FROM silver.crm_sales_details
WHERE sls_order_dt > sls_ship_dt
   OR sls_ship_dt > sls_due_dt;

-- Check negative quantities
SELECT *
FROM silver.crm_sales_details
WHERE sls_quantity <= 0;

-- Check negative sales
SELECT *
FROM silver.crm_sales_details
WHERE sls_sales < 0;

-- Check negative prices
SELECT *
FROM silver.crm_sales_details
WHERE sls_price < 0;



-- ============================================================================
-- ERP CUSTOMER INFORMATION
-- ============================================================================

-- Check for NULL customer IDs
SELECT *
FROM silver.erp_cust_az12
WHERE cid IS NULL;

-- Check future birth dates
SELECT *
FROM silver.erp_cust_az12
WHERE bdate > GETDATE();

-- Check gender standardization
SELECT DISTINCT gen
FROM silver.erp_cust_az12;



-- ============================================================================
-- ERP CUSTOMER LOCATION
-- ============================================================================

-- Check NULL customer IDs
SELECT *
FROM silver.erp_loc_a101
WHERE cid IS NULL;

-- Check country values
SELECT DISTINCT cntry
FROM silver.erp_loc_a101;



-- ============================================================================
-- ERP PRODUCT CATEGORIES
-- ============================================================================

-- Check NULL IDs
SELECT *
FROM silver.erp_px_cat_g1v2
WHERE id IS NULL;

-- Check duplicate category IDs
SELECT
    id,
    COUNT(*) AS duplicate_count
FROM silver.erp_px_cat_g1v2
GROUP BY id
HAVING COUNT(*) > 1;

-- Check category values
SELECT DISTINCT cat
FROM silver.erp_px_cat_g1v2;

-- Check subcategory values
SELECT DISTINCT subcat
FROM silver.erp_px_cat_g1v2;

-- Check maintenance values
SELECT DISTINCT maintenance
FROM silver.erp_px_cat_g1v2;
