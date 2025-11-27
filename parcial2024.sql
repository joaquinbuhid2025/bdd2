-- Indique la sentencia SQL para crear un stored procedure que reciba como parámetros los
-- campos ConceptoID, CajaID, Monto y Fecha para agregar un movimiento y actualizar el saldo de
-- la caja, garantizando que se hacen las dos operaciones o ninguna. El campo MovimientoID se
-- debe calcular sumando 1 al máximo MovimientoId.

CREATE PROCEDURE add_movement(@ConceptoID INT, @CajaID INT,@Monto INT, @Fecha DATE)
AS
BEGIN
DECLARE @nuevoID INT
BEGIN TRANSACTION
BEGIN TRY
SELECT @nuevoID=ISNULL(MAX(MovimientoID),0) + 1 FROM MOVIMIENTOS
INSERT INTO MOVIMIENTOS(MovimientoID,ConceptoID,CajaID,Monto,Fecha) VALUES(@nuevoID,@ConceptoID,@CajaID,@Monto,@Fecha)
UPDATE CAJAS
SET Saldo=Saldo+@Monto WHERE @CajaID=@CajaID
COMMIT TRANSACTION
END TRY
BEGIN CATCH
SELECT ERROR_MESSAGE()
ROLLBACK TRANSACTION
END CATCH
END

-- Indique la sentencia SQL para consultar los conceptos que tienen tanto movimientos de
-- ingreso (positivos) como de egreso (negativos), sin utilizar la instrucción INTERSECT.

USE BANCO
SELECT DISTINCT m.ConceptoID FROM MOVIMIENTOS m
WHERE EXISTS(
	SELECT 1 FROM MOVIMIENTOS m1
	WHERE Monto<0 AND m1.ConceptoID=m.ConceptoID AND EXISTS(
		SELECT 1 FROM MOVIMIENTOS m2
		WHERE Monto>0
		AND m2.ConceptoID=m.ConceptoID
	)
)
SELECT * FROM MOVIMIENTOS
ORDER BY ConceptoID


-- Indique la sentencia SQL para crear un trigger que al momento de actualizar el Monto de un
-- Movimiento se actualice el Saldo de la Caja asociada al movimiento. Se sabe que sólo se puede
-- modificar el campo Monto de los Movimientos.

CREATE TRIGGER upd_cajas
ON MOVIMIENTOS
AFTER UPDATE
AS
BEGIN
	DECLARE @CajaID INT
	DECLARE @Monto INT
	SELECT @CajaID=CajaID, @Monto=Monto FROM inserted
	UPDATE CAJAS
	SET Saldo=Saldo+@Monto WHERE CajaID=@CajaID
END