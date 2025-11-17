-- Debe actualizar el departamento de todos los empleados que trabajan en el
-- departamento 50, cambiarlo por el departamento 90. Además, estos empleados
-- trabajarán en un nuevo país, para esto agregue en la tabla países un nuevo país
-- Argentina y agregar una nueva localidad “Cordoba” que tenga ese nuevo país.
-- a) Cancele la transacción y verifique.
-- b) Confirme la transacción y verifique.
USE RRHH
PRINT '--- ANTES DE LA TRANSACCIÓN ---'
SELECT * FROM paises WHERE PAIS_ID = 'AR'
SELECT * FROM localidades WHERE LOC_ID = 5200
SELECT * FROM empleados WHERE DEPT_ID IN (50, 90)
BEGIN TRANSACTION
	BEGIN TRY
		INSERT INTO paises values('AR','Argentina',2)
		INSERT INTO localidades values(5200,'Finlay 126','5152','Cordoba','Cordoba','AR')
		UPDATE empleados
		SET DEPT_ID=90
		WHERE DEPT_ID=50
		PRINT '--- DENTRO DE LA TRANSACCIÓN (antes de confirmar) ---'
		SELECT * FROM paises WHERE PAIS_ID = 'AR'
		SELECT * FROM localidades WHERE LOC_ID = 5200
		SELECT * FROM empleados WHERE DEPT_ID IN (50, 90)
		COMMIT TRANSACTION
	END TRY
	BEGIN CATCH
		SELECT
        ERROR_NUMBER() AS ErrorNumber
        ,ERROR_SEVERITY() AS ErrorSeverity
        ,ERROR_STATE() AS ErrorState
        ,ERROR_PROCEDURE() AS ErrorProcedure
        ,ERROR_LINE() AS ErrorLine
        ,ERROR_MESSAGE() AS ErrorMessage;
		ROLLBACK TRANSACTION
	END CATCH
PRINT '--- DESPUES DE LA TRANSACCIÓN (para confirmar) ---'
SELECT * FROM paises WHERE PAIS_ID = 'AR'
SELECT * FROM localidades WHERE LOC_ID = 5200
SELECT * FROM empleados WHERE DEPT_ID IN (50, 90)