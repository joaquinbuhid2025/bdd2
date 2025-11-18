-- 1) Debe actualizar el departamento de todos los empleados que trabajan en el
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

--2. Verifique en la ayuda la declaración de Variables y escriba una transacción, que:
--a) Actualice todos los sueldos de los empleados cuyo trabajo_id es ‘IT-PROG’ al sueldo
--máximo de la empresa, y a aquellos empleados que tengan el sueldo mínimo de la
--empresa incrementárselos en un 10%. Declare variables para el sueldo máximo y para
--el sueldo mínimo.
--b) Modifique la transacción anterior, que registre, usando variables en una tabla nueva
--‘LOG_CAMBIOS_SUELDO’, la fecha del día, el salario máximo anterior, el salario
--máximo nuevo, el salario mínimo anterior y el salario mínimo nuevo.
--c) Modifique la transacción anterior, agregue a la tabla ‘LOG_CAMBIOS_SUELDO’, el
--usuario conectado y la ip desde donde se ejecuta.

--a)
DECLARE @sueldo_minimo FLOAT
DECLARE @sueldo_maximo FLOAT
SET @sueldo_maximo = (SELECT MAX(TRABAJO_SAL_MAX) FROM trabajos)
SET @sueldo_minimo = (SELECT MIN(TRABAJO_SAL_MIN) FROM trabajos)
BEGIN TRANSACTION
BEGIN TRY
UPDATE empleados
SET EMPLEADO_SALARIO=@sueldo_maximo WHERE TRABAJO_ID='IT_PROG'
UPDATE empleados
SET EMPLEADO_SALARIO = @sueldo_minimo*1.10 WHERE EMPLEADO_SALARIO = @sueldo_minimo
UPDATE trabajos
SET TRABAJO_SAL_MIN = @sueldo_minimo*1.10
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
--b)
CREATE TABLE LOG_CAMBIOS_SUELDO(
LOG_ID INT IDENTITY(1,1) PRIMARY KEY,
fecha DATETIME DEFAULT GETDATE(),
SAL_MAX_ANTERIOR FLOAT,
SAL_MAX_NUEVO FLOAT,
SAL_MIN_ANTERIOR FLOAT,
SAL_MIN_NUEVO FLOAT
)
DECLARE @sueldo_minimo_viejo FLOAT
DECLARE @sueldo_maximo_viejo FLOAT
DECLARE @sueldo_minimo_nuevo FLOAT
DECLARE @sueldo_maximo_nuevo FLOAT
BEGIN TRANSACTION
	BEGIN TRY
		SET @sueldo_maximo_nuevo = (SELECT MAX(TRABAJO_SAL_MAX) FROM trabajos)
		SET @sueldo_minimo_viejo = (SELECT MIN(TRABAJO_SAL_MIN) FROM trabajos)
		UPDATE empleados
			SET EMPLEADO_SALARIO=@sueldo_maximo_nuevo WHERE TRABAJO_ID='IT_PROG'
			SET @sueldo_maximo_viejo=(SELECT EMPLEADO_SALARIO=@sueldo_maximo_nuevo FROM empleados WHERE TRABAJO_ID='IT_PROG')
			INSERT INTO LOG_CAMBIOS_SUELDO(SAL_MAX_ANTERIOR,SAL_MAX_NUEVO,SAL_MIN_ANTERIOR,SAL_MIN_NUEVO) values(@sueldo_maximo_viejo,@sueldo_maximo_nuevo,@sueldo_minimo_viejo,@sueldo_minimo_nuevo)
			SET @sueldo_minimo_nuevo = @sueldo_minimo_viejo*1.10
		UPDATE empleados
			SET EMPLEADO_SALARIO = @sueldo_minimo_nuevo WHERE EMPLEADO_SALARIO = @sueldo_minimo_viejo

		UPDATE trabajos
			SET TRABAJO_SAL_MIN = @sueldo_minimo_nuevo
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
--c)
ALTER TABLE LOG_CAMBIOS_SUELDO
ADD EMPLEADO_ID FLOAT NOT NULL, IP_ADRESS VARCHAR(20) DEFAULT '0.0.0.0'
DECLARE @sueldo_minimo_viejo FLOAT
DECLARE @sueldo_maximo_viejo FLOAT
DECLARE @sueldo_minimo_nuevo FLOAT
DECLARE @sueldo_maximo_nuevo FLOAT
DECLARE @usuario VARCHAR
DECLARE @ip_adress VARCHAR
BEGIN TRANSACTION
	BEGIN TRY
		SET @sueldo_maximo_nuevo = (SELECT MAX(TRABAJO_SAL_MAX) FROM trabajos)
		SET @sueldo_minimo_viejo = (SELECT MIN(TRABAJO_SAL_MIN) FROM trabajos)
		UPDATE empleados
			SET EMPLEADO_SALARIO=@sueldo_maximo_nuevo WHERE TRABAJO_ID='IT_PROG'
			SET @sueldo_maximo_viejo=(SELECT MAX(EMPLEADO_SALARIO) FROM empleados WHERE TRABAJO_ID='IT_PROG')
			INSERT INTO LOG_CAMBIOS_SUELDO(SAL_MAX_ANTERIOR,SAL_MAX_NUEVO,SAL_MIN_ANTERIOR,SAL_MIN_NUEVO,EMPLEADO_ID,IP_ADRESS) values(@sueldo_maximo_viejo,@sueldo_maximo_nuevo,@sueldo_minimo_viejo,@sueldo_minimo_nuevo,141,'192.168.1.114')
			SET @sueldo_minimo_nuevo = @sueldo_minimo_viejo*1.10
		UPDATE empleados
			SET EMPLEADO_SALARIO = @sueldo_minimo_nuevo WHERE EMPLEADO_SALARIO = @sueldo_minimo_viejo

		UPDATE trabajos
			SET TRABAJO_SAL_MIN = @sueldo_minimo_nuevo
		COMMIT TRANSACTION
	END TRY
