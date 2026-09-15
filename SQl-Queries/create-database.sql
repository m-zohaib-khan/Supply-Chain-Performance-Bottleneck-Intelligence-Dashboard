CREATE DATABASE IF NOT EXISTS supply_chain_dashboard;
USE supply_chain_dashboard;

-- ══════════════════════════════════════════
-- DIMENSION TABLES (Parents)
-- ══════════════════════════════════════════

-- Customer Dimension
CREATE TABLE dim_customer (
    customer_id         INT PRIMARY KEY,
    customer_segment    VARCHAR(30),
    customer_city       VARCHAR(80),
    customer_state      VARCHAR(80),
    customer_country    VARCHAR(80)
);

-- Department Dimension
CREATE TABLE dim_department (
    department_id       INT PRIMARY KEY,
    department_name     VARCHAR(80) NOT NULL
);

-- Category Dimension (Linked to Department)
CREATE TABLE dim_category (
    category_id         INT PRIMARY KEY,
    category_name       VARCHAR(80) NOT NULL,
    department_id       INT,
    FOREIGN KEY (department_id) REFERENCES dim_department(department_id)
);

-- Product Dimension (Linked to Category)
CREATE TABLE dim_product (
    product_id          INT PRIMARY KEY,
    product_name        VARCHAR(200) NOT NULL,
    product_price       DECIMAL(10,2),
    abc_class           VARCHAR(2),
    category_id         INT,
    FOREIGN KEY (category_id) REFERENCES dim_category(category_id)
);

-- Shipping Mode Dimension
CREATE TABLE dim_shipping_mode (
    shipping_mode_id    INT AUTO_INCREMENT PRIMARY KEY,
    shipping_mode       VARCHAR(30) UNIQUE NOT NULL
);

-- Supplier Proxy Dimension / Scorecard
CREATE TABLE dim_supplier_proxy (
    supplier_proxy_id   INT AUTO_INCREMENT PRIMARY KEY,
    supplier_proxy      VARCHAR(80) UNIQUE NOT NULL,
    total_orders        INT,
    late_orders         INT,
    avg_delay           DECIMAL(6,2),
    total_revenue       DECIMAL(12,2),
    total_profit        DECIMAL(12,2),
    on_time_rate        DECIMAL(6,2),
    risk_flag           VARCHAR(10)
);

-- Product ABC Analysis Reference Table
CREATE TABLE product_abc (
    product_name        VARCHAR(200) PRIMARY KEY,
    sales               DECIMAL(12,2),
    cumulative_revenue  DECIMAL(12,2),
    cumulative_pct      DECIMAL(8,4),
    abc_class           VARCHAR(2)
);

-- ══════════════════════════════════════════
-- FACT TABLE (Child Table)
-- ══════════════════════════════════════════

CREATE TABLE fact_order_items (
    order_item_id           INT PRIMARY KEY,
    order_id                INT NOT NULL,
    
    -- Foreign Key Keys
    customer_id             INT,
    product_id              INT,
    shipping_mode_id        INT,
    supplier_proxy_id       INT,
    
    -- Timestamps & Date Attributes
    order_date              DATE,
    shipping_date           DATE,
    order_year              INT,
    order_month             INT,
    order_quarter           INT,
    order_month_name        VARCHAR(5),
    order_yearmonth         VARCHAR(10),
    order_dayofweek         VARCHAR(15),
    order_week              INT,
    
    -- Geographic & Order Context
    market                  VARCHAR(30),
    order_region            VARCHAR(80),
    order_country           VARCHAR(80),
    order_city              VARCHAR(80),
    latitude                DECIMAL(10,6),
    longitude               DECIMAL(10,6),
    payment_type            VARCHAR(20),
    order_status            VARCHAR(30),
    delivery_status         VARCHAR(30),
    
    -- Numerical Performance & Delay Metrics
    actual_shipping_days    INT,
    scheduled_shipping_days INT,
    delay_days              INT,
    is_late                 TINYINT,
    late_delivery_risk      TINYINT,
    
    -- Transaction Financials & Measures
    quantity                INT,
    sales                   DECIMAL(10,2),
    profit_per_order        DECIMAL(10,2),
    profit_margin_pct       DECIMAL(8,2),
    benefit_per_order       DECIMAL(10,2),
    order_item_discount     DECIMAL(10,2),
    order_item_discount_rate DECIMAL(6,4),
    has_discount            TINYINT,
    revenue_at_risk         DECIMAL(10,2),
    
    -- Foreign Key Constraints
    FOREIGN KEY (customer_id) REFERENCES dim_customer(customer_id),
    FOREIGN KEY (product_id) REFERENCES dim_product(product_id),
    FOREIGN KEY (shipping_mode_id) REFERENCES dim_shipping_mode(shipping_mode_id),
    FOREIGN KEY (supplier_proxy_id) REFERENCES dim_supplier_proxy(supplier_proxy_id)
);


SELECT * FROM supply_chain_dashboard.dim_customer LIMIT 5;
SELECT * FROM supply_chain_dashboard.dim_department LIMIT 5;
SELECT * FROM supply_chain_dashboard.dim_category LIMIT 5;
SELECT * FROM supply_chain_dashboard.dim_product LIMIT 5;
SELECT * FROM supply_chain_dashboard.dim_shipping_mode LIMIT 5;
SELECT * FROM supply_chain_dashboard.dim_supplier_proxy LIMIT 5;
SELECT * FROM supply_chain_dashboard.product_abc LIMIT 5;
SELECT * FROM supply_chain_dashboard.fact_order_items LIMIT 5;