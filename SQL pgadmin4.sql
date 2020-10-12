/* Установить PgAdmin4 */

/* Создать базу данных northwind */

/* Выполнить SQL norhwind.sql */

/* SELECT */
/* Выбрать все колонки из таблицы products */
SELECT * 
FROM products

/* Выбрать определенные колонки из таблицы products */
SELECT product_id, product_name, unit_price 
FROM products

/*  Математические операции */
SELECT product_id, product_name, unit_price * units_in_stock
FROM products

/* DISTINCT - набор уникальных значений 
список городов в которых проживают сотрудники работающие в компании Northwind */
SELECT DISTINCT city
FROM employees

/* Уникальные страны */
SELECT DISTINCT country
FROM employees

/* Уникальное сочетание country и city */
SELECT DISTINCT country, city
FROM employees

/* Count - подсчет значений */
SELECT COUNT(DISTINCT country)
FROM employees

/* WHERE - фильтр */
/* Контакты заказчиков где страна USA */
SELECT company_name, contact_name, phone, country
FROM customers
WHERE country = 'USA'

/* Количество продуктов с ценой больше 20 */
SELECT COUNT(*)
FROM products
WHERE unit_price > 20;

/* Все заказы больше даты */ 
SELECT *
FROM orders
WHERE order_date > '1998-03-01'

/* Логические операторы AND и OR */ 
SELECT *
FROM orders
WHERE shipped_date > '1998-04-30' AND (freight < 75 OR freight > 150);

/* BETWEEN - диапазон значений границы включаются в диапазон */
SELECT * 
FROM orders
WHERE freight BETWEEN 20 AND 40

/* IN */
SELECT *
FROM customers
WHERE country IN ('Mexico', 'Germany', 'USA', 'Canada')

/* NOT IN */
SELECT *
FROM customers
WHERE country NOT IN ('Mexico', 'Germany', 'USA', 'Canada')

/* ORDER BY сортировка - по умолчанию ASC - по возрастанию DESC - по убыванию*/
SELECT DISTINCT country, city
FROM customers
ORDER BY country DESC, city ASC

/* MIN MAX AVG SUM */
SELECT MIN(order_date)
FROM orders
WHERE ship_city = 'London'

SELECT MAX(order_date)
FROM orders
WHERE ship_city = 'London'

SELECT AVG(unit_price)
FROM products
WHERE discontinued != 1

SELECT SUM(units_in_stock)
FROM products
WHERE discontinued != 1

/* LIKE поиск в строках */
SELECT last_name, first_name
FROM employees
WHERE	first_name LIKE '%n' /* Имя заканчивающееся на n */

/* LIMIT Ограничение выборки */
SELECT product_name, unit_price
FROM products
WHERE discontinued != 1
ORDER BY unit_price DESC
LIMIT 10

/* NULL */
SELECT ship_city, ship_region, ship_country
FROM orders
WHERE ship_region IS NULL /* или IS NOT NULL */

/* GROUP BY группировка */
SELECT ship_country, COUNT(*)
FROM orders
WHERE freight > 50
GROUP BY	ship_country
ORDER BY COUNT(*) DESC

SELECT category_id, SUM(units_in_stock)
FROM products
GROUP BY category_id
ORDER BY SUM(units_in_stock) DESC
LIMIT 5

/* HAVING - пост фильтрация до сортировки */
SELECT category_id, SUM(unit_price * units_in_stock)
FROM products
WHERE discontinued <> 1
GROUP BY category_id
HAVING SUM(unit_price * units_in_stock) > 5000
ORDER BY SUM(unit_price * units_in_stock) DESC

/* UNION - объединение */
SELECT country
FROM customers
UNION /* Без дублирования, с дублированием UNION ALL */
SELECT country
FROM employees

/* INTERSECT объединение где данные пересекаются и там и там*/
SELECT country
FROM customers
INTERSECT
SELECT country
FROM employees

/* EXCEPT объединение где данные во второй таблице отсуствуют*/
SELECT country
FROM customers
EXCEPT
SELECT country
FROM employees

/* JOIN */
/* INNER JOIN Попадают только те строки которые пересекаются в используемых таблицах */
/* ( табл 1 (+) табл 2) включая дубликация данных */
SELECT product_name, suppliers.company_name, units_in_stock
FROM products
INNER JOIN suppliers ON products.supplier_id = suppliers.supplier_id
ORDER BY units_in_stock DESC

