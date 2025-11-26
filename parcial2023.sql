-- 1.	a. Indique la sentencia SQL para obtener los nombres y apellidos de
-- los pacientes, nombre y apellido de los titulares en los casos que no
-- sean titulares sino "", y la clínica en que fue dispensado el medicamento,
-- que tuvieron dispensas en el mes de septiembre de 2023. (2ptos)
USE FARMACIA
SELECT p.Nombre, p.Apellido, ISNULL(t.Nombre,'"') AS TitularNom, ISNULL(t.Apellido,'"') AS TitularApe, c.ClinicaDesc
FROM PACIENTES p
LEFT JOIN PACIENTES t ON p.TitularID=t.TitularID AND p.titularID <> 0
INNER JOIN DISPENSAS d ON d.PacienteID=p.PacienteID
INNER JOIN CLINICAS c ON c.ClinicaID=d.ClinicaID
WHERE MONTH(d.Fecha)=9 AND YEAR(d.Fecha)=2023

-- 2. Indique la sentencia SQL para obtener los nombres y apellidos de los
-- pacientes que han recibido las dispensas de todas las monodrogas. (2ptos)
USE FARMACIA
SELECT p.Nombre, p.Apellido FROM PACIENTES p
WHERE NOT EXISTS(
	SELECT 1 FROM MEDICAMENTOS m
		WHERE NOT EXISTS(
			SELECT 1 FROM DISPENSAS d
			INNER JOIN MEDICAMENTOS m2 ON m2.MedMonodroga=m.MedMonodroga
			WHERE p.PacienteID=d.PacienteID
			AND d.MedID = m.MedID
		)
)
