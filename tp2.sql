--EJERCICIO 1
-- Genere una lista de selección de la tabla Employees donde solo se genere en una sola columna de salida. Concatenados los campos: EmployeeID, LastName y
-- FirstName. (coloque un “- “entre cada valor)
USE Northwind
GO
SELECT CONCAT (E.EmployeeID,' - ', E.LastName,' - ', E.FirstName) AS columna
FROM Employees E

--EJERCICIO 2
-- Listar los productos (Tabla Products) cuyos valores se encuentran entre los 4 y 20 dólares.
USE Northwind
GO
SELECT ProductID, ProductName, UnitPrice
FROM Products
WHERE UnitPrice  > 4 OR UnitPrice  < 20

-- EJERCICIO 3
-- Liste los campos de la tabla productos que tengan exactamente un precio de 18, 19 y 10 dólares
USE Northwind
GO
SELECT ProductID, ProductName, UnitPrice
FROM Products
WHERE UnitPrice = 18 OR UnitPrice = 19 OR UnitPrice = 10
ORDER BY UnitPrice

--EJERCICIO 4
-- Liste todos los campos de la tabla Suppliers que no tienen registrado datos en las columnas fax o homepage. Luego use una función para que en vez de mostrar null
-- muestre el texto “sin registrar”.