SELECT category_name, SUM(units_in_stock)
FROM products
INNER JOIN categories ON products.category_id = categories.category_id
GROUP BY category_name
ORDER BY SUM(units_in_stock) DESC
LIMIT 5

SELECT category_name, SUM(unit_price * units_in_stock)
FROM products
INNER JOIN categories ON products.category_id = categories.category_id
WHERE discontinued <> 1
GROUP BY category_name
HAVING SUM(unit_price * units_in_stock) > 5000
ORDER BY SUM(unit_price * units_in_stock) DESC

SELECT order_id, customer_id, first_name, last_name, title
FROM orders
INNER JOIN employees ON orders.employee_id = employees.employee_id

SELECT order_date, product_name, ship_country, products.unit_price, quantity, discount
FROM orders
INNER JOIN order_details ON orders.order_id = order_details.order_id
INNER JOIN products ON order_details.product_id = products.product_id

SELECT contact_name, company_name, phone, first_name, last_name, title,
		order_date, product_name, ship_country, products.unit_price, quantity, discount
FROM orders
JOIN order_details ON orders.order_id = order_details.order_id
JOIN products ON order_details.product_id = products.product_id
JOIN customers ON orders.customer_id = customers.customer_id
JOIN employees ON orders.employee_id = employees.employee_id
WHERE ship_country = 'USA'

/* LEFT OUTER JOIN Попадают все записи табл 1 а с правой если данных нет будет значение NULL */
/* ( табл 1 + (+) табл 2) включая дубликация данных */
/* RIGHT OUTER JOIN Попадают все записи правой таблицы а с левой если данных нет будет значение NULL */
/* ( табл 1 (+) + табл 2) включая дубликация данных */
SELECT company_name, order_id
FROM customers
LEFT JOIN orders ON orders.customer_id = customers.customer_id
WHERE order_id is NULL


/* FULL OUTER JOIN соединение LEFT + RIGHT OUTER JOIN */
/* ( табл 1 + (+) + табл 2) включая дубликация данных */

/* CROSS JOIN каждой записи слева сопоставляются все записи справа */

/* SELF JOIN */
/* Создайте таблицу работников где любой из них может быть менеджером другого работника */
CREATE TABLE employee (
		employee_id INT PRIMARY_KEY,
		first_name VARCHAR (255) NOT NULL,
		last_name VARCHAR (255) NOT NULL,
		manager_id INT,
		FOREIGN KEY (manager_id) REFERENCES employee (employee_id)
		);

/* Заполните таблицу данными */

/* Запрос */
SELECT e.first_name || ' ' || e.last_name as employee,
			m.first_name || ' ' || m.last_name as manager
FROM employee e
LEFT JOIN employee m ON m.employee_id = e.manager_id
ORDER BY manager


/* Сокращение записей USING */
SELECT contact_name, company_name, phone, first_name, last_name, title,
		order_date, product_name, ship_country, products.unit_price, quantity, discount
FROM orders
JOIN order_details USING(order_id) -- ON orders.order_id = order_details.order_id
JOIN products USING(product_id) --ON order_details.product_id = products.product_id
JOIN customers USING(customer_id) --ON orders.customer_id = customers.customer_id
JOIN employees USING(employee_id) --ON orders.employee_id = employees.employee_id
WHERE ship_country = 'USA'

/* Alias псевдонимы AS */
SELECT -- выполняется 4 (если здесь псевдоним)
FROM -- выполняется 1 (в 1 2 3 псевдонима еще не существует)
WHERE -- выполнятеся 2
HAVING -- выполняется 3
ORDER BY -- выполняется 5 (использовать можно только здесь)

/* Подзапросы */
/* Сделать запрос из каких стран заказчики */
SELECT DISTINCT country
FROM customers

/* Все компании поставщиков из этих стран */
SELECT company_name
FROM suppliers
WHERE country IN (SELECT DISTINCT country
						FROM customers) -- 'Aregentina', 'Spain', ...

/* Тоже самое только Без подзапроса */
SELECT DISTINCT suppliers.company_name
FROM suppliers
JOIN customers USING(country)

/* Подзапрос в LIMIT */
SELECT category_name, SUM(units_in_stock)
FROm products
INNER JOIN categories USING(category_id)
GROUP BY category_name
ORDER BY SUM(units_in_stock) DESC
LIMIT (SELECT MIN(product_id) + 4 FROM products)

