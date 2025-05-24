--Función para actualizar total en INVOICE_SALES:
CREATE OR REPLACE FUNCTION DIAMOND.fn_update_total_invoice_sales()
RETURNS TRIGGER AS $$
BEGIN
	UPDATE DIAMOND.INVOICE_SALES
	SET total = (
		SELECT COALESCE(SUM(subtotal),0)
		FROM DIAMOND.DETAILS_INVOICE_SALES
		WHERE id_invoice_sale = NEW.id_invoice_sale
	)
	WHERE id_invoice_sale = NEW.id_invoice_sale;

	RETURN NULL;
END;

$$ LANGUAGE plpgsql;

--Triggers sobre DETAILS_INVOICE_SALES
CREATE TRIGGER trg_update_total_invoice_sales_insert
AFTER INSERT ON DIAMOND.DETAILS_INVOICE_SALES
FOR EACH ROW
EXECUTE FUNCTION DIAMOND.fn_update_total_invoice_sales();

CREATE TRIGGER trg_update_total_invoice_sales_update
AFTER UPDATE ON DIAMOND.DETAILS_INVOICE_SALES
FOR EACH ROW
EXECUTE FUNCTION DIAMOND.fn_update_total_invoice_sales();

CREATE TRIGGER trg_update_total_invoice_sales_delete
AFTER DELETE ON DIAMOND.DETAILS_INVOICE_SALES
FOR EACH ROW
EXECUTE FUNCTION DIAMOND.fn_update_total_invoice_sales();












