-- Создаем базу данных my_shop
DROP DATABASE IF EXISTS my_shop;
CREATE DATABASE my_shop;

USE my_shop;


-- Создаем таблицы
DROP TABLE IF EXISTS customers;
CREATE TABLE IF NOT EXISTS customers (
  id INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
  org_or_person CHAR(1) NOT NULL COMMENT "Организация или физ.лицо",
  org_name VARCHAR(40) DEFAULT NULL COMMENT "Имя организации",
  gender CHAR(1) NOT NULL COMMENT "Пол",
  first_name VARCHAR(20) NOT NULL COMMENT "Имя заказчика",
  last_name VARCHAR(50) NOT NULL COMMENT "Фамилия заказчика",
  email_address VARCHAR(40) NOT NULL UNIQUE COMMENT "Почта",
  login_name VARCHAR(20) NOT NULL UNIQUE COMMENT "Логин заказчика",
  login_password VARCHAR(20) NOT NULL COMMENT "Пароль заказчика",
  phone_number VARCHAR(30) NOT NULL UNIQUE COMMENT "Телефон заказчика",
  address_line_1 VARCHAR(50) NOT NULL COMMENT "Адрес заказчика - улица, дом",
  address_line_2 VARCHAR(20) DEFAULT NULL COMMENT "Адрес заказчика - аппартаменты, номер квартиры",
  city VARCHAR(30) COMMENT "Город заказчика",
  country VARCHAR(40) COMMENT "Страна заказчика",
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
  updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) COMMENT "Заказчики"; 

DROP TABLE IF EXISTS customer_payment_methods;
CREATE TABLE IF NOT EXISTS customer_payment_methods (
  id INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
  customer_id INT UNSIGNED NOT NULL COMMENT "Ссылка на заказчика",
  code INT UNSIGNED NOT NULL COMMENT "Ссылка на код оплаты заказчика",
  credit_card_number VARCHAR(30) DEFAULT NULL COMMENT "Номер кредитной карты заказчика",
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
  updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) COMMENT "Методы оплаты заказчика"; 

DROP TABLE IF EXISTS payment_methods;
CREATE TABLE IF NOT EXISTS payment_methods (
  id INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
  method_name VARCHAR(100) NOT NULL UNIQUE COMMENT "Описание метода оплаты",
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
  updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) COMMENT "Методы оплаты";

DROP TABLE IF EXISTS products;
CREATE TABLE IF NOT EXISTS products (
  id INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
  name VARCHAR(255) COMMENT "Название товара",
  description TEXT COMMENT "Описание товара",
  price DECIMAL (11,2) NOT NULL COMMENT "Цена товара",
  catalog_id INT UNSIGNED NOT NULL COMMENT "Ссылка на каталог",
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
  updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) COMMENT "Товары"; 

DROP TABLE IF EXISTS catalogs;
CREATE TABLE catalogs (
  id INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
  name VARCHAR(50) NOT NULL UNIQUE COMMENT "Название раздела",
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
  updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) COMMENT "Разделы интернет-магазина";

DROP TABLE IF EXISTS orders;
CREATE TABLE IF NOT EXISTS orders (
  id INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
  customer_id INT UNSIGNED NOT NULL COMMENT "Ссылка на заказчика",
  status_code INT UNSIGNED NOT NULL COMMENT "Ссылка на код статуса заказа",
  date_order_placed DATE COMMENT "Дата создания заказа",
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
  updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) COMMENT "Заказы"; 

DROP TABLE IF EXISTS orders_products;
CREATE TABLE orders_products (
  id INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
  order_id INT UNSIGNED NOT NULL COMMENT "Ссылка на заказ",
  product_id INT UNSIGNED NOT NULL COMMENT "Ссылка на товар",
  total INT UNSIGNED DEFAULT 1 COMMENT "Количество заказанных товарных позиций",
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
  updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) COMMENT "Состав заказа";

DROP TABLE IF EXISTS orders_status_codes;
CREATE TABLE IF NOT EXISTS orders_status_codes (
  id INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
  status_name VARCHAR(30) NOT NULL COMMENT "Описание кода статуса заказа",
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
  updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) COMMENT "Коды статусов заказа";

DROP TABLE IF EXISTS shipments;
CREATE TABLE IF NOT EXISTS shipments (
  id INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
  order_id INT UNSIGNED NOT NULL COMMENT "Ссылка на заказ",
  tracking_number VARCHAR(50) NOT NULL UNIQUE COMMENT "Номер отслеживания заказа",
  shipment_date DATE COMMENT "Дата отправления заказа",
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
  updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) COMMENT "Отгрузки"; 

DROP TABLE IF EXISTS storehouses;
CREATE TABLE storehouses (
  id INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
  name VARCHAR(50) NOT NULL COMMENT "Название склада",
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
  updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) COMMENT "Склады";

DROP TABLE IF EXISTS storehouses_products;
CREATE TABLE storehouses_products (
  id INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
  storehouse_id INT UNSIGNED NOT NULL COMMENT "Ссылка на склад",
  product_id INT UNSIGNED NOT NULL COMMENT "Ссылка на товар",
  value INT UNSIGNED NOT NULL COMMENT "Запас товарной позиции на складе",
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
  updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) COMMENT "Запасы на складе";


-- Создаем внешние ключи
ALTER TABLE customer_payment_methods
  ADD CONSTRAINT customer_payment_methods_customer_id_fk 
    FOREIGN KEY (customer_id) REFERENCES customers(id),
  ADD CONSTRAINT customer_payment_methods_code_fk
    FOREIGN KEY (code) REFERENCES payment_methods(id);
   
ALTER TABLE products
  ADD CONSTRAINT products_catalog_id_fk 
    FOREIGN KEY (catalog_id) REFERENCES catalogs(id);
   
ALTER TABLE orders
  ADD CONSTRAINT orders_customer_id_fk 
    FOREIGN KEY (customer_id) REFERENCES customers(id),
  ADD CONSTRAINT orders_status_code_fk
    FOREIGN KEY (status_code) REFERENCES orders_status_codes(id); 

ALTER TABLE orders_products
  ADD CONSTRAINT orders_products_order_id_fk 
    FOREIGN KEY (order_id) REFERENCES orders(id),
  ADD CONSTRAINT orders_product_id_fk
    FOREIGN KEY (product_id) REFERENCES products(id);
   
ALTER TABLE shipments
  ADD CONSTRAINT shipments_order_id_fk 
    FOREIGN KEY (order_id) REFERENCES orders(id);

ALTER TABLE storehouses_products
  ADD CONSTRAINT storehouses_products_storehouse_id_fk 
    FOREIGN KEY (storehouse_id) REFERENCES storehouses(id),
  ADD CONSTRAINT storehouses_products_product_id_fk
    FOREIGN KEY (product_id) REFERENCES products(id);

-- Создаем индексы
CREATE INDEX customers_name_surname_idx ON customers(first_name, last_name);   
CREATE UNIQUE INDEX customers_email_uq ON customers(email_address);
CREATE UNIQUE INDEX customers_login_uq ON customers(login_name);
CREATE UNIQUE INDEX storehouses_products_storehouse_id_product_id_uq ON storehouses_products(storehouse_id, product_id);
CREATE UNIQUE INDEX shipments_tracking_number_uq ON shipments(tracking_number);

-- Заполним данными таблицы:
-- customers
INSERT INTO 
  `customers` 
