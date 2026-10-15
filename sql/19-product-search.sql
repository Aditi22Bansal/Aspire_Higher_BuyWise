-- 19-product-search: fast product lookup for case workspace
CREATE EXTENSION IF NOT EXISTS pg_trgm;
CREATE INDEX IF NOT EXISTS idx_products_name_trgm ON products USING gin (name gin_trgm_ops);
CREATE INDEX IF NOT EXISTS idx_products_case_status ON products (procurement_id, created_at DESC);
CREATE OR REPLACE VIEW v_case_products AS
SELECT procurement_id, count(*) AS product_count, max(created_at) AS last_found
FROM products GROUP BY procurement_id;
