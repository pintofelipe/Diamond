ALTER TABLE DIAMOND.EMPLOYEES
ALTER COLUMN employee_type TYPE VARCHAR(40);

INSERT INTO DIAMOND.EMPLOYEES (id_line_item, first_name, last_name, salary, employee_type, id_manager) VALUES
('E001', 'Laura', 'Jimenez', 15000000, 'CEO', NULL),
('E002', 'Carlos', 'Restrepo', 12000000, 'Director', NULL), -- Director Operaciones
('E003', 'Sofia', 'Gaviria', 12000000, 'Director', NULL), -- Directora Financiera
('E004', 'Andres', 'Molina', 10000000, 'Director', NULL), -- Director Marketing
('E005', 'Camila', 'Vargas', 10000000, 'Director', NULL), -- Directora RRHH
('E006', 'David', 'Lopera', 8000000, 'Manager', NULL), -- Gerente General Tiendas
('E007', 'Valentina', 'Perez', 7500000, 'Manager', NULL), -- Gerente Logística
('E008', 'Santiago', 'Rojas', 7000000, 'Manager', NULL), -- Gerente IT
('E009', 'Mariana', 'Gomez', 6500000, 'Manager', NULL), -- Gerente Contabilidad
('E010', 'Juan', 'Lopez', 6000000, 'Manager', NULL), -- Gerente Compras
('E011', 'Daniela', 'Martinez', 5500000, 'Manager', NULL), -- Gerente Tienda Principal
('E012', 'Alejandro', 'Sanchez', 5000000, 'Manager', NULL), -- Gerente Marketing Digital
('E013', 'Gabriela', 'Fernandez', 4800000, 'Manager', NULL), -- Gerente Talento Humano
('E014', 'Mateo', 'Garcia', 4500000, 'Manager', NULL), -- Gerente Soporte Técnico
('E015', 'Isabella', 'Gonzalez', 4200000, 'Manager', NULL), -- Jefe de Bodega Central
('E016', 'Nicolas', 'Diaz', 4000000, 'Specialist', NULL), -- Especialista Senior Finanzas
('E017', 'Luciana', 'Ruiz', 3800000, 'Coordinator', NULL), -- Coordinadora E-commerce
('E018', 'Emilio', 'Alvarez', 3600000, 'Analyst', NULL), -- Analista Senior BI
('E019', 'Julieta', 'Moreno', 3500000, 'Designer', NULL), -- Diseñadora Gráfica Principal
('E020', 'Tomas', 'Jimenez', 3400000, 'HRBP', NULL), -- HR Business Partner
('E021', 'Antonia', 'Vargas', 3300000, 'LogisticsSp', NULL), -- Especialista Logística
('E022', 'Felipe', 'Castro', 3200000, 'NetworkAdm', NULL), -- Administrador de Redes
('E023', 'Martina', 'Silva', 3100000, 'Accountant', NULL), -- Contadora Senior
('E024', 'Joaquin', 'Torres', 3000000, 'Buyer', NULL), -- Comprador Senior
('E025', 'Sara', 'Rojas', 2800000, 'SalesLead', NULL), -- Líder de Ventas Tienda
('E026', 'Martin', 'Herrera', 2700000, 'ContentLead', NULL), -- Líder de Contenido
('E027', 'Elena', 'Medina', 2600000, 'Recruiter', NULL), -- Reclutadora Senior
('E028', 'Simon', 'Flores', 2500000, 'HelpDeskSup', NULL), -- Supervisor Mesa de Ayuda
('E029', 'Olivia', 'Morales', 2400000, 'StockLead', NULL), -- Líder de Inventarios
('E030', 'Maximiliano', 'Ortega', 2300000, 'Auditor', NULL); -- Auditor Interno
INSERT INTO DIAMOND.EMPLOYEES (id_line_item, first_name, last_name, salary, employee_type, id_manager) VALUES
-- Reportando a Directores (E002-E005)
('E031', 'Valeria', 'Guzman', 7000000, 'Manager', 'E002'), -- Gerente Producción a Dir. Operaciones
('E032', 'Lucas', 'Navas', 6800000, 'Manager', 'E002'), -- Gerente Calidad a Dir. Operaciones
('E033', 'Renata', 'Campos', 6500000, 'Manager', 'E003'), -- Gerente Tesorería a Dir. Financiera
('E034', 'Bruno', 'Silva', 6200000, 'Manager', 'E003'), -- Gerente Planeación Fin. a Dir. Financiera
('E035', 'Clara', 'Mendez', 6000000, 'Manager', 'E004'), -- Gerente Publicidad a Dir. Marketing
('E036', 'Hugo', 'Rios', 5800000, 'Manager', 'E004'), -- Gerente Relaciones P. a Dir. Marketing
('E037', 'Eva', 'Soto', 5500000, 'Manager', 'E005'), -- Gerente Bienestar a Dir. RRHH
('E038', 'Adrian', 'Vega', 5300000, 'Manager', 'E005'), -- Gerente Desarrollo Org. a Dir. RRHH

-- Reportando a Managers (E006-E015)
('E039', 'Sofia', 'Castro', 4500000, 'Manager', 'E006'), -- Subgerente Tienda A a Ger. Gral Tiendas
('E040', 'Javier', 'Luna', 4300000, 'Manager', 'E006'), -- Subgerente Tienda B a Ger. Gral Tiendas
('E041', 'Paula', 'Blanco', 3500000, 'Coordinator', 'E007'), -- Coordinador Despachos a Ger. Logística
('E042', 'Ricardo', 'Marin', 3400000, 'Coordinator', 'E007'), -- Coordinador Transporte a Ger. Logística
('E043', 'Laura', 'Acosta', 3300000, 'DevLead', 'E008'), -- Líder Desarrollo a Ger. IT
('E044', 'Mateo', 'Pinto', 3200000, 'InfraLead', 'E008'), -- Líder Infraestructura a Ger. IT
('E045', 'Catalina', 'Bravo', 3100000, 'AccountantS', 'E009'), -- Contador SemiSr a Ger. Contabilidad
('E046', 'Esteban', 'Cortes', 3000000, 'AccountantS', 'E009'), -- Contador SemiSr a Ger. Contabilidad
('E047', 'Victoria', 'Salas', 2900000, 'BuyerJr', 'E010'), -- Comprador Jr a Ger. Compras
('E048', 'Ignacio', 'Leon', 2800000, 'BuyerJr', 'E010'), -- Comprador Jr a Ger. Compras
('E049', 'Carolina', 'Velez', 2500000, 'Sales', 'E011'), -- Vendedor Tienda Principal
('E050', 'Andres', 'Mora', 2400000, 'Cashier', 'E011'), -- Cajero Tienda Principal
('E051', 'Fernanda', 'Diaz', 2500000, 'Sales', 'E011'), -- Vendedor Tienda Principal
('E052', 'Roberto', 'Silva', 2300000, 'MarketingEx', 'E012'), -- Ejecutivo Marketing Dig.
('E053', 'Manuela', 'Peña', 2200000, 'SEOAnalyst', 'E012'), -- Analista SEO
('E054', 'Samuel', 'Cordoba', 2100000, 'HRAnalyst', 'E013'), -- Analista RRHH
('E055', 'Daniel', 'Ortiz', 2000000, 'RecruiterJr', 'E013'), -- Reclutador Jr
('E056', 'Camila', 'Guerrero', 1900000, 'SupportTech', 'E014'), -- Técnico Soporte
('E057', 'Luis', 'Hoyos', 1900000, 'SupportTech', 'E014'), -- Técnico Soporte
('E058', 'Ana', 'Quintana', 1800000, 'WarehouseOp', 'E015'), -- Operario Bodega
('S059', 'Pedro', 'Zamora', 1800000, 'WarehouseOp', 'E015'), -- Operario Bodega (CORRECCIÓN ID a E059)
('E059', 'Pedro', 'Zamora', 1800000, 'WarehouseOp', 'E015'), -- Operario Bodega (ID CORREGIDO)
('E060', 'Carmen', 'Nuñez', 1700000, 'AdminAsist', 'E016'), -- Asistente Admin. a Esp. Finanzas

-- Nuevos Empleados reportando a Managers recién creados o existentes
('E061', 'David', 'Campos', 2000000, 'Sales', 'E039'), -- Vendedor Tienda A
('E062', 'Isabel', 'Reyes', 1900000, 'Cashier', 'E039'), -- Cajero Tienda A
('E063', 'Miguel', 'Santos', 2000000, 'Sales', 'E040'), -- Vendedor Tienda B
('E064', 'Patricia', 'Parra', 1900000, 'Cashier', 'E040'), -- Cajero Tienda B
('E065', 'Javier', 'Solarte', 1800000, 'LogisticsAs', 'E041'), -- Asistente Logística a Coord. Despachos
('E066', 'Elena', 'Barrios', 1800000, 'LogisticsAs', 'E042'), -- Asistente Logística a Coord. Transporte
('E067', 'Andres', 'Tapia', 2800000, 'Developer', 'E043'), -- Desarrollador
('E068', 'Camila', 'Urrutia', 2800000, 'Developer', 'E043'), -- Desarrollador
('E069', 'Santiago', 'Valencia', 2700000, 'SysAdmin', 'E044'), -- Administrador Sistemas
('E070', 'Valentina', 'Zuleta', 2600000, 'AccountantJ', 'E045'), -- Contador Jr
('E071', 'Daniel', 'Abadia', 2600000, 'AccountantJ', 'E046'), -- Contador Jr
('E072', 'Gabriela', 'Bernal', 2500000, 'PurchasingA', 'E047'), -- Asistente Compras
('E073', 'Ricardo', 'Casas', 2500000, 'PurchasingA', 'E048'), -- Asistente Compras
('E074', 'Paula', 'Duarte', 1800000, 'Sales', 'E025'), -- Vendedor (reporta a SalesLead E025)
('E075', 'Alejandro', 'Estevez', 1700000, 'Cashier', 'E025'), -- Cajero
('E076', 'Natalia', 'Franco', 2000000, 'ContentCrea', 'E026'), -- Creador Contenido
('E077', 'Martin', 'Giraldo', 1900000, 'SocialMedia', 'E026'), -- Especialista Social Media
('E078', 'Lucia', 'Henao', 1800000, 'HRAsist', 'E020'), -- Asistente RRHH (reporta a HRBP E020)
('E079', 'Fernando', 'Ibarra', 1700000, 'SupportJr', 'E028'), -- Soporte Jr (reporta a HelpDeskSup E028)
('E080', 'Veronica', 'Jaramillo', 1600000, 'StockAssist', 'E029'); -- Asistente Inventarios

INSERT INTO DIAMOND.EMPLOYEES (id_line_item, first_name, last_name, salary, employee_type, id_manager) VALUES
-- Más personal para Tiendas, Logística, IT, Contabilidad, Compras
('E081', 'Sergio', 'Klein', 2000000, 'Sales', 'E011'), -- Tienda Principal
('E082', 'Andrea', 'Lugo', 1900000, 'Cashier', 'E011'),
('E083', 'Jorge', 'Marin', 1800000, 'WarehouseOp', 'E015'), -- Bodega Central
('E084', 'Adriana', 'Nieto', 1800000, 'WarehouseOp', 'E015'),
('E085', 'Alberto', 'Ocampo', 2700000, 'Developer', 'E043'),
('E086', 'Monica', 'Patiño', 2600000, 'SysAdmin', 'E044'),
('E087', 'Victor', 'Quintero', 2500000, 'AccountantJ', 'E009'), -- Reporta directo a Ger. Contabilidad
('E088', 'Cristina', 'Ramirez', 2400000, 'BuyerAsist', 'E010'), -- Asistente de Ger. Compras

-- Personal para Marketing, RRHH, Soporte (reportando a managers de nivel medio)
('E089', 'Raul', 'Saldarriaga', 2100000, 'MarketingAs', 'E012'), -- Asistente Marketing Digital
('E090', 'Beatriz', 'Tamayo', 2000000, 'HRAsist', 'E013'), -- Asistente Talento Humano
('E091', 'Oscar', 'Useche', 1800000, 'SupportTech', 'E014'),
('E092', 'Silvia', 'Varela', 1700000, 'AdminAsist', 'E003'), -- Asistente a Directora Financiera

-- Personal para Gerentes de Producción, Calidad, Tesorería, etc. (E031-E038)
('E093', 'Jose', 'Yepes', 2200000, 'ProdAnalyst', 'E031'), -- Analista Producción
('E094', 'Rosa', 'Zuluaga', 2100000, 'QualityInsp', 'E032'), -- Inspector Calidad
('E095', 'Manuel', 'Arbelaez', 2000000, 'TreasuryAs', 'E033'), -- Asistente Tesorería
('E096', 'Teresa', 'Benitez', 1900000, 'FinPlanAs', 'E034'), -- Asistente Planeación Fin.
('E097', 'Francisco', 'Cardenas', 1800000, 'AdCreative', 'E035'), -- Creativo Publicidad
('E098', 'Gloria', 'Delgado', 1700000, 'PRAssist', 'E036'), -- Asistente Relaciones P.
('E099', 'Antonio', 'Echeverri', 1600000, 'WellnessAs', 'E037'), -- Asistente Bienestar
('E100', 'Angela', 'Fajardo', 1500000, 'OrgDevAs', 'E038'), -- Asistente Desarrollo Org.

