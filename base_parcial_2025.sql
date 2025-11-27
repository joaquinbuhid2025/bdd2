USE TRABAJO
CREATE TABLE HISTORIA(
EmpleadoID INT,
DeptID INT
)
CREATE TABLE EMPLEADOS(
EmpleadoID INT,
Nombre VARCHAR(50),
Apellido VARCHAR(50),
DeptiID INT,
JefeID INT,
Salario INT
)
CREATE TABLE LOCALIDADES(
LocID INT,
Ciudad VARCHAR(50)
)
CREATE TABLE DEPARTAMENTOS(
DeptID INT,
DeptNombre VARCHAR(50),
LocID INT,
JefeID INT
)

INSERT INTO Empleados VALUES (100, 'Steven',   'Rey',     90, NULL, 2400000);
INSERT INTO Empleados VALUES (101, 'Neena',    'Kochhar', 90, 100,   1700000);
INSERT INTO Empleados VALUES (102, 'Lex',      'DeHaan',  90, 100,   1700000);
INSERT INTO Empleados VALUES (103, 'Alejandro','Hunold',  60, 102,    900000);
INSERT INTO Empleados VALUES (104, 'Bruce',    'Ernst',   60, 103,    600000);
INSERT INTO Empleados VALUES (107, 'Diana',    'Lorentz', 60, 103,    420000);
INSERT INTO Empleados VALUES (124, 'Kevin',    'Mourgos', 50, 100,    580000);
INSERT INTO Empleados VALUES (141, 'Trenna',   'RAJS',    50, 124,    350000);
INSERT INTO Empleados VALUES (142, 'Curtis',   'Davies',  50, 124,    310000);
INSERT INTO Departamentos VALUES (50, 'Embarques',   1500, 124);
INSERT INTO Departamentos VALUES (60, 'IT',          1400, 103);
INSERT INTO Departamentos VALUES (90, 'Ejecutivos',  1700, 100);
INSERT INTO Historia VALUES (102, 60);
INSERT INTO Historia VALUES (102, 50);
INSERT INTO Historia VALUES (142, 60);
INSERT INTO Historia VALUES (142, 90);
INSERT INTO Historia VALUES (100, 60);
INSERT INTO Historia VALUES (100, 90);
INSERT INTO Historia VALUES (101, 90);
INSERT INTO Historia VALUES (102, 90);
INSERT INTO Historia VALUES (103, 60);
INSERT INTO Historia VALUES (104, 60);
INSERT INTO Historia VALUES (107, 60);
INSERT INTO Historia VALUES (124, 50);
INSERT INTO Historia VALUES (141, 50);
INSERT INTO Historia VALUES (142, 50);
INSERT INTO Localidades VALUES (1400, 'Southlake');
INSERT INTO Localidades VALUES (1500, 'San Francisco');
INSERT INTO Localidades VALUES (1700, 'Seattle');
