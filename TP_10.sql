USE RRHH
GO
CREATE TRIGGER punto1a
ON empleados
AFTER UPDATE
AS
BEGIN
	DECLARE @fecha DATE
	SELECT @fecha = GETDATE()
	DECLARE @operacion VARCHAR
	SELECT @operacion = 'UPD'
	DECLARE @id_empleado INT
	SELECT @id_empleado = deleted.EMPLEADO_ID FROM deleted
	INSERT INTO controles(fecha,operacion,empleado) values(@fecha,@operacion,@id_empleado)
END

USE RRHH
UPDATE empleados
SET EMPLEADO_NOMBRE = 'JOAQUINNN' WHERE EMPLEADO_ID = 1

SELECT * FROM controles

USE RRHH
GO
CREATE TRIGGER punto1b
ON empleados
AFTER INSERT
AS
BEGIN
	DECLARE @fecha DATE
	SELECT @fecha = GETDATE()
	DECLARE @operacion VARCHAR
	SELECT @operacion = 'UPD'
	INSERT INTO controles(fecha,operacion,empleado) values(@fecha,@operacion,NULL)
END

UPDATE empleados
SET EMPLEADO_NOMBRE = 'JOAQUINNN' WHERE EMPLEADO_ID = 100


INSERT INTO empleados(EMPLEADO_ID,EMPLEADO_NOMBRE,EMPLEADO_APELLIDO,EMPLEADO_EMAIL,EMPLEADO_TEL,EMPLEADO_FECING,TRABAJO_ID,EMPLEADO_SALARIO,COMMISSION_PCT) values(1,'Ivan','Añañin','ivannññn@gmail.ar','3871234567',21/8/2024,2,120000,'no se')
USE RRHH
SELECT * FROM controles