-- Más personal para Subgerentes de Tienda (E039, E040)
('E101', 'Diego', 'Galindo', 1800000, 'Sales', 'E039'), -- Tienda A
('E102', 'Sandra', 'Gomez', 1700000, 'Sales', 'E039'),
('E103', 'Ana', 'Hurtado', 1800000, 'Sales', 'E040'), -- Tienda B
('E104', 'Luis', 'Isaza', 1700000, 'Sales', 'E040'),

-- Personal bajo Coordinadores (E041, E042) y Líderes (E043, E044)
('E105', 'Maria', 'Jimenez', 1700000, 'LogisticsOp', 'E041'), -- Operario Despachos
('E106', 'Carlos', 'Leon', 1700000, 'Driver', 'E042'), -- Conductor
('E107', 'Sofia', 'Mejia', 2500000, 'DeveloperJr', 'E043'),
('E108', 'Juan', 'Naranjo', 2400000, 'InfraTech', 'E044'),

-- Personal bajo Especialistas/Coordinadores que ahora pueden tener equipo (E017, E019, E021, E022, E024)
('E109', 'Daniela', 'Orozco', 1800000, 'EcomAsist', 'E017'), -- Asistente E-commerce
('E110', 'Alejandro', 'Palacio', 1700000, 'DesignJr', 'E019'), -- Diseñador Jr
('E111', 'Gabriela', 'Quiroga', 1600000, 'LogisticsJr', 'E021'), -- Logística Jr
('E112', 'Mateo', 'Rendon', 1500000, 'NetworkJr', 'E022'), -- Redes Jr
('E113', 'Isabella', 'Suarez', 1400000, 'BuyerTraine', 'E024'), -- Comprador en Entrenamiento

-- Distribuyendo más personal operativo y de entrada
('E114', 'Nicolas', 'Toro', 1800000, 'Sales', 'E011'),
('E115', 'Luciana', 'Urrego', 1700000, 'Cashier', 'E011'),
('E116', 'Emilio', 'Vasco', 1600000, 'WarehouseOp', 'E015'),
('E117', 'Julieta', 'Zapata', 1500000, 'MarketingJr', 'E012'),
('E118', 'Tomas', 'Aguirre', 1400000, 'HRIntern', 'E013'),
('E119', 'Antonia', 'Blandon', 1300000, 'SupportTrn', 'E014'),
('E120', 'Felipe', 'Cifuentes', 1800000, 'Sales', 'E039'),
('E121', 'Martina', 'Davila', 1700000, 'Cashier', 'E039'),
('E122', 'Joaquin', 'Escudero', 1800000, 'Sales', 'E040'),
('E123', 'Sara', 'Franco', 1700000, 'Cashier', 'E040'),
('E124', 'Martin', 'Giraldo', 1600000, 'LogisticsOp', 'E041'),
('E125', 'Elena', 'Hincapie', 1600000, 'Driver', 'E042'),
('E126', 'Simon', 'Jaramillo', 2300000, 'DeveloperJr', 'E043'),
('E127', 'Olivia', 'Koppel', 2200000, 'InfraTech', 'E044'),
('E128', 'Maximiliano', 'Lopez', 2000000, 'AccountantJ', 'E045'),
('E129', 'Valeria', 'Maldonado', 1900000, 'PurchasingA', 'E047'),
('E130', 'Lucas', 'Narvaez', 1800000, 'Sales', 'E025');




INSERT INTO DIAMOND.EMPLOYEES (id_line_item, first_name, last_name, salary, employee_type, id_manager) VALUES
-- Personal para Líderes/Coordinadores que podrían tener equipos pequeños (E017-E029)
('E131', 'Renata', 'Osorio', 1700000, 'EcomSupport', 'E017'), -- Soporte E-commerce
('E132', 'Bruno', 'Pabon', 1600000, 'BIJrAnalyst', 'E018'), -- Analista BI Jr
('E133', 'Clara', 'Quiceno', 1500000, 'DesignAsist', 'E019'), -- Asistente Diseño
('E134', 'Hugo', 'Ramirez', 1400000, 'HRIntern', 'E020'),
('E135', 'Eva', 'Salazar', 1300000, 'LogisticsTr', 'E021'), -- Trainee Logística
('E136', 'Adrian', 'Tellez', 1200000, 'NetworkTrn', 'E022'), -- Trainee Redes
('E137', 'Sofia', 'Upegui', 1900000, 'AccountJrAs', 'E023'), -- Asistente Contable Jr
('E138', 'Javier', 'Valbuena', 1800000, 'BuyerAsist', 'E024'),
('E139', 'Paula', 'Wills', 1700000, 'Sales', 'E025'),
('E140', 'Ricardo', 'Ximenez', 1600000, 'ContentJr', 'E026'), -- Contenido Jr
('E141', 'Laura', 'Yanez', 1500000, 'RecruitAsis', 'E027'), -- Asistente Reclutamiento
('E142', 'Mateo', 'Zambrano', 1400000, 'HelpDeskAs', 'E028'), -- Asistente Mesa Ayuda
('E143', 'Catalina', 'Aristizabal', 1300000, 'StockIntern', 'E029'), -- Pasante Inventarios

-- Más empleados para diferentes áreas, asignando a managers de nivel medio/alto
('E144', 'Esteban', 'Botero', 2000000, 'Sales', 'E011'),
('E145', 'Victoria', 'Cabrera', 1900000, 'Cashier', 'E011'),
('E146', 'Ignacio', 'Dominguez', 1800000, 'WarehouseOp', 'E015'),
('E147', 'Carolina', 'Espinosa', 1700000, 'MarketingJr', 'E012'),
('E148', 'Andres', 'Ferrer', 1600000, 'HRAsist', 'E013'),
('E149', 'Fernanda', 'Garcia', 1500000, 'SupportTech', 'E014'),
('E150', 'Roberto', 'Herrera', 2200000, 'ProdAnalyst', 'E031'), -- Analista Producción
('E151', 'Manuela', 'Iglesias', 2100000, 'QualityInsp', 'E032'),
('E152', 'Samuel', 'Jaramillo', 2000000, 'TreasuryAs', 'E033'),
('E153', 'Daniel', 'Kattan', 1900000, 'FinPlanAs', 'E034'),
('E154', 'Camila', 'Linares', 1800000, 'AdCreative', 'E035'),
('E155', 'Luis', 'Montoya', 1700000, 'PRAssist', 'E036'),
('E156', 'Ana', 'Noreña', 1600000, 'WellnessAs', 'E037'),
('E157', 'Pedro', 'Olaya', 1500000, 'OrgDevAs', 'E038'),

-- "Promoviendo" a E049 (Carolina Velez) a 'TeamLeadSales' y asignándole gente
('E158', 'David', 'Pachon', 1800000, 'Sales', 'E049'), -- Reporta a Carolina Velez (E049)
('E159', 'Isabel', 'Quesada', 1800000, 'Sales', 'E049'),
-- Actualizar E049
-- UPDATE DIAMOND.EMPLOYEES SET employee_type = 'TeamLead', salary = 3000000 WHERE id_line_item = 'E049';
-- (Este UPDATE lo harías en SQL después de los INSERTS si quieres formalizar la promoción)

-- "Promoviendo" a E052 (Roberto Silva) a 'CoordinatorMKT'
('E160', 'Miguel', 'Ricaurte', 1700000, 'MarketingJr', 'E052'), -- Reporta a Roberto Silva (E052)
('E161', 'Patricia', 'Suescun', 1700000, 'MarketingJr', 'E052'),
-- UPDATE DIAMOND.EMPLOYEES SET employee_type = 'Coordinator', salary = 2800000 WHERE id_line_item = 'E052';

-- Más personal para Subgerentes de Tienda (E039, E040)
('E162', 'Javier', 'Torrado', 1700000, 'Sales', 'E039'),
('E163', 'Elena', 'Umaña', 1600000, 'Cashier', 'E039'),
('E164', 'Andres', 'Villegas', 1700000, 'Sales', 'E040'),
('E165', 'Camila', 'Yepes', 1600000, 'Cashier', 'E040'),

-- Personal bajo Líderes de IT (E043, E044)
('E166', 'Santiago', 'Zabala', 2600000, 'Developer', 'E043'),
('E167', 'Valentina', 'Alarcon', 2500000, 'Developer', 'E043'),
('E168', 'Daniel', 'Becerra', 2400000, 'SysAdmin', 'E044'),
('E169', 'Gabriela', 'Correa', 2300000, 'SysAdmin', 'E044'),

-- Personal bajo Contadores SemiSr (E045, E046 - ahora pueden ser Coordinadores Contables)
-- UPDATE DIAMOND.EMPLOYEES SET employee_type = 'CoordCont', salary = 3500000 WHERE id_line_item = 'E045';
-- UPDATE DIAMOND.EMPLOYEES SET employee_type = 'CoordCont', salary = 3400000 WHERE id_line_item = 'E046';
('E170', 'Ricardo', 'Daza', 2200000, 'AccountantJ', 'E045'),
('E171', 'Paula', 'Escobar', 2200000, 'AccountantJ', 'E045'),
('E172', 'Alejandro', 'Fajardo', 2100000, 'AccountantJ', 'E046'),
('E173', 'Natalia', 'Giraldo', 2100000, 'AccountantJ', 'E046'),

-- Personal bajo Compradores Jr (E047, E048 - ahora pueden ser Compradores Plenos)
-- UPDATE DIAMOND.EMPLOYEES SET employee_type = 'BuyerFull', salary = 3200000 WHERE id_line_item = 'E047';
-- UPDATE DIAMOND.EMPLOYEES SET employee_type = 'BuyerFull', salary = 3100000 WHERE id_line_item = 'E048';
('E174', 'Martin', 'Hoyos', 2000000, 'BuyerAsist', 'E047'),
('E175', 'Lucia', 'Iregui', 2000000, 'BuyerAsist', 'E047'),
('E176', 'Fernando', 'Jimenez', 1900000, 'BuyerAsist', 'E048'),
('E177', 'Veronica', 'Lara', 1900000, 'BuyerAsist', 'E048'),

-- Diversificando asignaciones
('E178', 'Sergio', 'Moncada', 1800000, 'Sales', 'E011'),
('E179', 'Andrea', 'Noguera', 1700000, 'WarehouseOp', 'E015'),
('E180', 'Jorge', 'Ospina', 2000000, 'DeveloperJr', 'E008'); -- Reporta a Gerente IT directamente


INSERT INTO DIAMOND.EMPLOYEES (id_line_item, first_name, last_name, salary, employee_type, id_manager) VALUES
('E181', 'Adriana', 'Pardo', 2500000, 'Sales', 'E039'),
('E182', 'Alberto', 'Quintero', 2400000, 'Cashier', 'E039'),
('E183', 'Monica', 'Roldan', 2500000, 'Sales', 'E040'),
('E184', 'Victor', 'Saenz', 2400000, 'Cashier', 'E040'),
('E185', 'Cristina', 'Tovar', 2000000, 'LogisticsOp', 'E041'),
('E186', 'Raul', 'Urbina', 1900000, 'Driver', 'E042'),
('E187', 'Beatriz', 'Velez', 2800000, 'Developer', 'E043'),
('E188', 'Oscar', 'Yanez', 2700000, 'SysAdmin', 'E044'),

-- Nuevos Coordinadores/Líderes y su personal
-- E109 (Daniela Orozco) de EcomAsist pasa a EcomCoord
-- UPDATE DIAMOND.EMPLOYEES SET employee_type = 'EcomCoord', salary = 2500000 WHERE id_line_item = 'E109';
('E189', 'Silvia', 'Zorrilla', 1700000, 'EcomAsist', 'E109'),
('E190', 'Jose', 'Almanza', 1700000, 'EcomAsist', 'E109'),

-- E110 (Alejandro Palacio) de DesignJr pasa a DesignCoord
-- UPDATE DIAMOND.EMPLOYEES SET employee_type = 'DesignCoord', salary = 2400000 WHERE id_line_item = 'E110';
('E191', 'Rosa', 'Beltran', 1600000, 'DesignJr', 'E110'),
('E192', 'Manuel', 'Cifuentes', 1600000, 'DesignJr', 'E110'),

-- Personal para managers de nivel alto (E006-E010)
('E193', 'Teresa', 'Dorado', 3000000, 'Supervisor', 'E006'), -- Supervisor de Tiendas
('E194', 'Francisco', 'Espejo', 2800000, 'Supervisor', 'E007'), -- Supervisor Logística
('E195', 'Gloria', 'Florez', 2700000, 'Coordinator', 'E008'), -- Coordinador Proyectos IT
('E196', 'Antonio', 'Gaitan', 2600000, 'AnalystSr', 'E009'), -- Analista Contable Sr
('E197', 'Angela', 'Henriquez', 2500000, 'AnalystSr', 'E010'), -- Analista Compras Sr

