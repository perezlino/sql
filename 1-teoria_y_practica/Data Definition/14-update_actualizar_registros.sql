-- ======================================================
-- ================ ACTUALIZAR REGISTROS ================
-- ======================================================

/* ===================
   ===    UPDATE   ===
   ===================

/* Para modificar los datos existentes en una tabla, se utiliza la siguiente sentencia UPDATE:

                                        UPDATE table_name
                                        SET c1 = v1, c2 = v2, ... cn = vn
                                        [WHERE condition]

    En esta sintaxis:

    - En primer lugar, especifique el nombre de la tabla cuyos datos deben actualizarse.

    - En segundo lugar, especifique una lista de columnas c1, c2, ..., cn y los valores v1, v2, ... vn que 
      deben actualizarse.

    - En tercer lugar, especifique las condiciones en la cláusula WHERE para seleccionar las filas que se 
      actualizan. La cláusula WHERE es opcional. Si omite la cláusula WHERE, se actualizarán todas las filas 
      de la tabla.


    Ejemplos de SQL Server UPDATE
    =============================

    Primero, cree una nueva tabla llamada "Taxes" para demostración.  */

CREATE TABLE Sales.Taxes(
	tax_id INT PRIMARY KEY IDENTITY (1, 1),
	state VARCHAR (50) NOT NULL UNIQUE,
	state_tax_rate DEC (3, 2),
	avg_local_tax_rate DEC (3, 2),
	combined_rate AS state_tax_rate + avg_local_tax_rate,
	max_local_tax_rate DEC (3, 2),
	updated_at datetime
)

-- En segundo lugar, ejecute las siguientes sentencias para insertar datos en la tabla Taxes:

