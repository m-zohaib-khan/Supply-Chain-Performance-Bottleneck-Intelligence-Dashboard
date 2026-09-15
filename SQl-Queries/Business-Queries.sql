USE supply_chain_dashboard;


-- ══════════════════════════════════════════════
-- QUERY 1: Overall Supply Chain Health Summary
-- ══════════════════════════════════════════════
SELECT
    COUNT(*)                                    AS total_orders,
    SUM(is_late)                                AS late_orders,
    ROUND(AVG(is_late) * 100, 2)               AS late_rate_pct,
    ROUND(100 - AVG(is_late) * 100, 2)         AS on_time_rate_pct,
    ROUND(AVG(
        CASE WHEN is_late = 1 
        THEN delay_days END), 2)                AS avg_delay_days,
    ROUND(SUM(sales), 2)                        AS total_revenue,
    ROUND(SUM(profit_per_order), 2)             AS total_profit,
    ROUND(AVG(profit_margin_pct), 2)            AS avg_profit_margin_pct,
    ROUND(SUM(revenue_at_risk), 2)              AS total_revenue_at_risk,
    ROUND(
        SUM(revenue_at_risk) / 
        NULLIF(SUM(sales), 0) * 100
    , 2)                                        AS revenue_at_risk_pct
FROM fact_order_items;


-- ══════════════════════════════════════════════
-- QUERY 2: Supplier Performance Scorecard
-- ══════════════════════════════════════════════
SELECT
    supplier_proxy                              AS supplier,
    total_orders,
    late_orders,
    ROUND(on_time_rate, 2)                      AS on_time_rate_pct,
    ROUND(avg_delay, 2)                         AS avg_delay_days,
    ROUND(total_revenue, 2)                     AS revenue_handled,
    ROUND(total_profit, 2)                      AS profit_generated,
    risk_flag,
    RANK() OVER (
        ORDER BY on_time_rate DESC
    )                                           AS performance_rank
FROM dim_supplier_proxy
ORDER BY on_time_rate ASC;


-- ══════════════════════════════════════════════
-- QUERY 3: Late Delivery Rate by Category
-- ══════════════════════════════════════════════
SELECT
    c.category_name,
    COUNT(*)                                    AS total_orders,
    SUM(f.is_late)                              AS late_orders,
    ROUND(AVG(f.is_late) * 100, 2)              AS late_rate_pct,
    ROUND(AVG(f.delay_days), 2)                 AS avg_delay_days,
    ROUND(SUM(f.sales), 2)                      AS total_revenue,
    ROUND(SUM(f.revenue_at_risk), 2)            AS revenue_at_risk,
    RANK() OVER (
        ORDER BY AVG(f.is_late) DESC
    )                                           AS delay_rank
FROM fact_order_items f
JOIN dim_product p ON f.product_id = p.product_id
JOIN dim_category c ON p.category_id = c.category_id
GROUP BY c.category_id, c.category_name
ORDER BY late_rate_pct DESC;


-- ══════════════════════════════════════════════
-- QUERY 4: ABC Class vs Delivery Performance
-- (Most Critical Analysis)
-- ══════════════════════════════════════════════
SELECT
    p.abc_class,
    COUNT(*)                                    AS total_orders,
    SUM(f.is_late)                              AS late_orders,
    ROUND(AVG(f.is_late) * 100, 2)              AS late_rate_pct,
    ROUND(SUM(f.sales), 2)                      AS total_revenue,
    ROUND(SUM(f.revenue_at_risk), 2)            AS revenue_at_risk,
    ROUND(
        SUM(f.revenue_at_risk) / 
        NULLIF(SUM(f.sales), 0) * 100
    , 2)                                        AS revenue_at_risk_pct,
    ROUND(AVG(f.profit_margin_pct), 2)           AS avg_margin_pct,
    ROUND(
        SUM(f.sales) / 
        (SELECT SUM(sales) FROM fact_order_items) * 100
    , 2)                                        AS revenue_share_pct