-- Distribuyendo personal en áreas operativas
('E198', 'Diego', 'Iriarte', 1800000, 'Sales', 'E011'),
('E199', 'Sandra', 'Joya', 1700000, 'Cashier', 'E011'),
('E200', 'Ana', 'Lizarazo', 1600000, 'WarehouseOp', 'E015'),
('E201', 'Luis', 'Macea', 1800000, 'MarketingJr', 'E012'),
('E202', 'Maria', 'Novoa', 1700000, 'HRAsist', 'E013'),
('E203', 'Carlos', 'Pineda', 1600000, 'SupportTech', 'E014'),
('E204', 'Sofia', 'Quijano', 2000000, 'ProdAnalyst', 'E031'),
('E205', 'Juan', 'Ramos', 1900000, 'QualityInsp', 'E032'),
('E206', 'Daniela', 'Saldana', 1800000, 'TreasuryAs', 'E033'),
('E207', 'Alejandro', 'Trujillo', 1700000, 'FinPlanAs', 'E034'),
('E208', 'Gabriela', 'Ulloa', 1600000, 'AdCreative', 'E035'),
('E209', 'Mateo', 'Valderrama', 1500000, 'PRAssist', 'E036'),
('E210', 'Isabella', 'Yepes', 1400000, 'WellnessAs', 'E037'),
('E211', 'Nicolas', 'Zea', 1300000, 'OrgDevAs', 'E038'),
('E212', 'Luciana', 'Arias', 1800000, 'Sales', 'E039'),
('E213', 'Emilio', 'Bustamante', 1700000, 'Cashier', 'E039'),
('E214', 'Julieta', 'Castellanos', 1800000, 'Sales', 'E040'),
('E215', 'Tomas', 'Duran', 1700000, 'Cashier', 'E040'),
('E216', 'Antonia', 'Figueroa', 1600000, 'LogisticsOp', 'E041'),
('E217', 'Felipe', 'Guarin', 1600000, 'Driver', 'E042'),
('E218', 'Martina', 'Holguin', 2200000, 'DeveloperJr', 'E043'),
('E219', 'Joaquin', 'Lasso', 2100000, 'InfraTech', 'E044'),
('E220', 'Sara', 'Manrique', 2000000, 'AccountantJ', 'E045'),
('E221', 'Martin', 'Nieto', 1900000, 'AccountantJ', 'E046'),
('E222', 'Elena', 'Orozco', 1800000, 'PurchasingA', 'E047'),
('E223', 'Simon', 'Pardo', 1800000, 'PurchasingA', 'E048'),
('E224', 'Olivia', 'Quiñones', 1700000, 'Sales', 'E049'), -- Reporta a Carolina (ahora TeamLead)
('E225', 'Maximiliano', 'Rincon', 1600000, 'MarketingJr', 'E052'), -- Reporta a Roberto (ahora Coordinator)
('E226', 'Valeria', 'Salcedo', 1500000, 'HRAsist', 'E020'),
('E227', 'Lucas', 'Tafur', 1400000, 'SupportJr', 'E028'),
('E228', 'Renata', 'Uribe', 1300000, 'StockAssist', 'E029'),
('E229', 'Bruno', 'Vallejo', 1200000, 'AuditorJr', 'E030'), -- Reporta a Auditor Interno
('E230', 'Clara', 'Zapata', 1800000, 'Sales', 'E011');








INSERT INTO DIAMOND.EMPLOYEES (id_line_item, first_name, last_name, salary, employee_type, id_manager) VALUES
('E231', 'Hugo', 'Aguilar', 1700000, 'Cashier', 'E011'),
('E232', 'Eva', 'Baron', 1600000, 'WarehouseOp', 'E015'),
('E233', 'Adrian', 'Celis', 1800000, 'MarketingJr', 'E012'),
('E234', 'Sofia', 'Delgado', 1700000, 'HRAsist', 'E013'),
('E235', 'Javier', 'Estevez', 1600000, 'SupportTech', 'E014'),
('E236', 'Paula', 'Fonseca', 2000000, 'ProdAnalyst', 'E031'),
('E237', 'Ricardo', 'Galeano', 1900000, 'QualityInsp', 'E032'),
('E238', 'Laura', 'Hoyos', 1800000, 'TreasuryAs', 'E033'),
('E239', 'Mateo', 'Ibarra', 1700000, 'FinPlanAs', 'E034'),
('E240', 'Catalina', 'Jaimes', 1600000, 'AdCreative', 'E035'),
('E241', 'Esteban', 'Lara', 1500000, 'PRAssist', 'E036'),
('E242', 'Victoria', 'Mendez', 1400000, 'WellnessAs', 'E037'),
('E243', 'Ignacio', 'Naranjo', 1300000, 'OrgDevAs', 'E038'),
('E244', 'Carolina', 'Ochoa', 1800000, 'Sales', 'E039'),
('E245', 'Andres', 'Paez', 1700000, 'Cashier', 'E039'),
('E246', 'Fernanda', 'Quiroz', 1800000, 'Sales', 'E040'),
('E247', 'Roberto', 'Riascos', 1700000, 'Cashier', 'E040'),
('E248', 'Manuela', 'Sarmiento', 1600000, 'LogisticsOp', 'E041'),
('E249', 'Samuel', 'Tovar', 1600000, 'Driver', 'E042'),
('E250', 'Daniel', 'Urena', 2100000, 'DeveloperJr', 'E043'),
('E251', 'Camila', 'Vargas', 2000000, 'InfraTech', 'E044'),
('E252', 'Luis', 'Yepes', 1900000, 'AccountantJ', 'E045'),
('E253', 'Ana', 'Zamudio', 1800000, 'AccountantJ', 'E046'),
('E254', 'Pedro', 'Alarcon', 1700000, 'PurchasingA', 'E047'),
('E255', 'Carmen', 'Bermudez', 1700000, 'PurchasingA', 'E048'),
('E256', 'David', 'Cabrera', 1600000, 'Sales', 'E049'), -- Reporta a Carolina (TeamLead)
('E257', 'Isabel', 'Duarte', 1500000, 'MarketingJr', 'E052'), -- Reporta a Roberto (Coordinator)
('E258', 'Miguel', 'Florez', 1400000, 'HRAsist', 'E020'),
('E259', 'Patricia', 'Giraldo', 1300000, 'SupportJr', 'E028'),
('E260', 'Javier', 'Hurtado', 1200000, 'StockAssist', 'E029'),
('E261', 'Elena', 'Leon', 1800000, 'Sales', 'E011'),
('E262', 'Andres', 'Manrique', 1700000, 'Cashier', 'E011'),
('E263', 'Camila', 'Norena', 1600000, 'WarehouseOp', 'E015'),
('E264', 'Santiago', 'Ospina', 1800000, 'MarketingJr', 'E012'),
('E265', 'Valentina', 'Pardo', 1700000, 'HRAsist', 'E013'),
('E266', 'Daniel', 'Quiceno', 1600000, 'SupportTech', 'E014'),
('E267', 'Gabriela', 'Ramirez', 2000000, 'ProdAnalyst', 'E031'),
('E268', 'Ricardo', 'Saldarriaga', 1900000, 'QualityInsp', 'E032'),
('E269', 'Paula', 'Tamayo', 1800000, 'TreasuryAs', 'E033'),
('E270', 'Alejandro', 'Useche', 1700000, 'FinPlanAs', 'E034'),
('E271', 'Natalia', 'Varela', 1600000, 'AdCreative', 'E035'),
('E272', 'Martin', 'Yepes', 1500000, 'PRAssist', 'E036'),
('E273', 'Lucia', 'Zamudio', 1400000, 'WellnessAs', 'E037'),
('E274', 'Fernando', 'Aguilar', 1300000, 'OrgDevAs', 'E038'),
('E275', 'Veronica', 'Baron', 1800000, 'Sales', 'E039'),
('E276', 'Sergio', 'Celis', 1700000, 'Cashier', 'E039'),
('E277', 'Andrea', 'Delgado', 1800000, 'Sales', 'E040'),
('E278', 'Jorge', 'Estevez', 1700000, 'Cashier', 'E040'),
('E279', 'Adriana', 'Fonseca', 1600000, 'LogisticsOp', 'E041'),
('E280', 'Alberto', 'Galeano', 1600000, 'Driver', 'E042');


INSERT INTO DIAMOND.EMPLOYEES (id_line_item, first_name, last_name, salary, employee_type, id_manager) VALUES
('E281', 'Monica', 'Hoyos', 2000000, 'DeveloperJr', 'E043'),
('E282', 'Victor', 'Ibarra', 1900000, 'InfraTech', 'E044'),
('E283', 'Cristina', 'Jaimes', 1800000, 'AccountantJ', 'E045'),
('E284', 'Raul', 'Lara', 1700000, 'AccountantJ', 'E046'),
('E285', 'Beatriz', 'Mendez', 1600000, 'PurchasingA', 'E047'),
('E286', 'Oscar', 'Naranjo', 1600000, 'PurchasingA', 'E048'),
('E287', 'Silvia', 'Ochoa', 1500000, 'Sales', 'E049'),
('E288', 'Jose', 'Paez', 1400000, 'MarketingJr', 'E052'),
('E289', 'Rosa', 'Quiroz', 1300000, 'HRAsist', 'E020'),
('E290', 'Manuel', 'Riascos', 1200000, 'SupportJr', 'E028'),
('E291', 'Teresa', 'Sarmiento', 1700000, 'StockAssist', 'E029'), -- Salario ajustado
('E292', 'Francisco', 'Tovar', 1800000, 'Sales', 'E011'),
('E293', 'Gloria', 'Urena', 1700000, 'Cashier', 'E011'),
('E294', 'Antonio', 'Vargas', 1600000, 'WarehouseOp', 'E015'),
('E295', 'Angela', 'Yepes', 1800000, 'MarketingJr', 'E012'),
('E296', 'Diego', 'Zamudio', 1700000, 'HRAsist', 'E013'),
('E297', 'Sandra', 'Alarcon', 1600000, 'SupportTech', 'E014'),
('E298', 'Ana', 'Bermudez', 2000000, 'ProdAnalyst', 'E031'),
('E299', 'Luis', 'Cabrera', 1900000, 'QualityInsp', 'E032'),
('E300', 'Maria', 'Duarte', 1800000, 'TreasuryAs', 'E033'),
('E301', 'Carlos', 'Florez', 1700000, 'FinPlanAs', 'E034'),
('E302', 'Sofia', 'Giraldo', 1600000, 'AdCreative', 'E035'),
('E303', 'Juan', 'Hurtado', 1500000, 'PRAssist', 'E036'),
('E304', 'Daniela', 'Leon', 1400000, 'WellnessAs', 'E037'),
('E305', 'Alejandro', 'Manrique', 1300000, 'OrgDevAs', 'E038'),
('E306', 'Gabriela', 'Norena', 1800000, 'Sales', 'E039'),
('E307', 'Mateo', 'Ospina', 1700000, 'Cashier', 'E039'),
('E308', 'Isabella', 'Pardo', 1800000, 'Sales', 'E040'),
('E309', 'Nicolas', 'Quiceno', 1700000, 'Cashier', 'E040'),
('E310', 'Luciana', 'Ramirez', 1600000, 'LogisticsOp', 'E041'),
('E311', 'Emilio', 'Saldarriaga', 1600000, 'Driver', 'E042'),
('E312', 'Julieta', 'Tamayo', 1900000, 'DeveloperJr', 'E043'),
('E313', 'Tomas', 'Useche', 1800000, 'InfraTech', 'E044'),
('E314', 'Antonia', 'Varela', 1700000, 'AccountantJ', 'E045'),
('E315', 'Felipe', 'Yepes', 1600000, 'AccountantJ', 'E046'),
('E316', 'Martina', 'Zamudio', 1500000, 'PurchasingA', 'E047'),
('E317', 'Joaquin', 'Alarcon', 1500000, 'PurchasingA', 'E048'),
('E318', 'Sara', 'Bermudez', 1400000, 'Sales', 'E049'),
('E319', 'Martin', 'Cabrera', 1300000, 'MarketingJr', 'E052'),
('E320', 'Elena', 'Duarte', 1700000, 'HRAsist', 'E020'),
('E321', 'Simon', 'Florez', 1600000, 'SupportJr', 'E028'),
('E322', 'Olivia', 'Giraldo', 1500000, 'StockAssist', 'E029'),
('E323', 'Maximiliano', 'Hurtado', 1800000, 'Sales', 'E011'),
('E324', 'Valeria', 'Leon', 1700000, 'Cashier', 'E011'),
('E325', 'Lucas', 'Manrique', 1600000, 'WarehouseOp', 'E015'),
('E326', 'Renata', 'Norena', 1800000, 'MarketingJr', 'E012'),
('E327', 'Bruno', 'Ospina', 1700000, 'HRAsist', 'E013'),
('E328', 'Clara', 'Pardo', 1600000, 'SupportTech', 'E014'),
('E329', 'Hugo', 'Quiceno', 2000000, 'ProdAnalyst', 'E031'),
('E330', 'Eva', 'Ramirez', 1900000, 'QualityInsp', 'E032');


