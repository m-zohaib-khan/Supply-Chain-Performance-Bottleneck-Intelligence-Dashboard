import pandas as pd
from sqlalchemy import create_engine

# ─── 1. CONNECT TO MYSQL DATABASE ──────────────────────────────────────────
# Special characters in password (@, #, $) are URL-encoded for SQLAlchemy connection
DB_USER = "root"
DB_PASS = "zohaib123%40%23%24"  # Encoded version of: zohaib123@#$
DB_HOST = "localhost"
DB_PORT = "3306"
DB_NAME = "supply_chain_dashboard"

DB_URI = f"mysql+pymysql://{DB_USER}:{DB_PASS}@{DB_HOST}:{DB_PORT}/{DB_NAME}"
engine = create_engine(DB_URI)

print("Connecting to MySQL...")

# ─── 2. LOAD SOURCE CSV FILES ─────────────────────────────────────────────
# ─── 2. LOAD SOURCE CSV FILES ─────────────────────────────────────────────
print("\nLoading source CSV files...")
df_main = pd.read_csv('supply_chain_clean.csv')
supplier = pd.read_csv('supplier_scorecard.csv')
product_abc = pd.read_csv('product_abc.csv')

# ─── 3. EXTRACT & LOAD PARENT DIMENSION TABLES ─────────────────────────────

# --- A. dim_customer ---
print("\nLoading dim_customer...")
dim_customer = df_main[[
    'customer_id', 'customer_segment', 'customer_city', 
    'customer_state', 'customer_country'
]].drop_duplicates(subset=['customer_id'])

dim_customer.to_sql('dim_customer', con=engine, if_exists='append', index=False, chunksize=1000)
print(f"✅ dim_customer: {len(dim_customer):,} rows loaded")

# --- B. dim_department ---
print("\nLoading dim_department...")
dim_department = df_main[[
    'department_id', 'department_name'
]].drop_duplicates(subset=['department_id'])

dim_department.to_sql('dim_department', con=engine, if_exists='append', index=False)
print(f"✅ dim_department: {len(dim_department):,} rows loaded")

# --- C. dim_category ---
print("\nLoading dim_category...")
dim_category = df_main[[
    'category_id', 'category_name', 'department_id'
]].drop_duplicates(subset=['category_id'])

dim_category.to_sql('dim_category', con=engine, if_exists='append', index=False)
print(f"✅ dim_category: {len(dim_category):,} rows loaded")

# --- D. dim_product ---
print("\nLoading dim_product...")
dim_product = df_main[[
    'product_id', 'product_name', 'product_list_price', 'abc_class', 'category_id'
]].rename(columns={'product_list_price': 'product_price'}).drop_duplicates(subset=['product_id'])

dim_product.to_sql('dim_product', con=engine, if_exists='append', index=False, chunksize=1000)
print(f"✅ dim_product: {len(dim_product):,} rows loaded")

# --- E. dim_shipping_mode ---
print("\nLoading dim_shipping_mode...")
dim_shipping_mode = df_main[['shipping_mode']].drop_duplicates().reset_index(drop=True)

dim_shipping_mode.to_sql('dim_shipping_mode', con=engine, if_exists='append', index=False)
print(f"✅ dim_shipping_mode: {len(dim_shipping_mode):,} rows loaded")

# --- F. dim_supplier_proxy ---
print("\nLoading dim_supplier_proxy...")
supplier_dedup = supplier.drop_duplicates(subset=['supplier_proxy'])

supplier_dedup.to_sql('dim_supplier_proxy', con=engine, if_exists='append', index=False)
print(f"✅ dim_supplier_proxy: {len(supplier_dedup):,} rows loaded")

# --- G. product_abc ---
print("\nLoading product_abc...")
product_abc_dedup = product_abc.drop_duplicates(subset=['product_name'])

product_abc_dedup.to_sql('product_abc', con=engine, if_exists='append', index=False)
print(f"✅ product_abc: {len(product_abc_dedup):,} rows loaded")

# ─── 4. RESOLVE SURROGATE KEYS FOR FACT TABLE ─────────────────────────────
print("\nFetching generated IDs for shipping_mode and supplier_proxy...")

# Retrieve generated auto-increment IDs from MySQL
shipping_map = pd.read_sql("SELECT shipping_mode_id, shipping_mode FROM dim_shipping_mode", con=engine)
supplier_map = pd.read_sql("SELECT supplier_proxy_id, supplier_proxy FROM dim_supplier_proxy", con=engine)

# Merge surrogate IDs back into the main DataFrame
df_main = df_main.merge(shipping_map, on='shipping_mode', how='left')
df_main = df_main.merge(supplier_map, on='supplier_proxy', how='left')

# ─── 5. EXTRACT & LOAD CHILD FACT TABLE ───────────────────────────────────
print("\nLoading fact_order_items...")

fact_cols = [
    'order_item_id', 'order_id', 'customer_id', 'product_id',
    'shipping_mode_id', 'supplier_proxy_id', 'order_date', 'shipping_date',
    'order_year', 'order_month', 'order_quarter', 'order_month_name',
    'order_yearmonth', 'order_dayofweek', 'order_week', 'market',
    'order_region', 'order_country', 'order_city', 'latitude', 'longitude',
    'payment_type', 'order_status', 'delivery_status', 'actual_shipping_days',
    'scheduled_shipping_days', 'delay_days', 'is_late', 'late_delivery_risk',
    'quantity', 'sales', 'profit_per_order', 'profit_margin_pct',
    'benefit_per_order', 'order_item_discount', 'order_item_discount_rate',
    'has_discount', 'revenue_at_risk'
]

fact_order_items = df_main[fact_cols].drop_duplicates(subset=['order_item_id'])

# Load fact table in chunks
fact_order_items.to_sql(
    'fact_order_items',
    con=engine,
    if_exists='append',
    index=False,
    chunksize=5000,
    method='multi'
)

print(f"✅ fact_order_items: {len(fact_order_items):,} rows loaded")
print("\n🎉 ALL DIMENSION AND FACT TABLES LOADED SUCCESSFULLY INTO MYSQL!")