INSERT INTO Sales.Taxes(state,state_tax_rate,avg_local_tax_rate,max_local_tax_rate) VALUES('Alabama',0.04,0.05,0.07);
INSERT INTO Sales.Taxes(state,state_tax_rate,avg_local_tax_rate,max_local_tax_rate) VALUES('Alaska',0,0.01,0.07);
INSERT INTO Sales.Taxes(state,state_tax_rate,avg_local_tax_rate,max_local_tax_rate) VALUES('Arizona',0.05,0.02,0.05);
INSERT INTO Sales.Taxes(state,state_tax_rate,avg_local_tax_rate,max_local_tax_rate) VALUES('Arkansas',0.06,0.02,0.05);
INSERT INTO Sales.Taxes(state,state_tax_rate,avg_local_tax_rate,max_local_tax_rate) VALUES('California',0.07,0.01,0.02);
INSERT INTO Sales.Taxes(state,state_tax_rate,avg_local_tax_rate,max_local_tax_rate) VALUES('Colorado',0.02,0.04,0.08);
INSERT INTO Sales.Taxes(state,state_tax_rate,avg_local_tax_rate,max_local_tax_rate) VALUES('Connecticut',0.06,0,0);
INSERT INTO Sales.Taxes(state,state_tax_rate,avg_local_tax_rate,max_local_tax_rate) VALUES('Delaware',0,0,0);
INSERT INTO Sales.Taxes(state,state_tax_rate,avg_local_tax_rate,max_local_tax_rate) VALUES('Florida',0.06,0,0.02);
INSERT INTO Sales.Taxes(state,state_tax_rate,avg_local_tax_rate,max_local_tax_rate) VALUES('Georgia',0.04,0.03,0.04);
INSERT INTO Sales.Taxes(state,state_tax_rate,avg_local_tax_rate,max_local_tax_rate) VALUES('Hawaii',0.04,0,0);
INSERT INTO Sales.Taxes(state,state_tax_rate,avg_local_tax_rate,max_local_tax_rate) VALUES('Idaho',0.06,0,0.03);
INSERT INTO Sales.Taxes(state,state_tax_rate,avg_local_tax_rate,max_local_tax_rate) VALUES('Illinois',0.06,0.02,0.04);
INSERT INTO Sales.Taxes(state,state_tax_rate,avg_local_tax_rate,max_local_tax_rate) VALUES('Indiana',0.07,0,0);
INSERT INTO Sales.Taxes(state,state_tax_rate,avg_local_tax_rate,max_local_tax_rate) VALUES('Iowa',0.06,0,0.01);
INSERT INTO Sales.Taxes(state,state_tax_rate,avg_local_tax_rate,max_local_tax_rate) VALUES('Kansas',0.06,0.02,0.04);
INSERT INTO Sales.Taxes(state,state_tax_rate,avg_local_tax_rate,max_local_tax_rate) VALUES('Kentucky',0.06,0,0);
INSERT INTO Sales.Taxes(state,state_tax_rate,avg_local_tax_rate,max_local_tax_rate) VALUES('Louisiana',0.05,0.04,0.07);
INSERT INTO Sales.Taxes(state,state_tax_rate,avg_local_tax_rate,max_local_tax_rate) VALUES('Maine',0.05,0,0);
INSERT INTO Sales.Taxes(state,state_tax_rate,avg_local_tax_rate,max_local_tax_rate) VALUES('Maryland',0.06,0,0);
INSERT INTO Sales.Taxes(state,state_tax_rate,avg_local_tax_rate,max_local_tax_rate) VALUES('Massachusetts',0.06,0,0);
INSERT INTO Sales.Taxes(state,state_tax_rate,avg_local_tax_rate,max_local_tax_rate) VALUES('Michigan',0.06,0,0);
INSERT INTO Sales.Taxes(state,state_tax_rate,avg_local_tax_rate,max_local_tax_rate) VALUES('Minnesota',0.06,0,0.01);
INSERT INTO Sales.Taxes(state,state_tax_rate,avg_local_tax_rate,max_local_tax_rate) VALUES('Mississippi',0.07,0,0.01);
INSERT INTO Sales.Taxes(state,state_tax_rate,avg_local_tax_rate,max_local_tax_rate) VALUES('Missouri',0.04,0.03,0.05);
INSERT INTO Sales.Taxes(state,state_tax_rate,avg_local_tax_rate,max_local_tax_rate) VALUES('Montana',0,0,0);
INSERT INTO Sales.Taxes(state,state_tax_rate,avg_local_tax_rate,max_local_tax_rate) VALUES('Nebraska',0.05,0.01,0.02);
INSERT INTO Sales.Taxes(state,state_tax_rate,avg_local_tax_rate,max_local_tax_rate) VALUES('Nevada',0.06,0.01,0.01);
INSERT INTO Sales.Taxes(state,state_tax_rate,avg_local_tax_rate,max_local_tax_rate) VALUES('New Hampshire',0,0,0);
INSERT INTO Sales.Taxes(state,state_tax_rate,avg_local_tax_rate,max_local_tax_rate) VALUES('New Jersey',0.06,0,0);
INSERT INTO Sales.Taxes(state,state_tax_rate,avg_local_tax_rate,max_local_tax_rate) VALUES('New Mexico',0.05,0.02,0.03);
INSERT INTO Sales.Taxes(state,state_tax_rate,avg_local_tax_rate,max_local_tax_rate) VALUES('New York',0.04,0.04,0.04);
INSERT INTO Sales.Taxes(state,state_tax_rate,avg_local_tax_rate,max_local_tax_rate) VALUES('North Carolina',0.04,0.02,0.02);
INSERT INTO Sales.Taxes(state,state_tax_rate,avg_local_tax_rate,max_local_tax_rate) VALUES('North Dakota',0.05,0.01,0.03);
INSERT INTO Sales.Taxes(state,state_tax_rate,avg_local_tax_rate,max_local_tax_rate) VALUES('Ohio',0.05,0.01,0.02);
INSERT INTO Sales.Taxes(state,state_tax_rate,avg_local_tax_rate,max_local_tax_rate) VALUES('Oklahoma',0.04,0.04,0.06);
INSERT INTO Sales.Taxes(state,state_tax_rate,avg_local_tax_rate,max_local_tax_rate) VALUES('Oregon',0,0,0);
INSERT INTO Sales.Taxes(state,state_tax_rate,avg_local_tax_rate,max_local_tax_rate) VALUES('Pennsylvania',0.06,0,0.02);
INSERT INTO Sales.Taxes(state,state_tax_rate,avg_local_tax_rate,max_local_tax_rate) VALUES('Rhode Island',0.07,0,0);
INSERT INTO Sales.Taxes(state,state_tax_rate,avg_local_tax_rate,max_local_tax_rate) VALUES('South Carolina',0.06,0.01,0.02);
INSERT INTO Sales.Taxes(state,state_tax_rate,avg_local_tax_rate,max_local_tax_rate) VALUES('South Dakota',0.04,0.01,0.04);
INSERT INTO Sales.Taxes(state,state_tax_rate,avg_local_tax_rate,max_local_tax_rate) VALUES('Tennessee',0.07,0.02,0.02);
INSERT INTO Sales.Taxes(state,state_tax_rate,avg_local_tax_rate,max_local_tax_rate) VALUES('Texas',0.06,0.01,0.02);
INSERT INTO Sales.Taxes(state,state_tax_rate,avg_local_tax_rate,max_local_tax_rate) VALUES('Utah',0.05,0,0.02);
INSERT INTO Sales.Taxes(state,state_tax_rate,avg_local_tax_rate,max_local_tax_rate) VALUES('Vermont',0.06,0,0.01);
INSERT INTO Sales.Taxes(state,state_tax_rate,avg_local_tax_rate,max_local_tax_rate) VALUES('Virginia',0.05,0,0);
INSERT INTO Sales.Taxes(state,state_tax_rate,avg_local_tax_rate,max_local_tax_rate) VALUES('Washington',0.06,0.02,0.03);
INSERT INTO Sales.Taxes(state,state_tax_rate,avg_local_tax_rate,max_local_tax_rate) VALUES('West Virginia',0.06,0,0.01);
INSERT INTO Sales.Taxes(state,state_tax_rate,avg_local_tax_rate,max_local_tax_rate) VALUES('Wisconsin',0.05,0,0.01);
INSERT INTO Sales.Taxes(state,state_tax_rate,avg_local_tax_rate,max_local_tax_rate) VALUES('Wyoming',0.04,0.01,0.02);
INSERT INTO Sales.Taxes(state,state_tax_rate,avg_local_tax_rate,max_local_tax_rate) VALUES('D.C.',0.05,0,0);


