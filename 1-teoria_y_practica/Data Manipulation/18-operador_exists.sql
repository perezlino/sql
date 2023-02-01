-- ======================================================
-- ================== OPERADOR EXISTS ===================
-- ======================================================

/*  El operador EXISTS es un operador lógico que permite comprobar si una subconsulta 
    devuelve alguna fila. El operador EXISTS devuelve TRUE si la subconsulta devuelve una 
    o más filas.

    A continuación se muestra la sintaxis del operador EXISTS de SQL Server:

                                    EXISTS ( subquery)


    En esta sintaxis, la subconsulta es sólo una sentencia SELECT. Tan pronto como la subconsulta 
    devuelva filas, el operador EXISTS devuelve TRUE y deja de procesarse inmediatamente.

    Observe que aunque la subconsulta devuelva un valor NULL, el operador EXISTS se evalúa como TRUE.


    Ejemplos del operador EXISTS
    ============================  */

    USE TiendaBicicletas
/*

    Veamos algunos ejemplos para entender como funciona el operador EXISTS.


    A) Ejemplo de uso de EXISTS con una subconsulta que devuelve NULL
    -----------------------------------------------------------------

    El siguiente ejemplo devuelve todas las filas de la tabla Ventas.clientes:  */

    SELECT
        cliente_id,
        nombre,
        apellido
    FROM
        Ventas.clientes
    WHERE
        EXISTS (SELECT NULL)
    ORDER BY
        nombre,
        apellido
/*
|------------|--------|----------|
| cliente_id | nombre | apellido |
|------------|--------|----------|
|   1174     |  Aaron |	Knapp    |   
|    338	 |  Abbey |	Pugh     |   
|     75	 |  Abby  |	Gamble   |   
|   1224	 |  Abram |	Copeland |   
|    673	 |  Adam  |	Henderson|
| .........  | ...... | ........ |
|------------|--------|----------|

    En este ejemplo, la subconsulta devuelve un conjunto de resultados que contiene NULL, lo que 
    hace que el operador EXISTS se evalúe como TRUE. Por lo tanto, la consulta completa devuelve 
    todas las filas de la tabla de clientes.

    
    B) Ejemplo de utilización de EXISTS con una subconsulta correlacionada
    ----------------------------------------------------------------------

    El siguiente ejemplo busca todos los clientes que han realizado más de dos pedidos:  */
 
    SELECT
        cliente_id,
        nombre,
        apellido
    FROM
        Ventas.clientes c
    WHERE
        EXISTS (
            SELECT
                COUNT (*)
            FROM
                Ventas.pedidos o
            WHERE
                cliente_id = c.cliente_id
            GROUP BY
                cliente_id
            HAVING
                COUNT (*) > 2
        )
    ORDER BY
        nombre,
        apellido
/*
|------------|-----------|----------|
| cliente_id |   nombre  | apellido |
|------------|-----------|----------|
|     20	 | Aleta	 | Shepard  |
|     32	 | Araceli	 | Golden   |
|     64	 | Bobbie	 | Foster   |
|     47	 | Bridgette | Guerra   |
|     17	 | Caren	 | Stephens |
| .........  | ......... | ........ |
|------------|-----------|----------|

    En este ejemplo, teníamos una subconsulta correlacionada que devuelve los clientes que realizan más 
    de dos pedidos.

    Si el número de pedidos realizados por el cliente es inferior o igual a dos, la subconsulta devuelve 
    un conjunto de resultados vacío que hace que el operador EXISTS se evalúe como FALSE.

    En función del resultado del operador EXISTS, el cliente se incluirá en el conjunto de resultados.


    C) Ejemplo de EXISTS frente a IN
    --------------------------------

    La siguiente sentencia utiliza el operador IN para encontrar los pedidos de los clientes de San José: */

    SELECT
        *
    FROM
        Ventas.pedidos
    WHERE
        cliente_id IN (
            SELECT
                cliente_id
            FROM
                Ventas.clientes
            WHERE
                ciudad = 'San Jose'
        )
    ORDER BY
        cliente_id,
        fecha_pedido
