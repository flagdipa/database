-- ============================================================================
-- ESTRUCTURA UNIFICADA DE BASE DE DATOS PARA SISTEMA DE FINANZAS PERSONALES
-- Versión consolidada que incluye todas las actualizaciones (v0-v21)
-- ============================================================================

-- Describir ACCOUNTLIST_V1 (Lista de Cuentas)
CREATE TABLE ACCOUNTLIST_V1(
ACCOUNTID integer primary key
, ACCOUNTNAME TEXT COLLATE NOCASE NOT NULL UNIQUE
, ACCOUNTTYPE TEXT NOT NULL /* Efectivo, Caja de Ahorro, Cuenta Corriente, Plazo Fijo, Inversión, Tarjeta de Crédito, Préstamo, Activo, Acciones */
, ACCOUNTNUM TEXT
, STATUS TEXT NOT NULL /* Abierta, Cerrada */
, NOTES TEXT
, HELDAT TEXT
, WEBSITE TEXT
, CONTACTINFO TEXT
, ACCESSINFO TEXT
, INITIALBAL numeric
, INITIALDATE TEXT
, FAVORITEACCT TEXT NOT NULL
, CURRENCYID integer NOT NULL
, STATEMENTLOCKED integer
, STATEMENTDATE TEXT
, MINIMUMBALANCE numeric
, CREDITLIMIT numeric
, INTERESTRATE numeric
, PAYMENTDUEDATE text
, MINIMUMPAYMENT numeric
, ENTIDAD TEXT
, SUCURSAL TEXT
, CBU TEXT
, ALIAS TEXT
);
CREATE INDEX IDX_ACCOUNTLIST_ACCOUNTTYPE ON ACCOUNTLIST_V1(ACCOUNTTYPE);

-- Describir ASSETS_V1 (Activos)
CREATE TABLE ASSETS_V1(
ASSETID integer primary key
, STARTDATE TEXT NOT NULL
, ASSETNAME TEXT COLLATE NOCASE NOT NULL
, ASSETSTATUS TEXT /* Abierto, Cerrado */
, CURRENCYID integer
, VALUECHANGEMODE TEXT /* Porcentaje, Lineal */
, VALUE numeric
, VALUECHANGE TEXT /* Ninguno, Se Aprecia, Se Deprecia */
, NOTES TEXT
, VALUECHANGERATE numeric
, ASSETTYPE TEXT /* Propiedad, Automóvil, Objeto del Hogar, Arte, Joyería, Efectivo, Otro */
);
CREATE INDEX IDX_ASSETS_ASSETTYPE ON ASSETS_V1(ASSETTYPE);

-- Describir BILLSDEPOSITS_V1 (Facturas y Depósitos Programados)
CREATE TABLE BILLSDEPOSITS_V1(
BDID integer primary key
, ACCOUNTID integer NOT NULL
, TOACCOUNTID integer
, PAYEEID integer NOT NULL
, TRANSCODE TEXT NOT NULL /* Retiro, Depósito, Transferencia */
, TRANSAMOUNT numeric NOT NULL
, STATUS TEXT /* Ninguno, Conciliado, Anulado, Seguimiento, Duplicado */
, TRANSACTIONNUMBER TEXT
, NOTES TEXT
, CATEGID integer
, TRANSDATE TEXT
, FOLLOWUPID integer
, TOTRANSAMOUNT numeric
, REPEATS integer
, NEXTOCCURRENCEDATE TEXT
, NUMOCCURRENCES integer
, COLOR integer DEFAULT -1
);
CREATE INDEX IDX_BILLSDEPOSITS_ACCOUNT ON BILLSDEPOSITS_V1 (ACCOUNTID, TOACCOUNTID);

-- Describir BUDGETSPLITTRANSACTIONS_V1 (Transacciones Divididas de Presupuesto)
CREATE TABLE BUDGETSPLITTRANSACTIONS_V1(
SPLITTRANSID integer primary key
, TRANSID integer NOT NULL
, CATEGID integer
, SPLITTRANSAMOUNT numeric
, NOTES TEXT
);
CREATE INDEX IDX_BUDGETSPLITTRANSACTIONS_TRANSID ON BUDGETSPLITTRANSACTIONS_V1(TRANSID);

-- Describir BUDGETTABLE_V1 (Tabla de Presupuesto)
CREATE TABLE BUDGETTABLE_V1(
BUDGETENTRYID integer primary key
, BUDGETYEARID integer
, CATEGID integer
, PERIOD TEXT NOT NULL /* Ninguno, Semanal, Quincenal, Mensual, Bimestral, Trimestral, Semestral, Anual, Diario */
, AMOUNT numeric NOT NULL
, NOTES TEXT
, ACTIVE integer
);
CREATE INDEX IDX_BUDGETTABLE_BUDGETYEARID ON BUDGETTABLE_V1(BUDGETYEARID);

-- Describir BUDGETYEAR_V1 (Año de Presupuesto)
CREATE TABLE BUDGETYEAR_V1(
BUDGETYEARID integer primary key
, BUDGETYEARNAME TEXT NOT NULL UNIQUE
);
CREATE INDEX IDX_BUDGETYEAR_BUDGETYEARNAME ON BUDGETYEAR_V1(BUDGETYEARNAME);

-- Describir CATEGORY_V1 (Categorías)
CREATE TABLE CATEGORY_V1(
CATEGID INTEGER PRIMARY KEY
, CATEGNAME TEXT NOT NULL COLLATE NOCASE
, ACTIVE INTEGER
, PARENTID INTEGER
, UNIQUE(CATEGNAME, PARENTID)
);
CREATE INDEX IDX_CATEGORY_CATEGNAME ON CATEGORY_V1(CATEGNAME);
CREATE INDEX IDX_CATEGORY_CATEGNAME_PARENTID ON CATEGORY_V1(CATEGNAME, PARENTID);

