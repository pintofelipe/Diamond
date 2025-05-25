--Test 

select * from diamond.products
where id_product in ('TP01','TP02');

INSERT INTO diamond.products (id_product, name, current_price, description, type, stock, stock_min, stock_max, id_regular, id_promotion)
VALUES
('TP01', 'Perfume Test Alpha', 150000, 'Descripción Test Alpha', 'Eau de Parfum', 50, 10, 100, 'R001', 'P001'),
('TP02', 'Perfume Test Beta', 200000, 'Descripción Test Beta', 'Eau de Toilette', 30, 5, 50, 'R002', NULL);

-- Verifica el estado inicial
SELECT * FROM diamond.products 
WHERE id_product
LIKE 'TP%';

SELECT * 
FROM diamond.audit_products; -- Debería estar vacía o con registros de pruebas anteriores


UPDATE diamond.products
SET current_price = 160000, stock = 45
WHERE id_product = 'TP01';



DELETE FROM diamond.products
WHERE id_product = 'TP02';


INSERT INTO diamond.products (id_product, name, current_price, description, type, stock, stock_min, stock_max)
VALUES ('TP03', 'Perfume Test Gamma', 100000, 'Descripción Test Gamma', 'Body Mist', 70, 15, 150);

select *
from diamond.customers
where id_customer = 'TC01';

-- Asumiendo que ya existen, sino insertar:
INSERT INTO diamond.customers (id_customer, first_name, last_name, phone, email)
VALUES ('TC01', 'Cliente', 'Prueba', '318207777', 'cliente.prueba@example.com');

INSERT INTO diamond.employees (id_line_item, first_name, last_name, salary, employee_type)
VALUES ('TE01', 'Empleado', 'Auditor', 2000000, 'Vendedor');

INSERT INTO diamond.payment_types (id_payment_type, name)
VALUES ('06', 'TestPay');

SELECT * FROM diamond.employees;

SELECT * FROM diamond.audit_invoice_Sales


select * from diamond.invoice_sales
where id_line_item = 'E003'
and id_invoice_sale = 'I279';



select * from diamond.details_invoice_sales
where id_line_item = 'E003';

-- Asumiendo que el empleado 'E003' existe
UPDATE diamond.invoice_sales
SET details_invoice = 'Factura Prueba DOS - Modificada', id_line_item = 'E003'
WHERE id_invoice_sale = 'I279';



-- Si TI02 tiene detalles y la FK es restrictiva, primero elimina los detalles:

Select * from diamond.details_invoice_Sales
where id_invoice_sale = 'I274'

select * from diamond.invoice_saleS
where id_invoice_sale = 'I274'

DELETE FROM diamond.details_invoice_sales
WHERE id_invoice_sale = 'I274';

DELETE FROM diamond.invoice_sales
WHERE id_invoice_sale = 'I274';

select * from diamond.shippings
where id_invoice_sale ='I274';

DELETE FROM diamond.shippings
where id_invoice_sale = 'I274'

select *
from diamond.audit_invoice_sales;
