/* 1) Ejemplo de actualización de una única columna en todas las filas
   ===================================================================

    La siguiente sentencia actualiza una única columna para todas las filas de la tabla Taxes:  */

UPDATE Sales.Taxes
SET updated_at = GETDATE()

-- En este ejemplo, la sentencia cambia los valores de la columna updated_at a la fecha-hora del sistema 
-- devuelta por la función GETDATE().

-- SQL Server emitió el siguiente mensaje:

(51 rows affected)


/* 2) Ejemplo de actualización de varias columnas
   ==============================================

    La siguiente sentencia incrementa el max local tax rate en un 2% y el average local tax rate en un 1% para 
    los states que tienen el max local tax rate 1%.  */

UPDATE Sales.Taxes
SET max_local_tax_rate += 0.02,
    avg_local_tax_rate += 0.01
WHERE
    max_local_tax_rate = 0.01



/* =============================================================================================================
   =============================================================================================================

   ===================
   === UPDATE JOIN ===
   ===================

   Para consultar datos de tablas relacionadas, a menudo se utilizan las cláusulas join, ya sean inner join 
   o left join. En SQL Server, puede utilizar estas cláusulas join en la sentencia UPDATE para realizar una 
   actualización entre tablas.

   A continuación, se ilustra la sintaxis de la cláusula UPDATE JOIN:

                                        UPDATE 
                                            t1
                                        SET 
                                            t1.c1 = t2.c2,
                                            t1.c2 = expression,
                                            ...   
                                        FROM 
                                            t1
                                            [INNER | LEFT] JOIN t2 ON join_predicate
                                        WHERE 
                                            where_predicate


   En esta sintaxis:

   - En primer lugar, especifique el nombre de la tabla (t1) que desea actualizar en la cláusula UPDATE.

   - A continuación, especifique el nuevo valor de cada columna de la tabla actualizada.

   - Luego, especifique de nuevo la tabla desde la que desea actualizar en la cláusula FROM.

   - Después, utilice INNER JOIN o LEFT JOIN para unirse a otra tabla (t2) utilizando un predicado join 
     especificado después de la palabra clave ON.

   - Por último, añada una cláusula WHERE opcional para especificar las filas que se actualizarán.


   Ejemplos de UPDATE JOIN de SQL Server
   =====================================

   Veamos algunos ejemplos de uso de la sentencia UPDATE JOIN.


        Configuración de tablas de ejemplo
        ==================================

        En primer lugar, cree una nueva tabla denominada Sales.Targets para almacenar los objetivos de 
        ventas:  */

        DROP TABLE IF EXISTS Sales.Targets

        CREATE TABLE Sales.Targets
        (
            target_id  INT	PRIMARY KEY, 
            percentage DECIMAL(4, 2) NOT NULL DEFAULT 0
        )

        INSERT INTO 
            Sales.Targets(target_id, percentage)
        VALUES
            (1,0.2),
            (2,0.3),
            (3,0.5),
            (4,0.6),
            (5,0.8)

    --  Si el personal de ventas alcanza el target 1, obtendrá el ratio de 0.2 o 20% de comisión de ventas y 
    --  así sucesivamente.

    --  En segundo lugar, cree otra tabla llamada Sales.Commissions para almacenar las comisiones de ventas:

        CREATE TABLE Sales.Commissions
        (
            staff_id    INT PRIMARY KEY, 
            target_id   INT, 
            base_amount DECIMAL(10, 2) NOT NULL DEFAULT 0, 
            commission  DECIMAL(10, 2) NOT NULL DEFAULT 0, 
            FOREIGN KEY(target_id) REFERENCES Sales.Targets(target_id), 
            FOREIGN KEY(staff_id) REFERENCES Sales.Staffs(staff_id),
        )

        INSERT INTO 
            Sales.Commissions(staff_id, base_amount, target_id)
        VALUES
            (1,100000,2),
            (2,120000,1),
            (3,80000,3),
            (4,900000,4),
            (5,950000,5)
        
    /*  La tabla Sales.Commissions almacena el staff identification, target_id, base_amount y comisión. Esta 
        tabla está vinculada a la tabla Sales.Targets a través de la columna target_id.

        Nuestro objetivo es calcular las comisiones de todos los vendedores en función de sus objetivos de 
        ventas (sales targets).


        A) Ejemplo de UPDATE INNER JOIN de SQL Server
        =============================================

        La siguiente sentencia utiliza UPDATE INNER JOIN para calcular la comisión de ventas de todos los 
        vendedores:  */

        UPDATE
            Sales.Commissions
        SET
            Sales.Commissions.commission = 
                c.base_amount * t.percentage
        FROM 
            Sales.Commissions c
            INNER JOIN sales.targets t
                ON c.target_id = t.target_id
    
    --  Este es el resultado:

        (5 rows affected)

    --  Si vuelve a consultar la tabla Sales.Commissions, verá que se actualizan los valores de la columna 
    --  commission:

        SELECT *
        FROM Sales.Commissions
    
    --  |----------|-----------|-------------|------------|
    --  | staff_id | target_id | base_amount | commission |
    --  |----------|-----------|-------------|------------|
    --  |     1    |     2     |  100000.00  |  30000.00  |
    --  |     2    |     1     |  120000.00  |  24000.00  |
    --  |     3    |     3     |   80000.00  |  40000.00  |
    --  |     4    |     4     |  900000.00  | 540000.00  |
    --  |     5    |     5     |  950000.00  | 760000.00  |
    --  |----------|-----------|-------------|------------|


    /*  B) Ejemplo de UPDATE LEFT JOIN de SQL Server
        ============================================

        Supongamos que tenemos dos nuevos vendedores (two more new sales staffs) que acaban de incorporarse 
        y todavía no tienen ningún objetivo (target):  */

        INSERT INTO 
            Sales.Commissions(staff_id, base_amount, target_id)
        VALUES
            (6,100000,NULL),
            (7,120000,NULL)

    /*  Asumimos que la comisión para los nuevos vendedores es 0.1 o 10%, podemos actualizar la comisión de 
        todos los vendedores usando UPDATE LEFT JOIN como sigue:  */

        UPDATE 
            Sales.Commissions
        SET  
            Sales.Commissions.commission = 
                c.base_amount  * COALESCE(t.percentage,0.1)
        FROM  
            Sales.Commissions c
            LEFT JOIN sales.targets t 
                ON c.target_id = t.target_id

    /*  En este ejemplo, hemos utilizado COALESCE() para devolver 0,1 si el porcentaje es NULL.

        Tenga en cuenta que si utiliza la cláusula UPDATE INNER JOIN, sólo se actualizarán las cinco filas de 
        la tabla cuyos objetivos no sean NULL.

        Examinemos los datos de la tabla Sales.Commissions:  */

        SELECT * 
        FROM Sales.Commissions

    --  |----------|-----------|-------------|------------|
    --  | staff_id | target_id | base_amount | commission |
    --  |----------|-----------|-------------|------------|
    --  |     1    |     2     |  100000.00  |  30000.00  |
    --  |     2    |     1     |  120000.00  |  24000.00  |
    --  |     3    |     3     |   80000.00  |  40000.00  |
    --  |     4    |     4     |  900000.00  | 540000.00  |
    --  |     5    |     5     |  950000.00  | 760000.00  |
    --  |     6    |    NULL   |  100000.00  |  10000.00  |
    --  |     7    |    NULL   |  120000.00  |  12000.00  |
    --  |----------|-----------|-------------|------------|      