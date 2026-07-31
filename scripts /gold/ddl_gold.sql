/*
=========================================================================================================
DDL Script: Create Gold Layer Views
=========================================================================================================

Script Purpose:

    This script creates the analytical views for the Gold layer of the Data Warehouse.

    The Gold layer represents the final Star Schema used for business intelligence,
    reporting, dashboards, and data analysis.

    The views transform, enrich, and combine data from the Silver layer into
    clean, business-ready dimension and fact tables.

Views Created:

    - gold.dim_customers
        Customer dimension enriched with demographic and location information.

    - gold.dim_products
        Product dimension enriched with category, subcategory, and maintenance data.

    - gold.fact_sales
        Sales fact table linking customers and products through surrogate keys
        while exposing sales measures for reporting.

Data Sources:

    - silver.crm_cust_info
    - silver.crm_prd_info
    - silver.crm_sales_details
    - silver.erp_cust_az12
    - silver.erp_loc_a101
    - silver.erp_px_cat_g1v2

Business Rules Applied:

    - Generate surrogate keys using ROW_NUMBER().
    - Standardize customer gender values.
    - Filter historical product records.
    - Enrich products using category lookup tables.
    - Replace business keys with surrogate keys in the fact table.
    - Preserve unmatched records using LEFT JOINs where appropriate.

Usage:

    Execute this script after the Silver layer has been successfully loaded.

=========================================================================================================
*/
