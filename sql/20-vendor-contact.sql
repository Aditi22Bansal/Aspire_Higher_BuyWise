-- 20-vendor-contact: normalized contact lookup for negotiations
CREATE INDEX IF NOT EXISTS idx_vendors_case_contact ON vendors (procurement_id);
CREATE OR REPLACE VIEW v_vendor_contacts AS
SELECT procurement_id, vendor_id, email, phone FROM vendors WHERE email IS NOT NULL OR phone IS NOT NULL;
