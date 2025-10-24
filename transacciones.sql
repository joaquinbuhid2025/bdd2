BEGIN TRANSACTION
-- or BEGIN TRAN
BEGIN TRANSACTION;
INSERT INTO Customers VALUES ('Gerald',
                             'Villegas',
                             '1195 White Avenue',
                             NULL);
INSERT INTO Customers VALUES ('Margaret',
                              NULL,
                              '3191 Wescam Court',
                              NULL);
COMMIT TRANSACTION;

----------------------------------------
BEGIN TRAN;
    BEGIN TRY
        INSERT INTO Customers VALUES ('Robert',
                                     'Austin',
                                     '339 Tuna Street',
                                     NULL);
        INSERT INTO Customers VALUES ('Margaret',
                                      NULL,
                                      '3191 Wescam Court',
                                      NULL);
        COMMIT TRAN;
    END TRY
    BEGIN CATCH
        SELECT
         ERROR_NUMBER() AS ErrorNumber
        ,ERROR_SEVERITY() AS ErrorSeverity
        ,ERROR_STATE() AS ErrorState
        ,ERROR_PROCEDURE() AS ErrorProcedure
        ,ERROR_LINE() AS ErrorLine
        ,ERROR_MESSAGE() AS ErrorMessage;
        ROLLBACK TRAN
    END CATCH;