BEGIN CATCH
	SELECT
	ERROR_NUMBER() AS ErrorNumber,
	ERROR_SEVERITY() AS ErrorSeverity,
	ERROR_STATE() AS ErrorState,
	ERROR_PROCEDURE() AS ErrorProcedure,
	ERROR_LINE() AS ErrorLine,
	ERROR_MESSAGE() AS ErrorMessage;
	ROLLBACK TRANSACTION
END CATCH

--Verifique en la ayuda el efecto de la sintaxis SET IMPLICIT_TRANSACTIONS ON y
--explique cómo trabajaría si elimina un registro de la tabla País seteando en ON antes
--de ejecutar el DELETE.
USE RRHH
SET IMPLICIT_TRANSACTIONS ON
DELETE FROM paises WHERE PAIS_ID = 'AR'
-- Msg 547, Level 16, State 0, Line 6
-- The DELETE statement conflicted with the REFERENCE constraint "FK_localidades_paises". The conflict occurred in database "RRHH", table "dbo.localidades", column 'PAIS_ID'.
-- The statement has been terminated.
-- Completion time: 2025-11-17T16:23:50.3341788-03:00

--4. Transacciones anidadas.
--https://programacion.net/articulo/transacciones_en_sql_server_299
--Ejemplo:
--a) Escribir una transacción TrInslocal que realiza lo siguiente:
--Inserta una nueva región (Sudamerica) en la tabla regiones
--Inserta una nuevo Pais de la tabla países (Uruguay)

--b) Escribir una transacción trUplocal que realiza lo siguiente:
--Actualiza el pais_id a Uruguay a todas las localidades con loc_id > 1600
--Actualiza el nombre de Ciudad a “Maldonado “a las localidades que tengan los
--siguientes loc_id 1700,1800,2500

--c) Escribirlas en forma anidadas, el inicio de la trUlocal debe ir dentro de la transacción
--Trinslocal
--d) Verifique los valores de la variable @@trancount cada vez que realice un BEGIN, un
--ROLLBACK y un COMMIT
--e) Verifique que ocurre cuando realiza un dentro de la transacción trUplocal un
--ROLLBACK
--f) Verifique que efecto realiza un solo COMMIT y que necesita hacer para que ambas
--transacciones se confirmen.

--a)
USE RRHH
BEGIN TRANSACTION TrInslocal
	BEGIN TRY
		DECLARE @NUEVO_ID INT
		DECLARE @region VARCHAR
		DECLARE @pais VARCHAR
		DECLARE @alias_pais VARCHAR
		SELECT @NUEVO_ID = ISNULL((MAX(REG_ID)), 0) + 1 FROM regiones
		INSERT INTO regiones values(@NUEVO_ID,@region)
		BEGIN TRANSACTION
			BEGIN TRY
				INSERT INTO paises values(@alias_pais,@pais,@NUEVO_ID)
				COMMIT TRANSACTION
			END TRY
			BEGIN CATCH
				SELECT
				ERROR_NUMBER() AS ErrorNumber,
				ERROR_SEVERITY() AS ErrorSeverity,
				ERROR_STATE() AS ErrorState,
				ERROR_PROCEDURE() AS ErrorProcedure,
				ERROR_LINE() AS ErrorLine,
				ERROR_MESSAGE() AS ErrorMessage;
				ROLLBACK TRANSACTION
			END CATCH
		COMMIT TRANSACTION
	END TRY
	BEGIN CATCH
		SELECT
		ERROR_NUMBER() AS ErrorNumber,
		ERROR_SEVERITY() AS ErrorSeverity,
		ERROR_STATE() AS ErrorState,
		ERROR_PROCEDURE() AS ErrorProcedure,
		ERROR_LINE() AS ErrorLine,
		ERROR_MESSAGE() AS ErrorMessage;
		ROLLBACK TRANSACTION
	END CATCH