FROM fact_order_items f
JOIN dim_product p ON f.product_id = p.product_id
GROUP BY p.abc_class
ORDER BY p.abc_class;


-- ══════════════════════════════════════════════
-- QUERY 5: Regional Bottleneck Analysis
-- ══════════════════════════════════════════════
SELECT
    order_region,
    market,
    COUNT(*)                                    AS total_orders,
    SUM(is_late)                                AS late_orders,
    ROUND(AVG(is_late) * 100, 2)               AS late_rate_pct,
    ROUND(AVG(delay_days), 2)                 AS avg_delay_days,
    ROUND(SUM(sales), 2)                        AS total_revenue,
    ROUND(SUM(revenue_at_risk), 2)              AS revenue_at_risk,
    RANK() OVER (
        ORDER BY AVG(is_late) DESC
    )                                           AS risk_rank
FROM fact_order_items
GROUP BY order_region, market
ORDER BY late_rate_pct DESC;


-- ══════════════════════════════════════════════
-- QUERY 6: Shipping Mode Performance
-- ══════════════════════════════════════════════
SELECT
    sm.shipping_mode,
    COUNT(*)                                    AS total_orders,
    SUM(f.is_late)                              AS late_orders,
    ROUND(AVG(f.is_late) * 100, 2)              AS late_rate_pct,
    ROUND(AVG(f.actual_shipping_days), 2)       AS avg_actual_days,
    ROUND(AVG(f.scheduled_shipping_days), 2)    AS avg_scheduled_days,
    ROUND(AVG(f.delay_days), 2)                 AS avg_delay_days,
    ROUND(SUM(f.sales), 2)                      AS total_revenue,
    ROUND(SUM(f.revenue_at_risk), 2)            AS revenue_at_risk
FROM fact_order_items f
JOIN dim_shipping_mode sm ON f.shipping_mode_id = sm.shipping_mode_id
GROUP BY sm.shipping_mode_id, sm.shipping_mode
ORDER BY late_rate_pct DESC;


-- ══════════════════════════════════════════════
-- QUERY 7: Monthly Trend Analysis
-- ══════════════════════════════════════════════
WITH monthly AS (
    SELECT
        order_yearmonth,
        order_year,
        order_month,
        COUNT(*)                                AS total_orders,
        SUM(is_late)                            AS late_orders,
        ROUND(AVG(is_late) * 100, 2)           AS late_rate_pct,
        ROUND(SUM(sales), 2)                    AS revenue,
        ROUND(SUM(revenue_at_risk), 2)          AS revenue_at_risk,
        ROUND(SUM(profit_per_order), 2)         AS profit
    FROM fact_order_items
    GROUP BY order_yearmonth, order_year, order_month
)
SELECT
    order_yearmonth,
    total_orders,
    late_orders,
    late_rate_pct,
    revenue,
    revenue_at_risk,
    profit,
    LAG(late_rate_pct) OVER (
        ORDER BY order_year, order_month
    )                                           AS prev_month_late_rate,
    ROUND(
        late_rate_pct - LAG(late_rate_pct) OVER (
            ORDER BY order_year, order_month
        )
    , 2)                                        AS late_rate_change
FROM monthly
ORDER BY order_year, order_month;


-- ══════════════════════════════════════════════
-- QUERY 8: Customer Segment Analysis
-- ══════════════════════════════════════════════
SELECT
    c.customer_segment,
    COUNT(*)                                    AS total_orders,
    ROUND(AVG(f.is_late) * 100, 2)              AS late_rate_pct,
    ROUND(SUM(f.sales), 2)                      AS total_revenue,
    ROUND(AVG(f.sales), 2)                      AS avg_order_value,
    ROUND(SUM(f.profit_per_order), 2)           AS total_profit,
    ROUND(AVG(f.profit_margin_pct), 2)          AS avg_margin_pct,
    ROUND(SUM(f.revenue_at_risk), 2)            AS revenue_at_risk
