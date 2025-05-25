select * from diamond.invoice_sales;

CREATE TABLE diamond.audit_invoice_sales (
    consecutivo SERIAL PRIMARY KEY,
    -- Columnas replicadas de diamond.invoice_sales
    id_invoice_sale_old VARCHAR(4),
    date_old DATE,
    details_invoice_old VARCHAR(100),
    total_old NUMERIC,
    id_customer_old VARCHAR(4),
    id_payment_type_old VARCHAR(2),
    id_line_item_old VARCHAR(4), -- FK a employees
    -- Columnas de auditoría
    fecha_registro TIMESTAMP WITHOUT TIME ZONE,
    usuario_db VARCHAR(100),
    accion CHAR(1) -- 'U' para Update, 'D' para Delete
);

COMMENT ON TABLE diamond.audit_invoice_sales IS 'Tabla de auditoría para registrar cambios (UPDATE, DELETE) en la tabla diamond.invoice_sales.';
-- ... (añadir comentarios para las columnas _old y de auditoría como en el ejemplo anterior)