/*
|---------|----------|-------------|------------|-------------------|-----------|---------|-----------|
|pedido_id|cliente_id|estado_pedido|fecha_pedido|fecha_requerimiento|fecha_envio|tienda_id|personal_id|
|---------|----------|-------------|------------|-------------------|-----------|---------|-----------|
|  1411   |   109    |   	4      | 2018-03-01 |	 2018-03-02	    | 2018-03-02|	 1    |  	2     |  
|  1584	  |   109	 |      2	   | 2018-04-26	|    2018-04-26	    |   NULL    |	 1	  |     3     |  
|  1275	  |   165    |	    4	   | 2017-11-29	|    2017-12-01	    | 2017-11-30|	 1	  |     2     |  
|  1591	  |   165	 |      2	   | 2018-04-27	|    2018-04-27	    |   NULL	|    1	  |     2     |  
|   156	  |   357	 |      4	   | 2016-04-03	|    2016-04-06	    | 2016-04-05|	 1	  |     3     |  
|   868	  |   868	 |      4	   | 2017-05-01	|    2017-05-04	    | 2017-05-02|	 1	  |     3     |  
|  1336	  |   904	 |      4	   | 2018-01-09	|    2018-01-10	    | 2018-01-12|	 1	  |     2     |  
|  1026	  |  1370	 |      4	   | 2017-07-26	|    2017-07-28	    | 2017-07-29|	 1	  |     2     |  
|   927	  |  1438	 |      4	   | 2017-06-03	|    2017-06-05	    | 2017-06-06|	 1	  |     2     |  
|---------|----------|-------------|------------|-------------------|-----------|---------|-----------|


    La siguiente sentencia utiliza el operador EXISTS que devuelve el mismo resultado:  */

    SELECT
        *
    FROM
        Ventas.pedidos o
    WHERE
        EXISTS (
            SELECT
                cliente_id
            FROM
                Ventas.clientes c
            WHERE
                o.cliente_id = c.cliente_id
            AND ciudad = 'San Jose'
        )
    ORDER BY
        o.cliente_id,
        fecha_pedido
/*
|---------|----------|-------------|------------|-------------------|-----------|---------|-----------|
|pedido_id|cliente_id|estado_pedido|fecha_pedido|fecha_requerimiento|fecha_envio|tienda_id|personal_id|
|---------|----------|-------------|------------|-------------------|-----------|---------|-----------|
|  1411   |   109    |   	4      | 2018-03-01 |	 2018-03-02	    | 2018-03-02|	 1    |  	2     |  
|  1584	  |   109	 |      2	   | 2018-04-26	|    2018-04-26	    |   NULL    |	 1	  |     3     |  
|  1275	  |   165    |	    4	   | 2017-11-29	|    2017-12-01	    | 2017-11-30|	 1	  |     2     |  
|  1591	  |   165	 |      2	   | 2018-04-27	|    2018-04-27	    |   NULL	|    1	  |     2     |  
|   156	  |   357	 |      4	   | 2016-04-03	|    2016-04-06	    | 2016-04-05|	 1	  |     3     |  
|   868	  |   868	 |      4	   | 2017-05-01	|    2017-05-04	    | 2017-05-02|	 1	  |     3     |  
|  1336	  |   904	 |      4	   | 2018-01-09	|    2018-01-10	    | 2018-01-12|	 1	  |     2     |  
|  1026	  |  1370	 |      4	   | 2017-07-26	|    2017-07-28	    | 2017-07-29|	 1	  |     2     |  
|   927	  |  1438	 |      4	   | 2017-06-03	|    2017-06-05	    | 2017-06-06|	 1	  |     2     |  
|---------|----------|-------------|------------|-------------------|-----------|---------|-----------|


    EXISTS vs. JOIN
    ---------------

    El operador EXISTS devuelve TRUE o FALSE mientras que la cláusula JOIN devuelve filas de otra tabla.

    El operador EXISTS se utiliza para comprobar si una subconsulta devuelve alguna fila y se 
    cortocircuita en cuanto lo hace. Por otro lado, se utiliza JOIN para ampliar el conjunto de 
    resultados combinándolo con las columnas de tablas relacionadas.

    En la práctica, se utiliza EXISTS cuando se necesita comprobar la existencia de filas de tablas
     relacionadas sin devolver datos de las mismas.