INSERT INTO DIAMOND.EMPLOYEES (id_line_item, first_name, last_name, salary, employee_type, id_manager) VALUES
('E331', 'Adrian', 'Saldarriaga', 1800000, 'TreasuryAs', 'E033'),
('E332', 'Sofia', 'Tamayo', 1700000, 'FinPlanAs', 'E034'),
('E333', 'Javier', 'Useche', 1600000, 'AdCreative', 'E035'),
('E334', 'Paula', 'Varela', 1500000, 'PRAssist', 'E036'),
('E335', 'Ricardo', 'Yepes', 1400000, 'WellnessAs', 'E037'),
('E336', 'Laura', 'Zamudio', 1300000, 'OrgDevAs', 'E038'),
('E337', 'Mateo', 'Alarcon', 1800000, 'Sales', 'E039'),
('E338', 'Catalina', 'Bermudez', 1700000, 'Cashier', 'E039'),
('E339', 'Esteban', 'Cabrera', 1800000, 'Sales', 'E040'),
('E340', 'Victoria', 'Duarte', 1700000, 'Cashier', 'E040'),
('E341', 'Ignacio', 'Florez', 1600000, 'LogisticsOp', 'E041'),
('E342', 'Carolina', 'Giraldo', 1600000, 'Driver', 'E042'),
('E343', 'Andres', 'Hurtado', 1800000, 'DeveloperJr', 'E043'),
('E344', 'Fernanda', 'Leon', 1700000, 'InfraTech', 'E044'),
('E345', 'Roberto', 'Manrique', 1600000, 'AccountantJ', 'E045'),
('E346', 'Manuela', 'Norena', 1500000, 'AccountantJ', 'E046'),
('E347', 'Samuel', 'Ospina', 1400000, 'PurchasingA', 'E047'),
('E348', 'Daniel', 'Pardo', 1400000, 'PurchasingA', 'E048'),
('E349', 'Camila', 'Quiceno', 1300000, 'Sales', 'E049'),
('E350', 'Luis', 'Ramirez', 1200000, 'MarketingJr', 'E052'),
('E351', 'Ana', 'Saldarriaga', 1700000, 'HRAsist', 'E020'),
('E352', 'Pedro', 'Tamayo', 1600000, 'SupportJr', 'E028'),
('E353', 'Carmen', 'Useche', 1500000, 'StockAssist', 'E029'),
('E354', 'David', 'Varela', 1800000, 'Sales', 'E011'),
('E355', 'Isabel', 'Yepes', 1700000, 'Cashier', 'E011'),
('E356', 'Miguel', 'Zamudio', 1600000, 'WarehouseOp', 'E015'),
('E357', 'Patricia', 'Alarcon', 1800000, 'MarketingJr', 'E012'),
('E358', 'Javier', 'Bermudez', 1700000, 'HRAsist', 'E013'),
('E359', 'Elena', 'Cabrera', 1600000, 'SupportTech', 'E014'),
('E360', 'Andres', 'Duarte', 2000000, 'ProdAnalyst', 'E031'),
('E361', 'Camila', 'Florez', 1900000, 'QualityInsp', 'E032'),
('E362', 'Santiago', 'Giraldo', 1800000, 'TreasuryAs', 'E033'),
('E363', 'Valentina', 'Hurtado', 1700000, 'FinPlanAs', 'E034'),
('E364', 'Daniel', 'Leon', 1600000, 'AdCreative', 'E035'),
('E365', 'Gabriela', 'Manrique', 1500000, 'PRAssist', 'E036'),
('E366', 'Ricardo', 'Norena', 1400000, 'WellnessAs', 'E037'),
('E367', 'Paula', 'Ospina', 1300000, 'OrgDevAs', 'E038'),
('E368', 'Alejandro', 'Pardo', 1800000, 'Sales', 'E039'),
('E369', 'Natalia', 'Quiceno', 1700000, 'Cashier', 'E039'),
('E370', 'Martin', 'Ramirez', 1800000, 'Sales', 'E040'),
('E371', 'Lucia', 'Saldarriaga', 1700000, 'Cashier', 'E040'),
('E372', 'Fernando', 'Tamayo', 1600000, 'LogisticsOp', 'E041'),
('E373', 'Veronica', 'Useche', 1600000, 'Driver', 'E042'),
('E374', 'Sergio', 'Varela', 1700000, 'DeveloperJr', 'E043'),
('E375', 'Andrea', 'Yepes', 1600000, 'InfraTech', 'E044'),
('E376', 'Jorge', 'Zamudio', 1500000, 'AccountantJ', 'E045'),
('E377', 'Adriana', 'Alarcon', 1400000, 'AccountantJ', 'E046'),
('E378', 'Alberto', 'Bermudez', 1300000, 'PurchasingA', 'E047'),
('E379', 'Monica', 'Cabrera', 1300000, 'PurchasingA', 'E048'),
('E380', 'Victor', 'Duarte', 1200000, 'Sales', 'E049');

INSERT INTO DIAMOND.EMPLOYEES (id_line_item, first_name, last_name, salary, employee_type, id_manager) VALUES
('E381', 'Cristina', 'Florez', 1100000, 'MarketingJr', 'E052'),
('E382', 'Raul', 'Giraldo', 1700000, 'HRAsist', 'E020'),
('E383', 'Beatriz', 'Hurtado', 1600000, 'SupportJr', 'E028'),
('E384', 'Oscar', 'Leon', 1500000, 'StockAssist', 'E029'),
('E385', 'Silvia', 'Manrique', 1800000, 'Sales', 'E011'),
('E386', 'Jose', 'Norena', 1700000, 'Cashier', 'E011'),
('E387', 'Rosa', 'Ospina', 1600000, 'WarehouseOp', 'E015'),
('E388', 'Manuel', 'Pardo', 1800000, 'MarketingJr', 'E012'),
('E389', 'Teresa', 'Quiceno', 1700000, 'HRAsist', 'E013'),
('E390', 'Francisco', 'Ramirez', 1600000, 'SupportTech', 'E014'),
('E391', 'Gloria', 'Saldarriaga', 2000000, 'ProdAnalyst', 'E031'),
('E392', 'Antonio', 'Tamayo', 1900000, 'QualityInsp', 'E032'),
('E393', 'Angela', 'Useche', 1800000, 'TreasuryAs', 'E033'),
('E394', 'Diego', 'Varela', 1700000, 'FinPlanAs', 'E034'),
('E395', 'Sandra', 'Yepes', 1600000, 'AdCreative', 'E035'),
('E396', 'Ana', 'Zamudio', 1500000, 'PRAssist', 'E036'),
('E397', 'Luis', 'Alarcon', 1400000, 'WellnessAs', 'E037'),
('E398', 'Maria', 'Bermudez', 1300000, 'OrgDevAs', 'E038'),
('E399', 'Carlos', 'Cabrera', 1800000, 'Sales', 'E039'),
('E400', 'Sofia', 'Duarte', 1700000, 'Cashier', 'E039'),
('E401', 'Juan', 'Florez', 1800000, 'Sales', 'E040'),
('E402', 'Daniela', 'Giraldo', 1700000, 'Cashier', 'E040'),
('E403', 'Alejandro', 'Hurtado', 1600000, 'LogisticsOp', 'E041'),
('E404', 'Gabriela', 'Leon', 1600000, 'Driver', 'E042'),
('E405', 'Mateo', 'Manrique', 1600000, 'DeveloperJr', 'E043'),
('E406', 'Isabella', 'Norena', 1500000, 'InfraTech', 'E044'),
('E407', 'Nicolas', 'Ospina', 1400000, 'AccountantJ', 'E045'),
('E408', 'Luciana', 'Pardo', 1300000, 'AccountantJ', 'E046'),
('E409', 'Emilio', 'Quiceno', 1200000, 'PurchasingA', 'E047'),
('E410', 'Julieta', 'Ramirez', 1200000, 'PurchasingA', 'E048'),
('E411', 'Tomas', 'Saldarriaga', 1100000, 'Sales', 'E049'),
('E412', 'Antonia', 'Tamayo', 1000000, 'MarketingJr', 'E052'),
('E413', 'Felipe', 'Useche', 1700000, 'HRAsist', 'E020'),
('E414', 'Martina', 'Varela', 1600000, 'SupportJr', 'E028'),
('E415', 'Joaquin', 'Yepes', 1500000, 'StockAssist', 'E029'),
('E416', 'Sara', 'Zamudio', 1800000, 'Sales', 'E011'),
('E417', 'Martin', 'Alarcon', 1700000, 'Cashier', 'E011'),
('E418', 'Elena', 'Bermudez', 1600000, 'WarehouseOp', 'E015'),
('E419', 'Simon', 'Cabrera', 1800000, 'MarketingJr', 'E012'),
('E420', 'Olivia', 'Duarte', 1700000, 'HRAsist', 'E013'),
('E421', 'Maximiliano', 'Florez', 1600000, 'SupportTech', 'E014'),
('E422', 'Valeria', 'Giraldo', 2000000, 'ProdAnalyst', 'E031'),
('E423', 'Lucas', 'Hurtado', 1900000, 'QualityInsp', 'E032'),
('E424', 'Renata', 'Leon', 1800000, 'TreasuryAs', 'E033'),
('E425', 'Bruno', 'Manrique', 1700000, 'FinPlanAs', 'E034'),
('E426', 'Clara', 'Norena', 1600000, 'AdCreative', 'E035'),
('E427', 'Hugo', 'Ospina', 1500000, 'PRAssist', 'E036'),
('E428', 'Eva', 'Pardo', 1400000, 'WellnessAs', 'E037'),
('E429', 'Adrian', 'Quiceno', 1300000, 'OrgDevAs', 'E038'),
('E430', 'Sofia', 'Ramirez', 1800000, 'Sales', 'E039');

INSERT INTO DIAMOND.EMPLOYEES (id_line_item, first_name, last_name, salary, employee_type, id_manager) VALUES
('E431', 'Javier', 'Saldarriaga', 1700000, 'Cashier', 'E039'),
('E432', 'Paula', 'Tamayo', 1800000, 'Sales', 'E040'),
('E433', 'Ricardo', 'Useche', 1700000, 'Cashier', 'E040'),
('E434', 'Laura', 'Varela', 1600000, 'LogisticsOp', 'E041'),
('E435', 'Mateo', 'Yepes', 1600000, 'Driver', 'E042'),
('E436', 'Catalina', 'Zamudio', 1500000, 'DeveloperJr', 'E043'),
('E437', 'Esteban', 'Alarcon', 1400000, 'InfraTech', 'E044'),
('E438', 'Victoria', 'Bermudez', 1300000, 'AccountantJ', 'E045'),
('E439', 'Ignacio', 'Cabrera', 1200000, 'AccountantJ', 'E046'),
('E440', 'Carolina', 'Duarte', 1100000, 'PurchasingA', 'E047'),
('E441', 'Andres', 'Florez', 1100000, 'PurchasingA', 'E048'),
('E442', 'Fernanda', 'Giraldo', 1000000, 'Sales', 'E049'),
('E443', 'Roberto', 'Hurtado', 1000000, 'MarketingJr', 'E052'),
('E444', 'Manuela', 'Leon', 1700000, 'HRAsist', 'E020'),
('E445', 'Samuel', 'Manrique', 1600000, 'SupportJr', 'E028'),
('E446', 'Daniel', 'Norena', 1500000, 'StockAssist', 'E029'),
('E447', 'Camila', 'Ospina', 1800000, 'Sales', 'E011'),
('E448', 'Luis', 'Pardo', 1700000, 'Cashier', 'E011'),
('E449', 'Ana', 'Quiceno', 1600000, 'WarehouseOp', 'E015'),
('E450', 'Pedro', 'Ramirez', 1800000, 'MarketingJr', 'E012'),
('E451', 'Carmen', 'Saldarriaga', 1700000, 'HRAsist', 'E013'),
('E452', 'David', 'Tamayo', 1600000, 'SupportTech', 'E014'),
('E453', 'Isabel', 'Useche', 2000000, 'ProdAnalyst', 'E031'),
('E454', 'Miguel', 'Varela', 1900000, 'QualityInsp', 'E032'),
('E455', 'Patricia', 'Yepes', 1800000, 'TreasuryAs', 'E033'),
('E456', 'Javier', 'Zamudio', 1700000, 'FinPlanAs', 'E034'),
('E457', 'Elena', 'Alarcon', 1600000, 'AdCreative', 'E035'),
('E458', 'Andres', 'Bermudez', 1500000, 'PRAssist', 'E036'),
('E459', 'Camila', 'Cabrera', 1400000, 'WellnessAs', 'E037'),
('E460', 'Santiago', 'Duarte', 1300000, 'OrgDevAs', 'E038'),
('E461', 'Valentina', 'Florez', 1800000, 'Sales', 'E039'),
('E462', 'Daniel', 'Giraldo', 1700000, 'Cashier', 'E039'),
('E463', 'Gabriela', 'Hurtado', 1800000, 'Sales', 'E040'),
('E464', 'Ricardo', 'Leon', 1700000, 'Cashier', 'E040'),
('E465', 'Paula', 'Manrique', 1600000, 'LogisticsOp', 'E041'),
('E466', 'Alejandro', 'Norena', 1600000, 'Driver', 'E042'),
('E467', 'Natalia', 'Ospina', 1400000, 'DeveloperJr', 'E043'),
('E468', 'Martin', 'Pardo', 1300000, 'InfraTech', 'E044'),
('E469', 'Lucia', 'Quiceno', 1200000, 'AccountantJ', 'E045'),
('E470', 'Fernando', 'Ramirez', 1100000, 'AccountantJ', 'E046'),
('E471', 'Veronica', 'Saldarriaga', 1000000, 'PurchasingA', 'E047'),
('E472', 'Sergio', 'Tamayo', 1000000, 'PurchasingA', 'E048'),
('E473', 'Andrea', 'Useche', 1700000, 'Sales', 'E049'),
('E474', 'Jorge', 'Varela', 1600000, 'MarketingJr', 'E052'),
('E475', 'Adriana', 'Yepes', 1500000, 'HRAsist', 'E020'),
('E476', 'Alberto', 'Zamudio', 1400000, 'SupportJr', 'E028'),
('E477', 'Monica', 'Alarcon', 1300000, 'StockAssist', 'E029'),
('E478', 'Victor', 'Bermudez', 1800000, 'Sales', 'E011'),
('E479', 'Cristina', 'Cabrera', 1700000, 'Cashier', 'E011'),
('E480', 'Raul', 'Duarte', 1600000, 'WarehouseOp', 'E015');

