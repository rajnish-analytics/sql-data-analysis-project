/*
===========================================================================================================================================
9. Performance Analysis: (Evaluating business performance against benchmarks and historical trends)
===========================================================================================================================================
Purpose:
    • Measure yearly product performance using sales metrics
    • Compare current sales against historical averages
    • Perform Year-over-Year (YoY) growth analysis
    • Identify products showing growth, decline, or stable performance
    • Analyze deviations from average sales benchmarks
    • Evaluate business performance trends over time
===========================================================================================================================================
*/

-- Yearly Performance of Product by Comparing to Average Sales & Year-over-Year Analysis
SELECT
YEAR(s.order_date) order_year,
p.product_name,
SUM(s.sales_amount) total_sales_per_product,   -- Total sales amount per year for each product
AVG(SUM(s.sales_amount)) OVER(PARTITION BY p.product_name) avg_total_sales,   -- Average yearly sales for each product across all available years
SUM(s.sales_amount) - AVG(SUM(s.sales_amount)) OVER(PARTITION BY p.product_name) diff_avg_sales,
CASE WHEN SUM(s.sales_amount) > AVG(SUM(s.sales_amount)) OVER(PARTITION BY p.product_name) THEN 'Above Average'
     WHEN SUM(s.sales_amount) < AVG(SUM(s.sales_amount)) OVER(PARTITION BY p.product_name) THEN 'Below Average'
     ELSE 'Average' END performance_status,
-- Year-over-Year Analysis
LAG(SUM(s.sales_amount)) OVER(PARTITION BY p.product_name ORDER BY YEAR(s.order_date)) prev_year_sales,
SUM(s.sales_amount) - LAG(SUM(s.sales_amount)) OVER(PARTITION BY p.product_name ORDER BY YEAR(s.order_date)) diff_prev_sales,
CASE WHEN SUM(s.sales_amount) - LAG(SUM(s.sales_amount)) OVER(PARTITION BY p.product_name ORDER BY YEAR(s.order_date)) > 0 THEN 'Growth'
     WHEN SUM(s.sales_amount) - LAG(SUM(s.sales_amount)) OVER(PARTITION BY p.product_name ORDER BY YEAR(s.order_date)) < 0 THEN 'Decline'
     ELSE 'No Change' END growth_status
FROM gold.fact_sales_info s
LEFT JOIN gold.dim_product_info p
ON s.product_key = p.product_key
WHERE s.order_date IS NOT NULL
GROUP BY YEAR(s.order_date), p.product_name
ORDER BY 2, 1;