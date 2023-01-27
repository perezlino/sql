-- ==============================================================
-- ======================= CREACIÓN OBJETOS =====================
-- ==============================================================

-- crear database
CREATE DATABASE Transacciones

-- crear tablas
CREATE TABLE dbo.Transaccion (
	empleado_id INT NOT NULL,
	fecha_transaccion SMALLDATETIME NOT NULL,
    monto SMALLMONEY NOT NULL
    PRIMARY KEY (empleado_id, fecha_transaccion)
);

CREATE TABLE dbo.Transaccion_staging (
	empleado_id INT NOT NULL,
	fecha_transaccion SMALLDATETIME NOT NULL,
    monto SMALLMONEY NOT NULL
);