-- Nota: Todas las cadenas que requieren traducción tienen el prefijo: '_tr_'
-- El prefijo _tr_ se elimina al generar archivos .h mediante sqlite2cpp.py
-- Las cadenas que contienen unicode no deben traducirse.
INSERT INTO CATEGORY_V1 VALUES(1,'_tr_Facturas',1,-1);
INSERT INTO CATEGORY_V1 VALUES(2,'_tr_Teléfono',1,1);
INSERT INTO CATEGORY_V1 VALUES(3,'_tr_Electricidad',1,1);
INSERT INTO CATEGORY_V1 VALUES(4,'_tr_Gas',1,1);
INSERT INTO CATEGORY_V1 VALUES(5,'_tr_Internet',1,1);
INSERT INTO CATEGORY_V1 VALUES(6,'_tr_Alquiler',1,1);
INSERT INTO CATEGORY_V1 VALUES(7,'_tr_TV por Cable',1,1);
INSERT INTO CATEGORY_V1 VALUES(8,'_tr_Agua',1,1);
INSERT INTO CATEGORY_V1 VALUES(9,'_tr_Alimentos',1,-1);
INSERT INTO CATEGORY_V1 VALUES(10,'_tr_Supermercado',1,9);
INSERT INTO CATEGORY_V1 VALUES(11,'_tr_Restaurantes',1,9);
INSERT INTO CATEGORY_V1 VALUES(12,'_tr_Ocio',1,-1);
INSERT INTO CATEGORY_V1 VALUES(13,'_tr_Cine',1,12);
INSERT INTO CATEGORY_V1 VALUES(14,'_tr_Alquiler de Videos',1,12);
INSERT INTO CATEGORY_V1 VALUES(15,'_tr_Revistas',1,12);
INSERT INTO CATEGORY_V1 VALUES(16,'_tr_Automóvil',1,-1);
INSERT INTO CATEGORY_V1 VALUES(17,'_tr_Mantenimiento',1,16);
INSERT INTO CATEGORY_V1 VALUES(18,'_tr_Combustible',1,16);
INSERT INTO CATEGORY_V1 VALUES(19,'_tr_Estacionamiento',1,16);
INSERT INTO CATEGORY_V1 VALUES(20,'_tr_Registro',1,16);
INSERT INTO CATEGORY_V1 VALUES(21,'_tr_Educación',1,-1);
INSERT INTO CATEGORY_V1 VALUES(22,'_tr_Libros',1,21);
INSERT INTO CATEGORY_V1 VALUES(23,'_tr_Matrícula',1,21);
INSERT INTO CATEGORY_V1 VALUES(24,'_tr_Otros',1,21);
INSERT INTO CATEGORY_V1 VALUES(25,'_tr_Necesidades del Hogar',1,-1);
INSERT INTO CATEGORY_V1 VALUES(26,'_tr_Ropa',1,25);
INSERT INTO CATEGORY_V1 VALUES(27,'_tr_Muebles',1,25);
INSERT INTO CATEGORY_V1 VALUES(28,'_tr_Otros',1,25);
INSERT INTO CATEGORY_V1 VALUES(29,'_tr_Salud',1,-1);
INSERT INTO CATEGORY_V1 VALUES(30,'_tr_Salud',1,29);
INSERT INTO CATEGORY_V1 VALUES(31,'_tr_Dental',1,29);
INSERT INTO CATEGORY_V1 VALUES(32,'_tr_Oftalmología',1,29);
INSERT INTO CATEGORY_V1 VALUES(33,'_tr_Médico',1,29);
INSERT INTO CATEGORY_V1 VALUES(34,'_tr_Medicamentos',1,29);
INSERT INTO CATEGORY_V1 VALUES(35,'_tr_Seguros',1,-1);
INSERT INTO CATEGORY_V1 VALUES(36,'_tr_Automóvil',1,35);
INSERT INTO CATEGORY_V1 VALUES(37,'_tr_Vida',1,35);
INSERT INTO CATEGORY_V1 VALUES(38,'_tr_Hogar',1,35);
INSERT INTO CATEGORY_V1 VALUES(39,'_tr_Salud',1,35);
INSERT INTO CATEGORY_V1 VALUES(40,'_tr_Vacaciones',1,-1);
INSERT INTO CATEGORY_V1 VALUES(41,'_tr_Viajes',1,40);
INSERT INTO CATEGORY_V1 VALUES(42,'_tr_Alojamiento',1,40);
INSERT INTO CATEGORY_V1 VALUES(43,'_tr_Turismo',1,40);
INSERT INTO CATEGORY_V1 VALUES(44,'_tr_Impuestos',1,-1);
INSERT INTO CATEGORY_V1 VALUES(45,'_tr_Impuesto a las Ganancias',1,44);
INSERT INTO CATEGORY_V1 VALUES(46,'_tr_Impuesto Inmobiliario',1,44);
INSERT INTO CATEGORY_V1 VALUES(47,'_tr_Impuesto al Agua',1,44);
INSERT INTO CATEGORY_V1 VALUES(48,'_tr_Otros',1,44);
INSERT INTO CATEGORY_V1 VALUES(49,'_tr_Misceláneos',1,-1);
INSERT INTO CATEGORY_V1 VALUES(50,'_tr_Regalos',1,-1);
INSERT INTO CATEGORY_V1 VALUES(51,'_tr_Ingresos',1,-1);
INSERT INTO CATEGORY_V1 VALUES(52,'_tr_Salario',1,51);
INSERT INTO CATEGORY_V1 VALUES(53,'_tr_Reembolsos/Devoluciones',1,51);
INSERT INTO CATEGORY_V1 VALUES(54,'_tr_Ingresos por Inversiones',1,51);
INSERT INTO CATEGORY_V1 VALUES(55,'_tr_Otros Ingresos',1,-1);
INSERT INTO CATEGORY_V1 VALUES(56,'_tr_Otros Gastos',1,-1);
INSERT INTO CATEGORY_V1 VALUES(57,'_tr_Transferencia',1,-1);
INSERT INTO CATEGORY_V1 VALUES(58, '_tr_Inversión', 1, -1);
INSERT INTO CATEGORY_V1 VALUES(59, '_tr_Compra', 1, 58);           -- Compra
INSERT INTO CATEGORY_V1 VALUES(60, '_tr_Venta', 1, 58);            -- Venta
INSERT INTO CATEGORY_V1 VALUES(61, '_tr_Dividendo', 1, 58);        -- Dividendo
INSERT INTO CATEGORY_V1 VALUES(62, '_tr_Ganancias de Capital', 1, 58);  -- Ganancias de capital
INSERT INTO CATEGORY_V1 VALUES(63, '_tr_Comisiones de Corretaje', 1, 58); -- Comisiones de corretaje
INSERT INTO CATEGORY_V1 VALUES(64, '_tr_Interés', 1, 58);          -- Interés de inversión
INSERT INTO CATEGORY_V1 VALUES(65, '_tr_Impuestos', 1, 58);        -- Impuestos de inversión
INSERT INTO CATEGORY_V1 VALUES(66, '_tr_División', 1, 58);         -- División de acciones
INSERT INTO CATEGORY_V1 VALUES(67, '_tr_Fusión', 1, 58);           -- Fusión de acciones
INSERT INTO CATEGORY_V1 VALUES(68, '_tr_Calopes', 1, -1);
INSERT INTO CATEGORY_V1 VALUES(69, '_tr_Consorcio CAL', 1, -1);
INSERT INTO CATEGORY_V1 VALUES(70, '_tr_Echauri', 1, -1);
INSERT INTO CATEGORY_V1 VALUES(71, '_tr_Hobbies', 1, -1);
INSERT INTO CATEGORY_V1 VALUES(72, '_tr_Mutual Mujica', 1, -1);
INSERT INTO CATEGORY_V1 VALUES(73, '_tr_Jardines de la Estancia', 1, -1);
INSERT INTO CATEGORY_V1 VALUES(74, '_tr_Otros Ingresos', 1, -1);
INSERT INTO CATEGORY_V1 VALUES(75, '_tr_Papercor', 1, -1);
INSERT INTO CATEGORY_V1 VALUES(76, '_tr_Regalos', 1, -1);
INSERT INTO CATEGORY_V1 VALUES(77, '_tr_Seguro', 1, -1);
INSERT INTO CATEGORY_V1 VALUES(78, '_tr_Varios', 1, -1);

-- Subcategorías de Alimentos (PARENTID=9)
INSERT INTO CATEGORY_V1 VALUES(79, '_tr_Almuerzo trabajo', 1, 9);
INSERT INTO CATEGORY_V1 VALUES(80, '_tr_Bar', 1, 9);
INSERT INTO CATEGORY_V1 VALUES(81, '_tr_Café', 1, 9);
INSERT INTO CATEGORY_V1 VALUES(82, '_tr_Carnicería', 1, 9);
INSERT INTO CATEGORY_V1 VALUES(83, '_tr_Delivery', 1, 9);
INSERT INTO CATEGORY_V1 VALUES(84, '_tr_Desconocido', 1, 9);
INSERT INTO CATEGORY_V1 VALUES(85, '_tr_Despensa', 1, 9);
INSERT INTO CATEGORY_V1 VALUES(86, '_tr_Heladería', 1, 9);
INSERT INTO CATEGORY_V1 VALUES(87, '_tr_Kiosco', 1, 9);
INSERT INTO CATEGORY_V1 VALUES(88, '_tr_Panadería', 1, 9);
INSERT INTO CATEGORY_V1 VALUES(89, '_tr_Pedido', 1, 9);
INSERT INTO CATEGORY_V1 VALUES(90, '_tr_Pizzería', 1, 9);
INSERT INTO CATEGORY_V1 VALUES(91, '_tr_Regalo (Alimentos)', 1, 9);
INSERT INTO CATEGORY_V1 VALUES(92, '_tr_Restaurant', 1, 9);
INSERT INTO CATEGORY_V1 VALUES(93, '_tr_Supermercado', 1, 9);
INSERT INTO CATEGORY_V1 VALUES(94, '_tr_Varios (Alimentos)', 1, 9);
INSERT INTO CATEGORY_V1 VALUES(95, '_tr_Verdulería', 1, 9);

-- Subcategorías de Automóvil (PARENTID=16)
INSERT INTO CATEGORY_V1 VALUES(96, '_tr_Estacionamiento', 1, 16);
INSERT INTO CATEGORY_V1 VALUES(97, '_tr_GNC (Automóvil)', 1, 16);
INSERT INTO CATEGORY_V1 VALUES(98, '_tr_Lavadero', 1, 16);
INSERT INTO CATEGORY_V1 VALUES(99, '_tr_Licencia de conducir', 1, 16);
INSERT INTO CATEGORY_V1 VALUES(100, '_tr_Mantenimiento (Automóvil)', 1, 16);
INSERT INTO CATEGORY_V1 VALUES(101, '_tr_Multa', 1, 16);
INSERT INTO CATEGORY_V1 VALUES(102, '_tr_Nafta (Automóvil)', 1, 16);
INSERT INTO CATEGORY_V1 VALUES(103, '_tr_Patente', 1, 16);
INSERT INTO CATEGORY_V1 VALUES(104, '_tr_Peaje (Automóvil)', 1, 16);
INSERT INTO CATEGORY_V1 VALUES(105, '_tr_Registración', 1, 16);
INSERT INTO CATEGORY_V1 VALUES(106, '_tr_Repuestos', 1, 16);
INSERT INTO CATEGORY_V1 VALUES(107, '_tr_Seguro (Automóvil)', 1, 16);
INSERT INTO CATEGORY_V1 VALUES(108, '_tr_Venta', 1, 16);

