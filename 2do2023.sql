-EJERCIO 1 (hay q usar la base de datos base_parcial.sql)
USE sanatorio

BEGIN TRANSACTION;
	BEGIN TRY
		INSERT INTO PACIENTES VALUES(6,'Fernando','Rivera',1,0)
		INSERT INTO LOGG VALUES(0,'ALTA PACIENTE',GETDATE())
		COMMIT TRANSACTION
	END TRY
	BEGIN CATCH
		SELECT
		ERROR_MESSAGE() AS ErrorMessage
		ROLLBACK TRANSACTION
	END CATCH

declare @ProvinciaID as int = 1
declare @Fecha as date = null
go
create procedure getdatte3(@ProvinciaID int, @Fecha date = null) as 
begin

SELECT C.ClinicaDesc, D.Fecha, C.ProvinciaID
	FROM  CLINICAS C
	JOIN DISPENSAS D ON D.ClinicaID=C.ClinicaID
	WHERE C.ProvinciaID = @ProvinciaID AND (@Fecha IS NULL OR D.Fecha = @Fecha)

end

exec getdatte3 @ProvinciaID=1, @Fecha = '09/01/2023'

