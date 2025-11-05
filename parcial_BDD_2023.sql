--PARCIAL 1er2023
USE sanatorio
SELECT P.Nombre, P.Apellido,
CASE
	WHEN P.TitularID =0 THEN '-'
	ELSE P.Nombre
END AS TitularNom,
CASE
	WHEN P.TitularID =0 THEN '-'
	ELSE P.Apellido
END AS TitularApe,
C.ClinicaDesc
FROM DISPENSAS D
LEFT JOIN PACIENTES P ON D.PacienteID=P.PacienteID
LEFT JOIN CLINICAS C ON D.ClinicaID=C.ClinicaID

WHERE MONTH(D.Fecha)=9 AND YEAR(D.Fecha)=2023

USE sanatorio;
SELECT P.PacienteID, COUNT(D.DispensaID) AS medicamentos
FROM PACIENTES P
INNER JOIN DISPENSAS D ON D.PacienteID = P.PacienteID
GROUP BY P.PacienteID
HAVING COUNT(D.DispensaID) = 4;