/* Наличие товаров больше чем в среднем*/
/* Среднее значение количества товаров */
SELECT AVG(units_in_stock)
FROM products --~ 40

/* Используем как подзапрос */
SELECT product_name, units_in_stock
FROM products
WHERE units_in_stock > (SELECT AVG(units_in_stock)
								FROM products)
ORDER BY units_in_stock

/* Подзапросы WHERE EXISTS */
SELECT company_name, cаontact_name
FROM customers
WHERE EXISTS (SELECT customer_id FROM orders
					WHERE customer_id = customers.customer_id
					AND freight BETWEEN 50 AND 100)

/* Выбрать продукты которые не покупались в диап дат */
SELECT product_name
FROM products
WHERE NOT EXISTS (SELECT orders.order_id FROM orders
						JOIN order_details USING(order_id)
						WHERE order_details.product_id = product_id
						AND order_date BETWEEN '1995-02-01' AND '1995-02-15')

/* Все уникальные компании заказчиков которые делали заказы на более 90 товаров  */
/* Без подзапроса */
SELECT DISTINCT company_name
FROM customers
JOIN orders USING(customer_id)
JOIN order_details USING(order_id)
WHERE quantity > 90

/* С подзапросом */
SELECT DISTINCT company_name
FROM customers
WHERE customer_id = ANY(
	SELECT customer_id
	FROM orders
	JOIN order_details USING(order_id)
	WHERE quantity > 40
	)

/* Количество продуктов которые больше среднего по заказам */
SELECT DISTINCT product_name, quantity
FROM products
JOIN order_details USING(product_id)
WHERE quantity > (
	SELECT AVG(quantity)
	FROM order_details
)
ORDER BY quantity 

/* Все проукты кол-во больше среднего значения */
SELECT AVG(quantity)
FROM order_details
GROUP BY product_id

SELECT DISTINCT product_name, quantity
FROM products
JOIN order_details USING(product_id)
WHERE quantity > ALL (
	SELECT AVG(quantity)
	FROM order_details
	GROUP BY product_id)
ORDER BY quantity

/* DDL DATA DEFINITION LANGUAGE */
CREATE TABLE table_name -- Создать таблицу в существующей таблице
ALTER TABLE table_name  -- Изменить таблицу
	ADD COLUMN	column_name --Добавляем колонку
	RENAME TO new_table_name -- Перименовать таблицу
	RENAME old_column_name TO new_column_name -- Перименовать столбец
	ALTER CLOUMN column_name SET DATA TYPE data_tape --Изменить тип данных колонки
DROP TABLE table_name
TRUNCATE TABLE table_name --Удаление данных из таблицы по умолчанию не рестартит IDENTITY, чтобы рестарт сработал RESTART IDENTITY
DROP COLUMN column_name

/* FOREIGN KEY */
/* Добавление внешнего ключа при создании таблицы */
CREATE TABLE book
	(
		book_id int,
		title text NOT NULL,
		isbn varchar(32) NOT NULL,
		publisher_id int,

		CONSTRAINT PK_book_book_id PRIMARY KEY(book_id)
		CONSTRAINT FK_book_publisher FOREIGN KEY(publisher_id) REFERENCES publisher(publisher_id)
	)
/* Добавление внешнего ключа при изменении таблицы */
ALTER TABLE book
ADD CONSTRAINT FK_books_publisher FOREIGN KEY(publisher_id) REFERENCES publisher(publisher_id)

/* Удаление внешнего ключа при изменении таблицы */
ALTER TABLE book
DROP CONSTRAINT

/* Ограничения Check */
ALTER TABLE book
ADD COLUMN price decimal CONSTRAINT CHK_book_price CHECK (price >=0 ) --ограничение цены больше или равно 0
/* Любые логические условия */

/* Значения по умолчанию */
CREATE TABLE customer
	(
		customer_id serial,
		full_name text,
		status char DEFAULT 'r',

		CONSTRAINT PK_customer_customer_id PRIMARY KEY(customer_id)
		CONSTRAINT CHK_customer_status CHEK (status = 'r' OR status = 'p')
		-- По умолчанию статус r, можно вставить значение только r или p
	)
-- Удалить дефолтные значения
ALTER TABLE customer
ALTER COLUMN status DROP DEFAULT

-- Установить дефолтные значения
ALTER TABLE customer
ALTER COLUMN status SET DEFAULT 'r'

/* Последовательности (счетчик) SEQUENCE */
CREATE SEQUENCE seq1;