INSERT INTO DIAMOND.EMPLOYEES (id_line_item, first_name, last_name, salary, employee_type, id_manager) VALUES
('E481', 'Beatriz', 'Florez', 1800000, 'MarketingJr', 'E012'),
('E482', 'Oscar', 'Giraldo', 1700000, 'HRAsist', 'E013'),
('E483', 'Silvia', 'Hurtado', 1600000, 'SupportTech', 'E014'),
('E484', 'Jose', 'Leon', 2000000, 'ProdAnalyst', 'E031'),
('E485', 'Rosa', 'Manrique', 1900000, 'QualityInsp', 'E032'),
('E486', 'Manuel', 'Norena', 1800000, 'TreasuryAs', 'E033'),
('E487', 'Teresa', 'Ospina', 1700000, 'FinPlanAs', 'E034'),
('E488', 'Francisco', 'Pardo', 1600000, 'AdCreative', 'E035'),
('E489', 'Gloria', 'Quiceno', 1500000, 'PRAssist', 'E036'),
('E490', 'Antonio', 'Ramirez', 1400000, 'WellnessAs', 'E037'),
('E491', 'Angela', 'Saldarriaga', 1300000, 'OrgDevAs', 'E038'),
('E492', 'Diego', 'Tamayo', 1800000, 'Sales', 'E039'),
('E493', 'Sandra', 'Useche', 1700000, 'Cashier', 'E039'),
('E494', 'Ana', 'Varela', 1800000, 'Sales', 'E040'),
('E495', 'Luis', 'Yepes', 1700000, 'Cashier', 'E040'),
('E496', 'Maria', 'Zamudio', 1600000, 'LogisticsOp', 'E041'),
('E497', 'Carlos', 'Alarcon', 1500000, 'EcomAsist', 'E109'), -- Reporta a Daniela (EcomCoord)
('E498', 'Sofia', 'Bermudez', 1400000, 'DesignJr', 'E110'), -- Reporta a Alejandro (DesignCoord)
('E499', 'Juan', 'Cabrera', 1300000, 'LogisticsJr', 'E021'), -- Reporta a Antonia (LogisticsSp)
('E500', 'Daniela', 'Duarte', 1200000, 'NetworkJr', 'E022'); -- Reporta a Felipe (NetworkAdm)




INSERT INTO DIAMOND.EMPLOYEES (id_line_item, first_name, last_name, salary, employee_type, id_manager) VALUES
('E501', 'Alejandro', 'Florez', 1800000, 'Sales', 'E011'), -- Tienda Principal
('E502', 'Gabriela', 'Giraldo', 1700000, 'Cashier', 'E011'),
('E503', 'Mateo', 'Hurtado', 1600000, 'WarehouseOp', 'E015'), -- Bodega Central
('E504', 'Isabella', 'Leon', 1800000, 'MarketingJr', 'E012'),
('E505', 'Nicolas', 'Manrique', 1700000, 'HRAsist', 'E013'),
('E506', 'Luciana', 'Norena', 1600000, 'SupportTech', 'E014'),
('E507', 'Emilio', 'Ospina', 2000000, 'ProdAnalyst', 'E031'),
('E508', 'Julieta', 'Pardo', 1900000, 'QualityInsp', 'E032'),
('E509', 'Tomas', 'Quiceno', 1800000, 'TreasuryAs', 'E033'),
('E510', 'Antonia', 'Ramirez', 1700000, 'FinPlanAs', 'E034'),
('E511', 'Felipe', 'Saldarriaga', 1600000, 'AdCreative', 'E035'),
('E512', 'Martina', 'Tamayo', 1500000, 'PRAssist', 'E036'),
('E513', 'Joaquin', 'Useche', 1400000, 'WellnessAs', 'E037'),
('E514', 'Sara', 'Varela', 1300000, 'OrgDevAs', 'E038'),
('E515', 'Martin', 'Yepes', 1800000, 'Sales', 'E039'), -- Tienda A
('E516', 'Elena', 'Zamudio', 1700000, 'Cashier', 'E039'),
('E517', 'Simon', 'Alarcon', 1800000, 'Sales', 'E040'), -- Tienda B
('E518', 'Olivia', 'Bermudez', 1700000, 'Cashier', 'E040'),
('E519', 'Maximiliano', 'Cabrera', 1600000, 'LogisticsOp', 'E041'),
('E520', 'Valeria', 'Duarte', 1600000, 'Driver', 'E042'),
('E521', 'Lucas', 'Florez', 1400000, 'DeveloperJr', 'E043'),
('E522', 'Renata', 'Giraldo', 1300000, 'InfraTech', 'E044'),
('E523', 'Bruno', 'Hurtado', 1200000, 'AccountantJ', 'E045'),
('E524', 'Clara', 'Leon', 1100000, 'AccountantJ', 'E046'),
('E525', 'Hugo', 'Manrique', 1000000, 'PurchasingA', 'E047'),
('E526', 'Eva', 'Norena', 1000000, 'PurchasingA', 'E048'),
('E527', 'Adrian', 'Ospina', 1700000, 'Sales', 'E049'),
('E528', 'Sofia', 'Pardo', 1600000, 'MarketingJr', 'E052'),
('E529', 'Javier', 'Quiceno', 1500000, 'HRAsist', 'E020'),
('E530', 'Paula', 'Ramirez', 1400000, 'SupportJr', 'E028'),
('E531', 'Ricardo', 'Saldarriaga', 1300000, 'StockAssist', 'E029'),
('E532', 'Laura', 'Tamayo', 1800000, 'Sales', 'E011'),
('E533', 'Mateo', 'Useche', 1700000, 'Cashier', 'E011'),
('E534', 'Catalina', 'Varela', 1600000, 'WarehouseOp', 'E015'),
('E535', 'Esteban', 'Yepes', 1800000, 'MarketingJr', 'E012'),
('E536', 'Victoria', 'Zamudio', 1700000, 'HRAsist', 'E013'),
('E537', 'Ignacio', 'Alarcon', 1600000, 'SupportTech', 'E014'),
('E538', 'Carolina', 'Bermudez', 2000000, 'ProdAnalyst', 'E031'),
('E539', 'Andres', 'Cabrera', 1900000, 'QualityInsp', 'E032'),
('E540', 'Fernanda', 'Duarte', 1800000, 'TreasuryAs', 'E033'),
('E541', 'Roberto', 'Florez', 1700000, 'FinPlanAs', 'E034'),
('E542', 'Manuela', 'Giraldo', 1600000, 'AdCreative', 'E035'),
('E543', 'Samuel', 'Hurtado', 1500000, 'PRAssist', 'E036'),
('E544', 'Daniel', 'Leon', 1400000, 'WellnessAs', 'E037'),
('E545', 'Camila', 'Manrique', 1300000, 'OrgDevAs', 'E038'),
('E546', 'Luis', 'Norena', 1800000, 'Sales', 'E039'),
('E547', 'Ana', 'Ospina', 1700000, 'Cashier', 'E039'),
('E548', 'Pedro', 'Pardo', 1800000, 'Sales', 'E040'),
('E549', 'Carmen', 'Quiceno', 1700000, 'Cashier', 'E040'),
('E550', 'David', 'Ramirez', 1600000, 'LogisticsOp', 'E041');


INSERT INTO DIAMOND.EMPLOYEES (id_line_item, first_name, last_name, salary, employee_type, id_manager) VALUES
('E551', 'Isabel', 'Saldarriaga', 1600000, 'Driver', 'E042'),
('E552', 'Miguel', 'Tamayo', 2200000, 'DeveloperSr', 'E043'), -- Developer Senior
('E553', 'Patricia', 'Useche', 2100000, 'InfraSr', 'E044'), -- Infraestructura Senior
('E554', 'Javier', 'Varela', 2000000, 'AccSenior', 'E045'), -- Contador Senior
('E555', 'Elena', 'Yepes', 1900000, 'AccSenior', 'E046'), -- Contador Senior
('E556', 'Andres', 'Zamudio', 1800000, 'BuyerSr', 'E047'), -- Comprador Senior
('E557', 'Camila', 'Alarcon', 1800000, 'BuyerSr', 'E048'), -- Comprador Senior
('E558', 'Santiago', 'Bermudez', 1700000, 'Sales', 'E049'),
('E559', 'Valentina', 'Cabrera', 1600000, 'MarketingJr', 'E052'),
('E560', 'Daniel', 'Duarte', 1500000, 'HRAsist', 'E020'),
('E561', 'Gabriela', 'Florez', 1400000, 'SupportJr', 'E028'),
('E562', 'Ricardo', 'Giraldo', 1300000, 'StockAssist', 'E029'),
('E563', 'Paula', 'Hurtado', 1800000, 'Sales', 'E011'),
('E564', 'Alejandro', 'Leon', 1700000, 'Cashier', 'E011'),
('E565', 'Natalia', 'Manrique', 1600000, 'WarehouseOp', 'E015'),
('E566', 'Martin', 'Norena', 1800000, 'MarketingJr', 'E012'),
('E567', 'Lucia', 'Ospina', 1700000, 'HRAsist', 'E013'),
('E568', 'Fernando', 'Pardo', 1600000, 'SupportTech', 'E014'),
('E569', 'Veronica', 'Quiceno', 2000000, 'ProdAnalyst', 'E031'),
('E570', 'Sergio', 'Ramirez', 1900000, 'QualityInsp', 'E032'),
('E571', 'Andrea', 'Saldarriaga', 1800000, 'TreasuryAs', 'E033'),
('E572', 'Jorge', 'Tamayo', 1700000, 'FinPlanAs', 'E034'),
('E573', 'Adriana', 'Useche', 1600000, 'AdCreative', 'E035'),
('E574', 'Alberto', 'Varela', 1500000, 'PRAssist', 'E036'),
('E575', 'Monica', 'Yepes', 1400000, 'WellnessAs', 'E037'),
('E576', 'Victor', 'Zamudio', 1300000, 'OrgDevAs', 'E038'),
('E577', 'Cristina', 'Alarcon', 1800000, 'Sales', 'E039'),
('E578', 'Raul', 'Bermudez', 1700000, 'Cashier', 'E039'),
('E579', 'Beatriz', 'Cabrera', 1800000, 'Sales', 'E040'),
('E580', 'Oscar', 'Duarte', 1700000, 'Cashier', 'E040'),
('E581', 'Silvia', 'Florez', 1600000, 'LogisticsOp', 'E041'),
('E582', 'Jose', 'Giraldo', 1600000, 'Driver', 'E042'),
('E583', 'Rosa', 'Hurtado', 2300000, 'DeveloperSr', 'E043'), -- Otro Developer Senior
('E584', 'Manuel', 'Leon', 2200000, 'InfraSr', 'E044'), -- Otro Infra Senior
('E585', 'Teresa', 'Manrique', 2100000, 'AccSenior', 'E009'), -- Otro Contador Senior (reporta a Ger. Contabilidad)
('E586', 'Francisco', 'Norena', 2000000, 'BuyerSr', 'E010'), -- Otro Comprador Senior (reporta a Ger. Compras)
('E587', 'Gloria', 'Ospina', 1700000, 'Sales', 'E049'),
('E588', 'Antonio', 'Pardo', 1600000, 'MarketingJr', 'E052'),
('E589', 'Angela', 'Quiceno', 1500000, 'HRAsist', 'E013'), -- Mas asistentes para Talento Humano
('E590', 'Diego', 'Ramirez', 1400000, 'SupportJr', 'E014'), -- Mas soporte técnico
('E591', 'Sandra', 'Saldarriaga', 1300000, 'StockAssist', 'E015'), -- Mas asistentes de bodega
('E592', 'Ana', 'Tamayo', 1800000, 'Sales', 'E011'),
('E593', 'Luis', 'Useche', 1700000, 'Cashier', 'E011'),
('E594', 'Maria', 'Varela', 1600000, 'WarehouseOp', 'E015'),
('E595', 'Carlos', 'Yepes', 1800000, 'MarketingJr', 'E012'),
('E596', 'Sofia', 'Zamudio', 1700000, 'HRAsist', 'E020'), -- Reportando a HRBP
('E597', 'Juan', 'Alarcon', 1600000, 'SupportTech', 'E028'), -- Reportando a Supervisor Mesa Ayuda
('E598', 'Daniela', 'Bermudez', 1900000, 'ProdAnalyst', 'E031'),
('E599', 'Alejandro', 'Cabrera', 1800000, 'QualityInsp', 'E032'),
('E600', 'Gabriela', 'Duarte', 1700000, 'TreasuryAs', 'E033');


