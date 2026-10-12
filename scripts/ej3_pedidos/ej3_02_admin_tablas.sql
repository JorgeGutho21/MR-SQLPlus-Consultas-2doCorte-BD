-- ============================================================
-- ej3_02_admin_tablas.sql
-- Ruta practica Oracle - Ejercicio 3: Clientes y pedidos
-- Etapa 3 (administrador): CREATE TABLE de todas las tablas, sin restricciones.
-- Usuario: USR_ADMIN_PED  |  Servicio: localhost:1521/XEPDB1
-- Ejecutar desde SQL*Plus con:  @C:\archivosbd\ej3_02_admin_tablas.sql
-- Las contrasenas NO estan en el archivo: SQL*Plus las pide ocultas.
-- ============================================================
SET VERIFY OFF

CONNECT usr_admin_ped@localhost:1521/XEPDB1
SHOW USER
SPOOL C:\archivosbd\evidencia_ej3_pedidos.txt APPEND

-- ------------------------------------------------------------
-- Crear la tabla CLIENTE
CREATE TABLE cliente (
  id_cliente NUMBER(6),
  nombre     VARCHAR2(15 CHAR) NOT NULL,
  apellido   VARCHAR2(20 CHAR) NOT NULL,
  correo     VARCHAR2(100 CHAR) NOT NULL,
  ciudad     VARCHAR2(30 CHAR)
);

-- Verificacion
DESC cliente

-- ------------------------------------------------------------
-- Crear la tabla PRODUCTO
CREATE TABLE producto (
  id_producto  NUMBER(5),
  nom_producto VARCHAR2(40 CHAR) NOT NULL,
  precio_lista NUMBER(10,2) NOT NULL
);

-- Verificacion
DESC producto

-- ------------------------------------------------------------
-- Crear la tabla PEDIDO
CREATE TABLE pedido (
  id_pedido    NUMBER(8),
  fecha_pedido DATE DEFAULT SYSDATE NOT NULL,
  estado       VARCHAR2(10 CHAR) DEFAULT 'PENDIENTE' NOT NULL,
  id_cliente   NUMBER(6) NOT NULL
);

-- Verificacion
DESC pedido

-- ------------------------------------------------------------
-- Crear la tabla DETALLE_PEDIDO
CREATE TABLE detalle_pedido (
  id_pedido    NUMBER(8),
  id_producto  NUMBER(5),
  cantidad     NUMBER(4) NOT NULL,
  precio_venta NUMBER(10,2) NOT NULL
);

-- Verificacion
DESC detalle_pedido

SPOOL OFF
