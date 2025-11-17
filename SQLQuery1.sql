USE BDII;
GO

SELECT * FROM ALUMNOS;

SELECT * FROM ALUMNOS2;

SELECT * FROM NOTAS;

SELECT * FROM ASIGNATURAS;

SELECT * FROM PROYECTO;

SELECT * FROM PROYECTO2;

/*
UNION DE CONJUNTOS

La union de dos relaciones R y S, es otra relacion que contiene las tuplas  que estan en R y en S, eliminandose las duplicadas.
R y S deben ser union compatibles, que quiere decir ? deben tener la misma cantidad de atributos iguales.
No basta con un atributo en comun. OJO CON ESO
*/

SET STATISTICS TIME ON;
SET STATISTICS IO   ON;
GO

SELECT a.Nmat, a.Nombre, a.Apellidos FROM ALUMNOS a
UNION
SELECT b.Nmat, b.Nombre, b.Apellidos FROM ALUMNOS2 b OPTION (RECOMPILE);;

GO
SET STATISTICS TIME OFF;
SET STATISTICS IO   OFF;

/*
RESTA DE CONJUNTOS
La resta de R-S, es otra relacion que contiene las tuplas que estan en R pero no en S.
R y S deben ser union compatibles.
*/

/*FORMA 1*/

SET STATISTICS TIME ON;
SET STATISTICS IO   ON;
GO

SELECT a.Nmat, a.Nombre, a.Apellidos FROM ALUMNOS a
LEFT JOIN ALUMNOS2 b
	ON a.Nmat=b.Nmat
	AND a.Nombre=b.Nombre
	AND a.Apellidos=b.Apellidos
WHERE B.Nmat IS NULL;

GO
SET STATISTICS TIME OFF;
SET STATISTICS IO   OFF;

/*FORMA 2(Recomendable)*/

SET STATISTICS TIME ON;
SET STATISTICS IO   ON;
GO

SELECT a.Nmat, a.Nombre, a.Apellidos FROM ALUMNOS a
WHERE NOT EXISTS(
	SELECT 1 FROM ALUMNOS2 b
	WHERE a.Nombre=b.Nombre
);

GO
SET STATISTICS TIME OFF;
SET STATISTICS IO   OFF;

/*
Producto Cartesiano
Concatenacion de cada tupla de R con cada tupla de S.
*/

/*Forma 1(Recomendable)*/

SET STATISTICS TIME ON;
SET STATISTICS IO   ON;
GO

SELECT a.Nombre, a.Apellidos, b.NombreA, b.Precio
FROM ALUMNOS a, ASIGNATURAS b;

GO
SET STATISTICS TIME OFF;
SET STATISTICS IO   OFF;


/* Forma 2 */

SET STATISTICS TIME ON;
SET STATISTICS IO   ON;
GO

SELECT a.Nombre, a.Apellidos
FROM ALUMNOS a
CROSS JOIN ASIGNATURAS b;

GO
SET STATISTICS TIME OFF;
SET STATISTICS IO   OFF;


/*Seleccion */

SELECT b.NombreA, b.Precio FROM ASIGNATURAS b
WHERE( b.Precio >15000 );

/*Proyeccion */

SELECT b.NombreA FROM ASIGNATURAS b;

/* Interseccion */

SELECT a.Nmat, a.Nombre, a.Apellidos FROM ALUMNOS a
WHERE NOT EXISTS(
	SELECT 1 FROM ALUMNOS a1
	WHERE a.Nombre=a1.Nombre AND a.Apellidos=a1.Apellidos
	AND NOT EXISTS(
	SELECT 1 FROM ALUMNOS2 b
	WHERE b.Nombre=a1.Nombre AND b.Apellidos=a1.Apellidos
	)
);

/* Division */

SET STATISTICS TIME ON;
SET STATISTICS IO   ON;
GO

SELECT DISTINCT r.E#
FROM PROYECTO r
WHERE NOT EXISTS (
  SELECT 1
  FROM PROYECTO2 s
  WHERE NOT EXISTS (
    SELECT 1
    FROM PROYECTO r2
    WHERE r2.E# = r.E# AND r2.Proyecto = s.Proyecto
  )
)

GO
SET STATISTICS TIME OFF;
SET STATISTICS IO   OFF;


/* Selecciona los alumnos que estan en Ingles y en Dibujo */

select * from notas;
select * from asignaturas;

SELECT n1.*
FROM NOTAS n1
INNER JOIN ASIGNATURAS a1 
ON a1.CodA = n1.CodA
INNER JOIN NOTAS n2 
ON n2.Nmat = n1.Nmat 
    INNER JOIN ASIGNATURAS a2 
    ON a2.CodA = n2.CodA 
WHERE a1.NombreA = 'Ingl?s'AND a2.NombreA = 'Dibujo';

select n1.* From Notas n1 inner join Notas n2 on n2.Nmat=n1.Nmat


select distinct c.conceptoID, c.ConceptoDesc, c.ConceptoGrupo 
From Conceptos c
 inner join movimientos m on m.conceptoID= c.conceptoID and monto > 0
inner join movimientos m on m.conceptoID= c.conceptoID and monto < 0;


/* (conceptos-(conceptos-(movimientos-(movimientos-conceptos)))*/

