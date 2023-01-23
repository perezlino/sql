
CREATE DATABASE EJERCICIOS

USE EJERCICIOS

CREATE TABLE fabricante (
  codigo INT PRIMARY KEY IDENTITY(1,1),
  nombre VARCHAR(100) NOT NULL
);

CREATE TABLE producto (
  codigo INT PRIMARY KEY IDENTITY(1,1),
  nombre VARCHAR(100) NOT NULL,
  precio FLOAT NOT NULL,
  codigo_fabricante INT NOT NULL,
  CONSTRAINT fk_cod_fabricante FOREIGN KEY (codigo_fabricante) 
  REFERENCES fabricante(codigo)
)

INSERT INTO fabricante VALUES('Asus');
INSERT INTO fabricante VALUES('Lenovo');
INSERT INTO fabricante VALUES('Hewlett-Packard');
INSERT INTO fabricante VALUES('Samsung');
INSERT INTO fabricante VALUES('Seagate');
INSERT INTO fabricante VALUES('Crucial');
INSERT INTO fabricante VALUES('Gigabyte');
INSERT INTO fabricante VALUES('Huawei');
INSERT INTO fabricante VALUES('Xiaomi');

INSERT INTO producto VALUES('Disco duro SATA3 1TB', 86.99, 5);
INSERT INTO producto VALUES('Memoria RAM DDR4 8GB', 120, 6);
INSERT INTO producto VALUES('Disco SSD 1 TB', 150.99, 4);
INSERT INTO producto VALUES('GeForce GTX 1050Ti', 185, 7);
INSERT INTO producto VALUES('GeForce GTX 1080 Xtreme', 755, 6);
INSERT INTO producto VALUES('Monitor 24 LED Full HD', 202, 1);
INSERT INTO producto VALUES('Monitor 27 LED Full HD', 245.99, 1);
INSERT INTO producto VALUES('Portátil Yoga 520', 559, 2);
INSERT INTO producto VALUES('Portátil Ideapd 320', 444, 2);
INSERT INTO producto VALUES('Impresora HP Deskjet 3720', 59.99, 3);
INSERT INTO producto VALUES('Impresora HP Laserjet Pro M26nw', 180, 3);