VALUES 
  ('1','o','Emmerich-Wolff','f','Patsy','Cummerata','zora.kihn@example.org','clangworth','f5a738bf6873fb12dd61','1-375-327-6560','968 Joey Avenue Apt. 257\nWest Deliaview, IL 16891','Apt. 364','Palmabury','Faroe Islands','2020-06-03 17:16:40','2020-09-27 03:18:43'),
  ('2','o','Wiegand-Bednar','f','Michaela','Rodriguez','harmony87@example.org','ryan.katelin','7e15e6e3e7229c259dff','061-530-1411x782','400 Jana Tunnel Apt. 200\nKuvalisfort, MN 01751-113','Suite 563','North Avaland','Gambia','2020-01-17 23:43:08','2020-09-16 05:17:50'),
  ('3','o','Powlowski, Veum and Beer','m','Carolyne','Halvorson','bhand@example.com','bill.schiller','91ae89c114c05e50d0ee','451-702-9664','943 Littel Rue Apt. 106\nEast Glennie, MN 52804','Suite 911','Earleneshire','Panama','2020-08-10 10:29:30','2020-09-22 04:39:01'),
  ('4','o','Tillman PLC','m','Brooke','Predovic','zola.spencer@example.org','dlind','411718877ad63900555f','(857)284-7336x61367','33416 Daniella Land\nPort Coleman, NJ 62589-5820','Apt. 977','Osvaldoborough','Panama','2020-05-16 22:20:34','2020-09-21 16:45:50'),
  ('5','o','Lehner LLC','f','Kobe','Reichert','oraynor@example.net','idonnelly','972e94ccdeec99d32ff6','+95(5)4857126573','42285 Bergstrom Passage Suite 813\nOkeyburgh, AL 53','Suite 789','Alisaside','Nepal','2020-07-26 13:37:26','2020-09-16 11:14:51'),
  ('6','p','Conn, Will and Hand','m','Eden','Luettgen','sedrick44@example.org','becker.dillon','a3b98fa18f03ba06f955','(870)822-2590x64385','6906 Dianna Rapid\nWellingtonborough, NM 27436','Apt. 043','Port Mitchellstad','Ethiopia','2020-03-29 15:50:18','2020-09-24 04:54:27'),
  ('7','o','Senger PLC','f','Gideon','Bartoletti','zborer@example.net','pacocha.lenny','21a96f4ce0ce1b56ff4f','(714)597-4275x06694','9513 Schneider Run Apt. 760\nLeolafort, AL 33883-11','Apt. 374','Muellerhaven','Liberia','2020-06-13 23:43:07','2020-09-18 03:40:43'),
  ('8','p','Anderson PLC','m','Rozella','Howe','mallie.pagac@example.net','istracke','cfa673d2d0763a82d8e4','07179291329','58557 Davis Pass Apt. 301\nJakobhaven, SC 57339','Apt. 143','Andersontown','Bahamas','2020-01-28 15:54:43','2020-08-28 09:17:53'),
  ('9','p','Bartell LLC','m','Blair','Reichel','lavon32@example.com','miller05','efbc382a31268d929ae6','07954160938','7216 Rylee Harbor\nEast Theresafurt, VT 68205-7935','Apt. 760','Larkinbury','Guyana','2020-09-24 14:14:10','2020-09-26 01:40:23'),
  ('10','o','Sipes LLC','f','Katharina','Kozey','gschulist@example.net','dariana31','910ecd277c63ebf18004','(226)957-8993','4415 Cecelia Springs Apt. 763\nDarefurt, SC 19386-8','Apt. 555','Lake Gerhardmouth','Yemen','2020-07-25 23:51:33','2020-09-23 01:44:06'),
  ('11','o','Witting-Schmidt','m','Alysson','Mante','fstoltenberg@example.org','salvatore25','eb03e1144ae52c85dc28','884-101-6773x395','19703 Kameron Ridges\nWest Keanubury, WV 97002-3622','Apt. 192','Port Verla','Lao People\'s Democratic Republic','2019-12-20 17:04:37','2020-09-08 06:23:07'),
  ('12','o','Bartell-Sauer','m','Imogene','Weber','alangosh@example.net','clifton06','5c5e84aa46e7cee3312d','325.520.6469x64091','7789 Lila Grove Apt. 972\nMozellemouth, ND 77815-64','Apt. 860','North Alexiebury','Faroe Islands','2020-01-03 16:45:38','2020-09-21 18:26:51'),
  ('13','o','Dickens Ltd','f','Brenda','Fahey','evangeline.mcclure@example.com','edwardo71','64dd3771f61d3e7b5ff6','848.123.6494x2729','7506 Martin Manor\nNew Johnpaul, ND 59790','Suite 124','West Cruzberg','Northern Mariana Islands','2019-11-10 22:03:35','2020-09-17 09:20:17'),
  ('14','o','Schmidt Group','f','Terrance','Nikolaus','mosciski.leo@example.net','elise.collier','d39ed2d2ae7fcc90cc79','1-982-074-0537','510 Hanna Club Suite 699\nLake Rodolfoville, ND 342','Apt. 711','South Luciusstad','Malawi','2020-05-08 01:31:07','2020-09-06 14:31:49'),
  ('15','o','Murray-Schinner','m','Emmie','Feeney','tremaine28@example.net','sonny13','862c86cf35b59b24cc86','594.273.2181x278','41723 Sanford Terrace Apt. 924\nRitchieville, OK 78','Suite 650','West Cristina','Albania','2020-06-20 05:15:15','2020-09-25 22:00:38'),
  ('16','p','Hauck, Homenick and Rempel','f','Nicolette','Mueller','lenore35@example.org','vhagenes','e3a0a8ac3bbfb93d93f5','1-851-057-6380x9844','87005 Jevon Corner\nLake Devynview, CO 61084','Suite 442','Port Irwinchester','Bulgaria','2020-01-31 19:39:27','2020-09-04 12:40:31'),
  ('17','p','Gottlieb Ltd','m','Ariane','Hessel','jamir.wisoky@example.com','ceffertz','91778f34fbeb554be61d','(749)058-4313x6034','65512 Marshall Isle\nWisozkshire, ID 21421-0856','Suite 229','Leschbury','Guam','2020-03-19 18:43:18','2020-09-12 11:11:05'),
  ('18','p','O\'Connell-Stehr','m','Rodolfo','Rosenbaum','randy.mann@example.org','rryan','bce149ef079ea4519d48','142.931.7709','13665 Effertz Mill Apt. 260\nEast Caleb, MT 77406-6','Apt. 906','Considineview','Falkland Islands (Malvinas)','2020-01-31 00:14:43','2020-09-08 02:53:36'),
  ('19','o','Abernathy-Gerlach','m','Bailey','Lynch','alverta72@example.net','grady.monroe','751232fd8d083f9b4eb7','(779)903-0458x11703','6221 Gerlach Spurs Apt. 807\nGrimesport, NC 96660-0','Apt. 303','Manteville','Angola','2020-06-12 01:42:04','2020-09-20 06:04:07'),
  ('20','o','Luettgen-Fahey','m','Vivien','Leuschke','ruthie.morissette@example.org','o\'conner.bertram','211805aa4472398af5ac','227.693.5682','1022 Trinity Road Suite 951\nMcLaughlintown, MO 203','Apt. 311','Belletown','Nigeria','2019-12-19 22:52:54','2020-09-16 12:16:38'),
  ('21','o','Stroman, Muller and Rogahn','m','Thora','McClure','prosacco.damien@example.org','okuneva.arden','09e9f0786a28db18a1b1','281.394.7503','178 Boyle Pines Apt. 560\nZiemannstad, CO 56675','Suite 684','Russelmouth','Germany','2019-11-22 15:28:20','2020-09-14 18:35:49'),
  ('22','o','Nolan Inc','f','Frederic','Goodwin','gutkowski.roberta@example.net','jturcotte','0ea4e329ce1b4c3355ce','+05(1)4919213936','2941 Oberbrunner Forges Apt. 518\nSouth Bonitaburgh','Apt. 251','Misaelmouth','Anguilla','2020-08-20 09:42:59','2020-09-25 05:08:05'),
  ('23','o','Kshlerin Ltd','m','Norval','Robel','whitney.kemmer@example.net','enrico.macejkovic','1875d52cc8400f32402a','836-711-1829x3567','7506 Krystel Valley\nWymanshire, NM 51215-4392','Apt. 876','Hammesberg','Anguilla','2020-08-13 15:24:16','2020-08-29 19:18:28'),
  ('24','p','Stark, Abshire and Hartmann','f','Kaela','Mohr','camilla59@example.com','richmond.lesch','f51aeda5732deb65f089','962.205.7148','571 Selmer Islands Suite 138\nJewelchester, ND 4193','Suite 054','Hanebury','Taiwan','2019-10-03 16:52:44','2020-09-26 00:26:24'),
  ('25','o','Spencer, Rogahn and Hackett','m','Kristoffer','Effertz','collins.osborne@example.net','jbruen','bb9fbab92abf655d220b','676.221.2684x734','329 Mitchell Station Apt. 444\nPacochaburgh, ID 424','Apt. 950','South Darylshire','Korea','2020-09-08 06:33:50','2020-09-15 06:49:13'),
  ('26','o','Mraz-Mayer','f','Danny','Mosciski','ottis.schmeler@example.com','sophie.dach','87820224230c4e184e90','674-845-4479','53865 Lebsack Crossroad Suite 591\nEmersonbury, MI ','Apt. 809','Pinkiemouth','Montserrat','2020-08-14 02:18:13','2020-09-12 21:19:30'),
  ('27','o','O\'Connell-Schmitt','f','Wyatt','Hayes','schumm.magdalen@example.org','johnny.brakus','129b76025634fc5b56a8','726.141.2597','0799 Alexandre Islands Suite 640\nWest Ethelynburgh','Apt. 129','New Malinda','Slovakia (Slovak Republic)','2020-01-07 12:51:41','2020-08-31 02:55:29'),
  ('28','p','Kilback Ltd','f','Clara','McDermott','tbayer@example.net','gschulist','77d5c921d89bcff969f1','00980873143','0604 Haag Parkways\nEast Cindy, AZ 93985','Apt. 406','East Rae','Guam','2020-03-08 10:35:09','2020-09-19 18:23:29'),
  ('29','o','Jones Group','m','Jeramy','Fritsch','diamond80@example.net','wzboncak','be82848676376bc27580','(749)572-2054','34145 Howell Gateway Apt. 668\nLake Marianemouth, K','Apt. 055','South Daxton','Central African Republic','2020-06-21 01:55:12','2020-09-20 23:40:19'),
  ('30','o','Gutmann LLC','f','Delbert','Orn','morar.jeramie@example.com','kirk.jones','c087f6ac6f785f1add48','628.389.8388x4564','22446 Jalen Freeway\nMrazport, VT 92019','Suite 549','New Kurtis','Russian Federation','2020-01-12 23:50:52','2020-09-14 08:40:30'),
  ('31','p','Sawayn-Hodkiewicz','f','Silas','Thompson','nienow.mabelle@example.com','gabrielle.fadel','73ef8cbdf0fc400e697e','051.036.6445x7336','4608 Pfannerstill Row\nSouth Germaine, LA 71908','Suite 427','Harberberg','Guadeloupe','2020-06-02 23:06:07','2020-08-28 10:36:32'),
  ('32','o','Kutch and Sons','m','Jackie','Robel','blindgren@example.org','rodolfo.reinger','1a319187a7c3658fe078','(843)955-1652','8315 Padberg Harbor Suite 431\nLake Alberto, AZ 983','Apt. 026','New Marcelinaton','Libyan Arab Jamahiriya','2020-03-07 18:32:55','2020-09-06 06:34:06'),
  ('33','o','Bradtke LLC','f','Pauline','Brekke','maci39@example.com','lcorkery','7fb1ebf36c7c31d415c4','333.288.5924','450 Savannah Manor\nPedrohaven, MA 56975-5971','Suite 427','Port Everettshire','Puerto Rico','2020-06-01 12:39:28','2020-08-28 13:11:23'),
  ('34','p','Watsica LLC','f','Eliseo','Rolfson','marge.willms@example.com','fbraun','86c4eac783e2bdcd00f1','130.497.7173','216 Eino Springs\nPort Naomie, ND 08328-8596','Apt. 858','South Isadoremouth','Tuvalu','2020-03-12 23:52:35','2020-09-17 22:54:23'),
  ('35','o','Bergnaum Inc','f','Samara','Stroman','agreen@example.org','sawayn.willie','74af9e60ef1052f52053','1-307-020-9625','49896 Bauch Club Suite 876\nLaurenland, MN 50658','Apt. 013','New Kaden','Christmas Island','2019-12-19 05:41:39','2020-09-25 10:21:06'),
  ('36','p','Larkin, Morar and Fadel','f','Rita','Kassulke','vcormier@example.net','torrey.braun','338d9b1a39adf9b74894','1-102-703-2581x57460','675 Gerhold Knolls Apt. 363\nKesslerfurt, NM 52608-','Suite 581','Tatyanafort','Mauritania','2020-07-21 13:52:32','2020-09-09 01:31:17'),
  ('37','o','Doyle, Flatley and Turcotte','f','Elwyn','Tillman','molly61@example.net','zwindler','306707392256ad953c0d','1-636-471-4121x795','67010 Johns Isle\nZiemefort, DC 29058-1773','Apt. 661','Bauchtown','Cuba','2019-09-28 08:33:41','2020-09-14 22:16:27'),
  ('38','o','Reilly-Ritchie','m','Anjali','Cartwright','magali84@example.org','pearlie36','41d23110adbe94b83743','(474)958-5103x94063','30992 Anderson Circles\nAlbertchester, SC 98572-913','Apt. 170','Jamaalfort','Angola','2020-05-26 02:54:35','2020-08-30 20:01:03'),
  ('39','o','Green PLC','f','Eldridge','Hammes','pmacejkovic@example.net','elinor38','1f57a613b545cad78d85','864-305-7077','56553 Wehner Haven Suite 721\nNorth Calistaview, MD','Apt. 428','Stephaniaberg','Tokelau','2020-07-14 07:42:46','2020-09-14 02:26:41'),
  ('40','p','Wiza LLC','f','Krystina','Paucek','nova67@example.net','bjacobi','2150367722fbfb7e4893','+42(9)6574864660','006 Marvin Pike Suite 973\nWizafurt, IN 06360-4032','Apt. 351','Lake Jerad','Holy See (Vatican City State)','2020-09-21 06:08:09','2020-09-29 13:51:08'),
  ('41','o','Williamson, Block and Carroll','m','Paige','Fay','rice.magdalen@example.org','lfritsch','541b06528e44581ef99f','294-675-9496x81506','92676 Shanny Centers Apt. 288\nLake Keshawnfurt, KS','Suite 471','Damonmouth','United Kingdom','2020-07-15 06:47:04','2020-09-19 22:43:02'),
  ('42','p','Grady-Pacocha','m','Grace','Becker','hackett.linnea@example.org','reanna39','9445bf5c6854cdf0ef6f','(646)506-3675x1998','641 Mafalda Squares\nNorth Myronchester, NV 17316','Apt. 149','North Everett','Slovenia','2020-04-03 03:47:25','2020-09-23 06:48:45'),
  ('43','p','Waelchi and Sons','m','Linwood','Johnston','jeff.cormier@example.com','oadams','792e83523ce248d4cf5a','06262321148','92223 Kim Crossroad Apt. 496\nKhalilbury, NY 05325-','Apt. 325','Marcelleland','Ireland','2019-10-28 19:35:57','2020-09-10 22:05:37'),
  ('44','p','King PLC','m','Roderick','Hintz','keshaun69@example.org','edward45','b16cab933e83dcf15743','998.422.8917x2596','5162 Euna Land Apt. 603\nHaleychester, OH 06197','Apt. 676','South Brandy','Jordan','2020-06-02 12:15:15','2020-09-06 02:03:30'),
  ('45','p','Volkman-Dibbert','m','Demetris','Runte','ykonopelski@example.com','mafalda.collins','5d4eb7ee46a1836e6767','1-091-961-0417','71776 Madalyn Via\nSchimmelmouth, DE 22801','Suite 218','East Brycentown','Korea','2020-04-06 03:35:15','2020-09-27 02:42:10'),
  ('46','p','Torphy and Sons','f','Zula','Konopelski','laurence74@example.com','lakin.ethyl','37640bb3f3f298549fbd','+34(1)0424433468','03092 Shields Field\nEast Camrenstad, MO 37092','Apt. 125','North Elroybury','Equatorial Guinea','2020-08-15 06:06:16','2020-08-27 14:22:52'),
  ('47','p','Wuckert Ltd','m','Christ','Lockman','hailee30@example.net','harvey.magdalena','c7aff0f6400cd34cc734','1-277-828-0153x8820','48925 Hermiston Key\nPort Fannie, ID 54496-7716','Apt. 883','McLaughlintown','Northern Mariana Islands','2020-09-18 10:11:00','2020-09-24 10:19:29'),
  ('48','o','Zemlak-Beahan','m','Mose','Sauer','ulises98@example.net','scarroll','9b9e79e85ab886f0c559','578.619.4898x855','409 O\'Kon Square\nAlyciaberg, SC 34975','Suite 571','Port Jaqueline','Suriname','2020-06-26 02:58:04','2020-08-31 09:31:57'),
  ('49','p','Johnson, Johns and Bechtelar','f','Jayce','Tromp','ehaag@example.com','everardo23','35218fee10b84a52f4aa','177-687-0390x46463','2341 Jakubowski Track\nAbbyfort, CO 07150-5828','Suite 283','Augusthaven','India','2020-05-11 20:30:24','2020-09-05 14:50:15'),
  ('50','p','Ruecker PLC','f','Jaren','Collins','ecremin@example.net','cormier.bradley','b352ee79fd645fefba98','675.470.9292x32655','98906 Mara Drive\nRuthieville, LA 92259','Apt. 564','Kennystad','Haiti','2019-11-11 21:05:32','2020-08-27 21:40:23'),
  ('51','p','Dickinson, Kohler and Predovic','m','Jamal','Marquardt','wbailey@example.net','iroob','ebe9dd564d19be03c448','1-552-589-4574x268','261 Prosacco Row\nHyattchester, TN 37915','Apt. 234','Lake Aileenshire','Jamaica','2020-07-14 05:34:48','2020-09-07 11:29:36'),
  ('52','o','Friesen, Kirlin and Stanton','m','Patricia','Gleason','heller.monica@example.net','denesik.pascale','473324264eac1f588a22','043-336-5537x920','0599 Bell River Apt. 600\nLake Woodrow, MA 55185','Suite 981','South Deanna','Seychelles','2020-05-18 04:17:34','2020-09-20 19:12:36'),
  ('53','p','Zieme-Schaefer','m','Karina','Langworth','ddeckow@example.com','huels.allison','6c58268cfd2ee023c939','1-211-680-3960x3378','7596 Samson Spur\nWest Rylan, CO 07825-3062','Apt. 342','Amelyside','Indonesia','2019-12-20 01:54:57','2020-09-16 11:03:04'),
  ('54','o','Barrows, Moore and Bergnaum','m','Rhea','Wehner','pacocha.eda@example.net','dickinson.birdie','597f5a78b30fb8502815','274-943-9611x251','03471 Romaguera Cape Suite 427\nTeaganfort, CT 9340','Apt. 133','Alicetown','Micronesia','2019-10-16 08:00:30','2020-09-22 22:34:09'),
  ('55','o','Kuhn, Streich and Labadie','f','Delaney','Streich','greenholt.christy@example.net','hardy.bailey','0c39ec8d6b29faeebc70','562-011-4733','317 Hane Alley Apt. 035\nSouth Alvafort, CO 86749-3','Apt. 000','North Colleenchester','Uruguay','2020-06-02 03:42:40','2020-09-08 03:18:54'),
  ('56','o','Bailey, Crooks and Schmitt','f','Anika','Wiza','rath.reggie@example.com','betty24','14f6f41fbdcaa9e7aa78','980.287.0574x2019','36919 Rau Cape\nSouth Itzel, ME 01308','Suite 648','Carterport','Christmas Island','2020-08-04 20:48:38','2020-09-14 16:40:49'),
  ('57','o','O\'Connell-Abshire','m','Watson','Nicolas','mikel81@example.com','phettinger','6402de40b22962603962','(971)946-7862x984','27266 Hilpert Shoals Apt. 061\nPort Veronicachester','Suite 213','Malachibury','Czech Republic','2019-11-13 20:12:37','2020-08-27 17:55:58'),
  ('58','p','Rutherford Ltd','m','Cassandra','Fritsch','gkreiger@example.com','sadie31','274b2c64e98a9e64cacf','013-695-2864x6646','5628 Ullrich Lane Apt. 335\nTayaside, ME 74794-1357','Apt. 532','Quitzonburgh','Holy See (Vatican City State)','2020-03-24 15:47:34','2020-09-15 19:27:41'),
  ('59','o','Huel and Sons','f','Clarabelle','Rippin','jody.rippin@example.org','abigail.maggio','0fb87e65b279d502ff1a','533.557.3226','603 Myrna Islands\nDuBuqueshire, AZ 09248-6519','Suite 436','Karineport','Chile','2020-03-02 00:31:09','2020-08-27 07:56:31'),
  ('60','p','Stoltenberg and Sons','m','Amaya','Johns','o\'keefe.dedric@example.net','eliseo50','95e69b5bf1dc70246984','(366)937-0080x3750','0994 Wolff Manor Apt. 281\nJacobiport, OK 39952-699','Apt. 826','Feestbury','Ireland','2020-04-11 19:35:47','2020-09-15 04:32:57'),
  ('61','p','Labadie and Sons','m','Deshaun','Murazik','amos03@example.net','percival.keeling','6351b0bedb86e644f608','(370)501-3008','4435 Guy Well\nEbertview, NE 11642-8758','Apt. 667','New Alysachester','Heard Island and McDonald Islands','2019-10-13 15:58:20','2020-09-20 04:31:52'),
  ('62','o','Hickle Ltd','f','Toby','Towne','santiago05@example.com','kovacek.murl','769b62ce0dbddc82dbbc','584.593.5538x356','511 Tito Knoll\nWinfieldstad, VA 26331','Apt. 246','North Fanniemouth','Italy','2020-04-03 12:24:33','2020-09-08 02:06:12'),
  ('63','o','Schiller, Fay and Moen','m','Alex','Parisian','sflatley@example.net','qgreenholt','324fefc9012c956fe075','1-010-730-2007x527','0271 Kiley Orchard\nWest Felipe, IN 82209','Apt. 369','Raeberg','South Georgia and the South Sandwich Isl','2020-06-20 11:20:07','2020-08-31 09:59:00'),
  ('64','p','Kertzmann LLC','f','Amos','Wunsch','wisozk.garrison@example.org','gkuhn','46e740b8774873846cee','071.301.4732','0143 Bernhard Plaza Suite 930\nNew Vivaborough, WY ','Apt. 462','South Justicemouth','Jersey','2019-09-27 13:37:01','2020-08-27 07:24:20'),
  ('65','o','Nitzsche-Kertzmann','m','Lionel','Will','gutmann.herta@example.com','fredrick91','04fc2add705463925c1d','041-680-8359x210','918 Sarai Gateway\nEast Cydneyton, NJ 06906-2363','Suite 198','Harberport','Spain','2020-05-24 11:43:05','2020-09-05 02:12:02'),
  ('66','o','Anderson Ltd','m','Dakota','Lindgren','fay.bonita@example.com','felicia.sporer','f6f96d9485edd2952b48','864.599.0046','8740 Romaguera Club Apt. 285\nSteuberhaven, MN 0081','Suite 000','West Deron','Saint Barthelemy','2020-02-24 15:56:45','2020-09-19 20:36:26'),
  ('67','o','Ernser-Mante','m','Aimee','Torp','breana61@example.net','vlangworth','297de89ade6aa06285da','1-288-287-7557x94418','42393 Thiel Village Apt. 457\nMarvintown, MO 24389-','Suite 759','South Catharine','Pitcairn Islands','2020-05-08 15:42:22','2020-09-24 08:41:07'),
  ('68','p','Lemke PLC','m','Rebeca','Durgan','gkutch@example.com','dooley.idella','ced1424f2ac05e6136f9','589.319.3698x0905','10496 Jordy Circles\nKlockohaven, WY 81751-8551','Suite 294','South Maegan','India','2019-10-28 01:05:04','2020-09-07 05:35:48'),
  ('69','p','Conn PLC','m','Laverna','Wyman','reichert.eldridge@example.org','glenna08','7e3e315c6e8efecef536','1-348-202-7142x74026','009 Alfredo Crescent\nSouth Reymundomouth, MA 69226','Apt. 344','East Lonberg','Tajikistan','2019-11-19 09:45:18','2020-09-25 09:00:19'),
  ('70','o','Mraz-Miller','m','Verner','Rath','qstanton@example.org','farrell.doyle','04a8bb01361ae341d89d','1-710-844-0283x451','298 Filiberto Dam\nWest Emileshire, CT 52924','Apt. 174','South Damion','Hong Kong','2020-03-23 12:29:35','2020-09-03 18:02:59'),
  ('71','p','Gerlach, Goyette and Stehr','m','Henriette','Bailey','weber.cristina@example.com','tkuhic','dd62bb3ee45bcdf1f548','088-988-8803x426','930 Grant Glen\nMayermouth, GA 08963-7665','Suite 659','Walkerfurt','Saint Kitts and Nevis','2020-06-11 21:17:32','2020-08-27 14:56:10'),
  ('72','o','Ankunding-Senger','f','Terrance','Heathcote','fritz34@example.com','josh12','e5d355252a9c86a7c71a','218.460.0132x2241','2575 Stacy Lock\nEast Maiyahaven, WV 83274-7912','Suite 098','South Donhaven','Cambodia','2020-01-10 12:37:56','2020-09-20 03:14:55'),
  ('73','p','Keeling-Volkman','m','Paula','Conn','hkris@example.net','uquitzon','0d386d9de63c1ec96445','(668)874-0602','888 Thompson Ridge\nSouth Alberta, OH 60315-5389','Suite 754','West Alliebury','Bhutan','2019-12-21 01:25:27','2020-09-18 05:08:02'),
  ('74','p','Greenfelder Ltd','m','Kailyn','Predovic','sally80@example.net','spowlowski','afa61b46ad72e2ff223f','(941)719-2506','69226 Goldner Port\nJudyberg, VA 20740','Apt. 612','Robertofort','Iraq','2020-04-27 21:58:46','2020-09-14 00:02:46'),
  ('75','o','Abbott PLC','m','Vern','Hirthe','ysimonis@example.net','jake.crooks','1aed4c7e99c970980447','918-798-4135x7260','14628 Horacio Highway\nSouth Haylie, KY 43508','Apt. 307','North Coy','Senegal','2020-02-18 00:42:00','2020-09-19 21:28:17'),
  ('76','o','Senger Group','m','Sigrid','Hansen','arlie.murray@example.net','jsauer','0b63f724742950ecd8ce','651.722.9689x0029','789 Anika Ridges\nGottliebfort, MN 46992','Suite 033','Cormierhaven','Gambia','2020-02-17 07:03:06','2020-09-01 17:30:50'),
  ('77','p','Altenwerth, Cruickshank and Kreiger','f','Clair','Collier','drowe@example.net','jan90','36bb9fac233118a753fc','745.705.0722x7692','06590 Kunde Falls Apt. 442\nWest Burleyshire, MD 19','Suite 830','South Casandra','Estonia','2020-04-20 01:08:55','2020-09-02 11:32:27'),
  ('78','o','Heathcote, Cronin and Schultz','f','Trycia','Kreiger','nannie.muller@example.com','satterfield.cindy','5e36130d32164fb9e535','1-821-328-2665x360','5480 Joshua Parkway Apt. 587\nIssacmouth, IN 18296-','Suite 375','Hoegerstad','Mayotte','2019-10-30 14:56:23','2020-08-30 05:44:53'),
  ('79','o','Ferry, Veum and Kohler','m','Eda','Keeling','gbarrows@example.org','lonnie.trantow','e2ddb54d2234a02a2084','+54(9)1433142198','17737 Howell Pine\nEast Eva, OH 18389','Apt. 211','Davischester','Cape Verde','2020-09-09 17:21:00','2020-09-27 08:39:09'),
  ('80','p','McClure-Durgan','m','Levi','Beier','qstroman@example.net','huels.julien','a03653c8f5cba083e6b8','871.352.2108x856','39758 Tatyana Falls Apt. 557\nEmmanuelstad, TN 0713','Suite 907','Paucekside','Rwanda','2020-01-30 15:04:28','2020-09-19 04:41:17'),
  ('81','p','Roob-Lebsack','f','Jody','O\'Kon','pstanton@example.net','heathcote.mariane','dc0f44f2e831ebff9dc2','397-845-1108x3215','61001 Walsh Harbor\nNicolasmouth, AK 70835','Apt. 162','Fadelside','Saint Kitts and Nevis','2020-03-20 23:38:35','2020-08-30 02:04:33'),
  ('82','o','Mertz, Simonis and Windler','f','Kitty','Hodkiewicz','harry.morar@example.org','erik05','76e960c6bb7084a7a22e','1-907-757-7894x29901','1931 Parker Radial Apt. 513\nLake Reyberg, NJ 19664','Apt. 978','Lake Rozellaburgh','Kazakhstan','2020-07-17 16:40:07','2020-09-19 01:43:31'),
  ('83','o','Ledner PLC','f','Georgiana','Ebert','elvera.bartell@example.net','yvette.trantow','4cda73a305db516db867','(799)260-4313x63964','70690 Ava Plains\nHaleymouth, OH 16299','Apt. 255','Auerburgh','Yemen','2019-12-07 07:25:16','2020-09-23 01:03:09'),
  ('84','p','Green, Homenick and Kunde','m','Mayra','Kilback','lehner.tamia@example.net','esteban84','3c5a9ab014b8aed45be3','(964)965-5829','4818 Bessie Curve Suite 794\nPresleyton, FL 01617','Apt. 847','North Twilashire','El Salvador','2020-09-03 14:28:39','2020-09-21 16:00:47'),
  ('85','o','Christiansen-Lind','m','Margret','Gleason','sporer.elmer@example.org','tkutch','1888e8f2741ad3fec00b','913.650.1064x2476','11911 Ziemann Spring\nBuckland, CO 50121','Suite 044','North Cordiestad','Uganda','2020-07-03 16:57:09','2020-09-07 17:00:06'),
  ('86','o','Bashirian-Carroll','f','Phyllis','Strosin','ankunding.nedra@example.org','schuster.jacey','b467f49586ef0e21ea8e','898-628-3015x86638','30025 Annette Parkways Apt. 519\nWest Donnychester,','Apt. 986','Aliaside','Bosnia and Herzegovina','2020-09-04 04:50:35','2020-09-21 18:06:17'),
  ('87','p','Dibbert-Pacocha','m','Ollie','Grimes','qboyer@example.org','lkeebler','5b98e97ab1fbb55344e9','+76(0)2979421558','07794 Auer Walk Apt. 340\nSteuberfurt, NY 29698','Apt. 487','Masonhaven','Wallis and Futuna','2019-12-25 05:07:50','2020-09-12 04:14:27'),
  ('88','p','King, Frami and Nolan','m','Cristina','Crooks','beryl30@example.org','jamal44','7e17c54ea24af08af0ca','06497421589','27426 Rhoda Plaza Apt. 402\nNicolasland, DC 25301','Apt. 923','Port Andre','Guyana','2020-04-01 04:54:46','2020-09-23 19:37:23'),
  ('89','o','Stehr, Nicolas and Donnelly','m','Felicia','Deckow','stephanie.barton@example.net','marietta47','68e1789e366e92a99923','(095)287-5463x94409','17159 Jana Forges\nGarettton, MA 63479-8489','Suite 519','Kassulkeport','Saint Pierre and Miquelon','2020-07-31 23:48:20','2020-09-18 07:57:49'),
  ('90','p','Mills Group','m','Adolph','Mueller','tessie57@example.org','eliane.ryan','0e81c9709e0e8f00b8cc','(240)931-1318','98036 Witting Pike\nNorth Richie, CT 78138-7879','Apt. 822','Port Laurine','Mexico','2020-09-13 11:44:42','2020-09-22 23:33:34'),
  ('91','o','Durgan PLC','f','Javonte','Fahey','botsford.arthur@example.org','zemmerich','9f6f074370a311ba055d','1-579-599-5855x090','02660 Bogan Light Suite 538\nFeltonview, MD 37731','Apt. 564','Lake Noblechester','Korea','2020-02-13 01:17:33','2020-08-30 03:35:32'),
  ('92','o','Bergnaum LLC','m','Daija','Hills','emily25@example.net','nschulist','b3fc0251f9610f90dcb6','714.249.6236x06026','858 Joanie Lake Suite 883\nWest Demetrisstad, NV 16','Suite 333','Torphymouth','Azerbaijan','2020-02-09 11:58:16','2020-09-05 10:43:02'),
  ('93','o','Quigley Group','f','Conor','Effertz','gino.harber@example.org','demetris.jacobs','40397865ce01c4351e0f','694.778.2827x892','09018 Hoppe Ports Suite 428\nMichaelfort, AR 46903','Suite 571','Port Meaganberg','Korea','2020-04-18 17:59:27','2020-09-13 14:54:08'),
  ('94','o','Kertzmann LLC','m','Alejandrin','Morissette','ywaters@example.com','shanahan.herminia','92c8c5ece7f76a00c901','(305)814-4392','056 Leonardo Via\nSouth Keshaunmouth, ME 22027-7139','Suite 971','Jordonborough','Antarctica (the territory South of 60 de','2020-07-22 18:12:28','2020-08-28 06:24:55'),
  ('95','p','Herzog, Swaniawski and Huel','m','Berenice','Dooley','ezemlak@example.net','morris.wisozk','f4c0cae8796219348fb4','(600)649-4030x397','13578 Katlynn Fort Apt. 166\nPort Jovany, MS 34068-','Apt. 704','East Shirley','South Africa','2020-07-01 23:06:11','2020-09-22 06:25:32'),
  ('96','p','Douglas, Fritsch and Hudson','f','Edythe','Becker','mann.lazaro@example.com','izulauf','6b9b9756f275c5bbfdbc','(781)312-2707','9491 Elisha Port\nHankfurt, OK 94481-7261','Apt. 546','Hartmannside','French Polynesia','2020-08-21 11:29:30','2020-09-04 11:54:50'),
  ('97','o','Murazik-Parisian','m','Peter','Hickle','keeling.aaron@example.org','nlebsack','a730fe99c92512bc1125','893.846.4184x569','095 Cortney Station Apt. 483\nWest Juliabury, KS 08','Suite 133','South Darylstad','Thailand','2020-04-07 11:33:16','2020-08-30 10:55:05'),
  ('98','o','Bode-Schmidt','m','Katelyn','Rohan','bailey.yessenia@example.net','pjohnson','cd981333a2217d262840','748.545.1985x741','434 Meggie Island Suite 170\nBernicebury, KS 80038-','Suite 586','East Fidel','Mongolia','2020-08-25 16:43:01','2020-09-24 03:32:51'),
  ('99','p','Connelly-Russel','f','Hertha','Powlowski','mortimer48@example.net','montana.carter','b92810951058b7b40552','1-867-457-0938','2314 Padberg Key Apt. 479\nNew Aleen, WI 17449-7135','Suite 242','East Boris','Cayman Islands','2020-09-10 19:22:50','2020-09-17 17:59:16'),
  ('100','p','Gerlach PLC','f','Mathilde','Morar','reynolds.annalise@example.org','rhoda26','5eef10db7f369049ba5b','513.639.6927','6347 Moen Ford\nSouth Brettchester, VA 06158','Apt. 398','North Monserratefort','El Salvador','2020-04-07 09:08:41','2020-09-06 16:18:52'); 

