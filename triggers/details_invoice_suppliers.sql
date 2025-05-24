--INVOICE SUPPLIERS
CREATE OR REPLACE FUNCTION DIAMOND.fn_update_total_invoice_suppliers()
RETURNS TRIGGER AS $$
BEGIN
    UPDATE DIAMOND.INVOICE_SUPPLIERS
    SET total = (
        SELECT COALESCE(SUM(subtotal), 0)
        FROM DIAMOND.DETAILS_INVOICE_SUPPLIERS
        WHERE id_invoice_supplier = NEW.id_invoice_supplier
    )
    WHERE id_invoice_supplier = NEW.id_invoice_supplier;

    RETURN NULL;
END;
$$ LANGUAGE plpgsql;

--TRIGGERS

CREATE TRIGGER trg_update_total_invoice_suppliers_insert
AFTER INSERT ON DIAMOND.DETAILS_INVOICE_SUPPLIERS
FOR EACH ROW
EXECUTE FUNCTION DIAMOND.fn_update_total_invoice_suppliers();

CREATE TRIGGER trg_update_total_invoice_suppliers_update
AFTER UPDATE ON DIAMOND.DETAILS_INVOICE_SUPPLIERS
FOR EACH ROW
EXECUTE FUNCTION DIAMOND.fn_update_total_invoice_suppliers();

CREATE TRIGGER trg_update_total_invoice_suppliers_delete
AFTER DELETE ON DIAMOND.DETAILS_INVOICE_SUPPLIERS
FOR EACH ROW
EXECUTE FUNCTION DIAMOND.fn_update_total_invoice_suppliers();
