select * from diamond.products;


CREATE TABLE diamond.audit_products (
    consecutivo SERIAL PRIMARY KEY,
    -- Columnas replicadas de diamond.products
    id_product_old VARCHAR(4),
    name_old VARCHAR(100),
    current_price_old NUMERIC,
    description_old VARCHAR(100),
    type_old VARCHAR(40),
    stock_old INTEGER,
    stock_min_old INTEGER,
    stock_max_old INTEGER,
    id_customer_old VARCHAR(4),
    id_regular_old VARCHAR(4),
    id_promotion_old VARCHAR(4),
    -- Columnas de auditoría
    fecha_registro TIMESTAMP WITHOUT TIME ZONE,
    usuario_db VARCHAR(100), -- current_user puede ser largo
    accion CHAR(1) -- 'U' para Update, 'D' para Delete
);

select * from diamond.audit_products;

COMMENT ON TABLE diamond.audit_products IS 'Tabla de auditoría para registrar cambios (UPDATE, DELETE) en la tabla diamond.products.';
COMMENT ON COLUMN diamond.audit_products.consecutivo IS 'Identificador único autoincremental para el registro de auditoría.';
COMMENT ON COLUMN diamond.audit_products.id_product_old IS 'Valor anterior del ID del producto auditado.';
COMMENT ON COLUMN diamond.audit_products.name_old IS 'Valor anterior del nombre del producto.';
-- ... (comentarios para otras columnas _old)
COMMENT ON COLUMN diamond.audit_products.fecha_registro IS 'Fecha y hora en que se realizó la operación auditada.';
COMMENT ON COLUMN diamond.audit_products.usuario_db IS 'Usuario de la base de datos que realizó la operación.';
COMMENT ON COLUMN diamond.audit_products.accion IS 'Tipo de operación realizada (U: Update, D: Delete).';





