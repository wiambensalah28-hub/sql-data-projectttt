-- ============================================================================
-- Checking: gold.dim_products
-- ============================================================================

-- Check for Uniqueness of Product Key in gold.dim_products
-- Expectation: No results

SELECT
    product_key,
    COUNT(*) AS duplicate_count
FROM gold.dim_products
GROUP BY product_key
HAVING COUNT(*) > 1;


-- ============================================================================
-- Checking: gold.fact_sales
-- ============================================================================

-- Check the data model connectivity between fact and dimension tables
-- Expectation: No results

SELECT *
FROM gold.fact_sales f

LEFT JOIN gold.dim_customers c
    ON c.customer_key = f.customer_key

LEFT JOIN gold.dim_products p
    ON p.product_key = f.product_key

WHERE
    c.customer_key IS NULL
    OR p.product_key IS NULL;


-- ============================================================================
-- Check for Duplicate Sales Records
-- ============================================================================

-- Expectation: No results

SELECT
    order_number,
    product_key,
    customer_key,
    COUNT(*) AS duplicate_count
FROM gold.fact_sales
GROUP BY
    order_number,
    product_key,
    customer_key
HAVING COUNT(*) > 1;


-- ============================================================================
-- Check for Invalid Sales Values
-- ============================================================================

-- Expectation: No results

SELECT *
FROM gold.fact_sales
WHERE
    sales_amount < 0
    OR quantity < 0
    OR price < 0;


-- ============================================================================
-- Gold Layer Quality Checks Completed
-- ============================================================================
