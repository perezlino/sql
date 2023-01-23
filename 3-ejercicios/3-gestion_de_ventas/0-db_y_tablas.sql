CREATE DATABASE EJERCICIOS

USE EJERCICIOS

CREATE TABLE consumidor (
  consumidor_id INT PRIMARY KEY IDENTITY(1,1),
  nombre VARCHAR(100) NOT NULL,
  apellido_paterno VARCHAR(100),
  apellido_materno VARCHAR(100),
  ciudad VARCHAR(100),
  categoria INT
)

CREATE TABLE comercial (
  comercial_id INT PRIMARY KEY IDENTITY(1,1),
  nombre VARCHAR(100) NOT NULL,
  apellido_paterno VARCHAR(100),
  apellido_materno VARCHAR(100),
  comision FLOAT NOT NULL
)

CREATE TABLE orden (
  orden_id INT PRIMARY KEY IDENTITY(1,1),
  total FLOAT NOT NULL,
  fecha_orden DATE NOT NULL,
  consumidor_id INT,
  comercial_id INT
  CONSTRAINT fk_con_id FOREIGN KEY (consumidor_id) 
  REFERENCES consumidor(consumidor_id),
  CONSTRAINT fk_com_id FOREIGN KEY (comercial_id) 
  REFERENCES comercial(comercial_id)
)


INSERT INTO orden VALUES(150.50, '2017-10-05', 5, 2);
INSERT INTO orden VALUES(270.65, '2016-09-10', 1, 5);
INSERT INTO orden VALUES(65.26, '2017-10-05', 2, 1);
INSERT INTO orden VALUES(110.50, '2016-08-17', 8, 3);
INSERT INTO orden VALUES(948.50, '2017-09-10', 5, 2);
INSERT INTO orden VALUES(2400.60, '2016-07-27', 7, 1);
INSERT INTO orden VALUES(5760.00, '2015-09-10', 2, 1);
INSERT INTO orden VALUES(1983.43, '2017-10-10', 4, 6);
INSERT INTO orden VALUES(2480.40, '2016-10-10', 8, 3);
INSERT INTO orden VALUES(250.45, '2015-06-27', 8, 2);
INSERT INTO orden VALUES(75.29, '2016-08-17', 3, 7);
INSERT INTO orden VALUES(3045.60, '2017-04-25', 2, 1);
INSERT INTO orden VALUES(545.75, '2019-01-25', 6, 1);
INSERT INTO orden VALUES(145.82, '2017-02-02', 6, 1);
INSERT INTO orden VALUES(370.85, '2019-03-11', 1, 5);
INSERT INTO orden VALUES(2389.23, '2019-03-11', 1, 5);


INSERT INTO consumidor VALUES('Aaron', 'Rivero', 'Gomez', 'Almeria', 100);
INSERT INTO consumidor VALUES('Adela', 'Salas', 'Diaz', 'Granada', 200);
INSERT INTO consumidor VALUES('Adolfo', 'Rubio', 'Flores', 'Sevilla', NULL);
INSERT INTO consumidor VALUES('Adrian', 'Suarez', NULL, 'Jaen', 300);
INSERT INTO consumidor VALUES('Marcos', 'Loyola', 'Mendez', 'Almeria', 300);
INSERT INTO consumidor VALUES('Maria', 'Santana', 'Moreno', 'Cadiz', 100);
INSERT INTO consumidor VALUES('Pilar', 'Ruiz', NULL, 'Sevilla', 300);
INSERT INTO consumidor VALUES('Pepe', 'Ruiz', 'Santana', 'Huelva', 200);
INSERT INTO consumidor VALUES('Juan', 'Gomez', 'Lopez', 'Granada', 225);
INSERT INTO consumidor VALUES('Diego', 'Flores', 'Salas', 'Sevilla', 125);


INSERT INTO comercial VALUES('Marta', 'Herrera', 'Gil', 0.15);
INSERT INTO comercial VALUES('Irene', 'Salas', 'Flores', 0.13);
INSERT INTO comercial VALUES('Juan', 'Saez', 'Guerrero', 0.11);
INSERT INTO comercial VALUES('Alfonso', 'Perez', 'Lino', 0.14);
INSERT INTO comercial VALUES('Tomas', 'Rios', 'Rojas', 0.12);
INSERT INTO comercial VALUES('Gonzalo', 'Pedrero', 'Sanhueza', 0.13);
INSERT INTO comercial VALUES('Antonio', 'Vega', 'Hernandez', 0.11);
INSERT INTO comercial VALUES('Daniel', 'Smith', 'Soto', 0.05);