-- Subcategorías de Calopes (PARENTID=68)
INSERT INTO CATEGORY_V1 VALUES(109, '_tr_Agua (calopes)', 1, 68);
INSERT INTO CATEGORY_V1 VALUES(110, '_tr_Alquiler (calopes)', 1, 68);
INSERT INTO CATEGORY_V1 VALUES(111, '_tr_Decoración', 1, 68);
INSERT INTO CATEGORY_V1 VALUES(112, '_tr_Electricidad (calopes)', 1, 68);
INSERT INTO CATEGORY_V1 VALUES(113, '_tr_Equipamiento', 1, 68);
INSERT INTO CATEGORY_V1 VALUES(114, '_tr_Expensas (calopes)', 1, 68);
INSERT INTO CATEGORY_V1 VALUES(115, '_tr_Gas (calopes)', 1, 68);
INSERT INTO CATEGORY_V1 VALUES(116, '_tr_Jardín', 1, 68);
INSERT INTO CATEGORY_V1 VALUES(117, '_tr_Limpieza (calopes)', 1, 68);
INSERT INTO CATEGORY_V1 VALUES(118, '_tr_Mantenimiento', 1, 68);
INSERT INTO CATEGORY_V1 VALUES(119, '_tr_Municipal (calopes)', 1, 68);
INSERT INTO CATEGORY_V1 VALUES(120, '_tr_Rentas (calopes)', 1, 68);
INSERT INTO CATEGORY_V1 VALUES(121, '_tr_Teléfono varios', 1, 68);

-- Subcategorías de Consorcio CAL (PARENTID=69)
INSERT INTO CATEGORY_V1 VALUES(122, '_tr_Expensas (consorcio CAL)', 1, 69);
INSERT INTO CATEGORY_V1 VALUES(123, '_tr_Limpieza (consorcio CAL)', 1, 69);
INSERT INTO CATEGORY_V1 VALUES(124, '_tr_Mantenimiento (consorcio CAL)', 1, 69);
INSERT INTO CATEGORY_V1 VALUES(125, '_tr_Matafuegos', 1, 69);
INSERT INTO CATEGORY_V1 VALUES(126, '_tr_Seguro (consorcio CAL)', 1, 69);

-- Subcategorías de Echauri (PARENTID=70)
INSERT INTO CATEGORY_V1 VALUES(127, '_tr_Agua (Echauri)', 1, 70);
INSERT INTO CATEGORY_V1 VALUES(128, '_tr_Alquiler (Echauri)', 1, 70);
INSERT INTO CATEGORY_V1 VALUES(129, '_tr_Electricidad (Echauri)', 1, 70);
INSERT INTO CATEGORY_V1 VALUES(130, '_tr_Gas (Echauri)', 1, 70);
INSERT INTO CATEGORY_V1 VALUES(131, '_tr_Honorarios (Echauri)', 1, 70);
INSERT INTO CATEGORY_V1 VALUES(132, '_tr_Mantenimiento municipal (Echauri)', 1, 70);
INSERT INTO CATEGORY_V1 VALUES(133, '_tr_Rentas (Echauri)', 1, 70);
INSERT INTO CATEGORY_V1 VALUES(134, '_tr_Seguro (Echauri)', 1, 70);

-- Subcategorías de Educación (PARENTID=21)
INSERT INTO CATEGORY_V1 VALUES(135, '_tr_Libros', 1, 21);
INSERT INTO CATEGORY_V1 VALUES(136, '_tr_Matrícula', 1, 21);
INSERT INTO CATEGORY_V1 VALUES(137, '_tr_Otros (Educación)', 1, 21);

-- Subcategorías de Hobbies (PARENTID=71)
INSERT INTO CATEGORY_V1 VALUES(138, '_tr_Electrónica', 1, 71);
INSERT INTO CATEGORY_V1 VALUES(139, '_tr_Componentes', 1, 71);

-- Subcategorías de Impuestos (PARENTID=44)
INSERT INTO CATEGORY_V1 VALUES(140, '_tr_Impuesto país', 1, 44);
INSERT INTO CATEGORY_V1 VALUES(141, '_tr_Otros RG 4815', 1, 44);
INSERT INTO CATEGORY_V1 VALUES(142, '_tr_Bienes personales', 1, 44);
INSERT INTO CATEGORY_V1 VALUES(143, '_tr_Ganancias', 1, 44);
INSERT INTO CATEGORY_V1 VALUES(144, '_tr_Ingresos', 1, 44);
INSERT INTO CATEGORY_V1 VALUES(145, '_tr_Interés', 1, 44);
INSERT INTO CATEGORY_V1 VALUES(146, '_tr_Salario', 1, 44);
INSERT INTO CATEGORY_V1 VALUES(147, '_tr_Viáticos', 1, 44);

-- Subcategorías de Mutual Mujica (PARENTID=72)
INSERT INTO CATEGORY_V1 VALUES(148, '_tr_Mujita mujita', 1, 72);
INSERT INTO CATEGORY_V1 VALUES(149, '_tr_Cuota prohas I', 1, 72);
INSERT INTO CATEGORY_V1 VALUES(150, '_tr_Cuota prohas IV', 1, 72);
INSERT INTO CATEGORY_V1 VALUES(151, '_tr_Cuota social', 1, 72);

-- Subcategorías de Jardines de la Estancia (PARENTID=73)
INSERT INTO CATEGORY_V1 VALUES(152, '_tr_EPEC', 1, 73);
INSERT INTO CATEGORY_V1 VALUES(153, '_tr_Honorarios (Jardines de la Estancia)', 1, 73);
INSERT INTO CATEGORY_V1 VALUES(154, '_tr_Materiales', 1, 73);
INSERT INTO CATEGORY_V1 VALUES(155, '_tr_Trámites varios', 1, 73);

-- Subcategorías de Papercor (PARENTID=75)
INSERT INTO CATEGORY_V1 VALUES(156, '_tr_Facturas', 1, 75);
INSERT INTO CATEGORY_V1 VALUES(157, '_tr_Caja', 1, 75);
INSERT INTO CATEGORY_V1 VALUES(158, '_tr_Contador', 1, 75);
INSERT INTO CATEGORY_V1 VALUES(159, '_tr_Ingresos brutos', 1, 75);
INSERT INTO CATEGORY_V1 VALUES(160, '_tr_Internet', 1, 75);
INSERT INTO CATEGORY_V1 VALUES(161, '_tr_Monotributo', 1, 75);
INSERT INTO CATEGORY_V1 VALUES(162, '_tr_Pago a proveedores', 1, 75);
INSERT INTO CATEGORY_V1 VALUES(163, '_tr_Teléfonos', 1, 75);

-- Subcategorías de Regalos (PARENTID=76)
INSERT INTO CATEGORY_V1 VALUES(164, '_tr_Regalos', 1, 76);

-- Subcategorías de Salud (PARENTID=29)
INSERT INTO CATEGORY_V1 VALUES(165, '_tr_Dentista', 1, 29);
INSERT INTO CATEGORY_V1 VALUES(166, '_tr_Flevólogo', 1, 29);
INSERT INTO CATEGORY_V1 VALUES(167, '_tr_Hospital', 1, 29);
INSERT INTO CATEGORY_V1 VALUES(168, '_tr_Obra social', 1, 29);
INSERT INTO CATEGORY_V1 VALUES(169, '_tr_Oftalmólogo', 1, 29);
INSERT INTO CATEGORY_V1 VALUES(170, '_tr_Prescripción', 1, 29);
INSERT INTO CATEGORY_V1 VALUES(171, '_tr_Psicólogo', 1, 29);
INSERT INTO CATEGORY_V1 VALUES(172, '_tr_Psiquiatra', 1, 29);
INSERT INTO CATEGORY_V1 VALUES(173, '_tr_Quiropraxia', 1, 29);
INSERT INTO CATEGORY_V1 VALUES(174, '_tr_Remedios', 1, 29);