SELECT nextval('seq1');
SELECT currval('seq1');
SELECT lastval();

SELECT setval('seq1', 16, true -- по умолчанию)
SELECT currval('seq1'); --16
SELECT nextval('seq1'); --17

SELECT setval('seq1', 16, false)
SELECT currval('seq1'); -- 17
SELECT nextval('seq1'); --16, 17, 18, 19, 20

CREATE SEQUENCE IF NOT EXISTS seq2 INCREMENT 16
SELECT nextval('seq2'); -- 1, 17, 33, 49 (+16)

CREATE SEQUENCE IF NOT EXISTS seq3
INCREMENT 16
MINVALUE 0
MAXVALUE 128
START WITH 0
RESTART WITH 16

SELECT nextval('seq3');

ALTER SEQUENCE seq3 RENAME TO seq4 -- Переименовать
DROP SEQUENCE seq3 -- Удалить последовательность

/* Последовательность в таблицах */
CREATE TABLE book
	(
		book_id int NOT NULL,
		title text NOT NULL,
		isbn varchar(32) NOT NULL,
		publisher_id int NOT NULLm

		CONSTRAINT PK_book_book_id PRIMARY KEY(book_id)
	)

CREATE SEQUENCE IF NOT EXISTS book_book_id_seq
START WITH 1 OWNED BY book.book_id; -- назначить последовательность полю в таблице

ALTER TABLE book
ALTER COLUMN book_id SET DEFAULT nextval('book_book_id_seq')
-- тоже самое делает serial

/* Более продвинутое поле с автоинкрементом */
CREATE TABLE book
	(
		book_id int GENERATED ALWAYS IS IDENTITY NOT NULL, -- не дает явно вставить значение id, только через OVERRIDING SYSTEM VALUE
		title text NOT NULL,
		isbn varchar(32) NOT NULL,
		publisher_id int NOT NULLm

		CONSTRAINT PK_book_book_id PRIMARY KEY(book_id)
	)

/* INSERT выборки из одной таблицы в другую */
INSERT INTO best_authors
SELECT *
FROM autor 
WHERE raiting < 4.5

/* UPDATE author*/
UPDATE author
SET full_name = 'Elais', rating = 5;
WHERE author_id = 1

/* DELETE */
DELETE FROM author
WHERE rating < 4.5

TRUNCATE TABLE author;

DELETE FROM author;

/* RETURNING */
INSERT INTO book (title, isbn, publisher_id)
VALUES ('title', 'isbn', 3)
RETURNING book_id -- возвращает ийдишник записи или * все данные

UPDATE author
SET full_name = 'Walter', rating = 5
WHERE author_id = 1
RETURNING  author_id

/* VIEW - Представления */
-- VIEW - сохраненный запрос в виде объекта базы данных (виртуальная таблица)
-- к View можно стделать оычный SELECT
-- View можно соединять, делать JOIN
-- Используются для кэширования с помощью материализации
-- Сокращаяет сложные запросы
-- Позволяет подменить реальную таблицу, скрыть логику агреции данных
-- Скрыть столбцы или строки от групп пользователей

/* Синтаксис */
CREATE VIEW view_name AS
SELECT select_statement

-- нельзя удалить существующие столбцы
-- нельзя поменять имена столбцов
-- нельзя поменять порядок следования столбцов

-- можно переимновать представление
ALTER VIEW old_view_name RENAME TO new_view_name

-- модификация данных через представления
-- 1. Только одна таблица в FROM
-- 2. Нет DISTINCT, GROUP BY, HAVING, UNION, INTERSECT, EXCEPT, LIMIT
-- 3. Нет оконных функций MIN, MAX,SUM, COUNT, AVG

/* Удалить представления */
DROP VIEW IF EXISTS view_name


/* БД Northwind */
-- Создаем View
CREATE VIEW products_suppliers_categories AS
SELECT product_name, quantity_per_unit, unit_price, units_in_stock,
company_name, contact_name, phone, category_name, description
FROM products
JOIN suppliers USING(supplier_id)
JOIN categories USING(category_id);

-- View появится в Schema -> public, теперь можно сделать запрос как к обычной таблице
SELECT *
FROM products_suppliers_categories
WHERE unit_price > 20;

-- DROP удалить View
DROP VIEW IF EXISTS products_suppliers_categories

-- Создадим VIEW где находятся тяжелые заказы
CREATE VIEW heavy_orders AS 
SELECT *
FROM orders
WHERE freight > 50