-- payment_methods
INSERT INTO 
  `payment_methods` 
VALUES 
  ('1','Visa','2019-10-14 08:56:13','2020-09-26 05:54:16'),
  ('2','MasterCard','2020-08-16 03:05:35','2020-09-20 16:12:52'),
  ('3','American Express','2019-11-17 06:24:36','2020-09-14 14:55:35'); 
  
-- customer_payment_methods
INSERT INTO 
  `customer_payment_methods`
VALUES 
  ('1','1','1','6011518515955301','2013-07-01 07:43:09','2020-09-06 06:58:33'),
  ('2','2','2','4485239949082','2019-01-27 07:41:14','2020-09-22 19:11:52'),
  ('3','3','3','5592155562739188','2015-03-19 09:49:09','2020-09-01 09:40:42'),
  ('4','4','1','4024007132861771','2012-04-04 22:40:11','2020-08-28 02:17:44'),
  ('5','5','2','5598239073566748','2011-09-28 12:50:19','2020-09-06 20:13:54'),
  ('6','6','3','6011714159477708','2020-02-19 10:31:00','2020-09-12 06:02:16'),
  ('7','7','1','343844190709246','2016-03-20 17:13:01','2020-09-14 10:38:42'),
  ('8','8','2','5366499083499202','2019-09-25 00:45:14','2020-09-22 07:48:25'),
  ('9','9','3','4539935392909843','2019-04-09 01:35:27','2020-09-15 05:08:47'),
  ('10','10','1','4024007103702322','2013-11-30 11:09:59','2020-09-17 21:43:08'),
  ('11','11','2','4178584471532','2014-04-16 08:51:15','2020-09-19 06:56:00'),
  ('12','12','3','5458094648450184','2011-04-03 21:32:50','2020-08-29 12:40:35'),
  ('13','13','1','4929049780944625','2011-08-18 01:14:19','2020-09-23 20:43:58'),
  ('14','14','2','6011151526856879','2013-04-14 07:03:51','2020-09-22 02:43:27'),
  ('15','15','3','5443985527414621','2018-05-11 14:37:47','2020-09-23 23:15:48'),
  ('16','16','1','377160202238781','2011-02-12 14:07:33','2020-09-06 08:45:14'),
  ('17','17','2','5159337435497210','2018-08-20 04:45:17','2020-08-29 04:57:46'),
  ('18','18','3','4532320404553008','2019-12-20 01:31:30','2020-09-19 05:01:09'),
  ('19','19','1','5586312714327254','2018-07-17 18:20:36','2020-08-27 23:57:39'),
  ('20','20','2','5360105444976872','2020-01-06 12:01:04','2020-08-27 19:32:17'),
  ('21','21','3','4485550222422','2013-09-19 19:29:53','2020-09-07 04:46:50'),
  ('22','22','1','4485739498460','2018-07-19 06:35:02','2020-09-16 16:13:57'),
  ('23','23','2','5115731774763969','2014-04-30 09:08:47','2020-09-03 08:10:10'),
  ('24','24','3','5525138826695876','2013-07-24 23:30:21','2020-09-01 01:02:40'),
  ('25','25','1','4556676332358942','2012-11-22 15:55:36','2020-09-12 09:41:16'),
  ('26','26','2','4716363241038415','2018-06-17 07:14:22','2020-08-31 04:18:29'),
  ('27','27','3','4539924544738023','2016-10-23 15:17:04','2020-09-23 13:42:25'),
  ('28','28','1','4539504824661508','2011-10-14 10:26:16','2020-09-13 11:28:49'),
  ('29','29','2','4391564137554809','2012-01-04 10:36:10','2020-09-18 01:26:00'),
  ('30','30','3','5275987508011865','2011-05-21 11:19:50','2020-08-29 03:54:50'),
  ('31','31','1','6011887872378279','2012-09-13 21:38:42','2020-09-15 10:44:41'),
  ('32','32','2','378985243217498','2019-08-31 02:06:56','2020-09-10 02:47:37'),
  ('33','33','3','5416175237076261','2013-07-20 02:12:29','2020-09-17 13:15:12'),
  ('34','34','1','4957206531281326','2016-11-23 14:55:06','2020-09-03 22:23:51'),
  ('35','35','2','4485858696964615','2015-08-15 14:48:41','2020-09-23 08:31:39'),
  ('36','36','3','5246811930371198','2014-06-14 21:36:06','2020-09-06 08:11:11'),
  ('37','37','1','4716898587799','2013-01-29 05:33:42','2020-09-04 17:38:41'),
  ('38','38','2','5573912885132307','2017-12-01 01:58:45','2020-09-27 02:10:01'),
  ('39','39','3','4485789999824253','2014-07-08 03:40:58','2020-09-05 13:14:00'),
  ('40','40','1','5356326362704223','2010-11-03 06:19:39','2020-09-08 05:28:41'),
  ('41','41','2','4916860726927061','2016-03-22 04:23:48','2020-09-20 12:16:29'),
  ('42','42','3','346411020963308','2014-09-08 07:08:31','2020-09-16 00:44:45'),
  ('43','43','1','4485484464821','2016-04-25 10:57:38','2020-09-17 15:00:53'),
  ('44','44','2','4556935689662','2020-01-11 09:27:21','2020-09-09 15:05:39'),
  ('45','45','3','4916829885128328','2020-04-17 14:49:39','2020-09-21 20:26:08'),
  ('46','46','1','4485785838898577','2014-11-22 04:20:38','2020-08-29 23:15:52'),
  ('47','47','2','4532180448817','2020-05-18 06:50:05','2020-09-09 04:22:20'),
  ('48','48','3','4556556444255164','2017-07-07 17:59:10','2020-09-14 23:17:30'),
  ('49','49','1','5173119694308988','2017-01-02 06:53:19','2020-09-18 00:51:19'),
  ('50','50','2','4929125594575880','2019-06-24 10:33:11','2020-09-05 16:00:20'),
  ('51','51','3','4556317995901269','2012-12-18 08:35:04','2020-09-05 05:38:50'),
  ('52','52','1','4127404576118','2013-11-09 19:39:24','2020-09-13 22:03:03'),
  ('53','53','2','4929557348635','2017-05-26 18:56:27','2020-08-29 13:29:36'),
  ('54','54','3','6011798199070310','2012-06-04 23:57:38','2020-09-17 17:11:40'),
  ('55','55','1','4929146811080','2015-12-21 20:13:05','2020-09-20 11:54:38'),
  ('56','56','2','5412585010218406','2018-01-22 21:43:50','2020-09-18 14:58:17'),
  ('57','57','3','5362717164516045','2017-04-22 01:20:56','2020-09-22 09:21:41'),
  ('58','58','1','4024007130933014','2015-04-28 17:43:52','2020-09-26 21:19:27'),
  ('59','59','2','4916945180208616','2016-10-23 04:26:56','2020-09-22 09:36:51'),
  ('60','60','3','4929720610562','2017-02-24 03:51:49','2020-08-28 21:29:57'),
  ('61','61','1','5547592376559634','2012-12-29 17:59:20','2020-08-27 19:47:49'),
  ('62','62','2','5432299056322316','2019-07-19 21:08:02','2020-09-15 00:40:04'),
  ('63','63','3','4716167193566','2019-06-07 07:51:08','2020-09-13 02:58:07'),
  ('64','64','1','5116553574538901','2010-12-06 03:31:10','2020-09-17 05:30:36'),
  ('65','65','2','4532522787875','2019-04-16 20:57:54','2020-08-31 01:51:31'),
  ('66','66','3','4024007159511','2014-07-31 13:02:47','2020-09-26 17:01:33'),
  ('67','67','1','343794502672397','2017-08-08 10:09:36','2020-09-19 06:29:40'),
  ('68','68','2','5242699102864372','2015-08-20 17:22:05','2020-09-22 22:11:51'),
  ('69','69','3','5313246765164231','2018-05-05 04:20:13','2020-09-11 12:00:49'),
  ('70','70','1','5154332756689350','2012-10-28 13:31:26','2020-09-21 06:43:20'),
  ('71','71','2','4916403628379','2013-12-02 09:08:12','2020-09-26 05:48:16'),
  ('72','72','3','5336111777410832','2013-02-01 19:12:49','2020-09-03 00:10:38'),
  ('73','73','1','5148332579472247','2010-12-24 02:23:26','2020-09-18 14:41:15'),
  ('74','74','2','4532137771059166','2013-11-28 19:13:55','2020-09-21 09:14:42'),
  ('75','75','3','5196719675047632','2012-10-21 10:43:44','2020-09-23 11:52:43'),
  ('76','76','1','4013467745401791','2016-03-31 08:27:51','2020-08-29 16:12:23'),
  ('77','77','2','373916986173459','2017-01-21 06:55:28','2020-08-31 14:18:33'),
  ('78','78','3','4024007177176','2020-04-11 12:38:42','2020-09-12 11:29:22'),
  ('79','79','1','4929545057299','2012-10-01 21:41:57','2020-09-19 14:21:44'),
  ('80','80','2','4532018766923498','2017-10-13 21:58:48','2020-09-17 14:26:18'),
  ('81','81','3','4929576869474984','2015-10-27 21:09:07','2020-09-26 07:56:05'),
  ('82','82','1','4916676992384','2012-05-07 06:52:03','2020-09-26 02:55:26'),
  ('83','83','2','6011561875673496','2017-11-09 00:43:03','2020-09-01 18:29:50'),
  ('84','84','3','5396243447788902','2020-01-10 15:04:21','2020-09-16 17:50:34'),
  ('85','85','1','5253419828781022','2015-05-15 08:20:33','2020-09-07 06:16:52'),
  ('86','86','2','4024007180150741','2020-03-23 14:22:01','2020-09-16 09:50:49'),
  ('87','87','3','5424298997173192','2012-11-27 03:35:43','2020-09-25 20:37:47'),
  ('88','88','1','4916927516410','2020-05-15 12:22:01','2020-09-17 08:20:05'),
  ('89','89','2','5170464722455799','2012-04-01 08:37:51','2020-09-20 02:14:56'),
  ('90','90','3','5179613869918693','2019-10-12 23:42:50','2020-09-26 10:51:18'),
  ('91','91','1','5247015469252340','2011-09-07 20:22:52','2020-09-05 10:25:51'),
  ('92','92','2','5340259484106174','2018-04-15 10:37:58','2020-09-06 00:06:24'),
  ('93','93','3','5526039175210557','2016-12-17 00:36:56','2020-09-02 10:30:06'),
  ('94','94','1','5372570890550372','2011-07-11 23:54:12','2020-09-24 04:43:10'),
  ('95','95','2','5414191594100797','2013-09-05 11:45:09','2020-09-18 05:02:29'),
  ('96','96','3','5246572801034318','2011-03-06 13:34:06','2020-09-21 01:15:50'),
  ('97','97','1','342415245065023','2012-07-24 21:58:13','2020-09-20 02:35:48'),
  ('98','98','2','5244922609060747','2013-01-17 21:07:13','2020-09-24 03:34:47'),
  ('99','99','3','5557124183459483','2019-04-09 09:04:33','2020-08-27 12:26:09'),
  ('100','100','1','5344514398948734','2018-04-11 03:06:24','2020-09-04 21:42:09');

