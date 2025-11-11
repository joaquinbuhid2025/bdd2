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
-- de la tabla titles
