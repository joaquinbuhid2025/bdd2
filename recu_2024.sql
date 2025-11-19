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