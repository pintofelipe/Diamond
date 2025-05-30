toc.dat                                                                                             0000600 0004000 0002000 00000101337 15014423351 0014442 0                                                                                                    ustar 00postgres                        postgres                        0000000 0000000                                                                                                                                                                        PGDMP                       }            postgres    17.4    17.4 Q               0    0    ENCODING    ENCODING        SET client_encoding = 'UTF8';
                           false                    0    0 
   STDSTRINGS 
   STDSTRINGS     (   SET standard_conforming_strings = 'on';
                           false                    0    0 
   SEARCHPATH 
   SEARCHPATH     8   SELECT pg_catalog.set_config('search_path', '', false);
                           false                    1262    5    postgres    DATABASE     ~   CREATE DATABASE postgres WITH TEMPLATE = template0 ENCODING = 'UTF8' LOCALE_PROVIDER = libc LOCALE = 'Spanish_Colombia.1252';
    DROP DATABASE postgres;
                     postgres    false                    0    0    DATABASE postgres    COMMENT     N   COMMENT ON DATABASE postgres IS 'default administrative connection database';
                        postgres    false    5146         	            2615    25430    diamond    SCHEMA        CREATE SCHEMA diamond;
    DROP SCHEMA diamond;
                     postgres    false                    0    0    SCHEMA diamond    COMMENT     9   COMMENT ON SCHEMA diamond IS 'database for a perfumery';
                        postgres    false    9                    1255    25754    fn_calculate_shipping_cost()    FUNCTION     �  CREATE FUNCTION diamond.fn_calculate_shipping_cost() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
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
        NEW.shipping_cost := 15;
    END IF;

    RETURN NEW;
END;
$$;
 4   DROP FUNCTION diamond.fn_calculate_shipping_cost();
       diamond               postgres    false    9                    1255    25742    fn_calculate_subtotal_sales()    FUNCTION     �   CREATE FUNCTION diamond.fn_calculate_subtotal_sales() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
	NEW.subtotal := (NEW.quantity * NEW.unit_price) - NEW.discount;
	RETURN NEW;
END;
$$;
 5   DROP FUNCTION diamond.fn_calculate_subtotal_sales();
       diamond               postgres    false    9                    1255    25744 !   fn_calculate_subtotal_suppliers()    FUNCTION     �   CREATE FUNCTION diamond.fn_calculate_subtotal_suppliers() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
	NEW.subtotal := (NEW.quantity * NEW.unit_price) - NEW.discount;
	RETURN NEW;
END;
$$;
 9   DROP FUNCTION diamond.fn_calculate_subtotal_suppliers();
       diamond               postgres    false    9                    1255    25746    fn_update_total_invoice_sales()    FUNCTION     Z  CREATE FUNCTION diamond.fn_update_total_invoice_sales() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
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

$$;
 7   DROP FUNCTION diamond.fn_update_total_invoice_sales();
       diamond               postgres    false    9                    1255    25750 #   fn_update_total_invoice_suppliers()    FUNCTION     �  CREATE FUNCTION diamond.fn_update_total_invoice_suppliers() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
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
$$;
 ;   DROP FUNCTION diamond.fn_update_total_invoice_suppliers();
       diamond               postgres    false    9         
           1255    25740    fn_validate_stock_range()    FUNCTION     �  CREATE FUNCTION diamond.fn_validate_stock_range() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
    IF NEW.stock < NEW.stock_min THEN
        RAISE EXCEPTION 'El stock actual (%), es menor que el stock mínimo permitido (%)', NEW.stock, NEW.stock_min;
    ELSIF NEW.stock > NEW.stock_max THEN
        RAISE EXCEPTION 'El stock actual (%), es mayor que el stock máximo permitido (%)', NEW.stock, NEW.stock_max;
    END IF;
    RETURN NEW;
END;
$$;
 1   DROP FUNCTION diamond.fn_validate_stock_range();
       diamond               postgres    false    9                    1259    25653    cities    TABLE     �   CREATE TABLE diamond.cities (
    id_city character varying(3) NOT NULL,
    name character varying(40),
    CONSTRAINT nn_cities_name CHECK ((name IS NOT NULL))
);
    DROP TABLE diamond.cities;
       diamond         heap r       postgres    false    9         �            1259    25431 	   customers    TABLE     �  CREATE TABLE diamond.customers (
    id_customer character varying(4) NOT NULL,
    first_name character varying(20),
    last_name character varying(20),
    phone character varying(20),
    email character varying(50),
    CONSTRAINT nn_customers_first_name CHECK ((first_name IS NOT NULL)),
    CONSTRAINT nn_customers_last_name CHECK ((last_name IS NOT NULL)),
    CONSTRAINT nn_customers_phone CHECK ((phone IS NOT NULL))
);
    DROP TABLE diamond.customers;
       diamond         heap r       postgres    false    9         �            1259    25556    details_invoice_sales    TABLE       CREATE TABLE diamond.details_invoice_sales (
    id_details_invoice_sale character varying(4) NOT NULL,
    quantity integer,
    unit_price numeric,
    discount numeric,
    subtotal numeric,
    id_invoice_sale character varying(4),
    id_product character varying(4),
    CONSTRAINT nn_details_invoice_sales_discount CHECK ((discount IS NOT NULL)),
    CONSTRAINT nn_details_invoice_sales_invoice_sale CHECK ((id_invoice_sale IS NOT NULL)),
    CONSTRAINT nn_details_invoice_sales_price CHECK ((unit_price IS NOT NULL)),
    CONSTRAINT nn_details_invoice_sales_product CHECK ((id_product IS NOT NULL)),
    CONSTRAINT nn_details_invoice_sales_quantity CHECK ((quantity IS NOT NULL)),
    CONSTRAINT nn_details_invoice_sales_subtotal CHECK ((subtotal IS NOT NULL))
);
 *   DROP TABLE diamond.details_invoice_sales;
       diamond         heap r       postgres    false    9                     1259    25617    details_invoice_suppliers    TABLE     x  CREATE TABLE diamond.details_invoice_suppliers (
    id_line_item character varying(4) NOT NULL,
    quantity integer,
    unit_price numeric,
    discount numeric,
    subtotal numeric,
    id_invoice_supplier character varying(20),
    id_product character varying(4),
    CONSTRAINT nn_details_invoice_suppliers_invoice_supplier CHECK ((id_invoice_supplier IS NOT NULL)),
    CONSTRAINT nn_details_invoice_suppliers_price CHECK ((unit_price IS NOT NULL)),
    CONSTRAINT nn_details_invoice_suppliers_product CHECK ((id_product IS NOT NULL)),
    CONSTRAINT nn_details_invoice_suppliers_quantity CHECK ((quantity IS NOT NULL))
);
 .   DROP TABLE diamond.details_invoice_suppliers;
       diamond         heap r       postgres    false    9         �            1259    25439 	   employees    TABLE       CREATE TABLE diamond.employees (
    id_line_item character varying(4) NOT NULL,
    first_name character varying(20),
    last_name character varying(20),
    salary numeric,
    employee_type character varying(40),
    id_manager character varying(4),
    CONSTRAINT nn_employee_type CHECK ((employee_type IS NOT NULL)),
    CONSTRAINT nn_employees_first_name CHECK ((first_name IS NOT NULL)),
    CONSTRAINT nn_employees_last_name CHECK ((last_name IS NOT NULL)),
    CONSTRAINT nn_employees_salary CHECK ((salary IS NOT NULL))
);
    DROP TABLE diamond.employees;
       diamond         heap r       postgres    false    9         �            1259    25529    invoice_sales    TABLE     �  CREATE TABLE diamond.invoice_sales (
    id_invoice_sale character varying(4) NOT NULL,
    date date,
    details_invoice character varying(100),
    total numeric,
    id_customer character varying(4),
    id_payment_type character varying(2),
    id_line_item character varying(4),
    CONSTRAINT nn_invoice_sales_date CHECK ((date IS NOT NULL)),
    CONSTRAINT nn_invoice_sales_id_customer CHECK ((id_customer IS NOT NULL)),
    CONSTRAINT nn_invoice_sales_id_line_item CHECK ((id_line_item IS NOT NULL)),
    CONSTRAINT nn_invoice_sales_id_payment_type CHECK ((id_payment_type IS NOT NULL)),
    CONSTRAINT nn_invoice_sales_total CHECK ((total IS NOT NULL))
);
 "   DROP TABLE diamond.invoice_sales;
       diamond         heap r       postgres    false    9         �            1259    25602    invoice_suppliers    TABLE     �  CREATE TABLE diamond.invoice_suppliers (
    id_invoice_supplier character varying(4) NOT NULL,
    date date,
    details_invoice character varying(100),
    total numeric,
    id_supplier character varying(4),
    CONSTRAINT nn_invoice_suppliers_date CHECK ((date IS NOT NULL)),
    CONSTRAINT nn_invoice_suppliers_supplier_id CHECK ((id_supplier IS NOT NULL)),
    CONSTRAINT nn_invoice_suppliers_total CHECK ((total IS NOT NULL))
);
 &   DROP TABLE diamond.invoice_suppliers;
       diamond         heap r       postgres    false    9         �            1259    25456    payment_types    TABLE     �   CREATE TABLE diamond.payment_types (
    id_payment_type character varying(2) NOT NULL,
    name character varying(40),
    CONSTRAINT nn_payment_types_name CHECK ((name IS NOT NULL))
);
 "   DROP TABLE diamond.payment_types;
       diamond         heap r       postgres    false    9         �            1259    25502    products    TABLE     �  CREATE TABLE diamond.products (
    id_product character varying(4) NOT NULL,
    name character varying(100),
    current_price numeric,
    description character varying(100),
    type character varying(40),
    stock integer,
    stock_min integer,
    stock_max integer,
    id_customer character varying(4),
    id_regular character varying(4),
    id_promotion character varying(4),
    CONSTRAINT nn_products_current_price CHECK ((current_price IS NOT NULL)),
    CONSTRAINT nn_products_name CHECK ((name IS NOT NULL)),
    CONSTRAINT nn_products_stock CHECK ((stock IS NOT NULL)),
    CONSTRAINT nn_products_stock_max CHECK ((stock_max IS NOT NULL)),
    CONSTRAINT nn_products_stock_min CHECK ((stock_min IS NOT NULL))
);
    DROP TABLE diamond.products;
       diamond         heap r       postgres    false    9         �            1259    25468 
   promotions    TABLE     x  CREATE TABLE diamond.promotions (
    id_promotion character varying(4) NOT NULL,
    start_date date,
    end_date date,
    code character varying(10),
    details character varying(100),
    CONSTRAINT nn_end_date CHECK ((end_date IS NOT NULL)),
    CONSTRAINT nn_promotions_code CHECK ((code IS NOT NULL)),
    CONSTRAINT nn_start_date CHECK ((start_date IS NOT NULL))
);
    DROP TABLE diamond.promotions;
       diamond         heap r       postgres    false    9         �            1259    25462    regulars    TABLE     �   CREATE TABLE diamond.regulars (
    id_regular character varying(4) NOT NULL,
    code character varying(10),
    brand character varying(20),
    CONSTRAINT nn_brand CHECK ((brand IS NOT NULL))
);
    DROP TABLE diamond.regulars;
       diamond         heap r       postgres    false    9                    1259    25713 	   shippings    TABLE     �  CREATE TABLE diamond.shippings (
    id_shipping character varying(4) NOT NULL,
    date date,
    delivery_address character varying(100),
    shipping_cost numeric,
    status character(1),
    id_invoice_sale character varying(4),
    id_state character varying(3),
    CONSTRAINT nn_shippings_date CHECK ((date IS NOT NULL)),
    CONSTRAINT nn_shippings_delivery_address CHECK ((delivery_address IS NOT NULL)),
    CONSTRAINT nn_shippings_invoice_sale CHECK ((id_invoice_sale IS NOT NULL)),
    CONSTRAINT nn_shippings_shipping_cost CHECK ((shipping_cost IS NOT NULL)),
    CONSTRAINT nn_shippings_states CHECK ((id_state IS NOT NULL)),
    CONSTRAINT nn_shippings_status CHECK ((status IS NOT NULL))
);
    DROP TABLE diamond.shippings;
       diamond         heap r       postgres    false    9                    1259    25701    states    TABLE       CREATE TABLE diamond.states (
    id_state character varying(3) NOT NULL,
    name character varying(60),
    id_city character varying(3),
    CONSTRAINT nn_states_id_city CHECK ((id_city IS NOT NULL)),
    CONSTRAINT nn_states_name CHECK ((name IS NOT NULL))
);
    DROP TABLE diamond.states;
       diamond         heap r       postgres    false    9         �            1259    25482 	   suppliers    TABLE     �  CREATE TABLE diamond.suppliers (
    id_supplier character varying(4) NOT NULL,
    first_name character varying(40),
    last_name character varying(15),
    contact character varying(40),
    address character varying(100),
    CONSTRAINT nn_suppliers_address CHECK ((address IS NOT NULL)),
    CONSTRAINT nn_suppliers_contact CHECK ((contact IS NOT NULL)),
    CONSTRAINT nn_suppliers_first_name CHECK ((first_name IS NOT NULL))
);
    DROP TABLE diamond.suppliers;
       diamond         heap r       postgres    false    9                   0    25653    cities 
   TABLE DATA           0   COPY diamond.cities (id_city, name) FROM stdin;
    diamond               postgres    false    259       5138.dat           0    25431 	   customers 
   TABLE DATA           V   COPY diamond.customers (id_customer, first_name, last_name, phone, email) FROM stdin;
    diamond               postgres    false    246       5127.dat           0    25556    details_invoice_sales 
   TABLE DATA           �   COPY diamond.details_invoice_sales (id_details_invoice_sale, quantity, unit_price, discount, subtotal, id_invoice_sale, id_product) FROM stdin;
    diamond               postgres    false    254       5135.dat           0    25617    details_invoice_suppliers 
   TABLE DATA           �   COPY diamond.details_invoice_suppliers (id_line_item, quantity, unit_price, discount, subtotal, id_invoice_supplier, id_product) FROM stdin;
    diamond               postgres    false    256       5137.dat           0    25439 	   employees 
   TABLE DATA           l   COPY diamond.employees (id_line_item, first_name, last_name, salary, employee_type, id_manager) FROM stdin;
    diamond               postgres    false    247       5128.dat           0    25529    invoice_sales 
   TABLE DATA           �   COPY diamond.invoice_sales (id_invoice_sale, date, details_invoice, total, id_customer, id_payment_type, id_line_item) FROM stdin;
    diamond               postgres    false    253       5134.dat           0    25602    invoice_suppliers 
   TABLE DATA           l   COPY diamond.invoice_suppliers (id_invoice_supplier, date, details_invoice, total, id_supplier) FROM stdin;
    diamond               postgres    false    255       5136.dat 	          0    25456    payment_types 
   TABLE DATA           ?   COPY diamond.payment_types (id_payment_type, name) FROM stdin;
    diamond               postgres    false    248       5129.dat           0    25502    products 
   TABLE DATA           �   COPY diamond.products (id_product, name, current_price, description, type, stock, stock_min, stock_max, id_customer, id_regular, id_promotion) FROM stdin;
    diamond               postgres    false    252       5133.dat           0    25468 
   promotions 
   TABLE DATA           X   COPY diamond.promotions (id_promotion, start_date, end_date, code, details) FROM stdin;
    diamond               postgres    false    250       5131.dat 
          0    25462    regulars 
   TABLE DATA           <   COPY diamond.regulars (id_regular, code, brand) FROM stdin;
    diamond               postgres    false    249       5130.dat           0    25713 	   shippings 
   TABLE DATA           {   COPY diamond.shippings (id_shipping, date, delivery_address, shipping_cost, status, id_invoice_sale, id_state) FROM stdin;
    diamond               postgres    false    261       5140.dat           0    25701    states 
   TABLE DATA           :   COPY diamond.states (id_state, name, id_city) FROM stdin;
    diamond               postgres    false    260       5139.dat           0    25482 	   suppliers 
   TABLE DATA           Z   COPY diamond.suppliers (id_supplier, first_name, last_name, contact, address) FROM stdin;
    diamond               postgres    false    251       5132.dat X           2606    25658    cities pk_cities 
   CONSTRAINT     T   ALTER TABLE ONLY diamond.cities
    ADD CONSTRAINT pk_cities PRIMARY KEY (id_city);
 ;   ALTER TABLE ONLY diamond.cities DROP CONSTRAINT pk_cities;
       diamond                 postgres    false    259         @           2606    25438    customers pk_customers 
   CONSTRAINT     ^   ALTER TABLE ONLY diamond.customers
    ADD CONSTRAINT pk_customers PRIMARY KEY (id_customer);
 A   ALTER TABLE ONLY diamond.customers DROP CONSTRAINT pk_customers;
       diamond                 postgres    false    246         R           2606    25568 .   details_invoice_sales pk_details_invoice_sales 
   CONSTRAINT     �   ALTER TABLE ONLY diamond.details_invoice_sales
    ADD CONSTRAINT pk_details_invoice_sales PRIMARY KEY (id_details_invoice_sale);
 Y   ALTER TABLE ONLY diamond.details_invoice_sales DROP CONSTRAINT pk_details_invoice_sales;
       diamond                 postgres    false    254         V           2606    25627 6   details_invoice_suppliers pk_details_invoice_suppliers 
   CONSTRAINT        ALTER TABLE ONLY diamond.details_invoice_suppliers
    ADD CONSTRAINT pk_details_invoice_suppliers PRIMARY KEY (id_line_item);
 a   ALTER TABLE ONLY diamond.details_invoice_suppliers DROP CONSTRAINT pk_details_invoice_suppliers;
       diamond                 postgres    false    256         D           2606    25449    employees pk_employees 
   CONSTRAINT     _   ALTER TABLE ONLY diamond.employees
    ADD CONSTRAINT pk_employees PRIMARY KEY (id_line_item);
 A   ALTER TABLE ONLY diamond.employees DROP CONSTRAINT pk_employees;
       diamond                 postgres    false    247         P           2606    25540    invoice_sales pk_invoice_sales 
   CONSTRAINT     j   ALTER TABLE ONLY diamond.invoice_sales
    ADD CONSTRAINT pk_invoice_sales PRIMARY KEY (id_invoice_sale);
 I   ALTER TABLE ONLY diamond.invoice_sales DROP CONSTRAINT pk_invoice_sales;
       diamond                 postgres    false    253         T           2606    25819 &   invoice_suppliers pk_invoice_suppliers 
   CONSTRAINT     v   ALTER TABLE ONLY diamond.invoice_suppliers
    ADD CONSTRAINT pk_invoice_suppliers PRIMARY KEY (id_invoice_supplier);
 Q   ALTER TABLE ONLY diamond.invoice_suppliers DROP CONSTRAINT pk_invoice_suppliers;
       diamond                 postgres    false    255         F           2606    25461    payment_types pk_payment_types 
   CONSTRAINT     j   ALTER TABLE ONLY diamond.payment_types
    ADD CONSTRAINT pk_payment_types PRIMARY KEY (id_payment_type);
 I   ALTER TABLE ONLY diamond.payment_types DROP CONSTRAINT pk_payment_types;
       diamond                 postgres    false    248         N           2606    25513    products pk_products 
   CONSTRAINT     [   ALTER TABLE ONLY diamond.products
    ADD CONSTRAINT pk_products PRIMARY KEY (id_product);
 ?   ALTER TABLE ONLY diamond.products DROP CONSTRAINT pk_products;
       diamond                 postgres    false    252         J           2606    25785    promotions pk_promotions 
   CONSTRAINT     a   ALTER TABLE ONLY diamond.promotions
    ADD CONSTRAINT pk_promotions PRIMARY KEY (id_promotion);
 C   ALTER TABLE ONLY diamond.promotions DROP CONSTRAINT pk_promotions;
       diamond                 postgres    false    250         H           2606    25778    regulars pk_regulars 
   CONSTRAINT     [   ALTER TABLE ONLY diamond.regulars
    ADD CONSTRAINT pk_regulars PRIMARY KEY (id_regular);
 ?   ALTER TABLE ONLY diamond.regulars DROP CONSTRAINT pk_regulars;
       diamond                 postgres    false    249         \           2606    25725    shippings pk_shippings 
   CONSTRAINT     ^   ALTER TABLE ONLY diamond.shippings
    ADD CONSTRAINT pk_shippings PRIMARY KEY (id_shipping);
 A   ALTER TABLE ONLY diamond.shippings DROP CONSTRAINT pk_shippings;
       diamond                 postgres    false    261         Z           2606    25707    states pk_states 
   CONSTRAINT     U   ALTER TABLE ONLY diamond.states
    ADD CONSTRAINT pk_states PRIMARY KEY (id_state);
 ;   ALTER TABLE ONLY diamond.states DROP CONSTRAINT pk_states;
       diamond                 postgres    false    260         L           2606    25489    suppliers pk_suppliers 
   CONSTRAINT     ^   ALTER TABLE ONLY diamond.suppliers
    ADD CONSTRAINT pk_suppliers PRIMARY KEY (id_supplier);
 A   ALTER TABLE ONLY diamond.suppliers DROP CONSTRAINT pk_suppliers;
       diamond                 postgres    false    251         B           2606    25739    customers uq_customers_email 
   CONSTRAINT     Y   ALTER TABLE ONLY diamond.customers
    ADD CONSTRAINT uq_customers_email UNIQUE (email);
 G   ALTER TABLE ONLY diamond.customers DROP CONSTRAINT uq_customers_email;
       diamond                 postgres    false    246         u           2620    25755 %   shippings trg_calculate_shipping_cost    TRIGGER     �   CREATE TRIGGER trg_calculate_shipping_cost BEFORE INSERT OR UPDATE ON diamond.shippings FOR EACH ROW EXECUTE FUNCTION diamond.fn_calculate_shipping_cost();
 ?   DROP TRIGGER trg_calculate_shipping_cost ON diamond.shippings;
       diamond               postgres    false    271    261         m           2620    25743 2   details_invoice_sales trg_calculate_subtotal_sales    TRIGGER     �   CREATE TRIGGER trg_calculate_subtotal_sales BEFORE INSERT OR UPDATE ON diamond.details_invoice_sales FOR EACH ROW EXECUTE FUNCTION diamond.fn_calculate_subtotal_sales();
 L   DROP TRIGGER trg_calculate_subtotal_sales ON diamond.details_invoice_sales;
       diamond               postgres    false    267    254         q           2620    25745 :   details_invoice_suppliers trg_calculate_subtotal_suppliers    TRIGGER     �   CREATE TRIGGER trg_calculate_subtotal_suppliers BEFORE INSERT OR UPDATE ON diamond.details_invoice_suppliers FOR EACH ROW EXECUTE FUNCTION diamond.fn_calculate_subtotal_suppliers();
 T   DROP TRIGGER trg_calculate_subtotal_suppliers ON diamond.details_invoice_suppliers;
       diamond               postgres    false    268    256         n           2620    25749 ;   details_invoice_sales trg_update_total_invoice_sales_delete    TRIGGER     �   CREATE TRIGGER trg_update_total_invoice_sales_delete AFTER DELETE ON diamond.details_invoice_sales FOR EACH ROW EXECUTE FUNCTION diamond.fn_update_total_invoice_sales();
 U   DROP TRIGGER trg_update_total_invoice_sales_delete ON diamond.details_invoice_sales;
       diamond               postgres    false    254    269         o           2620    25747 ;   details_invoice_sales trg_update_total_invoice_sales_insert    TRIGGER     �   CREATE TRIGGER trg_update_total_invoice_sales_insert AFTER INSERT ON diamond.details_invoice_sales FOR EACH ROW EXECUTE FUNCTION diamond.fn_update_total_invoice_sales();
 U   DROP TRIGGER trg_update_total_invoice_sales_insert ON diamond.details_invoice_sales;
       diamond               postgres    false    254    269         p           2620    25748 ;   details_invoice_sales trg_update_total_invoice_sales_update    TRIGGER     �   CREATE TRIGGER trg_update_total_invoice_sales_update AFTER UPDATE ON diamond.details_invoice_sales FOR EACH ROW EXECUTE FUNCTION diamond.fn_update_total_invoice_sales();
 U   DROP TRIGGER trg_update_total_invoice_sales_update ON diamond.details_invoice_sales;
       diamond               postgres    false    269    254         r           2620    25753 C   details_invoice_suppliers trg_update_total_invoice_suppliers_delete    TRIGGER     �   CREATE TRIGGER trg_update_total_invoice_suppliers_delete AFTER DELETE ON diamond.details_invoice_suppliers FOR EACH ROW EXECUTE FUNCTION diamond.fn_update_total_invoice_suppliers();
 ]   DROP TRIGGER trg_update_total_invoice_suppliers_delete ON diamond.details_invoice_suppliers;
       diamond               postgres    false    270    256         s           2620    25751 C   details_invoice_suppliers trg_update_total_invoice_suppliers_insert    TRIGGER     �   CREATE TRIGGER trg_update_total_invoice_suppliers_insert AFTER INSERT ON diamond.details_invoice_suppliers FOR EACH ROW EXECUTE FUNCTION diamond.fn_update_total_invoice_suppliers();
 ]   DROP TRIGGER trg_update_total_invoice_suppliers_insert ON diamond.details_invoice_suppliers;
       diamond               postgres    false    256    270         t           2620    25752 C   details_invoice_suppliers trg_update_total_invoice_suppliers_update    TRIGGER     �   CREATE TRIGGER trg_update_total_invoice_suppliers_update AFTER UPDATE ON diamond.details_invoice_suppliers FOR EACH ROW EXECUTE FUNCTION diamond.fn_update_total_invoice_suppliers();
 ]   DROP TRIGGER trg_update_total_invoice_suppliers_update ON diamond.details_invoice_suppliers;
       diamond               postgres    false    256    270         l           2620    25741 !   products trg_validate_stock_range    TRIGGER     �   CREATE TRIGGER trg_validate_stock_range BEFORE INSERT OR UPDATE ON diamond.products FOR EACH ROW EXECUTE FUNCTION diamond.fn_validate_stock_range();
 ;   DROP TRIGGER trg_validate_stock_range ON diamond.products;
       diamond               postgres    false    252    266         d           2606    25569 ;   details_invoice_sales fk_details_invoice_sales_invoice_sale    FK CONSTRAINT     �   ALTER TABLE ONLY diamond.details_invoice_sales
    ADD CONSTRAINT fk_details_invoice_sales_invoice_sale FOREIGN KEY (id_invoice_sale) REFERENCES diamond.invoice_sales(id_invoice_sale);
 f   ALTER TABLE ONLY diamond.details_invoice_sales DROP CONSTRAINT fk_details_invoice_sales_invoice_sale;
       diamond               postgres    false    4944    253    254         e           2606    25574 6   details_invoice_sales fk_details_invoice_sales_product    FK CONSTRAINT     �   ALTER TABLE ONLY diamond.details_invoice_sales
    ADD CONSTRAINT fk_details_invoice_sales_product FOREIGN KEY (id_product) REFERENCES diamond.products(id_product);
 a   ALTER TABLE ONLY diamond.details_invoice_sales DROP CONSTRAINT fk_details_invoice_sales_product;
       diamond               postgres    false    254    252    4942         g           2606    25820 G   details_invoice_suppliers fk_details_invoice_suppliers_invoice_supplier    FK CONSTRAINT     �   ALTER TABLE ONLY diamond.details_invoice_suppliers
    ADD CONSTRAINT fk_details_invoice_suppliers_invoice_supplier FOREIGN KEY (id_invoice_supplier) REFERENCES diamond.invoice_suppliers(id_invoice_supplier);
 r   ALTER TABLE ONLY diamond.details_invoice_suppliers DROP CONSTRAINT fk_details_invoice_suppliers_invoice_supplier;
       diamond               postgres    false    255    4948    256         h           2606    25633 >   details_invoice_suppliers fk_details_invoice_suppliers_product    FK CONSTRAINT     �   ALTER TABLE ONLY diamond.details_invoice_suppliers
    ADD CONSTRAINT fk_details_invoice_suppliers_product FOREIGN KEY (id_product) REFERENCES diamond.products(id_product);
 i   ALTER TABLE ONLY diamond.details_invoice_suppliers DROP CONSTRAINT fk_details_invoice_suppliers_product;
       diamond               postgres    false    4942    256    252         ]           2606    25450    employees fk_employees_manager    FK CONSTRAINT     �   ALTER TABLE ONLY diamond.employees
    ADD CONSTRAINT fk_employees_manager FOREIGN KEY (id_manager) REFERENCES diamond.employees(id_line_item);
 I   ALTER TABLE ONLY diamond.employees DROP CONSTRAINT fk_employees_manager;
       diamond               postgres    false    4932    247    247         a           2606    25541 (   invoice_sales fk_invoice_sales_customers    FK CONSTRAINT     �   ALTER TABLE ONLY diamond.invoice_sales
    ADD CONSTRAINT fk_invoice_sales_customers FOREIGN KEY (id_customer) REFERENCES diamond.customers(id_customer);
 S   ALTER TABLE ONLY diamond.invoice_sales DROP CONSTRAINT fk_invoice_sales_customers;
       diamond               postgres    false    4928    246    253         b           2606    25551 (   invoice_sales fk_invoice_sales_employees    FK CONSTRAINT     �   ALTER TABLE ONLY diamond.invoice_sales
    ADD CONSTRAINT fk_invoice_sales_employees FOREIGN KEY (id_line_item) REFERENCES diamond.employees(id_line_item);
 S   ALTER TABLE ONLY diamond.invoice_sales DROP CONSTRAINT fk_invoice_sales_employees;
       diamond               postgres    false    253    247    4932         c           2606    25546 ,   invoice_sales fk_invoice_sales_payment_types    FK CONSTRAINT     �   ALTER TABLE ONLY diamond.invoice_sales
    ADD CONSTRAINT fk_invoice_sales_payment_types FOREIGN KEY (id_payment_type) REFERENCES diamond.payment_types(id_payment_type);
 W   ALTER TABLE ONLY diamond.invoice_sales DROP CONSTRAINT fk_invoice_sales_payment_types;
       diamond               postgres    false    4934    248    253         f           2606    25612 2   invoice_suppliers fk_invoice_suppliers_supplier_id    FK CONSTRAINT     �   ALTER TABLE ONLY diamond.invoice_suppliers
    ADD CONSTRAINT fk_invoice_suppliers_supplier_id FOREIGN KEY (id_supplier) REFERENCES diamond.suppliers(id_supplier);
 ]   ALTER TABLE ONLY diamond.invoice_suppliers DROP CONSTRAINT fk_invoice_suppliers_supplier_id;
       diamond               postgres    false    255    251    4940         ^           2606    25514    products fk_products_customers    FK CONSTRAINT     �   ALTER TABLE ONLY diamond.products
    ADD CONSTRAINT fk_products_customers FOREIGN KEY (id_customer) REFERENCES diamond.customers(id_customer);
 I   ALTER TABLE ONLY diamond.products DROP CONSTRAINT fk_products_customers;
       diamond               postgres    false    252    246    4928         _           2606    25792    products fk_products_promotions    FK CONSTRAINT     �   ALTER TABLE ONLY diamond.products
    ADD CONSTRAINT fk_products_promotions FOREIGN KEY (id_promotion) REFERENCES diamond.promotions(id_promotion);
 J   ALTER TABLE ONLY diamond.products DROP CONSTRAINT fk_products_promotions;
       diamond               postgres    false    250    4938    252         `           2606    25797    products fk_products_regulars    FK CONSTRAINT     �   ALTER TABLE ONLY diamond.products
    ADD CONSTRAINT fk_products_regulars FOREIGN KEY (id_regular) REFERENCES diamond.regulars(id_regular);
 H   ALTER TABLE ONLY diamond.products DROP CONSTRAINT fk_products_regulars;
       diamond               postgres    false    252    249    4936         j           2606    25726 #   shippings fk_shippings_invoice_sale    FK CONSTRAINT     �   ALTER TABLE ONLY diamond.shippings
    ADD CONSTRAINT fk_shippings_invoice_sale FOREIGN KEY (id_invoice_sale) REFERENCES diamond.invoice_sales(id_invoice_sale);
 N   ALTER TABLE ONLY diamond.shippings DROP CONSTRAINT fk_shippings_invoice_sale;
       diamond               postgres    false    261    253    4944         k           2606    25731    shippings fk_shippings_states    FK CONSTRAINT     �   ALTER TABLE ONLY diamond.shippings
    ADD CONSTRAINT fk_shippings_states FOREIGN KEY (id_state) REFERENCES diamond.states(id_state);
 H   ALTER TABLE ONLY diamond.shippings DROP CONSTRAINT fk_shippings_states;
       diamond               postgres    false    261    260    4954         i           2606    25708    states fk_states_cities    FK CONSTRAINT     ~   ALTER TABLE ONLY diamond.states
    ADD CONSTRAINT fk_states_cities FOREIGN KEY (id_city) REFERENCES diamond.cities(id_city);
 B   ALTER TABLE ONLY diamond.states DROP CONSTRAINT fk_states_cities;
       diamond               postgres    false    259    260    4952                                                                                                                                                                                                                                                                                                         5138.dat                                                                                            0000600 0004000 0002000 00000032716 15014423351 0014261 0                                                                                                    ustar 00postgres                        postgres                        0000000 0000000                                                                                                                                                                        A01	MEDELLIN
A02	ABEJORRAL
A03	ABRIAQUI
A04	ALEJANDRIA
A05	AMAGA
A06	AMALFI
A07	ANDES
A08	ANGELOPOLIS
A09	ANGOSTURA
A10	ANORI
A11	SANTAFE DE ANTIOQUIA
A12	ANZA
A13	APARTADO
A14	ARBOLETES
A15	ARGELIA
A16	ARMENIA
A17	BARBOSA
A18	BELMIRA
A19	BELLO
A20	BETANIA
A21	BETULIA
A22	CIUDAD BOLIVAR
A23	BRICEÑO
A24	BURITICA
A25	CACERES
A26	CAICEDO
A27	CALDAS
A28	CAMPAMENTO
A29	CAÑASGORDAS
A30	CARACOLI
A31	CARAMANTA
A32	CAREPA
A33	EL CARMEN DE VIBORAL
A34	CAROLINA
A35	CAUCASIA
A36	CHIGORODO
A37	CISNEROS
A38	COCORNA
A39	CONCEPCION
A40	CONCORDIA
A41	COPACABANA
A42	DABEIBA
A43	DON MATIAS
A44	EBEJICO
A45	EL BAGRE
A46	ENTRERRIOS
A47	ENVIGADO
A48	FREDONIA
A49	FRONTINO
A50	GIRALDO
A51	GIRARDOTA
A52	GOMEZ PLATA
A53	GRANADA
A54	GUADALUPE
A55	GUARNE
A56	GUATAPE
A57	HELICONIA
A58	HISPANIA
A59	ITAGUI
A60	ITUANGO
A61	JARDIN
A62	JERICO
A63	LA CEJA
A64	LA ESTRELLA
A65	LA PINTADA
A66	LA UNION
A67	LIBORINA
A68	MACEO
A69	MARINILLA
A70	MONTEBELLO
A71	MURINDO
A72	MUTATA
A73	NARIÑO
A74	NECOCLI
A75	NECHI
A76	OLAYA
A77	PEÑOL
A78	PEQUE
A79	PUEBLORRICO
A80	PUERTO BERRIO
A81	PUERTO NARE
A82	PUERTO TRIUNFO
A83	REMEDIOS
A84	RETIRO
A85	RIONEGRO
A86	SABANALARGA
A87	SABANETA
A88	SALGAR
A89	SAN ANDRES DE CUERQUIA
A90	SAN CARLOS
A91	SAN FRANCISCO
A92	SAN JERONIMO
A93	SAN JOSE DE LA MONTAÑA
A94	SAN JUAN DE URABA
A95	SAN LUIS
A96	SAN PEDRO
A97	SAN PEDRO DE URABA
A98	SAN RAFAEL
A99	SAN ROQUE
A00	SAN VICENTE
B01	SANTA BARBARA
B02	SANTA ROSA DE OSOS
B03	SANTO DOMINGO
B04	EL SANTUARIO
B05	SEGOVIA
B06	SONSON
B07	SOPETRAN
B08	TAMESIS
B09	TARAZA
B10	TARSO
B11	TITIRIBI
B12	TOLEDO
B13	TURBO
B14	URAMITA
B15	URRAO
B16	VALDIVIA
B17	VALPARAISO
B18	VEGACHI
B19	VENECIA
B20	VIGIA DEL FUERTE
B21	YALI
B22	YARUMAL
B23	YOLOMBO
B24	YONDO
B25	ZARAGOZA
B26	BARRANQUILLA
B27	BARANOA
B28	CAMPO DE LA CRUZ
B29	CANDELARIA
B30	GALAPA
B31	JUAN DE ACOSTA
B32	LURUACO
B33	MALAMBO
B34	MANATI
B35	PALMAR DE VARELA
B36	PIOJO
B37	POLONUEVO
B38	PONEDERA
B39	PUERTO COLOMBIA
B40	REPELON
B41	SABANAGRANDE
B42	SABANALARGA
B43	SANTA LUCIA
B44	SANTO TOMAS
B45	SOLEDAD
B46	SUAN
B47	TUBARA
B48	USIACURI
B49	BOGOTA, D.C.
B50	CARTAGENA
B51	ACHI
B52	ALTOS DEL ROSARIO
B53	ARENAL
B54	ARJONA
B55	ARROYOHONDO
B56	BARRANCO DE LOBA
B57	CALAMAR
B58	CANTAGALLO
B59	CICUCO
B60	CORDOBA
B61	CLEMENCIA
B62	EL CARMEN DE BOLIVAR
B63	EL GUAMO
B64	EL PEÑON
B65	HATILLO DE LOBA
B66	MAGANGUE
B67	MAHATES
B68	MARGARITA
B69	MARIA LA BAJA
B70	MONTECRISTO
B71	MOMPOS
B72	NOROSI
B73	MORALES
B74	PINILLOS
B75	REGIDOR
B76	RIO VIEJO
B77	SAN CRISTOBAL
B78	SAN ESTANISLAO
B79	SAN FERNANDO
B80	SAN JACINTO
B81	SAN JACINTO DEL CAUCA
B82	SAN JUAN NEPOMUCENO
B83	SAN MARTIN DE LOBA
B84	SAN PABLO
B85	SANTA CATALINA
B86	SANTA ROSA
B87	SANTA ROSA DEL SUR
B88	SIMITI
B89	SOPLAVIENTO
B90	TALAIGUA NUEVO
B91	TIQUISIO
B92	TURBACO
B93	TURBANA
B94	VILLANUEVA
B95	ZAMBRANO
B96	TUNJA
B97	ALMEIDA
B98	AQUITANIA
B99	ARCABUCO
B00	BELEN
C01	BERBEO
C02	BETEITIVA
C03	BOAVITA
C04	BOYACA
C05	BRICEÑO
C06	BUENAVISTA
C07	BUSBANZA
C08	CALDAS
C09	CAMPOHERMOSO
C10	CERINZA
C11	CHINAVITA
C12	CHIQUINQUIRA
C13	CHISCAS
C14	CHITA
C15	CHITARAQUE
C16	CHIVATA
C17	CIENEGA
C18	COMBITA
C19	COPER
C20	CORRALES
C21	COVARACHIA
C22	CUBARA
C23	CUCAITA
C24	CUITIVA
C25	CHIQUIZA
C26	CHIVOR
C27	DUITAMA
C28	EL COCUY
C29	EL ESPINO
C30	FIRAVITOBA
C31	FLORESTA
C32	GACHANTIVA
C33	GAMEZA
C34	GARAGOA
C35	GUACAMAYAS
C36	GUATEQUE
C37	GUAYATA
C38	GsICAN
C39	IZA
C40	JENESANO
C41	JERICO
C42	LABRANZAGRANDE
C43	LA CAPILLA
C44	LA VICTORIA
C45	LA UVITA
C46	VILLA DE LEYVA
C47	MACANAL
C48	MARIPI
C49	MIRAFLORES
C50	MONGUA
C51	MONGUI
C52	MONIQUIRA
C53	MOTAVITA
C54	MUZO
C55	NOBSA
C56	NUEVO COLON
C57	OICATA
C58	OTANCHE
C59	PACHAVITA
C60	PAEZ
C61	PAIPA
C62	PAJARITO
C63	PANQUEBA
C64	PAUNA
C65	PAYA
C66	PAZ DE RIO
C67	PESCA
C68	PISBA
C69	PUERTO BOYACA
C70	QUIPAMA
C71	RAMIRIQUI
C72	RAQUIRA
C73	RONDON
C74	SABOYA
C75	SACHICA
C76	SAMACA
C77	SAN EDUARDO
C78	SAN JOSE DE PARE
C79	SAN LUIS DE GACENO
C80	SAN MATEO
C81	SAN MIGUEL DE SEMA
C82	SAN PABLO DE BORBUR
C83	SANTANA
C84	SANTA MARIA
C85	SANTA ROSA DE VITERBO
C86	SANTA SOFIA
C87	SATIVANORTE
C88	SATIVASUR
C89	SIACHOQUE
C90	SOATA
C91	SOCOTA
C92	SOCHA
C93	SOGAMOSO
C94	SOMONDOCO
C95	SORA
C96	SOTAQUIRA
C97	SORACA
C98	SUSACON
C99	SUTAMARCHAN
C00	SUTATENZA
D01	TASCO
D02	TENZA
D03	TIBANA
D04	TIBASOSA
D05	TINJACA
D06	TIPACOQUE
D07	TOCA
D08	TOGsI
D09	TOPAGA
D10	TOTA
D11	TUNUNGUA
D12	TURMEQUE
D13	TUTA
D14	TUTAZA
D15	UMBITA
D16	VENTAQUEMADA
D17	VIRACACHA
D18	ZETAQUIRA
D19	MANIZALES
D20	AGUADAS
D21	ANSERMA
D22	ARANZAZU
D23	BELALCAZAR
D24	CHINCHINA
D25	FILADELFIA
D26	LA DORADA
D27	LA MERCED
D28	MANZANARES
D29	MARMATO
D30	MARQUETALIA
D31	MARULANDA
D32	NEIRA
D33	NORCASIA
D34	PACORA
D35	PALESTINA
D36	PENSILVANIA
D37	RIOSUCIO
D38	RISARALDA
D39	SALAMINA
D40	SAMANA
D41	SAN JOSE
D42	SUPIA
D43	VICTORIA
D44	VILLAMARIA
D45	VITERBO
D46	FLORENCIA
D47	ALBANIA
D48	BELEN DE LOS ANDAQUIES
D49	CARTAGENA DEL CHAIRA
D50	CURILLO
D51	EL DONCELLO
D52	EL PAUJIL
D53	LA MONTAÑITA
D54	MILAN
D55	MORELIA
D56	PUERTO RICO
D57	SAN JOSE DEL FRAGUA
D58	SAN VICENTE DEL CAGUAN
D59	SOLANO
D60	SOLITA
D61	VALPARAISO
D62	POPAYAN
D63	ALMAGUER
D64	ARGELIA
D65	BALBOA
D66	BOLIVAR
D67	BUENOS AIRES
D68	CAJIBIO
D69	CALDONO
D70	CALOTO
D71	CORINTO
D72	EL TAMBO
D73	FLORENCIA
D74	GUACHENE
D75	GUAPI
D76	INZA
D77	JAMBALO
D78	LA SIERRA
D79	LA VEGA
D80	LOPEZ
D81	MERCADERES
D82	MIRANDA
D83	MORALES
D84	PADILLA
D85	PAEZ
D86	PATIA
D87	PIAMONTE
D88	PIENDAMO
D89	PUERTO TEJADA
D90	PURACE
D91	ROSAS
D92	SAN SEBASTIAN
D93	SANTANDER DE QUILICHAO
D94	SANTA ROSA
D95	SILVIA
D96	SOTARA
D97	SUAREZ
D98	SUCRE
D99	TIMBIO
D00	TIMBIQUI
E01	TORIBIO
E02	TOTORO
E03	VILLA RICA
E04	VALLEDUPAR
E05	AGUACHICA
E06	AGUSTIN CODAZZI
E07	ASTREA
E08	BECERRIL
E09	BOSCONIA
E10	CHIMICHAGUA
E11	CHIRIGUANA
E12	CURUMANI
E13	EL COPEY
E14	EL PASO
E15	GAMARRA
E16	GONZALEZ
E17	LA GLORIA
E18	LA JAGUA DE IBIRICO
E19	MANAURE
E20	PAILITAS
E21	PELAYA
E22	PUEBLO BELLO
E23	RIO DE ORO
E24	LA PAZ
E25	SAN ALBERTO
E26	SAN DIEGO
E27	SAN MARTIN
E28	TAMALAMEQUE
E29	MONTERIA
E30	AYAPEL
E31	BUENAVISTA
E32	CANALETE
E33	CERETE
E34	CHIMA
E35	CHINU
E36	CIENAGA DE ORO
E37	COTORRA
E38	LA APARTADA
E39	LORICA
E40	LOS CORDOBAS
E41	MOMIL
E42	MONTELIBANO
E43	MOÑITOS
E44	PLANETA RICA
E45	PUEBLO NUEVO
E46	PUERTO ESCONDIDO
E47	PUERTO LIBERTADOR
E48	PURISIMA
E49	SAHAGUN
E50	SAN ANDRES SOTAVENTO
E51	SAN ANTERO
E52	SAN BERNARDO DEL VIENTO
E53	SAN CARLOS
E54	SAN PELAYO
E55	TIERRALTA
E56	VALENCIA
E57	AGUA DE DIOS
E58	ALBAN
E59	ANAPOIMA
E60	ANOLAIMA
E61	ARBELAEZ
E62	BELTRAN
E63	BITUIMA
E64	BOJACA
E65	CABRERA
E66	CACHIPAY
E67	CAJICA
E68	CAPARRAPI
E69	CAQUEZA
E70	CARMEN DE CARUPA
E71	CHAGUANI
E72	CHIA
E73	CHIPAQUE
E74	CHOACHI
E75	CHOCONTA
E76	COGUA
E77	COTA
E78	CUCUNUBA
E79	EL COLEGIO
E80	EL PEÑON
E81	EL ROSAL
E82	FACATATIVA
E83	FOMEQUE
E84	FOSCA
E85	FUNZA
E86	FUQUENE
E87	FUSAGASUGA
E88	GACHALA
E89	GACHANCIPA
E90	GACHETA
E91	GAMA
E92	GIRARDOT
E93	GRANADA
E94	GUACHETA
E95	GUADUAS
E96	GUASCA
E97	GUATAQUI
E98	GUATAVITA
E99	GUAYABAL DE SIQUIMA
E00	GUAYABETAL
F01	GUTIERREZ
F02	JERUSALEN
F03	JUNIN
F04	LA CALERA
F05	LA MESA
F06	LA PALMA
F07	LA PEÑA
F08	LA VEGA
F09	LENGUAZAQUE
F10	MACHETA
F11	MADRID
F12	MANTA
F13	MEDINA
F14	MOSQUERA
F15	NARIÑO
F16	NEMOCON
F17	NILO
F18	NIMAIMA
F19	NOCAIMA
F20	VENECIA
F21	PACHO
F22	PAIME
F23	PANDI
F24	PARATEBUENO
F25	PASCA
F26	PUERTO SALGAR
F27	PULI
F28	QUEBRADANEGRA
F29	QUETAME
F30	QUIPILE
F31	APULO
F32	RICAURTE
F33	SAN ANTONIO DEL TEQUENDAMA
F34	SAN BERNARDO
F35	SAN CAYETANO
F36	SAN FRANCISCO
F37	SAN JUAN DE RIO SECO
F38	SASAIMA
F39	SESQUILE
F40	SIBATE
F41	SILVANIA
F42	SIMIJACA
F43	SOACHA
F44	SOPO
F45	SUBACHOQUE
F46	SUESCA
F47	SUPATA
F48	SUSA
F49	SUTATAUSA
F50	TABIO
F51	TAUSA
F52	TENA
F53	TENJO
F54	TIBACUY
F55	TIBIRITA
F56	TOCAIMA
F57	TOCANCIPA
F58	TOPAIPI
F59	UBALA
F60	UBAQUE
F61	VILLA DE SAN DIEGO DE UBATE
F62	UNE
F63	UTICA
F64	VERGARA
F65	VIANI
F66	VILLAGOMEZ
F67	VILLAPINZON
F68	VILLETA
F69	VIOTA
F70	YACOPI
F71	ZIPACON
F72	ZIPAQUIRA
F73	QUIBDO
F74	ACANDI
F75	ALTO BAUDO
F76	ATRATO
F77	BAGADO
F78	BAHIA SOLANO
F79	BAJO BAUDO
F80	BOJAYA
F81	EL CANTON DEL SAN PABLO
F82	CARMEN DEL DARIEN
F83	CERTEGUI
F84	CONDOTO
F85	EL CARMEN DE ATRATO
F86	EL LITORAL DEL SAN JUAN
F87	ISTMINA
F88	JURADO
F89	LLORO
F90	MEDIO ATRATO
F91	MEDIO BAUDO
F92	MEDIO SAN JUAN
F93	NOVITA
F94	NUQUI
F95	RIO IRO
F96	RIO QUITO
F97	RIOSUCIO
F98	SAN JOSE DEL PALMAR
F99	SIPI
F00	TADO
G01	UNGUIA
G02	UNION PANAMERICANA
G03	NEIVA
G04	ACEVEDO
G05	AGRADO
G06	AIPE
G07	ALGECIRAS
G08	ALTAMIRA
G09	BARAYA
G10	CAMPOALEGRE
G11	COLOMBIA
G12	ELIAS
G13	GARZON
G14	GIGANTE
G15	GUADALUPE
G16	HOBO
G17	IQUIRA
G18	ISNOS
G19	LA ARGENTINA
G20	LA PLATA
G21	NATAGA
G22	OPORAPA
G23	PAICOL
G24	PALERMO
G25	PALESTINA
G26	PITAL
G27	PITALITO
G28	RIVERA
G29	SALADOBLANCO
G30	SAN AGUSTIN
G31	SANTA MARIA
G32	SUAZA
G33	TARQUI
G34	TESALIA
G35	TELLO
G36	TERUEL
G37	TIMANA
G38	VILLAVIEJA
G39	YAGUARA
G40	RIOHACHA
G41	ALBANIA
G42	BARRANCAS
G43	DIBULLA
G44	DISTRACCION
G45	EL MOLINO
G46	FONSECA
G47	HATONUEVO
G48	LA JAGUA DEL PILAR
G49	MAICAO
G50	MANAURE
G51	SAN JUAN DEL CESAR
G52	URIBIA
G53	URUMITA
G54	VILLANUEVA
G55	SANTA MARTA
G56	ALGARROBO
G57	ARACATACA
G58	ARIGUANI
G59	CERRO SAN ANTONIO
G60	CHIBOLO
G61	CIENAGA
G62	CONCORDIA
G63	EL BANCO
G64	EL PIÑON
G65	EL RETEN
G66	FUNDACION
G67	GUAMAL
G68	NUEVA GRANADA
G69	PEDRAZA
G70	PIJIÑO DEL CARMEN
G71	PIVIJAY
G72	PLATO
G73	PUEBLOVIEJO
G74	REMOLINO
G75	SABANAS DE SAN ANGEL
G76	SALAMINA
G77	SAN SEBASTIAN DE BUENAVISTA
G78	SAN ZENON
G79	SANTA ANA
G80	SANTA BARBARA DE PINTO
G81	SITIONUEVO
G82	TENERIFE
G83	ZAPAYAN
G84	ZONA BANANERA
G85	VILLAVICENCIO
G86	ACACIAS
G87	BARRANCA DE UPIA
G88	CABUYARO
G89	CASTILLA LA NUEVA
G90	CUBARRAL
G91	CUMARAL
G92	EL CALVARIO
G93	EL CASTILLO
G94	EL DORADO
G95	FUENTE DE ORO
G96	GRANADA
G97	GUAMAL
G98	MAPIRIPAN
G99	MESETAS
G00	LA MACARENA
H01	URIBE
H02	LEJANIAS
H03	PUERTO CONCORDIA
H04	PUERTO GAITAN
H05	PUERTO LOPEZ
H06	PUERTO LLERAS
H07	PUERTO RICO
H08	RESTREPO
H09	SAN CARLOS DE GUAROA
H10	SAN JUAN DE ARAMA
H11	SAN JUANITO
H12	SAN MARTIN
H13	VISTAHERMOSA
H14	PASTO
H15	ALBAN
H16	ALDANA
H17	ANCUYA
H18	ARBOLEDA
H19	BARBACOAS
H20	BELEN
H21	BUESACO
H22	COLON
H23	CONSACA
H24	CONTADERO
H25	CORDOBA
H26	CUASPUD
H27	CUMBAL
H28	CUMBITARA
H29	CHACHAGÜI
H30	EL CHARCO
H31	EL PEÑOL
H32	EL ROSARIO
H33	EL TABLON DE GOMEZ
H34	EL TAMBO
H35	FUNES
H36	GUACHUCAL
H37	GUAITARILLA
H38	GUALMATAN
H39	ILES
H40	IMUES
H41	IPIALES
H42	LA CRUZ
H43	LA FLORIDA
H44	LA LLANADA
H45	LA TOLA
H46	LA UNION
H47	LEIVA
H48	LINARES
H49	LOS ANDES
H50	MAGÜI
H51	MALLAMA
H52	MOSQUERA
H53	NARIÑO
H54	OLAYA HERRERA
H55	OSPINA
H56	FRANCISCO PIZARRO
H57	POLICARPA
H58	POTOSI
H59	PROVIDENCIA
H60	PUERRES
H61	PUPIALES
H62	RICAURTE
H63	ROBERTO PAYAN
H64	SAMANIEGO
H65	SANDONA
H66	SAN BERNARDO
H67	SAN LORENZO
H68	SAN PABLO
H69	SAN PEDRO DE CARTAGO
H70	SANTA BARBARA
H71	SANTACRUZ
H72	SAPUYES
H73	TAMINANGO
H74	TANGUA
H75	SAN ANDRES DE TUMACO
H76	TUQUERRES
H77	YACUANQUER
H78	CUCUTA
H79	ABREGO
H80	ARBOLEDAS
H81	BOCHALEMA
H82	BUCARASICA
H83	CACOTA
H84	CACHIRA
H85	CHINACOTA
H86	CHITAGA
H87	CONVENCION
H88	CUCUTILLA
H89	DURANIA
H90	EL CARMEN
H91	EL TARRA
H92	EL ZULIA
H93	GRAMALOTE
H94	HACARI
H95	HERRAN
H96	LABATECA
H97	LA ESPERANZA
H98	LA PLAYA
H99	LOS PATIOS
H00	LOURDES
I01	MUTISCUA
I02	OCAÑA
I03	PAMPLONA
I04	PAMPLONITA
I05	PUERTO SANTANDER
I06	RAGONVALIA
I07	SALAZAR
I08	SAN CALIXTO
I09	SAN CAYETANO
I10	SANTIAGO
I11	SARDINATA
I12	SILOS
I13	TEORAMA
I14	TIBU
I15	TOLEDO
I16	VILLA CARO
I17	VILLA DEL ROSARIO
I18	ARMENIA
I19	BUENAVISTA
I20	CALARCA
I21	CIRCASIA
I22	CORDOBA
I23	FILANDIA
I24	GENOVA
I25	LA TEBAIDA
I26	MONTENEGRO
I27	PIJAO
I28	QUIMBAYA
I29	SALENTO
I30	PEREIRA
I31	APIA
I32	BALBOA
I33	BELEN DE UMBRIA
I34	DOSQUEBRADAS
I35	GUATICA
I36	LA CELIA
I37	LA VIRGINIA
I38	MARSELLA
I39	MISTRATO
I40	PUEBLO RICO
I41	QUINCHIA
I42	SANTA ROSA DE CABAL
I43	SANTUARIO
I44	BUCARAMANGA
I45	AGUADA
I46	ALBANIA
I47	ARATOCA
I48	BARBOSA
I49	BARICHARA
I50	BARRANCABERMEJA
I51	BETULIA
I52	BOLIVAR
I53	CABRERA
I54	CALIFORNIA
I55	CAPITANEJO
I56	CARCASI
I57	CEPITA
I58	CERRITO
I59	CHARALA
I60	CHARTA
I61	CHIMA
I62	CHIPATA
I63	CIMITARRA
I64	CONCEPCION
I65	CONFINES
I66	CONTRATACION
I67	COROMORO
I68	CURITI
I69	EL CARMEN DE CHUCURI
I70	EL GUACAMAYO
I71	EL PEÑON
I72	EL PLAYON
I73	ENCINO
I74	ENCISO
I75	FLORIAN
I76	FLORIDABLANCA
I77	GALAN
I78	GAMBITA
I79	GIRON
I80	GUACA
I81	GUADALUPE
I82	GUAPOTA
I83	GUAVATA
I84	GSEPSA
I85	HATO
I86	JESUS MARIA
I87	JORDAN
I88	LA BELLEZA
I89	LANDAZURI
I90	LA PAZ
I91	LEBRIJA
I92	LOS SANTOS
I93	MACARAVITA
I94	MALAGA
I95	MATANZA
I96	MOGOTES
I97	MOLAGAVITA
I98	OCAMONTE
I99	OIBA
I00	ONZAGA
J01	PALMAR
J02	PALMAS DEL SOCORRO
J03	PARAMO
J04	PIEDECUESTA
J05	PINCHOTE
J06	PUENTE NACIONAL
J07	PUERTO PARRA
J08	PUERTO WILCHES
J09	RIONEGRO
J10	SABANA DE TORRES
J11	SAN ANDRES
J12	SAN BENITO
J13	SAN GIL
J14	SAN JOAQUIN
J15	SAN JOSE DE MIRANDA
J16	SAN MIGUEL
J17	SAN VICENTE DE CHUCURI
J18	SANTA BARBARA
J19	SANTA HELENA DEL OPON
J20	SIMACOTA
J21	SOCORRO
J22	SUAITA
J23	SUCRE
J24	SURATA
J25	TONA
J26	VALLE DE SAN JOSE
J27	VELEZ
J28	VETAS
J29	VILLANUEVA
J30	ZAPATOCA
J31	SINCELEJO
J32	BUENAVISTA
J33	CAIMITO
J34	COLOSO
J35	COROZAL
J36	COVEÑAS
J37	CHALAN
J38	EL ROBLE
J39	GALERAS
J40	GUARANDA
J41	LA UNION
J42	LOS PALMITOS
J43	MAJAGUAL
J44	MORROA
J45	OVEJAS
J46	PALMITO
J47	SAMPUES
J48	SAN BENITO ABAD
J49	SAN JUAN DE BETULIA
J50	SAN MARCOS
J51	SAN ONOFRE
J52	SAN PEDRO
J53	SAN LUIS DE SINCE
J54	SUCRE
J55	SANTIAGO DE TOLU
J56	TOLU VIEJO
J57	IBAGUE
J58	ALPUJARRA
J59	ALVARADO
J60	AMBALEMA
J61	ANZOATEGUI
J62	ARMERO
J63	ATACO
J64	CAJAMARCA
J65	CARMEN DE APICALA
J66	CASABIANCA
J67	CHAPARRAL
J68	COELLO
J69	COYAIMA
J70	CUNDAY
J71	DOLORES
J72	ESPINAL
J73	FALAN
J74	FLANDES
J75	FRESNO
J76	GUAMO
J77	HERVEO
J78	HONDA
J79	ICONONZO
J80	LERIDA
J81	LIBANO
J82	MARIQUITA
J83	MELGAR
J84	MURILLO
J85	NATAGAIMA
J86	ORTEGA
J87	PALOCABILDO
J88	PIEDRAS
J89	PLANADAS
J90	PRADO
J91	PURIFICACION
J92	RIOBLANCO
J93	RONCESVALLES
J94	ROVIRA
J95	SALDAÑA
J96	SAN ANTONIO
J97	SAN LUIS
J98	SANTA ISABEL
J99	SUAREZ
J00	VALLE DE SAN JUAN
\.


                                                  5127.dat                                                                                            0000600 0004000 0002000 00000153774 15014423351 0014267 0                                                                                                    ustar 00postgres                        postgres                        0000000 0000000                                                                                                                                                                        C001	Ana	Perez	3001234501	ana.perez@example.com
C002	Luis	Gomez	3109876502	luis.gomez@mail.com
C003	Maria	Rodriguez	3205551203	maria.rodriguez@test.org
C004	Carlos	Lopez	3017654304	carlos.lopez@example.net
C005	Sofia	Martinez	3151237805	sofia.martinez@email.com
C006	Juan	Sanchez	3002345606	juan.sanchez@example.org
C007	Laura	Fernandez	3108765407	laura.fernandez@mail.net
C008	Pedro	Garcia	3204441208	pedro.garcia@test.com
C009	Carmen	Gonzalez	3016543209	carmen.gonzalez@example.com
C010	David	Diaz	3152348710	david.diaz@email.net
C011	Isabel	Ruiz	3003456711	isabel.ruiz@mail.org
C012	Miguel	Alvarez	3107654312	miguel.alvarez@test.net
C013	Patricia	Moreno	3203331213	patricia.moreno@example.com
C014	Javier	Jimenez	3015432114	javier.jimenez@email.org
C015	Elena	Vargas	3153459815	elena.vargas@mail.com
C016	Andres	Castro	3004567816	andres.castro@test.org
C017	Camila	Silva	3106543217	camila.silva@example.net
C018	Santiago	Torres	3202221218	santiago.torres@email.com
C019	Valentina	Rojas	3014321019	valentina.rojas@example.org
C020	Daniel	Herrera	3154560920	daniel.herrera@mail.net
C021	Gabriela	Medina	3005678921	gabriela.medina@test.com
C022	Ricardo	Flores	3105432122	ricardo.flores@example.com
C023	Paula	Morales	3201111223	paula.morales@email.net
C024	Alejandro	Ortega	3013210924	alejandro.ortega@mail.org
C025	Natalia	Guzman	3155671025	natalia.guzman@test.net
C026	Ana	Ramos	3006789026	ana.ramos@example.com
C027	Luis	Cruz	3104321027	luis.cruz@email.org
C028	Maria	Romero	3200001228	maria.romero@mail.com
C029	Carlos	Vasquez	3012109829	carlos.vasquez@test.org
C030	Sofia	Reyes	3156780130	sofia.reyes@example.net
C031	Juan	Perez	3007890131	juan.perez1@example.com
C032	Laura	Gomez	3103210932	laura.gomez1@mail.com
C033	Pedro	Rodriguez	3209991233	pedro.rodriguez1@test.org
C034	Carmen	Lopez	3011098734	carmen.lopez1@example.net
C035	David	Martinez	3157891235	david.martinez1@email.com
C036	Isabel	Sanchez	3008901236	isabel.sanchez1@example.org
C037	Miguel	Fernandez	3102109837	miguel.fernandez1@mail.net
C038	Patricia	Garcia	3208881238	patricia.garcia1@test.com
C039	Javier	Gonzalez	3010987639	javier.gonzalez1@example.com
C040	Elena	Diaz	3158902340	elena.diaz1@email.net
C041	Andres	Ruiz	3009012341	andres.ruiz1@mail.org
C042	Camila	Alvarez	3101098742	camila.alvarez1@test.net
C043	Santiago	Moreno	3207771243	santiago.moreno1@example.com
C044	Valentina	Jimenez	3019876544	valentina.jimenez1@email.org
C045	Daniel	Vargas	3159013445	daniel.vargas1@mail.com
C046	Gabriela	Castro	3000123446	gabriela.castro1@test.org
C047	Ricardo	Silva	3109876547	ricardo.silva1@example.net
C048	Paula	Torres	3206661248	paula.torres1@email.com
C049	Alejandro	Rojas	3018765449	alejandro.rojas1@example.org
C050	Natalia	Herrera	3150124550	natalia.herrera1@mail.net
C051	Martin	Acosta	3115839201	martin.acosta@example.com
C052	Lucia	Benitez	3227492058	lucia.benitez@mail.net
C053	Fernando	Campos	3001238765	fernando.campos@test.org
C054	Veronica	Dominguez	3183214567	veronica.dominguez@email.com
C055	Sergio	Esteban	3147659870	sergio.esteban@example.net
C056	Andrea	Fuentes	3058761234	andrea.fuentes@mail.org
C057	Jorge	Gil	3123456789	jorge.gil@test.com
C058	Adriana	Hernandez	3178901234	adriana.hernandez@email.net
C059	Alberto	Iglesias	3025678901	alberto.iglesias@example.org
C060	Monica	Juarez	3161234567	monica.juarez@mail.com
C061	Victor	Leon	3192345678	victor.leon@test.net
C062	Cristina	Marin	3046789012	cristina.marin@example.com
C063	Raul	Nuñez	3135678901	raul.nunez@email.org
C064	Beatriz	Ortiz	3218901234	beatriz.ortiz@mail.com
C065	Oscar	Peña	3009876543	oscar.pena@test.org
C066	Silvia	Quintana	3101234560	silvia.quintana@example.net
C067	Jose	Salazar	3157654321	jose.salazar@email.com
C068	Rosa	Soto	3012345670	rosa.soto@example.org
C069	Manuel	Uribe	3208765432	manuel.uribe@mail.net
C070	Teresa	Vega	3186543210	teresa.vega@test.com
C071	Francisco	Perez	3027654321	francisco.perez@example.com
C072	Gloria	Gomez	3165432109	gloria.gomez@email.net
C073	Antonio	Rodriguez	3112345671	antonio.rodriguez@mail.org
C074	Angela	Lopez	3226543210	angela.lopez@test.net
C075	Diego	Martinez	3008765430	diego.martinez@example.com
C076	Sandra	Sanchez	3171234562	sandra.sanchez@email.org
C077	Ana	Fernandez	3043210987	ana.fernandez1@mail.com
C078	Luis	Garcia	3138765431	luis.garcia1@test.org
C079	Maria	Gonzalez	3211234563	maria.gonzalez1@example.net
C080	Carlos	Diaz	3007654329	carlos.diaz1@email.com
C081	Sofia	Ruiz	3106543218	sofia.ruiz1@example.org
C082	Juan	Alvarez	3155432107	juan.alvarez1@mail.net
C083	Laura	Moreno	3011234564	laura.moreno1@test.com
C084	Pedro	Jimenez	3203210986	pedro.jimenez1@example.com
C085	Carmen	Vargas	3182109875	carmen.vargas1@email.net
C086	David	Castro	3022109874	david.castro1@mail.org
C087	Isabel	Silva	3161098763	isabel.silva1@test.net
C088	Miguel	Torres	3110987652	miguel.torres1@example.com
C089	Patricia	Rojas	3229876541	patricia.rojas1@email.org
C090	Javier	Herrera	3009876540	javier.herrera1@mail.com
C091	Elena	Medina	3178765439	elena.medina1@test.org
C092	Andres	Flores	3047654328	andres.flores1@example.net
C093	Camila	Morales	3136543217	camila.morales1@email.com
C094	Santiago	Ortega	3215432106	santiago.ortega1@example.org
C095	Valentina	Guzman	3004321095	valentina.guzman1@mail.net
C096	Daniel	Ramos	3103210984	daniel.ramos1@test.com
C097	Gabriela	Cruz	3152109873	gabriela.cruz1@example.com
C098	Ricardo	Romero	3011098762	ricardo.romero1@email.net
C099	Paula	Vasquez	3200987651	paula.vasquez1@mail.org
C100	Alejandro	Reyes	3189876540	alejandro.reyes1@test.net
C101	Natalia	Acosta	3028765439	natalia.acosta@example.com
C102	Martin	Benitez	3167654328	martin.benitez@mail.net
C103	Lucia	Campos	3116543217	lucia.campos@test.org
C104	Fernando	Dominguez	3225432106	fernando.dominguez@email.com
C105	Veronica	Esteban	3004321095	veronica.esteban@example.net
C106	Sergio	Fuentes	3173210984	sergio.fuentes@mail.org
C107	Andrea	Gil	3042109873	andrea.gil@test.com
C108	Jorge	Hernandez	3131098762	jorge.hernandez1@email.net
C109	Adriana	Iglesias	3210987651	adriana.iglesias1@example.org
C110	Alberto	Juarez	3009876540	alberto.juarez1@mail.com
C111	Monica	Leon	3108765439	monica.leon1@test.net
C112	Victor	Marin	3157654328	victor.marin1@example.com
C113	Cristina	Nuñez	3016543217	cristina.nunez1@email.org
C114	Raul	Ortiz	3205432106	raul.ortiz1@mail.com
C115	Beatriz	Peña	3184321095	beatriz.pena1@test.org
C116	Oscar	Quintana	3023210984	oscar.quintana1@example.net
C117	Silvia	Salazar	3162109873	silvia.salazar1@email.com
C118	Jose	Soto	3111098762	jose.soto1@example.org
C119	Rosa	Uribe	3220987651	rosa.uribe1@mail.net
C120	Manuel	Vega	3009876540	manuel.vega1@test.com
C121	Teresa	Perez	3178765439	teresa.perez@example.com
C122	Francisco	Gomez	3047654328	francisco.gomez1@email.net
C123	Gloria	Rodriguez	3136543217	gloria.rodriguez1@mail.org
C124	Antonio	Lopez	3215432106	antonio.lopez1@test.net
C125	Angela	Martinez	3004321095	angela.martinez1@example.com
C126	Diego	Sanchez	3103210984	diego.sanchez1@email.org
C127	Sandra	Fernandez	3152109873	sandra.fernandez1@mail.com
C128	Ana	Garcia	3011098762	ana.garcia2@test.org
C129	Luis	Gonzalez	3200987651	luis.gonzalez2@example.net
C130	Maria	Diaz	3189876540	maria.diaz2@email.com
C131	Carlos	Ruiz	3028765439	carlos.ruiz2@example.org
C132	Sofia	Alvarez	3167654328	sofia.alvarez2@mail.net
C133	Juan	Moreno	3116543217	juan.moreno2@test.com
C134	Laura	Jimenez	3225432106	laura.jimenez2@example.com
C135	Pedro	Vargas	3004321095	pedro.vargas2@email.net
C136	Carmen	Castro	3173210984	carmen.castro2@mail.org
C137	David	Silva	3042109873	david.silva2@test.net
C138	Isabel	Torres	3131098762	isabel.torres2@example.com
C139	Miguel	Rojas	3210987651	miguel.rojas2@email.org
C140	Patricia	Herrera	3009876540	patricia.herrera2@mail.com
C141	Javier	Medina	3108765439	javier.medina2@test.org
C142	Elena	Flores	3157654328	elena.flores2@example.net
C143	Andres	Morales	3016543217	andres.morales2@email.com
C144	Camila	Ortega	3205432106	camila.ortega2@example.org
C145	Santiago	Guzman	3184321095	santiago.guzman2@mail.net
C146	Valentina	Ramos	3023210984	valentina.ramos2@test.com
C147	Daniel	Cruz	3162109873	daniel.cruz2@example.com
C148	Gabriela	Romero	3111098762	gabriela.romero2@email.net
C149	Ricardo	Vasquez	3220987651	ricardo.vasquez2@mail.org
C150	Paula	Reyes	3009876540	paula.reyes2@test.net
C151	Alejandro	Acosta	3178765439	alejandro.acosta1@example.com
C152	Natalia	Benitez	3047654328	natalia.benitez1@mail.net
C153	Martin	Campos	3136543217	martin.campos1@test.org
C154	Lucia	Dominguez	3215432106	lucia.dominguez1@email.com
C155	Fernando	Esteban	3004321095	fernando.esteban1@example.net
C156	Veronica	Fuentes	3103210984	veronica.fuentes1@mail.org
C157	Sergio	Gil	3152109873	sergio.gil1@test.com
C158	Andrea	Hernandez	3011098762	andrea.hernandez1@email.net
C159	Jorge	Iglesias	3200987651	jorge.iglesias1@example.org
C160	Adriana	Juarez	3189876540	adriana.juarez1@mail.com
C161	Alberto	Leon	3028765439	alberto.leon1@test.net
C162	Monica	Marin	3167654328	monica.marin1@example.com
C163	Victor	Nuñez	3116543217	victor.nunez1@email.org
C164	Cristina	Ortiz	3225432106	cristina.ortiz1@mail.com
C165	Raul	Peña	3004321095	raul.pena1@test.org
C166	Beatriz	Quintana	3173210984	beatriz.quintana1@example.net
C167	Oscar	Salazar	3042109873	oscar.salazar1@email.com
C168	Silvia	Soto	3131098762	silvia.soto1@example.org
C169	Jose	Uribe	3210987651	jose.uribe1@mail.net
C170	Rosa	Vega	3009876540	rosa.vega1@test.com
C171	Manuel	Perez	3108765439	manuel.perez1@example.com
C172	Teresa	Gomez	3157654328	teresa.gomez1@email.net
C173	Francisco	Rodriguez	3016543217	francisco.rodriguez1@mail.org
C174	Gloria	Lopez	3205432106	gloria.lopez1@test.net
C175	Antonio	Martinez	3184321095	antonio.martinez1@example.com
C176	Angela	Sanchez	3023210984	angela.sanchez1@email.org
C177	Diego	Fernandez	3162109873	diego.fernandez1@mail.com
C178	Sandra	Garcia	3111098762	sandra.garcia1@test.org
C179	Ana	Gonzalez	3220987651	ana.gonzalez2@example.net
C180	Luis	Diaz	3009876540	luis.diaz2@email.com
C181	Maria	Ruiz	3178765439	maria.ruiz2@example.org
C182	Carlos	Alvarez	3047654328	carlos.alvarez2@mail.net
C183	Sofia	Moreno	3136543217	sofia.moreno2@test.com
C184	Juan	Jimenez	3215432106	juan.jimenez2@example.com
C185	Laura	Vargas	3004321095	laura.vargas2@email.net
C186	Pedro	Castro	3103210984	pedro.castro2@mail.org
C187	Carmen	Silva	3152109873	carmen.silva2@test.net
C188	David	Torres	3011098762	david.torres2@example.com
C189	Isabel	Rojas	3200987651	isabel.rojas2@email.org
C190	Miguel	Herrera	3189876540	miguel.herrera2@mail.com
C191	Patricia	Medina	3028765439	patricia.medina2@test.org
C192	Javier	Flores	3167654328	javier.flores2@example.net
C193	Elena	Morales	3116543217	elena.morales2@email.com
C194	Andres	Ortega	3225432106	andres.ortega2@example.org
C195	Camila	Guzman	3004321095	camila.guzman2@mail.net
C196	Santiago	Ramos	3173210984	santiago.ramos2@test.com
C197	Valentina	Cruz	3042109873	valentina.cruz2@example.com
C198	Daniel	Romero	3131098762	daniel.romero2@email.net
C199	Gabriela	Vasquez	3210987651	gabriela.vasquez2@mail.org
C200	Ricardo	Reyes	3009876540	ricardo.reyes2@test.net
C201	Paula	Acosta	3108765439	paula.acosta1@example.com
C202	Alejandro	Benitez	3157654328	alejandro.benitez1@mail.net
C203	Natalia	Campos	3016543217	natalia.campos1@test.org
C204	Martin	Dominguez	3205432106	martin.dominguez1@email.com
C205	Lucia	Esteban	3184321095	lucia.esteban1@example.net
C206	Fernando	Fuentes	3023210984	fernando.fuentes1@mail.org
C207	Veronica	Gil	3162109873	veronica.gil1@test.com
C208	Sergio	Hernandez	3111098762	sergio.hernandez1@email.net
C209	Andrea	Iglesias	3220987651	andrea.iglesias1@example.org
C210	Jorge	Juarez	3009876540	jorge.juarez1@mail.com
C211	Adriana	Leon	3178765439	adriana.leon1@test.net
C212	Alberto	Marin	3047654328	alberto.marin1@example.com
C213	Monica	Nuñez	3136543217	monica.nunez1@email.org
C214	Victor	Ortiz	3215432106	victor.ortiz1@mail.com
C215	Cristina	Peña	3004321095	cristina.pena1@test.org
C216	Raul	Quintana	3103210984	raul.quintana1@example.net
C217	Beatriz	Salazar	3152109873	beatriz.salazar1@email.com
C218	Oscar	Soto	3011098762	oscar.soto1@example.org
C219	Silvia	Uribe	3200987651	silvia.uribe1@mail.net
C220	Jose	Vega	3189876540	jose.vega1@test.com
C221	Rosa	Perez	3028765439	rosa.perez1@example.com
C222	Manuel	Gomez	3167654328	manuel.gomez1@email.net
C223	Teresa	Rodriguez	3116543217	teresa.rodriguez1@mail.org
C224	Francisco	Lopez	3225432106	francisco.lopez1@test.net
C225	Gloria	Martinez	3004321095	gloria.martinez1@example.com
C226	Antonio	Sanchez	3173210984	antonio.sanchez1@email.org
C227	Angela	Fernandez	3042109873	angela.fernandez1@mail.com
C228	Diego	Garcia	3131098762	diego.garcia1@test.org
C229	Sandra	Gonzalez	3210987651	sandra.gonzalez1@example.net
C230	Ana	Diaz	3009876540	ana.diaz2@email.com
C231	Luis	Ruiz	3108765439	luis.ruiz2@example.org
C232	Maria	Alvarez	3157654328	maria.alvarez2@mail.net
C233	Carlos	Moreno	3016543217	carlos.moreno2@test.com
C234	Sofia	Jimenez	3205432106	sofia.jimenez2@example.com
C235	Juan	Vargas	3184321095	juan.vargas2@email.net
C236	Laura	Castro	3023210984	laura.castro2@mail.org
C237	Pedro	Silva	3162109873	pedro.silva2@test.net
C238	Carmen	Torres	3111098762	carmen.torres2@example.com
C239	David	Rojas	3220987651	david.rojas2@email.org
C240	Isabel	Herrera	3009876540	isabel.herrera2@mail.com
C241	Miguel	Medina	3178765439	miguel.medina2@test.org
C242	Patricia	Flores	3047654328	patricia.flores2@example.net
C243	Javier	Morales	3136543217	javier.morales2@email.com
C244	Elena	Ortega	3215432106	elena.ortega2@example.org
C245	Andres	Guzman	3004321095	andres.guzman2@mail.net
C246	Camila	Ramos	3103210984	camila.ramos2@test.com
C247	Santiago	Cruz	3152109873	santiago.cruz2@example.com
C248	Valentina	Romero	3011098762	valentina.romero2@email.net
C249	Daniel	Vasquez	3200987651	daniel.vasquez2@mail.org
C250	Gabriela	Reyes	3189876540	gabriela.reyes2@test.net
C251	Ricardo	Acosta	3028765439	ricardo.acosta1@example.com
C252	Paula	Benitez	3167654328	paula.benitez1@mail.net
C253	Alejandro	Campos	3116543217	alejandro.campos1@test.org
C254	Natalia	Dominguez	3225432106	natalia.dominguez1@email.com
C255	Martin	Esteban	3004321095	martin.esteban1@example.net
C256	Lucia	Fuentes	3173210984	lucia.fuentes1@mail.org
C257	Fernando	Gil	3042109873	fernando.gil1@test.com
C258	Veronica	Hernandez	3131098762	veronica.hernandez1@email.net
C259	Sergio	Iglesias	3210987651	sergio.iglesias1@example.org
C260	Andrea	Juarez	3009876540	andrea.juarez1@mail.com
C261	Jorge	Leon	3108765439	jorge.leon1@test.net
C262	Adriana	Marin	3157654328	adriana.marin1@example.com
C263	Alberto	Nuñez	3016543217	alberto.nunez1@email.org
C264	Monica	Ortiz	3205432106	monica.ortiz1@mail.com
C265	Victor	Peña	3184321095	victor.pena1@test.org
C266	Cristina	Quintana	3023210984	cristina.quintana1@example.net
C267	Raul	Salazar	3162109873	raul.salazar1@email.com
C268	Beatriz	Soto	3111098762	beatriz.soto1@example.org
C269	Oscar	Uribe	3220987651	oscar.uribe1@mail.net
C270	Silvia	Vega	3009876540	silvia.vega1@test.com
C271	Jose	Perez	3178765439	jose.perez2@example.com
C272	Rosa	Gomez	3047654328	rosa.gomez1@email.net
C273	Manuel	Rodriguez	3136543217	manuel.rodriguez1@mail.org
C274	Teresa	Lopez	3215432106	teresa.lopez1@test.net
C275	Francisco	Martinez	3004321095	francisco.martinez1@example.com
C276	Gloria	Sanchez	3103210984	gloria.sanchez1@email.org
C277	Antonio	Fernandez	3152109873	antonio.fernandez1@mail.com
C278	Angela	Garcia	3011098762	angela.garcia1@test.org
C279	Diego	Gonzalez	3200987651	diego.gonzalez1@example.net
C280	Sandra	Diaz	3189876540	sandra.diaz1@email.com
C281	Ana	Ruiz	3028765439	ana.ruiz2@example.org
C282	Luis	Alvarez	3167654328	luis.alvarez2@mail.net
C283	Maria	Moreno	3116543217	maria.moreno2@test.com
C284	Carlos	Jimenez	3225432106	carlos.jimenez2@example.com
C285	Sofia	Vargas	3004321095	sofia.vargas2@email.net
C286	Juan	Castro	3173210984	juan.castro2@mail.org
C287	Laura	Silva	3042109873	laura.silva2@test.net
C288	Pedro	Torres	3131098762	pedro.torres2@example.com
C289	Carmen	Rojas	3210987651	carmen.rojas2@email.org
C290	David	Herrera	3009876540	david.herrera2@mail.com
C291	Isabel	Medina	3108765439	isabel.medina2@test.org
C292	Miguel	Flores	3157654328	miguel.flores2@example.net
C293	Patricia	Morales	3016543217	patricia.morales2@email.com
C294	Javier	Ortega	3205432106	javier.ortega2@example.org
C295	Elena	Guzman	3184321095	elena.guzman2@mail.net
C296	Andres	Ramos	3023210984	andres.ramos2@test.com
C297	Camila	Cruz	3162109873	camila.cruz2@example.com
C298	Santiago	Romero	3111098762	santiago.romero2@email.net
C299	Valentina	Vasquez	3220987651	valentina.vasquez2@mail.org
C300	Daniel	Reyes	3009876540	daniel.reyes2@test.net
C301	Gabriela	Acosta	3178765439	gabriela.acosta1@example.com
C302	Ricardo	Benitez	3047654328	ricardo.benitez1@mail.net
C303	Paula	Campos	3136543217	paula.campos1@test.org
C304	Alejandro	Dominguez	3215432106	alejandro.dominguez1@email.com
C305	Natalia	Esteban	3004321095	natalia.esteban1@example.net
C306	Martin	Fuentes	3103210984	martin.fuentes1@mail.org
C307	Lucia	Gil	3152109873	lucia.gil1@test.com
C308	Fernando	Hernandez	3011098762	fernando.hernandez1@email.net
C309	Veronica	Iglesias	3200987651	veronica.iglesias1@example.org
C310	Sergio	Juarez	3189876540	sergio.juarez1@mail.com
C311	Andrea	Leon	3028765439	andrea.leon1@test.net
C312	Jorge	Marin	3167654328	jorge.marin1@example.com
C313	Adriana	Nuñez	3116543217	adriana.nunez1@email.org
C314	Alberto	Ortiz	3225432106	alberto.ortiz1@mail.com
C315	Monica	Peña	3004321095	monica.pena1@test.org
C316	Victor	Quintana	3173210984	victor.quintana1@example.net
C317	Cristina	Salazar	3042109873	cristina.salazar1@email.com
C318	Raul	Soto	3131098762	raul.soto1@example.org
C319	Beatriz	Uribe	3210987651	beatriz.uribe1@mail.net
C320	Oscar	Vega	3009876540	oscar.vega1@test.com
C321	Silvia	Perez	3108765439	silvia.perez1@example.com
C322	Jose	Gomez	3157654328	jose.gomez2@email.net
C323	Rosa	Rodriguez	3016543217	rosa.rodriguez1@mail.org
C324	Manuel	Lopez	3205432106	manuel.lopez1@test.net
C325	Teresa	Martinez	3184321095	teresa.martinez1@example.com
C326	Francisco	Sanchez	3023210984	francisco.sanchez1@email.org
C327	Gloria	Fernandez	3162109873	gloria.fernandez1@mail.com
C328	Antonio	Garcia	3111098762	antonio.garcia1@test.org
C329	Angela	Gonzalez	3220987651	angela.gonzalez1@example.net
C330	Diego	Diaz	3009876540	diego.diaz1@email.com
C331	Sandra	Ruiz	3178765439	sandra.ruiz1@example.org
C332	Ana	Alvarez	3047654328	ana.alvarez2@mail.net
C333	Luis	Moreno	3136543217	luis.moreno2@test.com
C334	Maria	Jimenez	3215432106	maria.jimenez2@example.com
C335	Carlos	Vargas	3004321095	carlos.vargas2@email.net
C336	Sofia	Castro	3103210984	sofia.castro2@mail.org
C337	Juan	Silva	3152109873	juan.silva2@test.net
C338	Laura	Torres	3011098762	laura.torres2@example.com
C339	Pedro	Rojas	3200987651	pedro.rojas2@email.org
C340	Carmen	Herrera	3189876540	carmen.herrera2@mail.com
C341	David	Medina	3028765439	david.medina2@test.org
C342	Isabel	Flores	3167654328	isabel.flores2@example.net
C343	Miguel	Morales	3116543217	miguel.morales2@email.com
C344	Patricia	Ortega	3225432106	patricia.ortega2@example.org
C345	Javier	Guzman	3004321095	javier.guzman2@mail.net
C346	Elena	Ramos	3173210984	elena.ramos2@test.com
C347	Andres	Cruz	3042109873	andres.cruz2@example.com
C348	Camila	Romero	3131098762	camila.romero2@email.net
C349	Santiago	Vasquez	3210987651	santiago.vasquez2@mail.org
C350	Valentina	Reyes	3009876540	valentina.reyes2@test.net
C351	Daniel	Acosta	3108765439	daniel.acosta1@example.com
C352	Gabriela	Benitez	3157654328	gabriela.benitez1@mail.net
C353	Ricardo	Campos	3016543217	ricardo.campos1@test.org
C354	Paula	Dominguez	3205432106	paula.dominguez1@email.com
C355	Alejandro	Esteban	3184321095	alejandro.esteban1@example.net
C356	Natalia	Fuentes	3023210984	natalia.fuentes1@mail.org
C357	Martin	Gil	3162109873	martin.gil1@test.com
C358	Lucia	Hernandez	3111098762	lucia.hernandez1@email.net
C359	Fernando	Iglesias	3220987651	fernando.iglesias1@example.org
C360	Veronica	Juarez	3009876540	veronica.juarez1@mail.com
C361	Sergio	Leon	3178765439	sergio.leon1@test.net
C362	Andrea	Marin	3047654328	andrea.marin1@example.com
C363	Jorge	Nuñez	3136543217	jorge.nunez1@email.org
C364	Adriana	Ortiz	3215432106	adriana.ortiz1@mail.com
C365	Alberto	Peña	3004321095	alberto.pena1@test.org
C366	Monica	Quintana	3103210984	monica.quintana1@example.net
C367	Victor	Salazar	3152109873	victor.salazar1@email.com
C368	Cristina	Soto	3011098762	cristina.soto1@example.org
C369	Raul	Uribe	3200987651	raul.uribe1@mail.net
C370	Beatriz	Vega	3189876540	beatriz.vega1@test.com
C371	Oscar	Perez	3028765439	oscar.perez1@example.com
C372	Silvia	Gomez	3167654328	silvia.gomez1@email.net
C373	Jose	Rodriguez	3116543217	jose.rodriguez2@mail.org
C374	Rosa	Lopez	3225432106	rosa.lopez1@test.net
C375	Manuel	Martinez	3004321095	manuel.martinez1@example.com
C376	Teresa	Sanchez	3173210984	teresa.sanchez1@email.org
C377	Francisco	Fernandez	3042109873	francisco.fernandez1@mail.com
C378	Gloria	Garcia	3131098762	gloria.garcia1@test.org
C379	Antonio	Gonzalez	3210987651	antonio.gonzalez1@example.net
C380	Angela	Diaz	3009876540	angela.diaz1@email.com
C381	Diego	Ruiz	3108765439	diego.ruiz1@example.org
C382	Sandra	Alvarez	3157654328	sandra.alvarez1@mail.net
C383	Ana	Moreno	3016543217	ana.moreno2@test.com
C384	Luis	Jimenez	3205432106	luis.jimenez2@example.com
C385	Maria	Vargas	3184321095	maria.vargas2@email.net
C386	Carlos	Castro	3023210984	carlos.castro2@mail.org
C387	Sofia	Silva	3162109873	sofia.silva2@test.net
C388	Juan	Torres	3111098762	juan.torres2@example.com
C389	Laura	Rojas	3220987651	laura.rojas2@email.org
C390	Pedro	Herrera	3009876540	pedro.herrera2@mail.com
C391	Carmen	Medina	3178765439	carmen.medina2@test.org
C392	David	Flores	3047654328	david.flores2@example.net
C393	Isabel	Morales	3136543217	isabel.morales2@email.com
C394	Miguel	Ortega	3215432106	miguel.ortega2@example.org
C395	Patricia	Guzman	3004321095	patricia.guzman2@mail.net
C396	Javier	Ramos	3103210984	javier.ramos2@test.com
C397	Elena	Cruz	3152109873	elena.cruz2@example.com
C398	Andres	Romero	3011098762	andres.romero2@email.net
C399	Camila	Vasquez	3200987651	camila.vasquez2@mail.org
C400	Santiago	Reyes	3189876540	santiago.reyes2@test.net
C401	Valentina	Acosta	3028765439	valentina.acosta1@example.com
C402	Daniel	Benitez	3167654328	daniel.benitez1@mail.net
C403	Gabriela	Campos	3116543217	gabriela.campos1@test.org
C404	Ricardo	Dominguez	3225432106	ricardo.dominguez1@email.com
C405	Paula	Esteban	3004321095	paula.esteban1@example.net
C406	Alejandro	Fuentes	3173210984	alejandro.fuentes1@mail.org
C407	Natalia	Gil	3042109873	natalia.gil1@test.com
C408	Martin	Hernandez	3131098762	martin.hernandez1@email.net
C409	Lucia	Iglesias	3210987651	lucia.iglesias1@example.org
C410	Fernando	Juarez	3009876540	fernando.juarez1@mail.com
C411	Veronica	Leon	3108765439	veronica.leon1@test.net
C412	Sergio	Marin	3157654328	sergio.marin1@example.com
C413	Andrea	Nuñez	3016543217	andrea.nunez1@email.org
C414	Jorge	Ortiz	3205432106	jorge.ortiz1@mail.com
C415	Adriana	Peña	3184321095	adriana.pena1@test.org
C416	Alberto	Quintana	3023210984	alberto.quintana1@example.net
C417	Monica	Salazar	3162109873	monica.salazar1@email.com
C418	Victor	Soto	3111098762	victor.soto1@example.org
C419	Cristina	Uribe	3220987651	cristina.uribe1@mail.net
C420	Raul	Vega	3009876540	raul.vega1@test.com
C421	Beatriz	Perez	3178765439	beatriz.perez1@example.com
C422	Oscar	Gomez	3047654328	oscar.gomez1@email.net
C423	Silvia	Rodriguez	3136543217	silvia.rodriguez1@mail.org
C424	Jose	Lopez	3215432106	jose.lopez2@test.net
C425	Rosa	Martinez	3004321095	rosa.martinez1@example.com
C426	Manuel	Sanchez	3103210984	manuel.sanchez1@email.org
C427	Teresa	Fernandez	3152109873	teresa.fernandez1@mail.com
C428	Francisco	Garcia	3011098762	francisco.garcia1@test.org
C429	Gloria	Gonzalez	3200987651	gloria.gonzalez1@example.net
C430	Antonio	Diaz	3189876540	antonio.diaz1@email.com
C431	Angela	Ruiz	3028765439	angela.ruiz1@example.org
C432	Diego	Alvarez	3167654328	diego.alvarez1@mail.net
C433	Sandra	Moreno	3116543217	sandra.moreno1@test.com
C434	Ana	Jimenez	3225432106	ana.jimenez2@example.com
C435	Luis	Vargas	3004321095	luis.vargas2@email.net
C436	Maria	Castro	3173210984	maria.castro2@mail.org
C437	Carlos	Silva	3042109873	carlos.silva2@test.net
C438	Sofia	Torres	3131098762	sofia.torres2@example.com
C439	Juan	Rojas	3210987651	juan.rojas2@email.org
C440	Laura	Herrera	3009876540	laura.herrera2@mail.com
C441	Pedro	Medina	3108765439	pedro.medina2@test.org
C442	Carmen	Flores	3157654328	carmen.flores2@example.net
C443	David	Morales	3016543217	david.morales2@email.com
C444	Isabel	Ortega	3205432106	isabel.ortega2@example.org
C445	Miguel	Guzman	3184321095	miguel.guzman2@mail.net
C446	Patricia	Ramos	3023210984	patricia.ramos2@test.com
C447	Javier	Cruz	3162109873	javier.cruz2@example.com
C448	Elena	Romero	3111098762	elena.romero2@email.net
C449	Andres	Vasquez	3220987651	andres.vasquez2@mail.org
C450	Camila	Reyes	3009876540	camila.reyes2@test.net
C451	Santiago	Acosta	3178765439	santiago.acosta1@example.com
C452	Valentina	Benitez	3047654328	valentina.benitez1@mail.net
C453	Daniel	Campos	3136543217	daniel.campos1@test.org
C454	Gabriela	Dominguez	3215432106	gabriela.dominguez1@email.com
C455	Ricardo	Esteban	3004321095	ricardo.esteban1@example.net
C456	Paula	Fuentes	3103210984	paula.fuentes1@mail.org
C457	Alejandro	Gil	3152109873	alejandro.gil1@test.com
C458	Natalia	Hernandez	3011098762	natalia.hernandez1@email.net
C459	Martin	Iglesias	3200987651	martin.iglesias1@example.org
C460	Lucia	Juarez	3189876540	lucia.juarez1@mail.com
C461	Fernando	Leon	3028765439	fernando.leon1@test.net
C462	Veronica	Marin	3167654328	veronica.marin1@example.com
C463	Sergio	Nuñez	3116543217	sergio.nunez1@email.org
C464	Andrea	Ortiz	3225432106	andrea.ortiz1@mail.com
C465	Jorge	Peña	3004321095	jorge.pena1@test.org
C466	Adriana	Quintana	3173210984	adriana.quintana1@example.net
C467	Alberto	Salazar	3042109873	alberto.salazar1@email.com
C468	Monica	Soto	3131098762	monica.soto1@example.org
C469	Victor	Uribe	3210987651	victor.uribe1@mail.net
C470	Cristina	Vega	3009876540	cristina.vega1@test.com
C471	Raul	Perez	3108765439	raul.perez2@example.com
C472	Beatriz	Gomez	3157654328	beatriz.gomez1@email.net
C473	Oscar	Rodriguez	3016543217	oscar.rodriguez1@mail.org
C474	Silvia	Lopez	3205432106	silvia.lopez1@test.net
C475	Jose	Martinez	3184321095	jose.martinez2@example.com
C476	Rosa	Sanchez	3023210984	rosa.sanchez1@email.org
C477	Manuel	Fernandez	3162109873	manuel.fernandez1@mail.com
C478	Teresa	Garcia	3111098762	teresa.garcia1@test.org
C479	Francisco	Gonzalez	3220987651	francisco.gonzalez1@example.net
C480	Gloria	Diaz	3009876540	gloria.diaz1@email.com
C481	Antonio	Ruiz	3178765439	antonio.ruiz1@example.org
C482	Angela	Alvarez	3047654328	angela.alvarez1@mail.net
C483	Diego	Moreno	3136543217	diego.moreno1@test.com
C484	Sandra	Jimenez	3215432106	sandra.jimenez1@example.com
C485	Ana	Vargas	3004321095	ana.vargas2@email.net
C486	Luis	Castro	3103210984	luis.castro2@mail.org
C487	Maria	Silva	3152109873	maria.silva2@test.net
C488	Carlos	Torres	3011098762	carlos.torres2@example.com
C489	Sofia	Rojas	3200987651	sofia.rojas2@email.org
C490	Juan	Herrera	3189876540	juan.herrera2@mail.com
C491	Laura	Medina	3028765439	laura.medina2@test.org
C492	Pedro	Flores	3167654328	pedro.flores2@example.net
C493	Carmen	Morales	3116543217	carmen.morales2@email.com
C494	David	Ortega	3225432106	david.ortega2@example.org
C495	Isabel	Guzman	3004321095	isabel.guzman2@mail.net
C496	Miguel	Ramos	3173210984	miguel.ramos2@test.com
C497	Patricia	Cruz	3042109873	patricia.cruz2@example.com
C498	Javier	Romero	3131098762	javier.romero2@email.net
C499	Elena	Vasquez	3210987651	elena.vasquez2@mail.org
C500	Andres	Reyes	3009876540	andres.reyes2@test.net
C501	Camila	Acosta	3108765439	camila.acosta1@example.com
C502	Santiago	Benitez	3157654328	santiago.benitez1@mail.net
C503	Valentina	Campos	3016543217	valentina.campos1@test.org
C504	Daniel	Dominguez	3205432106	daniel.dominguez1@email.com
C505	Gabriela	Esteban	3184321095	gabriela.esteban1@example.net
C506	Ricardo	Fuentes	3023210984	ricardo.fuentes1@mail.org
C507	Paula	Gil	3162109873	paula.gil1@test.com
C508	Alejandro	Hernandez	3111098762	alejandro.hernandez1@email.net
C509	Natalia	Iglesias	3220987651	natalia.iglesias1@example.org
C510	Martin	Juarez	3009876540	martin.juarez2@mail.com
C511	Lucia	Leon	3178765439	lucia.leon1@test.net
C512	Fernando	Marin	3047654328	fernando.marin1@example.com
C513	Veronica	Nuñez	3136543217	veronica.nunez1@email.org
C514	Sergio	Ortiz	3215432106	sergio.ortiz1@mail.com
C515	Andrea	Peña	3004321095	andrea.pena1@test.org
C516	Jorge	Quintana	3103210984	jorge.quintana1@example.net
C517	Adriana	Salazar	3152109873	adriana.salazar1@email.com
C518	Alberto	Soto	3011098762	alberto.soto1@example.org
C519	Monica	Uribe	3200987651	monica.uribe1@mail.net
C520	Victor	Vega	3189876540	victor.vega1@test.com
C521	Cristina	Perez	3028765439	cristina.perez1@example.com
C522	Raul	Gomez	3167654328	raul.gomez1@email.net
C523	Beatriz	Rodriguez	3116543217	beatriz.rodriguez1@mail.org
C524	Oscar	Lopez	3225432106	oscar.lopez1@test.net
C525	Silvia	Martinez	3004321095	silvia.martinez1@example.com
C526	Jose	Sanchez	3173210984	jose.sanchez2@email.org
C527	Rosa	Fernandez	3042109873	rosa.fernandez1@mail.com
C528	Manuel	Garcia	3131098762	manuel.garcia1@test.org
C529	Teresa	Gonzalez	3210987651	teresa.gonzalez1@example.net
C530	Francisco	Diaz	3009876540	francisco.diaz1@email.com
C531	Gloria	Ruiz	3108765439	gloria.ruiz1@example.org
C532	Antonio	Alvarez	3157654328	antonio.alvarez1@mail.net
C533	Angela	Moreno	3016543217	angela.moreno1@test.com
C534	Diego	Jimenez	3205432106	diego.jimenez1@example.com
C535	Sandra	Vargas	3184321095	sandra.vargas1@email.net
C536	Ana	Castro	3023210984	ana.castro2@mail.org
C537	Luis	Silva	3162109873	luis.silva2@test.net
C538	Maria	Torres	3111098762	maria.torres2@example.com
C539	Carlos	Rojas	3220987651	carlos.rojas2@email.org
C540	Sofia	Herrera	3009876540	sofia.herrera2@mail.com
C541	Juan	Medina	3178765439	juan.medina2@test.org
C542	Laura	Flores	3047654328	laura.flores2@example.net
C543	Pedro	Morales	3136543217	pedro.morales2@email.com
C544	Carmen	Ortega	3215432106	carmen.ortega2@example.org
C545	David	Guzman	3004321095	david.guzman2@mail.net
C546	Isabel	Ramos	3103210984	isabel.ramos2@test.com
C547	Miguel	Cruz	3152109873	miguel.cruz2@example.com
C548	Patricia	Romero	3011098762	patricia.romero2@email.net
C549	Javier	Vasquez	3200987651	javier.vasquez2@mail.org
C550	Elena	Reyes	3189876540	elena.reyes2@test.net
C551	Andres	Acosta	3028765439	andres.acosta1@example.com
C552	Camila	Benitez	3167654328	camila.benitez1@mail.net
C553	Santiago	Campos	3116543217	santiago.campos1@test.org
C554	Valentina	Dominguez	3225432106	valentina.dominguez1@email.com
C555	Daniel	Esteban	3004321095	daniel.esteban1@example.net
C556	Gabriela	Fuentes	3173210984	gabriela.fuentes1@mail.org
C557	Ricardo	Gil	3042109873	ricardo.gil1@test.com
C558	Paula	Hernandez	3131098762	paula.hernandez1@email.net
C559	Alejandro	Iglesias	3210987651	alejandro.iglesias1@example.org
C560	Natalia	Juarez	3009876540	natalia.juarez1@mail.com
C561	Martin	Leon	3108765439	martin.leon2@test.net
C562	Lucia	Marin	3157654328	lucia.marin1@example.com
C563	Fernando	Nuñez	3016543217	fernando.nunez1@email.org
C564	Veronica	Ortiz	3205432106	veronica.ortiz1@mail.com
C565	Sergio	Peña	3184321095	sergio.pena1@test.org
C566	Andrea	Quintana	3023210984	andrea.quintana1@example.net
C567	Jorge	Salazar	3162109873	jorge.salazar1@email.com
C568	Adriana	Soto	3111098762	adriana.soto1@example.org
C569	Alberto	Uribe	3220987651	alberto.uribe1@mail.net
C570	Monica	Vega	3009876540	monica.vega1@test.com
C571	Victor	Perez	3178765439	victor.perez1@example.com
C572	Cristina	Gomez	3047654328	cristina.gomez1@email.net
C573	Raul	Rodriguez	3136543217	raul.rodriguez1@mail.org
C574	Beatriz	Lopez	3215432106	beatriz.lopez1@test.net
C575	Oscar	Martinez	3004321095	oscar.martinez1@example.com
C576	Silvia	Sanchez	3103210984	silvia.sanchez1@email.org
C577	Jose	Fernandez	3152109873	jose.fernandez2@mail.com
C578	Rosa	Garcia	3011098762	rosa.garcia1@test.org
C579	Manuel	Gonzalez	3200987651	manuel.gonzalez1@example.net
C580	Teresa	Diaz	3189876540	teresa.diaz1@email.com
C581	Francisco	Ruiz	3028765439	francisco.ruiz1@example.org
C582	Gloria	Alvarez	3167654328	gloria.alvarez1@mail.net
C583	Antonio	Moreno	3116543217	antonio.moreno1@test.com
C584	Angela	Jimenez	3225432106	angela.jimenez1@example.com
C585	Diego	Vargas	3004321095	diego.vargas1@email.net
C586	Sandra	Castro	3173210984	sandra.castro1@mail.org
C587	Ana	Silva	3042109873	ana.silva2@test.net
C588	Luis	Torres	3131098762	luis.torres2@example.com
C589	Maria	Rojas	3210987651	maria.rojas2@email.org
C590	Carlos	Herrera	3009876540	carlos.herrera2@mail.com
C591	Sofia	Medina	3108765439	sofia.medina2@test.org
C592	Juan	Flores	3157654328	juan.flores2@example.net
C593	Laura	Morales	3016543217	laura.morales2@email.com
C594	Pedro	Ortega	3205432106	pedro.ortega2@example.org
C595	Carmen	Guzman	3184321095	carmen.guzman2@mail.net
C596	David	Ramos	3023210984	david.ramos2@test.com
C597	Isabel	Cruz	3162109873	isabel.cruz2@example.com
C598	Miguel	Romero	3111098762	miguel.romero2@email.net
C599	Patricia	Vasquez	3220987651	patricia.vasquez2@mail.org
C600	Javier	Reyes	3009876540	javier.reyes2@test.net
C601	Elena	Acosta	3178765439	elena.acosta1@example.com
C602	Andres	Benitez	3047654328	andres.benitez1@mail.net
C603	Camila	Campos	3136543217	camila.campos1@test.org
C604	Santiago	Dominguez	3215432106	santiago.dominguez1@email.com
C605	Valentina	Esteban	3004321095	valentina.esteban1@example.net
C606	Daniel	Fuentes	3103210984	daniel.fuentes1@mail.org
C607	Gabriela	Gil	3152109873	gabriela.gil1@test.com
C608	Ricardo	Hernandez	3011098762	ricardo.hernandez1@email.net
C609	Paula	Iglesias	3200987651	paula.iglesias1@example.org
C610	Alejandro	Juarez	3189876540	alejandro.juarez1@mail.com
C611	Natalia	Leon	3028765439	natalia.leon1@test.net
C612	Martin	Marin	3167654328	martin.marin2@example.com
C613	Lucia	Nuñez	3116543217	lucia.nunez1@email.org
C614	Fernando	Ortiz	3225432106	fernando.ortiz1@mail.com
C615	Veronica	Peña	3004321095	veronica.pena1@test.org
C616	Sergio	Quintana	3173210984	sergio.quintana1@example.net
C617	Andrea	Salazar	3042109873	andrea.salazar1@email.com
C618	Jorge	Soto	3131098762	jorge.soto1@example.org
C619	Adriana	Uribe	3210987651	adriana.uribe1@mail.net
C620	Alberto	Vega	3009876540	alberto.vega1@test.com
C621	Monica	Perez	3108765439	monica.perez1@example.com
C622	Victor	Gomez	3157654328	victor.gomez1@email.net
C623	Cristina	Rodriguez	3016543217	cristina.rodriguez1@mail.org
C624	Raul	Lopez	3205432106	raul.lopez1@test.net
C625	Beatriz	Martinez	3184321095	beatriz.martinez1@example.com
C626	Oscar	Sanchez	3023210984	oscar.sanchez1@email.org
C627	Silvia	Fernandez	3162109873	silvia.fernandez1@mail.com
C628	Jose	Garcia	3111098762	jose.garcia2@test.org
C629	Rosa	Gonzalez	3220987651	rosa.gonzalez1@example.net
C630	Manuel	Diaz	3009876540	manuel.diaz1@email.com
C631	Teresa	Ruiz	3178765439	teresa.ruiz1@example.org
C632	Francisco	Alvarez	3047654328	francisco.alvarez1@mail.net
C633	Gloria	Moreno	3136543217	gloria.moreno1@test.com
C634	Antonio	Jimenez	3215432106	antonio.jimenez1@example.com
C635	Angela	Vargas	3004321095	angela.vargas1@email.net
C636	Diego	Castro	3103210984	diego.castro1@mail.org
C637	Sandra	Silva	3152109873	sandra.silva1@test.net
C638	Ana	Torres	3011098762	ana.torres2@example.com
C639	Luis	Rojas	3200987651	luis.rojas2@email.org
C640	Maria	Herrera	3189876540	maria.herrera2@mail.com
C641	Carlos	Medina	3028765439	carlos.medina2@test.org
C642	Sofia	Flores	3167654328	sofia.flores2@example.net
C643	Juan	Morales	3116543217	juan.morales2@email.com
C644	Laura	Ortega	3225432106	laura.ortega2@example.org
C645	Pedro	Guzman	3004321095	pedro.guzman2@mail.net
C646	Carmen	Ramos	3173210984	carmen.ramos2@test.com
C647	David	Cruz	3042109873	david.cruz2@example.com
C648	Isabel	Romero	3131098762	isabel.romero2@email.net
C649	Miguel	Vasquez	3210987651	miguel.vasquez2@mail.org
C650	Patricia	Reyes	3009876540	patricia.reyes2@test.net
C651	Javier	Acosta	3108765439	javier.acosta1@example.com
C652	Elena	Benitez	3157654328	elena.benitez1@mail.net
C653	Andres	Campos	3016543217	andres.campos1@test.org
C654	Camila	Dominguez	3205432106	camila.dominguez1@email.com
C655	Santiago	Esteban	3184321095	santiago.esteban1@example.net
C656	Valentina	Fuentes	3023210984	valentina.fuentes1@mail.org
C657	Daniel	Gil	3162109873	daniel.gil1@test.com
C658	Gabriela	Hernandez	3111098762	gabriela.hernandez1@email.net
C659	Ricardo	Iglesias	3220987651	ricardo.iglesias1@example.org
C660	Paula	Juarez	3009876540	paula.juarez1@mail.com
C661	Alejandro	Leon	3178765439	alejandro.leon1@test.net
C662	Natalia	Marin	3047654328	natalia.marin1@example.com
C663	Martin	Nuñez	3136543217	martin.nunez2@email.org
C664	Lucia	Ortiz	3215432106	lucia.ortiz1@mail.com
C665	Fernando	Peña	3004321095	fernando.pena1@test.org
C666	Veronica	Quintana	3103210984	veronica.quintana1@example.net
C667	Sergio	Salazar	3152109873	sergio.salazar1@email.com
C668	Andrea	Soto	3011098762	andrea.soto1@example.org
C669	Jorge	Uribe	3200987651	jorge.uribe1@mail.net
C670	Adriana	Vega	3189876540	adriana.vega1@test.com
C671	Alberto	Perez	3028765439	alberto.perez1@example.com
C672	Monica	Gomez	3167654328	monica.gomez1@email.net
C673	Victor	Rodriguez	3116543217	victor.rodriguez1@mail.org
C674	Cristina	Lopez	3225432106	cristina.lopez1@test.net
C675	Raul	Martinez	3004321095	raul.martinez1@example.com
C676	Beatriz	Sanchez	3173210984	beatriz.sanchez1@email.org
C677	Oscar	Fernandez	3042109873	oscar.fernandez1@mail.com
C678	Silvia	Garcia	3131098762	silvia.garcia1@test.org
C679	Jose	Gonzalez	3210987651	jose.gonzalez2@example.net
C680	Rosa	Diaz	3009876540	rosa.diaz1@email.com
C681	Manuel	Ruiz	3108765439	manuel.ruiz1@example.org
C682	Teresa	Alvarez	3157654328	teresa.alvarez1@mail.net
C683	Francisco	Moreno	3016543217	francisco.moreno1@test.com
C684	Gloria	Jimenez	3205432106	gloria.jimenez1@example.com
C685	Antonio	Vargas	3184321095	antonio.vargas1@email.net
C686	Angela	Castro	3023210984	angela.castro1@mail.org
C687	Diego	Silva	3162109873	diego.silva1@test.net
C688	Sandra	Torres	3111098762	sandra.torres1@example.com
C689	Ana	Rojas	3220987651	ana.rojas2@email.org
C690	Luis	Herrera	3009876540	luis.herrera2@mail.com
C691	Maria	Medina	3178765439	maria.medina2@test.org
C692	Carlos	Flores	3047654328	carlos.flores2@example.net
C693	Sofia	Morales	3136543217	sofia.morales2@email.com
C694	Juan	Ortega	3215432106	juan.ortega2@example.org
C695	Laura	Guzman	3004321095	laura.guzman2@mail.net
C696	Pedro	Ramos	3103210984	pedro.ramos2@test.com
C697	Carmen	Cruz	3152109873	carmen.cruz2@example.com
C698	David	Romero	3011098762	david.romero2@email.net
C699	Isabel	Vasquez	3200987651	isabel.vasquez2@mail.org
C700	Miguel	Reyes	3189876540	miguel.reyes2@test.net
C701	Patricia	Acosta	3028765439	patricia.acosta1@example.com
C702	Javier	Benitez	3167654328	javier.benitez1@mail.net
C703	Elena	Campos	3116543217	elena.campos1@test.org
C704	Andres	Dominguez	3225432106	andres.dominguez1@email.com
C705	Camila	Esteban	3004321095	camila.esteban1@example.net
C706	Santiago	Fuentes	3173210984	santiago.fuentes1@mail.org
C707	Valentina	Gil	3042109873	valentina.gil1@test.com
C708	Daniel	Hernandez	3131098762	daniel.hernandez1@email.net
C709	Gabriela	Iglesias	3210987651	gabriela.iglesias1@example.org
C710	Ricardo	Juarez	3009876540	ricardo.juarez1@mail.com
C711	Paula	Leon	3108765439	paula.leon1@test.net
C712	Alejandro	Marin	3157654328	alejandro.marin1@example.com
C713	Natalia	Nuñez	3016543217	natalia.nunez1@email.org
C714	Martin	Ortiz	3205432106	martin.ortiz2@mail.com
C715	Lucia	Peña	3184321095	lucia.pena1@test.org
C716	Fernando	Quintana	3023210984	fernando.quintana1@example.net
C717	Veronica	Salazar	3162109873	veronica.salazar1@email.com
C718	Sergio	Soto	3111098762	sergio.soto1@example.org
C719	Andrea	Uribe	3220987651	andrea.uribe1@mail.net
C720	Jorge	Vega	3009876540	jorge.vega1@test.com
C721	Adriana	Perez	3178765439	adriana.perez1@example.com
C722	Alberto	Gomez	3047654328	alberto.gomez1@email.net
C723	Monica	Rodriguez	3136543217	monica.rodriguez1@mail.org
C724	Victor	Lopez	3215432106	victor.lopez1@test.net
C725	Cristina	Martinez	3004321095	cristina.martinez1@example.com
C726	Raul	Sanchez	3103210984	raul.sanchez1@email.org
C727	Beatriz	Fernandez	3152109873	beatriz.fernandez1@mail.com
C728	Oscar	Garcia	3011098762	oscar.garcia1@test.org
C729	Silvia	Gonzalez	3200987651	silvia.gonzalez1@example.net
C730	Jose	Diaz	3189876540	jose.diaz2@email.com
C731	Rosa	Ruiz	3028765439	rosa.ruiz1@example.org
C732	Manuel	Alvarez	3167654328	manuel.alvarez1@mail.net
C733	Teresa	Moreno	3116543217	teresa.moreno1@test.com
C734	Francisco	Jimenez	3225432106	francisco.jimenez1@example.com
C735	Gloria	Vargas	3004321095	gloria.vargas1@email.net
C736	Antonio	Castro	3173210984	antonio.castro1@mail.org
C737	Angela	Silva	3042109873	angela.silva1@test.net
C738	Diego	Torres	3131098762	diego.torres1@example.com
C739	Sandra	Rojas	3210987651	sandra.rojas1@email.org
C740	Ana	Herrera	3009876540	ana.herrera2@mail.com
C741	Luis	Medina	3108765439	luis.medina2@test.org
C742	Maria	Flores	3157654328	maria.flores2@example.net
C743	Carlos	Morales	3016543217	carlos.morales2@email.com
C744	Sofia	Ortega	3205432106	sofia.ortega2@example.org
C745	Juan	Guzman	3184321095	juan.guzman2@mail.net
C746	Laura	Ramos	3023210984	laura.ramos2@test.com
C747	Pedro	Cruz	3162109873	pedro.cruz2@example.com
C748	Carmen	Romero	3111098762	carmen.romero2@email.net
C749	David	Vasquez	3220987651	david.vasquez2@mail.org
C750	Isabel	Reyes	3009876540	isabel.reyes2@test.net
C751	Miguel	Acosta	3178765439	miguel.acosta1@example.com
C752	Patricia	Benitez	3047654328	patricia.benitez1@mail.net
C753	Javier	Campos	3136543217	javier.campos1@test.org
C754	Elena	Dominguez	3215432106	elena.dominguez1@email.com
C755	Andres	Esteban	3004321095	andres.esteban1@example.net
C756	Camila	Fuentes	3103210984	camila.fuentes1@mail.org
C757	Santiago	Gil	3152109873	santiago.gil1@test.com
C758	Valentina	Hernandez	3011098762	valentina.hernandez1@email.net
C759	Daniel	Iglesias	3200987651	daniel.iglesias1@example.org
C760	Gabriela	Juarez	3189876540	gabriela.juarez1@mail.com
C761	Ricardo	Leon	3028765439	ricardo.leon1@test.net
C762	Paula	Marin	3167654328	paula.marin1@example.com
C763	Alejandro	Nuñez	3116543217	alejandro.nunez1@email.org
C764	Natalia	Ortiz	3225432106	natalia.ortiz1@mail.com
C765	Martin	Peña	3004321095	martin.pena2@test.org
C766	Lucia	Quintana	3173210984	lucia.quintana1@example.net
C767	Fernando	Salazar	3042109873	fernando.salazar1@email.com
C768	Veronica	Soto	3131098762	veronica.soto1@example.org
C769	Sergio	Uribe	3210987651	sergio.uribe1@mail.net
C770	Andrea	Vega	3009876540	andrea.vega1@test.com
C771	Jorge	Perez	3108765439	jorge.perez1@example.com
C772	Adriana	Gomez	3157654328	adriana.gomez1@email.net
C773	Alberto	Rodriguez	3016543217	alberto.rodriguez1@mail.org
C774	Monica	Lopez	3205432106	monica.lopez1@test.net
C775	Victor	Martinez	3184321095	victor.martinez1@example.com
C776	Cristina	Sanchez	3023210984	cristina.sanchez1@email.org
C777	Raul	Fernandez	3162109873	raul.fernandez1@mail.com
C778	Beatriz	Garcia	3111098762	beatriz.garcia1@test.org
C779	Oscar	Gonzalez	3220987651	oscar.gonzalez1@example.net
C780	Silvia	Diaz	3009876540	silvia.diaz1@email.com
C781	Jose	Ruiz	3178765439	jose.ruiz2@example.org
C782	Rosa	Alvarez	3047654328	rosa.alvarez1@mail.net
C783	Manuel	Moreno	3136543217	manuel.moreno1@test.com
C784	Teresa	Jimenez	3215432106	teresa.jimenez1@example.com
C785	Francisco	Vargas	3004321095	francisco.vargas1@email.net
C786	Gloria	Castro	3103210984	gloria.castro1@mail.org
C787	Antonio	Silva	3152109873	antonio.silva1@test.net
C788	Angela	Torres	3011098762	angela.torres1@example.com
C789	Diego	Rojas	3200987651	diego.rojas1@email.org
C790	Sandra	Herrera	3189876540	sandra.herrera1@mail.com
C791	Ana	Medina	3028765439	ana.medina2@test.org
C792	Luis	Flores	3167654328	luis.flores2@example.net
C793	Maria	Morales	3116543217	maria.morales2@email.com
C794	Carlos	Ortega	3225432106	carlos.ortega2@example.org
C795	Sofia	Guzman	3004321095	sofia.guzman2@mail.net
C796	Juan	Ramos	3173210984	juan.ramos2@test.com
C797	Laura	Cruz	3042109873	laura.cruz2@example.com
C798	Pedro	Romero	3131098762	pedro.romero2@email.net
C799	Carmen	Vasquez	3210987651	carmen.vasquez2@mail.org
C800	David	Reyes	3009876540	david.reyes2@test.net
C801	Isabel	Acosta	3108765439	isabel.acosta1@example.com
C802	Miguel	Benitez	3157654328	miguel.benitez1@mail.net
C803	Patricia	Campos	3016543217	patricia.campos1@test.org
C804	Javier	Dominguez	3205432106	javier.dominguez1@email.com
C805	Elena	Esteban	3184321095	elena.esteban1@example.net
C806	Andres	Fuentes	3023210984	andres.fuentes1@mail.org
C807	Camila	Gil	3162109873	camila.gil1@test.com
C808	Santiago	Hernandez	3111098762	santiago.hernandez1@email.net
C809	Valentina	Iglesias	3220987651	valentina.iglesias1@example.org
C810	Daniel	Juarez	3009876540	daniel.juarez1@mail.com
C811	Gabriela	Leon	3178765439	gabriela.leon1@test.net
C812	Ricardo	Marin	3047654328	ricardo.marin1@example.com
C813	Paula	Nuñez	3136543217	paula.nunez1@email.org
C814	Alejandro	Ortiz	3215432106	alejandro.ortiz1@mail.com
C815	Natalia	Peña	3004321095	natalia.pena1@test.org
C816	Martin	Quintana	3103210984	martin.quintana2@example.net
C817	Lucia	Salazar	3152109873	lucia.salazar1@email.com
C818	Fernando	Soto	3011098762	fernando.soto1@example.org
C819	Veronica	Uribe	3200987651	veronica.uribe1@mail.net
C820	Sergio	Vega	3189876540	sergio.vega1@test.com
C821	Andrea	Perez	3028765439	andrea.perez1@example.com
C822	Jorge	Gomez	3167654328	jorge.gomez1@email.net
C823	Adriana	Rodriguez	3116543217	adriana.rodriguez1@mail.org
C824	Alberto	Lopez	3225432106	alberto.lopez1@test.net
C825	Monica	Martinez	3004321095	monica.martinez1@example.com
C826	Victor	Sanchez	3173210984	victor.sanchez1@email.org
C827	Cristina	Fernandez	3042109873	cristina.fernandez1@mail.com
C828	Raul	Garcia	3131098762	raul.garcia1@test.org
C829	Beatriz	Gonzalez	3210987651	beatriz.gonzalez1@example.net
C830	Oscar	Diaz	3009876540	oscar.diaz1@email.com
C831	Silvia	Ruiz	3108765439	silvia.ruiz1@example.org
C832	Jose	Alvarez	3157654328	jose.alvarez2@mail.net
C833	Rosa	Moreno	3016543217	rosa.moreno1@test.com
C834	Manuel	Jimenez	3205432106	manuel.jimenez1@example.com
C835	Teresa	Vargas	3184321095	teresa.vargas1@email.net
C836	Francisco	Castro	3023210984	francisco.castro1@mail.org
C837	Gloria	Silva	3162109873	gloria.silva1@test.net
C838	Antonio	Torres	3111098762	antonio.torres1@example.com
C839	Angela	Rojas	3220987651	angela.rojas1@email.org
C840	Diego	Herrera	3009876540	diego.herrera1@mail.com
C841	Sandra	Medina	3178765439	sandra.medina1@test.org
C842	Ana	Flores	3047654328	ana.flores2@example.net
C843	Luis	Morales	3136543217	luis.morales2@email.com
C844	Maria	Ortega	3215432106	maria.ortega2@example.org
C845	Carlos	Guzman	3004321095	carlos.guzman2@mail.net
C846	Sofia	Ramos	3103210984	sofia.ramos2@test.com
C847	Juan	Cruz	3152109873	juan.cruz2@example.com
C848	Laura	Romero	3011098762	laura.romero2@email.net
C849	Pedro	Vasquez	3200987651	pedro.vasquez2@mail.org
C850	Carmen	Reyes	3189876540	carmen.reyes2@test.net
C851	David	Acosta	3028765439	david.acosta1@example.com
C852	Isabel	Benitez	3167654328	isabel.benitez1@mail.net
C853	Miguel	Campos	3116543217	miguel.campos1@test.org
C854	Patricia	Dominguez	3225432106	patricia.dominguez1@email.com
C855	Javier	Esteban	3004321095	javier.esteban1@example.net
C856	Elena	Fuentes	3173210984	elena.fuentes1@mail.org
C857	Andres	Gil	3042109873	andres.gil1@test.com
C858	Camila	Hernandez	3131098762	camila.hernandez1@email.net
C859	Santiago	Iglesias	3210987651	santiago.iglesias1@example.org
C860	Valentina	Juarez	3009876540	valentina.juarez1@mail.com
C861	Daniel	Leon	3108765439	daniel.leon1@test.net
C862	Gabriela	Marin	3157654328	gabriela.marin1@example.com
C863	Ricardo	Nuñez	3016543217	ricardo.nunez1@email.org
C864	Paula	Ortiz	3205432106	paula.ortiz1@mail.com
C865	Alejandro	Peña	3184321095	alejandro.pena1@test.org
C866	Natalia	Quintana	3023210984	natalia.quintana1@example.net
C867	Martin	Salazar	3162109873	martin.salazar2@email.com
C868	Lucia	Soto	3111098762	lucia.soto1@example.org
C869	Fernando	Uribe	3220987651	fernando.uribe1@mail.net
C870	Veronica	Vega	3009876540	veronica.vega1@test.com
C871	Sergio	Perez	3178765439	sergio.perez1@example.com
C872	Andrea	Gomez	3047654328	andrea.gomez1@email.net
C873	Jorge	Rodriguez	3136543217	jorge.rodriguez1@mail.org
C874	Adriana	Lopez	3215432106	adriana.lopez1@test.net
C875	Alberto	Martinez	3004321095	alberto.martinez1@example.com
C876	Monica	Sanchez	3103210984	monica.sanchez1@email.org
C877	Victor	Fernandez	3152109873	victor.fernandez1@mail.com
C878	Cristina	Garcia	3011098762	cristina.garcia1@test.org
C879	Raul	Gonzalez	3200987651	raul.gonzalez1@example.net
C880	Beatriz	Diaz	3189876540	beatriz.diaz1@email.com
C881	Oscar	Ruiz	3028765439	oscar.ruiz1@example.org
C882	Silvia	Alvarez	3167654328	silvia.alvarez1@mail.net
C883	Jose	Moreno	3116543217	jose.moreno2@test.com
C884	Rosa	Jimenez	3225432106	rosa.jimenez1@example.com
C885	Manuel	Vargas	3004321095	manuel.vargas1@email.net
C886	Teresa	Castro	3173210984	teresa.castro1@mail.org
C887	Francisco	Silva	3042109873	francisco.silva1@test.net
C888	Gloria	Torres	3131098762	gloria.torres1@example.com
C889	Antonio	Rojas	3210987651	antonio.rojas1@email.org
C890	Angela	Herrera	3009876540	angela.herrera1@mail.com
C891	Diego	Medina	3108765439	diego.medina1@test.org
C892	Sandra	Flores	3157654328	sandra.flores1@example.net
C893	Ana	Morales	3016543217	ana.morales2@email.com
C894	Luis	Ortega	3205432106	luis.ortega2@example.org
C895	Maria	Guzman	3184321095	maria.guzman2@mail.net
C896	Carlos	Ramos	3023210984	carlos.ramos2@test.com
C897	Sofia	Cruz	3162109873	sofia.cruz2@example.com
C898	Juan	Romero	3111098762	juan.romero2@email.net
C899	Laura	Vasquez	3220987651	laura.vasquez2@mail.org
C900	Pedro	Reyes	3009876540	pedro.reyes2@test.net
C901	Carmen	Acosta	3178765439	carmen.acosta1@example.com
C902	David	Benitez	3047654328	david.benitez1@mail.net
C903	Isabel	Campos	3136543217	isabel.campos1@test.org
C904	Miguel	Dominguez	3215432106	miguel.dominguez1@email.com
C905	Patricia	Esteban	3004321095	patricia.esteban1@example.net
C906	Javier	Fuentes	3103210984	javier.fuentes1@mail.org
C907	Elena	Gil	3152109873	elena.gil1@test.com
C908	Andres	Hernandez	3011098762	andres.hernandez1@email.net
C909	Camila	Iglesias	3200987651	camila.iglesias1@example.org
C910	Santiago	Juarez	3189876540	santiago.juarez1@mail.com
C911	Valentina	Leon	3028765439	valentina.leon1@test.net
C912	Daniel	Marin	3167654328	daniel.marin1@example.com
C913	Gabriela	Nuñez	3116543217	gabriela.nunez1@email.org
C914	Ricardo	Ortiz	3225432106	ricardo.ortiz1@mail.com
C915	Paula	Peña	3004321095	paula.pena1@test.org
C916	Alejandro	Quintana	3173210984	alejandro.quintana1@example.net
C917	Natalia	Salazar	3042109873	natalia.salazar1@email.com
C918	Martin	Soto	3131098762	martin.soto2@example.org
C919	Lucia	Uribe	3210987651	lucia.uribe1@mail.net
C920	Fernando	Vega	3009876540	fernando.vega1@test.com
C921	Veronica	Perez	3108765439	veronica.perez1@example.com
C922	Sergio	Gomez	3157654328	sergio.gomez1@email.net
C923	Andrea	Rodriguez	3016543217	andrea.rodriguez1@mail.org
C924	Jorge	Lopez	3205432106	jorge.lopez1@test.net
C925	Adriana	Martinez	3184321095	adriana.martinez1@example.com
C926	Alberto	Sanchez	3023210984	alberto.sanchez1@email.org
C927	Monica	Fernandez	3162109873	monica.fernandez1@mail.com
C928	Victor	Garcia	3111098762	victor.garcia1@test.org
C929	Cristina	Gonzalez	3220987651	cristina.gonzalez1@example.net
C930	Raul	Diaz	3009876540	raul.diaz1@email.com
C931	Beatriz	Ruiz	3178765439	beatriz.ruiz1@example.org
C932	Oscar	Alvarez	3047654328	oscar.alvarez1@mail.net
C933	Silvia	Moreno	3136543217	silvia.moreno1@test.com
C934	Jose	Jimenez	3215432106	jose.jimenez2@example.com
C935	Rosa	Vargas	3004321095	rosa.vargas1@email.net
C936	Manuel	Castro	3103210984	manuel.castro1@mail.org
C937	Teresa	Silva	3152109873	teresa.silva1@test.net
C938	Francisco	Torres	3011098762	francisco.torres1@example.com
C939	Gloria	Rojas	3200987651	gloria.rojas1@email.org
C940	Antonio	Herrera	3189876540	antonio.herrera1@mail.com
C941	Angela	Medina	3028765439	angela.medina1@test.org
C942	Diego	Flores	3167654328	diego.flores1@example.net
C943	Sandra	Morales	3116543217	sandra.morales1@email.com
C944	Ana	Ortega	3225432106	ana.ortega2@example.org
C945	Luis	Guzman	3004321095	luis.guzman2@mail.net
C946	Maria	Ramos	3173210984	maria.ramos2@test.com
C947	Carlos	Cruz	3042109873	carlos.cruz2@example.com
C948	Sofia	Romero	3131098762	sofia.romero2@email.net
C949	Juan	Vasquez	3210987651	juan.vasquez2@mail.org
C950	Laura	Reyes	3009876540	laura.reyes2@test.net
C951	Pedro	Acosta	3108765439	pedro.acosta1@example.com
C952	Carmen	Benitez	3157654328	carmen.benitez1@mail.net
C953	David	Campos	3016543217	david.campos1@test.org
C954	Isabel	Dominguez	3205432106	isabel.dominguez1@email.com
C955	Miguel	Esteban	3184321095	miguel.esteban1@example.net
C956	Patricia	Fuentes	3023210984	patricia.fuentes1@mail.org
C957	Javier	Gil	3162109873	javier.gil1@test.com
C958	Elena	Hernandez	3111098762	elena.hernandez1@email.net
C959	Andres	Iglesias	3220987651	andres.iglesias1@example.org
C960	Camila	Juarez	3009876540	camila.juarez1@mail.com
C961	Santiago	Leon	3178765439	santiago.leon1@test.net
C962	Valentina	Marin	3047654328	valentina.marin1@example.com
C963	Daniel	Nuñez	3136543217	daniel.nunez1@email.org
C964	Gabriela	Ortiz	3215432106	gabriela.ortiz1@mail.com
C965	Ricardo	Peña	3004321095	ricardo.pena1@test.org
C966	Paula	Quintana	3103210984	paula.quintana1@example.net
C967	Alejandro	Salazar	3152109873	alejandro.salazar1@email.com
C968	Natalia	Soto	3011098762	natalia.soto1@example.org
C969	Martin	Uribe	3200987651	martin.uribe2@mail.net
C970	Lucia	Vega	3189876540	lucia.vega1@test.com
C971	Fernando	Perez	3028765439	fernando.perez1@example.com
C972	Veronica	Gomez	3167654328	veronica.gomez1@email.net
C973	Sergio	Rodriguez	3116543217	sergio.rodriguez1@mail.org
C974	Andrea	Lopez	3225432106	andrea.lopez1@test.net
C975	Jorge	Martinez	3004321095	jorge.martinez1@example.com
C976	Adriana	Sanchez	3173210984	adriana.sanchez1@email.org
C977	Alberto	Fernandez	3042109873	alberto.fernandez1@mail.com
C978	Monica	Garcia	3131098762	monica.garcia1@test.org
C979	Victor	Gonzalez	3210987651	victor.gonzalez1@example.net
C980	Cristina	Diaz	3009876540	cristina.diaz1@email.com
C981	Raul	Ruiz	3108765439	raul.ruiz1@example.org
C982	Beatriz	Alvarez	3157654328	beatriz.alvarez1@mail.net
C983	Oscar	Moreno	3016543217	oscar.moreno1@test.com
C984	Silvia	Jimenez	3205432106	silvia.jimenez1@example.com
C985	Jose	Vargas	3184321095	jose.vargas2@email.net
C986	Rosa	Castro	3023210984	rosa.castro1@mail.org
C987	Manuel	Silva	3162109873	manuel.silva1@test.net
C988	Teresa	Torres	3111098762	teresa.torres1@example.com
C989	Francisco	Rojas	3220987651	francisco.rojas1@email.org
C990	Gloria	Herrera	3009876540	gloria.herrera1@mail.com
C991	Antonio	Medina	3178765439	antonio.medina1@test.org
C992	Angela	Flores	3047654328	angela.flores1@example.net
C993	Diego	Morales	3136543217	diego.morales1@email.com
C994	Sandra	Ortega	3215432106	sandra.ortega1@example.org
C995	Ana	Guzman	3004321095	ana.guzman2@mail.net
C996	Luis	Ramos	3103210984	luis.ramos2@test.com
C997	Maria	Cruz	3152109873	maria.cruz2@example.com
C998	Carlos	Romero	3011098762	carlos.romero2@email.net
C999	Sofia	Vasquez	3200987651	sofia.vasquez2@mail.org
C000	Juan	Reyes	3189876540	juan.reyes2@test.net
\.


    5135.dat                                                                                            0000600 0004000 0002000 00000042233 15014423351 0014251 0                                                                                                    ustar 00postgres                        postgres                        0000000 0000000                                                                                                                                                                        D001	1	280000	56000	224000	I001	P001
D002	1	550000	0	550000	I002	P002
D003	2	190000	38000	342000	I003	P003
D004	1	95000	0	95000	I004	P004
D005	1	150000	15000	135000	P005	P005
D006	1	120000	0	120000	I006	P006
D007	3	70000	21000	189000	I007	P007
D008	1	350000	70000	280000	I008	P008
D009	1	320000	0	320000	I009	P009
D010	2	210000	42000	378000	I010	P010
D011	1	160000	16000	144000	I011	P011
D012	1	480000	0	480000	I012	P012
D013	1	110000	22000	88000	I013	P013
D014	1	175000	29750	145250	I014	P014
D015	2	295000	59000	531000	I015	P015
D016	1	340000	0	340000	I016	P016
D017	1	85000	25500	59500	I017	P017
D018	1	220000	33000	187000	I018	P018
D019	1	90000	22500	67500	I019	P019
D020	1	420000	0	420000	I020	P020
D021	1	260000	26000	234000	I021	P021
D022	2	230000	46000	414000	I022	P022
D023	1	165000	33000	132000	I023	P023
D024	1	680000	0	680000	I024	P024
D025	1	65000	9750	55250	I025	P025
D026	2	55000	0	110000	I026	P026
D027	1	130000	13000	117000	I027	P027
D028	1	105000	0	105000	I028	P028
D029	1	75000	7500	67500	I029	P029
D030	1	180000	36000	144000	I030	P030
D031	1	650000	0	650000	I031	P031
D032	1	480000	72000	408000	I032	P032
D033	1	520000	0	520000	I033	P033
D034	2	1200000	240000	2160000	I034	P034
D035	1	580000	0	580000	I035	P035
D036	1	720000	72000	648000	I036	P036
D037	1	560000	112000	448000	I037	P037
D038	1	530000	0	530000	I038	P038
D039	1	590000	59000	531000	I039	P039
D040	2	450000	90000	810000	I040	P040
D041	1	540000	54000	486000	I041	P041
D042	1	380000	0	380000	I042	P042
D043	1	320000	41600	278400	I043	P043
D044	1	510000	0	510000	I044	P044
D045	1	490000	49000	441000	I045	P045
D046	1	950000	0	950000	I046	P046
D047	1	880000	88000	792000	I047	P047
D048	1	2100000	420000	1680000	I048	P048
D049	1	620000	0	620000	I049	P049
D050	1	1150000	575000	575000	I050	P050
D051	1	290000	29000	261000	I051	P051
D052	1	580000	116000	464000	I052	P052
D053	2	220000	0	440000	I053	P053
D054	1	125000	12500	112500	I054	P054
D055	1	160000	0	160000	I055	P055
D056	1	250000	50000	200000	I056	P056
D057	3	78000	46800	187200	I057	P057
D058	1	380000	76000	304000	I058	P058
D059	1	450000	45000	405000	I059	P059
D060	1	235000	23500	211500	I060	P060
D061	1	190000	0	190000	I061	P061
D062	1	520000	104000	416000	I062	P062
D063	2	100000	20000	180000	I063	P063
D064	1	145000	0	145000	I064	P064
D065	1	310000	62000	248000	I065	P065
D066	1	360000	61200	298800	I066	P066
D067	1	92000	0	92000	I067	P067
D068	2	170000	34000	306000	I068	P068
D069	1	98000	0	98000	I069	P069
D070	1	850000	170000	680000	I070	P070
D071	1	300000	0	300000	I071	P071
D072	1	195000	29250	165750	I072	P072
D073	3	240000	108000	612000	I073	P073
D074	1	610000	152500	457500	I074	P074
D075	1	115000	0	115000	I075	P075
D076	2	250000	0	500000	I076	P076
D077	1	70000	14000	56000	I077	P077
D078	1	60000	0	60000	I078	P078
D079	1	120000	12000	108000	I079	P079
D080	1	180000	0	180000	I080	P080
D081	1	275000	41250	233750	I081	P081
D082	1	200000	0	200000	I082	P082
D083	1	560000	112000	448000	I083	P083
D084	2	135000	0	270000	I084	P084
D085	1	280000	28000	252000	I085	P085
D086	1	110000	0	110000	I086	P086
D087	1	400000	80000	320000	I087	P087
D088	1	330000	0	330000	I088	P088
D089	1	245000	36750	208250	I089	P089
D090	3	290000	0	870000	I090	P090
D091	1	750000	112500	637500	I091	P091
D092	1	150000	0	150000	I092	P092
D093	1	315000	31500	283500	I093	P093
D094	1	95000	19000	76000	I094	P094
D095	1	140000	0	140000	I095	P095
D096	1	175000	17500	157500	I096	P096
D097	1	380000	0	380000	I097	P097
D098	1	265000	39750	225250	I098	P098
D099	2	210000	42000	378000	I099	P099
D100	1	495000	0	495000	I100	P100
D101	1	320000	32000	288000	I101	P101
D102	1	240000	72000	168000	I102	P102
D103	1	950000	0	950000	I103	P103
D104	2	140000	28000	252000	I104	P104
D105	1	190000	0	190000	I105	P105
D106	1	180000	18000	162000	I106	P106
D107	1	88000	0	88000	I107	P107
D108	1	390000	39000	351000	I108	P108
D109	1	350000	70000	280000	I109	P109
D110	2	210000	0	420000	I110	P110
D111	1	150000	15000	135000	I111	P111
D112	1	620000	0	620000	I112	P112
D226	1	165000	0	165000	I226	P226
D113	1	120000	12000	108000	I113	P113
D114	1	160000	0	160000	I114	P114
D115	1	335000	33500	301500	I115	P115
D116	1	370000	0	370000	I116	P116
D117	1	150000	15000	135000	I117	P117
D118	1	200000	40000	160000	I118	P118
D119	2	85000	0	170000	I119	P119
D120	1	250000	25000	225000	I120	P120
D121	1	360000	0	360000	I121	P121
D122	1	225000	22500	202500	I122	P122
D123	1	200000	0	200000	I123	P123
D124	1	650000	130000	520000	I124	P124
D125	2	90000	0	180000	I125	P125
D126	1	60000	6000	54000	I126	P126
D127	1	70000	0	70000	I127	P127
D128	1	190000	19000	171000	I128	P128
D129	1	110000	0	110000	I129	P129
D130	1	290000	58000	232000	I130	P130
D131	2	230000	0	460000	I131	P131
D132	1	185000	18500	166500	I132	P132
D133	1	590000	0	590000	I133	P133
D134	1	98000	9800	88200	I134	P134
D135	1	75000	0	75000	I135	P135
D136	1	260000	52000	208000	I136	P136
D137	2	105000	0	210000	I137	P137
D138	1	370000	37000	333000	I138	P138
D139	1	345000	0	345000	I139	P139
D140	1	215000	21500	193500	I140	P140
D141	1	250000	0	250000	I141	P141
D142	1	480000	96000	384000	I142	P142
D143	2	80000	0	160000	I143	P143
D144	1	110000	11000	99000	I144	P144
D145	1	70000	0	70000	I145	P145
D146	1	125000	12500	112500	I146	P146
D147	1	45000	0	45000	I147	P147
D148	1	95000	19000	76000	I148	P148
D149	2	65000	0	130000	I149	P149
D150	1	200000	20000	180000	I150	P150
D151	1	330000	0	330000	I151	P151
D152	1	250000	25000	225000	I152	P152
D153	1	550000	110000	440000	I153	P153
D154	2	140000	0	280000	I154	P154
D155	1	195000	19500	175500	I155	P155
D156	1	300000	0	300000	I156	P156
D157	1	95000	9500	85500	I157	P157
D158	1	450000	45000	405000	I158	P158
D159	1	370000	0	370000	I159	P159
D160	2	260000	52000	468000	I160	P160
D161	1	170000	17000	153000	I161	P161
D162	1	720000	144000	576000	I162	P162
D163	1	80000	0	80000	I163	P163
D164	1	150000	15000	135000	I164	P164
D165	1	400000	0	400000	I165	P165
D166	1	380000	38000	342000	I166	P166
D167	1	92000	0	92000	I167	P167
D168	1	190000	19000	171000	I168	P168
D169	1	100000	0	100000	I169	P169
D170	1	480000	96000	384000	I170	P170
D171	2	350000	0	700000	I171	P171
D172	1	180000	18000	162000	I172	P172
D173	1	220000	0	220000	I173	P173
D174	1	690000	69000	621000	I174	P174
D175	1	130000	0	130000	I175	P175
D176	1	140000	14000	126000	I176	P176
D177	1	550000	110000	440000	I177	P177
D178	3	70000	0	210000	I178	P178
D179	1	90000	9000	81000	I179	P179
D180	1	310000	0	310000	I180	P180
D181	1	200000	20000	180000	I181	P181
D182	1	170000	0	170000	I182	P182
D183	1	580000	58000	522000	I183	P183
D184	1	100000	0	100000	I184	P184
D185	1	130000	13000	117000	I185	P185
D186	1	95000	19000	76000	I186	P186
D187	2	420000	0	840000	I187	P187
D188	1	360000	36000	324000	I188	P188
D189	1	230000	0	230000	I189	P189
D190	1	190000	19000	171000	I190	P190
D191	1	670000	0	670000	I191	P191
D192	1	150000	15000	135000	I192	P192
D193	1	135000	27000	108000	I193	P193
D194	2	115000	0	230000	I194	P194
D195	1	240000	24000	216000	I195	P195
D196	1	220000	0	220000	I196	P196
D197	1	290000	29000	261000	I197	P197
D198	1	180000	0	180000	I198	P198
D199	1	250000	25000	225000	I199	P199
D200	1	90000	18000	72000	I200	P200
D201	2	180000	0	360000	I201	P201
D202	1	80000	8000	72000	I202	P202
D203	1	200000	0	200000	I203	P203
D204	1	75000	7500	67500	I204	P204
D205	1	520000	0	520000	I205	P205
D206	1	135000	13500	121500	I206	P206
D207	1	100000	20000	80000	I207	P207
D208	2	390000	0	780000	I208	P208
D209	1	340000	34000	306000	I209	P209
D210	1	255000	0	255000	I210	P210
D211	1	180000	18000	162000	I211	P211
D212	1	700000	0	700000	I212	P212
D213	1	85000	8500	76500	I213	P213
D214	1	155000	31000	124000	I214	P214
D215	2	325000	0	650000	I215	P215
D216	1	390000	39000	351000	I216	P216
D217	1	98000	0	98000	I217	P217
D218	1	175000	17500	157500	I218	P218
D219	1	90000	0	90000	I219	P219
D220	1	380000	38000	342000	I220	P220
D221	1	370000	74000	296000	I221	P221
D222	2	240000	0	480000	I222	P222
D223	1	210000	21000	189000	I223	P223
D224	1	730000	0	730000	I224	P224
D225	1	125000	12500	112500	I225	P225
D227	1	120000	12000	108000	I227	P227
D228	1	255000	51000	204000	I228	P228
D229	2	230000	0	460000	I229	P229
D230	1	330000	33000	297000	I230	P230
D231	1	265000	0	265000	I231	P231
D232	1	195000	19500	175500	I232	P232
D233	1	600000	0	600000	I233	P233
D234	1	80000	8000	72000	I234	P234
D235	1	60000	12000	48000	I235	P235
D236	2	190000	0	380000	I236	P236
D237	1	110000	11000	99000	I237	P237
D238	1	185000	0	185000	I238	P238
D239	1	115000	11500	103500	I239	P239
D240	1	550000	0	550000	I240	P240
D241	1	450000	45000	405000	I241	P241
D242	1	220000	44000	176000	I242	P242
D243	2	300000	0	600000	I243	P243
D244	1	1200000	120000	1080000	I244	P244
D245	1	145000	0	145000	I245	P245
D246	1	200000	20000	180000	I246	P246
D247	1	100000	0	100000	I247	P247
D248	1	320000	32000	288000	I248	P248
D249	1	195000	39000	156000	I249	P249
D250	2	340000	0	680000	I250	P250
D251	1	270000	27000	243000	I251	P251
D252	1	200000	0	200000	I252	P252
D253	1	620000	62000	558000	I253	P253
D254	1	90000	0	90000	I254	P254
D255	1	350000	35000	315000	I255	P255
D256	1	400000	80000	320000	I256	P256
D257	2	70000	0	140000	I257	P257
D258	1	160000	16000	144000	I258	P258
D259	1	190000	0	190000	I259	P259
D260	1	110000	11000	99000	I260	P260
D261	1	98000	0	98000	I261	P261
D262	1	330000	33000	297000	I262	P262
D263	1	260000	52000	208000	I263	P263
D264	2	195000	0	390000	I264	P264
D265	1	500000	50000	450000	I265	P265
D266	1	120000	0	120000	I266	P266
D267	1	140000	14000	126000	I267	P267
D268	1	100000	0	100000	I268	P268
D269	1	165000	16500	148500	I269	P269
D270	1	310000	62000	248000	I270	P270
D271	2	220000	0	440000	I271	P271
D272	1	180000	18000	162000	I272	P272
D273	1	590000	0	590000	I273	P273
D274	1	105000	10500	94500	I274	P274
D275	1	145000	0	145000	I275	P275
D276	1	100000	10000	90000	I276	P276
D277	1	370000	74000	296000	I277	P277
D278	2	235000	0	470000	I278	P278
D279	1	185000	18500	166500	I279	P279
D280	1	510000	0	510000	I280	P280
D281	1	92000	9200	82800	I281	P281
D282	1	150000	0	150000	I282	P282
D283	1	180000	18000	162000	I283	P283
D284	1	115000	23000	92000	I284	P284
D285	2	320000	0	640000	I285	P285
D286	1	250000	25000	225000	I286	P286
D287	1	200000	0	200000	I287	P287
D288	1	650000	65000	585000	I288	P288
D289	1	130000	0	130000	I289	P289
D290	1	195000	19500	175500	I290	P290
D291	1	150000	30000	120000	I291	P291
D292	2	105000	0	210000	I292	P292
D293	1	300000	30000	270000	I293	P293
D294	1	225000	0	225000	I294	P294
D295	1	180000	18000	162000	I295	P295
D296	1	520000	0	520000	I296	P296
D297	1	90000	9000	81000	I297	P297
D298	1	170000	34000	136000	I298	P298
D299	2	160000	0	320000	I299	P299
D300	1	360000	36000	324000	I300	P300
D301	1	240000	0	240000	I301	P301
D302	1	205000	20500	184500	I302	P302
D303	1	680000	0	680000	I303	P303
D304	1	85000	8500	76500	I304	P304
D305	1	420000	0	420000	I305	P305
D306	1	155000	15500	139500	I306	P306
D307	1	140000	28000	112000	I307	P307
D308	2	120000	0	240000	I308	P308
D309	1	90000	9000	81000	I309	P309
D310	1	330000	0	330000	I310	P310
D311	1	255000	25500	229500	I311	P311
D312	1	190000	0	190000	I312	P312
D313	1	500000	50000	450000	I313	P313
D314	1	70000	0	70000	I314	P314
D315	1	145000	14500	130500	I315	P315
D316	1	200000	40000	160000	I316	P316
D317	2	170000	0	340000	I317	P317
D318	1	315000	31500	283500	I318	P318
D319	1	260000	0	260000	I319	P319
D320	1	210000	21000	189000	I320	P320
D321	1	660000	0	660000	I321	P321
D322	1	135000	13500	121500	I322	P322
D323	1	150000	30000	120000	I323	P323
D324	2	110000	0	220000	I324	P324
D325	1	250000	25000	225000	I325	P325
D326	1	225000	0	225000	I326	P326
D327	1	380000	38000	342000	I327	P327
D328	1	100000	0	100000	I328	P328
D329	1	400000	40000	360000	I329	P329
D330	1	370000	74000	296000	I330	P330
D331	2	245000	0	490000	I331	P331
D332	1	215000	21500	193500	I332	P332
D333	1	560000	0	560000	I333	P333
D334	1	130000	13000	117000	I334	P334
D335	1	170000	0	170000	I335	P335
D336	1	175000	17500	157500	I336	P336
D337	1	180000	36000	144000	I337	P337
D338	2	320000	0	640000	I338	P338
D339	1	270000	27000	243000	I339	P339
D340	1	220000	0	220000	I340	P340
D341	1	690000	69000	621000	I341	P341
D342	1	95000	0	95000	I342	P342
D343	1	160000	16000	144000	I343	P343
D344	1	180000	36000	144000	I344	P344
D345	2	110000	0	220000	I345	P345
D346	1	325000	32500	292500	I346	P346
D347	1	250000	0	250000	I347	P347
D348	1	185000	18500	166500	I348	P348
D349	1	490000	0	490000	I349	P349
D350	1	88000	8800	79200	I350	P350
D351	1	190000	19000	171000	I351	P351
D352	1	145000	29000	116000	I352	P352
D353	2	165000	0	330000	I353	P353
D354	1	295000	29500	265500	I354	P354
D355	1	215000	0	215000	I355	P355
D356	1	175000	17500	157500	I356	P356
D357	1	570000	0	570000	I357	P357
D358	1	125000	12500	112500	I358	P358
D359	1	130000	26000	104000	I359	P359
D360	2	170000	0	340000	I360	P360
D361	1	105000	10500	94500	I361	P361
D362	1	350000	0	350000	I362	P362
D363	1	220000	22000	198000	I363	P363
D364	1	180000	0	180000	I364	P364
D365	1	480000	48000	432000	I365	P365
D366	1	92000	18400	73600	I366	P366
D367	2	165000	0	330000	I367	P367
D368	1	140000	14000	126000	I368	P368
D369	1	160000	0	160000	I369	P369
D370	1	310000	31000	279000	I370	P370
D371	1	245000	0	245000	I371	P371
D372	1	190000	19000	171000	I372	P372
D373	1	670000	134000	536000	I373	P373
D374	2	130000	0	260000	I374	P374
D375	1	290000	29000	261000	I375	P375
D376	1	112000	0	112000	I376	P376
D377	1	410000	41000	369000	I377	P377
D378	1	365000	0	365000	I378	P378
D379	1	230000	23000	207000	I379	P379
D380	1	180000	36000	144000	I380	P380
D381	2	500000	0	1000000	I381	P381
D382	1	78000	7800	70200	I382	P382
D383	1	145000	0	145000	I383	P383
D384	1	175000	17500	157500	I384	P384
D385	1	112000	0	112000	I385	P385
D386	1	320000	32000	288000	I386	P386
D387	1	255000	51000	204000	I387	P387
D388	2	200000	0	400000	I388	P388
D389	1	680000	68000	612000	I389	P389
D390	1	128000	0	128000	I390	P390
D391	1	175000	17500	157500	I391	P391
D392	1	150000	0	150000	I392	P392
D393	1	170000	17000	153000	I393	P393
D394	1	380000	76000	304000	I394	P394
D395	2	270000	0	540000	I395	P395
D396	1	190000	19000	171000	I396	P396
D397	1	530000	0	530000	I397	P397
D398	1	140000	14000	126000	I398	P398
D399	1	300000	0	300000	I399	P399
D400	1	120000	12000	108000	I400	P400
D401	1	460000	92000	368000	I401	P401
D402	2	380000	0	760000	I402	P402
D403	1	240000	24000	216000	I403	P403
D404	1	210000	0	210000	I404	P404
D405	1	750000	75000	675000	I405	P405
D406	1	135000	0	135000	I406	P406
D407	1	180000	18000	162000	I407	P407
D408	1	155000	31000	124000	I408	P408
D409	2	175000	0	350000	I409	P409
D410	1	340000	34000	306000	I410	P410
D411	1	275000	0	275000	I411	P411
D412	1	200000	20000	180000	I412	P412
D413	1	540000	0	540000	I413	P413
D414	1	110000	11000	99000	I414	P414
D415	1	310000	62000	248000	I415	P415
D416	2	110000	0	220000	I416	P416
D417	1	430000	43000	387000	I417	P417
D418	1	375000	0	375000	I418	P418
D419	1	230000	23000	207000	I419	P419
D420	1	200000	0	200000	I420	P420
D421	1	660000	66000	594000	I421	P421
D422	1	132000	26400	105600	I422	P422
D423	2	170000	0	340000	I423	P423
D424	1	148000	14800	133200	I424	P424
D425	1	168000	0	168000	I425	P425
D426	1	335000	33500	301500	I426	P426
D427	1	265000	0	265000	I427	P427
D428	1	195000	19500	175500	I428	P428
D429	1	550000	110000	440000	I429	P429
D430	2	118000	0	236000	I430	P430
D431	1	305000	30500	274500	I431	P431
D432	1	112000	0	112000	I432	P432
D433	1	440000	44000	396000	I433	P433
D434	1	390000	0	390000	I434	P434
D435	1	235000	23500	211500	I435	P435
D436	1	205000	41000	164000	I436	P436
D437	2	675000	0	1350000	I437	P437
D438	1	138000	13800	124200	I438	P438
D439	1	172000	0	172000	I439	P439
D440	1	152000	15200	136800	I440	P440
D441	1	172000	0	172000	I441	P441
D442	1	345000	34500	310500	I442	P442
D443	1	280000	56000	224000	I443	P443
D444	2	210000	0	420000	I444	P444
D445	1	560000	56000	504000	I445	P445
D446	1	82000	0	82000	I446	P446
D447	1	168000	16800	151200	I447	P447
D448	1	182000	0	182000	I448	P448
D449	1	118000	11800	106200	I449	P449
D450	1	350000	70000	280000	I450	P450
D451	2	285000	0	570000	I451	P451
D452	1	225000	22500	202500	I452	P452
D453	1	695000	0	695000	I453	P453
D454	1	142000	14200	127800	I454	P454
D455	1	315000	0	315000	I455	P455
D456	1	122000	12200	109800	I456	P456
D457	1	470000	94000	376000	I457	P457
D458	2	400000	0	800000	I458	P458
D459	1	245000	24500	220500	I459	P459
D460	1	215000	0	215000	I460	P460
D461	1	570000	57000	513000	I461	P461
D462	1	148000	0	148000	I462	P462
D463	1	182000	18200	163800	I463	P463
D464	1	160000	32000	128000	I464	P464
D465	2	178000	0	356000	I465	P465
D466	1	355000	35500	319500	I466	P466
D467	1	290000	0	290000	I467	P467
D468	1	230000	23000	207000	I468	P468
D469	1	710000	0	710000	I469	P469
D470	1	150000	15000	135000	I470	P470
D471	1	330000	66000	264000	I471	P471
D472	2	130000	0	260000	I472	P472
D473	1	500000	50000	450000	I473	P473
D474	1	410000	0	410000	I474	P474
D475	1	250000	25000	225000	I475	P475
D476	1	220000	0	220000	I476	P476
D477	1	580000	58000	522000	I477	P477
D478	1	85000	17000	68000	I478	P478
D479	2	170000	0	340000	I479	P479
D480	1	190000	19000	171000	I480	P480
D481	1	125000	0	125000	I481	P481
D482	1	360000	36000	324000	I482	P482
D483	1	295000	0	295000	I483	P483
D484	1	235000	23500	211500	I484	P484
D485	1	700000	140000	560000	I485	P485
D486	2	95000	0	190000	I486	P486
D487	1	178000	17800	160200	I487	P487
D488	1	165000	0	165000	I488	P488
D489	1	182000	18200	163800	I489	P489
D490	1	370000	0	370000	I490	P490
D491	1	260000	26000	234000	I491	P491
D492	1	200000	40000	160000	I492	P492
D493	2	510000	0	1020000	I493	P493
D494	1	98000	9800	88200	I494	P494
D495	1	140000	0	140000	I495	P495
D496	1	170000	17000	153000	I496	P496
D497	1	108000	0	108000	I497	P497
D498	1	355000	35500	319500	I498	P498
D499	1	230000	46000	184000	I499	P499
D500	2	195000	0	390000	I500	P500
\.


                                                                                                                                                                                                                                                                                                                                                                     5137.dat                                                                                            0000600 0004000 0002000 00000043205 15014423351 0014253 0                                                                                                    ustar 00postgres                        postgres                        0000000 0000000                                                                                                                                                                        DS01	50	120000	500000	5500000	IS01	P001
DS02	20	250000	200000	4800000	IS02	P002
DS03	100	70000	0	7000000	IS03	P003
DS04	200	35000	100000	6900000	IS04	P004
DS05	75	60000	0	4500000	IS05	P005
DS06	30	50000	0	1500000	IS06	P006
DS07	150	25000	50000	3700000	IS07	P007
DS08	25	150000	150000	3600000	IS08	P008
DS09	40	140000	0	5600000	IS09	P009
DS10	60	85000	0	5100000	IS10	P010
DS11	35	70000	70000	2380000	IS11	P011
DS12	15	200000	0	3000000	IS12	P012
DS13	50	45000	0	2250000	IS13	P013
DS14	80	65000	100000	5100000	IS14	P014
DS15	30	130000	0	3900000	IS15	P015
DS16	20	150000	0	3000000	IS16	P016
DS17	100	30000	150000	2850000	IS17	P017
DS18	18	90000	0	1620000	IS18	P018
DS19	70	35000	0	2450000	IS19	P019
DS20	12	180000	100000	2060000	IS20	P020
DS21	45	110000	0	4950000	IS21	P021
DS22	60	95000	0	5700000	IS22	P022
DS23	55	60000	50000	3250000	IS23	P023
DS24	10	300000	0	3000000	IS24	P024
DS25	120	22000	0	2640000	IS25	P025
DS26	75	20000	30000	1470000	IS26	P026
DS27	25	55000	0	1375000	IS27	P027
DS28	40	40000	0	1600000	IS28	P028
DS29	65	28000	20000	1800000	IS29	P029
DS30	30	75000	0	2250000	IS30	P030
DS31	20	280000	250000	5350000	IS31	P031
DS32	35	200000	0	7000000	IS32	P032
DS33	18	230000	100000	4040000	IS33	P033
DS34	10	500000	0	5000000	IS34	P034
DS35	25	250000	0	6250000	IS35	P035
DS36	12	320000	150000	3690000	IS36	P036
DS37	28	240000	0	6720000	IS37	P037
DS38	30	230000	0	6900000	IS38	P038
DS39	22	260000	120000	5600000	IS39	P039
DS40	40	180000	0	7200000	IS40	P040
DS41	20	240000	0	4800000	IS41	P041
DS42	38	150000	100000	5600000	IS42	P042
DS43	50	120000	0	6000000	IS43	P043
DS44	15	220000	0	3300000	IS44	P044
DS45	16	200000	80000	3120000	IS45	P045
DS46	8	400000	0	3200000	IS46	P046
DS47	10	380000	0	3800000	IS47	P047
DS48	5	900000	200000	4300000	IS48	P048
DS49	17	270000	0	4590000	IS49	P049
DS50	7	500000	0	3500000	IS50	P050
DS51	60	130500	391500	7438500	IS51	P051
DS52	30	261000	0	7830000	IS52	P052
DS53	80	99000	0	7920000	IS53	P053
DS54	150	56250	400000	8037500	IS54	P054
DS55	70	72000	0	5040000	IS55	P055
DS56	25	112500	0	2812500	IS56	P056
DS57	180	35100	300000	6018000	IS57	P057
DS58	20	171000	0	3420000	IS58	P058
DS59	30	202500	0	6075000	IS59	P059
DS60	50	105750	250000	5037500	IS60	P060
DS61	30	85500	0	2565000	IS61	P061
DS62	12	234000	0	2808000	IS62	P062
DS63	80	45000	150000	3450000	IS63	P063
DS64	35	65250	0	2283750	IS64	P064
DS65	40	139500	0	5580000	IS65	P065
DS66	22	162000	100000	3464000	IS66	P066
DS67	90	41400	0	3726000	IS67	P067
DS68	20	76500	0	1530000	IS68	P068
DS69	60	44100	50000	2596000	IS69	P069
DS70	10	382500	0	3825000	IS70	P070
DS71	35	135000	0	4725000	IS71	P071
DS72	50	87750	100000	4287500	IS72	P072
DS73	100	108000	0	10800000	IS73	P073
DS74	15	274500	0	4117500	IS74	P074
DS75	80	51750	150000	3990000	IS75	P075
DS76	28	112500	0	3150000	IS76	P076
DS77	120	31500	0	3780000	IS77	P077
DS78	40	27000	40000	1040000	IS78	P078
DS79	30	54000	0	1620000	IS79	P079
DS80	70	81000	0	5670000	IS80	P080
DS81	40	123750	100000	4850000	IS81	P081
DS82	85	90000	0	7650000	IS82	P082
DS83	18	252000	0	4536000	IS83	P083
DS84	50	60750	50000	2987500	IS84	P084
DS85	10	126000	0	1260000	IS85	P085
DS86	60	49500	0	2970000	IS86	P086
DS87	25	180000	100000	4400000	IS87	P087
DS88	30	148500	0	4455000	IS88	P088
DS89	45	110250	0	4961250	IS89	P089
DS90	100	130500	500000	12550000	IS90	P090
DS91	8	337500	0	2700000	IS91	P091
DS92	40	67500	0	2700000	IS92	P092
DS93	30	141750	80000	4172500	IS93	P093
DS94	60	42750	0	2565000	IS94	P094
DS95	20	63000	0	1260000	IS95	P095
DS96	32	78750	50000	2470000	IS96	P096
DS97	15	171000	0	2565000	IS97	P097
DS98	40	119250	0	4770000	IS98	P098
DS99	90	94500	200000	8305000	IS99	P099
DT01	20	222750	0	4455000	IT01	P100
DT02	50	144000	100000	7100000	IT02	P101
DT03	70	108000	0	7560000	IT03	P102
DT04	8	427500	0	3420000	IT04	P103
DT05	100	63000	200000	6100000	IT05	P104
DT06	60	85500	0	5130000	IT06	P105
DT07	25	81000	0	2025000	IT07	P106
DT08	150	39600	250000	5690000	IT08	P107
DT09	18	175500	0	3159000	IT09	P108
DT10	30	157500	0	4725000	IT10	P109
DT11	55	94500	100000	5097500	IT11	P110
DT12	38	67500	0	2565000	IT12	P111
DT13	10	279000	0	2790000	IT13	P112
DT14	40	54000	40000	2120000	IT14	P113
DT15	20	72000	0	1440000	IT15	P114
DT16	28	150750	0	4221000	IT16	P115
DT17	22	166500	80000	3583000	IT17	P116
DT18	100	67500	0	6750000	IT18	P117
DT19	12	90000	0	1080000	IT19	P118
DT20	70	38250	60000	2617500	IT20	P119
DT21	10	112500	0	1125000	IT21	P120
DT22	30	162000	0	4860000	IT22	P121
DT23	50	101250	100000	4962500	IT23	P122
DT24	80	90000	0	7200000	IT24	P123
DT25	12	292500	0	3510000	IT25	P124
DT26	120	40500	200000	4660000	IT26	P125
DT27	20	27000	0	540000	IT27	P126
DT28	90	31500	0	2835000	IT28	P127
DT29	35	85500	50000	2942500	IT29	P128
DT30	18	49500	0	891000	IT30	P129
DT31	40	130500	0	5220000	IT31	P130
DT32	60	103500	150000	6060000	IT32	P131
DT33	100	83250	0	8325000	IT33	P132
DT34	15	265500	0	3982500	IT34	P133
DT35	80	44100	100000	3428000	IT35	P134
DT36	25	33750	0	843750	IT36	P135
DT37	140	117000	0	16380000	IT37	P136
DT38	20	47250	30000	915000	IT38	P137
DT39	10	166500	0	1665000	IT39	P138
DT40	30	155250	0	4657500	IT40	P139
DT41	50	96750	80000	4757500	IT41	P140
DT42	70	112500	0	7875000	IT42	P141
DT43	8	216000	0	1728000	IT43	P142
DT44	100	36000	100000	3500000	IT44	P143
DT45	40	49500	0	1980000	IT45	P144
DT46	20	31500	0	630000	IT46	P145
DT47	35	56250	40000	1928750	IT47	P146
DT48	15	20250	0	303750	IT48	P147
DT49	28	42750	0	1197000	IT49	P148
DT50	90	90000	250000	7850000	IT50	P149
DU01	10	90000	0	900000	IU01	P150
DU02	45	148500	100000	6582500	IU02	P151
DU03	60	112500	0	6750000	IU03	P152
DU04	20	247500	0	4950000	IU04	P153
DU05	80	63000	150000	4890000	IU05	P154
DU06	50	87750	0	4387500	IU06	P155
DU07	28	135000	0	3780000	IU07	P156
DU08	130	42750	200000	5357500	IU08	P157
DU09	15	202500	0	3037500	IU09	P158
DU10	32	166500	0	5328000	IU10	P159
DU11	65	94500	120000	6022500	IU11	P160
DU12	40	76500	0	3060000	IU12	P161
DU13	12	324000	0	3888000	IU13	P162
DU14	90	36000	80000	3160000	IU14	P163
DU15	30	67500	0	2025000	IU15	P164
DU16	20	180000	0	3600000	IU16	P165
DU17	25	171000	100000	4175000	IU17	P166
DU18	110	41400	0	4554000	IU18	P167
DU19	18	85500	0	1539000	IU19	P168
DU20	60	45000	50000	2650000	IU20	P169
DU21	10	216000	0	2160000	IU21	P170
DU22	30	157500	0	4725000	IU22	P171
DU23	50	81000	80000	3970000	IU23	P172
DU24	70	99000	0	6930000	IU24	P173
DU25	14	310500	0	4347000	IU25	P174
DU26	100	58500	180000	5670000	IU26	P175
DU27	22	63000	0	1386000	IU27	P176
DU28	80	225000	0	18000000	IU28	P177
DU29	30	31500	30000	915000	IU29	P178
DU30	16	40500	0	648000	IU30	P179
DU31	40	139500	0	5580000	IU31	P180
DU32	55	90000	100000	4850000	IU32	P181
DU33	90	81000	0	7290000	IU33	P182
DU34	10	261000	0	2610000	IU34	P183
DU35	60	45000	80000	2620000	IU35	P184
DU36	25	58500	0	1462500	IU36	P185
DU37	120	42750	0	5130000	IU37	P186
DU38	20	189000	100000	3680000	IU38	P187
DU39	12	162000	0	1944000	IU39	P188
DU40	30	103500	0	3105000	IU40	P189
DU41	50	85500	90000	4185000	IU41	P190
DU42	70	301500	0	21105000	IU42	P191
DU43	8	67500	0	540000	IU43	P192
DU44	100	60750	150000	5925000	IU44	P193
DU45	40	51750	0	2070000	IU45	P194
DU46	20	108000	0	2160000	IU46	P195
DU47	35	99000	60000	3405000	IU47	P196
DU48	15	130500	0	1957500	IU48	P197
DU49	28	81000	0	2268000	IU49	P198
DU50	90	112500	200000	9925000	IU50	P199
DV01	10	40500	0	405000	IV01	P200
DV02	45	81000	50000	3595000	IV02	P201
DV03	60	36000	0	2160000	IV03	P202
DV04	20	90000	0	1800000	IV04	P203
DV05	80	33750	100000	2600000	IV05	P204
DV06	50	234000	0	11700000	IV06	P205
DV07	28	60750	0	1701000	IV07	P206
DV08	130	45000	150000	5700000	IV08	P207
DV09	15	175500	0	2632500	IV09	P208
DV10	32	153000	0	4896000	IV10	P209
DV11	65	114750	100000	7358750	IV11	P210
DV12	40	81000	0	3240000	IV12	P211
DV13	12	315000	0	3780000	IV13	P212
DV14	90	38250	70000	3372500	IV14	P213
DV15	30	69750	0	2092500	IV15	P214
DV16	20	175500	0	3510000	IV16	P215
DV17	25	175500	90000	4297500	IV17	P216
DV18	110	44100	0	4851000	IV18	P217
DV19	18	78750	0	1417500	IV19	P218
DV20	60	40500	45000	2385000	IV20	P219
DV21	10	171000	0	1710000	IV21	P220
DV22	30	166500	0	4995000	IV22	P221
DV23	50	108000	90000	5310000	IV23	P222
DV24	70	94500	0	6615000	IV24	P223
DV25	14	328500	0	4599000	IV25	P224
DV26	100	56250	170000	5455000	IV26	P225
DV27	22	74250	0	1633500	IV27	P226
DV28	80	54000	0	4320000	IV28	P227
DV29	30	114750	60000	3382500	IV29	P228
DV30	16	103500	0	1656000	IV30	P229
DV31	40	148500	0	5940000	IV31	P230
DV32	55	119250	120000	6438750	IV32	P231
DV33	90	87750	0	7897500	IV33	P232
DV34	10	270000	0	2700000	IV34	P233
DV35	60	36000	70000	2090000	IV35	P234
DV36	25	27000	0	675000	IV36	P235
DV37	120	85500	0	10260000	IV37	P236
DV38	20	49500	25000	965000	IV38	P237
DV39	12	83250	0	999000	IV39	P238
DV40	30	51750	0	1552500	IV40	P239
DV41	50	247500	200000	12175000	IV41	P240
DV42	70	202500	0	14175000	IV42	P241
DV43	8	99000	0	792000	IV43	P242
DV44	100	135000	250000	13250000	IV44	P243
DV45	40	540000	0	21600000	IV45	P244
DV46	20	65250	0	1305000	IV46	P245
DV47	35	90000	50000	3100000	IV47	P246
DV48	15	45000	0	675000	IV48	P247
DV49	28	144000	0	4032000	IV49	P248
DV50	90	87750	180000	7717500	IV50	P249
DW01	10	157500	0	1575000	IW01	P250
DW02	45	121500	80000	5387500	IW02	P251
DW03	60	90000	0	5400000	IW03	P252
DW04	20	279000	0	5580000	IW04	P253
DW05	80	38250	100000	2960000	IW05	P254
DW06	50	189000	0	9450000	IW06	P255
DW07	28	69750	0	1953000	IW07	P256
DW08	130	63000	180000	8010000	IW08	P257
DW09	15	180000	0	2700000	IW09	P258
DW10	32	85500	0	2736000	IW10	P259
DW11	65	49500	90000	3127500	IW11	P260
DW12	40	148500	0	5940000	IW12	P261
DW13	12	112500	0	1350000	IW13	P262
DW14	90	283500	400000	25115000	IW14	P263
DW15	30	36000	0	1080000	IW15	P264
DW16	20	157500	0	3150000	IW16	P265
DW17	25	180000	100000	4400000	IW17	P266
DW18	110	67500	0	7425000	IW18	P267
DW19	18	85500	0	1539000	IW19	P268
DW20	60	49500	50000	2920000	IW20	P269
DW21	10	148500	0	1485000	IW21	P270
DW22	30	112500	0	3375000	IW22	P271
DW23	50	283500	200000	13975000	IW23	P272
DW24	70	36000	0	2520000	IW24	P273
DW25	14	157500	0	2205000	IW25	P274
DW26	100	180000	300000	17700000	IW26	P275
DW27	22	67500	0	1485000	IW27	P276
DW28	80	85500	0	6840000	IW28	P277
DW29	30	49500	40000	1445000	IW29	P278
DW30	16	148500	0	2376000	IW30	P279
DW31	40	112500	0	4500000	IW31	P280
DW32	55	283500	150000	15442500	IW32	P281
DW33	90	36000	0	3240000	IW33	P282
DW34	10	157500	0	1575000	IW34	P283
DW35	60	180000	100000	10700000	IW35	P284
DW36	25	67500	0	1687500	IW36	P285
DW37	120	85500	0	10260000	IW37	P286
DW38	20	49500	30000	960000	IW38	P287
DW39	12	148500	0	1782000	IW39	P288
DW40	30	112500	0	3375000	IW40	P289
DW41	50	283500	200000	13975000	IW41	P290
DW42	70	36000	0	2520000	IW42	P291
DW43	8	157500	0	1260000	IW43	P292
DW44	100	180000	300000	17700000	IW44	P293
DW45	40	67500	0	2700000	IW45	P294
DW46	20	85500	0	1710000	IW46	P295
DW47	35	49500	40000	1692500	IW47	P296
DW48	15	148500	0	2227500	IW48	P297
DW49	28	112500	0	3150000	IW49	P298
DW50	90	283500	200000	25315000	IW50	P299
DY01	15	85500	0	1282500	IW51	P400
DY02	28	49500	0	1386000	IW52	P401
DY03	90	148500	200000	13165000	IW53	P402
DY04	10	112500	0	1125000	IW54	P403
DY05	60	283500	0	17010000	IW55	P404
DY06	25	36000	30000	870000	IW56	P405
DY07	120	157500	0	18900000	IW57	P406
DY08	20	180000	0	3600000	IW58	P407
DY09	12	67500	15000	795000	IW59	P408
DY10	30	85500	0	2565000	IW60	P409
DY11	50	49500	0	2475000	IW61	P410
DY12	70	148500	180000	10215000	IW62	P411
DY13	8	112500	0	900000	IW63	P412
DY14	100	283500	0	28350000	IW64	P413
DY15	40	36000	40000	1400000	IW65	P414
DY16	20	157500	0	3150000	IW66	P415
DY17	35	180000	0	6300000	IW67	P416
DY18	15	67500	20000	992500	IW68	P417
DY19	28	85500	0	2394000	IW69	P418
DY20	90	49500	0	4455000	IW70	P419
DY21	10	148500	25000	1460000	IW71	P420
DY22	60	112500	0	6750000	IW72	P421
DY23	25	283500	0	7087500	IW73	P422
DY24	120	36000	8000	4312000	IW74	P423
DY25	20	157500	0	3150000	IW75	P424
DY26	12	180000	0	2160000	IW76	P425
DY27	30	67500	15000	2010000	IW77	P426
DY28	50	85500	0	4275000	IW78	P427
DY29	70	49500	0	3465000	IW79	P428
DY30	8	148500	20000	1168000	IW80	P429
DY31	100	112500	0	11250000	IW81	P430
DY32	40	283500	0	11340000	IW82	P431
DY33	20	36000	5000	715000	IW83	P432
DY34	35	157500	0	5512500	IW84	P433
DY35	15	180000	0	2700000	IW85	P434
DY36	28	67500	10000	1880000	IW86	P435
DY37	90	85500	0	7695000	IW87	P436
DY38	10	49500	0	495000	IW88	P437
DY39	60	148500	15000	8895000	IW89	P438
DY40	25	112500	0	2812500	IW90	P439
DY41	120	283500	0	34020000	IW91	P440
DY42	20	36000	4000	716000	IW92	P441
DY43	12	157500	0	1890000	IW93	P442
DY44	30	180000	0	5400000	IW94	P443
DY45	50	67500	8000	3367000	IW95	P444
DY46	70	85500	0	5985000	IW96	P445
DY47	8	49500	0	396000	IW97	P446
DY48	100	148500	20000	14830000	IW98	P447
DY49	40	112500	0	4500000	IW99	P448
DW51	70	162000	0	11340000	IW51	P300
DW52	8	108000	0	864000	IW52	P301
DW53	100	92250	180000	9045000	IW53	P302
DW54	40	306000	0	12240000	IW54	P303
DW55	20	38250	0	765000	IW55	P304
DW56	50	189000	150000	9300000	IW56	P305
DW57	70	69750	0	4882500	IW57	P306
DW58	25	63000	0	1575000	IW58	P307
DW59	130	175500	500000	22315000	IW59	P308
DW60	15	85500	0	1282500	IW60	P309
DW61	32	49500	0	1584000	IW61	P310
DW62	65	148500	200000	9452500	IW62	P311
DW63	40	112500	0	4500000	IW63	P312
DW64	12	283500	0	3402000	IW64	P313
DW65	90	36000	100000	3140000	IW65	P314
DW66	30	157500	0	4725000	IW66	P315
DW67	20	180000	0	3600000	IW67	P316
DW68	25	67500	40000	1647500	IW68	P317
DW69	110	85500	0	9405000	IW69	P318
DW70	18	49500	0	891000	IW70	P319
DW71	60	148500	120000	8790000	IW71	P320
DW72	10	112500	0	1125000	IW72	P321
DW73	30	283500	0	8505000	IW73	P322
DW74	50	36000	50000	1750000	IW74	P323
DW75	70	157500	0	11025000	IW75	P324
DW76	14	180000	0	2520000	IW76	P325
DW77	100	67500	150000	6600000	IW77	P326
DW78	22	85500	0	1881000	IW78	P327
DW79	80	49500	0	3960000	IW79	P328
DW80	30	148500	80000	4375000	IW80	P329
DW81	16	112500	0	1800000	IW81	P330
DW82	40	283500	0	11340000	IW82	P331
DW83	55	36000	40000	1940000	IW83	P332
DW84	90	157500	0	14175000	IW84	P333
DW85	10	180000	0	1800000	IW85	P334
DW86	60	67500	100000	3950000	IW86	P335
DW87	25	85500	0	2137500	IW87	P336
DW88	120	49500	0	5940000	IW88	P337
DW89	20	148500	30000	2940000	IW89	P338
DW90	12	112500	0	1350000	IW90	P339
DW91	30	283500	0	8505000	IW91	P340
DW92	50	36000	50000	1750000	IW92	P341
DW93	70	157500	0	11025000	IW93	P342
DW94	8	180000	0	1440000	IW94	P343
DW95	100	67500	150000	6600000	IW95	P344
DW96	40	85500	0	3420000	IW96	P345
DW97	20	49500	0	990000	IW97	P346
DW98	35	148500	40000	5157500	IW98	P347
DW99	15	112500	0	1687500	IW99	P348
DX01	28	283500	0	7938000	IX01	P349
DX02	90	36000	100000	3140000	IX02	P350
DX03	10	157500	0	1575000	IX03	P351
DX04	60	180000	0	10800000	IX04	P352
DX05	25	67500	30000	1657500	IX05	P353
DX06	120	85500	0	10260000	IX06	P354
DX07	20	49500	0	990000	IX07	P355
DX08	12	148500	20000	1762000	IX08	P356
DX09	30	112500	0	3375000	IX09	P357
DX10	50	283500	0	14175000	IX10	P358
DX11	70	36000	60000	2460000	IX11	P359
DX12	8	157500	0	1260000	IX12	P360
DX13	100	180000	0	18000000	IX13	P361
DX14	40	67500	50000	2650000	IX14	P362
DX15	20	85500	0	1710000	IX15	P363
DX16	35	49500	0	1732500	IX16	P364
DX17	15	148500	25000	2202500	IX17	P365
DX18	28	112500	0	3150000	IX18	P366
DX19	90	283500	0	25515000	IX19	P367
DX20	10	36000	10000	350000	IX20	P368
DX21	60	157500	0	9450000	IX21	P369
DX22	25	180000	0	4500000	IX22	P370
DX23	120	67500	180000	7920000	IX23	P371
DX24	20	85500	0	1710000	IX24	P372
DX25	12	49500	0	594000	IX25	P373
DX26	30	148500	35000	4420000	IX26	P374
DX27	50	112500	0	5625000	IX27	P375
DX28	70	283500	0	19845000	IX28	P376
DX29	8	36000	8000	280000	IX29	P377
DX30	100	157500	0	15750000	IX30	P378
DX31	40	180000	0	7200000	IX31	P379
DX32	20	67500	20000	1330000	IX32	P380
DX33	35	85500	0	2992500	IX33	P381
DX34	15	49500	0	742500	IX34	P382
DX35	28	148500	40000	4118000	IX35	P383
DX36	90	112500	0	10125000	IX36	P384
DX37	10	283500	0	2835000	IX37	P385
DX38	60	36000	6000	2154000	IX38	P386
DX39	25	157500	0	3937500	IX39	P387
DX40	120	180000	0	21600000	IX40	P388
DX41	20	67500	25000	1325000	IX41	P389
DX42	12	85500	0	1026000	IX42	P390
DX43	30	49500	0	1485000	IX43	P391
DX44	50	148500	45000	7380000	IX44	P392
DX45	70	112500	0	7875000	IX45	P393
DX46	8	283500	0	2268000	IX46	P394
DX47	100	36000	7000	3593000	IX47	P395
DX48	40	157500	0	6300000	IX48	P396
DX49	20	180000	0	3600000	IX49	P397
DX50	35	67500	30000	2332500	IX50	P398
DY50	20	283500	0	5670000	IX01	P449
DY51	35	36000	3000	1257000	IX02	P450
DY52	15	157500	0	2362500	IX03	P451
DY53	28	180000	0	5040000	IX04	P452
DY54	90	67500	12000	6063000	IX05	P453
DY55	10	85500	0	855000	IX06	P454
DY56	60	49500	0	2970000	IX07	P455
DY57	25	148500	22000	3690500	IX08	P456
DY58	120	112500	0	13500000	IX09	P457
DY59	20	283500	0	5670000	IX10	P458
DY60	12	36000	2500	429500	IX11	P459
DY61	30	157500	0	4725000	IX12	P460
DY62	50	180000	0	9000000	IX13	P461
DY63	70	67500	10000	4715000	IX14	P462
DY64	8	85500	0	684000	IX15	P463
DY65	100	49500	0	4950000	IX16	P464
DY66	40	148500	18000	5922000	IX17	P465
DY67	20	112500	0	2250000	IX18	P466
DY68	35	283500	0	9922500	IX19	P467
DY69	15	36000	1500	538500	IX20	P468
DY70	28	157500	0	4410000	IX21	P469
DY71	90	180000	0	16200000	IX22	P470
DY72	10	67500	5000	670000	IX23	P471
DY73	60	85500	0	5130000	IX24	P472
DY74	25	49500	0	1237500	IX25	P473
DY75	120	148500	25000	17795000	IX26	P474
DY76	20	112500	0	2250000	IX27	P475
DY77	12	283500	0	3402000	IX28	P476
DY78	30	36000	2000	1078000	IX29	P477
DY79	50	157500	0	7875000	IX30	P478
DY80	70	180000	0	12600000	IX31	P479
DY81	8	67500	4000	536000	IX32	P480
DY82	100	85500	0	8550000	IX33	P481
DY83	40	49500	0	1980000	IX34	P482
DY84	20	148500	20000	2950000	IX35	P483
DY85	35	112500	0	3937500	IX36	P484
DY86	15	283500	0	4252500	IX37	P485
DY87	28	36000	1000	1007000	IX38	P486
DY88	90	157500	0	14175000	IX39	P487
DY89	10	180000	0	1800000	IX40	P488
DY90	60	67500	3000	4047000	IX41	P489
DY91	25	85500	0	2137500	IX42	P490
DY92	120	49500	0	5940000	IX43	P491
DY93	20	148500	15000	2955000	IX44	P492
DY94	12	112500	0	1350000	IX45	P493
DY95	30	283500	0	8505000	IX46	P494
DY96	50	36000	1800	1798200	IX47	P495
DY97	70	157500	0	11025000	IX48	P496
DY98	8	180000	0	1440000	IX49	P497
DY99	100	67500	2000	6748000	IX50	P498
DZ00	40	85500	0	3420000	IX48	P498
DZ01	20	49500	0	990000	IX49	P499
DZ02	35	148500	10000	5187500	IX50	P500
\.


                                                                                                                                                                                                                                                                                                                                                                                           5128.dat                                                                                            0000600 0004000 0002000 00000122730 15014423351 0014254 0                                                                                                    ustar 00postgres                        postgres                        0000000 0000000                                                                                                                                                                        E001	Laura	Jimenez	15000000	CEO	\N
E002	Carlos	Restrepo	12000000	Director	\N
E003	Sofia	Gaviria	12000000	Director	\N
E004	Andres	Molina	10000000	Director	\N
E005	Camila	Vargas	10000000	Director	\N
E006	David	Lopera	8000000	Manager	\N
E007	Valentina	Perez	7500000	Manager	\N
E008	Santiago	Rojas	7000000	Manager	\N
E009	Mariana	Gomez	6500000	Manager	\N
E010	Juan	Lopez	6000000	Manager	\N
E011	Daniela	Martinez	5500000	Manager	\N
E012	Alejandro	Sanchez	5000000	Manager	\N
E013	Gabriela	Fernandez	4800000	Manager	\N
E014	Mateo	Garcia	4500000	Manager	\N
E015	Isabella	Gonzalez	4200000	Manager	\N
E016	Nicolas	Diaz	4000000	Specialist	\N
E017	Luciana	Ruiz	3800000	Coordinator	\N
E018	Emilio	Alvarez	3600000	Analyst	\N
E019	Julieta	Moreno	3500000	Designer	\N
E020	Tomas	Jimenez	3400000	HRBP	\N
E021	Antonia	Vargas	3300000	LogisticsSp	\N
E022	Felipe	Castro	3200000	NetworkAdm	\N
E023	Martina	Silva	3100000	Accountant	\N
E024	Joaquin	Torres	3000000	Buyer	\N
E025	Sara	Rojas	2800000	SalesLead	\N
E026	Martin	Herrera	2700000	ContentLead	\N
E027	Elena	Medina	2600000	Recruiter	\N
E028	Simon	Flores	2500000	HelpDeskSup	\N
E029	Olivia	Morales	2400000	StockLead	\N
E030	Maximiliano	Ortega	2300000	Auditor	\N
E031	Valeria	Guzman	7000000	Manager	E002
E032	Lucas	Navas	6800000	Manager	E002
E033	Renata	Campos	6500000	Manager	E003
E034	Bruno	Silva	6200000	Manager	E003
E035	Clara	Mendez	6000000	Manager	E004
E036	Hugo	Rios	5800000	Manager	E004
E037	Eva	Soto	5500000	Manager	E005
E038	Adrian	Vega	5300000	Manager	E005
E039	Sofia	Castro	4500000	Manager	E006
E040	Javier	Luna	4300000	Manager	E006
E041	Paula	Blanco	3500000	Coordinator	E007
E042	Ricardo	Marin	3400000	Coordinator	E007
E043	Laura	Acosta	3300000	DevLead	E008
E044	Mateo	Pinto	3200000	InfraLead	E008
E045	Catalina	Bravo	3100000	AccountantS	E009
E046	Esteban	Cortes	3000000	AccountantS	E009
E047	Victoria	Salas	2900000	BuyerJr	E010
E048	Ignacio	Leon	2800000	BuyerJr	E010
E049	Carolina	Velez	2500000	Sales	E011
E050	Andres	Mora	2400000	Cashier	E011
E051	Fernanda	Diaz	2500000	Sales	E011
E052	Roberto	Silva	2300000	MarketingEx	E012
E053	Manuela	Peña	2200000	SEOAnalyst	E012
E054	Samuel	Cordoba	2100000	HRAnalyst	E013
E055	Daniel	Ortiz	2000000	RecruiterJr	E013
E056	Camila	Guerrero	1900000	SupportTech	E014
E057	Luis	Hoyos	1900000	SupportTech	E014
E058	Ana	Quintana	1800000	WarehouseOp	E015
S059	Pedro	Zamora	1800000	WarehouseOp	E015
E059	Pedro	Zamora	1800000	WarehouseOp	E015
E060	Carmen	Nuñez	1700000	AdminAsist	E016
E061	David	Campos	2000000	Sales	E039
E062	Isabel	Reyes	1900000	Cashier	E039
E063	Miguel	Santos	2000000	Sales	E040
E064	Patricia	Parra	1900000	Cashier	E040
E065	Javier	Solarte	1800000	LogisticsAs	E041
E066	Elena	Barrios	1800000	LogisticsAs	E042
E067	Andres	Tapia	2800000	Developer	E043
E068	Camila	Urrutia	2800000	Developer	E043
E069	Santiago	Valencia	2700000	SysAdmin	E044
E070	Valentina	Zuleta	2600000	AccountantJ	E045
E071	Daniel	Abadia	2600000	AccountantJ	E046
E072	Gabriela	Bernal	2500000	PurchasingA	E047
E073	Ricardo	Casas	2500000	PurchasingA	E048
E074	Paula	Duarte	1800000	Sales	E025
E075	Alejandro	Estevez	1700000	Cashier	E025
E076	Natalia	Franco	2000000	ContentCrea	E026
E077	Martin	Giraldo	1900000	SocialMedia	E026
E078	Lucia	Henao	1800000	HRAsist	E020
E079	Fernando	Ibarra	1700000	SupportJr	E028
E080	Veronica	Jaramillo	1600000	StockAssist	E029
E081	Sergio	Klein	2000000	Sales	E011
E082	Andrea	Lugo	1900000	Cashier	E011
E083	Jorge	Marin	1800000	WarehouseOp	E015
E084	Adriana	Nieto	1800000	WarehouseOp	E015
E085	Alberto	Ocampo	2700000	Developer	E043
E086	Monica	Patiño	2600000	SysAdmin	E044
E087	Victor	Quintero	2500000	AccountantJ	E009
E088	Cristina	Ramirez	2400000	BuyerAsist	E010
E089	Raul	Saldarriaga	2100000	MarketingAs	E012
E090	Beatriz	Tamayo	2000000	HRAsist	E013
E091	Oscar	Useche	1800000	SupportTech	E014
E092	Silvia	Varela	1700000	AdminAsist	E003
E093	Jose	Yepes	2200000	ProdAnalyst	E031
E094	Rosa	Zuluaga	2100000	QualityInsp	E032
E095	Manuel	Arbelaez	2000000	TreasuryAs	E033
E096	Teresa	Benitez	1900000	FinPlanAs	E034
E097	Francisco	Cardenas	1800000	AdCreative	E035
E098	Gloria	Delgado	1700000	PRAssist	E036
E099	Antonio	Echeverri	1600000	WellnessAs	E037
E100	Angela	Fajardo	1500000	OrgDevAs	E038
E101	Diego	Galindo	1800000	Sales	E039
E102	Sandra	Gomez	1700000	Sales	E039
E103	Ana	Hurtado	1800000	Sales	E040
E104	Luis	Isaza	1700000	Sales	E040
E105	Maria	Jimenez	1700000	LogisticsOp	E041
E106	Carlos	Leon	1700000	Driver	E042
E107	Sofia	Mejia	2500000	DeveloperJr	E043
E108	Juan	Naranjo	2400000	InfraTech	E044
E109	Daniela	Orozco	1800000	EcomAsist	E017
E110	Alejandro	Palacio	1700000	DesignJr	E019
E111	Gabriela	Quiroga	1600000	LogisticsJr	E021
E112	Mateo	Rendon	1500000	NetworkJr	E022
E113	Isabella	Suarez	1400000	BuyerTraine	E024
E114	Nicolas	Toro	1800000	Sales	E011
E115	Luciana	Urrego	1700000	Cashier	E011
E116	Emilio	Vasco	1600000	WarehouseOp	E015
E117	Julieta	Zapata	1500000	MarketingJr	E012
E118	Tomas	Aguirre	1400000	HRIntern	E013
E119	Antonia	Blandon	1300000	SupportTrn	E014
E120	Felipe	Cifuentes	1800000	Sales	E039
E121	Martina	Davila	1700000	Cashier	E039
E122	Joaquin	Escudero	1800000	Sales	E040
E123	Sara	Franco	1700000	Cashier	E040
E124	Martin	Giraldo	1600000	LogisticsOp	E041
E125	Elena	Hincapie	1600000	Driver	E042
E126	Simon	Jaramillo	2300000	DeveloperJr	E043
E127	Olivia	Koppel	2200000	InfraTech	E044
E128	Maximiliano	Lopez	2000000	AccountantJ	E045
E129	Valeria	Maldonado	1900000	PurchasingA	E047
E130	Lucas	Narvaez	1800000	Sales	E025
E231	Hugo	Aguilar	1700000	Cashier	E011
E232	Eva	Baron	1600000	WarehouseOp	E015
E233	Adrian	Celis	1800000	MarketingJr	E012
E234	Sofia	Delgado	1700000	HRAsist	E013
E235	Javier	Estevez	1600000	SupportTech	E014
E236	Paula	Fonseca	2000000	ProdAnalyst	E031
E237	Ricardo	Galeano	1900000	QualityInsp	E032
E238	Laura	Hoyos	1800000	TreasuryAs	E033
E239	Mateo	Ibarra	1700000	FinPlanAs	E034
E240	Catalina	Jaimes	1600000	AdCreative	E035
E241	Esteban	Lara	1500000	PRAssist	E036
E242	Victoria	Mendez	1400000	WellnessAs	E037
E243	Ignacio	Naranjo	1300000	OrgDevAs	E038
E244	Carolina	Ochoa	1800000	Sales	E039
E245	Andres	Paez	1700000	Cashier	E039
E246	Fernanda	Quiroz	1800000	Sales	E040
E247	Roberto	Riascos	1700000	Cashier	E040
E248	Manuela	Sarmiento	1600000	LogisticsOp	E041
E249	Samuel	Tovar	1600000	Driver	E042
E250	Daniel	Urena	2100000	DeveloperJr	E043
E251	Camila	Vargas	2000000	InfraTech	E044
E252	Luis	Yepes	1900000	AccountantJ	E045
E253	Ana	Zamudio	1800000	AccountantJ	E046
E254	Pedro	Alarcon	1700000	PurchasingA	E047
E255	Carmen	Bermudez	1700000	PurchasingA	E048
E256	David	Cabrera	1600000	Sales	E049
E257	Isabel	Duarte	1500000	MarketingJr	E052
E258	Miguel	Florez	1400000	HRAsist	E020
E259	Patricia	Giraldo	1300000	SupportJr	E028
E260	Javier	Hurtado	1200000	StockAssist	E029
E261	Elena	Leon	1800000	Sales	E011
E262	Andres	Manrique	1700000	Cashier	E011
E263	Camila	Norena	1600000	WarehouseOp	E015
E264	Santiago	Ospina	1800000	MarketingJr	E012
E265	Valentina	Pardo	1700000	HRAsist	E013
E266	Daniel	Quiceno	1600000	SupportTech	E014
E267	Gabriela	Ramirez	2000000	ProdAnalyst	E031
E268	Ricardo	Saldarriaga	1900000	QualityInsp	E032
E269	Paula	Tamayo	1800000	TreasuryAs	E033
E270	Alejandro	Useche	1700000	FinPlanAs	E034
E271	Natalia	Varela	1600000	AdCreative	E035
E272	Martin	Yepes	1500000	PRAssist	E036
E273	Lucia	Zamudio	1400000	WellnessAs	E037
E274	Fernando	Aguilar	1300000	OrgDevAs	E038
E275	Veronica	Baron	1800000	Sales	E039
E276	Sergio	Celis	1700000	Cashier	E039
E277	Andrea	Delgado	1800000	Sales	E040
E278	Jorge	Estevez	1700000	Cashier	E040
E279	Adriana	Fonseca	1600000	LogisticsOp	E041
E280	Alberto	Galeano	1600000	Driver	E042
E281	Monica	Hoyos	2000000	DeveloperJr	E043
E282	Victor	Ibarra	1900000	InfraTech	E044
E283	Cristina	Jaimes	1800000	AccountantJ	E045
E284	Raul	Lara	1700000	AccountantJ	E046
E285	Beatriz	Mendez	1600000	PurchasingA	E047
E286	Oscar	Naranjo	1600000	PurchasingA	E048
E287	Silvia	Ochoa	1500000	Sales	E049
E288	Jose	Paez	1400000	MarketingJr	E052
E289	Rosa	Quiroz	1300000	HRAsist	E020
E290	Manuel	Riascos	1200000	SupportJr	E028
E291	Teresa	Sarmiento	1700000	StockAssist	E029
E292	Francisco	Tovar	1800000	Sales	E011
E293	Gloria	Urena	1700000	Cashier	E011
E294	Antonio	Vargas	1600000	WarehouseOp	E015
E295	Angela	Yepes	1800000	MarketingJr	E012
E296	Diego	Zamudio	1700000	HRAsist	E013
E297	Sandra	Alarcon	1600000	SupportTech	E014
E298	Ana	Bermudez	2000000	ProdAnalyst	E031
E299	Luis	Cabrera	1900000	QualityInsp	E032
E300	Maria	Duarte	1800000	TreasuryAs	E033
E301	Carlos	Florez	1700000	FinPlanAs	E034
E302	Sofia	Giraldo	1600000	AdCreative	E035
E303	Juan	Hurtado	1500000	PRAssist	E036
E304	Daniela	Leon	1400000	WellnessAs	E037
E305	Alejandro	Manrique	1300000	OrgDevAs	E038
E306	Gabriela	Norena	1800000	Sales	E039
E307	Mateo	Ospina	1700000	Cashier	E039
E308	Isabella	Pardo	1800000	Sales	E040
E309	Nicolas	Quiceno	1700000	Cashier	E040
E310	Luciana	Ramirez	1600000	LogisticsOp	E041
E311	Emilio	Saldarriaga	1600000	Driver	E042
E312	Julieta	Tamayo	1900000	DeveloperJr	E043
E313	Tomas	Useche	1800000	InfraTech	E044
E314	Antonia	Varela	1700000	AccountantJ	E045
E315	Felipe	Yepes	1600000	AccountantJ	E046
E316	Martina	Zamudio	1500000	PurchasingA	E047
E317	Joaquin	Alarcon	1500000	PurchasingA	E048
E318	Sara	Bermudez	1400000	Sales	E049
E319	Martin	Cabrera	1300000	MarketingJr	E052
E320	Elena	Duarte	1700000	HRAsist	E020
E321	Simon	Florez	1600000	SupportJr	E028
E322	Olivia	Giraldo	1500000	StockAssist	E029
E323	Maximiliano	Hurtado	1800000	Sales	E011
E324	Valeria	Leon	1700000	Cashier	E011
E325	Lucas	Manrique	1600000	WarehouseOp	E015
E326	Renata	Norena	1800000	MarketingJr	E012
E327	Bruno	Ospina	1700000	HRAsist	E013
E328	Clara	Pardo	1600000	SupportTech	E014
E329	Hugo	Quiceno	2000000	ProdAnalyst	E031
E330	Eva	Ramirez	1900000	QualityInsp	E032
E688	Diego	Pardo	1800000	MarketingJr	E012
E331	Adrian	Saldarriaga	1800000	TreasuryAs	E033
E332	Sofia	Tamayo	1700000	FinPlanAs	E034
E333	Javier	Useche	1600000	AdCreative	E035
E334	Paula	Varela	1500000	PRAssist	E036
E335	Ricardo	Yepes	1400000	WellnessAs	E037
E336	Laura	Zamudio	1300000	OrgDevAs	E038
E337	Mateo	Alarcon	1800000	Sales	E039
E338	Catalina	Bermudez	1700000	Cashier	E039
E339	Esteban	Cabrera	1800000	Sales	E040
E340	Victoria	Duarte	1700000	Cashier	E040
E341	Ignacio	Florez	1600000	LogisticsOp	E041
E342	Carolina	Giraldo	1600000	Driver	E042
E343	Andres	Hurtado	1800000	DeveloperJr	E043
E344	Fernanda	Leon	1700000	InfraTech	E044
E345	Roberto	Manrique	1600000	AccountantJ	E045
E346	Manuela	Norena	1500000	AccountantJ	E046
E347	Samuel	Ospina	1400000	PurchasingA	E047
E348	Daniel	Pardo	1400000	PurchasingA	E048
E349	Camila	Quiceno	1300000	Sales	E049
E350	Luis	Ramirez	1200000	MarketingJr	E052
E351	Ana	Saldarriaga	1700000	HRAsist	E020
E352	Pedro	Tamayo	1600000	SupportJr	E028
E353	Carmen	Useche	1500000	StockAssist	E029
E354	David	Varela	1800000	Sales	E011
E355	Isabel	Yepes	1700000	Cashier	E011
E356	Miguel	Zamudio	1600000	WarehouseOp	E015
E357	Patricia	Alarcon	1800000	MarketingJr	E012
E358	Javier	Bermudez	1700000	HRAsist	E013
E359	Elena	Cabrera	1600000	SupportTech	E014
E360	Andres	Duarte	2000000	ProdAnalyst	E031
E361	Camila	Florez	1900000	QualityInsp	E032
E362	Santiago	Giraldo	1800000	TreasuryAs	E033
E363	Valentina	Hurtado	1700000	FinPlanAs	E034
E364	Daniel	Leon	1600000	AdCreative	E035
E365	Gabriela	Manrique	1500000	PRAssist	E036
E366	Ricardo	Norena	1400000	WellnessAs	E037
E367	Paula	Ospina	1300000	OrgDevAs	E038
E368	Alejandro	Pardo	1800000	Sales	E039
E369	Natalia	Quiceno	1700000	Cashier	E039
E370	Martin	Ramirez	1800000	Sales	E040
E371	Lucia	Saldarriaga	1700000	Cashier	E040
E372	Fernando	Tamayo	1600000	LogisticsOp	E041
E373	Veronica	Useche	1600000	Driver	E042
E374	Sergio	Varela	1700000	DeveloperJr	E043
E375	Andrea	Yepes	1600000	InfraTech	E044
E376	Jorge	Zamudio	1500000	AccountantJ	E045
E377	Adriana	Alarcon	1400000	AccountantJ	E046
E378	Alberto	Bermudez	1300000	PurchasingA	E047
E379	Monica	Cabrera	1300000	PurchasingA	E048
E380	Victor	Duarte	1200000	Sales	E049
E381	Cristina	Florez	1100000	MarketingJr	E052
E382	Raul	Giraldo	1700000	HRAsist	E020
E383	Beatriz	Hurtado	1600000	SupportJr	E028
E384	Oscar	Leon	1500000	StockAssist	E029
E385	Silvia	Manrique	1800000	Sales	E011
E386	Jose	Norena	1700000	Cashier	E011
E387	Rosa	Ospina	1600000	WarehouseOp	E015
E388	Manuel	Pardo	1800000	MarketingJr	E012
E389	Teresa	Quiceno	1700000	HRAsist	E013
E390	Francisco	Ramirez	1600000	SupportTech	E014
E391	Gloria	Saldarriaga	2000000	ProdAnalyst	E031
E392	Antonio	Tamayo	1900000	QualityInsp	E032
E393	Angela	Useche	1800000	TreasuryAs	E033
E394	Diego	Varela	1700000	FinPlanAs	E034
E395	Sandra	Yepes	1600000	AdCreative	E035
E396	Ana	Zamudio	1500000	PRAssist	E036
E397	Luis	Alarcon	1400000	WellnessAs	E037
E398	Maria	Bermudez	1300000	OrgDevAs	E038
E399	Carlos	Cabrera	1800000	Sales	E039
E400	Sofia	Duarte	1700000	Cashier	E039
E401	Juan	Florez	1800000	Sales	E040
E402	Daniela	Giraldo	1700000	Cashier	E040
E403	Alejandro	Hurtado	1600000	LogisticsOp	E041
E404	Gabriela	Leon	1600000	Driver	E042
E405	Mateo	Manrique	1600000	DeveloperJr	E043
E406	Isabella	Norena	1500000	InfraTech	E044
E407	Nicolas	Ospina	1400000	AccountantJ	E045
E408	Luciana	Pardo	1300000	AccountantJ	E046
E409	Emilio	Quiceno	1200000	PurchasingA	E047
E410	Julieta	Ramirez	1200000	PurchasingA	E048
E411	Tomas	Saldarriaga	1100000	Sales	E049
E412	Antonia	Tamayo	1000000	MarketingJr	E052
E413	Felipe	Useche	1700000	HRAsist	E020
E414	Martina	Varela	1600000	SupportJr	E028
E415	Joaquin	Yepes	1500000	StockAssist	E029
E416	Sara	Zamudio	1800000	Sales	E011
E417	Martin	Alarcon	1700000	Cashier	E011
E418	Elena	Bermudez	1600000	WarehouseOp	E015
E419	Simon	Cabrera	1800000	MarketingJr	E012
E420	Olivia	Duarte	1700000	HRAsist	E013
E421	Maximiliano	Florez	1600000	SupportTech	E014
E422	Valeria	Giraldo	2000000	ProdAnalyst	E031
E423	Lucas	Hurtado	1900000	QualityInsp	E032
E424	Renata	Leon	1800000	TreasuryAs	E033
E425	Bruno	Manrique	1700000	FinPlanAs	E034
E426	Clara	Norena	1600000	AdCreative	E035
E427	Hugo	Ospina	1500000	PRAssist	E036
E428	Eva	Pardo	1400000	WellnessAs	E037
E429	Adrian	Quiceno	1300000	OrgDevAs	E038
E430	Sofia	Ramirez	1800000	Sales	E039
E431	Javier	Saldarriaga	1700000	Cashier	E039
E432	Paula	Tamayo	1800000	Sales	E040
E433	Ricardo	Useche	1700000	Cashier	E040
E434	Laura	Varela	1600000	LogisticsOp	E041
E435	Mateo	Yepes	1600000	Driver	E042
E436	Catalina	Zamudio	1500000	DeveloperJr	E043
E437	Esteban	Alarcon	1400000	InfraTech	E044
E438	Victoria	Bermudez	1300000	AccountantJ	E045
E439	Ignacio	Cabrera	1200000	AccountantJ	E046
E440	Carolina	Duarte	1100000	PurchasingA	E047
E441	Andres	Florez	1100000	PurchasingA	E048
E442	Fernanda	Giraldo	1000000	Sales	E049
E443	Roberto	Hurtado	1000000	MarketingJr	E052
E444	Manuela	Leon	1700000	HRAsist	E020
E445	Samuel	Manrique	1600000	SupportJr	E028
E446	Daniel	Norena	1500000	StockAssist	E029
E447	Camila	Ospina	1800000	Sales	E011
E448	Luis	Pardo	1700000	Cashier	E011
E449	Ana	Quiceno	1600000	WarehouseOp	E015
E450	Pedro	Ramirez	1800000	MarketingJr	E012
E451	Carmen	Saldarriaga	1700000	HRAsist	E013
E452	David	Tamayo	1600000	SupportTech	E014
E453	Isabel	Useche	2000000	ProdAnalyst	E031
E454	Miguel	Varela	1900000	QualityInsp	E032
E455	Patricia	Yepes	1800000	TreasuryAs	E033
E456	Javier	Zamudio	1700000	FinPlanAs	E034
E457	Elena	Alarcon	1600000	AdCreative	E035
E458	Andres	Bermudez	1500000	PRAssist	E036
E459	Camila	Cabrera	1400000	WellnessAs	E037
E460	Santiago	Duarte	1300000	OrgDevAs	E038
E461	Valentina	Florez	1800000	Sales	E039
E462	Daniel	Giraldo	1700000	Cashier	E039
E463	Gabriela	Hurtado	1800000	Sales	E040
E464	Ricardo	Leon	1700000	Cashier	E040
E465	Paula	Manrique	1600000	LogisticsOp	E041
E466	Alejandro	Norena	1600000	Driver	E042
E467	Natalia	Ospina	1400000	DeveloperJr	E043
E468	Martin	Pardo	1300000	InfraTech	E044
E469	Lucia	Quiceno	1200000	AccountantJ	E045
E470	Fernando	Ramirez	1100000	AccountantJ	E046
E471	Veronica	Saldarriaga	1000000	PurchasingA	E047
E472	Sergio	Tamayo	1000000	PurchasingA	E048
E473	Andrea	Useche	1700000	Sales	E049
E474	Jorge	Varela	1600000	MarketingJr	E052
E475	Adriana	Yepes	1500000	HRAsist	E020
E476	Alberto	Zamudio	1400000	SupportJr	E028
E477	Monica	Alarcon	1300000	StockAssist	E029
E478	Victor	Bermudez	1800000	Sales	E011
E479	Cristina	Cabrera	1700000	Cashier	E011
E480	Raul	Duarte	1600000	WarehouseOp	E015
E481	Beatriz	Florez	1800000	MarketingJr	E012
E482	Oscar	Giraldo	1700000	HRAsist	E013
E483	Silvia	Hurtado	1600000	SupportTech	E014
E484	Jose	Leon	2000000	ProdAnalyst	E031
E485	Rosa	Manrique	1900000	QualityInsp	E032
E486	Manuel	Norena	1800000	TreasuryAs	E033
E487	Teresa	Ospina	1700000	FinPlanAs	E034
E488	Francisco	Pardo	1600000	AdCreative	E035
E489	Gloria	Quiceno	1500000	PRAssist	E036
E490	Antonio	Ramirez	1400000	WellnessAs	E037
E491	Angela	Saldarriaga	1300000	OrgDevAs	E038
E492	Diego	Tamayo	1800000	Sales	E039
E493	Sandra	Useche	1700000	Cashier	E039
E494	Ana	Varela	1800000	Sales	E040
E495	Luis	Yepes	1700000	Cashier	E040
E496	Maria	Zamudio	1600000	LogisticsOp	E041
E497	Carlos	Alarcon	1500000	EcomAsist	E109
E498	Sofia	Bermudez	1400000	DesignJr	E110
E499	Juan	Cabrera	1300000	LogisticsJr	E021
E500	Daniela	Duarte	1200000	NetworkJr	E022
E131	Renata	Osorio	1700000	EcomSupport	E017
E132	Bruno	Pabon	1600000	BIJrAnalyst	E018
E133	Clara	Quiceno	1500000	DesignAsist	E019
E134	Hugo	Ramirez	1400000	HRIntern	E020
E135	Eva	Salazar	1300000	LogisticsTr	E021
E136	Adrian	Tellez	1200000	NetworkTrn	E022
E137	Sofia	Upegui	1900000	AccountJrAs	E023
E138	Javier	Valbuena	1800000	BuyerAsist	E024
E139	Paula	Wills	1700000	Sales	E025
E140	Ricardo	Ximenez	1600000	ContentJr	E026
E141	Laura	Yanez	1500000	RecruitAsis	E027
E142	Mateo	Zambrano	1400000	HelpDeskAs	E028
E143	Catalina	Aristizabal	1300000	StockIntern	E029
E144	Esteban	Botero	2000000	Sales	E011
E145	Victoria	Cabrera	1900000	Cashier	E011
E146	Ignacio	Dominguez	1800000	WarehouseOp	E015
E147	Carolina	Espinosa	1700000	MarketingJr	E012
E148	Andres	Ferrer	1600000	HRAsist	E013
E149	Fernanda	Garcia	1500000	SupportTech	E014
E150	Roberto	Herrera	2200000	ProdAnalyst	E031
E151	Manuela	Iglesias	2100000	QualityInsp	E032
E152	Samuel	Jaramillo	2000000	TreasuryAs	E033
E153	Daniel	Kattan	1900000	FinPlanAs	E034
E154	Camila	Linares	1800000	AdCreative	E035
E155	Luis	Montoya	1700000	PRAssist	E036
E156	Ana	Noreña	1600000	WellnessAs	E037
E157	Pedro	Olaya	1500000	OrgDevAs	E038
E158	David	Pachon	1800000	Sales	E049
E159	Isabel	Quesada	1800000	Sales	E049
E160	Miguel	Ricaurte	1700000	MarketingJr	E052
E161	Patricia	Suescun	1700000	MarketingJr	E052
E162	Javier	Torrado	1700000	Sales	E039
E163	Elena	Umaña	1600000	Cashier	E039
E164	Andres	Villegas	1700000	Sales	E040
E165	Camila	Yepes	1600000	Cashier	E040
E166	Santiago	Zabala	2600000	Developer	E043
E167	Valentina	Alarcon	2500000	Developer	E043
E168	Daniel	Becerra	2400000	SysAdmin	E044
E169	Gabriela	Correa	2300000	SysAdmin	E044
E170	Ricardo	Daza	2200000	AccountantJ	E045
E171	Paula	Escobar	2200000	AccountantJ	E045
E172	Alejandro	Fajardo	2100000	AccountantJ	E046
E173	Natalia	Giraldo	2100000	AccountantJ	E046
E174	Martin	Hoyos	2000000	BuyerAsist	E047
E175	Lucia	Iregui	2000000	BuyerAsist	E047
E176	Fernando	Jimenez	1900000	BuyerAsist	E048
E177	Veronica	Lara	1900000	BuyerAsist	E048
E178	Sergio	Moncada	1800000	Sales	E011
E179	Andrea	Noguera	1700000	WarehouseOp	E015
E180	Jorge	Ospina	2000000	DeveloperJr	E008
E181	Adriana	Pardo	2500000	Sales	E039
E182	Alberto	Quintero	2400000	Cashier	E039
E183	Monica	Roldan	2500000	Sales	E040
E184	Victor	Saenz	2400000	Cashier	E040
E185	Cristina	Tovar	2000000	LogisticsOp	E041
E186	Raul	Urbina	1900000	Driver	E042
E187	Beatriz	Velez	2800000	Developer	E043
E188	Oscar	Yanez	2700000	SysAdmin	E044
E189	Silvia	Zorrilla	1700000	EcomAsist	E109
E190	Jose	Almanza	1700000	EcomAsist	E109
E191	Rosa	Beltran	1600000	DesignJr	E110
E192	Manuel	Cifuentes	1600000	DesignJr	E110
E193	Teresa	Dorado	3000000	Supervisor	E006
E194	Francisco	Espejo	2800000	Supervisor	E007
E195	Gloria	Florez	2700000	Coordinator	E008
E196	Antonio	Gaitan	2600000	AnalystSr	E009
E197	Angela	Henriquez	2500000	AnalystSr	E010
E198	Diego	Iriarte	1800000	Sales	E011
E199	Sandra	Joya	1700000	Cashier	E011
E200	Ana	Lizarazo	1600000	WarehouseOp	E015
E201	Luis	Macea	1800000	MarketingJr	E012
E202	Maria	Novoa	1700000	HRAsist	E013
E203	Carlos	Pineda	1600000	SupportTech	E014
E204	Sofia	Quijano	2000000	ProdAnalyst	E031
E205	Juan	Ramos	1900000	QualityInsp	E032
E206	Daniela	Saldana	1800000	TreasuryAs	E033
E207	Alejandro	Trujillo	1700000	FinPlanAs	E034
E208	Gabriela	Ulloa	1600000	AdCreative	E035
E209	Mateo	Valderrama	1500000	PRAssist	E036
E210	Isabella	Yepes	1400000	WellnessAs	E037
E211	Nicolas	Zea	1300000	OrgDevAs	E038
E212	Luciana	Arias	1800000	Sales	E039
E213	Emilio	Bustamante	1700000	Cashier	E039
E214	Julieta	Castellanos	1800000	Sales	E040
E215	Tomas	Duran	1700000	Cashier	E040
E216	Antonia	Figueroa	1600000	LogisticsOp	E041
E217	Felipe	Guarin	1600000	Driver	E042
E218	Martina	Holguin	2200000	DeveloperJr	E043
E219	Joaquin	Lasso	2100000	InfraTech	E044
E220	Sara	Manrique	2000000	AccountantJ	E045
E221	Martin	Nieto	1900000	AccountantJ	E046
E222	Elena	Orozco	1800000	PurchasingA	E047
E223	Simon	Pardo	1800000	PurchasingA	E048
E224	Olivia	Quiñones	1700000	Sales	E049
E225	Maximiliano	Rincon	1600000	MarketingJr	E052
E226	Valeria	Salcedo	1500000	HRAsist	E020
E227	Lucas	Tafur	1400000	SupportJr	E028
E228	Renata	Uribe	1300000	StockAssist	E029
E229	Bruno	Vallejo	1200000	AuditorJr	E030
E230	Clara	Zapata	1800000	Sales	E011
E501	Alejandro	Florez	1800000	Sales	E011
E502	Gabriela	Giraldo	1700000	Cashier	E011
E503	Mateo	Hurtado	1600000	WarehouseOp	E015
E504	Isabella	Leon	1800000	MarketingJr	E012
E505	Nicolas	Manrique	1700000	HRAsist	E013
E506	Luciana	Norena	1600000	SupportTech	E014
E507	Emilio	Ospina	2000000	ProdAnalyst	E031
E508	Julieta	Pardo	1900000	QualityInsp	E032
E509	Tomas	Quiceno	1800000	TreasuryAs	E033
E510	Antonia	Ramirez	1700000	FinPlanAs	E034
E511	Felipe	Saldarriaga	1600000	AdCreative	E035
E512	Martina	Tamayo	1500000	PRAssist	E036
E513	Joaquin	Useche	1400000	WellnessAs	E037
E514	Sara	Varela	1300000	OrgDevAs	E038
E515	Martin	Yepes	1800000	Sales	E039
E516	Elena	Zamudio	1700000	Cashier	E039
E517	Simon	Alarcon	1800000	Sales	E040
E518	Olivia	Bermudez	1700000	Cashier	E040
E519	Maximiliano	Cabrera	1600000	LogisticsOp	E041
E520	Valeria	Duarte	1600000	Driver	E042
E521	Lucas	Florez	1400000	DeveloperJr	E043
E522	Renata	Giraldo	1300000	InfraTech	E044
E523	Bruno	Hurtado	1200000	AccountantJ	E045
E524	Clara	Leon	1100000	AccountantJ	E046
E525	Hugo	Manrique	1000000	PurchasingA	E047
E526	Eva	Norena	1000000	PurchasingA	E048
E527	Adrian	Ospina	1700000	Sales	E049
E528	Sofia	Pardo	1600000	MarketingJr	E052
E529	Javier	Quiceno	1500000	HRAsist	E020
E530	Paula	Ramirez	1400000	SupportJr	E028
E531	Ricardo	Saldarriaga	1300000	StockAssist	E029
E532	Laura	Tamayo	1800000	Sales	E011
E533	Mateo	Useche	1700000	Cashier	E011
E534	Catalina	Varela	1600000	WarehouseOp	E015
E535	Esteban	Yepes	1800000	MarketingJr	E012
E536	Victoria	Zamudio	1700000	HRAsist	E013
E537	Ignacio	Alarcon	1600000	SupportTech	E014
E538	Carolina	Bermudez	2000000	ProdAnalyst	E031
E539	Andres	Cabrera	1900000	QualityInsp	E032
E540	Fernanda	Duarte	1800000	TreasuryAs	E033
E541	Roberto	Florez	1700000	FinPlanAs	E034
E542	Manuela	Giraldo	1600000	AdCreative	E035
E543	Samuel	Hurtado	1500000	PRAssist	E036
E544	Daniel	Leon	1400000	WellnessAs	E037
E545	Camila	Manrique	1300000	OrgDevAs	E038
E546	Luis	Norena	1800000	Sales	E039
E547	Ana	Ospina	1700000	Cashier	E039
E548	Pedro	Pardo	1800000	Sales	E040
E549	Carmen	Quiceno	1700000	Cashier	E040
E550	David	Ramirez	1600000	LogisticsOp	E041
E551	Isabel	Saldarriaga	1600000	Driver	E042
E552	Miguel	Tamayo	2200000	DeveloperSr	E043
E553	Patricia	Useche	2100000	InfraSr	E044
E554	Javier	Varela	2000000	AccSenior	E045
E555	Elena	Yepes	1900000	AccSenior	E046
E556	Andres	Zamudio	1800000	BuyerSr	E047
E557	Camila	Alarcon	1800000	BuyerSr	E048
E558	Santiago	Bermudez	1700000	Sales	E049
E559	Valentina	Cabrera	1600000	MarketingJr	E052
E560	Daniel	Duarte	1500000	HRAsist	E020
E561	Gabriela	Florez	1400000	SupportJr	E028
E562	Ricardo	Giraldo	1300000	StockAssist	E029
E563	Paula	Hurtado	1800000	Sales	E011
E564	Alejandro	Leon	1700000	Cashier	E011
E565	Natalia	Manrique	1600000	WarehouseOp	E015
E566	Martin	Norena	1800000	MarketingJr	E012
E567	Lucia	Ospina	1700000	HRAsist	E013
E568	Fernando	Pardo	1600000	SupportTech	E014
E569	Veronica	Quiceno	2000000	ProdAnalyst	E031
E570	Sergio	Ramirez	1900000	QualityInsp	E032
E571	Andrea	Saldarriaga	1800000	TreasuryAs	E033
E572	Jorge	Tamayo	1700000	FinPlanAs	E034
E573	Adriana	Useche	1600000	AdCreative	E035
E574	Alberto	Varela	1500000	PRAssist	E036
E575	Monica	Yepes	1400000	WellnessAs	E037
E576	Victor	Zamudio	1300000	OrgDevAs	E038
E577	Cristina	Alarcon	1800000	Sales	E039
E578	Raul	Bermudez	1700000	Cashier	E039
E579	Beatriz	Cabrera	1800000	Sales	E040
E580	Oscar	Duarte	1700000	Cashier	E040
E581	Silvia	Florez	1600000	LogisticsOp	E041
E582	Jose	Giraldo	1600000	Driver	E042
E583	Rosa	Hurtado	2300000	DeveloperSr	E043
E584	Manuel	Leon	2200000	InfraSr	E044
E585	Teresa	Manrique	2100000	AccSenior	E009
E586	Francisco	Norena	2000000	BuyerSr	E010
E587	Gloria	Ospina	1700000	Sales	E049
E588	Antonio	Pardo	1600000	MarketingJr	E052
E589	Angela	Quiceno	1500000	HRAsist	E013
E590	Diego	Ramirez	1400000	SupportJr	E014
E591	Sandra	Saldarriaga	1300000	StockAssist	E015
E592	Ana	Tamayo	1800000	Sales	E011
E593	Luis	Useche	1700000	Cashier	E011
E594	Maria	Varela	1600000	WarehouseOp	E015
E595	Carlos	Yepes	1800000	MarketingJr	E012
E596	Sofia	Zamudio	1700000	HRAsist	E020
E597	Juan	Alarcon	1600000	SupportTech	E028
E598	Daniela	Bermudez	1900000	ProdAnalyst	E031
E599	Alejandro	Cabrera	1800000	QualityInsp	E032
E600	Gabriela	Duarte	1700000	TreasuryAs	E033
E601	Mateo	Florez	1600000	FinPlanAs	E034
E602	Isabella	Giraldo	1500000	AdCreative	E035
E603	Nicolas	Hurtado	1400000	PRAssist	E036
E604	Luciana	Leon	1300000	WellnessAs	E037
E605	Emilio	Manrique	1200000	OrgDevAs	E038
E606	Julieta	Norena	1800000	Sales	E039
E607	Tomas	Ospina	1700000	Cashier	E039
E608	Antonia	Pardo	1800000	Sales	E040
E609	Felipe	Quiceno	1700000	Cashier	E040
E610	Martina	Ramirez	1600000	LogisticsOp	E041
E611	Joaquin	Saldarriaga	1600000	Driver	E042
E612	Sara	Tamayo	2400000	DeveloperSr	E043
E613	Martin	Useche	2300000	InfraSr	E044
E614	Elena	Varela	2200000	AccSenior	E045
E615	Simon	Yepes	2100000	AccSenior	E046
E616	Olivia	Zamudio	2000000	BuyerSr	E047
E617	Maximiliano	Alarcon	1900000	BuyerSr	E048
E618	Valeria	Bermudez	1700000	Sales	E049
E619	Lucas	Cabrera	1600000	MarketingJr	E052
E620	Renata	Duarte	1500000	HRAsist	E013
E621	Bruno	Florez	1400000	SupportJr	E014
E622	Clara	Giraldo	1300000	StockAssist	E015
E623	Hugo	Hurtado	1800000	Sales	E011
E624	Eva	Leon	1700000	Cashier	E011
E625	Adrian	Manrique	1600000	WarehouseOp	E015
E626	Sofia	Norena	1800000	MarketingJr	E012
E627	Javier	Ospina	1700000	HRAsist	E020
E628	Paula	Pardo	1600000	SupportTech	E028
E629	Ricardo	Quiceno	2000000	ProdAnalyst	E031
E630	Laura	Ramirez	1900000	QualityInsp	E032
E631	Mateo	Saldarriaga	1800000	TreasuryAs	E033
E632	Catalina	Tamayo	1700000	FinPlanAs	E034
E633	Esteban	Useche	1600000	AdCreative	E035
E634	Victoria	Varela	1500000	PRAssist	E036
E635	Ignacio	Yepes	1400000	WellnessAs	E037
E636	Carolina	Zamudio	1300000	OrgDevAs	E038
E637	Andres	Alarcon	1800000	Sales	E039
E638	Fernanda	Bermudez	1700000	Cashier	E039
E639	Roberto	Cabrera	1800000	Sales	E040
E640	Manuela	Duarte	1700000	Cashier	E040
E641	Samuel	Florez	1600000	LogisticsOp	E041
E642	Daniel	Giraldo	1600000	Driver	E042
E643	Camila	Hurtado	2500000	DeveloperSr	E043
E644	Luis	Leon	2400000	InfraSr	E044
E645	Ana	Manrique	2300000	AccSenior	E009
E646	Pedro	Norena	2200000	BuyerSr	E010
E647	Carmen	Ospina	1700000	Sales	E025
E648	David	Pardo	1600000	MarketingJr	E026
E649	Isabel	Quiceno	1500000	HRAsist	E027
E650	Miguel	Ramirez	1400000	SupportJr	E014
E651	Patricia	Saldarriaga	1300000	StockAssist	E029
E652	Javier	Tamayo	1800000	Sales	E011
E653	Elena	Useche	1700000	Cashier	E011
E654	Andres	Varela	1600000	WarehouseOp	E015
E655	Camila	Yepes	1800000	MarketingJr	E012
E656	Santiago	Zamudio	1700000	HRAsist	E013
E657	Valentina	Alarcon	1600000	SupportTech	E014
E658	Daniel	Bermudez	2000000	ProdAnalyst	E031
E659	Gabriela	Cabrera	1900000	QualityInsp	E032
E660	Ricardo	Duarte	1800000	TreasuryAs	E033
E661	Paula	Florez	1700000	FinPlanAs	E034
E662	Alejandro	Giraldo	1600000	AdCreative	E035
E663	Natalia	Hurtado	1500000	PRAssist	E036
E664	Martin	Leon	1400000	WellnessAs	E037
E665	Lucia	Manrique	1300000	OrgDevAs	E038
E666	Fernando	Norena	1800000	Sales	E039
E667	Veronica	Ospina	1700000	Cashier	E039
E668	Sergio	Pardo	1800000	Sales	E040
E669	Andrea	Quiceno	1700000	Cashier	E040
E670	Jorge	Ramirez	1600000	LogisticsOp	E041
E671	Adriana	Saldarriaga	1600000	Driver	E042
E672	Alberto	Tamayo	2600000	DataAnalyst	E008
E673	Monica	Useche	2500000	SecuritySp	E008
E674	Victor	Varela	2400000	FinAnalystS	E009
E675	Cristina	Yepes	2300000	TaxSpecial	E009
E676	Raul	Zamudio	2200000	MarketResSr	E004
E677	Beatriz	Alarcon	2100000	BrandSpec	E004
E678	Oscar	Bermudez	2000000	RecruitLead	E005
E679	Silvia	Cabrera	1900000	TrainingSp	E005
E680	Jose	Duarte	1800000	Sales	E049
E681	Rosa	Florez	1700000	MarketingJr	E052
E682	Manuel	Giraldo	1600000	HRAsist	E013
E683	Teresa	Hurtado	1500000	SupportJr	E014
E684	Francisco	Leon	1400000	StockAssist	E015
E685	Gloria	Manrique	1800000	Sales	E011
E686	Antonio	Norena	1700000	Cashier	E011
E687	Angela	Ospina	1600000	WarehouseOp	E015
E689	Sandra	Quiceno	1700000	HRAsist	E020
E690	Ana	Ramirez	1600000	SupportTech	E028
E691	Luis	Saldarriaga	2000000	ProdAnalyst	E031
E692	Maria	Tamayo	1900000	QualityInsp	E032
E693	Carlos	Useche	1800000	TreasuryAs	E033
E694	Sofia	Varela	1700000	FinPlanAs	E034
E695	Juan	Yepes	1600000	AdCreative	E035
E696	Daniela	Zamudio	1500000	PRAssist	E036
E697	Alejandro	Alarcon	1400000	WellnessAs	E037
E698	Gabriela	Bermudez	1300000	OrgDevAs	E038
E699	Mateo	Cabrera	1800000	Sales	E039
E700	Isabella	Duarte	1700000	Cashier	E039
E701	Nicolas	Florez	1800000	Sales	E040
E702	Luciana	Giraldo	1700000	Cashier	E040
E703	Emilio	Hurtado	1600000	LogisticsOp	E041
E704	Julieta	Leon	1600000	Driver	E042
E705	Tomas	Manrique	2700000	DeveloperSr	E043
E706	Antonia	Norena	2600000	InfraSr	E044
E707	Felipe	Ospina	2500000	AccSenior	E045
E708	Martina	Pardo	2400000	AccSenior	E046
E709	Joaquin	Quiceno	2300000	BuyerSr	E047
E710	Sara	Ramirez	2200000	BuyerSr	E048
E711	Martin	Saldarriaga	1700000	Sales	E049
E712	Elena	Tamayo	1600000	MarketingJr	E052
E713	Simon	Useche	1500000	HRAsist	E013
E714	Olivia	Varela	1400000	SupportJr	E014
E715	Maximiliano	Yepes	1300000	StockAssist	E015
E716	Valeria	Zamudio	1800000	Sales	E011
E717	Lucas	Alarcon	1700000	Cashier	E011
E718	Renata	Bermudez	1600000	WarehouseOp	E015
E719	Bruno	Cabrera	1800000	MarketingJr	E012
E720	Clara	Duarte	1700000	HRAsist	E020
E721	Hugo	Florez	1600000	SupportTech	E028
E722	Eva	Giraldo	2000000	ProdAnalyst	E031
E723	Adrian	Hurtado	1900000	QualityInsp	E032
E724	Sofia	Leon	1800000	TreasuryAs	E033
E725	Javier	Manrique	1700000	FinPlanAs	E034
E726	Paula	Norena	1600000	AdCreative	E035
E727	Ricardo	Ospina	1500000	PRAssist	E036
E728	Laura	Pardo	1400000	WellnessAs	E037
E729	Mateo	Quiceno	1300000	OrgDevAs	E038
E730	Catalina	Ramirez	1800000	Sales	E039
E731	Esteban	Saldarriaga	1700000	Cashier	E039
E732	Victoria	Tamayo	1800000	Sales	E040
E733	Ignacio	Useche	1700000	Cashier	E040
E734	Carolina	Varela	1600000	LogisticsOp	E041
E735	Andres	Yepes	1600000	Driver	E042
E736	Fernanda	Zamudio	2800000	DataScientist	E008
E737	Roberto	Alarcon	2700000	CloudArch	E008
E738	Manuela	Bermudez	2600000	AuditLead	E003
E739	Samuel	Cabrera	2500000	PayrollLead	E005
E740	Daniel	Duarte	2400000	CommsLead	E004
E741	Camila	Florez	1700000	Sales	E049
E742	Luis	Giraldo	1600000	MarketingJr	E052
E743	Ana	Hurtado	1500000	HRAsist	E013
E744	Pedro	Leon	1400000	SupportJr	E014
E745	Carmen	Manrique	1300000	StockAssist	E015
E746	David	Norena	1800000	Sales	E011
E747	Isabel	Ospina	1700000	Cashier	E011
E748	Miguel	Pardo	1600000	WarehouseOp	E015
E749	Patricia	Quiceno	1800000	MarketingJr	E012
E750	Javier	Ramirez	1700000	HRAsist	E020
E751	Elena	Saldarriaga	1600000	SupportTech	E028
E752	Andres	Tamayo	2000000	ProdAnalyst	E031
E753	Camila	Useche	1900000	QualityInsp	E032
E754	Santiago	Varela	1800000	TreasuryAs	E033
E755	Valentina	Yepes	1700000	FinPlanAs	E034
E756	Daniel	Zamudio	1600000	AdCreative	E035
E757	Gabriela	Alarcon	1500000	PRAssist	E036
E758	Ricardo	Bermudez	1400000	WellnessAs	E037
E759	Paula	Cabrera	1300000	OrgDevAs	E038
E760	Alejandro	Duarte	1800000	Sales	E039
E761	Natalia	Florez	1700000	Cashier	E039
E762	Martin	Giraldo	1800000	Sales	E040
E763	Lucia	Hurtado	1700000	Cashier	E040
E764	Fernando	Leon	1600000	LogisticsOp	E041
E765	Veronica	Manrique	1600000	Driver	E042
E766	Sergio	Norena	2900000	UXDesignerSr	E008
E767	Andrea	Ospina	2800000	DevOpsEng	E008
E768	Jorge	Pardo	2700000	InternalCtrl	E003
E769	Adriana	Quiceno	2600000	CompBenLead	E005
E770	Alberto	Ramirez	2500000	PRLead	E004
E771	Monica	Saldarriaga	1700000	Sales	E025
E772	Victor	Tamayo	1600000	MarketingJr	E026
E773	Cristina	Useche	1500000	HRAsist	E027
E774	Raul	Varela	1400000	SupportJr	E014
E775	Beatriz	Yepes	1300000	StockAssist	E029
E776	Oscar	Zamudio	1800000	Sales	E011
E777	Silvia	Alarcon	1700000	Cashier	E011
E778	Jose	Bermudez	1600000	WarehouseOp	E015
E779	Rosa	Cabrera	1800000	MarketingJr	E012
E780	Manuel	Duarte	1700000	HRAsist	E020
E781	Teresa	Florez	1600000	SupportTech	E028
E782	Francisco	Giraldo	2000000	ProdAnalyst	E031
E783	Gloria	Hurtado	1900000	QualityInsp	E032
E784	Antonio	Leon	1800000	TreasuryAs	E033
E785	Angela	Manrique	1700000	FinPlanAs	E034
E786	Diego	Norena	1600000	AdCreative	E035
E787	Sandra	Ospina	1500000	PRAssist	E036
E788	Ana	Pardo	1400000	WellnessAs	E037
E789	Luis	Quiceno	1300000	OrgDevAs	E038
E790	Maria	Ramirez	1800000	Sales	E039
E791	Carlos	Saldarriaga	1700000	Cashier	E039
E792	Sofia	Tamayo	1800000	Sales	E040
E793	Juan	Useche	1700000	Cashier	E040
E794	Daniela	Varela	1600000	LogisticsOp	E041
E795	Alejandro	Yepes	1600000	Driver	E042
E796	Gabriela	Zamudio	3000000	ProductOwner	E004
E797	Mateo	Alarcon	2900000	ProjectMgr	E002
E798	Isabella	Bermudez	2800000	RiskAnalyst	E003
E799	Nicolas	Cabrera	2700000	CorpCommsSp	E004
E800	Luciana	Duarte	2600000	LegalCounsel	E001
E801	Emilio	Florez	1700000	Sales	E049
E802	Julieta	Giraldo	1600000	MarketingJr	E052
E803	Tomas	Hurtado	1500000	HRAsist	E013
E804	Antonia	Leon	1400000	SupportJr	E014
E805	Felipe	Manrique	1300000	StockAssist	E015
E806	Martina	Norena	1800000	Sales	E011
E807	Joaquin	Ospina	1700000	Cashier	E011
E808	Sara	Pardo	1600000	WarehouseOp	E015
E809	Martin	Quiceno	1800000	MarketingJr	E012
E810	Elena	Ramirez	1700000	HRAsist	E020
E811	Simon	Saldarriaga	1600000	SupportTech	E028
E812	Olivia	Tamayo	2000000	ProdAnalyst	E031
E813	Maximiliano	Useche	1900000	QualityInsp	E032
E814	Valeria	Varela	1800000	TreasuryAs	E033
E815	Lucas	Yepes	1700000	FinPlanAs	E034
E816	Renata	Zamudio	1600000	AdCreative	E035
E817	Bruno	Alarcon	1500000	PRAssist	E036
E818	Clara	Bermudez	1400000	WellnessAs	E037
E819	Hugo	Cabrera	1300000	OrgDevAs	E038
E820	Eva	Duarte	1800000	Sales	E039
E821	Adrian	Florez	1700000	Cashier	E039
E822	Sofia	Giraldo	1800000	Sales	E040
E823	Javier	Hurtado	1700000	Cashier	E040
E824	Paula	Leon	1600000	LogisticsOp	E041
E825	Ricardo	Manrique	1600000	Driver	E042
E826	Laura	Norena	2800000	DataEng	E008
E827	Mateo	Ospina	2700000	CyberSecAn	E008
E828	Catalina	Pardo	2600000	ComplianceOf	E003
E829	Esteban	Quiceno	2500000	ERPSpec	E003
E830	Victoria	Ramirez	2400000	CustomerExp	E004
E831	Ignacio	Saldarriaga	1700000	Sales	E025
E832	Carolina	Tamayo	1600000	MarketingJr	E026
E833	Andres	Useche	1500000	HRAsist	E027
E834	Fernanda	Varela	1400000	SupportJr	E014
E835	Roberto	Yepes	1300000	StockAssist	E029
E836	Manuela	Zamudio	1800000	Sales	E011
E837	Samuel	Alarcon	1700000	Cashier	E011
E838	Daniel	Bermudez	1600000	WarehouseOp	E015
E839	Camila	Cabrera	1800000	MarketingJr	E012
E840	Luis	Duarte	1700000	HRAsist	E020
E841	Ana	Florez	1600000	SupportTech	E028
E842	Pedro	Giraldo	2000000	ProdAnalyst	E031
E843	Carmen	Hurtado	1900000	QualityInsp	E032
E844	David	Leon	1800000	TreasuryAs	E033
E845	Isabel	Manrique	1700000	FinPlanAs	E034
E846	Miguel	Norena	1600000	AdCreative	E035
E847	Patricia	Ospina	1500000	PRAssist	E036
E848	Javier	Pardo	1400000	WellnessAs	E037
E849	Elena	Quiceno	1300000	OrgDevAs	E038
E850	Andres	Ramirez	1800000	Sales	E039
E851	Camila	Saldarriaga	1700000	Cashier	E039
E852	Santiago	Tamayo	1800000	Sales	E040
E853	Valentina	Useche	1700000	Cashier	E040
E854	Daniel	Varela	1600000	LogisticsOp	E041
E855	Gabriela	Yepes	1600000	Driver	E042
E856	Ricardo	Zamudio	3000000	TechLead	E043
E857	Paula	Alarcon	2900000	SrSysAdmin	E044
E858	Alejandro	Bermudez	2800000	SrAccount	E045
E859	Natalia	Cabrera	2700000	SrAccount	E046
E860	Martin	Duarte	2600000	SrBuyer	E047
E861	Lucia	Florez	2500000	SrBuyer	E048
E862	Fernando	Giraldo	1700000	Sales	E049
E863	Veronica	Hurtado	1600000	MarketingJr	E052
E864	Sergio	Leon	1500000	HRAsist	E013
E865	Andrea	Manrique	1400000	SupportJr	E014
E866	Jorge	Norena	1300000	StockAssist	E015
E867	Adriana	Ospina	1800000	Sales	E011
E868	Alberto	Pardo	1700000	Cashier	E011
E869	Monica	Quiceno	1600000	WarehouseOp	E015
E870	Victor	Ramirez	1800000	MarketingJr	E012
E871	Cristina	Saldarriaga	1700000	HRAsist	E020
E872	Raul	Tamayo	1600000	SupportTech	E028
E873	Beatriz	Useche	2000000	ProdAnalyst	E031
E874	Oscar	Varela	1900000	QualityInsp	E032
E875	Silvia	Yepes	1800000	TreasuryAs	E033
E876	Jose	Zamudio	1700000	FinPlanAs	E034
E877	Rosa	Alarcon	1600000	AdCreative	E035
E878	Manuel	Bermudez	1500000	PRAssist	E036
E879	Teresa	Cabrera	1400000	WellnessAs	E037
E880	Francisco	Duarte	1300000	OrgDevAs	E038
E881	Gloria	Florez	1800000	Sales	E039
E882	Antonio	Giraldo	1700000	Cashier	E039
E883	Angela	Hurtado	1800000	Sales	E040
E884	Diego	Leon	1700000	Cashier	E040
E885	Sandra	Manrique	1600000	LogisticsOp	E041
E886	Ana	Norena	1600000	Driver	E042
E887	Luis	Ospina	3200000	LeadSalesReg	E006
E888	Maria	Pardo	3100000	LeadLogReg	E007
E889	Carlos	Quiceno	3000000	ITSecLead	E008
E890	Sofia	Ramirez	2900000	TreasuryLead	E009
E891	Juan	Saldarriaga	2800000	CategoryLead	E010
E892	Daniela	Tamayo	1700000	Sales	E049
E893	Alejandro	Useche	1600000	MarketingJr	E052
E894	Gabriela	Varela	1500000	HRAsist	E013
E895	Mateo	Yepes	1400000	SupportJr	E014
E896	Isabella	Zamudio	1300000	StockAssist	E015
E897	Nicolas	Alarcon	1800000	Sales	E011
E898	Luciana	Bermudez	1700000	Cashier	E011
E899	Emilio	Cabrera	1600000	WarehouseOp	E015
E900	Julieta	Duarte	1800000	MarketingJr	E012
E901	Tomas	Florez	1700000	HRAsist	E020
E902	Antonia	Giraldo	1600000	SupportTech	E028
E903	Felipe	Hurtado	2000000	ProdAnalyst	E031
E904	Martina	Leon	1900000	QualityInsp	E032
E905	Joaquin	Manrique	1800000	TreasuryAs	E033
E906	Sara	Norena	1700000	FinPlanAs	E034
E907	Martin	Ospina	1600000	AdCreative	E035
E908	Elena	Pardo	1500000	PRAssist	E036
E909	Simon	Quiceno	1400000	WellnessAs	E037
E910	Olivia	Ramirez	1300000	OrgDevAs	E038
E911	Maximiliano	Saldarriaga	1800000	Sales	E039
E912	Valeria	Tamayo	1700000	Cashier	E039
E913	Lucas	Useche	1800000	Sales	E040
E914	Renata	Varela	1700000	Cashier	E040
E915	Bruno	Yepes	1600000	LogisticsOp	E041
E916	Clara	Zamudio	1600000	Driver	E042
E917	Hugo	Alarcon	2700000	SolutionArch	E827
E918	Eva	Bermudez	2600000	DBAdminSr	E827
E919	Adrian	Cabrera	2500000	ProcessEng	E797
E920	Sofia	Duarte	2400000	AutomationSp	E797
E921	Javier	Florez	1700000	Sales	E049
E922	Paula	Giraldo	1600000	MarketingJr	E052
E923	Ricardo	Hurtado	1500000	HRAsist	E013
E924	Laura	Leon	1400000	SupportJr	E014
E925	Mateo	Manrique	1300000	StockAssist	E015
E926	Catalina	Norena	1800000	Sales	E011
E927	Esteban	Ospina	1700000	Cashier	E011
E928	Victoria	Pardo	1600000	WarehouseOp	E015
E929	Ignacio	Quiceno	1800000	MarketingJr	E012
E930	Carolina	Ramirez	1700000	HRAsist	E020
E931	Andres	Saldarriaga	1600000	SupportTech	E028
E932	Fernanda	Tamayo	2000000	ProdAnalyst	E031
E933	Roberto	Useche	1900000	QualityInsp	E032
E934	Manuela	Varela	1800000	TreasuryAs	E033
E935	Samuel	Yepes	1700000	FinPlanAs	E034
E936	Daniel	Zamudio	1600000	AdCreative	E035
E937	Camila	Alarcon	1500000	PRAssist	E036
E938	Luis	Bermudez	1400000	WellnessAs	E037
E939	Ana	Cabrera	1300000	OrgDevAs	E038
E940	Pedro	Duarte	1800000	Sales	E039
E941	Carmen	Florez	1700000	Cashier	E039
E942	David	Giraldo	1800000	Sales	E040
E943	Isabel	Hurtado	1700000	Cashier	E040
E944	Miguel	Leon	1600000	LogisticsOp	E041
E945	Patricia	Manrique	1600000	Driver	E042
E946	Javier	Norena	2800000	VisualMerchLd	E006
E947	Elena	Ospina	2700000	InventoryMgr	E007
E948	Andres	Pardo	2600000	NetworkArch	E008
E949	Camila	Quiceno	2500000	FinancialCtrl	E009
E950	Santiago	Ramirez	2400000	SourcingLead	E010
E951	Valentina	Saldarriaga	1700000	Sales	E049
E952	Daniel	Tamayo	1600000	MarketingJr	E052
E953	Gabriela	Useche	1500000	HRAsist	E013
E954	Ricardo	Varela	1400000	SupportJr	E014
E955	Paula	Yepes	1300000	StockAssist	E015
E956	Alejandro	Zamudio	1800000	Sales	E011
E957	Natalia	Alarcon	1700000	Cashier	E011
E958	Martin	Bermudez	1600000	WarehouseOp	E015
E959	Lucia	Cabrera	1800000	MarketingJr	E012
E960	Fernando	Duarte	1700000	HRAsist	E020
E961	Veronica	Florez	1600000	SupportTech	E028
E962	Sergio	Giraldo	2000000	ProdAnalyst	E031
E963	Andrea	Hurtado	1900000	QualityInsp	E032
E964	Jorge	Leon	1800000	TreasuryAs	E033
E965	Adriana	Manrique	1700000	FinPlanAs	E034
E966	Alberto	Norena	1600000	AdCreative	E035
E967	Monica	Ospina	1500000	PRAssist	E036
E968	Victor	Pardo	1400000	WellnessAs	E037
E969	Cristina	Quiceno	1300000	OrgDevAs	E038
E970	Raul	Ramirez	1800000	Sales	E039
E971	Beatriz	Saldarriaga	1700000	Cashier	E039
E972	Oscar	Tamayo	1800000	Sales	E040
E973	Silvia	Useche	1700000	Cashier	E040
E974	Jose	Varela	1600000	LogisticsOp	E041
E975	Rosa	Yepes	1600000	Driver	E042
E976	Manuel	Zamudio	3200000	StoreMgrB	E006
E977	Teresa	Alarcon	3100000	StoreMgrC	E006
E978	Francisco	Bermudez	3000000	LogisticsCoord	E007
E979	Gloria	Cabrera	2900000	ITSupportLead	E008
E980	Antonio	Duarte	2800000	AccountPayLead	E009
E981	Angela	Florez	2700000	SupplierRelLead	E010
E982	Diego	Giraldo	1700000	Sales	E976
E983	Sandra	Hurtado	1700000	Sales	E977
E984	Ana	Leon	1600000	LogisticsAsist	E978
E985	Luis	Manrique	1500000	ITSupportJr	E979
E986	Maria	Norena	1400000	AccountPayAs	E980
E987	Carlos	Ospina	1300000	SupplierRelAs	E981
E988	Sofia	Pardo	1800000	Sales	E011
E989	Juan	Quiceno	1700000	Cashier	E011
E990	Daniela	Ramirez	1600000	WarehouseOp	E015
E991	Alejandro	Saldarriaga	1800000	MarketingJr	E012
E992	Gabriela	Tamayo	1700000	HRAsist	E013
E993	Mateo	Useche	1600000	SupportTech	E014
E994	Isabella	Varela	2000000	ProdAnalyst	E031
E995	Nicolas	Yepes	1900000	QualityInsp	E032
E996	Luciana	Zamudio	1800000	TreasuryAs	E033
E997	Emilio	Alarcon	1700000	FinPlanAs	E034
E998	Julieta	Bermudez	1600000	AdCreative	E035
E999	Tomas	Cabrera	1500000	PRAssist	E036
E000	Antonia	Duarte	1400000	WellnessAs	E037
\.


                                        5134.dat                                                                                            0000600 0004000 0002000 00000100712 15014423351 0014245 0                                                                                                    ustar 00postgres                        postgres                        0000000 0000000                                                                                                                                                                        I274	2024-05-19	Pedido perfumes solares C693	94500	C693	02	E004
I275	2024-05-20	Factura cliente C703	145000	C703	01	E005
I276	2024-05-21	Compra de regalos de graduación C713	90000	C713	03	E003
I277	2024-05-22	Venta con promoción C723	296000	C723	04	E004
I278	2024-05-23	Pedido online C733	470000	C733	02	E005
I279	2024-05-24	Factura cliente C743	166500	C743	01	E003
I280	2024-05-25	Compra Memorial Day Weekend C753	510000	C753	05	E004
I281	2024-05-26	Venta fragancias USA C763	82800	C763	02	E005
I282	2024-05-27	Pedido Memorial Day C773	150000	C773	01	E003
I283	2024-05-28	Factura cliente C783	162000	C783	03	E004
I284	2024-05-29	Compra de perfumes de diseñador C793	92000	C793	04	E005
I285	2024-05-30	Venta fin de mes mayo C803	640000	C803	02	E003
I286	2024-05-31	¡VENTA DÍA SIN TABACO!	225000	C813	01	E004
I287	2024-06-01	Pedido inicio de junio C823	200000	C823	05	E005
I288	2024-06-02	Factura cliente C833	585000	C833	02	E003
I289	2024-06-03	Compra Día del Padre (anticipada) C843	130000	C843	01	E004
I290	2024-06-04	Venta fragancias masculinas C853	175500	C853	03	E005
I291	2024-06-05	Pedido online C863	120000	C863	04	E003
I292	2024-06-06	Factura cliente C873	210000	C873	02	E004
I293	2024-06-07	Compra de regalos para papá C883	270000	C883	01	E005
I294	2024-06-08	Venta Día de los Océanos C893	225000	C893	05	E003
I295	2024-06-09	Pedido perfumes acuáticos C903	162000	C903	02	E004
I296	2024-06-10	Factura cliente C913	520000	C913	01	E005
I297	2024-06-11	Compra de sets para papá C923	81000	C923	03	E003
I298	2024-06-12	Venta con descuento Día Padre C933	136000	C933	04	E004
I299	2024-06-13	Pedido online C943	320000	C943	02	E005
I300	2024-06-14	Factura cliente C953	324000	C953	01	E003
I301	2024-06-15	Compra regalos graduación C963	240000	C963	05	E004
I302	2024-06-16	¡VENTA DÍA DEL PADRE!	184500	C973	02	E005
I303	2024-06-17	Pedido post Día del Padre C983	680000	C983	01	E003
I304	2024-06-18	Factura cliente C993	76500	C993	03	E004
I305	2024-06-19	Compra de fragancias de verano C004	420000	C004	04	E005
I306	2024-06-20	Venta Solsticio de Verano C014	139500	C014	02	E003
I307	2024-06-21	Pedido perfumes solares C024	112000	C024	01	E004
I308	2024-06-22	Factura cliente C034	240000	C034	05	E005
I309	2024-06-23	Compra de regalos de verano C044	81000	C044	02	E003
I310	2024-06-24	Venta fragancias frescas C054	330000	C054	01	E004
I311	2024-06-25	Pedido online C064	229500	C064	03	E005
I312	2024-06-26	Factura cliente C074	190000	C074	04	E003
I313	2024-06-27	Compra de perfumes de playa C084	450000	C084	02	E004
I314	2024-06-28	Venta fin de mes junio C094	70000	C094	01	E005
I315	2024-06-29	Pedido online (promo travel size) C104	130500	C104	05	E003
I316	2024-06-30	Factura cliente C114	160000	C114	02	E004
I317	2024-07-01	¡VENTA CANADA DAY!	340000	C124	01	E005
I318	2024-07-02	Pedido inicio de julio C134	283500	C134	03	E003
I319	2024-07-03	Factura cliente C144	260000	C144	04	E004
I320	2024-07-04	¡VENTA INDEPENDENCE DAY USA!	189000	C154	02	E005
I321	2024-07-05	Pedido ofertas patrias C164	660000	C164	01	E003
I322	2024-07-06	Factura cliente C174	121500	C174	05	E004
I051	2024-11-30	Oferta Small Business Saturday	261000	C642	01	E003
I052	2024-12-02	Compra Cyber Monday online	464000	C665	05	E004
I053	2024-12-05	Regalos navideños (sets)	440000	C688	02	E005
I054	2024-12-08	Venta promo Noche de Velitas	112500	C711	01	E003
I055	2024-12-17	Pedido última semana regalos	160000	C734	03	E004
I056	2024-12-25	Compra especial día de Navidad	200000	C757	04	E005
I057	2024-12-28	Venta liquidación Fin de Año	187200	C780	02	E003
I058	2025-01-01	Pedido Bienvenido 2025 (promo)	304000	C803	01	E004
I059	2025-01-05	Compra limpieza de Enero	405000	C826	05	E005
I060	2025-01-16	Venta Blue Monday Pick-Me-Up	211500	C849	01	E003
I061	2025-01-25	Pedido escapada de Invierno (set)	190000	C872	03	E004
I062	2025-02-03	Compra San Valentín 2025 (ed. especial)	416000	C895	04	E005
I063	2025-02-09	Venta Love Weekend (2x1 perfumes)	180000	C918	02	E003
I064	2025-02-22	Pedido promo Año Bisiesto	145000	C941	01	E004
I065	2025-03-02	Compra Semana de la Mujer (descuentos)	248000	C964	05	E005
I066	2025-03-17	Venta St. Patrick's Day (17% off)	298800	C987	01	E003
I067	2025-03-22	Pedido Equinoccio Primavera (lanzamientos)	92000	C010	03	E004
I068	2025-03-30	Compra fin de mes Marzo (envío gratis)	306000	C033	04	E005
I069	2025-04-01	Venta April Fools (descuento o broma)	98000	C056	02	E003
I070	2025-04-07	Pedido Gran Venta de Primavera (20% off)	680000	C079	01	E004
I071	2025-04-20	Compra Pascua (regalos y descuentos)	300000	C103	05	E005
I072	2025-04-22	Venta Día de la Tierra (sostenibles)	165750	C126	01	E003
I073	2025-04-27	Pedido Flash Sale Abril (Gourmand)	612000	C149	03	E004
I074	2025-05-03	Compra Día de la Madre (regalos)	457500	C172	04	E005
I075	2025-05-10	Venta Star Wars Day (promo galáctica)	115000	C195	02	E003
I076	2025-05-18	Pedido Fin de Semana Misterioso Mayo	500000	C218	01	E004
I077	2025-05-25	Compra Memorial Weekend Sale (verano)	56000	C241	05	E005
I078	2025-05-31	Venta Día sin Tabaco (frescas)	60000	C264	01	E003
I079	2025-06-02	Pedido Día del Padre (sorpresa)	108000	C287	03	E004
I080	2025-06-08	Compra Día de los Océanos (acuáticas)	180000	C310	04	E005
I081	2025-06-15	Venta Felicidades Graduados (descuento)	233750	C333	02	E003
I082	2025-06-21	Pedido Solsticio Verano (ofertas)	200000	C356	01	E004
I083	2025-06-29	Compra fin de mes Junio (travel size)	448000	C379	05	E005
I084	2025-07-01	Venta Canada Day (ofertas)	270000	C402	01	E003
I085	2025-07-05	Pedido Independence Day USA (ofertas)	252000	C425	03	E004
I086	2025-07-13	Compra Flash Sale Julio (bestsellers)	110000	C448	04	E005
I087	2025-07-19	Venta Independencia Colombia (20% off)	320000	C471	02	E003
I323	2024-07-07	Compra de fragancias de autor C184	120000	C184	02	E005
I324	2024-07-08	Venta con descuento C194	220000	C194	01	E003
I325	2024-07-09	Pedido online C204	225000	C204	03	E004
I326	2024-07-10	Factura cliente C214	225000	C214	04	E005
I327	2024-07-11	Compra de regalos de verano C224	342000	C224	02	E003
I328	2024-07-12	Venta flash sale Julio C234	100000	C234	01	E004
I329	2024-07-13	Pedido perfumes bestseller C244	360000	C244	05	E005
I330	2024-07-14	Factura cliente C254	296000	C254	02	E003
I331	2024-07-15	Compra de perfumes de nicho C264	490000	C264	01	E004
I332	2024-07-16	Venta ofertas de verano C274	193500	C274	03	E005
I333	2024-07-17	Pedido online C284	560000	C284	04	E003
I334	2024-07-18	Factura cliente C294	117000	C294	02	E004
I335	2024-07-19	Compra de regalos para amigos C304	170000	C304	01	E005
I336	2024-07-20	¡VENTA INDEPENDENCIA COLOMBIA!	157500	C314	05	E003
I337	2024-07-21	Pedido perfumes nacionales C324	144000	C324	02	E004
I338	2024-07-22	Factura cliente C334	640000	C334	01	E005
I339	2024-07-23	Compra de fragancias frescas C344	243000	C344	03	E003
I340	2024-07-24	Venta con promoción C354	220000	C354	04	E004
I341	2024-07-25	Pedido online C364	621000	C364	02	E005
I342	2024-07-26	Factura cliente C374	95000	C374	01	E003
I343	2024-07-27	Compra Diamond Prime Weekend C384	144000	C384	05	E004
I344	2024-07-28	Venta ofertas exclusivas C394	144000	C394	02	E005
I345	2024-07-29	Pedido online C404	220000	C404	01	E003
I346	2024-07-30	Factura cliente C414	292500	C414	03	E004
I347	2024-07-31	Compra fin de mes Julio C424	250000	C424	04	E005
I348	2024-08-01	Venta Agosto Fresco (2x1) C434	166500	C434	02	E003
I349	2024-08-02	Pedido body mists C444	490000	C444	01	E004
I350	2024-08-03	Factura cliente C454	79200	C454	05	E005
I367	2024-08-20	Factura cliente frecuente C624	330000	C624	03	E004
I368	2024-08-21	Compra online C634	126000	C634	04	E005
I369	2024-08-22	Venta con liquidación C644	160000	C644	02	E003
I370	2024-08-23	Pedido promo de agosto C654	279000	C654	01	E004
I371	2024-08-24	Compra para regalo C664	245000	C664	05	E005
I372	2024-08-25	Factura cliente C674	171000	C674	02	E003
I373	2024-08-26	Pedido para un amigo C684	536000	C684	01	E004
I374	2024-08-27	Compra fragancias aromaticas C694	260000	C694	03	E005
I375	2024-08-28	Venta perfumes de temporada C704	261000	C704	04	E003
I376	2024-08-29	Pedido online para mujer C714	112000	C714	02	E004
I377	2024-08-30	Factura cliente C724	369000	C724	01	E005
I378	2024-08-31	Compra promo de fin de semana C734	365000	C734	05	E003
I379	2024-09-01	¡VENTA LABOR DAY!	207000	C744	02	E004
I380	2024-09-02	Pedido por el día del trabajo C754	144000	C754	01	E005
I381	2024-09-03	Compra fragancias finas C764	1000000	C764	03	E003
I382	2024-09-04	Venta con envío gratis C774	70200	C774	04	E004
I383	2024-09-05	Pedido online para hombre C784	145000	C784	02	E005
I384	2024-09-06	Factura cliente C794	157500	C794	01	E003
I101	2025-10-12	Compra Discovery Weekend (muestras)	288000	C793	05	E005
I102	2025-10-19	Venta Flash Sale Octubre (cuero/tabaco)	168000	C816	01	E003
I103	2025-10-27	Pedido Semana de Halloween (temáticos)	950000	C839	03	E004
I104	2025-11-02	Compra Día de Todos los Santos (reconfortantes)	252000	C862	04	E005
I105	2024-03-05	Venta semanal (Marzo W1)	190000	C002	02	E003
I106	2024-03-12	Pedido semanal (Marzo W2)	162000	C012	01	E004
I107	2024-03-19	Compra semanal (Marzo W3)	88000	C022	05	E005
I108	2024-03-26	Venta semanal (Marzo W4)	351000	C032	01	E003
I109	2024-04-02	Pedido semanal (Abril W1)	280000	C042	03	E004
I110	2024-04-09	Compra semanal (Abril W2)	420000	C052	04	E005
I111	2024-04-16	Venta semanal (Abril W3)	135000	C062	02	E003
I112	2024-04-23	Pedido semanal (Abril W4)	620000	C072	01	E004
I113	2024-04-30	Compra semanal (Abril W5)	108000	C082	05	E005
I151	2024-01-17	Pedido cliente C462	330000	C462	03	E004
I152	2024-01-18	Compra online C472	225000	C472	04	E005
I153	2024-01-19	Venta tienda C482	440000	C482	02	E003
I154	2024-01-20	Factura promoción C492	280000	C492	01	E004
I155	2024-01-21	Regalo para C502	175500	C502	05	E005
I156	2024-01-22	Pedido mayorista C512	300000	C512	02	E003
I157	2024-01-23	Venta con descuento C522	85500	C522	01	E004
I158	2024-01-24	Compra fragancia nueva C532	405000	C532	03	E005
I159	2024-01-25	Pedido telefónico C542	370000	C542	04	E003
I160	2024-01-26	Venta fin de semana C552	468000	C552	02	E004
I161	2024-01-27	Factura cliente frecuente C562	153000	C562	01	E005
I162	2024-01-28	Compra para regalo C572	576000	C572	05	E003
I163	2024-01-29	Pedido productos de tocador C582	80000	C582	02	E004
I164	2024-01-30	Venta cierre de mes C592	135000	C592	01	E005
I165	2024-01-31	Factura promo fin de enero C602	400000	C602	03	E003
I166	2024-02-01	Compra inicio de febrero C612	342000	C612	04	E004
I167	2024-02-02	Venta especial San Valentín C622	92000	C622	02	E005
I168	2024-02-03	Pedido perfumes florales C632	171000	C632	01	E003
I169	2024-02-04	Factura con tarjeta C642	100000	C642	05	E004
I170	2024-02-05	Compra online cliente VIP C652	384000	C652	02	E005
I171	2024-02-06	Venta de sets de regalo C662	700000	C662	01	E003
I172	2024-02-07	Pedido fragancias unisex C672	162000	C672	03	E004
I173	2024-02-08	Factura cliente C682 (Nequi)	220000	C682	04	E005
I174	2024-02-09	Compra para evento C692	621000	C692	02	E003
I175	2024-02-10	Venta promoción pareja C702	130000	C702	01	E004
I176	2024-02-11	Pedido con envoltura especial C712	126000	C712	05	E005
I177	2024-02-12	Factura cliente C722 (Efectivo)	440000	C722	01	E003
I178	2024-02-13	Compra de última hora C732	210000	C732	03	E004
I179	2024-02-14	¡VENTA MASIVA SAN VALENTÍN!	81000	C742	04	E005
I251	2024-04-26	Venta fragancias unisex C463	243000	C463	01	E005
I252	2024-04-27	Pedido fin de semana Abril C473	200000	C473	05	E003
I253	2024-04-28	Factura cliente C483	558000	C483	02	E004
I254	2024-04-29	Compra de regalos para mayo C493	90000	C493	01	E005
I255	2024-04-30	Venta fin de mes Abril C503	315000	C503	03	E003
I256	2024-05-01	¡VENTA DÍA DEL TRABAJADOR!	320000	C513	04	E004
I257	2024-05-02	Pedido especial Día de la Madre C523	140000	C523	02	E005
I258	2024-05-03	Factura cliente C533	144000	C533	01	E003
I259	2024-05-04	Compra online Día de la Madre C543	190000	C543	05	E004
I260	2024-05-05	¡VENTA CINCO DE MAYO!	99000	C553	02	E005
I261	2024-05-06	Pedido fragancias florales C563	98000	C563	01	E003
I262	2024-05-07	Factura cliente C573	297000	C573	03	E004
I263	2024-05-08	Compra de sets de regalo C583	208000	C583	04	E005
I264	2024-05-09	Venta con descuento Día Madre C593	390000	C593	02	E003
I265	2024-05-10	Pedido online C603	450000	C603	01	E004
I266	2024-05-11	Factura cliente C613	120000	C613	05	E005
I267	2024-05-12	¡VENTA DÍA DE LA MADRE!	126000	C623	02	E003
I268	2024-05-13	Pedido post Día de la Madre C633	100000	C633	01	E004
I269	2024-05-14	Compra de fragancias de verano C643	148500	C643	03	E005
I270	2024-05-15	Venta quincena mayo C653	248000	C653	04	E003
I271	2024-05-16	Factura cliente C663	440000	C663	02	E004
I272	2024-05-17	Compra online C673	162000	C673	01	E005
I273	2024-05-18	Venta fin de semana misterioso C683	590000	C683	05	E003
I385	2024-09-07	Compra por la noche C804	112000	C804	05	E004
I386	2024-09-08	Pedido especial para amigos C814	288000	C814	02	E005
I387	2024-09-09	Venta semana de promociones C824	204000	C824	01	E003
I388	2024-09-10	Factura cliente frecuente C834	400000	C834	03	E004
I389	2024-09-11	Compra online de diseños C844	612000	C844	04	E005
I390	2024-09-12	Pedido solo lo mejor de tienda C854	128000	C854	02	E003
I391	2024-09-13	Venta con pago en Efectivo C864	157500	C864	01	E004
I392	2024-09-14	Factura cliente C874	150000	C874	05	E005
I393	2024-09-15	Compra perfumes árabes C884	153000	C884	02	E003
I394	2024-09-16	Pedido con entrega a domicilio C894	304000	C894	01	E004
I395	2024-09-17	Compra descuentos de aniversario C904	540000	C904	03	E005
I396	2024-09-18	Venta fragancias por tendencia C914	171000	C914	04	E003
I397	2024-09-19	Pedido para regalo C924	530000	C924	02	E004
I398	2024-09-20	¡VENTA DÍA DEL AMOR Y LA AMISTAD!	126000	C934	01	E005
I399	2024-09-21	Compra perfumes de edición limitada C944	300000	C944	05	E003
I400	2024-09-22	Factura cliente C954	108000	C954	02	E004
I401	2024-09-23	Pedido para ocasiones especiales	368000	C964	01	E005
I402	2024-09-24	Venta fragancias exclusivas C974	760000	C974	03	E003
I403	2024-09-25	Pedido online express C984	216000	C984	04	E004
I404	2024-09-26	Factura cliente C994	210000	C994	02	E005
I405	2024-09-27	Compra con regalo incluido C005	675000	C005	01	E003
I406	2024-09-28	Venta perfumes de colección C015	135000	C015	05	E004
I407	2024-09-29	Pedido en zona Bogotá C025	162000	C025	02	E005
I408	2024-09-30	Factura cliente recurrente C035	124000	C035	01	E003
I409	2024-10-01	Compra fragancias de diseñador C045	350000	C045	03	E004
I410	2024-10-02	Venta con descuento de temporada C055	306000	C055	04	E005
I411	2024-10-03	Pedido para cliente fiel C065	275000	C065	02	E003
I412	2024-10-04	Factura online con Nequi C075	180000	C075	04	E004
I413	2024-10-05	Compra fragancias de nicho C085	540000	C085	05	E005
I414	2024-10-06	Venta con retiro en tienda C095	99000	C095	01	E003
I415	2024-10-07	Pedido de regalo para octubre C105	248000	C105	03	E004
I416	2024-10-08	Factura online para mujer C115	220000	C115	04	E005
I417	2024-10-09	Compra especial de Aniversario C125	387000	C125	02	E003
I418	2024-10-10	Venta fragancias de alta gama C135	375000	C135	01	E004
I419	2024-10-11	Pedido con código de descuento C145	207000	C145	05	E005
I420	2024-10-12	Factura cliente Transf Bancolombia C155	200000	C155	02	E003
I421	2024-10-13	Compra para un evento especial C165	594000	C165	01	E004
I422	2024-10-14	Venta online en Colombia C175	105600	C175	03	E005
I423	2024-10-15	Pedido fragancias del mundo C185	340000	C185	04	E003
I424	2024-10-16	Factura cliente con Daviplata C195	133200	C195	02	E004
I425	2024-10-17	Compra con envoltura especial C205	168000	C205	01	E005
I426	2024-10-18	Venta perfumes económicos C215	301500	C215	05	E003
I456	2024-11-17	Venta de fragancias amaderadas C515	109800	C515	02	E003
I457	2024-11-18	Pedido de perfumes para hombre C525	376000	C525	01	E004
I458	2024-11-19	Factura con promoción 2x1 C535	800000	C535	03	E005
I459	2024-11-20	Compra online con envío a Medellín C545	220500	C545	04	E003
I460	2024-11-21	Venta especial para cliente VIP C555	215000	C555	02	E004
I461	2024-11-22	Pedido de perfumes para mujer C565	513000	C565	01	E005
I462	2024-11-23	Factura con descuento de cumpleaños C575	148000	C575	05	E003
I463	2024-11-24	Compra de fragancias unisex C585	163800	C585	02	E004
I464	2024-11-25	Venta de Black Friday anticipada C595	128000	C595	01	E005
I465	2024-11-26	Pedido de perfumes orientales C605	356000	C605	03	E003
I466	2024-11-27	Factura con envío a Cali C615	319500	C615	04	E004
I467	2024-11-28	¡VENTA ESPECIAL DE THANKSGIVING!	290000	C625	02	E005
I468	2024-11-29	¡OFERTAS INCREÍBLES DE BLACK FRIDAY!	207000	C635	01	E003
I469	2024-11-30	Venta Small Business Saturday Online C645	710000	C645	05	E004
I470	2024-12-01	Compra de Domingo (Small Business) C655	135000	C655	02	E005
I471	2024-12-02	¡VENTA CYBER MONDAY EN LÍNEA!	264000	C665	04	E003
I472	2024-12-03	Pedido Cyber Week con Nequi C675	260000	C675	04	E004
I473	2024-12-04	Factura de compra corporativa C685	450000	C685	02	E005
I474	2024-12-05	Compra de regalos de Navidad C695	410000	C695	01	E003
I475	2024-12-06	Venta con promoción de Diciembre C705	225000	C705	03	E004
I476	2024-12-07	Pedido de Noche de Velitas C715	220000	C715	05	E005
I477	2024-12-08	Factura especial Día de Velitas C725	522000	C725	01	E003
I478	2024-12-09	Compra de sets de regalo navideños C735	68000	C735	02	E004
I479	2024-12-10	Venta con descuento especial C745	340000	C745	04	E005
I480	2024-12-11	Pedido online para Navidad C755	171000	C755	01	E003
I481	2024-12-12	Factura cliente con Daviplata C765	125000	C765	05	E004
I482	2024-12-13	Compra de perfumes de lujo para regalo C775	324000	C775	02	E005
I483	2024-12-14	Venta con promoción de fin de semana C785	295000	C785	01	E003
I484	2024-12-15	Pedido online con envío a Barranquilla C795	211500	C795	03	E004
I485	2024-12-16	Factura para regalo de amigo secreto C805	560000	C805	04	E005
I486	2024-12-17	Compra de regalos de última hora C815	190000	C815	02	E003
I487	2024-12-18	Venta con promoción de aguinaldos C825	160200	C825	01	E004
I488	2024-12-19	Pedido online express para Navidad C835	165000	C835	05	E005
I489	2024-12-20	Factura cliente con pago en efectivo C845	163800	C845	01	E003
I490	2024-12-21	Compra de última hora para Nochebuena C855	370000	C855	03	E004
I491	2024-12-22	Venta de perfumes para la fiesta de Navidad C865	234000	C865	04	E005
I492	2024-12-23	Pedido Nochebuena con envío urgente C875	160000	C875	02	E003
I493	2024-12-24	¡COMPRA DE NOCHEBUENA EN TIENDA!	1020000	C885	01	E004
I494	2024-12-25	¡VENTA ESPECIAL DÍA DE NAVIDAD!	88200	C895	05	E005
I495	2024-12-26	Venta de Boxing Day con grandes descuentos C905	140000	C905	02	E003
I496	2024-12-27	Pedido online liquidación post-navidad C915	153000	C915	01	E004
I497	2024-12-28	Factura cliente con pago Nequi C925	108000	C925	04	E005
I498	2024-12-29	Compra de regalos para la fiesta de Año Nuevo C935	319500	C935	03	E003
I499	2024-12-30	Venta con promoción especial Fin de Año C945	184000	C945	02	E004
I500	2024-12-31	¡ÚLTIMA VENTA DEL AÑO 2024!	390000	C955	01	E005
I351	2024-08-04	Compra Día del Niño C464	171000	C464	02	E003
I352	2024-08-05	Pedido online C474	116000	C474	01	E004
I353	2024-08-06	Venta fragancias juveniles C484	330000	C484	03	E005
I354	2024-08-07	Pedido Batalla de Boyacá (his)	265500	C494	04	E003
I355	2024-08-08	Factura cliente C504	215000	C504	02	E004
I356	2024-08-09	Compra fragancias eco-friendly C514	157500	C514	01	E005
I357	2024-08-10	¡VENTA DÍA DEL PERRO!	570000	C524	05	E003
I358	2024-08-11	Pedido promociones de stock C534	112500	C534	02	E004
I359	2024-08-12	Factura cliente C544	104000	C544	01	E005
I360	2024-08-13	Compra fin de semana Agosto C554	340000	C554	03	E003
I361	2024-08-14	Venta online C564	94500	C564	04	E004
I362	2024-08-15	Pedido dia de la Virgen (floral)	350000	C574	02	E005
I363	2024-08-16	Factura cliente C584	198000	C584	01	E003
I364	2024-08-17	Compra fragancias top ventas C594	180000	C594	05	E004
I365	2024-08-18	Venta con envío express C604	432000	C604	02	E005
I366	2024-08-19	Pedido vuelta a clases C614	73600	C614	01	E003
I450	2024-11-11	¡VENTA DE ANIVERSARIO DE LA TIENDA!	280000	C455	03	E003
I451	2024-11-12	Compra con descuento para miembros C465	570000	C465	04	E004
I452	2024-11-13	Venta de perfumes florales C475	202500	C475	02	E005
I453	2024-11-14	Pedido online con pago contraentrega C485	695000	C485	03	E003
I454	2024-11-15	Factura de quincena para cliente C495	127800	C495	01	E004
I455	2024-11-16	Compra de edición limitada C505	315000	C505	05	E005
I001	2023-11-22	Compra Black Friday anticipada	224000	C001	04	E003
I002	2023-12-05	Regalos de Navidad corporativos	550000	C015	02	E005
I003	2023-12-20	Venta perfume edición limitada	342000	C030	01	E003
I004	2024-01-03	Compra online cliente nuevo	95000	C055	05	E004
P005	2024-01-10	Venta con promoción de Enero	135000	C077	01	E005
I006	2024-01-18	Pedido fragancias florales	120000	C102	03	E003
I007	2024-01-25	Compra fin de semana flash sale	189000	C123	04	E004
I008	2024-02-02	Regalo San Valentín para ella	280000	C150	02	E005
I009	2024-02-08	Venta perfumes de pareja	320000	C188	01	E003
I010	2024-02-14	Compra de último minuto San Valentín	378000	C205	05	E004
I011	2024-02-22	Pedido con envío gratis (promo)	144000	C233	01	E005
I012	2024-03-01	Regalo Día de la Mujer (anticipado)	480000	C250	03	E003
I013	2024-03-07	Venta perfumes florales promo Mujer	88000	C277	04	E004
I014	2024-03-16	Compra St. Patrick promo verde	145250	C302	02	E005
I015	2024-03-25	Pedido bienvenida primavera	531000	C323	01	E003
I016	2024-04-02	Venta promo Abril (2x1 en 3ro)	340000	C350	05	E004
I017	2024-04-13	Compra flash sale Oriental	59500	C377	01	E005
I018	2024-04-22	Venta Día de la Tierra (eco)	187000	C402	03	E003
I019	2024-05-03	Regalo Día de la Madre (set)	67500	C423	04	E004
I020	2024-05-05	Compra Cinco de Mayo (agave)	420000	C450	02	E005
I021	2024-05-18	Venta fin de semana misterioso	234000	C477	01	E003
I022	2024-05-26	Pedido Memorial Day (verano)	414000	C501	05	E004
I023	2024-06-03	Regalo Día del Padre (masculina)	132000	C005	01	E005
I024	2024-06-10	Venta lanzamiento Lunes	680000	C020	03	E003
I025	2024-06-22	Compra Solsticio de Verano (frescas)	55250	C044	04	E004
I026	2024-06-29	Pedido fin de mes (doble puntos)	110000	C066	02	E005
I027	2024-07-02	Venta semana Independencia (USA)	117000	C089	01	E003
I028	2024-07-04	Pedido 4 de Julio (envío gratis)	105000	C112	05	E004
I029	2024-07-16	Compra ofertas de verano (colonias)	67500	C135	01	E005
I030	2024-07-20	Venta Día Independencia (COL)	144000	C158	03	E003
I031	2024-07-27	Pedido Prime Days Diamond (miembros)	650000	C181	04	E004
I032	2024-08-02	Compra Regreso a Clases (juvenil)	408000	C204	02	E005
I033	2024-08-07	Venta Batalla de Boyacá (histórica)	520000	C227	01	E003
I034	2024-08-16	Pedido promo Día del Perro	2160000	C251	05	E004
I035	2024-08-25	Compra fin de semana Agosto (2x1 en 2do)	580000	C274	01	E005
I036	2024-09-01	Venta Labor Day Sale	648000	C297	03	E003
I037	2024-09-07	Pedido Festival Floral (flores blancas)	448000	C320	04	E004
I038	2024-09-16	Compra semana Amor y Amistad (sets)	530000	C343	02	E005
I039	2024-09-20	Venta Día Amor y Amistad (regalo)	531000	C366	01	E003
I040	2024-09-29	Pedido bienvenida Otoño (amaderadas)	810000	C389	05	E004
I041	2024-10-03	Compra semana Perfume Nicho	486000	C412	01	E005
I042	2024-10-13	Venta Día de la Raza (frag. mundo)	380000	C435	03	E003
I043	2024-10-19	Pedido Pre-Halloween (13% off)	278400	C458	04	E004
I044	2024-10-28	Compra Halloween (regalo misterioso)	510000	C481	02	E005
I045	2024-11-02	Venta Día de Muertos (descuento)	441000	C504	01	E003
I046	2024-11-08	Pedido Single's Day Sale	950000	C527	05	E004
I047	2024-11-11	Compra Veterans Day (descuento)	792000	C550	01	E005
I048	2024-11-18	Venta Pre-Black Friday (miembros)	1680000	C573	03	E003
I049	2024-11-28	Pedido Thanksgiving (envío gratis)	620000	C596	04	E004
I050	2024-11-29	¡COMPRA BLACK FRIDAY MASIVA!	575000	C619	02	E005
I088	2025-07-27	Pedido Diamond Prime Weekend (exclusivos)	330000	C494	01	E004
I089	2025-08-02	Compra Agosto Fresco (2x1 body mists)	208250	C517	05	E005
I090	2025-08-10	Venta Día del Gato (muestra felina)	870000	C540	01	E003
I091	2025-08-18	Pedido Vuelta al Cole (sets juveniles)	637500	C563	03	E004
I092	2025-08-31	Compra fin de mes Agosto (envío express)	150000	C586	04	E005
I093	2025-09-01	Venta Labor Day (ofertas relax)	283500	C609	02	E003
I094	2025-09-07	Pedido Día de los Abuelos (clásicas)	76000	C632	01	E004
I095	2025-09-15	Compra Amor y Amistad Semana (regalos)	140000	C655	05	E005
I096	2025-09-20	Venta Día especial Amor y Amistad	157500	C678	01	E003
I097	2025-09-22	Pedido Equinoccio de Otoño (especiados)	380000	C701	03	E004
I098	2025-09-28	Compra Día Mundial del Turismo (viajes)	225250	C724	04	E005
I099	2025-10-03	Venta Mes Vegetariano (veganas)	378000	C747	02	E003
I100	2025-10-05	Pedido Día Mundial de los Animales	495000	C770	01	E004
I114	2024-05-07	Venta semanal (Mayo W1)	160000	C092	01	E003
I115	2024-05-14	Pedido semanal (Mayo W2)	301500	C102	03	E004
I116	2024-05-21	Compra semanal (Mayo W3)	370000	C112	04	E005
I117	2024-05-28	Venta semanal (Mayo W4)	135000	C122	02	E003
I118	2024-06-04	Pedido semanal (Junio W1)	160000	C132	01	E004
I119	2024-06-11	Compra semanal (Junio W2)	170000	C142	05	E005
I120	2024-06-18	Venta semanal (Junio W3)	225000	C152	01	E003
I121	2024-06-25	Pedido semanal (Junio W4)	360000	C162	03	E004
I122	2024-07-02	Compra semanal (Julio W1)	202500	C172	04	E005
I123	2024-07-09	Venta semanal (Julio W2)	200000	C182	02	E003
I124	2024-07-16	Pedido semanal (Julio W3)	520000	C192	01	E004
I125	2024-07-23	Compra semanal (Julio W4)	180000	C202	05	E005
I126	2024-07-30	Venta semanal (Julio W5)	54000	C212	01	E003
I127	2024-08-06	Pedido semanal (Agosto W1)	70000	C222	03	E004
I128	2024-08-13	Compra semanal (Agosto W2)	171000	C232	04	E005
I129	2024-08-20	Venta semanal (Agosto W3)	110000	C242	02	E003
I130	2024-08-27	Pedido semanal (Agosto W4)	232000	C252	01	E004
I131	2024-09-03	Compra semanal (Septiembre W1)	460000	C262	05	E005
I132	2024-09-10	Venta semanal (Septiembre W2)	166500	C272	01	E003
I133	2024-09-17	Pedido semanal (Septiembre W3)	590000	C282	03	E004
I134	2024-09-24	Compra semanal (Septiembre W4)	88200	C292	04	E005
I135	2024-10-01	Venta semanal (Octubre W1)	75000	C302	02	E003
I136	2024-10-08	Pedido semanal (Octubre W2)	208000	C312	01	E004
I137	2024-10-15	Compra semanal (Octubre W3)	210000	C322	05	E005
I138	2024-10-22	Venta semanal (Octubre W4)	333000	C332	01	E003
I139	2024-10-29	Pedido semanal (Octubre W5)	345000	C342	03	E004
I140	2024-11-05	Compra semanal (Noviembre W1)	193500	C352	04	E005
I141	2024-11-12	Venta semanal (Noviembre W2)	250000	C362	02	E003
I142	2024-11-19	Pedido semanal (Noviembre W3)	384000	C372	01	E004
I143	2024-11-26	Compra semanal (Noviembre W4)	160000	C382	05	E005
I144	2024-12-03	Venta semanal (Diciembre W1)	99000	C392	01	E003
I145	2024-12-10	Pedido semanal (Diciembre W2)	70000	C402	03	E004
I146	2024-12-17	Compra semanal (Diciembre W3)	112500	C412	04	E005
I147	2024-12-24	Venta semanal (Diciembre W4)	45000	C422	02	E003
I148	2024-12-31	Pedido semanal (Diciembre W5)	76000	C432	01	E004
I149	2024-01-15	Factura cliente C442	130000	C442	05	E005
I150	2024-01-16	Venta especial empleado E003	180000	C452	01	E003
I180	2024-02-15	Pedido post-San Valentín C752	310000	C752	02	E003
I181	2024-02-16	Venta con descuento acumulado C762	180000	C762	01	E004
I182	2024-02-17	Factura cliente C772 (Daviplata)	170000	C772	05	E005
I183	2024-02-18	Compra de fragancias frescas C782	522000	C782	02	E003
I184	2024-02-19	Venta productos de cuidado C792	100000	C792	01	E004
I185	2024-02-20	Pedido corporativo pequeño C802	117000	C802	03	E005
I186	2024-02-21	Factura con promoción activa C812	76000	C812	04	E003
I187	2024-02-22	Compra para obsequio C822	840000	C822	02	E004
I188	2024-02-23	Venta en tienda física C832	324000	C832	01	E005
I189	2024-02-24	Pedido online varios productos C842	230000	C842	05	E003
I190	2024-02-25	Factura cliente C852 (Transf.)	171000	C852	02	E004
I191	2024-02-26	Compra de perfumes de nicho C862	670000	C862	01	E005
I192	2024-02-27	Venta de liquidación C872	135000	C872	03	E003
I193	2024-02-28	Pedido fin de mes febrero C882	108000	C882	04	E004
I194	2024-02-29	Factura especial año bisiesto C892	230000	C892	02	E005
I195	2024-03-01	Compra inicio de marzo C902	216000	C902	01	E003
I196	2024-03-02	Venta Día de la Mujer (anticipada) C912	220000	C912	05	E004
I197	2024-03-03	Pedido perfumes florales promo C922	261000	C922	02	E005
I198	2024-03-04	Factura cliente C932	180000	C932	01	E003
I199	2024-03-05	Compra online C942	225000	C942	03	E004
I200	2024-03-06	Venta con descuento C952	72000	C952	04	E005
I201	2024-03-07	Pedido Día de la Mujer C962	360000	C962	02	E003
I202	2024-03-08	¡VENTA ESPECIAL DÍA MUJER!	72000	C972	01	E004
I203	2024-03-09	Factura cliente C982	200000	C982	05	E005
I204	2024-03-10	Compra perfumes verdes C992	67500	C992	02	E003
I205	2024-03-11	Venta St. Patrick (anticipada) C003	520000	C003	01	E004
I206	2024-03-12	Pedido con promoción C013	121500	C013	03	E005
I207	2024-03-13	Factura cliente frecuente C023	80000	C023	04	E003
I208	2024-03-14	Compra online C033	780000	C033	02	E004
I209	2024-03-15	Venta quincena C043	306000	C043	01	E005
I210	2024-03-16	Pedido St. Patrick C053	255000	C053	05	E003
I211	2024-03-17	¡Venta St. Patrick's Day!	162000	C063	02	E004
I212	2024-03-18	Factura cliente C073	700000	C073	01	E005
I213	2024-03-19	Compra de primavera C083	76500	C083	03	E003
I214	2024-03-20	Venta con descuento floral C093	124000	C093	04	E004
I215	2024-03-21	Pedido bienvenida primavera C103	650000	C103	02	E005
I216	2024-03-22	Factura cliente C113	351000	C113	01	E003
I217	2024-03-23	Compra online C123	98000	C123	05	E004
I218	2024-03-24	Venta perfumes frescos C133	157500	C133	02	E005
I219	2024-03-25	Pedido promoción semanal C143	90000	C143	01	E003
I220	2024-03-26	Factura cliente C153	342000	C153	03	E004
I221	2024-03-27	Compra de regalos C163	296000	C163	04	E005
I222	2024-03-28	Venta fin de mes marzo C173	480000	C173	02	E003
I223	2024-03-29	Pedido online C183	189000	C183	01	E004
I224	2024-03-30	Factura cliente C193	730000	C193	05	E005
I225	2024-03-31	Compra de Pascua (anticipada) C203	112500	C203	02	E003
I226	2024-04-01	¡Venta April Fools!	165000	C213	01	E004
I227	2024-04-02	Pedido promoción Abril C223	108000	C223	03	E005
I228	2024-04-03	Factura cliente C233	204000	C233	04	E003
I229	2024-04-04	Compra online C243	460000	C243	02	E004
I230	2024-04-05	Venta perfumes cítricos C253	297000	C253	01	E005
I231	2024-04-06	Pedido fin de semana C263	265000	C263	05	E003
I232	2024-04-07	Factura cliente C273	175500	C273	02	E004
I233	2024-04-08	Compra de fragancias nuevas C283	600000	C283	01	E005
I234	2024-04-09	Venta con descuento C293	72000	C293	03	E003
I235	2024-04-10	Pedido online C303	48000	C303	04	E004
I236	2024-04-11	Factura cliente C313	380000	C313	02	E005
I237	2024-04-12	Compra flash sale Abril C323	99000	C323	01	E003
I238	2024-04-13	Venta perfumes orientales C333	185000	C333	05	E004
I239	2024-04-14	Pedido fin de semana C343	103500	C343	02	E005
I240	2024-04-15	Factura cliente C353	550000	C353	01	E003
I241	2024-04-16	Compra de regalos de primavera C363	405000	C363	03	E004
I242	2024-04-17	Venta con promoción C373	176000	C373	04	E005
I243	2024-04-18	Pedido online C383	600000	C383	02	E003
I244	2024-04-19	Factura cliente C393	1080000	C393	01	E004
I245	2024-04-20	Compra de Pascua C403	145000	C403	05	E005
I246	2024-04-21	Venta perfumes florales suaves C413	180000	C413	02	E003
I247	2024-04-22	¡VENTA DÍA DE LA TIERRA!	100000	C423	01	E004
I248	2024-04-23	Pedido productos sostenibles C433	288000	C433	03	E005
I249	2024-04-24	Factura cliente C443	156000	C443	04	E003
I250	2024-04-25	Compra online C453	680000	C453	02	E004
I427	2024-10-19	Pedido promociones por catalogo C225	265000	C225	02	E004
I428	2024-10-20	Factura cliente recurrente C235	175500	C235	01	E005
I429	2024-10-21	Compra de invierno con descuento C245	440000	C245	03	E003
I430	2024-10-22	Venta día de la madre Colombia C255	236000	C255	04	E005
I431	2024-10-23	Pedido para un caballero C265	274500	C265	02	E004
I432	2024-10-24	Factura con pago en línea C275	112000	C275	01	E005
I433	2024-10-25	Compra fragancias frescas C285	396000	C285	05	E003
I434	2024-10-26	Venta promo Halloween C295	390000	C295	02	E004
I435	2024-10-27	Pedido para celebración especial C305	211500	C305	01	E005
I436	2024-10-28	Factura online Halloween C315	164000	C315	03	E004
I437	2024-10-29	Compra de perfumes y licores C325	1350000	C325	04	E005
I438	2024-10-30	Venta con regalo sorpresa C335	124200	C335	02	E003
I439	2024-10-31	¡¡¡COMPRA HOY y RECIBE DULCES!!!	172000	C345	01	E004
I440	2024-11-01	Pedido día de los santos C355	136800	C355	05	E005
I441	2024-11-02	Factura en el mes del Mundial C365	172000	C365	02	E003
I442	2024-11-03	Compra de lociones corporales C375	310500	C375	01	E004
I443	2024-11-04	Venta para un cliente recurrente C385	224000	C385	03	E005
I444	2024-11-05	Pedido semana de la música C395	420000	C395	04	E003
I445	2024-11-06	Factura en línea con tarjeta C405	504000	C405	02	E004
I446	2024-11-07	Compra con envío a la costa C415	82000	C415	01	E005
I447	2024-11-08	Venta con entrega a domicilio C425	151200	C425	05	E003
I448	2024-11-09	Pedido online con envío express C435	182000	C435	02	E004
I449	2024-11-10	Factura especial en noviembre C445	106200	C445	01	E005
\.


                                                      5136.dat                                                                                            0000600 0004000 0002000 00000075670 15014423351 0014265 0                                                                                                    ustar 00postgres                        postgres                        0000000 0000000                                                                                                                                                                        IW01	2025-09-27	Tarjetas visita S414	1575000	S414
IW02	2025-10-04	Café para clientes S415	5387500	S415
IW03	2025-10-09	Purificadores aire S416	5400000	S416
IW04	2025-10-14	Marketing olfativo S417	5580000	S417
IW05	2025-10-19	Kits iniciación S418	2960000	S418
IW06	2025-10-27	Packaging envíos S419	9450000	S419
IW07	2025-11-04	Muestras proveedor S420	1953000	S420
IW08	2025-11-09	Atomizadores recarga S421	8010000	S421
IW09	2025-11-14	Envases lujo S422	2700000	S422
IW10	2025-11-19	Estuches premium S423	2736000	S423
IW11	2025-11-27	Hidrolatos S424	3127500	S424
IW12	2025-12-04	Ceras naturales S425	5940000	S425
IW13	2025-12-09	Pabilos velas S426	1350000	S426
IW14	2025-12-14	Vidrio oscuro S427	25115000	S427
IW15	2025-12-19	Tapones corcho S428	1080000	S428
IW16	2025-12-27	Roll-on ámbar S429	3150000	S429
IW17	2023-10-13	Alcohol cereal S430	4400000	S430
IW18	2023-10-18	Envases airless S431	7425000	S431
IW19	2023-10-23	Etiquetas agua S432	1539000	S432
IW20	2023-10-28	Material talleres S433	2920000	S433
IW21	2023-11-05	Incienso grano S434	1485000	S434
IW22	2023-11-10	Carbones incienso S435	3375000	S435
IW23	2023-11-15	Plumas decorativas S436	13975000	S436
IW24	2023-11-20	Lazos seda S437	2520000	S437
IW25	2023-11-28	Cajas madera S438	2205000	S438
IW26	2023-12-05	Expositores metacrilato S439	17700000	S439
IW27	2023-12-10	Bolsas yute S440	1485000	S440
IW28	2023-12-15	Papel secante S441	6840000	S441
IW29	2023-12-20	Vitrinas LED S442	1445000	S442
IW30	2023-12-28	Limpieza vidrios S443	2376000	S443
IW31	2024-01-05	Esencias florales S444	4500000	S444
IW32	2024-01-10	Envases 50ml S445	15442500	S445
IW33	2024-01-15	Químicos aromáticos S446	3240000	S446
IW34	2024-01-20	Etiquetas S447	1575000	S447
IW35	2024-01-28	Importación lujo S448	10700000	S448
IW36	2024-02-05	Materia prima natural S449	1687500	S449
IW37	2024-02-10	Esencias amaderadas S450	10260000	S450
IW38	2024-02-15	Cajas personalizadas S001	960000	S001
IW39	2024-02-20	Componentes nicho S002	1782000	S002
IW40	2024-02-28	Botellas diseño S003	3375000	S003
IW41	2024-03-05	Etiquetas Navidad S004	13975000	S004
IW42	2024-03-10	Importación bestsellers S005	2520000	S005
IW43	2024-03-15	Extractos orgánicos S006	1260000	S006
IW44	2024-03-20	Envases estándar S007	17700000	S007
IW45	2024-03-28	Esencias cítricas S008	2700000	S008
IW46	2024-04-05	Químicos vainilla S009	1710000	S009
IW47	2024-04-10	Botellas San Valentín S010	1692500	S010
IW48	2024-04-15	Material marketing S011	2227500	S011
IW49	2024-04-20	Importación florales S012	3150000	S012
IW50	2024-04-28	Materia prima románticos S013	25315000	S013
IS51	2024-08-07	Compra químicos aromáticos (notas juveniles)	7438500	S055
IS52	2024-08-12	Adquisición material de papelería (facturas)	7830000	S057
IS53	2024-08-18	Pedido etiquetas para nueva colección otoño	7920000	S061
IS54	2024-08-25	Importación fragancias amaderadas y especiadas	8037500	S060
IS55	2024-09-01	Compra materia prima (canela, clavo, nuez)	5040000	S059
IS56	2024-09-07	Suministro esencias de pachulí y sándalo	2812500	S063
IS57	2024-09-12	Pedido embalajes temáticos de otoño	6018000	S064
IS58	2024-09-18	Compra componentes para difusores de ambiente	3420000	S065
IS59	2024-09-25	Adquisición botellas de color ámbar	6075000	S066
IS60	2024-10-01	Pedido etiquetas para línea Halloween	5037500	S067
IS61	2024-10-07	Importación fragancias misteriosas y oscuras	2565000	S070
IS62	2024-10-12	Compra extractos de incienso y mirra	2808000	S069
IS63	2024-10-18	Suministro envases con diseño gótico	3450000	S072
IS64	2024-10-25	Pedido esencias de calabaza y especias	2283750	S071
IS65	2024-11-01	Compra químicos aromáticos (notas cálidas)	5580000	S075
IS66	2024-11-07	Adquisición botellas para edición navideña	3464000	S076
IS67	2024-11-12	Pedido material de regalo (cintas, papel)	3726000	S077
IS68	2024-11-18	Importación fragancias festivas (pino, canela)	1530000	S080
IS69	2024-11-25	Compra materia prima para velas navideñas	2596000	S079
IS70	2024-12-01	Suministro esencias de abeto y jengibre	3825000	S081
IS71	2024-12-07	Pedido cajas de regalo con motivos navideños	4725000	S084
IS72	2024-12-12	Compra componentes para sets de lujo Navidad	4287500	S083
IS73	2024-12-18	Adquisición botellas doradas y plateadas	10800000	S086
IS74	2023-10-12	Suministro de alcohol perfumista	4117500	S087
IS75	2023-10-18	Compra fijadores y solventes	3990000	S090
IS76	2023-10-22	Adquisición de pipetas y material de laboratorio	3150000	S089
IS77	2023-11-05	Pedido frascos muestra (viales) 2ml	3780000	S092
IS78	2023-11-10	Compra tapones y pulverizadores estándar	1040000	S091
IS79	2023-11-15	Suministro de bolsas de papel y tela para tienda	1620000	S095
IS80	2023-11-20	Adquisición de material de limpieza para laboratorio	5670000	S096
IS81	2023-11-28	Pedido de uniformes para personal de tienda	4850000	S097
IS82	2023-12-05	Compra software de gestión de inventario	7650000	S100
IS83	2023-12-10	Suministro de material de oficina (papelería)	4536000	S099
IS84	2023-12-15	Adquisición de muebles expositores para tienda	2987500	S101
IS85	2024-01-05	Mantenimiento de equipos de laboratorio	1260000	S102
IS86	2024-01-12	Servicio de diseño gráfico para etiquetas nuevas	2970000	S103
IX50	2025-10-31	Muestras de fragancias de la competencia (estudio) S112	14268000	S112
IX12	2025-04-24	Uniformes de diseño para equipo de ventas S074	5985000	S074
IX13	2025-04-29	Actualización software de formulación S075	27000000	S075
IX14	2025-05-04	Papelería corporativa (sobres, hojas membretadas) S076	7365000	S076
IX15	2025-05-09	Muebles de exhibición para nueva colección S077	2394000	S077
IX16	2025-05-14	Servicio calibración de balanzas de precisión S078	6682500	S078
IX17	2025-05-19	Diseño de campaña publicitaria impresa S079	8124500	S079
IX18	2025-05-24	Contrato anual servicio de transporte refrigerado S080	5400000	S080
IX19	2025-05-29	Insumos para empaque anti-impacto (foam) S081	35437500	S081
IX20	2025-06-03	Pedido esencias marinas y ozónicas S082	888500	S082
IX21	2025-06-08	Colorantes naturales para cosmética S083	13860000	S083
IX22	2025-06-13	Cera de carnauba y candelilla S084	20700000	S084
IX23	2025-06-18	Moldes de silicona para formas especiales S085	8590000	S085
IX24	2025-06-23	Bases para perfume en crema S086	6840000	S086
IX25	2025-06-28	Aceite esencial de Sándalo Australiano S087	1831500	S087
IX26	2025-07-03	Packaging de caña de azúcar S088	22215000	S088
IX27	2025-07-08	Difusores de ambiente ultrasónicos S089	7875000	S089
IX28	2025-07-13	Recargas para difusores con nuevos aromas S090	23247000	S090
IX29	2025-07-18	Resina de elemí y gálbano S091	1358000	S091
IX30	2025-07-23	Quemadores de resina con diseño S092	23625000	S092
IX31	2025-07-28	Libros de formulación avanzada S093	19800000	S093
IX32	2025-08-02	Musgo de roble y absoluto de heno S094	1866000	S094
IT51	2023-11-13	Embalaje S167	0	S167
IT52	2023-11-19	Componentes S168 (nicho)	0	S168
IT53	2023-11-26	Botellas S169 (diseño)	0	S169
IT54	2023-12-02	Etiquetas S170 (Navidad)	0	S170
IT55	2023-12-08	Importación S171 (bestsellers)	0	S171
IT56	2023-12-13	Extractos S172 (orgánicos)	0	S172
IT57	2023-12-19	Envases S173 (estándar)	0	S173
IT58	2024-01-03	Esencias S174 (cítricas)	0	S174
IT59	2024-01-08	Químicos S175 (vainilla)	0	S175
IT60	2024-01-14	Botellas S176 (San Valentín)	0	S176
IT61	2024-01-19	Marketing S177 (material)	0	S177
IT62	2024-01-25	Importación S178 (florales)	0	S178
IT63	2024-01-31	Materia prima S179 (románticos)	0	S179
IT64	2024-02-06	Esencias S180 (rosa)	0	S180
IT65	2024-02-11	Embalajes S181 (San Valentín)	0	S181
IT66	2024-02-17	Componentes S182 (sets)	0	S182
IT67	2024-02-24	Botellas S183 (atomizador lujo)	0	S183
IT68	2024-02-29	Etiquetas S184 (Día Mujer)	0	S184
IT69	2024-03-06	Importación S185 (frutales)	0	S185
IT70	2024-03-11	Extractos S186 (flores exóticas)	0	S186
IT71	2024-03-17	Envases S187 (roll-on)	0	S187
IT72	2024-03-24	Esencias S188 (verdes)	0	S188
IT73	2024-03-31	Químicos S189 (acuáticos)	0	S189
IT74	2024-04-06	Botellas S190 (reciclado)	0	S190
IT75	2024-04-11	Promocional S191 (muestras)	0	S191
IT76	2024-04-17	Importación S192 (verano)	0	S192
IT77	2024-04-24	Materia prima S193 (solar)	0	S193
IT78	2024-04-30	Esencias S194 (Día Madre)	0	S194
IT79	2024-05-06	Cajas regalo S195	0	S195
IT80	2024-05-11	Componentes S196 (velas)	0	S196
IT81	2024-05-17	Botellas S197 (artesanal)	0	S197
IT82	2024-05-24	Etiquetas S198 (VIP)	0	S198
IT83	2024-05-31	Importación S199 (masculinas)	0	S199
IT84	2024-06-06	Extractos S200 (cuero)	0	S200
IT85	2024-06-11	Neceseres S201	0	S201
IT86	2024-06-17	Esencias S202 (deportivas)	0	S202
IT87	2024-06-24	Químicos S203 (marinas)	0	S203
IT88	2024-06-30	Botellas S204 (verano)	0	S204
IT89	2024-07-06	Empaque S205 (playa)	0	S205
IT90	2024-07-11	Importación S206 (tropicales)	0	S206
IT91	2024-07-17	Materia prima S207 (mists)	0	S207
IT92	2024-07-24	Esencias S208 (cítricas)	0	S208
IT93	2024-07-31	Envases S209 (Regreso Clases)	0	S209
IT94	2024-08-06	Químicos S210 (juveniles)	0	S210
IT95	2024-08-11	Papelería S211 (facturas)	0	S211
IT96	2024-08-17	Etiquetas S212 (otoño)	0	S212
IT97	2024-08-24	Importación S213 (amaderadas)	0	S213
IT98	2024-08-31	Materia prima S214 (especias)	0	S214
IT99	2024-09-06	Esencias S215 (pachulí)	0	S215
IW95	2025-01-28	Químicos cálidos S058	9967000	S058
IW96	2025-02-05	Botellas Navidad S059	9405000	S059
IW97	2025-02-10	Material regalo S060	1386000	S060
IW98	2025-02-15	Importación festivas S061	19987500	S061
IW99	2025-02-20	Materia prima velas Navidad S062	6187500	S062
IX01	2025-02-28	Esencias abeto S063	13608000	S063
IX02	2025-03-05	Cajas regalo Navidad S064	4397000	S064
IX03	2025-03-10	Componentes sets lujo S065	3937500	S065
IX04	2025-03-15	Botellas doradas S066	15840000	S066
IX05	2025-03-20	Alcohol perfumista S067	7720500	S067
IX06	2025-03-25	Fijadores y solventes S068	11115000	S068
IX07	2025-03-30	Material de laboratorio especializado S069	3960000	S069
IX08	2025-04-04	Pedido grande frascos muestra 1ml S070	5452500	S070
IX09	2025-04-09	Tapones pulverizadores de alta gama S071	16875000	S071
IX10	2025-04-14	Bolsas de lujo para entrega en tienda S072	19845000	S072
IX11	2025-04-19	Material de limpieza específico para producción S073	2889500	S073
IX33	2025-08-07	Herramientas de precisión para mezclas S095	11542500	S095
IX34	2025-08-12	Envases de muestra tipo spray 1.5ml S096	2722500	S096
IX35	2025-08-17	Cintas de satén con logo impreso S097	7068000	S097
IX36	2025-08-22	Aceite de argán y rosa mosqueta (portadores) S098	14062500	S098
IX37	2025-08-27	Bases para jabón de glicerina transparente S099	7087500	S099
IX38	2025-09-01	Productos de limpieza biodegradables para producción S100	3161000	S100
IX39	2025-09-06	Bolsas de tela organdí para regalos S101	18112500	S101
IX40	2025-09-11	Expositores de bambú para productos eco S102	23400000	S102
IX41	2025-09-16	Etiquetas de papel reciclado con semillas S103	5372000	S103
IX42	2025-09-21	Licencia de software de diseño de etiquetas S104	3163500	S104
IX43	2025-09-26	Elementos decorativos para tienda (temporada otoño) S105	7425000	S105
IX44	2025-10-01	Folletos de nuevos lanzamientos S106	10335000	S106
IX45	2025-10-06	Suscripción a revistas especializadas de perfumería S107	9225000	S107
IX46	2025-10-11	Humidificadores para mantener calidad de aire en bodega S108	10773000	S108
IX47	2025-10-16	Esencias para velas (alta concentración) S109	5391200	S109
IX48	2025-10-21	Kits de creación de perfumes para clientes S110	20745000	S110
IX49	2025-10-26	Packaging para envíos internacionales (reforzado) S111	6030000	S111
IU51	2025-07-11	Limpieza tienda S266	0	S266
IU52	2025-07-17	Bolsas reutilizables S267	0	S267
IU53	2025-07-24	Expositores S268	0	S268
IU54	2025-07-31	Etiquetas seguridad S269	0	S269
IU55	2025-08-06	Software TPV S270	0	S270
IU56	2025-08-11	Decoración vitrinas S271	0	S271
IU57	2025-08-17	Tarjetas visita S272	0	S272
IU58	2025-08-24	Café para clientes S273	0	S273
IU59	2025-08-31	Purificadores aire S274	0	S274
IU60	2025-09-06	Marketing olfativo S275	0	S275
IU61	2025-09-11	Kits iniciación S276	0	S276
IU62	2025-09-17	Packaging envíos S277	0	S277
IU63	2025-09-24	Muestras proveedor S278	0	S278
IU64	2025-09-30	Atomizadores recarga S279	0	S279
IU65	2025-10-06	Envases lujo S280	0	S280
IU66	2025-10-11	Estuches premium S281	0	S281
IU67	2025-10-17	Hidrolatos S282	0	S282
IU68	2025-10-24	Ceras naturales S283	0	S283
IU69	2025-10-31	Pabilos velas S284	0	S284
IU70	2025-11-06	Vidrio oscuro S285	0	S285
IU71	2025-11-11	Tapones corcho S286	0	S286
IU72	2025-11-17	Roll-on ámbar S287	0	S287
IU73	2025-11-24	Alcohol cereal S288	0	S288
IU74	2025-11-30	Envases airless S289	0	S289
IU75	2025-12-06	Etiquetas agua S290	0	S290
IU76	2025-12-11	Material talleres S291	0	S291
IU77	2025-12-17	Incienso grano S292	0	S292
IU78	2025-12-24	Carbones incienso S293	0	S293
IU79	2025-12-31	Plumas decorativas S294	0	S294
IU80	2023-10-07	Lazos seda S295	0	S295
IU81	2023-10-12	Cajas madera S296	0	S296
IU82	2023-10-17	Expositores metacrilato S297	0	S297
IU83	2023-10-22	Bolsas yute S298	0	S298
IU84	2023-10-27	Papel secante S299	0	S299
IU85	2023-11-04	Vitrinas LED S300	0	S300
IU86	2023-11-09	Limpieza vidrios S301	0	S301
IU87	2023-11-14	Esencias florales S302	0	S302
IU88	2023-11-19	Envases 50ml S303	0	S303
IU89	2023-11-27	Químicos aromáticos S304	0	S304
IU90	2023-12-04	Etiquetas S305	0	S305
IU91	2023-12-09	Importación lujo S306	0	S306
IU92	2023-12-14	Materia prima natural S307	0	S307
IU93	2023-12-19	Esencias amaderadas S308	0	S308
IU94	2023-12-27	Cajas personalizadas S309	0	S309
IU95	2024-01-04	Componentes nicho S310	0	S310
IU96	2024-01-09	Botellas diseño S311	0	S311
IU97	2024-01-14	Etiquetas Navidad S312	0	S312
IU98	2024-01-19	Importación bestsellers S313	0	S313
IU99	2024-01-27	Extractos orgánicos S314	0	S314
IV51	2024-12-04	Esencias calabaza S365	0	S365
IV52	2024-12-09	Químicos cálidos S366	0	S366
IV53	2024-12-14	Botellas Navidad S367	0	S367
IV54	2024-12-19	Material regalo cintas S368	0	S368
IV55	2024-12-27	Importación festivas S369	0	S369
IV56	2025-01-04	Materia prima velas Navidad S370	0	S370
IV57	2025-01-09	Esencias abeto S371	0	S371
IV58	2025-01-14	Cajas regalo Navidad S372	0	S372
IV59	2025-01-19	Componentes sets lujo S373	0	S373
IV60	2025-01-27	Botellas doradas S374	0	S374
IV61	2025-02-04	Alcohol perfumista S375	0	S375
IV62	2025-02-09	Fijadores S376	0	S376
IV63	2025-02-14	Material laboratorio S377	0	S377
IV64	2025-02-19	Frascos muestra S378	0	S378
IV65	2025-02-27	Tapones S379	0	S379
IV66	2025-03-04	Bolsas tienda S380	0	S380
IV67	2025-03-09	Limpieza laboratorio S381	0	S381
IV68	2025-03-14	Uniformes S382	0	S382
IV69	2025-03-19	Software inventario S383	0	S383
IV70	2025-03-27	Material oficina S384	0	S384
IV71	2025-04-04	Muebles expositores S385	0	S385
IV72	2025-04-09	Mantenimiento equipos S386	0	S386
IV73	2025-04-14	Diseño etiquetas S387	0	S387
IV74	2025-04-19	Mensajería S388	0	S388
IV75	2025-04-27	Insumos empaque S389	0	S389
IV76	2025-05-04	Esencias raras S390	0	S390
IV77	2025-05-09	Colorantes S391	0	S391
IV78	2025-05-14	Mechas y cera S392	0	S392
IV79	2025-05-19	Moldes jabón S393	0	S393
IV80	2025-05-27	Bases perfume S394	0	S394
IV81	2025-06-04	Aceites esenciales S395	0	S395
IV82	2025-06-09	Packaging eco S396	0	S396
IV83	2025-06-14	Difusores S397	0	S397
IV84	2025-06-19	Recargas difusor S398	0	S398
IV85	2025-06-27	Inciensos S399	0	S399
IV86	2025-07-04	Quemadores S400	0	S400
IV87	2025-07-09	Libros perfumería S401	0	S401
IV88	2025-07-14	Flores secas S402	0	S402
IV89	2025-07-19	Herramientas taller S403	0	S403
IV90	2025-07-27	Envases miniatura S404	0	S404
IV91	2025-08-04	Cintas decorativas S405	0	S405
IV92	2025-08-09	Aceites portadores S406	0	S406
IV93	2025-08-14	Glicerina S407	0	S407
IV94	2025-08-19	Limpieza tienda S408	0	S408
IV95	2025-08-27	Bolsas reutilizables S409	0	S409
IV96	2025-09-04	Expositores S410	0	S410
IV97	2025-09-09	Etiquetas seguridad S411	0	S411
IV98	2025-09-14	Software TPV S412	0	S412
IV99	2025-09-19	Decoración vitrinas S413	0	S413
IW51	2024-05-05	Esencias rosa S014	12622500	S014
IW52	2024-05-10	Embalajes San Valentín S015	2250000	S015
IW53	2024-05-15	Componentes sets S016	22210000	S016
IW54	2024-05-20	Botellas atomizador S017	13365000	S017
IW55	2024-05-28	Etiquetas Día Mujer S018	17775000	S018
IW56	2024-06-05	Importación frutales S019	10170000	S019
IW57	2024-06-10	Extractos flores S020	23782500	S020
IW58	2024-06-15	Envases roll-on S021	5175000	S021
IW59	2024-06-20	Esencias verdes S022	23110000	S022
IW60	2024-06-28	Químicos acuáticos S023	3847500	S023
IW61	2024-07-05	Botellas reciclado S024	4059000	S024
IW62	2024-07-10	Promocional S025	19667500	S025
IW63	2024-07-15	Importación verano S026	5400000	S026
IW64	2024-07-20	Materia prima solar S027	31752000	S027
IW65	2024-07-28	Esencias Día Madre S028	4540000	S028
IW66	2024-08-05	Cajas regalo S029	7875000	S029
IW67	2024-08-10	Componentes velas S030	9900000	S030
IW68	2024-08-15	Botellas artesanal S031	2640000	S031
IW69	2024-08-20	Etiquetas VIP S032	11799000	S032
IW70	2024-08-28	Importación masculinas S033	5346000	S033
IW71	2024-09-05	Extractos cuero S034	10250000	S034
IW72	2024-09-10	Neceseres S035	7875000	S035
IW73	2024-09-15	Esencias deportivas S036	15592500	S036
IW74	2024-09-20	Químicos marinas S037	6062000	S037
IW75	2024-09-28	Botellas verano S038	14175000	S038
IW76	2024-10-05	Empaque playa S039	4680000	S039
IW77	2024-10-10	Importación tropicales S040	8610000	S040
IW78	2024-10-15	Materia prima mists S041	6156000	S041
IW79	2024-10-20	Esencias cítricas S042	7425000	S042
IW80	2024-10-28	Envases Regreso Clases S043	5543000	S043
IW81	2024-11-05	Químicos juveniles S044	13050000	S044
IW82	2024-11-10	Papelería S045	22680000	S045
IW83	2024-11-15	Etiquetas otoño S046	2655000	S046
IW84	2024-11-20	Importación amaderadas S047	19687500	S047
IW85	2024-11-28	Materia prima especias S048	4500000	S048
IW86	2024-12-05	Esencias pachulí S049	5830000	S049
IW87	2024-12-10	Embalajes otoño S050	9832500	S050
IW88	2024-12-15	Componentes difusores S051	6435000	S051
IW89	2024-12-20	Botellas ámbar S052	11835000	S052
IW90	2024-12-28	Etiquetas Halloween S053	4162500	S053
IW91	2025-01-05	Importación misteriosas S054	42525000	S054
IW92	2025-01-10	Extractos incienso S055	2466000	S055
IW93	2025-01-15	Envases gótico S056	12915000	S056
IW94	2025-01-20	Esencias calabaza S057	6840000	S057
IS01	2023-10-05	Pedido inicial esencias florales base	5500000	S001
IS02	2023-10-10	Compra lote envases vidrio 50ml y 100ml	4800000	S004
IS03	2023-10-15	Adquisición químicos aromáticos para producción	7000000	S005
IS04	2023-10-20	Pedido etiquetas y material de empaque	6900000	S007
IS05	2023-10-25	Importación fragancias de lujo (muestra)	4500000	S010
IS06	2023-11-02	Compra materia prima natural (extractos)	1500000	S009
IS07	2023-11-08	Pedido mensual esencias amaderadas	3700000	S011
IS08	2023-11-12	Suministro cajas y embalaje personalizado	3600000	S014
IS09	2023-11-18	Compra componentes para perfumes nicho	5600000	S013
IS10	2023-11-25	Adquisición botellas de diseño especial	5100000	S016
IS11	2023-12-01	Pedido etiquetas para edición navideña	2380000	S017
IS12	2023-12-07	Importación lotes fragancias más vendidas	3000000	S020
IS13	2023-12-12	Compra extractos orgánicos certificados	2250000	S019
IS14	2023-12-18	Suministro mensual envases estándar	5100000	S022
IS15	2024-01-04	Pedido esencias cítricas y frescas (Año Nuevo)	3900000	S021
IS16	2024-01-09	Compra químicos aromáticos (vainilla, ámbar)	3000000	S025
IS17	2024-01-15	Adquisición botellas para línea San Valentín	2850000	S026
IS18	2024-01-20	Pedido material de marketing y display	1620000	S027
IS19	2024-01-26	Importación fragancias florales (nuevas)	2450000	S030
IS20	2024-02-01	Compra materia prima para perfumes románticos	2060000	S029
IS21	2024-02-07	Suministro esencias de rosa y jazmín	4950000	S031
IS22	2024-02-12	Pedido embalajes especiales San Valentín	5700000	S034
IS23	2024-02-18	Compra componentes para sets de regalo	3250000	S033
IS24	2024-02-25	Adquisición botellas con atomizador de lujo	3000000	S036
IS25	2024-03-01	Pedido etiquetas para línea Día de la Mujer	2640000	S037
IS26	2024-03-07	Importación fragancias frutales y gourmand	1470000	S040
IS27	2024-03-12	Compra extractos de flores exóticas	1375000	S039
IS28	2024-03-18	Suministro envases roll-on y travel size	1600000	S042
IS29	2024-03-25	Pedido esencias verdes y herbales (Primavera)	1800000	S041
IS30	2024-04-01	Compra químicos aromáticos (notas acuáticas)	2250000	S045
IS31	2024-04-07	Adquisición botellas de vidrio reciclado	5350000	S046
IS32	2024-04-12	Pedido material promocional y muestras	7000000	S047
IS33	2024-04-18	Importación fragancias frescas para verano	4040000	S050
IS34	2024-04-25	Compra materia prima para línea solar	5000000	S049
IS35	2024-05-01	Suministro esencias florales para Día Madre	6250000	S002
IS36	2024-05-07	Pedido cajas de regalo y lazos especiales	3690000	S003
IS37	2024-05-12	Compra componentes para velas aromáticas	6720000	S008
IS38	2024-05-18	Adquisición botellas de diseño artesanal	6900000	S006
IS39	2024-05-25	Pedido etiquetas personalizadas para clientes VIP	5600000	S012
IS40	2024-06-01	Importación fragancias masculinas (Día Padre)	7200000	S015
IS41	2024-06-07	Compra extractos amaderados y de cuero	4800000	S018
IS42	2024-06-12	Suministro neceseres y kits de afeitado	5600000	S023
IS43	2024-06-18	Pedido esencias deportivas y energizantes	6000000	S028
IS44	2024-06-25	Compra químicos aromáticos (notas marinas)	3300000	S032
IS45	2024-07-01	Adquisición botellas para línea de verano	3120000	S035
IS46	2024-07-07	Pedido material de empaque temático (playa)	3200000	S038
IS47	2024-07-12	Importación fragancias tropicales y frutales	3800000	S043
IS48	2024-07-18	Compra materia prima para body mists	4300000	S048
IS49	2024-07-25	Suministro esencias cítricas refrescantes	4590000	S052
IS50	2024-08-01	Pedido envases para línea Regreso a Clases	3500000	S054
IS87	2024-01-19	Contratación servicio de mensajería local	4400000	S104
IS88	2024-01-28	Compra de insumos para empaque (burbujas, relleno)	4455000	S105
IS89	2024-02-05	Pedido de esencias exóticas raras	4961250	S106
IS90	2024-02-10	Suministro de colorantes para jabones y velas	12550000	S107
IS91	2024-02-15	Adquisición de mechas y cera de soja para velas	2700000	S108
IS92	2024-02-20	Compra de moldes para jabones artesanales	2700000	S109
IS93	2024-02-28	Pedido de bases para perfumes (sin alcohol)	4172500	S110
IS94	2024-03-05	Suministro de aceites esenciales puros (aromaterapia)	2565000	S111
IS95	2024-03-10	Adquisición de packaging biodegradable	1260000	S112
IS96	2024-03-15	Compra de difusores eléctricos y de varillas	2470000	S113
IS97	2024-03-20	Pedido de recargas para difusores de ambiente	2565000	S114
IS98	2024-03-28	Suministro de inciensos naturales y resinas	4770000	S115
IS99	2024-04-05	Adquisición de quemadores de esencias y aceites	8305000	S116
IT01	2024-04-10	Compra de libros sobre perfumería y aromas	4455000	S117
IT02	2024-04-15	Pedido de flores secas y potpourri	7100000	S118
IT03	2024-04-20	Suministro de herramientas para taller de perfumería	7560000	S119
IT04	2024-04-28	Adquisición de envases miniatura para muestras	3420000	S120
IT05	2024-05-05	Compra de cintas decorativas y papel de seda	6100000	S121
IT06	2024-05-10	Pedido de aceites portadores (almendra, jojoba)	5130000	S122
IT07	2024-05-15	Suministro de glicerina y bases para jabón	2025000	S123
IT08	2024-05-20	Adquisición de productos de limpieza eco para tienda	5690000	S124
IT09	2024-05-28	Compra de bolsas de regalo reutilizables	3159000	S125
IT10	2024-06-05	Pedido de expositores acrílicos para productos	4725000	S126
IT11	2024-06-10	Suministro de etiquetas de seguridad y sellos	5097500	S127
IT12	2024-06-15	Adquisición de software TPV para punto de venta	2565000	S128
IT13	2024-06-20	Compra de elementos de decoración para vitrinas	2790000	S129
IT14	2024-06-28	Pedido de tarjetas de visita y folletos	2120000	S130
IT15	2024-07-05	Suministro de café y té para clientes en tienda	1440000	S131
IT16	2024-07-10	Adquisición de purificadores de aire para local	4221000	S132
IT17	2024-07-15	Compra de esencias para marketing olfativo	3583000	S133
IT18	2024-07-20	Pedido de kits de iniciación a la perfumería	6750000	S134
IT19	2024-07-28	Suministro de packaging para envíos online seguros	1080000	S135
IT20	2024-08-05	Adquisición de muestras de nuevas fragancias proveedor	2617500	S136
IT21	2024-08-10	Compra de atomizadores de recarga para viaje	1125000	S137
IT22	2024-08-15	Pedido de envases de lujo para ediciones especiales	4860000	S138
IT23	2024-08-20	Suministro de estuches y cajas premium	4962500	S139
IT24	2024-08-28	Adquisición de hidrolatos y aguas florales	7200000	S140
IT25	2024-09-05	Compra de ceras naturales para velas (abeja, coco)	3510000	S141
IT26	2024-09-10	Pedido de pabilos de madera y algodón para velas	4660000	S142
IT27	2024-09-15	Suministro de envases de vidrio oscuro para aceites	540000	S143
IT28	2024-09-20	Adquisición de tapones de corcho y madera	2835000	S144
IT29	2024-09-28	Compra de botellas roll-on de cristal ámbar	2942500	S145
IT30	2024-10-05	Pedido de alcohol de cereal tridestilado	891000	S146
IT31	2024-10-10	Suministro de envases airless para cremas	5220000	S147
IT32	2024-10-15	Adquisición de etiquetas resistentes al agua	6060000	S148
IT33	2024-10-20	Compra de material para talleres (fragancias, papeles secantes)	8325000	S149
IT34	2024-10-28	Pedido de incienso en grano (copal, mirra, benjuí)	3982500	S150
IT35	2024-11-05	Suministro de carbones vegetales para incienso	3428000	S151
IT36	2024-11-10	Adquisición de plumas y elementos decorativos para packaging	843750	S152
IT37	2024-11-15	Compra de lazos de seda y organza para regalos	16380000	S153
IT38	2024-11-20	Pedido de cajas de madera para sets de lujo	915000	S154
IT39	2024-11-28	Suministro de expositores de metacrilato	1665000	S155
IT40	2024-12-05	Adquisición de bolsas de yute personalizadas	4657500	S156
IT41	2024-12-10	Compra de papel secante de alta calidad (mouillettes)	4757500	S157
IT42	2024-12-15	Pedido de vitrinas con iluminación LED	7875000	S158
IT43	2024-12-20	Suministro de material de limpieza para vidrios y espejos	1728000	S159
IT44	2023-10-06	Factura proveedor S160 Octubre	3500000	S160
IT45	2023-10-11	Pedido a S161 (químicos)	1980000	S161
IT46	2023-10-16	Compra a S162 (envases)	630000	S162
IT47	2023-10-21	Factura S163 (etiquetas)	1928750	S163
IT48	2023-10-26	Importación S164 (lujo)	303750	S164
IT49	2023-11-03	Materia prima S165	1197000	S165
IT50	2023-11-09	Esencias S166 (amaderadas)	7850000	S166
IU01	2024-09-11	Embalajes S216 (otoño)	900000	S216
IU02	2024-09-17	Componentes S217 (difusores)	6582500	S217
IU03	2024-09-24	Botellas S218 (ámbar)	6750000	S218
IU04	2024-09-30	Etiquetas S219 (Halloween)	4950000	S219
IU05	2024-10-06	Importación S220 (misteriosas)	4890000	S220
IU06	2024-10-11	Extractos S221 (incienso)	4387500	S221
IU07	2024-10-17	Envases S222 (gótico)	3780000	S222
IU08	2024-10-24	Esencias S223 (calabaza)	5357500	S223
IU09	2024-10-31	Químicos S224 (cálidos)	3037500	S224
IU10	2024-11-06	Botellas S225 (Navidad)	5328000	S225
IU11	2024-11-11	Material regalo S226	6022500	S226
IU12	2024-11-17	Importación S227 (festivas)	3060000	S227
IU13	2024-11-24	Materia prima S228 (velas Navidad)	3888000	S228
IU14	2024-11-30	Esencias S229 (abeto)	3160000	S229
IU15	2024-12-06	Cajas regalo S230 (Navidad)	2025000	S230
IU16	2024-12-11	Componentes S231 (sets lujo)	3600000	S231
IU17	2024-12-17	Botellas S232 (doradas)	4175000	S232
IU18	2024-12-24	Alcohol perfumista S233	4554000	S233
IU19	2024-12-31	Fijadores S234	1539000	S234
IU20	2025-01-06	Material laboratorio S235	2650000	S235
IU21	2025-01-11	Frascos muestra S236	2160000	S236
IU22	2025-01-17	Tapones S237	4725000	S237
IU23	2025-01-24	Bolsas tienda S238	3970000	S238
IU24	2025-01-31	Limpieza laboratorio S239	6930000	S239
IU25	2025-02-06	Uniformes S240	4347000	S240
IU26	2025-02-11	Software inventario S241	5670000	S241
IU27	2025-02-17	Material oficina S242	1386000	S242
IU28	2025-02-24	Muebles expositores S243	18000000	S243
IU29	2025-02-28	Mantenimiento equipos S244	915000	S244
IU30	2025-03-06	Diseño etiquetas S245	648000	S245
IU31	2025-03-11	Mensajería S246	5580000	S246
IU32	2025-03-17	Insumos empaque S247	4850000	S247
IU33	2025-03-24	Esencias raras S248	7290000	S248
IU34	2025-03-31	Colorantes S249	2610000	S249
IU35	2025-04-06	Mechas y cera S250	2620000	S250
IU36	2025-04-11	Moldes jabón S251	1462500	S251
IU37	2025-04-17	Bases perfume S252	5130000	S252
IU38	2025-04-24	Aceites esenciales S253	3680000	S253
IU39	2025-04-30	Packaging eco S254	1944000	S254
IU40	2025-05-06	Difusores S255	3105000	S255
IU41	2025-05-11	Recargas difusor S256	4185000	S256
IU42	2025-05-17	Inciensos S257	21105000	S257
IU43	2025-05-24	Quemadores S258	540000	S258
IU44	2025-05-31	Libros perfumería S259	5925000	S259
IU45	2025-06-06	Flores secas S260	2070000	S260
IU46	2025-06-11	Herramientas taller S261	2160000	S261
IU47	2025-06-17	Envases miniatura S262	3405000	S262
IU48	2025-06-24	Cintas decorativas S263	1957500	S263
IU49	2025-06-30	Aceites portadores S264	2268000	S264
IU50	2025-07-06	Glicerina S265	9925000	S265
IV01	2024-02-04	Envases estándar S315	405000	S315
IV02	2024-02-09	Esencias cítricas S316	3595000	S316
IV03	2024-02-14	Químicos vainilla S317	2160000	S317
IV04	2024-02-19	Botellas San Valentín S318	1800000	S318
IV05	2024-02-27	Material marketing S319	2600000	S319
IV06	2024-03-04	Importación florales S320	11700000	S320
IV07	2024-03-09	Materia prima románticos S321	1701000	S321
IV08	2024-03-14	Esencias rosa S322	5700000	S322
IV09	2024-03-19	Embalajes San Valentín S323	2632500	S323
IV10	2024-03-27	Componentes sets S324	4896000	S324
IV11	2024-04-04	Botellas atomizador S325	7358750	S325
IV12	2024-04-09	Etiquetas Día Mujer S326	3240000	S326
IV13	2024-04-14	Importación frutales S327	3780000	S327
IV14	2024-04-19	Extractos flores S328	3372500	S328
IV15	2024-04-27	Envases roll-on S329	2092500	S329
IV16	2024-05-04	Esencias verdes S330	3510000	S330
IV17	2024-05-09	Químicos acuáticos S331	4297500	S331
IV18	2024-05-14	Botellas reciclado S332	4851000	S332
IV19	2024-05-19	Material promocional S333	1417500	S333
IV20	2024-05-27	Importación verano S334	2385000	S334
IV21	2024-06-04	Materia prima solar S335	1710000	S335
IV22	2024-06-09	Esencias Día Madre S336	4995000	S336
IV23	2024-06-14	Cajas regalo S337	5310000	S337
IV24	2024-06-19	Componentes velas S338	6615000	S338
IV25	2024-06-27	Botellas artesanal S339	4599000	S339
IV26	2024-07-04	Etiquetas VIP S340	5455000	S340
IV27	2024-07-09	Importación masculinas S341	1633500	S341
IV28	2024-07-14	Extractos cuero S342	4320000	S342
IV29	2024-07-19	Neceseres S343	3382500	S343
IV30	2024-07-27	Esencias deportivas S344	1656000	S344
IV31	2024-08-04	Químicos marinas S345	5940000	S345
IV32	2024-08-09	Botellas verano S346	6438750	S346
IV33	2024-08-14	Empaque playa S347	7897500	S347
IV34	2024-08-19	Importación tropicales S348	2700000	S348
IV35	2024-08-27	Materia prima mists S349	2090000	S349
IV36	2024-09-04	Esencias cítricas S350	675000	S350
IV37	2024-09-09	Envases Regreso Clases S351	10260000	S351
IV38	2024-09-14	Químicos juveniles S352	965000	S352
IV39	2024-09-19	Papelería S353	999000	S353
IV40	2024-09-27	Etiquetas otoño S354	1552500	S354
IV41	2024-10-04	Importación amaderadas S355	12175000	S355
IV42	2024-10-09	Materia prima especias S356	14175000	S356
IV43	2024-10-14	Esencias pachulí S357	792000	S357
IV44	2024-10-19	Embalajes otoño S358	13250000	S358
IV45	2024-10-27	Componentes difusores S359	21600000	S359
IV46	2024-11-04	Botellas ámbar S360	1305000	S360
IV47	2024-11-09	Etiquetas Halloween S361	3100000	S361
IV48	2024-11-14	Importación misteriosas S362	675000	S362
IV49	2024-11-19	Extractos incienso S363	4032000	S363
IV50	2024-11-27	Envases gótico S364	7717500	S364
\.


                                                                        5129.dat                                                                                            0000600 0004000 0002000 00000000130 15014423351 0014242 0                                                                                                    ustar 00postgres                        postgres                        0000000 0000000                                                                                                                                                                        01	Efectivo
02	Transferencia Bancaria
03	Pago Contra Entrega
04	Nequi
05	Daviplata
\.


                                                                                                                                                                                                                                                                                                                                                                                                                                        5133.dat                                                                                            0000600 0004000 0002000 00000215720 15014423351 0014252 0                                                                                                    ustar 00postgres                        postgres                        0000000 0000000                                                                                                                                                                        P001	Elysian Bloom EDP 50ml	280000	Fragancia floral etérea con notas de jazmín y peonía.	Eau de Parfum	75	20	150	C007	R153	P008
P002	Noir Absolu Extrait 30ml	550000	Extracto intenso y oscuro con oud, cuero y especias.	Extracto de Perfume	30	5	60	\N	R007	\N
P003	Aqua Breeze EDT 100ml	190000	Colonia refrescante con cítricos marinos y menta.	Eau de Toilette	120	30	250	C125	R612	P024
P004	Velvet Rose Body Lotion 200ml	95000	Loción corporal hidratante con aroma a rosas de terciopelo.	Body Lotion	200	50	400	\N	R220	\N
P005	Gentleman's Reserve EDC 75ml	150000	Clásica agua de colonia para hombre con lavanda y vetiver.	Eau de Cologne	90	25	180	C033	R018	P018
P006	Mystic Amber Candle 180g	120000	Vela aromática con notas cálidas de ámbar, vainilla y sándalo.	Candle	60	15	100	\N	\N	P309
P007	Sparkling Citrus Shower Gel 250ml	70000	Gel de ducha energizante con limón, bergamota y naranja.	Shower Gel	150	40	300	C211	R225	\N
P008	Dream Weaver Gift Set	350000	Set de regalo con EDP 50ml, loción y miniatura Dream Weaver.	Gift Set	40	10	80	\N	R176	P001
P009	Orion's Belt EDP 100ml (Unisex)	320000	Fragancia unisex especiada y misteriosa con cardamomo y cedro.	Eau de Parfum	65	15	130	C080	R149	\N
P010	Solstice Kiss EDT 50ml	210000	Aroma solar y vibrante con flores blancas y frutas tropicales.	Eau de Toilette	80	20	160	\N	R152	P020
P011	Crystal Dew Diffuser 100ml	160000	Difusor de ambiente con aroma fresco y limpio a lluvia matutina.	Diffuser	50	10	90	C305	R155	\N
P012	Silken Musk Extrait 15ml	480000	Extracto delicado y sensual con almizcle blanco y cachemira.	Extracto de Perfume	25	5	50	\N	R157	P102
P013	Lunar Glow Body Cream 150g	110000	Crema corporal rica con partículas iridiscentes y aroma floral nocturno.	Body Cream	70	20	140	C015	R158	\N
P014	Stellar Dust EDC 120ml	175000	Colonia efervescente y brillante con notas metálicas y aldehídos.	Eau de Cologne	100	25	200	\N	R159	P252
P015	Nebula Nights EDP 75ml	295000	Perfume profundo y cósmico con incienso, vetiver y pimienta.	Eau de Parfum	55	15	110	C450	R160	\N
P016	Terra Firma Cologne Intense 100ml	340000	Colonia intensa con notas terrosas, musgo de roble y cuero.	Cologne Intense	45	10	90	\N	R161	P332
P017	Aqua Vitae Shower Oil 200ml	85000	Aceite de ducha hidratante con aroma acuático y revitalizante.	Shower Oil	130	30	260	C099	R162	\N
P018	Ignis Ardens Candle Large 300g	220000	Vela grande con aroma especiado y ardiente a canela y clavo.	Candle	35	8	70	\N	\N	P458
P019	Ventus Spiritus Room Spray 100ml	90000	Spray de ambiente fresco y ventoso con menta y eucalipto.	Room Spray	110	25	220	C188	R164	\N
P020	Floralia Maxima Gift Set (EDP+Lotion)	420000	Set de lujo Floralia con EDP 75ml y loción corporal perfumada.	Gift Set	28	7	55	\N	R165	P014
P021	Sylva Origins EDP 50ml (Herbal)	260000	Perfume herbal y natural con salvia, tomillo y lavanda.	Eau de Parfum	70	20	140	C521	R166	\N
P022	Urban Elixir EDT 100ml (Modern)	230000	Eau de Toilette moderna y urbana con notas de jengibre y ámbar gris.	Eau de Toilette	95	25	190	\N	R167	P237
P023	Rurari Essence EDC 200ml (Rustic)	165000	Agua de colonia rústica con heno, cuero y tabaco.	Eau de Cologne	85	20	170	C042	R168	\N
P024	Majestic Oud Extrait 50ml	680000	Extracto opulento con oud puro, azafrán y rosa de Taif.	Extracto de Perfume	15	3	30	\N	R169	P249
P025	Serene Petals Body Mist 150ml	65000	Bruma corporal ligera y serena con flor de loto y té blanco.	Body Mist	180	45	360	C601	R170	\N
P026	Vibrant Citrus Hand Cream 75ml	55000	Crema de manos revitalizante con limón, mandarina y pomelo.	Hand Cream	100	25	200	\N	R171	P243
P027	Opulent Amber Solid Perfume 10g	130000	Perfume sólido concentrado con ámbar, benjuí y ládano.	Solid Perfume	40	10	80	C003	R172	\N
P028	Radiant Musk Shimmer Lotion 100ml	105000	Loción con destellos y aroma a almizcle radiante y flores blancas.	Shimmer Lotion	60	15	120	\N	R173	P248
P029	Mystic Woods Candle Tin 100g	75000	Vela en lata con aroma a maderas misteriosas y resinas.	Candle	90	20	180	\N	\N	P309
P030	Enigma Parfum Roll-On 10ml	180000	Roll-on de perfume Enigma, ideal para llevar.	Roll-On Perfume	50	10	100	C715	R175	\N
P031	Chanel No. 5 EDP 100ml (Iconic)	650000	El icónico Chanel No. 5, un clásico floral aldehídico.	Eau de Parfum	40	10	70	\N	R000	P100
P032	Dior Sauvage EDT 100ml (Masculine)	480000	Fragancia masculina fresca y poderosa con bergamota y pimienta.	Eau de Toilette	60	15	100	C002	R001	P101
P033	Guerlain Shalimar EDP 90ml (Oriental)	520000	Legendario perfume oriental con vainilla, iris y bergamota.	Eau de Parfum	35	8	60	\N	R040	P139
P034	Creed Aventus EDP 100ml (Niche)	1200000	Aclamada fragancia nicho con piña, abedul y grosella negra.	Eau de Parfum	20	5	40	C023	R023	P122
P035	Jo Malone Lime Basil & Mandarin EDC 100ml	580000	Colonia insignia de Jo Malone, fresca y herbal.	Eau de Cologne	45	10	80	\N	R022	P121
P036	Tom Ford Black Orchid EDP 50ml	720000	Opulenta y oscura fragancia con orquídea negra, trufa y chocolate.	Eau de Parfum	25	5	45	C007	R006	P106
P037	YSL Black Opium EDP 90ml (Modern)	560000	Adictiva fragancia moderna con café, vainilla y flores blancas.	Eau de Parfum	50	12	90	\N	R003	P103
P038	Lancôme La Vie Est Belle EDP 75ml	530000	Dulce y popular fragancia con iris, pachulí y praliné.	Eau de Parfum	55	15	95	C104	R004	P104
P039	Armani Sì EDP 100ml (Feminine)	590000	Elegante fragancia chipre frutal con cassis y vainilla.	Eau de Parfum	48	10	85	\N	R006	P105
P040	Paco Rabanne 1 Million EDT 100ml	450000	Popular fragancia masculina con canela, cuero y ámbar.	Eau de Toilette	70	20	120	C250	R015	P114
P041	CH Good Girl EDP 80ml (Iconic Heel)	540000	Fragancia en icónico tacón con nardo, jazmín y cacao.	Eau de Parfum	42	10	75	\N	R017	P116
P042	Bvlgari Omnia Crystalline EDT 65ml	380000	Delicada y acuática fragancia con bambú, nashi y flor de loto.	Eau de Toilette	65	15	110	C311	R012	P111
P043	CK One EDT 200ml (Unisex Classic)	320000	Clásico unisex, fresco y limpio con té verde y bergamota.	Eau de Toilette	100	25	180	\N	R013	P112
P044	Hermès Terre d'Hermès EDT 100ml	510000	Fragancia masculina terrosa y amaderada con naranja y vetiver.	Eau de Toilette	38	8	65	C014	R014	P113
P045	Mugler Angel EDP 50ml (Gourmand)	490000	Pionero gourmand con pachulí, chocolate y caramelo.	Eau de Parfum	30	7	50	\N	R020	P119
P046	Le Labo Santal 33 EDP 50ml (Cult)	950000	Fragancia de culto con sándalo, cardamomo y cuero.	Eau de Parfum	18	4	35	C035	R035	P134
P047	Byredo Gypsy Water EDP 100ml (Boho)	880000	Aroma bohemio y amaderado con pino, incienso y vainilla.	Eau de Parfum	22	5	40	\N	R036	P135
P048	MFK Baccarat Rouge 540 Extrait 70ml	2100000	Lujoso extracto con ámbar gris, azafrán y cedro.	Extracto de Perfume	10	2	20	C037	R037	P136
P049	Diptyque Philosykos EDT 50ml (Fig)	620000	Fragancia realista de higuera, con hojas y madera de higo.	Eau de Toilette	33	7	55	\N	R038	P137
P050	Kilian Love, Don't Be Shy EDP 50ml	1150000	Dulce y narcótico aroma con neroli, malvavisco y ámbar.	Eau de Parfum	16	3	30	C039	R039	P138
P051	AuraSphere EDP 75ml (Luminous)	290000	Fragancia etérea y luminosa con iris, almizcle blanco y bergamota.	Eau de Parfum	60	15	100	\N	R150	P035
P052	Nocturne Essences Extrait 30ml (Dark)	580000	Extracto profundo y nocturno con pachulí, incienso y rosa negra.	Extracto de Perfume	28	5	55	C052	R151	\N
P053	Solstice Aromas EDT 100ml (Solar)	220000	Aroma solar con neroli, flor de naranjo y ámbar dorado.	Eau de Toilette	110	30	220	\N	R152	P020
P054	Elysian Fields Body Butter 180g	125000	Manteca corporal ultra-hidratante con aroma floral celestial.	Body Butter	80	20	160	C111	R153	\N
P055	Zephyr Notes EDC 120ml (Breezy)	160000	Colonia ligera como la brisa con notas verdes y acuáticas.	Eau de Cologne	95	25	190	\N	R154	P302
P056	Crystal Bloom Candle XL 400g	250000	Vela XL con aroma a flores cristalinas y almizcle puro.	Candle	30	7	60	\N	\N	P400
P057	Velvet Whisper Shower Cream 250ml	78000	Crema de ducha suave con aroma aterciopelado a vainilla y sándalo.	Shower Cream	140	35	280	C230	R156	\N
P058	Silken Mist Gift Set (EDT+Mist)	380000	Set de regalo Silken Mist con EDT 75ml y body mist a juego.	Gift Set	35	8	70	\N	R157	P048
P059	Lunar Glow Parfum 50ml (Unisex)	450000	Perfume unisex misterioso con nardo, incienso y ámbar gris.	Parfum	40	10	80	C301	R158	\N
P060	Stellar Dust EDT 50ml (Sparkling)	235000	Eau de Toilette brillante con aldehídos, pimienta rosa y vetiver.	Eau de Toilette	70	18	140	\N	R159	P252
P061	Nebula Fragrance Diffuser 150ml	190000	Difusor con aroma cósmico a maderas oscuras y especias exóticas.	Diffuser	45	10	85	C061	R160	\N
P062	Terra Firma Extrait 15ml (Earthy)	520000	Extracto terroso con musgo, pachulí y notas de tierra húmeda.	Extracto de Perfume	22	4	45	\N	R161	P332
P063	Aqua Vitae Body Oil 100ml	100000	Aceite corporal ligero con aroma fresco y acuático, ideal post-ducha.	Body Oil	75	20	150	C018	R162	\N
P064	Ignis Ardens Solid Cologne 15g	145000	Colonia sólida especiada con canela, clavo y pimienta negra.	Solid Cologne	38	8	75	\N	R163	P458
P065	Ventus Spiritus EDP 75ml (Airy)	310000	Perfume ligero y aéreo con notas ozónicas, menta y flores blancas.	Eau de Parfum	50	12	100	C088	R164	\N
P066	Floralia Maxima Cologne Intense 120ml	360000	Colonia intensa floral con un bouquet de rosas, jazmines y lirios.	Cologne Intense	40	10	80	\N	R165	P014
P067	Sylva Origins Shower Scrub 200g	92000	Exfoliante de ducha herbal con salvia, romero y partículas naturales.	Shower Scrub	125	30	250	C117	R166	\N
P068	Urban Elixir Candle Medium 220g	170000	Vela mediana con aroma urbano y moderno a jengibre y ámbar.	Candle	42	10	80	\N	\N	P237
P069	Rurari Essence Room Spray 120ml	98000	Spray de ambiente rústico con cuero, tabaco y heno.	Room Spray	105	25	210	C240	R168	\N
P070	Majestic Oud Gift Set (Extrait+Oil)	850000	Set de lujo Majestic Oud con Extrait 30ml y aceite perfumado.	Gift Set	12	3	25	\N	R169	P249
P071	Serene Petals EDP 100ml (Calm)	300000	Perfume calmante y sereno con flor de loto, té blanco y sándalo.	Eau de Parfum	62	15	120	C603	R170	\N
P072	Vibrant Citrus EDT 50ml (Zesty)	195000	EDT vibrante con pomelo rosa, mandarina y verbena.	Eau de Toilette	88	22	170	\N	R171	P243
P073	Opulent Amber EDC 250ml (Rich)	240000	Agua de colonia rica y opulenta con ámbar, ládano y vainilla.	Eau de Cologne	70	18	140	C021	R172	\N
P074	Radiant Musk Extrait 30ml (Bright)	610000	Extracto luminoso con almizcles blancos, iris y pera.	Extracto de Perfume	18	4	38	\N	R173	P248
P075	Mystic Woods Body Soufflé 200ml	115000	Soufflé corporal ligero con aroma a maderas y resinas.	Body Soufflé	78	20	150	C005	R174	\N
P076	Enigma Parfum Travel Spray 15ml	250000	Spray de viaje del enigmático Enigma Parfum.	Travel Spray	45	10	90	\N	R175	P180
P077	Dream Weaver Pillow Mist 50ml	70000	Bruma de almohada relajante con lavanda y manzanilla.	Pillow Mist	150	35	300	C077	R176	\N
P078	Memory Lane Scented Sachet (Set of 3)	60000	Set de 3 saquitos perfumados con aroma nostálgico a talco y violetas.	Scented Sachet	90	20	180	\N	R177	P049
P079	Echoes of Nature Diffuser Refill 200ml	120000	Recarga para difusor Echoes of Nature, aroma a bosque húmedo.	Diffuser Refill	55	12	110	C190	R178	\N
P080	Whimsical Spritz EDP 30ml (Playful)	180000	Perfume juguetón y caprichoso con algodón de azúcar y frambuesa.	Eau de Parfum	80	20	160	\N	R179	P004
P081	Arcane Formulations EDT 75ml (Secret)	275000	EDT con una fórmula secreta de hierbas y especias raras.	Eau de Toilette	63	15	125	C201	R180	\N
P082	Legendary Aromas EDC 100ml (Bold)	200000	Colonia audaz y legendaria con cuero, vetiver y pimienta.	Eau de Cologne	77	20	150	\N	R181	P306
P083	Ethereal Blends Extrait 20ml (Light)	560000	Extracto ligero y celestial con aldehídos, iris y almizcle.	Extracto de Perfume	20	4	40	C083	R182	\N
P084	Divine Nectars Body Elixir 100ml	135000	Elixir corporal divino con aceites preciosos y aroma floral dulce.	Body Elixir	68	18	130	\N	R183	P402
P085	Imperial Collection Candle Set (3 Mini)	280000	Set de 3 mini velas de la Colección Imperial (Oud, Ámbar, Rosa).	Candle Set	25	6	50	\N	R184	P487
P086	Royal Essence Room Fragrance 150ml	110000	Fragancia de ambiente real con sándalo, rosa y especias.	Room Fragrance	92	22	180	C333	R185	\N
P087	Noble Spirit Gift Set (EDP+Deo)	400000	Set Noble Spirit con EDP 50ml y desodorante perfumado.	Gift Set	32	8	65	\N	R186	P018
P088	Purest Formulations EDP 100ml (Clean)	330000	Perfume limpio y puro con notas de algodón, lino y té blanco.	Eau de Parfum	58	15	115	C090	R187	\N
P089	Artisan Scents EDT 50ml (Unique)	245000	EDT artesanal con una mezcla única de ingredientes locales.	Eau de Toilette	72	18	140	\N	R188	P208
P090	Exclusif Aromatique EDC 200ml (Rare)	290000	Colonia exclusiva con ingredientes raros y exóticos.	Eau de Cologne	40	10	80	C409	R189	\N
P091	Signature Blends Extrait 50ml	750000	Extracto de autor con una mezcla personalizada y opulenta.	Extracto de Perfume	12	3	25	\N	R190	P215
P092	Unik Parfums Discovery Set (5x2ml)	150000	Set de descubrimiento con 5 muestras de Unik Parfums.	Discovery Set	60	15	120	C009	R191	\N
P093	Vanguard Fragrance EDP 75ml (Bold)	315000	Perfume vanguardista y audaz con notas metálicas y especiadas.	Eau de Parfum	53	12	105	\N	R192	P315
P094	Classic Notes Co. Aftershave 100ml	95000	Aftershave clásico con lavanda, sándalo y musgo de roble.	Aftershave	85	20	170	C501	R193	\N
P095	Modern Aromas Inc. Candle 200g (Minimalist)	140000	Vela minimalista con aroma moderno a concreto y té verde.	Candle	48	10	90	\N	\N	P323
P096	Timeless Elixirs Room Diffuser 120ml	175000	Difusor con aroma atemporal a ámbar, vainilla y maderas nobles.	Diffuser	36	8	70	C115	R195	\N
P097	FutureScents Lab EDP 30ml (Futuristic)	380000	Perfume futurista con notas sintéticas innovadoras y ozónicas.	Eau de Parfum	30	7	60	\N	R196	P409
P098	Heritage Perfumery EDT 100ml (Vintage)	265000	EDT con fórmula vintage recreada, aroma clásico y empolvado.	Eau de Toilette	66	18	130	C222	R197	\N
P099	Innovate Aromatics EDC 250ml (Fresh)	210000	Colonia innovadora con una mezcla inesperada de frutas y hierbas.	Eau de Cologne	74	20	145	\N	R198	P026
P100	Tradition Parfumee Extrait 10ml (Rich)	495000	Extracto tradicional con ingredientes clásicos de alta calidad.	Extracto de Perfume	26	6	50	C345	R199	\N
P101	Alchemy Aromas EDP 50ml (Mystic)	320000	Perfume místico con incienso, mirra y especias secretas.	Eau de Parfum	55	15	110	\N	R200	P333
P102	Essentia Pura EDT 100ml (Pure)	240000	EDT pura y limpia con notas de almizcle blanco y algodón.	Eau de Toilette	80	20	160	C011	R201	\N
P103	Magnum Opus Parfum Extrait 30ml (Master)	950000	Extracto magistral, la obra cumbre de la casa.	Extracto de Perfume	10	2	20	\N	R202	P215
P104	Quintessence Art Body Cream 200g	140000	Crema corporal lujosa, la quintaesencia de la hidratación.	Body Cream	60	15	120	C123	R203	\N
P105	Renaissance Scents EDC 120ml (Classic)	190000	Colonia clásica inspirada en el Renacimiento, con cítricos y hierbas.	Eau de Cologne	70	18	140	\N	R204	P258
P106	Baroque Elixirs Candle 220g (Ornate)	180000	Vela opulenta con aroma barroco a ámbar, rosa y pachulí.	Candle	40	10	80	\N	\N	P352
P107	Rococo Perfumes Shower Gel 250ml	88000	Gel de ducha delicado y ornamental con aroma a flores empolvadas.	Shower Gel	110	25	220	C234	R206	\N
P108	NeoClassic Aromas Gift Set (EDT+AS)	390000	Set neoclásico con EDT 75ml y aftershave a juego.	Gift Set	28	7	55	\N	R207	P094
P109	AvantGarde Scent EDP 50ml (Modern)	350000	Perfume vanguardista con notas inusuales y sintéticas.	Eau de Parfum	45	10	90	C346	R208	\N
P110	Minimalist Notes EDT 100ml (Simple)	210000	EDT minimalista con pocas notas, pero impactantes.	Eau de Toilette	90	22	180	\N	R209	P267
P111	Bohemian Spirit Co Diffuser 100ml (Free)	150000	Difusor bohemio con pachulí, sándalo y naranja dulce.	Diffuser	52	12	100	C013	R210	\N
P112	Luxe Aura Extrait 15ml (Rich)	620000	Extracto lujoso con iris, azafrán y maderas preciosas.	Extracto de Perfume	18	4	36	\N	R211	P504
P113	Glamour Essence Body Shimmer Oil 100ml	120000	Aceite corporal con brillo y aroma glamoroso a champán y fresas.	Body Shimmer Oil	65	18	130	C114	R212	\N
P114	Chic Parfumerie Solid Perfume Compact	160000	Perfume sólido en elegante compacto, aroma floral chic.	Solid Perfume	35	8	70	\N	R213	P376
P115	Elegant Expressions EDP 75ml (Refined)	335000	Perfume refinado y elegante con rosa blanca, peonía y almizcle.	Eau de Parfum	50	12	100	C220	R214	\N
P116	Sophisticate Aroma Cologne Intense 100ml	370000	Colonia intensa sofisticada con cuero, tabaco y bergamota.	Cologne Intense	38	8	75	\N	R215	P005
P117	Powerhouse Scents Shower Gel XL 500ml	150000	Gel de ducha XL energizante con cítricos y especias.	Shower Gel	80	20	160	C330	R216	\N
P118	Seduction Elixir Candle Boudoir 250g	200000	Vela seductora para alcoba con jazmín, ylang-ylang y vainilla.	Candle	33	7	65	\N	\N	P217
P119	Passion Fruit Co. Room Spray 100ml (Exotic)	85000	Spray de ambiente exótico con maracuyá, mango y piña.	Room Spray	120	30	240	C019	R218	\N
P120	Vanilla Dreams Inc. Gift Set (Cream+Mist)	250000	Set de Vainilla con crema corporal y body mist.	Gift Set	42	10	85	\N	R219	P004
P121	Rose Garden Parfum EDP 100ml (Romantic)	360000	Perfume romántico con un bouquet de rosas frescas de jardín.	Eau de Parfum	48	10	95	C441	R220	\N
P122	Jasmine Bloom Ltd. EDT 50ml (Sensual)	225000	EDT sensual con jazmín nocturno, nardo y sándalo.	Eau de Toilette	75	20	150	\N	R221	P001
P123	Sandalwood Secret EDC 200ml (Warm)	200000	Colonia cálida y reconfortante con sándalo de Mysore y cedro.	Eau de Cologne	68	18	135	C022	R222	\N
P124	Amber Glow Aromas Extrait 30ml (Rich)	650000	Extracto rico y dorado con ámbar, benjuí y haba tonka.	Extracto de Perfume	16	3	32	\N	R223	P251
P125	Musketeer Scents Body Lotion 200ml	90000	Loción corporal con una mezcla de almizcles puros y limpios.	Body Lotion	130	30	260	C552	R224	\N
P126	Citrus Burst Co. Hand Soap 300ml	60000	Jabón de manos líquido energizante con explosión cítrica.	Hand Soap	160	40	320	\N	R225	P007
P127	Herbal Infusion P. Solid Shampoo Bar	70000	Champú sólido herbal con romero, menta y ortiga.	Solid Shampoo	80	20	160	C027	R226	\N
P128	Spice Route Aroma Candle Set (3 Travel)	190000	Set de 3 velas de viaje con aromas de la ruta de las especias.	Candle Set	30	7	60	\N	\N	P310
P129	Woodland Notes Diffuser Refill 150ml	110000	Recarga para difusor Woodland Notes, aroma a bosque y pino.	Diffuser Refill	58	15	115	C030	R228	\N
P130	Ocean Breeze Scent EDP 75ml (Marine)	290000	Perfume marino y fresco con sal marina, algas y cítricos.	Eau de Parfum	60	15	120	\N	R229	P306
P131	Mountain Air Co. EDT 100ml (Crisp)	230000	EDT fresca y crujiente como el aire de montaña, con pino y ozono.	Eau de Toilette	82	20	165	C131	R230	\N
P132	Forest Whisper P. EDC 120ml (Green)	185000	Colonia verde y profunda con notas de musgo, helecho y tierra.	Eau de Cologne	72	18	140	\N	R231	P414
P133	Desert Mirage Extrait 20ml (Dry)	590000	Extracto seco y cálido con notas de arena, especias y maderas secas.	Extracto de Perfume	20	4	40	C233	R232	\N
P134	Island Paradise Co Body Scrub 250g	98000	Exfoliante corporal tropical con coco, piña y arena volcánica.	Body Scrub	115	28	230	\N	R233	P024
P135	Tropical Nectar Solid Conditioner Bar	75000	Acondicionador sólido tropical con mango, papaya y manteca de karité.	Solid Conditioner	70	18	140	C035	R234	\N
P136	Exotic Journey P. Candle Large 350g	260000	Vela grande con aroma a viaje exótico, flores raras y especias.	Candle	28	6	55	\N	\N	P450
P137	Adventure Spirit S. Room Spray 150ml	105000	Spray de ambiente aventurero con cuero, cedro y pimienta.	Room Spray	95	22	190	C337	R236	\N
P138	Urbanite Collection Gift Set (EDP+Soap)	370000	Set Urbanite con EDP 50ml y jabón artesanal a juego.	Gift Set	30	7	60	\N	R237	P237
P139	Cosmopolitan Aroma EDP 100ml (City)	345000	Perfume cosmopolita y chic con notas de café, flores blancas y ámbar.	Eau de Parfum	50	12	100	C039	R238	\N
P140	Global Essence Ltd. EDT 50ml (Worldly)	215000	EDT mundana con una mezcla de ingredientes de diversos continentes.	Eau de Toilette	78	20	155	\N	R239	P481
P141	Nightfall Parfum EDC 200ml (Evening)	250000	Colonia para la noche con lavanda, haba tonka y almizcle.	Eau de Cologne	65	18	130	C141	R240	\N
P142	Dawn Chorus Scents Extrait 10ml (Morning)	480000	Extracto matutino con notas de rocío, hierba cortada y flores frescas.	Extracto de Perfume	24	5	48	\N	R241	P429
P143	Twilight Mist Co. Bath Bomb Set (x4)	80000	Set de 4 bombas de baño relajantes con aroma a crepúsculo.	Bath Bomb Set	100	25	200	C243	R242	\N
P144	Midnight Bloom P. Scented Oil 30ml	110000	Aceite perfumado para cuerpo y cabello con aroma a flores nocturnas.	Scented Oil	62	15	125	\N	R243	P434
P145	Daylight Radiance Face Mist 100ml	70000	Bruma facial hidratante y radiante con cítricos y aloe vera.	Face Mist	140	35	280	C345	R244	\N
P146	Summer Solstice S. Shimmer Dry Oil 50ml	125000	Aceite seco con brillo dorado y aroma a solsticio de verano.	Shimmer Dry Oil	55	12	110	\N	R245	P020
P147	Winter Embrace Co. Lip Balm (Spiced)	45000	Bálsamo labial especiado para invierno con canela y clavo.	Lip Balm	150	38	300	C047	R246	\N
P148	Autumn Leaves P. Potpourri Bag 200g	95000	Bolsa de potpourri con aroma a hojas de otoño y especias.	Potpourri	70	18	140	\N	R247	P357
P149	Spring Blossom Ltd. Hand Lotion 100ml	65000	Loción de manos ligera con aroma a flores de primavera.	Hand Lotion	135	32	270	C149	R248	\N
P150	Seasonal Scents Discovery Kit (4x5ml)	200000	Kit con 4 miniaturas representando cada estación.	Discovery Kit	40	10	80	\N	R249	P003
P151	Celestial Aromas EDP 75ml (Cosmic)	330000	Perfume cósmico con notas de ozono, incienso y ámbar estelar.	Eau de Parfum	50	12	100	\N	R250	P250
P152	Galaxy Perfumes EDT 100ml (Nebula)	250000	EDT inspirada en nebulosas, con maderas oscuras y especias frías.	Eau de Toilette	70	18	140	C051	R251	\N
P153	Comet Tail Scents Extrait 15ml (Bright)	550000	Extracto brillante y fugaz con aldehídos, cítricos y almizcle.	Extracto de Perfume	20	4	40	\N	R252	P252
P154	Stardust Elixirs Body Glow Oil 50ml	140000	Aceite corporal con polvo de estrellas (mica) y aroma celestial.	Body Glow Oil	60	15	120	C154	R253	\N
P155	Astral Projection P. EDC 120ml (Ethereal)	195000	Colonia etérea para la meditación con sándalo y mirra.	Eau de Cologne	75	20	150	\N	R254	P380
P156	Orbital Notes Co. Candle Set (Planets)	300000	Set de velas representando planetas, con aromas únicos.	Candle Set	25	6	50	\N	\N	P460
P157	Cosmic Nectar Ltd. Shower Nectar 200ml	95000	Néctar de ducha cósmico con frutas exóticas y flores luminosas.	Shower Nectar	100	25	200	C257	R256	\N
P158	Void Fragrances Gift Set (EDP+Solid)	450000	Set Void con EDP 50ml y perfume sólido a juego.	Gift Set	22	5	45	\N	R257	P058
P159	Dimension Shift S. EDP 50ml (Altered)	370000	Perfume que altera la percepción con notas inusuales y cambiantes.	Eau de Parfum	40	10	80	C359	R258	\N
P160	Parallel Universe P EDT 100ml (Dual)	260000	EDT con dos facetas contrastantes, una clara y una oscura.	Eau de Toilette	65	18	130	\N	R259	P260
P161	Fantasy Realm Co. Diffuser 100ml (Magic)	170000	Difusor con aroma a bosque encantado y frutas mágicas.	Diffuser	48	10	95	C061	R260	\N
P162	Mythic Legends P. Extrait 30ml (Epic)	720000	Extracto épico con notas de cuero antiguo, especias y maderas nobles.	Extracto de Perfume	15	3	30	\N	R261	P502
P163	Faerie Glen Scents Body Powder 100g	80000	Polvo corporal perfumado con aroma a flores silvestres y musgo.	Body Powder	85	20	170	C163	R262	\N
P164	Dragons Breath Ltd. Solid Perfume (Spicy)	150000	Perfume sólido especiado y ahumado con canela y pimienta.	Solid Perfume	30	7	60	\N	R263	P377
P165	Phoenix Ash Parfum EDP 75ml (Rebirth)	400000	Perfume de renacimiento con incienso, ceniza y flores rojas.	Eau de Parfum	35	8	70	C265	R264	\N
P166	Unicorn Horn Co. Cologne Intense 100ml	380000	Colonia intensa mágica con iris, vainilla y destellos.	Cologne Intense	32	7	65	\N	R265	P005
P167	Griffin Feather S. Shower Mousse 200ml	92000	Mousse de ducha ligera y aérea con notas de aire fresco y plumas.	Shower Mousse	105	25	210	C367	R266	\N
P168	Mermaid Song P. Candle (Oceanic)	190000	Vela con aroma a canto de sirena, sal marina y flores acuáticas.	Candle	38	8	75	\N	\N	P268
P169	Elven Woods Ltd. Room Spray 120ml (Forest)	100000	Spray de ambiente con aroma a bosque élfico, musgo y pino.	Room Spray	90	22	180	C069	R268	\N
P170	Vampire Kiss Co. Gift Set (EDP+Lip)	480000	Set Vampire Kiss con EDP 50ml y labial rojo sangre.	Gift Set	20	4	40	\N	R269	P270
P171	Werewolf Musk P. EDP 100ml (Primal)	350000	Perfume primal con almizcle animal, cuero y notas terrosas.	Eau de Parfum	42	10	85	C471	R270	\N
P172	Zombie Zest Scents EDT 50ml (Odd)	180000	EDT peculiar con notas de tierra húmeda, cítricos podridos (humor).	Eau de Toilette	60	15	120	\N	R271	P004
P173	Ghostly Whisper P. EDC 200ml (Ethereal)	220000	Colonia etérea y sutil con incienso blanco y flores pálidas.	Eau de Cologne	55	12	110	C073	R272	\N
P174	Angel Wing Co. Ltd Extrait 30ml (Pure)	690000	Extracto puro y celestial con lirio blanco, almizcle y vainilla.	Extracto de Perfume	16	3	32	\N	R273	P273
P175	Demon Charm Parfum Body Shimmer 100g	130000	Polvo corporal con brillo y aroma seductor a especias y flores oscuras.	Body Shimmer	70	18	140	C175	R274	\N
P176	Spirit Guide S. Solid Balm 15g (Calming)	140000	Bálsamo sólido calmante con lavanda, sándalo y manzanilla.	Solid Balm	32	7	65	\N	R275	P275
P177	Soulmate Essence EDP Duo (His&Hers 30ml)	550000	Dúo de perfumes para almas gemelas, complementarios.	EDP Duo	25	6	50	C277	R276	\N
P178	Karma Balance Co. Incense Sticks (20u)	70000	Varitas de incienso para equilibrar el karma, con sándalo y nag champa.	Incense Sticks	80	20	160	\N	R277	P049
P179	Destiny Weaver P. Diffuser Oil 10ml	90000	Aceite para difusor con aroma que evoca el destino, con mirra y azafrán.	Diffuser Oil	68	18	135	C379	R278	\N
P180	Fate & Fortune Ltd EDP 75ml (Lucky)	310000	Perfume para atraer la buena fortuna con trébol, bambú y té verde.	Eau de Parfum	58	15	115	\N	R279	P280
P181	Lucky Charm Scents EDT 100ml (Sweet)	200000	EDT dulce y alegre con notas de malvavisco y frutas confitadas.	Eau de Toilette	88	22	175	C081	R280	\N
P182	Providence Parfum EDC 120ml (Guiding)	170000	Colonia guía con notas herbales y cítricas para la claridad.	Eau de Cologne	78	20	155	\N	R281	P382
P183	Serendipity Co. Extrait 20ml (Chance)	580000	Extracto de encuentros fortuitos, con notas inesperadas y alegres.	Extracto de Perfume	19	4	38	C183	R282	\N
P184	Blissful Moments P Bath Salts 300g	100000	Sales de baño para momentos de felicidad, con rosa y vainilla.	Bath Salts	72	18	145	\N	R283	P402
P185	Joyful Spirit Ltd. Candle 180g (Uplifting)	130000	Vela edificante con aroma a cítricos, jengibre y flores solares.	Candle	46	10	90	\N	\N	P485
P186	Peaceful Mind Co. Room Mist 100ml (Calm)	95000	Bruma de ambiente para la paz mental, con lavanda y sándalo.	Room Mist	98	25	195	C286	R285	\N
P187	Happiness in Bottle Gift Set (EDP+Mini)	420000	Set Felicidad con EDP 50ml y miniatura para llevar.	Gift Set	26	6	52	\N	R286	P014
P188	Love Potion No. 10 EDP 50ml (Romantic)	360000	Poción de amor moderna con rosa, chocolate y fresa.	Eau de Parfum	44	10	88	C388	R287	\N
P189	Friendship Bond P. EDT 75ml (Warm)	230000	EDT cálida para celebrar la amistad, con ámbar y vainilla.	Eau de Toilette	69	18	138	\N	R288	P208
P190	Family Ties Scents EDC 200ml (Comfort)	190000	Colonia reconfortante con notas de talco, algodón y leche.	Eau de Cologne	76	20	150	C090	R289	\N
P191	Homeward Bound Co. Extrait 30ml (Nostalgic)	670000	Extracto nostálgico con aroma a hogar, pan horneado y madera.	Extracto de Perfume	14	3	28	\N	R290	P215
P192	Comfort Zone P. Body Butter 250g	150000	Manteca corporal ultra reconfortante con karité y cacao.	Body Butter	55	12	110	C192	R291	\N
P193	Safe Haven Aromas Solid Perfume Tin	135000	Perfume sólido en lata con aroma protector a sándalo y cedro.	Solid Perfume	36	8	72	\N	R292	P315
P194	Tranquil Escape S. Bath Oil 100ml	115000	Aceite de baño para una escapada tranquila, con lavanda y ylang-ylang.	Bath Oil	60	15	120	C294	R293	\N
P195	Relaxation Station Candle Large 400g	240000	Vela grande para la relajación total, con manzanilla y melisa.	Candle	28	6	56	\N	\N	P323
P196	Meditative Moods P. Diffuser Oil Set	220000	Set de aceites para difusor (3 aromas) para meditación.	Diffuser Oil Set	30	7	60	C396	R295	\N
P197	Yoga Flow Scents EDP 50ml (Balancing)	290000	Perfume equilibrante para yoga, con sándalo, pachulí y neroli.	Eau de Parfum	52	12	105	\N	R296	P409
P198	Zen Garden Co. Ltd. Room Spray Set	180000	Set de sprays de ambiente Zen (Bambú, Té Verde, Loto).	Room Spray Set	40	10	80	C098	R297	\N
P199	Energy Boost Parfum EDT 100ml (Vitality)	250000	EDT energizante con jengibre, pomelo y pimienta rosa.	Eau de Toilette	70	18	140	\N	R298	P026
P200	Vitality Spark S. Shower Steamers (x6)	90000	Pastillas de ducha efervescentes para vitalidad, con eucalipto y menta.	Shower Steamers	95	22	190	C200	R299	\N
P201	Rejuvenate Me Co. Face Serum 30ml	180000	Sérum facial rejuvenecedor con antioxidantes y aroma herbal.	Face Serum	45	10	90	\N	R300	P300
P202	Refresh & Revive P. Hair Mist 100ml	80000	Bruma capilar refrescante con menta y té verde.	Hair Mist	110	25	220	C102	R301	\N
P203	Invigorate Ltd. EDC 200ml (Zesty)	200000	Colonia vigorizante con lima, jengibre y verbena.	Eau de Cologne	68	18	135	\N	R302	P401
P204	Motivation Mist S. Body Spray 150ml	75000	Body spray motivador con cítricos y especias energizantes.	Body Spray	130	30	260	C204	R303	\N
P205	Inspiration Spark P. Extrait 10ml (Bright)	520000	Extracto brillante para la inspiración con aldehídos y flores blancas.	Extracto de Perfume	22	5	45	\N	R304	P504
P206	Creativity Flow Co. Candle 180g (Muse)	135000	Vela para la creatividad con romero, limón y menta.	Candle	42	10	85	\N	\N	P405
P207	Focus Point Aromas Diffuser Oil 15ml	100000	Aceite para difusor Focus Point, con pino y eucalipto.	Diffuser Oil	60	15	120	C307	R306	\N
P208	Clarity Essence S. Gift Set (EDP+Soap)	390000	Set Clarity con EDP 50ml y jabón artesanal purificante.	Gift Set	29	7	58	\N	R307	P008
P209	Wisdom Seeker P. EDP 50ml (Sage)	340000	Perfume de sabiduría con salvia, incienso y cedro.	Eau de Parfum	47	10	95	C009	R308	\N
P210	Knowledge Nectar EDT 100ml (Herbal)	255000	EDT herbal para el conocimiento, con romero y albahaca.	Eau de Toilette	66	18	130	\N	R309	P210
P211	Truth Serum Scents EDC 120ml (Clear)	180000	Colonia clara y honesta con notas acuáticas y ozónicas (humor).	Eau de Cologne	73	20	145	C111	R310	\N
P212	Honesty Parfum Co. Extrait 30ml (Pure)	700000	Extracto puro y transparente con almizcle blanco y lirio.	Extracto de Perfume	13	3	26	\N	R311	P502
P213	Integrity Blends P. Body Wash 250ml	85000	Gel de ducha íntegro con ingredientes naturales y aroma herbal.	Body Wash	115	28	230	C213	R312	\N
P214	Courageous Spirit Solid Perfume (Bold)	155000	Perfume sólido audaz con cuero, pimienta y vetiver.	Solid Perfume	33	7	66	\N	R313	P313
P215	Braveheart Aromas EDP 75ml (Strong)	325000	Perfume fuerte y valiente con maderas nobles y especias.	Eau de Parfum	49	10	98	C315	R314	\N
P216	Strong Will Co. S. Cologne Intense 100ml	390000	Colonia intensa para la fuerza de voluntad, con cedro y ámbar.	Cologne Intense	30	7	60	\N	R315	P005
P217	Resilience Parfum Shower Oil 200ml	98000	Aceite de ducha para la resiliencia, con aroma herbal y cítrico.	Shower Oil	90	22	180	C017	R316	\N
P218	Hopeful Horizon P. Candle 220g (Light)	175000	Vela luminosa con aroma a esperanza, flores blancas y cítricos.	Candle	39	8	78	\N	\N	P317
P219	Dreamcatcher Ltd. Room Spray 100ml (Sleep)	90000	Spray de ambiente para atrapar sueños, con lavanda y sándalo.	Room Spray	108	25	215	C119	R318	\N
P220	Ambition Fuel Co. Gift Set (EDT+Deo)	380000	Set Ambition con EDT 75ml y desodorante energizante.	Gift Set	27	6	54	\N	R319	P018
P221	Success Story S. EDP 100ml (Winner)	370000	Perfume de éxito con notas de champán, maderas y especias.	Eau de Parfum	46	10	92	C221	R320	\N
P222	Victory Lap Parfum EDT 50ml (Triumph)	240000	EDT triunfal con laurel, cítricos y notas marinas.	Eau de Toilette	71	18	142	\N	R321	P001
P223	Champion Spirit P. EDC 200ml (Sport)	210000	Colonia deportiva para campeones, con menta y jengibre.	Eau de Cologne	67	18	134	C323	R322	\N
P224	Leadership Aura Extrait 30ml (Command)	730000	Extracto de liderazgo con oud, cuero y tabaco.	Extracto de Perfume	12	3	24	\N	R323	P215
P225	Influence Essence S. Body Soufflé 180g	125000	Soufflé corporal influyente con aroma carismático y floral.	Body Soufflé	64	15	128	C025	R324	\N
P226	Charisma Factor Co. Solid Perfume (Magnetic)	165000	Perfume sólido magnético con ámbar gris y feromonas (ficticias).	Solid Perfume	31	7	62	\N	R325	P313
P227	Magnetic Pull P. Bath Oil 100ml	120000	Aceite de baño atractivo con ylang-ylang, jazmín y vainilla.	Bath Oil	58	15	116	C127	R326	\N
P228	Allure Mystique S. Candle Large 350g	255000	Vela grande con aroma místico y seductor a incienso y rosa.	Candle	27	6	53	\N	\N	P326
P229	Captivate Me Ltd. Diffuser Oil Set (Sensual)	230000	Set de aceites para difusor (3 aromas sensuales) para cautivar.	Diffuser Oil Set	29	7	58	C229	R328	\N
P230	Fascination Co. P. EDP 75ml (Enchanting)	330000	Perfume encantador y fascinante con orquídea, vainilla y ámbar.	Eau de Parfum	48	10	96	\N	R329	P409
P231	Temptation Isle S. EDT 100ml (Forbidden)	265000	EDT tentadora con frutas prohibidas, flores exóticas y almizcle.	Eau de Toilette	62	15	124	C331	R330	\N
P232	Desire Path Parfum EDC 120ml (Sensual)	195000	Colonia sensual que sigue el camino del deseo, con jazmín y sándalo.	Eau de Cologne	70	18	140	\N	R331	P026
P233	Intrigue Aromas P. Extrait 20ml (Mysterious)	600000	Extracto misterioso e intrigante con notas oscuras y especiadas.	Extracto de Perfume	17	4	34	C033	R332	\N
P234	Mystery Unveiled S. Body Mist 150ml	80000	Bruma corporal que desvela un misterio, con flores nocturnas.	Body Mist	120	30	240	\N	R333	P434
P235	Secret Garden Co. Hand Cream 75ml	60000	Crema de manos con aroma a jardín secreto, rosas y jazmines.	Hand Cream	140	35	280	C135	R334	\N
P236	Hidden Treasure P. Solid Perfume Locket	190000	Medallón con perfume sólido, un tesoro oculto de aroma.	Solid Perfume Locket	25	6	50	\N	R335	P335
P237	Forbidden Fruit S. Shimmer Lotion 100ml	110000	Loción con brillo y aroma a frutas prohibidas y exóticas.	Shimmer Lotion	66	18	132	C237	R336	\N
P238	Rare Gem Parfum Candle 200g (Precious)	185000	Vela con aroma a gema rara, mineral y floral.	Candle	37	8	74	\N	\N	P337
P239	Precious Metals P. Room Fragrance 120ml	115000	Fragancia de ambiente con notas metálicas y amaderadas.	Room Fragrance	88	22	176	C339	R338	\N
P240	Diamond Dust Co. S. Gift Set (EDP+Shimmer)	550000	Set Diamond Dust con EDP 50ml y polvo de brillo corporal.	Gift Set	20	4	40	\N	R339	P018
P241	Golden Elixir Ltd. EDP 100ml (Luxury)	450000	Perfume lujoso con azafrán, oud y ámbar dorado.	Eau de Parfum	35	8	70	C041	R340	\N
P242	Silver Lining P. EDT 50ml (Hopeful)	220000	EDT esperanzadora con iris, violeta y almizcle plateado.	Eau de Toilette	76	20	152	\N	R341	P208
P243	Platinum StandardS EDC 200ml (Refined)	300000	Colonia refinada de estándar platino, con vetiver y cítricos.	Eau de Cologne	50	12	100	C143	R342	\N
P244	Crown Jewel Parfum Extrait 50ml (Regal)	1200000	Extracto real, la joya de la corona, con ingredientes preciosos.	Extracto de Perfume	8	2	16	\N	R343	P215
P245	Scepter of Power P. Body Oil 100ml	145000	Aceite corporal de poder con especias, maderas y ámbar.	Body Oil	53	12	106	C245	R344	\N
P246	Throne Room Aromas Solid Perfume Case	200000	Estuche de lujo para perfume sólido, digno de un trono.	Solid Perfume Case	22	5	44	\N	R345	P313
P247	Empire Builder S. Aftershave Balm 75ml	100000	Bálsamo aftershave para constructores de imperios, con cedro.	Aftershave Balm	80	20	160	C347	R346	\N
P248	Kingdom Come Co. P. Candle Set (Royal)	320000	Set de velas reales con aromas a incienso, mirra y oro.	Candle Set	23	5	46	\N	\N	P346
P249	Queen Bee Parfum Diffuser 150ml (Honey)	195000	Difusor con aroma a miel, cera de abeja y flores de campo.	Diffuser	34	8	68	C049	R348	\N
P250	Princely Charm S. EDP 75ml (Elegant)	340000	Perfume elegante y encantador con lavanda, cuero y ámbar.	Eau de Parfum	49	10	98	\N	R349	P409
P251	Duchess Grace Ltd. EDT 100ml (Noble)	270000	EDT noble y agraciada con rosa, violeta y sándalo.	Eau de Toilette	60	15	120	C151	R350	\N
P252	Earl Grey Notes P. EDC 120ml (Refined)	200000	Colonia refinada con notas de té Earl Grey y bergamota.	Eau de Cologne	68	18	136	\N	R351	P026
P253	Baron Von Scent Extrait 20ml (Aristocrat)	620000	Extracto aristocrático con tabaco, coñac y maderas oscuras.	Extracto de Perfume	19	4	38	C253	R352	\N
P254	Knight's Valor Co. Shower Gel 250ml	90000	Gel de ducha valiente con cedro, pino y especias.	Shower Gel	105	25	210	\N	R353	P434
P255	Lady Luck Parfum S. EDP 50ml (Fortunate)	350000	Perfume de la suerte con trébol, jazmín y almizcle.	Eau de Parfum	46	10	92	C355	R354	\N
P256	Lord of Aromas P. Cologne Intense 100ml	400000	Colonia intensa señorial con cuero, oud y vetiver.	Cologne Intense	28	6	56	\N	R355	P005
P257	Maiden Fair Scents Body Mist 150ml (Pure)	70000	Bruma corporal pura y delicada con flores blancas y talco.	Body Mist	125	30	250	C057	R356	\N
P258	Warrior Spirit Co. Solid Perfume (Strong)	160000	Perfume sólido fuerte con ámbar, pachulí y especias.	Solid Perfume	34	8	68	\N	R357	P313
P259	Mage's Mysterium P. Candle 220g (Arcane)	190000	Vela arcana con incienso, mirra y hierbas mágicas.	Candle	36	8	72	\N	\N	P359
P260	Alchemist's Brew S. Diffuser Oil 15ml	110000	Aceite para difusor con una mezcla alquímica de resinas y especias.	Diffuser Oil	56	12	112	C160	R359	\N
P261	Scribe's Ink Ltd. Room Spray 100ml (Paper)	98000	Spray de ambiente con aroma a tinta, papel y cuero.	Room Spray	92	22	184	\N	R360	P461
P262	Poet's Muse Parfum EDP 75ml (Inspiring)	330000	Perfume inspirador con notas de rosa, violeta y sándalo.	Eau de Parfum	47	10	94	C262	R361	\N
P263	Artist's Palette P. EDT 100ml (Creative)	260000	EDT creativa con una mezcla colorida de frutas y flores.	Eau de Toilette	63	15	126	\N	R362	P208
P264	Musician's Harmony EDC 120ml (Melodic)	195000	Colonia melódica con notas equilibradas y armoniosas.	Eau de Cologne	71	18	142	C364	R363	\N
P265	Dancer's Rhythm S. Extrait 10ml (Grace)	500000	Extracto grácil y rítmico con flores blancas y almizcle.	Extracto de Perfume	21	5	42	\N	R364	P504
P266	Actor's SpotlightP Body Shimmer 75g	120000	Polvo corporal con brillo para el centro de atención, aroma floral.	Body Shimmer	61	15	122	C066	R365	\N
P267	Filmmaker's Dream Solid Perfume Tin	140000	Perfume sólido en lata con aroma a palomitas, cuero y misterio.	Solid Perfume	37	8	74	\N	R366	P366
P268	Writer's Block Co. Candle (Unscented)	100000	Vela sin aroma para no distraer (humorístico).	Candle	50	10	100	\N	\N	P367
P269	Reader's Nook S. Diffuser 100ml (Cozy)	165000	Difusor acogedor con aroma a libros viejos, té y galletas.	Diffuser	41	10	82	C169	R368	\N
P270	LibraryWhispers P. EDP 50ml (Quiet)	310000	Perfume silencioso con notas de papel, vainilla y cedro.	Eau de Parfum	51	12	102	\N	R369	P409
P271	Bookworm Aromas EDT 75ml (Comfort)	220000	EDT reconfortante para amantes de los libros, con cacao y café.	Eau de Toilette	67	18	134	C271	R370	\N
P272	Paper & Quill Ltd. EDC 200ml (Classic)	180000	Colonia clásica con aroma a papel de carta y tinta fresca.	Eau de Cologne	74	20	148	\N	R371	P026
P273	Inkwell Dreams P. Extrait 20ml (Deep)	590000	Extracto profundo e inspirador con notas de tinta y cuero.	Extracto de Perfume	18	4	36	C373	R372	\N
P274	Quill & Scroll S. Bath Salts 300g (Relax)	105000	Sales de baño relajantes para escritores, con lavanda y manzanilla.	Bath Salts	69	18	138	\N	R373	P402
P275	Manuscript Memories Candle 180g (Historic)	145000	Vela con aroma a manuscritos antiguos, papiro y resinas.	Candle	43	10	86	\N	\N	P485
P276	Storyteller's Co P. Room Spray 120ml	100000	Spray de ambiente para contar historias, con fogata y maderas.	Room Spray	89	22	178	C076	R375	\N
P277	Tale Weaver Parfum EDP 100ml (Magic)	370000	Perfume mágico que teje historias, con flores encantadas y especias.	Eau de Parfum	44	10	88	\N	R376	P280
P278	Fable & Fantasy S. EDT 50ml (Dreamy)	235000	EDT de ensueño con notas de fantasía y frutas azucaradas.	Eau de Toilette	70	18	140	C178	R377	\N
P279	Legend & Lore Co. EDC 120ml (Ancient)	185000	Colonia ancestral con aroma a leyendas y mitos.	Eau de Cologne	76	20	152	\N	R378	P382
P280	Folklore Fragrance Extrait 10ml (Tradition)	510000	Extracto tradicional con notas folclóricas y rurales.	Extracto de Perfume	23	5	46	C280	R379	\N
P281	Traveler's Joy P. Body Lotion 200ml	92000	Loción corporal para viajeros, con aroma refrescante y energizante.	Body Lotion	112	28	224	\N	R380	P434
P282	Explorer's SpiritS Solid Perfume (Advent)	150000	Perfume sólido aventurero con notas de pino, cuero y tierra.	Solid Perfume	35	8	70	C382	R381	\N
P283	Adventurer's Call Candle 220g (Wild)	180000	Vela salvaje para aventureros, con maderas y especias exóticas.	Candle	39	8	78	\N	\N	P383
P284	Voyager's CompassP Diffuser Oil 15ml	115000	Aceite para difusor que guía el viaje, con cedro y bergamota.	Diffuser Oil	54	12	108	C084	R383	\N
P285	Nomad's Heart Co. EDP 75ml (Free)	320000	Perfume de espíritu libre con notas de estepa y cuero.	Eau de Parfum	48	10	96	\N	R384	P409
P286	Wanderlust Aromas EDT 100ml (Journey)	250000	EDT para el deseo de viajar, con notas de diferentes continentes.	Eau de Toilette	65	18	130	C186	R385	\N
P287	Pathfinder ParfumS EDC 200ml (Guiding)	200000	Colonia guía con notas herbales y amaderadas.	Eau de Cologne	70	18	140	\N	R386	P026
P288	Journey Within Ltd Extrait 30ml (Inner)	650000	Extracto para el viaje interior, con incienso y sándalo.	Extracto de Perfume	16	3	32	C288	R387	\N
P289	Destination Unknown Body Soufflé 180g	130000	Soufflé corporal para destinos desconocidos, aroma exótico.	Body Soufflé	62	15	124	\N	R388	P434
P290	Horizon Line P. Solid Perfume Locket	195000	Medallón con perfume sólido, aroma a horizonte lejano.	Solid Perfume Locket	28	6	56	C390	R389	\N
P291	Road Less Traveled Candle 180g (Unique)	150000	Vela con aroma único para caminos menos transitados.	Candle	41	10	82	\N	\N	P390
P292	Mapmaker's ScentS Room Spray 100ml (Old)	105000	Spray de ambiente con aroma a mapas antiguos y especias.	Room Spray	86	22	172	C092	R391	\N
P293	Compass Rose Co. P. EDP 50ml (Direction)	300000	Perfume que marca la dirección, con notas marinas y amaderadas.	Eau de Parfum	53	12	106	\N	R392	P208
P294	Navigator's Notes EDT 75ml (Maritime)	225000	EDT marítima con sal, algas y cítricos.	Eau de Toilette	69	18	138	C194	R393	\N
P295	Sailor's Delight S. EDC 120ml (Sea)	180000	Colonia marinera con brisa marina y ron.	Eau de Cologne	75	20	150	\N	R394	P306
P296	Shipwreck Bay P. Extrait 10ml (Deep)	520000	Extracto profundo con aroma a maderas mojadas y tesoros hundidos.	Extracto de Perfume	24	5	48	C296	R395	\N
P297	Port of Call Co. Aftershave 100ml	90000	Aftershave refrescante con aroma a puerto exótico.	Aftershave	82	20	164	\N	R396	P094
P298	Harbor Lights Ltd. Candle 220g (Coastal)	170000	Vela costera con aroma a brisa marina y luces de puerto.	Candle	38	8	76	\N	\N	P398
P299	Beacon Point P. Diffuser 100ml (Guiding)	160000	Difusor guía con aroma fresco y luminoso.	Diffuser	44	10	88	C399	R398	\N
P300	Anchor & Hope S. EDP 100ml (Steady)	360000	Perfume firme y esperanzador con vetiver, cedro y cítricos.	Eau de Parfum	45	10	90	\N	R399	P409
P301	Wavecrest Parfum EDT 50ml (Oceanic)	240000	EDT oceánica con cresta de ola, sal y aire fresco.	Eau de Toilette	72	18	144	C101	R400	\N
P302	Tidal Bloom Co. P. EDC 200ml (Floral)	205000	Colonia floral que florece con la marea, con flores acuáticas.	Eau de Cologne	67	18	134	\N	R401	P026
P303	Coral Reef DreamsS Extrait 30ml (Vivid)	680000	Extracto vívido con aroma a arrecife de coral, frutas tropicales.	Extracto de Perfume	15	3	30	C203	R402	\N
P304	Seashell Whisper L. Body Powder 120g	85000	Polvo corporal con susurro de conchas marinas, aroma suave.	Body Powder	80	20	160	\N	R403	P434
P305	Pearl Diver Parfum EDP 75ml (Lustrous)	420000	Perfume lustroso con perlas (nota imaginaria) y flores blancas.	Eau de Parfum	33	7	66	C305	R404	\N
P306	Sand Dune AromasP. Solid Perfume (Warm)	155000	Perfume sólido cálido con aroma a dunas y especias del desierto.	Solid Perfume	36	8	72	\N	R405	P306
P307	Beach Day Scents S. Candle 180g (Sunny)	140000	Vela soleada con aroma a día de playa, coco y protector solar.	Candle	43	10	86	\N	\N	P307
P308	Sunken Treasure Co. Diffuser Oil 15ml (Deep)	120000	Aceite para difusor con aroma a tesoro hundido, ámbar y maderas.	Diffuser Oil	51	12	102	C008	R407	\N
P309	Coastal Breeze P. Room Spray 100ml (Fresh)	90000	Spray de ambiente con brisa costera, fresco y salino.	Room Spray	94	22	188	\N	R408	P461
P310	Isle of Skye Ltd. EDP 50ml (Misty)	330000	Perfume brumoso inspirado en la Isla de Skye, con brezo y musgo.	Eau de Parfum	49	10	98	C110	R409	\N
P311	Lagoon Secret S. EDT 100ml (Hidden)	255000	EDT con secreto de laguna, flores acuáticas y maderas exóticas.	Eau de Toilette	64	15	128	\N	R410	P208
P312	Riverbend Parfum P. EDC 120ml (Flowing)	190000	Colonia fluida con aroma a recodo de río, hojas verdes y agua.	Eau de Cologne	73	18	146	C212	R411	\N
P313	Lakeside Morning S. Extrait 10ml (Calm)	500000	Extracto calmado de mañana junto al lago, con nenúfar y rocío.	Extracto de Perfume	25	5	50	\N	R412	P504
P314	Stream & Stone Co. Bath Bomb (Earthy)	70000	Bomba de baño terrosa con aroma a arroyo y piedras mojadas.	Bath Bomb	110	25	220	C314	R413	\N
P315	Waterfall Mist P. Solid Perfume (Fresh)	145000	Perfume sólido fresco con aroma a bruma de cascada y ozono.	Solid Perfume	38	8	76	\N	R414	P315
P316	Fountain of YouthS Candle (Mythic)	200000	Vela mítica con aroma a fuente de la juventud (floral y frutal).	Candle	34	8	68	\N	\N	P316
P317	Springwater FreshL. Diffuser 100ml (Pure)	170000	Difusor puro con aroma a agua de manantial fresca y limpia.	Diffuser	40	10	80	C017	R416	\N
P318	Dewdrop Blossom P. EDP 75ml (Delicate)	315000	Perfume delicado con aroma a flor cubierta de rocío.	Eau de Parfum	52	12	104	\N	R417	P409
P319	Rainforest Dew CoS EDT 100ml (Lush)	260000	EDT exuberante con aroma a rocío de selva tropical y flores exóticas.	Eau de Toilette	61	15	122	C119	R418	\N
P320	Misty Mountain Ltd. EDC 200ml (High)	210000	Colonia alta y brumosa con pino, abeto y aire fresco de montaña.	Eau de Cologne	66	18	132	\N	R419	P026
P321	Fog & Fern ParfumP Extrait 30ml (Green)	660000	Extracto verde y brumoso con helecho, musgo y tierra húmeda.	Extracto de Perfume	17	3	34	C221	R420	\N
P322	Cloud Nine ScentsS Body Butter 200g	135000	Manteca corporal celestial con aroma a nubes de algodón y vainilla.	Body Butter	60	15	120	\N	R421	P434
P323	Skylight AromasCo Solid Perfume Tin	150000	Perfume sólido en lata con aroma a cielo abierto y brisa fresca.	Solid Perfume	35	8	70	C323	R422	\N
P324	Sunbeam Essence P. Bath Oil 100ml	110000	Aceite de baño radiante con aroma a rayo de sol y cítricos.	Bath Oil	63	15	126	\N	R423	P323
P325	Moonflower PetalsS Candle Large 350g	250000	Vela grande con aroma a pétalos de flor de luna y jazmín nocturno.	Candle	29	6	58	\N	\N	P325
P326	Starlight Gleam Lt. Diffuser Oil Set	225000	Set de aceites para difusor (3 aromas) con brillo estelar.	Diffuser Oil Set	28	6	56	C026	R425	\N
P327	Aurora Borealis P. EDP 50ml (Colors)	380000	Perfume inspirado en la aurora boreal, con notas cambiantes.	Eau de Parfum	40	10	80	\N	R426	P409
P328	Twilight Shimmer S. Room Spray 120ml	100000	Spray de ambiente con brillo crepuscular y aroma floral suave.	Room Spray	85	22	170	C128	R427	\N
P329	Nightfall MagicCo. Gift Set (EDT+Candle)	400000	Set Magia Nocturna con EDT 75ml y vela a juego.	Gift Set	26	6	52	\N	R428	P018
P330	Dawnbringer Parfum EDP 100ml (Hope)	370000	Perfume de esperanza con aroma a amanecer y flores frescas.	Eau de Parfum	42	10	84	\N	R429	P280
P331	Sunrise Glow P. EDT 75ml (Warmth)	245000	EDT cálida con brillo de amanecer, naranja y ámbar.	Eau de Toilette	67	18	134	C231	R430	\N
P332	Sunset Serenade S. EDC 200ml (Romantic)	215000	Colonia romántica con serenata de atardecer, rosa y vainilla.	Eau de Cologne	60	15	120	\N	R431	P026
P333	Noonday Heat Ltd. Extrait 15ml (Intense)	560000	Extracto intenso de calor de mediodía, con especias y maderas.	Extracto de Perfume	21	4	42	C333	R432	\N
P334	Evening Star Co. P. Body Cream 180g	130000	Crema corporal para la estrella vespertina, con jazmín y nardo.	Body Cream	65	18	130	\N	R433	P434
P335	Midnight Garden S. Solid Perfume Compact	170000	Perfume sólido en compacto, jardín de medianoche floral.	Solid Perfume	32	7	64	C035	R434	\N
P336	Blue Hour Parfum Candle 200g (Mystic)	175000	Vela mística de la hora azul, con incienso y lavanda.	Candle	39	8	78	\N	\N	P336
P337	Golden Hour Ltd.P. Diffuser 120ml (Warm)	180000	Difusor cálido de la hora dorada, con ámbar y vainilla.	Diffuser	37	8	74	C137	R436	\N
P338	Silver Hour Scents EDP 50ml (Cool)	320000	Perfume fresco de la hora plateada, con iris y almizcle.	Eau de Parfum	50	12	100	\N	R437	P409
P339	White Nights Co. S. EDT 100ml (Luminous)	270000	EDT luminosa de noches blancas, con flores blancas y aldehídos.	Eau de Toilette	58	15	116	C239	R438	\N
P340	Darkest Night P. EDC 200ml (Deep)	220000	Colonia profunda de la noche más oscura, con pachulí y cuero.	Eau de Cologne	55	12	110	\N	R439	P026
P341	Lightness of Being Extrait 30ml (Aura)	690000	Extracto áurico de levedad, con almizcle y notas etéreas.	Extracto de Perfume	14	3	28	C341	R440	\N
P342	Shadow Play ParfumS Body Lotion 200ml	95000	Loción corporal de juego de sombras, con maderas y especias.	Body Lotion	100	25	200	\N	R441	P434
P343	Reflection PoolCo Solid Perfume (Clear)	160000	Perfume sólido claro como un estanque, con notas acuáticas.	Solid Perfume	33	7	66	C043	R442	\N
P344	Echoing Cavern P. Candle 220g (Mystic)	180000	Vela mística con eco de caverna, con tierra húmeda y musgo.	Candle	36	8	72	\N	\N	P344
P345	Whispering Wind S. Diffuser Oil 15ml	110000	Aceite para difusor con susurro de viento, notas aéreas y frescas.	Diffuser Oil	56	12	112	C145	R444	\N
P346	Silent Forest Ltd. EDP 75ml (Green)	325000	Perfume verde de bosque silencioso, con pino y helecho.	Eau de Parfum	48	10	96	\N	R445	P409
P347	Still Waters P. EDT 100ml (Calm)	250000	EDT calmada de aguas quietas, con nenúfar y loto.	Eau de Toilette	63	15	126	C247	R446	\N
P348	Calm Sea Aromas S. EDC 120ml (Ocean)	185000	Colonia oceánica de mar en calma, con sal y algas.	Eau de Cologne	72	18	144	\N	R447	P026
P349	Serene Meadow Co. Extrait 10ml (Floral)	490000	Extracto floral de prado sereno, con flores silvestres y hierba.	Extracto de Perfume	26	6	52	C349	R448	\N
P350	Peaceful Valley P. Body Wash 250ml (Gentle)	88000	Gel de ducha suave de valle pacífico, con manzanilla y lavanda.	Body Wash	112	28	224	\N	R449	P434
P351	Blissful HeightsS Solid Perfume Locket	190000	Medallón con perfume sólido de alturas felices, floral y aéreo.	Solid Perfume Locket	27	6	54	C051	R450	\N
P352	Joyful Noise Ltd. Candle 180g (Bright)	145000	Vela brillante de ruido alegre, con cítricos y jengibre.	Candle	42	10	84	\N	\N	P352
P353	Happiness Found P. Diffuser 100ml (Sweet)	165000	Difusor dulce de felicidad encontrada, con vainilla y caramelo.	Diffuser	41	10	82	C153	R452	\N
P354	Laughter Lines CoS. EDP 50ml (Playful)	295000	Perfume juguetón de líneas de risa, con frutas y flores alegres.	Eau de Parfum	54	12	108	\N	R453	P409
P355	Smile Awhile Ltd. EDT 75ml (Happy)	215000	EDT feliz para sonreír, con mandarina y neroli.	Eau de Toilette	70	18	140	C255	R454	\N
P356	Positive Vibes P. EDC 200ml (Uplifting)	175000	Colonia edificante de vibras positivas, con pomelo y menta.	Eau de Cologne	78	20	156	\N	R455	P026
P357	Optimist Heart S. Extrait 20ml (Bright)	570000	Extracto brillante de corazón optimista, con flores solares.	Extracto de Perfume	20	4	40	C357	R456	\N
P358	Grateful SpiritCo. Body Cream 180g (Warm)	125000	Crema corporal cálida de espíritu agradecido, con ámbar y canela.	Body Cream	66	18	132	\N	R457	P434
P359	Thankful ThoughtsP. Solid Perfume Tin	130000	Perfume sólido en lata de pensamientos agradecidos, floral suave.	Solid Perfume	39	8	78	C059	R458	\N
P360	Blessed Aromas S. Candle 220g (Sacred)	170000	Vela sagrada de aromas benditos, con incienso y mirra.	Candle	38	8	76	\N	\N	P360
P361	Faith & Flowers L. Diffuser Oil 15ml	105000	Aceite para difusor de fe y flores, con rosa y lirio.	Diffuser Oil	58	15	116	C161	R460	\N
P362	Trustworthy NotesP. EDP 100ml (Reliable)	350000	Perfume confiable con notas clásicas y equilibradas.	Eau de Parfum	47	10	94	\N	R461	P409
P363	Loyalty Parfum CoS. EDT 50ml (Steadfast)	220000	EDT firme de lealtad, con cedro y vetiver.	Eau de Toilette	73	18	146	C263	R462	\N
P364	Honor & Grace Ltd. EDC 120ml (Noble)	180000	Colonia noble de honor y gracia, con lavanda y sándalo.	Eau de Cologne	76	20	152	\N	R463	P026
P365	Virtue Scents P. Extrait 10ml (Pure)	480000	Extracto puro de virtud, con almizcle blanco y flores delicadas.	Extracto de Perfume	27	6	54	C365	R464	\N
P366	Nobility Aromas S. Body Wash 250ml (Regal)	92000	Gel de ducha real de nobleza, con ámbar y especias.	Body Wash	108	25	216	\N	R465	P434
P367	Purity Essence Co. Solid Perfume Compact	165000	Perfume sólido en compacto de esencia pura, aroma limpio.	Solid Perfume	34	8	68	C067	R466	\N
P368	Innocence Found P. Candle 180g (Gentle)	140000	Vela gentil de inocencia encontrada, con talco y manzanilla.	Candle	44	10	88	\N	\N	P368
P369	Simplicity ScentsS. Diffuser 100ml (Minimal)	160000	Difusor minimalista de simplicidad, con notas sutiles.	Diffuser	43	10	86	C169	R468	\N
P370	Minimalist TouchL. EDP 75ml (Clean)	310000	Perfume limpio de toque minimalista, con Iso E Super.	Eau de Parfum	53	12	106	\N	R469	P409
P371	Essential Being P. EDT 100ml (Core)	245000	EDT esencial del ser, con notas fundamentales y equilibradas.	Eau de Toilette	68	18	136	C271	R470	\N
P372	Core Values Co. S. EDC 200ml (True)	190000	Colonia verdadera de valores fundamentales, aroma honesto.	Eau de Cologne	71	18	142	\N	R471	P026
P373	True North Ltd. P. Extrait 30ml (Guiding)	670000	Extracto guía de norte verdadero, con pino y maderas.	Extracto de Perfume	15	3	30	C373	R472	\N
P374	Authentic Self S. Body Elixir 100ml (Real)	130000	Elixir corporal real de ser auténtico, con aroma natural.	Body Elixir	65	18	130	\N	R473	P434
P375	Individuality Co. Candle Set (Unique x3)	290000	Set de 3 velas únicas de individualidad, aromas distintos.	Candle Set	26	6	52	\N	\N	P375
P376	Uniqueness ParfumP. Room Fragrance 150ml	112000	Fragancia de ambiente única, con una mezcla original.	Room Fragrance	87	22	174	C076	R475	\N
P377	Originality Scents. Gift Set (EDP+Lotion)	410000	Set Originalidad con EDP 50ml y loción a juego.	Gift Set	29	7	58	\N	R476	P018
P378	Creative SparkLtd. EDP 100ml (Inspire)	365000	Perfume inspirador de chispa creativa, con cítricos y jengibre.	Eau de Parfum	45	10	90	\N	R477	P280
P379	Imagination Co. P. EDT 50ml (Dream)	230000	EDT de ensueño para la imaginación, con frutas y flores.	Eau de Toilette	72	18	144	C178	R478	\N
P380	Visionary AromasS. EDC 120ml (Future)	180000	Colonia futurista para visionarios, con notas metálicas y ozónicas.	Eau de Cologne	77	20	154	\N	R479	P382
P381	Dreamscape ParfumL. Extrait 10ml (Ethereal)	500000	Extracto etéreo de paisaje onírico, con flores luminosas.	Extracto de Perfume	24	5	48	C280	R480	\N
P382	Fantasia Notes P. Body Mist 150ml (Magic)	78000	Bruma corporal mágica de fantasía, con frutas encantadas.	Body Mist	118	28	236	\N	R481	P434
P383	Wonderlust Co. S. Solid Perfume (Explore)	145000	Perfume sólido para explorar, con notas exóticas y aventureras.	Solid Perfume	37	8	74	C382	R482	\N
P384	Magical ThinkingP. Candle 220g (Believe)	175000	Vela para creer en la magia, con incienso y vainilla.	Candle	39	8	78	\N	\N	P383
P385	Enchanted ForestS. Diffuser Oil 15ml (Mystic)	112000	Aceite para difusor de bosque encantado, con musgo y pino.	Diffuser Oil	55	12	110	C084	R484	\N
P386	Spellbound AromasL. EDP 75ml (Captivate)	320000	Perfume cautivador y hechizante, con flores oscuras y especias.	Eau de Parfum	50	12	100	\N	R485	P409
P387	Charmed Life Co. P. EDT 100ml (Lucky)	255000	EDT de vida encantada y afortunada, con trébol y cítricos.	Eau de Toilette	66	18	132	C186	R486	\N
P388	Amulet Scents S. EDC 200ml (Protect)	200000	Colonia protectora de amuleto, con sándalo y mirra.	Eau de Cologne	69	18	138	\N	R487	P026
P389	Talisman ParfumLtd. Extrait 30ml (Power)	680000	Extracto poderoso de talismán, con ámbar y oud.	Extracto de Perfume	16	3	32	C288	R488	\N
P390	Fortuna's Favor P. Body Cream 180g (Luck)	128000	Crema corporal de la fortuna, con aroma a prosperidad.	Body Cream	63	15	126	\N	R489	P434
P391	Prosperity EssenceS. Solid Perfume Compact	175000	Perfume sólido en compacto de prosperidad, con pachulí y canela.	Solid Perfume	31	7	62	C390	R490	\N
P392	Abundance Co. Ltd. Candle 180g (Rich)	150000	Vela rica de abundancia, con frutas y especias.	Candle	40	10	80	\N	\N	P391
P393	Wealth & Wisdom P. Diffuser 100ml (Noble)	170000	Difusor noble de riqueza y sabiduría, con cedro e incienso.	Diffuser	42	10	84	C092	R492	\N
P394	Luxuria Aromas S. EDP 50ml (Opulent)	380000	Perfume opulento de luxuria, con orquídea y vainilla negra.	Eau de Parfum	43	10	86	\N	R493	P409
P395	Opulence Parfum Co. EDT 75ml (Grand)	270000	EDT grandiosa de opulencia, con ámbar y flores exóticas.	Eau de Toilette	60	15	120	C194	R494	\N
P396	Richness of Spirit. EDC 120ml (Full)	190000	Colonia plena de riqueza espiritual, con sándalo y mirra.	Eau de Cologne	74	20	148	\N	R495	P026
P397	Grandeur Scents P. Extrait 10ml (Majestic)	530000	Extracto majestuoso de grandeza, con oud y rosa.	Extracto de Perfume	22	5	44	C296	R496	\N
P398	Majesty Parfum Ltd. Body Elixir 100ml	140000	Elixir corporal majestuoso, con aceites dorados y aroma real.	Body Elixir	59	15	118	\N	R497	P434
P399	Regalia Aromas Co. Candle Set (Royal x3)	300000	Set de 3 velas reales de regalia, aromas nobles.	Candle Set	25	6	50	\N	\N	P398
P400	Sovereign EssenceS. Room Fragrance 150ml	120000	Fragancia de ambiente soberana, con incienso y maderas.	Room Fragrance	84	22	168	C098	R499	\N
P401	Imperium Parfum P. Gift Set (EDP+Solid)	460000	Set Imperium con EDP 50ml y perfume sólido a juego.	Gift Set	27	6	54	\N	R500	P018
P402	Dynasty Scents Ltd. EDP 100ml (Legacy)	380000	Perfume legado de dinastía, con ámbar y especias ancestrales.	Eau de Parfum	40	10	80	\N	R501	P280
P403	Noblesse Oblige Co. EDT 50ml (Refined)	240000	EDT refinada de nobleza, con iris y violeta.	Eau de Toilette	68	18	136	C101	R502	\N
P404	Aristocrat AromasS. EDC 200ml (Classic)	210000	Colonia clásica aristocrática, con lavanda y cuero.	Eau de Cologne	65	18	130	\N	R503	P026
P405	Elite Collection P. Extrait 30ml (Top)	750000	Extracto top de colección élite, con ingredientes exclusivos.	Extracto de Perfume	12	3	24	C203	R504	\N
P406	Prestige ParfumLtd. Body Shimmer Oil 50ml	135000	Aceite corporal con brillo de prestigio, aroma lujoso.	Body Shimmer Oil	60	15	120	\N	R505	P434
P407	Ultimate Essence S. Solid Perfume Compact	180000	Perfume sólido en compacto de esencia última, aroma único.	Solid Perfume	30	7	60	C305	R506	\N
P408	Perfection Co. P. Candle 180g (Flawless)	155000	Vela impecable de perfección, con aroma puro y equilibrado.	Candle	39	8	78	\N	\N	P307
P409	Ideal FormulationsS. Diffuser 100ml (Pure)	175000	Difusor puro de formulaciones ideales, aroma limpio.	Diffuser	38	8	76	C008	R508	\N
P410	Flawless Finish L. EDP 75ml (Smooth)	340000	Perfume suave de acabado impecable, con almizcle y cachemira.	Eau de Parfum	46	10	92	\N	R509	P409
P411	Excellence ParfumP. EDT 100ml (Superior)	275000	EDT superior de excelencia, con notas vibrantes y duraderas.	Eau de Toilette	59	15	118	C110	R510	\N
P412	Supreme Aromas CoS. EDC 120ml (Grand)	200000	Colonia grandiosa de aromas supremos, con cítricos y maderas.	Eau de Cologne	70	18	140	\N	R511	P026
P413	Top Tier Scents L. Extrait 10ml (Peak)	540000	Extracto cumbre de aromas de primer nivel, con ingredientes raros.	Extracto de Perfume	23	5	46	C212	R512	\N
P414	Apex Notes ParfumP. Bath Salts 300g (Zenith)	110000	Sales de baño cénit de notas cumbre, relajantes y lujosas.	Bath Salts	67	18	134	\N	R513	P402
P415	Zenith CollectionS. Candle Set (Peak x3)	310000	Set de 3 velas cumbre de colección cénit, aromas elevados.	Candle Set	24	5	48	\N	\N	P315
P416	Summit Aromas Co. Room Spray 120ml (High)	110000	Spray de ambiente alto de aromas cumbre, fresco y puro.	Room Spray	83	22	166	C314	R515	\N
P417	Peak Performance P. Gift Set (EDP+Deo)	430000	Set Rendimiento Cumbre con EDP 50ml y desodorante.	Gift Set	28	6	56	\N	R516	P018
P418	Highland Mist S. EDP 100ml (Earthy)	375000	Perfume terroso de bruma de altiplano, con brezo y musgo.	Eau de Parfum	42	10	84	\N	R517	P280
P419	Lowland Bloom Ltd. EDT 50ml (Floral)	230000	EDT floral de flor de llanura, con flores silvestres y hierba.	Eau de Toilette	71	18	142	C017	R518	\N
P420	Valley Dew ParfumP. EDC 200ml (Fresh)	200000	Colonia fresca de rocío de valle, con notas verdes y acuáticas.	Eau de Cologne	66	18	132	\N	R519	P026
P421	Plainsong AromasS. Extrait 30ml (Simple)	660000	Extracto simple de canto llano, con notas puras y serenas.	Extracto de Perfume	17	3	34	C119	R520	\N
P422	Meadow Gold Co. L. Body Butter 180g (Rich)	132000	Manteca corporal rica de oro de prado, con miel y flores.	Body Butter	61	15	122	\N	R521	P434
P423	Grassroots ParfumP. Solid Perfume Compact	170000	Perfume sólido en compacto de raíces, con hierba y tierra.	Solid Perfume	32	7	64	C221	R522	\N
P424	Earthen Vessels S. Candle 180g (Natural)	148000	Vela natural de vasijas de barro, con arcilla y musgo.	Candle	40	10	80	\N	\N	P324
P425	Terra Firma II Co. Diffuser 100ml (Ground)	168000	Difusor de tierra firme II, con vetiver y pachulí.	Diffuser	40	10	80	C323	R524	\N
P426	Stone Circle P. EDP 75ml (Mystic)	335000	Perfume místico de círculo de piedras, con incienso y musgo.	Eau de Parfum	47	10	94	\N	R525	P409
P427	Rock Crystal Ltd.S. EDT 100ml (Clear)	265000	EDT clara de cristal de roca, con notas minerales y ozónicas.	Eau de Toilette	62	15	124	C025	R526	\N
P428	Mineral Spring P. EDC 120ml (Fresh)	195000	Colonia fresca de manantial mineral, con notas acuáticas.	Eau de Cologne	72	18	144	\N	R527	P026
P429	Gemstone Essence S. Extrait 10ml (Precious)	550000	Extracto precioso de esencia de gema, multifacético.	Extracto de Perfume	22	5	44	C127	R528	\N
P430	Amethyst Dream Co. Bath Oil 100ml (Calm)	118000	Aceite de baño calmante de sueño amatista, con lavanda.	Bath Oil	64	15	128	\N	R529	P402
P431	Sapphire Sky P. Candle Set (Celestialx3)	305000	Set de 3 velas celestiales de cielo zafiro, aromas etéreos.	Candle Set	25	6	50	\N	\N	P330
P432	Ruby Ember Ltd. S. Room Spray 120ml (Warm)	112000	Spray de ambiente cálido de brasa rubí, con canela y clavo.	Room Spray	85	22	170	C231	R531	\N
P433	Emerald Forest P. Gift Set (EDP+Lotion)	440000	Set Bosque Esmeralda con EDP 50ml y loción a juego.	Gift Set	27	6	54	\N	R532	P018
P434	Opal Mist Parfum S. EDP 100ml (Mystic)	390000	Perfume místico de niebla ópalo, con iris y almizcle.	Eau de Parfum	41	10	82	\N	R533	P280
P435	Jade Whisper Co. L. EDT 50ml (Serene)	235000	EDT serena de susurro jade, con té verde y bambú.	Eau de Toilette	70	18	140	C333	R534	\N
P436	Topaz Sun Parfum P. EDC 200ml (Bright)	205000	Colonia brillante de sol topacio, con cítricos y flores solares.	Eau de Cologne	67	18	134	\N	R535	P026
P437	Garnet Glow Aromas. Extrait 30ml (Deep)	675000	Extracto profundo de brillo granate, con frutos rojos y especias.	Extracto de Perfume	16	3	32	C035	R536	\N
P438	Aquamarine Deep S. Body Soufflé 180g	138000	Soufflé corporal de profundidad aguamarina, aroma fresco.	Body Soufflé	60	15	120	\N	R537	P434
P439	Peridot Leaf Co. P. Solid Perfume Compact	172000	Perfume sólido en compacto de hoja peridoto, verde y herbal.	Solid Perfume	31	7	62	C137	R538	\N
P440	Citrine Zest Ltd.S. Candle 180g (Bright)	152000	Vela brillante de cáscara citrina, con limón y jengibre.	Candle	39	8	78	\N	\N	P340
P441	Turquoise Bay P. Diffuser 100ml (Coastal)	172000	Difusor costero de bahía turquesa, con sal y brisa marina.	Diffuser	39	8	78	C239	R540	\N
P442	Moonstone Magic S. EDP 75ml (Mystic)	345000	Perfume místico de magia piedra lunar, con flores blancas y sándalo.	Eau de Parfum	45	10	90	\N	R541	P409
P443	Sunstone RadianceC. EDT 100ml (Warm)	280000	EDT cálida de radiancia piedra solar, con ámbar y cítricos.	Eau de Toilette	57	15	114	C341	R542	\N
P444	Labradorite FlashP. EDC 120ml (Shifting)	210000	Colonia cambiante de destello labradorita, con notas iridiscentes.	Eau de Cologne	68	18	136	\N	R543	P026
P445	Tiger Eye Parfum S. Extrait 10ml (Bold)	560000	Extracto audaz de ojo de tigre, con ámbar y especias.	Extracto de Perfume	21	5	42	C043	R544	\N
P446	Obsidian Night Ltd. Body Mist 150ml (Dark)	82000	Bruma corporal oscura de noche obsidiana, con incienso y cuero.	Body Mist	115	28	230	\N	R545	P434
P447	Quartz Clear Co. P. Solid Perfume Tin	168000	Perfume sólido en lata de cuarzo claro, aroma puro y limpio.	Solid Perfume	34	8	68	C145	R546	\N
P448	Agate Earth TonesS. Candle 220g (Natural)	182000	Vela natural de tonos tierra ágata, con musgo y maderas.	Candle	37	8	74	\N	\N	P348
P449	Jasper Stone Ltd. Diffuser Oil 15ml	118000	Aceite para difusor de piedra jaspe, aroma terroso y cálido.	Diffuser Oil	54	12	108	C247	R548	\N
P450	Malachite Swirl P. EDP 50ml (Green)	350000	Perfume verde de remolino malaquita, con notas herbales y minerales.	Eau de Parfum	44	10	88	\N	R549	P409
P451	Lapis Lazuli Co. S. EDT 75ml (Deep Blue)	285000	EDT azul profundo de lapislázuli, con notas marinas y florales.	Eau de Toilette	56	15	112	C349	R550	\N
P452	Azurite Sky Ltd. P. EDC 200ml (Celestial)	225000	Colonia celestial de cielo azurita, con notas ozónicas y etéreas.	Eau de Cologne	53	12	106	\N	R551	P026
P453	Fluorite Dreams S. Extrait 20ml (Rainbow)	695000	Extracto arcoíris de sueños fluorita, con notas multifacéticas.	Extracto de Perfume	13	3	26	C051	R552	\N
P454	Selenite Moon Co. Body Elixir 100ml (Pure)	142000	Elixir corporal puro de luna selenita, con almizcle blanco.	Body Elixir	58	15	116	\N	R553	P434
P455	Calcite Glow P. Candle Set (Warm x3)	315000	Set de 3 velas cálidas de brillo calcita, aromas suaves.	Candle Set	22	5	44	\N	\N	P355
P456	Pyrite Spark Ltd.S. Room Fragrance 150ml	122000	Fragancia de ambiente chispeante de pirita, con notas metálicas.	Room Fragrance	82	22	164	C153	R555	\N
P457	Hematite Ground P. Gift Set (EDP+Solid)	470000	Set Tierra Hematita con EDP 50ml y perfume sólido a juego.	Gift Set	26	6	52	\N	R556	P018
P458	Rhodochrosite Love. EDP 100ml (Rose)	400000	Perfume de amor rodocrosita, con rosa, peonía y frutos rojos.	Eau de Parfum	39	8	78	\N	R557	P280
P459	Kunzite Spirit CoS. EDT 50ml (Gentle)	245000	EDT gentil de espíritu kunzita, con flores rosadas y almizcle.	Eau de Toilette	67	18	134	C255	R558	\N
P460	Morganite Heart P. EDC 120ml (Sweet)	215000	Colonia dulce de corazón morganita, con durazno y vainilla.	Eau de Cologne	64	15	128	\N	R559	P026
P461	Heliodor Sun Ltd.S. Extrait 10ml (Golden)	570000	Extracto dorado de sol heliodoro, con flores amarillas y miel.	Extracto de Perfume	20	4	40	C357	R560	\N
P462	Spinel Fire Parfum. Body Shimmer Oil 50ml	148000	Aceite corporal con brillo de fuego espinela, aroma especiado.	Body Shimmer Oil	57	15	114	\N	R561	P434
P463	Zircon BrillianceP. Solid Perfume Compact	182000	Perfume sólido en compacto de brillo zircón, aroma chispeante.	Solid Perfume	29	7	58	C059	R562	\N
P464	Iolite Vision Co.S. Candle 180g (Clarity)	160000	Vela de claridad visión iolita, con menta y eucalipto.	Candle	38	8	76	\N	\N	P364
P465	Apatite Clarity L. Diffuser 100ml (Focus)	178000	Difusor de enfoque claridad apatita, con romero y pino.	Diffuser	37	8	74	C161	R564	\N
P466	Kyanite Flow P. EDP 75ml (Serene)	355000	Perfume sereno de flujo cianita, con notas acuáticas y herbales.	Eau de Parfum	43	10	86	\N	R565	P409
P467	Chrysocolla PeaceS. EDT 100ml (Calm)	290000	EDT calmada de paz crisocola, con manzanilla y sándalo.	Eau de Toilette	55	12	110	C263	R566	\N
P468	Prehnite Dream Co. EDC 200ml (Mystic)	230000	Colonia mística de sueño prehnita, con flores nocturnas.	Eau de Cologne	52	12	104	\N	R567	P026
P469	Seraphinite Wing P. Extrait 20ml (Angelic)	710000	Extracto angélico de ala serafinita, con lirio y almizcle.	Extracto de Perfume	12	3	24	C365	R568	\N
P470	Danburite Light S. Body Elixir 100ml (Pure)	150000	Elixir corporal puro de luz danburita, con notas etéreas.	Body Elixir	56	15	112	\N	R569	P434
P471	Petalite Angel Ltd. Candle Set (Heavenlyx3)	330000	Set de 3 velas celestiales de ángel petalita, aromas divinos.	Candle Set	21	5	42	\N	\N	P371
P472	Phenakite Power P. Room Fragrance 150ml	130000	Fragancia de ambiente poderosa de fenaquita, energizante.	Room Fragrance	80	22	160	C067	R571	\N
P473	Moldavite Star CoS. Gift Set (EDP+Oil)	500000	Set Estrella Moldavita con EDP 50ml y aceite cósmico.	Gift Set	24	5	48	\N	R572	P018
P474	Tektite Cosmic Ltd. EDP 100ml (Meteor)	410000	Perfume meteórico de tectita cósmica, con notas minerales.	Eau de Parfum	38	8	76	\N	R573	P280
P475	Libyan DesertGlass. EDT 50ml (Solar)	250000	EDT solar de vidrio desierto libio, con ámbar y especias.	Eau de Toilette	65	18	130	C169	R574	\N
P476	Shungite Protect P. EDC 120ml (Grounding)	220000	Colonia protectora de shungita, con vetiver y tierra.	Eau de Cologne	63	15	126	\N	R575	P026
P477	Amber Resin Scents. Extrait 10ml (Warm)	580000	Extracto cálido de resina de ámbar, profundo y dulce.	Extracto de Perfume	20	4	40	C265	R576	\N
P478	Copal Incense Co.S. Body Mist 150ml (Sacred)	85000	Bruma corporal sagrada de incienso copal, purificante.	Body Mist	110	28	220	\N	R577	P434
P479	Frankincense Ltd.P. Solid Perfume (Holy)	170000	Perfume sólido sagrado de olíbano, con resinas y maderas.	Solid Perfume	30	7	60	C367	R578	\N
P480	Myrrh Mystique S. Candle 220g (Ancient)	190000	Vela ancestral de mirra mística, con especias y ámbar.	Candle	35	8	70	\N	\N	P380
P481	Palo Santo WoodCo. Diffuser Oil 15ml (Cleanse)	125000	Aceite para difusor purificante de palo santo, sagrado.	Diffuser Oil	52	12	104	C076	R580	\N
P482	White Sage CleanseP. EDP 75ml (Pure)	360000	Perfume puro de limpieza salvia blanca, herbal y fresco.	Eau de Parfum	42	10	84	\N	R581	P409
P483	Cedarwood Atlas S. EDT 100ml (Woody)	295000	EDT amaderada de cedro del Atlas, seco y elegante.	Eau de Toilette	54	12	108	C178	R582	\N
P484	Pine Needle FreshL. EDC 200ml (Forest)	235000	Colonia fresca de aguja de pino, aroma a bosque.	Eau de Cologne	50	12	100	\N	R583	P026
P485	Juniper Berry P. Extrait 20ml (Crisp)	700000	Extracto crujiente de baya de enebro, herbal y gin-like.	Extracto de Perfume	11	2	22	C280	R584	\N
P486	Cypress Grove Co.S. Body Wash 250ml (Green)	95000	Gel de ducha verde de cipresal, fresco y resinoso.	Body Wash	100	25	200	\N	R585	P434
P487	Vetiver Earth Ltd. Solid Perfume Compact	178000	Perfume sólido en compacto de tierra vetiver, ahumado.	Solid Perfume	28	6	56	C382	R586	\N
P488	Patchouli Deep P. Candle 180g (Mystic)	165000	Vela mística de pachulí profundo, terroso y dulce.	Candle	36	8	72	\N	\N	P388
P489	Ylang Ylang BloomS. Diffuser 100ml (Exotic)	182000	Difusor exótico de flor ylang-ylang, dulce y narcótico.	Diffuser	36	8	72	C084	R588	\N
P490	Neroli Blossom Co. EDP 50ml (Bright)	370000	Perfume brillante de flor de neroli, cítrico y floral.	Eau de Parfum	41	10	82	\N	R589	P409
P491	Petitgrain Leaf P. EDT 75ml (GreenCitrus)	260000	EDT verde cítrica de hoja de petitgrain, fresca y amarga.	Eau de Toilette	60	15	120	C186	R590	\N
P492	Bergamot Bliss LtdS. EDC 120ml (Uplifting)	200000	Colonia edificante de felicidad bergamota, chispeante.	Eau de Cologne	67	18	134	\N	R591	P026
P493	Lavender Calm P. Extrait 10ml (Relaxing)	510000	Extracto relajante de calma lavanda, herbal y suave.	Extracto de Perfume	25	5	50	C288	R592	\N
P494	Chamomile Dream S. Body Lotion 200ml (Soothing)	98000	Loción corporal calmante de sueño manzanilla, delicada.	Body Lotion	95	22	190	\N	R593	P434
P495	Rosemary Focus Co. Solid Perfume Tin	140000	Perfume sólido en lata de enfoque romero, herbal y estimulante.	Solid Perfume	38	8	76	C390	R594	\N
P496	Peppermint Rush P. Candle 220g (Invigorate)	170000	Vela vigorizante de impulso menta, fresca y penetrante.	Candle	37	8	74	\N	\N	P396
P497	Spearmint Fresh S. Diffuser Oil 15ml	108000	Aceite para difusor fresco de hierbabuena, dulce y mentolado.	Diffuser Oil	57	15	114	C092	R596	\N
P498	Eucalyptus Clear L. EDP 100ml (Breathe)	355000	Perfume para respirar de eucalipto claro, balsámico y fresco.	Eau de Parfum	43	10	86	\N	R597	P409
P499	Tea Tree Pure P. EDT 50ml (Cleanse)	230000	EDT purificante de árbol de té puro, medicinal y herbal.	Eau de Toilette	69	18	138	C194	R598	\N
P500	Lemon Zest Co. S. EDC 200ml (Brightening)	195000	Colonia iluminadora de cáscara de limón, vibrante y ácida.	Eau de Cologne	70	18	140	C296	R599	P026
\.


                                                5131.dat                                                                                            0000600 0004000 0002000 00000254373 15014423351 0014257 0                                                                                                    ustar 00postgres                        postgres                        0000000 0000000                                                                                                                                                                        P000	2023-11-20	2023-11-26	BF23	Black Friday 2023: Hasta 50% en seleccionados
P001	2023-12-01	2023-12-24	XMS3	Navidad Mágica: 20% en toda la tienda + Regalo sorpresa
P002	2023-12-26	2023-12-31	BOX3	Boxing Week: Descuentos de fin de año hasta 60%
P003	2024-01-02	2024-01-15	NYR4	Año Nuevo, Aroma Nuevo: 15% en lanzamientos 2024
P004	2024-01-20	2024-01-22	WK01	Flash Sale Fin de Semana: 25% en fragancias cítricas
P005	2024-02-01	2024-02-14	VALN	San Valentín: Compra un perfume, llévate una miniatura de lujo
P006	2024-02-10	2024-02-11	LVE4	Amor y Amistad Weekend: 2x1 en sets de regalo seleccionados
P007	2024-02-20	2024-02-29	FEB4	Fin de Mes Febrero: Envío gratis en compras > $100
P008	2024-03-01	2024-03-08	WOMN	Día de la Mujer: 20% en perfumes florales y frutales
P009	2024-03-15	2024-03-17	GRN4	Promo Verde St. Patrick: 17% en fragancias con notas verdes
P010	2024-03-25	2024-03-31	SPR1	Bienvenida Primavera: 10% + muestra floral con cada pedido
P011	2024-04-01	2024-04-07	APR4	Semana de Abril: Compra 2 productos, el 3ro al 50%
P012	2024-04-12	2024-04-14	FLS1	Flash Sale Abril: 30% en línea Oriental por 48h
P013	2024-04-20	2024-04-30	ERTH	Día de la Tierra: 15% en marcas eco-amigables + donación
P014	2024-05-01	2024-05-12	MOM4	Especial Día de la Madre: Sets de regalo con 25% off
P015	2024-05-05	2024-05-05	CINCO	Cinco de Mayo: Descuento especial en fragancias con agave
P016	2024-05-18	2024-05-19	MYST	Fin de Semana Misterioso: Descuento sorpresa al pagar
P017	2024-05-25	2024-05-31	MEMD	Memorial Day Sale: 20% en fragancias de verano USA
P018	2024-06-01	2024-06-16	DAD4	Día del Padre: 20% en masculinas + neceser de regalo
P019	2024-06-10	2024-06-10	LMN4	Lunes de Lanzamiento: Nuevo perfume con precio especial hoy
P020	2024-06-21	2024-06-23	SOLS	Solsticio de Verano: 15% en fragancias frescas y solares
P021	2024-06-28	2024-06-30	PAYD	Fin de Mes Junio: Doble puntos de lealtad en todas las compras
P022	2024-07-01	2024-07-07	JUL4	Semana de la Independencia (USA): Descuentos patrióticos
P023	2024-07-04	2024-07-04	FREE	4 de Julio: Envío GRATIS en todos los pedidos
P024	2024-07-15	2024-07-21	SUMR	Ofertas de Verano: Hasta 30% en colonias y body mists
P025	2024-07-20	2024-07-20	COLD	Día de la Independencia (COL): 20% en marcas nacionales
P026	2024-07-27	2024-07-28	PRM4	Prime Days Diamond: Ofertas exclusivas para miembros
P027	2024-08-01	2024-08-11	BKSC	Regreso a Clases: 15% en juveniles + estuche de regalo
P028	2024-08-07	2024-08-07	BOY4	Batalla de Boyacá: Descuento especial en fragancias históricas
P029	2024-08-15	2024-08-18	DOGD	Día del Perro: 10% y donación a refugios con tu compra
P030	2024-08-24	2024-08-25	WK08	Fin de Semana de Agosto: Compra 1 lleva el 2do con 40% off
P031	2024-09-01	2024-09-02	LABR	Labor Day Sale: Descuentos para celebrar el trabajo
P032	2024-09-07	2024-09-08	FLW4	Festival Floral: 20% en perfumes con base de flores blancas
P033	2024-09-15	2024-09-22	AMOR	Semana Amor y Amistad: Sets para compartir con descuento
P034	2024-09-20	2024-09-20	LOVE	Día del Amor y la Amistad: Regalo especial con compras > $150
P035	2024-09-28	2024-09-29	AUTM	Bienvenida Otoño: 15% en fragancias amaderadas y especiadas
P036	2024-10-01	2024-10-07	NICH	Semana del Perfume Nicho: Descubre joyas ocultas con 10% off
P037	2024-10-12	2024-10-14	RACE	Día de la Raza/Columbus Day: Ofertas en fragancias del mundo
P038	2024-10-19	2024-10-20	SPKY	Fin de Semana Espeluznante: Pre-Halloween 13% off
P039	2024-10-26	2024-10-31	HALO	Halloween: Compra y recibe dulces y muestra misteriosa
P040	2024-11-01	2024-11-03	SOUL	Día de Muertos: Ofrenda de aromas con descuento especial
P041	2024-11-01	2024-11-11	SING	Single's Day Sale: Descuentos para consentirte
P042	2024-11-11	2024-11-11	VET4	Veterans Day: Descuento especial para veteranos
P043	2024-11-15	2024-11-24	PREB	Pre-Black Friday: Acceso anticipado a ofertas para miembros
P044	2024-11-28	2024-11-28	THNK	Thanksgiving: Agradecimiento con envío gratis
P045	2024-11-29	2024-11-29	BLKF	BLACK FRIDAY: ¡Las MEJORES OFERTAS del año!
P046	2024-11-30	2024-12-01	SMBS	Small Business Saturday/Sunday: Apoya con descuento
P047	2024-12-02	2024-12-02	CYBM	CYBER MONDAY: Ofertas online extendidas!
P048	2024-12-03	2024-12-15	GIFT	Guía de Regalos Navideños: Descuentos en sets y perfumes top
P049	2024-12-07	2024-12-08	VELA	Noche de Velitas: Set de mini velas aromáticas con compra
P050	2024-12-16	2024-12-24	LAST	Última Semana para Regalos: Envío express con descuento
P051	2024-12-25	2024-12-25	MERY	Feliz Navidad: Descuento especial solo por hoy!
P052	2024-12-26	2024-12-31	EOY4	Fin de Año Sale: Liquida stock 2024 con hasta 70% off
P053	2025-01-01	2025-01-01	NEW5	Bienvenido 2025: 25% en tu primera compra del año
P054	2025-01-02	2025-01-10	CLNS	Limpieza de Enero: Descuentos adicionales en productos seleccionados
P055	2025-01-15	2025-01-17	BLUM	Blue Monday Pick-Me-Up: 10% en fragancias alegres
P056	2025-01-25	2025-01-26	WINT	Escapada de Invierno: Set de viaje con compras > $120
P057	2025-02-01	2025-02-14	VAL5	San Valentín 2025: Ediciones especiales y regalos con compra
P058	2025-02-08	2025-02-09	LOVEWK	Love Weekend: 2x1 en perfumes de pareja seleccionados
P059	2025-02-20	2025-02-28	LEAP	Año Bisiesto (si aplica): Promo especial cada 4 años!
P060	2025-03-01	2025-03-09	WMS5	Semana de la Mujer 2025: Descuentos y regalos en marcas femeninas
P061	2025-03-17	2025-03-17	STP5	St. Patrick's Day: 17% off en todo lo verde o irlandés
P062	2025-03-21	2025-03-23	EQNX	Equinoccio de Primavera: Nuevos aromas con descuento de introducción
P063	2025-03-29	2025-03-31	EMAR	Fin de Mes Marzo: Envío gratis en toda la tienda
P064	2025-04-01	2025-04-01	FOOL	April Fools: ¿Descuento real o broma? Descúbrelo!
P065	2025-04-05	2025-04-13	SPR5	Gran Venta de Primavera: Renueva tus fragancias con 20% off
P066	2025-04-19	2025-04-21	ESTR	Pascua: Regalos dulces y descuentos en florales suaves
P067	2025-04-22	2025-04-22	ERTD	Día de la Tierra 2025: Promociones en productos sostenibles
P068	2025-04-26	2025-04-27	FLS2	Flash Sale Abril: 35% en línea Gourmand por 48h
P069	2025-05-01	2025-05-11	MTHR5	Día de la Madre 2025: Los mejores regalos con descuento
P070	2025-05-10	2025-05-10	STARW	Star Wars Day (May 4th be with you): Promo galáctica
P071	2025-05-17	2025-05-18	MYWK	Fin de Semana Misterioso Mayo: Código oculto para gran descuento
P072	2025-05-24	2025-05-26	MMRW	Memorial Weekend Sale: Descuentos para el inicio del verano
P073	2025-05-31	2025-05-31	NOSM	Día sin Tabaco: 10% en fragancias frescas y limpias
P074	2025-06-01	2025-06-15	FTHR5	Día del Padre 2025: Sorpréndelo con aromas únicos
P075	2025-06-07	2025-06-08	OCEAN	Día de los Océanos: 15% en acuáticas + donación a conservación
P076	2025-06-14	2025-06-15	GRAD	Felicidades Graduados: Descuento especial para ellos
P077	2025-06-20	2025-06-22	SMRS	Solsticio Verano 2025: Celebra el día más largo con ofertas
P078	2025-06-28	2025-06-30	EJUN	Fin de Mes Junio: Compra $X y llévate un travel size gratis
P079	2025-07-01	2025-07-01	CAN5	Canada Day: Ofertas especiales para nuestros amigos canadienses
P080	2025-07-04	2025-07-06	IND5	Independence Day USA: Fin de semana de ofertas patrias
P081	2025-07-12	2025-07-13	FLS3	Flash Sale Julio: 40% en bestsellers de verano
P082	2025-07-19	2025-07-20	COL5	Independencia Colombia: 20% en toda la tienda (si aplica)
P083	2025-07-26	2025-07-27	PRD5	Diamond Prime Weekend: Ofertas y lanzamientos exclusivos
P084	2025-08-01	2025-08-03	AUGF	Agosto Fresco: 2x1 en body mists y aguas de colonia
P085	2025-08-09	2025-08-10	CATD	Día Internacional del Gato: Muestra gratis con temática felina
P086	2025-08-16	2025-08-24	BTS5	Vuelta al Cole 2025: Sets juveniles con descuento
P087	2025-08-30	2025-08-31	EAUG	Fin de Mes Agosto: Envío express a mitad de precio
P088	2025-09-01	2025-09-01	LBD5	Labor Day 2025: Relájate con nuestras ofertas
P089	2025-09-06	2025-09-07	GRAND	Día de los Abuelos: Descuento en fragancias clásicas
P090	2025-09-13	2025-09-21	AYAS	Amor y Amistad Semana 2025: Regalos para todos
P091	2025-09-20	2025-09-20	AMOR5	Día especial Amor y Amistad: Sorpresas y regalos
P092	2025-09-22	2025-09-22	AUTE	Equinoccio de Otoño: Descuentos en cálidos y especiados
P093	2025-09-27	2025-09-28	TOUR	Día Mundial del Turismo: Fragancias inspiradas en viajes con off
P094	2025-10-01	2025-10-05	VEGN	Mes Vegetariano: 15% en todas nuestras fragancias veganas
P095	2025-10-04	2025-10-05	ANML	Día Mundial de los Animales: Donación por cada compra + promo
P096	2025-10-11	2025-10-13	DISC	Discovery Weekend: Muestras gratis de nuevas marcas
P097	2025-10-18	2025-10-19	FLS4	Flash Sale Octubre: 30% en perfumes de cuero y tabaco
P098	2025-10-25	2025-10-31	HLWN5	Semana de Halloween: Descuentos y regalos temáticos
P099	2025-11-01	2025-11-02	ALLS	Día de Todos los Santos: Aromas reconfortantes en oferta
P100	2024-01-05	2024-01-12	CHNLS	Semana Chanel: 10% en toda la línea Chanel + muestra No.5
P101	2024-01-13	2024-01-19	DIORS	Especial Dior: Compra Sauvage y llévate miniatura JAdore
P102	2024-01-20	2024-01-26	GUCCI	Gucci Bloom Days: 15% en la colección Bloom y accesorios
P103	2024-01-27	2024-02-02	YSLWK	Semana Yves Saint Laurent: Black Opium con 20% off
P104	2024-02-03	2024-02-09	LNCME	Lancôme Paris: La Vie Est Belle con regalo especial
P105	2024-02-10	2024-02-16	ARMNI	Armani Code Event: Descuento en toda la línea Code
P106	2024-02-17	2024-02-23	T FORD	Tom Ford Private Blend: Muestras exclusivas con compra
P107	2024-02-24	2024-03-02	PRADA	Prada Candy Fest: 10% en la línea Candy + body lotion
P108	2024-03-03	2024-03-09	VERSA	Versace Eros Flame: Set de regalo con la fragancia
P109	2024-03-10	2024-03-16	GIVEN	Givenchy LInterdit: 15% + labial miniatura
P110	2024-03-17	2024-03-23	BRBRY	Burberry Brit Focus: Descuento y regalo de bufanda miniatura
P111	2024-03-24	2024-03-30	BVLGR	Bvlgari Omnia Week: 10% en la colección Omnia
P112	2024-03-31	2024-04-06	CKONE	Calvin Klein One: Promoción especial 2x$XX
P113	2024-04-07	2024-04-13	HERMS	Hermès Jardin Collection: Muestra de Twilly con compra
P114	2024-04-14	2024-04-20	PACOR	Paco Rabanne Invictus: Kit de afeitado de regalo
P115	2024-04-21	2024-04-27	JPGSC	Jean Paul Gaultier Scandal: 20% en la fragancia
P116	2024-04-28	2024-05-04	CHERR	Carolina Herrera Good Girl: Set con body lotion
P117	2024-05-05	2024-05-11	HBOSS	Hugo Boss Bottled: Descuento en el tamaño grande
P118	2024-05-12	2024-05-18	RLLAU	Ralph Lauren Polo Blue: Aftershave de regalo
P119	2024-05-19	2024-05-25	MGLER	Mugler Alien Days: Recarga tu frasco con descuento
P120	2024-05-26	2024-06-01	NRISO	Narciso Rodriguez For Her: 15% + miniatura
P121	2024-06-02	2024-06-08	JMALO	Jo Malone London: Vela pequeña con compra de colonia 100ml
P122	2024-06-09	2024-06-15	CREED	Creed Aventus Special: Muestra de Viking con Aventus
P123	2024-06-16	2024-06-22	MTBLC	Montblanc Legend: Descuento en set de regalo
P124	2024-06-23	2024-06-29	DGLIG	Dolce&Gabbana Light Blue: Gel de ducha de regalo
P125	2024-06-30	2024-07-06	KNZFL	Kenzo Flower: 10% en toda la línea Flower by Kenzo
P126	2024-07-07	2024-07-13	CHLOE	Chloé Signature: Muestra de Nomade con compra
P127	2024-07-14	2024-07-20	MJDAI	Marc Jacobs Daisy: Edición especial con descuento
P128	2024-07-21	2024-07-27	LOEWE	Loewe Solo Atlas: 15% en la fragancia masculina
P129	2024-07-28	2024-08-03	ISSEY	Issey Miyake LEau dIssey: Promoción dúo hombre/mujer
P130	2024-08-04	2024-08-10	VALRO	Valentino Donna Born in Roma: Muestra de Uomo con compra
P131	2024-08-11	2024-08-17	BOTTE	Bottega Veneta Illusione: Descuento en pareja de fragancias
P132	2024-08-18	2024-08-24	ARTIS	LArtisan Parfumeur: Compra 2, ahorra 20%
P133	2024-08-25	2024-08-31	SLUTE	Serge Lutens La Fille de Berlin: Muestra Ambre Sultan
P134	2024-09-01	2024-09-07	LELAB	Le Labo Santal 33: Vela de la misma fragancia con descuento
P135	2024-09-08	2024-09-14	BYRED	Byredo Gypsy Water: Body wash de regalo
P136	2024-09-15	2024-09-21	MFKBK	Maison Francis Kurkdjian Baccarat Rouge: Muestra Oud Satin
P137	2024-09-22	2024-09-28	DIPTY	Diptyque Do Son: Crema de manos de la misma línea
P138	2024-09-29	2024-10-05	KILIA	Kilian Good Girl Gone Bad: Muestra Love Don't Be Shy
P139	2024-10-06	2024-10-12	GUERL	Guerlain Mon Guerlain: Descuento en el set completo
P140	2024-10-13	2024-10-19	ACQUA	Acqua di Parma Colonia: Kit de viaje de regalo
P141	2024-10-20	2024-10-26	ESAAB	Elie Saab Le Parfum: Velo corporal con descuento
P142	2024-10-27	2024-11-02	AZARO	Azzaro Wanted: Desodorante de la línea gratis
P143	2024-11-03	2024-11-09	NRICI	Nina Ricci Nina: 10% + miniatura de Luna
P144	2024-11-10	2024-11-16	CARTI	Cartier La Panthère: Muestra de Pasha con compra
P145	2024-11-17	2024-11-23	PENHA	Penhaligon's Portrait Collection: Descubre con 15% off
P146	2024-11-24	2024-11-30	CLINI	Clinique Happy: Set de fragancia y loción en promo
P147	2024-12-01	2024-12-07	SHISE	Shiseido Ginza: Descuento en la nueva fragancia Ginza
P148	2024-12-08	2024-12-14	ZADIG	Zadig & Voltaire This is Her!: Muestra This is Him!
P149	2024-12-15	2024-12-21	MOSCH	Moschino Toy Boy/Toy 2: Promoción especial en pareja
P150	2025-01-04	2025-01-10	LACOS	Lacoste L.12.12 Blanc: 15% en la fragancia y desodorante
P151	2025-01-11	2025-01-17	VIKRO	Viktor & Rolf Flowerbomb: Loción corporal de regalo
P152	2025-01-18	2025-01-24	ROCHA	Rochas Mademoiselle: Muestra de Eau de Rochas Homme
P153	2025-01-25	2025-01-31	BALEN	Balenciaga Florabotanica: Descuento en el tamaño de 100ml
P154	2025-02-01	2025-02-07	JIMCH	Jimmy Choo I Want Choo: Set de regalo con miniatura
P155	2025-02-08	2025-02-14	ESCAD	Escada Cherry in Japan: 10% en la edición limitada
P156	2025-02-15	2025-02-21	TIFFC	Tiffany & Co. Love: Promoción especial en dúo de fragancias
P157	2025-02-22	2025-02-28	COACH	Coach Dreams Sunset: Body Mist con la compra del EDP
P158	2025-03-01	2025-03-07	TOMMY	Tommy Hilfiger Impact: Kit de viaje de la fragancia
P159	2025-03-08	2025-03-14	DKNYB	DKNY Be Delicious: Descuento en el set de regalo
P160	2025-03-15	2025-03-21	ARDEN	Elizabeth Arden Red Door: Crema corporal con 50% off
P161	2025-03-22	2025-03-28	JILSAN	Jil Sander Sun: Aftersun de regalo en temporada
P162	2025-03-29	2025-04-04	LANVI	Lanvin Eclat dArpège: 15% y muestra de Modern Princess
P163	2025-04-05	2025-04-11	MOLTO	Molton Brown Re-charge Black Pepper: Vela aromática con compra
P164	2025-04-12	2025-04-18	YROCH	Yves Rocher Comme une Evidence: Set completo en oferta
P165	2025-04-19	2025-04-25	LOCCI	L'Occitane Verbena: Gel de ducha con descuento
P166	2025-04-26	2025-05-02	TBSWM	The Body Shop White Musk: 20% en toda la línea White Musk
P167	2025-05-03	2025-05-09	FRESH	Fresh Sugar Lemon: Exfoliante corporal de regalo
P168	2025-05-10	2025-05-16	KIEHL	Kiehl's Musk Essence Oil: Muestra de su crema más vendida
P169	2025-05-17	2025-05-23	AESOP	Aesop Marrakech Intense: Aceite corporal con descuento
P170	2025-05-24	2025-05-30	CLARI	Clarins Eau Dynamisante: Tratamiento corporal con la fragancia
P171	2025-05-31	2025-06-06	BIOTH	Biotherm Eau Vitaminée: Loción energizante de regalo
P172	2025-06-07	2025-06-13	ORIGI	Origins Ginger Essence: Crema de jengibre con 10% off
P173	2025-06-14	2025-06-20	CAUDA	Caudalie Thé des Vignes: Aceite nutritivo de regalo
P174	2025-06-21	2025-06-27	PHILO	Philosophy Amazing Grace: Set de baño en promoción
P175	2025-06-28	2025-07-04	NIVEA	Nivea Creme (Aroma Clásico): Edición especial coleccionable
P176	2025-07-05	2025-07-11	LOREP	L'Oréal Paris: Descuento en fragancias seleccionadas de la marca
P177	2025-07-12	2025-07-18	MAYBL	Maybelline (si aplica fragancia): Promo cruzada con maquillaje
P178	2025-07-19	2025-07-25	MACCO	MAC Cosmetics (si aplica fragancia): Shadescents con descuento
P179	2025-07-26	2025-08-01	NARSG	NARS Audacious Fragrance: Muestra de labial con compra
P180	2025-08-02	2025-08-08	BENEFI	Benefit Cosmetics (si aplica fragancia): Crescent Row en oferta
P181	2025-08-09	2025-08-15	URBAN	Urban Decay Go Naked Perfume Oil: Descuento especial
P182	2024-02-05	2024-02-09	GWP01	Regalo con Compra: Neceser exclusivo por compras > $180
P183	2024-03-06	2024-03-10	GWP02	Miniatura de Lujo (azar) por cualquier fragancia de 100ml
P184	2024-04-03	2024-04-07	GWP03	Set de 3 Muestras Nicho por compras superiores a $250
P185	2024-05-08	2024-05-12	GWP04	Fular de seda Diamond con la compra de 2 perfumes de diseñador
P186	2024-06-05	2024-06-09	GWP05	Vela Aromática Pequeña al comprar cualquier Eau de Parfum
P187	2024-07-03	2024-07-07	GWP06	Estuche de Viaje Diamond con la compra de 2 fragancias > 50ml
P188	2024-08-07	2024-08-11	GWP07	Loción Corporal Perfumada (a juego) con fragancias seleccionadas
P189	2024-09-04	2024-09-08	GWP08	Descuento de $20 en tu próxima compra por pedidos > $200
P190	2024-10-02	2024-10-06	GWP09	Muestra de Lanzamiento Exclusivo con cualquier compra online
P191	2024-11-06	2024-11-10	GWPA	Envoltura de Regalo Premium + Tarjeta personalizada GRATIS
P192	2024-01-10	2024-01-12	2X1A	2x1 en Body Mists seleccionados de Victoria's Secret
P193	2024-02-15	2024-02-17	3X2M	Lleva 3 Paga 2 en Miniaturas de Colección (hasta $30 c/u)
P194	2024-03-20	2024-03-22	BOGO	Compra Un Perfume de Diseñador, Lleva Otro de igual o menor valor al 50%
P195	2024-04-17	2024-04-19	SETD	Descuento del 25% en todos los Sets de Regalo pre-armados
P196	2024-05-22	2024-05-24	VOL10	10% de descuento adicional comprando 3 o más productos
P197	2024-06-19	2024-06-21	VOL15	15% de descuento adicional en compras superiores a $300
P198	2024-07-17	2024-07-19	SHIP0	Envío GRATIS en todos los pedidos sin mínimo de compra (48h)
P199	2024-08-21	2024-08-23	MEMB5	Miembros Diamond: 5% extra de descuento en todo
P200	2024-09-18	2024-09-20	LOYAL	Puntos Dobles de Lealtad en todas las compras
P201	2024-10-16	2024-10-18	VIPAC	Acceso VIP Anticipado a la Nueva Colección Otoño/Invierno
P202	2024-11-13	2024-11-15	REFER	Refiere un Amigo: Ambos reciben $15 de crédito Diamond
P203	2024-12-11	2024-12-13	BDAYG	Regalo Sorpresa de Cumpleaños para Miembros inscritos en Diciembre
P204	2025-01-08	2025-01-10	UPGRD	Upgrade Gratuito a Envío Express en pedidos > $75
P205	2025-02-12	2025-02-14	SECRT	Oferta Secreta para Suscriptores del Newsletter (San Valentín)
P206	2025-03-12	2025-03-14	EARLY	Early Bird Special: Descuento en la colección de Primavera
P207	2025-04-09	2025-04-11	SURVY	Completa nuestra Encuesta y Recibe un Cupón del 10%
P208	2025-05-14	2025-05-16	LNCH1	Lanzamiento Nueva Fragancia Floral: Precio especial de introducción
P209	2025-06-11	2025-06-13	LNCH2	Nueva Colección Verano: 10% off en los primeros 3 días
P210	2025-07-09	2025-07-11	LNCH3	Descubre el Perfume "Oceanis": Regalo con pre-orden
P211	2025-08-13	2025-08-15	LNCH4	Llegó la Línea "Aura": Envío gratis en esta nueva colección
P212	2025-09-10	2025-09-12	LNCH5	Anticipo Navideño: Perfume exclusivo "Noel" a precio de intro
P213	2025-10-08	2025-10-10	LNCH6	Novedad 2026: Set de descubrimiento "Essentials" con miniaturas
P214	2025-11-12	2025-11-14	LNCH7	Recién Llegado: 15% en el perfume destacado del mes "Mystere"
P215	2025-12-10	2025-12-12	LNCH8	Pre-Venta Exclusiva: Nueva fragancia unisex "Equilibrium"
P216	2024-01-23	2024-01-25	LIQ01	Liquidación Enero: Hasta 60% en fragancias seleccionadas
P217	2024-02-27	2024-02-29	LIQ02	Última Oportunidad Febrero: Precios bajos en últimas unidades
P218	2024-03-26	2024-03-28	LIQ03	Outlet de Perfumes Marzo: Descuentos increíbles
P219	2024-04-23	2024-04-25	LIQ04	Gran Liquidación de Primavera: Todo al 50% o más
P220	2024-05-28	2024-05-30	LIQ05	Fin de Temporada Mayo: Aprovecha los mejores precios
P221	2024-06-25	2024-06-27	LIQ06	Rebajas de Verano Anticipadas: Perfumes desde $40
P222	2024-07-23	2024-07-25	LIQ07	Liquidación por Inventario: Todo debe irse!
P223	2024-08-27	2024-08-29	LIQ08	Liquidación de Stock Limitado Agosto: Precios de remate
P224	2024-09-24	2024-09-26	LIQ09	Vaciando Estanterías Septiembre: Descuentos progresivos
P225	2024-10-22	2024-10-24	LIQ10	Ofertas Fin de Año Anticipadas: Prepara tus regalos
P226	2024-11-19	2024-11-21	LIQ11	Liquidación Pre-Navidad: Espacio para lo nuevo!
P227	2024-12-27	2024-12-29	LIQ12	Liquidación Post-Navidad: Descuentos finales del año
P228	2024-01-03	2024-01-05	MYSTB	Caja Misteriosa Diamond: Perfumes sorpresa a precio único
P229	2024-02-07	2024-02-09	BUNDL	Arma tu Bundle Perfumado: 3 miniaturas por $90
P230	2024-03-06	2024-03-08	TRYIT	Pruébame Gratis: Muestra deluxe de un lanzamiento con cualquier compra
P231	2024-04-03	2024-04-05	SOCIA	Comparte y Gana: Descuento por postear tu compra en redes
P232	2024-05-01	2024-05-03	QUIZP	Descubre tu Fragancia Ideal: Realiza el Quiz + 10% off en tu match
P233	2024-06-05	2024-06-07	WORKP	Taller de Perfumería Online: Cupón de descuento al inscribirte
P234	2024-07-03	2024-07-05	ECOWK	Semana Eco-Friendly: Descuento en marcas con refill o empaque reciclado
P235	2024-08-07	2024-08-09	ARTCO	Colaboración Artística: Edición limitada "Diamond x ArtistaLocal"
P236	2024-09-04	2024-09-06	HOUR24	Oferta de 24 Horas: Un perfume top con 50% off (cambia cada día)
P237	2024-10-02	2024-10-04	POINT	Triple Puntos de Lealtad en fragancias orientales y amaderadas
P238	2024-11-06	2024-11-08	EARLYX	Acceso Anticipado a Regalos de Navidad para Miembros Oro
P239	2024-12-04	2024-12-06	WRAPC	Servicio de Envoltura de Regalo con Caligrafía GRATIS
P240	2025-01-22	2025-01-24	FRESH	Año Nuevo, Frescura Nueva: 20% en todas las fragancias acuáticas
P241	2025-02-26	2025-02-28	COUPLE	Dúos Perfectos: Compra 2 fragancias (hombre/mujer) y ahorra 25%
P242	2025-03-26	2025-03-28	BLOOM	Despertar Floral: 15% en perfumes con notas de rosa, jazmín y lirio
P243	2025-04-23	2025-04-25	CITRUS	Explosión Cítrica: Compra 1 fragancia cítrica, la 2da al 50%
P244	2025-05-28	2025-05-30	GOURM	Dulce Tentación: 20% en todas las fragancias gourmand
P245	2025-06-25	2025-06-27	WOODY	Aventura Amaderada: Set de muestras amaderadas con compras > $100
P246	2025-07-23	2025-07-25	SPICY	Noches Especiadas: 10% + vela especiada con fragancias orientales
P247	2025-08-27	2025-08-29	LEATH	Elegancia en Cuero: Descuento en fragancias con notas de cuero
P248	2025-09-24	2025-09-26	MUSKY	Abrazo Almizclado: Compra 2 fragancias con musk, ahorra $30
P249	2025-10-22	2025-10-24	OUDLUX	Lujo Oriental: 15% en todas las fragancias con Oud
P250	2025-11-19	2025-11-21	INCENS	Misterio del Incienso: Regalo sorpresa con fragancias de incienso
P251	2025-12-17	2025-12-19	AMBERW	Calidez Ambarina: 20% en perfumes con base de ámbar
P252	2024-01-16	2024-01-18	UNISEX	Para Compartir: 15% en toda nuestra selección de fragancias unisex
P253	2024-02-20	2024-02-22	MASCU	Fuerza Masculina: Descuentos en los top 10 perfumes para hombre
P254	2024-03-19	2024-03-21	FEMME	Esencia Femenina: Regalo con compra en los top 10 para mujer
P255	2024-04-16	2024-04-18	NICHE	Explora lo Nicho: Kit de descubrimiento de marcas nicho con descuento
P256	2024-05-21	2024-05-23	DESIGN	Lujo de Diseñador: Compra fragancia de diseñador y recibe neceser
P257	2024-06-18	2024-06-20	INDIE	Apoya lo Indie: 10% en marcas de perfumistas independientes
P258	2024-07-16	2024-07-18	CLASS	Clásicos Atemporales: 20% en fragancias icónicas de la historia
P259	2024-08-20	2024-08-22	MODRN	Aromas Modernos: Descuento en lanzamientos de los últimos 2 años
P260	2024-09-17	2024-09-19	VINTG	Tesoro Vintage: Ediciones limitadas o descontinuadas con precio especial
P261	2024-10-15	2024-10-17	EDP20	Intensidad Eau de Parfum: 20% en todos los EDPs de más de 75ml
P262	2024-11-12	2024-11-14	EDT15	Frescura Eau de Toilette: 15% en todos los EDTs de más de 100ml
P263	2024-12-10	2024-12-12	EDC10	Ligereza Eau de Cologne: 10% en todas las EDCs y aguas frescas
P264	2025-01-14	2025-01-16	EXTRT	Lujo Extrême (Extracto): Muestra de lujo con compra de cualquier extracto
P265	2025-02-18	2025-02-20	SOLID	Perfumes Sólidos: Compra 2 y llévate un estuche especial
P266	2025-03-18	2025-03-20	ROLLN	Roll-ons & Travel Size: Arma tu kit de viaje y ahorra 20%
P267	2025-04-15	2025-04-17	HAIRM	Hair Mists Perfumados: 15% en toda la selección
P268	2025-05-20	2025-05-22	BODYL	Lociones Corporales Perfumadas: Compra la fragancia, lleva la loción al 50%
P269	2025-06-17	2025-06-19	BATHG	Geles de Ducha Perfumados: 3x2 en toda la línea de baño
P270	2025-07-15	2025-07-17	DEOSP	Desodorantes Perfumados: Set de fragancia + desodorante con descuento
P271	2025-08-19	2025-08-21	CANDL	Velas Aromáticas de Lujo: 20% en velas de más de 200g
P272	2025-09-16	2025-09-18	DIFFU	Difusores de Ambiente: Recarga gratis con la compra del difusor
P273	2025-10-14	2025-10-16	ROOMS	Room Sprays Exclusivos: 15% en la colección hogar Diamond
P274	2025-11-11	2025-11-13	FABRI	Sprays para Textiles: Set de 3 aromas para el hogar con descuento
P275	2025-12-09	2025-12-11	GIFTX	Cajas de Regalo Exclusivas Diamond: Personalízala y ahorra
P276	2024-01-29	2024-01-31	HAPPY	Hora Feliz Diamond: Descuento aleatorio entre 5-25% de 4-6pm
P277	2024-02-26	2024-02-28	NIGHT	Ofertas Nocturnas: Código especial para compras de 10pm a 6am
P278	2024-03-25	2024-03-27	STUDT	Descuento Estudiantil: 10% presentando carnet vigente (en tienda)
P279	2024-04-22	2024-04-24	SENIO	Días Dorados: 15% para mayores de 60 años (Martes y Miércoles)
P280	2024-05-27	2024-05-29	CORPO	Compras Corporativas: Descuentos por volumen para empresas
P281	2024-06-24	2024-06-26	BRIDE	Especial Novias: Asesoría y descuento para el perfume de tu boda
P282	2024-07-22	2024-07-24	NEWCU	Bienvenida Nuevos Clientes: 15% en tu primera compra online
P283	2024-08-26	2024-08-28	TOPUP	Recarga tu Lealtad: Bono de $10 por cada $100 de recarga en tarjeta regalo
P284	2024-09-23	2024-09-25	SOCM	Concurso en Redes Sociales: Participa y gana un set de lujo
P285	2024-10-21	2024-10-23	REVIE	Escribe una Reseña: Cupón de descuento para tu próxima compra
P286	2024-11-18	2024-11-20	PREOR	Pre-Ordena el Lanzamiento X: Regalo exclusivo y envío prioritario
P287	2024-12-16	2024-12-18	LASTM	Regalos de Último Minuto: Envío express GRATIS
P288	2025-01-20	2025-01-22	CLEAR	Gran Venta de Liquidación de Invierno: Hasta 70% OFF
P289	2025-02-17	2025-02-19	PERFCT	Encuentra tu Perfume Perfecto: Asesoría personalizada + muestra
P290	2025-03-17	2025-03-19	GREEN	Celebra lo Verde: Descuento en fragancias con notas herbales
P291	2025-04-14	2025-04-16	RENEW	Renovación Primaveral: Compra 2, lleva 3 en cítricos y florales
P292	2025-05-19	2025-05-21	TRAVEL	Listos para Viajar: 25% en todos los tamaños de viaje y miniaturas
P293	2025-06-16	2025-06-18	SUMFUN	Diversión de Verano: Regalo sorpresa con temática playera
P294	2025-07-14	2025-07-16	REFRESH	Refréscate: 2x1 en aguas de colonia y body sprays
P295	2025-08-18	2025-08-20	STYL	Regreso con Estilo: Descuento en fragancias juveniles y de moda
P296	2025-09-15	2025-09-17	COZY	Acogedor Otoño: 15% en velas y difusores amaderados
P297	2025-10-13	2025-10-15	DARK	Noches Oscuras: Descuento en perfumes intensos y misteriosos
P298	2025-11-10	2025-11-12	WARMTH	Calidez Invernal: Regalo de bufanda Diamond con compras > $150
P299	2025-12-08	2025-12-10	SPARK	Brillo Navideño: Set de miniaturas brillantes de regalo
P300	2024-01-08	2024-01-14	LUXWK	Semana del Lujo: Descuentos en marcas de alta perfumería seleccionadas
P301	2024-02-12	2024-02-18	LOVEB	Love Birds Special: Compra un perfume para él y uno para ella con 20% off total
P302	2024-03-11	2024-03-17	FRESHS	Frescura de Primavera: 15% en todas las fragancias acuáticas y verdes
P303	2024-04-08	2024-04-14	BRIGHT	Días Brillantes: Compra una fragancia solar y llévate un bálsamo labial SPF
P304	2024-05-13	2024-05-19	ELEGAN	Toque de Elegancia: Set de pañuelo de seda con perfumes clásicos femeninos
P305	2024-06-10	2024-06-16	POWERM	Poder Masculino: Descuento en fragancias amaderadas intensas para hombre
P306	2024-07-08	2024-07-14	TROPIC	Escape Tropical: Compra 2 fragancias frutales, la 3ra GRATIS
P307	2024-08-12	2024-08-18	RELAX	Momento Relax: 20% en velas y difusores con lavanda y manzanilla
P308	2024-09-09	2024-09-15	STUDY	Concentración Total: 10% en fragancias con romero y menta para estudiar
P309	2024-10-07	2024-10-13	MYSTIC	Noches Místicas: Descuento en perfumes con incienso, mirra y oud
P310	2024-11-04	2024-11-10	COZYUP	Acurrúcate: Regalo de manta Diamond con compras de fragancias cálidas > $200
P311	2024-12-02	2024-12-08	FESTIV	Espíritu Festivo: Compra un perfume navideño, llévate adornos Diamond
P312	2025-01-06	2025-01-12	DETOX	Détox de Año Nuevo: 15% en fragancias limpias y minimalistas
P313	2025-02-10	2025-02-16	ROMANC	Romance Eterno: Edición especial San Valentín con grabado gratuito
P314	2025-03-10	2025-03-16	ENERGI	Explosión de Energía: 20% en fragancias cítricas vibrantes
P315	2025-04-07	2025-04-13	AWAKEN	Despertar Primaveral: Set de miniaturas florales con descuento
P316	2025-05-12	2025-05-18	PAMPER	Consiéntete Mamá: Spa Kit Diamond con la compra de fragancias de lujo
P317	2025-06-09	2025-06-15	ADVENT	Espíritu Aventurero: 15% en fragancias exploradoras para papá
P318	2025-07-07	2025-07-13	BEACH	Días de Playa: Compra una fragancia de verano, llévate una bolsa de playa
P319	2025-08-11	2025-08-17	COOL	Mantente Fresco: 3x2 en todos los body sprays refrescantes
P320	2025-09-08	2025-09-14	FOCUSN	Enfoque Otoñal: Descuento en fragancias que inspiran concentración
P321	2025-10-06	2025-10-12	ENIGMA	Noches de Enigma: Regalo misterioso con fragancias orientales oscuras
P322	2025-11-03	2025-11-09	COMFOR	Confort de Hogar: 20% en la colección Diamond Home (velas, difusores)
P323	2025-12-01	2025-12-07	WONDER	País de las Maravillas Invernal: Calendario de Adviento Diamond con muestras
P324	2024-01-22	2024-01-24	CITFLA	Flash Sale Cítricos: 48h con 30% en todos los perfumes cítricos
P325	2024-02-19	2024-02-21	FLOFLA	Flash Sale Florales: 48h con 30% en todos los perfumes florales
P326	2024-03-18	2024-03-20	WOOFLA	Flash Sale Amaderados: 48h con 30% en perfumes amaderados
P327	2024-04-15	2024-04-17	ORIFLA	Flash Sale Orientales: 48h con 30% en perfumes orientales
P328	2024-05-20	2024-05-22	SPICFLA	Flash Sale Especiados: 48h con 30% en perfumes especiados
P329	2024-06-17	2024-06-19	AQUAFLA	Flash Sale Acuáticos: 48h con 30% en perfumes acuáticos
P330	2024-07-15	2024-07-17	FRUIFLA	Flash Sale Frutales: 48h con 30% en perfumes frutales
P331	2024-08-19	2024-08-21	GOURFLA	Flash Sale Gourmand: 48h con 30% en perfumes gourmand
P332	2024-09-16	2024-09-18	LEAFFLA	Flash Sale Otoñales (Hojas/Tierra): 48h con 30% off
P333	2024-10-14	2024-10-16	MYSTFLA	Flash Sale Misterio (Incienso/Cuero): 48h con 30% off
P334	2024-11-11	2024-11-13	WARMFLA	Flash Sale Cálidos (Ámbar/Vainilla): 48h con 30% off
P335	2024-12-09	2024-12-11	FESTFLA	Flash Sale Festivos (Pino/Canela): 48h con 30% off
P336	2025-01-13	2025-01-15	NEWFLA	Flash Sale Novedades: 48h con 25% en recién llegados
P337	2025-02-17	2025-02-19	LOVEFLA	Flash Sale San Valentín: 48h con ofertas románticas
P338	2025-03-17	2025-03-19	GRNFLA	Flash Sale Verde (Herbal/Fresco): 48h con 30% off
P339	2025-04-14	2025-04-16	SPRFLA	Flash Sale Primavera (Flores Blancas): 48h con 30% off
P340	2025-05-19	2025-05-21	SUNFLA	Flash Sale Solares (Coco/Tiaré): 48h con 30% off
P341	2025-06-16	2025-06-18	COOLFLA	Flash Sale Refrescantes (Menta/Agua): 48h con 30% off
P342	2025-07-14	2025-07-16	EXOTFLA	Flash Sale Exóticos (Frutas Tropicales): 48h con 30% off
P343	2025-08-18	2025-08-20	CLEAFLA	Flash Sale Limpios (Almizcle Blanco/Jabón): 48h con 30% off
P344	2025-09-15	2025-09-17	RICHFLA	Flash Sale Ricos (Oud/Pachulí): 48h con 30% off
P345	2025-10-13	2025-10-15	DARKFLA	Flash Sale Oscuros (Tabaco/Café): 48h con 30% off
P346	2025-11-10	2025-11-12	LUXEFLA	Flash Sale Lujo (Marcas Nicho Seleccionadas): 48h con 20% off
P347	2025-12-08	2025-12-10	XMASFLA	Flash Sale Navideño (Especias/Pino): 48h con 30% off
P348	2024-01-01	2024-01-31	MEMJAN	Mes del Miembro Enero: 10% extra en todas las compras para miembros
P349	2024-02-01	2024-02-29	MEMFEB	Mes del Miembro Febrero: Envío gratis para miembros sin mínimo
P350	2024-03-01	2024-03-31	MEMMAR	Mes del Miembro Marzo: Regalo sorpresa exclusivo para miembros
P351	2024-04-01	2024-04-30	MEMAPR	Mes del Miembro Abril: Doble puntos de lealtad para miembros
P352	2024-05-01	2024-05-31	MEMMAY	Mes del Miembro Mayo: Acceso anticipado a ofertas de Día de la Madre
P353	2024-06-01	2024-06-30	MEMJUN	Mes del Miembro Junio: Muestra deluxe con cada compra de miembro
P354	2024-07-01	2024-07-31	MEMJUL	Mes del Miembro Julio: 15% en fragancias de verano para miembros
P355	2024-08-01	2024-08-31	MEMAUG	Mes del Miembro Agosto: Descuento especial en sets Regreso a Clases
P356	2024-09-01	2024-09-30	MEMSEP	Mes del Miembro Sept: Participa en sorteo exclusivo para miembros
P357	2024-10-01	2024-10-31	MEMOCT	Mes del Miembro Oct: 20% en velas y difusores para miembros
P358	2024-11-01	2024-11-30	MEMNOV	Mes del Miembro Nov: Acceso VIP a ofertas Black Friday
P359	2024-12-01	2024-12-31	MEMDEC	Mes del Miembro Dic: Envoltura de regalo premium gratis para miembros
P360	2025-01-01	2025-01-31	MMJA5	Miembro Enero 2025: Descuento sorpresa del 5-20% al pagar
P361	2025-02-01	2025-02-28	MMFE5	Miembro Febrero 2025: Regalo especial de San Valentín para miembros
P362	2025-03-01	2025-03-31	MMMA5	Miembro Marzo 2025: Muestra de nueva colección para miembros
P363	2025-04-01	2025-04-30	MMAP5	Miembro Abril 2025: Triple puntos en fragancias florales
P364	2025-05-01	2025-05-31	MMMY5	Miembro Mayo 2025: Descuento adicional en regalos Día de la Madre
P365	2025-06-01	2025-06-30	MMJU5	Miembro Junio 2025: Envío express gratuito en todos los pedidos
P366	2025-07-01	2025-07-31	MMJL5	Miembro Julio 2025: 20% en tamaños de viaje para miembros
P367	2025-08-01	2025-08-31	MMAU5	Miembro Agosto 2025: Regalo con compra en fragancias juveniles
P368	2025-09-01	2025-09-30	MMSE5	Miembro Sept 2025: Cupón de $10 para el mes de tu cumpleaños (si es Sept)
P369	2025-10-01	2025-10-31	MMOC5	Miembro Oct 2025: Descuento exclusivo en fragancias de Oud y Ámbar
P370	2025-11-01	2025-11-30	MMNO5	Miembro Nov 2025: Sorteo de cesta de Navidad entre miembros
P371	2025-12-01	2025-12-31	MMDE5	Miembro Dic 2025: Regalo de lujo (miniatura especial) con compra > $200
P372	2024-01-15	2024-01-31	EDPJAN	Especial EDP Enero: Compra un EDP 100ml, llévate un Rollerball
P373	2024-02-15	2024-02-29	EDTFEB	Especial EDT Febrero: 2x1 en EDTs de verano seleccionados
P374	2024-03-15	2024-03-31	EDCMAR	Especial EDC Marzo: Kit de 3 EDCs mini con 20% off
P375	2024-04-15	2024-04-30	PARAPR	Especial Parfum Abril: Muestra de 5ml de otro Parfum con tu compra
P376	2024-05-15	2024-05-31	SOLMAY	Especial Sólido Mayo: Estuche metálico gratis con perfume sólido
P377	2024-06-15	2024-06-30	ROLJUN	Especial Rollerball Junio: Compra 3 Rollerballs, paga 2
P378	2024-07-15	2024-07-31	MISTJUL	Especial Hair Mist Julio: 15% en todos los Hair Mists
P379	2024-08-15	2024-08-31	LOT AUG	Especial Loción Agosto: Fragancia + Loción a juego con 20% off
P380	2024-09-15	2024-09-30	GELSEP	Especial Gel Ducha Sept: Gel de ducha XL al precio del normal
P381	2024-10-15	2024-10-31	DEOOCT	Especial Desodorante Oct: Compra 2 desodorantes, el 3ro GRATIS
P382	2024-11-15	2024-11-30	CANNV	Especial Velas Nov: Set de 3 velas aromáticas navideñas
P383	2024-12-15	2024-12-31	DIFDEC	Especial Difusor Dic: Difusor + Recarga Pino con descuento
P384	2025-01-15	2025-01-31	ROOMJAN	Especial Room Spray Ene: 2x$XX en Room Sprays de invierno
P385	2025-02-15	2025-02-28	TEXTFEB	Especial Textil Feb: Spray para linos con aroma a San Valentín
P386	2025-03-15	2025-03-31	BOXMAR	Especial Caja Regalo Mar: Arma tu caja personalizada y obtén 10% off
P387	2024-01-07	2024-01-07	SUNFL	Sunday Flash: Oferta sorpresa válida solo Domingos de Enero
P388	2024-02-04	2024-02-04	MONFL	Monday Mood Boost: Descuento especial solo los Lunes de Febrero
P389	2024-03-05	2024-03-05	TUEFL	Tuesday Treat: Regalo con compra solo los Martes de Marzo
P390	2024-04-03	2024-04-03	WEDFL	Wednesday Wins: Envío gratis solo los Miércoles de Abril
P391	2024-05-02	2024-05-02	THUFL	Thirsty Thursday: 20% en fragancias acuáticas solo Jueves de Mayo
P392	2024-06-07	2024-06-07	FRIFL	TGIF Flash: Descuento para el fin de semana solo Viernes de Junio
P393	2024-07-06	2024-07-06	SATFL	Saturday Special: Doble puntos solo los Sábados de Julio
P394	2024-08-03	2024-08-03	WKND1	Weekend Warrior Promo: Descuento del 5-10% todo el fin de semana
P395	2024-09-07	2024-09-07	WKND2	Weekend Getaway Kit: Set de viaje con compras de fin de semana
P396	2024-10-05	2024-10-05	WKND3	Weekend Relaxation: 15% en velas y difusores (Sáb-Dom)
P397	2024-11-02	2024-11-02	WKND4	Weekend Glam: Muestra de labial de lujo con compras (Sáb-Dom)
P398	2024-12-07	2024-12-07	WKND5	Weekend Sparkle: Envoltura de regalo con glitter gratis (Sáb-Dom)
P399	2025-01-04	2025-01-04	WKND6	Weekend Fresh Start: 20% en fragancias cítricas (Sáb-Dom)
P400	2025-02-01	2025-02-01	WKND7	Weekend Love: Muestra de perfume romántico (Sáb-Dom)
P401	2025-03-01	2025-03-01	WKND8	Weekend Bloom: 10% en florales (Sáb-Dom)
P402	2025-04-05	2025-04-05	WKND9	Weekend Adventure: Descuento en fragancias unisex (Sáb-Dom)
P403	2025-05-03	2025-05-03	WKNDA	Weekend Pamper: Regalo con compra de sets de baño (Sáb-Dom)
P404	2025-06-07	2025-06-07	WKNDB	Weekend Escape: 15% en fragancias tropicales (Sáb-Dom)
P405	2025-07-05	2025-07-05	WKNDC	Weekend Cool Down: 2x1 en body mists (Sáb-Dom)
P406	2025-08-02	2025-08-02	WKNDD	Weekend Vibes: Envío gratis en pedidos de fin de semana
P407	2025-09-06	2025-09-06	WKNDE	Weekend Cozy: Descuento en velas especiadas (Sáb-Dom)
P408	2025-10-04	2025-10-04	WKNDF	Weekend Mystery: Código de descuento sorpresa (Sáb-Dom)
P409	2025-11-01	2025-11-01	WKNDG	Weekend Warmth: Regalo con compra de fragancias ambarinas (Sáb-Dom)
P410	2025-12-06	2025-12-06	WKNDH	Weekend Cheer: Muestra de perfume festivo (Sáb-Dom)
P411	2024-01-12	2024-01-12	PAYF1	PayDay Friday: 10% extra al final del día (Enero)
P412	2024-02-09	2024-02-09	PAYF2	PayDay Friday: Envío gratis + muestra (Febrero)
P413	2024-03-08	2024-03-08	PAYF3	PayDay Friday: Doble puntos de lealtad (Marzo)
P414	2024-04-12	2024-04-12	PAYF4	PayDay Friday: 15% en tu próxima compra (Abril)
P415	2024-05-10	2024-05-10	PAYF5	PayDay Friday: Regalo sorpresa con compras > $100 (Mayo)
P416	2024-06-14	2024-06-14	PAYF6	PayDay Friday: 20% en fragancias de verano (Junio)
P417	2024-07-12	2024-07-12	PAYF7	PayDay Friday: Compra 2, lleva el 3ro al 50% (Julio)
P418	2024-08-09	2024-08-09	PAYF8	PayDay Friday: Descuento especial en sets (Agosto)
P419	2024-09-13	2024-09-13	PAYF9	PayDay Friday: Acceso a oferta secreta (Septiembre)
P420	2024-10-11	2024-10-11	PAYFA	PayDay Friday: 10% en velas y difusores (Octubre)
P421	2024-11-08	2024-11-08	PAYFB	PayDay Friday: Muestra de lanzamiento navideño (Noviembre)
P422	2024-12-13	2024-12-13	PAYFC	PayDay Friday: Envoltura de regalo deluxe gratis (Diciembre)
P423	2025-01-10	2025-01-10	PAYFD	PayDay Friday: 20% en fragancias "fresh start" (Enero 2025)
P424	2025-02-14	2025-02-14	PAYFE	PayDay Friday (San Valentín): Regalo especial extra (Febrero 2025)
P425	2024-01-02	2024-01-04	TUE20	Martes 20% OFF: Descuento del 20% en categoría seleccionada (1ra sem Ene)
P426	2024-01-09	2024-01-11	WED15	Miércoles 15% OFF: Descuento del 15% en marca del día (2da sem Ene)
P427	2024-01-16	2024-01-18	THU10	Jueves 10% OFF: Descuento del 10% en tamaños grandes (3ra sem Ene)
P428	2024-01-23	2024-01-25	FRI05	Viernes 5% EXTRA: Descuento adicional del 5% en todo (4ta sem Ene)
P429	2024-01-30	2024-01-31	MONT25	Fin de Mes: 25% en los más vendidos del mes (Enero)
P430	2024-02-06	2024-02-08	TUEGFT	Martes de Regalo: Regalo con compras > $150 (1ra sem Feb)
P431	2024-02-13	2024-02-15	WEDSHIP	Miércoles de Envío Gratis: Sin mínimo (2da sem Feb)
P432	2024-02-20	2024-02-22	THUDISC	Jueves de Doble Descuento: Descuento base + % extra (3ra sem Feb)
P433	2024-02-27	2024-02-29	FRIMYS	Viernes Misterioso: Descuento sorpresa al pagar (4ta sem Feb)
P434	2024-03-05	2024-03-07	TUESPCL	Martes Especial: Oferta única en producto estrella (1ra sem Mar)
P435	2024-03-12	2024-03-14	WEDPNTS	Miércoles de Puntos: Doble o triple puntos (2da sem Mar)
P436	2024-03-19	2024-03-21	THUSAVE	Jueves Ahorrador: Compra más, ahorra más (descuento por niveles) (3ra sem Mar)
P437	2024-03-26	2024-03-28	FRIFREE	Viernes de Regalo: Muestra deluxe gratis con cualquier compra (4ta sem Mar)
P438	2024-04-02	2024-04-04	TUEDUO	Martes de Dúo: Descuento especial en sets de 2 productos (1ra sem Abr)
P439	2024-04-09	2024-04-11	WEDNEW	Miércoles de Novedades: Descuento en los últimos lanzamientos (2da sem Abr)
P440	2024-04-16	2024-04-18	THUTRIO	Jueves de Trío: Compra 3 y paga el de menor valor al 50% (3ra sem Abr)
P441	2024-04-23	2024-04-25	FRIJOY	Viernes de Alegría: Pequeño obsequio con cada pedido (4ta sem Abr)
P442	2024-05-07	2024-05-09	TUEMOM	Martes para Mamá: Descuento extra en regalos para ella (1ra sem May)
P443	2024-05-14	2024-05-16	WEDLUX	Miércoles de Lujo: Muestra de marca nicho con compras > $200 (2da sem May)
P444	2024-05-21	2024-05-23	THUSET	Jueves de Sets: 20% en todos los sets de regalo (3ra sem May)
P445	2024-05-28	2024-05-30	FRIFLWR	Viernes Floral: Descuento en fragancias florales (4ta sem May)
P446	2024-06-04	2024-06-06	TUEDAD	Martes para Papá: 15% en fragancias masculinas (1ra sem Jun)
P447	2024-06-11	2024-06-13	WEDMEN	Miércoles Masculino: Regalo con compra en línea para hombre (2da sem Jun)
P448	2024-06-18	2024-06-20	THUSUM	Jueves de Verano: Descuento en fragancias frescas (3ra sem Jun)
P449	2024-06-25	2024-06-27	FRIFUN	Viernes Divertido: Código promocional para sorteo (4ta sem Jun)
P450	2024-07-02	2024-07-04	TUEJUL	Martes de Julio: 20% en fragancias acuáticas (1ra sem Jul)
P451	2024-07-09	2024-07-11	WEDBEA	Miércoles de Playa: Regalo playero con compras > $100 (2da sem Jul)
P452	2024-07-16	2024-07-18	THUTRV	Jueves de Viaje: Descuento en travel sizes (3ra sem Jul)
P453	2024-07-23	2024-07-25	FRISUN	Viernes Soleado: 15% en fragancias con coco y tiaré (4ta sem Jul)
P454	2024-08-06	2024-08-08	TUEAUG	Martes de Agosto: Últimas rebajas de verano (1ra sem Ago)
P455	2024-08-13	2024-08-15	WEDBTS	Miércoles Regreso a Clases: Kit escolar con compra (2da sem Ago)
P456	2024-08-20	2024-08-22	THUEND	Jueves Fin de Verano: Liquidación de stock veraniego (3ra sem Ago)
P457	2024-08-27	2024-08-29	FRIAUT	Viernes Pre-Otoño: Descuento en novedades de otoño (4ta sem Ago)
P458	2024-09-03	2024-09-05	TUESEP	Martes de Septiembre: 10% en fragancias amaderadas (1ra sem Sep)
P459	2024-09-10	2024-09-12	WEDCOZ	Miércoles Acogedor: Regalo de vela con compra (2da sem Sep)
P460	2024-09-17	2024-09-19	THUHAR	Jueves de Cosecha: Descuento en fragancias frutales de otoño (3ra sem Sep)
P461	2024-09-24	2024-09-26	FRIAMB	Viernes Ambarino: 20% en perfumes con ámbar (4ta sem Sep)
P462	2024-10-01	2024-10-03	TUEOCT	Martes de Octubre: 15% en fragancias especiadas (1ra sem Oct)
P463	2024-10-08	2024-10-10	WEDMYS	Miércoles Misterioso: Descuento aleatorio en el carrito (2da sem Oct)
P464	2024-10-15	2024-10-17	THUDARK	Jueves Oscuro: 20% en perfumes intensos y nocturnos (3ra sem Oct)
P465	2024-10-22	2024-10-24	FRIHAL	Viernes Pre-Halloween: Regalo temático con compra (4ta sem Oct)
P466	2024-11-05	2024-11-07	TUENOV	Martes de Noviembre: Envío gratis en todos los pedidos (1ra sem Nov)
P467	2024-11-12	2024-11-14	WEDGFT	Miércoles de Regalos: Descuento en sets de regalo (2da sem Nov)
P468	2024-11-19	2024-11-21	THUBLA	Jueves Pre-Black Friday: Ofertas anticipadas (3ra sem Nov)
P469	2024-11-26	2024-11-28	FRITHX	Viernes de Acción de Gracias: Descuento especial (4ta sem Nov)
P470	2024-12-03	2024-12-05	TUEDEC	Martes de Diciembre: 20% en fragancias festivas (1ra sem Dic)
P471	2024-12-10	2024-12-12	WEDXMS	Miércoles Navideño: Regalo con temática navideña (2da sem Dic)
P472	2024-12-17	2024-12-19	THULAST	Jueves Última Hora: Descuento en envío express para regalos (3ra sem Dic)
P473	2024-12-24	2024-12-24	FRIXMAS	Viernes Nochebuena: Oferta especial de última hora (Navidad)
P474	2024-12-31	2024-12-31	NYEVE	Fin de Año: Descuento para celebrar el nuevo año
P475	2025-01-02	2025-01-05	NEWYR5	Promo de Año Nuevo 2025: Descuentos en todo el sitio
P476	2025-02-03	2025-02-07	LOVE25	Semana del Amor 2025: Regalos y ofertas para San Valentín
P477	2025-03-03	2025-03-07	WOMN25	Día de la Mujer 2025: Honrando con fragancias especiales
P478	2025-04-14	2025-04-18	EAST25	Pascua 2025: Dulces ofertas y aromas primaverales
P479	2025-05-05	2025-05-09	MOM25	Día de la Madre 2025: Los mejores regalos para ella
P480	2025-06-09	2025-06-13	DAD25	Día del Padre 2025: Fragancias perfectas para papá
P481	2025-07-01	2025-07-04	JULY25	4 de Julio 2025: Celebración con descuentos patrios
P482	2025-08-04	2025-08-08	BTS25	Regreso a Clases 2025: Aromas frescos para un nuevo inicio
P483	2025-09-15	2025-09-19	AYA25	Amor y Amistad 2025: Celebra los lazos con regalos
P484	2025-10-27	2025-10-31	HALL25	Halloween 2025: Descuentos espeluznantes y divertidos
P485	2025-11-24	2025-11-28	BLK25	Black Friday 2025: ¡Las ofertas más grandes del año!
P486	2025-12-01	2025-12-01	CYB25	Cyber Monday 2025: Continúan las ofertas online
P487	2025-12-15	2025-12-24	XMAS25	Navidad 2025: Encuentra el regalo perfecto
P488	2024-01-06	2024-01-06	3KING	Día de Reyes: Última oportunidad para regalos festivos
P489	2024-02-02	2024-02-02	GRNDH	Día de la Marmota: ¿Más invierno o primavera? Descuento según predicción!
P490	2024-03-14	2024-03-14	PIDAY	Día de Pi (3.14): Descuento del 3.14% o regalo matemático
P491	2024-04-20	2024-04-20	420SP	Especial 4/20: Fragancias herbales y relajantes con promo
P492	2024-05-25	2024-05-25	TOWEL	Día de la Toalla (Homenaje Douglas Adams): Promo con humor
P493	2024-06-06	2024-06-06	DRVDY	D-Day Conmemoración: Descuento en fragancias clásicas
P494	2024-07-11	2024-07-11	711FR	7-Eleven Day: Oferta especial de $7.11 en producto seleccionado
P495	2024-08-08	2024-08-08	88DAY	Día del 8/8 (Prosperidad): Oferta especial de la suerte
P496	2024-09-19	2024-09-19	PIRAT	Día de Hablar como un Pirata: ¡Descuentos, Arrr!
P497	2024-10-04	2024-10-04	VODKA	Día Nacional del Vodka (USA): Fragancias con notas "boozy"
P498	2024-11-05	2024-11-05	GUYFA	Guy Fawkes Night: Promo "explosiva" (descuento grande)
P499	2024-12-21	2024-12-21	SOLSW	Solsticio de Invierno: Aromas cálidos para la noche más larga
P500	2024-01-01	2024-01-07	NEW01	Nueva Década de Aromas: 10% en todo para empezar bien
P501	2024-01-08	2024-01-14	FRESH1	Frescura Invernal: 15% en cítricos y acuáticos seleccionados
P502	2024-01-15	2024-01-21	COZY01	Calidez de Enero: 20% en fragancias amaderadas y de vainilla
P503	2024-01-22	2024-01-28	LUXE01	Lujo Accesible: Muestra de perfume nicho con compras > $150
P504	2024-01-29	2024-02-04	PRELV	Pre-San Valentín: Ideas de regalo y descuentos anticipados
P505	2024-02-05	2024-02-11	FORHER	Para Ella: Sets de regalo femeninos con 20% off
P506	2024-02-12	2024-02-18	FORHIM	Para Él: Fragancias masculinas top con 15% off
P507	2024-02-19	2024-02-25	UNISX1	Amor Universal: Descuento en fragancias unisex para compartir
P508	2024-02-26	2024-03-03	SPRNGP	Adelanto de Primavera: 10% en nuevos florales y verdes
P509	2024-03-04	2024-03-10	FLORAL	Festival Floral: Compra 2 perfumes florales, el 3ro al 50%
P510	2024-03-11	2024-03-17	GREEN1	Explosión Verde: 15% en fragancias herbales y fougère
P511	2024-03-18	2024-03-24	CLEAN1	Aromas Limpios: 20% en fragancias con notas de algodón y jabón
P512	2024-03-25	2024-03-31	BRNCHN	Brunch de Pascua: Regalo dulce con compras de fin de semana
P513	2024-04-01	2024-04-07	APRILF	Fiebre de Abril: Descuentos diarios sorpresa en la web
P514	2024-04-08	2024-04-14	RENEW1	Renueva tu Aroma: Compra tu favorito, prueba uno nuevo con descuento
P515	2024-04-15	2024-04-21	EARTH1	Conexión Tierra: 10% en fragancias con vetiver y pachulí
P516	2024-04-22	2024-04-28	ECOFRN	Eco-Amigos: Envío gratis en marcas sostenibles
P517	2024-04-29	2024-05-05	MAYDAY	Flores de Mayo: Regalo de miniatura floral con cada compra
P518	2024-05-06	2024-05-12	MOTHR1	Mamá Merece lo Mejor: Sets de lujo y envoltura especial
P519	2024-05-13	2024-05-19	SUNNY1	Días Soleados: 15% en fragancias con coco, tiaré y cítricos
P520	2024-05-20	2024-05-26	MEMWK1	Fin de Semana Memorial: Descuentos para el verano
P521	2024-05-27	2024-06-02	JUNEGL	Glamour de Junio: Muestra de labial o iluminador con fragancias de noche
P522	2024-06-03	2024-06-09	FATHR1	Papá Campeón: Descuentos en fragancias deportivas y frescas
P523	2024-06-10	2024-06-16	GRADU1	Éxito Graduados: Regalo especial con la compra de fragancias de celebración
P524	2024-06-17	2024-06-23	SUMRSL	Solsticio de Verano: 20% en los más vendidos para el calor
P525	2024-06-24	2024-06-30	BEACH1	Listos para la Playa: Set de miniaturas de verano con 25% off
P526	2024-07-01	2024-07-07	JULY4TH	Celebración de Julio: Descuentos y regalos con los colores patrios
P527	2024-07-08	2024-07-14	AQUAT1	Semana Acuática: 15% en todas las fragancias marinas y ozónicas
P528	2024-07-15	2024-07-21	HOTDL	Ofertas Calientes de Verano: Descuentos progresivos hasta 40%
P529	2024-07-22	2024-07-28	COOLIT	Refréscate: Compra 2 body sprays, el 3ro con 75% off
P530	2024-07-29	2024-08-04	TRVL01	Esenciales de Viaje: Neceser de regalo con 2 travel sizes
P531	2024-08-05	2024-08-11	BK2SKL	Aromas para el Estudio: 10% en fragancias que ayudan a concentrar
P532	2024-08-12	2024-08-18	LATESM	Últimos Días de Verano: Liquidación de temporada con hasta 50%
P533	2024-08-19	2024-08-25	DOGDAY	Feliz Día del Perro: Muestra temática con tu pedido
P534	2024-08-26	2024-09-01	LABORD	Fin de Semana Labor Day: Descuentos para despedir el verano
P535	2024-09-02	2024-09-08	FALLP	Prepara tu Otoño: 15% en fragancias amaderadas y especiadas
P536	2024-09-09	2024-09-15	AMIST1	Regalos de Amistad: Compra uno para ti, otro para tu amigo con descuento
P537	2024-09-16	2024-09-22	HARVST	Cosecha de Otoño: 20% en fragancias con notas de calabaza y manzana
P538	2024-09-23	2024-09-29	AUTEQN	Equinoccio Otoñal: Nuevos lanzamientos cálidos con regalo
P539	2024-09-30	2024-10-06	NICHEX	Explora lo Exclusivo: Semana de Perfumería Nicho con muestras gratis
P540	2024-10-07	2024-10-13	WORLD1	Aromas del Mundo: Descuentos en fragancias inspiradas en países
P541	2024-10-14	2024-10-20	PUMPKN	Todo Calabaza: 15% en fragancias y velas con notas de calabaza
P542	2024-10-21	2024-10-27	SPOOKY	Semana Espeluznante: Descuento del 13% en fragancias oscuras
P543	2024-10-28	2024-11-03	HALLWN	Truco o Trato: Regalo sorpresa de Halloween con cada pedido
P544	2024-11-04	2024-11-10	SNGLES	Día del Soltero: Auto-regálate con 20% de descuento
P545	2024-11-11	2024-11-17	VETER1	Honor a Veteranos: Descuento especial y donación
P546	2024-11-18	2024-11-24	PREBF1	Calentando Motores para Black Friday: Ofertas diarias
P547	2024-11-25	2024-12-01	CYBWK	Cyber Week Completa: Black Friday + Cyber Monday Deals
P548	2024-12-02	2024-12-08	GIFTG1	Guía de Regalos Parte 1: Descuentos en perfumes más vendidos
P549	2024-12-09	2024-12-15	GIFTG2	Guía de Regalos Parte 2: Ofertas en sets de lujo y ediciones limitadas
P550	2024-12-16	2024-12-22	SPRKL1	Brilla esta Navidad: Regalo de accesorio brillante con tu compra
P551	2024-12-23	2024-12-25	XMSEVE	Víspera y Día de Navidad: Oferta especial de último momento
P552	2024-12-26	2024-12-28	BOXD1	Boxing Day Deals: Grandes descuentos para despedir el año
P553	2024-12-29	2024-12-31	NYPREP	Prepárate para Año Nuevo: Descuentos en fragancias de fiesta
P554	2025-01-01	2025-01-05	HELLO25	Hola 2025: 20% en todo el sitio para empezar el año
P555	2025-01-06	2025-01-12	WINTERC	Confort Invernal: 15% en fragancias cálidas y envolventes
P556	2025-01-13	2025-01-19	BLUEMO	Combate el Blue Monday: Regalo sorpresa con compras > $50
P557	2025-01-20	2025-01-26	FRESHST	Nuevo Comienzo: Descuentos en fragancias limpias y energizantes
P558	2025-01-27	2025-02-02	LOVEIS	El Amor está en el Aire: Adelanto de ofertas de San Valentín
P559	2025-02-03	2025-02-09	VALENG	Regalos de San Valentín: Sets para él y para ella con descuento
P560	2025-02-10	2025-02-16	GALENT	Galentine's Day: Celebra la amistad con 2x1 en miniaturas
P561	2025-02-17	2025-02-23	SPRPREV	Preview de Primavera: 10% en los nuevos lanzamientos florales
P562	2025-02-24	2025-03-02	WOMENS	Mes de la Mujer: Destacados femeninos con regalo especial
P563	2025-03-03	2025-03-09	INTWOD	Día Internacional de la Mujer: 20% en marcas fundadas por mujeres
P564	2025-03-10	2025-03-16	LUCKYG	Suerte Irlandesa: Descuento en fragancias verdes y envío gratis
P565	2025-03-17	2025-03-23	SPRINGB	Florecer Primaveral: Compra una fragancia, llévate una muestra floral deluxe
P566	2025-03-24	2025-03-30	EASTERB	Canasta de Pascua: Descuentos y sorpresas en cada pedido
P567	2025-03-31	2025-04-06	APRILS	Sorpresas de Abril: Oferta diferente cada día de la semana
P568	2025-04-07	2025-04-13	REBIRTH	Renacimiento Primaveral: 15% en fragancias frescas y revitalizantes
P569	2025-04-14	2025-04-20	PLANET	Amamos el Planeta: Doble puntos en marcas eco-conscientes
P570	2025-04-21	2025-04-27	SUNSHN	Sol de Primavera: 20% en fragancias solares y cítricas
P571	2025-04-28	2025-05-04	MAYFLW	Flores de Mayo: Regalo de un ramillete (simbólico) con tu compra
P572	2025-05-05	2025-05-11	FORMA	Para Mamá con Amor: Sets de lujo y envoltura premium gratis
P573	2025-05-12	2025-05-18	GETAWY	Escapada de Fin de Semana: Descuento en travel sizes y neceseres
P574	2025-05-19	2025-05-25	SUMMERP	Previa de Verano: 10% en los más vendidos para el calor
P575	2025-05-26	2025-06-01	MEMDAY5	Fin de Semana Memorial: Inicio oficial de ofertas de verano
P576	2025-06-02	2025-06-08	FATHERD	El Mejor Papá: Regalos exclusivos y descuentos para él
P577	2025-06-09	2025-06-15	SPORTF	Espíritu Deportivo: 15% en fragancias frescas y energéticas
P578	2025-06-16	2025-06-22	SUMSOL5	Solsticio de Verano: Celebra con 20% en aromas vibrantes
P579	2025-06-23	2025-06-29	BEACHRD	Listos para la Arena: Compra 2, llévate un bolso de playa Diamond
P580	2025-06-30	2025-07-06	INDEP5	Semana de la Independencia: Descuentos patrios y regalos
P581	2025-07-07	2025-07-13	OCEANLV	Amor por el Océano: 10% en acuáticas y donación a ONG marina
P582	2025-07-14	2025-07-20	HOTDEAL	Ofertas Ardientes de Julio: Hasta 40% en seleccionados
P583	2025-07-21	2025-07-27	COOLOF	Refréscate y Ahorra: 3x2 en aguas de colonia y body mists
P584	2025-07-28	2025-08-03	TRVLBUG	El Bicho Viajero: Kit de miniaturas con 25% off
P585	2025-08-04	2025-08-10	BK2SCH	Aromas para Estudiar: 15% en fragancias que fomentan la concentración
P586	2025-08-11	2025-08-17	LASTSUM	Despedida del Verano: Liquidación de temporada con grandes descuentos
P587	2025-08-18	2025-08-24	PETLOVE	Amor por las Mascotas: Muestra temática con tu pedido y donación
P588	2025-08-25	2025-08-31	LABORW	Fin de Semana Labor Day: Ofertas para un merecido descanso
P589	2025-09-01	2025-09-07	FALLPRE	Anticipo de Otoño: 10% en fragancias amaderadas y cálidas
P590	2025-09-08	2025-09-14	FRNDS1	Regalos para Amigos: Compra uno para ti, otro para tu amigo con 20% off
P591	2025-09-15	2025-09-21	HARVFST	Festival de la Cosecha: 15% en fragancias con notas frutales de otoño
P592	2025-09-22	2025-09-28	AUTEQ5	Equinoccio Otoñal: Nuevos lanzamientos especiados con regalo
P593	2025-09-29	2025-10-05	NICHWK5	Semana de Perfumería Nicho: Descubre tesoros con 15% off
P594	2025-10-06	2025-10-12	AROUNDW	Aromas del Mundo: Descuentos en fragancias inspiradas en viajes exóticos
P595	2025-10-13	2025-10-19	SPICEUP	Dale Sabor a tu Vida: 20% en fragancias con canela, clavo y cardamomo
P596	2025-10-20	2025-10-26	SPOOKW	Semana de Escalofrios: Descuento del 13% en fragancias misteriosas
P597	2025-10-27	2025-11-02	HALLOW5	Truco o Descuento: Regalo sorpresa de Halloween con cada pedido online
P598	2025-11-03	2025-11-09	SINGLE5	Día del Soltero con Estilo: Auto-regálate con 25% de descuento
P599	2025-11-10	2025-11-16	VETDAY5	En Honor a Nuestros Héroes: Descuento especial y donación a veteranos
P600	2025-11-17	2025-11-23	PREBF5	Acceso VIP a Black Friday: Ofertas exclusivas para miembros Diamond
P601	2025-11-24	2025-11-30	CYBERW5	Cyber Week Extendida: Las mejores ofertas de Black Friday y Cyber Monday
P602	2025-12-01	2025-12-07	GIFTID1	Ideas de Regalo Parte 1: Descuentos en los perfumes más populares del año
P603	2025-12-08	2025-12-14	GIFTID2	Ideas de Regalo Parte 2: Ofertas en sets de lujo y ediciones coleccionables
P604	2025-12-15	2025-12-21	SPARKLE	Añade Brillo a tu Navidad: Regalo de accesorio con glitter con tu compra
P605	2025-12-22	2025-12-25	XMASEV5	Nochebuena y Navidad: Oferta especial de último segundo para regalos
P606	2025-12-26	2025-12-28	BOXDAY5	Boxing Day Bonanza: Descuentos masivos para cerrar el año
P607	2025-12-29	2025-12-31	NYPREP5	Listos para Año Nuevo: Descuentos en fragancias festivas y de celebración
P608	2024-01-04	2024-01-04	FLSHJ1	Flash Jueves Enero W1: 24h de oferta en Marca X
P609	2024-01-11	2024-01-11	FLSHJ2	Flash Jueves Enero W2: 24h de oferta en Categoría Y
P610	2024-01-18	2024-01-18	FLSHJ3	Flash Jueves Enero W3: 24h de oferta en Tamaño Z
P611	2024-01-25	2024-01-25	FLSHJ4	Flash Jueves Enero W4: 24h de oferta en Línea A
P612	2024-02-01	2024-02-01	FLSHF1	Flash Jueves Febrero W1: San Valentín anticipado
P613	2024-02-08	2024-02-08	FLSHF2	Flash Jueves Febrero W2: Oferta en florales románticos
P614	2024-02-15	2024-02-15	FLSHF3	Flash Jueves Febrero W3: Descuento en sets de pareja
P615	2024-02-22	2024-02-22	FLSHF4	Flash Jueves Febrero W4: Última oportunidad aromas de invierno
P616	2024-03-07	2024-03-07	FLSHM1	Flash Jueves Marzo W1: Bienvenida primavera temprana
P617	2024-03-14	2024-03-14	FLSHM2	Flash Jueves Marzo W2: Oferta en fragancias verdes
P618	2024-03-21	2024-03-21	FLSHM3	Flash Jueves Marzo W3: Descuento en aromas limpios
P619	2024-03-28	2024-03-28	FLSHM4	Flash Jueves Marzo W4: Especial fin de mes
P620	2024-04-04	2024-04-04	FLSHA1	Flash Jueves Abril W1: Oferta en cítricos revitalizantes
P621	2024-04-11	2024-04-11	FLSHA2	Flash Jueves Abril W2: Descuento en perfumes de autor
P622	2024-04-18	2024-04-18	FLSHA3	Flash Jueves Abril W3: Especial fragancias unisex
P623	2024-04-25	2024-04-25	FLSHA4	Flash Jueves Abril W4: Regalo con compra online
P624	2024-05-02	2024-05-02	FLSHY1	Flash Jueves Mayo W1: Ideas para el Día de la Madre
P625	2024-05-09	2024-05-09	FLSHY2	Flash Jueves Mayo W2: Oferta en sets de regalo floral
P626	2024-05-16	2024-05-16	FLSHY3	Flash Jueves Mayo W3: Descuento en velas perfumadas
P627	2024-05-23	2024-05-23	FLSHY4	Flash Jueves Mayo W4: Previa de ofertas de verano
P628	2024-05-30	2024-05-30	FLSHY5	Flash Jueves Mayo W5: Última llamada para ofertas de mayo
P629	2024-06-06	2024-06-06	FLSHJN1	Flash Jueves Junio W1: Especial Día del Padre
P630	2024-06-13	2024-06-13	FLSHJN2	Flash Jueves Junio W2: Oferta en fragancias masculinas acuáticas
P631	2024-06-20	2024-06-20	FLSHJN3	Flash Jueves Junio W3: Descuento en aromas de verano
P632	2024-06-27	2024-06-27	FLSHJN4	Flash Jueves Junio W4: Liquidación de primavera
P633	2024-07-04	2024-07-04	FLSHJL1	Flash Jueves Julio W1: Especial 4 de Julio
P634	2024-07-11	2024-07-11	FLSHJL2	Flash Jueves Julio W2: Oferta en fragancias tropicales
P635	2024-07-18	2024-07-18	FLSHJL3	Flash Jueves Julio W3: Descuento en body mists
P636	2024-07-25	2024-07-25	FLSHJL4	Flash Jueves Julio W4: Últimas ofertas de verano
P637	2024-08-01	2024-08-01	FLSHAG1	Flash Jueves Agosto W1: Previa Regreso a Clases
P638	2024-08-08	2024-08-08	FLSHAG2	Flash Jueves Agosto W2: Oferta en fragancias juveniles
P639	2024-08-15	2024-08-15	FLSHAG3	Flash Jueves Agosto W3: Descuento en sets de estudio
P640	2024-08-22	2024-08-22	FLSHAG4	Flash Jueves Agosto W4: Despedida del verano deals
P641	2024-08-29	2024-08-29	FLSHAG5	Flash Jueves Agosto W5: Oferta fin de mes
P642	2024-09-05	2024-09-05	FLSHSP1	Flash Jueves Septiembre W1: Bienvenida Otoño Temprano
P643	2024-09-12	2024-09-12	FLSHSP2	Flash Jueves Septiembre W2: Oferta en aromas de cosecha
P644	2024-09-19	2024-09-19	FLSHSP3	Flash Jueves Septiembre W3: Descuento en fragancias de Amistad
P645	2024-09-26	2024-09-26	FLSHSP4	Flash Jueves Septiembre W4: Especial aromas cálidos
P646	2024-10-03	2024-10-03	FLSHOC1	Flash Jueves Octubre W1: Oferta en especiados y misteriosos
P647	2024-10-10	2024-10-10	FLSHOC2	Flash Jueves Octubre W2: Descuento en velas de otoño
P648	2024-10-17	2024-10-17	FLSHOC3	Flash Jueves Octubre W3: Previa de Halloween
P649	2024-10-24	2024-10-24	FLSHOC4	Flash Jueves Octubre W4: Oferta en fragancias oscuras
P650	2024-10-31	2024-10-31	FLSHOC5	Flash Jueves Octubre W5: Especial Halloween Night!
P651	2024-11-07	2024-11-07	FLSHNV1	Flash Jueves Noviembre W1: Oferta en aromas de gratitud
P652	2024-11-14	2024-11-14	FLSHNV2	Flash Jueves Noviembre W2: Descuento en sets de regalo anticipados
P653	2024-11-21	2024-11-21	FLSHNV3	Flash Jueves Noviembre W3: Calentando para Black Friday
P654	2024-11-28	2024-11-28	FLSHNV4	Flash Jueves Noviembre W4: Acción de Gracias Special!
P655	2024-12-05	2024-12-05	FLSHDC1	Flash Jueves Diciembre W1: Oferta en fragancias festivas
P656	2024-12-12	2024-12-12	FLSHDC2	Flash Jueves Diciembre W2: Descuento en regalos de lujo
P657	2024-12-19	2024-12-19	FLSHDC3	Flash Jueves Diciembre W3: Última oportunidad para envíos
P658	2024-12-26	2024-12-26	FLSHDC4	Flash Jueves Diciembre W4: Boxing Day Flash Deal!
P659	2024-01-03	2024-01-10	CLRLUX	Liquidación de Lujo: 25% en marcas nicho seleccionadas (Ene)
P660	2024-02-07	2024-02-14	CLRVAL	Liquidación Pre-San Valentín: Hasta 40% en regalos (Feb)
P661	2024-03-06	2024-03-13	CLRSPR	Liquidación de Invierno: Prepara espacio para Primavera (Mar)
P662	2024-04-03	2024-04-10	CLREAS	Liquidación Post-Pascua: Descuentos en florales (Abr)
P663	2024-05-08	2024-05-15	CLRMOM	Liquidación Día de la Madre: Ofertas en sets (May)
P664	2024-06-05	2024-06-12	CLRDAD	Liquidación Día del Padre: Descuentos en masculinas (Jun)
P665	2024-07-03	2024-07-10	CLRSUM	Liquidación de Verano Profunda: Hasta 60% (Jul)
P666	2024-08-07	2024-08-14	CLRBTS	Liquidación Regreso a Clases: Ofertas en juveniles (Aug)
P667	2024-09-04	2024-09-11	CLRAUT	Liquidación Fin de Verano/Inicio Otoño: Descuentos mixtos (Sep)
P668	2024-10-02	2024-10-09	CLRHAL	Liquidación Pre-Halloween: Aromas de temporada (Oct)
P669	2024-11-06	2024-11-13	CLRBF	Liquidación Pre-Black Friday: Calentamiento de ofertas (Nov)
P670	2024-12-04	2024-12-11	CLRXMS	Liquidación Navideña Anticipada: Regalos con descuento (Dic)
P671	2025-01-08	2025-01-15	CLREND	Liquidación Fin de Temporada (Invierno 24/25): Grandes ahorros
P672	2024-01-02	2024-01-02	BDL01	Bundle del Día: Set sorpresa con 30% off (Ene D1)
P673	2024-01-09	2024-01-09	BDL02	Bundle Floral: 3 florales mini por $XX (Ene D2)
P674	2024-01-16	2024-01-16	BDL03	Bundle Masculino: Set de 3 muestras para hombre (Ene D3)
P675	2024-01-23	2024-01-23	BDL04	Bundle Viajero: 3 travel sizes con neceser (Ene D4)
P676	2024-01-30	2024-01-30	BDL05	Bundle Lujo: Muestras de alta perfumería (Ene D5)
P677	2024-02-06	2024-02-06	BDL06	Bundle San Valentín: Para él y para ella (Feb D1)
P678	2024-02-13	2024-02-13	BDL07	Bundle Rojo Pasión: Fragancias con notas rojas (Feb D2)
P679	2024-02-20	2024-02-20	BDL08	Bundle Fresco: 3 acuáticos o cítricos (Feb D3)
P680	2024-02-27	2024-02-27	BDL09	Bundle Relax: Velas y difusores mini (Feb D4)
P681	2024-03-05	2024-03-05	BDL10	Bundle Primavera: Aromas florales y verdes (Mar D1)
P682	2024-03-12	2024-03-12	BDL11	Bundle Mujer: Set de fragancias femeninas top (Mar D2)
P683	2024-03-19	2024-03-19	BDL12	Bundle Limpio: Aromas de algodón y jabón (Mar D3)
P684	2024-03-26	2024-03-26	BDL13	Bundle Energizante: Cítricos y jengibre (Mar D4)
P685	2024-04-02	2024-04-02	BDL14	Bundle Abril: Sorpresas de temporada (Abr D1)
P686	2024-04-09	2024-04-09	BDL15	Bundle Eco: Productos sostenibles y veganos (Abr D2)
P687	2024-04-16	2024-04-16	BDL16	Bundle Descubrimiento Nicho: Muestras de autor (Abr D3)
P688	2024-04-23	2024-04-23	BDL17	Bundle Dulce: Gourmand y avainillados (Abr D4)
P689	2024-04-30	2024-04-30	BDL18	Bundle Fin de Mes: Variedad con descuento (Abr D5)
P690	2024-05-07	2024-05-07	BDL19	Bundle Día de la Madre: Lujo para ella (May D1)
P691	2024-05-14	2024-05-14	BDL20	Bundle Spa en Casa: Productos de baño y cuerpo (May D2)
P692	2024-05-21	2024-05-21	BDL21	Bundle Solar: Fragancias de verano y protección (May D3)
P693	2024-05-28	2024-05-28	BDL22	Bundle Clásicos: Iconos de la perfumería (May D4)
P694	2024-06-04	2024-06-04	BDL23	Bundle Día del Padre: Masculinos y elegantes (Jun D1)
P695	2024-06-11	2024-06-11	BDL24	Bundle Deportivo: Frescos y energéticos para él (Jun D2)
P696	2024-06-18	2024-06-18	BDL25	Bundle Verano Total: Todo para el calor (Jun D3)
P697	2024-06-25	2024-06-25	BDL26	Bundle Celebración: Fragancias de fiesta (Jun D4)
P698	2024-07-02	2024-07-02	BDL27	Bundle Julio: Frescura y vitalidad (Jul D1)
P699	2024-07-09	2024-07-09	BDL28	Bundle Marino: Acuáticos y ozónicos (Jul D2)
P700	2024-07-16	2024-07-16	BDL29	Bundle Exótico: Frutas tropicales y flores exóticas (Jul D3)
P701	2024-07-23	2024-07-23	BDL30	Bundle Noche de Verano: Sensuales y cálidos (Jul D4)
P702	2024-07-30	2024-07-30	BDL31	Bundle Anti-Calor: Mists y aguas frescas (Jul D5)
P703	2024-08-06	2024-08-06	BDL32	Bundle Regreso a Rutina: Aromas para concentrar (Aug D1)
P704	2024-08-13	2024-08-13	BDL33	Bundle Juvenil: Fragancias divertidas y modernas (Aug D2)
P705	2024-08-20	2024-08-20	BDL34	Bundle Despedida Verano: Últimos aromas de temporada (Aug D3)
P706	2024-08-27	2024-08-27	BDL35	Bundle Transición: De verano a otoño (Aug D4)
P707	2024-09-03	2024-09-03	BDL36	Bundle Otoño Acogedor: Amaderados y especiados (Sep D1)
P708	2024-09-10	2024-09-10	BDL37	Bundle Amistad: Para regalar y compartir (Sep D2)
P709	2024-09-17	2024-09-17	BDL38	Bundle Cosecha: Frutas de otoño y especias (Sep D3)
P710	2024-09-24	2024-09-24	BDL39	Bundle Elegancia Otoñal: Chipres y cueros (Sep D4)
P711	2024-10-01	2024-10-01	BDL40	Bundle Octubre: Misterio y calidez (Oct D1)
P712	2024-10-08	2024-10-08	BDL41	Bundle Halloween Soft: Calabaza y canela (Oct D2)
P713	2024-10-15	2024-10-15	BDL42	Bundle Noche Encantada: Incienso y maderas oscuras (Oct D3)
P714	2024-10-22	2024-10-22	BDL43	Bundle Truco o Trato: Sorpresas aromáticas (Oct D4)
P715	2024-10-29	2024-10-29	BDL44	Bundle Víspera de Santos: Reconfortante y sereno (Oct D5)
P716	2024-11-05	2024-11-05	BDL45	Bundle Noviembre: Gratitud y preparación festiva (Nov D1)
P717	2024-11-12	2024-11-12	BDL46	Bundle Regalo Anticipado: Ideas para Navidad (Nov D2)
P718	2024-11-19	2024-11-19	BDL47	Bundle Black Friday Preview: Miniaturas de ofertas (Nov D3)
P719	2024-11-26	2024-11-26	BDL48	Bundle Acción de Gracias: Aromas de hogar y familia (Nov D4)
P720	2024-12-03	2024-12-03	BDL49	Bundle Diciembre Festivo: Pino, canela y cítricos (Dic D1)
P721	2024-12-10	2024-12-10	BDL50	Bundle Regalos de Lujo: Miniaturas de alta gama (Dic D2)
P722	2024-12-17	2024-12-17	BDL51	Bundle Última Hora: Sets listos para regalar (Dic D3)
P723	2024-12-24	2024-12-24	BDL52	Bundle Nochebuena: Aromas especiales para la celebración (Dic D4)
P724	2024-12-31	2024-12-31	BDL53	Bundle Año Nuevo: Brillante y festivo (Dic D5)
P725	2025-01-07	2025-01-07	BDL54	Bundle Detox 2025: Aromas limpios y puros (Ene D1 2025)
P726	2025-01-14	2025-01-14	BDL55	Bundle Invierno Profundo: Cálidos y reconfortantes (Ene D2 2025)
P727	2024-01-05	2024-01-19	2WKA	Oferta Quincenal Enero A: 15% en marca X y envío gratis
P728	2024-01-20	2024-02-02	2WKB	Oferta Quincenal Enero B: Regalo con compra en categoría Y
P729	2024-02-03	2024-02-16	2WKC	Oferta Quincenal Febrero A: Descuento en sets de San Valentín
P730	2024-02-17	2024-03-01	2WKD	Oferta Quincenal Febrero B: 20% en fragancias florales seleccionadas
P731	2024-03-02	2024-03-15	2WKE	Oferta Quincenal Marzo A: Especial Día de la Mujer + Puntos Dobles
P732	2024-03-16	2024-03-29	2WKF	Oferta Quincenal Marzo B: 10% en nuevos lanzamientos de primavera
P733	2024-03-30	2024-04-12	2WKG	Oferta Quincenal Abril A: Descuentos en aromas frescos y limpios
P734	2024-04-13	2024-04-26	2WKH	Oferta Quincenal Abril B: Regalo con compra en línea eco-amigable
P735	2024-04-27	2024-05-10	2WKI	Oferta Quincenal Mayo A: Especial Día de la Madre, sets con descuento
P736	2024-05-11	2024-05-24	2WKJ	Oferta Quincenal Mayo B: 15% en fragancias solares y de verano
P737	2024-05-25	2024-06-07	2WKK	Oferta Quincenal Junio A: Descuentos para el Día del Padre
P738	2024-06-08	2024-06-21	2WKL	Oferta Quincenal Junio B: 20% en fragancias acuáticas y deportivas
P739	2024-06-22	2024-07-05	2WKM	Oferta Quincenal Julio A: Especial Independencia, ofertas patrias
P740	2024-07-06	2024-07-19	2WKN	Oferta Quincenal Julio B: Rebajas de verano, hasta 30% off
P741	2024-07-20	2024-08-02	2WKO	Oferta Quincenal Agosto A: Preparación Regreso a Clases, kits juveniles
P742	2024-08-03	2024-08-16	2WKP	Oferta Quincenal Agosto B: Última liquidación de verano, hasta 50%
P743	2024-08-17	2024-08-30	2WKQ	Oferta Quincenal Agosto C: Descuento en fragancias de transición
P744	2024-08-31	2024-09-13	2WKR	Oferta Quincenal Sept A: Especial Amor y Amistad, regalos dúo
P745	2024-09-14	2024-09-27	2WKS	Oferta Quincenal Sept B: 15% en fragancias cálidas de otoño
P746	2024-09-28	2024-10-11	2WKT	Oferta Quincenal Oct A: Descuentos en aromas especiados y de calabaza
P747	2024-10-12	2024-10-25	2WKU	Oferta Quincenal Oct B: Especial Halloween, fragancias misteriosas
P748	2024-10-26	2024-11-08	2WKV	Oferta Quincenal Nov A: Anticipo de regalos navideños, sets en oferta
P749	2024-11-09	2024-11-22	2WKW	Oferta Quincenal Nov B: Pre-Black Friday, descuentos diarios
P750	2024-11-23	2024-12-06	2WKX	Oferta Quincenal Dic A: Black Friday Extendido y Cyber Monday
P751	2024-12-07	2024-12-20	2WKY	Oferta Quincenal Dic B: Especial Navidad, regalos y descuentos
P752	2024-12-21	2025-01-03	2WKZ	Oferta Quincenal Dic C: Liquidación Fin de Año y Año Nuevo
P753	2024-01-01	2024-03-31	Q1D24	Oferta Trimestral Q1: Descuento acumulable por compras del trimestre
P754	2024-04-01	2024-06-30	Q2D24	Oferta Trimestral Q2: Regalo exclusivo al alcanzar meta de gasto trimestral
P755	2024-07-01	2024-09-30	Q3D24	Oferta Trimestral Q3: Envío gratis en todos los pedidos del trimestre para miembros
P756	2024-10-01	2024-12-31	Q4D24	Oferta Trimestral Q4: Participa en sorteo de gran premio por compras trimestrales
P757	2025-01-01	2025-03-31	Q1D25	Oferta Trimestral Q1 2025: Bono de descuento para el siguiente trimestre
P758	2025-04-01	2025-06-30	Q2D25	Oferta Trimestral Q2 2025: Acceso a ventas privadas exclusivas
P759	2025-07-01	2025-09-30	Q3D25	Oferta Trimestral Q3 2025: Doble puntos en todas las compras
P760	2025-10-01	2025-12-31	Q4D25	Oferta Trimestral Q4 2025: Regalo de lujo al final del trimestre para top clientes
P761	2024-01-15	2024-01-15	MON15	Lunes 15 Enero: 15% off solo hoy
P762	2024-02-15	2024-02-15	THU15	Jueves 15 Febrero: Envío gratis solo hoy
P763	2024-03-15	2024-03-15	FRI15	Viernes 15 Marzo: Regalo con compra solo hoy
P764	2024-04-15	2024-04-15	MONAP	Lunes 15 Abril: Puntos dobles solo hoy
P765	2024-05-15	2024-05-15	WEDMY	Miércoles 15 Mayo: 10% extra solo hoy
P766	2024-06-15	2024-06-15	SATJU	Sábado 15 Junio: Oferta sorpresa solo hoy
P767	2024-07-15	2024-07-15	MONJL	Lunes 15 Julio: 20% en categoría X solo hoy
P768	2024-08-15	2024-08-15	THUAU	Jueves 15 Agosto: Muestra deluxe solo hoy
P769	2024-09-15	2024-09-15	SUNSE	Domingo 15 Septiembre: Envío express gratis solo hoy
P770	2024-10-15	2024-10-15	TUEOC	Martes 15 Octubre: 25% en marca Y solo hoy
P771	2024-11-15	2024-11-15	FRINO	Viernes 15 Noviembre: Regalo VIP solo hoy
P772	2024-12-15	2024-12-15	SUNDE	Domingo 15 Diciembre: Descuento navideño extra solo hoy
P773	2025-01-15	2025-01-15	WEDJA	Miércoles 15 Enero 2025: 15% off + regalo
P774	2024-01-01	2024-06-30	HALF1	Primera Mitad del Año: Acumula compras y gana premio semestral
P775	2024-07-01	2024-12-31	HALF2	Segunda Mitad del Año: Ofertas exclusivas para clientes recurrentes
P776	2025-01-01	2025-06-30	HALF3	Primera Mitad 2025: Nuevos beneficios por lealtad semestral
P777	2024-02-14	2024-02-14	VDAYX	San Valentín Express: Envío en 2h en ciudades seleccionadas
P778	2024-05-12	2024-05-12	MDAYX	Día Madre Express: Entrega especial para mamá el mismo día
P779	2024-06-16	2024-06-16	FDAYX	Día Padre Express: Regalo de último minuto entregado hoy
P780	2024-12-24	2024-12-24	XMASX	Navidad Express: Entrega garantizada antes de medianoche
P781	2024-01-20	2024-01-27	CHNYR	Año Nuevo Chino: Fragancias con temática oriental y regalos rojos
P782	2024-03-20	2024-03-27	NOWRZ	Nowruz (Año Nuevo Persa): Descuentos en aromas florales y primaverales
P783	2024-04-10	2024-04-17	RAMDN	Ramadán Kareem: Ofertas especiales y donación con compra
P784	2024-05-01	2024-05-08	EIDFT	Eid al-Fitr: Celebración con regalos y descuentos festivos
P785	2024-06-16	2024-06-23	EIDAD	Eid al-Adha: Promociones especiales y sets de regalo
P786	2024-10-24	2024-10-31	DIWAL	Diwali Festival de Luces: Fragancias luminosas y velas con descuento
P787	2024-12-16	2024-12-24	HANUK	Hanukkah: 8 días de ofertas y regalos diarios
P788	2024-01-01	2024-01-01	NEWYRD	New Year's Day Deal: 24% off por 24 horas
P789	2024-02-14	2024-02-14	VALDAY	Valentine's Day Special: Regalo con compra temática amor
P790	2024-03-08	2024-03-08	IWOMD	Int'l Women's Day: 20% en fragancias creadas por mujeres
P791	2024-04-22	2024-04-22	ERTHD	Earth Day: 15% en marcas eco y plantamos un árbol
P792	2024-05-12	2024-05-12	MOMDAY	Mother's Day: Envío gratis y tarjeta personalizada
P793	2024-06-16	2024-06-16	DADAY	Father's Day: 15% en masculinas y neceser de regalo
P794	2024-07-04	2024-07-04	JULY4	Independence Day USA: Descuento patriótico + regalo
P795	2024-07-20	2024-07-20	COLDAY	Colombia Independence: 20.07% off en toda la tienda
P796	2024-09-02	2024-09-02	LABDAY	Labor Day: Descuento para trabajadores incansables
P797	2024-09-20	2024-09-20	AMORDY	Día Amor y Amistad (COL): Regalo especial para compartir
P798	2024-10-31	2024-10-31	HALLDY	Halloween Night: Descuento flash de última hora
P799	2024-11-29	2024-11-29	BLKFRI	Black Friday Doorbuster: Ofertas limitadas al stock
P800	2024-12-02	2024-12-02	CYMON	Cyber Monday Madness: Descuentos online exclusivos
P801	2024-12-25	2024-12-25	XMASDY	Christmas Day Gift: Descuento adicional solo hoy
P802	2024-01-10	2024-01-10	DBLPT1	Doble Puntos Miércoles (Ene W2)
P803	2024-01-17	2024-01-17	TRPLPT1	Triple Puntos Miércoles (Ene W3)
P804	2024-01-24	2024-01-24	FREEG1	Regalo Sorpresa Miércoles (Ene W4)
P805	2024-01-31	2024-01-31	ENDSALE1	Fin de Mes Sale Miércoles (Ene W5)
P806	2024-02-07	2024-02-07	DBLPT2	Doble Puntos Miércoles (Feb W1)
P807	2024-02-14	2024-02-14	VDAYPT	Puntos Extra San Valentín (Feb W2)
P808	2024-02-21	2024-02-21	FREEG2	Regalo Sorpresa Miércoles (Feb W3)
P809	2024-02-28	2024-02-28	ENDSALE2	Fin de Mes Sale Miércoles (Feb W4)
P810	2024-03-06	2024-03-06	DBLPT3	Doble Puntos Miércoles (Mar W1)
P811	2024-03-13	2024-03-13	TRPLPT3	Triple Puntos Miércoles (Mar W2)
P812	2024-03-20	2024-03-20	FREEG3	Regalo Sorpresa Miércoles (Mar W3)
P813	2024-03-27	2024-03-27	ENDSALE3	Fin de Mes Sale Miércoles (Mar W4)
P814	2024-04-03	2024-04-03	DBLPT4	Doble Puntos Miércoles (Abr W1)
P815	2024-04-10	2024-04-10	TRPLPT4	Triple Puntos Miércoles (Abr W2)
P816	2024-04-17	2024-04-17	FREEG4	Regalo Sorpresa Miércoles (Abr W3)
P817	2024-04-24	2024-04-24	ENDSALE4	Fin de Mes Sale Miércoles (Abr W4)
P818	2024-05-01	2024-05-01	DBLPT5	Doble Puntos Miércoles (May W1)
P819	2024-05-08	2024-05-08	TRPLPT5	Triple Puntos Miércoles (May W2)
P820	2024-05-15	2024-05-15	FREEG5	Regalo Sorpresa Miércoles (May W3)
P821	2024-05-22	2024-05-22	ENDSALE5	Fin de Mes Sale Miércoles (May W4)
P822	2024-05-29	2024-05-29	LASTWED5	Último Miércoles de Mayo Oferta
P823	2024-06-05	2024-06-05	DBLPT6	Doble Puntos Miércoles (Jun W1)
P824	2024-06-12	2024-06-12	TRPLPT6	Triple Puntos Miércoles (Jun W2)
P825	2024-06-19	2024-06-19	FREEG6	Regalo Sorpresa Miércoles (Jun W3)
P826	2024-06-26	2024-06-26	ENDSALE6	Fin de Mes Sale Miércoles (Jun W4)
P827	2024-07-03	2024-07-03	DBLPT7	Doble Puntos Miércoles (Jul W1)
P828	2024-07-10	2024-07-10	TRPLPT7	Triple Puntos Miércoles (Jul W2)
P829	2024-07-17	2024-07-17	FREEG7	Regalo Sorpresa Miércoles (Jul W3)
P830	2024-07-24	2024-07-24	ENDSALE7	Fin de Mes Sale Miércoles (Jul W4)
P831	2024-07-31	2024-07-31	LASTWED7	Último Miércoles de Julio Oferta
P832	2024-08-07	2024-08-07	DBLPT8	Doble Puntos Miércoles (Aug W1)
P833	2024-08-14	2024-08-14	TRPLPT8	Triple Puntos Miércoles (Aug W2)
P834	2024-08-21	2024-08-21	FREEG8	Regalo Sorpresa Miércoles (Aug W3)
P835	2024-08-28	2024-08-28	ENDSALE8	Fin de Mes Sale Miércoles (Aug W4)
P836	2024-09-04	2024-09-04	DBLPT9	Doble Puntos Miércoles (Sep W1)
P837	2024-09-11	2024-09-11	TRPLPT9	Triple Puntos Miércoles (Sep W2)
P838	2024-09-18	2024-09-18	FREEG9	Regalo Sorpresa Miércoles (Sep W3)
P839	2024-09-25	2024-09-25	ENDSALE9	Fin de Mes Sale Miércoles (Sep W4)
P840	2024-10-02	2024-10-02	DBLPT10	Doble Puntos Miércoles (Oct W1)
P841	2024-10-09	2024-10-09	TRPLPT10	Triple Puntos Miércoles (Oct W2)
P842	2024-10-16	2024-10-16	FREEG10	Regalo Sorpresa Miércoles (Oct W3)
P843	2024-10-23	2024-10-23	ENDSALE10	Fin de Mes Sale Miércoles (Oct W4)
P844	2024-10-30	2024-10-30	LASTWED10	Último Miércoles de Octubre Oferta
P845	2024-11-06	2024-11-06	DBLPT11	Doble Puntos Miércoles (Nov W1)
P846	2024-11-13	2024-11-13	TRPLPT11	Triple Puntos Miércoles (Nov W2)
P847	2024-11-20	2024-11-20	FREEG11	Regalo Sorpresa Miércoles (Nov W3)
P848	2024-11-27	2024-11-27	ENDSALE11	Fin de Mes Sale Miércoles (Nov W4)
P849	2024-12-04	2024-12-04	DBLPT12	Doble Puntos Miércoles (Dic W1)
P850	2024-12-11	2024-12-11	TRPLPT12	Triple Puntos Miércoles (Dic W2)
P851	2024-12-18	2024-12-18	FREEG12	Regalo Sorpresa Miércoles (Dic W3)
P852	2024-12-25	2024-12-25	XMASWED	Miércoles de Navidad: Oferta especial solo hoy
P853	2025-01-01	2025-01-01	NEWYWED	Miércoles de Año Nuevo 2025: Descuento
P854	2024-01-06	2024-01-13	WEKSL1	Venta Semanal Enero W1: 10% en categoría X
P855	2024-01-13	2024-01-20	WEKSL2	Venta Semanal Enero W2: Envío gratis en marca Y
P856	2024-01-20	2024-01-27	WEKSL3	Venta Semanal Enero W3: Regalo con compra en línea Z
P857	2024-01-27	2024-02-03	WEKSL4	Venta Semanal Enero W4: 15% en nuevos lanzamientos
P858	2024-02-03	2024-02-10	WEKSL5	Venta Semanal Febrero W1: Descuento en sets San Valentín
P859	2024-02-10	2024-02-17	WEKSL6	Venta Semanal Febrero W2: Oferta en perfumes florales
P860	2024-02-17	2024-02-24	WEKSL7	Venta Semanal Febrero W3: 20% en fragancias de lujo
P861	2024-02-24	2024-03-02	WEKSL8	Venta Semanal Febrero W4: Muestras gratis con cada pedido
P862	2024-03-02	2024-03-09	WEKSL9	Venta Semanal Marzo W1: Especial Día de la Mujer
P863	2024-03-09	2024-03-16	WEKSL10	Venta Semanal Marzo W2: 10% en aromas primaverales
P864	2024-03-16	2024-03-23	WEKSL11	Venta Semanal Marzo W3: Puntos dobles de lealtad
P865	2024-03-23	2024-03-30	WEKSL12	Venta Semanal Marzo W4: Descuento en fragancias verdes
P866	2024-03-30	2024-04-06	WEKSL13	Venta Semanal Abril W1: Ofertas de Pascua y limpieza
P867	2024-04-06	2024-04-13	WEKSL14	Venta Semanal Abril W2: 15% en fragancias cítricas
P868	2024-04-13	2024-04-20	WEKSL15	Venta Semanal Abril W3: Regalo con compra eco-amigable
P869	2024-04-20	2024-04-27	WEKSL16	Venta Semanal Abril W4: 20% en perfumes de autor
P870	2024-04-27	2024-05-04	WEKSL17	Venta Semanal Mayo W1: Anticipo Día de la Madre
P871	2024-05-04	2024-05-11	WEKSL18	Venta Semanal Mayo W2: Especial sets de regalo para mamá
P872	2024-05-11	2024-05-18	WEKSL19	Venta Semanal Mayo W3: Descuento en fragancias florales blancas
P873	2024-05-18	2024-05-25	WEKSL20	Venta Semanal Mayo W4: 10% en aromas de verano
P874	2024-05-25	2024-06-01	WEKSL21	Venta Semanal Junio W1: Ofertas Memorial Day y pre-verano
P875	2024-06-01	2024-06-08	WEKSL22	Venta Semanal Junio W2: Especial Día del Padre, masculinas
P876	2024-06-08	2024-06-15	WEKSL23	Venta Semanal Junio W3: 15% en fragancias deportivas
P877	2024-06-15	2024-06-22	WEKSL24	Venta Semanal Junio W4: 20% en aromas de solsticio
P878	2024-06-22	2024-06-29	WEKSL25	Venta Semanal Junio W5: Preparación para vacaciones de verano
P879	2024-06-29	2024-07-06	WEKSL26	Venta Semanal Julio W1: Especial Independencia USA
P880	2024-07-06	2024-07-13	WEKSL27	Venta Semanal Julio W2: Ofertas en fragancias acuáticas
P881	2024-07-13	2024-07-20	WEKSL28	Venta Semanal Julio W3: Descuentos en body mists y colonias
P882	2024-07-20	2024-07-27	WEKSL29	Venta Semanal Julio W4: Especial Independencia Colombia
P883	2024-07-27	2024-08-03	WEKSL30	Venta Semanal Agosto W1: Ofertas Prime Days Diamond
P884	2024-08-03	2024-08-10	WEKSL31	Venta Semanal Agosto W2: Regreso a Clases, juveniles
P885	2024-08-10	2024-08-17	WEKSL32	Venta Semanal Agosto W3: 15% en fragancias de estudio
P886	2024-08-17	2024-08-24	WEKSL33	Venta Semanal Agosto W4: Liquidación final de verano
P887	2024-08-24	2024-08-31	WEKSL34	Venta Semanal Agosto W5: Despedida de agosto, últimas ofertas
P888	2024-08-31	2024-09-07	WEKSL35	Venta Semanal Septiembre W1: Labor Day y transición a otoño
P889	2024-09-07	2024-09-14	WEKSL36	Venta Semanal Septiembre W2: Especial Amor y Amistad, regalos
P890	2024-09-14	2024-09-21	WEKSL37	Venta Semanal Septiembre W3: Ofertas en aromas cálidos y de cosecha
P891	2024-09-21	2024-09-28	WEKSL38	Venta Semanal Septiembre W4: 20% en fragancias de otoño
P892	2024-09-28	2024-10-05	WEKSL39	Venta Semanal Octubre W1: Bienvenida oficial al otoño
P893	2024-10-05	2024-10-12	WEKSL40	Venta Semanal Octubre W2: Descuento en fragancias especiadas
P894	2024-10-12	2024-10-19	WEKSL41	Venta Semanal Octubre W3: Ofertas en aromas de Día de la Raza
P895	2024-10-19	2024-10-26	WEKSL42	Venta Semanal Octubre W4: Previa Halloween, descuentos oscuros
P896	2024-10-26	2024-11-02	WEKSL43	Venta Semanal Noviembre W1: Especial Halloween y Día de Muertos
P897	2024-11-02	2024-11-09	WEKSL44	Venta Semanal Noviembre W2: Ofertas Single's Day y Veteranos
P898	2024-11-09	2024-11-16	WEKSL45	Venta Semanal Noviembre W3: Calentando para Black Friday
P899	2024-11-16	2024-11-23	WEKSL46	Venta Semanal Noviembre W4: Semana Pre-Black Friday, ofertas diarias
P900	2024-11-23	2024-11-30	WEKSL47	Venta Semanal Noviembre W5: ¡SEMANA DE BLACK FRIDAY!
P901	2024-11-30	2024-12-07	WEKSL48	Venta Semanal Diciembre W1: CYBER MONDAY Y OFERTAS NAVIDEÑAS
P902	2024-12-07	2024-12-14	WEKSL49	Venta Semanal Diciembre W2: Guía de Regalos y descuentos
P903	2024-12-14	2024-12-21	WEKSL50	Venta Semanal Diciembre W3: Últimas compras navideñas, envío express
P904	2024-12-21	2024-12-28	WEKSL51	Venta Semanal Diciembre W4: Navidad y Boxing Day Deals
P905	2024-12-28	2025-01-04	WEKSL52	Venta Semanal Diciembre W5: Fin de Año y Año Nuevo
P906	2024-01-01	2024-12-31	YEARLY	Promo Anual Miembros: Beneficio exclusivo por renovación
P907	2024-06-01	2024-08-31	SUMMER	Gran Venta de Verano: Descuentos en toda la temporada
P908	2024-09-01	2024-11-30	AUTUMN	Colección de Otoño: Nuevos aromas y ofertas de temporada
P909	2024-12-01	2025-02-28	WINTERS	Especiales de Invierno: Fragancias cálidas y regalos
P910	2025-03-01	2025-05-31	SPRINGA	Aires de Primavera: Descuentos en florales y frescos
P911	2024-07-29	2024-08-04	BDAYJUL	Cumpleaños de Julio: Descuento especial si cumples en Julio
P912	2024-08-26	2024-09-01	BDAYAUG	Cumpleaños de Agosto: Regalo si tu cumpleaños es en Agosto
P913	2024-09-30	2024-10-06	BDAYSEP	Cumpleaños de Sept: Oferta exclusiva para cumpleañeros de Sept
P914	2024-10-28	2024-11-03	BDAYOCT	Cumpleaños de Oct: Sorpresa especial si cumples en Octubre
P915	2024-11-25	2024-12-01	BDAYNOV	Cumpleaños de Nov: Descuento y regalo para los de Noviembre
P916	2024-12-23	2024-12-29	BDAYDEC	Cumpleaños de Dic: ¡Celebra con nosotros si es tu mes!
P917	2025-01-27	2025-02-02	BDAYJAN	Cumpleaños de Enero 2025: Empieza el año con un regalo
P918	2025-02-24	2025-03-02	BDAYFEB	Cumpleaños de Febrero 2025: Amor y regalos para ti
P919	2025-03-24	2025-03-30	BDAYMAR	Cumpleaños de Marzo 2025: Florece con un descuento
P920	2025-04-28	2025-05-04	BDAYAPR	Cumpleaños de Abril 2025: Sorpresas primaverales
P921	2025-05-26	2025-06-01	BDAYMAY	Cumpleaños de Mayo 2025: Celebra tu mes especial
P922	2025-06-23	2025-06-29	BDAYJUN	Cumpleaños de Junio 2025: Sol, verano y regalos
P923	2024-01-01	2024-01-01	CODE01	Promo Test Código 01
P924	2024-01-02	2024-01-02	CODE02	Promo Test Código 02
P925	2024-01-03	2024-01-03	CODE03	Promo Test Código 03
P926	2024-01-04	2024-01-04	CODE04	Promo Test Código 04
P927	2024-01-05	2024-01-05	CODE05	Promo Test Código 05
P928	2024-01-06	2024-01-06	CODE06	Promo Test Código 06
P929	2024-01-07	2024-01-07	CODE07	Promo Test Código 07
P930	2024-01-08	2024-01-08	CODE08	Promo Test Código 08
P931	2024-01-09	2024-01-09	CODE09	Promo Test Código 09
P932	2024-01-10	2024-01-10	CODE10	Promo Test Código 10
P933	2024-01-11	2024-01-11	CODE11	Promo Test Código 11
P934	2024-01-12	2024-01-12	CODE12	Promo Test Código 12
P935	2024-01-13	2024-01-13	CODE13	Promo Test Código 13
P936	2024-01-14	2024-01-14	CODE14	Promo Test Código 14
P937	2024-01-15	2024-01-15	CODE15	Promo Test Código 15
P938	2024-01-16	2024-01-16	CODE16	Promo Test Código 16
P939	2024-01-17	2024-01-17	CODE17	Promo Test Código 17
P940	2024-01-18	2024-01-18	CODE18	Promo Test Código 18
P941	2024-01-19	2024-01-19	CODE19	Promo Test Código 19
P942	2024-01-20	2024-01-20	CODE20	Promo Test Código 20
P943	2024-01-21	2024-01-21	CODE21	Promo Test Código 21
P944	2024-01-22	2024-01-22	CODE22	Promo Test Código 22
P945	2024-01-23	2024-01-23	CODE23	Promo Test Código 23
P946	2024-01-24	2024-01-24	CODE24	Promo Test Código 24
P947	2024-01-25	2024-01-25	CODE25	Promo Test Código 25
P948	2024-01-26	2024-01-26	CODE26	Promo Test Código 26
P949	2024-01-27	2024-01-27	CODE27	Promo Test Código 27
P950	2024-01-28	2024-01-28	CODE28	Promo Test Código 28
P951	2024-01-29	2024-01-29	CODE29	Promo Test Código 29
P952	2024-01-30	2024-01-30	CODE30	Promo Test Código 30
P953	2024-01-31	2024-01-31	CODE31	Promo Test Código 31
P954	2024-02-01	2024-02-01	TEST01	Test Promoción Febrero 1
P955	2024-02-02	2024-02-02	TEST02	Test Promoción Febrero 2
P956	2024-02-03	2024-02-03	TEST03	Test Promoción Febrero 3
P957	2024-02-04	2024-02-04	TEST04	Test Promoción Febrero 4
P958	2024-02-05	2024-02-05	TEST05	Test Promoción Febrero 5
P959	2024-02-06	2024-02-06	TEST06	Test Promoción Febrero 6
P960	2024-02-07	2024-02-07	TEST07	Test Promoción Febrero 7
P961	2024-02-08	2024-02-08	TEST08	Test Promoción Febrero 8
P962	2024-02-09	2024-02-09	TEST09	Test Promoción Febrero 9
P963	2024-02-10	2024-02-10	TEST10	Test Promoción Febrero 10
P964	2024-02-11	2024-02-11	TEST11	Test Promoción Febrero 11
P965	2024-02-12	2024-02-12	TEST12	Test Promoción Febrero 12
P966	2024-02-13	2024-02-13	TEST13	Test Promoción Febrero 13
P967	2024-02-14	2024-02-14	TEST14	Test Promoción Febrero 14 (San Valentín)
P968	2024-02-15	2024-02-15	TEST15	Test Promoción Febrero 15
P969	2024-02-16	2024-02-16	TEST16	Test Promoción Febrero 16
P970	2024-02-17	2024-02-17	TEST17	Test Promoción Febrero 17
P971	2024-02-18	2024-02-18	TEST18	Test Promoción Febrero 18
P972	2024-02-19	2024-02-19	TEST19	Test Promoción Febrero 19
P973	2024-02-20	2024-02-20	TEST20	Test Promoción Febrero 20
P974	2024-02-21	2024-02-21	TEST21	Test Promoción Febrero 21
P975	2024-02-22	2024-02-22	TEST22	Test Promoción Febrero 22
P976	2024-02-23	2024-02-23	TEST23	Test Promoción Febrero 23
P977	2024-02-24	2024-02-24	TEST24	Test Promoción Febrero 24
P978	2024-02-25	2024-02-25	TEST25	Test Promoción Febrero 25
P979	2024-02-26	2024-02-26	TEST26	Test Promoción Febrero 26
P980	2024-02-27	2024-02-27	TEST27	Test Promoción Febrero 27
P981	2024-02-28	2024-02-28	TEST28	Test Promoción Febrero 28
P982	2024-02-29	2024-02-29	LEAPT	Test Promoción Año Bisiesto 29 Feb
P983	2024-03-01	2024-03-01	SMPL1	Promo Simple Marzo 1
P984	2024-03-02	2024-03-02	SMPL2	Promo Simple Marzo 2
P985	2024-03-03	2024-03-03	SMPL3	Promo Simple Marzo 3
P986	2024-03-04	2024-03-04	SMPL4	Promo Simple Marzo 4
P987	2024-03-05	2024-03-05	SMPL5	Promo Simple Marzo 5
P988	2024-03-06	2024-03-06	SMPL6	Promo Simple Marzo 6
P989	2024-03-07	2024-03-07	SMPL7	Promo Simple Marzo 7 (Pre-Día Mujer)
P990	2024-03-08	2024-03-08	SMPL8	Promo Simple Marzo 8 (Día Mujer)
P991	2024-03-09	2024-03-09	SMPL9	Promo Simple Marzo 9
P992	2024-03-10	2024-03-10	SMPL10	Promo Simple Marzo 10
P993	2024-03-11	2024-03-11	SMPL11	Promo Simple Marzo 11
P994	2024-03-12	2024-03-12	SMPL12	Promo Simple Marzo 12
P995	2024-03-13	2024-03-13	SMPL13	Promo Simple Marzo 13
P996	2024-03-14	2024-03-14	SMPL14	Promo Simple Marzo 14
P997	2024-03-15	2024-03-15	SMPL15	Promo Simple Marzo 15 (Quincena)
P998	2024-03-16	2024-03-16	SMPL16	Promo Simple Marzo 16
P999	2024-03-17	2024-03-17	STPAT	Promo Simple Marzo 17 (St. Patrick)
\.


                                                                                                                                                                                                                                                                     5130.dat                                                                                            0000600 0004000 0002000 00000066332 15014423351 0014252 0                                                                                                    ustar 00postgres                        postgres                        0000000 0000000                                                                                                                                                                        R000	CHAN	Chanel
R001	DIOR	Dior
R002	GUCC	Gucci
R003	YSLO	Yves Saint Laurent
R004	LANC	Lancôme
R005	ESTL	Estée Lauder
R006	ARMA	Giorgio Armani
R007	TFOR	Tom Ford
R008	PRAD	Prada
R009	VERS	Versace
R010	GIVE	Givenchy
R011	BURB	Burberry
R012	BVLG	Bvlgari
R013	CKLE	Calvin Klein
R014	HERM	Hermès
R015	PACR	Paco Rabanne
R016	JPGA	Jean Paul Gaultier
R017	CAHE	Carolina Herrera
R018	HUBO	Hugo Boss
R019	RALP	Ralph Lauren
R020	MUGL	Mugler
R021	NARC	Narciso Rodriguez
R022	JOML	Jo Malone
R023	CREE	Creed
R024	MONT	Montblanc
R025	DGSQ	Dolce & Gabbana
R026	KENZ	Kenzo
R027	CHLO	Chloé
R028	MARC	Marc Jacobs
R029	LOEW	Loewe
R030	ISSM	Issey Miyake
R031	VALE	Valentino
R032	BOTV	Bottega Veneta
R033	LART	LArtisan Parfumeur
R034	SERG	Serge Lutens
R035	LELA	Le Labo
R036	BYRE	Byredo
R037	MAFK	Maison Francis K.
R038	DIPT	Diptyque
R039	KILI	Kilian
R040	GUER	Guerlain
R041	ACQU	Acqua di Parma
R042	ELIE	Elie Saab
R043	AZZA	Azzaro
R044	NINA	Nina Ricci
R045	CART	Cartier
R046	PENH	Penhaligon's
R047	CLIN	Clinique
R048	SHIS	Shiseido
R049	ZADI	Zadig & Voltaire
R050	MOSC	Moschino
R051	LACO	Lacoste
R052	VIKR	Viktor & Rolf
R053	ROCH	Rochas
R054	BALN	Balenciaga
R055	JIMC	Jimmy Choo
R056	ESCA	Escada
R057	TIFF	Tiffany & Co.
R058	COAC	Coach
R059	TOMH	Tommy Hilfiger
R060	DKNY	DKNY
R061	ARDE	Elizabeth Arden
R062	JILS	Jil Sander
R063	LANV	Lanvin
R064	MOLB	Molton Brown
R065	AVON	Avon
R066	YARO	Yves Rocher
R067	LOCI	L'Occitane
R068	BODY	The Body Shop
R069	NATU	Natura
R070	OBOT	O Boticário
R071	ESIK	Ésika
R072	LBEL	L'Bel
R073	CYZO	Cyzone
R074	FRSH	Fresh
R075	KIEH	Kiehl's
R076	AESO	Aesop
R077	CLAR	Clarins
R078	BIOT	Biotherm
R079	ORIG	Origins
R080	CAUD	Caudalie
R081	PHIL	Philosophy
R082	NEUT	Neutrogena
R083	NIVE	Nivea
R084	DOVE	Dove
R085	OLAY	Olay
R086	PANT	Pantene
R087	GARN	Garnier
R088	LORE	L'Oréal Paris
R089	MAYB	Maybelline
R090	REVL	Revlon
R091	BOUR	Bourjois
R092	RIMM	Rimmel London
R093	MACM	MAC Cosmetics
R094	NARS	NARS Cosmetics
R095	BENE	Benefit Cosmetics
R096	URBD	Urban Decay
R097	AMOU	Amouage
R098	BND9	Bond No. 9
R099	BKIL	By Kilian
R100	CLCH	Clive Christian
R101	FRMA	Frederic Malle
R102	INPF	Initio Parfums P.
R103	JOLO	Jo Loves
R104	JUHG	Juliette Has A Gun
R105	MEMP	Memo Paris
R106	NASO	Nasomatto
R107	NISH	Nishane
R108	PDMA	Parfums de Marly
R109	ROJA	Roja Parfums
R110	SMNV	Santa Maria Novella
R111	TITE	Tiziana Terenzi
R112	XERJ	Xerjoff
R113	ESMO	Escentric Molecules
R114	CDGP	Comme des Garçons P
R115	ETRO	Etro
R116	FLRL	Floris London
R117	ANGO	Annick Goutal
R118	ATKI	Atkinsons
R119	CARO	Caron
R120	HOUB	Houbigant
R121	LUBI	Lubin
R122	MIHA	Miller Harris
R123	ORJA	Ormonde Jayne
R124	ROPI	Robert Piguet
R125	TDCO	The Different Comp.
R126	COSP	Comptoir Sud Pacif.
R127	MANC	Mancera
R128	MONA	Montale
R129	RAMN	Ramon Monegal
R130	HISP	Histoires de Parfum
R131	ETLD	Etat Libre dOrange
R132	KEPA	Keiko Mecheri
R133	LMPO	LM Parfums
R134	MAZZ	Mazzolari
R135	NEZO	Nez a Nez
R136	OLPR	Olfactive Studio
R137	PDRS	Parfumerie Generale
R138	PRNY	Profumum Roma
R139	SOSO	Sospiro Parfums
R140	STDU	Stephane Humbert L.
R141	XNIC	Ex Nihilo
R142	ZOOP	Zoologist Perfumes
R143	MDCI	MDCI Parfums
R144	PGAN	Phaedon Paris
R145	AJAR	Aedes de Venustas
R146	VCAH	Van Cleef & Arpels
R147	LILI	Liliana Fragrances
R148	ELAR	Elara Scents
R149	ORIO	Orion Perfumes
R150	AURA	AuraSphere
R151	NOCT	Nocturne Essences
R152	SOLS	Solstice Aromas
R153	ELYS	Elysian Fields
R154	ZEPH	Zephyr Notes
R155	CRYS	Crystal Bloom
R156	VELV	Velvet Whisper
R157	SILK	Silken Mist
R158	LUNA	Lunar Glow Parfum
R159	STER	Stellar Dust Co.
R160	NEBU	Nebula Fragrance
R161	TERR	Terra Firma Scents
R162	AQUA	Aqua Vitae Parfum
R163	IGNI	Ignis Ardens
R164	VENT	Ventus Spiritus
R165	FLOR	Floralia Maxima
R166	SYLV	Sylva Origins
R167	URBA	Urban Elixir
R168	RURA	Rurari Essence
R169	MAJS	Majestic Oud
R170	SERE	Serene Petals
R171	VIBR	Vibrant Citrus
R172	OPUL	Opulent Amber
R173	RADI	Radiant Musk
R174	MYST	Mystic Woods Co.
R175	ENIG	Enigma Parfum
R176	DREA	Dream Weaver Scent
R177	MEMO	Memory Lane Aroma
R178	ECHO	Echoes of Nature
R179	WHIM	Whimsical Spritz
R180	ARCA	Arcane Formulations
R181	LEGE	Legendary Aromas
R182	ETHE	Ethereal Blends
R183	DIVI	Divine Nectars
R184	IMPE	Imperial Collection
R185	ROYA	Royal Essence Ltd.
R186	NOBL	Noble Spirit Parfum
R187	PURE	Purest Formulations
R188	ARTN	Artisan Scents Co.
R189	EXCL	Exclusif Aromatique
R190	SIGN	Signature Blends
R191	UNIK	Unik Parfums
R192	VANG	Vanguard Fragrance
R193	CLAS	Classic Notes Co.
R194	MODE	Modern Aromas Inc.
R195	TIME	Timeless Elixirs
R196	FUTR	FutureScents Lab
R197	HERI	Heritage Perfumery
R198	INNO	Innovate Aromatics
R199	TRAD	Tradition Parfumee
R200	ALCH	Alchemy Aromas
R201	ESSE	Essentia Pura
R202	MAGN	Magnum Opus Parfum
R203	QUIA	Quintessence Art
R204	RENA	Renaissance Scents
R205	BARO	Baroque Elixirs
R206	ROCO	Rococo Perfumes
R207	NEOC	NeoClassic Aromas
R208	AVGR	AvantGarde Scent
R209	MINI	Minimalist Notes
R210	BOHO	Bohemian Spirit Co
R211	LUXE	Luxe Aura
R212	GLAM	Glamour Essence
R213	CHIC	Chic Parfumerie
R214	ELEG	Elegant Expressions
R215	SOPI	Sophisticate Aroma
R216	POWE	Powerhouse Scents
R217	SEDU	Seduction Elixir
R218	PASS	Passion Fruit Co.
R219	VANL	Vanilla Dreams Inc.
R220	ROSE	Rose Garden Parfum
R221	JASM	Jasmine Bloom Ltd.
R222	SAND	Sandalwood Secret
R223	AMBR	Amber Glow Aromas
R224	MUSK	Musketeer Scents
R225	CITR	Citrus Burst Co.
R226	HERB	Herbal Infusion P.
R227	SPIC	Spice Route Aroma
R228	WOOD	Woodland Notes
R229	OCEA	Ocean Breeze Scent
R230	MOUN	Mountain Air Co.
R231	FORE	Forest Whisper P.
R232	DESE	Desert Mirage
R233	ISLA	Island Paradise Co
R234	TROP	Tropical Nectar
R235	EXOT	Exotic Journey P.
R236	ADVE	Adventure Spirit S.
R237	URBN	Urbanite Collection
R238	COSM	Cosmopolitan Aroma
R239	GLOB	Global Essence Ltd.
R240	NITE	Nightfall Parfum
R241	DAWN	Dawn Chorus Scents
R242	TWIL	Twilight Mist Co.
R243	MIDN	Midnight Bloom P.
R244	DAYL	Daylight Radiance
R245	SUMM	Summer Solstice S.
R246	WINT	Winter Embrace Co.
R247	AUTU	Autumn Leaves P.
R248	SPRI	Spring Blossom Ltd.
R249	SEAS	Seasonal Scents
R250	CELE	Celestial Aromas
R251	GALA	Galaxy Perfumes
R252	COMT	Comet Tail Scents
R253	STAR	Stardust Elixirs
R254	ASTR	Astral Projection P
R255	ORBI	Orbital Notes Co.
R256	COSN	Cosmic Nectar Ltd.
R257	VOID	Void Fragrances
R258	DIMN	Dimension Shift S.
R259	PARA	Parallel Universe P
R260	FANT	Fantasy Realm Co.
R261	MYTH	Mythic Legends P.
R262	FAER	Faerie Glen Scents
R263	DRAG	Dragons Breath Ltd.
R264	PHOE	Phoenix Ash Parfum
R265	UNIC	Unicorn Horn Co.
R266	GRIF	Griffin Feather S.
R267	MERM	Mermaid Song P.
R268	ELVE	Elven Woods Ltd.
R269	VAMP	Vampire Kiss Co.
R270	WERE	Werewolf Musk P.
R271	ZOMB	Zombie Zest Scents
R272	GHOS	Ghostly Whisper P.
R273	ANGE	Angel Wing Co. Ltd
R274	DEMO	Demon Charm Parfum
R275	SPIR	Spirit Guide S.
R276	SOUL	Soulmate Essence
R277	KARMA	Karma Balance Co.
R278	DEST	Destiny Weaver P.
R279	FATE	Fate & Fortune Ltd
R280	LUCK	Lucky Charm Scents
R281	PROV	Providence Parfum
R282	SERN	Serendipity Co.
R283	BLIS	Blissful Moments P
R284	JOYF	Joyful Spirit Ltd.
R285	PEAC	Peaceful Mind Co.
R286	HAPP	Happiness in Bottle
R287	LOVE	Love Potion No. 10
R288	FRIE	Friendship Bond P.
R289	FAMI	Family Ties Scents
R290	HOME	Homeward Bound Co.
R291	COMF	Comfort Zone P.
R292	SAFE	Safe Haven Aromas
R293	TRAN	Tranquil Escape S.
R294	RELA	Relaxation Station
R295	MEDI	Meditative Moods P
R296	YOGA	Yoga Flow Scents
R297	ZENF	Zen Garden Co. Ltd
R298	ENER	Energy Boost Parfum
R299	VITA	Vitality Spark S.
R300	REJU	Rejuvenate Me Co.
R301	REFR	Refresh & Revive P
R302	INVI	Invigorate Ltd.
R303	MOTI	Motivation Mist S.
R304	INSP	Inspiration Spark P
R305	CREA	Creativity Flow Co
R306	FOCU	Focus Point Aromas
R307	CLAR	Clarity Essence S.
R308	WISD	Wisdom Seeker P.
R309	KNOW	Knowledge Nectar
R310	TRUT	Truth Serum Scents
R311	HONE	Honesty Parfum Co.
R312	INTE	Integrity Blends P
R313	COUR	Courageous Spirit
R314	BRAV	Braveheart Aromas
R315	STRO	Strong Will Co. S.
R316	RESI	Resilience Parfum
R317	HOPE	Hopeful Horizon P.
R318	DREM	Dreamcatcher Ltd.
R319	AMBT	Ambition Fuel Co.
R320	SUCC	Success Story S.
R321	VICT	Victory Lap Parfum
R322	CHMP	Champion Spirit P.
R323	LEAD	Leadership Aura
R324	INFL	Influence Essence S
R325	CHAR	Charisma Factor Co
R326	MAGT	Magnetic Pull P.
R327	ALLU	Allure Mystique S.
R328	CAPT	Captivate Me Ltd.
R329	FASC	Fascination Co. P.
R330	TEMP	Temptation Isle S.
R331	DESI	Desire Path Parfum
R332	INTR	Intrigue Aromas P.
R333	MYSR	Mystery Unveiled S
R334	SECR	Secret Garden Co.
R335	HIDO	Hidden Treasure P.
R336	FORB	Forbidden Fruit S.
R337	RARE	Rare Gem Parfum
R338	PREC	Precious Metals P.
R339	DIAM	Diamond Dust Co. S
R340	GOLD	Golden Elixir Ltd.
R341	SILV	Silver Lining P.
R342	PLAT	Platinum StandardS
R343	CRWN	Crown Jewel Parfum
R344	SCEP	Scepter of Power P
R345	THRO	Throne Room Aromas
R346	EMPI	Empire Builder S.
R347	KING	Kingdom Come Co. P
R348	QUEE	Queen Bee Parfum
R349	PRIN	Princely Charm S.
R350	DUCH	Duchess Grace Ltd.
R351	EARL	Earl Grey Notes P.
R352	BARN	Baron Von Scent
R353	KNIG	Knight's Valor Co.
R354	LADY	Lady Luck Parfum S
R355	LORD	Lord of Aromas P.
R356	MAID	Maiden Fair Scents
R357	WARR	Warrior Spirit Co.
R358	MAGE	Mage's Mysterium P
R359	ALCM	Alchemist's Brew S
R360	SCRI	Scribe's Ink Ltd.
R361	POET	Poet's Muse Parfum
R362	ARTT	Artist's Palette P
R363	MUSI	Musician's Harmony
R364	DANC	Dancer's Rhythm S.
R365	ACTO	Actor's SpotlightP
R366	FILM	Filmmaker's Dream
R367	WRIT	Writer's Block Co.
R368	READ	Reader's Nook S.
R369	LIBR	LibraryWhispers P.
R370	BOOK	Bookworm Aromas
R371	PAPR	Paper & Quill Ltd.
R372	INKW	Inkwell Dreams P.
R373	QUIK	Quill & Scroll S.
R374	MANU	Manuscript Memories
R375	STOR	Storyteller's Co P
R376	TALE	Tale Weaver Parfum
R377	FABL	Fable & Fantasy S.
R378	LEGD	Legend & Lore Co.
R379	FOLK	Folklore Fragrance
R380	TRVL	Traveler's Joy P.
R381	EXPL	Explorer's SpiritS
R382	ADVT	Adventurer's Call
R383	VOYA	Voyager's CompassP
R384	NOMD	Nomad's Heart Co.
R385	WAND	Wanderlust Aromas
R386	PATH	Pathfinder ParfumS
R387	JOUR	Journey Within Ltd
R388	DESTN	Destination Unknown
R389	HORZ	Horizon Line P.
R390	ROAD	Road Less Traveled
R391	MAPS	Mapmaker's ScentS
R392	COMP	Compass Rose Co. P
R393	NAVY	Navigator's Notes
R394	SAIL	Sailor's Delight S
R395	SHIP	Shipwreck Bay P.
R396	PORT	Port of Call Co.
R397	HARB	Harbor Lights Ltd.
R398	BEAC	Beacon Point P.
R399	ANCH	Anchor & Hope S.
R400	WAVE	Wavecrest Parfum
R401	TIDE	Tidal Bloom Co. P.
R402	REEF	Coral Reef DreamsS
R403	SHELL	Seashell Whisper L
R404	PEAR	Pearl Diver Parfum
R405	SANDD	Sand Dune AromasP
R406	BEAH	Beach Day Scents S
R407	SUNC	Sunken Treasure Co
R408	COAS	Coastal Breeze P.
R409	ISLE	Isle of Skye Ltd.
R410	LAGO	Lagoon Secret S.
R411	RIVR	Riverbend Parfum P
R412	LAKE	Lakeside Morning S
R413	STRM	Stream & Stone Co.
R414	WATR	Waterfall Mist P.
R415	FOUN	Fountain of YouthS
R416	SPRG	Springwater FreshL
R417	DEWP	Dewdrop Blossom P.
R418	RAIN	Rainforest Dew CoS
R419	MIST	Misty Mountain Ltd
R420	FOGG	Fog & Fern ParfumP
R421	CLOD	Cloud Nine ScentsS
R422	SKYE	Skylight AromasCo
R423	SUNB	Sunbeam Essence P.
R424	MOON	Moonflower PetalsS
R425	STLG	Starlight Gleam Lt
R426	AURR	Aurora Borealis P
R427	TWLG	Twilight Shimmer S
R428	NITEF	Nightfall MagicCo
R429	DAWNBR	Dawnbringer Parfum
R430	SUNR	Sunrise Glow P.
R431	SSET	Sunset Serenade S.
R432	NOON	Noonday Heat Ltd.
R433	EVEG	Evening Star Co. P
R434	MDNTG	Midnight Garden S.
R435	BLUEH	Blue Hour Parfum
R436	GOLDH	Golden Hour Ltd.P
R437	SILVH	Silver Hour Scents
R438	WHITN	White Nights Co. S
R439	DARKN	Darkest Night P.
R440	LITEN	Lightness of Being
R441	SHAD	Shadow Play ParfumS
R442	REFL	Reflection PoolCo
R443	ECHOE	Echoing Cavern P.
R444	WHISP	Whispering Wind S.
R445	SILE	Silent Forest Ltd
R446	STIL	Still Waters P.
R447	CALM	Calm Sea Aromas S.
R448	SEREN	Serene Meadow Co.
R449	PEACF	Peaceful Valley P
R450	BLISS	Blissful HeightsS
R451	JOYB	Joyful Noise Ltd.
R452	HAPIN	Happiness Found P.
R453	LAUGH	Laughter Lines CoS
R454	SMILE	Smile Awhile Ltd.
R455	POSIT	Positive Vibes P.
R456	OPTIM	Optimist Heart S.
R457	GRATE	Grateful SpiritCo
R458	THANK	Thankful ThoughtsP
R459	BLESS	Blessed Aromas S.
R460	FAITH	Faith & Flowers L.
R461	TRUST	Trustworthy NotesP
R462	LOYAL	Loyalty Parfum CoS
R463	HONOR	Honor & Grace Ltd
R464	VIRT	Virtue Scents P.
R465	NOBIL	Nobility Aromas S.
R466	PURIT	Purity Essence Co.
R467	INNOC	Innocence Found P.
R468	SIMP	Simplicity ScentsS
R469	MINML	Minimalist TouchL
R470	ESSNL	Essential Being P.
R471	COREV	Core Values Co. S.
R472	TRUEV	True North Ltd. P
R473	AUENT	Authentic Self S.
R474	INDIV	Individuality Co.
R475	UNQNE	Uniqueness ParfumP
R476	ORIGL	Originality Scents
R477	CRETV	Creative SparkLtd
R478	IMAGI	Imagination Co. P.
R479	VISIO	Visionary AromasS
R480	DREAM	Dreamscape ParfumL
R481	FANTAS	Fantasia Notes P.
R482	WOND	Wonderlust Co. S.
R483	MAGCL	Magical ThinkingP
R484	ENCHA	Enchanted ForestS
R485	SPELL	Spellbound AromasL
R486	CHARM	Charmed Life Co. P
R487	AMULT	Amulet Scents S.
R488	TALIS	Talisman ParfumLtd
R489	FORTN	Fortuna's Favor P
R490	PROSP	Prosperity EssenceS
R491	ABUND	Abundance Co. Ltd.
R492	WEALT	Wealth & Wisdom P.
R493	LUXUR	Luxuria Aromas S.
R494	OPULN	Opulence Parfum Co
R495	RICHN	Richness of Spirit
R496	GRAND	Grandeur Scents P.
R497	MAJES	Majesty Parfum Ltd
R498	REGAL	Regalia Aromas Co.
R499	SOVER	Sovereign EssenceS
R500	IMPRL	Imperium Parfum P.
R501	DYNAS	Dynasty Scents Ltd
R502	NOBLES	Noblesse Oblige Co
R503	ARIST	Aristocrat AromasS
R504	ELITE	Elite Collection P
R505	PREST	Prestige ParfumLtd
R506	ULTIM	Ultimate Essence S
R507	PERFE	Perfection Co. P.
R508	IDEAL	Ideal FormulationsS
R509	FLAWL	Flawless Finish L.
R510	EXCEL	Excellence ParfumP
R511	SUPRM	Supreme Aromas CoS
R512	TOPTR	Top Tier Scents L.
R513	APEXN	Apex Notes ParfumP
R514	ZENIT	Zenith CollectionS
R515	SUMMI	Summit Aromas Co.
R516	PEAKP	Peak Performance P
R517	HIGHL	Highland Mist S.
R518	LOWLA	Lowland Bloom Ltd
R519	VALLY	Valley Dew ParfumP
R520	PLAIN	Plainsong AromasS
R521	MEADW	Meadow Gold Co. L.
R522	GRASS	Grassroots ParfumP
R523	EARTH	Earthen Vessels S.
R524	TERRA	Terra Firma II Co.
R525	STONE	Stone Circle P.
R526	ROCKC	Rock Crystal Ltd.S
R527	MINER	Mineral Spring P.
R528	GEMST	Gemstone Essence S
R529	AMETH	Amethyst Dream Co.
R530	SAPHI	Sapphire Sky P.
R531	RUBYE	Ruby Ember Ltd. S.
R532	EMERA	Emerald Forest P.
R533	OPALM	Opal Mist Parfum S
R534	JADEW	Jade Whisper Co. L
R535	TOPAZ	Topaz Sun Parfum P
R536	GARNT	Garnet Glow Aromas
R537	AQUAM	Aquamarine Deep S.
R538	PERID	Peridot Leaf Co. P
R539	CITRN	Citrine Zest Ltd.S
R540	TURQU	Turquoise Bay P.
R541	MOONS	Moonstone Magic S.
R542	SUNST	Sunstone RadianceC
R543	LABRA	Labradorite FlashP
R544	TIGER	Tiger Eye Parfum S
R545	OBSID	Obsidian Night Ltd
R546	QUART	Quartz Clear Co. P
R547	AGATE	Agate Earth TonesS
R548	JASPR	Jasper Stone Ltd.
R549	MALAC	Malachite Swirl P.
R550	LAPIS	Lapis Lazuli Co. S
R551	AZURI	Azurite Sky Ltd. P
R552	FLOUR	Fluorite Dreams S.
R553	SELEN	Selenite Moon Co.
R554	CALCI	Calcite Glow P.
R555	PYRIT	Pyrite Spark Ltd.S
R556	HEMAT	Hematite Ground P.
R557	RHODO	Rhodochrosite Love
R558	KUNZI	Kunzite Spirit CoS
R559	MORGA	Morganite Heart P.
R560	HELIOD	Heliodor Sun Ltd.S
R561	SPNEL	Spinel Fire Parfum
R562	ZIRCO	Zircon BrillianceP
R563	IOLIT	Iolite Vision Co.S
R564	APATI	Apatite Clarity L.
R565	KYANI	Kyanite Flow P.
R566	CHYSO	Chrysocolla PeaceS
R567	PREHN	Prehnite Dream Co.
R568	SERAP	Seraphinite Wing P
R569	DANBU	Danburite Light S.
R570	PETAL	Petalite Angel Ltd
R571	PHENK	Phenakite Power P.
R572	MOLDV	Moldavite Star CoS
R573	TEKTI	Tektite Cosmic Ltd
R574	LIBYA	Libyan DesertGlass
R575	SHUNG	Shungite Protect P
R576	AMBERR	Amber Resin Scents
R577	COPAL	Copal Incense Co.S
R578	FRANK	Frankincense Ltd.P
R579	MYRRH	Myrrh Mystique S.
R580	PALOS	Palo Santo WoodCo
R581	SAGEW	White Sage CleanseP
R582	CEDAR	Cedarwood Atlas S.
R583	PINEN	Pine Needle FreshL
R584	JUNIP	Juniper Berry P.
R585	CYPRE	Cypress Grove Co.S
R586	VETIV	Vetiver Earth Ltd.
R587	PATCH	Patchouli Deep P.
R588	YLANG	Ylang Ylang BloomS
R589	NEROL	Neroli Blossom Co.
R590	PETIT	Petitgrain Leaf P.
R591	BERGA	Bergamot Bliss LtdS
R592	LAVEN	Lavender Calm P.
R593	CHAMO	Chamomile Dream S.
R594	ROSEM	Rosemary Focus Co.
R595	PEPPM	Peppermint Rush P.
R596	SPEAM	Spearmint Fresh S.
R597	EUCAL	Eucalyptus Clear L
R598	TEATE	Tea Tree Pure P.
R599	LEMON	Lemon Zest Co. S.
R600	LIMEK	Lime Kickstart Ltd
R601	ORANG	Orange Sun ParfumP
R602	GRAPE	Grapefruit Zing S.
R603	MANDA	Mandarin Joy Co. L
R604	TANGE	Tangerine Dream P.
R605	CLEME	Clementine Kiss S.
R606	YUZUS	Yuzu Sparkle Co. P
R607	PEACH	Peach Blossom LtdS
R608	APRIC	Apricot Nectar P.
R609	PLUMR	Plum Perfection S.
R610	CHERR	Cherry Delight Co.
R611	BERRY	Berry Bliss ParfumP
R612	STRWB	Strawberry FieldsS
R613	RASPB	Raspberry Tart L.
R614	BLUEB	Blueberry Dream P.
R615	BLACK	Blackberry Night S
R616	CRANB	Cranberry CrispCo
R617	FIGUE	Fig & Honey Ltd.P
R618	POMGR	Pomegranate Ruby S
R619	COCON	Coconut Cove Co. L
R620	MANGO	Mango Tango ParfumP
R621	PAPAY	Papaya Paradise S.
R622	GUAVA	Guava Getaway Co.
R623	PINEA	Pineapple Punch P.
R624	LYCHE	Lychee Love Ltd. S
R625	KIWIF	Kiwi Kiss Parfum P
R626	MELON	Melon Meadow S.
R627	WATER	Watermelon SplashC
R628	APPLE	Apple Orchard P.
R629	PEARE	Pear Essence Ltd.S
R630	GRAPT	Grapevine Nectar P
R631	OLIVE	Olive Grove Co. S.
R632	ALMON	Almond Milk Ltd.P
R633	PISTA	Pistachio Cream S.
R634	HAZEL	Hazelnut Haze Co.
R635	WALNU	Walnut Woods P.
R636	CASHE	Cashew Cloud Ltd.S
R637	MACAD	Macadamia Dream P.
R638	COFFE	Coffee Bean BrewS
R639	CHOCO	Chocolate Decadence
R640	CARML	Caramel Swirl P.
R641	HONEY	Honeycomb Nectar S
R642	MAPLE	Maple Morning Co.P
R643	CINNA	Cinnamon Spice Ltd
R644	NUTME	Nutmeg Warmth P.
R645	CLOVE	Clove Ember Co. S.
R646	GINGR	Ginger Zing Ltd. P
R647	CARDA	Cardamom Kiss S.
R648	ANISE	Anise Star Co. P.
R649	FENNL	Fennel Fresh Ltd.S
R650	CORIA	Coriander Seed P.
R651	CUMIN	Cumin Earth Co. S.
R652	TURME	Turmeric Sun Ltd.P
R653	SAFFR	Saffron Gold S.
R654	PAPRI	Paprika Fire Co.
R655	CHILI	Chili Heat ParfumP
R656	BASIL	Basil Garden S.
R657	OREGA	Oregano Hills Ltd
R658	THYME	Thyme Traveler P.
R659	MARJO	Marjoram Meadow S.
R660	DILLW	Dill Weed BreezeCo
R661	TARRA	Tarragon Twist P.
R662	MINTY	Minty Peaks Ltd.S
R663	PARSL	Parsley Patch P.
R664	CILAN	Cilantro Fresh S.
R665	BAYLF	Bay Leaf Manor Co.
R666	JUNGL	Jungle Bloom P.
R667	SAVAN	Savanna Sunset S.
R668	PRAIR	Prairie Wind Ltd.
R669	TUNDR	Tundra Frost P.
R670	ARCTI	Arctic Chill Co.S
R671	VOLCA	Volcanic Ash Ltd.
R672	GEOTH	Geothermal SteamP
R673	CAVER	Cavern Echoes S.
R674	CANON	Canyonlands Co. P
R675	PLATE	Plateau Vista LtdS
R676	SUMMT	Summit Ascent P.
R677	GLACI	Glacier Melt Co.S.
R678	FJORD	Fjord Mist Ltd. P
R679	PENIN	Peninsula BreezeS
R680	ARCHP	Archipelago DreamC
R681	CONTN	Continental DriftP
R682	PANGA	Pangaea Ultima S.
R683	ATLNT	Atlantis Rising L.
R684	LEMUR	Lemuria Lost Co.P
R685	SHAMB	Shambhala ScentsS
R686	ELDOR	El Dorado Gold Ltd
R687	AVALO	Avalon Mist Parfum
R688	CAMEL	Camelot Bloom Co.P
R689	XANAD	Xanadu Pleasure S.
R690	UTOPI	Utopian Garden Ltd
R691	NIRVA	Nirvana State P.
R692	OLYMP	Olympus Heights S.
R693	ASGAR	Asgardian Nectar C
R694	VALHA	Valhalla Valor P.
R695	ELYSIF	Elysian Fields II S
R696	ARCAD	Arcadian Dream L.
R697	EDENP	Garden of Eden P.
R698	SHANG	Shangri-La BlissS
R699	BABYL	Babylonian NightsC
R700	EGYPK	Egyptian King P.
R701	ROMEM	Roman Empire Ltd.S
R702	GREEG	Greek Isles Co. P.
R703	PERSI	Persian Nights S.
R704	MAYAN	Mayan Sun Ltd. Co
R705	AZTEC	Aztec Gold ParfumP
R706	INCAN	Incan Treasure S.
R707	CELTI	Celtic Knot Co. L.
R708	VIKIN	Viking Fury Parfum
R709	SAMUR	Samurai Spirit S.
R710	NINJA	Ninja Stealth Co.P
R711	SPART	Spartan Strength L
R712	GLADT	Gladiator Arena P.
R713	MONKS	Monk's MeditationS
R714	SAGES	Sage Wisdom Co. L.
R715	GURUS	Guru's Guidance P.
R716	SHAMN	Shaman's Journey S
R717	YOGIM	Yogi Master Co. P.
R718	ZENMA	Zen Master Ltd. S.
R719	TAOIS	Taoist Path P.
R720	BUDDH	Buddha Nature Co.S
R721	HINDU	Hindu Deities Ltd
R722	JAPAN	Japanese Garden P
R723	CHINE	Chinese Silk RoadS
R724	INDIA	Indian Spice Co.L.
R725	ARABI	Arabian Desert P.
R726	AFRIC	African Safari S.
R727	EUROP	European EleganceC
R728	AMERI	American Dream P.
R729	AUSSI	Aussie Outback S.
R730	ANTAR	Antarctic Ice Ltd
R731	PACIF	Pacific Wave Co.P
R732	ATLCO	Atlantic Mist S.
R733	MEDIT	Mediterranean SunL
R734	CARIB	Caribbean Rhythm P
R735	BALTI	Baltic Amber Co.S.
R736	NORDI	Nordic Light Ltd.
R737	ALPIN	Alpine Fresh P.
R738	HIMAL	Himalayan Peak S.
R739	ANDESM	Andean Condor Co.L
R740	ROCKY	Rocky Mountain P.
R741	APPAL	Appalachian TrailS
R742	AMAZR	Amazon RainforestC
R743	SAHAR	Sahara Dune Parfum
R744	GOBI	Gobi Desert Wind S
R745	KALAH	Kalahari Sun Ltd.
R746	SERENGETI	Serengeti PlainsP
R747	NILEV	Nile Valley Co.S.
R748	CONGO	Congo River Ltd. P
R749	DANUB	Danube Waltz Scents
R750	VOLGA	Volga River Co. L.
R751	RHINE	Rhinegold Parfum P
R752	YANGT	Yangtze Dragon S.
R753	MEKON	Mekong Delta Ltd.
R754	GANGA	Ganges Spirit Co.P
R755	INDUS	Indus Valley S.
R756	TIGRI	Tigris & Euphrates
R757	JORDN	Jordan River Ltd.P
R758	THAME	Thames Fog Co. S.
R759	SEINE	Seine Romance Ltd.
R760	TIBER	Tiber River P.
R761	POVAL	Po Valley Bloom S.
R762	LOIRE	Loire Chateau Co.P
R763	EBROV	Ebro Valley Ltd. S
R764	ODERV	Oder River ParfumP
R765	VISTL	Vistula River S.
R766	DNIEP	Dnieper River Co.L
R767	DONRV	Don River Parfum P
R768	URALR	Ural River ScentsS
R769	LENAR	Lena River Co. Ltd
R770	YENIS	Yenisei River P.
R771	AMURR	Amur River S.
R772	OBRIV	Ob River Co. Ltd.P
R773	MISSY	Mississippi DeltaS
R774	MISSO	Missouri River CoL
R775	OHIOR	Ohio River ParfumP
R776	COLOR	Colorado River S.
R777	RIOGR	Rio Grande Co. Ltd
R778	YUKON	Yukon Gold ParfumP
R779	MACKE	Mackenzie River S.
R780	STLWR	St. Lawrence Co. L
R781	ORINO	Orinoco Flow P.
R782	PARAN	Paraná River S.
R783	MAGDA	Magdalena River Co
R784	CAUCA	Cauca Valley Ltd.P
R785	ATRTO	Atrato River S.
R786	SINFO	Sinú River ParfumL
R787	BAUDO	Baudó River Co. P.
R788	PATIA	Patía River ScentsS
R789	GUAVR	Guaviare River Ltd
R790	VAUPE	Vaupés River P.
R791	INIRI	Inírida River S.
R792	PUTUM	Putumayo River CoP
R793	CAQUE	Caquetá River LtdS
R794	APAPO	Apaporis River P.
R795	NEGRO	Rio Negro Scents S
R796	CASIQ	Casiquiare Canal L
R797	META	Meta River Parfum P
R798	ARACA	Arauca River Co. S
R799	APURE	Apure River Ltd.
R800	CHICM	Chicamocha CanyonP
R801	SUARE	Suárez River Ltd.S
R802	SOGAM	Sogamoso River CoP
R803	CESAR	Cesar River S.
R804	RANCH	Ranchería River Lt
R805	SINMA	Sinu River Delta P
R806	SANJO	San Jorge River S.
R807	NECHI	Nechí River Co. L.
R808	PORCE	Porce River Parfum
R809	GUATP	Guatapé River S.
R810	SAMAN	Samaná River Co. P
R811	LACLA	La Clara River Ltd
R812	LAMIEL	La Miel River P.
R813	COCORN	Cocorná River S.
R814	NUAQU	Nuquí River Co. P.
R815	JURAD	Juradó River Ltd.S
R816	TRUAN	Truandó River P.
R817	SALAD	Salado River Co. S
R818	MIRAFL	Miraflorez River L
R819	TEQUEN	Tequendama Falls P
R820	IGUAZ	Iguazú Falls S.
R821	ANGEL	Angel Falls Co. L.
R822	NIAGA	Niagara Falls P.
R823	VICTOF	Victoria Falls S.
R824	YOSEM	Yosemite Falls CoP
R825	KAIET	Kaieteur Falls Ltd
R826	SUTHER	Sutherland Falls P
R827	TUGEL	Tugela Falls Scents
R828	GOCTA	Gocta Falls Co.Ltd
R829	MARDA	Mardalsfossen P.
R830	RHINEF	Rhine Falls S.
R831	DETTI	Dettifoss Co. LtdP
R832	GULLF	Gullfoss Parfum S.
R833	SKOGA	Skógafoss Co. Ltd.
R834	SELJA	Seljalandsfoss P.
R835	HAVAS	Havasu Falls Scents
R836	PLITV	Plitvice Lakes Ltd
R837	BANFF	Banff Springs P.
R838	JASPRN	Jasper National Pk
R839	YELLO	Yellowstone Co. L.
R840	GRANDC	Grand Canyon P.
R841	ZIONP	Zion Park Scents S
R842	BRYCE	Bryce Canyon Co. L
R843	ARCHS	Arches Park Parfum
R844	CANOL	Canyonlands II S.
R845	DEATH	Death Valley Ltd.
R846	JOSHT	Joshua Tree Co. P.
R847	SEQUO	Sequoia Grove S.
R848	REDWO	Redwood Forest Ltd
R849	OLYMC	Olympic RainforestP
R850	GLACIERNP	Glacier Nat. ParkS
R851	TETON	Grand Teton Co. L.
R852	ACADI	Acadia Coast P.
R853	EVERG	Everglades ParfumS
R854	SMOKY	Smoky Mountains Co
R855	DENAL	Denali Peak Ltd. P
R856	KENAI	Kenai Fjords S.
R857	GLBAY	Glacier Bay Co. L.
R858	HALEA	Haleakala SunriseP
R859	HAWAV	Hawaii Volcanoes S
R860	DRYTO	Dry Tortugas Ltd.
R861	BISCA	Biscayne Bay Co. P
R862	CONGA	Congaree Swamp S.
R863	CUYAH	Cuyahoga Valley L
R864	GATEW	Gateway Arch P.
R865	HOTSP	Hot Springs Co. S.
R866	INDDU	Indiana Dunes Ltd
R867	ISROY	Isle Royale Parfum
R868	KINGS	Kings Canyon Co. P
R869	KOBUK	Kobuk Valley S.
R870	LAKEC	Lake Clark Ltd. P.
R871	LASSN	Lassen Volcanic S.
R872	MAMCA	Mammoth Cave Co. L
R873	MESAV	Mesa Verde ParfumP
R874	MOUNT	Mount Rainier S.
R875	NORCA	North Cascades Ltd
R876	PETRI	Petrified Forest P
R877	PINNA	Pinnacles Co. S.
R878	SAGUA	Saguaro Desert Ltd
R879	SHENN	Shenandoah ValleyP
R880	THEOD	Theodore Roosevelt
R881	VIRGI	Virgin Islands CoS
R882	VOYAG	Voyageurs Parfum L
R883	WHISA	White Sands Co. P.
R884	WINDV	Wind Cave Scents S
R885	WRANG	Wrangell St. Elias
R886	TORRE	Torres del Paine P
R887	IGUAÇ	Iguaçu Nat. Park S
R888	GALAP	Galapagos IslandsL
R889	SERENII	Serengeti II Co. P
R890	NGORO	Ngorongoro CraterS
R891	KRUGE	Kruger Park Ltd. P
R892	MASAI	Masai Mara Co. S.
R893	OKAVA	Okavango Delta Ltd
R894	NAMIB	Namib Desert P.
R895	ETOSH	Etosha Pan ScentsS
R896	DRAKE	Drakensberg Co. L.
R897	ULURU	Uluru Rock ParfumP
R898	KAKAD	Kakadu Park S.
R899	DAINT	Daintree Rainforest
R900	GREBA	Great Barrier Reef
R901	BLUE M	Blue Mountains CoS
R902	FIORDL	Fiordland Nat Park
R903	AORAK	Aoraki Mt Cook Ltd
R904	TONGA	Tongariro Parfum P
R905	ABELT	Abel Tasman Co. S.
R906	PAPAR	Paparoa Park Ltd.
R907	WESTL	Westland Tai PoutP
R908	ARTHP	Arthur's Pass S.
R909	MTASP	Mt Aspiring Co. L.
R910	RAKIU	Rakiura Stewart Is
R911	KAHUR	Kahurangi Park P.
R912	NELSO	Nelson Lakes S.
R913	JIUZH	Jiuzhaigou ValleyC
R914	HUANG	Huangshan Mt. Ltd.
R915	ZHANG	Zhangjiajie Parfum
R916	GUILI	Guilin Karst S.
R917	WULIN	Wulingyuan Co. Ltd
R918	HALON	Ha Long Bay ParfumP
R919	PHANG	Phang Nga Bay S.
R920	KOMOD	Komodo Island Co.L
R921	RAJA	Raja Ampat ParfumP
R922	BOROB	Borobudur SunriseS
R923	PRAMB	Prambanan Temple L
R924	ANGKO	Angkor Wat Co. P.
R925	BAGAN	Bagan Temples S.
R926	TAJMA	Taj Mahal Ltd. P.
R927	PETRA	Petra City ScentsS
R928	MACHU	Machu Picchu Co. L
R929	CHICH	Chichen Itza P.
R930	TEOTI	Teotihuacan S.
R931	PALEN	Palenque Ruins CoP
R932	UXMAL	Uxmal City Ltd. S.
R933	TIKAL	Tikal Jungle P.
R934	COPAN	Copan Ruins Co. S.
R935	EASTE	Easter Island Ltd.
R936	STONEH	Stonehenge Myst P.
R937	NEWGR	Newgrange Light S.
R938	SKARA	Skara Brae Co. Ltd
R939	CARNA	Carnac Stones P.
R940	ALTMIR	Altamira Cave S.
R941	LASCA	Lascaux Cave Co. P
R942	CHAUV	Chauvet Cave Ltd.S
R943	POMPE	Pompeii Ashes P.
R944	HERCU	Herculaneum Co. S.
R945	EPHES	Ephesus Ruins Ltd.
R946	DELPH	Delphi Oracle P.
R947	OLYMA	Olympia Games S.
R948	KNOSS	Knossos LabyrinthC
R949	MYCEN	Mycenae Gold P.
R950	TROYW	Troy War Scents S.
R951	CARTH	Carthage Harbor L.
R952	ALEXL	Alexandria LibraryP
R953	RHODE	Colossus of RhodesS
R954	BABHG	Hanging Gardens Co
R955	ARTEM	Temple of ArtemisP
R956	ZEUST	Statue of Zeus S.
R957	MAUSS	Mausoleum Halicarn
R958	GIZAP	Pyramids of Giza L
R959	SPHIN	Great Sphinx Co. P.
R960	LUXOR	Luxor Temple S.
R961	KARNK	Karnak Temple LtdP
R962	ABUSI	Abu Simbel ScentsS
R963	VALKG	Valley of Kings Co
R964	VALQN	Valley of Queens P
R965	DEADS	Dead Sea MineralsS
R966	MASAD	Masada Fortress L.
R967	QUMRA	Qumran Scrolls CoP
R968	JERUS	Jerusalem Stone S.
R969	NAZAR	Nazareth Bloom Ltd
R970	BETHM	Bethlehem Star P.
R971	GALIL	Sea of Galilee S.
R972	SINAI	Mount Sinai Co. P.
R973	ARART	Mount Ararat Ltd.S
R974	FUJIY	Mount Fuji ParfumP
R975	KILIM	Kilimanjaro Snow S
R976	EVERB	Everest Base CampL
R977	K2SAV	K2 Savage MountainP
R978	ANNAP	Annapurna Co. S.
R979	MATTE	Matterhorn Peak Ltd
R980	MONTB	Mont Blanc II P.
R981	ELBRU	Mount Elbrus S.
R982	ACONC	Aconcagua Co. P.
R983	DENALII	Denali II Ltd. S.
R984	VINSO	Vinson Massif P.
R985	PUNCA	Puncak Jaya Co. S.
R986	KOSCI	Mount Kosciuszko L
R987	BLANC	Blanc Perfumes
R988	NOIRP	Noir Parfums
R989	ROUGE	Rouge Aromas
R990	VERTP	Vert Elixirs
R991	BLEUP	Bleu Scents Co.
R992	JAUNE	Jaune Parfum Ltd.
R993	ORANP	Orange Blossom II S
R994	VIOLE	Violette Dreams Co
R995	INDIG	Indigo Nights P.
R996	AZURE	Azure Sky Scents
R997	CYANS	Cyan Waters Ltd.
R998	MAGEN	Magenta Bloom P.
R999	TEALP	Teal Lagoon Co. S.
\.


                                                                                                                                                                                                                                                                                                      5140.dat                                                                                            0000600 0004000 0002000 00000140400 15014423351 0014240 0                                                                                                    ustar 00postgres                        postgres                        0000000 0000000                                                                                                                                                                        SH03	2023-12-21	Avenida Siempre Viva 742, Yarumal (Antioquia Norte)	0	D	I003	S02
SH49	2024-11-29	Calle 10A # 38-55, Pasto (Nariño Pasto)	0	P	I049	S48
SH01	2023-11-23	Calle Falsa 123, Apto 101, Medellín (Antioquia Central)	0	P	I001	S00
SH02	2023-12-06	Carrera 7 # 80-90, Oficina 302, Andes (Antioquia Suroeste)	0	E	I002	S01
SH04	2024-01-04	Calle 100 # 20-30, Apartadó (Antioquia Urabá)	15	P	I004	S03
SH05	2024-01-11	Transversal 5 # 45-12, Rionegro (Antioquia Oriente)	15	E	P005	S04
SH06	2024-01-19	Diagonal 25G # 95A-55, Barranquilla (Atlántico Metro)	15	D	I006	S05
SH07	2024-01-26	Carrera 43 # 70-10, Sabanagrande (Atlántico Sur)	15	P	I007	S06
SH08	2024-02-03	Calle 116 # 19-50, Puerto Colombia (Atlántico Oriental)	0	E	I008	S07
SH09	2024-02-09	Avenida El Poblado # 5S-150, Bogotá (Bogotá D.C. Centro)	0	D	I009	S08
SH10	2024-02-15	Carrera 27 # 50-10, Bogotá (Bogotá D.C. Norte)	0	P	I010	S09
SH11	2024-02-23	Calle 85 # 11-05, Bogotá (Bogotá D.C. Occidente)	15	E	I011	S10
SH12	2024-03-02	Avenida La Playa # 30-45, Cartagena (Bolívar Costa Norte)	0	D	I012	S11
SH13	2024-03-08	Transversal 70C # 80-12, El Carmen de Bolívar (Montes de María)	15	P	I013	S12
SH14	2024-03-17	Calle 33 # 16-80, Magangué (Bolívar Sur)	15	E	I014	S13
SH15	2024-03-26	Carrera 5 # 60-20, Arjona (Bolívar Dique)	0	D	I015	S14
SH16	2024-04-03	Avenida Circunvalar # 10-50, Tunja (Boyacá Central)	0	P	I016	S15
SH17	2024-04-14	Calle Larga # 2-110, Sogamoso (Boyacá Sugamuxi)	15	E	I017	S16
SH18	2024-04-23	Carrera 100 # 15-30, Chiquinquirá (Boyacá Occidente)	15	D	I018	S17
SH19	2024-05-04	Avenida Oriental # 45-90, Duitama (Boyacá Norte)	15	P	I019	S18
SH20	2024-05-06	Calle 93B # 17-25, Manizales (Caldas Eje Cafetero)	0	E	I020	S19
SH21	2024-05-19	Carrera 33 # 29-15, Salamina (Caldas Norte)	0	D	I021	S20
SH22	2024-05-27	Calle Murillo Toro # 50-11, La Dorada (Caldas Oriente)	0	P	I022	S21
SH23	2024-06-04	Avenida Roosevelt # 39-100, Florencia (Caquetá Florencia)	15	E	I023	S22
SH24	2024-06-11	Calle 45 # 70-80, San Vicente del Caguán (Caquetá Sur)	0	D	I024	S23
SH25	2024-06-23	Carrera 7 # 127-45, Popayán (Cauca Popayán Metro)	15	P	I025	S24
SH26	2024-06-30	Avenida Los Libertadores # 20-30, Santander de Quilichao (Cauca Norte)	15	E	I026	S25
SH27	2024-07-03	Calle 82 # 50-60, Guapi (Cauca Costa Pacífica)	15	D	I027	S26
SH28	2024-07-05	Carrera 66 # 10-25, Valledupar (Cesar Valledupar)	15	P	I028	S27
SH29	2024-07-17	Transversal 39B # 72-11, Aguachica (Cesar Sur)	15	E	I029	S28
SH30	2024-07-21	Avenida Suba # 100-50, Curumaní (Cesar Centro)	15	D	I030	S29
SH31	2024-07-28	Calle 52 # 28-40, Montería (Córdoba Montería)	0	P	I031	S30
SH32	2024-08-03	Carrera 51B # 84-120, Lorica (Córdoba Costa)	0	E	I032	S31
SH33	2024-08-08	Avenida Pasoancho # 80-10, Tierralta (Córdoba Alto Sinú)	0	D	I033	S32
SH34	2024-08-17	Calle 7 Sur # 42-70, Chía (Cundinamarca Sabana Centro)	0	P	I034	S33
SH35	2024-08-26	Carrera 19 # 134-80, Facatativá (Cund. Sabana Occidente)	0	E	I035	S34
SH36	2024-09-02	Avenida González Valencia # 55-22, Girardot (Cund. Girardot)	0	D	I036	S35
SH37	2024-09-08	Calle 98 # 52D-10, Ubaté (Cundinamarca Provincia Ubaté)	0	P	I037	S36
SH38	2024-09-17	Carrera 80 # 13-55, Quibdó (Chocó Atrato Medio)	0	E	I038	S37
SH39	2024-09-21	Circular 4 # 70-05, Bahía Solano (Chocó Costa Pacífica N.)	0	D	I039	S38
SH40	2024-09-30	Avenida Chile # 73-47, Neiva (Huila Neiva)	0	P	I040	S39
SH41	2024-10-04	Calle 45 # 27-90, Pitalito (Huila Sur)	0	E	I041	S40
SH42	2024-10-14	Carrera 46 # 79-150, Uribia (La Guajira Alta Guajira)	0	D	I042	S41
SH43	2024-10-20	Avenida 6N # 25-33, Riohacha (La Guajira Riohacha)	0	P	I043	S42
SH44	2024-10-29	Calle 30A # 80-12, Santa Marta (Magdalena Santa Marta)	0	E	I044	S43
SH45	2024-11-03	Carrera 24 # 82-10, Zona Bananera (Magdalena Zona Bananera)	0	D	I045	S44
SH46	2024-11-09	Avenida QuebradaSeca # 30-05, El Banco (Magdalena Sur)	0	P	I046	S45
SH47	2024-11-12	Calle 76 # 41D-80, Villavicencio (Meta Villavicencio)	0	E	I047	S46
SH48	2024-11-19	Carrera 1 # 44-12, Granada (Meta Ariari)	0	D	I048	S47
SH50	2024-11-30	Avenida El Dorado # 69-76, Tumaco (Nariño Costa Pacífica S.)	0	E	I050	S49
SH51	2024-12-01	Avenida Libertadores # 10-20, Edificio Central, Apto 301, Centro, Cúcuta	0	P	I051	S50
SH52	2024-12-03	Calle 5 # 12-34, Barrio El Centro, Ocaña (Norte de Santander Occidente)	0	E	I052	S51
SH53	2024-12-06	Carrera 14 # 25-16, Apto 202, Armenia (Quindío Armenia y Montenegro)	0	D	I053	S52
SH54	2024-12-09	Vereda La Cabaña, Finca El Mirador, Salento (Quindío Cordillera)	15	P	I054	S53
SH55	2024-12-18	Avenida Circunvalar # 30-15, Pereira (Risaralda Pereira)	15	E	I055	S54
SH56	2025-01-02	Calle Real # 8-40, La Virginia (Risaralda Occidente)	0	D	I056	S55
SH57	2025-01-06	Carrera 33 # 45-12, Bucaramanga (Santander Bucaramanga Metro)	15	P	I057	S56
SH58	2025-01-17	Finca Las Nubes, Vereda El Hato, Matanza (Santander Soto Norte)	0	E	I058	S57
SH59	2025-01-26	Calle 10 # 5-22, Vélez (Santander Provincia de Vélez)	0	D	I059	S58
SH60	2025-02-04	Avenida Los Estudiantes # 22-10, Barrancabermeja (Santander Barrancabermeja)	0	P	I060	S59
SH61	2025-02-10	Carrera 19 # 25-05, Sincelejo (Sucre Sincelejo y Sabanas)	15	E	I061	S60
SH62	2025-02-23	Calle El Centro # 1-01, Tolú (Sucre Golfo de Morrosquillo)	0	D	I062	S61
SH63	2025-03-03	Avenida Ambalá # 60-30, Ibagué (Tolima Ibagué y Nevados)	15	P	I063	S62
SH64	2025-03-18	Carrera 3 # 10-50, Honda (Tolima Norte)	15	E	I064	S63
SH65	2025-03-23	Calle 8 # 12-18, Chaparral (Tolima Sur)	0	D	I065	S64
SH66	2025-03-31	Transversal 55 # 100-20, Bello (Valle del Cauca - Norte)	0	P	I066	S65
SH67	2025-04-02	Barrio El Bosque, Manzana C Casa 5, Buenaventura (Valle Pacífico)	15	E	I067	S66
SH68	2025-04-08	Calle 30 # 25-10, Palmira (Valle Palmira)	0	D	I068	S67
SH69	2025-04-09	Avenida Principal # 1-23, Arauca (Arauca Capital)	15	P	I069	S68
SH70	2025-04-15	Carrera 10 # 15-05, Saravena (Arauca Sarare)	0	E	I070	S69
SH71	2025-04-21	Calle Las Flores # 20-33, Yopal (Casanare Yopal)	0	D	I071	S70
SH72	2025-04-23	Vereda El Progreso, Lote 7, Paz de Ariporo (Casanare Norte)	15	P	I072	S71
SH73	2025-04-28	Barrio El Centro, Calle 8 # 9-12, Mocoa (Putumayo Mocoa)	0	E	I073	S72
SH74	2025-05-04	Avenida Los Colonos # 45-60, Puerto Asís (Putumayo Bajo)	0	D	I074	S73
SH75	2025-05-11	Sector Sarie Bay, Manzana A Casa 10, San Andrés Isla	15	P	I075	S74
SH76	2025-05-19	Barrio Bottom House, Calle Principal, Providencia Isla	0	E	I076	S75
SH77	2025-05-26	Avenida Amazonas # 10-11, Leticia (Amazonas Leticia)	15	D	I077	S76
SH78	2025-06-01	Carrera 5 # 12-30, Inírida (Guainía Inírida)	15	P	I078	S77
SH79	2025-06-03	Calle de Los Héroes # 1-15, San José del Guaviare (Guaviare San José)	15	E	I079	S78
SH80	2025-06-09	Barrio Centro, Frente al Parque, Mitú (Vaupés Mitú)	15	D	I080	S79
SH81	2025-06-16	Avenida Orinoco # 20-25, Puerto Carreño (Vichada Puerto Carreño)	0	P	I081	S80
SH82	2025-06-22	Calle La Industria # 5-50, Puerto Berrío (Antioquia Magdalena Medio)	0	E	I082	S81
SH83	2025-06-30	Carrera 10 # 3-12, Juan de Acosta (Atlántico Occidente)	0	D	I083	S82
SH84	2025-07-02	Corregimiento de Loba, Finca El Descanso, Mompós (Bolívar Depresión Momposina)	0	P	I084	S83
SH85	2025-07-06	Vereda El Mortiño, Casa 2, Garagoa (Boyacá Provincia de Lengupá)	0	E	I085	S84
SH86	2025-07-14	Calle Real # 15-25, La Dorada (Caldas Magdalena Caldense)	15	D	I086	S85
SH87	2025-07-20	Barrio Las Palmas, Mz B Cs 7, Cartagena del Chairá (Caquetá Medio)	0	P	I087	S86
SH88	2025-07-28	Vereda El Crucero, Almaguer (Cauca Macizo Colombiano)	0	E	I088	S87
SH89	2025-08-03	Calle Principal # 10-01, Agustín Codazzi (Cesar Serranía Perijá)	0	D	I089	S88
SH90	2025-08-11	Carrera 5 # 20-30, Montelíbano (Córdoba San Jorge)	0	P	I090	S89
SH91	2025-08-19	Vereda Mundo Nuevo, Finca La Esperanza, Gachalá (Cundinamarca Guavio)	0	E	I091	S90
SH92	2025-08-31	Corregimiento de Opogodó, Istmina (Chocó San Juan)	15	D	I092	S91
SH93	2025-09-02	Calle 8 # 7-14, Garzón (Huila Centro)	0	P	I093	S92
SH94	2025-09-08	Carrera 12 # 10-05, Maicao (La Guajira Media Guajira)	15	E	I094	S93
SH95	2025-09-16	Calle Las Flores, Barrio Arriba, Ciénaga (Magdalena Ciénaga Grande)	15	D	I095	S94
SH96	2025-09-21	Vereda Caño Amarillo, Finca El Recuerdo, Cumaral (Meta Alto Meta)	15	P	I096	S95
SH97	2025-09-23	Carrera 20 # 15-22, Ipiales (Nariño Cordillera Occidental)	0	E	I097	S96
SH98	2025-09-29	Barrio El Centro, Calle Principal, El Carmen (N. Santander Catatumbo)	0	D	I098	S97
SH99	2025-10-04	Vereda La Bella, Finca El Descanso, La Tebaida (Quindío Zona Plana)	0	P	I099	S98
SJ01	2025-10-06	Carrera 8 # 10-12, Santa Rosa de Cabal (Risaralda Sta Rosa Entorno)	0	E	I100	S99
SJ02	2025-10-13	Calle Real # 5-60, San Gil (Santander Provincia Guanentá)	0	D	I101	T00
SJ03	2025-10-20	Corregimiento El Palmar, Finca La Ilusión, San Benito Abad (Sucre La Mojana)	15	P	I102	T01
SJ04	2025-10-28	Vereda Chenche, Casa #3, Cunday (Tolima Oriente)	0	E	I103	T02
SJ05	2024-03-06	Avenida Las Industrias #10-20, Bello (Antioquia Área Metro Norte)	0	D	I104	T03
SJ06	2024-03-13	Muelle Turístico, Local 5, Puerto Colombia (Atlántico Área Portuaria)	15	P	I105	T04
SJ07	2024-03-20	Carrera 7 con Calle 34, Ed. Tequendama, Bogotá (Bogotá Chapinero Alto)	15	E	I106	T05
SJ08	2024-03-27	Bocagrande, Avenida San Martín #5-50, Cartagena (Bolívar Cgena Histórico)	15	D	I107	T06
SJ09	2024-04-03	Plaza Mayor, Casa Colonial, Duitama (Boyacá Tundama)	0	P	I108	T07
SJ10	2024-04-10	Avenida Santander, Ed. El Cable, Chinchiná (Caldas Risaralda Caldense)	0	E	I109	T08
SJ11	2024-04-17	Barrio El Jardín, Manzana 10 Casa 5, El Doncello (Caquetá Amazonia Norte)	0	D	I110	T09
SJ12	2024-04-24	Vereda El Tierrero, Resguardo Indígena, Inzá (Cauca Tierradentro)	15	P	I111	T10
SJ13	2024-05-01	Finca La Carbonera, Corregimiento La Loma, La Jagua de Ibirico (Cesar Jagua)	0	E	I112	T11
SJ14	2024-05-08	Barrio Venecia, Calle 20 #8-15, Ciénaga de Oro (Córdoba Bajo Sinú)	15	D	I113	T12
SJ15	2024-05-15	Conjunto Residencial El Roble, Casa 20, Fusagasugá (Cund. Sumapaz)	15	P	I114	T13
SJ16	2024-05-22	Corregimiento Pizarro, Casa Principal, Bajo Baudó (Chocó Baudó Región)	0	E	I115	T14
SJ17	2024-05-29	Hacienda El Triunfo, Vereda El Patico, La Plata (Huila Occidente)	0	D	I116	T15
SJ18	2024-06-05	Ranchería Wayuu, Km 5 Vía Uribia, San Juan del Cesar (La Guajira Sur)	15	P	I117	T16
SJ19	2024-06-12	Barrio San Martín, Calle 10 #12-01, Plato (Magdalena Plato y Ribera)	15	E	I118	T17
SJ20	2024-06-19	Parque Natural La Macarena, Centro de Visitantes, La Macarena (Meta Macarena)	15	D	I119	T18
SJ21	2024-06-26	Vereda El Encano, Corregimiento El Encano, Samaniego (Nariño Occ. Montañoso)	0	P	I120	T19
SJ22	2024-07-03	Plaza Principal, Frente a la Catedral, Pamplona (N.Santander Pamplona Región)	0	E	I121	T20
SJ23	2024-07-10	Barrio La Esneda, Manzana G Casa 3, Calarcá (Quindío Calarcá)	0	D	I122	T21
SJ24	2024-07-17	Vereda El Aguacate, Finca La Esperanza, Balboa (Risaralda Balboa y Montaña)	0	P	I123	T22
SJ25	2024-07-24	Parque Principal, Socorro (Santander Provincia Comunera)	0	E	I124	T23
SJ26	2024-07-31	Corregimiento Las Chispas, San Marcos (Sucre San Marcos Región)	15	D	I125	T24
SJ27	2024-08-07	Barrio Centro, Calle del Comercio, Espinal (Tolima Espinal y Llano)	15	P	I126	T25
SJ28	2024-08-14	Parque Principal, Sopetrán (Antioquia Occidente Cercano)	15	E	I127	T26
SJ29	2024-08-21	Urbanización Ciudad del Puerto, Bloque 5 Apto 101, Soledad (Atlántico Soledad)	15	D	I128	T27
SJ30	2024-08-28	Edificio Parque 93, Oficina 1205, Bogotá (Bogotá Usaquén Residencial)	15	P	I129	T28
SJ31	2024-09-04	Zona Industrial Mamonal, Km 8, Bodega Sur, Cartagena (Bolívar Mamonal)	0	E	I130	T29
SJ32	2024-09-11	Hotel Boutique El Olivo, Villa de Leyva (Boyacá Provincia Ricaurte)	0	D	I131	T30
SJ33	2024-09-18	Aeropuerto La Nubia, Oficina de Carga, Palestina (Caldas Palestina Aeropuerto)	15	P	I132	T31
SJ34	2024-09-25	Vereda El Encanto, Finca Villa Andrea, Florencia (Caquetá Rural Florencia)	0	E	I133	T32
SJ35	2024-10-02	Resguardo Indígena de Silvia, Casa Comunal, Silvia (Cauca Silvia Indígena)	15	D	I134	T33
SJ36	2024-10-09	Finca La Bonanza, Vereda Las Mercedes, El Copey (Cesar El Copey Agrícola)	15	P	I135	T34
SJ37	2024-10-16	Hacienda El Paraíso, Corregimiento Berástegui, Cereté (Córdoba Cereté Agrícola)	0	E	I136	T35
SJ38	2024-10-23	Inspección de Pradilla, Finca El Recreo, La Mesa (Cundinamarca Tequendama)	0	D	I137	T36
SJ39	2024-10-30	Comunidad El Morro, Litoral del San Juan (Chocó Litoral San Juan)	0	P	I138	T37
SJ40	2024-11-06	Finca Villa Natalia, Vereda Zuluaga, Gigante (Huila Gigante y Represa)	0	E	I139	T38
SJ41	2024-11-13	Salinas de Manaure, Comunidad Wayuu, Manaure (La Guajira Manaure Salinero)	15	D	I140	T39
SJ42	2024-11-20	Finca El Delirio, Corregimiento de Palermo, Ariguaní (Magdalena Ariguaní Ganadero)	0	P	I141	T40
SJ43	2024-11-27	Hotel Campestre Las Heliconias, Puerto López (Meta Puerto López Llanero)	0	E	I142	T41
SJ44	2024-12-04	Vereda El Motilón, Finca El Arrayán, La Unión (Nariño La Unión Cafetera)	15	D	I143	T42
SJ45	2024-12-11	Corregimiento de La Ermita, Villa del Rosario (N.Santander Villa del Rosario)	15	P	I144	T43
SJ46	2024-12-18	Finca El Mirador, Vereda El Caimo, Filandia (Quindío Filandia Turístico)	15	E	I145	T44
SJ47	2024-12-26	Hacienda Marsella, Vereda La Estrella, Marsella (Risaralda Marsella Cafetera)	15	D	I146	T45
SJ48	2025-01-02	Hotel Colonial, Calle Real, Girón (Santander Girón Colonial)	15	P	I147	T46
SJ49	2025-01-09	Finca La Victoria, Corregimiento Don Alonso, Corozal (Sucre Corozal Ganadero)	15	E	I148	T47
SJ50	2025-01-16	Hotel Girardot Resort, Melgar (Tolima Melgar Turístico)	15	D	I149	T48
SJ51	2025-01-23	Mina El Silencio, Vereda La Clara, Segovia (Antioquia Nordeste Minero)	15	P	I150	T49
SJ52	2025-01-30	Zona Industrial, Bodega #15, Malambo (Atlántico Malambo Industrial)	0	E	I151	T50
SJ53	2025-02-06	Barrio Restrepo, Calle 15 Sur #20-10, Bogotá (Bogotá Kennedy Popular)	0	D	I152	T51
SJ54	2025-02-13	Urbanización El Golf, Casa 25, Turbaco (Bolívar Turbaco Cercano)	0	P	I153	T52
SJ55	2025-02-20	Hotel Hacienda El Salitre, Paipa (Boyacá Paipa Turístico)	0	E	I154	T53
SJ56	2025-02-27	Finca El Recuerdo, Vereda El Oro, Anserma (Caldas Anserma Occidente)	15	D	I155	T54
SJ57	2025-03-06	Hacienda La Vorágine, Puerto Rico (Caquetá Puerto Rico Ganadero)	0	P	I156	T55
SJ58	2025-03-13	Resguardo Indígena de Pescador, Piendamó (Cauca Piendamó Central)	15	E	I157	T56
SJ59	2025-03-20	Estación de Servicio El Cruce, Bosconia (Cesar Bosconia Cruce Caminos)	0	D	I158	T57
SJ60	2025-03-27	Finca La Fortuna, Vereda El Sabanal, Planeta Rica (Córdoba Planeta Rica Ganadero)	0	P	I159	T58
SJ61	2025-04-03	Hotel Campestre La Casona, Villeta (Cundinamarca Villeta Gualivá)	0	E	I160	T59
SJ62	2025-04-10	Mina de Oro El Tambo, Istmina (Chocó Istmina Minero)	15	D	I161	T60
SJ63	2025-04-17	Finca La Esmeralda, Vereda El Mesón, Pital (Huila Pital Agrícola)	0	P	I162	T61
SJ64	2025-04-24	Comunidad El Dividivi, Vía Riohacha, Fonseca (La Guajira Fonseca Agrícola)	15	E	I163	T62
SJ65	2025-05-01	Finca El Encanto, Corregimiento El Horno, Fundación (Magdalena Fundación Agrícola)	15	D	I164	T63
SJ66	2025-05-08	Hotel Llanero, Acacías (Meta Acacías Petrolero)	0	P	I165	T64
SJ67	2025-05-15	Plaza de Mercado Principal, Túquerres (Nariño Túquerres Altiplano)	0	E	I166	T65
SJ68	2025-05-22	Parque Principal, Frente a la Alcaldía, Los Patios (N.Santander Los Patios Metro)	15	D	I167	T66
SJ69	2025-05-29	Parque del Café, Montenegro (Quindío Montenegro Parque del Café)	15	P	I168	T67
SJ70	2025-06-05	Zona Industrial La Badea, Bodega Alfa, Dosquebradas (Risaralda Dosquebradas Ind.)	15	E	I169	T68
SJ71	2025-06-12	Centro Comercial Cañaveral, Local 205, Floridablanca (Santander Floridablanca Metro)	0	D	I170	T69
SJ72	2025-06-19	Hotel Cabañas de Coveñas, Coveñas (Sucre Coveñas Turístico)	0	P	I171	T70
SJ73	2025-06-26	Finca Cafetera El Portal, Vereda China Alta, Líbano (Tolima Líbano Cafetero)	15	E	I172	T71
SJ74	2025-07-03	Parque Principal, Jardín (Antioquia Jardín Suroeste)	0	D	I173	T72
SJ75	2025-07-10	Plaza Central, Sabanalarga (Atlántico Sabanalarga Central)	0	P	I174	T73
SJ76	2025-07-17	Barrio 20 de Julio, Calle 27 Sur #5-10, Bogotá (Bogotá Suba Residencial)	15	E	I175	T74
SJ77	2025-07-24	Malecón del Río, Mompós (Bolívar Mompós Histórico Fluvial)	15	D	I176	T75
SJ78	2025-07-31	Hotel Colonial, Soatá (Boyacá Soatá Norte)	0	P	I177	T76
SJ79	2025-08-07	Hacienda Venecia, Chinchiná (Caldas Chinchiná Cafetero Ind.)	0	E	I178	T77
SJ80	2025-08-14	Aeropuerto Gustavo Artunduaga, Florencia (Caquetá San Vicente Frontera)	15	D	I179	T78
SJ81	2025-08-21	Finca La Chorrera, Vereda El Tablón, El Tambo (Cauca El Tambo Agrícola)	0	P	I180	T79
SJ82	2025-08-28	Plaza Principal, Aguachica (Cesar Aguachica Comercial Sur)	15	E	I181	T80
SJ83	2025-09-04	Hotel El Descanso, Sahagún (Córdoba Sahagún Sabanero)	15	D	I182	T81
SJ84	2025-09-11	Parque Principal, Cajicá (Cundinamarca Cajicá Almeidas)	0	P	I183	T82
SJ85	2025-09-18	Mina La Esmeralda, Corregimiento Raspadura, Condoto (Chocó Condoto Minero Río)	15	E	I184	T83
SJ86	2025-09-25	Hotel Los Gabrieles, Garzón (Huila Garzón Central Cafetero)	15	D	I185	T84
SJ87	2025-10-02	Mercado Nuevo, Maicao (La Guajira Maicao Comercial Frontera)	15	P	I186	T85
SJ88	2025-10-09	Puerto Fluvial, El Banco (Magdalena El Banco Fluvial Comercial)	0	E	I187	T86
SJ89	2025-10-16	Hotel Campestre La Potra, Granada (Meta Granada Ariari)	0	D	I188	T87
SJ90	2025-10-23	Terminal de Transportes, Ipiales (Nariño Ipiales Frontera Comercial)	0	P	I189	T88
SJ91	2025-10-30	Plaza de Mercado, Ocaña (N.Santander Ocaña Provincial)	15	E	I190	T89
SJ92	2025-11-06	Mirador Alto de la Cruz, Salento (Quindío Salento Turístico Montaña)	0	D	I191	T90
SJ93	2025-11-13	Puerto de La Virginia, La Virginia (Risaralda La Virginia Puerto)	15	P	I192	T91
SJ94	2025-11-20	Parque Gallineral, San Gil (Santander San Gil Aventura)	15	E	I193	T92
SJ95	2025-11-27	Corralejas de Tolú Viejo, Tolú Viejo (Sucre Tolú Viejo Tradicional)	0	D	I194	T93
SJ96	2025-12-04	Puente Navarro, Honda (Tolima Honda Histórico Fluvial)	0	P	I195	T94
SJ97	2025-12-11	Parque Principal, Marinilla (Antioquia Marinilla del Oriente)	0	E	I196	T95
SJ98	2025-12-18	Mina Cerrejón (cercanías), Barrancas (La Guajira Barrancas Minero)	0	D	I197	T96
SJ99	2025-12-26	Centro Mayor Centro Comercial, Bogotá (Bogotá Fontibón Industrial)	15	P	I198	T97
SK01	2024-01-02	Hacienda Fizebad, Arjona (Bolívar Arjona Agrícola Dique)	0	E	I199	T98
SK02	2024-01-09	Hotel Termales El Batán, Moniquirá (Boyacá Moniquirá Panelero Turístico)	15	D	I200	T99
SK03	2024-01-16	Finca La Cristalina, Vereda La Cabaña, Pensilvania (Caldas Pensilvania Montañoso)	0	P	I201	U50
SK04	2024-01-23	Reserva Natural El Danubio, Solano (Caquetá Solano Remoto)	15	E	I202	U51
SK05	2024-01-30	Finca El Naranjal, Corregimiento El Jagual, Corinto (Cauca Corinto Agroindustrial)	0	D	I203	U52
SK06	2024-02-06	Balcón del Cesar, Manaure (Cesar Manaure Balcón Cesar)	15	P	I204	U53
SK07	2024-02-13	Hotel Campestre Las Heliconias, Ciénaga de Oro (Córdoba Ciénaga de Oro Cultural)	0	E	I205	U54
SK08	2024-02-20	Centro Chía, Local 1-105, Chía (Cundinamarca Sabana Centro Chía)	15	D	I206	U55
SK09	2024-02-27	Corregimiento de Beté, Lloró (Chocó Lloró Minero)	15	P	I207	U56
SK10	2024-03-05	Hotel Los Termales de Rivera, Rivera (Huila Rivera Turístico Termal)	0	E	I208	U57
SK11	2024-03-12	Playa La Boca de Dibulla, Dibulla (La Guajira Dibulla Costero Turístico)	0	D	I209	U58
SK12	2024-03-19	Corregimiento de Guaimaral, Sitionuevo (Magdalena Sitionuevo Ribereño)	0	P	I210	U59
SK13	2024-03-26	Finca La Esmeralda, Vereda El Recreo, Cubarral (Meta Cubarral Piedemonte)	15	E	I211	U60
SK14	2024-04-02	Parque Principal, Guachucal (Nariño Guachucal Altiplano Agrícola)	0	D	I212	U61
SK15	2024-04-09	Corregimiento de Filo Gringo, Sardinata (N.Santander Sardinata Catatumbo)	15	P	I213	U62
SK16	2024-04-16	Mirador de Buenavista, Buenavista (Quindío Buenavista Mirador)	15	E	I214	U63
SK17	2024-04-23	Resguardo Indígena de Purembará, Apía (Risaralda Apía Montañoso Cafetero)	0	D	I215	U64
SK18	2024-04-30	Parque Nacional del Chicamocha (cercanías), Barichara (Santander Barichara)	0	P	I216	U65
SK19	2024-05-07	Corregimiento de Bremen, Majagual (Sucre Majagual La Mojana)	15	E	I217	U66
SK20	2024-05-14	Finca El Ocaso, Vereda Buenos Aires, Alvarado (Tolima Alvarado Agrícola)	15	D	I218	U67
SK21	2024-05-21	Parque Principal, Amalfi (Antioquia Amalfi Nordeste)	15	P	I219	U68
SK22	2024-05-28	Plaza Central, Ponedera (Atlántico Ponedera Oriental)	0	E	I220	U69
SK23	2024-06-04	Barrio Olaya Herrera, Bogotá (Bogotá Ciudad Bolívar Sur)	0	D	I221	U70
SK24	2024-06-11	Mina de Oro La Ye, Santa Rosa del Sur (Bolívar Santa Rosa del Sur Minero)	0	P	I222	U71
SK25	2024-06-18	Hotel Campestre Villa Laura, Miraflores (Boyacá Miraflores Lengupá)	15	E	I223	U72
SK26	2024-06-25	Finca La Esperanza, Vereda El Rayo, Aranzazu (Caldas Aranzazu Norte)	0	D	I224	U73
SK27	2024-07-02	Comunidad Indígena El Progreso, Solita (Caquetá Solita Rural)	15	P	I225	U74
SK28	2024-07-09	Finca La Argelia, Corregimiento El Mango, Buenos Aires (Cauca Buenos Aires Afro)	15	E	I226	U75
SK29	2024-07-16	Complejo Cenagoso de Zapatosa (cercanías), Chimichagua (Cesar Chimichagua Ciénaga)	15	D	I227	U76
SK30	2024-07-23	Hotel Ciénaga Grande, Momil (Córdoba Momil Cultural Ciénaga)	0	P	I228	U77
SK31	2024-07-30	Parque Industrial Tibitoc, Bodega 25, Funza (Cundinamarca Funza Industrial)	0	E	I229	U78
SK32	2024-08-06	Comunidad Embera de Jurubirá, Juradó (Chocó Juradó Fronterizo Pacífico)	0	D	I230	U79
SK33	2024-08-13	Finca El Porvenir, Vereda El Dinde, Aipe (Huila Aipe Petrolero Norte)	0	P	I231	U80
SK34	2024-08-20	Mina de Carbón Cerrejón (acceso), Albania (La Guajira Albania Minero)	15	E	I232	U81
SK35	2024-08-27	Corregimiento de Candelaria, Pedraza (Magdalena Pedraza Ribereño)	0	D	I233	U82
SK36	2024-09-03	Parque Nacional Natural Tinigua (cercanías), Mapiripán (Meta Mapiripán)	15	P	I234	U83
SK37	2024-09-10	Reserva Natural La Planada (cercanías), El Charco (Nariño El Charco Costa Pacífica)	15	E	I235	U84
SK38	2024-09-17	Parque Natural Catatumbo Barí (entrada), Tibú (N.Santander Tibú Catatumbo)	0	D	I236	U85
SK39	2024-09-24	Finca El Placer, Vereda La Bella, Córdoba (Quindío Córdoba Montañoso Sur)	15	P	I237	U86
SK40	2024-10-01	Resguardo Indígena Karmata Rúa, Mistrató (Risaralda Mistrató Indígena Occ.)	15	E	I238	U87
SK41	2024-10-08	Corregimiento de La India, Cimitarra (Santander Cimitarra Magdalena Medio)	15	D	I239	U88
SK42	2024-10-15	Finca La Soledad, Vereda El Jardín, San Pedro (Sucre San Pedro Sabanero)	0	P	I240	U89
SK43	2024-10-22	Puente de Ambalema, Ambalema (Tolima Ambalema Histórico Tabacalero)	0	E	I241	U90
SK44	2024-10-29	Casa Museo Otraparte (cercanías), Jericó (Antioquia Jericó Suroeste Religioso)	15	D	I242	U91
SK45	2024-11-05	Embalse del Guájaro, Repelón (Atlántico Repelón Embalse)	0	P	I243	U92
SK46	2024-11-12	Plaza España, Bogotá (Bogotá Barrios Unidos Central)	0	E	I244	U93
SK47	2024-11-19	Reserva Natural Los Colorados (cercanías), Tiquisio (Bolívar Tiquisio Minero Sur)	15	D	I245	U94
SK48	2024-11-26	Parque Principal, Ramiriquí (Boyacá Ramiriquí Provincia Márquez)	15	P	I246	U95
SK49	2024-12-03	Finca La Aurora, Vereda La Quiebra, Manzanares (Caldas Manzanares Oriente)	15	E	I247	U96
SK50	2025-01-07	Comunidad Indígena de Araracuara, Valparaíso (Caquetá Valparaíso Rural)	0	D	I248	U97
SK51	2025-01-14	Finca El Descanso, Corregimiento de Ortega, Cajibío (Cauca Cajibío Central Agrícola)	15	P	I249	U98
SK52	2025-01-21	Mina El Descanso (cercanías), Becerril (Cesar Becerril Minero)	0	E	I250	U99
SK53	2025-01-28	Playa de Moñitos, Moñitos (Córdoba Moñitos Costero Turístico)	0	D	I251	V00
SK54	2025-02-04	Embalse del Neusa, Cabaña Los Pinos, Cogua (Cundinamarca Cogua Embalse Neusa)	0	P	I252	V01
SK55	2025-02-11	Comunidad de Boca de Raspadura, Medio Atrato (Chocó Medio Atrato Ribereño)	0	E	I253	V02
SK56	2025-02-18	Finca Villa Celina, Vereda El Paraíso, Algeciras (Huila Algeciras Agrícola Mont.)	15	D	I254	V03
SK57	2025-02-25	Festival Cuna de Acordeones (lugar), El Molino (La Guajira El Molino Cultural)	0	P	I255	V04
SK58	2025-03-04	Corregimiento de El Retén, Remolino (Magdalena Remolino Ribereño)	0	E	I256	V05
SK59	2025-03-11	Cascadas de Lejanías, Lejanías (Meta Lejanías Turístico Ariari)	15	D	I257	V06
SK60	2025-03-18	Volcán Cumbal (faldas), Cumbal (Nariño Cumbal Volcánico Fronterizo)	15	P	I258	V07
SK61	2025-03-25	Parque Principal, Salazar de las Palmas (N.Santander Salazar Histórico)	15	E	I259	V08
SK62	2025-04-01	Finca Cafetera La Esmeralda, Génova (Quindío Génova Montañoso Sur)	15	D	I260	V09
SK63	2025-04-08	Reserva Indígena de Geguadas, Pueblo Rico (Risaralda Pueblo Rico Indígena Occ.)	15	P	I261	V10
SK64	2025-04-15	Hotel Campestre El Ensueño, Oiba (Santander Oiba Panelero Turístico)	0	E	I262	V11
SK65	2025-04-22	Corregimiento de Canutalito, Chalán (Sucre Chalán Montes de María Sucreño)	0	D	I263	V12
SK66	2025-04-29	Finca Villa Amparo, Vereda El Guayabo, Anzoátegui (Tolima Anzoátegui Montañoso N.)	0	P	I264	V13
SK67	2025-05-06	Parque Ecológico Los Salados, El Retiro (Antioquia El Retiro Oriente Cercano)	0	E	I265	V14
SK68	2025-05-13	Pozos de Usiacurí, Usiacurí (Atlántico Usiacurí Artesanal Turístico)	15	D	I266	V15
SK69	2025-05-20	Barrio Egipto, Bogotá (Bogotá Antonio Nariño Sur)	15	P	I267	V16
SK70	2025-05-27	Corregimiento Las Brisas, San Pablo (Bolívar San Pablo Sur Minero)	15	E	I268	V17
SK71	2025-06-03	Casa de Terracota, Ráquira (Boyacá Ráquira Artesanal Turístico)	15	D	I269	V18
SK72	2025-06-10	Hacienda Cafetera El Bosque, Marquetalia (Caldas Marquetalia Oriente Montañoso)	0	P	I270	V19
SK73	2025-06-17	Reserva Natural La Paya (cercanías), Albania (Caquetá Albania Rural)	0	E	I271	V20
SK74	2025-06-24	Resguardo Indígena de Totoró, Caldono (Cauca Caldono Indígena Norte)	15	D	I272	V21
SK75	2025-07-01	Finca Las Marías, Vereda El Centro, El Copey (Cesar El Copey Ganadero)	0	P	I273	V22
SK76	2025-07-08	Playas de San Bernardo del Viento, Puerto Escondido (Córdoba Puerto Escondido Costero)	15	E	I274	V23
SK77	2025-07-15	Salto de Versalles, Guaduas (Cundinamarca Guaduas Histórico Ruta Mutis)	15	D	I275	V24
SK78	2025-07-22	Comunidad de El Valle, Río Quito (Chocó Río Quito Minero)	15	P	I276	V25
SK79	2025-07-29	Finca La Primavera, Vereda El Colegio, Baraya (Huila Baraya Agrícola Norte)	0	E	I277	V26
SK80	2025-08-05	Mina de Sal de Hatonuevo (cercanías), Hatonuevo (La Guajira Hatonuevo Minero)	0	D	I278	V27
SK81	2025-08-12	Corregimiento de Apure, San Zenón (Magdalena San Zenón Ribereño)	15	P	I279	V28
SK82	2025-08-19	Caño Cristales (acceso), Puerto Lleras (Meta Puerto Lleras Llanero)	0	E	I280	V29
SK83	2025-08-26	Santuario de Las Lajas (cercanías), El Tambo (Nariño El Tambo Extenso Montañoso)	15	D	I281	V30
SK84	2025-09-02	Pozo Azul, Convención (N.Santander Convención Catatumbo)	15	P	I282	V31
SK85	2025-09-09	Finca El Recuerdo, Vereda La Siria, Pijao (Quindío Pijao Cafetero Montañoso)	15	E	I283	V32
SK86	2025-09-16	Parque Natural Tatamá (entrada), Santuario (Risaralda Santuario Natural Occ.)	15	D	I284	V33
SK87	2025-09-23	Cueva del Indio, Málaga (Santander Málaga Provincia García Rovira)	0	P	I285	V34
SK88	2025-09-30	Finca La Esperanza, Corregimiento El Viajano, El Roble (Sucre El Roble Sabanero)	0	E	I286	V35
SK89	2025-10-07	Minas de Santa Ana, Ataco (Tolima Ataco Minero Sur)	0	D	I287	V36
SK90	2025-10-14	Cueva del Esplendor, Támesis (Antioquia Támesis Suroeste Turístico)	0	P	I288	V37
SK91	2025-10-21	Finca El Oasis, Vereda Las Compuertas, Campo de la Cruz (Atlántico Campo de la Cruz)	15	E	I289	V38
SK92	2025-10-28	Plaza de Bolívar, Bogotá (Bogotá Mártires Central Histórico)	15	D	I290	V39
SK93	2025-11-04	Corregimiento de Tacamocho, Simití (Bolívar Simití Serranía San Lucas)	15	P	I291	V40
SK94	2025-11-11	Hotel El Colonial, Santana (Boyacá Santana Ricaurte Bajo)	0	E	I292	V41
SK95	2025-11-18	Termales El Otoño (cercanías), Marulanda (Caldas Marulanda Páramo Ganadero)	0	D	I293	V42
SK96	2025-11-25	Comunidad Indígena de Peñas Blancas, Morelia (Caquetá Morelia Rural)	0	P	I294	V43
SK97	2025-12-02	Hacienda Japio, El Tambo (Cauca El Tambo Rural Extenso)	15	E	I295	V44
SK98	2025-12-09	Finca La Carolina, Vereda El Palmar, González (Cesar González Sur Agrícola)	0	D	I296	V45
SK99	2025-12-16	Parque Natural Paramillo (acceso), Puerto Libertador (Córdoba Pto Libertador)	15	P	I297	V46
SL00	2025-12-23	Laguna de Guatavita, Guatavita (Cundinamarca Guatavita Turístico Embalse)	15	E	I298	V47
SL01	2025-12-30	Termales de Santa Mónica, San José del Palmar (Chocó San José del Palmar Cafetero)	0	D	I299	V48
SL02	2024-01-02	Finca El Edén, Vereda La Lindosa, Colombia (Huila Colombia Norte Montañoso)	0	P	I300	V49
SL03	2024-01-09	Comunidad de Carraipía, Jagua del Pilar (La Guajira Jagua del Pilar Fronterizo)	0	E	I301	V50
SL04	2024-01-16	Plaza Principal, Tenerife (Magdalena Tenerife Ribereño Histórico)	15	D	I302	V51
SL05	2024-01-23	Hotel Caño Cristales, San Juan de Arama (Meta San Juan de Arama Piedemonte)	0	P	I303	V52
SL06	2024-01-30	Finca El Rosal, Vereda El Carmelo, Funes (Nariño Funes Altiplano Sur)	15	E	I304	V53
SL07	2024-02-06	Parque Recreacional, Cucutilla (N.Santander Cucutilla Montañoso)	0	D	I305	V54
SL08	2024-02-13	Hotel Mirador del Quindío, Quimbaya (Quindío Quimbaya Turístico Cultural)	15	P	I306	V55
SL09	2024-02-20	Resguardo Indígena Embera Chamí, Guática (Risaralda Guática Indígena Montañoso)	15	E	I307	V56
SL10	2024-02-27	Páramo de Santurbán (acceso), Onzaga (Santander Onzaga Páramo Santurbán)	0	D	I308	V57
SL11	2024-03-05	Finca Las Delicias, Corregimiento Pileta, Galeras (Sucre Galeras Sabanero Cultural)	15	P	I309	V58
SL12	2024-03-12	Parque del Arroz, Cajamarca (Tolima Cajamarca Despensa Agrícola)	0	E	I310	V59
SL13	2024-03-19	Finca Hotel El Tesoro, Hispania (Antioquia Hispania Suroeste Panelero)	0	D	I311	V60
SL14	2024-03-26	Plaza Principal, Candelaria (Atlántico Candelaria Oriental Agrícola)	15	P	I312	V61
SL15	2024-04-02	Plaza de la Mariposa, Bogotá (Bogotá Santa Fe Histórico Central)	0	E	I313	V62
SL16	2024-04-09	Puente de Soplaviento, Soplaviento (Bolívar Soplaviento Ribereño Dique)	15	D	I314	V63
SL17	2024-04-16	Laguna de Sativanorte, Sativanorte (Boyacá Sativanorte Páramo Norte)	15	P	I315	V64
SL18	2024-04-23	Finca La Divisa, Vereda La Florida, Neira (Caldas Neira Norte Cafetero)	15	E	I316	V65
SL19	2024-04-30	Comunidad Indígena Uitoto, Milán (Caquetá Milán Rural)	0	D	I317	V66
SL20	2025-01-07	Reserva Natural Cerro Plateado, Guachené (Cauca Guachené Afro Norte Industrial)	0	P	I318	V67
SL21	2025-01-14	Finca El Progreso, Corregimiento La Mata, La Gloria (Cesar La Gloria Ribereño Sur)	0	E	I319	V68
SL22	2025-01-21	Plaza Principal, Purísima (Córdoba Purísima Bajo Sinú)	15	D	I320	V69
SL23	2025-01-28	Vereda El Chuscal, Finca Los Alisos, Junín (Cundinamarca Provincia del Guavio)	0	P	I321	V70
SL24	2025-02-04	Comunidad de Pie de Pató, Sipí (Chocó Sipí Minero Baudó)	15	E	I322	V71
SL25	2025-02-11	Hotel Campestre El Bambú, Elías (Huila Elías Cafetero Central)	15	D	I323	V72
SL26	2025-02-18	Pozo de la Dicha, Distracción (La Guajira Distracción Agrícola Centro)	0	P	I324	V73
SL27	2025-02-25	Corregimiento de La China, Zapayán (Magdalena Zapayán Ciénaga)	0	E	I325	V74
SL28	2025-03-04	Río Guejar (senderos), San Juanito (Meta San Juanito Páramo Meta)	0	D	I326	V75
SL29	2025-03-11	Termales de Tajumbina, Guaitarilla (Nariño Guaitarilla Montañoso Central)	0	P	I327	V76
SL30	2025-03-18	Parque Natural Regional Sisavita (cercanías), Durania (N.Santander Durania Metro)	15	E	I328	V77
SL31	2025-03-25	Plaza de Bolívar, Armenia (Quindío Armenia Área Comercial)	0	D	I329	V78
SL32	2025-04-01	Cascada Los Frailes, La Celia (Risaralda La Celia Cafetero Occidente)	0	P	I330	V79
SL33	2025-04-08	Puente Real, Sucre (Santander Sucre Provincia de Vélez)	0	E	I331	V80
SL34	2025-04-15	Finca La Mojana, Corregimiento El Cauchal, Guaranda (Sucre Guaranda La Mojana)	15	D	I332	V81
SL35	2025-04-22	Parque Principal, Carmen de Apicalá (Tolima Carmen de Apicalá Turístico Rel.)	0	P	I333	V82
SL36	2025-04-29	Cerro El Capiro, Montebello (Antioquia Montebello Suroeste Cafetero)	15	E	I334	V83
SL37	2025-05-06	Volcán del Totumo (cercanías), Piojó (Atlántico Piojó Turístico Ecológico)	15	D	I335	V84
SL38	2025-05-13	Chorro de Quevedo, Bogotá (Bogotá La Candelaria Cultural)	15	P	I336	V85
SL39	2025-05-20	Ciénaga de El Floral, Talaigua Nuevo (Bolívar Talaigua Nuevo Ribereño)	15	E	I337	V86
SL40	2025-05-27	Nevado del Cocuy (acceso), Sativasur (Boyacá Sativasur Páramo Histórico)	0	D	I338	V87
SL41	2025-06-03	Embalse Amaní (orillas), Norcasia (Caldas Norcasia Embalse Oriental)	0	P	I339	V88
SL42	2025-06-10	Raudal del Jirijirimo (cercanías), San José del Fragua (Caquetá San José del Fragua)	0	E	I340	V89
SL43	2025-06-17	Parque Arqueológico de Tierradentro (acceso), Jambaló (Cauca Jambaló Indígena Mont.)	0	D	I341	V90
SL44	2025-06-24	Finca El Tesoro, Vereda La Victoria, Pailitas (Cesar Pailitas Sur Ganadero)	15	P	I342	V91
SL45	2025-07-01	Resguardo Indígena Zenú, San Andrés de Sotavento (Córdoba San Andrés Sotavento)	15	E	I343	V92
SL46	2025-07-08	Piedra Capira, La Calera (Cundinamarca La Calera Cercano Bogotá Turístico)	15	D	I344	V93
SL47	2025-07-15	Parque Nacional Natural Utría (acceso), Unguía (Chocó Unguía Darién Caribe)	0	P	I345	V94
SL48	2025-07-22	Santuario de Nuestra Señora de Aránzazu, Guadalupe (Huila Guadalupe Cafetero Rel.)	0	E	I346	V95
SL49	2025-07-29	Plaza Padilla, Villanueva (La Guajira Villanueva Sur Cultural)	0	D	I347	V96
SL50	2025-08-12	Finca Cafetera El Vergel, Córdoba (Quindío Córdoba Cafetero Sur)	15	D	I348	V52
SL51	2025-08-19	Parque Ukumarí (cercanías), Mistrató (Risaralda Mistrató Reserva Natural)	0	P	I349	V53
SL52	2025-08-26	Hoyo de los Pájaros, Zapatoca (Santander Zapatoca Turístico Colonial)	15	E	I350	V54
SL53	2025-09-02	Ciénaga de La Caimanera, Morroa (Sucre Morroa Artesanal Sabanero)	15	D	I351	V55
SL54	2025-09-09	Represa de Prado (cercanías), Coello (Tolima Coello Agrícola Central)	15	P	I352	V56
SL55	2025-09-16	Parque Arqueológico El Tablón, Nariño (Antioquia Nariño Oriente Páramo)	0	E	I353	V57
SL56	2025-09-23	Playas de Tubará, Tubará (Atlántico Tubará Turístico Ecológico Caribe)	0	D	I354	V58
SL57	2025-09-30	Parque Nacional Sumapaz (acceso), Bogotá (Bogotá San Cristóbal Suroriente)	0	P	I355	V59
SL58	2025-10-07	Ciénaga de Zapatosa (orillas), Zambrano (Bolívar Zambrano Ribereño Magdalena Medio)	15	E	I356	V60
SL59	2025-10-14	Plaza de Mercado, Sogamoso (Boyacá Sogamoso Industrial Valle Sugamuxi)	0	D	I357	V61
SL60	2025-10-21	Ecoparque Los Yarumos, Pensilvania (Caldas Pensilvania Oriental Montañoso)	15	P	I358	V62
SL61	2025-10-28	Río Orteguaza (riberas), Curillo (Caquetá Curillo Ganadero)	15	E	I359	V63
SL62	2025-11-04	Salto de Bordones (cercanías), López de Micay (Cauca López de Micay Costa Pacífica)	0	D	I360	V64
SL63	2025-11-11	Balneario El Encanto, Río de Oro (Cesar Río de Oro Sur Agrícola)	15	P	I361	V65
SL64	2025-11-18	Museo Zenú de Arte Contemporáneo, San Carlos (Córdoba San Carlos Sabanero Ganadero)	0	E	I362	V66
SL65	2025-11-25	Parque Ecológico Jericó, La Vega (Cundinamarca La Vega Turístico Climático)	15	D	I363	V67
SL66	2025-12-02	Cascada de Sal de Frutas, Alto Baudó (Chocó Alto Baudó Selva Pacífica)	15	P	I364	V68
SL67	2025-12-09	Parque Arqueológico de San Agustín (acceso), Isnos (Huila Isnos Arqueológico Macizo)	0	E	I365	V69
SL68	2025-12-16	Santuario de Fauna y Flora Los Flamencos (acceso), Uribia (La Guajira Uribia Desierto Wayuu)	15	D	I366	V70
SL69	2025-12-23	Pueblos Palafitos Ciénaga Grande, Remolino (Magdalena Remolino Pesquero Ciénaga)	0	P	I367	V71
SL70	2025-12-30	Rafting Río Güejar, Fuente de Oro (Meta Fuente de Oro Ariari Agrícola)	15	E	I368	V72
SL71	2024-01-06	Laguna de la Cocha (muelle), Ipiales (Nariño Ipiales Comercio Fronterizo)	15	D	I369	V73
SL72	2024-01-13	Páramo de Guerrero (senderos), Labateca (N.Santander Labateca Montañoso Suroriente)	0	P	I370	V74
SL73	2024-01-20	Valle de Cócora, Génova (Quindío Génova Cafetero Cordillera)	0	E	I371	V75
SL74	2024-01-27	Santuario de Fauna y Flora Otún Quimbaya (acceso), Pueblo Rico (Risaralda Pueblo Rico Biodiverso)	15	D	I372	V76
SL75	2024-02-03	Cueva del Nitro, Aguada (Santander Aguada Provincia de Vélez)	0	P	I373	V77
SL76	2024-02-10	Ciénaga de Momil, Palmito (Sucre Palmito Sabanero Agrícola)	0	E	I374	V78
SL77	2024-02-17	Cañón del Combeima, Cunday (Tolima Cunday Montañoso Oriente)	0	D	I375	V79
SL78	2024-02-24	Playas de Necoclí, Necoclí (Antioquia Necoclí Urabá Caribe)	15	P	I376	V80
SL79	2024-03-02	Artesanías de Usiacurí, Usiacurí (Atlántico Usiacurí Termal Artesanal)	0	E	I377	V81
SL80	2024-03-09	Parque Nacional Natural Sumapaz (entrada sur), Bogotá (Bogotá Sumapaz Rural Páramo)	0	D	I378	V82
SL81	2024-03-16	Ciénaga de Achí, Achí (Bolívar Achí Depresión Momposina Sur)	0	P	I379	V83
SL82	2024-03-23	Cascadas La Chorrera, Somondoco (Boyacá Somondoco Valle de Tenza)	15	E	I380	V84
SL83	2024-03-30	Termales de Espíritu Santo, Salamina (Caldas Salamina Patrimonio Cafetero)	0	D	I381	V85
SL84	2024-04-06	Río Caguán (pesca), El Doncello (Caquetá El Doncello Ganadero Norte)	15	P	I382	V86
SL85	2024-04-13	Finca El Paraíso (Hacienda), Mercaderes (Cauca Mercaderes Sur Macizo)	15	E	I383	V87
SL86	2024-04-20	Balneario Hurtado, San Alberto (Cesar San Alberto Agroindustrial Sur)	15	D	I384	V88
SL87	2024-04-27	Volcán de Lodo El Totumo (cercanías), San Pelayo (Córdoba San Pelayo Cultural Porro)	15	P	I385	V89
SL88	2025-01-07	Minas de Sal de Nemocón (cercanías), Lenguazaque (Cund. Lenguazaque Minero Ubaté)	0	E	I386	V90
SL89	2025-01-14	Río Atrato (navegación), Atrato (Chocó Atrato Ribereño Central)	0	D	I387	V91
SL90	2025-01-21	Desierto de la Tatacoa (observatorio), La Argentina (Huila La Argentina Cafetero Occ.)	0	P	I388	V92
SL91	2025-01-28	Ranchería Sumaain Ipa, Albania (La Guajira Albania Minero Central)	0	E	I389	V93
SL92	2025-02-04	Parque Isla de Salamanca (acceso), Sabanas de San Ángel (Magdalena Sabanas de San Ángel)	15	D	I390	V94
SL93	2025-02-11	Río Ariari (balnearios), Guamal (Meta Guamal Piedemonte Turístico)	15	P	I391	V95
SL94	2025-02-18	Santuario de Flora y Fauna Volcán Galeras (acceso), La Cruz (Nariño La Cruz Macizo Oriental)	15	E	I392	V96
SL95	2025-02-25	Embalse del Sisga (cercanías), La Esperanza (N.Santander La Esperanza Montañoso Límite)	15	D	I393	V97
SL96	2025-03-04	Ecoparque Peñas Blancas, Montenegro (Quindío Montenegro Turístico Quimbaya)	0	P	I394	V98
SL97	2025-03-11	Parque Natural Regional Ucumarí (acceso), Quinchía (Risaralda Quinchía Minero Cultural)	0	E	I395	V99
SL98	2025-03-18	Cascada de Los Caballeros, Albania (Santander Albania Provincia de Vélez)	15	D	I396	W00
SL99	2025-03-25	Playas de Rincón del Mar, Sampués (Sucre Sampués Artesanal Cultural)	0	P	I397	W01
SM00	2025-04-01	Represa de Hidroprado, Dolores (Tolima Dolores Montañoso Suroriente)	15	E	I398	W02
SM01	2025-04-08	Reserva Natural Cañón del Río Alicante, Nechí (Antioquia Nechí Bajo Cauca Minero)	0	D	I399	W03
SM02	2025-04-15	Playas de Salgar, Santo Tomás (Atlántico Santo Tomás Oriental Cultural)	15	P	I400	W04
SM03	2025-04-22	Parque Tercer Milenio, Bogotá (Bogotá Tunjuelito Sur Industrial)	0	E	I401	W05
SM04	2025-04-29	Serranía de San Lucas (estribaciones), Altos del Rosario (Bolívar Altos del Rosario Ribereño)	0	D	I402	W06
SM05	2025-05-06	Iglesia de Sora, Sora (Boyacá Sora Central Agrícola)	0	P	I403	W07
SM06	2025-05-13	Mirador Alto de la Virgen, San José (Caldas San José Cafetero Occidental)	0	E	I404	W08
SM07	2025-05-20	Río Peneya (balnearios), La Montañita (Caquetá La Montañita Rural Central)	0	D	I405	W09
SM08	2025-05-27	Puente del Humilladero, Miranda (Cauca Miranda Azucarero Norte)	15	P	I406	W10
SM09	2025-06-03	Finca El Porvenir, Vereda Las Vegas, San Diego (Cesar San Diego Agrícola Perijá)	15	E	I407	W11
SM10	2025-06-10	Parque Nacional Natural Paramillo (acceso sur), Tierralta (Córdoba Tierralta Alto Sinú)	15	D	I408	W12
SM11	2025-06-17	Termales de Machetá, Machetá (Cundinamarca Provincia Almeidas)	0	P	I409	W13
SM12	2025-06-24	Río Andágueda (pesca), Bagadó (Chocó Bagadó Minero Atrato)	0	E	I410	W14
SM13	2025-07-01	Salto de Bordones, La Plata (Huila La Plata Occidental Agrícola)	0	D	I411	W15
SM14	2025-07-08	Rancherías en la vía a Mayapo, Barrancas (La Guajira Barrancas Carbón Central)	15	P	I412	W16
SM15	2025-07-15	Puente Pumarejo (vista), Salamina (Magdalena Salamina Ribereño Histórico)	0	E	I413	W17
SM16	2025-07-22	Parque Nacional Natural Sierra de La Macarena, La Macarena (Meta La Macarena Turístico)	15	D	I414	W18
SM17	2025-07-29	Piedra de Bolívar, La Florida (Nariño La Florida Volcánico Galeras)	0	P	I415	W19
SM18	2025-08-05	Museo de la Gran Convención, La Playa de Belén (N.Santander La Playa Turístico)	0	E	I416	W20
SM19	2025-08-12	Finca Hotel La Tata, Pijao (Quindío Pijao Cafetero Cordillerano)	0	D	I417	W21
SM20	2025-08-19	Parque Principal, Santa Rosa de Cabal (Risaralda Santa Rosa de Cabal Termales)	0	P	I418	W22
SM21	2025-08-26	Salto del Mico, Aratoca (Santander Aratoca Cañón Chicamocha)	0	E	I419	W23
SM22	2025-09-02	Ciénaga de San Marcos, San Benito Abad (Sucre San Benito Abad La Mojana)	0	D	I420	W24
SM23	2025-09-09	Represa de Betania (orillas), Espinal (Tolima Espinal Arrocero Llano)	0	P	I421	W25
SM24	2025-09-16	Puente de Occidente, Olaya (Antioquia Olaya Occidente Histórico)	15	E	I422	W26
SM25	2025-09-23	Plaza de la Paz, Palmar de Varela (Atlántico Palmar de Varela Agroindustrial)	0	D	I423	W27
SM26	2025-09-30	Parque Nacional Chingaza (acceso Usme), Bogotá (Bogotá Usme Sur Rural)	15	P	I424	W28
SM27	2025-10-07	Corregimiento de Cascajal, Arenal (Bolívar Arenal Sur Minero)	15	E	I425	W29
SM28	2025-10-14	Iglesia de Sotaquirá, Sotaquirá (Boyacá Sotaquirá Central Agrícola)	0	D	I426	W30
SM29	2025-10-21	Nevado del Ruiz (miradores), Supía (Caldas Supía Minero Occidental)	0	P	I427	W31
SM30	2025-10-28	Comunidad Indígena Coreguaje, Milán (Caquetá Milán Ganadero Rural)	15	E	I428	W32
SM31	2025-11-04	Hacienda Calibío, Morales (Cauca Morales Central Indígena)	0	D	I429	W33
SM32	2025-11-11	Finca La Ilusión, Vereda El Carmen, San Martín (Cesar San Martín Sur Petrolero)	0	P	I430	W34
SM33	2025-11-18	Parque Nacional Natural Paramillo (acceso), Valencia (Córdoba Valencia Alto Sinú)	0	E	I431	W35
SM34	2025-11-25	Parque Jaime Duque (cercanías), Madrid (Cundinamarca Madrid Sabana Occidente Ind.)	15	D	I432	W36
SM35	2025-12-02	Playas de Nuquí, Bahía Solano (Chocó Bahía Solano Biodiversidad Pacífica)	0	P	I433	W37
SM36	2025-12-09	Finca Villa Alejandra, Vereda Otás, Nátaga (Huila Nátaga Cafetero Occidental)	0	E	I434	W38
SM37	2025-12-16	Santuario de Fauna y Flora Los Colorados (acceso), Dibulla (La Guajira Dibulla Tayrona)	0	D	I435	W39
SM38	2025-12-23	Finca La Escondida, Corregimiento El Bongo, San Sebastián (Magdalena San Sebastián)	15	P	I436	W40
SM39	2025-12-30	Río Güejar (balnearios), Lejanías (Meta Lejanías Ariari Turístico Montañoso)	0	E	I437	W41
SM40	2024-01-06	Laguna de Telpis, La Llanada (Nariño La Llanada Minero Occidental)	15	D	I438	W42
SM41	2024-01-13	Parque Principal, Lourdes (N.Santander Lourdes Metropolitano Histórico)	15	P	I439	W43
SM42	2024-01-20	Mirador del Valle de Cócora, Salento (Quindío Salento Valle de Cócora)	15	E	I440	W44
SM43	2024-01-27	Termales de San Vicente (cercanías), Santuario (Risaralda Santuario Parque Natural)	15	D	I441	W45
SM44	2024-02-03	Puente de Boyacá (cercanías), Barbosa (Santander Barbosa Comercial Panelero)	0	P	I442	W46
SM45	2024-02-10	Finca El Carmen, Corregimiento Las Tablitas, San Juan de Betulia (Sucre San Juan de Betulia)	0	E	I443	W47
SM46	2024-02-17	Minas de Oro de Falan, Falan (Tolima Falan Minero Histórico)	0	D	I444	W48
SM47	2024-02-24	Piedra del Peñol, Peñol (Antioquia Peñol Embalse Turístico)	0	P	I445	W49
SM48	2024-03-02	Sombrero Vueltiao (monumento), Piojó (Atlántico Piojó Ecológico Costero)	15	E	I446	W50
SM49	2024-03-09	Parque Simón Bolívar, Bogotá (Bogotá Ciudad Bolívar Urbano Sur)	15	D	I447	W51
SN00	2024-03-16	Ciénaga de Palagua, Arroyohondo (Bolívar Arroyohondo Canal del Dique)	15	P	I448	W52
SN01	2024-03-23	Iglesia de Soracá, Soracá (Boyacá Soracá Central Agrícola)	15	E	I449	W53
SN02	2024-03-30	Río Magdalena (riberas), Victoria (Caldas Victoria Magdalena Caldense Oriental)	0	D	I450	W54
SN03	2024-04-06	Finca La Escondida, Vereda El Silencio, Pensilvania (Caldas Pensilvania Oriental Mont.)	0	P	I451	W55
SN04	2024-04-13	Comunidad Indígena de Puerto Siare, Solano (Caquetá Solano Remoto)	0	E	I452	W56
SN05	2024-04-20	Hacienda El Tesoro, Corregimiento La Fonda, Corinto (Cauca Corinto Agroindustrial)	0	D	I453	W57
SN06	2024-04-27	Parque Principal, Manaure (Cesar Manaure Balcón del Cesar)	15	P	I454	W58
SN07	2024-05-04	Hotel Campestre Las Palmeras, Ciénaga de Oro (Córdoba Ciénaga de Oro Cultural)	0	E	I455	W59
SN08	2024-05-11	Centro Comercial Fontanar (cercanías), Chía (Cundinamarca Sabana Centro Chía)	15	D	I456	W60
SN09	2024-05-18	Comunidad de Yuto, Lloró (Chocó Lloró Minero)	0	P	I457	W61
SN10	2024-05-25	Hotel Los Termales, Rivera (Huila Rivera Turístico Termal)	0	E	I458	W62
SN11	2024-06-01	Playas de Mayapo, Dibulla (La Guajira Dibulla Costero Turístico)	0	D	I459	W63
SN12	2024-06-08	Corregimiento de Palermo, Sitionuevo (Magdalena Sitionuevo Ribereño)	0	P	I460	W64
SN13	2024-06-15	Finca Villa Paz, Vereda La Argentina, Cubarral (Meta Cubarral Piedemonte)	0	E	I461	W65
SN14	2024-06-22	Plaza de Nariño, Guachucal (Nariño Guachucal Altiplano Agrícola)	15	D	I462	W66
SN15	2024-06-29	Corregimiento de Las Mercedes, Sardinata (N.Santander Sardinata Catatumbo)	15	P	I463	W67
SN16	2024-07-06	Parque de la Vida, Buenavista (Quindío Buenavista Mirador)	15	E	I464	W68
SN17	2024-07-13	Resguardo Indígena de Escopetera-Pirsa, Apía (Risaralda Apía Montañoso Cafetero)	0	D	I465	W69
SN18	2024-07-20	Gallineral Parque Ecológico, Barichara (Santander Barichara Colonial Turístico)	0	P	I466	W70
SN19	2024-07-27	Corregimiento de Sabaneta, Majagual (Sucre Majagual La Mojana)	0	E	I467	W71
SN20	2024-08-03	Finca La Carolina, Vereda El Cedral, Alvarado (Tolima Alvarado Agrícola)	0	D	I468	W72
SN21	2024-08-10	Cerro Tusa, Amalfi (Antioquia Amalfi Nordeste)	0	P	I469	W73
SN22	2024-08-17	Plaza de la Aduana, Ponedera (Atlántico Ponedera Oriental)	15	E	I470	W74
SN23	2024-08-24	Parque El Tunal, Bogotá (Bogotá Ciudad Bolívar Sur)	0	D	I471	W75
SN24	2024-08-31	Corregimiento de Norosí, Santa Rosa del Sur (Bolívar Santa Rosa del Sur Minero)	0	P	I472	W76
SN25	2024-09-07	Hotel El Lago, Miraflores (Boyacá Miraflores Lengupá)	0	E	I473	W77
SN26	2024-09-14	Finca El Reposo, Vereda La Estrella, Aranzazu (Caldas Aranzazu Norte)	0	D	I474	W78
SN27	2024-09-21	Comunidad Indígena de La Chorrera, Solita (Caquetá Solita Rural)	0	P	I475	W79
SN28	2024-09-28	Finca El Diamante, Corregimiento El Plateado, Buenos Aires (Cauca Buenos Aires Afro)	0	E	I476	W80
SN29	2024-10-05	Ciénaga de Palagua (orillas), Chimichagua (Cesar Chimichagua Ciénaga)	0	D	I477	W81
SN30	2024-10-12	Hotel La Casona, Momil (Córdoba Momil Cultural Ciénaga)	15	P	I478	W82
SN31	2024-10-19	Parque Industrial La Florida, Bodega 30, Funza (Cundinamarca Funza Industrial)	0	E	I479	W83
SN32	2024-10-26	Comunidad Afro de Togoromá, Juradó (Chocó Juradó Fronterizo Pacífico)	15	D	I480	W84
SN33	2024-11-02	Finca La Pradera, Vereda El Paraíso, Aipe (Huila Aipe Petrolero Norte)	15	P	I481	W85
SN34	2024-11-09	Cerro La Teta, Albania (La Guajira Albania Minero)	0	E	I482	W86
SN35	2024-11-16	Corregimiento de Chimila, Pedraza (Magdalena Pedraza Ribereño)	0	D	I483	W87
SN36	2024-11-23	Parque Nacional Natural Chingaza (acceso), Mapiripán (Meta Mapiripán)	0	P	I484	W88
SN37	2024-11-30	Reserva Natural Río Ñambí (cercanías), El Charco (Nariño El Charco Costa Pacífica)	0	E	I485	W89
SN38	2024-12-07	Cerro de las Tres Cruces, Tibú (N.Santander Tibú Catatumbo)	15	D	I486	W90
SN39	2024-12-14	Finca El Mirador, Vereda La Palma, Córdoba (Quindío Córdoba Montañoso Sur)	15	P	I487	W91
SN40	2024-12-21	Reserva Indígena de Quiparadó, Mistrató (Risaralda Mistrató Indígena Occ.)	15	E	I488	W92
SN41	2024-12-28	Cueva de la Vaca, Cimitarra (Santander Cimitarra Magdalena Medio)	15	D	I489	W93
SN42	2025-01-04	Finca La Bendita, Vereda San Antonio, San Pedro (Sucre San Pedro Sabanero)	0	P	I490	W94
SN43	2025-01-11	Puente de Ambalema (viejo), Ambalema (Tolima Ambalema Histórico Tabacalero)	0	E	I491	W95
SN44	2025-01-18	Salto del Ángel (réplica), Jericó (Antioquia Jericó Suroeste Religioso)	15	D	I492	W96
SN45	2025-01-25	Ciénaga de Luruaco, Repelón (Atlántico Repelón Embalse)	0	P	I493	W97
SN46	2025-02-01	Parque El Virrey, Bogotá (Bogotá Barrios Unidos Central)	15	E	I494	W98
SN47	2025-02-08	Reserva Natural El Paujil (cercanías), Tiquisio (Bolívar Tiquisio Minero Sur)	15	D	I495	W99
SN48	2025-02-15	Parque Ecológico La Periquera, Ramiriquí (Boyacá Ramiriquí Provincia Márquez)	15	P	I496	X00
SN49	2025-02-22	Finca El Diamante, Vereda El Aguila, Manzanares (Caldas Manzanares Oriente)	15	E	I497	X01
SN50	2025-03-01	Comunidad Indígena de El Encanto, Valparaíso (Caquetá Valparaíso Rural)	0	D	I498	X02
SN51	2025-03-08	Finca El Tesoro, Corregimiento de Gabriel López, Cajibío (Cauca Cajibío Central Agrícola)	15	P	I499	X03
SN52	2025-03-15	Mina La Jagua (cercanías), Becerril (Cesar Becerril Minero)	0	E	I500	X04
\.


                                                                                                                                                                                                                                                                5139.dat                                                                                            0000600 0004000 0002000 00000047226 15014423351 0014264 0                                                                                                    ustar 00postgres                        postgres                        0000000 0000000                                                                                                                                                                        S00	Antioquia Central	A01
S01	Antioquia Suroeste	A07
S02	Antioquia Norte	B22
S03	Antioquia Urabá	A13
S04	Antioquia Oriente	A85
S05	Atlántico Metropolitano	B26
S06	Atlántico Sur	B41
S07	Atlántico Oriental	B39
S08	Bogotá D.C. Centro	B49
S09	Bogotá D.C. Norte	B49
S10	Bogotá D.C. Occidente	B49
S11	Bolívar Costa Norte	B50
S12	Bolívar Montes de María	B62
S13	Bolívar Sur	B66
S14	Bolívar Dique	B54
S15	Boyacá Central	B96
S16	Boyacá Sugamuxi	C93
S17	Boyacá Occidente	C12
S18	Boyacá Norte	C27
S19	Caldas Eje Cafetero Central	D19
S20	Caldas Norte	D39
S21	Caldas Oriente	D26
S22	Caquetá Florencia y Alrededores	D46
S23	Caquetá Sur	D58
S24	Cauca Popayán Metropolitano	D62
S25	Cauca Norte	D93
S26	Cauca Costa Pacífica	D75
S27	Cesar Valledupar y Sierra	E04
S28	Cesar Sur	E05
S29	Cesar Centro	E12
S30	Córdoba Montería y Sabanas	E29
S31	Córdoba Costa	E39
S32	Córdoba Alto Sinú	E55
S33	Cundinamarca Sabana Centro	E72
S34	Cundinamarca Sabana Occidente	E82
S35	Cundinamarca Girardot y Alto Mag.	E92
S36	Cundinamarca Provincia de Ubaté	F61
S37	Chocó Atrato Medio	F73
S38	Chocó Costa Pacífica Norte	F78
S39	Huila Neiva y Río Magdalena	G03
S40	Huila Sur	G27
S41	La Guajira Alta Guajira	G52
S42	La Guajira Riohacha y Costa	G40
S43	Magdalena Santa Marta y Parque Tay.	G55
S44	Magdalena Zona Bananera	G84
S45	Magdalena Sur	G63
S46	Meta Villavicencio y Piedemonte	G85
S47	Meta Ariari	G96
S48	Nariño Pasto y Volcanes	H14
S49	Nariño Costa Pacífica Sur	H75
S50	Norte de Santander Cúcuta Metro.	H78
S51	Norte de Santander Occidente	I02
S52	Quindío Armenia y Montenegro	I18
S53	Quindío Cordillera	I29
S54	Risaralda Pereira y Dosquebradas	I30
S55	Risaralda Occidente	I37
S56	Santander Bucaramanga Metro.	I44
S57	Santander Provincia de Soto Norte	I80
S58	Santander Provincia de Vélez	J27
S59	Santander Barrancabermeja y Mag. Medio	I50
S60	Sucre Sincelejo y Sabanas	J31
S61	Sucre Golfo de Morrosquillo	J55
S62	Tolima Ibagué y Nevados	J57
S63	Tolima Norte	J78
S64	Tolima Sur	J67
S65	Valle del Cauca - Norte (Ejemplo)	A19
S66	Valle del Cauca Buenaventura Pacífico	A19
S67	Valle del Cauca Palmira	A19
S68	Arauca Capital	A02
S69	Arauca Sarare	A03
S70	Casanare Yopal y Llanos	A04
S71	Casanare Norte	A05
S72	Putumayo Mocoa y Amazonia	A06
S73	Putumayo Bajo Putumayo	A08
S74	San Andrés Isla Principal	A09
S75	Providencia y Santa Catalina Islas	A10
S76	Amazonas Leticia y Frontera	A11
S77	Guainía Inírida Capital	A12
S78	Guaviare San José Capital	A14
S79	Vaupés Mitú Capital	A15
S80	Vichada Puerto Carreño Capital	A16
S81	Antioquia Magdalena Medio	A80
S82	Atlántico Occidente	B31
S83	Bolívar Depresión Momposina	B71
S84	Boyacá Provincia de Lengupá	C34
S85	Caldas Magdalena Caldense	D26
S86	Caquetá Medio	D49
S87	Cauca Macizo Colombiano	D63
S88	Cesar Serranía del Perijá	E06
S89	Córdoba San Jorge	E42
S90	Cundinamarca Provincia del Guavio	E88
S91	Chocó San Juan	F87
S92	Huila Centro	G13
S93	La Guajira Media Guajira	G49
S94	Magdalena Ciénaga Grande	G61
S95	Meta Alto Meta	G91
S96	Nariño Cordillera Occidental	H41
S97	Norte de Santander Catatumbo	H90
S98	Quindío Zona Plana	I25
S99	Risaralda Santa Rosa de Cabal Entorno	I42
T00	Santander Provincia de Guanentá	J13
T01	Sucre La Mojana Sucreña	J48
T02	Tolima Oriente	J70
T03	Antioquia Área Metropolitana Norte	A19
T04	Atlántico Área Portuaria	B39
T05	Bogotá D.C. Chapinero Alto	B49
T06	Bolívar Cartagena Histórico	B50
T07	Boyacá Tundama	C27
T08	Caldas Risaralda Caldense	D24
T09	Caquetá Amazonia Norte (Ejemplo)	D51
T10	Cauca Tierradentro (Ejemplo)	D76
T11	Cesar La Jagua de Ibirico Entorno	E18
T12	Córdoba Bajo Sinú	E36
T13	Cundinamarca Provincia de Sumapaz	E87
T14	Chocó Baudó Región	F79
T15	Huila Occidente (Ejemplo)	G20
T16	La Guajira Sur (Ejemplo)	G51
T17	Magdalena Plato y Ribera	G72
T18	Meta Macarena (Ejemplo)	G00
T19	Nariño Occidente Montañoso	H64
T20	Norte de Santander Pamplona Región	I03
T21	Quindío Calarcá y Alrededores	I20
T22	Risaralda Balboa y Montaña	I32
T23	Santander Provincia Comunera	J21
T24	Sucre San Marcos Región	J50
T25	Tolima Espinal y Llano	J72
T26	Antioquia Occidente Cercano	B07
T27	Atlántico Soledad Conurbado	B45
T28	Bogotá D.C. Usaquén Residencial	B49
T29	Bolívar Zona Industrial Mamonal	B50
T30	Boyacá Provincia de Ricaurte	C46
T31	Caldas Palestina Aeropuerto	D35
T32	Caquetá Rural Florencia (Ejemplo)	D46
T33	Cauca Silvia Indígena (Ejemplo)	D95
T34	Cesar El Copey Agrícola	E13
T35	Córdoba Cereté Agrícola	E33
T36	Cundinamarca Provincia de Tequendama	F05
T37	Chocó Litoral San Juan (Ejemplo)	F86
T38	Huila Gigante y Represa	G14
T39	La Guajira Manaure Salinero	G50
T40	Magdalena Ariguaní Ganadero	G58
T41	Meta Puerto López Llanero	H05
T42	Nariño La Unión Cafetera	H46
T43	Norte de Santander Villa del Rosario Frontera	I17
T44	Quindío Filandia Turístico	I23
T45	Risaralda Marsella Cafetera	I38
T46	Santander Girón Colonial	I79
T47	Sucre Corozal Ganadero	J35
T48	Tolima Melgar Turístico	J83
T49	Antioquia Nordeste Minero	B05
T50	Atlántico Malambo Industrial	B33
T51	Bogotá D.C. Kennedy Popular	B49
T52	Bolívar Turbaco Cercano	B92
T53	Boyacá Paipa Turístico	C61
T54	Caldas Anserma Occidente	D21
T55	Caquetá Puerto Rico Ganadero	D56
T56	Cauca Piendamó Central	D88
T57	Cesar Bosconia Cruce Caminos	E09
T58	Córdoba Planeta Rica Ganadero	E44
T59	Cundinamarca Villeta Gualivá	F68
T60	Chocó Istmina Minero	F87
T61	Huila Pital Agrícola	G26
T62	La Guajira Fonseca Agrícola	G46
T63	Magdalena Fundación Agrícola	G66
T64	Meta Acacías Petrolero	G86
T65	Nariño Túquerres Altiplano	H76
T66	Norte de Santander Los Patios Metro	H99
T67	Quindío Montenegro Parque del Café	I26
T68	Risaralda Dosquebradas Industrial	I06
T69	Santander Floridablanca Metropolitana	I76
T70	Sucre Coveñas Turístico	J36
T71	Tolima Líbano Cafetero	J81
T72	Antioquia Jardín Suroeste	A61
T73	Atlántico Sabanalarga Central	B42
T74	Bogotá D.C. Suba Residencial	B49
T75	Bolívar Mompós Histórico Fluvial	B71
T76	Boyacá Soatá Norte	C90
T77	Caldas Chinchiná Cafetero Industrial	D24
T78	Caquetá San Vicente Frontera	D58
T79	Cauca El Tambo Agrícola	D72
T80	Cesar Aguachica Comercial Sur	E05
T81	Córdoba Sahagún Sabanero	E49
T82	Cundinamarca Cajicá Almeidas	E67
T83	Chocó Condoto Minero Río	F84
T84	Huila Garzón Central Cafetero	G13
T85	La Guajira Maicao Comercial Frontera	G49
T86	Magdalena El Banco Fluvial Comercial	G63
T87	Meta Granada Ariari	G96
T88	Nariño Ipiales Frontera Comercial	H41
T89	Norte de Santander Ocaña Provincial	I02
T90	Quindío Salento Turístico Montaña	I29
T91	Risaralda La Virginia Puerto	I37
T92	Santander San Gil Aventura	J13
T93	Sucre Tolú Viejo Tradicional	J47
T94	Tolima Honda Histórico Fluvial	J78
T95	Antioquia Marinilla del Oriente	A69
T96	La Guajira Barrancas Minero	G42
T97	Bogotá D.C. Fontibón Industrial	B49
T98	Bolívar Arjona Agrícola del Dique	B54
T99	Boyacá Moniquirá Panelero Turístico	C52
U50	Caldas Pensilvania Montañoso	D36
U51	Caquetá Solano Remoto (Ejemplo)	D59
U52	Cauca Corinto Agroindustrial Norte	D71
U53	Cesar Manaure Balcón Cesar	E19
U54	Córdoba Ciénaga de Oro Cultural	E36
U55	Cundinamarca Provincia de Sabana Centro Chía	E72
U56	Chocó Lloró Minero (Ejemplo)	F89
U57	Huila Rivera Turístico Termal	G28
U58	La Guajira Dibulla Costero Turístico	G43
U59	Magdalena Sitionuevo Ribereño	G81
U60	Meta Cubarral Piedemonte	G90
U61	Nariño Guachucal Altiplano Agrícola	H36
U62	Norte de Santander Sardinata Catatumbo	I11
U63	Quindío Buenavista Mirador	I19
U64	Risaralda Apía Montañoso Cafetero	I31
U65	Santander Barichara Colonial Turístico	I49
U66	Sucre Majagual La Mojana	J43
U67	Tolima Alvarado Agrícola	J59
U68	Antioquia Amalfi Nordeste	A06
U69	Atlántico Ponedera Oriental	B38
U70	Bogotá D.C. Ciudad Bolívar Sur	B49
U71	Bolívar Santa Rosa del Sur Minero	B87
U72	Boyacá Miraflores Lengupá	C49
U73	Caldas Aranzazu Norte	D22
U74	Caquetá Solita Rural (Ejemplo)	D60
U75	Cauca Buenos Aires Norte Afro	D67
U76	Cesar Chimichagua Ciénaga	E10
U77	Córdoba Momil Cultural Ciénaga	E41
U78	Cundinamarca Funza Industrial Sabana	E85
U79	Chocó Juradó Fronterizo Pacífico	F88
U80	Huila Aipe Petrolero Norte	G06
U81	La Guajira Albania Minero	G41
U82	Magdalena Pedraza Ribereño	G69
U83	Meta Mapiripán Llanos Orientales	G98
U84	Nariño El Charco Costa Pacífica	H30
U85	Norte de Santander Tibú Catatumbo Petrolero	I14
U86	Quindío Córdoba Montañoso Sur	I22
U87	Risaralda Mistrató Indígena Occidente	I39
U88	Santander Cimitarra Magdalena Medio	I63
U89	Sucre San Pedro Sabanero	J52
U90	Tolima Ambalema Histórico Tabacalero	J60
U91	Antioquia Jericó Suroeste Religioso	A62
U92	Atlántico Repelón Embalse	B40
U93	Bogotá D.C. Barrios Unidos Central	B49
U94	Bolívar Tiquisio Minero Sur	B91
U95	Boyacá Ramiriquí Provincia Márquez	C71
U96	Caldas Manzanares Oriente	D28
U97	Caquetá Valparaíso Rural (Ejemplo)	D61
U98	Cauca Cajibío Central Agrícola	D68
U99	Cesar Becerril Minero	E08
V00	Córdoba Moñitos Costero Turístico	E43
V01	Cundinamarca Cogua Embalse Neusa	E76
V02	Chocó Medio Atrato Ribereño (Ejemplo)	F90
V03	Huila Algeciras Agrícola Montañoso	G07
V04	La Guajira El Molino Cultural	G45
V05	Magdalena Remolino Ribereño	G74
V06	Meta Lejanías Turístico Ariari	H02
V07	Nariño Cumbal Volcánico Fronterizo	H27
V08	Norte de Santander Salazar de las Palmas Histórico	I07
V09	Quindío Génova Montañoso Sur	I24
V10	Risaralda Pueblo Rico Indígena Occidente	I40
V11	Santander Oiba Panelero Turístico	I99
V12	Sucre Chalán Montes de María Sucreño	J37
V13	Tolima Anzoátegui Montañoso Norte	J61
V14	Antioquia El Retiro Oriente Cercano	A84
V15	Atlántico Usiacurí Artesanal Turístico	B48
V16	Bogotá D.C. Antonio Nariño Sur	B49
V17	Bolívar San Pablo Sur Minero	B84
V18	Boyacá Ráquira Artesanal Turístico	C72
V19	Caldas Marquetalia Oriente Montañoso	D30
V20	Caquetá Albania Rural (Ejemplo)	D47
V21	Cauca Caldono Indígena Norte	D69
V22	Cesar El Copey Ganadero	E13
V23	Córdoba Puerto Escondido Costero	E46
V24	Cundinamarca Guaduas Histórico Ruta Mutis	E95
V25	Chocó Río Quito Minero (Ejemplo)	F96
V26	Huila Baraya Agrícola Norte	G09
V27	La Guajira Hatonuevo Minero	G47
V28	Magdalena San Zenón Ribereño	G78
V29	Meta Puerto Lleras Llanero	H06
V30	Nariño El Tambo Extenso Montañoso	H34
V31	Norte de Santander Convención Catatumbo	H87
V32	Quindío Pijao Cafetero Montañoso	I27
V33	Risaralda Santuario Natural Occidente	I43
V34	Santander Málaga Provincia García Rovira	I94
V35	Sucre El Roble Sabanero	J38
V36	Tolima Ataco Minero Sur	J63
V37	Antioquia Támesis Suroeste Turístico	B08
V38	Atlántico Campo de la Cruz Sur Ribereño	B28
V39	Bogotá D.C. Mártires Central Histórico	B49
V40	Bolívar Simití Serranía San Lucas	B88
V41	Boyacá Santana Ricaurte Bajo	C83
V42	Caldas Marulanda Páramo Ganadero	D31
V43	Caquetá Morelia Rural (Ejemplo)	D55
V44	Cauca El Tambo Rural Extenso	D72
V45	Cesar González Sur Agrícola	E16
V46	Córdoba Puerto Libertador Minero San Jorge	E47
V47	Cundinamarca Guatavita Turístico Embalse	E98
V48	Chocó San José del Palmar Cafetero (Ejemplo)	F98
V49	Huila Colombia Norte Montañoso	G11
V50	La Guajira Jagua del Pilar Fronterizo	G48
V51	Magdalena Tenerife Ribereño Histórico	G82
V52	Meta San Juan de Arama Piedemonte Ariari	H10
V53	Nariño Funes Altiplano Sur	H35
V54	Norte de Santander Cucutilla Montañoso	H88
V55	Quindío Quimbaya Turístico Cultural	I28
V56	Risaralda Guática Indígena Montañoso	I35
V57	Santander Onzaga Páramo Santurbán	I00
V58	Sucre Galeras Sabanero Cultural	J39
V59	Tolima Cajamarca Despensa Agrícola	J64
V60	Antioquia Hispania Suroeste Panelero	A58
V61	Atlántico Candelaria Oriental Agrícola	B29
V62	Bogotá D.C. Santa Fe Histórico Central	B49
V63	Bolívar Soplaviento Ribereño Dique	B89
V64	Boyacá Sativanorte Páramo Norte	C87
V65	Caldas Neira Norte Cafetero	D32
V66	Caquetá Milán Rural (Ejemplo)	D54
V67	Cauca Guachené Afro Norte Industrial	D74
V68	Cesar La Gloria Ribereño Sur	E17
V69	Córdoba Purísima Bajo Sinú	E48
V70	Cundinamarca Junín Provincia del Guavio	F03
V71	Chocó Sipí Minero Baudó (Ejemplo)	F99
V72	Huila Elías Cafetero Central	G12
V73	La Guajira Distracción Agrícola Centro	G44
V74	Magdalena Zapayán Ciénaga	G83
V75	Meta San Juanito Páramo Meta	H11
V76	Nariño Guaitarilla Montañoso Central	H37
V77	Norte de Santander Durania Metropolitano Cúcuta	H89
V78	Quindío Armenia Área Comercial	I18
V79	Risaralda La Celia Cafetero Occidente	I36
V80	Santander Sucre Provincia de Vélez	J23
V81	Sucre Guaranda La Mojana	J40
V82	Tolima Carmen de Apicalá Turístico Religioso	J65
V83	Antioquia Montebello Suroeste Cafetero	A70
V84	Atlántico Piojó Turístico Ecológico	B36
V85	Bogotá D.C. La Candelaria Cultural	B49
V86	Bolívar Talaigua Nuevo Ribereño Depresión Momposina	B90
V87	Boyacá Sativasur Páramo Histórico	C88
V88	Caldas Norcasia Embalse Oriental	D33
V89	Caquetá San José del Fragua Rural (Ejemplo)	D57
V90	Cauca Jambaló Indígena Montañoso	D77
V91	Cesar Pailitas Sur Ganadero	E20
V92	Córdoba San Andrés de Sotavento Resguardo Indígena	E50
V93	Cundinamarca La Calera Cercano Bogotá Turístico	F04
V94	Chocó Unguía Darién Fronterizo (Ejemplo)	G01
V95	Huila Guadalupe Cafetero Religioso	G15
V96	La Guajira Villanueva Sur Cultural	G54
V97	Magdalena Nueva Granada Agrícola	G68
V98	Meta Vistahermosa Macarena Sur	H13
V99	Nariño Gualmatán Altiplano Agrícola	H38
W00	Norte de Santander Gramalote Histórico Reconstruido	H93
W01	Quindío Circasia Cafetera	I21
W02	Risaralda Marsella Turística	I38
W03	Santander Tona Páramo Santurbán	J25
W04	Sucre La Unión Sabanero	J41
W05	Tolima Casabianca Montañoso Nevados	J66
W06	Antioquia Murindó Atrato Medio	A71
W07	Atlántico Polonuevo Central Agrícola	B37
W08	Bogotá D.C. Puente Aranda Industrial	B49
W09	Bolívar Turbana Cercano Industrial	B93
W10	Boyacá Siachoque Central Agrícola	C89
W11	Caldas Pácora Norte Cafetero	D34
W12	Caquetá Belén de los Andaquíes Rural (Ejemplo)	D48
W13	Cauca La Sierra Macizo Sur	D78
W14	Cesar Pelaya Sur Ribereño	E21
W15	Córdoba San Antero Costero Turístico	E51
W16	Cundinamarca La Palma Provincia Rionegro	F06
W17	Chocó Unión Panamericana (Ejemplo)	G02
W18	Huila Hobo Represa Betania	G16
W19	La Guajira Maicao Zona de Régimen Especial	G49
W20	Magdalena Pijiño del Carmen Sur Ribereño	G70
W21	Meta El Castillo Ariari Sur	G93
W22	Nariño Iles Altiplano Sur	H39
W23	Norte de Santander Hacarí Catatumbo	H94
W24	Quindío Buenavista Paisaje Cultural Cafetero	I19
W25	Risaralda Apía Cordillera Occidental	I31
W26	Santander Valle de San José Turístico	J26
W27	Sucre Los Palmitos Sabanero Montes de María	J42
W28	Tolima Chaparral Sur Cafetero	J67
W29	Antioquia Mutatá Urabá Antioqueño	A72
W30	Atlántico Suan Sur Ribereño	B46
W31	Bogotá D.C. Rafael Uribe Uribe Sur	B49
W32	Bolívar Villanueva Norte Cercano	B94
W33	Boyacá Socha Páramo Histórico	C92
W34	Caldas Palestina Cafetero Central	D35
W35	Caquetá Cartagena del Chairá Medio (Ejemplo)	D49
W36	Cauca La Vega Macizo Colombiano	D79
W37	Cesar Pueblo Bello Sierra Nevada	E22
W38	Córdoba San Bernardo del Viento Costero	E52
W39	Cundinamarca La Peña Provincia Rionegro	F07
W40	Chocó Acandí Darién Caribe (Ejemplo)	F74
W41	Huila Íquira Occidental Montañoso	G17
W42	La Guajira San Juan del Cesar Sur	G51
W43	Magdalena Pivijay Central Ganadero	G71
W44	Meta El Dorado Ariari	G94
W45	Nariño Imués Altiplano Sur	H40
W46	Norte de Santander Herrán Montañoso Fronterizo	H95
W47	Quindío Córdoba Cafetero Sur	I22
W48	Risaralda Mistrató Reserva Natural	I39
W49	Santander Zapatoca Turístico Colonial	J30
W50	Sucre Morroa Artesanal Sabanero	J44
W51	Tolima Coello Agrícola Central	J68
W52	Antioquia Nariño Oriente Páramo	A73
W53	Atlántico Tubará Turístico Ecológico Caribe	B47
W54	Bogotá D.C. San Cristóbal Suroriente	B49
W55	Bolívar Zambrano Ribereño Magdalena Medio	B95
W56	Boyacá Sogamoso Industrial Valle Sugamuxi	C93
W57	Caldas Pensilvania Oriental Montañoso	D36
W58	Caquetá Curillo Ganadero (Ejemplo)	D50
W59	Cauca López de Micay Costa Pacífica	D80
W60	Cesar Río de Oro Sur Agrícola	E23
W61	Córdoba San Carlos Sabanero Ganadero	E53
W62	Cundinamarca La Vega Turístico Climático	F08
W63	Chocó Alto Baudó Selva Pacífica (Ejemplo)	F75
W64	Huila Isnos Arqueológico Macizo	G18
W65	La Guajira Uribia Desierto Wayuu	G52
W66	Magdalena Remolino Pesquero Ciénaga	G74
W67	Meta Fuente de Oro Ariari Agrícola	G95
W68	Nariño Ipiales Comercio Fronterizo	H41
W69	Norte de Santander Labateca Montañoso Suroriente	H96
W70	Quindío Génova Cafetero Cordillera	I24
W71	Risaralda Pueblo Rico Biodiverso Occidente	I40
W72	Santander Aguada Provincia de Vélez	I45
W73	Sucre Palmito Sabanero Agrícola	J46
W74	Tolima Cunday Montañoso Oriente	J70
W75	Antioquia Necoclí Urabá Caribe	A74
W76	Atlántico Usiacurí Termal Artesanal	B48
W77	Bogotá D.C. Sumapaz Rural Páramo	B49
W78	Bolívar Achí Depresión Momposina Sur	B51
W79	Boyacá Somondoco Valle de Tenza	C94
W80	Caldas Salamina Patrimonio Cafetero	D39
W81	Caquetá El Doncello Ganadero Norte	D51
W82	Cauca Mercaderes Sur Macizo	D81
W83	Cesar San Alberto Agroindustrial Sur	E25
W84	Córdoba San Pelayo Cultural Porro	E54
W85	Cundinamarca Lenguazaque Minero Ubaté	F09
W86	Chocó Atrato Ribereño Central (Ejemplo)	F76
W87	Huila La Argentina Cafetero Occidental	G19
W88	La Guajira Albania Minero Central	G41
W89	Magdalena Sabanas de San Ángel Ganadero	G75
W90	Meta Guamal Piedemonte Turístico	G97
W91	Nariño La Cruz Macizo Oriental	H42
W92	Norte de Santander La Esperanza Montañoso Límite	H97
W93	Quindío Montenegro Turístico Quimbaya	I26
W94	Risaralda Quinchía Minero Cultural	I41
W95	Santander Albania Provincia de Vélez	I46
W96	Sucre Sampués Artesanal Cultural	J47
W97	Tolima Dolores Montañoso Suroriente	J71
W98	Antioquia Nechí Bajo Cauca Minero	A75
W99	Atlántico Santo Tomás Oriental Cultural	B44
X00	Bogotá D.C. Tunjuelito Sur Industrial	B49
X01	Bolívar Altos del Rosario Ribereño Sur	B52
X02	Boyacá Sora Central Agrícola	C95
X03	Caldas San José Cafetero Occidental	D41
X04	Caquetá La Montañita Rural Central (Ejemplo)	D53
X05	Cauca Miranda Azucarero Norte	D82
X06	Cesar San Diego Agrícola Perijá	E26
X07	Córdoba Tierralta Alto Sinú Parque Natural	E55
X08	Cundinamarca Machetá Provincia Almeidas	F10
X09	Chocó Bagadó Minero Atrato (Ejemplo)	F77
X10	Huila La Plata Occidental Agrícola	G20
X11	La Guajira Barrancas Carbón Central	G42
X12	Magdalena Salamina Ribereño Histórico	G76
X13	Meta La Macarena Parque Natural Turístico	G00
X14	Nariño La Florida Volcánico Galeras	H43
X15	Norte de Santander La Playa de Belén Turístico Colonial	H98
X16	Quindío Pijao Cafetero Cordillerano	I27
X17	Risaralda Santa Rosa de Cabal Termales	I42
X18	Santander Aratoca Cañón Chicamocha	I47
X19	Sucre San Benito Abad La Mojana Ganadero	J48
X20	Tolima Espinal Arrocero Llano	J72
X21	Antioquia Olaya Occidente Histórico	A76
X22	Atlántico Palmar de Varela Agroindustrial	B35
X23	Bogotá D.C. Usme Sur Rural	B49
X24	Bolívar Arenal Sur Minero	B53
X25	Boyacá Sotaquirá Central Agrícola	C96
X26	Caldas Supía Minero Occidental	D42
X27	Caquetá Milán Ganadero Rural (Ejemplo)	D54
X28	Cauca Morales Central Indígena	D83
X29	Cesar San Martín Sur Petrolero	E27
X30	Córdoba Valencia Alto Sinú Agrícola	E56
X31	Cundinamarca Madrid Sabana Occidente Industrial	F11
X32	Chocó Bahía Solano Biodiversidad Pacífica (Ejemplo)	F78
X33	Huila Nátaga Cafetero Occidental	G21
X34	La Guajira Dibulla Tayrona Turístico	G43
X35	Magdalena San Sebastián de Buenavista Ribereño Sur	G77
X36	Meta Lejanías Ariari Turístico Montañoso	H02
X37	Nariño La Llanada Minero Occidental	H44
X38	Norte de Santander Lourdes Metropolitano Histórico	H00
X39	Quindío Salento Valle de Cócora	I29
X40	Risaralda Santuario Parque Natural Tatamá	I43
X41	Santander Barbosa Comercial Panelero	I48
X42	Sucre San Juan de Betulia Sabanero	J49
X43	Tolima Falan Minero Histórico	J73
X44	Antioquia Peñol Embalse Turístico	A77
X45	Atlántico Piojó Ecológico Costero	B36
X46	Bogotá D.C. Ciudad Bolívar Urbano Sur	B49
X47	Bolívar Arroyohondo Canal del Dique	B55
X48	Boyacá Soracá Central Agrícola	C97
X49	Caldas Victoria Magdalena Caldense Oriental	D43
\.


                                                                                                                                                                                                                                                                                                                                                                          5132.dat                                                                                            0000600 0004000 0002000 00000257672 15014423351 0014265 0                                                                                                    ustar 00postgres                        postgres                        0000000 0000000                                                                                                                                                                        S001	EsenciasGlobales	S.A.	ventas@esenciasglobal.com	Zona Franca Palmaseca, Bodega 10
S002	AromasDelMundo	Ltda.	3001234501	Calle 100 # 20-30, Of. 501
S003	FraganciasPuras	Corp.	pedidos@fraganciaspuras.co	Carrera 15 # 82-44, Local 3
S004	EnvasesPremium	\N	3109876502	Parque Industrial Celta, Lote 22A
S005	QuimicosAromaticos	S.A.S.	info@quimaromas.com	Avenida El Dorado # 68C-61
S006	VidrioPack	Internacional	3205551203	Autopista Medellín Km 5, Bodega 7
S007	EtiquetasPrint	\N	cotizaciones@etiprint.net	Calle 72 # 10-83, Piso 2
S008	DistribucionesVIP	Group	3017654304	Centro Empresarial Connecta, Modulo B
S009	MateriaPrimaNatural	Bio	compras@matprimanatural.org	Vereda El Retiro, Finca La Esperanza
S010	ImportacionesLujo	S.L.	3151237805	Oficina 707, World Trade Center Bogotá
S011	Carlos	Ramirez	c.ramirez@suministros.com	Calle Falsa 123, Apto 101
S012	Lucia	Vargas	3002345606	Transversal 5 # 45-12, Bodega Sur
S013	PerfumeIngredients	Co.	support@perfumeing.com	Km 7 Via Siberia, Parque Logístico
S014	PackagingSolutions	\N	3108765407	Zona Industrial Montevideo, Bodega 15
S015	AromaSource	Chemicals	sales.dept@aromasource.com	Calle 26 # 92-32, Complejo T2
S016	GlassBottlePros	Inc.	3204441208	Manzana C Lote 5, Parque Arinco
S017	LabelMasters	Print	info@labelmasters.co	Carrera 68 # 12-50, Local 10B
S018	LuxurySupplyChain	\N	3016543209	Edificio Teleport, Torre C, Of. 901
S019	OrganicExtracts	Ltd.	orders@organicextracts.net	Finca Las Acacias, Guarne, Ant.
S020	GlobalFragranceImporters	\N	3152348710	Calle 93 # 11A-28, Of. 303
S021	Roberto	Nuñez	roberto.n@distripack.com	Avenida Boyacá # 70-20
S022	Ana	Sarmiento	3003456711	Parque Industrial Tibitoc, Bodega 3C
S023	BotanicalEssences	World	contact@botanicaless.com	Vía Funza-Siberia, Lote Esmeralda
S024	ContainerSupply	Co.	3107654312	Zona Franca Bogotá, Bodega Alfa 7
S025	FineChemicals	Trading	fctrade@mail.com	Carrera 7 # 116-50, Of. 604
S026	BottleManufacturing	S.A.	3203331213	Autopista Sur Km 10, Complejo Vidrial
S027	PrintingServicesPro	\N	sales@printpro.co	Calle 13 # 45-67, Taller 2
S028	EliteDistribution	Co.	3015432114	Centro Logístico San Cayetano, Bodega 11
S029	NaturalIngredients	Source	info.natural@ingsource.com	Corregimiento Santa Elena, Finca El Mirador
S030	PrestigeImports	LLC	3153459815	Calle 109 # 15-33, Suite 400
S031	Javier	Mendoza	javier.m@globalpack.net	Carrera 50 # 30-10, Local A
S032	Isabel	Castro	3004567816	Zona Industrial Cazucá, Bodega Beta
S033	WorldOfAromas	Inc.	info@worldofaromas.biz	Avenida Las Américas # 50-50, Piso 3
S034	PackagingWorld	\N	3106543217	Parque Empresarial Metropolitano, Bodega 21
S035	AromaticCompounds	Ltd.	orders.ac@chemtrade.com	Calle 80 # 70-15, Complejo Industrial
S036	SpecialtyGlass	Corp.	3202221218	Vía Mosquera, Parque Logístico La Florida
S037	LabelAndPrint	Solutions	contact@labelprintsol.com	Carrera 30 # 5C-75, Of. 201
S038	PremiumLogistics	S.A.S.	3014321019	Centro de Distribución Fontibón, Mod. Gamma
S039	PureEssenceOils	Co.	pure.oils@essenceco.net	Finca La Esmeralda, Salento, Quindío
S040	InternationalScents	\N	3154560920	Calle 127 # 7A-45, Of. 802
S041	Andres	Cordoba	andres.c@supplychainpros.co	Diagonal 25G # 95A-55, Bodega 5
S042	Laura	Guerrero	3005678921	Parque Industrial Terrapuerto, Bodega Delta
S043	FragranceLab	Global	lab@fragrancelabglobal.com	Zona Franca Rionegro, Unidad 12
S044	BoxAndBottle	Supply	3105432122	Centro Industrial Arroyohondo, Bodega 18
S045	ChemicalBrokers	Intl.	brokers@chembrokers.com	Carrera 11 # 93-03, Piso 5
S046	ArtisanGlassware	\N	3201111223	Vereda El Carmen, Taller Artesanal El Vidrio
S047	CustomLabelsNow	Inc.	sales@customlabelsnow.com	Calle 63 # 24-80, Local C
S048	SupplyChainMasters	Group	3013210924	Edificio Capital Tower, Of. 1105
S049	HerbalExtractsCo	S.A.	info@herbalextractsco.com	Finca Los Naranjos, Calarcá, Quindío
S050	LuxuryGoodsImport	Co.	3155671025	Avenida Chile # 75-20, Of. 1001
S051	ComponentesEsenciales	S.A.S.	contact@compesenciales.com	Parque Logístico Siberia, Modulo 7
S052	Ricardo	Giraldo	3118765432	Calle 50 # 15-25, Bodega Norte
S053	AromasNativos	BioExtract	info@aromasnativos.bio	Corregimiento La Elvira, Cali, Finca Aroma
S054	EnvasesDelValle	Ltda.	ventas.valle@envases.co	Zona Industrial Yumbo, Bodega 14B
S055	Quimifar	S.A.	pedidos@quimifar.com.co	Carrera 4 # 22-10, Centro, Bogotá
S056	CristalPack	Solutions	3027659801	Autopista Norte Km 12, Bodega Cristal
S057	ImpresionesCreativas	\N	arte@impresionescrea.net	Calle de los Oficios 10-A, Taller
S058	LogisticaTotal	Group	3183217654	Centro de Carga El Dorado, Oficina 203
S059	ExtractosAndinos	Natural	compras@extractosandinos.org	Vereda San Jorge, Manizales, Lote 5
S060	ImportadoraSelecta	S.L.	3147650123	Oficina 1201, Torre Empresarial Andina
S061	Marina	Fuentes	marina.f@suministrosglobal.com	Avenida Caracas # 30-55, Local 12
S062	Esteban	Pizarro	3058763412	Transversal 15 # 98-02, Bodega Este
S063	EssentialOilsCo	Global	support@essentialoilsglobal.com	Km 3 Via Funza, Parque Industrial Zeta
S064	CustomPackaging	\N	3123459876	Zona Industrial Montevideo, Bodega 28 Sur
S065	FragranceCompounds	Chem	sales.fc@fragcomp.com	Calle 13 # 88-15, Complejo Químico
S066	GlassArtisans	Inc.	3178904321	Manzana F Lote 8, Parque Industrial Malambo
S067	LabelInnovations	PrintCo	info@labelinnovate.co	Carrera 70 # 5-22, Local 3C
S068	SupplySolutionsPro	\N	3025671234	Edificio North Point, Torre A, Of. 1504
S069	AmazonianRoots	Extracts	orders@amazonroots.net	Leticia, Amazonas, Centro Acopio
S070	FineFragranceImports	\N	3161237654	Calle 100 # 8A-55, Of. 702, Bogotá
S071	Alejandro	Velez	alejov@distriempaques.com	Avenida 68 # 40-10 Sur
S072	Beatriz	Londoño	3192340123	Parque Industrial San Diego, Bodega Gamma 2
S073	HerbalTraditions	World	contact@herbaltraditions.com	Vía La Calera Km 9, Finca El Arrayán
S074	EcoContainers	S.A.S.	3046783210	Zona Franca Barranquilla, Bodega Verde 1
S075	PharmaChemicals	Trade	pharma.trade@chemnet.com	Carrera 9 # 120-30, Of. 901
S076	CrystalBottleMakers	\N	3135676543	Autopista Medellín Km 2, Complejo El Vidriero
S077	PrecisionPrinting	Co.	sales@precisionprint.co	Calle 45 # 20-80, Taller 5A
S078	GlobalLogisticsPartner	\N	3218909876	Centro Logístico La Sabana, Bodega Omega
S079	AndeanBotanicals	Source	info.andean@botanicsource.com	Corregimiento Pasquilla, Usme, Finca La Huerta
S080	ExclusiveImports	Group	3009871234	Calle 116 # 19-45, Suite 808
S081	Fernando	Rojas	fernando.r@packagingsupply.net	Carrera 27 # 10-05, Local B
S082	Gabriela	Camacho	3101230987	Zona Industrial Fontibón, Bodega Alfa 9
S083	ScentMasters	Intl.	info@scentmastersintl.biz	Avenida El Poblado # 10-200, Medellín, Piso 8
S084	TotalPackaging	Corp.	3157659876	Parque Empresarial Las Palmas, Bodega 33
S085	SpecialtyChemicals	Ltd.	orders.sc@spechem.com	Calle 90 # 60-25, Complejo Industrial Norte
S086	DesignerGlass	\N	3012348765	Vía Tenjo, Parque Logístico El Rosal
S087	PrintAndLabel	Tech	contact@printlabeltech.com	Carrera 50 # 1A- Sur, Of. 305
S088	SupplyChainExperts	S.A.	3208764321	Centro de Distribución Toberín, Mod. Beta 4
S089	RainforestEssences	Co.	rain.essence@forestco.net	Mocoa, Putumayo, Centro de Extracción
S090	WorldClassScents	\N	3186547654	Calle 98 # 22-64, Of. 1103, Bogotá
S091	Oscar	Montoya	oscar.m@logisticssolutions.co	Diagonal 45 # 16-88, Bodega 12
S092	Valentina	Herrera	3027651234	Parque Industrial Cartagena Mamonal, Bodega Eco
S093	AromaFusion	Labs	lab@aromafusionglobal.com	Zona Franca del Pacífico, Unidad Beta 5
S094	EcoPackGlobal	Supply	3147654321	Centro Industrial Argelia, Bodega 22
S095	FineChemSolutions	Intl.	fcs@finechemsol.com	Carrera 13 # 93A-45, Piso 9, Bogotá
S096	ArtGlassCreations	\N	3058760123	Vereda La Clara, Guatapé, Taller Vidrio Arte
S097	DigitalLabelsCo	Inc.	sales@digitallabelsco.com	Calle 76 # 30-10, Local D2
S098	LogisticsProServices	Group	3123458765	Edificio Titanium Plaza, Of. 1802, Cali
S099	MountainHerbs	Extracts	info@mountainherbs.co	Finca El Manantial, Salento, Risaralda
S100	GlobalSourcingCo	Imports	3178903210	Avenida Pepe Sierra # 15-60, Of. 1204
S101	PureIngredients	Global	pure@ingredientsglobal.com	Zona Franca Intexzona, Bodega A5
S102	Santiago	Patiño	3001112233	Calle Larga # 2-10, Getsemaní, Cartagena
S103	ExoticAromas	Source	exotic@aromasource.net	Santa Marta, Magdalena, Finca Tropical
S104	ProEnvases	S.A.S.	comercial@proenvases.com.co	Zona Industrial La Popa, Dosquebradas
S105	ChemTradeCo	International	info@chemtradeco.com	Carrera 19 # 100-20, Of. 401, Bogotá
S106	CrystalClearGlass	\N	3119998877	Parque Industrial Palermo, Barranquilla
S107	LabelRight	Printing	ventas@labelright.co	Avenida de las Ferias 5-50, Taller
S108	SupplyChainInnovators	\N	3165554433	Torre KLM, Piso 10, Medellín
S109	BioActiveExtracts	Ltd.	bioactive@extracts.com.org	Vereda El Roble, Chía, Cundinamarca
S110	WorldWideImports	Corp.	3018887766	Oficina 905, Centro Internacional Tequendama
S111	Daniela	Alvarez	daniela.a@globalsupply.co	Calle Principal 123, Bodega Central
S112	Mateo	Benavides	3227776655	Transversal Superior # 10-110, El Poblado
S113	NaturesEssence	Co.	support@naturesessence.co	Km 10 Vía Cali-Yumbo, Parque Logístico
S114	PackagingPros	Solutions	3056665544	Zona Industrial Arroyohondo, Bodega Magna
S115	AromaChem	Supplies	orders@aromachemsupplies.com	Calle 10 # 43A-30, Complejo Industrial Sur
S116	PremiumBottles	Inc.	3125554433	Manzana D Lote 1, Parque Industrial El Bosque
S117	LabelTech	Innovations	info@labeltechinnov.com	Carrera 25 # 33-15, Local 1A, Bucaramanga
S118	LogisticsSolutions	Global	3184443322	Edificio Calle 100 Plaza, Torre B, Of. 1101
S119	WildHarvest	Extracts	compras@wildharvest.net	Florencia, Caquetá, Centro Agroindustrial
S120	GlobalFragranceHub	\N	3043332211	Calle 85 # 19C-12, Of. 505, Bogotá
S121	Camila	Zuluaga	camila.z@distripet.com	Avenida Ferrocarril # 20-40, Santa Marta
S122	David	Ospina	3172221100	Parque Industrial Juanchito, Bodega Zafiro
S123	OriginBotanics	World	contact@originbotanics.com	Vía Pereira-Armenia Km 5, Finca El Edén
S124	EcoFriendlyContainers	S.A.	3021110099	Zona Franca La Candelaria, Cartagena, Bodega Sol
S125	FineChemGlobal	Trading	fcg.trade@mailglobal.com	Carrera 15 # 93-60, Of. 1002, Bogotá
S126	ArtisanBottleDesign	\N	3130009988	Autopista Sur Km 15, Taller Vidrio Soplado
S127	QuickPrintLabels	Co.	sales@quickprint.co.net	Calle 53 # 16-35, Taller 8B, Bogotá
S128	ProLogistics	Network	3219998877	Centro Logístico Buenaventura, Bodega Pacifico
S129	JungleEssences	Source	info.jungle@essencesource.com	Mitú, Vaupés, Comunidad Indígena
S130	SelectImports	Group	3008887766	Calle 72 # 7-64, Suite 600, Bogotá
S131	Sebastian	Cardenas	sebastian.c@packpro.net	Carrera 80 # 25-10, Local Industrial
S132	Sofia	Rincon	3107776655	Zona Industrial El Recreo, Bodega Diamante
S133	ScentUniverse	Intl.	info@scentuniverse.biz	Avenida Las Vegas # 30-150, Envigado, Piso 4
S134	UniPackaging	Corp.	3156665544	Parque Empresarial del Norte, Bodega 45, Bogotá
S135	AgroChemicals	Ltd.	orders.agro@chemind.com	Calle 75 # 50-05, Complejo Agroindustrial
S136	ElegantGlassware	\N	3015554433	Vía Girardota, Parque Logístico Antioquia
S137	LabelPro	Solutions	contact@labelprosol.com	Carrera 43 # 80-120, Of. 401, Barranquilla
S138	ExpertLogistics	S.A.	3204443322	Centro de Distribución Occidente, Mod. Delta 1
S139	TropicalEssence	Co.	tropical@essenceco.net	Villavicencio, Meta, Finca La Victoria
S140	WorldScentImports	\N	3183332211	Calle 106 # 19A-05, Of. 1005, Bogotá
S141	Nicolas	Gomez	nicolas.g@logipro.co	Diagonal 70 # 20-50, Bodega Alfa
S142	Manuela	Torres	3022221100	Parque Industrial del Cauca, Bodega Andina
S143	FragranceSource	Global	source@fragsourceglobal.com	Zona Franca de Occidente, Unidad Delta 8
S144	GreenPack	Supply	3141110099	Centro Industrial El Dorado, Bodega 30
S145	PrimeChem	Intl.	prime@primechemintl.com	Carrera 7 # 71-21, Torre B, Piso 12, Bogotá
S146	GlassMasters	\N	3050009988	Vereda La Cejita, Copacabana, Taller El Crisol
S147	NextGenLabels	Inc.	sales@nextgenlabels.com	Calle 68 # 15-90, Local E1, Bogotá
S148	ProChainLogistics	Group	3129998877	Edificio Business Center, Of. 2001, Medellín
S149	ForestBotanics	Extracts	info@forestbotanics.co	Finca El Paraíso, Guaviare
S150	EliteSourcing	Imports	3178887766	Avenida El Libertador # 25-80, Of. 1500, Sta Marta
S151	AlphaIngredients	Corp.	alpha@ingredientscorp.com	Zona Franca Fontibón, Bodega B7
S152	Juan	Vallejo	3002223344	Calle Angosta # 1-5, Mompox, Bolívar
S153	PacificAromas	Source	pacific@aromasnet.com	Buenaventura, Valle, Finca Marina
S154	CartonPack	S.A.	ventas@cartonpack.com.co	Zona Industrial Belén, Medellín
S155	VertexChemicals	Global	info@vertexchem.com	Carrera 13 # 85-30, Of. 602, Bogotá
S156	ShineGlass	\N	3118887766	Parque Industrial La Nubia, Manizales
S157	PerfectLabel	Printing	pedidos@perfectlabel.co	Avenida Boyacá # 60-20, Taller Sur
S158	AgileLogistics	Solutions	3164445566	Torre Empresarial del Este, Piso 14, Bucaramanga
S159	AndeanBio	Extracts	andean@bioextracts.com	Vereda El Rosal, Zipaquirá, Cund.
S160	PremiumSelect	Imports	3017778899	Oficina 1102, Centro Ejecutivo Bocagrande
S161	Laura	Castaño	laura.c@supplyglobal.co	Calle Larga 456, Bodega Principal
S162	Samuel	Diaz	3226667788	Transversal Inferior # 5-150, El Tesoro, Medellín
S163	PurityEssence	Co.	contact@purityessence.co	Km 5 Vía Siberia-Cota, Parque Industrial Oasis
S164	BoxSolutions	Packaging	3055556677	Zona Industrial Guayabal, Bodega Esmeralda
S165	NovaAroma	Chemicals	orders.nova@aromachem.com	Calle 17 # 55-40, Complejo Industrial Central
S166	ElegantBottles	Inc.	3124445566	Manzana G Lote 3, Parque Industrial La Montaña
S167	TopLabel	Innovations	info@toplabelinnov.com	Carrera 30 # 40-25, Local 2B, Cali
S168	SwiftLogistics	Global	3183334455	Edificio World Business Port, Torre A, Of. 1403
S169	OrinocoHarvest	Extracts	compras.orinoco@harvest.net	Puerto Carreño, Vichada, Centro de Acopio Selva
S170	MasterFragrance	Hub	3042223344	Calle 90 # 18-25, Of. 708, Bogotá
S171	Mario	Bedoya	mario.b@distriflex.com	Avenida Santander # 30-50, Manizales
S172	Paula	Navarro	3171112233	Parque Industrial del Café, Bodega Rubi
S173	AncientHerbs	World	support@ancientherbs.com	Vía Tabio-Tenjo Km 2, Finca Los Sauces
S174	SecureContainers	S.A.	3020001122	Zona Franca de Bogotá, Bodega Segura 3
S175	ChemSource	Trading	chemsource.trade@mailsrc.com	Carrera 11 # 82-71, Of. 1201, Bogotá
S176	UniqueBottleDesign	\N	3139990011	Autopista Norte Km 20, Taller Vidrio Único
S177	ProPrintSolutions	Co.	sales.proprint@printsol.co	Calle 60 # 10-45, Taller 10C, Medellín
S178	EfficientLogistics	Network	3218889900	Centro Logístico del Caribe, Bodega Atlántico
S179	SierraNevadaEssences	Source	info.sierra@essencesrc.com	Vereda Minca, Santa Marta, Finca Aurora
S180	ChoiceImports	Group	3007778899	Calle 82 # 10-10, Suite 905, Bogotá
S181	Diego	Arango	diego.a@packlogistics.net	Carrera 65 # 30-15, Local Industrial Sur
S182	Isabella	Mora	3106667788	Zona Industrial El Poblado, Bodega Topacio
S183	AromaDeluxe	Intl.	info@aromadeluxe.biz	Avenida El Libertador # 40-200, Pereira, Piso 6
S184	FlexiPackaging	Corp.	3155556677	Parque Empresarial Sabana Norte, Bodega 50, Cajicá
S185	PetroChemicals	Ltd.	orders.petro@chemfocus.com	Calle 68 # 45-15, Complejo Petroquímico
S186	PrimeGlassware	\N	3014445566	Vía Briceño-Sopó, Parque Logístico Andino
S187	LabelCraft	Solutions	contact@labelcraftsol.com	Carrera 52 # 85-130, Of. 502, Itagüí
S188	ReliableLogistics	S.A.	3203334455	Centro de Distribución Oriental, Mod. Gamma 3
S189	CoastalEssence	Co.	coastal@essencecoastal.net	Coveñas, Sucre, Finca Brisa Marina
S190	WorldChoiceScents	\N	3182223344	Calle 100 # 19-50, Of. 1408, Bogotá
S191	Lucas	Restrepo	lucas.r@logisticspro.co	Diagonal 60 # 15-60, Bodega Beta
S192	Antonia	Salazar	3021112233	Parque Industrial de Palmira, Bodega Cañaveral
S193	FragranceArt	Global	art@fragartglobal.com	Zona Franca de Pereira, Unidad Gamma 6
S194	TerraPack	Supply	3140001122	Centro Industrial El Rosal, Bodega 40
S195	SelectChem	Intl.	select@selectchemintl.com	Carrera 9 # 76-49, Torre C, Piso 15, Bogotá
S196	DecoGlass	\N	3059990011	Vereda El Tablazo, Rionegro, Taller El Vitral
S197	CustomPrint	Inc.	sales.custom@printnow.com	Calle 70 # 12-80, Local F3, Pereira
S198	ChainProLogistics	Group	3128889900	Edificio Smart Office, Of. 2205, Barranquilla
S199	HighlandHerbs	Extracts	info@highlandherbs.co	Finca La Cumbre, Manizales, Caldas
S200	GlobalTradeCo	Imports	3177778899	Avenida San Martín # 5-10, Of. 1800, Cartagena
S201	OmegaIngredients	S.A.S.	omega@ingredients.com.co	Zona Franca del Eje, Bodega C2
S202	Valeria	Guzman	3003334455	Calle Real # 3-25, Honda, Tolima
S203	IslandAromas	Source	island@aromas.net.co	San Andrés Isla, Finca Coralina
S204	EcoCarton	Solutions	info@ecocarton.com	Zona Industrial Cazucá, Soacha, Bodega Recicla
S205	InnovaChemicals	Corp.	innovachem@mail.com	Carrera 10 # 92-15, Of. 803, Bogotá
S206	ArtisticGlass	\N	3117778899	Parque Industrial Malambo II, Barranquilla
S207	VividLabels	Printing	pedidos.vivid@labels.co	Avenida Oriental # 50-30, Taller Color
S208	StreamlineLogistics	S.A.	3163334455	Torre Central, Piso 16, Cali
S209	MountainBio	Extracts	mountain@bioextracts.net	Vereda La Florida, Pereira, Risaralda
S210	EliteChoice	Imports	3016667788	Oficina 1501, Edificio Santa Fe Real, Medellín
S211	Bruno	Contreras	bruno.c@supplynet.co	Calle Larga Este 789, Bodega Delta
S212	Julieta	Escobar	3225556677	Transversal de la Montaña # 8-120, La Calera
S213	ZenEssence	Co.	contact.zen@essence.co	Km 8 Vía Tenjo-Tabio, Parque Industrial Shanti
S214	SecurePack	Packaging	3054445566	Zona Industrial Puente Aranda, Bodega Segura
S215	AuraAroma	Chemicals	orders.aura@aromachemco.com	Calle 20 # 60-50, Complejo Industrial Suroriente
S216	FlawlessBottles	Inc.	3123334455	Manzana H Lote 5, Parque Industrial La Estrella
S217	NextLevelLabels	Innovations	info.next@labelinnov.com	Carrera 35 # 50-35, Local 3C, Bucaramanga
S218	AgilityLogistics	Global	3182223344	Edificio Business Tower, Torre C, Of. 1605, Bquilla
S219	SavannaHarvest	Extracts	compras.savanna@harvest.co	Yopal, Casanare, Centro de Acopio Llanero
S220	PrestigeFragrance	Hub	3041112233	Calle 95 # 15-35, Of. 909, Bogotá
S221	Emilio	Zambrano	emilio.z@distrifarma.com	Avenida El Río # 25-60, Cúcuta
S222	Renata	Pardo	3170001122	Parque Industrial de Occidente, Bodega Platino
S223	SacredHerbs	World	support.sacred@herbs.com	Vía Guatavita Km 3, Finca Laguna Sagrada
S224	GuardianContainers	S.A.	3029990011	Zona Franca de Rionegro, Bodega Guardián 5
S225	ApexChem	Trading	apex.trade@chemsource.net	Carrera 14 # 80-65, Of. 1402, Bogotá
S226	BespokeBottleDesign	\N	3138889900	Autopista del Café Km 12, Taller Vidrio Fino
S227	UltraPrintSolutions	Co.	sales.ultra@printsol.co	Calle 65 # 12-55, Taller 12D, Medellín
S228	DynamicLogistics	Network	3217778899	Centro Logístico del Sur, Bodega Andina II
S229	ValleyEssences	Source	info.valley@essencesrc.net	Vereda El Placer, Cerrito, Valle, Finca Edén
S230	ConnoisseurImports	Group	3006667788	Calle 77 # 12-20, Suite 1010, Bogotá
S231	Tomas	Ortega	tomas.o@packinnovate.net	Carrera 70 # 35-25, Local Industrial Central
S232	Gabriela	Santos	3105556677	Zona Industrial La Badea, Bodega Ónix, Dosquebradas
S233	ElixirAromas	Intl.	info@elixiraromas.biz	Avenida Circunvalar # 5-100, Pereira, Piso 7
S234	SmartPackaging	Corp.	3154445566	Parque Empresarial La Florida, Bodega 60, Funza
S235	AgroChemSource	Ltd.	orders.agro@chemsource.co	Calle 70 # 40-10, Complejo Agrícola
S236	MajesticGlassware	\N	3013334455	Vía Copacabana-Girardota, Parque Industrial Cristal
S237	LabelWorks	Solutions	contact@labelworks.com	Carrera 48 # 75-140, Of. 603, Barranquilla
S238	VertexLogistics	S.A.	3202223344	Centro de Distribución Norte, Mod. Epsilon 5
S239	DesertEssence	Co.	desert@essenceco.org	Uribia, La Guajira, Finca Wayuu
S240	PrestigeScentImports	\N	3181112233	Calle 103 # 18A-15, Of. 1208, Bogotá
S241	Julian	Pineda	julian.p@logisticplus.co	Diagonal 75 # 25-70, Bodega Gamma
S242	Sara	Ramirez	3020001122	Parque Industrial de Siberia, Bodega Nevada
S243	AromaCraft	Global	craft@aromacraftglobal.com	Zona Franca de Palmaseca, Unidad Epsilon 7
S244	NaturePack	Supply	3149990011	Centro Industrial El Cortijo, Bodega 50
S245	GlobalChem	Intl.	global@globalchemintl.com	Carrera 10 # 70-30, Torre D, Piso 18, Bogotá
S246	CrystalDesignGlass	\N	3058889900	Vereda El Retiro, Caldas, Taller El Diamante
S247	PrimeLabels	Inc.	sales.prime@labelsnow.net	Calle 72 # 18-95, Local G5, Manizales
S248	CoreLogistics	Group	3127778899	Edificio Prisma Business, Of. 2500, Cali
S249	HighMountainBotanics	Extracts	info@hmbotanics.co	Finca El Nevado, Santa Rosa de Cabal
S250	SignatureSourcing	Imports	3176667788	Avenida Del Mar # 10-50, Of. 2000, Cartagena
S251	CentralIngredients	Ltda.	central@ingredients.co	Zona Franca de Tocancipá, Bodega D4
S252	Mariana	Villegas	3004445566	Calle de la Iglesia # 4-40, Salento, Quindío
S253	TropicalAromas	Pure	tropical@aromaspure.com	Taganga, Santa Marta, Finca Caribeña
S254	PaperBox	Solutions	info@paperbox.net	Zona Industrial Itagüí, Bodega Cartón
S255	ChemConnect	S.A.	connect@chemconnect.com.co	Carrera 16 # 97-46, Of. 904, Bogotá
S256	GalaGlass	\N	3116667788	Parque Industrial del Sur, Neiva
S257	DynamicLabels	Printing	pedidos.dynamic@labels.net	Avenida Roosevelt # 30-10, Taller Digital
S258	LinkLogistics	Services	3162223344	Torre Empresarial Connect, Piso 18, Medellín
S259	AndesGreen	Extracts	andes@greenextracts.org	Vereda El Verjón, Choachí, Cund.
S260	GlobalChoice	Imports	3015556677	Oficina 1802, Edificio Trade Center, Barranquilla
S261	Felipe	Herrera	felipe.h@globalsources.co	Calle Peatonal 101, Bodega Sol
S262	Carolina	Mejia	3224445566	Transversal Oriental # 12-150, Floridablanca
S263	AuraEssence	Co.	contact.aura@essence.net	Km 12 Vía Mosquera-Funza, Parque Industrial Aura
S264	ProtectPack	Packaging	3053334455	Zona Industrial Cazucá II, Bodega Protección
S265	ElementAroma	Chemicals	orders.element@aromachem.net	Calle 25 # 70-60, Complejo Industrial Oeste
S266	RegalBottles	Inc.	3122223344	Manzana J Lote 7, Parque Industrial Guarne
S267	VisionLabels	Innovations	info.vision@labelinnov.net	Carrera 38 # 60-45, Local 4D, Pereira
S268	ConnectLogistics	Global	3181112233	Edificio City Business, Torre D, Of. 1807, Cali
S269	OrchidHarvest	Extracts	compras.orchid@harvest.org	Fusagasugá, Cundinamarca, Finca Las Orquídeas
S270	CosmoFragrance	Hub	3040001122	Calle 92 # 16-45, Of. 1110, Bogotá
S271	Alejandra	Bernal	alejandra.b@distrilog.com	Avenida El Consulado # 30-70, Cartagena
S272	Cristian	Franco	3179990011	Parque Industrial del Norte, Bodega Zircón, Tunja
S273	MysticHerbs	World	support.mystic@herbs.net	Vía Suesca Km 5, Finca Piedra Sagrada
S274	SafeContainers	S.A.	3028889900	Zona Franca de Pereira, Bodega Segura 7
S275	SourceChem	Trading	source.trade@chemsource.org	Carrera 12 # 78-55, Of. 1603, Bogotá
S276	UniqueBottleCraft	\N	3137778899	Autopista del Sol Km 8, Taller Vidrio Artístico
S277	PrimePrintSolutions	Co.	sales.prime@printsol.org	Calle 70 # 15-65, Taller 15E, Manizales
S278	FlowLogistics	Network	3216667788	Centro Logístico del Oriente, Bodega Cafetera
S279	AmazonEssences	Source	info.amazon@essencesrc.org	Leticia, Amazonas, Comunidad Ticuna
S280	WorldlyImports	Group	3005556677	Calle 70 # 10-30, Suite 1212, Barranquilla
S281	Andres	Rios	andres.r@packinnov.net	Carrera 75 # 40-35, Local Industrial Sur
S282	Valentina	Silva	3104445566	Zona Industrial La Nubia, Bodega Jade, Manizales
S283	DivineAromas	Intl.	info@divinearomas.biz	Avenida El Ferrocarril # 10-120, Sta Marta, Piso 9
S284	OptiPackaging	Corp.	3153334455	Parque Empresarial Cota, Bodega 70, Cota
S285	TerraChemicals	Ltd.	orders.terra@chemterra.com	Calle 65 # 35-20, Complejo Terrestre
S286	ImperialGlassware	\N	3012223344	Vía Caldas-Amagá, Parque Industrial Imperial
S287	LabelMax	Solutions	contact@labelmax.com	Carrera 50 # 80-150, Of. 704, Medellín
S288	ApexLogistics	S.A.	3201112233	Centro de Distribución Central, Mod. Zeta 7
S289	CoastalHarvest	Co.	coastal@harvestco.org	Riohacha, La Guajira, Finca Arenosa
S290	CosmicScentImports	\N	3180001122	Calle 98 # 17A-25, Of. 1410, Bogotá
S291	Mateo	Leon	mateo.l@logisticsprovider.co	Diagonal 80 # 30-80, Bodega Omega
S292	Daniela	Vargas	3029990011	Parque Industrial de Yumbo, Bodega Azucarera
S293	AromaGenesis	Global	genesis@aromagenesis.com	Zona Franca de Cartagena, Unidad Zeta 8
S294	BioPack	Supply	3148889900	Centro Industrial La Ceja, Bodega 60, La Ceja
S295	SourceGlobalChem	Intl.	source@sgchemintl.com	Carrera 11 # 73-40, Torre E, Piso 20, Bogotá
S296	EtherealGlass	\N	3057778899	Vereda El Tambo, La Unión, Taller El Reflejo
S297	InfiniteLabels	Inc.	sales.infinite@labels.net	Calle 75 # 20-105, Local H7, Pereira
S298	SummitLogistics	Group	3126667788	Edificio Cumbre Empresarial, Of. 2805, Medellín
S299	PristineBotanics	Extracts	info@pristinebotanics.co	Finca La Pradera, Villa de Leyva
S300	CelestialSourcing	Imports	3175556677	Avenida Colombia # 5-20, Of. 2200, Cali
S301	QuantumIngredients	Corp.	quantum@ingredients.net	Zona Franca de Occidente II, Bodega E3
S302	Camila	Rojas	3005556677	Calle de la Factoría # 5-50, Cartagena
S303	MaritimeAromas	Source	maritime@aromas.co	Tumaco, Nariño, Finca Costera
S304	FlexoPack	S.A.S.	info@flexopack.com.co	Zona Industrial Fontibón II, Bogotá
S305	CatalystChemicals	Global	catalyst@chemglobal.net	Carrera 15 # 90-20, Of. 1005, Bogotá
S306	RadiantGlass	\N	3115556677	Parque Industrial de Sogamoso, Boyacá
S307	PrecisionLabels	Printing	pedidos.precision@labels.org	Avenida Sur # 40-20, Taller Exacto, Pereira
S308	MomentumLogistics	Services	3161112233	Torre Platinum, Piso 20, Barranquilla
S309	BioFusion	Extracts	biofusion@extracts.com	Vereda El Hato, Guasca, Cundinamarca
S310	GlobalReach	Imports	3014445566	Oficina 2003, Edificio World Trade Center, Cali
S311	Natalia	Castro	natalia.c@supplychain.net	Calle Corta 12, Bodega Luna
S312	Sebastian	Molina	3223334455	Transversal de los Cerros # 15-180, Bogotá
S313	TranquilEssence	Co.	contact.tranquil@essence.org	Km 15 Vía Girardot-Melgar, Parque Industrial Paz
S314	GuardianPack	Packaging	3052223344	Zona Industrial La Popa II, Bodega Guardián
S315	SynergyAroma	Chemicals	orders.synergy@aromachem.org	Calle 30 # 75-70, Complejo Industrial Este
S316	LuminousBottles	Inc.	3121112233	Manzana K Lote 9, Parque Industrial Sabaneta
S317	AdvancedLabels	Innovations	info.advanced@labelinnov.org	Carrera 40 # 70-55, Local 5E, Manizales
S318	MomentumGlobal	Logistics	3180001122	Edificio Momentum Tower, Torre E, Of. 2009, Medellín
S319	RiverHarvest	Extracts	compras.river@harvest.net	Magangué, Bolívar, Centro de Acopio Fluvial
S320	ZenithFragrance	Hub	3049990011	Calle 90 # 12-55, Of. 1312, Bogotá
S321	Gabriel	Perez	gabriel.p@distrilab.com	Avenida El Bosque # 35-80, Pasto
S322	Isabela	Gomez	3178889900	Parque Industrial de Armenia, Bodega Esmeralda
S323	ElementalHerbs	World	support.elemental@herbs.org	Vía Villa de Leyva-Sáchica Km 7, Finca Terra
S324	FortressContainers	S.A.	3027778899	Zona Franca de Barranquilla II, Bodega Fortaleza 9
S325	NovaChem	Trading	nova.trade@chemsource.com	Carrera 10 # 75-65, Of. 1804, Bogotá
S326	SculptedBottleDesign	\N	3136667788	Autopista del Sol Sur Km 10, Taller Vidrio Esculpido
S327	MaxPrintSolutions	Co.	sales.max@printsol.net	Calle 75 # 18-75, Taller 18F, Cali
S328	AgileFlowLogistics	Network	3215556677	Centro Logístico del Pacífico, Bodega Marítima
S329	CanyonEssences	Source	info.canyon@essencesrc.com	Chicamocha, Santander, Finca Cañón
S330	ApexImports	Group	3004445566	Calle 73 # 11-40, Suite 1414, Bogotá
S331	Lucas	Sarmiento	lucas.s@packsolutions.net	Carrera 80 # 45-45, Local Industrial Oeste
S332	Valeria	Torres	3103334455	Zona Industrial El Carmen, Bodega Rubí, Viboral
S333	SereneAromas	Intl.	info@serenearomas.biz	Avenida Centenario # 8-130, Armenia, Piso 10
S334	LogicPackaging	Corp.	3152223344	Parque Empresarial Tocancipá, Bodega 80
S335	GeoChemicals	Ltd.	orders.geo@chemgeo.com	Calle 60 # 30-25, Complejo Geológico
S336	EtherealGlassware	\N	3011112233	Vía La Unión-Sonson, Parque Industrial Etéreo
S337	LabelSmart	Solutions	contact@labelsmart.com	Carrera 52 # 85-160, Of. 805, Barranquilla
S338	PinnacleLogistics	S.A.	3200001122	Centro de Distribución Andino, Mod. Kappa 9
S339	LagoonHarvest	Co.	lagoon@harvestco.com	Ciénaga, Magdalena, Finca La Ciénaga
S340	NovaScentImports	\N	3189990011	Calle 96 # 16A-35, Of. 1612, Bogotá
S341	Simon	Quintero	simon.q@logisticplusnet.co	Diagonal 85 # 35-90, Bodega Sigma
S342	Sofia	Castro	3028889900	Parque Industrial de Funza, Bodega Estrella
S343	AromaSphere	Global	sphere@aromasphere.com	Zona Franca de Bogotá II, Unidad Kappa 10
S344	TerraPackSolutions	Supply	3147778899	Centro Industrial de Mosquera, Bodega 70
S345	SourceOneChem	Intl.	sourceone@s1chemintl.com	Carrera 12 # 71-50, Torre F, Piso 22, Bogotá
S346	GlimmerGlass	\N	3056667788	Vereda El Peñol, Guatapé, Taller El Brillo
S347	TotalLabels	Inc.	sales.total@labels.co	Calle 78 # 22-115, Local J9, Manizales
S348	NexusLogistics	Group	3125556677	Edificio Nexus Empresarial, Of. 3000, Cali
S349	ParamoBotanics	Extracts	info@paramobotanics.co	Finca El Cóndor, Cocuy, Boyacá
S350	ZenithSourcing	Imports	3174445566	Avenida Libertadores # 8-30, Of. 2500, Cúcuta
S351	StellarIngredients	Ltda.	stellar@ingredients.biz	Zona Franca La Cayena, Bodega F5, Barranquilla
S352	Ricardo	Montenegro	3006667788	Calle San Juan # 6-60, Villa de Leyva
S353	OceanicAromas	Pure	oceanic@aromas.com.co	Nuquí, Chocó, Finca Pacífica
S354	SolidBox	Solutions	info@solidbox.org	Zona Industrial El Dorado, Bogotá, Bodega Firme
S355	ApexChemConnect	S.A.	apex@chemconnect.co	Carrera 18 # 95-50, Of. 1106, Bogotá
S356	BrilliantGlass	\N	3114445566	Parque Industrial de Duitama, Boyacá
S357	SmartLabels	Printing	pedidos.smart@labels.com	Avenida Las Palmas # 35-20, Taller Inteligente, Medellín
S358	VelocityLogistics	Services	3160001122	Torre Velocity, Piso 22, Cali
S359	AndesPure	Extracts	andespure@extracts.net	Vereda El Santuario, Zipacón, Cund.
S360	PrimeChoice	Imports	3013334455	Oficina 2204, Edificio Prime Center, Bucaramanga
S361	Isabella	Lopez	isabella.l@supplypro.net	Calle Estrecha 23, Bodega Estrella
S362	Martin	Pardo	3222223344	Transversal de la Loma # 18-190, Medellín
S363	HarmonyEssence	Co.	contact.harmony@essence.com	Km 18 Vía Suba-Cota, Parque Industrial Armonía
S364	FortifyPack	Packaging	3051112233	Zona Industrial La Maria, Bodega Fortaleza
S365	ChromaAroma	Chemicals	orders.chroma@aromachem.com	Calle 35 # 80-80, Complejo Industrial Arcoiris
S366	CrystalGraceBottles	Inc.	3120001122	Manzana L Mote 11, Parque Industrial Itagüí
S367	ProLabelsPlus	Innovations	info.pro@labelplus.com	Carrera 42 # 75-65, Local 6F, Barranquilla
S368	SynergyGlobal	Logistics	3189990011	Edificio Synergy Tower, Torre F, Of. 2210, Bogotá
S369	DeltaHarvest	Extracts	compras.delta@harvest.org	Barrancabermeja, Santander, Centro de Acopio Ribereño
S370	SummitFragrance	Hub	3048889900	Calle 93 # 10-65, Of. 1514, Bogotá
S371	David	Reyes	david.r@distriplus.com	Avenida El Lago # 40-90, Villavicencio
S372	Julieta	Soto	3177778899	Parque Industrial de Girón, Bodega Ópalo
S373	DivineHerbs	World	support.divine@herbs.com	Vía Ráquira Km 9, Finca Cerámica Sagrada
S374	ShieldContainers	S.A.	3026667788	Zona Franca de La Tebaida, Bodega Escudo 11
S375	AlphaChem	Trading	alpha.trade@chemsource.net	Carrera 13 # 73-75, Of. 2005, Bogotá
S376	EleganceBottleCraft	\N	3135556677	Autopista del Café Sur Km 15, Taller Vidrio Elegante
S377	OptimalPrintSolutions	Co.	sales.optimal@printsol.net	Calle 80 # 20-85, Taller 20G, Cali
S378	PeakFlowLogistics	Network	3214445566	Centro Logístico Andino, Bodega Cordillera
S379	OasisEssences	Source	info.oasis@essencesrc.net	Desierto de la Tatacoa, Huila, Finca Oasis
S380	RegalImports	Group	3003334455	Calle 75 # 10-50, Suite 1616, Bogotá
S381	Nicolas	Vargas	nicolas.v@packmaster.net	Carrera 85 # 50-55, Local Industrial Central
S382	Manuela	Campos	3102223344	Zona Industrial El Bosque, Bodega Zafiro, Cartagena
S383	MystiqueAromas	Intl.	info@mystiquearomas.biz	Avenida Pinares # 12-140, Pereira, Piso 11
S384	AdvancedPackaging	Corp.	3151112233	Parque Empresarial La Pradera, Bodega 90, Sopo
S385	TerraChemSource	Ltd.	orders.tcs@chemsource.org	Calle 55 # 25-30, Complejo Terrestre II
S386	CelestialGlassware	\N	3010001122	Vía Guarne-Marinilla, Parque Industrial Celestial
S387	LabelGenius	Solutions	contact@labelgenius.com	Carrera 55 # 90-170, Of. 906, Medellín
S388	ZenithLogistics	S.A.	3209990011	Centro de Distribución Global, Mod. Lambda 11
S389	SunHarvest	Co.	sun@harvestco.net	Valledupar, Cesar, Finca Soleada
S390	MysticScentImports	\N	3188889900	Calle 99 # 15A-45, Of. 1814, Bogotá
S391	Esteban	Silva	esteban.s@logisticworld.co	Diagonal 90 # 40-100, Bodega Rho
S392	Laura	Benitez	3027778899	Parque Industrial de Malambo, Bodega Coral
S393	AromaVerse	Global	verse@aromaverse.com	Zona Franca del Pacífico II, Unidad Lambda 12
S394	EcoTerraPack	Supply	3146667788	Centro Industrial de Cogua, Bodega 80
S395	ChemSourcePrime	Intl.	prime@csprimeintl.com	Carrera 10 # 68-40, Torre G, Piso 25, Bogotá
S396	AuraGlass	\N	3055556677	Vereda La Montañita, El Retiro, Taller El Aura
S397	SwiftLabels	Inc.	sales.swift@labels.org	Calle 82 # 25-125, Local K11, Pereira
S398	ApexChainLogistics	Group	3124445566	Edificio Apex Empresarial, Of. 3200, Barranquilla
S399	CloudForestBotanics	Extracts	info@cfbotanics.co	Finca La Niebla, Jardín, Antioquia
S400	StarlightSourcing	Imports	3173334455	Avenida Santander # 12-40, Of. 2800, Manizales
S401	NovaIngredients	S.A.	nova@ingredients.co.net	Zona Franca Metropolitana, Bodega G7, Bogotá
S402	Daniela	Perez	3007778899	Calle El Edén # 7-70, Filandia, Quindío
S403	CoralReefAromas	Source	coral@aromas.co.com	Providencia Isla, Finca Coralina II
S404	GreenBox	Solutions	info@greenbox.co.org	Zona Industrial Siberia, Cota, Bodega Ecológica
S405	SynergyChem	S.A.S.	synergy@chem.com.co	Carrera 17 # 93-60, Of. 1207, Bogotá
S406	LumiGlass	\N	3113334455	Parque Industrial de Paipa, Boyacá
S407	AgileLabels	Printing	pedidos.agile@labels.net.co	Avenida Cañasgordas # 40-30, Taller Veloz, Cali
S408	MomentumPlusLogistics	Services	3169990011	Torre Momentum Plus, Piso 25, Medellín
S409	HighPeakBio	Extracts	highpeak@bioextracts.org	Vereda El Páramo, Villa de Leyva
S410	AlphaChoice	Imports	3012223344	Oficina 2505, Edificio Alpha Center, Pereira
S411	Mateo	Romero	mateo.r@supplylogistic.net	Calle Ancha 34, Bodega Cometa
S412	Sofia	Gonzalez	3221112233	Transversal de la Sabana # 20-200, Chía
S413	SerenityEssence	Co.	contact.serenity@essence.net.co	Km 20 Vía La Mesa-Anapoima, Parque Industrial Serenidad
S414	SolidGuardPack	Packaging	3050001122	Zona Industrial El Muña, Bodega Sólida
S415	SpectrumAroma	Chemicals	orders.spectrum@aromachem.net.co	Calle 40 # 85-90, Complejo Industrial Espectral
S416	RadianceBottles	Inc.	3129990011	Manzana M Lote 13, Parque Industrial Envigado
S417	UltraLabelsPlus	Innovations	info.ultra@labelplus.net	Carrera 45 # 80-75, Local 7G, Barranquilla
S418	VelocityGlobal	Logistics	3188889900	Edificio Velocity Tower, Torre G, Of. 2512, Cali
S419	MagdalenaHarvest	Extracts	compras.magdalena@harvest.net.co	Honda, Tolima, Centro de Acopio Dorado
S420	CelestialFragrance	Hub	3047778899	Calle 96 # 11-75, Of. 1716, Bogotá
S421	Bruno	Gomez	bruno.g@distrimax.com	Avenida El Ferrocarril # 45-100, Ibagué
S422	Julieta	Patiño	3176667788	Parque Industrial de La Virginia, Bodega Perla
S423	TerraHerbs	World	support.terra@herbs.net.co	Vía Sopo Km 11, Finca Tierra Viva
S424	TitanContainers	S.A.	3025556677	Zona Franca de Cartagena II, Bodega Titán 13
S425	VertexChemSource	Trading	vertex.trade@chemsource.co	Carrera 12 # 70-85, Of. 2206, Bogotá
S426	ArtFormBottleDesign	\N	3134445566	Autopista del Sol Norte Km 12, Taller Vidrio Formas
S427	OptimusPrintSolutions	Co.	sales.optimus@printsol.co.net	Calle 85 # 22-95, Taller 22H, Manizales
S428	SummitFlowLogistics	Network	3213334455	Centro Logístico de Occidente, Bodega Cumbre
S429	SunValleyEssences	Source	info.sunvalley@essencesrc.co	Valle de Tenza, Boyacá, Finca Sol Naciente
S430	PinnacleImports	Group	3002223344	Calle 76 # 13-60, Suite 1818, Bogotá
S431	Tomas	Salazar	tomas.s@packelite.net	Carrera 90 # 55-65, Local Industrial Principal
S432	Gabriela	Bedoya	3101112233	Zona Industrial La Argentina, Bodega Platino, Neiva
S433	AuraMystiqueAromas	Intl.	info@auramystique.biz	Avenida Las Américas # 15-150, Armenia, Piso 12
S434	IntelliPackaging	Corp.	3150001122	Parque Empresarial Gachancipá, Bodega 100
S435	EcoChemSource	Ltd.	orders.ecs@chemsource.net.co	Calle 50 # 20-35, Complejo Ecológico
S436	NovaGlassware	\N	3019990011	Vía Rionegro-La Ceja, Parque Industrial Nova
S437	LabelVerse	Solutions	contact@labelverse.com	Carrera 58 # 95-180, Of. 1007, Medellín
S438	CorePlusLogistics	S.A.	3208889900	Centro de Distribución Sabana, Mod. Omicron 13
S439	MoonHarvest	Co.	moon@harvestco.net.co	Villa de Leyva, Boyacá, Finca Luna Llena
S440	ApexScentImports	\N	3187778899	Calle 101 # 14A-55, Of. 2014, Bogotá
S441	Julian	Cardenas	julian.c@logisticore.co	Diagonal 95 # 45-110, Bodega Tau
S442	Sara	Ortega	3026667788	Parque Industrial de Palmaseca, Bodega Diamante
S443	AromaZenith	Global	zenith@aromazenith.com	Zona Franca de Barranquilla III, Unidad Omicron 14
S444	BioTerraPack	Supply	3145556677	Centro Industrial de Tenjo, Bodega 90
S445	PrimeSourceChem	Intl.	prime@pschemintl.com	Carrera 13 # 68-50, Torre H, Piso 28, Bogotá
S446	StarlightGlass	\N	3054445566	Vereda El Carmen, Sopó, Taller La Estrella
S447	QuantumLabels	Inc.	sales.quantum@labels.net.co	Calle 80 # 28-125, Local L13, Pereira
S448	SynergyChainLogistics	Group	3123334455	Edificio Synergy Empresarial, Of. 3500, Cali
S449	GoldenValBotanics	Extracts	info@gvbotanics.co	Finca El Dorado, Calima, Valle
S450	RegalSourcing	Imports	3172223344	Avenida El Poblado # 5-40, Of. 3000, Medellín
S451	ElementIngredients	Corp.	element@ingredients.co.com	Zona Franca Gachancipá, Bodega H9
S452	Nicolas	Quintero	3008889900	Calle de la Moneda # 8-80, Popayán
S453	LagoonAromas	Source	lagoon@aromas.net.com	Tolú, Sucre, Finca Laguna Azul
S454	StructurBox	Solutions	info@structurbox.org.co	Zona Industrial Montevideo II, Bogotá, Bodega Estructura
S455	CatalystChemSource	S.A.	catalyst@chemsource.co.com	Carrera 19 # 90-70, Of. 1308, Bogotá
S456	EtherealGlowGlass	\N	3112223344	Parque Industrial de Yopal, Casanare
S457	InfinitePrintLabels	Printing	pedidos.infinite@labels.com.co	Avenida Sur Oriental # 45-40, Taller Infinito, Pasto
S458	PinnacleFlowLogistics	Services	3167778899	Torre Pinnacle, Piso 28, Barranquilla
S459	SacredPeakBio	Extracts	sacredpeak@bioextracts.co	Vereda El Cocuy, Güicán, Boyacá
S460	SummitChoice	Imports	3011112233	Oficina 2806, Edificio Summit Center, Manizales
S461	Simon	Zuluaga	simon.z@supplycore.net	Calle Empedrada 45, Bodega Astro
S462	Manuela	Bernal	3220001122	Transversal de la Cordillera # 22-220, Ibagué
S463	ZenithEssence	Co.	contact.zenith@essence.co.com	Km 22 Vía Funza-Siberia, Parque Industrial Zenith
S464	AegisPack	Packaging	3059990011	Zona Industrial La Ceja, Bodega Aegis
S465	AetherAroma	Chemicals	orders.aether@aromachem.co.com	Calle 45 # 90-100, Complejo Industrial Etéreo
S466	GlimmerGraceBottles	Inc.	3128889900	Manzana N Lote 15, Parque Industrial Rionegro
S467	ApexLabelsPlus	Innovations	info.apex@labelplus.co	Carrera 48 # 85-85, Local 8H, Itagüí
S468	NexusGlobal	Logistics	3187778899	Edificio Nexus Tower, Torre H, Of. 2814, Medellín
S469	AndeanGoldHarvest	Extracts	compras.gold@harvest.co.com	Pasto, Nariño, Centro de Acopio Andino
S470	AlphaFragrance	Hub	3046667788	Calle 98 # 10-75, Of. 1918, Bogotá
S471	Gabriel	Ospina	gabriel.o@districhem.com	Avenida Las Vegas # 50-110, Sabaneta
S472	Isabela	Ramirez	3175556677	Parque Industrial de Dosquebradas, Bodega Titanio
S473	PrimalHerbs	World	support.primal@herbs.co.com	Vía Tabio Km 13, Finca Origen
S474	BastionContainers	S.A.	3024445566	Zona Franca de La Candelaria II, Bodega Bastión 15
S475	CoreChem	Trading	core.trade@chemsource.com.co	Carrera 13 # 70-95, Of. 2407, Bogotá
S476	RadiantBottleCraft	\N	3133334455	Autopista del Sol Central Km 18, Taller Vidrio Radiante
S477	SynergyPrintSolutions	Co.	sales.synergy@printsol.co.com	Calle 90 # 25-105, Taller 25J, Cali
S478	VertexFlowLogistics	Network	3212223344	Centro Logístico de la Sabana, Bodega Vértice
S479	EmeraldEssences	Source	info.emerald@essencesrc.co.com	Muzo, Boyacá, Finca Esmeralda
S480	ZenithImports	Group	3001112233	Calle 78 # 15-70, Suite 2020, Bogotá
S481	Lucas	Pineda	lucas.p@packglobal.net	Carrera 95 # 60-75, Local Industrial Principal Sur
S482	Valeria	Montenegro	3100001122	Zona Industrial El Salado, Bodega Cuarzo, Ibagué
S483	CelestialAromas	Intl.	info@celestialaromas.biz	Avenida Oriental # 15-160, Cúcuta, Piso 14
S484	PrecisionPackaging	Corp.	3159990011	Parque Empresarial Mosquera, Bodega 110
S485	PrimeChemSource	Ltd.	orders.pcs@chemsource.co.com	Calle 45 # 15-40, Complejo Principal
S486	LuminousGlassware	\N	3018889900	Vía Marinilla-El Peñol, Parque Industrial Luminoso
S487	LabelPerfect	Solutions	contact@labelperfect.com	Carrera 60 # 100-190, Of. 1108, Barranquilla
S488	AgilePlusLogistics	S.A.	3207778899	Centro de Distribución Metro, Mod. Rho 15
S489	SapphireHarvest	Co.	sapphire@harvestco.co.com	Quibdó, Chocó, Finca Zafiro
S490	StellarScentImports	\N	3186667788	Calle 105 # 13A-65, Of. 2216, Bogotá
S491	Simon	Mejia	simon.m@logisticprime.co	Diagonal 100 # 50-120, Bodega Upsilon
S492	Sofia	Villegas	3025556677	Parque Industrial de La Tebaida, Bodega Amatista
S493	AuraNova	Global	nova@auranova.com	Zona Franca de Rionegro II, Unidad Upsilon 16
S494	GeoPack	Supply	3144445566	Centro Industrial de Madrid, Bodega 100
S495	VertexSourceChem	Intl.	vertex@vschemintl.com	Carrera 14 # 65-60, Torre J, Piso 30, Bogotá
S496	GlowFormGlass	\N	3053334455	Vereda El Alto, La Calera, Taller La Chispa
S497	SynergyLabels	Inc.	sales.synergy@labels.co.com	Calle 85 # 30-135, Local M15, Manizales
S498	MomentumChainLogistics	Group	3122223344	Edificio Momentum Empresarial, Of. 3800, Cali
S499	RubyPeakBotanics	Extracts	info@rpbotanics.co	Finca La Joya, Guatavita, Cundinamarca
S500	AlphaTierSourcing	Imports	3171112233	Avenida El Río # 10-60, Of. 3200, Villavicencio
S501	ZenithIngredients	S.A.S.	zenith@ingredients.com	Zona Franca Palermo, Bodega J1, Barranquilla
S502	Camila	Contreras	3009990011	Calle El Sol # 9-90, Barichara, Santander
S503	AndeanMistAromas	Source	andeanmist@aromas.co	Salento, Quindío, Finca Neblina
S504	PrimeBox	Solutions	info@primebox.net.co	Zona Industrial Puente Aranda II, Bogotá, Bodega Prime
S505	ElementChemSource	S.A.	element@chemsource.com	Carrera 20 # 93-80, Of. 1409, Bogotá
S506	AuraGlowGlass	\N	3111112233	Parque Industrial de Sogamoso II, Boyacá
S507	ApexPrintLabels	Printing	pedidos.apex@labels.net	Avenida Oriental # 55-50, Taller Cumbre, Medellín
S508	CoreFlowLogistics	Services	3166667788	Torre Core, Piso 30, Cali
S509	TerraNovaBio	Extracts	terranova@bioextracts.net	Vereda El Robledal, Tabio, Cundinamarca
S510	StellarChoice	Imports	3010001122	Oficina 3007, Edificio Stellar Center, Bucaramanga
S511	Nicolas	Escobar	nicolas.e@supplycore.net.co	Calle Luna 56, Bodega Galaxia
S512	Isabella	Pardo	3229990011	Transversal del Bosque # 25-230, Manizales
S513	EtherealEssence	Co.	contact.ethereal@essence.com.co	Km 25 Vía Mosquera-La Mesa, Parque Industrial Etéreo
S514	GuardianPlusPack	Packaging	3058889900	Zona Industrial La Estrella, Bodega Guardiana Plus
S515	NovaSpectrumAroma	Chemicals	orders.nova@aromachem.com.co	Calle 50 # 95-110, Complejo Industrial Nova
S516	LumiRadianceBottles	Inc.	3127778899	Manzana P Lote 17, Parque Industrial Envigado Sur
S517	VertexLabelsPlus	Innovations	info.vertex@labelplus.net.co	Carrera 50 # 90-95, Local 9J, Barranquilla
S518	PinnacleGlobal	Logistics	3186667788	Edificio Pinnacle Tower, Torre J, Of. 3016, Medellín
S519	AmazonianJewelHarvest	Extracts	compras.jewel@harvest.com.co	Leticia, Amazonas, Centro de Acopio Joya Verde
S520	CoreFragrance	Hub	3045556677	Calle 100 # 10-85, Of. 2120, Bogotá
S521	Sebastian	Gomez	sebastian.g@distrimundo.com	Avenida El Libertador # 50-120, Santa Marta
S522	Julieta	Patiño	3174445566	Parque Industrial de Pereira II, Bodega Ónix
S523	SacredGroveHerbs	World	support.sacred@herbs.com.co	Vía Guatavita-Sesquilé Km 9, Finca Bosque Sagrado
S524	AegisContainers	S.A.	3023334455	Zona Franca de Rionegro II, Bodega Aegis 7
S525	SynergyChemSource	Trading	synergy.trade@chemsource.co.net	Carrera 11 # 68-95, Of. 2508, Bogotá
S526	RadiantArtBottleDesign	\N	3132223344	Autopista del Café Norte Km 15, Taller Vidrio Luz
S527	ApexPrintSolutions	Co.	sales.apex@printsol.co.com	Calle 95 # 28-115, Taller 28K, Manizales
S528	MomentumFlowLogistics	Network	3211112233	Centro Logístico de Occidente II, Bodega Flujo
S529	HighlandValleyEssences	Source	info.hv@essencesrc.net	Valle de Tenza, Boyacá, Finca Altura
S530	StellarImports	Group	3000001122	Calle 79 # 16-80, Suite 2222, Bogotá
S531	Tomas	Salazar	tomas.s@packnexus.net.co	Carrera 95 # 65-75, Local Industrial Alfa
S532	Gabriela	Bedoya	3109990011	Zona Industrial La Badea II, Bodega Zafiro, Dosquebradas
S533	EtherealMystiqueAromas	Intl.	info@etherealmystique.biz	Avenida Centenario # 10-160, Armenia, Piso 14
S534	LogicPlusPackaging	Corp.	3158889900	Parque Empresarial Gachancipá II, Bodega 120
S535	GeoChemPrime	Ltd.	orders.gcp@chemprime.co	Calle 55 # 22-45, Complejo Geológico Prime
S536	NovaGlowGlassware	\N	3017778899	Vía Rionegro-Marinilla, Parque Industrial Nova Luz
S537	LabelZenith	Solutions	contact@labelzenith.com	Carrera 60 # 105-200, Of. 1209, Medellín
S538	CoreChainLogistics	S.A.	3206667788	Centro de Distribución Sabana II, Mod. Phi 17
S539	MoonValleyHarvest	Co.	moonvalley@harvestco.com.co	Villa de Leyva, Boyacá, Finca Valle Lunar
S540	ApexScentPrime	\N	3185556677	Calle 103 # 13A-75, Of. 2416, Bogotá
S541	Julian	Cardenas	julian.c@logisticoreplus.co	Diagonal 100 # 55-130, Bodega Chi
S542	Sara	Ortega	3024445566	Parque Industrial de Palmaseca II, Bodega Esmeralda
S543	AromaApex	Global	apex@aromapex.com	Zona Franca de Barranquilla IV, Unidad Phi 18
S544	BioTerraPlusPack	Supply	3143334455	Centro Industrial de Tenjo II, Bodega 110
S545	PrimeSourceGlobalChem	Intl.	prime@psgchemintl.com	Carrera 14 # 63-70, Torre J, Piso 32, Bogotá
S546	StarlightGlowGlass	\N	3052223344	Vereda El Carmen II, Sopó, Taller Luz Estelar
S547	QuantumPlusLabels	Inc.	sales.quantum@labelsplus.net	Calle 83 # 30-145, Local N17, Pereira
S548	SynergyCoreLogistics	Group	3121112233	Edificio Synergy Empresarial II, Of. 3802, Cali
S549	GoldenPeakBotanics	Extracts	info@gpbotanics.co	Finca El Mirador Dorado, Calima, Valle
S550	RegalTierSourcing	Imports	3170001122	Avenida El Poblado # 8-60, Of. 3302, Medellín
S551	ElementPrimeIngredients	Corp.	element@primeing.com	Zona Franca Gachancipá II, Bodega K11
S552	Nicolas	Quintero	3009991122	Calle de la Amargura # 10-100, Popayán
S553	LagoonBlueAromas	Source	lagoonblue@aromas.net.co	Tolú Viejo, Sucre, Finca Azul Marino
S554	StructurPlusBox	Solutions	info@structurplus.org.co	Zona Industrial Montevideo III, Bogotá, Bodega Estructura Plus
S555	CatalystGlobalChem	S.A.	catalyst@globalchem.co.com	Carrera 21 # 95-90, Of. 1510, Bogotá
S556	EtherealShineGlass	\N	3110001122	Parque Industrial de Yopal II, Casanare
S557	InfinitePlusPrintLabels	Printing	pedidos.infinite@labelsplus.com	Avenida Sur # 50-60, Taller Infinito Plus, Pasto
S558	PinnacleCoreLogistics	Services	3165556677	Torre Pinnacle II, Piso 32, Barranquilla
S559	SacredZenBio	Extracts	sacredzen@bioextracts.co.net	Vereda El Cocuy II, Güicán, Boyacá
S560	SummitTierChoice	Imports	3018889900	Oficina 3208, Edificio Summit Center II, Manizales
S561	Simon	Zuluaga	simon.z@supplyzenith.net.co	Calle Florida 67, Bodega Nebulosa
S562	Manuela	Bernal	3227778899	Transversal de la Montaña # 28-250, Ibagué
S563	ZenithPlusEssence	Co.	contact.zenith@essenceplus.co	Km 28 Vía Funza-Siberia, Parque Industrial Zenith Plus
S564	AegisSecurePack	Packaging	3056667788	Zona Industrial La Ceja II, Bodega Aegis Secure
S565	AetherGlowAroma	Chemicals	orders.aether@aromachemplus.co	Calle 55 # 100-120, Complejo Industrial Etéreo Plus
S566	GlimmerShineBottles	Inc.	3125556677	Manzana Q Lote 19, Parque Industrial Rionegro Sur
S567	ApexCoreLabels	Innovations	info.apex@labelcore.net.co	Carrera 52 # 95-105, Local 10K, Itagüí
S568	NexusPlusGlobal	Logistics	3184445566	Edificio Nexus Tower II, Torre K, Of. 3018, Medellín
S569	AndeanSunHarvest	Extracts	compras.sun@harvestplus.co	Pasto, Nariño, Centro de Acopio Sol Andino
S570	AlphaTierFragrance	Hub	3043334455	Calle 102 # 12-95, Of. 2322, Bogotá
S571	Gabriel	Ospina	gabriel.o@distriaether.com	Avenida Las Vegas # 60-130, Sabaneta
S572	Isabela	Ramirez	3172223344	Parque Industrial de Dosquebradas II, Bodega Uranio
S573	PrimalGroveHerbs	World	support.primal@herbsplus.co	Vía Tabio II Km 15, Finca Origen Sagrado
S574	BastionSecureContainers	S.A.	3021112233	Zona Franca de La Candelaria III, Bodega Bastión Secure
S575	CorePlusChem	Trading	core.trade@chemplus.com.co	Carrera 14 # 72-105, Of. 2609, Bogotá
S576	RadiantGlowBottleCraft	\N	3130001122	Autopista del Sol Central II Km 20, Taller Vidrio Luz Radiante
S577	SynergyPlusPrintSolutions	Co.	sales.synergy@printsolplus.co	Calle 92 # 28-125, Taller 28L, Cali
S578	VertexCoreLogistics	Network	3219990011	Centro Logístico de la Sabana II, Bodega Vértice Core
S579	EmeraldPeakEssences	Source	info.emerald@essencesrcplus.co	Muzo, Boyacá, Finca Esmeralda Alta
S580	ZenithTierImports	Group	3008889900	Calle 80 # 18-90, Suite 2424, Bogotá
S581	Lucas	Pineda	lucas.p@packzenith.net.co	Carrera 100 # 70-85, Local Industrial Beta
S582	Valeria	Montenegro	3107778899	Zona Industrial El Salado II, Bodega Onix Plus, Ibagué
S583	CelestialMystiqueAromas	Intl.	info@celestialmystique.biz	Avenida Oriental # 18-180, Cúcuta, Piso 16
S584	PrecisionPlusPackaging	Corp.	3156667788	Parque Empresarial Mosquera II, Bodega 130
S585	PrimeTierChemSource	Ltd.	orders.ptcs@chemsourceplus.co	Calle 50 # 18-50, Complejo Principal Plus
S586	LuminousShineGlassware	\N	3015556677	Vía Marinilla-El Peñol II, Parque Industrial Luminoso Plus
S587	LabelApex	Solutions	contact@labelapex.com	Carrera 62 # 102-200, Of. 1310, Barranquilla
S588	AgileCoreLogistics	S.A.	3204445566	Centro de Distribución Metro II, Mod. Sigma 19
S589	SapphirePeakHarvest	Co.	sapphire@harvestcoplus.co	Quibdó, Chocó, Finca Zafiro Alto
S590	StellarNovaScentImports	\N	3183334455	Calle 108 # 12A-75, Of. 2418, Bogotá
S591	Simon	Mejia	simon.m@logisticzenith.co	Diagonal 105 # 60-140, Bodega Omega Plus
S592	Sofia	Villegas	3022223344	Parque Industrial de La Tebaida II, Bodega Amatista Plus
S593	AuraZenith	Global	zenith@aurazenith.com	Zona Franca de Rionegro III, Unidad Omega 19
S594	GeoPlusPack	Supply	3141112233	Centro Industrial de Madrid II, Bodega 120
S595	VertexPrimeChem	Intl.	vertex@vpchemintl.com	Carrera 15 # 62-80, Torre K, Piso 35, Bogotá
S596	GlowZenithGlass	\N	3050001122	Vereda El Alto II, La Calera, Taller La Llama
S597	SynergyPlusLabels	Inc.	sales.synergy@labelsplus.net.co	Calle 88 # 32-145, Local P19, Manizales
S598	MomentumCoreLogistics	Group	3129990011	Edificio Momentum Empresarial II, Of. 4002, Cali
S599	RubyZenithBotanics	Extracts	info@rzbotanics.co	Finca La Gema, Guatavita, Cundinamarca
S600	AlphaPinnacleSourcing	Imports	3178889900	Avenida El Río # 12-80, Of. 3502, Villavicencio
S601	PinnacleIngredients	S.A.	pinnacle@ingredients.net.co	Zona Franca del Eje II, Bodega K3, Pereira
S602	Laura	Contreras	3000001122	Calle del Silencio # 11-110, Jardín, Antioquia
S603	CelestialMistAromas	Source	celestial@aromas.com.co	Minca, Sierra Nevada, Finca Celestial
S604	ApexPlusBox	Solutions	info@apexplusbox.net	Zona Industrial Cazucá III, Bogotá, Bodega Cumbre Plus
S605	NovaGlobalChem	S.A.S.	nova@globalchem.net.co	Carrera 22 # 98-100, Of. 1611, Bogotá
S606	ZenithShineGlass	\N	3119990011	Parque Industrial de Paipa II, Boyacá
S607	CorePrintLabels	Printing	pedidos.core@labels.com.co	Avenida Las Américas # 60-70, Taller Núcleo, Cali
S608	ElementFlowLogistics	Services	3164445566	Torre Elemento, Piso 32, Medellín
S609	AlphaNovaBio	Extracts	alphanova@bioextracts.net.co	Vereda El Paraíso, Sasaima, Cundinamarca
S610	PinnacleTierChoice	Imports	3017778899	Oficina 3509, Edificio Pinnacle Center II, Bucaramanga
S611	Bruno	Escobar	bruno.e@supplypinnacle.net.co	Calle Aurora 78, Bodega Cosmos
S612	Julieta	Pardo	3226667788	Transversal del Cielo # 30-260, Manizales
S613	StellarPlusEssence	Co.	contact.stellar@essenceplus.net	Km 30 Vía Mosquera-Apulo, Parque Industrial Estelar
S614	AegisCorePack	Packaging	3055556677	Zona Industrial La María II, Bodega Aegis Core
S615	EtherealSpectrumAroma	Chemicals	orders.ethereal@aromachemplus.net	Calle 60 # 105-130, Complejo Industrial Etéreo Spectrum
S616	LumiZenithBottles	Inc.	3124445566	Manzana R Lote 21, Parque Industrial Envigado Norte
S617	VertexCoreLabels	Innovations	info.vertex@labelcore.com.co	Carrera 55 # 100-115, Local 11L, Barranquilla
S618	PinnaclePlusGlobal	Logistics	3183334455	Edificio Pinnacle Tower II, Torre L, Of. 3220, Medellín
S619	CelestialJewelHarvest	Extracts	compras.celestial@harvestplus.net.co	Leticia, Amazonas, Centro de Acopio Joya Celestial
S620	ElementFragrance	Hub	3042223344	Calle 105 # 11-105, Of. 2524, Bogotá
S621	Emilio	Gomez	emilio.g@districelestial.com	Avenida El Libertador # 60-140, Santa Marta
S622	Renata	Patiño	3171112233	Parque Industrial de Pereira III, Bodega Galaxia
S623	SacredZenithHerbs	World	support.sacred@herbsplus.net.co	Vía Guatavita-Guasca Km 11, Finca Bosque Zen
S624	AegisSecureContainers	S.A.	3020001122	Zona Franca de Rionegro III, Bodega Aegis Secure Plus
S625	SynergyCoreChem	Trading	synergy.trade@chemcore.co	Carrera 10 # 65-105, Of. 2810, Bogotá
S626	RadiantZenithBottleDesign	\N	3139990011	Autopista del Café Central Km 18, Taller Vidrio Luz Zen
S627	ApexCorePrintSolutions	Co.	sales.apex@printsolcore.co	Calle 100 # 30-135, Taller 30M, Manizales
S628	MomentumCoreLogistics	Network	3218889900	Centro Logístico de Occidente III, Bodega Flujo Core
S629	HighlandZenithEssences	Source	info.hz@essencesrcplus.net.co	Valle de Cocora, Salento, Finca Altura Zen
S630	StellarPinnacleImports	Group	3007778899	Calle 82 # 19-100, Suite 2626, Bogotá
S631	Tomas	Salazar	tomas.s@packalpha.net.co	Carrera 105 # 75-85, Local Industrial Gamma
S632	Gabriela	Bedoya	3106667788	Zona Industrial La Badea III, Bodega Celestia, Dosquebradas
S633	EtherealApexAromas	Intl.	info@etherealapex.biz	Avenida Centenario # 12-180, Armenia, Piso 16
S634	LogicCorePackaging	Corp.	3155556677	Parque Empresarial Gachancipá III, Bodega 140
S635	GeoChemZenith	Ltd.	orders.gcz@chemzenith.co	Calle 60 # 20-55, Complejo Geológico Zenith
S636	NovaShineGlassware	\N	3014445566	Vía Rionegro-El Carmen, Parque Industrial Nova Brillo
S637	LabelElement	Solutions	contact@labelelement.com	Carrera 65 # 110-220, Of. 1411, Medellín
S638	CorePlusChainLogistics	S.A.	3203334455	Centro de Distribución Sabana III, Mod. Psi 21
S639	MoonZenithHarvest	Co.	moonzenith@harvestcoplus.net	Villa de Leyva, Boyacá, Finca Cénit Lunar
S640	ApexNovaScentImports	\N	3182223344	Calle 106 # 12A-85, Of. 2618, Bogotá
S641	Julian	Cardenas	julian.c@logisticzenithplus.co	Diagonal 110 # 65-150, Bodega Psi
S642	Sara	Ortega	3021112233	Parque Industrial de Palmaseca III, Bodega Galáctica
S643	AromaElement	Global	element@aromaelement.com	Zona Franca de Barranquilla V, Unidad Psi 22
S644	BioTerraCorePack	Supply	3140001122	Centro Industrial de Tenjo III, Bodega 130
S645	PrimeSourceZenithChem	Intl.	prime@pszenithchemintl.com	Carrera 16 # 60-90, Torre L, Piso 38, Bogotá
S646	StarlightShineGlass	\N	3059990011	Vereda El Carmen III, Sopó, Taller Brillo Estelar
S647	QuantumCoreLabels	Inc.	sales.quantum@labelscore.net	Calle 90 # 32-165, Local Q19, Pereira
S648	SynergyPinnacleLogistics	Group	3128889900	Edificio Synergy Empresarial III, Of. 4004, Cali
S649	GoldenZenithBotanics	Extracts	info@gzbotanics.co	Finca El Edén Dorado, Calima, Valle
S650	RegalApexSourcing	Imports	3177778899	Avenida El Poblado # 10-80, Of. 3604, Medellín
S651	ElementZenithIngredients	Corp.	element@zenithing.com	Zona Franca Gachancipá III, Bodega M13
S652	Nicolas	Quintero	3000002233	Calle de la Esperanza # 12-120, Popayán
S653	LagoonMistAromas	Source	lagoonmist@aromas.net.co	Tolú Viejo, Sucre, Finca Niebla Marina
S654	StructurCoreBox	Solutions	info@structurcore.org.co	Zona Industrial Montevideo IV, Bogotá, Bodega Estructura Central
S655	CatalystZenithChem	S.A.	catalyst@zenithchem.co.com	Carrera 23 # 100-110, Of. 1712, Bogotá
S656	EtherealRadiantGlass	\N	3118889900	Parque Industrial de Yopal III, Casanare
S657	InfiniteCorePrintLabels	Printing	pedidos.infinite@labelscore.com	Avenida Sur # 60-80, Taller Infinito Central, Pasto
S658	PinnacleElementLogistics	Services	3163334455	Torre Pinnacle III, Piso 35, Barranquilla
S659	SacredAlphaBio	Extracts	sacredalpha@bioextracts.co.net	Vereda El Cocuy III, Güicán, Boyacá
S660	SummitApexChoice	Imports	3016667788	Oficina 3810, Edificio Summit Center III, Manizales
S661	Simon	Zuluaga	simon.z@supplyelement.net.co	Calle Cosmos 89, Bodega Quasar
S662	Manuela	Bernal	3225556677	Transversal de la Galaxia # 32-280, Ibagué
S663	ZenithCoreEssence	Co.	contact.zenith@essencecore.co	Km 32 Vía Funza-Siberia, Parque Industrial Zenith Central
S664	AegisElementPack	Packaging	3054445566	Zona Industrial La Ceja III, Bodega Aegis Elemento
S665	AetherShineAroma	Chemicals	orders.aether@aromashine.co	Calle 65 # 110-140, Complejo Industrial Etéreo Brillo
S666	GlimmerRadiantBottles	Inc.	3123334455	Manzana S Lote 23, Parque Industrial Rionegro Central
S667	ApexElementLabels	Innovations	info.apex@labelelement.net.co	Carrera 58 # 105-125, Local 12M, Itagüí
S668	NexusCoreGlobal	Logistics	3182223344	Edificio Nexus Tower III, Torre M, Of. 3222, Medellín
S669	AndeanRadiantHarvest	Extracts	compras.radiant@harvestcore.co	Pasto, Nariño, Centro de Acopio Sol Radiante
S670	AlphaElementFragrance	Hub	3041112233	Calle 108 # 11-115, Of. 2726, Bogotá
S671	Gabriel	Ospina	gabriel.o@distriaetherplus.com	Avenida Las Vegas # 70-150, Sabaneta
S672	Isabela	Ramirez	3170001122	Parque Industrial de Dosquebradas III, Bodega Plutón
S673	PrimalZenithHerbs	World	support.primal@herbszenith.co	Vía Tabio III Km 18, Finca Origen Cénit
S674	BastionElementContainers	S.A.	3029990011	Zona Franca de La Candelaria IV, Bodega Bastión Elemento
S675	CoreApexChem	Trading	core.trade@chemapex.com.co	Carrera 15 # 70-115, Of. 2911, Bogotá
S676	RadiantShineBottleCraft	\N	3138889900	Autopista del Sol Central III Km 22, Taller Vidrio Luz Brillante
S677	SynergyApexPrintSolutions	Co.	sales.synergy@printsolapex.co	Calle 95 # 30-145, Taller 30N, Cali
S678	VertexElementLogistics	Network	3217778899	Centro Logístico de la Sabana III, Bodega Vértice Elemento
S679	EmeraldZenithEssences	Source	info.emerald@essencesrczenith.co	Muzo, Boyacá, Finca Esmeralda Suprema
S680	ZenithApexImports	Group	3006667788	Calle 83 # 20-110, Suite 2828, Bogotá
S681	Lucas	Pineda	lucas.p@packalpha.net.co	Carrera 110 # 80-95, Local Industrial Delta
S682	Valeria	Montenegro	3105556677	Zona Industrial El Salado III, Bodega Platino Plus, Ibagué
S683	CelestialApexAromas	Intl.	info@celestialapex.biz	Avenida Oriental # 20-200, Cúcuta, Piso 18
S684	PrecisionCorePackaging	Corp.	3154445566	Parque Empresarial Mosquera III, Bodega 150
S685	PrimeElementChemSource	Ltd.	orders.pecs@chemsourcecore.co	Calle 55 # 20-60, Complejo Principal Elemento
S686	LuminousRadiantGlassware	\N	3013334455	Vía Marinilla-El Peñol III, Parque Industrial Luminoso Radiante
S687	LabelPinnacle	Solutions	contact@labelpinnacle.com	Carrera 68 # 108-240, Of. 1513, Barranquilla
S688	AgileElementLogistics	S.A.	3202223344	Centro de Distribución Metro III, Mod. Tau 23
S689	SapphireZenithHarvest	Co.	sapphire@harvestcozenith.co	Quibdó, Chocó, Finca Zafiro Supremo
S690	StellarAlphaScentImports	\N	3181112233	Calle 110 # 11A-85, Of. 2620, Bogotá
S691	Simon	Mejia	simon.m@logisticalpha.co	Diagonal 115 # 70-160, Bodega Phi Plus
S692	Sofia	Villegas	3020001122	Parque Industrial de La Tebaida III, Bodega Cósmica
S693	AuraPinnacle	Global	pinnacle@aurapinnacle.com	Zona Franca de Rionegro IV, Unidad Phi 23
S694	GeoCorePack	Supply	3149990011	Centro Industrial de Madrid III, Bodega 140
S695	VertexZenithChem	Intl.	vertex@vzchemintl.com	Carrera 17 # 60-100, Torre M, Piso 40, Bogotá
S696	GlowPinnacleGlass	\N	3058889900	Vereda El Alto III, La Calera, Taller El Fulgor
S697	SynergyCoreLabels	Inc.	sales.synergy@labelscore.net.co	Calle 92 # 35-165, Local R21, Manizales
S698	MomentumPinnacleLogistics	Group	3127778899	Edificio Momentum Empresarial III, Of. 4204, Cali
S699	RubyPinnacleBotanics	Extracts	info@rpbotanicsplus.co	Finca La Corona, Guatavita, Cundinamarca
S700	AlphaZenithSourcing	Imports	3176667788	Avenida El Río # 14-100, Of. 3804, Villavicencio
S701	QuantumCoreIngredients	Corp.	quantum@coreing.com	Zona Franca de Occidente III, Bodega F5
S702	Laura	Reyes	3001112233	Calle de las Flores # 13-130, Salento, Quindío
S703	MaritimeMistAromas	Source	maritime@mistaromas.co	Isla Fuerte, Bolívar, Finca Brisa Marina
S704	FlexoCoreBox	Solutions	info@flexocorebox.net	Zona Industrial Fontibón III, Bogotá, Bodega Flexible Core
S705	CatalystAlphaChem	Global	catalyst@alphachem.net.co	Carrera 16 # 92-110, Of. 1207, Bogotá
S706	RadiantShineGlass	\N	3110001122	Parque Industrial de Duitama II, Boyacá
S707	PrecisionCoreLabels	Printing	pedidos.precision@labelscore.org	Avenida Oriental # 65-80, Taller Preciso Core, Medellín
S708	MomentumElementLogistics	Services	3169990011	Torre Momentum III, Piso 28, Barranquilla
S709	BioFusionAlpha	Extracts	biofusion@alphaextracts.com	Vereda El Hato II, Guasca, Cundinamarca
S710	GlobalPinnacleChoice	Imports	3018889900	Oficina 2808, Edificio Global Center II, Pereira
S711	Bruno	Sarmiento	bruno.s@supplyelement.net.co	Calle Nebulosa 89, Bodega Pulsar
S712	Julieta	Torres	3227778899	Transversal del Universo # 35-290, Ibagué
S713	TranquilCoreEssence	Co.	contact.tranquil@essencecore.net	Km 28 Vía Girardot-Tocaima, Parque Industrial Sosiego
S714	GuardianElementPack	Packaging	3056667788	Zona Industrial La Popa III, Bodega Guardián Elemento
S715	SynergyShineAroma	Chemicals	orders.synergy@aromashine.net	Calle 70 # 115-150, Complejo Industrial Sinergia Brillo
S716	LuminousRadiantBottles	Inc.	3125556677	Manzana T Lote 25, Parque Industrial Sabaneta Sur
S717	AdvancedCoreLabels	Innovations	info.advanced@labelcore.org	Carrera 43 # 80-85, Local 8H, Manizales
S718	MomentumPlusGlobal	Logistics	3184445566	Edificio Momentum Plus Tower, Torre H, Of. 3014, Cali
S719	RiverPeakHarvest	Extracts	compras.river@harvestcore.net.co	Magangué, Bolívar, Centro de Acopio Fluvial Alto
S720	ZenithElementFragrance	Hub	3043334455	Calle 93 # 11-125, Of. 2928, Bogotá
S721	Gabriel	Perez	gabriel.p@distripinnacle.com	Avenida El Bosque # 40-100, Pasto
S722	Isabela	Gomez	3172223344	Parque Industrial de Armenia II, Bodega Celeste
S723	ElementalZenithHerbs	World	support.elemental@herbszenith.org	Vía Villa de Leyva-Gachantivá Km 9, Finca Tierra Zen
S724	FortressCoreContainers	S.A.	3021112233	Zona Franca de Barranquilla III, Bodega Fortaleza Core
S725	NovaPinnacleChem	Trading	nova.trade@chempinnacle.com	Carrera 11 # 72-75, Of. 3006, Bogotá
S726	SculptedRadiantBottleDesign	\N	3130001122	Autopista del Sol Sur II Km 12, Taller Vidrio Esculpido Radiante
S727	MaxCorePrintSolutions	Co.	sales.max@printsolcore.net.co	Calle 80 # 22-105, Taller 22I, Manizales
S728	AgileZenithLogistics	Network	3219990011	Centro Logístico del Pacífico II, Bodega Marítima Zen
S729	CanyonPeakEssences	Source	info.canyon@essencesrczenith.co	Chicamocha, Santander, Finca Cañón Alto
S730	ApexPinnacleImports	Group	3008889900	Calle 76 # 14-70, Suite 3030, Bogotá
S731	Lucas	Sarmiento	lucas.s@packstellar.net.co	Carrera 90 # 60-65, Local Industrial Sigma
S732	Valeria	Torres	3107778899	Zona Industrial El Carmen II, Bodega Zafiro, Viboral
S733	SerenePinnacleAromas	Intl.	info@serenepinnacle.biz	Avenida Centenario # 11-140, Armenia, Piso 11
S734	LogicZenithPackaging	Corp.	3156667788	Parque Empresarial Tocancipá II, Bodega 105
S735	GeoCoreChemicals	Ltd.	orders.gc@chemcore.co	Calle 65 # 32-35, Complejo Geológico Central
S736	EtherealRadiantGlassware	\N	3015556677	Vía La Unión-Rionegro, Parque Industrial Etéreo Radiante
S737	LabelAlpha	Solutions	contact@labelalpha.com	Carrera 60 # 90-180, Of. 1008, Barranquilla
S738	PinnacleCoreLogistics	S.A.	3204445566	Centro de Distribución Andino II, Mod. Kappa 11
S739	LagoonZenithHarvest	Co.	lagoon@harvestcozenith.co	Ciénaga, Magdalena, Finca La Ciénaga Zen
S740	NovaPinnacleScentImports	\N	3183334455	Calle 99 # 15A-45, Of. 2816, Bogotá
S741	Simon	Quintero	simon.q@logisticstellar.co	Diagonal 90 # 40-100, Bodega Upsilon
S742	Sofia	Castro	3022223344	Parque Industrial de Funza II, Bodega Galaxia
S743	AromaStellar	Global	stellar@aromastellar.com	Zona Franca de Bogotá III, Unidad Upsilon 12
S744	TerraCorePackSolutions	Supply	3141112233	Centro Industrial de Mosquera II, Bodega 95
S745	SourceOnePinnacleChem	Intl.	sourceone@s1pchemintl.com	Carrera 13 # 70-60, Torre G, Piso 24, Bogotá
S746	GlimmerRadiantGlass	\N	3050001122	Vereda El Peñol II, Guatapé, Taller El Brillo Radiante
S747	TotalCoreLabels	Inc.	sales.total@labelscore.co	Calle 82 # 28-135, Local M17, Manizales
S748	NexusPinnacleLogistics	Group	3129990011	Edificio Nexus Empresarial II, Of. 3302, Cali
S749	ParamoZenithBotanics	Extracts	info@pzbotanics.co	Finca El Mirador del Cóndor, Cocuy, Boyacá
S750	ZenithStellarSourcing	Imports	3178889900	Avenida Libertadores # 10-40, Of. 3002, Cúcuta
S751	StellarCoreIngredients	Ltda.	stellar@coreing.com.co	Zona Franca La Cayena II, Bodega G7, Barranquilla
S752	Ricardo	Montenegro	3000003344	Calle San Juan II # 8-80, Villa de Leyva
S753	OceanicMistAromas	Pure	oceanic@mistaromas.net	Nuquí, Chocó, Finca Pacífica Niebla
S880	ZenithStellarImports	Group	3001112233	Calle 85 # 22-130, Suite 3030, Bogotá
S754	SolidCoreBox	Solutions	info@solidcorebox.org.co	Zona Industrial El Dorado II, Bogotá, Bodega Firme Core
S755	ApexAlphaChem	S.A.	apex@alphachem.co.net	Carrera 17 # 98-60, Of. 1309, Bogotá
S756	BrilliantRadiantGlass	\N	3117778899	Parque Industrial de Duitama III, Boyacá
S757	SmartCoreLabels	Printing	pedidos.smart@labelscore.com.co	Avenida Las Palmas # 40-30, Taller Inteligente Core, Medellín
S758	VelocityElementLogistics	Services	3166667788	Torre Velocity II, Piso 24, Cali
S759	AndesZenithBio	Extracts	andeszenith@bioextracts.com.co	Vereda El Santuario II, Zipacón, Cund.
S760	PrimePinnacleChoice	Imports	3015556677	Oficina 3006, Edificio Prime Center II, Bucaramanga
S761	Isabella	Lopez	isabella.l@supplyalpha.net	Calle Estrecha 34, Bodega Lunar
S762	Martin	Pardo	3221112233	Transversal de la Loma II # 20-200, Medellín
S763	HarmonyCoreEssence	Co.	contact.harmony@essencecore.net.co	Km 20 Vía Suba-Cota, Parque Industrial Armonía Central
S764	FortifyElementPack	Packaging	3050001122	Zona Industrial La Maria III, Bodega Fortaleza Elemento
S765	ChromaShineAroma	Chemicals	orders.chroma@aromashine.net.co	Calle 40 # 90-90, Complejo Industrial Croma Brillo
S766	CrystalZenithBottles	Inc.	3129990011	Manzana M Lote 14, Parque Industrial Itagüí Sur
S767	ProCoreLabelsPlus	Innovations	info.pro@labelcoreplus.com.co	Carrera 45 # 85-75, Local 9I, Barranquilla
S768	SynergyZenithGlobal	Logistics	3188889900	Edificio Synergy Tower II, Torre I, Of. 3212, Bogotá
S769	DeltaPeakHarvest	Extracts	compras.delta@harvestcore.net	Barrancabermeja, Santander, Centro de Acopio Ribereño Alto
S770	SummitElementFragrance	Hub	3047778899	Calle 96 # 10-85, Of. 2728, Bogotá
S771	David	Reyes	david.r@distripinnacleplus.com	Avenida El Lago # 50-110, Villavicencio
S772	Julieta	Soto	3176667788	Parque Industrial de Girón II, Bodega Cuarzo
S773	DivineZenithHerbs	World	support.divine@herbszenith.net	Vía Ráquira II Km 11, Finca Cerámica Zen
S774	ShieldCoreContainers	S.A.	3025556677	Zona Franca de La Tebaida II, Bodega Escudo Core
S775	AlphaPinnacleChem	Trading	alpha.trade@chempinnacle.net	Carrera 14 # 70-85, Of. 3207, Bogotá
S776	EleganceRadiantBottleCraft	\N	3134445566	Autopista del Café Sur II Km 17, Taller Vidrio Elegancia Radiante
S777	OptimalCorePrintSolutions	Co.	sales.optimal@printsolcore.net	Calle 82 # 25-115, Taller 25J, Manizales
S778	PeakZenithFlowLogistics	Network	3213334455	Centro Logístico Andino II, Bodega Cordillera Zen
S779	OasisPeakEssences	Source	info.oasis@essencesrczenith.net.co	Desierto de la Tatacoa II, Huila, Finca Oasis Alto
S780	RegalPinnacleImports	Group	3002223344	Calle 78 # 12-60, Suite 3232, Bogotá
S781	Nicolas	Vargas	nicolas.v@packstellarplus.net	Carrera 95 # 65-85, Local Industrial Tau
S782	Manuela	Campos	3101112233	Zona Industrial El Bosque II, Bodega Astral, Cartagena
S783	MystiquePinnacleAromas	Intl.	info@mystiquepinnacle.biz	Avenida Pinares # 14-160, Pereira, Piso 13
S784	AdvancedZenithPackaging	Corp.	3150001122	Parque Empresarial La Pradera II, Bodega 115, Sopo
S785	TerraCoreChemSource	Ltd.	orders.tccs@chemsourcezenith.co	Calle 60 # 22-40, Complejo Terrestre Central
S786	CelestialRadiantGlassware	\N	3019990011	Vía Guarne-Marinilla II, Parque Industrial Celestial Radiante
S787	LabelZenithPlus	Solutions	contact@labelzenithplus.com	Carrera 62 # 100-210, Of. 1109, Medellín
S788	ZenithCoreLogistics	S.A.	3208889900	Centro de Distribución Global II, Mod. Lambda 13
S789	SunPeakHarvest	Co.	sun@harvestcozenith.net.co	Valledupar, Cesar, Finca Soleada Alta
S790	MysticPinnacleScentImports	\N	3187778899	Calle 102 # 14A-65, Of. 3016, Bogotá
S791	Esteban	Silva	esteban.s@logisticstellarplus.co	Diagonal 95 # 45-120, Bodega Upsilon Plus
S792	Laura	Benitez	3026667788	Parque Industrial de Malambo II, Bodega Astral
S793	AromaPinnacle	Global	pinnacle@aromapinnacle.com	Zona Franca del Pacífico III, Unidad Lambda 14
S794	EcoTerraZenithPack	Supply	3145556677	Centro Industrial de Cogua II, Bodega 105
S795	ChemSourceApex	Intl.	apex@csprimeintl.com	Carrera 11 # 65-70, Torre K, Piso 30, Bogotá
S796	AuraRadiantGlass	\N	3054445566	Vereda La Montañita II, El Retiro, Taller Aura Radiante
S797	SwiftCoreLabels	Inc.	sales.swift@labelscore.org.co	Calle 85 # 30-145, Local N19, Pereira
S798	ApexZenithChainLogistics	Group	3123334455	Edificio Apex Empresarial II, Of. 3502, Barranquilla
S799	CloudForestPinnacleBotanics	Extracts	info@cfbotanicsplus.co	Finca La Niebla II, Jardín, Antioquia
S800	StarlightPinnacleSourcing	Imports	3172223344	Avenida Santander # 14-60, Of. 3004, Manizales
S801	NovaCoreIngredients	S.A.S.	nova@coreingredients.com	Zona Franca Metropolitana II, Bodega H9, Bogotá
S802	Daniela	Perez	3001113344	Calle El Edén II # 9-90, Filandia, Quindío
S803	CoralMistAromas	Source	coral@mistaromas.net.co	Providencia Isla II, Finca Coralina Niebla
S804	GreenCoreBox	Solutions	info@greencorebox.co.org	Zona Industrial Siberia II, Cota, Bodega Ecológica Central
S805	SynergyAlphaChem	S.A.	synergy@alphachem.com.co	Carrera 18 # 90-80, Of. 1410, Bogotá
S806	LumiRadiantGlass	\N	3119991122	Parque Industrial de Paipa III, Boyacá
S807	AgileCoreLabels	Printing	pedidos.agile@labelscore.net	Avenida Cañasgordas # 50-40, Taller Veloz Central, Cali
S808	MomentumZenithLogistics	Services	3168889900	Torre Momentum IV, Piso 30, Medellín
S809	HighPeakAlphaBio	Extracts	highpeak@alphaextracts.org	Vereda El Páramo II, Villa de Leyva
S810	AlphaPinnacleChoice	Imports	3010002233	Oficina 3207, Edificio Alpha Center II, Pereira
S811	Mateo	Romero	mateo.r@supplyzenith.net	Calle Ancha 45, Bodega Nova
S812	Sofia	Gonzalez	3229991122	Transversal de la Sabana II # 22-230, Chía
S813	SerenityCoreEssence	Co.	contact.serenity@essencecore.com.co	Km 22 Vía La Mesa-Girardot, Parque Industrial Calma
S814	SolidElementPack	Packaging	3057778899	Zona Industrial El Muña II, Bodega Sólida Elemento
S815	SpectrumShineAroma	Chemicals	orders.spectrum@aromashine.com.co	Calle 50 # 100-110, Complejo Industrial Espectro Brillo
S816	RadianceZenithBottles	Inc.	3126667788	Manzana N Lote 16, Parque Industrial Envigado Central
S817	UltraCoreLabelsPlus	Innovations	info.ultra@labelcoreplus.net.co	Carrera 48 # 90-85, Local 10J, Barranquilla
S818	VelocityZenithGlobal	Logistics	3185556677	Edificio Velocity Tower II, Torre J, Of. 3214, Cali
S819	MagdalenaPeakHarvest	Extracts	compras.magdalena@harvestcore.net	Honda, Tolima, Centro de Acopio Dorado Alto
S820	CelestialElementFragrance	Hub	3044445566	Calle 99 # 10-95, Of. 3030, Bogotá
S821	Bruno	Gomez	bruno.g@distrapex.com	Avenida El Ferrocarril # 50-120, Ibagué
S822	Julieta	Patiño	3173334455	Parque Industrial de La Virginia II, Bodega Celeste
S823	TerraZenithHerbs	World	support.terra@herbszenith.net.co	Vía Sopo II Km 13, Finca Tierra Viva Zen
S824	TitanCoreContainers	S.A.	3022223344	Zona Franca de Cartagena III, Bodega Titán Core
S825	VertexPinnacleChem	Trading	vertex.trade@chempinnacle.net.co	Carrera 13 # 68-95, Of. 3408, Bogotá
S826	ArtFormRadiantBottleDesign	\N	3131112233	Autopista del Sol Norte II Km 14, Taller Vidrio Formas Radiantes
S827	OptimusCorePrintSolutions	Co.	sales.optimus@printsolcore.net	Calle 90 # 28-125, Taller 28K, Manizales
S828	SummitZenithFlowLogistics	Network	3210001122	Centro Logístico de Occidente III, Bodega Cumbre Zen
S829	SunValleyPeakEssences	Source	info.sunvalley@essencesrczenith.net	Valle de Tenza, Boyacá, Finca Sol Naciente Alto
S830	PinnacleApexImports	Group	3009990011	Calle 79 # 15-80, Suite 3434, Bogotá
S831	Tomas	Salazar	tomas.s@packcelestial.net.co	Carrera 92 # 62-75, Local Industrial Omega
S832	Gabriela	Bedoya	3108889900	Zona Industrial La Argentina II, Bodega Estelar, Neiva
S833	AuraApexAromas	Intl.	info@auraapex.biz	Avenida Las Américas # 18-170, Armenia, Piso 14
S834	IntelliZenithPackaging	Corp.	3157778899	Parque Empresarial Gachancipá III, Bodega 125
S835	EcoCoreChemSource	Ltd.	orders.eccs@chemsourcezenith.co	Calle 52 # 22-45, Complejo Ecológico Central
S836	NovaRadiantGlassware	\N	3016667788	Vía Rionegro-La Ceja II, Parque Industrial Nova Radiante
S837	LabelStellar	Solutions	contact@labelstellar.com	Carrera 62 # 100-190, Of. 1210, Medellín
S838	CoreZenithLogistics	S.A.	3205556677	Centro de Distribución Sabana III, Mod. Omicron 15
S839	MoonPeakHarvest	Co.	moon@harvestcozenith.net	Villa de Leyva, Boyacá, Finca Luna Llena Alta
S840	ApexStellarScentImports	\N	3184445566	Calle 104 # 13A-75, Of. 3218, Bogotá
S841	Julian	Cardenas	julian.c@logisticcelestial.co	Diagonal 100 # 50-130, Bodega Phi
S842	Sara	Ortega	3023334455	Parque Industrial de Palmaseca III, Bodega Cósmica
S843	AromaCelestial	Global	celestial@aromacelestial.com	Zona Franca de Barranquilla IV, Unidad Phi 20
S844	BioTerraStellarPack	Supply	3142223344	Centro Industrial de Tenjo III, Bodega 115
S845	PrimeSourceZenithChem	Intl.	prime@pszenithchem.com	Carrera 15 # 60-80, Torre L, Piso 34, Bogotá
S846	StarlightRadiantGlass	\N	3051112233	Vereda El Carmen III, Sopó, Taller Luz Estelar Radiante
S847	QuantumStellarLabels	Inc.	sales.quantum@labelsstellar.net	Calle 86 # 32-155, Local P21, Pereira
S848	SynergyPinnacleLogistics	Group	3120001122	Edificio Synergy Empresarial IV, Of. 4206, Cali
S849	GoldenPeakZenithBotanics	Extracts	info@gpzbotanics.co	Finca El Edén Dorado II, Calima, Valle
S850	RegalApexSourcing	Imports	3179990011	Avenida El Poblado # 12-100, Of. 3806, Medellín
S851	ElementPinnacleIngredients	Corp.	element@pinnacleing.com	Zona Franca Gachancipá IV, Bodega N15
S852	Nicolas	Quintero	3002223344	Calle de la Poesía # 14-140, Popayán
S853	LagoonRadiantAromas	Source	lagoon@radiantaromas.net.co	Tolú Viejo, Sucre, Finca Radiante Marina
S854	StructurStellarBox	Solutions	info@structurstellar.org.co	Zona Industrial Montevideo V, Bogotá, Bodega Estructura Estelar
S855	CatalystZenithPlusChem	S.A.	catalyst@zenithpluschem.co	Carrera 24 # 102-120, Of. 1814, Bogotá
S856	EtherealLumiGlass	\N	3117778899	Parque Industrial de Yopal IV, Casanare
S857	InfiniteStellarPrintLabels	Printing	pedidos.infinite@labelsstellar.com	Avenida Sur # 70-90, Taller Infinito Estelar, Pasto
S858	PinnacleElementPlusLogistics	Services	3162223344	Torre Pinnacle IV, Piso 38, Barranquilla
S859	SacredAlphaPlusBio	Extracts	sacredalpha@bioextractsplus.co	Vereda El Cocuy IV, Güicán, Boyacá
S860	SummitApexPlusChoice	Imports	3011112233	Oficina 4012, Edificio Summit Center IV, Manizales
S861	Simon	Zuluaga	simon.z@supplyelementplus.net	Calle Galaxia 90, Bodega Supernova
S862	Manuela	Bernal	3220001122	Transversal del Firmamento # 38-300, Ibagué
S863	ZenithStellarEssence	Co.	contact.zenith@essencestellar.co	Km 35 Vía Funza-Siberia, Parque Industrial Zenith Estelar
S864	AegisPinnaclePack	Packaging	3059990011	Zona Industrial La Ceja IV, Bodega Aegis Pináculo
S865	AetherRadiantAroma	Chemicals	orders.aether@aromaradiant.co	Calle 70 # 120-160, Complejo Industrial Etéreo Radiante
S866	GlimmerLumiBottles	Inc.	3128889900	Manzana U Lote 27, Parque Industrial Rionegro Central Sur
S867	ApexStellarLabels	Innovations	info.apex@labelstellar.net.co	Carrera 60 # 110-135, Local 14N, Itagüí
S868	NexusPinnacleGlobal	Logistics	3187778899	Edificio Nexus Tower IV, Torre N, Of. 3524, Medellín
S869	AndeanLumiHarvest	Extracts	compras.lumi@harveststellar.co	Pasto, Nariño, Centro de Acopio Sol Luminoso
S870	AlphaPinnacleFragrance	Hub	3046667788	Calle 110 # 10-125, Of. 2928, Bogotá
S871	Gabriel	Ospina	gabriel.o@distrizenith.com	Avenida Las Vegas # 80-170, Sabaneta
S872	Isabela	Ramirez	3175556677	Parque Industrial de Dosquebradas IV, Bodega Neptuno
S873	PrimalPinnacleHerbs	World	support.primal@herbspinnacle.co	Vía Tabio IV Km 20, Finca Origen Pináculo
S874	BastionPinnacleContainers	S.A.	3024445566	Zona Franca de La Candelaria V, Bodega Bastión Pináculo
S875	CoreStellarChem	Trading	core.trade@chemstellar.com.co	Carrera 16 # 68-125, Of. 3113, Bogotá
S876	RadiantLumiBottleCraft	\N	3133334455	Autopista del Sol Central IV Km 24, Taller Vidrio Luz Luminosa
S877	SynergyStellarPrintSolutions	Co.	sales.synergy@printsolstellar.co	Calle 98 # 32-155, Taller 32P, Cali
S878	VertexPinnacleLogistics	Network	3212223344	Centro Logístico de la Sabana IV, Bodega Vértice Pináculo
S879	EmeraldPinnacleEssences	Source	info.emerald@essencesrcpinnacle.co	Muzo, Boyacá, Finca Esmeralda Cumbre
S881	Lucas	Pineda	lucas.p@packzenithplus.net	Carrera 115 # 90-105, Local Industrial Epsilon
S882	Valeria	Montenegro	3100001122	Zona Industrial El Salado IV, Bodega Cósmica Plus, Ibagué
S883	CelestialPinnacleAromas	Intl.	info@celestialpinnacle.biz	Avenida Oriental # 22-220, Cúcuta, Piso 20
S884	PrecisionStellarPackaging	Corp.	3159990011	Parque Empresarial Mosquera IV, Bodega 170
S885	PrimePinnacleChemSource	Ltd.	orders.ppcs@chemsourcepinnacle.co	Calle 60 # 19-70, Complejo Principal Pináculo
S886	LuminousLumiGlassware	\N	3018889900	Vía Marinilla-El Peñol IV, Parque Industrial Luminoso Doble
S887	LabelZenithPlus	Solutions	contact@labelzenithplus.com.co	Carrera 70 # 112-260, Of. 1715, Barranquilla
S888	AgilePinnacleLogistics	S.A.	3207778899	Centro de Distribución Metro IV, Mod. Upsilon 27
S889	SapphirePinnacleHarvest	Co.	sapphire@harvestcopinnacle.co	Quibdó, Chocó, Finca Zafiro Cumbre
S890	StellarZenithScentImports	\N	3186667788	Calle 112 # 10A-95, Of. 2822, Bogotá
S891	Simon	Mejia	simon.m@logisticapex.co	Diagonal 120 # 75-180, Bodega Chi Plus
S892	Sofia	Villegas	3025556677	Parque Industrial de La Tebaida IV, Bodega Universal
S893	AuraZenithPlus	Global	zenith@aurazenithplus.com	Zona Franca de Rionegro V, Unidad Chi 27
S894	GeoStellarPack	Supply	3144445566	Centro Industrial de Madrid IV, Bodega 160
S895	VertexPinnacleChem	Intl.	vertex@vpchemplusintl.com	Carrera 18 # 58-110, Torre N, Piso 42, Bogotá
S896	GlowZenithPlusGlass	\N	3053334455	Vereda El Alto IV, La Calera, Taller El Destello
S897	SynergyStellarLabels	Inc.	sales.synergy@labelsstellar.net.co	Calle 95 # 38-185, Local T23, Manizales
S898	MomentumZenithLogistics	Group	3122223344	Edificio Momentum Empresarial IV, Of. 4504, Cali
S899	RubyZenithPlusBotanics	Extracts	info@rzbotanicsplus.co	Finca La Alhaja, Guatavita, Cundinamarca
S900	AlphaPinnaclePlusSourcing	Imports	3171112233	Avenida El Río # 16-120, Of. 4006, Villavicencio
S901	QuantumPinnacleIngredients	Corp.	quantum@pinnacleing.net	Zona Franca de Occidente IV, Bodega G7
S902	Laura	Reyes	3003334455	Calle de las Estrellas # 15-150, Salento, Quindío
S903	MaritimeZenithAromas	Source	maritime@zenitharomas.co	Isla Fuerte II, Bolívar, Finca Brisa Zen
S904	FlexoStellarBox	Solutions	info@flexostellarbox.net.co	Zona Industrial Fontibón IV, Bogotá, Bodega Flexible Estelar
S905	CatalystAlphaPlusChem	Global	catalyst@alphapluschem.net	Carrera 17 # 90-120, Of. 1409, Bogotá
S906	RadiantZenithGlass	\N	3112223344	Parque Industrial de Duitama IV, Boyacá
S907	PrecisionStellarLabels	Printing	pedidos.precision@labelsstellar.org	Avenida Oriental # 70-90, Taller Preciso Estelar, Medellín
S908	MomentumPinnacleLogistics	Services	3161112233	Torre Momentum V, Piso 32, Barranquilla
S909	BioFusionAlphaPlus	Extracts	biofusion@alphaplus.com	Vereda El Hato III, Guasca, Cundinamarca
S910	GlobalZenithChoice	Imports	3010001122	Oficina 3010, Edificio Global Center III, Pereira
S911	Bruno	Sarmiento	bruno.s@supplypinnacleplus.net	Calle Cometa 90, Bodega Constelación
S912	Julieta	Torres	3229990011	Transversal del Cosmos # 40-310, Ibagué
S913	TranquilStellarEssence	Co.	contact.tranquil@essencestellar.net	Km 30 Vía Girardot-Melgar, Parque Industrial Calma Estelar
S914	GuardianPinnaclePack	Packaging	3058889900	Zona Industrial La Popa IV, Bodega Guardián Pináculo
S915	SynergyRadiantAroma	Chemicals	orders.synergy@aromaradiant.net.co	Calle 75 # 120-170, Complejo Industrial Sinergia Radiante
S916	LuminousZenithBottles	Inc.	3127778899	Manzana V Lote 29, Parque Industrial Sabaneta Central
S917	AdvancedStellarLabels	Innovations	info.advanced@labelstellar.org	Carrera 46 # 90-95, Local 11K, Manizales
S918	MomentumPlusZenithGlobal	Logistics	3186667788	Edificio Momentum Plus Tower II, Torre K, Of. 3216, Cali
S919	RiverZenithHarvest	Extracts	compras.river@harvestzenith.net	Magangué, Bolívar, Centro de Acopio Fluvial Supremo
S920	ZenithPinnacleFragrance	Hub	3045556677	Calle 95 # 10-135, Of. 3130, Bogotá
S921	Gabriel	Perez	gabriel.p@districelestialplus.com	Avenida El Bosque # 50-120, Pasto
S922	Isabela	Gomez	3174445566	Parque Industrial de Armenia III, Bodega Universal
S923	ElementalPinnacleHerbs	World	support.elemental@herbspinnacle.org	Vía Villa de Leyva-Sáchica II Km 11, Finca Tierra Pináculo
S924	FortressStellarContainers	S.A.	3023334455	Zona Franca de Barranquilla IV, Bodega Fortaleza Estelar
S925	NovaZenithChem	Trading	nova.trade@chemzenith.net.co	Carrera 10 # 70-85, Of. 3208, Bogotá
S926	SculptedLumiBottleDesign	\N	3132223344	Autopista del Sol Sur III Km 14, Taller Vidrio Esculpido Luminoso
S927	MaxStellarPrintSolutions	Co.	sales.max@printsolstellar.net	Calle 85 # 25-125, Taller 25L, Manizales
S928	AgilePinnacleLogistics	Network	3211112233	Centro Logístico del Pacífico III, Bodega Marítima Pináculo
S929	CanyonZenithEssences	Source	info.canyon@essencesrczenith.net.co	Chicamocha, Santander, Finca Cañón Supremo
S930	ApexZenithImports	Group	3000001122	Calle 80 # 16-90, Suite 3636, Bogotá
S931	Lucas	Sarmiento	lucas.s@packcelestialplus.net	Carrera 95 # 70-75, Local Industrial Omega Plus
S932	Valeria	Torres	3109990011	Zona Industrial El Carmen III, Bodega Astral, Viboral
S933	SereneZenithAromas	Intl.	info@serenezenith.biz	Avenida Centenario # 13-160, Armenia, Piso 13
S934	LogicPinnaclePackaging	Corp.	3158889900	Parque Empresarial Tocancipá III, Bodega 135
S935	GeoStellarChemicals	Ltd.	orders.gs@chemstellar.co	Calle 70 # 35-45, Complejo Geológico Estelar
S936	EtherealLumiGlassware	\N	3017778899	Vía La Unión-Rionegro II, Parque Industrial Etéreo Luminoso
S937	LabelAlphaPlus	Solutions	contact@labelalphaplus.com	Carrera 65 # 95-200, Of. 1212, Barranquilla
S938	PinnacleStellarLogistics	S.A.	3206667788	Centro de Distribución Andino III, Mod. Kappa 13
S939	LagoonPinnacleHarvest	Co.	lagoon@harvestcopinnacle.co	Ciénaga, Magdalena, Finca La Ciénaga Pináculo
S940	NovaZenithScentImports	\N	3185556677	Calle 102 # 14A-55, Of. 3018, Bogotá
S941	Simon	Quintero	simon.q@logisticstellarplus.co	Diagonal 92 # 42-110, Bodega Phi
S942	Sofia	Castro	3024445566	Parque Industrial de Funza III, Bodega Celestial
S943	AromaPinnaclePlus	Global	pinnacle@aromapinnacleplus.com	Zona Franca de Bogotá IV, Unidad Chi 14
S944	TerraStellarPackSolutions	Supply	3143334455	Centro Industrial de Mosquera III, Bodega 100
S945	SourceOneZenithChem	Intl.	sourceone@s1zchemintl.com	Carrera 14 # 72-70, Torre H, Piso 26, Bogotá
S946	GlimmerLumiGlass	\N	3052223344	Vereda El Peñol III, Guatapé, Taller El Brillo Luminoso
S947	TotalStellarLabels	Inc.	sales.total@labelsstellar.co	Calle 88 # 30-155, Local N21, Manizales
S948	NexusZenithLogistics	Group	3121112233	Edificio Nexus Empresarial III, Of. 3604, Cali
S949	ParamoPinnacleBotanics	Extracts	info@ppbotanics.co	Finca El Mirador del Cóndor II, Cocuy, Boyacá
S950	ZenithPinnacleSourcing	Imports	3170001122	Avenida Libertadores # 12-50, Of. 3304, Cúcuta
S951	StellarPinnacleIngredients	Ltda.	stellar@pinnacleing.net.co	Zona Franca La Cayena III, Bodega H9, Barranquilla
S952	Ricardo	Montenegro	3004445566	Calle San Juan III # 10-100, Villa de Leyva
S953	OceanicZenithAromas	Pure	oceanic@zenitharomas.com	Nuquí, Chocó, Finca Pacífica Suprema
S954	SolidStellarBox	Solutions	info@solidstellarbox.org	Zona Industrial El Dorado III, Bogotá, Bodega Firme Estelar
S955	ApexAlphaPlusChem	S.A.	apex@alphapluschem.co.net	Carrera 19 # 100-70, Of. 1511, Bogotá
S956	BrilliantLumiGlass	\N	3113334455	Parque Industrial de Duitama V, Boyacá
S957	SmartStellarLabels	Printing	pedidos.smart@labelsstellar.net.co	Avenida Las Palmas # 50-40, Taller Inteligente Estelar, Medellín
S958	VelocityPinnacleLogistics	Services	3160001122	Torre Velocity III, Piso 26, Cali
S959	AndesPinnacleBio	Extracts	andespinnacle@bioextracts.com	Vereda El Santuario III, Zipacón, Cund.
S960	PrimeZenithChoice	Imports	3019990011	Oficina 3408, Edificio Prime Center III, Bucaramanga
S961	Isabella	Lopez	isabella.l@supplyzenithplus.net	Calle Cometa 45, Bodega Nebulosa Plus
S962	Martin	Pardo	3228889900	Transversal de la Galaxia II # 25-250, Ibagué
S963	HarmonyStellarEssence	Co.	contact.harmony@essencestellar.net.co	Km 25 Vía Suba-Cota, Parque Industrial Armonía Estelar
S964	FortifyPinnaclePack	Packaging	3057778899	Zona Industrial La Maria IV, Bodega Fortaleza Pináculo
S965	ChromaRadiantAroma	Chemicals	orders.chroma@aromaradiant.net	Calle 45 # 100-100, Complejo Industrial Croma Radiante
S966	CrystalPinnacleBottles	Inc.	3126667788	Manzana P Lote 18, Parque Industrial Itagüí Central
S967	ProStellarLabelsPlus	Innovations	info.pro@labelstellarplus.com	Carrera 48 # 95-85, Local 12L, Barranquilla
S968	SynergyPinnacleGlobal	Logistics	3185556677	Edificio Synergy Tower III, Torre L, Of. 3514, Bogotá
S969	DeltaZenithHarvest	Extracts	compras.delta@harvestzenith.net.co	Barrancabermeja, Santander, Centro de Acopio Ribereño Supremo
S970	SummitPinnacleFragrance	Hub	3044445566	Calle 100 # 9-95, Of. 3032, Bogotá
S971	David	Reyes	david.r@districelestialcore.com	Avenida El Lago # 60-130, Villavicencio
S972	Julieta	Soto	3173334455	Parque Industrial de Girón III, Bodega Planetaria
S973	DivinePinnacleHerbs	World	support.divine@herbspinnacle.net.co	Vía Ráquira III Km 13, Finca Cerámica Pináculo
S974	ShieldStellarContainers	S.A.	3022223344	Zona Franca de La Tebaida III, Bodega Escudo Estelar
S975	AlphaZenithChem	Trading	alpha.trade@chemzenith.net.co	Carrera 15 # 68-95, Of. 3509, Bogotá
S976	EleganceLumiBottleCraft	\N	3131112233	Autopista del Café Sur III Km 19, Taller Vidrio Elegancia Luminosa
S977	OptimalStellarPrintSolutions	Co.	sales.optimal@printsolstellar.net.co	Calle 92 # 28-135, Taller 28M, Manizales
S978	PeakPinnacleFlowLogistics	Network	3210001122	Centro Logístico Andino III, Bodega Cordillera Pináculo
S979	OasisZenithEssences	Source	info.oasis@essencesrczenithplus.co	Desierto de la Tatacoa III, Huila, Finca Oasis Supremo
S980	RegalZenithImports	Group	3009990011	Calle 82 # 14-80, Suite 3838, Bogotá
S981	Nicolas	Vargas	nicolas.v@packcelestialcore.net	Carrera 100 # 70-95, Local Industrial Phi
S982	Manuela	Campos	3108889900	Zona Industrial El Bosque III, Bodega Solar, Cartagena
S983	MystiqueZenithAromas	Intl.	info@mystiquezenith.biz	Avenida Pinares # 16-180, Pereira, Piso 15
S984	AdvancedPinnaclePackaging	Corp.	3157778899	Parque Empresarial La Pradera III, Bodega 145, Sopo
S985	TerraStellarChemSource	Ltd.	orders.tccs@chemsourcezenithplus.co	Calle 62 # 24-50, Complejo Terrestre Estelar
S986	CelestialLumiGlassware	\N	3016667788	Vía Guarne-Marinilla III, Parque Industrial Celestial Luminoso
S987	LabelPinnaclePlus	Solutions	contact@labelpinnacleplus.com.co	Carrera 68 # 105-250, Of. 1315, Barranquilla
S988	ZenithStellarLogistics	S.A.	3205556677	Centro de Distribución Global III, Mod. Lambda 15
S989	SunZenithHarvest	Co.	sun@harvestcozenithplus.net.co	Valledupar, Cesar, Finca Soleada Suprema
S990	MysticPinnacleScentImports	\N	3184445566	Calle 105 # 13A-85, Of. 3218, Bogotá
S991	Esteban	Silva	esteban.s@logisticcelestialcore.co	Diagonal 100 # 50-140, Bodega Omega Plus Plus
S992	Laura	Benitez	3023334455	Parque Industrial de Malambo III, Bodega Galáctica
S993	AromaZenithPlus	Global	zenith@aromazenithplus.com.co	Zona Franca del Pacífico IV, Unidad Lambda 16
S994	EcoTerraPinnaclePack	Supply	3142223344	Centro Industrial de Cogua III, Bodega 125
S995	ChemSourceApexPlus	Intl.	apex@csprimeplusintl.com	Carrera 10 # 62-90, Torre M, Piso 32, Bogotá
S996	AuraLumiGlass	\N	3051112233	Vereda La Montañita III, El Retiro, Taller Aura Luminosa
S997	SwiftStellarLabels	Inc.	sales.swift@labelsstellar.org.co	Calle 90 # 35-165, Local R23, Pereira
S998	ApexPinnacleChainLogistics	Group	3120001122	Edificio Apex Empresarial III, Of. 3804, Barranquilla
S999	CloudForestZenithBotanics	Extracts	info@cfbotanicsplus.co.net	Finca La Niebla III, Jardín, Antioquia
S000	StarlightZenithSourcing	Imports	3179990011	Avenida Santander # 16-80, Of. 3206, Manizales
\.


                                                                      restore.sql                                                                                         0000600 0004000 0002000 00000065752 15014423351 0015401 0                                                                                                    ustar 00postgres                        postgres                        0000000 0000000                                                                                                                                                                        --
-- NOTE:
--
-- File paths need to be edited. Search for $$PATH$$ and
-- replace it with the path to the directory containing
-- the extracted data files.
--
--
-- PostgreSQL database dump
--

-- Dumped from database version 17.4
-- Dumped by pg_dump version 17.4

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET transaction_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

DROP DATABASE postgres;
--
-- Name: postgres; Type: DATABASE; Schema: -; Owner: postgres
--

CREATE DATABASE postgres WITH TEMPLATE = template0 ENCODING = 'UTF8' LOCALE_PROVIDER = libc LOCALE = 'Spanish_Colombia.1252';


ALTER DATABASE postgres OWNER TO postgres;

\connect postgres

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET transaction_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

--
-- Name: DATABASE postgres; Type: COMMENT; Schema: -; Owner: postgres
--

COMMENT ON DATABASE postgres IS 'default administrative connection database';


--
-- Name: diamond; Type: SCHEMA; Schema: -; Owner: postgres
--

CREATE SCHEMA diamond;


ALTER SCHEMA diamond OWNER TO postgres;

--
-- Name: SCHEMA diamond; Type: COMMENT; Schema: -; Owner: postgres
--

COMMENT ON SCHEMA diamond IS 'database for a perfumery';


--
-- Name: fn_calculate_shipping_cost(); Type: FUNCTION; Schema: diamond; Owner: postgres
--

CREATE FUNCTION diamond.fn_calculate_shipping_cost() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
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
        NEW.shipping_cost := 15;
    END IF;

    RETURN NEW;
END;
$$;


ALTER FUNCTION diamond.fn_calculate_shipping_cost() OWNER TO postgres;

--
-- Name: fn_calculate_subtotal_sales(); Type: FUNCTION; Schema: diamond; Owner: postgres
--

CREATE FUNCTION diamond.fn_calculate_subtotal_sales() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
	NEW.subtotal := (NEW.quantity * NEW.unit_price) - NEW.discount;
	RETURN NEW;
END;
$$;


ALTER FUNCTION diamond.fn_calculate_subtotal_sales() OWNER TO postgres;

--
-- Name: fn_calculate_subtotal_suppliers(); Type: FUNCTION; Schema: diamond; Owner: postgres
--

CREATE FUNCTION diamond.fn_calculate_subtotal_suppliers() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
	NEW.subtotal := (NEW.quantity * NEW.unit_price) - NEW.discount;
	RETURN NEW;
END;
$$;


ALTER FUNCTION diamond.fn_calculate_subtotal_suppliers() OWNER TO postgres;

--
-- Name: fn_update_total_invoice_sales(); Type: FUNCTION; Schema: diamond; Owner: postgres
--

CREATE FUNCTION diamond.fn_update_total_invoice_sales() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
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

$$;


ALTER FUNCTION diamond.fn_update_total_invoice_sales() OWNER TO postgres;

--
-- Name: fn_update_total_invoice_suppliers(); Type: FUNCTION; Schema: diamond; Owner: postgres
--

CREATE FUNCTION diamond.fn_update_total_invoice_suppliers() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
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
$$;


ALTER FUNCTION diamond.fn_update_total_invoice_suppliers() OWNER TO postgres;

--
-- Name: fn_validate_stock_range(); Type: FUNCTION; Schema: diamond; Owner: postgres
--

CREATE FUNCTION diamond.fn_validate_stock_range() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
    IF NEW.stock < NEW.stock_min THEN
        RAISE EXCEPTION 'El stock actual (%), es menor que el stock mínimo permitido (%)', NEW.stock, NEW.stock_min;
    ELSIF NEW.stock > NEW.stock_max THEN
        RAISE EXCEPTION 'El stock actual (%), es mayor que el stock máximo permitido (%)', NEW.stock, NEW.stock_max;
    END IF;
    RETURN NEW;
END;
$$;


ALTER FUNCTION diamond.fn_validate_stock_range() OWNER TO postgres;

SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- Name: cities; Type: TABLE; Schema: diamond; Owner: postgres
--

CREATE TABLE diamond.cities (
    id_city character varying(3) NOT NULL,
    name character varying(40),
    CONSTRAINT nn_cities_name CHECK ((name IS NOT NULL))
);


ALTER TABLE diamond.cities OWNER TO postgres;

--
-- Name: customers; Type: TABLE; Schema: diamond; Owner: postgres
--

CREATE TABLE diamond.customers (
    id_customer character varying(4) NOT NULL,
    first_name character varying(20),
    last_name character varying(20),
    phone character varying(20),
    email character varying(50),
    CONSTRAINT nn_customers_first_name CHECK ((first_name IS NOT NULL)),
    CONSTRAINT nn_customers_last_name CHECK ((last_name IS NOT NULL)),
    CONSTRAINT nn_customers_phone CHECK ((phone IS NOT NULL))
);


ALTER TABLE diamond.customers OWNER TO postgres;

--
-- Name: details_invoice_sales; Type: TABLE; Schema: diamond; Owner: postgres
--

CREATE TABLE diamond.details_invoice_sales (
    id_details_invoice_sale character varying(4) NOT NULL,
    quantity integer,
    unit_price numeric,
    discount numeric,
    subtotal numeric,
    id_invoice_sale character varying(4),
    id_product character varying(4),
    CONSTRAINT nn_details_invoice_sales_discount CHECK ((discount IS NOT NULL)),
    CONSTRAINT nn_details_invoice_sales_invoice_sale CHECK ((id_invoice_sale IS NOT NULL)),
    CONSTRAINT nn_details_invoice_sales_price CHECK ((unit_price IS NOT NULL)),
    CONSTRAINT nn_details_invoice_sales_product CHECK ((id_product IS NOT NULL)),
    CONSTRAINT nn_details_invoice_sales_quantity CHECK ((quantity IS NOT NULL)),
    CONSTRAINT nn_details_invoice_sales_subtotal CHECK ((subtotal IS NOT NULL))
);


ALTER TABLE diamond.details_invoice_sales OWNER TO postgres;

--
-- Name: details_invoice_suppliers; Type: TABLE; Schema: diamond; Owner: postgres
--

CREATE TABLE diamond.details_invoice_suppliers (
    id_line_item character varying(4) NOT NULL,
    quantity integer,
    unit_price numeric,
    discount numeric,
    subtotal numeric,
    id_invoice_supplier character varying(20),
    id_product character varying(4),
    CONSTRAINT nn_details_invoice_suppliers_invoice_supplier CHECK ((id_invoice_supplier IS NOT NULL)),
    CONSTRAINT nn_details_invoice_suppliers_price CHECK ((unit_price IS NOT NULL)),
    CONSTRAINT nn_details_invoice_suppliers_product CHECK ((id_product IS NOT NULL)),
    CONSTRAINT nn_details_invoice_suppliers_quantity CHECK ((quantity IS NOT NULL))
);


ALTER TABLE diamond.details_invoice_suppliers OWNER TO postgres;

--
-- Name: employees; Type: TABLE; Schema: diamond; Owner: postgres
--

CREATE TABLE diamond.employees (
    id_line_item character varying(4) NOT NULL,
    first_name character varying(20),
    last_name character varying(20),
    salary numeric,
    employee_type character varying(40),
    id_manager character varying(4),
    CONSTRAINT nn_employee_type CHECK ((employee_type IS NOT NULL)),
    CONSTRAINT nn_employees_first_name CHECK ((first_name IS NOT NULL)),
    CONSTRAINT nn_employees_last_name CHECK ((last_name IS NOT NULL)),
    CONSTRAINT nn_employees_salary CHECK ((salary IS NOT NULL))
);


ALTER TABLE diamond.employees OWNER TO postgres;

--
-- Name: invoice_sales; Type: TABLE; Schema: diamond; Owner: postgres
--

CREATE TABLE diamond.invoice_sales (
    id_invoice_sale character varying(4) NOT NULL,
    date date,
    details_invoice character varying(100),
    total numeric,
    id_customer character varying(4),
    id_payment_type character varying(2),
    id_line_item character varying(4),
    CONSTRAINT nn_invoice_sales_date CHECK ((date IS NOT NULL)),
    CONSTRAINT nn_invoice_sales_id_customer CHECK ((id_customer IS NOT NULL)),
    CONSTRAINT nn_invoice_sales_id_line_item CHECK ((id_line_item IS NOT NULL)),
    CONSTRAINT nn_invoice_sales_id_payment_type CHECK ((id_payment_type IS NOT NULL)),
    CONSTRAINT nn_invoice_sales_total CHECK ((total IS NOT NULL))
);


ALTER TABLE diamond.invoice_sales OWNER TO postgres;

--
-- Name: invoice_suppliers; Type: TABLE; Schema: diamond; Owner: postgres
--

CREATE TABLE diamond.invoice_suppliers (
    id_invoice_supplier character varying(4) NOT NULL,
    date date,
    details_invoice character varying(100),
    total numeric,
    id_supplier character varying(4),
    CONSTRAINT nn_invoice_suppliers_date CHECK ((date IS NOT NULL)),
    CONSTRAINT nn_invoice_suppliers_supplier_id CHECK ((id_supplier IS NOT NULL)),
    CONSTRAINT nn_invoice_suppliers_total CHECK ((total IS NOT NULL))
);


ALTER TABLE diamond.invoice_suppliers OWNER TO postgres;

--
-- Name: payment_types; Type: TABLE; Schema: diamond; Owner: postgres
--

CREATE TABLE diamond.payment_types (
    id_payment_type character varying(2) NOT NULL,
    name character varying(40),
    CONSTRAINT nn_payment_types_name CHECK ((name IS NOT NULL))
);


ALTER TABLE diamond.payment_types OWNER TO postgres;

--
-- Name: products; Type: TABLE; Schema: diamond; Owner: postgres
--

CREATE TABLE diamond.products (
    id_product character varying(4) NOT NULL,
    name character varying(100),
    current_price numeric,
    description character varying(100),
    type character varying(40),
    stock integer,
    stock_min integer,
    stock_max integer,
    id_customer character varying(4),
    id_regular character varying(4),
    id_promotion character varying(4),
    CONSTRAINT nn_products_current_price CHECK ((current_price IS NOT NULL)),
    CONSTRAINT nn_products_name CHECK ((name IS NOT NULL)),
    CONSTRAINT nn_products_stock CHECK ((stock IS NOT NULL)),
    CONSTRAINT nn_products_stock_max CHECK ((stock_max IS NOT NULL)),
    CONSTRAINT nn_products_stock_min CHECK ((stock_min IS NOT NULL))
);


ALTER TABLE diamond.products OWNER TO postgres;

--
-- Name: promotions; Type: TABLE; Schema: diamond; Owner: postgres
--

CREATE TABLE diamond.promotions (
    id_promotion character varying(4) NOT NULL,
    start_date date,
    end_date date,
    code character varying(10),
    details character varying(100),
    CONSTRAINT nn_end_date CHECK ((end_date IS NOT NULL)),
    CONSTRAINT nn_promotions_code CHECK ((code IS NOT NULL)),
    CONSTRAINT nn_start_date CHECK ((start_date IS NOT NULL))
);


ALTER TABLE diamond.promotions OWNER TO postgres;

--
-- Name: regulars; Type: TABLE; Schema: diamond; Owner: postgres
--

CREATE TABLE diamond.regulars (
    id_regular character varying(4) NOT NULL,
    code character varying(10),
    brand character varying(20),
    CONSTRAINT nn_brand CHECK ((brand IS NOT NULL))
);


ALTER TABLE diamond.regulars OWNER TO postgres;

--
-- Name: shippings; Type: TABLE; Schema: diamond; Owner: postgres
--

CREATE TABLE diamond.shippings (
    id_shipping character varying(4) NOT NULL,
    date date,
    delivery_address character varying(100),
    shipping_cost numeric,
    status character(1),
    id_invoice_sale character varying(4),
    id_state character varying(3),
    CONSTRAINT nn_shippings_date CHECK ((date IS NOT NULL)),
    CONSTRAINT nn_shippings_delivery_address CHECK ((delivery_address IS NOT NULL)),
    CONSTRAINT nn_shippings_invoice_sale CHECK ((id_invoice_sale IS NOT NULL)),
    CONSTRAINT nn_shippings_shipping_cost CHECK ((shipping_cost IS NOT NULL)),
    CONSTRAINT nn_shippings_states CHECK ((id_state IS NOT NULL)),
    CONSTRAINT nn_shippings_status CHECK ((status IS NOT NULL))
);


ALTER TABLE diamond.shippings OWNER TO postgres;

--
-- Name: states; Type: TABLE; Schema: diamond; Owner: postgres
--

CREATE TABLE diamond.states (
    id_state character varying(3) NOT NULL,
    name character varying(60),
    id_city character varying(3),
    CONSTRAINT nn_states_id_city CHECK ((id_city IS NOT NULL)),
    CONSTRAINT nn_states_name CHECK ((name IS NOT NULL))
);


ALTER TABLE diamond.states OWNER TO postgres;

--
-- Name: suppliers; Type: TABLE; Schema: diamond; Owner: postgres
--

CREATE TABLE diamond.suppliers (
    id_supplier character varying(4) NOT NULL,
    first_name character varying(40),
    last_name character varying(15),
    contact character varying(40),
    address character varying(100),
    CONSTRAINT nn_suppliers_address CHECK ((address IS NOT NULL)),
    CONSTRAINT nn_suppliers_contact CHECK ((contact IS NOT NULL)),
    CONSTRAINT nn_suppliers_first_name CHECK ((first_name IS NOT NULL))
);


ALTER TABLE diamond.suppliers OWNER TO postgres;

--
-- Data for Name: cities; Type: TABLE DATA; Schema: diamond; Owner: postgres
--

COPY diamond.cities (id_city, name) FROM stdin;
\.
COPY diamond.cities (id_city, name) FROM '$$PATH$$/5138.dat';

--
-- Data for Name: customers; Type: TABLE DATA; Schema: diamond; Owner: postgres
--

COPY diamond.customers (id_customer, first_name, last_name, phone, email) FROM stdin;
\.
COPY diamond.customers (id_customer, first_name, last_name, phone, email) FROM '$$PATH$$/5127.dat';

--
-- Data for Name: details_invoice_sales; Type: TABLE DATA; Schema: diamond; Owner: postgres
--

COPY diamond.details_invoice_sales (id_details_invoice_sale, quantity, unit_price, discount, subtotal, id_invoice_sale, id_product) FROM stdin;
\.
COPY diamond.details_invoice_sales (id_details_invoice_sale, quantity, unit_price, discount, subtotal, id_invoice_sale, id_product) FROM '$$PATH$$/5135.dat';

--
-- Data for Name: details_invoice_suppliers; Type: TABLE DATA; Schema: diamond; Owner: postgres
--

COPY diamond.details_invoice_suppliers (id_line_item, quantity, unit_price, discount, subtotal, id_invoice_supplier, id_product) FROM stdin;
\.
COPY diamond.details_invoice_suppliers (id_line_item, quantity, unit_price, discount, subtotal, id_invoice_supplier, id_product) FROM '$$PATH$$/5137.dat';

--
-- Data for Name: employees; Type: TABLE DATA; Schema: diamond; Owner: postgres
--

COPY diamond.employees (id_line_item, first_name, last_name, salary, employee_type, id_manager) FROM stdin;
\.
COPY diamond.employees (id_line_item, first_name, last_name, salary, employee_type, id_manager) FROM '$$PATH$$/5128.dat';

--
-- Data for Name: invoice_sales; Type: TABLE DATA; Schema: diamond; Owner: postgres
--

COPY diamond.invoice_sales (id_invoice_sale, date, details_invoice, total, id_customer, id_payment_type, id_line_item) FROM stdin;
\.
COPY diamond.invoice_sales (id_invoice_sale, date, details_invoice, total, id_customer, id_payment_type, id_line_item) FROM '$$PATH$$/5134.dat';

--
-- Data for Name: invoice_suppliers; Type: TABLE DATA; Schema: diamond; Owner: postgres
--

COPY diamond.invoice_suppliers (id_invoice_supplier, date, details_invoice, total, id_supplier) FROM stdin;
\.
COPY diamond.invoice_suppliers (id_invoice_supplier, date, details_invoice, total, id_supplier) FROM '$$PATH$$/5136.dat';

--
-- Data for Name: payment_types; Type: TABLE DATA; Schema: diamond; Owner: postgres
--

COPY diamond.payment_types (id_payment_type, name) FROM stdin;
\.
COPY diamond.payment_types (id_payment_type, name) FROM '$$PATH$$/5129.dat';

--
-- Data for Name: products; Type: TABLE DATA; Schema: diamond; Owner: postgres
--

COPY diamond.products (id_product, name, current_price, description, type, stock, stock_min, stock_max, id_customer, id_regular, id_promotion) FROM stdin;
\.
COPY diamond.products (id_product, name, current_price, description, type, stock, stock_min, stock_max, id_customer, id_regular, id_promotion) FROM '$$PATH$$/5133.dat';

--
-- Data for Name: promotions; Type: TABLE DATA; Schema: diamond; Owner: postgres
--

COPY diamond.promotions (id_promotion, start_date, end_date, code, details) FROM stdin;
\.
COPY diamond.promotions (id_promotion, start_date, end_date, code, details) FROM '$$PATH$$/5131.dat';

--
-- Data for Name: regulars; Type: TABLE DATA; Schema: diamond; Owner: postgres
--

COPY diamond.regulars (id_regular, code, brand) FROM stdin;
\.
COPY diamond.regulars (id_regular, code, brand) FROM '$$PATH$$/5130.dat';

--
-- Data for Name: shippings; Type: TABLE DATA; Schema: diamond; Owner: postgres
--

COPY diamond.shippings (id_shipping, date, delivery_address, shipping_cost, status, id_invoice_sale, id_state) FROM stdin;
\.
COPY diamond.shippings (id_shipping, date, delivery_address, shipping_cost, status, id_invoice_sale, id_state) FROM '$$PATH$$/5140.dat';

--
-- Data for Name: states; Type: TABLE DATA; Schema: diamond; Owner: postgres
--

COPY diamond.states (id_state, name, id_city) FROM stdin;
\.
COPY diamond.states (id_state, name, id_city) FROM '$$PATH$$/5139.dat';

--
-- Data for Name: suppliers; Type: TABLE DATA; Schema: diamond; Owner: postgres
--

COPY diamond.suppliers (id_supplier, first_name, last_name, contact, address) FROM stdin;
\.
COPY diamond.suppliers (id_supplier, first_name, last_name, contact, address) FROM '$$PATH$$/5132.dat';

--
-- Name: cities pk_cities; Type: CONSTRAINT; Schema: diamond; Owner: postgres
--

ALTER TABLE ONLY diamond.cities
    ADD CONSTRAINT pk_cities PRIMARY KEY (id_city);


--
-- Name: customers pk_customers; Type: CONSTRAINT; Schema: diamond; Owner: postgres
--

ALTER TABLE ONLY diamond.customers
    ADD CONSTRAINT pk_customers PRIMARY KEY (id_customer);


--
-- Name: details_invoice_sales pk_details_invoice_sales; Type: CONSTRAINT; Schema: diamond; Owner: postgres
--

ALTER TABLE ONLY diamond.details_invoice_sales
    ADD CONSTRAINT pk_details_invoice_sales PRIMARY KEY (id_details_invoice_sale);


--
-- Name: details_invoice_suppliers pk_details_invoice_suppliers; Type: CONSTRAINT; Schema: diamond; Owner: postgres
--

ALTER TABLE ONLY diamond.details_invoice_suppliers
    ADD CONSTRAINT pk_details_invoice_suppliers PRIMARY KEY (id_line_item);


--
-- Name: employees pk_employees; Type: CONSTRAINT; Schema: diamond; Owner: postgres
--

ALTER TABLE ONLY diamond.employees
    ADD CONSTRAINT pk_employees PRIMARY KEY (id_line_item);


--
-- Name: invoice_sales pk_invoice_sales; Type: CONSTRAINT; Schema: diamond; Owner: postgres
--

ALTER TABLE ONLY diamond.invoice_sales
    ADD CONSTRAINT pk_invoice_sales PRIMARY KEY (id_invoice_sale);


--
-- Name: invoice_suppliers pk_invoice_suppliers; Type: CONSTRAINT; Schema: diamond; Owner: postgres
--

ALTER TABLE ONLY diamond.invoice_suppliers
    ADD CONSTRAINT pk_invoice_suppliers PRIMARY KEY (id_invoice_supplier);


--
-- Name: payment_types pk_payment_types; Type: CONSTRAINT; Schema: diamond; Owner: postgres
--

ALTER TABLE ONLY diamond.payment_types
    ADD CONSTRAINT pk_payment_types PRIMARY KEY (id_payment_type);


--
-- Name: products pk_products; Type: CONSTRAINT; Schema: diamond; Owner: postgres
--

ALTER TABLE ONLY diamond.products
    ADD CONSTRAINT pk_products PRIMARY KEY (id_product);


--
-- Name: promotions pk_promotions; Type: CONSTRAINT; Schema: diamond; Owner: postgres
--

ALTER TABLE ONLY diamond.promotions
    ADD CONSTRAINT pk_promotions PRIMARY KEY (id_promotion);


--
-- Name: regulars pk_regulars; Type: CONSTRAINT; Schema: diamond; Owner: postgres
--

ALTER TABLE ONLY diamond.regulars
    ADD CONSTRAINT pk_regulars PRIMARY KEY (id_regular);


--
-- Name: shippings pk_shippings; Type: CONSTRAINT; Schema: diamond; Owner: postgres
--

ALTER TABLE ONLY diamond.shippings
    ADD CONSTRAINT pk_shippings PRIMARY KEY (id_shipping);


--
-- Name: states pk_states; Type: CONSTRAINT; Schema: diamond; Owner: postgres
--

ALTER TABLE ONLY diamond.states
    ADD CONSTRAINT pk_states PRIMARY KEY (id_state);


--
-- Name: suppliers pk_suppliers; Type: CONSTRAINT; Schema: diamond; Owner: postgres
--

ALTER TABLE ONLY diamond.suppliers
    ADD CONSTRAINT pk_suppliers PRIMARY KEY (id_supplier);


--
-- Name: customers uq_customers_email; Type: CONSTRAINT; Schema: diamond; Owner: postgres
--

ALTER TABLE ONLY diamond.customers
    ADD CONSTRAINT uq_customers_email UNIQUE (email);


--
-- Name: shippings trg_calculate_shipping_cost; Type: TRIGGER; Schema: diamond; Owner: postgres
--

CREATE TRIGGER trg_calculate_shipping_cost BEFORE INSERT OR UPDATE ON diamond.shippings FOR EACH ROW EXECUTE FUNCTION diamond.fn_calculate_shipping_cost();


--
-- Name: details_invoice_sales trg_calculate_subtotal_sales; Type: TRIGGER; Schema: diamond; Owner: postgres
--

CREATE TRIGGER trg_calculate_subtotal_sales BEFORE INSERT OR UPDATE ON diamond.details_invoice_sales FOR EACH ROW EXECUTE FUNCTION diamond.fn_calculate_subtotal_sales();


--
-- Name: details_invoice_suppliers trg_calculate_subtotal_suppliers; Type: TRIGGER; Schema: diamond; Owner: postgres
--

CREATE TRIGGER trg_calculate_subtotal_suppliers BEFORE INSERT OR UPDATE ON diamond.details_invoice_suppliers FOR EACH ROW EXECUTE FUNCTION diamond.fn_calculate_subtotal_suppliers();


--
-- Name: details_invoice_sales trg_update_total_invoice_sales_delete; Type: TRIGGER; Schema: diamond; Owner: postgres
--

CREATE TRIGGER trg_update_total_invoice_sales_delete AFTER DELETE ON diamond.details_invoice_sales FOR EACH ROW EXECUTE FUNCTION diamond.fn_update_total_invoice_sales();


--
-- Name: details_invoice_sales trg_update_total_invoice_sales_insert; Type: TRIGGER; Schema: diamond; Owner: postgres
--

CREATE TRIGGER trg_update_total_invoice_sales_insert AFTER INSERT ON diamond.details_invoice_sales FOR EACH ROW EXECUTE FUNCTION diamond.fn_update_total_invoice_sales();


--
-- Name: details_invoice_sales trg_update_total_invoice_sales_update; Type: TRIGGER; Schema: diamond; Owner: postgres
--

CREATE TRIGGER trg_update_total_invoice_sales_update AFTER UPDATE ON diamond.details_invoice_sales FOR EACH ROW EXECUTE FUNCTION diamond.fn_update_total_invoice_sales();


--
-- Name: details_invoice_suppliers trg_update_total_invoice_suppliers_delete; Type: TRIGGER; Schema: diamond; Owner: postgres
--

CREATE TRIGGER trg_update_total_invoice_suppliers_delete AFTER DELETE ON diamond.details_invoice_suppliers FOR EACH ROW EXECUTE FUNCTION diamond.fn_update_total_invoice_suppliers();


--
-- Name: details_invoice_suppliers trg_update_total_invoice_suppliers_insert; Type: TRIGGER; Schema: diamond; Owner: postgres
--

CREATE TRIGGER trg_update_total_invoice_suppliers_insert AFTER INSERT ON diamond.details_invoice_suppliers FOR EACH ROW EXECUTE FUNCTION diamond.fn_update_total_invoice_suppliers();


--
-- Name: details_invoice_suppliers trg_update_total_invoice_suppliers_update; Type: TRIGGER; Schema: diamond; Owner: postgres
--

CREATE TRIGGER trg_update_total_invoice_suppliers_update AFTER UPDATE ON diamond.details_invoice_suppliers FOR EACH ROW EXECUTE FUNCTION diamond.fn_update_total_invoice_suppliers();


--
-- Name: products trg_validate_stock_range; Type: TRIGGER; Schema: diamond; Owner: postgres
--

CREATE TRIGGER trg_validate_stock_range BEFORE INSERT OR UPDATE ON diamond.products FOR EACH ROW EXECUTE FUNCTION diamond.fn_validate_stock_range();


--
-- Name: details_invoice_sales fk_details_invoice_sales_invoice_sale; Type: FK CONSTRAINT; Schema: diamond; Owner: postgres
--

ALTER TABLE ONLY diamond.details_invoice_sales
    ADD CONSTRAINT fk_details_invoice_sales_invoice_sale FOREIGN KEY (id_invoice_sale) REFERENCES diamond.invoice_sales(id_invoice_sale);


--
-- Name: details_invoice_sales fk_details_invoice_sales_product; Type: FK CONSTRAINT; Schema: diamond; Owner: postgres
--

ALTER TABLE ONLY diamond.details_invoice_sales
    ADD CONSTRAINT fk_details_invoice_sales_product FOREIGN KEY (id_product) REFERENCES diamond.products(id_product);


--
-- Name: details_invoice_suppliers fk_details_invoice_suppliers_invoice_supplier; Type: FK CONSTRAINT; Schema: diamond; Owner: postgres
--

ALTER TABLE ONLY diamond.details_invoice_suppliers
    ADD CONSTRAINT fk_details_invoice_suppliers_invoice_supplier FOREIGN KEY (id_invoice_supplier) REFERENCES diamond.invoice_suppliers(id_invoice_supplier);


--
-- Name: details_invoice_suppliers fk_details_invoice_suppliers_product; Type: FK CONSTRAINT; Schema: diamond; Owner: postgres
--

ALTER TABLE ONLY diamond.details_invoice_suppliers
    ADD CONSTRAINT fk_details_invoice_suppliers_product FOREIGN KEY (id_product) REFERENCES diamond.products(id_product);


--
-- Name: employees fk_employees_manager; Type: FK CONSTRAINT; Schema: diamond; Owner: postgres
--

ALTER TABLE ONLY diamond.employees
    ADD CONSTRAINT fk_employees_manager FOREIGN KEY (id_manager) REFERENCES diamond.employees(id_line_item);


--
-- Name: invoice_sales fk_invoice_sales_customers; Type: FK CONSTRAINT; Schema: diamond; Owner: postgres
--

ALTER TABLE ONLY diamond.invoice_sales
    ADD CONSTRAINT fk_invoice_sales_customers FOREIGN KEY (id_customer) REFERENCES diamond.customers(id_customer);


--
-- Name: invoice_sales fk_invoice_sales_employees; Type: FK CONSTRAINT; Schema: diamond; Owner: postgres
--

ALTER TABLE ONLY diamond.invoice_sales
    ADD CONSTRAINT fk_invoice_sales_employees FOREIGN KEY (id_line_item) REFERENCES diamond.employees(id_line_item);


--
-- Name: invoice_sales fk_invoice_sales_payment_types; Type: FK CONSTRAINT; Schema: diamond; Owner: postgres
--

ALTER TABLE ONLY diamond.invoice_sales
    ADD CONSTRAINT fk_invoice_sales_payment_types FOREIGN KEY (id_payment_type) REFERENCES diamond.payment_types(id_payment_type);


--
-- Name: invoice_suppliers fk_invoice_suppliers_supplier_id; Type: FK CONSTRAINT; Schema: diamond; Owner: postgres
--

ALTER TABLE ONLY diamond.invoice_suppliers
    ADD CONSTRAINT fk_invoice_suppliers_supplier_id FOREIGN KEY (id_supplier) REFERENCES diamond.suppliers(id_supplier);


--
-- Name: products fk_products_customers; Type: FK CONSTRAINT; Schema: diamond; Owner: postgres
--

ALTER TABLE ONLY diamond.products
    ADD CONSTRAINT fk_products_customers FOREIGN KEY (id_customer) REFERENCES diamond.customers(id_customer);


--
-- Name: products fk_products_promotions; Type: FK CONSTRAINT; Schema: diamond; Owner: postgres
--

ALTER TABLE ONLY diamond.products
    ADD CONSTRAINT fk_products_promotions FOREIGN KEY (id_promotion) REFERENCES diamond.promotions(id_promotion);


--
-- Name: products fk_products_regulars; Type: FK CONSTRAINT; Schema: diamond; Owner: postgres
--

ALTER TABLE ONLY diamond.products
    ADD CONSTRAINT fk_products_regulars FOREIGN KEY (id_regular) REFERENCES diamond.regulars(id_regular);


--
-- Name: shippings fk_shippings_invoice_sale; Type: FK CONSTRAINT; Schema: diamond; Owner: postgres
--

ALTER TABLE ONLY diamond.shippings
    ADD CONSTRAINT fk_shippings_invoice_sale FOREIGN KEY (id_invoice_sale) REFERENCES diamond.invoice_sales(id_invoice_sale);


--
-- Name: shippings fk_shippings_states; Type: FK CONSTRAINT; Schema: diamond; Owner: postgres
--

ALTER TABLE ONLY diamond.shippings
    ADD CONSTRAINT fk_shippings_states FOREIGN KEY (id_state) REFERENCES diamond.states(id_state);


--
-- Name: states fk_states_cities; Type: FK CONSTRAINT; Schema: diamond; Owner: postgres
--

ALTER TABLE ONLY diamond.states
    ADD CONSTRAINT fk_states_cities FOREIGN KEY (id_city) REFERENCES diamond.cities(id_city);


--
-- PostgreSQL database dump complete
--

                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                      