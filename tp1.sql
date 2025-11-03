--creacion de la tabla:
CREATE DATABASE tp1
USE tp1
CREATE TABLE A(
name VARCHAR(20),
address VARCHAR(30),
gender VARCHAR(5),
birthdate DATE,
primary_key INT)

CREATE TABLE B(
name VARCHAR(20),
address VARCHAR(30),
gender VARCHAR(5),
birthdate DATE,
primary_key INT)

INSERT INTO A values('Carrie Fisher','123 Maple St.','F','9/9/99',1)
INSERT INTO A values('Mark Hamill','456 Oak Rd.','M','8/8/88',2)

INSERT INTO B values('Harrison Ford','789 Palm Dr.','M','7/7/77',2)
INSERT INTO B values('Carrie Fisher','123 Maple St.','F','9/9/99',1)

--Ejercicio 1
-- a) Realizar unión (AUB), intersección (AΩB) resta (A-B) de estas tablas mostrar los
-- resultados como tablas
-- b) Realizar las mismas operaciones mediante sentencias SQL
-- c) ¿Qué ocurre si la Tabla A no tiene la columna gender, que operaciones se
-- podrían hacer y cuáles no?
--b)

--  AUB
USE tp1;
SELECT A.* FROM A
UNION
SELECT B.* FROM B;

--la interseccion en SQL es R-(R-S), en este caso A-(A-B)
USE tp1;
SELECT A.* -- primer A
FROM A
WHERE NOT EXISTS (
    SELECT 1
    FROM A AS A_inner --segundo A
    WHERE A_inner.name = A.name  -- Comparar por nombre, no por primary_key
    AND NOT EXISTS (
        SELECT 1
        FROM B
        WHERE B.name = A_inner.name  -- Comparar por nombre
    )
);

--  A-B
USE tp1;
SELECT A.* FROM A
WHERE NOT EXISTS (
        SELECT 1 FROM B
        WHERE B.name = A.name  -- Comparar por nombre
);

