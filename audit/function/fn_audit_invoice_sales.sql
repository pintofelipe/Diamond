CREATE OR REPLACE FUNCTION diamond.fn_audit_invoice_sales()
RETURNS TRIGGER AS $$
BEGIN
    IF (TG_OP = 'UPDATE') THEN
        INSERT INTO diamond.audit_invoice_sales (
            id_invoice_sale_old, date_old, details_invoice_old, total_old,
            id_customer_old, id_payment_type_old, id_line_item_old,
            fecha_registro, usuario_db, accion
        )
        VALUES (
            OLD.id_invoice_sale, OLD.date, OLD.details_invoice, OLD.total,
            OLD.id_customer, OLD.id_payment_type, OLD.id_line_item,
            CURRENT_TIMESTAMP, current_user, 'U'
        );
        RETURN NEW;
    ELSIF (TG_OP = 'DELETE') THEN
        INSERT INTO diamond.audit_invoice_sales (
            id_invoice_sale_old, date_old, details_invoice_old, total_old,
            id_customer_old, id_payment_type_old, id_line_item_old,
            fecha_registro, usuario_db, accion
        )
        VALUES (
            OLD.id_invoice_sale, OLD.date, OLD.details_invoice, OLD.total,
            OLD.id_customer, OLD.id_payment_type, OLD.id_line_item,
            CURRENT_TIMESTAMP, current_user, 'D'
        );
        RETURN OLD;
    END IF;
    RETURN NULL;
END;
$$ LANGUAGE plpgsql;

COMMENT ON FUNCTION diamond.fn_audit_invoice_sales() IS 'Función de trigger para registrar los valores antiguos de la tabla diamond.invoice_sales antes de un UPDATE o DELETE.';