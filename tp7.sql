-- Para recuperar la información de un autor cuyo ID comienza con el número
-- 724, sabiendo que cada ID tiene el formato de tres dígitos seguidos por un
-- guion, seguido por dos dígitos, otro guion y finalmente cuatro dígitos.
-- Utilizar el comodín
USE pubs
SELECT a.au_id, a.au_lname, a.au_fname FROM authors a
WHERE  LEFT(a.au_id,3)=724

-- Puede averiguar el precio promedio de todos los libros si se duplicaran los
-- precios (tabla titles).
USE pubs
SELECT AVG(2*t.price) FROM titles t

-- Muestre una lista de precios de los títulos, nombre y precio. Agregue en una
-- nueva columna el precio actualizado en un 30%.
USE pubs
SELECT t.title, t.price, t.price*1.3 'precio actualizado' FROM titles t

-- Muestre el mayor valor de las ventas del año (ytd_sales) de todos los libros
-- de la tabla titles (será asi?)
USE pubs
SELECT MAX(t.ytd_sales) FROM titles t

--Muestre el mínimo valor de las ventas del año (ytd_sales) de todos los libros
--de la tabla titles. (será asi?)
USE pubs
SELECT MIN(t.ytd_sales) FROM titles t

--Muestre de de la tabla titles los registros cuyos precios están en nulo.
SELECT title_id, title, type, pub_id,price, advance, royalty, ytd_sales, notes, pubdate FROM titles
WHERE price IS NULL

--Cuente los datos de la tabla titles, cuyo tipo (TYPE) sea business
SELECT COUNT(1) 'titulos tipo busiess' FROM titles
WHERE type='business'

--Mostrar los Stores cuyo nombre contenga la palabra book.
SELECT * FROM stores
WHERE stor_name LIKE '%book%'

--Mostrar los empleados con apellidos que empiezan con J o con C
SELECT emp_id,fname,lname,job_id,job_lvl,pub_id,hire_date FROM employee
WHERE LEFT(fname,1)='J' OR LEFT(fname,1)='C'

--Reconstruya la venta con id P3087a, mostrar fecha, nombre de la tienda 
--donde se realizó (store), el nombre del libro, precio unitario del libro y
--subtotal
SELECT DISTINCT s.ord_date 'fecha', st.stor_name 'nombre de la tienda', t.title 'Libro',t.price 'precio', t.price*s.qty 'subtotal' FROM sales s
JOIN stores st ON s.stor_id=st.stor_id
JOIN titles t ON t.title_id=s.title_id
WHERE s.ord_num = 'P3087a'

--Mostrar los títulos que superan el precio promedio de todos los títulos.
-- nose si hacerlo asi
SELECT t.title, t.price
FROM titles AS t
WHERE t.price > (SELECT AVG(price) FROM titles);
--o asi (este es durisimo:)
WITH t AS (
  SELECT title, price, type,
         AVG(price) OVER (PARTITION BY type) AS avg_type
  FROM dbo.titles
)
SELECT title, type, price, avg_type
FROM t
WHERE price > avg_type
ORDER BY type, price DESC;

--Mostrar los autores que tengan la misma ciudad que el autor con apellido Green.
SELECT a.au_fname, a.city
FROM authors a
WHERE a.city=(SELECT city FROM authors WHERE au_lname='Green')

--Liste la suma de las ventas por año (ytd_sales) hasta la fecha, clasificándolas
--por tipo (TYPE) de título (titles).
SELECT
  t.type,
  SUM(t.ytd_sales) 'ytd_ventas_unidades'
FROM titles AS t
GROUP BY t.type
ORDER BY t.type;

--Liste las sumas de las ventas por año (ydt_sales) hasta la fecha,
--agrupándolas por tipo (TYPE) y pub_id.
SELECT
  t.type,
  t.pub_id,
  SUM(t.ytd_sales) AS ytd_ventas_unidades
FROM dbo.titles AS t
GROUP BY t.type, t.pub_id
ORDER BY t.type, t.pub_id;

-- Utilizando el último ejemplo. Liste solamente los grupos cuyo pub_id sea
-- igual a 0877. Pista, usar having
USE pubs
SELECT
  t.type,
  t.pub_id,
  SUM(t.ytd_sales) AS ytd_ventas_unidades
FROM dbo.titles AS t
GROUP BY t.type, t.pub_id
HAVING t.pub_id = '0877'   -- o 877 si es numérico
ORDER BY t.type, t.pub_id;

-- Unir las tablas stores y discounts para mostrar que tienda (stor_id) ofrece
-- un descuento y el tipo de descuento (discounttype). Hacerlo de dos formas,
-- con producto cartesiano y con INNER JOIN.
--Producto cartesiano:
USE pubs
SELECT s.stor_id, d.discounttype FROM stores s, discounts d
WHERE s.stor_id=d.stor_id
--INNER JOIN:
SELECT s.stor_id, d.discounttype FROM stores s
INNER JOIN discounts d ON d.stor_id=s.stor_id

--Utilice el mismo ejemplo anterior solo utilice la instrucción FULL OUTER
--JOIN. Explique el resultado
-- FULL OUTER JOIN = LEFT JOIN + RIGHT JOIN juntos.
-- Es decir, te devuelve:
-- Tiendas que tienen descuentos
-- Coinciden s.stor_id = d.stor_id.
-- Verás el stor_id y el discounttype completo.
-- Si una tienda tiene varios descuentos, aparece repetida (una fila por cada descuento).
USE pubs
SELECT s.stor_id, d.discounttype FROM stores s
FULL OUTER JOIN discounts d ON d.stor_id=s.stor_id

--Utilice el mismo ejemplo anterior solo utilice en el from la instrucción LEFT
--OUTER JOIN. Explique el resultado
USE pubs
SELECT s.stor_id, d.discounttype FROM stores s
LEFT OUTER JOIN discounts d ON d.stor_id=s.stor_id
--Va a mostrar todas las tiendas, pero si no hay descuentos, no aparecerá ninguna fila.

-- Utilice el mismo ejemplo anterior solo utilice en el from la instrucción RIGHT
-- OUTER JOIN. Explique el resultado.
USE pubs
SELECT s.stor_id, d.discounttype FROM stores s
RIGHT OUTER JOIN discounts d ON d.stor_id=s.stor_id
--Va a mostrar todas las tiendas, pero si no hay descuentos, aparecerá una fila

-- Listar los tipos de títulos (type), ordenados por cantidad de ventas
-- realizadas (sales.qty). Solo muestre aquellos que vendieron más de 60
-- unidades:
USE pubs
SELECT t.type, s.qty FROM titles t
JOIN sales s ON s.title_id=t.title_id
WHERE s.qty>60
ORDER BY s.qty

-- Listado de cantidad de libros vendidos por año. Ordenarlo:
USE pubs
SELECT YEAR(s.ord_date), count(s.ord_date) FROM sales s
GROUP BY YEAR(s.ord_date)

-- Listar el ranking de cantidad de ventas por Nombre de Publishers
USE pubs;
SELECT 
    p.pub_name,
    SUM(s.qty) AS total_ventas
FROM publishers p
INNER JOIN titles AS t
    ON p.pub_id = t.pub_id
INNER JOIN sales AS s
    ON t.title_id = s.title_id
GROUP BY 
    p.pub_name
ORDER BY 
    total_ventas DESC;
