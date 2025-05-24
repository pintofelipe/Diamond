select * from diamond.details_invoice_sales;
select * from diamond.invoice_sales;

INSERT INTO DIAMOND.DETAILS_INVOICE_SALES (id_details_invoice_sale, quantity, unit_price, discount, subtotal, id_invoice_sale, id_product) VALUES
-- Para I001 (Cliente C001, Producto P001 - Elysian Bloom EDP 50ml, Precio 280000, Promo P008)
('D001', 1, 280000, 56000, 0, 'I001', 'P001'), -- Descuento del 20% (ejemplo para promo P008)
-- Para I002 (Cliente C015, Producto P002 - Noir Absolu Extrait 30ml, Precio 550000, Sin Promo)
('D002', 1, 550000, 0, 0, 'I002', 'P002'),
-- Para I003 (Cliente C030, Producto P003 - Aqua Breeze EDT 100ml, Precio 190000, Promo P024)
('D003', 2, 190000, 38000, 0, 'I003', 'P003'), -- 2 unidades, 10% descuento total (ejemplo)
-- Para I004 (Cliente C055, Producto P004 - Velvet Rose Body Lotion, Precio 95000, Sin Promo)
('D004', 1, 95000, 0, 0, 'I004', 'P004'),
-- Para P005 (en INVOICE_SALES) que era I005 (Cliente C077, Producto P005 - Gentleman's Reserve, Precio 150000, Promo P018)
('D005', 1, 150000, 15000, 0, 'P005', 'P005'), -- 10% descuento
('D006', 1, 120000, 0, 0, 'I006', 'P006'), -- P006 Mystic Amber Candle
('D007', 3, 70000, 21000, 0, 'I007', 'P007'), -- P007 Sparkling Citrus Shower Gel, 10% desc
('D008', 1, 350000, 70000, 0, 'I008', 'P008'), -- P008 Dream Weaver Gift Set, 20% desc (San Valentín)
('D009', 1, 320000, 0, 0, 'I009', 'P009'), -- P009 Orion's Belt EDP
('D010', 2, 210000, 42000, 0, 'I010', 'P010'), -- P010 Solstice Kiss EDT, 10% desc
('D011', 1, 160000, 16000, 0, 'I011', 'P011'), -- P011 Crystal Dew Diffuser, 10% desc (promo envío gratis)
('D012', 1, 480000, 0, 0, 'I012', 'P012'), -- P012 Silken Musk Extrait
('D013', 1, 110000, 22000, 0, 'I013', 'P013'), -- P013 Lunar Glow Body Cream, 20% desc (Día Mujer)
('D014', 1, 175000, 29750, 0, 'I014', 'P014'), -- P014 Stellar Dust EDC, 17% desc (St Patrick)
('D015', 2, 295000, 59000, 0, 'I015', 'P015'), -- P015 Nebula Nights EDP, 10% desc (Bienvenida Primavera)
('D016', 1, 340000, 0, 0, 'I016', 'P016'), -- P016 Terra Firma Cologne Intense
('D017', 1, 85000, 25500, 0, 'I017', 'P017'), -- P017 Aqua Vitae Shower Oil, 30% desc (Flash Sale Oriental)
('D018', 1, 220000, 33000, 0, 'I018', 'P018'), -- P018 Ignis Ardens Candle, 15% desc (Día Tierra)
('D019', 1, 90000, 22500, 0, 'I019', 'P019'), -- P019 Ventus Spiritus Room Spray, 25% desc (Día Madre)
('D020', 1, 420000, 0, 0, 'I020', 'P020'), -- P020 Floralia Maxima Gift Set
('D021', 1, 260000, 26000, 0, 'I021', 'P021'), -- P021 Sylva Origins EDP, 10% desc
('D022', 2, 230000, 46000, 0, 'I022', 'P022'), -- P022 Urban Elixir EDT, 10% desc (Memorial Day)
('D023', 1, 165000, 33000, 0, 'I023', 'P023'), -- P023 Rurari Essence EDC, 20% desc (Día Padre)
('D024', 1, 680000, 0, 0, 'I024', 'P024'), -- P024 Majestic Oud Extrait
('D025', 1, 65000, 9750, 0, 'I025', 'P025'), -- P025 Serene Petals Body Mist, 15% desc (Solsticio)
('D026', 2, 55000, 0, 0, 'I026', 'P026'), -- P026 Vibrant Citrus Hand Cream (Doble Puntos)
('D027', 1, 130000, 13000, 0, 'I027', 'P027'), -- P027 Opulent Amber Solid Perfume, 10% desc
('D028', 1, 105000, 0, 0, 'I028', 'P028'), -- P028 Radiant Musk Shimmer Lotion (Envío Gratis)
('D029', 1, 75000, 7500, 0, 'I029', 'P029'), -- P029 Mystic Woods Candle Tin, 10% desc
('D030', 1, 180000, 36000, 0, 'I030', 'P030'), -- P030 Enigma Parfum Roll-On, 20% desc (Indep. COL)
('D031', 1, 650000, 0, 0, 'I031', 'P031'), -- P031 Chanel No. 5 (Prime Days)
('D032', 1, 480000, 72000, 0, 'I032', 'P032'), -- P032 Dior Sauvage, 15% desc (Regreso Clases)
('D033', 1, 520000, 0, 0, 'I033', 'P033'), -- P033 Guerlain Shalimar
('D034', 2, 1200000, 240000, 0, 'I034', 'P034'), -- P034 Creed Aventus, 10% desc (Día Perro)
('D035', 1, 580000, 0, 0, 'I035', 'P035'), -- P035 Jo Malone Lime Basil
('D036', 1, 720000, 72000, 0, 'I036', 'P036'), -- P036 Tom Ford Black Orchid, 10% desc
('D037', 1, 560000, 112000, 0, 'I037', 'P037'), -- P037 YSL Black Opium, 20% desc (Festival Floral)
('D038', 1, 530000, 0, 0, 'I038', 'P038'), -- P038 Lancôme La Vie Est Belle
('D039', 1, 590000, 59000, 0, 'I039', 'P039'), -- P039 Armani Sì, 10% desc (Amor y Amistad)
('D040', 2, 450000, 90000, 0, 'I040', 'P040'), -- P040 Paco Rabanne 1 Million, 10% desc (Bienvenida Otoño)
('D041', 1, 540000, 54000, 0, 'I041', 'P041'), -- P041 CH Good Girl, 10% desc (Semana Nicho)
('D042', 1, 380000, 0, 0, 'I042', 'P042'), -- P042 Bvlgari Omnia Crystalline
('D043', 1, 320000, 41600, 0, 'I043', 'P043'), -- P043 CK One, 13% desc (Pre-Halloween)
('D044', 1, 510000, 0, 0, 'I044', 'P044'), -- P044 Hermès Terre d'Hermès
('D045', 1, 490000, 49000, 0, 'I045', 'P045'), -- P045 Mugler Angel, 10% desc (Día Muertos)
('D046', 1, 950000, 0, 0, 'I046', 'P046'), -- P046 Le Labo Santal 33
('D047', 1, 880000, 88000, 0, 'I047', 'P047'), -- P047 Byredo Gypsy Water, 10% desc (Veterans Day)
('D048', 1, 2100000, 420000, 0, 'I048', 'P048'), -- P048 MFK Baccarat Rouge, 20% desc (Pre-Black Friday)
('D049', 1, 620000, 0, 0, 'I049', 'P049'), -- P049 Diptyque Philosykos
('D050', 1, 1150000, 575000, 0, 'I050', 'P050'); -- P050 Kilian Love, Don't Be Shy, 50% desc (BLACK FRIDAY)


INSERT INTO DIAMOND.DETAILS_INVOICE_SALES (id_details_invoice_sale, quantity, unit_price, discount, subtotal, id_invoice_sale, id_product) VALUES
-- I051 (Oferta Small Business Saturday) con P051 (AuraSphere EDP, precio ~290000)
('D051', 1, 290000, 29000, 0, 'I051', 'P051'), -- 10% desc
-- I052 (Cyber Monday) con P052 (Nocturne Extrait, precio ~580000)
('D052', 1, 580000, 116000, 0, 'I052', 'P052'), -- 20% desc Cyber Monday
-- I053 (Regalos navideños) con P053 (Solstice EDT, precio ~220000)
('D053', 2, 220000, 0, 0, 'I053', 'P053'),
-- I054 (Noche de Velitas) con P054 (Elysian Fields Body Butter, precio ~125000)
('D054', 1, 125000, 12500, 0, 'I054', 'P054'), -- 10% desc Velitas
-- I055 (Última semana regalos) con P055 (Zephyr Notes EDC, precio ~160000)
('D055', 1, 160000, 0, 0, 'I055', 'P055'),
-- I056 (Día de Navidad) con P056 (Crystal Bloom Candle, precio ~250000)
('D056', 1, 250000, 50000, 0, 'I056', 'P056'), -- 20% desc Navidad
-- I057 (Liquidación Fin de Año) con P057 (Velvet Whisper Shower Cream, precio ~78000)
('D057', 3, 78000, 46800, 0, 'I057', 'P057'), -- 20% desc liquidación
-- I058 (Bienvenido 2025) con P058 (Silken Mist Gift Set, precio ~380000)
('D058', 1, 380000, 76000, 0, 'I058', 'P058'), -- 20% desc Año Nuevo
-- I059 (Limpieza de Enero) con P059 (Lunar Glow Parfum, precio ~450000)
('D059', 1, 450000, 45000, 0, 'I059', 'P059'), -- 10% desc limpieza
-- I060 (Blue Monday) con P060 (Stellar Dust EDT, precio ~235000)
('D060', 1, 235000, 23500, 0, 'I060', 'P060'), -- 10% desc Blue Monday
('D061', 1, 190000, 0, 0, 'I061', 'P061'), -- P061 Nebula Diffuser
('D062', 1, 520000, 104000, 0, 'I062', 'P062'), -- P062 Terra Firma Extrait, 20% San Valentín
('D063', 2, 100000, 20000, 0, 'I063', 'P063'), -- P063 Aqua Vitae Body Oil, 10% desc
('D064', 1, 145000, 0, 0, 'I064', 'P064'), -- P064 Ignis Ardens Solid Cologne
('D065', 1, 310000, 62000, 0, 'I065', 'P065'), -- P065 Ventus Spiritus EDP, 20% desc (Semana Mujer)
('D066', 1, 360000, 61200, 0, 'I066', 'P066'), -- P066 Floralia Maxima Cologne, 17% St Patrick
('D067', 1, 92000, 0, 0, 'I067', 'P067'), -- P067 Sylva Origins Shower Scrub
('D068', 2, 170000, 34000, 0, 'I068', 'P068'), -- P068 Urban Elixir Candle, 10% desc (Fin Mes)
('D069', 1, 98000, 0, 0, 'I069', 'P069'), -- P069 Rurari Essence Room Spray
('D070', 1, 850000, 170000, 0, 'I070', 'P070'), -- P070 Majestic Oud Gift Set, 20% desc (Venta Primavera)
('D071', 1, 300000, 0, 0, 'I071', 'P071'), -- P071 Serene Petals EDP
('D072', 1, 195000, 29250, 0, 'I072', 'P072'), -- P072 Vibrant Citrus EDT, 15% desc (Día Tierra)
('D073', 3, 240000, 108000, 0, 'I073', 'P073'), -- P073 Opulent Amber EDC, 15% desc (Flash Sale)
('D074', 1, 610000, 152500, 0, 'I074', 'P074'), -- P074 Radiant Musk Extrait, 25% desc (Día Madre)
('D075', 1, 115000, 0, 0, 'I075', 'P075'), -- P075 Mystic Woods Body Soufflé
('D076', 2, 250000, 0, 0, 'I076', 'P076'), -- P076 Enigma Parfum Travel Spray
('D077', 1, 70000, 14000, 0, 'I077', 'P077'), -- P077 Dream Weaver Pillow Mist, 20% desc (Memorial)
('D078', 1, 60000, 0, 0, 'I078', 'P078'), -- P078 Memory Lane Sachet
('D079', 1, 120000, 12000, 0, 'I079', 'P079'), -- P079 Echoes of Nature Diffuser Refill, 10% desc
('D080', 1, 180000, 0, 0, 'I080', 'P080'), -- P080 Whimsical Spritz EDP
('D081', 1, 275000, 41250, 0, 'I081', 'P081'), -- P081 Arcane Formulations EDT, 15% desc (Día Océanos)
('D082', 1, 200000, 0, 0, 'I082', 'P082'), -- P082 Legendary Aromas EDC
('D083', 1, 560000, 112000, 0, 'I083', 'P083'), -- P083 Ethereal Blends Extrait, 20% desc (Solsticio)
('D084', 2, 135000, 0, 0, 'I084', 'P084'), -- P084 Divine Nectars Body Elixir
('D085', 1, 280000, 28000, 0, 'I085', 'P085'), -- P085 Imperial Collection Candle Set, 10% desc
('D086', 1, 110000, 0, 0, 'I086', 'P086'), -- P086 Royal Essence Room Fragrance
('D087', 1, 400000, 80000, 0, 'I087', 'P087'), -- P087 Noble Spirit Gift Set, 20% desc (Indep. COL)
('D088', 1, 330000, 0, 0, 'I088', 'P088'), -- P088 Purest Formulations EDP (Prime Days)
('D089', 1, 245000, 36750, 0, 'I089', 'P089'), -- P089 Artisan Scents EDT, 15% desc (Agosto Fresco)
('D090', 3, 290000, 0, 0, 'I090', 'P090'), -- P090 Exclusif Aromatique EDC
('D091', 1, 750000, 112500, 0, 'I091', 'P091'), -- P091 Signature Blends Extrait, 15% desc (Vuelta Cole)
('D092', 1, 150000, 0, 0, 'I092', 'P092'), -- P092 Unik Parfums Discovery Set
('D093', 1, 315000, 31500, 0, 'I093', 'P093'), -- P093 Vanguard Fragrance EDP, 10% desc (Labor Day)
('D094', 1, 95000, 19000, 0, 'I094', 'P094'), -- P094 Classic Notes Aftershave, 20% desc (Abuelos)
('D095', 1, 140000, 0, 0, 'I095', 'P095'), -- P095 Modern Aromas Candle
('D096', 1, 175000, 17500, 0, 'I096', 'P096'), -- P096 Timeless Elixirs Diffuser, 10% desc (Amor Amistad)
('D097', 1, 380000, 0, 0, 'I097', 'P097'), -- P097 FutureScents Lab EDP
('D098', 1, 265000, 39750, 0, 'I098', 'P098'), -- P098 Heritage Perfumery EDT, 15% desc (Día Turismo)
('D099', 2, 210000, 42000, 0, 'I099', 'P099'), -- P099 Innovate Aromatics EDC, 10% desc (Mes Vegano)
('D100', 1, 495000, 0, 0, 'I100', 'P100'); -- P100 Tradition Parfumee Extrait

INSERT INTO DIAMOND.DETAILS_INVOICE_SALES (id_details_invoice_sale, quantity, unit_price, discount, subtotal, id_invoice_sale, id_product) VALUES
('D101', 1, 320000, 32000, 0, 'I101', 'P101'), -- P101 Alchemy Aromas EDP, 10% desc (Discovery Weekend)
('D102', 1, 240000, 72000, 0, 'I102', 'P102'), -- P102 Essentia Pura EDT, 30% desc (Flash Sale Cuero)
('D103', 1, 950000, 0, 0, 'I103', 'P103'), -- P103 Magnum Opus Extrait
('D104', 2, 140000, 28000, 0, 'I104', 'P104'), -- P104 Quintessence Body Cream, 10% desc
('D105', 1, 190000, 0, 0, 'I105', 'P105'), -- P105 Renaissance Scents EDC
('D106', 1, 180000, 18000, 0, 'I106', 'P106'), -- P106 Baroque Elixirs Candle, 10% desc
('D107', 1, 88000, 0, 0, 'I107', 'P107'), -- P107 Rococo Perfumes Shower Gel
('D108', 1, 390000, 39000, 0, 'I108', 'P108'), -- P108 NeoClassic Gift Set, 10% desc
('D109', 1, 350000, 70000, 0, 'I109', 'P109'), -- P109 AvantGarde EDP, 20% desc
('D110', 2, 210000, 0, 0, 'I110', 'P110'), -- P110 Minimalist Notes EDT
('D111', 1, 150000, 15000, 0, 'I111', 'P111'), -- P111 Bohemian Diffuser, 10% desc
('D112', 1, 620000, 0, 0, 'I112', 'P112'), -- P112 Luxe Aura Extrait
('D113', 1, 120000, 12000, 0, 'I113', 'P113'), -- P113 Glamour Body Shimmer, 10% desc
('D114', 1, 160000, 0, 0, 'I114', 'P114'), -- P114 Chic Solid Perfume
('D115', 1, 335000, 33500, 0, 'I115', 'P115'), -- P115 Elegant Expressions EDP, 10% desc
('D116', 1, 370000, 0, 0, 'I116', 'P116'), -- P116 Sophisticate Cologne Intense
('D117', 1, 150000, 15000, 0, 'I117', 'P117'), -- P117 Powerhouse Shower Gel, 10% desc
('D118', 1, 200000, 40000, 0, 'I118', 'P118'), -- P118 Seduction Candle, 20% desc
('D119', 2, 85000, 0, 0, 'I119', 'P119'), -- P119 Passion Fruit Room Spray
('D120', 1, 250000, 25000, 0, 'I120', 'P120'), -- P120 Vanilla Dreams Gift Set, 10% desc
('D121', 1, 360000, 0, 0, 'I121', 'P121'), -- P121 Rose Garden EDP
('D122', 1, 225000, 22500, 0, 'I122', 'P122'), -- P122 Jasmine Bloom EDT, 10% desc
('D123', 1, 200000, 0, 0, 'I123', 'P123'), -- P123 Sandalwood Secret EDC
('D124', 1, 650000, 130000, 0, 'I124', 'P124'), -- P124 Amber Glow Extrait, 20% desc
('D125', 2, 90000, 0, 0, 'I125', 'P125'), -- P125 Musketeer Body Lotion
('D126', 1, 60000, 6000, 0, 'I126', 'P126'), -- P126 Citrus Burst Hand Soap, 10% desc
('D127', 1, 70000, 0, 0, 'I127', 'P127'), -- P127 Herbal Infusion Shampoo Bar
('D128', 1, 190000, 19000, 0, 'I128', 'P128'), -- P128 Spice Route Candle Set, 10% desc
('D129', 1, 110000, 0, 0, 'I129', 'P129'), -- P129 Woodland Notes Diffuser Refill
('D130', 1, 290000, 58000, 0, 'I130', 'P130'), -- P130 Ocean Breeze EDP, 20% desc
('D131', 2, 230000, 0, 0, 'I131', 'P131'), -- P131 Mountain Air EDT
('D132', 1, 185000, 18500, 0, 'I132', 'P132'), -- P132 Forest Whisper EDC, 10% desc
('D133', 1, 590000, 0, 0, 'I133', 'P133'), -- P133 Desert Mirage Extrait
('D134', 1, 98000, 9800, 0, 'I134', 'P134'), -- P134 Island Paradise Body Scrub, 10% desc
('D135', 1, 75000, 0, 0, 'I135', 'P135'), -- P135 Tropical Nectar Conditioner
('D136', 1, 260000, 52000, 0, 'I136', 'P136'), -- P136 Exotic Journey Candle, 20% desc
('D137', 2, 105000, 0, 0, 'I137', 'P137'), -- P137 Adventure Spirit Room Spray
('D138', 1, 370000, 37000, 0, 'I138', 'P138'), -- P138 Urbanite Gift Set, 10% desc
('D139', 1, 345000, 0, 0, 'I139', 'P139'), -- P139 Cosmopolitan EDP
('D140', 1, 215000, 21500, 0, 'I140', 'P140'), -- P140 Global Essence EDT, 10% desc
('D141', 1, 250000, 0, 0, 'I141', 'P141'), -- P141 Nightfall EDC
('D142', 1, 480000, 96000, 0, 'I142', 'P142'), -- P142 Dawn Chorus Extrait, 20% desc
('D143', 2, 80000, 0, 0, 'I143', 'P143'), -- P143 Twilight Mist Bath Bomb Set
('D144', 1, 110000, 11000, 0, 'I144', 'P144'), -- P144 Midnight Bloom Scented Oil, 10% desc
('D145', 1, 70000, 0, 0, 'I145', 'P145'), -- P145 Daylight Radiance Face Mist
('D146', 1, 125000, 12500, 0, 'I146', 'P146'), -- P146 Summer Solstice Shimmer Oil, 10% desc
('D147', 1, 45000, 0, 0, 'I147', 'P147'), -- P147 Winter Embrace Lip Balm
('D148', 1, 95000, 19000, 0, 'I148', 'P148'), -- P148 Autumn Leaves Potpourri, 20% desc
('D149', 2, 65000, 0, 0, 'I149', 'P149'), -- P149 Spring Blossom Hand Lotion
('D150', 1, 200000, 20000, 0, 'I150', 'P150'); -- P150 Seasonal Scents Discovery Kit, 10% desc


INSERT INTO DIAMOND.DETAILS_INVOICE_SALES (id_details_invoice_sale, quantity, unit_price, discount, subtotal, id_invoice_sale, id_product) VALUES
('D151', 1, 330000, 0, 0, 'I151', 'P151'), -- P151 Celestial Aromas EDP
('D152', 1, 250000, 25000, 0, 'I152', 'P152'), -- P152 Galaxy Perfumes EDT, 10% desc
('D153', 1, 550000, 110000, 0, 'I153', 'P153'), -- P153 Comet Tail Extrait, 20% desc
('D154', 2, 140000, 0, 0, 'I154', 'P154'), -- P154 Stardust Body Glow Oil
('D155', 1, 195000, 19500, 0, 'I155', 'P155'), -- P155 Astral Projection EDC, 10% desc
('D156', 1, 300000, 0, 0, 'I156', 'P156'), -- P156 Orbital Notes Candle Set
('D157', 1, 95000, 9500, 0, 'I157', 'P157'), -- P157 Cosmic Nectar Shower Nectar, 10% desc
('D158', 1, 450000, 45000, 0, 'I158', 'P158'), -- P158 Void Fragrances Gift Set, 10% desc
('D159', 1, 370000, 0, 0, 'I159', 'P159'), -- P159 Dimension Shift EDP
('D160', 2, 260000, 52000, 0, 'I160', 'P160'), -- P160 Parallel Universe EDT, 10% desc
('D161', 1, 170000, 17000, 0, 'I161', 'P161'), -- P161 Fantasy Realm Diffuser, 10% desc
('D162', 1, 720000, 144000, 0, 'I162', 'P162'), -- P162 Mythic Legends Extrait, 20% desc
('D163', 1, 80000, 0, 0, 'I163', 'P163'), -- P163 Faerie Glen Body Powder
('D164', 1, 150000, 15000, 0, 'I164', 'P164'), -- P164 Dragons Breath Solid Perfume, 10% desc
('D165', 1, 400000, 0, 0, 'I165', 'P165'), -- P165 Phoenix Ash EDP
('D166', 1, 380000, 38000, 0, 'I166', 'P166'), -- P166 Unicorn Horn Cologne Intense, 10% desc
('D167', 1, 92000, 0, 0, 'I167', 'P167'), -- P167 Griffin Feather Shower Mousse
('D168', 1, 190000, 19000, 0, 'I168', 'P168'), -- P168 Mermaid Song Candle, 10% desc
('D169', 1, 100000, 0, 0, 'I169', 'P169'), -- P169 Elven Woods Room Spray
('D170', 1, 480000, 96000, 0, 'I170', 'P170'), -- P170 Vampire Kiss Gift Set, 20% desc
('D171', 2, 350000, 0, 0, 'I171', 'P171'), -- P171 Werewolf Musk EDP
('D172', 1, 180000, 18000, 0, 'I172', 'P172'), -- P172 Zombie Zest EDT, 10% desc
('D173', 1, 220000, 0, 0, 'I173', 'P173'), -- P173 Ghostly Whisper EDC
('D174', 1, 690000, 69000, 0, 'I174', 'P174'), -- P174 Angel Wing Extrait, 10% desc
('D175', 1, 130000, 0, 0, 'I175', 'P175'), -- P175 Demon Charm Body Shimmer
('D176', 1, 140000, 14000, 0, 'I176', 'P176'), -- P176 Spirit Guide Solid Balm, 10% desc
('D177', 1, 550000, 110000, 0, 'I177', 'P177'), -- P177 Soulmate Essence EDP Duo, 20% desc
('D178', 3, 70000, 0, 0, 'I178', 'P178'), -- P178 Karma Balance Incense Sticks
('D179', 1, 90000, 9000, 0, 'I179', 'P179'), -- P179 Destiny Weaver Diffuser Oil, 10% desc
('D180', 1, 310000, 0, 0, 'I180', 'P180'), -- P180 Fate & Fortune EDP
('D181', 1, 200000, 20000, 0, 'I181', 'P181'), -- P181 Lucky Charm EDT, 10% desc
('D182', 1, 170000, 0, 0, 'I182', 'P182'), -- P182 Providence Parfum EDC
('D183', 1, 580000, 58000, 0, 'I183', 'P183'), -- P183 Serendipity Co. Extrait, 10% desc
('D184', 1, 100000, 0, 0, 'I184', 'P184'), -- P184 Blissful Moments Bath Salts
('D185', 1, 130000, 13000, 0, 'I185', 'P185'), -- P185 Joyful Spirit Candle, 10% desc
('D186', 1, 95000, 19000, 0, 'I186', 'P186'), -- P186 Peaceful Mind Room Mist, 20% desc
('D187', 2, 420000, 0, 0, 'I187', 'P187'), -- P187 Happiness in Bottle Gift Set
('D188', 1, 360000, 36000, 0, 'I188', 'P188'), -- P188 Love Potion No. 10 EDP, 10% desc
('D189', 1, 230000, 0, 0, 'I189', 'P189'), -- P189 Friendship Bond EDT
('D190', 1, 190000, 19000, 0, 'I190', 'P190'), -- P190 Family Ties EDC, 10% desc
('D191', 1, 670000, 0, 0, 'I191', 'P191'), -- P191 Homeward Bound Extrait
('D192', 1, 150000, 15000, 0, 'I192', 'P192'), -- P192 Comfort Zone Body Butter, 10% desc
('D193', 1, 135000, 27000, 0, 'I193', 'P193'), -- P193 Safe Haven Solid Perfume, 20% desc
('D194', 2, 115000, 0, 0, 'I194', 'P194'), -- P194 Tranquil Escape Bath Oil
('D195', 1, 240000, 24000, 0, 'I195', 'P195'), -- P195 Relaxation Station Candle, 10% desc
('D196', 1, 220000, 0, 0, 'I196', 'P196'), -- P196 Meditative Moods Diffuser Oil Set
('D197', 1, 290000, 29000, 0, 'I197', 'P197'), -- P197 Yoga Flow EDP, 10% desc
('D198', 1, 180000, 0, 0, 'I198', 'P198'), -- P198 Zen Garden Room Spray Set
('D199', 1, 250000, 25000, 0, 'I199', 'P199'), -- P199 Energy Boost EDT, 10% desc
('D200', 1, 90000, 18000, 0, 'I200', 'P200'); -- P200 Vitality Spark Shower Steamers, 20% desc

INSERT INTO DIAMOND.DETAILS_INVOICE_SALES (id_details_invoice_sale, quantity, unit_price, discount, subtotal, id_invoice_sale, id_product) VALUES
('D201', 2, 180000, 0, 0, 'I201', 'P201'), -- P201 Rejuvenate Me Face Serum
('D202', 1, 80000, 8000, 0, 'I202', 'P202'), -- P202 Refresh & Revive Hair Mist, 10% desc
('D203', 1, 200000, 0, 0, 'I203', 'P203'), -- P203 Invigorate Ltd. EDC
('D204', 1, 75000, 7500, 0, 'I204', 'P204'), -- P204 Motivation Mist Body Spray, 10% desc
('D205', 1, 520000, 0, 0, 'I205', 'P205'), -- P205 Inspiration Spark Extrait
('D206', 1, 135000, 13500, 0, 'I206', 'P206'), -- P206 Creativity Flow Candle, 10% desc
('D207', 1, 100000, 20000, 0, 'I207', 'P207'), -- P207 Focus Point Diffuser Oil, 20% desc
('D208', 2, 390000, 0, 0, 'I208', 'P208'), -- P208 Clarity Essence Gift Set
('D209', 1, 340000, 34000, 0, 'I209', 'P209'), -- P209 Wisdom Seeker EDP, 10% desc
('D210', 1, 255000, 0, 0, 'I210', 'P210'), -- P210 Knowledge Nectar EDT
('D211', 1, 180000, 18000, 0, 'I211', 'P211'), -- P211 Truth Serum EDC, 10% desc
('D212', 1, 700000, 0, 0, 'I212', 'P212'), -- P212 Honesty Parfum Extrait
('D213', 1, 85000, 8500, 0, 'I213', 'P213'), -- P213 Integrity Blends Body Wash, 10% desc
('D214', 1, 155000, 31000, 0, 'I214', 'P214'), -- P214 Courageous Spirit Solid Perfume, 20% desc
('D215', 2, 325000, 0, 0, 'I215', 'P215'), -- P215 Braveheart Aromas EDP
('D216', 1, 390000, 39000, 0, 'I216', 'P216'), -- P216 Strong Will Cologne Intense, 10% desc
('D217', 1, 98000, 0, 0, 'I217', 'P217'), -- P217 Resilience Parfum Shower Oil
('D218', 1, 175000, 17500, 0, 'I218', 'P218'), -- P218 Hopeful Horizon Candle, 10% desc
('D219', 1, 90000, 0, 0, 'I219', 'P219'), -- P219 Dreamcatcher Room Spray
('D220', 1, 380000, 38000, 0, 'I220', 'P220'), -- P220 Ambition Fuel Gift Set, 10% desc
('D221', 1, 370000, 74000, 0, 'I221', 'P221'), -- P221 Success Story EDP, 20% desc
('D222', 2, 240000, 0, 0, 'I222', 'P222'), -- P222 Victory Lap EDT
('D223', 1, 210000, 21000, 0, 'I223', 'P223'), -- P223 Champion Spirit EDC, 10% desc
('D224', 1, 730000, 0, 0, 'I224', 'P224'), -- P224 Leadership Aura Extrait
('D225', 1, 125000, 12500, 0, 'I225', 'P225'), -- P225 Influence Essence Body Soufflé, 10% desc
('D226', 1, 165000, 0, 0, 'I226', 'P226'), -- P226 Charisma Factor Solid Perfume
('D227', 1, 120000, 12000, 0, 'I227', 'P227'), -- P227 Magnetic Pull Bath Oil, 10% desc
('D228', 1, 255000, 51000, 0, 'I228', 'P228'), -- P228 Allure Mystique Candle, 20% desc
('D229', 2, 230000, 0, 0, 'I229', 'P229'), -- P229 Captivate Me Diffuser Oil Set
('D230', 1, 330000, 33000, 0, 'I230', 'P230'), -- P230 Fascination Co. EDP, 10% desc
('D231', 1, 265000, 0, 0, 'I231', 'P231'), -- P231 Temptation Isle EDT
('D232', 1, 195000, 19500, 0, 'I232', 'P232'), -- P232 Desire Path EDC, 10% desc
('D233', 1, 600000, 0, 0, 'I233', 'P233'), -- P233 Intrigue Aromas Extrait
('D234', 1, 80000, 8000, 0, 'I234', 'P234'), -- P234 Mystery Unveiled Body Mist, 10% desc
('D235', 1, 60000, 12000, 0, 'I235', 'P235'), -- P235 Secret Garden Hand Cream, 20% desc
('D236', 2, 190000, 0, 0, 'I236', 'P236'), -- P236 Hidden Treasure Solid Perfume Locket
('D237', 1, 110000, 11000, 0, 'I237', 'P237'), -- P237 Forbidden Fruit Shimmer Lotion, 10% desc
('D238', 1, 185000, 0, 0, 'I238', 'P238'), -- P238 Rare Gem Candle
('D239', 1, 115000, 11500, 0, 'I239', 'P239'), -- P239 Precious Metals Room Fragrance, 10% desc
('D240', 1, 550000, 0, 0, 'I240', 'P240'), -- P240 Diamond Dust Gift Set
('D241', 1, 450000, 45000, 0, 'I241', 'P241'), -- P241 Golden Elixir EDP, 10% desc
('D242', 1, 220000, 44000, 0, 'I242', 'P242'), -- P242 Silver Lining EDT, 20% desc
('D243', 2, 300000, 0, 0, 'I243', 'P243'), -- P243 Platinum StandardS EDC
('D244', 1, 1200000, 120000, 0, 'I244', 'P244'), -- P244 Crown Jewel Extrait, 10% desc
('D245', 1, 145000, 0, 0, 'I245', 'P245'), -- P245 Scepter of Power Body Oil
('D246', 1, 200000, 20000, 0, 'I246', 'P246'), -- P246 Throne Room Solid Perfume Case, 10% desc
('D247', 1, 100000, 0, 0, 'I247', 'P247'), -- P247 Empire Builder Aftershave Balm
('D248', 1, 320000, 32000, 0, 'I248', 'P248'), -- P248 Kingdom Come Candle Set, 10% desc
('D249', 1, 195000, 39000, 0, 'I249', 'P249'), -- P249 Queen Bee Diffuser, 20% desc
('D250', 2, 340000, 0, 0, 'I250', 'P250'); -- P250 Princely Charm EDP



INSERT INTO DIAMOND.DETAILS_INVOICE_SALES (id_details_invoice_sale, quantity, unit_price, discount, subtotal, id_invoice_sale, id_product) VALUES
('D251', 1, 270000, 27000, 0, 'I251', 'P251'), -- P251 Duchess Grace EDT, 10% desc
('D252', 1, 200000, 0, 0, 'I252', 'P252'), -- P252 Earl Grey Notes EDC
('D253', 1, 620000, 62000, 0, 'I253', 'P253'), -- P253 Baron Von Scent Extrait, 10% desc
('D254', 1, 90000, 0, 0, 'I254', 'P254'), -- P254 Knight's Valor Shower Gel
('D255', 1, 350000, 35000, 0, 'I255', 'P255'), -- P255 Lady Luck EDP, 10% desc
('D256', 1, 400000, 80000, 0, 'I256', 'P256'), -- P256 Lord of Aromas Cologne Intense, 20% desc
('D257', 2, 70000, 0, 0, 'I257', 'P257'), -- P257 Maiden Fair Body Mist
('D258', 1, 160000, 16000, 0, 'I258', 'P258'), -- P258 Warrior Spirit Solid Perfume, 10% desc
('D259', 1, 190000, 0, 0, 'I259', 'P259'), -- P259 Mage's Mysterium Candle
('D260', 1, 110000, 11000, 0, 'I260', 'P260'), -- P260 Alchemist's Brew Diffuser Oil, 10% desc
('D261', 1, 98000, 0, 0, 'I261', 'P261'), -- P261 Scribe's Ink Room Spray
('D262', 1, 330000, 33000, 0, 'I262', 'P262'), -- P262 Poet's Muse EDP, 10% desc
('D263', 1, 260000, 52000, 0, 'I263', 'P263'), -- P263 Artist's Palette EDT, 20% desc
('D264', 2, 195000, 0, 0, 'I264', 'P264'), -- P264 Musician's Harmony EDC
('D265', 1, 500000, 50000, 0, 'I265', 'P265'), -- P265 Dancer's Rhythm Extrait, 10% desc
('D266', 1, 120000, 0, 0, 'I266', 'P266'), -- P266 Actor's SpotlightP Body Shimmer
('D267', 1, 140000, 14000, 0, 'I267', 'P267'), -- P267 Filmmaker's Dream Solid Perfume, 10% desc
('D268', 1, 100000, 0, 0, 'I268', 'P268'), -- P268 Writer's Block Candle
('D269', 1, 165000, 16500, 0, 'I269', 'P269'), -- P269 Reader's Nook Diffuser, 10% desc
('D270', 1, 310000, 62000, 0, 'I270', 'P270'), -- P270 LibraryWhispers EDP, 20% desc
('D271', 2, 220000, 0, 0, 'I271', 'P271'), -- P271 Bookworm Aromas EDT
('D272', 1, 180000, 18000, 0, 'I272', 'P272'), -- P272 Paper & Quill EDC, 10% desc
('D273', 1, 590000, 0, 0, 'I273', 'P273'), -- P273 Inkwell Dreams Extrait
('D274', 1, 105000, 10500, 0, 'I274', 'P274'), -- P274 Quill & Scroll Bath Salts, 10% desc
('D275', 1, 145000, 0, 0, 'I275', 'P275'), -- P275 Manuscript Memories Candle
('D276', 1, 100000, 10000, 0, 'I276', 'P276'), -- P276 Storyteller's Room Spray, 10% desc
('D277', 1, 370000, 74000, 0, 'I277', 'P277'), -- P277 Tale Weaver EDP, 20% desc
('D278', 2, 235000, 0, 0, 'I278', 'P278'), -- P278 Fable & Fantasy EDT
('D279', 1, 185000, 18500, 0, 'I279', 'P279'), -- P279 Legend & Lore EDC, 10% desc
('D280', 1, 510000, 0, 0, 'I280', 'P280'), -- P280 Folklore Fragrance Extrait
('D281', 1, 92000, 9200, 0, 'I281', 'P281'), -- P281 Traveler's Joy Body Lotion, 10% desc
('D282', 1, 150000, 0, 0, 'I282', 'P282'), -- P282 Explorer's SpiritS Solid Perfume
('D283', 1, 180000, 18000, 0, 'I283', 'P283'), -- P283 Adventurer's Call Candle, 10% desc
('D284', 1, 115000, 23000, 0, 'I284', 'P284'), -- P284 Voyager's CompassP Diffuser Oil, 20% desc
('D285', 2, 320000, 0, 0, 'I285', 'P285'), -- P285 Nomad's Heart EDP
('D286', 1, 250000, 25000, 0, 'I286', 'P286'), -- P286 Wanderlust Aromas EDT, 10% desc
('D287', 1, 200000, 0, 0, 'I287', 'P287'), -- P287 Pathfinder ParfumS EDC
('D288', 1, 650000, 65000, 0, 'I288', 'P288'), -- P288 Journey Within Extrait, 10% desc
('D289', 1, 130000, 0, 0, 'I289', 'P289'), -- P289 Destination Unknown Body Soufflé
('D290', 1, 195000, 19500, 0, 'I290', 'P290'), -- P290 Horizon Line Solid Perfume Locket, 10% desc
('D291', 1, 150000, 30000, 0, 'I291', 'P291'), -- P291 Road Less Traveled Candle, 20% desc
('D292', 2, 105000, 0, 0, 'I292', 'P292'), -- P292 Mapmaker's ScentS Room Spray
('D293', 1, 300000, 30000, 0, 'I293', 'P293'), -- P293 Compass Rose EDP, 10% desc
('D294', 1, 225000, 0, 0, 'I294', 'P294'), -- P294 Navigator's Notes EDT
('D295', 1, 180000, 18000, 0, 'I295', 'P295'), -- P295 Sailor's Delight EDC, 10% desc
('D296', 1, 520000, 0, 0, 'I296', 'P296'), -- P296 Shipwreck Bay Extrait
('D297', 1, 90000, 9000, 0, 'I297', 'P297'), -- P297 Port of Call Aftershave, 10% desc
('D298', 1, 170000, 34000, 0, 'I298', 'P298'), -- P298 Harbor Lights Candle, 20% desc
('D299', 2, 160000, 0, 0, 'I299', 'P299'), -- P299 Beacon Point Diffuser
('D300', 1, 360000, 36000, 0, 'I300', 'P300'); -- P300 Anchor & Hope EDP, 10% desc

INSERT INTO DIAMOND.DETAILS_INVOICE_SALES (id_details_invoice_sale, quantity, unit_price, discount, subtotal, id_invoice_sale, id_product) VALUES
('D301', 1, 240000, 0, 0, 'I301', 'P301'), -- P301 Wavecrest Parfum EDT
('D302', 1, 205000, 20500, 0, 'I302', 'P302'), -- P302 Tidal Bloom EDC, 10% desc
('D303', 1, 680000, 0, 0, 'I303', 'P303'), -- P303 Coral Reef Extrait
('D304', 1, 85000, 8500, 0, 'I304', 'P304'), -- P304 Seashell Whisper Body Powder, 10% desc
('D305', 1, 420000, 0, 0, 'I305', 'P305'), -- P305 Pearl Diver EDP
('D306', 1, 155000, 15500, 0, 'I306', 'P306'), -- P306 Sand Dune Solid Perfume, 10% desc
('D307', 1, 140000, 28000, 0, 'I307', 'P307'), -- P307 Beach Day Candle, 20% desc
('D308', 2, 120000, 0, 0, 'I308', 'P308'), -- P308 Sunken Treasure Diffuser Oil
('D309', 1, 90000, 9000, 0, 'I309', 'P309'), -- P309 Coastal Breeze Room Spray, 10% desc
('D310', 1, 330000, 0, 0, 'I310', 'P310'), -- P310 Isle of Skye EDP
('D311', 1, 255000, 25500, 0, 'I311', 'P311'), -- P311 Lagoon Secret EDT, 10% desc
('D312', 1, 190000, 0, 0, 'I312', 'P312'), -- P312 Riverbend Parfum EDC
('D313', 1, 500000, 50000, 0, 'I313', 'P313'), -- P313 Lakeside Morning Extrait, 10% desc
('D314', 1, 70000, 0, 0, 'I314', 'P314'), -- P314 Stream & Stone Bath Bomb
('D315', 1, 145000, 14500, 0, 'I315', 'P315'), -- P315 Waterfall Mist Solid Perfume, 10% desc
('D316', 1, 200000, 40000, 0, 'I316', 'P316'), -- P316 Fountain of YouthS Candle, 20% desc
('D317', 2, 170000, 0, 0, 'I317', 'P317'), -- P317 Springwater FreshL Diffuser
('D318', 1, 315000, 31500, 0, 'I318', 'P318'), -- P318 Dewdrop Blossom EDP, 10% desc
('D319', 1, 260000, 0, 0, 'I319', 'P319'), -- P319 Rainforest Dew EDT
('D320', 1, 210000, 21000, 0, 'I320', 'P320'), -- P320 Misty Mountain EDC, 10% desc
('D321', 1, 660000, 0, 0, 'I321', 'P321'), -- P321 Fog & Fern Extrait
('D322', 1, 135000, 13500, 0, 'I322', 'P322'), -- P322 Cloud Nine Body Butter, 10% desc
('D323', 1, 150000, 30000, 0, 'I323', 'P323'), -- P323 Skylight AromasCo Solid Perfume, 20% desc
('D324', 2, 110000, 0, 0, 'I324', 'P324'), -- P324 Sunbeam Essence Bath Oil
('D325', 1, 250000, 25000, 0, 'I325', 'P325'), -- P325 Moonflower PetalsS Candle, 10% desc
('D326', 1, 225000, 0, 0, 'I326', 'P326'), -- P326 Starlight Gleam Diffuser Oil Set
('D327', 1, 380000, 38000, 0, 'I327', 'P327'), -- P327 Aurora Borealis EDP, 10% desc
('D328', 1, 100000, 0, 0, 'I328', 'P328'), -- P328 Twilight Shimmer Room Spray
('D329', 1, 400000, 40000, 0, 'I329', 'P329'), -- P329 Nightfall MagicCo Gift Set, 10% desc
('D330', 1, 370000, 74000, 0, 'I330', 'P330'), -- P330 Dawnbringer EDP, 20% desc
('D331', 2, 245000, 0, 0, 'I331', 'P331'), -- P331 Sunrise Glow EDT
('D332', 1, 215000, 21500, 0, 'I332', 'P332'), -- P332 Sunset Serenade EDC, 10% desc
('D333', 1, 560000, 0, 0, 'I333', 'P333'), -- P333 Noonday Heat Extrait
('D334', 1, 130000, 13000, 0, 'I334', 'P334'), -- P334 Evening Star Body Cream, 10% desc
('D335', 1, 170000, 0, 0, 'I335', 'P335'), -- P335 Midnight Garden Solid Perfume
('D336', 1, 175000, 17500, 0, 'I336', 'P336'), -- P336 Blue Hour Candle, 10% desc
('D337', 1, 180000, 36000, 0, 'I337', 'P337'), -- P337 Golden Hour Diffuser, 20% desc
('D338', 2, 320000, 0, 0, 'I338', 'P338'), -- P338 Silver Hour EDP
('D339', 1, 270000, 27000, 0, 'I339', 'P339'), -- P339 White Nights EDT, 10% desc
('D340', 1, 220000, 0, 0, 'I340', 'P340'), -- P340 Darkest Night EDC
('D341', 1, 690000, 69000, 0, 'I341', 'P341'), -- P341 Lightness of Being Extrait, 10% desc
('D342', 1, 95000, 0, 0, 'I342', 'P342'), -- P342 Shadow Play Body Lotion
('D343', 1, 160000, 16000, 0, 'I343', 'P343'), -- P343 Reflection PoolCo Solid Perfume, 10% desc
('D344', 1, 180000, 36000, 0, 'I344', 'P344'), -- P344 Echoing Cavern Candle, 20% desc
('D345', 2, 110000, 0, 0, 'I345', 'P345'), -- P345 Whispering Wind Diffuser Oil
('D346', 1, 325000, 32500, 0, 'I346', 'P346'), -- P346 Silent Forest EDP, 10% desc
('D347', 1, 250000, 0, 0, 'I347', 'P347'), -- P347 Still Waters EDT
('D348', 1, 185000, 18500, 0, 'I348', 'P348'), -- P348 Calm Sea EDC, 10% desc
('D349', 1, 490000, 0, 0, 'I349', 'P349'), -- P349 Serene Meadow Extrait
('D350', 1, 88000, 8800, 0, 'I350', 'P350'); -- P350 Peaceful Valley Body Wash, 10% desc


INSERT INTO DIAMOND.DETAILS_INVOICE_SALES (id_details_invoice_sale, quantity, unit_price, discount, subtotal, id_invoice_sale, id_product) VALUES
('D351', 1, 190000, 19000, 0, 'I351', 'P351'), -- P351 Blissful HeightsS Solid Perfume, 10% desc
('D352', 1, 145000, 29000, 0, 'I352', 'P352'), -- P352 Joyful Noise Candle, 20% desc
('D353', 2, 165000, 0, 0, 'I353', 'P353'), -- P353 Happiness Found Diffuser
('D354', 1, 295000, 29500, 0, 'I354', 'P354'), -- P354 Laughter Lines EDP, 10% desc
('D355', 1, 215000, 0, 0, 'I355', 'P355'), -- P355 Smile Awhile EDT
('D356', 1, 175000, 17500, 0, 'I356', 'P356'), -- P356 Positive Vibes EDC, 10% desc
('D357', 1, 570000, 0, 0, 'I357', 'P357'), -- P357 Optimist Heart Extrait
('D358', 1, 125000, 12500, 0, 'I358', 'P358'), -- P358 Grateful SpiritCo Body Cream, 10% desc
('D359', 1, 130000, 26000, 0, 'I359', 'P359'), -- P359 Thankful ThoughtsP Solid Perfume, 20% desc
('D360', 2, 170000, 0, 0, 'I360', 'P360'), -- P360 Blessed Aromas Candle
('D361', 1, 105000, 10500, 0, 'I361', 'P361'), -- P361 Faith & Flowers Diffuser Oil, 10% desc
('D362', 1, 350000, 0, 0, 'I362', 'P362'), -- P362 Trustworthy NotesP EDP
('D363', 1, 220000, 22000, 0, 'I363', 'P363'), -- P363 Loyalty Parfum EDT, 10% desc
('D364', 1, 180000, 0, 0, 'I364', 'P364'), -- P364 Honor & Grace EDC
('D365', 1, 480000, 48000, 0, 'I365', 'P365'), -- P365 Virtue Scents Extrait, 10% desc
('D366', 1, 92000, 18400, 0, 'I366', 'P366'), -- P366 Nobility Aromas Body Wash, 20% desc
('D367', 2, 165000, 0, 0, 'I367', 'P367'), -- P367 Purity Essence Solid Perfume
('D368', 1, 140000, 14000, 0, 'I368', 'P368'), -- P368 Innocence Found Candle, 10% desc
('D369', 1, 160000, 0, 0, 'I369', 'P369'), -- P369 Simplicity ScentsS Diffuser
('D370', 1, 310000, 31000, 0, 'I370', 'P370'), -- P370 Minimalist TouchL EDP, 10% desc
('D371', 1, 245000, 0, 0, 'I371', 'P371'), -- P371 Essential Being EDT
('D372', 1, 190000, 19000, 0, 'I372', 'P372'), -- P372 Core Values EDC, 10% desc
('D373', 1, 670000, 134000, 0, 'I373', 'P373'), -- P373 True North Extrait, 20% desc
('D374', 2, 130000, 0, 0, 'I374', 'P374'), -- P374 Authentic Self Body Elixir
('D375', 1, 290000, 29000, 0, 'I375', 'P375'), -- P375 Individuality Candle Set, 10% desc
('D376', 1, 112000, 0, 0, 'I376', 'P376'), -- P376 Uniqueness Room Fragrance
('D377', 1, 410000, 41000, 0, 'I377', 'P377'), -- P377 Originality Gift Set, 10% desc
('D378', 1, 365000, 0, 0, 'I378', 'P378'), -- P378 Creative SparkLtd EDP
('D379', 1, 230000, 23000, 0, 'I379', 'P379'), -- P379 Imagination Co. EDT, 10% desc
('D380', 1, 180000, 36000, 0, 'I380', 'P380'), -- P380 Visionary AromasS EDC, 20% desc
('D381', 2, 500000, 0, 0, 'I381', 'P381'), -- P381 Dreamscape ParfumL Extrait
('D382', 1, 78000, 7800, 0, 'I382', 'P382'), -- P382 Fantasia Notes Body Mist, 10% desc
('D383', 1, 145000, 0, 0, 'I383', 'P383'), -- P383 Wonderlust Co. Solid Perfume
('D384', 1, 175000, 17500, 0, 'I384', 'P384'), -- P384 Magical ThinkingP Candle, 10% desc
('D385', 1, 112000, 0, 0, 'I385', 'P385'), -- P385 Enchanted ForestS Diffuser Oil
('D386', 1, 320000, 32000, 0, 'I386', 'P386'), -- P386 Spellbound AromasL EDP, 10% desc
('D387', 1, 255000, 51000, 0, 'I387', 'P387'), -- P387 Charmed Life Co. EDT, 20% desc
('D388', 2, 200000, 0, 0, 'I388', 'P388'), -- P388 Amulet Scents EDC
('D389', 1, 680000, 68000, 0, 'I389', 'P389'), -- P389 Talisman ParfumLtd Extrait, 10% desc
('D390', 1, 128000, 0, 0, 'I390', 'P390'), -- P390 Fortuna's Favor Body Cream
('D391', 1, 175000, 17500, 0, 'I391', 'P391'), -- P391 Prosperity EssenceS Solid Perfume, 10% desc
('D392', 1, 150000, 0, 0, 'I392', 'P392'), -- P392 Abundance Co. Candle
('D393', 1, 170000, 17000, 0, 'I393', 'P393'), -- P393 Wealth & Wisdom Diffuser, 10% desc
('D394', 1, 380000, 76000, 0, 'I394', 'P394'), -- P394 Luxuria Aromas EDP, 20% desc
('D395', 2, 270000, 0, 0, 'I395', 'P395'), -- P395 Opulence Parfum EDT
('D396', 1, 190000, 19000, 0, 'I396', 'P396'), -- P396 Richness of Spirit EDC, 10% desc
('D397', 1, 530000, 0, 0, 'I397', 'P397'), -- P397 Grandeur Scents Extrait
('D398', 1, 140000, 14000, 0, 'I398', 'P398'), -- P398 Majesty Parfum Body Elixir, 10% desc
('D399', 1, 300000, 0, 0, 'I399', 'P399'); -- P399 Regalia Aromas Candle Set


INSERT INTO DIAMOND.DETAILS_INVOICE_SALES (id_details_invoice_sale, quantity, unit_price, discount, subtotal, id_invoice_sale, id_product) VALUES
('D400', 1, 120000, 12000, 0, 'I400', 'P400'), -- P400 Sovereign EssenceS Room Fragrance, 10% desc
('D401', 1, 460000, 92000, 0, 'I401', 'P401'), -- P401 Imperium Parfum Gift Set, 20% desc
('D402', 2, 380000, 0, 0, 'I402', 'P402'), -- P402 Dynasty Scents EDP
('D403', 1, 240000, 24000, 0, 'I403', 'P403'), -- P403 Noblesse Oblige EDT, 10% desc
('D404', 1, 210000, 0, 0, 'I404', 'P404'), -- P404 Aristocrat AromasS EDC
('D405', 1, 750000, 75000, 0, 'I405', 'P405'), -- P405 Elite Collection Extrait, 10% desc
('D406', 1, 135000, 0, 0, 'I406', 'P406'), -- P406 Prestige ParfumLtd Body Shimmer Oil
('D407', 1, 180000, 18000, 0, 'I407', 'P407'), -- P407 Ultimate Essence Solid Perfume, 10% desc
('D408', 1, 155000, 31000, 0, 'I408', 'P408'), -- P408 Perfection Co. Candle, 20% desc
('D409', 2, 175000, 0, 0, 'I409', 'P409'), -- P409 Ideal FormulationsS Diffuser
('D410', 1, 340000, 34000, 0, 'I410', 'P410'), -- P410 Flawless Finish EDP, 10% desc
('D411', 1, 275000, 0, 0, 'I411', 'P411'), -- P411 Excellence ParfumP EDT
('D412', 1, 200000, 20000, 0, 'I412', 'P412'), -- P412 Supreme Aromas EDC, 10% desc
('D413', 1, 540000, 0, 0, 'I413', 'P413'), -- P413 Top Tier Scents Extrait
('D414', 1, 110000, 11000, 0, 'I414', 'P414'), -- P414 Apex Notes Bath Salts, 10% desc
('D415', 1, 310000, 62000, 0, 'I415', 'P415'), -- P415 Zenith CollectionS Candle Set, 20% desc
('D416', 2, 110000, 0, 0, 'I416', 'P416'), -- P416 Summit Aromas Room Spray
('D417', 1, 430000, 43000, 0, 'I417', 'P417'), -- P417 Peak Performance Gift Set, 10% desc
('D418', 1, 375000, 0, 0, 'I418', 'P418'), -- P418 Highland Mist EDP
('D419', 1, 230000, 23000, 0, 'I419', 'P419'), -- P419 Lowland Bloom EDT, 10% desc
('D420', 1, 200000, 0, 0, 'I420', 'P420'), -- P420 Valley Dew EDC
('D421', 1, 660000, 66000, 0, 'I421', 'P421'), -- P421 Plainsong AromasS Extrait, 10% desc
('D422', 1, 132000, 26400, 0, 'I422', 'P422'), -- P422 Meadow Gold Body Butter, 20% desc
('D423', 2, 170000, 0, 0, 'I423', 'P423'), -- P423 Grassroots Solid Perfume
('D424', 1, 148000, 14800, 0, 'I424', 'P424'), -- P424 Earthen Vessels Candle, 10% desc
('D425', 1, 168000, 0, 0, 'I425', 'P425'), -- P425 Terra Firma II Diffuser
('D426', 1, 335000, 33500, 0, 'I426', 'P426'), -- P426 Stone Circle EDP, 10% desc
('D427', 1, 265000, 0, 0, 'I427', 'P427'), -- P427 Rock Crystal EDT
('D428', 1, 195000, 19500, 0, 'I428', 'P428'), -- P428 Mineral Spring EDC, 10% desc
('D429', 1, 550000, 110000, 0, 'I429', 'P429'), -- P429 Gemstone Essence Extrait, 20% desc
('D430', 2, 118000, 0, 0, 'I430', 'P430'), -- P430 Amethyst Dream Bath Oil
('D431', 1, 305000, 30500, 0, 'I431', 'P431'), -- P431 Sapphire Sky Candle Set, 10% desc
('D432', 1, 112000, 0, 0, 'I432', 'P432'), -- P432 Ruby Ember Room Spray
('D433', 1, 440000, 44000, 0, 'I433', 'P433'), -- P433 Emerald Forest Gift Set, 10% desc
('D434', 1, 390000, 0, 0, 'I434', 'P434'), -- P434 Opal Mist EDP
('D435', 1, 235000, 23500, 0, 'I435', 'P435'), -- P435 Jade Whisper EDT, 10% desc
('D436', 1, 205000, 41000, 0, 'I436', 'P436'), -- P436 Topaz Sun EDC, 20% desc
('D437', 2, 675000, 0, 0, 'I437', 'P437'), -- P437 Garnet Glow Extrait
('D438', 1, 138000, 13800, 0, 'I438', 'P438'), -- P438 Aquamarine Deep Body Soufflé, 10% desc
('D439', 1, 172000, 0, 0, 'I439', 'P439'), -- P439 Peridot Leaf Solid Perfume
('D440', 1, 152000, 15200, 0, 'I440', 'P440'), -- P440 Citrine Zest Candle, 10% desc
('D441', 1, 172000, 0, 0, 'I441', 'P441'), -- P441 Turquoise Bay Diffuser
('D442', 1, 345000, 34500, 0, 'I442', 'P442'), -- P442 Moonstone Magic EDP, 10% desc
('D443', 1, 280000, 56000, 0, 'I443', 'P443'), -- P443 Sunstone RadianceC EDT, 20% desc
('D444', 2, 210000, 0, 0, 'I444', 'P444'), -- P444 Labradorite FlashP EDC
('D445', 1, 560000, 56000, 0, 'I445', 'P445'), -- P445 Tiger Eye Extrait, 10% desc
('D446', 1, 82000, 0, 0, 'I446', 'P446'), -- P446 Obsidian Night Body Mist
('D447', 1, 168000, 16800, 0, 'I447', 'P447'), -- P447 Quartz Clear Solid Perfume, 10% desc
('D448', 1, 182000, 0, 0, 'I448', 'P448'), -- P448 Agate Earth Candle
('D449', 1, 118000, 11800, 0, 'I449', 'P449'); -- P449 Jasper Stone Diffuser Oil, 10% desc
select * from diamond.details_invoice_sales;

INSERT INTO DIAMOND.DETAILS_INVOICE_SALES (id_details_invoice_sale, quantity, unit_price, discount, subtotal, id_invoice_sale, id_product) VALUES
('D450', 1, 350000, 70000, 0, 'I450', 'P450'), -- P450 Malachite Swirl EDP, 20% desc (Aniversario)
('D451', 2, 285000, 0, 0, 'I451', 'P451'), -- P451 Lapis Lazuli EDT
('D452', 1, 225000, 22500, 0, 'I452', 'P452'), -- P452 Azurite Sky EDC, 10% desc
('D453', 1, 695000, 0, 0, 'I453', 'P453'), -- P453 Fluorite Dreams Extrait
('D454', 1, 142000, 14200, 0, 'I454', 'P454'), -- P454 Selenite Moon Body Elixir, 10% desc
('D455', 1, 315000, 0, 0, 'I455', 'P455'), -- P455 Calcite Glow Candle Set
('D456', 1, 122000, 12200, 0, 'I456', 'P456'), -- P456 Pyrite Spark Room Fragrance, 10% desc
('D457', 1, 470000, 94000, 0, 'I457', 'P457'), -- P457 Hematite Ground Gift Set, 20% desc
('D458', 2, 400000, 0, 0, 'I458', 'P458'), -- P458 Rhodochrosite Love EDP
('D459', 1, 245000, 24500, 0, 'I459', 'P459'), -- P459 Kunzite Spirit EDT, 10% desc
('D460', 1, 215000, 0, 0, 'I460', 'P460'), -- P460 Morganite Heart EDC
('D461', 1, 570000, 57000, 0, 'I461', 'P461'), -- P461 Heliodor Sun Extrait, 10% desc
('D462', 1, 148000, 0, 0, 'I462', 'P462'), -- P462 Spinel Fire Body Shimmer Oil
('D463', 1, 182000, 18200, 0, 'I463', 'P463'), -- P463 Zircon Brilliance Solid Perfume, 10% desc
('D464', 1, 160000, 32000, 0, 'I464', 'P464'), -- P464 Iolite Vision Candle, 20% desc
('D465', 2, 178000, 0, 0, 'I465', 'P465'), -- P465 Apatite Clarity Diffuser
('D466', 1, 355000, 35500, 0, 'I466', 'P466'), -- P466 Kyanite Flow EDP, 10% desc
('D467', 1, 290000, 0, 0, 'I467', 'P467'), -- P467 Chrysocolla PeaceS EDT
('D468', 1, 230000, 23000, 0, 'I468', 'P468'), -- P468 Prehnite Dream EDC, 10% desc
('D469', 1, 710000, 0, 0, 'I469', 'P469'), -- P469 Seraphinite Wing Extrait
('D470', 1, 150000, 15000, 0, 'I470', 'P470'), -- P470 Danburite Light Body Elixir, 10% desc
('D471', 1, 330000, 66000, 0, 'I471', 'P471'), -- P471 Petalite Angel Candle Set, 20% desc
('D472', 2, 130000, 0, 0, 'I472', 'P472'), -- P472 Phenakite Power Room Fragrance
('D473', 1, 500000, 50000, 0, 'I473', 'P473'), -- P473 Moldavite Star Gift Set, 10% desc
('D474', 1, 410000, 0, 0, 'I474', 'P474'), -- P474 Tektite Cosmic EDP
('D475', 1, 250000, 25000, 0, 'I475', 'P475'), -- P475 Libyan DesertGlass EDT, 10% desc
('D476', 1, 220000, 0, 0, 'I476', 'P476'), -- P476 Shungite Protect EDC
('D477', 1, 580000, 58000, 0, 'I477', 'P477'), -- P477 Amber Resin Extrait, 10% desc
('D478', 1, 85000, 17000, 0, 'I478', 'P478'), -- P478 Copal Incense Body Mist, 20% desc
('D479', 2, 170000, 0, 0, 'I479', 'P479'), -- P479 Frankincense Solid Perfume
('D480', 1, 190000, 19000, 0, 'I480', 'P480'), -- P480 Myrrh Mystique Candle, 10% desc
('D481', 1, 125000, 0, 0, 'I481', 'P481'), -- P481 Palo Santo Diffuser Oil
('D482', 1, 360000, 36000, 0, 'I482', 'P482'), -- P482 White Sage EDP, 10% desc
('D483', 1, 295000, 0, 0, 'I483', 'P483'), -- P483 Cedarwood Atlas EDT
('D484', 1, 235000, 23500, 0, 'I484', 'P484'), -- P484 Pine Needle EDC, 10% desc
('D485', 1, 700000, 140000, 0, 'I485', 'P485'), -- P485 Juniper Berry Extrait, 20% desc
('D486', 2, 95000, 0, 0, 'I486', 'P486'), -- P486 Cypress Grove Body Wash
('D487', 1, 178000, 17800, 0, 'I487', 'P487'), -- P487 Vetiver Earth Solid Perfume, 10% desc
('D488', 1, 165000, 0, 0, 'I488', 'P488'), -- P488 Patchouli Deep Candle
('D489', 1, 182000, 18200, 0, 'I489', 'P489'), -- P489 Ylang Ylang Diffuser, 10% desc
('D490', 1, 370000, 0, 0, 'I490', 'P490'), -- P490 Neroli Blossom EDP
('D491', 1, 260000, 26000, 0, 'I491', 'P491'), -- P491 Petitgrain Leaf EDT, 10% desc
('D492', 1, 200000, 40000, 0, 'I492', 'P492'), -- P492 Bergamot Bliss EDC, 20% desc
('D493', 2, 510000, 0, 0, 'I493', 'P493'), -- P493 Lavender Calm Extrait
('D494', 1, 98000, 9800, 0, 'I494', 'P494'), -- P494 Chamomile Dream Body Lotion, 10% desc
('D495', 1, 140000, 0, 0, 'I495', 'P495'), -- P495 Rosemary Focus Solid Perfume
('D496', 1, 170000, 17000, 0, 'I496', 'P496'), -- P496 Peppermint Rush Candle, 10% desc
('D497', 1, 108000, 0, 0, 'I497', 'P497'), -- P497 Spearmint Fresh Diffuser Oil
('D498', 1, 355000, 35500, 0, 'I498', 'P498'), -- P498 Eucalyptus Clear EDP, 10% desc
('D499', 1, 230000, 46000, 0, 'I499', 'P499'), -- P499 Tea Tree Pure EDT, 20% desc
('D500', 2, 195000, 0, 0, 'I500', 'P500'); -- P500 Lemon Zest EDC