-- Subcategorías de Seguro (PARENTID=77) - Nota: Originalmente listadas como PARENTID=1, corregido a 77
INSERT INTO CATEGORY_V1 VALUES(175, '_tr_Auto (Seguro)', 1, 77);
INSERT INTO CATEGORY_V1 VALUES(176, '_tr_Casa (Seguro)', 1, 77);
INSERT INTO CATEGORY_V1 VALUES(177, '_tr_Vida (Seguro)', 1, 77);

-- Subcategorías de Transporte (PARENTID=68) - Nota: Listadas bajo calopes en el original
INSERT INTO CATEGORY_V1 VALUES(178, '_tr_Aéreo', 1, 68);
INSERT INTO CATEGORY_V1 VALUES(179, '_tr_Bus', 1, 68);
INSERT INTO CATEGORY_V1 VALUES(180, '_tr_Metro', 1, 68);
INSERT INTO CATEGORY_V1 VALUES(181, '_tr_Micro', 1, 68);
INSERT INTO CATEGORY_V1 VALUES(182, '_tr_Taxi', 1, 68);
INSERT INTO CATEGORY_V1 VALUES(183, '_tr_Tren', 1, 68);

-- Subcategorías de Vacaciones (PARENTID=40)
INSERT INTO CATEGORY_V1 VALUES(184, '_tr_Alojamiento', 1, 40);
INSERT INTO CATEGORY_V1 VALUES(185, '_tr_Comida', 1, 40);
INSERT INTO CATEGORY_V1 VALUES(186, '_tr_GNC (Vacaciones)', 1, 40);
INSERT INTO CATEGORY_V1 VALUES(187, '_tr_Nafta (Vacaciones)', 1, 40);
INSERT INTO CATEGORY_V1 VALUES(188, '_tr_Paseo', 1, 40);
INSERT INTO CATEGORY_V1 VALUES(189, '_tr_Pases', 1, 40);
INSERT INTO CATEGORY_V1 VALUES(190, '_tr_Peaje (Vacaciones)', 1, 40);
INSERT INTO CATEGORY_V1 VALUES(191, '_tr_Viaje', 1, 40)

-- Describir CHECKINGACCOUNT_V1 (Cuenta Corriente/Transacciones)
CREATE TABLE CHECKINGACCOUNT_V1(
TRANSID integer primary key
, ACCOUNTID integer NOT NULL
, TOACCOUNTID integer
, PAYEEID integer NOT NULL
, TRANSCODE TEXT NOT NULL /* Retiro, Depósito, Transferencia */
, TRANSAMOUNT numeric NOT NULL
, STATUS TEXT /* Ninguno, Conciliado, Anulado, Seguimiento, Duplicado */
, TRANSACTIONNUMBER TEXT
, NOTES TEXT
, CATEGID integer
, TRANSDATE TEXT
, LASTUPDATEDTIME TEXT
, DELETEDTIME TEXT
, FOLLOWUPID integer
, TOTRANSAMOUNT numeric
, COLOR integer DEFAULT -1
);
CREATE INDEX IDX_CHECKINGACCOUNT_ACCOUNT ON CHECKINGACCOUNT_V1 (ACCOUNTID, TOACCOUNTID);
CREATE INDEX IDX_CHECKINGACCOUNT_TRANSDATE ON CHECKINGACCOUNT_V1 (TRANSDATE);

-- Describir CURRENCYHISTORY_V1 (Historial de Monedas)
CREATE TABLE CURRENCYHISTORY_V1(
CURRHISTID INTEGER PRIMARY KEY
, CURRENCYID INTEGER NOT NULL
, CURRDATE TEXT NOT NULL
, CURRVALUE NUMERIC NOT NULL
, CURRUPDTYPE INTEGER
, UNIQUE(CURRENCYID, CURRDATE)
);
CREATE INDEX IDX_CURRENCYHISTORY_CURRENCYID_CURRDATE ON CURRENCYHISTORY_V1(CURRENCYID, CURRDATE);

-- Describir CURRENCYFORMATS_V1 (Formatos de Moneda)
CREATE TABLE CURRENCYFORMATS_V1(
CURRENCYID integer primary key
, CURRENCYNAME TEXT COLLATE NOCASE NOT NULL UNIQUE
, PFX_SYMBOL TEXT
, SFX_SYMBOL TEXT
, DECIMAL_POINT TEXT
, GROUP_SEPARATOR TEXT
, UNIT_NAME TEXT COLLATE NOCASE
, CENT_NAME TEXT COLLATE NOCASE
, SCALE integer
, BASECONVRATE numeric
, CURRENCY_SYMBOL TEXT COLLATE NOCASE NOT NULL UNIQUE
, CURRENCY_TYPE TEXT NOT NULL /* Fiat, Crypto */
);
CREATE INDEX IDX_CURRENCYFORMATS_SYMBOL ON CURRENCYFORMATS_V1(CURRENCY_SYMBOL);

