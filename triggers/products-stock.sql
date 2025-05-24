--#validar el stock en la tabla PRODUCTS.

CREATE OR REPLACE FUNCTION DIAMOND.fn_validate_stock_range()
RETURNS TRIGGER AS $$
BEGIN
    IF NEW.stock < NEW.stock_min THEN
        RAISE EXCEPTION 'El stock actual (%), es menor que el stock mínimo permitido (%)', NEW.stock, NEW.stock_min;
    ELSIF NEW.stock > NEW.stock_max THEN
        RAISE EXCEPTION 'El stock actual (%), es mayor que el stock máximo permitido (%)', NEW.stock, NEW.stock_max;
    END IF;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;


--#Crear el trigger
CREATE TRIGGER trg_validate_stock_range
BEFORE INSERT OR UPDATE ON DIAMOND.PRODUCTS
FOR EACH ROW
EXECUTE FUNCTION DIAMOND.fn_validate_stock_range();