-- orders_status_codes
INSERT INTO 
  `orders_status_codes` 
VALUES 
  ('1','Shipped','2015-01-18 20:46:23','2020-09-11 20:16:28'),
  ('2','Pending','2019-04-26 16:56:41','2020-09-26 00:55:46'),
  ('3','Awaiting Payment','2012-05-26 22:20:09','2020-09-15 21:56:54'),
  ('4','Awaiting Shipment','2018-09-29 02:35:14','2020-09-12 16:26:50'),
  ('5','Cancelled','2015-07-31 20:33:21','2020-09-25 11:00:16'),
  ('6','Completed   ','2012-10-01 22:46:52','2020-09-12 18:58:02'),
  ('7','Awaiting Fulfillment','2014-08-22 15:16:47','2020-09-23 06:25:51'),
  ('8','Refunded','2016-05-24 03:18:07','2020-09-11 14:02:18'); 
  
-- orders
INSERT INTO 
  `orders` 
VALUES 
  ('1','1','1','2020-03-26','2020-03-26 16:43:11','2020-09-26 21:54:47'),
  ('2','2','2','2019-10-22','2019-10-22 04:27:24','2020-09-08 14:47:49'),
  ('3','3','3','2020-07-31','2020-07-31 12:48:14','2020-09-17 15:33:59'),
  ('4','4','4','2020-01-16','2020-01-16 14:14:59','2020-09-04 20:50:02'),
  ('5','5','5','2020-06-30','2020-06-30 00:22:50','2020-09-15 02:21:22'),
  ('6','6','6','2020-01-31','2020-01-31 23:20:48','2020-08-31 09:07:33'),
  ('7','7','7','2020-04-25','2020-04-25 22:09:48','2020-09-21 03:53:18'),
  ('8','8','8','2016-06-14','2020-06-14 07:04:45','2020-09-13 21:06:43'),
  ('9','9','1','2019-11-04','2019-11-04 20:10:05','2020-12-01 14:35:29'),
  ('10','10','2','2020-06-04','2020-06-04 22:17:15','2020-09-20 08:39:42'),
  ('11','11','3','2020-04-06','2020-04-06 18:09:35','2020-09-25 20:50:17'),
  ('12','12','4','2020-06-15','2020-06-15 15:51:41','2020-08-30 08:29:34'),
  ('13','13','5','2020-02-07','2020-02-07 17:00:41','2020-09-21 13:54:58'),
  ('14','14','6','2020-06-11','2020-06-11 11:39:08','2020-09-20 22:21:24'),
  ('15','15','7','2020-02-13','2020-02-13 16:04:27','2020-08-28 06:50:26'),
  ('16','16','8','2020-02-27','2020-02-27 04:52:37','2020-08-30 12:43:33'),
  ('17','17','1','2019-10-13','2019-10-13 12:37:55','2020-08-29 05:40:01'),
  ('18','18','2','2019-10-09','2019-10-09 05:27:52','2020-09-19 16:42:33'),
  ('19','19','3','2020-08-10','2020-08-10 08:42:20','2020-09-24 10:36:50'),
  ('20','20','4','2020-02-19','2020-02-19 02:34:37','2020-09-18 10:14:35'),
  ('21','21','5','2019-11-06','2019-11-06 04:07:07','2020-09-12 21:14:16'),
  ('22','22','6','2020-08-10','2020-08-10 09:00:08','2020-09-15 18:12:39'),
  ('23','23','7','2020-05-05','2020-05-05 01:53:29','2020-09-21 00:32:32'),
  ('24','24','8','2019-11-14','2019-11-14 21:32:59','2020-09-10 02:25:54'),
  ('25','25','1','2019-10-21','2019-10-21 20:53:36','2020-09-02 21:40:39'),
  ('26','26','2','2020-05-12','2020-05-12 17:27:35','2020-09-11 23:01:47'),
  ('27','27','3','2019-12-22','2019-12-22 20:40:58','2020-09-19 01:13:41'),
  ('28','28','4','2020-03-23','2020-03-23 19:18:37','2020-09-13 07:38:19'),
  ('29','29','5','2020-06-27','2020-06-27 15:26:11','2020-09-07 08:05:42'),
  ('30','30','6','2020-01-09','2020-01-09 02:43:27','2020-09-26 03:55:42'),
  ('31','31','7','2020-06-26','2020-06-26 17:19:15','2020-09-04 13:01:41'),
  ('32','32','8','2020-05-14','2020-05-14 19:48:56','2020-09-19 14:20:16'),
  ('33','33','1','2020-07-14','2020-07-14 07:37:33','2020-09-19 21:29:02'),
  ('34','34','2','2020-07-21','2020-07-21 15:10:33','2020-09-15 10:33:57'),
  ('35','35','3','2019-11-06','2019-11-06 06:12:46','2020-09-08 02:20:43'),
  ('36','36','4','2020-09-01','2020-09-01 08:05:36','2020-09-15 16:57:28'),
  ('37','37','5','2020-05-13','2020-05-13 18:14:25','2020-09-18 01:13:04'),
  ('38','38','6','2020-03-07','2020-03-07 00:41:04','2020-08-29 00:55:55'),
  ('39','39','7','2020-08-17','2020-08-17 19:57:28','2020-09-06 10:50:30'),
  ('40','40','8','2020-08-10','2020-08-10 18:24:21','2020-09-17 17:42:18'),
  ('41','41','1','2020-07-15','2020-07-15 07:06:36','2020-08-27 11:51:03'),
  ('42','42','2','2020-06-19','2020-06-19 17:14:58','2020-09-22 15:34:30'),
  ('43','43','3','2020-02-11','2020-02-11 22:52:22','2020-08-28 06:17:16'),
  ('44','44','4','2020-03-04','2020-03-04 08:00:53','2020-09-14 22:36:56'),
  ('45','45','5','2020-06-08','2020-06-08 10:14:59','2020-09-25 11:00:33'),
  ('46','46','6','2020-07-23','2020-07-23 15:35:09','2020-09-06 00:55:32'),
  ('47','47','7','2019-12-24','2019-12-24 12:43:29','2020-08-31 09:37:46'),
  ('48','48','8','2020-02-29','2020-02-29 10:50:51','2020-09-03 11:02:56'),
  ('49','49','1','2020-01-04','2020-01-04 03:20:00','2020-09-07 10:49:20'),
  ('50','50','2','2020-03-14','2020-03-14 09:14:36','2020-09-16 16:14:18'),
  ('51','51','3','2020-02-18','2020-02-18 18:47:02','2020-09-08 15:54:22'),
  ('52','52','4','2019-11-08','2019-11-08 00:50:20','2020-09-10 21:36:06'),
  ('53','53','5','2020-04-02','2020-04-02 04:40:59','2020-09-22 09:35:26'),
  ('54','54','6','2020-03-27','2020-03-27 08:57:09','2020-09-09 10:16:38'),
  ('55','55','7','2019-12-10','2019-12-10 12:01:12','2020-09-21 16:07:04'),
  ('56','56','8','2020-07-28','2020-07-28 07:45:58','2020-09-03 11:14:43'),
  ('57','57','1','2020-06-12','2020-06-12 15:00:11','2020-09-01 00:29:45'),
  ('58','58','2','2020-06-24','2020-06-24 18:15:11','2020-09-20 01:25:54'),
  ('59','59','3','2019-10-23','2019-10-23 00:43:11','2020-09-15 16:01:02'),
  ('60','60','4','2019-10-16','2019-10-16 16:22:53','2020-09-06 18:20:57'),
  ('61','61','5','2020-08-09','2020-08-09 01:07:23','2020-09-24 08:41:05'),
  ('62','62','6','2020-08-29','2020-08-29 23:54:28','2020-08-30 13:30:16'),
  ('63','63','7','2019-11-26','2019-11-26 23:46:47','2020-08-31 07:33:08'),
  ('64','64','8','2020-07-27','2020-07-27 00:39:02','2020-09-15 11:01:19'),
  ('65','65','1','2020-01-30','2020-01-30 00:12:56','2020-09-20 16:51:44'),
  ('66','66','2','2020-02-26','2020-02-26 20:11:34','2020-09-01 11:46:04'),
  ('67','67','3','2020-04-08','2020-04-08 02:50:44','2020-09-07 03:18:42'),
  ('68','68','4','2019-12-21','2019-12-21 09:06:30','2020-09-05 21:34:51'),
  ('69','69','5','2020-08-22','2020-08-22 22:22:28','2020-09-17 15:00:47'),
  ('70','70','6','2020-04-02','2020-04-02 06:29:02','2020-09-17 18:29:40'),
  ('71','71','7','2020-03-18','2020-03-18 15:09:48','2020-09-09 14:06:49'),
  ('72','72','8','2019-11-24','2019-11-24 05:38:11','2020-09-24 12:43:52'),
  ('73','73','1','2020-05-18','2020-05-18 03:00:29','2020-09-11 10:36:29'),
  ('74','74','2','2020-02-04','2020-02-04 19:20:17','2020-08-28 16:15:03'),
  ('75','75','3','2013-02-02','2019-11-24 20:45:53','2020-09-03 14:26:49'),
  ('76','76','4','2019-11-24','2020-08-05 09:49:04','2020-08-28 15:36:19'),
  ('77','77','5','2020-07-08','2020-07-08 04:53:51','2020-09-19 14:36:51'),
  ('78','78','6','2020-09-19','2020-09-19 09:43:54','2020-09-20 21:44:46'),
  ('79','79','7','2019-11-22','2019-11-22 09:06:21','2020-09-10 19:30:57'),
  ('80','80','8','2020-01-01','2020-01-01 08:03:54','2020-09-21 09:49:31'),
  ('81','81','1','2019-10-21','2019-10-21 01:55:35','2020-09-24 21:17:58'),
  ('82','82','2','2019-12-06','2019-12-06 07:18:05','2020-09-19 05:56:26'),
  ('83','83','3','2020-05-17','2020-05-17 04:42:33','2020-09-09 03:24:26'),
  ('84','84','4','2020-05-01','2020-05-01 23:47:59','2020-09-13 04:09:01'),
  ('85','85','5','2019-09-30','2019-09-30 10:27:54','2020-09-23 16:08:22'),
  ('86','86','6','2020-08-30','2020-08-30 23:00:33','2020-09-20 14:29:31'),
  ('87','87','7','2020-05-14','2020-05-14 16:23:12','2020-09-08 19:39:29'),
  ('88','88','8','2020-06-08','2020-06-08 07:45:20','2020-09-13 09:02:04'),
  ('89','89','1','2020-05-17','2020-05-11 11:15:59','2020-09-03 08:32:11'),
  ('90','90','2','2020-05-11','2020-03-08 12:13:38','2020-09-19 16:07:56'),
  ('91','91','3','2020-04-27','2020-04-27 15:23:44','2020-09-12 16:52:25'),
  ('92','92','4','2019-10-10','2019-10-10 05:46:48','2020-09-03 01:48:29'),
  ('93','93','5','2020-01-19','2020-01-19 01:33:51','2020-09-02 01:01:55'),
  ('94','94','6','2020-07-22','2020-07-22 10:43:42','2020-09-17 03:47:08'),
  ('95','95','7','2019-12-16','2019-12-16 04:49:47','2020-09-14 01:33:38'),
  ('96','96','8','2020-04-21','2020-04-21 09:08:51','2020-09-07 19:26:11'),
  ('97','97','1','2020-07-28','2020-07-28 15:39:43','2020-08-27 20:24:00'),
  ('98','98','2','2020-05-04','2020-05-04 19:00:39','2020-09-05 01:14:52'),
  ('99','99','3','2019-10-03','2019-10-03 22:07:50','2020-09-07 03:29:22'),
  ('100','100','4','2020-08-19','2020-08-19 23:22:35','2020-09-16 18:01:52');