FROM fact_order_items f
JOIN dim_customer c ON f.customer_id = c.customer_id
GROUP BY c.customer_segment
ORDER BY total_revenue DESC;


-- ══════════════════════════════════════════════
-- QUERY 9: Department Performance
-- ══════════════════════════════════════════════
SELECT
    d.department_name,
    COUNT(*)                                    AS total_orders,
    ROUND(AVG(f.is_late) * 100, 2)              AS late_rate_pct,
    ROUND(SUM(f.sales), 2)                      AS total_revenue,
    ROUND(SUM(f.profit_per_order), 2)           AS total_profit,
    ROUND(AVG(f.profit_margin_pct), 2)          AS avg_margin_pct,
    ROUND(SUM(f.revenue_at_risk), 2)            AS revenue_at_risk,
    RANK() OVER (
        ORDER BY SUM(f.sales) DESC
    )                                           AS revenue_rank
FROM fact_order_items f
JOIN dim_product p ON f.product_id = p.product_id
JOIN dim_category c ON p.category_id = c.category_id
JOIN dim_department d ON c.department_id = d.department_id
GROUP BY d.department_id, d.department_name
ORDER BY total_revenue DESC;


-- ══════════════════════════════════════════════
-- QUERY 10: Discount Impact on Profitability
-- ══════════════════════════════════════════════
SELECT
    has_discount,
    COUNT(*)                                    AS total_orders,
    ROUND(AVG(sales), 2)                        AS avg_order_value,
    ROUND(AVG(profit_margin_pct), 2)           AS avg_margin_pct,
    ROUND(SUM(sales), 2)                        AS total_revenue,
    ROUND(SUM(profit_per_order), 2)             AS total_profit,
    ROUND(AVG(order_item_discount_rate)*100,2) AS avg_discount_rate_pct,
    ROUND(AVG(is_late) * 100, 2)               AS late_rate_pct
FROM fact_order_items
GROUP BY has_discount
ORDER BY has_discount;


-- ══════════════════════════════════════════════
-- QUERY 11: Top 10 Most Delayed Categories with Revenue Impact
-- ══════════════════════════════════════════════
SELECT
    c.category_name,
    p.abc_class,
    COUNT(*)                                    AS total_orders,
    ROUND(AVG(f.is_late) * 100, 2)              AS late_rate_pct,
    ROUND(AVG(f.delay_days), 2)                 AS avg_delay_days,
    ROUND(SUM(f.revenue_at_risk), 2)            AS revenue_at_risk,
    ROUND(SUM(f.sales), 2)                      AS total_revenue,
    ROUND(
        SUM(f.revenue_at_risk) / 
        NULLIF(SUM(f.sales),0) * 100
    , 2)                                        AS risk_exposure_pct
FROM fact_order_items f
JOIN dim_product p ON f.product_id = p.product_id
JOIN dim_category c ON p.category_id = c.category_id
GROUP BY c.category_id, c.category_name, p.abc_class
ORDER BY revenue_at_risk DESC
LIMIT 10;


-- ══════════════════════════════════════════════
-- QUERY 12: Market Performance Overview
-- ══════════════════════════════════════════════
SELECT
    market,
    COUNT(*)                                    AS total_orders,
    ROUND(AVG(is_late) * 100, 2)               AS late_rate_pct,
    ROUND(SUM(sales), 2)                        AS total_revenue,
    ROUND(SUM(profit_per_order), 2)             AS total_profit,
    ROUND(AVG(profit_margin_pct), 2)            AS avg_margin_pct,
    ROUND(SUM(revenue_at_risk), 2)              AS revenue_at_risk,
    RANK() OVER (
        ORDER BY SUM(sales) DESC
    )                                           AS revenue_rank,
    RANK() OVER (
        ORDER BY AVG(is_late) ASC
    )                                           AS performance_rank
FROM fact_order_items
GROUP BY market
ORDER BY total_revenue DESC;
