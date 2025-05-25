CREATE TRIGGER trg_audit_products
BEFORE UPDATE OR DELETE ON diamond.products
    FOR EACH ROW EXECUTE FUNCTION diamond.fn_audit_products();

COMMENT ON TRIGGER trg_audit_products ON diamond.products IS 'Trigger que invoca a fn_audit_products antes de cada UPDATE o DELETE en la tabla products.';