-- catalogs
INSERT INTO 
  `catalogs` 
VALUES 
  ('1','Наушники','2015-01-18 20:46:23','2020-09-11 20:16:28'),
  ('2','Видеокамеры','2019-04-26 16:56:41','2020-09-26 00:55:46'),
  ('3','Фотоаппараты','2012-05-26 22:20:09','2020-09-15 21:56:54'),
  ('4','Телевизоры','2018-09-29 02:35:14','2020-09-12 16:26:50'); 
  
-- products
INSERT INTO 
  `products` 
VALUES 
  ('1','i11 TWS 5.0','Беспроводные наушники Bluetooth','559.00','1','2017-09-11 20:16:28','2020-09-11 20:16:28'),
  ('2','Inpods 12 TWS','Проводные наушники со встроенным аккумулятором','533.00','1','2017-08-11 20:16:28','2020-08-11 20:16:28'),
  ('3','Defender Warhead G-120','Игровые наушники накладные с микрофоном','599.00','1','2017-07-11 20:16:28','2020-07-11 20:16:28'),
  ('4','STR-GSM P2P IP','Цифровая P2P IP-камера','2995.00','2','2017-06-11 20:16:28','2020-06-11 20:16:28'),
  ('5','Xiaomi Xiaobai Smart Camera 1080p','Компактная IP-камера видеонаблюдения','1888.00','2','2017-06-11 22:16:28','2020-06-11 22:16:28'),
  ('6','Canon PowerShot G7 X Mark II','Компактный беззеркальный фотоаппарат','42290.00','3','2018-06-11 22:16:28','2020-06-11 22:16:28'),
  ('7','EOS 2000D EF-S 18-55 III Kit','Компактный зеркальный фотоаппарат','26990.00','3','2018-07-11 22:16:28','2020-07-11 22:16:28'),
  ('8','ECON EX-24HS001B 24','Умный SMART LED телевизор','7590.00','4','2017-08-11 22:16:28','2020-08-11 22:16:28'),
  ('9','Xiaomi MI TV 4A 32','Телевизор c DVTB-2 тюнером','14990.00','4','2018-08-11 22:16:28','2020-08-11 22:16:28');