-- Изменение условий
CREATE OR REPLACE VIEW heavy_orders AS
SELECT *
FROM orders
WHERE freight > 100;

-- Insert через View
INSERT INTO heavy_orders
VALUES (11078, 'VINET', 5, '2019-12-10', '2019-12-15', '2019-12-14', 1, 120,
			'Hanari Carnes', 'Rua do Paco', 'Bern', null, 3012, 'Swtzerland' );

SELECT *
FROM heavy_orders
ORDER BY order_id DESC;

-- Нельзя удалить через View данные которые есть в таблице и которых нет во View
-- Через View можно вставлять данных которые противречат фильтру WHERE во View

CREATE VIEW heavy_orders AS 
SELECT *
FROM orders
WHERE freight > 50
WITH LOCAL CHECK OPTION; -- Для того чтобы учитывался фильтр при вставке данных:
WITH CASCADE CHECK OPTION; -- Для представлений разного уровня созданных на основе других View

/* Логика CASE WHEN */
CASE 
	WHEN condition_1 THEN result_1
	WHEN condition_2 THEN result_2
	[WHEN ...]
	[ELSE result_n]
END

SELECT product_name, unit_price, units_in_stock,
	CASE WHEN units_in_stock >= 100 THEN 'lots of'
			WHEN units_in_stock >= 50 AND units_in_stock < 100 THEN 'Avarage'
			WHEN units_in_stock < 50 THEN 'Low number'
			ELSE 'unknown'
	END AS amount
FROM products
ORDER BY units_in_stock DESC

SELECT order_id, order_date,
	CASE WHEN date_part('month', order_date) BETWEEN 3 and 5 THEN 'spring'
		  WHEN date_part('month', order_date) BETWEEN 6 and 8 THEN 'summer'
		  WHEN date_part('month', order_date) BETWEEN 9 and 11 THEN 'autumn'
		  ELSE 'winter'
	END AS season
FROM orders

SELECT  product_name, unit_price,
	CASE WHEN unit_price >= 30 THEN 'Expensive'
		  WHEN unit_price < 30 THEN 'Inexpensive'
		  ELSE 'Undeterminded'
	END AS price_description
FROm products;

-- COALESCE & NULLIF
COALESCE (arg1, arg2, ...) -- возвращает первый аргумент NULL
NULLIF(arg1, arg2) -- сравнивает оба аргумента если они равны NULL, если не равны возвращает первое значение

-- примеры
-- подставить значение вместо NULL
SELECT order_id, order_date, COALESCE(ship_region, 'unknow')
FROM orders
LIMIT 10;

SELECT last_name, first_name, COALESCE(region, 'N/A') AS reigon
FROM employees

-- NULLIF как правило используется вместе с COALESCE
SELECT contact_name, COALESCE(NULLIF(city, ''), 'Unknown') AS city
FROM customers;
-- если city равен пустой строке Nullif возварщает Null, и COALESCE подменяет на Unknown

/* ПРОСТЫЕ ФУНКЦИИ */
CREATE OR REPLACE FUNCTION fix_customer_region RETURN viod AS $$
	UPDATE tmp_customers
	SET region = 'unknown'
	WHERE region IS NULL
$$ language SQL;

SELECT fix_customer_region(); -- Вызов функции

/* СКАЛЯРНЫЕ ФУНКЦИИ */
CREATE OR REPLACE FUNCTION get_total_number_of_goods() RETURNS bigint AS $$
	SELECT SUM(units_in_stock)
	FROM products
$$ LANGUAGE SQL;

SELECT get_total_number_of_goods() AS total_goods;

CREATE OR REPLACE FUNCTION get_avg_price() RETURNS float8 AS $$
	SELECT AVG(unit_price)
	FROM products
$$ LANGUAGE SQL;

SELECT get_avg_price() AS avg_price;

/* ФУНКЦИИ С АРГУМЕНТАМИ */
-- IN входящие аргументы
-- OUT исходящие аргументы
-- INOUT - и входящий и исходящий аргумент 
-- VARIADIC - массив входящих параметров
-- DEFAULT value - значение по умолчанию

-- фильтруем продукты по имени
CREATE OR REPLACE FUNCTION get_product_price_by_name(prod_name varchar) RETURNS real AS $$
	SELECT unit_price
	FROM products
	WHERE product_name = prod_name
$$ LANGUAGE SQL;