-- Nota: Todas las cadenas que requieren traducción tienen el prefijo: '_tr_'
-- El prefijo _tr_ se elimina al generar archivos .h mediante sqlite2cpp.py
-- Las cadenas que contienen unicode no deben traducirse.
INSERT INTO CURRENCYFORMATS_V1 VALUES(1,'_tr_Dólar estadounidense','$','','.',',','Dólar','Centavo',100,1,'USD','Fiat');
INSERT INTO CURRENCYFORMATS_V1 VALUES(2,'_tr_Euro','€','','.',' ','','',100,1,'EUR','Fiat');
INSERT INTO CURRENCYFORMATS_V1 VALUES(3,'_tr_Libra esterlina','£','','.',' ','Libra','Penique',100,1,'GBP','Fiat');
INSERT INTO CURRENCYFORMATS_V1 VALUES(4,'_tr_Rublo ruso','','р',',',' ','руб.','коп.',100,1,'RUB','Fiat');
INSERT INTO CURRENCYFORMATS_V1 VALUES(5,'_tr_Grivna ucraniana','₴','',',',' ','','',100,1,'UAH','Fiat');
INSERT INTO CURRENCYFORMATS_V1 VALUES(6,'_tr_Afgani afgano','؋','','.',' ','','pul',100,1,'AFN','Fiat');
INSERT INTO CURRENCYFORMATS_V1 VALUES(7,'_tr_Lek albanés','','L','.',' ','','',1,1,'ALL','Fiat');
INSERT INTO CURRENCYFORMATS_V1 VALUES(8,'_tr_Dinar argelino','دج','','.',' ','','',100,1,'DZD','Fiat');
INSERT INTO CURRENCYFORMATS_V1 VALUES(9,'_tr_Kwanza angoleño','','Kz','.',' ','','Céntimo',100,1,'AOA','Fiat');
INSERT INTO CURRENCYFORMATS_V1 VALUES(10,'_tr_Dólar del Caribe Oriental','EC$','','.',' ','','',100,1,'XCD','Fiat');
INSERT INTO CURRENCYFORMATS_V1 VALUES(11,'_tr_Peso argentino','AR$','',',','.','','centavo',100,1,'ARS','Fiat');
INSERT INTO CURRENCYFORMATS_V1 VALUES(12,'_tr_Dram armenio','','','.',' ','','',1,1,'AMD','Fiat');
INSERT INTO CURRENCYFORMATS_V1 VALUES(13,'_tr_Florín arubeño','ƒ','','.',' ','','',100,1,'AWG','Fiat');
INSERT INTO CURRENCYFORMATS_V1 VALUES(14,'_tr_Dólar australiano','$','','.',',','','',100,1,'AUD','Fiat');
INSERT INTO CURRENCYFORMATS_V1 VALUES(15,'_tr_Manat azerbaiyano','','','.',' ','','',100,1,'AZN','Fiat');
INSERT INTO CURRENCYFORMATS_V1 VALUES(16,'_tr_Dólar bahameño','B$','','.',' ','','',100,1,'BSD','Fiat');
INSERT INTO CURRENCYFORMATS_V1 VALUES(17,'_tr_Dinar bareiní','','','.',' ','','',100,1,'BHD','Fiat');
INSERT INTO CURRENCYFORMATS_V1 VALUES(18,'_tr_Taka bangladesí','','','.',' ','','',100,1,'BDT','Fiat');
INSERT INTO CURRENCYFORMATS_V1 VALUES(19,'_tr_Dólar de Barbados','Bds$','','.',' ','','',100,1,'BBD','Fiat');
INSERT INTO CURRENCYFORMATS_V1 VALUES(20,'_tr_Rublo bielorruso (2000-2016)','Br','',',',' ','','',1,1,'BYR','Fiat');
INSERT INTO CURRENCYFORMATS_V1 VALUES(21,'_tr_Dólar beliceño','BZ$','','.',' ','','',100,1,'BZD','Fiat');
INSERT INTO CURRENCYFORMATS_V1 VALUES(22,'_tr_Franco CFA de África Occidental','CFA','','.',' ','','',100,1,'XOF','Fiat');
INSERT INTO CURRENCYFORMATS_V1 VALUES(23,'_tr_Dólar bermudeño','BD$','','.',' ','','',100,1,'BMD','Fiat');
INSERT INTO CURRENCYFORMATS_V1 VALUES(24,'_tr_Ngultrum butanés','Nu.','','.',' ','','',100,1,'BTN','Fiat');
INSERT INTO CURRENCYFORMATS_V1 VALUES(25,'_tr_Boliviano','Bs.','','.',' ','','',100,1,'BOB','Fiat');
INSERT INTO CURRENCYFORMATS_V1 VALUES(26,'_tr_Marco convertible de Bosnia-Herzegovina','KM','',',','.','','',100,1,'BAM','Fiat');
INSERT INTO CURRENCYFORMATS_V1 VALUES(27,'_tr_Pula de Botsuana','P','','.',' ','','',100,1,'BWP','Fiat');
INSERT INTO CURRENCYFORMATS_V1 VALUES(28,'_tr_Real brasileño','R$','','.',' ','','',100,1,'BRL','Fiat');
INSERT INTO CURRENCYFORMATS_V1 VALUES(29,'_tr_Dólar de Brunéi','B$','','.',' ','','',100,1,'BND','Fiat');
INSERT INTO CURRENCYFORMATS_V1 VALUES(30,'_tr_Lev búlgaro','','','.',' ','','',100,1,'BGN','Fiat');
INSERT INTO CURRENCYFORMATS_V1 VALUES(31,'_tr_Franco burundés','FBu','','.',' ','','',1,1,'BIF','Fiat');
INSERT INTO CURRENCYFORMATS_V1 VALUES(32,'_tr_Riel camboyano','','','.',' ','','',100,1,'KHR','Fiat');
INSERT INTO CURRENCYFORMATS_V1 VALUES(33,'_tr_Franco CFA de África Central','CFA','','.',' ','','',1,1,'XAF','Fiat');
INSERT INTO CURRENCYFORMATS_V1 VALUES(34,'_tr_Dólar canadiense','$','','.',' ','','',100,1,'CAD','Fiat');
INSERT INTO CURRENCYFORMATS_V1 VALUES(35,'_tr_Escudo caboverdiano','Esc','','.',' ','','',100,1,'CVE','Fiat');
INSERT INTO CURRENCYFORMATS_V1 VALUES(36,'_tr_Dólar de las Islas Caimán','KY$','','.',' ','','',100,1,'KYD','Fiat');
INSERT INTO CURRENCYFORMATS_V1 VALUES(37,'_tr_Peso chileno','$','','.',' ','','',1,1,'CLP','Fiat');
INSERT INTO CURRENCYFORMATS_V1 VALUES(38,'_tr_Yuan chino','¥','','.',' ','','',100,1,'CNY','Fiat');
INSERT INTO CURRENCYFORMATS_V1 VALUES(39,'_tr_Peso colombiano','Col$','','.',' ','','',100,1,'COP','Fiat');
INSERT INTO CURRENCYFORMATS_V1 VALUES(40,'_tr_Franco comorense','','','.',' ','','',1,1,'KMF','Fiat');
INSERT INTO CURRENCYFORMATS_V1 VALUES(41,'_tr_Franco congoleño','F','','.',' ','','',100,1,'CDF','Fiat');
INSERT INTO CURRENCYFORMATS_V1 VALUES(42,'Colón costarricense','₡','','.',' ','','',1,1,'CRC','Fiat');
INSERT INTO CURRENCYFORMATS_V1 VALUES(43,'_tr_Kuna croata','kn','','.',' ','','',100,1,'HRK','Fiat');
INSERT INTO CURRENCYFORMATS_V1 VALUES(44,'_tr_Corona checa','Kč','','.',' ','','',100,1,'CZK','Fiat');
INSERT INTO CURRENCYFORMATS_V1 VALUES(45,'_tr_Corona danesa','Kr','','.',' ','','',100,1,'DKK','Fiat');
INSERT INTO CURRENCYFORMATS_V1 VALUES(46,'_tr_Franco yibutiano','Fdj','','.',' ','','',1,1,'DJF','Fiat');
INSERT INTO CURRENCYFORMATS_V1 VALUES(47,'_tr_Peso dominicano','RD$','','.',' ','','',100,1,'DOP','Fiat');
INSERT INTO CURRENCYFORMATS_V1 VALUES(48,'_tr_Libra egipcia','£','','.',' ','','',100,1,'EGP','Fiat');
INSERT INTO CURRENCYFORMATS_V1 VALUES(49,'_tr_Nakfa eritreo','Nfa','','.',' ','','',100,1,'ERN','Fiat');
INSERT INTO CURRENCYFORMATS_V1 VALUES(50,'_tr_Birr etíope','Br','','.',' ','','',100,1,'ETB','Fiat');
INSERT INTO CURRENCYFORMATS_V1 VALUES(51,'_tr_Libra de las Islas Malvinas','£','','.',' ','','',100,1,'FKP','Fiat');
INSERT INTO CURRENCYFORMATS_V1 VALUES(52,'_tr_Dólar fiyiano','FJ$','','.',' ','','',100,1,'FJD','Fiat');
INSERT INTO CURRENCYFORMATS_V1 VALUES(53,'_tr_Franco CFP','F','','.',' ','','',100,1,'XPF','Fiat');
INSERT INTO CURRENCYFORMATS_V1 VALUES(54,'_tr_Dalasi gambiano','D','','.',' ','','',100,1,'GMD','Fiat');
INSERT INTO CURRENCYFORMATS_V1 VALUES(55,'_tr_Lari georgiano','','','.',' ','','',100,1,'GEL','Fiat');
INSERT INTO CURRENCYFORMATS_V1 VALUES(56,'_tr_Cedi ghanés','','','.',' ','','',100,1,'GHS','Fiat');
INSERT INTO CURRENCYFORMATS_V1 VALUES(57,'_tr_Libra de Gibraltar','£','','.',' ','','',100,1,'GIP','Fiat');
INSERT INTO CURRENCYFORMATS_V1 VALUES(58,'_tr_Quetzal guatemalteco','Q','','.',' ','','',100,1,'GTQ','Fiat');
INSERT INTO CURRENCYFORMATS_V1 VALUES(59,'_tr_Franco guineano','FG','','.',' ','','',1,1,'GNF','Fiat');
INSERT INTO CURRENCYFORMATS_V1 VALUES(60,'_tr_Dólar guyanés','GY$','','.',' ','','',100,1,'GYD','Fiat');
INSERT INTO CURRENCYFORMATS_V1 VALUES(61,'_tr_Gourde haitiano','G','','.',' ','','',100,1,'HTG','Fiat');
INSERT INTO CURRENCYFORMATS_V1 VALUES(62,'_tr_Lempira hondureño','L','','.',' ','','',100,1,'HNL','Fiat');
INSERT INTO CURRENCYFORMATS_V1 VALUES(63,'_tr_Dólar de Hong Kong','HK$','','.',' ','','',100,1,'HKD','Fiat');
INSERT INTO CURRENCYFORMATS_V1 VALUES(64,'_tr_Forinto húngaro','','Ft','.',' ','','',1,1,'HUF','Fiat');
INSERT INTO CURRENCYFORMATS_V1 VALUES(65,'Corona islandesa','kr','','.',' ','','',1,1,'ISK','Fiat');
INSERT INTO CURRENCYFORMATS_V1 VALUES(66,'_tr_Rupia india','₹','','.',' ','','',100,1,'INR','Fiat');
INSERT INTO CURRENCYFORMATS_V1 VALUES(67,'_tr_Rupia indonesia','Rp','','.',' ','','',1,1,'IDR','Fiat');
INSERT INTO CURRENCYFORMATS_V1 VALUES(68,'_tr_Derechos especiales de giro','SDR','','.',' ','','',100,1,'XDR','Fiat');
INSERT INTO CURRENCYFORMATS_V1 VALUES(69,'_tr_Rial iraní','','','.',' ','','',1,1,'IRR','Fiat');
INSERT INTO CURRENCYFORMATS_V1 VALUES(70,'_tr_Dinar iraquí','','','.',' ','','',1,1,'IQD','Fiat');
INSERT INTO CURRENCYFORMATS_V1 VALUES(71,'_tr_Nuevo séquel israelí','₪','','.',' ','','',100,1,'ILS','Fiat');
INSERT INTO CURRENCYFORMATS_V1 VALUES(72,'_tr_Dólar jamaiquino','J$','','.',' ','','',100,1,'JMD','Fiat');
INSERT INTO CURRENCYFORMATS_V1 VALUES(73,'_tr_Yen japonés','¥','','.',' ','','',1,1,'JPY','Fiat');
INSERT INTO CURRENCYFORMATS_V1 VALUES(74,'_tr_Dinar jordano','','','.',' ','','',100,1,'JOD','Fiat');
INSERT INTO CURRENCYFORMATS_V1 VALUES(75,'_tr_Tenge kazajo','T','','.',' ','','',100,1,'KZT','Fiat');
INSERT INTO CURRENCYFORMATS_V1 VALUES(76,'_tr_Chelín keniano','KSh','','.',' ','','',100,1,'KES','Fiat');
INSERT INTO CURRENCYFORMATS_V1 VALUES(77,'_tr_Won norcoreano','W','','.',' ','','',100,1,'KPW','Fiat');
INSERT INTO CURRENCYFORMATS_V1 VALUES(78,'_tr_Won surcoreano','W','','.',' ','','',1,1,'KRW','Fiat');
INSERT INTO CURRENCYFORMATS_V1 VALUES(79,'_tr_Dinar kuwaití','','','.',' ','','',100,1,'KWD','Fiat');
INSERT INTO CURRENCYFORMATS_V1 VALUES(80,'_tr_Som kirguís','','','.',' ','','',100,1,'KGS','Fiat');
INSERT INTO CURRENCYFORMATS_V1 VALUES(81,'_tr_Kip laosiano','KN','','.',' ','','',100,1,'LAK','Fiat');
INSERT INTO CURRENCYFORMATS_V1 VALUES(82,'_tr_Lats letón','Ls','','.',' ','','',100,1,'LVL','Fiat');
INSERT INTO CURRENCYFORMATS_V1 VALUES(83,'_tr_Libra libanesa','','','.',' ','','',1,1,'LBP','Fiat');
INSERT INTO CURRENCYFORMATS_V1 VALUES(84,'_tr_Loti de Lesoto','M','','.',' ','','',100,1,'LSL','Fiat');
INSERT INTO CURRENCYFORMATS_V1 VALUES(85,'_tr_Dólar liberiano','L$','','.',' ','','',100,1,'LRD','Fiat');
INSERT INTO CURRENCYFORMATS_V1 VALUES(86,'_tr_Dinar libio','LD','','.',' ','','',100,1,'LYD','Fiat');
INSERT INTO CURRENCYFORMATS_V1 VALUES(87,'_tr_Litas lituano','Lt','','.',' ','','',100,1,'LTL','Fiat');
INSERT INTO CURRENCYFORMATS_V1 VALUES(88,'_tr_Pataca de Macao','P','','.',' ','','',100,1,'MOP','Fiat');
INSERT INTO CURRENCYFORMATS_V1 VALUES(89,'_tr_Denar macedonio','','','.',' ','','',100,1,'MKD','Fiat');
INSERT INTO CURRENCYFORMATS_V1 VALUES(90,'_tr_Ariary malgache','FMG','','.',' ','','',100,1,'MGA','Fiat');
INSERT INTO CURRENCYFORMATS_V1 VALUES(91,'_tr_Kwacha malauí','MK','','.',' ','','',1,1,'MWK','Fiat');
INSERT INTO CURRENCYFORMATS_V1 VALUES(92,'_tr_Ringgit malayo','RM','','.',' ','','',100,1,'MYR','Fiat');
INSERT INTO CURRENCYFORMATS_V1 VALUES(93,'_tr_Rufiya maldiva','Rf','','.',' ','','',100,1,'MVR','Fiat');
INSERT INTO CURRENCYFORMATS_V1 VALUES(94,'_tr_Ouguiya mauritana (1973-2017)','UM','','.',' ','','',100,1,'MRO','Fiat');
INSERT INTO CURRENCYFORMATS_V1 VALUES(95,'_tr_Rupia mauriciana','Rs','','.',' ','','',1,1,'MUR','Fiat');
INSERT INTO CURRENCYFORMATS_V1 VALUES(96,'_tr_Peso mexicano','$','','.',' ','','',100,1,'MXN','Fiat');
INSERT INTO CURRENCYFORMATS_V1 VALUES(97,'_tr_Leu moldavo','','','.',' ','','',100,1,'MDL','Fiat');
INSERT INTO CURRENCYFORMATS_V1 VALUES(98,'_tr_Tugrik mongol','₮','','.',' ','','',100,1,'MNT','Fiat');
INSERT INTO CURRENCYFORMATS_V1 VALUES(99,'_tr_Dírham marroquí','','','.',' ','','',100,1,'MAD','Fiat');
INSERT INTO CURRENCYFORMATS_V1 VALUES(100,'_tr_Kyat birmano','K','','.',' ','','',1,1,'MMK','Fiat');
INSERT INTO CURRENCYFORMATS_V1 VALUES(101,'_tr_Dólar namibio','N$','','.',' ','','',100,1,'NAD','Fiat');
INSERT INTO CURRENCYFORMATS_V1 VALUES(102,'_tr_Rupia nepalí','NRs','','.',' ','','',100,1,'NPR','Fiat');
INSERT INTO CURRENCYFORMATS_V1 VALUES(103,'_tr_Florín antillano neerlandés','NAƒ','','.',' ','','',100,1,'ANG','Fiat');
INSERT INTO CURRENCYFORMATS_V1 VALUES(104,'_tr_Dólar neozelandés','NZ$','','.',' ','','',100,1,'NZD','Fiat');
INSERT INTO CURRENCYFORMATS_V1 VALUES(105,'Córdoba nicaragüense','C$','','.',' ','','',100,1,'NIO','Fiat');
INSERT INTO CURRENCYFORMATS_V1 VALUES(106,'_tr_Naira nigeriana','₦','','.',' ','','',100,1,'NGN','Fiat');
INSERT INTO CURRENCYFORMATS_V1 VALUES(107,'_tr_Corona noruega','kr','','.',' ','','',100,1,'NOK','Fiat');
INSERT INTO CURRENCYFORMATS_V1 VALUES(108,'_tr_Rial omaní','','','.',' ','','',100,1,'OMR','Fiat');
INSERT INTO CURRENCYFORMATS_V1 VALUES(109,'_tr_Rupia pakistaní','Rs.','','.',' ','','',1,1,'PKR','Fiat');
INSERT INTO CURRENCYFORMATS_V1 VALUES(110,'_tr_Balboa panameño','B./','','.',' ','','',100,1,'PAB','Fiat');
INSERT INTO CURRENCYFORMATS_V1 VALUES(111,'_tr_Kina de Papúa Nueva Guinea','K','','.',' ','','',100,1,'PGK','Fiat');
INSERT INTO CURRENCYFORMATS_V1 VALUES(112,'_tr_Guaraní paraguayo','','','.',' ','','',1,1,'PYG','Fiat');
INSERT INTO CURRENCYFORMATS_V1 VALUES(113,'_tr_Sol peruano','S/.','','.',' ','','',100,1,'PEN','Fiat');
INSERT INTO CURRENCYFORMATS_V1 VALUES(114,'_tr_Peso filipino','₱','','.',' ','','',100,1,'PHP','Fiat');
INSERT INTO CURRENCYFORMATS_V1 VALUES(115,'_tr_Złoty polaco','','zł',',','.','złoty','grosz',100,1,'PLN','Fiat');
INSERT INTO CURRENCYFORMATS_V1 VALUES(116,'_tr_Riyal qatarí','QR','','.',' ','','',100,1,'QAR','Fiat');
INSERT INTO CURRENCYFORMATS_V1 VALUES(117,'_tr_Leu rumano','L','','.',' ','','',100,1,'RON','Fiat');
INSERT INTO CURRENCYFORMATS_V1 VALUES(118,'_tr_Franco ruandés','RF','','.',' ','','',1,1,'RWF','Fiat');
INSERT INTO CURRENCYFORMATS_V1 VALUES(119,'Dobra de Santo Tomé y Príncipe (1977-2017)','Db','','.',' ','','',100,1,'STD','Fiat');
INSERT INTO CURRENCYFORMATS_V1 VALUES(120,'_tr_Riyal saudí','SR','','.',' ','','',100,1,'SAR','Fiat');
INSERT INTO CURRENCYFORMATS_V1 VALUES(121,'_tr_Dinar serbio','din.','','.',' ','','',1,1,'RSD','Fiat');
INSERT INTO CURRENCYFORMATS_V1 VALUES(122,'_tr_Rupia de Seychelles','SR','','.',' ','','',100,1,'SCR','Fiat');
INSERT INTO CURRENCYFORMATS_V1 VALUES(123,'_tr_Leone de Sierra Leona (1964-2022)','Le','','.',' ','','',100,1,'SLL','Fiat');
INSERT INTO CURRENCYFORMATS_V1 VALUES(124,'_tr_Dólar de Singapur','S$','','.',' ','','',100,1,'SGD','Fiat');
INSERT INTO CURRENCYFORMATS_V1 VALUES(125,'_tr_Dólar de las Islas Salomón','SI$','','.',' ','','',100,1,'SBD','Fiat');
INSERT INTO CURRENCYFORMATS_V1 VALUES(126,'_tr_Chelín somalí','Sh.','','.',' ','','',1,1,'SOS','Fiat');
INSERT INTO CURRENCYFORMATS_V1 VALUES(127,'_tr_Rand sudafricano','R','','.',' ','','',100,1,'ZAR','Fiat');
INSERT INTO CURRENCYFORMATS_V1 VALUES(128,'_tr_Rupia de Sri Lanka','Rs','','.',' ','','',100,1,'LKR','Fiat');
INSERT INTO CURRENCYFORMATS_V1 VALUES(129,'_tr_Libra de Santa Elena','£','','.',' ','','',100,1,'SHP','Fiat');
INSERT INTO CURRENCYFORMATS_V1 VALUES(130,'_tr_Libra sudanesa','','','.',' ','','',100,1,'SDG','Fiat');
INSERT INTO CURRENCYFORMATS_V1 VALUES(131,'_tr_Dólar surinamés','$','','.',' ','','',100,1,'SRD','Fiat');
INSERT INTO CURRENCYFORMATS_V1 VALUES(132,'_tr_Lilangeni suazi','E','','.',' ','','',100,1,'SZL','Fiat');
INSERT INTO CURRENCYFORMATS_V1 VALUES(133,'_tr_Corona sueca','kr','','.',' ','','',100,1,'SEK','Fiat');
INSERT INTO CURRENCYFORMATS_V1 VALUES(134,'_tr_Franco suizo','Fr.','','.',' ','','',100,1,'CHF','Fiat');
INSERT INTO CURRENCYFORMATS_V1 VALUES(135,'_tr_Libra siria','','','.',' ','','',1,1,'SYP','Fiat');
INSERT INTO CURRENCYFORMATS_V1 VALUES(136,'_tr_Nuevo dólar taiwanés','NT$','','.',' ','','',100,1,'TWD','Fiat');
INSERT INTO CURRENCYFORMATS_V1 VALUES(137,'_tr_Somoni tayiko','','','.',' ','','',100,1,'TJS','Fiat');
INSERT INTO CURRENCYFORMATS_V1 VALUES(138,'_tr_Chelín tanzano','','','.',' ','','',1,1,'TZS','Fiat');
INSERT INTO CURRENCYFORMATS_V1 VALUES(139,'_tr_Baht tailandés','฿','','.',' ','','',100,1,'THB','Fiat');
INSERT INTO CURRENCYFORMATS_V1 VALUES(140,'_tr_Dólar de Trinidad y Tobago','TT$','','.',' ','','',100,1,'TTD','Fiat');
INSERT INTO CURRENCYFORMATS_V1 VALUES(141,'_tr_Dinar tunecino','DT','','.',' ','','',100,1,'TND','Fiat');
INSERT INTO CURRENCYFORMATS_V1 VALUES(142,'_tr_Lira turca','₺','','.',' ','','',100,1,'TRY','Fiat');
INSERT INTO CURRENCYFORMATS_V1 VALUES(143,'_tr_Manat turcomano','m','','.',' ','','',100,1,'TMT','Fiat');
INSERT INTO CURRENCYFORMATS_V1 VALUES(144,'_tr_Chelín ugandés','USh','','.',' ','','',1,1,'UGX','Fiat');
INSERT INTO CURRENCYFORMATS_V1 VALUES(145,'_tr_Dírham de los Emiratos Árabes Unidos','','','.',' ','','',100,1,'AED','Fiat');
INSERT INTO CURRENCYFORMATS_V1 VALUES(146,'_tr_Peso uruguayo','$U','','.',' ','','',100,1,'UYU','Fiat');
INSERT INTO CURRENCYFORMATS_V1 VALUES(147,'_tr_Som uzbeko','','','.',' ','','',1,1,'UZS','Fiat');
INSERT INTO CURRENCYFORMATS_V1 VALUES(148,'_tr_Vatu vanuatuense','VT','','.',' ','','',100,1,'VUV','Fiat');
INSERT INTO CURRENCYFORMATS_V1 VALUES(149,'_tr_Dong vietnamita','₫','','.',' ','','',1,1,'VND','Fiat');
INSERT INTO CURRENCYFORMATS_V1 VALUES(150,'_tr_Tala samoana','WS$','','.',' ','','',100,1,'WST','Fiat');
INSERT INTO CURRENCYFORMATS_V1 VALUES(151,'_tr_Rial yemení','','','.',' ','','',1,1,'YER','Fiat');
INSERT INTO CURRENCYFORMATS_V1 VALUES(152,'Bolívar venezolano (2008-2018)','Bs.','','.',',','bolívar','céntimos',100,1,'VEF','Fiat');
INSERT INTO CURRENCYFORMATS_V1 VALUES(153,'_tr_Bitcoin','Ƀ','','.',',','','',100000000,1,'BTC','Crypto');
INSERT INTO CURRENCYFORMATS_V1 VALUES(154,'_tr_Rublo bielorruso','BYN','','.',',','','',100,1,'BYN','Fiat');
INSERT INTO CURRENCYFORMATS_V1 VALUES(155,'_tr_Peso convertible cubano','$','','.',',','','',100,1,'CUC','Fiat');
INSERT INTO CURRENCYFORMATS_V1 VALUES(156,'_tr_Peso cubano','$','','.',',','','',100,1,'CUP','Fiat');
INSERT INTO CURRENCYFORMATS_V1 VALUES(157,'_tr_Ouguiya mauritana','MRU','','.',',','','',100,1,'MRU','Fiat');
INSERT INTO CURRENCYFORMATS_V1 VALUES(158,'_tr_Metical mozambiqueño','MZN','','.',',','','',100,1,'MZN','Fiat');
INSERT INTO CURRENCYFORMATS_V1 VALUES(159,'_tr_Leone de Sierra Leona','SLE','','.',',','','',100,1,'SLE','Fiat');
INSERT INTO CURRENCYFORMATS_V1 VALUES(160,'_tr_Libra sursudanesa','£','','.',',','','',100,1,'SSP','Fiat');
INSERT INTO CURRENCYFORMATS_V1 VALUES(161,'Dobra de Santo Tomé y Príncipe','Db','','.',',','','',100,1,'STN','Fiat');
INSERT INTO CURRENCYFORMATS_V1 VALUES(162,'Colón salvadoreño','SVC','','.',',','','',100,1,'SVC','Fiat');
INSERT INTO CURRENCYFORMATS_V1 VALUES(163,'Paʻanga tongano','T$','','.',',','','',100,1,'TOP','Fiat');
INSERT INTO CURRENCYFORMATS_V1 VALUES(164,'_tr_Unidad de índice de salarios uruguaya','UYW','','.',',','','',10000,1,'UYW','Fiat');
INSERT INTO CURRENCYFORMATS_V1 VALUES(165,'Bolívar soberano','VED','','.',',','','',100,1,'VED','Fiat');
INSERT INTO CURRENCYFORMATS_V1 VALUES(166,'Bolívar venezolano','VES','','.',',','','',100,1,'VES','Fiat');
INSERT INTO CURRENCYFORMATS_V1 VALUES(167,'_tr_Kwacha zambiano','ZK','','.',',','','',100,1,'ZMW','Fiat');
INSERT INTO CURRENCYFORMATS_V1 VALUES(168,'_tr_Dólar zimbabuense (2009)','ZWL','','.',',','','',100,1,'ZWL','Fiat');

