--subtotal en las tablas DETAILS_INVOICE_SALES y DETAILS_INVOICE_SUPPLIERS.

CREATE OR REPLACE FUNCTION DIAMOND.fn_calculate_subtotal_sales()
RETURNS TRIGGER AS $$
BEGIN
	NEW.subtotal := (NEW.quantity * NEW.unit_price) - NEW.discount;
	RETURN NEW;
END;
$$ LANGUAGE plpgsql;


--Crear el trigger para DETAILS_INVOICE_SALE
CREATE TRIGGER trg_calculate_subtotal_sales
BEFORE INSERT OR UPDATE ON DIAMOND.DETAILS_INVOICE_SALES
FOR EACH ROW
EXECUTE FUNCTION DIAMOND.fn_calculate_subtotal_sales();


--Function for DETAILS_INVOICE_SUPPLIERS
CREATE OR REPLACE FUNCTION DIAMOND.fn_calculate_subtotal_suppliers()
RETURNS TRIGGER AS $$
BEGIN
	NEW.subtotal := (NEW.quantity * NEW.unit_price) - NEW.discount;
	RETURN NEW;
END;
$$ LANGUAGE plpgsql;


--Crear trigger
CREATE TRIGGER trg_calculate_subtotal_suppliers
BEFORE INSERT OR UPDATE ON DIAMOND.DETAILS_INVOICE_SUPPLIERS
FOR EACH ROW
EXECUTE FUNCTION DIAMOND.fn_calculate_subtotal_suppliers();







