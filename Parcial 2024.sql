USE BDII;
GO

CREATE TABLE Caja(
    CajaID INT NOT NULL PRIMARY KEY,
    CajaDesc VARCHAR(50) NOT NULL,
    Saldo INT NOT NULL
);

CREATE TABLE Conceptos(
    ConceptoID INT NOT NULL PRIMARY KEY,
    ConceptoDesc VARCHAR(50) NOT NULL,
    ConceptoGrupo VARCHAR(30) NOT NULL
);

CREATE TABLE Movimientos(
    MovimientoID INT NOT NULL PRIMARY KEY,
    ConceptoID INT NOT NULL,
    CajaID INT NOT NULL,
    Monto INT NOT NULL,
    Fecha DATE NOT NULL,
    CONSTRAINT FK_Mov_Concepto FOREIGN KEY (ConceptoID) REFERENCES dbo.Conceptos(ConceptoID),
    CONSTRAINT FK_Mov_Caja      FOREIGN KEY (CajaID)      REFERENCES dbo.Caja(CajaID)   
);

INSERT INTO Caja(CajaID, CajaDesc, Saldo) VALUES
(1, 'Administracion',      0),
(2, 'Punto de Venta 1', 1120000),
(3, 'Banco ABCB',      -110000);
GO

INSERT INTO Conceptos(ConceptoID, ConceptoDesc, ConceptoGrupo) VALUES
(1, 'Electricidad',          'GASTOS'),
(2, 'Alquileres',            'ALQUILERES'),
(3, 'Gas',                   'GASTOS'),
(4, 'Generales',             'SERVICIOS'),
(5, 'Servicios Industriales','SERVICIOS'),
(6, 'Limpieza',              'SERVICIOS');
GO

INSERT INTO Movimientos(MovimientoID, ConceptoID, CajaID, Monto, Fecha) VALUES
( 1, 1, 1,  -230000, '2024-09-01'),
( 2, 1, 1,  -270000, '2024-09-01'),
( 3, 1, 1,  -300000, '2024-09-01'),
( 4, 2, 2,   300000, '2024-09-08'),
( 5, 2, 2,   820000, '2024-09-09'),
( 6, 4, 3,    39000, '2024-09-10'),
( 7, 6, 1,   510000, '2024-09-10'),
( 8, 1, 2,  -250000, '2024-10-01'),
( 9, 3, 2,  -200000, '2024-10-01'),
(10, 2, 3,  -600000, '2024-10-02'),
(11, 5, 1,   240000, '2024-10-02'),
(12, 5, 3,   620000, '2024-10-03');
GO

/* Punto 1 */

CREATE PROCEDURE sp_AgregarMovimiento
    @ConceptoID INT,
    @CajaID INT,
    @Monto INT,
    @Fecha DATE
AS
BEGIN
    SET NOCOUNT ON;

    BEGIN TRY
        BEGIN TRAN;
        DECLARE @NuevoID INT;
        SELECT @NuevoID= ISNULL(MAX(MovimientoID), 0)+1 FROM Movimientos;

        INSERT INTO Movimientos(MovimientoID, ConceptoID, CajaID, Monto, Fecha)
        VALUES(@NuevoID, @ConceptoID, @CajaID, @Monto, @Fecha);
         
        UPDATE Caja
        SET Saldo= Saldo+@Monto WHERE CajaID=@CajaID;
        
        COMMIT TRAN;
    END TRY
    BEGIN CATCH
    IF @@TRANCOUNT > 0 ROLLBACK TRAN;
    THROW
    END CATCH
END

/* Punto 2 */

SELECT DISTINCT c.ConceptoID, c.ConceptoDesc, c.ConceptoGrupo
FROM Conceptos c
INNER JOIN Movimientos m ON m.ConceptoID=c.ConceptoID  AND m.monto > 0
INNER JOIN Movimientos m2 on m2.ConceptoID=c.ConceptoID AND m2.monto < 0;

/* Punto 4 */

CREATE TRIGGER dbo.trg_ActualizarMontoMovimiento
ON dbo.Movimientos
AFTER UPDATE
AS
BEGIN
    SET NOCOUNT ON;
    IF NOT UPDATE(Monto) RETURN;

    UPDATE c 
    SET c.Saldo=c.Saldo-d.Monto
    FROM Caja c
    JOIN deleted d on d.CajaID=c.CajaID;

    update c2
    SET c2.Saldo=c2.Saldo+i.Monto
    FROM Caja c2
    JOIN inserted i on i.CajaID=c2.CajaID;
END;
GO