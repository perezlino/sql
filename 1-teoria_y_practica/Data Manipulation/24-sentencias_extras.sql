-- ======================================================
-- ================== SENTENCIAS EXTRAS =================
-- ======================================================

/*
    ============================
    === SET NOCOUNT [ON|OFF] ===
    ============================

    Si desea suprimir la salida, (que indica el número de filas afectadas en las sentencias SQL), 
    utilice la sentencia SET NOCOUNT ON. Por defecto, si no colocamos nada es como utilizar
    un SET NOCOUNT OFF */

    USE AdventureWorks2019
    SET NOCOUNT ON
    SELECT * FROM Sales.CreditCard

/*
    ===============================
    === SET ROWCOUNT [N° Filas] ===
    ===============================

    Nos devolverá el numero de filas que le indiquemos al ROWCOUNT */

    USE AdventureWorks2019
    SET ROWCOUNT 2
    SELECT * FROM Sales.CreditCard

/*
    |---------------|--------------|----------------|----------|---------|-------------------------|
    | CreditCardID	|   CardType   |   CardNumber	| ExpMonth | ExpYear |      ModifiedDate       |
    |---------------|--------------|----------------|----------|---------|-------------------------|
    |       1       | SuperiorCard | 33332664695310	|    11	   |  2006   | 2013-07-29 00:00:00.000 |
    |       2	    | Distinguish  | 55552127249722	|     8	   |  2005	 | 2013-12-05 00:00:00.000 |    
    |---------------|--------------|----------------|----------|---------|-------------------------|