-- Describir INFOTABLE_V1 (Tabla de Información)
CREATE TABLE INFOTABLE_V1(
INFOID integer not null primary key
, INFONAME TEXT COLLATE NOCASE NOT NULL UNIQUE
, INFOVALUE TEXT NOT NULL
);
CREATE INDEX IDX_INFOTABLE_INFONAME ON INFOTABLE_V1(INFONAME);

INSERT INTO INFOTABLE_V1 VALUES(1, 'DATAVERSION', '3');

-- Describir PAYEE_V1 (Beneficiarios)
CREATE TABLE PAYEE_V1(
PAYEEID integer primary key
, PAYEENAME TEXT COLLATE NOCASE NOT NULL UNIQUE
, CATEGID integer
, NUMBER TEXT
, WEBSITE TEXT
, NOTES TEXT
, ACTIVE integer
, PATTERN TEXT DEFAULT ''
, DIRECCION TEXT
, CUIT TEXT
, ALIAS TEXT
, EMAIL TEXT
, TELEFONO TEXT
);
CREATE INDEX IDX_PAYEE_INFONAME ON PAYEE_V1(PAYEENAME);

-- Describir SPLITTRANSACTIONS_V1 (Transacciones Divididas)
CREATE TABLE SPLITTRANSACTIONS_V1(
SPLITTRANSID integer primary key
, TRANSID integer NOT NULL
, CATEGID integer
, SPLITTRANSAMOUNT numeric
, NOTES TEXT
);
CREATE INDEX IDX_SPLITTRANSACTIONS_TRANSID ON SPLITTRANSACTIONS_V1(TRANSID);

