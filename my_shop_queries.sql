-- Запросы

-- Создадим запрос, который будет показывать сколько всего было заказов со стороны мужчин и женщин
SELECT 
  gender, 
  COUNT(o.customer_id) AS total
FROM customers
  JOIN orders AS o
ON customers.id = o.customer_id
GROUP BY gender
ORDER BY total DESC;

-- Создадим запрос, который будет показывать 10 самых дорогих заказов
SELECT
  o.id AS order_id,
  CONCAT(c.first_name, ' ', c.last_name, ' (', c.org_name, ')') AS customer,
  (total * p.price) AS total
FROM customers as c
JOIN orders AS o
  ON c.id = o.customer_id
JOIN orders_products AS op
  ON o.id = op.order_id
JOIN products AS p
  ON op.product_id = p.id
ORDER BY total DESC LIMIT 10;

-- Создадим запрос, который будет показывать общее наличие товаров на всех складах в сумме
SELECT
  CONCAT(p.name, ' (', p.description, ')') AS product,
  SUM(sp.value) AS total
FROM products AS p
JOIN storehouses_products AS sp
  ON p.id = sp.product_id 
JOIN storehouses AS s
  ON sp.storehouse_id = s.id
GROUP BY p.id
ORDER BY total;