INSERT INTO DIAMOND.EMPLOYEES (id_line_item, first_name, last_name, salary, employee_type, id_manager) VALUES
('E601', 'Mateo', 'Florez', 1600000, 'FinPlanAs', 'E034'),
('E602', 'Isabella', 'Giraldo', 1500000, 'AdCreative', 'E035'),
('E603', 'Nicolas', 'Hurtado', 1400000, 'PRAssist', 'E036'),
('E604', 'Luciana', 'Leon', 1300000, 'WellnessAs', 'E037'),
('E605', 'Emilio', 'Manrique', 1200000, 'OrgDevAs', 'E038'),
('E606', 'Julieta', 'Norena', 1800000, 'Sales', 'E039'),
('E607', 'Tomas', 'Ospina', 1700000, 'Cashier', 'E039'),
('E608', 'Antonia', 'Pardo', 1800000, 'Sales', 'E040'),
('E609', 'Felipe', 'Quiceno', 1700000, 'Cashier', 'E040'),
('E610', 'Martina', 'Ramirez', 1600000, 'LogisticsOp', 'E041'),
('E611', 'Joaquin', 'Saldarriaga', 1600000, 'Driver', 'E042'),
('E612', 'Sara', 'Tamayo', 2400000, 'DeveloperSr', 'E043'),
('E613', 'Martin', 'Useche', 2300000, 'InfraSr', 'E044'),
('E614', 'Elena', 'Varela', 2200000, 'AccSenior', 'E045'),
('E615', 'Simon', 'Yepes', 2100000, 'AccSenior', 'E046'),
('E616', 'Olivia', 'Zamudio', 2000000, 'BuyerSr', 'E047'),
('E617', 'Maximiliano', 'Alarcon', 1900000, 'BuyerSr', 'E048'),
('E618', 'Valeria', 'Bermudez', 1700000, 'Sales', 'E049'),
('E619', 'Lucas', 'Cabrera', 1600000, 'MarketingJr', 'E052'),
('E620', 'Renata', 'Duarte', 1500000, 'HRAsist', 'E013'),
('E621', 'Bruno', 'Florez', 1400000, 'SupportJr', 'E014'),
('E622', 'Clara', 'Giraldo', 1300000, 'StockAssist', 'E015'),
('E623', 'Hugo', 'Hurtado', 1800000, 'Sales', 'E011'),
('E624', 'Eva', 'Leon', 1700000, 'Cashier', 'E011'),
('E625', 'Adrian', 'Manrique', 1600000, 'WarehouseOp', 'E015'),
('E626', 'Sofia', 'Norena', 1800000, 'MarketingJr', 'E012'),
('E627', 'Javier', 'Ospina', 1700000, 'HRAsist', 'E020'),
('E628', 'Paula', 'Pardo', 1600000, 'SupportTech', 'E028'),
('E629', 'Ricardo', 'Quiceno', 2000000, 'ProdAnalyst', 'E031'),
('E630', 'Laura', 'Ramirez', 1900000, 'QualityInsp', 'E032'),
('E631', 'Mateo', 'Saldarriaga', 1800000, 'TreasuryAs', 'E033'),
('E632', 'Catalina', 'Tamayo', 1700000, 'FinPlanAs', 'E034'),
('E633', 'Esteban', 'Useche', 1600000, 'AdCreative', 'E035'),
('E634', 'Victoria', 'Varela', 1500000, 'PRAssist', 'E036'),
('E635', 'Ignacio', 'Yepes', 1400000, 'WellnessAs', 'E037'),
('E636', 'Carolina', 'Zamudio', 1300000, 'OrgDevAs', 'E038'),
('E637', 'Andres', 'Alarcon', 1800000, 'Sales', 'E039'),
('E638', 'Fernanda', 'Bermudez', 1700000, 'Cashier', 'E039'),
('E639', 'Roberto', 'Cabrera', 1800000, 'Sales', 'E040'),
('E640', 'Manuela', 'Duarte', 1700000, 'Cashier', 'E040'),
('E641', 'Samuel', 'Florez', 1600000, 'LogisticsOp', 'E041'),
('E642', 'Daniel', 'Giraldo', 1600000, 'Driver', 'E042'),
('E643', 'Camila', 'Hurtado', 2500000, 'DeveloperSr', 'E043'),
('E644', 'Luis', 'Leon', 2400000, 'InfraSr', 'E044'),
('E645', 'Ana', 'Manrique', 2300000, 'AccSenior', 'E009'),
('E646', 'Pedro', 'Norena', 2200000, 'BuyerSr', 'E010'),
('E647', 'Carmen', 'Ospina', 1700000, 'Sales', 'E025'), -- Reporta a SalesLead
('E648', 'David', 'Pardo', 1600000, 'MarketingJr', 'E026'), -- Reporta a ContentLead
('E649', 'Isabel', 'Quiceno', 1500000, 'HRAsist', 'E027'), -- Reporta a Recruiter Sr
('E650', 'Miguel', 'Ramirez', 1400000, 'SupportJr', 'E014');

INSERT INTO DIAMOND.EMPLOYEES (id_line_item, first_name, last_name, salary, employee_type, id_manager) VALUES
('E651', 'Patricia', 'Saldarriaga', 1300000, 'StockAssist', 'E029'),
('E652', 'Javier', 'Tamayo', 1800000, 'Sales', 'E011'),
('E653', 'Elena', 'Useche', 1700000, 'Cashier', 'E011'),
('E654', 'Andres', 'Varela', 1600000, 'WarehouseOp', 'E015'),
('E655', 'Camila', 'Yepes', 1800000, 'MarketingJr', 'E012'),
('E656', 'Santiago', 'Zamudio', 1700000, 'HRAsist', 'E013'),
('E657', 'Valentina', 'Alarcon', 1600000, 'SupportTech', 'E014'),
('E658', 'Daniel', 'Bermudez', 2000000, 'ProdAnalyst', 'E031'),
('E659', 'Gabriela', 'Cabrera', 1900000, 'QualityInsp', 'E032'),
('E660', 'Ricardo', 'Duarte', 1800000, 'TreasuryAs', 'E033'),
('E661', 'Paula', 'Florez', 1700000, 'FinPlanAs', 'E034'),
('E662', 'Alejandro', 'Giraldo', 1600000, 'AdCreative', 'E035'),
('E663', 'Natalia', 'Hurtado', 1500000, 'PRAssist', 'E036'),
('E664', 'Martin', 'Leon', 1400000, 'WellnessAs', 'E037'),
('E665', 'Lucia', 'Manrique', 1300000, 'OrgDevAs', 'E038'),
('E666', 'Fernando', 'Norena', 1800000, 'Sales', 'E039'),
('E667', 'Veronica', 'Ospina', 1700000, 'Cashier', 'E039'),
('E668', 'Sergio', 'Pardo', 1800000, 'Sales', 'E040'),
('E669', 'Andrea', 'Quiceno', 1700000, 'Cashier', 'E040'),
('E670', 'Jorge', 'Ramirez', 1600000, 'LogisticsOp', 'E041'),
('E671', 'Adriana', 'Saldarriaga', 1600000, 'Driver', 'E042'),
('E672', 'Alberto', 'Tamayo', 2600000, 'DataAnalyst', 'E008'), -- Analista de Datos Sr para Ger IT
('E673', 'Monica', 'Useche', 2500000, 'SecuritySp', 'E008'), -- Especialista Seguridad para Ger IT
('E674', 'Victor', 'Varela', 2400000, 'FinAnalystS', 'E009'), -- Analista Financiero Sr para Ger Cont
('E675', 'Cristina', 'Yepes', 2300000, 'TaxSpecial', 'E009'), -- Especialista Impuestos para Ger Cont
('E676', 'Raul', 'Zamudio', 2200000, 'MarketResSr', 'E004'), -- Investigador Mercado Sr para Dir Mark
('E677', 'Beatriz', 'Alarcon', 2100000, 'BrandSpec', 'E004'), -- Especialista Marca para Dir Mark
('E678', 'Oscar', 'Bermudez', 2000000, 'RecruitLead', 'E005'), -- Líder Reclutamiento para Dir RRHH
('E679', 'Silvia', 'Cabrera', 1900000, 'TrainingSp', 'E005'), -- Especialista Capacitación para Dir RRHH
('E680', 'Jose', 'Duarte', 1800000, 'Sales', 'E049'),
('E681', 'Rosa', 'Florez', 1700000, 'MarketingJr', 'E052'),
('E682', 'Manuel', 'Giraldo', 1600000, 'HRAsist', 'E013'),
('E683', 'Teresa', 'Hurtado', 1500000, 'SupportJr', 'E014'),
('E684', 'Francisco', 'Leon', 1400000, 'StockAssist', 'E015'),
('E685', 'Gloria', 'Manrique', 1800000, 'Sales', 'E011'),
('E686', 'Antonio', 'Norena', 1700000, 'Cashier', 'E011'),
('E687', 'Angela', 'Ospina', 1600000, 'WarehouseOp', 'E015'),
('E688', 'Diego', 'Pardo', 1800000, 'MarketingJr', 'E012'),
('E689', 'Sandra', 'Quiceno', 1700000, 'HRAsist', 'E020'),
('E690', 'Ana', 'Ramirez', 1600000, 'SupportTech', 'E028'),
('E691', 'Luis', 'Saldarriaga', 2000000, 'ProdAnalyst', 'E031'),
('E692', 'Maria', 'Tamayo', 1900000, 'QualityInsp', 'E032'),
('E693', 'Carlos', 'Useche', 1800000, 'TreasuryAs', 'E033'),
('E694', 'Sofia', 'Varela', 1700000, 'FinPlanAs', 'E034'),
('E695', 'Juan', 'Yepes', 1600000, 'AdCreative', 'E035'),
('E696', 'Daniela', 'Zamudio', 1500000, 'PRAssist', 'E036'),
('E697', 'Alejandro', 'Alarcon', 1400000, 'WellnessAs', 'E037'),
('E698', 'Gabriela', 'Bermudez', 1300000, 'OrgDevAs', 'E038'),
('E699', 'Mateo', 'Cabrera', 1800000, 'Sales', 'E039'),
('E700', 'Isabella', 'Duarte', 1700000, 'Cashier', 'E039');


INSERT INTO DIAMOND.EMPLOYEES (id_line_item, first_name, last_name, salary, employee_type, id_manager) VALUES
('E701', 'Nicolas', 'Florez', 1800000, 'Sales', 'E040'),
('E702', 'Luciana', 'Giraldo', 1700000, 'Cashier', 'E040'),
('E703', 'Emilio', 'Hurtado', 1600000, 'LogisticsOp', 'E041'),
('E704', 'Julieta', 'Leon', 1600000, 'Driver', 'E042'),
('E705', 'Tomas', 'Manrique', 2700000, 'DeveloperSr', 'E043'),
('E706', 'Antonia', 'Norena', 2600000, 'InfraSr', 'E044'),
('E707', 'Felipe', 'Ospina', 2500000, 'AccSenior', 'E045'),
('E708', 'Martina', 'Pardo', 2400000, 'AccSenior', 'E046'),
('E709', 'Joaquin', 'Quiceno', 2300000, 'BuyerSr', 'E047'),
('E710', 'Sara', 'Ramirez', 2200000, 'BuyerSr', 'E048'),
('E711', 'Martin', 'Saldarriaga', 1700000, 'Sales', 'E049'),
('E712', 'Elena', 'Tamayo', 1600000, 'MarketingJr', 'E052'),
('E713', 'Simon', 'Useche', 1500000, 'HRAsist', 'E013'),
('E714', 'Olivia', 'Varela', 1400000, 'SupportJr', 'E014'),
('E715', 'Maximiliano', 'Yepes', 1300000, 'StockAssist', 'E015'),
('E716', 'Valeria', 'Zamudio', 1800000, 'Sales', 'E011'),
('E717', 'Lucas', 'Alarcon', 1700000, 'Cashier', 'E011'),
('E718', 'Renata', 'Bermudez', 1600000, 'WarehouseOp', 'E015'),
('E719', 'Bruno', 'Cabrera', 1800000, 'MarketingJr', 'E012'),
('E720', 'Clara', 'Duarte', 1700000, 'HRAsist', 'E020'),
('E721', 'Hugo', 'Florez', 1600000, 'SupportTech', 'E028'),
('E722', 'Eva', 'Giraldo', 2000000, 'ProdAnalyst', 'E031'),
('E723', 'Adrian', 'Hurtado', 1900000, 'QualityInsp', 'E032'),
('E724', 'Sofia', 'Leon', 1800000, 'TreasuryAs', 'E033'),
('E725', 'Javier', 'Manrique', 1700000, 'FinPlanAs', 'E034'),
('E726', 'Paula', 'Norena', 1600000, 'AdCreative', 'E035'),
('E727', 'Ricardo', 'Ospina', 1500000, 'PRAssist', 'E036'),
('E728', 'Laura', 'Pardo', 1400000, 'WellnessAs', 'E037'),
('E729', 'Mateo', 'Quiceno', 1300000, 'OrgDevAs', 'E038'),
('E730', 'Catalina', 'Ramirez', 1800000, 'Sales', 'E039'),
('E731', 'Esteban', 'Saldarriaga', 1700000, 'Cashier', 'E039'),
('E732', 'Victoria', 'Tamayo', 1800000, 'Sales', 'E040'),
('E733', 'Ignacio', 'Useche', 1700000, 'Cashier', 'E040'),
('E734', 'Carolina', 'Varela', 1600000, 'LogisticsOp', 'E041'),
('E735', 'Andres', 'Yepes', 1600000, 'Driver', 'E042'),
('E736', 'Fernanda', 'Zamudio', 2800000, 'DataScientist', 'E008'), -- Científico de Datos para Ger IT
('E737', 'Roberto', 'Alarcon', 2700000, 'CloudArch', 'E008'), -- Arquitecto Cloud para Ger IT
('E738', 'Manuela', 'Bermudez', 2600000, 'AuditLead', 'E003'), -- Líder Auditoría para Dir Fin
('E739', 'Samuel', 'Cabrera', 2500000, 'PayrollLead', 'E005'), -- Líder Nómina para Dir RRHH
('E740', 'Daniel', 'Duarte', 2400000, 'CommsLead', 'E004'), -- Líder Comunicaciones para Dir Mark
('E741', 'Camila', 'Florez', 1700000, 'Sales', 'E049'),
('E742', 'Luis', 'Giraldo', 1600000, 'MarketingJr', 'E052'),
('E743', 'Ana', 'Hurtado', 1500000, 'HRAsist', 'E013'),
('E744', 'Pedro', 'Leon', 1400000, 'SupportJr', 'E014'),
('E745', 'Carmen', 'Manrique', 1300000, 'StockAssist', 'E015'),
('E746', 'David', 'Norena', 1800000, 'Sales', 'E011'),
('E747', 'Isabel', 'Ospina', 1700000, 'Cashier', 'E011'),
('E748', 'Miguel', 'Pardo', 1600000, 'WarehouseOp', 'E015'),
('E749', 'Patricia', 'Quiceno', 1800000, 'MarketingJr', 'E012'),
('E750', 'Javier', 'Ramirez', 1700000, 'HRAsist', 'E020');


