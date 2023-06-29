-- ==============================================================
-- ======================= CREACIÓN OBJETOS =====================
-- ==============================================================

-- crear database
CREATE DATABASE TiendaBicicletas

-- crear schemas
CREATE SCHEMA Produccion
GO

CREATE SCHEMA Ventas
GO

-- crear tablas
CREATE TABLE Produccion.categorias (
	categoria_id INT IDENTITY (1, 1) PRIMARY KEY,
	categoria_nombre VARCHAR (255) NOT NULL
);

CREATE TABLE Produccion.marcas (
	marca_id INT IDENTITY (1, 1) PRIMARY KEY,
	marca_nombre VARCHAR (255) NOT NULL
);

CREATE TABLE Produccion.productos (
	producto_id INT IDENTITY (1, 1) PRIMARY KEY,
	producto_nombre VARCHAR (255) NOT NULL,
	marca_id INT NOT NULL,
	categoria_id INT NOT NULL,
	ano_modelo SMALLINT NOT NULL,
	precio_catalogo DECIMAL (10, 2) NOT NULL,
	FOREIGN KEY (categoria_id) REFERENCES Produccion.categorias (categoria_id) ON DELETE CASCADE ON UPDATE CASCADE,
	FOREIGN KEY (marca_id) REFERENCES Produccion.marcas (marca_id) ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE TABLE Ventas.clientes (
	cliente_id INT IDENTITY (1, 1) PRIMARY KEY,
	nombre VARCHAR (255) NOT NULL,
	apellido VARCHAR (255) NOT NULL,
	telefono VARCHAR (25),
	email VARCHAR (255) NOT NULL,
	calle VARCHAR (255),
	ciudad VARCHAR (50),
	estado VARCHAR (25),
	codigo_zip VARCHAR (5)
);

CREATE TABLE Ventas.tiendas (
	tienda_id INT IDENTITY (1, 1) PRIMARY KEY,
	nombre_tienda VARCHAR (255) NOT NULL,
	telefono VARCHAR (25),
	email VARCHAR (255),
	calle VARCHAR (255),
	ciudad VARCHAR (255),
	estado VARCHAR (10),
	codigo_zip VARCHAR (5)
);

CREATE TABLE Ventas.personal (
	personal_id INT IDENTITY (1, 1) PRIMARY KEY,
	nombre VARCHAR (50) NOT NULL,
	apellido VARCHAR (50) NOT NULL,
	email VARCHAR (255) NOT NULL UNIQUE,
	telefono VARCHAR (25),
	activo tinyint NOT NULL,
	tienda_id INT NOT NULL,
	manager_id INT,
	FOREIGN KEY (tienda_id) REFERENCES Ventas.tiendas (tienda_id) ON DELETE CASCADE ON UPDATE CASCADE,
	FOREIGN KEY (manager_id) REFERENCES Ventas.personal (personal_id) ON DELETE NO ACTION ON UPDATE NO ACTION
);

CREATE TABLE Ventas.pedidos (
	pedido_id INT IDENTITY (1, 1) PRIMARY KEY,
	cliente_id INT,
	estado_pedido tinyint NOT NULL,
	-- Estado pedido: 1 = En espera; 2 = En proceso; 3 = Rechazado; 4 = Completado
	fecha_pedido DATE NOT NULL,
	fecha_requerimiento DATE NOT NULL,
	fecha_envio DATE,
	tienda_id INT NOT NULL,
	personal_id INT NOT NULL,
	FOREIGN KEY (cliente_id) REFERENCES Ventas.clientes (cliente_id) ON DELETE CASCADE ON UPDATE CASCADE,
	FOREIGN KEY (tienda_id) REFERENCES Ventas.tiendas (tienda_id) ON DELETE CASCADE ON UPDATE CASCADE,
	FOREIGN KEY (personal_id) REFERENCES Ventas.personal (personal_id) ON DELETE NO ACTION ON UPDATE NO ACTION
);

CREATE TABLE Ventas.items_pedidos (
	pedido_id INT,
	item_id INT,
	producto_id INT NOT NULL,
	cantidad INT NOT NULL,
	precio_catalogo DECIMAL (10, 2) NOT NULL,
	descuento DECIMAL (4, 2) NOT NULL DEFAULT 0,
	PRIMARY KEY (pedido_id, item_id),
	FOREIGN KEY (pedido_id) REFERENCES Ventas.pedidos (pedido_id) ON DELETE CASCADE ON UPDATE CASCADE,
	FOREIGN KEY (producto_id) REFERENCES Produccion.productos (producto_id) ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE TABLE Produccion.stocks (
	tienda_id INT,
	producto_id INT,
	cantidad INT,
	PRIMARY KEY (tienda_id, producto_id),
	FOREIGN KEY (tienda_id) REFERENCES Ventas.tiendas (tienda_id) ON DELETE CASCADE ON UPDATE CASCADE,
	FOREIGN KEY (producto_id) REFERENCES Produccion.productos (producto_id) ON DELETE CASCADE ON UPDATE CASCADE
);