--Supuesto: Envío gratis para compras superiores a $200
CREATE OR REPLACE FUNCTION DIAMOND.fn_calculate_shipping_cost()
RETURNS TRIGGER AS $$
DECLARE
    v_total NUMERIC;
BEGIN
    -- Obtener total de la factura asociada
    SELECT total INTO v_total
    FROM DIAMOND.INVOICE_SALES
    WHERE id_invoice_sale = NEW.id_invoice_sale;

    -- Lógica de envío
    IF v_total >= 200000 THEN
        NEW.shipping_cost := 0;
    ELSE
        NEW.shipping_cost := 15000;
    END IF;

    RETURN NEW;
END;
$$ LANGUAGE plpgsql;



--Triggers

CREATE TRIGGER trg_calculate_shipping_cost
BEFORE INSERT OR UPDATE ON DIAMOND.SHIPPINGS
FOR EACH ROW
EXECUTE FUNCTION DIAMOND.fn_calculate_shipping_cost();