-- orders_products
INSERT INTO 
  `orders_products` 
VALUES 
  ('1','1','1','5','2019-12-30 03:34:38','2020-05-22 04:01:25'),
  ('2','2','2','6','2019-08-21 21:14:44','2020-01-02 13:22:36'),
  ('3','3','3','3','2019-08-07 17:22:39','2020-04-08 00:18:37'),
  ('4','4','4','3','2019-07-26 05:08:08','2020-05-29 00:09:09'),
  ('5','5','5','6','2020-01-05 08:45:28','2020-09-27 01:30:53'),
  ('6','6','6','4','2019-03-18 20:37:29','2020-03-04 05:05:10'),
  ('7','7','7','1','2019-09-23 23:39:45','2020-05-03 05:56:12'),
  ('8','8','8','7','2019-08-24 14:28:11','2020-03-18 14:00:00'),
  ('9','9','9','3','2019-09-25 19:16:03','2020-08-22 16:46:15'),
  ('10','10','1','5','2019-01-06 13:14:41','2019-10-25 11:11:23'),
  ('11','11','2','9','2019-09-22 00:15:25','2019-10-04 10:22:19'),
  ('12','12','3','2','2019-12-10 07:48:05','2020-01-10 20:17:51'),
  ('13','13','4','2','2019-06-03 08:42:56','2019-10-28 01:13:03'),
  ('14','14','5','4','2019-07-24 12:17:07','2020-09-05 09:30:00'),
  ('15','15','6','5','2019-10-05 13:48:29','2020-05-15 16:29:21'),
  ('16','16','7','7','2019-12-10 10:15:34','2020-06-01 19:59:56'),
  ('17','17','8','6','2019-04-22 10:05:11','2020-01-28 17:10:52'),
  ('18','18','9','9','2019-07-18 12:26:54','2019-12-31 01:09:33'),
  ('19','19','1','9','2019-07-13 01:06:53','2020-01-03 12:56:19'),
  ('20','20','2','3','2019-01-30 14:54:53','2020-03-31 18:29:04'),
  ('21','21','3','9','2019-04-16 10:17:13','2020-03-21 16:29:14'),
  ('22','22','4','7','2019-12-02 13:20:00','2020-06-06 15:20:10'),
  ('23','23','5','1','2019-12-24 23:05:24','2020-05-30 14:03:54'),
  ('24','24','6','3','2019-12-24 22:52:24','2019-12-31 10:18:44'),
  ('25','25','7','6','2019-04-11 20:48:24','2020-02-08 01:50:38'),
  ('26','26','8','4','2019-10-26 10:29:46','2019-10-29 10:02:13'),
  ('27','27','9','8','2019-07-03 17:57:02','2020-09-19 18:42:11'),
  ('28','28','1','9','2019-02-27 17:31:51','2020-02-16 10:01:18'),
  ('29','29','2','6','2019-03-10 11:30:26','2020-05-15 18:50:20'),
  ('30','30','3','7','2019-09-10 06:26:54','2020-07-28 17:49:39'),
  ('31','31','4','6','2019-03-04 04:59:06','2020-04-30 18:51:24'),
  ('32','32','5','8','2019-02-02 12:56:53','2020-09-12 05:04:27'),
  ('33','33','6','4','2019-12-28 01:04:50','2020-08-10 13:43:31'),
  ('34','34','7','1','2019-10-15 09:50:03','2020-01-08 19:55:46'),
  ('35','35','8','9','2019-02-09 14:10:18','2020-05-17 16:56:44'),
  ('36','36','9','3','2019-10-07 15:09:17','2019-10-28 20:36:47'),
  ('37','37','1','7','2019-09-27 03:11:46','2019-12-24 07:47:15'),
  ('38','38','2','5','2019-12-23 20:02:38','2020-05-11 16:55:24'),
  ('39','39','3','2','2019-12-20 20:21:07','2019-12-27 16:24:31'),
  ('40','40','4','6','2019-03-21 01:27:47','2019-10-21 21:38:46'),
  ('41','41','5','7','2019-01-21 23:46:03','2020-09-18 17:54:54'),
  ('42','42','6','4','2019-04-22 23:11:48','2020-05-01 06:15:32'),
  ('43','43','7','3','2019-07-24 15:28:14','2020-03-18 05:57:03'),
  ('44','44','8','9','2019-06-06 16:09:29','2019-12-21 22:05:46'),
  ('45','45','9','5','2020-08-11 18:19:30','2020-08-31 08:18:49'),
  ('46','46','1','9','2020-01-08 10:22:08','2020-01-18 04:33:08'),
  ('47','47','2','3','2019-12-19 21:50:34','2020-01-13 17:58:00'),
  ('48','48','3','3','2019-06-30 00:24:24','2019-10-07 20:38:53'),
  ('49','49','4','2','2019-09-16 18:21:56','2019-11-03 20:59:47'),
  ('50','50','5','3','2019-01-14 01:01:22','2020-02-18 01:33:14'),
  ('51','51','6','5','2020-01-30 01:00:02','2020-01-31 17:26:45'),
  ('52','52','7','8','2019-06-19 08:54:51','2020-04-13 07:08:13'),
  ('53','53','8','3','2019-07-31 15:02:22','2019-10-07 16:09:32'),
  ('54','54','9','5','2019-02-02 18:53:18','2020-06-23 01:45:05'),
  ('55','55','1','7','2019-07-09 05:18:37','2019-11-19 12:38:43'),
  ('56','56','2','6','2019-11-01 07:00:27','2019-11-01 07:14:32'),
  ('57','57','3','9','2019-08-21 09:21:01','2020-05-21 21:07:56'),
  ('58','58','4','5','2019-06-03 04:28:18','2020-06-14 14:17:11'),
  ('59','59','5','7','2019-08-24 07:13:25','2019-12-30 06:09:18'),
  ('60','60','6','4','2019-11-10 03:41:17','2020-09-01 09:39:03'),
  ('61','61','7','3','2020-01-10 02:44:39','2020-04-02 07:37:24'),
  ('62','62','8','2','2019-01-15 22:19:00','2020-03-09 16:36:16'),
  ('63','63','9','3','2019-07-22 13:05:56','2019-11-13 23:13:01'),
  ('64','64','1','3','2019-09-05 05:19:15','2020-03-11 13:00:55'),
  ('65','65','2','8','2020-01-24 03:54:38','2020-08-02 03:52:17'),
  ('66','66','3','8','2019-03-24 14:57:10','2019-11-11 06:42:53'),
  ('67','67','4','3','2019-09-20 15:04:55','2020-08-18 04:49:46'),
  ('68','68','5','3','2019-05-25 17:48:16','2019-11-17 07:58:30'),
  ('69','69','6','1','2019-07-30 09:29:23','2020-02-03 15:52:23'),
  ('70','70','7','8','2019-12-08 22:10:00','2020-02-10 17:12:45'),
  ('71','71','8','9','2019-05-02 10:52:19','2020-01-06 03:32:56'),
  ('72','72','9','7','2019-01-21 15:01:00','2020-09-14 21:02:52'),
  ('73','73','1','8','2019-02-20 09:38:42','2019-11-27 01:44:42'),
  ('74','74','2','4','2019-06-24 07:53:55','2020-05-04 21:22:16'),
  ('75','75','3','2','2020-03-08 13:00:26','2020-03-13 09:48:07'), 
  ('76','76','4','5','2019-09-17 04:00:19','2020-03-01 04:31:16'),
  ('77','77','5','3','2019-09-11 19:37:50','2020-01-17 04:58:39'),
  ('78','78','6','8','2019-05-28 16:33:37','2020-07-22 14:10:23'),
  ('79','79','7','6','2019-07-05 14:18:33','2020-05-28 01:07:12'),
  ('80','80','8','5','2020-02-05 20:36:06','2020-02-06 19:27:49'),
  ('81','81','9','8','2019-12-29 22:01:54','2020-08-07 10:50:09'),
  ('82','82','1','2','2019-06-02 00:00:22','2020-01-10 07:38:18'),
  ('83','83','2','1','2019-05-13 06:53:03','2020-01-09 05:22:11'),
  ('84','84','3','4','2019-04-04 14:19:21','2020-04-17 12:39:51'),
  ('85','85','4','5','2019-04-13 00:56:51','2019-11-18 14:02:57'),
  ('86','86','5','2','2019-11-05 13:32:16','2019-11-07 19:00:13'),
  ('87','87','6','6','2019-11-17 02:09:23','2019-12-17 09:26:37'),
  ('88','88','7','4','2019-09-19 11:13:12','2020-01-10 04:05:45'),
  ('89','89','8','8','2019-11-09 09:28:30','2020-06-08 05:01:44'),
  ('90','90','9','5','2019-06-04 13:16:38','2020-05-01 17:17:11'),
  ('91','91','1','4','2019-02-19 07:09:11','2020-07-25 05:39:30'),
  ('92','92','2','2','2019-11-29 02:42:51','2020-07-04 13:25:25'),
  ('93','93','3','7','2019-12-06 09:45:55','2020-03-18 23:16:17'),
  ('94','94','4','9','2019-05-26 00:45:01','2020-05-26 20:06:49'),
  ('95','95','5','3','2019-09-12 07:57:43','2019-10-11 22:13:29'),
  ('96','96','6','3','2019-03-22 17:03:09','2019-11-26 10:20:24'),
  ('97','97','7','5','2019-01-22 17:09:06','2019-11-23 11:11:35'),
  ('98','98','8','6','2019-12-30 12:41:09','2020-09-12 09:46:05'),
  ('99','99','9','9','2019-04-01 00:04:31','2020-02-25 19:08:41'),
  ('100','100','1','6','2019-06-01 16:27:28','2019-10-18 18:55:49');

