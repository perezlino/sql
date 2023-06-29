-- ======================================================
-- ============== CREACIÓN TRIGGER DML AFTER ============
-- ======================================================
/*
 1) Crear una tabla para registrar los cambios
 =============================================

   La siguiente sentencia crea una tabla llamada "Producción.AuditoriasProducto" para registrar información cuando se 
   produce un evento INSERT o DELETE en la tabla "Produccion.productos":  */

CREATE TABLE Produccion.AuditoriasProducto(
modificacion_id INT IDENTITY PRIMARY KEY,
producto_id INT NOT NULL,
producto_nombre VARCHAR(255) NOT NULL,
marca_id INT NOT NULL,
categoria_id INT NOT NULL,
ano_modelo SMALLINT NOT NULL,
precio_catalogo DEC(10,2) NOT NULL,
actualizado_a DATETIME NOT NULL,
operacion CHAR(3) NOT NULL,
CHECK(operacion = 'INS' or operacion='DEL')
)

/* La tabla "Producción.AuditoriasProducto" tiene todas las columnas de la tabla "Produccion.productos". Además, tiene 
   algunas columnas más para registrar los cambios, por ejemplo, 'actualizado_a', 'operacion' y 'modificacion_id'.


 2) Creación de un trigger DML AFTER
 ===================================

   En primer lugar, para crear un nuevo trigger, especifique el nombre del trigger y el schema al que pertenece 
   el trigger en la cláusula CREATE TRIGGER:   */

CREATE TRIGGER Produccion.trg_auditoria_producto
ON Produccion.productos
AFTER INSERT, DELETE
AS
BEGIN
    SET NOCOUNT ON
    INSERT INTO Produccion.AuditoriasProducto(
        producto_id,
        producto_nombre,
        marca_id,
        categoria_id,
        ano_modelo,
        precio_catalogo,
        actualizado_a,
        operacion,
    )
    SELECT
        producto_id,
        producto_nombre,
        marca_id,
        categoria_id,
        ano_modelo,
        precio_catalogo,
        GETDATE(),
        'INS'
    FROM
        inserted
    UNION ALL
    SELECT
        producto_id,
        producto_nombre,
        marca_id,
        categoria_id,
        ano_modelo,
        precio_catalogo,
        GETDATE(),
        'DEL'
    FROM
        deleted
END


/*
 3) Prueba del trigger
 =====================

    La siguiente sentencia inserta una nueva fila en la tabla Produccion.productos: */

INSERT INTO Produccion.productos(
    producto_nombre,
    marca_id,
    categoria_id,
    ano_modelo,
    precio_catalogo
)
VALUES (
    'Test product',
    1,
    1,
    2018,
    599
)

/*
    Debido al evento INSERT, se disparó el trigger "Produccion.trg_auditoria_producto" de la tabla "Produccion.productos".
    Examinemos el contenido de la tabla "Produccion.AuditoriasProducto":  */
    

SELECT * 
FROM Produccion.AuditoriasProducto

/*
|---------------|-----------|---------------|--------|------------|----------|---------------|------------------------|---------|
|modificacion_id|producto_id|producto_nombre|marca_id|categoria_id|ano_modelo|precio_catalogo|      actualizado_a     |operation|
|---------------|-----------|---------------|--------|------------|----------|---------------|------------------------|---------|
|       1       |    322    | Test product  |   1    |      1     |   2018   |     599.00    |2023-01-24 23:17:30.833 |   INS   |
|---------------|-----------|---------------|--------|------------|----------|---------------|------------------------|---------|
    
    La siguiente sentencia elimina una fila de la tabla "Produccion.productos":  */


DELETE FROM Produccion.productos
WHERE producto_id = 322

/*
|---------------|-----------|---------------|--------|------------|----------|---------------|------------------------|---------|
|modificacion_id|producto_id|producto_nombre|marca_id|categoria_id|ano_modelo|precio_catalogo|      actualizado_a     |operation|
|---------------|-----------|---------------|--------|------------|----------|---------------|------------------------|---------|
|       1       |    322    | Test product  |   1    |      1     |   2018   |     599.00    |2023-01-24 23:17:30.833 |   INS   |
|       2       |    322    | Test product  |   1    |      1     |   2018   |     599.00    |2023-01-24 23:28:15.530 |   DEL   |
|---------------|-----------|---------------|--------|------------|----------|---------------|------------------------|---------|
*/