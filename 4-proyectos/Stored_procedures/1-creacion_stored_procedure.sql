-- ======================================================
-- ============= CREACIÓN STORED PROCEDURE ==============
-- ======================================================
/*

    Para este ejercicio se busca crear un stored procedure que nos permita buscar y obtener
    información de tarjetas de credito de un cliente especifico, ingresando su nombre y
    apellido. Se utilizó la base de datos AdventureWorks2019 para poder desarrollar este
    procedimiento almacenado. */

    USE AdventureWorks2019;   


    CREATE PROCEDURE uspGetCreditInfoForCustomer (
        @nombre VARCHAR(40),
        @apellido VARCHAR(40),
        @creditInfo VARCHAR(200) OUTPUT
    )
    AS
    BEGIN

        --  Declaración variable
        DECLARE @salesOrderID INT

        --  Obtener el último id del pedido del cliente solicitado

        SELECT TOP 1 @salesOrderID = SOH.SalesOrderID
        FROM Sales.SalesOrderHeader SOH
        INNER JOIN Sales.Customer C ON SOH.CustomerID = C.CustomerID
        INNER JOIN Person.Person P ON P.BusinessEntityID = C.PersonID
        WHERE P.FirstName = @nombre  
        AND P.LastName = @apellido
        ORDER BY SOH.OrderDate DESC

        IF @@ROWCOUNT > 0
        BEGIN
            SELECT @creditInfo = 'Card: ' + CC.CardType + ' - ' + 
                                REPLICATE('*', LEN(CC.CardNumber)-4) + RIGHT(CC.CardNumber,4) +
                                ' Exp: ' + CAST(CC.ExpYear AS VARCHAR(4)) + '-' +
                                CAST(CC.ExpMonth AS VARCHAR(2))
            FROM Sales.CreditCard CC
            INNER JOIN Sales.SalesOrderHeader SOH
            ON CC.CreditCardID = SOH.CreditCardID
            AND SOH.SalesOrderID = @salesOrderID
        END
        ELSE
        BEGIN
            SET @creditInfo = 'Cliente no tiene información sobre sus tarjetas de crédito'
        END

    END

    --  Llamamos al stored procedure

    DECLARE @tarjetaCreditoInfo VARCHAR(200)

    EXEC uspGetCreditInfoForCustomer
    @nombre = 'Kristina',
    @apellido = 'Garcia' ,
    @creditInfo = @tarjetaCreditoInfo OUTPUT

    SELECT @tarjetaCreditoInfo AS 'Resultado Test 1'

    EXEC uspGetCreditInfoForCustomer
    @nombre = 'Alfonso',
    @apellido = 'Perez' ,
    @creditInfo = @tarjetaCreditoInfo OUTPUT

    SELECT @tarjetaCreditoInfo AS 'Resultado Test 2'