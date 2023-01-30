-- ======================================================
-- =================== ROW_NUMBER() =====================
-- ======================================================

/*  ROW_NUMBER() es una función de ventana que asigna un número entero secuencial a cada fila 
    dentro de la partición de un conjunto de resultados. El número de fila empieza por 1 para 
    la primera fila de cada partición.

    A continuación se muestra la sintaxis de la función ROW_NUMBER():

                            ROW_NUMBER() OVER (
                                [PARTITION BY partition_expression, ... ]
                                ORDER BY sort_expression [ASC | DESC], ...
                            )

    Examinemos en detalle la sintaxis de la función ROW_NUMBER().

    PARTITION BY
    ------------

    La cláusula PARTITION BY divide el conjunto de resultados en particiones (otro término para grupos de 
    filas). La función ROW_NUMBER() se aplica a cada partición por separado y reinicializa el número de 
    fila de cada partición.

    La cláusula PARTITION BY es opcional. Si la omite, la función ROW_NUMBER() tratará todo el conjunto de 
    resultados como una única partición.

    ORDER BY
    --------

    La cláusula ORDER BY define el orden lógico de las filas dentro de cada partición del conjunto de 
    resultados. La cláusula ORDER BY es obligatoria porque la función ROW_NUMBER() es sensible al orden.


    =======================================================================================================

    Ejemplos de ROW_NUMBER() de SQL Server
    ======================================

    Utilizaremos la tabla Ventas.clientes de la base de datos "TiendaBiciletas" para demostrar la función 
    ROW_NUMBER().  */

    USE TiendaBicicletas  /*


    Uso de la función ROW_NUMBER() sobre un ejemplo de conjunto de resultados
    -------------------------------------------------------------------------

    La siguiente sentencia utiliza la función ROW_NUMBER() para asignar a cada fila de cliente un número 
    secuencial:   */

    SELECT * FROM Ventas.clientes

/*
|------------|------------|----------|---------------|-------------------------------|------------------------|-------------------|--------|------------|
| cliente_id |   nombre   |	apellido |    telefono	 |             email             |	        calle	      |       ciudad	  | estado | codigo_zip |
|------------|------------|----------|---------------|-------------------------------|------------------------|-------------------|--------|------------|
|      1     |   Debra	  | Burks	 |      NULL	 |   debra.burks@yahoo.com	     | 9273 Thorne Ave. 	  |  Orchard Park	  |   NY   |	14127   |
|      2	 |   Kasha	  | Todd	 |      NULL	 |   kasha.todd@yahoo.com	     | 910 Vine calle 	      |  Campbell	      |   CA   |	95008   |
|      3	 |   Tameka	  | Fisher	 |      NULL	 |   tameka.fisher@aol.com	     | 769C Honey Creek St.   |	 Redondo Beach	  |   CA   | 	90278   |
|      4	 |   Daryl	  | Spence	 |      NULL	 |   daryl.spence@aol.com	     | 988 Pearl Lane 	      |  Uniondale	      |   NY   |	11553   |
|      5	 | Charolette |	Rice	 |(916) 381-6003 |	 charolette.rice@msn.com	 | 107 River Dr. 	      |  Sacramento	      |   CA   |	95820   |
|      6	 |   Lyndsey  | Bean	 |      NULL	 |   lyndsey.bean@hotmail.com	 | 769 West Road 	      |  Fairport	      |   NY   |	14450   |
|      7	 |   Latasha  | Hays	 |(716) 986-3359 |	 latasha.hays@hotmail.com	 | 7014 Manor Station Rd. |	 Buffalo	      |   NY   |	14215   |
|      8	 |  Jacquline | Duncan	 |      NULL	 |   jacquline.duncan@yahoo.com	 | 15 Brown St. 	      |  Jackson Heights  |	  NY   |	11372   |
|      9	 |  Genoveva  |	Baldwin	 |      NULL	 |   genoveva.baldwin@msn.com	 | 8550 Spruce Drive 	  |  Port Washington  |	  NY   |	11050   |
|     10	 |   Pamelia  | Newman	 |      NULL	 |   pamelia.newman@gmail.com	 | 476 Chestnut Ave. 	  |  Monroe	          |   NY   |	10950   |
|   ......   | .........  | .......  |  ...........  |  .........................    | .....................  | ................  | ...... |  ........  |
|   ......   | .........  | .......  |  ...........  |  .........................    | .....................  | ................  | ...... |  ........  |
|------------|------------|----------|---------------|-------------------------------|------------------------|-------------------|--------|------------|  */


    SELECT 
        ROW_NUMBER() OVER (ORDER BY nombre) row_num,
        nombre, 
        apellido, 
        ciudad
    FROM 
        Ventas.clientes

