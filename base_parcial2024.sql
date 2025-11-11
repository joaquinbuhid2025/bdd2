CREATE DATABASE  BANCO

USE BANCO

CREATE TABLE CAJAS(
CajaID INT,
CajaDesc VARCHAR(20),
Saldo INT
)

CREATE TABLE MOVIMIENTOS(
MovimientoID INT,
ConceptoID INT,
CajaID INT,
Monto INT,
Fecha DATE
)

CREATE TABLE CONCEPTOS(
ConceptoID INT,
ConceptoDesc VARCHAR(30),
ConceptoGrupo VARCHAR(30)
)

INSERT INTO CAJAS (CajaID, CajaDesc, Saldo) VALUES
(1, 'Administracion', 0),
(2, 'Punto de Venta 1', 1120000),
(3, 'Banco ABCB', -110000);

INSERT INTO CONCEPTOS (ConceptoID, ConceptoDesc, ConceptoGrupo) VALUES
(1, 'Electricidad', 'GASTOS'),
(2, 'Alquileres', 'ALQUILERES'),
(3, 'Gas', 'GASTOS'),
(4, 'Generales', 'SERVICIOS'),
(5, 'Servicios Industriales', 'SERVICIOS'),
(6, 'Limpieza', 'SERVICIOS');

INSERT INTO MOVIMIENTOS (MovimientoID, ConceptoID, CajaID, Monto, Fecha) VALUES
(1, 1, 1, -230000, '2024-09-01'),
(2, 2, 3, -270000, '2024-09-01'),
(3, 2, 3, -300000, '2024-09-01'),
(4, 2, 2,  800000, '2024-09-08'),
(5, 5, 3,  200000, '2024-09-09'),
(6, 4, 3,  390000, '2024-09-10'),
(7, 1, 1, -230000, '2024-10-01'),
(8, 3, 3, -250000, '2024-10-01'),
(9, 3, 3, -240000, '2024-10-02'),
(10, 2, 2,  600000, '2024-10-02'),
(11, 5, 1,  120000, '2024-10-02'),
(12, 5, 3,  620000, '2024-10-03');