-- storehouses
INSERT INTO 
  `storehouses` 
VALUES 
  ('1','eos','2019-02-11 13:51:55','2019-09-18 22:05:29'),
  ('2','qui','2019-02-07 13:38:35','2019-08-27 21:41:41'),
  ('3','neque','2019-01-17 03:08:35','2019-09-24 14:27:21'),
  ('4','corrupti','2019-05-08 18:50:55','2019-08-28 01:50:57'),
  ('5','temporibus','2019-04-27 06:01:01','2019-08-27 12:56:32'),
  ('6','molestiae','2019-02-08 23:03:05','2019-09-09 11:53:17'),
  ('7','saepe','2019-08-20 23:59:53','2019-09-17 22:59:28'),
  ('8','inventore','2019-04-19 17:08:26','2019-09-24 08:10:57'),
  ('9','voluptas','2019-01-07 02:41:53','2019-09-20 16:40:52'),
  ('10','nemo','2019-08-17 01:20:15','2019-09-07 12:15:13');  
  
-- storehouses_products
INSERT INTO 
  `storehouses_products` 
VALUES 
  ('1','1','1','0','2019-05-08 06:50:27','2020-09-13 10:17:53'),
  ('2','2','2','3','2019-04-12 12:14:13','2020-09-08 13:07:12'),
  ('3','3','3','4','2019-02-24 22:06:48','2020-09-06 17:31:57'),
  ('4','4','4','0','2019-06-05 13:59:32','2020-09-02 03:46:17'),
  ('5','5','5','5','2019-05-29 23:40:33','2020-08-31 10:29:06'),
  ('6','6','6','2','2019-10-06 03:38:19','2020-08-30 04:01:31'),
  ('7','7','7','5','2019-09-14 23:29:53','2020-09-05 06:15:42'),
  ('8','8','8','2','2019-07-13 09:34:52','2020-09-02 00:09:36'),
  ('9','9','9','7','2019-06-01 05:19:04','2020-09-23 03:00:07'),
  ('10','10','1','8','2019-02-11 08:01:10','2020-09-13 11:33:57'),
  ('11','1','2','9','2019-07-14 14:58:33','2020-08-27 11:17:46'),
  ('12','2','3','1','2019-04-13 06:24:03','2020-09-21 20:31:28'),
  ('13','3','4','3','2019-04-12 07:58:15','2020-09-07 11:27:50'),
  ('14','4','5','5','2019-03-13 14:12:08','2020-09-04 05:15:42'),
  ('15','5','6','5','2019-04-13 02:08:01','2020-09-16 11:12:47'),
  ('16','6','7','9','2019-11-14 14:14:27','2020-09-01 12:55:33'),
  ('17','7','8','4','2019-02-08 07:30:33','2020-09-13 18:12:21'),
  ('18','8','9','7','2019-08-21 18:02:26','2020-09-06 07:46:22'),
  ('19','9','1','8','2019-01-22 02:32:59','2020-09-13 10:43:23'),
  ('20','10','2','5','2019-06-06 00:26:17','2020-09-23 06:40:22'),
  ('21','1','3','3','2019-01-06 13:58:51','2020-09-10 00:25:51'),
  ('22','2','4','9','2019-09-19 14:19:15','2020-08-30 18:38:09'),
  ('23','3','5','5','2019-12-07 10:33:26','2020-09-03 14:50:57'),
  ('24','4','6','2','2019-02-27 22:43:22','2020-09-07 11:37:19'),
  ('25','5','7','0','2019-03-14 12:20:20','2020-08-29 23:34:41'),
  ('26','6','8','3','2019-03-27 13:23:26','2020-09-19 13:16:46'),
  ('27','7','9','9','2019-02-03 09:48:08','2020-09-06 00:27:04'),
  ('28','8','1','4','2019-05-08 10:19:19','2020-09-03 23:28:06'),
  ('29','9','2','6','2019-07-13 11:11:21','2020-09-11 19:52:45'),
  ('30','10','3','5','2019-08-08 14:32:43','2020-09-13 17:48:21'); 
  
-- shipments
INSERT INTO 
  `shipments` 