/*
|---------|----------|------------|-----------------|
| row_num |	 nombre  |  apellido  |     ciudad      |
|---------|----------|------------|-----------------|
|    1    |  Aaron   |	 Knapp    |	Yonkers         |
|    2	  |  Abbey	 |   Pugh	  | Forest Hills    |
|    3	  |  Abby	 |   Gamble	  | Amityville      |
|    4	  |  Abram	 |  Copeland  |	Harlingen       |
|    5	  |  Adam	 |  Henderson |	Los Banos       |
|    6	  |  Adam	 |  Thornton  |	Central Islip   |
|    7	  |  Addie	 |   Hahn	  | Franklin Square |
|    8	  |  Adelaida|	 Hancock  |	San Pablo       |
|    9	  |  Adelle	 |   Larsen	  | East Northport  |
|   10	  |  Adena	 |   Blake	  | Ballston Spa    |
| ....... | .......  | .........  | .............   |
| ....... | .......  | .........  | .............   |
|---------|----------|------------|-----------------|

    En este ejemplo, omitimos la cláusula PARTITION BY, por lo tanto, ROW_NUMBER() trató todo el conjunto de 
    resultados como una única partición.


    Ejemplo de uso de ROW_NUMBER() sobre particiones
    ------------------------------------------------

    El siguiente ejemplo utiliza la función ROW_NUMBER() para asignar un número entero secuencial a cada cliente. 
    Restablece el número cuando cambia la ciudad:  */

    SELECT 
        nombre, 
        apellido, 
        ciudad,
        ROW_NUMBER() OVER (PARTITION BY ciudad ORDER BY nombre) row_num
    FROM 
        Ventas.clientes
    ORDER BY 
        ciudad

/*
|-----------|-------------|-------------|---------|
|   nombre	|   apellido  |	   ciudad   | row_num |
|-----------|-------------|-------------|---------|
| Douglass	| Blankenship |	 Albany	    |    1    |  
| Mi	    | Gray	      |  Albany	    |    2    |
| Priscilla	| Wilkins	  |  Albany	    |    3    |  
| Andria	| Rivers	  |  Amarillo	|    1    |  
| Delaine	| Estes	      |  Amarillo	|    2    |  
| Jonell	| Rivas	      |  Amarillo	|    3    |  
| Luis	    | Tyler	      |  Amarillo	|    4    |  
| Narcisa	| Knapp	      |  Amarillo	|    5    |  
| Abby	    | Gamble	  |  Amityville	|    1    |  
| Barton	| Cox	      |  Amityville	|    2    | 
| ......... | ..........  | ..........  |  .....  |
| ......... | ..........  | ..........  |  .....  |
|-----------|-------------|-------------|---------|


    En este ejemplo, utilizamos la cláusula PARTITION BY para dividir los clientes en particiones por ciudad. 
    El número de fila se reiniciaba cuando cambiaba la ciudad.


    Uso de ROW_NUMBER() para la paginación
    --------------------------------------

    La función ROW_NUMBER() es útil para la paginación en aplicaciones. Por ejemplo, puede mostrar una lista 
    de clientes por página, donde cada página tiene 10 filas.

    El siguiente ejemplo utiliza ROW_NUMBER() para devolver los clientes de la fila 11 a la 20, que es la 
    segunda página:   */

    WITH cte_clientes AS (
        SELECT 
            ROW_NUMBER() OVER(ORDER BY nombre, apellido) row_num, 
            cliente_id, 
            nombre, 
            apellido
        FROM 
            Ventas.clientes
    ) SELECT 
        row_num,
        cliente_id, 
        nombre, 
        apellido
    FROM 
        cte_clientes
    WHERE 
        row_num > 20 AND 
        row_num <= 30

/*
|---------|------------|----------|------------|
| row_num |	cliente_id |  nombre  |  apellido  |
|---------|------------|----------|------------|
|   21    |	    735	   |   Aide   |  Franco    | 
|   22	  |     952	   |   Aileen |  Marquez   | 
|   23	  |     384	   |   Aimee  |  Merritt   | 
|   24	  |    1058	   |   Aisha  |  Woods     | 
|   25	  |     158	   |   Alane  |  Kennedy   | 
|   26	  |     697	   |   Alane  |  Mccarty   | 
|   27	  |     442	   |   Alane  |  Munoz     | 
|   28	  |    1061	   |   Alanna |  Barry     | 
|   29	  |    1219	   |   Alden  |  Atkinson  | 
|   30	  |     475	   |   Alec	  |  Peck      | 
|---------|------------|----------|------------| 

    En este ejemplo:
    ----------------

    Primero, el CTE utilizó la función ROW_NUMBER() para asignar a cada fila del conjunto de resultados un 
    número entero secuencial.

    En segundo lugar, la consulta externa devolvió las filas de la segunda página, que tienen el número de 
    fila entre 21 y 30.



    Uso de ROW_NUMBER() con SELECT NULL
    -----------------------------------  */

    -- También nosp ermite generar un correlativo para cada fila

    SELECT *, ROW_NUMBER() OVER(ORDER BY (SELECT NULL)) row_num
    FROM 
        Ventas.clientes
    ORDER BY 
        ciudad