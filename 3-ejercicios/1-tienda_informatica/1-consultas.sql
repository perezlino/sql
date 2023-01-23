-- ======================================================
-- ====================== CONSULTAS  ====================
-- ======================================================

USE EJERCICIOS 

SELECT * FROM fabricante
SELECT * FROM producto

/* 1.	Devuelve una lista con el nombre del producto, precio y nombre de fabricante de todos los productos 
        de la base de datos. Ordene el resultado por el nombre del fabricante, por orden alfabético */

SELECT f.nombre 'Nombre Fabricante', p.nombre 'Nombre Producto', p.precio 'Precio'
FROM producto p 
INNER JOIN fabricante f
ON f.codigo = p.codigo_fabricante
ORDER BY f.nombre;

/* 2.	Devuelve una lista con el código del producto, nombre del producto, código del fabricante y nombre del 
        fabricante, de todos los productos de la base de datos */

SELECT f.nombre 'Nombre Fabricante', f.codigo 'Codigo Fabricante', p.nombre 'Nombre Producto', 
       p.codigo 'Codigo Producto'
FROM producto p 
INNER JOIN fabricante f
ON f.codigo = p.codigo_fabricante;

/* 3.	Devuelve el nombre del producto, su precio y el nombre de su fabricante, del producto más barato */

SELECT TOP 1 
       f.nombre 'Nombre Fabricante', p.nombre 'Nombre Producto', 
       p.precio 'Precio Producto'
FROM producto p 
INNER JOIN fabricante f
ON f.codigo = p.codigo_fabricante
ORDER BY p.precio

SELECT f.nombre 'Nombre Fabricante', p.nombre 'Nombre Producto', 
       p.precio 'Precio Producto'
FROM producto p 
INNER JOIN fabricante f
ON f.codigo = p.codigo_fabricante
WHERE p.precio = (SELECT MIN(precio) FROM producto);

/* 4.	Devuelve una lista de todos los productos del fabricante Lenovo.  */

SELECT f.nombre 'Nombre Fabricante', p.nombre 'Nombre Producto'
FROM producto p 
INNER JOIN fabricante f
ON f.codigo = p.codigo_fabricante
WHERE f.nombre = 'Lenovo';

/* 5.	Devuelve una lista de todos los productos del fabricante Crucial que tengan un precio mayor que $200 */

SELECT f.nombre 'Nombre Fabricante', p.nombre 'Nombre Producto'
FROM producto p 
INNER JOIN fabricante f
ON f.codigo = p.codigo_fabricante
WHERE f.nombre = 'Crucial' 
AND p.precio > 200;

/* 6.	Devuelve un listado con todos los productos de los fabricantes Asus, Hewlett-Packard y Seagate. Sin 
        utilizar el operador IN */

SELECT f.nombre 'Nombre Fabricante', p.nombre 'Nombre Producto'
FROM producto p 
INNER JOIN fabricante f
ON f.codigo = p.codigo_fabricante
WHERE f.nombre IN ('Asus','Hewlett-Packard','Seagate');

SELECT f.nombre 'Nombre Fabricante', p.nombre 'Nombre Producto'
FROM producto p 
INNER JOIN fabricante f
ON f.codigo = p.codigo_fabricante
WHERE f.nombre = 'Asus' OR f.nombre = 'Hewlett-Packard' OR f.nombre = 'Seagate';

/* 7.	Devuelve un listado con todos los productos de los fabricantes Asus, Hewlett-Packard y Seagate. 
        Utilizando el operador IN */

SELECT f.nombre 'Nombre Fabricante', p.nombre 'Nombre Producto'
FROM producto p 
INNER JOIN fabricante f
ON f.codigo = p.codigo_fabricante
WHERE f.nombre IN ('Asus','Hewlett-Packard','Seagate');

/* 8.	Devuelve un listado con el nombre de producto, precio y nombre de fabricante, de todos los productos 
        que tengan un precio mayor o igual a $180. Ordene el resultado en primer lugar por el precio (en 
        orden descendente) y en segundo lugar por el nombre (en orden ascendente) */

SELECT f.nombre 'Nombre Fabricante', p.nombre 'Nombre Producto', 
       p.precio 'Precio Producto'
FROM producto p 
INNER JOIN fabricante f
ON f.codigo = p.codigo_fabricante
WHERE p.precio >= ANY (SELECT precio FROM producto WHERE precio >= 180);

SELECT f.nombre 'Nombre Fabricante', p.nombre 'Nombre Producto', 
       p.precio 'Precio Producto'
FROM producto p 
INNER JOIN fabricante f
ON f.codigo = p.codigo_fabricante
WHERE p.precio IN (SELECT precio FROM producto 
                    WHERE precio >= 180)
ORDER BY p.precio, p.nombre;

SELECT f.nombre 'Nombre Fabricante', p.nombre 'Nombre Producto', 
       p.precio 'Precio Producto'
FROM producto p 
INNER JOIN fabricante f
ON f.codigo = p.codigo_fabricante
WHERE p.codigo IN (SELECT codigo FROM producto 
                    WHERE precio >= 180)
ORDER BY p.precio, p.nombre;

/* 9.	Devuelve un listado de todos los fabricantes que existen en la base de datos, junto con los productos 
        que tiene cada uno de ellos. El listado deberá mostrar también aquellos fabricantes que no tienen 
        productos asociados */

