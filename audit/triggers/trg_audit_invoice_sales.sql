CREATE TRIGGER trg_audit_invoice_sales
BEFORE UPDATE OR DELETE ON diamond.invoice_sales
    FOR EACH ROW EXECUTE FUNCTION diamond.fn_audit_invoice_sales();

COMMENT ON TRIGGER trg_audit_invoice_sales ON diamond.invoice_sales IS 'Trigger que invoca a fn_audit_invoice_sales antes de cada UPDATE o DELETE en la tabla invoice_sales.';