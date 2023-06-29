-- ======================================================
-- ============= CREACIÓN STORED PROCEDURE ==============
-- ======================================================
/*

    Para este ejercicio se busca crear un stored procedure que nos permita buscar y obtener
    información de tarjetas de credito de un cliente especifico, ingresando su nombre y
    apellido. Se utilizó la base de datos AdventureWorks2019 para poder desarrollar este
    procedimiento almacenado. */

    USE AdventureWorks2019;   


    CREATE PROCEDURE uspObtenerInfoCreditoCliente (
        @nombre VARCHAR(40),
        @apellido VARCHAR(40),
        @creditoInfo VARCHAR(200) OUTPUT
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
            SELECT @creditoInfo = 'Card: ' + CC.CardType + ' - ' + 
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
            SET @creditoInfo = 'Cliente no tiene información sobre sus tarjetas de crédito'
        END

    END

    --  Llamamos al stored procedure

    DECLARE @tarjetaCreditoInfo VARCHAR(200)

    EXEC uspObtenerInfoCreditoCliente
    @nombre = 'Kristina',
    @apellido = 'Garcia' ,
    @creditoInfo = @tarjetaCreditoInfo OUTPUT

    SELECT @tarjetaCreditoInfo AS 'Resultado Test 1'

    EXEC uspObtenerInfoCreditoCliente
    @nombre = 'Alfonso',
    @apellido = 'Perez' ,
    @creditoInfo = @tarjetaCreditoInfo OUTPUT

    SELECT @tarjetaCreditoInfo AS 'Resultado Test 2'