SELECT get_product_price_by_name('Chocolade') as price;


-- границы цен среди всех продуктов
CREATE OR REPLACE FUNCTION get_price_boundaries(OUT max_price real, OUT min_price real) AS $$
	SELECT MAX(unit_price), MIN(unit_price) -- соблюдать порядок следования аргументов
	FROM products
$$ LANGUAGE SQL;

SELECT * FROM get_price_boundaries();

-- Возврат множества строк
RETURNS SETOF data_type - возврат n значений типа data_type
RETURNS SETOF table - если нужно вернуть все столбцы из таблицы
RETURNS SETOF record только когда типы колонок в результирующем заранее неизвестны
RETURNS TABLE (column_name data_type ...) -тоже что и setof table явно укзать столбцы

-- Средние цены по категориям продуктов
CREATE OR REPLACE FUNCTION get_average_prices_by_prod_categories()
		RETURNS SETOF double precision AS $$
	SELECT AVG(unit_price)
	FROM products
	GROUP BY category_id
$$ LANGUAGE SQL;

SELECT * FROM get_average_prices_by_prod_categories() as average_prices;

-- с суммой
CREATE OR REPLACE FUNCTION get_avg_prices_by_prod_cats(OUT sum_price real, OUT avg_price float8)
		RETURNS SETOF RECORD AS $$
	SELECT SUM(unit_price), AVG(unit_price)
	FROM products
	GROUP BY category_id
$$ LANGUAGE SQL;

SELECT sum_price, avg_price FROM get_avg_prices_by_prod_cats();

-- нельзя использовать другие имена колонок, только через AS

-- с суммой без OUT параметров
CREATE OR REPLACE FUNCTION get_avg_prices_by_prod_cats()
		RETURNS SETOF RECORD AS $$
	SELECT SUM(unit_price), AVG(unit_price)
	FROM products
	GROUP BY category_id
$$ LANGUAGE SQL;

-- необходимо прописать явно типы данных в SELECT запросе
SELECT * FROM get_avg_prices_by_prod_cats() AS (sum_price real, avg_price float8);


-- возврат RETURNS Table
CREATE OR REPLACE FUNCTION get_customers_by_country(customer_country varchar)
		RETURNS TABLE(char_code char, company_name varchar) AS $$
	SELECT customer_id, company_name -- автоматическое сопоставление
	FROM customers
	WHERE country = customer_country
$$ LANGUAGE SQL;
SELECT * FROM get_customers_by_country('USA')
SELECT char_code, company_name FROM get_customers_by_country('USA')

/*ФУНКЦИИ PL/pgSQL*/
-- синтаксис:
CREATE FUNCTION func_name([arg1,arg2..]) RETURNS data_type AS $$
BEGIN
--logic
END; -- не забыть точку с запятой
$$ LANGUAGE plpgsql;

-- BEGIN / END - тело метода 
-- можно создавать переменные, использовать циклы, развитую логику 

-- возвращает сумму товара в продаже
CREATE OR REPLACE FUNCTION get_total_number_of_goods() RETURNS bigint AS $$
BEGIN
	RETURN sum(units_in_stock)
	FROM products;
END;
$$ LANGUAGE plpgsql;

SELECT get_total_number_of_goods();

-- максимальная цена продуктов которые исключены из продаж
CREATE OR REPLACE FUNCTION get_max_price_from_discontinued() RETURNS real AS $$
BEGIN
	RETURN max(unit_price)
	FROM products
	WHERE discontinued = 1;
END;
$$ LANGUAGE plpgsql;

SELECT get_max_price_from_discontinued();

-- максимальная и минимальная цена по unit_price
CREATE OR REPLACE FUNCTION get_price_boundaries(OUT max_price real, OUT min_price real) AS $$
BEGIN
	max_price := MAX(unit_price) FROM products;
	min_price := MIN(unit_price) FROM products;
	-- или
	-- SELECT MAX(unit_price), MIN(unit_price)
	-- INTO max_price, min_price
	-- FROM products
END;
$$ LANGUAGE plpgsql;

SELECT * FROM get_price_boundaries();

-- Сложение
CREATE OR REPLACE FUNCTION get_sum(x int, y int, out result int) AS $$
BEGIN
	result := x + y;
	RETURN; -- выход из функции
END;
$$ LANGUAGE plpgsql;

SELECT * FROM get_sum(2, 3);
-- := или = не отличается это присвоение