-- Describir STOCK_V1 (Acciones)
CREATE TABLE STOCK_V1(
STOCKID integer primary key
, HELDAT integer
, PURCHASEDATE TEXT NOT NULL
, STOCKNAME TEXT COLLATE NOCASE NOT NULL
, SYMBOL TEXT
, NUMSHARES numeric
, PURCHASEPRICE numeric NOT NULL
, NOTES TEXT
, CURRENTPRICE numeric NOT NULL
, VALUE numeric
, COMMISSION numeric
);
CREATE INDEX IDX_STOCK_HELDAT ON STOCK_V1(HELDAT);

-- Describir STOCKHISTORY_V1 (Historial de Acciones)
CREATE TABLE STOCKHISTORY_V1(
HISTID integer primary key
, SYMBOL TEXT NOT NULL
, DATE TEXT NOT NULL
, VALUE numeric NOT NULL
, UPDTYPE integer
, UNIQUE(SYMBOL, DATE)
);
CREATE INDEX IDX_STOCKHISTORY_SYMBOL ON STOCKHISTORY_V1(SYMBOL);

-- Describir SETTING_V1 (Configuraciones)
CREATE TABLE SETTING_V1(
SETTINGID integer not null primary key
, SETTINGNAME TEXT COLLATE NOCASE NOT NULL UNIQUE
, SETTINGVALUE TEXT
);
CREATE INDEX IDX_SETTING_SETTINGNAME ON SETTING_V1(SETTINGNAME);

