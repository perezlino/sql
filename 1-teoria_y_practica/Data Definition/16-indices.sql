-- ======================================================
-- ====================== INDICES =======================
-- ======================================================

/* ========================
   === CLUSTERED INDEX ===
   ========================

    - CLUSTERED INDEX te ordena fisicamente la tabla

    Crear un Clustered Index
    ========================

    Sintáxis:

    CREATE UNIQUE CLUSTERED INDEX <idx_nombre_indice> ON <schema>.<tabla> (<campo> ASC o DESC)
    CREATE CLUSTERED INDEX <idx_nombre_indice> ON <schema>.<tabla> (<campo> ASC o DESC)


    Eliminar un Clustered Index
    ===========================

    DROP INDEX IF EXISTS <nombre_indice> ON <tabla>

    Caracteristicas:
    ===============

    - Solo puede existir un solo Clustered Index, pero puede tener un alacance de un solo campo o 
      varios campos.
    
    - El nivel hoja del índice es donde se guardan los datos físicos.

    - Cualquier registro nuevo que se inserte lo hará respectando el orden físico del índice.

    - Se recomienda crear un Clustered Index en el Primary Key, es decir, tener un campo único e
      incrementable, y sobre ese campo crear el Primary key y a la vez sobre ese campo se crea su
      Clustered Index.
    
    - Los indices van a ser creados debido a la necesidad que se tiene de poder consultar el conjunto
      de datos. Por ejemplo, si en una empresa de telefonía diariamente realiza busquedas con respecto
      a un campo donde se indica el numero de celular, seria buena idea crear el Clustered Index en 
      base a este campo. En este caso, seria buena idea crear este indice en un campo distinto a un
      campo id.

    - Los árboles tipo B (B-tree) se autobalancean, es decir, equilibran sus nodos automáticamente.

    - Los arboles tipo (B-tree) proporcionan un buen rendimiento para consultas exactas, entre rangos y 
      ordenadas.  */

-- Creamos una tabla sin keys, ni indices
CREATE TABLE test_indice (
	id INT,
	nombre VARCHAR(50),
	sexo VARCHAR(20),
	fec_nacimiento DATE,
	puntaje INT,
	ciudad VARCHAR(50)
)

INSERT INTO test_indice VALUES (6, 'Kate', 'Mujer', '03-Jan-1985', 500, 'Liverpool'),
							   (9, 'Wise', 'Hombre', '11-Nov-1987', 499, 'Manchester'),
							   (3, 'Sara', 'Mujer', '07-Mar-1988', 600, 'Leeds'),
							   (11, 'Maria', 'Mujer', '28-Oct-1990', 450, 'Leeds'),
							   (10, 'Elis', 'Mujer', '28-Oct-1990', 400, 'Leeds'),
							   (1, 'Jolly', 'Mujer', '12-Jun-1989', 500, 'London'),
							   (4, 'Laura', 'Mujer', '22-Dec-1981', 400, 'Liverpool'),
							   (7, 'Joseph', 'Hombre', '09-Apr-1982', 643, 'London'),
							   (5, 'Alan', 'Hombre', '29-Jul-1993', 500, 'London'),
							   (8, 'Mice', 'Hombre', '16-Aug-1974', 543, 'Liverpool'),
							   (2, 'Jhon', 'Hombre', '02-Feb-1976', 500, 'Manchester')

-- Al hacer un SELECT escaneará toda la tabla (TABLE SCAN)
-- Poco eficiente y se utiliza mucho recurso
SELECT * FROM test_indice

-- Creamos un UNIQUE CLUSTERED INDEX (Indice agrupado único)
CREATE UNIQUE CLUSTERED INDEX IX_id ON test_indice (id ASC)

-- Eliminamos el INDICE AGRUPADO "id" (Clustered index "id")
DROP INDEX IF EXISTS IX_id ON test_indice

-- Ahora que eliminamos el CLUSTERED INDEX, volvemos a realizar una búsqueda
-- en la tabla "test_indice" que ya no tiene indice alguno:

SELECT * FROM test_indice 
WHERE sexo = 'Mujer' AND puntaje <= 450

-- Creo un CLUSTRED INDEX con un alcance de mas de un solo campo
CREATE CLUSTERED INDEX IX_test_indice_sexo_puntaje 
ON test_indice (sexo ASC, puntaje DESC)


-- =============================================================================================================
-- =============================================================================================================

/* ===========================
   === NON-CLUSTERED INDEX ===
   ===========================

   - Se recomienda utilizarlo sobre una FOREIGN KEY. De esta manera al existir un campo PRIMARY KEY y siendo
     este CLUSTERED INDEX, se potencian ambos.