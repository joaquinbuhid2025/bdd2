CREATE DATABASE DBIII
USE DBIII;
GO

CREATE TABLE dbo.CAJAS (
    CajaID   INT         NOT NULL PRIMARY KEY,
    CajaDesc VARCHAR(50) NOT NULL,
    Saldo    INT         NOT NULL
);
GO

-- CONCEPTOS
CREATE TABLE dbo.CONCEPTOS (
    ConceptoID    INT         NOT NULL PRIMARY KEY,
    ConceptoDesc  VARCHAR(50) NOT NULL,
    ConceptoGrupo VARCHAR(30) NOT NULL
);
GO

-- MOVIMIENTOS
CREATE TABLE dbo.MOVIMIENTOS (
    MovimientoID    INT      NOT NULL PRIMARY KEY,
    ConceptoID      INT      NOT NULL,
    CajaID          INT      NOT NULL,
    Monto           INT      NOT NULL,      -- si usás centavos: DECIMAL(18,2)
    Fecha           DATE     NOT NULL,
    MovimientoOrigID INT     NOT NULL DEFAULT(0), -- 0 = original; >0 = id del mov. original ajustado
    CONSTRAINT FK_Mov_Concepto FOREIGN KEY (ConceptoID) REFERENCES dbo.CONCEPTOS(ConceptoID),
    CONSTRAINT FK_Mov_Caja      FOREIGN KEY (CajaID)     REFERENCES dbo.CAJAS(CajaID)
);
GO

-- LOG
CREATE TABLE dbo.LOG (
    ObjetoID             INT          NOT NULL,
    OperacionDescripcion VARCHAR(200) NOT NULL,
    FechaHora            DATETIME2    NOT NULL DEFAULT SYSUTCDATETIME()
);
GO

/* =======================
   INSERTS (según enunciado)
   ======================= */

-- CAJAS
INSERT INTO dbo.CAJAS (CajaID, CajaDesc, Saldo) VALUES
(1, 'Administracion',      0),
(2, 'Punto de Venta 1', 1120000),
(3, 'Banco ABCB',      -110000);
GO

-- CONCEPTOS
INSERT INTO dbo.CONCEPTOS (ConceptoID, ConceptoDesc, ConceptoGrupo) VALUES
(1, 'Electricidad',           'GASTOS'),
(2, 'Alquileres',             'ALQUILERES'),
(3, 'Gas',                    'GASTOS'),
(4, 'Generales',              'SERVICIOS'),
(5, 'Servicios Industriales', 'SERVICIOS'),
(6, 'Limpieza',               'SERVICIOS');
GO

-- MOVIMIENTOS  (MovimientoOrigID en 0 por defecto; ajustalo si necesitás enlazar ajustes)
INSERT INTO dbo.MOVIMIENTOS (MovimientoID, ConceptoID, CajaID, Monto,   Fecha,       MovimientoOrigID) VALUES
( 1, 1, 1,  -230000, '2024-09-01', 0),
( 2, 1, 1,  -270000, '2024-09-01', 0),
( 3, 1, 1,  -300000, '2024-09-01', 0),
( 4, 2, 2,   300000, '2024-09-08', 0),
( 5, 2, 2,   820000, '2024-09-09', 0),
( 6, 4, 3,    39000, '2024-09-10', 0),
( 7, 6, 1,   510000, '2024-09-10', 0),
( 8, 1, 2,  -250000, '2024-10-01', 0),
( 9, 3, 2,  -200000, '2024-10-01', 0),
(10, 2, 3,  -600000, '2024-10-02', 0),
(11, 5, 1,   240000, '2024-10-02', 0),
(12, 5, 3,   620000, '2024-10-03', 0);
GO

-- MOVIMIENTOS  (MovimientoOrigID en 0 por defecto; ajustalo si necesitás enlazar ajustes)
INSERT INTO dbo.MOVIMIENTOS (MovimientoID, ConceptoID, CajaID, Monto,   Fecha,       MovimientoOrigID) VALUES
( 14, 1, 3,  -270000, '2024-09-01', 0)
GO

/* Punto 1 */


select * from Movimientos;

SELECT DISTINCT c.CajaID, c.CajaDesc, c.Saldo,
ISNULL(SUM(m.Monto) OVER (PARTITION BY c.CajaID), 0) AS SumaTotal,
    CASE
        WHEN ISNULL(SUM(m.Monto) OVER (PARTITION BY c.CajaID), 0)= c.saldo
        THEN 'COINCIDE' ELSE 'NO COINCIDE'
    END Coinciden
FROM Cajas c
LEFT JOIN Movimientos m on m.CajaID= c.CajaID;


/* Punto 2 */ 

SELECT DISTINCT c.ConceptoID, c.ConceptoDesc, c.ConceptoGrupo
FROM Conceptos c
WHERE NOT EXISTS(
    SELECT 1
    FROM Cajas c2
    WHERE NOT EXISTS(
        SELECT 1
        FROM MOVIMIENTOS m
        WHERE m.CajaID=c2.CajaID AND c.ConceptoID=m.ConceptoID
        )
)