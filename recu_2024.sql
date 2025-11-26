--Indique la sentencia SQL para crear un stored procedure que
--reciba como parametros las fechas límites de consulta (Fecha
--desde y fecha hasta de Movimientos) indicando para cada
--movimiento el concepto, la caja, el monto, la fecha,
--un campo que indique si es ingreso o egreso.
USE BANCO
GO
CREATE PROCEDURE procedimiento(@fecha_desde DATE, @fecha_hasta DATE)
AS
BEGIN
SELECT co.ConceptoDesc, ca.CajaDesc, m.monto, m.Fecha,
CASE
WHEN m.monto<0 THEN 'EGRESO'
WHEN m.monto>0 THEN 'INGRESO'
ELSE 'ES 0'
END AS tipo_movimiento
FROM MOVIMIENTOS m
JOIN CONCEPTOS co ON co.ConceptoID=m.ConceptoID
JOIN CAJAS ca ON ca.CajaID=m.CajaID
WHERE m.Fecha>@fecha_desde AND m.Fecha<@fecha_hasta
END

EXEC procedimiento @fecha_desde='01/09/2024', @fecha_hasta='10/09/2024'

--Indique la sentencia SQL para consultar
--los conceptos que solo tienen movimientos ingresos y no tienen movimiento
--de egreso.
-- Con esto descarto los completamente negativos
USE BANCO
SELECT DISTINCT co.ConceptoDesc
FROM CONCEPTOS co
INNER JOIN MOVIMIENTOS m1 ON co.ConceptoID=m1.ConceptoID
WHERE m1.Monto>0 AND NOT EXISTS(
SELECT 1 FROM MOVIMIENTOS m2 WHERE monto<0
AND m2.ConceptoID=co.ConceptoID
)



--Indique la instrucción de SQL para establecer el nivel de aislamiento, para actualizar el cambio
--en un movimiento y el saldo de caja en una operación atómica.
SET TRANSACTION ISOLATION LEVEL SERIALIZABLE
DECLARE @id_caja INT
DECLARE @monto INT
DECLARE @saldo INT
DECLARE @id_movimiento INT
BEGIN TRANSACTION upd_money
	BEGIN TRY
		SELECT  @id_caja = CajaID FROM MOVIMIENTOS
		WHERE MovimientoID=@id_movimiento
		UPDATE MOVIMIENTOS
		SET monto=@monto
		WHERE MovimientoID=@id_movimiento
		UPDATE CAJAS
		SET saldo = saldo + @monto
		WHERE CajaID=@id_caja
		COMMIT TRANSACTION
	END TRY
	BEGIN CATCH
		SELECT ERROR_MESSAGE()
		ROLLBACK TRANSACTION
	END CATCH