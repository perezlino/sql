CREATE DATABASE EJERCICIOS

USE EJERCICIOS

CREATE TABLE departamento (
  codigo INT PRIMARY KEY IDENTITY(1,1),
  nombre VARCHAR(100) NOT NULL,
  presupuesto INT NOT NULL,
  gastos INT NOT NULL
)

CREATE TABLE empleado (
  codigo INT PRIMARY KEY IDENTITY(1,1),
  nif VARCHAR(100) NOT NULL,
  nombre VARCHAR(100) NOT NULL,
  apellido_paterno VARCHAR(100),
  apellido_materno VARCHAR(100),
  codigo_departamento INT
  CONSTRAINT fk_cod_departamento FOREIGN KEY (codigo_departamento) 
  REFERENCES departamento(codigo)
)

INSERT INTO departamento VALUES('Desarrollo', 120000, 6000);
INSERT INTO departamento VALUES('Sistemas', 150000, 21000);
INSERT INTO departamento VALUES('Recursos Humanos', 280000, 25000);
INSERT INTO departamento VALUES('Contabilidad', 110000, 3000);
INSERT INTO departamento VALUES('I+D', 375000, 380000);
INSERT INTO departamento VALUES('Proyectos', 0, 0);
INSERT INTO departamento VALUES('Publicidad', 0, 1000);

INSERT INTO empleado VALUES('32481596F', 'Aaron', 'Rivero', 'Gomez', 1);
INSERT INTO empleado VALUES('Y5575632D', 'Adela', 'Salas', 'Diaz', 2);
INSERT INTO empleado VALUES('R6970642B', 'Adolfo', 'Rubio', 'Flores', 3);
INSERT INTO empleado VALUES('77705545E', 'Adrian', 'Suarez', NULL, 4);
INSERT INTO empleado VALUES('17087203C', 'Marcos', 'Loyola', 'Mendez', 5);
INSERT INTO empleado VALUES('38382980M', 'Maria', 'Santana', 'Moreno', 1);
INSERT INTO empleado VALUES('80576669X', 'Pilar', 'Ruiz', NULL, 2);
INSERT INTO empleado VALUES('71651431Z', 'Pepe', 'Ruiz', 'Santana', 3);
INSERT INTO empleado VALUES('56399183D', 'Juan', 'Gomez', 'Lopez', 2);
INSERT INTO empleado VALUES('46384486H', 'Diego', 'Flores', 'Salas', 5);
INSERT INTO empleado VALUES('67389283A', 'Marta', 'Herrera', 'Gil', 1);
INSERT INTO empleado VALUES('41234836R', 'Irene', 'Salas', 'Flores', NULL);
INSERT INTO empleado VALUES('82635162B', 'Juan', 'Saez', 'Guerrero', NULL);