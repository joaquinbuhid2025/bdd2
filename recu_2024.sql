--Indique la sentencia SQL para crear un stored procedure que
--reciba como parametros las fechas límites de consulta (Fecha
--desde y fecha hasta de Movimientos) indicando para cada
--movimiento el concepto, la caja, el monto, la fecha,
--un campo que indique si es ingreso o egreso.
USE BANCO
GO
CREATE PROCEDURE consulta_por_fechas (
@fecha_inicio DATE,
@fecha_fin DATE)
AS
BEGIN
	SELECT 
	co.ConceptoDesc, ca.CajaDesc, m.Monto, m.Fecha,
	CASE
	WHEN m.monto>0 THEN 'Ingreso'
	WHEN m.monto<0 THEN 'Egreso'
	ELSE 'Es cero'
	END AS tipo_movimiento
	FROM MOVIMIENTOS m
	JOIN CAJAS ca ON ca.CajaID=m.CajaID
	JOIN CONCEPTOS co ON co.ConceptoID=m.ConceptoID
	WHERE m.Fecha>@fecha_inicio AND m.Fecha<@fecha_fin
END

--Indique la sentencia SQL para crear un stored procedure que
--reciba como parametros las fechas límites de consulta (Fecha
--desde y fecha hasta de Movimientos) indicando para cada
--movimiento el concepto, la caja, el monto, la fecha,
--un campo que indique si es ingreso o egreso.
USE BANCO
GO
CREATE PROCEDURE consulta_por_fechas (
@fecha_inicio DATE,
@fecha_fin DATE)
AS
BEGIN
	SELECT 
	co.ConceptoDesc, ca.CajaDesc, m.Monto, m.Fecha,
	CASE
	WHEN m.monto>0 THEN 'Ingreso'
	WHEN m.monto<0 THEN 'Egreso'
	ELSE 'Es cero'
	END AS tipo_movimiento
	FROM MOVIMIENTOS m
	JOIN CAJAS ca ON ca.CajaID=m.CajaID
	JOIN CONCEPTOS co ON co.ConceptoID=m.ConceptoID
	WHERE m.Fecha>@fecha_inicio AND m.Fecha<@fecha_fin
END

--Indique la sentencia SQL para consultar
--los conceptos que solo tienen movimientos ingresos y no tienen movimiento de egreso.
-- Con esto descarto los completamente negativos
USE BANCO
SELECT DISTINCT c.ConceptoID,c.ConceptoDesc
FROM CONCEPTOS c
INNER JOIN MOVIMIENTOS m1 ON c.ConceptoID = m1.ConceptoID
WHERE m1.Monto > 0
--Con esto descarto los que tienen negativo aparte de positivo
AND NOT EXISTS (
    SELECT 1
    FROM MOVIMIENTOS m2
    WHERE m2.ConceptoID = c.ConceptoID
    AND m2.Monto < 0
)
