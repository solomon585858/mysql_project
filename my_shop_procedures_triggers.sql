-- Процедуры

-- Создадим процедуру, которая будет давать возможноcть узнать логин пользователя по его id
-- Пример запуска - CALL login(11, @login);
DELIMITER //

CREATE PROCEDURE login (IN customer_number INT, OUT login VARCHAR(20))
  BEGIN
    SELECT login_name INTO login FROM customers
    WHERE id = customer_number;
  END//

DELIMITER ;

-- Создадим процедуру, которая будет давать возможноcть узнать статус заказа по логину пользователя
-- Пример запуска - CALL order_status('salvatore25', @status);
DELIMITER //

CREATE PROCEDURE order_status (IN login VARCHAR(20), OUT status VARCHAR(20))
  BEGIN
	SELECT 
	  s.status_name
    FROM orders AS o
    JOIN customers as c
      ON o.customer_id = c.id
    JOIN orders_status_codes s
      ON o.status_code = s.id
    WHERE c.login_name = login;  
  END//

DELIMITER ;


-- Триггеры

-- Создадим триггеры для таблицы products, которые будут запрещать добавление или обновление позиций в таблице, когда и поле name, и поле description принимают неопределенное значение NULL
DELIMITER //

DROP TRIGGER IF EXISTS check_null_insert//

CREATE TRIGGER check_null_insert BEFORE INSERT ON products
FOR EACH ROW
BEGIN
	IF NEW.name IS NULL AND NEW.description IS NULL THEN
		SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Both name and description can not be NULL';
	END IF;
END //

DROP TRIGGER IF EXISTS check_null_update//

CREATE TRIGGER check_null_update BEFORE UPDATE ON products
FOR EACH ROW
BEGIN
	IF NEW.name IS NULL AND NEW.description IS NULL THEN
		SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Both name and description can not be NULL';
	END IF;
END //

DELIMITER ;