SELECT f.nombre 'Nombre Fabricante', p.nombre 'Nombre Producto'
FROM fabricante f 
LEFT JOIN producto p
ON f.codigo = p.codigo_fabricante;

/* 10.	Devuelve un listado donde sólo aparezcan aquellos fabricantes que no tienen ningún producto asociado */

SELECT f.nombre 'Nombre Fabricante', p.nombre 'Nombre Producto'
FROM fabricante f 
LEFT JOIN producto p
ON f.codigo = p.codigo_fabricante
WHERE p.nombre IS NULL;

/* 11.	Devuelve todos los productos del fabricante Lenovo. (Sin utilizar INNER JOIN) */

SELECT nombre FROM producto
WHERE codigo_fabricante = (SELECT codigo FROM fabricante WHERE nombre = 'Lenovo');

/* 12.	Devuelve todos los datos de los productos que tienen el mismo precio que el producto más caro del 
        fabricante Lenovo. (Sin utilizar INNER JOIN) */

SELECT f.nombre, p.nombre, p.precio
FROM producto p, fabricante f
WHERE p.codigo_fabricante = f.codigo
AND p.precio = (SELECT MAX(precio) FROM producto
				WHERE codigo_fabricante IN (SELECT codigo FROM fabricante
											WHERE nombre = 'Lenovo'));

/* 13.	Lista el nombre del producto más caro del fabricante Lenovo */

SELECT nombre
FROM producto
WHERE precio = (SELECT MAX(precio) FROM producto
				WHERE codigo_fabricante IN (SELECT codigo FROM fabricante
											WHERE nombre = 'Lenovo'));
                                            
SELECT p.nombre
FROM producto p, fabricante f
WHERE p.codigo_fabricante = f.codigo
AND p.precio = (SELECT MAX(precio) FROM producto
				WHERE codigo_fabricante IN (SELECT codigo FROM fabricante
											WHERE nombre = 'Lenovo'));
                                            
/* 14.	Lista todos los productos del fabricante Asus que tienen un precio superior al precio medio de todos 
        sus productos */

# Al precio medio de los productos Asus
SELECT p.nombre
FROM producto p, fabricante f
WHERE p.codigo_fabricante = f.codigo
AND f.nombre = 'Asus'
AND p.precio > (SELECT AVG(precio) FROM producto
				WHERE codigo_fabricante IN (SELECT codigo FROM fabricante
											WHERE nombre = 'Asus'));

-- ...un precio superior al precio de medio de todos los productos (no solo los productos Asus)

SELECT p.nombre
FROM producto p, fabricante f
WHERE p.codigo_fabricante = f.codigo
AND f.nombre = 'Asus'
AND p.precio > (SELECT AVG(precio) FROM producto);

/* 15.	Devuelve los nombres de los fabricantes que tienen productos asociados. (Utilizando ALL o ANY). 
        Devuelve los nombres de los fabricantes que no tienen productos asociados. (Utilizando ALL o ANY) */

SELECT nombre
FROM fabricante
WHERE codigo = ANY (SELECT codigo_fabricante FROM producto);

SELECT nombre
FROM fabricante
WHERE codigo <> ALL (SELECT codigo_fabricante FROM producto);

/* 16.	Devuelve los nombres de los fabricantes que tienen productos asociados. (Utilizando IN o NOT IN) */

SELECT nombre
FROM fabricante
WHERE codigo IN (SELECT codigo_fabricante FROM producto);

/* 17.	Devuelve los nombres de los fabricantes que no tienen productos asociados. (Utilizando IN o NOT IN) */

SELECT nombre
FROM fabricante
WHERE codigo NOT IN (SELECT codigo_fabricante FROM producto);

/* 18.	Devuelve los nombres de los fabricantes que tienen productos asociados. (Utilizando EXISTS o NOT EXISTS) */

SELECT nombre
FROM fabricante
WHERE EXISTS (SELECT codigo_fabricante FROM producto 
			  WHERE producto.codigo_fabricante = fabricante.codigo);

/* 19.	Devuelve los nombres de los fabricantes que no tienen productos asociados. (Utilizando EXISTS o NOT EXISTS) */

SELECT nombre
FROM fabricante
WHERE NOT EXISTS (SELECT codigo_fabricante FROM producto 
			  WHERE producto.codigo_fabricante = fabricante.codigo);

/* 20.	Devuelve un listado con todos los nombres de los fabricantes que tienen el mismo número de productos que el 
        fabricante Lenovo */
        
SELECT f.nombre 'Fabricante', COUNT(*) 'Cantidad Productos'
FROM fabricante F INNER JOIN producto p
ON p.codigo_fabricante = f.codigo
GROUP BY f.nombre
HAVING COUNT(*) = (SELECT COUNT(*) FROM producto 
				   WHERE codigo_fabricante IN (SELECT codigo FROM fabricante
											         WHERE nombre = 'Lenovo')); 

SELECT f.nombre 'Fabricante', COUNT(*) 'Cantidad Productos'
FROM fabricante F INNER JOIN producto p
ON p.codigo_fabricante = f.codigo
GROUP BY f.nombre
HAVING COUNT(*) IN (SELECT COUNT(*) FROM producto 
				   WHERE codigo_fabricante IN (SELECT codigo FROM fabricante
											         WHERE nombre = 'Lenovo')); 