VALUES 
  ('1','1','4127391497744320','2020-01-05','2020-03-13 16:59:55','2020-09-16 00:58:00'),
  ('2','2','5179417949587166','2019-12-05','2019-12-29 20:07:26','2020-09-13 05:11:06'),
  ('3','3','5395277655101890','2020-05-30','2020-01-08 14:30:14','2020-09-05 20:52:35'),
  ('4','4','4487021806059399','2019-12-05','2020-06-16 20:52:27','2020-09-11 16:02:27'),
  ('5','5','5199786280320037','2019-10-29','2020-09-09 20:53:55','2020-09-11 19:14:32'),
  ('6','6','5500496654737515','2020-08-16','2019-11-18 18:43:08','2020-09-15 14:19:03'),
  ('7','7','5383351716674259','2020-09-15','2020-07-13 05:23:44','2020-09-04 08:10:30'),
  ('8','8','5202947070251910','2020-07-05','2020-09-10 02:34:07','2020-08-30 19:13:42'),
  ('9','9','4716084511988961','2019-12-18','2020-06-01 00:12:40','2020-08-31 00:10:07'),
  ('10','10','4716155702802','2020-01-08','2020-07-03 14:47:34','2020-09-06 10:29:38'),
  ('11','11','4916025499287','2020-09-19','2020-08-15 23:55:24','2020-08-31 19:02:02'),
  ('12','12','4929520425992963','2020-02-17','2020-04-25 05:10:35','2020-09-18 07:10:57'),
  ('13','13','4539132484005','2020-02-24','2020-08-18 04:13:59','2020-08-30 05:13:01'),
  ('14','14','6011446376617468','2020-07-28','2019-12-23 18:32:07','2020-09-16 11:33:56'),
  ('15','15','4539897344364','2020-08-13','2020-01-29 05:36:50','2020-09-24 09:41:08'),
  ('16','16','370136533970931','2019-10-06','2019-12-26 14:49:59','2020-09-22 04:07:08'),
  ('17','17','5116668382542352','2020-04-27','2020-08-22 22:55:48','2020-09-22 10:05:49'),
  ('18','18','4556503930878','2020-08-09','2020-01-17 23:04:04','2020-09-14 13:16:58'),
  ('19','19','5330775802332686','2020-09-20','2020-05-15 03:19:10','2020-08-30 20:36:06'),
  ('20','20','5129120110901663','2020-03-27','2020-06-10 21:04:22','2020-09-13 22:19:44'),
  ('21','21','4539509566678683','2019-11-14','2020-04-07 09:54:00','2020-09-23 03:04:16'),
  ('22','22','4235068607113','2020-02-19','2020-05-20 08:47:39','2020-09-21 08:48:17'),
  ('23','23','4929356159689019','2020-05-09','2020-08-15 02:03:50','2020-08-27 15:49:33'),
  ('24','24','4556480576563','2019-11-22','2020-05-04 23:58:34','2020-09-18 14:19:33'),
  ('25','25','4539031168712477','2020-06-05','2020-02-01 16:59:38','2020-09-26 17:52:13'),
  ('26','26','4539808372618','2020-08-17','2019-10-11 08:43:29','2020-08-29 04:57:21'),
  ('27','27','4539443870686827','2020-09-25','2020-05-23 06:47:00','2020-09-21 16:28:00'),
  ('28','28','5410263386234813','2020-04-02','2020-06-07 11:26:36','2020-09-02 02:08:02'),
  ('29','29','5215504548975205','2019-10-09','2020-03-13 19:30:58','2020-09-23 21:37:47'),
  ('30','30','4024007160183','2019-10-09','2020-01-22 05:02:48','2020-09-07 08:17:04'),
  ('31','31','6011974636109512','2019-11-14','2020-01-02 19:25:46','2020-08-29 07:30:12'),
  ('32','32','4539544840718','2020-08-24','2020-08-18 18:39:46','2020-09-19 04:51:34'),
  ('33','33','4929914473013','2020-07-10','2019-12-12 00:11:33','2020-09-15 07:13:03'),
  ('34','34','5436759176479183','2019-11-10','2019-12-14 05:59:20','2020-09-24 09:47:59'),
  ('35','35','5448007098989271','2020-01-12','2019-10-07 08:51:44','2020-09-01 23:10:48'),
  ('36','36','5310370534843770','2019-10-17','2020-05-22 07:19:17','2020-09-12 00:00:55'),
  ('37','37','5210856591131590','2020-07-04','2019-10-05 15:26:43','2020-08-31 22:51:17'),
  ('38','38','4539005135852086','2020-04-10','2020-06-21 06:07:13','2020-09-09 05:56:38'),
  ('39','39','5431140390029723','2020-08-11','2020-09-08 09:01:15','2020-08-31 20:53:23'),
  ('40','40','349142356392810','2020-06-21','2020-05-12 06:03:50','2020-09-14 03:59:42'),
  ('41','41','6011360953174305','2020-05-05','2019-11-06 15:55:31','2020-08-30 06:35:30'),
  ('42','42','6011032223449644','2020-06-25','2020-03-24 08:00:21','2020-09-14 19:11:59'),
  ('43','43','4532942775471','2019-11-30','2019-11-12 21:37:21','2020-09-06 17:07:33'),
  ('44','44','4485694390265717','2020-08-18','2020-07-24 10:38:34','2020-09-13 00:48:16'),
  ('45','45','5273222848858512','2019-11-22','2020-05-14 18:58:58','2020-09-12 04:30:07'),
  ('46','46','5362602613017839','2019-12-06','2020-04-20 21:37:42','2020-09-13 00:40:53'),
  ('47','47','4024007102551097','2020-01-13','2020-06-01 13:52:16','2020-09-22 17:57:30'),
  ('48','48','4916175182510','2020-03-13','2019-11-08 16:13:42','2020-09-13 19:08:48'),
  ('49','49','4532275576624389','2020-07-26','2019-10-27 16:28:50','2020-09-24 07:05:39'),
  ('50','50','4532052882833','2020-08-10','2020-01-30 18:11:49','2020-09-18 11:57:51'),
  ('51','51','5206264521464488','2020-02-03','2020-08-20 23:46:06','2020-09-16 15:41:40'),
  ('52','52','4485059479869004','2020-03-29','2020-02-13 10:00:02','2020-09-02 20:47:09'),
  ('53','53','5299728791745942','2020-02-05','2019-12-21 00:46:04','2020-09-18 04:40:16'),
  ('54','54','5490801198867554','2020-04-04','2020-01-11 04:48:38','2020-09-13 11:48:47'),
  ('55','55','4024007158631742','2020-06-19','2020-07-01 09:33:45','2020-09-02 20:41:53'),
  ('56','56','372855828357552','2019-10-31','2019-12-16 13:13:55','2020-09-22 08:11:31'),
  ('57','57','5563644374614791','2020-07-15','2020-05-08 10:45:50','2020-09-03 16:57:38'),
  ('58','58','5514132766513757','2020-03-21','2019-10-12 02:37:33','2020-09-24 00:23:59'), 
  ('59','59','4716521826908956','2020-04-24','2020-02-20 04:56:28','2020-09-10 20:19:42'),
  ('60','60','6011483378583732','2020-02-21','2020-02-22 16:17:07','2020-09-15 04:01:03'),
  ('61','61','5159464275210964','2020-07-07','2020-06-29 06:07:20','2020-09-11 20:56:41'),
  ('62','62','4539332958008','2019-10-01','2020-01-20 16:17:21','2020-09-11 22:17:39'),
  ('63','63','345472371069694','2020-01-20','2020-09-16 03:44:08','2020-08-28 14:50:29'),
  ('64','64','373233655171709','2019-12-17','2020-09-13 19:01:55','2020-09-19 14:43:41'),
  ('65','65','5271244488599540','2020-06-14','2020-08-29 09:24:14','2020-09-23 12:23:59'),
  ('66','66','5389997298543598','2020-08-07','2019-12-19 22:29:35','2020-09-13 04:10:13'),
  ('67','67','4929631478631382','2020-02-03','2020-09-04 18:57:33','2020-08-30 00:53:42'),
  ('68','68','5171551049976274','2020-07-09','2019-10-14 13:05:06','2020-09-18 02:13:46'),
  ('69','69','379275501908753','2020-01-30','2020-06-28 19:29:22','2020-08-28 07:02:06'),
  ('70','70','5521980978605736','2020-03-22','2020-08-05 12:14:30','2020-09-22 03:41:39'),
  ('71','71','5329179543484303','2020-06-10','2019-11-21 22:13:22','2020-09-20 03:33:32'),
  ('72','72','5421747352075789','2020-02-10','2020-07-04 10:28:08','2020-09-18 04:56:04'),
  ('73','73','4024007121165','2019-10-24','2020-07-11 00:17:00','2020-09-23 18:25:36'),
  ('74','74','4556829307701','2019-10-31','2019-12-30 09:54:34','2020-09-05 03:29:44'),
  ('75','75','4532485710441286','2020-06-23','2020-02-15 20:55:53','2020-09-07 17:19:28'),
  ('76','76','5141168474188017','2020-04-01','2019-10-11 20:41:25','2020-09-05 06:53:09'),
  ('77','77','5112695197511174','2019-12-08','2019-12-11 15:33:30','2020-09-18 09:05:11'),
  ('78','78','4716115748124552','2020-01-17','2020-07-18 00:49:14','2020-09-25 16:37:15'),
  ('79','79','5519995307456259','2019-11-25','2019-10-17 14:55:49','2020-09-18 00:11:50'),
  ('80','80','5206292591793001','2020-05-15','2020-09-18 21:33:53','2020-09-16 23:06:16'),
  ('81','81','5532928024842835','2020-01-29','2020-06-20 13:22:17','2020-09-15 18:20:24'),
  ('82','82','5153375842200476','2019-12-30','2020-02-28 01:24:03','2020-09-09 01:22:43'),
  ('83','83','5232902534778957','2020-02-22','2019-10-21 06:18:40','2020-09-07 22:33:19'),
  ('84','84','5280493994293859','2019-10-04','2020-02-28 21:49:42','2020-09-11 20:49:20'),
  ('85','85','4556933411661','2019-12-06','2020-08-23 06:49:00','2020-09-08 17:07:59'),
  ('86','86','5140795701371967','2020-04-20','2020-08-10 19:05:31','2020-09-07 05:15:30'),
  ('87','87','4916527578787487','2020-08-18','2020-05-30 23:29:23','2020-09-09 18:06:10'),
  ('88','88','5476073503979428','2019-11-12','2020-04-02 06:08:10','2020-09-15 06:07:41'),
  ('89','89','4485264053849','2020-03-07','2020-07-14 01:52:21','2020-09-05 23:18:35'),
  ('90','90','4668304430691','2020-04-29','2019-11-02 00:51:14','2020-09-05 11:05:47'),
  ('91','91','4088667891520570','2020-02-22','2020-02-26 09:43:51','2020-08-31 00:46:20'),
  ('92','92','4485138062636','2019-12-09','2019-12-20 13:16:46','2020-09-06 19:54:08'),
  ('93','93','4024007197152383','2020-08-21','2020-09-14 08:14:36','2020-09-14 06:49:20'),
  ('94','94','4024007107052613','2020-01-01','2020-03-31 08:45:01','2020-09-23 10:42:12'),
  ('95','95','5126412532559101','2020-03-19','2020-04-29 23:44:24','2020-08-30 17:21:34'),
  ('96','96','4823611277679','2019-12-25','2020-09-02 05:00:58','2020-09-16 11:08:06'),
  ('97','97','4624925088845','2020-09-08','2019-12-25 21:13:03','2020-09-06 15:08:45'),
  ('98','98','4532300442986','2020-01-19','2020-01-22 14:14:47','2020-08-31 15:16:46'),
  ('99','99','5590415178701015','2020-01-16','2019-10-10 03:27:33','2020-09-05 14:21:42'),
  ('100','100','5172351528229466','2019-12-01','2020-09-11 01:53:11','2020-09-12 00:56:59');
 
 
-- Приведем в порядок временные метки
UPDATE 
  shipments 
SET 
  shipment_date = (SELECT created_at FROM orders WHERE orders.id = shipments.id),
  created_at = (SELECT created_at FROM orders WHERE orders.id = shipments.id),
  updated_at = (SELECT updated_at FROM orders WHERE orders.id = shipments.id);

UPDATE 
  orders_products 
SET 
  created_at = (SELECT created_at FROM orders WHERE orders.id = orders_products.id),
  updated_at = (SELECT updated_at FROM orders WHERE orders.id = orders_products.id);
 
UPDATE 
  customers 
SET 
  created_at = (SELECT created_at FROM orders WHERE orders.id = customers.id),
  updated_at = (SELECT updated_at FROM orders WHERE orders.id = customers.id);
 
UPDATE 
  customer_payment_methods 
SET 
  created_at = (SELECT created_at FROM orders WHERE orders.id = customer_payment_methods.id),
  updated_at = (SELECT updated_at FROM orders WHERE orders.id = customer_payment_methods.id);