-- Describir REPORT_V1 (Informes)
CREATE TABLE REPORT_V1(
REPORTID integer not null primary key
, REPORTNAME TEXT COLLATE NOCASE NOT NULL UNIQUE
, GROUPNAME TEXT COLLATE NOCASE
, ACTIVE integer
, SQLCONTENT TEXT
, LUACONTENT TEXT
, TEMPLATECONTENT TEXT
, DESCRIPTION TEXT
);
CREATE INDEX INDEX_REPORT_NAME ON REPORT_V1(REPORTNAME);

-- Describir ATTACHMENT_V1 (Adjuntos)
CREATE TABLE ATTACHMENT_V1 (
ATTACHMENTID INTEGER NOT NULL PRIMARY KEY
, REFTYPE TEXT NOT NULL /* Transacción, Acción, Activo, Cuenta Bancaria, Transacción Recurrente, Beneficiario */
, REFID INTEGER NOT NULL
, DESCRIPTION TEXT COLLATE NOCASE
, FILENAME TEXT NOT NULL COLLATE NOCASE
);
CREATE INDEX IDX_ATTACHMENT_REF ON ATTACHMENT_V1 (REFTYPE, REFID);

-- Describir USAGE_V1 (Uso)
CREATE TABLE USAGE_V1 (
USAGEID INTEGER NOT NULL PRIMARY KEY
, USAGEDATE TEXT NOT NULL
, JSONCONTENT TEXT NOT NULL
);
CREATE INDEX IDX_USAGE_DATE ON USAGE_V1 (USAGEDATE);

-- Describir CUSTOMFIELD_V1 (Campos Personalizados)
CREATE TABLE CUSTOMFIELD_V1 (
FIELDID INTEGER NOT NULL PRIMARY KEY
, REFTYPE TEXT NOT NULL /* Transacción, Acción, Activo, Cuenta Bancaria, Transacción Recurrente, Beneficiario */
, DESCRIPTION TEXT COLLATE NOCASE
, TYPE TEXT NOT NULL /* Cadena, Entero, Decimal, Booleano, Fecha, Hora, Selección Única, Selección Múltiple */
, PROPERTIES TEXT NOT NULL
);
CREATE INDEX IDX_CUSTOMFIELD_REF ON CUSTOMFIELD_V1 (REFTYPE);

-- Describir CUSTOMFIELDDATA_V1 (Datos de Campos Personalizados)
CREATE TABLE CUSTOMFIELDDATA_V1 (
FIELDATADID INTEGER NOT NULL PRIMARY KEY
, FIELDID INTEGER NOT NULL
, REFID INTEGER NOT NULL
, CONTENT TEXT
, UNIQUE(FIELDID, REFID)
);
CREATE INDEX IDX_CUSTOMFIELDDATA_REF ON CUSTOMFIELDDATA_V1 (FIELDID, REFID);

-- Describir TRANSLINK_V1 (Vínculos de Transacciones)
CREATE TABLE TRANSLINK_V1 (
TRANSLINKID  integer NOT NULL primary key
, CHECKINGACCOUNTID integer NOT NULL
, LINKTYPE TEXT NOT NULL /* Activo, Acción */
, LINKRECORDID integer NOT NULL
);
CREATE INDEX IDX_LINKRECORD ON TRANSLINK_V1 (LINKTYPE, LINKRECORDID);
CREATE INDEX IDX_CHECKINGACCOUNT ON TRANSLINK_V1 (CHECKINGACCOUNTID);

-- Describir SHAREINFO_V1 (Información de Acciones)
CREATE TABLE SHAREINFO_V1 (
SHAREINFOID integer NOT NULL primary key
, CHECKINGACCOUNTID integer NOT NULL
, SHARENUMBER numeric
, SHAREPRICE numeric
, SHARECOMMISSION numeric
, SHARELOT TEXT
);
CREATE INDEX IDX_SHAREINFO ON SHAREINFO_V1 (CHECKINGACCOUNTID);

-- Describir TAG_V1 (Etiquetas)
CREATE TABLE TAG_V1(
TAGID INTEGER PRIMARY KEY
, TAGNAME TEXT COLLATE NOCASE NOT NULL UNIQUE
, ACTIVE INTEGER
);
CREATE INDEX IDX_TAGNAME ON TAG_V1 (TAGNAME);

-- Describir TAGLINK_V1 (Vínculos de Etiquetas)
CREATE TABLE TAGLINK_V1(
TAGLINKID INTEGER PRIMARY KEY
, REFTYPE TEXT NOT NULL
, REFID INTEGER NOT NULL
, TAGID INTEGER NOT NULL
, FOREIGN KEY (TAGID) REFERENCES TAG_V1 (TAGID)
, UNIQUE(REFTYPE, REFID, TAGID)
);
CREATE INDEX IDX_TAGLINK ON TAGLINK_V1 (REFTYPE, REFID, TAGID);
