CREATE OR REPLACE FUNCTION diamond.fn_audit_products()
RETURNS TRIGGER AS $$
BEGIN
    IF (TG_OP = 'UPDATE') THEN
        INSERT INTO diamond.audit_products (
            id_product_old, name_old, current_price_old, description_old, type_old,
            stock_old, stock_min_old, stock_max_old, id_customer_old, id_regular_old, id_promotion_old,
            fecha_registro, usuario_db, accion
        )
        VALUES (
            OLD.id_product, OLD.name, OLD.current_price, OLD.description, OLD.type,
            OLD.stock, OLD.stock_min, OLD.stock_max, OLD.id_customer, OLD.id_regular, OLD.id_promotion,
            CURRENT_TIMESTAMP, current_user, 'U'
        );
        RETURN NEW; -- Para UPDATE, se debe retornar NEW
    ELSIF (TG_OP = 'DELETE') THEN
        INSERT INTO diamond.audit_products (
            id_product_old, name_old, current_price_old, description_old, type_old,
            stock_old, stock_min_old, stock_max_old, id_customer_old, id_regular_old, id_promotion_old,
            fecha_registro, usuario_db, accion
        )
        VALUES (
            OLD.id_product, OLD.name, OLD.current_price, OLD.description, OLD.type,
            OLD.stock, OLD.stock_min, OLD.stock_max, OLD.id_customer, OLD.id_regular, OLD.id_promotion,
            CURRENT_TIMESTAMP, current_user, 'D'
        );
        RETURN OLD; -- Para DELETE, se debe retornar OLD
    END IF;
    RETURN NULL; -- No debería llegar aquí, pero es buena práctica tener un retorno final
END;
$$ LANGUAGE plpgsql;

COMMENT ON FUNCTION diamond.fn_audit_products() IS 'Función de trigger para registrar los valores antiguos de la tabla diamond.products antes de un UPDATE o DELETE.';