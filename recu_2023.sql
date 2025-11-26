-- 1.	Indique la sentencia SQL para crear un trigger que al momento de actualizar un medicamento
-- de alta en la tabla LOG el texto anterior y el texto nuevo de MedDesc. Se insertarán los
-- campos MedId, MedDesc Anterior y fecha y hora del momento de la operación y en otro registro
-- similar pero con la MedDesc Nueva. (2 ptos)

USE sanatorio
GO
CREATE TRIGGER UPD_LOG
ON MEDICAMENTOS
AFTER UPDATE
AS
BEGIN
INSERT INTO LOGG(ObjetoID,Operacion,FechaHora) 
SELECT
deleted.MedID,
deleted.MedDesc,
GETDATE()
FROM deleted

INSERT INTO LOGG(ObjetoID, Operacion, FechaHora)
SELECT
inserted.MedId,
inserted.MedDesc,
GETDATE()
FROM inserted
END

UPDATE MEDICAMENTOS
SET MedDesc = 'fentanilo puro' WHERE MedID=1
SELECT * FROM LOGG
ORDER BY FechaHora ASC


-- 2.	Indique la sentencia SQL para crear un stored procedure que reciba como parámetro la fecha
-- desde y hasta que se quiere consultar dispensas (Fecha) indicando los nombres, apellidos y
-- descripciones de las provincias de los pacientes, la fecha de dispensa y los parámetros de
-- entrada. Si no tiene asignada provincia indicar “-”. Sólo considerar titulares. (2ptos)
CREATE PROCEDURE buscar_dispensas(@fecha_desde DATE, @fecha_hasta DATE)
AS
BEGIN
SELECT pa.Nombre, pa.Apellido, ISNULL(pr.ProvinciaDesc,'"'), d.Fecha, @fecha_desde,@fecha_hasta FROM DISPENSAS d
INNER JOIN PACIENTES pa ON pa.PacienteID = d.PacienteID AND pa.TitularID=0
INNER JOIN PROVINCIAS pr ON pr.ProvinciaID=pa.ProvinciaID
WHERE d.Fecha>@fecha_desde AND d.Fecha<@fecha_hasta
END
EXEC buscar_dispensas @fecha_desde='01/08/2020', @fecha_hasta='10/08/2024'

-- 3.	Indique la sentencia SQL para obtener los nombres de las clínicas (ClinicaDesc) que han
-- atendido (dispensado medicamentos) a pacientes de todas las provincias (Salta y CABA). (2ptos)

SELECT c.ClinicaDesc FROM CLINICAS c
WHERE NOT EXISTS(
	SELECT 1 FROM PROVINCIAS pr
	WHERE NOT EXISTS(
		SELECT 1 FROM DISPENSAS d
		INNER JOIN PACIENTES pa ON pa.PacienteID=d.PacienteID
		WHERE pr.ProvinciaID=pa.ProvinciaID
		AND c.ClinicaID=d.ClinicaID
	)
)

-- 5.	Indique la sentencia SQL para obtener para cada Clínica, la cantidad de monodrogas
-- dispensadas, siempre que la cantidad sea mayor a 1. (2ptos)

SELECT c.ClinicaDesc, m.MedMonodroga, COUNT(m.MedMonodroga) 'Cantidad' FROM CLINICAS c
INNER JOIN DISPENSAS d ON d.ClinicaID=c.ClinicaID
INNER JOIN MEDICAMENTOS m ON d.MedID=m.MedID
GROUP BY ClinicaDesc, m.MedMonodroga
HAVING COUNT(m.MedMonodroga)>1
ORDER BY ClinicaDesc