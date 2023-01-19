-- ======================================================
-- ================= SENTENCIA BEGIN - END ==============
-- ======================================================

/* Visión general de la sentencia BEGIN...END
   ==========================================

La sentencia BEGIN...END se utiliza para definir un bloque de sentencias. Un bloque de sentencias 
consiste en un conjunto de sentencias SQL que se ejecutan juntas. Un bloque de sentencias también 
se conoce como "batch".

En otras palabras, si las declaraciones son sentencias (statements are sentences), la sentencia 
BEGIN...END permite definir párrafos.

A continuación, se ilustra la sintaxis de la sentencia BEGIN...END:     

                            BEGIN
                                { sql_statement | statement_block}
                            END

En esta sintaxis, se coloca un conjunto de sentencias SQL entre las palabras clave BEGIN y END, 
por ejemplo:    */

BEGIN
    SELECT
        product_id,
        product_name
    FROM
        production.products
    WHERE
        list_price > 100000

    IF @@ROWCOUNT = 0
        PRINT 'No se ha encontrado ningún producto con un precio superior a 100000'
END

/* Para ver los mensajes generados por la sentencia PRINT, en SQL Server Management Studio, debe 
   hacer clic en la pestaña "Messages". Por defecto, la pestaña "Messages" está oculta.

En este ejemplo:

- Primero, tenemos un bloque que comienza con la palabra clave BEGIN y termina con la palabra clave END .

- Segundo, dentro del bloque, tenemos una sentencia SELECT que encuentra los productos cuyos list prices 
  son mayores a 100,000. Después, tenemos la sentencia IF para comprobar si la consulta devuelve algún 
  producto e imprime un mensaje si no devuelve ningún producto.

- Observe que @@ROWCOUNT es una variable del sistema que devuelve el número de filas afectadas por la 
  última sentencia anterior.

La sentencia BEGIN... END delimita un bloque lógico de sentencias SQL. A menudo usamos BEGIN...END al 
principio y al final de un procedimiento almacenado y una función. Pero no es estrictamente necesario.

Sin embargo, el BEGIN...END es requerido para las sentencias IF ELSE, WHILE, etc., donde usted necesita 
envolver múltiples sentencias.


Anidamiento BEGIN... END
========================

El bloque de sentencias puede anidarse. Esto significa simplemente que puede colocar una sentencia 
BEGIN...END dentro de otra sentencia BEGIN... END.

Considere el siguiente ejemplo:    */

BEGIN
    DECLARE @name VARCHAR(MAX)

    SELECT TOP 1
        @name = product_name
    FROM
        production.products
    ORDER BY
        list_price DESC
    
    IF @@ROWCOUNT <> 0
    BEGIN
        PRINT 'El producto más caro es ' + @name
    END
    ELSE
    BEGIN
        PRINT 'No se ha encontrado ningún producto'
    END
END