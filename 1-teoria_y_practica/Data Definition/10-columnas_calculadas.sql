-- ======================================================
-- ================ COLUMNAS CALCULADAS =================
-- ======================================================

-- Columnas calculadas (Computed columns)
-- ======================================

-- Vamos a crear una nueva tabla llamada "persons" para las demostraciones:

CREATE TABLE persons
(
    person_id  INT PRIMARY KEY IDENTITY, 
    first_name NVARCHAR(100) NOT NULL, 
    last_name  NVARCHAR(100) NOT NULL, 
    dob        DATE
)

-- E inserte dos filas en la tabla "persons":

INSERT INTO 
    persons(first_name, last_name, dob)
VALUES
    ('John','Doe','1990-05-01'),
    ('Jane','Doe','1995-03-01')

-- Para consultar los nombres completos de las personas de la tabla "persons", normalmente se utiliza 
-- la función CONCAT() o el operador + como se indica a continuación:

SELECT
    person_id,
    first_name + ' ' + last_name AS full_name,
    dob
FROM
    persons
ORDER BY
    full_name


-- Añadir la expresión full_name first_name + ' ' + last_name en cada consulta no es conveniente.

-- Afortunadamente, SQL Server nos proporciona una función llamada columnas computadas que permite añadir 
-- una nueva columna a una tabla con el valor derivado de los valores de otras columnas de la misma tabla.

-- Por ejemplo, puede añadir la columna full_name a la tabla persons utilizando la columna ALTER TABLE ADD 
-- de la siguiente manera:

ALTER TABLE persons
ADD full_name AS (first_name + ' ' + last_name)


-- Cada vez que se consultan datos de la tabla persons, SQL Server calcula el valor de la columna full_name 
-- basándose en la expresión first_name + ' ' + last_name y devuelve el resultado.

-- A continuación se muestra la nueva consulta, que es más compacta:

SELECT 
    person_id, 
    full_name, 
    dob
FROM 
    persons
ORDER BY 
    full_name


/* =============================================================================================================
   =============================================================================================================

   Columnas calculadas persistentes (Persisted computed columns)
   =============================================================

   Las columnas computadas pueden ser persistentes. Esto significa que SQL Server almacena físicamente los datos 
   de las columnas calculadas en el disco.

   Cuando se modifican los datos de la tabla, SQL Server calcula el resultado basándose en la expresión de las 
   columnas calculadas y almacena físicamente los resultados en estas columnas persistentes. Cuando se consultan 
   los datos de las columnas calculadas almacenadas, SQL Server sólo tiene que recuperar los datos sin realizar 
   ningún cálculo. Esto evita la sobrecarga de cálculo con el coste de almacenamiento adicional.

   Considere el siguiente ejemplo.

   En primer lugar, elimine la columna full_name de la tabla persons:   */

ALTER TABLE persons
DROP COLUMN full_name

-- A continuación, añada la nueva columna full_name a la tabla persons con la propiedad PERSISTED:

ALTER TABLE persons
ADD full_name AS (first_name + ' ' + last_name) PERSISTED

-- Tenga en cuenta que una columna calculada sólo persiste (computed column is persisted) si su expresión es 
-- determinista. Esto significa que, para un conjunto de entradas, la expresión siempre devuelve el mismo 
-- resultado.

-- Por ejemplo, la expresión first_name + ' ' + last_name es determinista. Sin embargo, la función GETDATE() es 
-- una función no determinista porque devuelve un valor diferente en un día diferente.

-- Esta fórmula devuelve la edad en años a partir de la fecha de nacimiento y el día de hoy:

(CONVERT(INT,CONVERT(CHAR(8),GETDATE(),112))-CONVERT(CHAR(8),dob,112))/10000


-- Podemos utilizar esta expresión para definir la columna computada age in year.

-- La siguiente sentencia intenta definir la columna computada age_in_year como una columna computada persistente:

ALTER TABLE persons
ADD age_in_years 
    AS (CONVERT(INT,CONVERT(CHAR(8),GETDATE(),112))-CONVERT(CHAR(8),dob,112))/10000 
PERSISTED

-- El servidor SQL emite el siguiente error:

Computed column 'age_in_years' in table 'persons' cannot be persisted because the column is non-deterministic.

-- Si eliminas la propiedad PERSISTED, debería funcionar:

ALTER TABLE persons
ADD age_in_years 
    AS (CONVERT(INT,CONVERT(CHAR(8),GETDATE(),112))-CONVERT(CHAR(8),dob,112))/10000

-- Ahora, puede consultar la edad en años de las personas en la tabla persons de la siguiente manera:

SELECT 
    person_id, 
    full_name, 
    age_in_years
FROM 
    persons
ORDER BY 
    age_in_years DESC


/* =============================================================================================================
   =============================================================================================================

   Sintaxis para añadir columnas calculadas a una tabla
   ====================================================

   Para añadir una nueva columna calculada a una tabla existente, utilice la siguiente sintaxis:

                                    ALTER TABLE table_name
                                    ADD column_name AS expression [PERSISTED]

   En esta sintaxis:

   - En primer lugar, especifique el nombre de la tabla a la que desea añadir la columna calculada.

   - En segundo lugar, especifique el nombre de la columna calculada con la expresión que devuelve los valores 
     de la columna.

   - En tercer lugar, si la expresión es determinista y desea almacenar físicamente los datos de la columna 
     calculada, puede utilizar la propiedad PERSISTED.

   Tenga en cuenta que puede crear un índice en una columna calculada persistente para mejorar la velocidad de 
   recuperación de datos de la columna calculada. Es una buena solución alternativa para los índices basados en 
   funciones de Oracle o los índices sobre expresiones de PostgreSQL.


   Sintaxis para definir columnas calculadas al crear una nueva tabla
   ==================================================================

   Para definir una columna calculada al crear una tabla, utilice la siguiente sintaxis:

                                        CREATE TABLE table_name(
                                            ...,
                                            column_name AS expression [PERSISTED],
                                            ...
                                        )