INSERT INTO DIAMOND.EMPLOYEES (id_line_item, first_name, last_name, salary, employee_type, id_manager) VALUES
('E751', 'Elena', 'Saldarriaga', 1600000, 'SupportTech', 'E028'),
('E752', 'Andres', 'Tamayo', 2000000, 'ProdAnalyst', 'E031'),
('E753', 'Camila', 'Useche', 1900000, 'QualityInsp', 'E032'),
('E754', 'Santiago', 'Varela', 1800000, 'TreasuryAs', 'E033'),
('E755', 'Valentina', 'Yepes', 1700000, 'FinPlanAs', 'E034'),
('E756', 'Daniel', 'Zamudio', 1600000, 'AdCreative', 'E035'),
('E757', 'Gabriela', 'Alarcon', 1500000, 'PRAssist', 'E036'),
('E758', 'Ricardo', 'Bermudez', 1400000, 'WellnessAs', 'E037'),
('E759', 'Paula', 'Cabrera', 1300000, 'OrgDevAs', 'E038'),
('E760', 'Alejandro', 'Duarte', 1800000, 'Sales', 'E039'),
('E761', 'Natalia', 'Florez', 1700000, 'Cashier', 'E039'),
('E762', 'Martin', 'Giraldo', 1800000, 'Sales', 'E040'),
('E763', 'Lucia', 'Hurtado', 1700000, 'Cashier', 'E040'),
('E764', 'Fernando', 'Leon', 1600000, 'LogisticsOp', 'E041'),
('E765', 'Veronica', 'Manrique', 1600000, 'Driver', 'E042'),
('E766', 'Sergio', 'Norena', 2900000, 'UXDesignerSr', 'E008'), -- Diseñador UX/UI Senior
('E767', 'Andrea', 'Ospina', 2800000, 'DevOpsEng', 'E008'), -- Ingeniero DevOps
('E768', 'Jorge', 'Pardo', 2700000, 'InternalCtrl', 'E003'), -- Control Interno para Dir Fin
('E769', 'Adriana', 'Quiceno', 2600000, 'CompBenLead', 'E005'), -- Líder Compensación y Ben. Dir RRHH
('E770', 'Alberto', 'Ramirez', 2500000, 'PRLead', 'E004'), -- Líder Relaciones Públicas Dir Mark
('E771', 'Monica', 'Saldarriaga', 1700000, 'Sales', 'E025'),
('E772', 'Victor', 'Tamayo', 1600000, 'MarketingJr', 'E026'),
('E773', 'Cristina', 'Useche', 1500000, 'HRAsist', 'E027'),
('E774', 'Raul', 'Varela', 1400000, 'SupportJr', 'E014'),
('E775', 'Beatriz', 'Yepes', 1300000, 'StockAssist', 'E029'),
('E776', 'Oscar', 'Zamudio', 1800000, 'Sales', 'E011'),
('E777', 'Silvia', 'Alarcon', 1700000, 'Cashier', 'E011'),
('E778', 'Jose', 'Bermudez', 1600000, 'WarehouseOp', 'E015'),
('E779', 'Rosa', 'Cabrera', 1800000, 'MarketingJr', 'E012'),
('E780', 'Manuel', 'Duarte', 1700000, 'HRAsist', 'E020'),
('E781', 'Teresa', 'Florez', 1600000, 'SupportTech', 'E028'),
('E782', 'Francisco', 'Giraldo', 2000000, 'ProdAnalyst', 'E031'),
('E783', 'Gloria', 'Hurtado', 1900000, 'QualityInsp', 'E032'),
('E784', 'Antonio', 'Leon', 1800000, 'TreasuryAs', 'E033'),
('E785', 'Angela', 'Manrique', 1700000, 'FinPlanAs', 'E034'),
('E786', 'Diego', 'Norena', 1600000, 'AdCreative', 'E035'),
('E787', 'Sandra', 'Ospina', 1500000, 'PRAssist', 'E036'),
('E788', 'Ana', 'Pardo', 1400000, 'WellnessAs', 'E037'),
('E789', 'Luis', 'Quiceno', 1300000, 'OrgDevAs', 'E038'),
('E790', 'Maria', 'Ramirez', 1800000, 'Sales', 'E039'),
('E791', 'Carlos', 'Saldarriaga', 1700000, 'Cashier', 'E039'),
('E792', 'Sofia', 'Tamayo', 1800000, 'Sales', 'E040'),
('E793', 'Juan', 'Useche', 1700000, 'Cashier', 'E040'),
('E794', 'Daniela', 'Varela', 1600000, 'LogisticsOp', 'E041'),
('E795', 'Alejandro', 'Yepes', 1600000, 'Driver', 'E042'),
('E796', 'Gabriela', 'Zamudio', 3000000, 'ProductOwner', 'E004'), -- Dueño de Producto para Dir Mark
('E797', 'Mateo', 'Alarcon', 2900000, 'ProjectMgr', 'E002'), -- Gerente de Proyectos para Dir Op
('E798', 'Isabella', 'Bermudez', 2800000, 'RiskAnalyst', 'E003'), -- Analista de Riesgos para Dir Fin
('E799', 'Nicolas', 'Cabrera', 2700000, 'CorpCommsSp', 'E004'), -- Especialista Com. Corp. Dir Mark
('E800', 'Luciana', 'Duarte', 2600000, 'LegalCounsel', 'E001'); -- Asesor Legal para CEO

INSERT INTO DIAMOND.EMPLOYEES (id_line_item, first_name, last_name, salary, employee_type, id_manager) VALUES
('E801', 'Emilio', 'Florez', 1700000, 'Sales', 'E049'),
('E802', 'Julieta', 'Giraldo', 1600000, 'MarketingJr', 'E052'),
('E803', 'Tomas', 'Hurtado', 1500000, 'HRAsist', 'E013'),
('E804', 'Antonia', 'Leon', 1400000, 'SupportJr', 'E014'),
('E805', 'Felipe', 'Manrique', 1300000, 'StockAssist', 'E015'),
('E806', 'Martina', 'Norena', 1800000, 'Sales', 'E011'),
('E807', 'Joaquin', 'Ospina', 1700000, 'Cashier', 'E011'),
('E808', 'Sara', 'Pardo', 1600000, 'WarehouseOp', 'E015'),
('E809', 'Martin', 'Quiceno', 1800000, 'MarketingJr', 'E012'),
('E810', 'Elena', 'Ramirez', 1700000, 'HRAsist', 'E020'),
('E811', 'Simon', 'Saldarriaga', 1600000, 'SupportTech', 'E028'),
('E812', 'Olivia', 'Tamayo', 2000000, 'ProdAnalyst', 'E031'),
('E813', 'Maximiliano', 'Useche', 1900000, 'QualityInsp', 'E032'),
('E814', 'Valeria', 'Varela', 1800000, 'TreasuryAs', 'E033'),
('E815', 'Lucas', 'Yepes', 1700000, 'FinPlanAs', 'E034'),
('E816', 'Renata', 'Zamudio', 1600000, 'AdCreative', 'E035'),
('E817', 'Bruno', 'Alarcon', 1500000, 'PRAssist', 'E036'),
('E818', 'Clara', 'Bermudez', 1400000, 'WellnessAs', 'E037'),
('E819', 'Hugo', 'Cabrera', 1300000, 'OrgDevAs', 'E038'),
('E820', 'Eva', 'Duarte', 1800000, 'Sales', 'E039'),
('E821', 'Adrian', 'Florez', 1700000, 'Cashier', 'E039'),
('E822', 'Sofia', 'Giraldo', 1800000, 'Sales', 'E040'),
('E823', 'Javier', 'Hurtado', 1700000, 'Cashier', 'E040'),
('E824', 'Paula', 'Leon', 1600000, 'LogisticsOp', 'E041'),
('E825', 'Ricardo', 'Manrique', 1600000, 'Driver', 'E042'),
('E826', 'Laura', 'Norena', 2800000, 'DataEng', 'E008'), -- Ingeniero de Datos
('E827', 'Mateo', 'Ospina', 2700000, 'CyberSecAn', 'E008'), -- Analista Ciberseguridad
('E828', 'Catalina', 'Pardo', 2600000, 'ComplianceOf', 'E003'), -- Oficial Cumplimiento
('E829', 'Esteban', 'Quiceno', 2500000, 'ERPSpec', 'E003'), -- Especialista ERP
('E830', 'Victoria', 'Ramirez', 2400000, 'CustomerExp', 'E004'), -- Jefe Exp. Cliente
('E831', 'Ignacio', 'Saldarriaga', 1700000, 'Sales', 'E025'),
('E832', 'Carolina', 'Tamayo', 1600000, 'MarketingJr', 'E026'),
('E833', 'Andres', 'Useche', 1500000, 'HRAsist', 'E027'),
('E834', 'Fernanda', 'Varela', 1400000, 'SupportJr', 'E014'),
('E835', 'Roberto', 'Yepes', 1300000, 'StockAssist', 'E029'),
('E836', 'Manuela', 'Zamudio', 1800000, 'Sales', 'E011'),
('E837', 'Samuel', 'Alarcon', 1700000, 'Cashier', 'E011'),
('E838', 'Daniel', 'Bermudez', 1600000, 'WarehouseOp', 'E015'),
('E839', 'Camila', 'Cabrera', 1800000, 'MarketingJr', 'E012'),
('E840', 'Luis', 'Duarte', 1700000, 'HRAsist', 'E020'),
('E841', 'Ana', 'Florez', 1600000, 'SupportTech', 'E028'),
('E842', 'Pedro', 'Giraldo', 2000000, 'ProdAnalyst', 'E031'),
('E843', 'Carmen', 'Hurtado', 1900000, 'QualityInsp', 'E032'),
('E844', 'David', 'Leon', 1800000, 'TreasuryAs', 'E033'),
('E845', 'Isabel', 'Manrique', 1700000, 'FinPlanAs', 'E034'),
('E846', 'Miguel', 'Norena', 1600000, 'AdCreative', 'E035'),
('E847', 'Patricia', 'Ospina', 1500000, 'PRAssist', 'E036'),
('E848', 'Javier', 'Pardo', 1400000, 'WellnessAs', 'E037'),
('E849', 'Elena', 'Quiceno', 1300000, 'OrgDevAs', 'E038'),
('E850', 'Andres', 'Ramirez', 1800000, 'Sales', 'E039');



INSERT INTO DIAMOND.EMPLOYEES (id_line_item, first_name, last_name, salary, employee_type, id_manager) VALUES
('E851', 'Camila', 'Saldarriaga', 1700000, 'Cashier', 'E039'),
('E852', 'Santiago', 'Tamayo', 1800000, 'Sales', 'E040'),
('E853', 'Valentina', 'Useche', 1700000, 'Cashier', 'E040'),
('E854', 'Daniel', 'Varela', 1600000, 'LogisticsOp', 'E041'),
('E855', 'Gabriela', 'Yepes', 1600000, 'Driver', 'E042'),
('E856', 'Ricardo', 'Zamudio', 3000000, 'TechLead', 'E043'), -- Líder Técnico para el DevLead
('E857', 'Paula', 'Alarcon', 2900000, 'SrSysAdmin', 'E044'), -- Admin Sistemas Sr. para InfraLead
('E858', 'Alejandro', 'Bermudez', 2800000, 'SrAccount', 'E045'), -- Contador Sr. para CoordCont
('E859', 'Natalia', 'Cabrera', 2700000, 'SrAccount', 'E046'), -- Contador Sr. para CoordCont
('E860', 'Martin', 'Duarte', 2600000, 'SrBuyer', 'E047'), -- Comprador Sr. para BuyerFull
('E861', 'Lucia', 'Florez', 2500000, 'SrBuyer', 'E048'), -- Comprador Sr. para BuyerFull
('E862', 'Fernando', 'Giraldo', 1700000, 'Sales', 'E049'),
('E863', 'Veronica', 'Hurtado', 1600000, 'MarketingJr', 'E052'),
('E864', 'Sergio', 'Leon', 1500000, 'HRAsist', 'E013'),
('E865', 'Andrea', 'Manrique', 1400000, 'SupportJr', 'E014'),
('E866', 'Jorge', 'Norena', 1300000, 'StockAssist', 'E015'),
('E867', 'Adriana', 'Ospina', 1800000, 'Sales', 'E011'),
('E868', 'Alberto', 'Pardo', 1700000, 'Cashier', 'E011'),
('E869', 'Monica', 'Quiceno', 1600000, 'WarehouseOp', 'E015'),
('E870', 'Victor', 'Ramirez', 1800000, 'MarketingJr', 'E012'),
('E871', 'Cristina', 'Saldarriaga', 1700000, 'HRAsist', 'E020'),
('E872', 'Raul', 'Tamayo', 1600000, 'SupportTech', 'E028'),
('E873', 'Beatriz', 'Useche', 2000000, 'ProdAnalyst', 'E031'),
('E874', 'Oscar', 'Varela', 1900000, 'QualityInsp', 'E032'),
('E875', 'Silvia', 'Yepes', 1800000, 'TreasuryAs', 'E033'),
('E876', 'Jose', 'Zamudio', 1700000, 'FinPlanAs', 'E034'),
('E877', 'Rosa', 'Alarcon', 1600000, 'AdCreative', 'E035'),
('E878', 'Manuel', 'Bermudez', 1500000, 'PRAssist', 'E036'),
('E879', 'Teresa', 'Cabrera', 1400000, 'WellnessAs', 'E037'),
('E880', 'Francisco', 'Duarte', 1300000, 'OrgDevAs', 'E038'),
('E881', 'Gloria', 'Florez', 1800000, 'Sales', 'E039'),
('E882', 'Antonio', 'Giraldo', 1700000, 'Cashier', 'E039'),
('E883', 'Angela', 'Hurtado', 1800000, 'Sales', 'E040'),
('E884', 'Diego', 'Leon', 1700000, 'Cashier', 'E040'),
('E885', 'Sandra', 'Manrique', 1600000, 'LogisticsOp', 'E041'),
('E886', 'Ana', 'Norena', 1600000, 'Driver', 'E042'),
('E887', 'Luis', 'Ospina', 3200000, 'LeadSalesReg', 'E006'), -- Líder Ventas Regional para Ger Gral Tiendas
('E888', 'Maria', 'Pardo', 3100000, 'LeadLogReg', 'E007'), -- Líder Logística Regional para Ger Logística
('E889', 'Carlos', 'Quiceno', 3000000, 'ITSecLead', 'E008'), -- Líder Seguridad IT para Ger IT
('E890', 'Sofia', 'Ramirez', 2900000, 'TreasuryLead', 'E009'), -- Líder Tesorería para Ger Contabilidad
('E891', 'Juan', 'Saldarriaga', 2800000, 'CategoryLead', 'E010'), -- Líder Categoría para Ger Compras
('E892', 'Daniela', 'Tamayo', 1700000, 'Sales', 'E049'),
('E893', 'Alejandro', 'Useche', 1600000, 'MarketingJr', 'E052'),
('E894', 'Gabriela', 'Varela', 1500000, 'HRAsist', 'E013'),
('E895', 'Mateo', 'Yepes', 1400000, 'SupportJr', 'E014'),
('E896', 'Isabella', 'Zamudio', 1300000, 'StockAssist', 'E015'),
('E897', 'Nicolas', 'Alarcon', 1800000, 'Sales', 'E011'),
('E898', 'Luciana', 'Bermudez', 1700000, 'Cashier', 'E011'),
('E899', 'Emilio', 'Cabrera', 1600000, 'WarehouseOp', 'E015'),
('E900', 'Julieta', 'Duarte', 1800000, 'MarketingJr', 'E012');


INSERT INTO DIAMOND.EMPLOYEES (id_line_item, first_name, last_name, salary, employee_type, id_manager) VALUES
('E901', 'Tomas', 'Florez', 1700000, 'HRAsist', 'E020'),
('E902', 'Antonia', 'Giraldo', 1600000, 'SupportTech', 'E028'),
('E903', 'Felipe', 'Hurtado', 2000000, 'ProdAnalyst', 'E031'),
('E904', 'Martina', 'Leon', 1900000, 'QualityInsp', 'E032'),
('E905', 'Joaquin', 'Manrique', 1800000, 'TreasuryAs', 'E033'),
('E906', 'Sara', 'Norena', 1700000, 'FinPlanAs', 'E034'),
('E907', 'Martin', 'Ospina', 1600000, 'AdCreative', 'E035'),
('E908', 'Elena', 'Pardo', 1500000, 'PRAssist', 'E036'),
('E909', 'Simon', 'Quiceno', 1400000, 'WellnessAs', 'E037'),
('E910', 'Olivia', 'Ramirez', 1300000, 'OrgDevAs', 'E038'),
('E911', 'Maximiliano', 'Saldarriaga', 1800000, 'Sales', 'E039'),
('E912', 'Valeria', 'Tamayo', 1700000, 'Cashier', 'E039'),
('E913', 'Lucas', 'Useche', 1800000, 'Sales', 'E040'),
('E914', 'Renata', 'Varela', 1700000, 'Cashier', 'E040'),
('E915', 'Bruno', 'Yepes', 1600000, 'LogisticsOp', 'E041'),
('E916', 'Clara', 'Zamudio', 1600000, 'Driver', 'E042'),
('E917', 'Hugo', 'Alarcon', 2700000, 'SolutionArch', 'E827'), -- Arquitecto Soluciones reporta a CyberSecAn
('E918', 'Eva', 'Bermudez', 2600000, 'DBAdminSr', 'E827'), -- DBA Senior reporta a CyberSecAn
('E919', 'Adrian', 'Cabrera', 2500000, 'ProcessEng', 'E797'), -- Ing. Procesos reporta a ProjectMgr Op.
('E920', 'Sofia', 'Duarte', 2400000, 'AutomationSp', 'E797'), -- Esp. Automatización reporta a ProjectMgr Op.
('E921', 'Javier', 'Florez', 1700000, 'Sales', 'E049'),
('E922', 'Paula', 'Giraldo', 1600000, 'MarketingJr', 'E052'),
('E923', 'Ricardo', 'Hurtado', 1500000, 'HRAsist', 'E013'),
('E924', 'Laura', 'Leon', 1400000, 'SupportJr', 'E014'),
('E925', 'Mateo', 'Manrique', 1300000, 'StockAssist', 'E015'),
('E926', 'Catalina', 'Norena', 1800000, 'Sales', 'E011'),
('E927', 'Esteban', 'Ospina', 1700000, 'Cashier', 'E011'),
('E928', 'Victoria', 'Pardo', 1600000, 'WarehouseOp', 'E015'),
('E929', 'Ignacio', 'Quiceno', 1800000, 'MarketingJr', 'E012'),
('E930', 'Carolina', 'Ramirez', 1700000, 'HRAsist', 'E020'),
('E931', 'Andres', 'Saldarriaga', 1600000, 'SupportTech', 'E028'),
('E932', 'Fernanda', 'Tamayo', 2000000, 'ProdAnalyst', 'E031'),
('E933', 'Roberto', 'Useche', 1900000, 'QualityInsp', 'E032'),
('E934', 'Manuela', 'Varela', 1800000, 'TreasuryAs', 'E033'),
('E935', 'Samuel', 'Yepes', 1700000, 'FinPlanAs', 'E034'),
('E936', 'Daniel', 'Zamudio', 1600000, 'AdCreative', 'E035'),
('E937', 'Camila', 'Alarcon', 1500000, 'PRAssist', 'E036'),
('E938', 'Luis', 'Bermudez', 1400000, 'WellnessAs', 'E037'),
('E939', 'Ana', 'Cabrera', 1300000, 'OrgDevAs', 'E038'),
('E940', 'Pedro', 'Duarte', 1800000, 'Sales', 'E039'),
('E941', 'Carmen', 'Florez', 1700000, 'Cashier', 'E039'),
('E942', 'David', 'Giraldo', 1800000, 'Sales', 'E040'),
('E943', 'Isabel', 'Hurtado', 1700000, 'Cashier', 'E040'),
('E944', 'Miguel', 'Leon', 1600000, 'LogisticsOp', 'E041'),
('E945', 'Patricia', 'Manrique', 1600000, 'Driver', 'E042'),
('E946', 'Javier', 'Norena', 2800000, 'VisualMerchLd', 'E006'), -- Líder Visual Merch. para Ger Gral Tiendas
('E947', 'Elena', 'Ospina', 2700000, 'InventoryMgr', 'E007'), -- Gerente Inventarios para Ger Logística
('E948', 'Andres', 'Pardo', 2600000, 'NetworkArch', 'E008'), -- Arquitecto Redes para Ger IT
('E949', 'Camila', 'Quiceno', 2500000, 'FinancialCtrl', 'E009'), -- Controlador Financiero para Ger Cont.
('E950', 'Santiago', 'Ramirez', 2400000, 'SourcingLead', 'E010'); -- Líder Abastecimiento para Ger Compras

INSERT INTO DIAMOND.EMPLOYEES (id_line_item, first_name, last_name, salary, employee_type, id_manager) VALUES
('E951', 'Valentina', 'Saldarriaga', 1700000, 'Sales', 'E049'),
('E952', 'Daniel', 'Tamayo', 1600000, 'MarketingJr', 'E052'),
('E953', 'Gabriela', 'Useche', 1500000, 'HRAsist', 'E013'),
('E954', 'Ricardo', 'Varela', 1400000, 'SupportJr', 'E014'),
('E955', 'Paula', 'Yepes', 1300000, 'StockAssist', 'E015'),
('E956', 'Alejandro', 'Zamudio', 1800000, 'Sales', 'E011'),
('E957', 'Natalia', 'Alarcon', 1700000, 'Cashier', 'E011'),
('E958', 'Martin', 'Bermudez', 1600000, 'WarehouseOp', 'E015'),
('E959', 'Lucia', 'Cabrera', 1800000, 'MarketingJr', 'E012'),
('E960', 'Fernando', 'Duarte', 1700000, 'HRAsist', 'E020'),
('E961', 'Veronica', 'Florez', 1600000, 'SupportTech', 'E028'),
('E962', 'Sergio', 'Giraldo', 2000000, 'ProdAnalyst', 'E031'),
('E963', 'Andrea', 'Hurtado', 1900000, 'QualityInsp', 'E032'),
('E964', 'Jorge', 'Leon', 1800000, 'TreasuryAs', 'E033'),
('E965', 'Adriana', 'Manrique', 1700000, 'FinPlanAs', 'E034'),
('E966', 'Alberto', 'Norena', 1600000, 'AdCreative', 'E035'),
('E967', 'Monica', 'Ospina', 1500000, 'PRAssist', 'E036'),
('E968', 'Victor', 'Pardo', 1400000, 'WellnessAs', 'E037'),
('E969', 'Cristina', 'Quiceno', 1300000, 'OrgDevAs', 'E038'),
('E970', 'Raul', 'Ramirez', 1800000, 'Sales', 'E039'),
('E971', 'Beatriz', 'Saldarriaga', 1700000, 'Cashier', 'E039'),
('E972', 'Oscar', 'Tamayo', 1800000, 'Sales', 'E040'),
('E973', 'Silvia', 'Useche', 1700000, 'Cashier', 'E040'),
('E974', 'Jose', 'Varela', 1600000, 'LogisticsOp', 'E041'),
('E975', 'Rosa', 'Yepes', 1600000, 'Driver', 'E042'),
('E976', 'Manuel', 'Zamudio', 3200000, 'StoreMgrB', 'E006'), -- Gerente Tienda B (reporta a Ger Gral Tiendas)
('E977', 'Teresa', 'Alarcon', 3100000, 'StoreMgrC', 'E006'), -- Gerente Tienda C
('E978', 'Francisco', 'Bermudez', 3000000, 'LogisticsCoord', 'E007'), -- Coordinador Logística Nacional
('E979', 'Gloria', 'Cabrera', 2900000, 'ITSupportLead', 'E008'), -- Líder Soporte IT
('E980', 'Antonio', 'Duarte', 2800000, 'AccountPayLead', 'E009'), -- Líder Cuentas por Pagar
('E981', 'Angela', 'Florez', 2700000, 'SupplierRelLead', 'E010'), -- Líder Relaciones Proveedores
('E982', 'Diego', 'Giraldo', 1700000, 'Sales', 'E976'), -- Vendedor Tienda B
('E983', 'Sandra', 'Hurtado', 1700000, 'Sales', 'E977'), -- Vendedor Tienda C
('E984', 'Ana', 'Leon', 1600000, 'LogisticsAsist', 'E978'), -- Asistente Logística Nacional
('E985', 'Luis', 'Manrique', 1500000, 'ITSupportJr', 'E979'), -- Soporte IT Jr
('E986', 'Maria', 'Norena', 1400000, 'AccountPayAs', 'E980'), -- Asistente Cuentas por Pagar
('E987', 'Carlos', 'Ospina', 1300000, 'SupplierRelAs', 'E981'), -- Asistente Rel. Proveedores
('E988', 'Sofia', 'Pardo', 1800000, 'Sales', 'E011'),
('E989', 'Juan', 'Quiceno', 1700000, 'Cashier', 'E011'),
('E990', 'Daniela', 'Ramirez', 1600000, 'WarehouseOp', 'E015'),
('E991', 'Alejandro', 'Saldarriaga', 1800000, 'MarketingJr', 'E012'),
('E992', 'Gabriela', 'Tamayo', 1700000, 'HRAsist', 'E013'),
('E993', 'Mateo', 'Useche', 1600000, 'SupportTech', 'E014'),
('E994', 'Isabella', 'Varela', 2000000, 'ProdAnalyst', 'E031'),
('E995', 'Nicolas', 'Yepes', 1900000, 'QualityInsp', 'E032'),
('E996', 'Luciana', 'Zamudio', 1800000, 'TreasuryAs', 'E033'),
('E997', 'Emilio', 'Alarcon', 1700000, 'FinPlanAs', 'E034'),
('E998', 'Julieta', 'Bermudez', 1600000, 'AdCreative', 'E035'),
('E999', 'Tomas', 'Cabrera', 1500000, 'PRAssist', 'E036'),
('E000', 'Antonia', 'Duarte', 1400000, 'WellnessAs', 'E037');
