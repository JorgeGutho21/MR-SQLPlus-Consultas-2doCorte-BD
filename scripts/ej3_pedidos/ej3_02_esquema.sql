-- ============================================================
-- ej3_02_esquema.sql
-- Ruta practica Oracle - Ejercicio 3: Clientes y pedidos
-- 02 - Esquema (administrador): tablas, restricciones, usuario de consultas y sus permisos (etapas 3 a 5).
-- Usuario: USR_ADMIN_PED  |  Servicio: localhost:1521/XEPDB1
-- Ejecutar desde SQL*Plus con:  @C:\archivosbd\ej3_02_esquema.sql
-- Las contrasenas NO estan en el archivo: SQL*Plus las pide ocultas.
-- ============================================================
SET VERIFY OFF

CONNECT usr_admin_ped@localhost:1521/XEPDB1
SHOW USER
SPOOL C:\archivosbd\evidencia_ej3_pedidos.txt APPEND
PROMPT Etapa 3 - USR_ADMIN_PED crea las tablas

-- ------------------------------------------------------------
-- Crear la tabla CLIENTE
CREATE TABLE cliente (
  id_cliente       NUMBER(6),
  primer_nombre    VARCHAR2(15 CHAR) NOT NULL,
  segundo_nombre   VARCHAR2(15 CHAR),
  primer_apellido  VARCHAR2(20 CHAR) NOT NULL,
  segundo_apellido VARCHAR2(20 CHAR),
  correo           VARCHAR2(100 CHAR) NOT NULL,
  ciudad           VARCHAR2(30 CHAR)
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

-- ------------------------------------------------------------
-- Agregar las PRIMARY KEY
PROMPT Etapa 3 - PRIMARY KEY
ALTER TABLE cliente
  ADD CONSTRAINT pk_cliente PRIMARY KEY (id_cliente);

ALTER TABLE producto
  ADD CONSTRAINT pk_producto PRIMARY KEY (id_producto);

ALTER TABLE pedido
  ADD CONSTRAINT pk_pedido PRIMARY KEY (id_pedido);

ALTER TABLE detalle_pedido
  ADD CONSTRAINT pk_detalle_pedido PRIMARY KEY (id_pedido, id_producto);

-- Verificacion
COLUMN constraint_name FORMAT A24
COLUMN table_name FORMAT A18
COLUMN r_constraint_name FORMAT A20
SELECT constraint_name, table_name
FROM user_constraints
WHERE constraint_type = 'P'
ORDER BY table_name;

-- ------------------------------------------------------------
-- Agregar las FOREIGN KEY
PROMPT Etapa 3 - FOREIGN KEY
ALTER TABLE pedido
  ADD CONSTRAINT fk_pedido_cliente
  FOREIGN KEY (id_cliente) REFERENCES cliente (id_cliente);

ALTER TABLE detalle_pedido
  ADD CONSTRAINT fk_detalle_pedido
  FOREIGN KEY (id_pedido) REFERENCES pedido (id_pedido);

ALTER TABLE detalle_pedido
  ADD CONSTRAINT fk_detalle_producto
  FOREIGN KEY (id_producto) REFERENCES producto (id_producto);

-- Verificacion
COLUMN constraint_name FORMAT A24
COLUMN table_name FORMAT A18
COLUMN r_constraint_name FORMAT A20
SELECT constraint_name, table_name, r_constraint_name
FROM user_constraints
WHERE constraint_type = 'R'
ORDER BY table_name, constraint_name;

-- ------------------------------------------------------------
-- Agregar UNIQUE y CHECK
PROMPT Etapa 3 - UNIQUE y CHECK
ALTER TABLE cliente
  ADD CONSTRAINT uq_cliente_correo UNIQUE (correo);

ALTER TABLE producto
  ADD CONSTRAINT uq_producto_nombre UNIQUE (nom_producto);

ALTER TABLE producto
  ADD CONSTRAINT chk_producto_precio CHECK (precio_lista > 0);

ALTER TABLE pedido
  ADD CONSTRAINT chk_pedido_estado CHECK (estado IN ('PENDIENTE', 'ENVIADO', 'ENTREGADO', 'ANULADO'));

ALTER TABLE detalle_pedido
  ADD CONSTRAINT chk_detalle_cantidad CHECK (cantidad > 0);

ALTER TABLE detalle_pedido
  ADD CONSTRAINT chk_detalle_precio CHECK (precio_venta >= 0);

-- Verificacion
COLUMN constraint_name FORMAT A24
COLUMN table_name FORMAT A18
COLUMN r_constraint_name FORMAT A20
SELECT constraint_name, constraint_type, table_name
FROM user_constraints
WHERE constraint_name NOT LIKE 'SYS%'
ORDER BY table_name, constraint_type, constraint_name;

-- ------------------------------------------------------------
-- Etapa 4 (USR_ADMIN_PED): crear el usuario de consultas USR_CONSULTAS_PED
PROMPT Etapa 4 - USR_ADMIN_PED crea el usuario de consultas
SPOOL OFF
ACCEPT clave_cons CHAR PROMPT 'Clave para USR_CONSULTAS_PED: ' HIDE
CREATE USER usr_consultas_ped
  IDENTIFIED BY "&clave_cons"
  DEFAULT TABLESPACE ts_pedidos
  TEMPORARY TABLESPACE temp;
UNDEFINE clave_cons
SPOOL C:\archivosbd\evidencia_ej3_pedidos.txt APPEND
PROMPT Etapa 4 - USR_ADMIN_PED creo el usuario USR_CONSULTAS_PED

-- Verificacion
COLUMN username FORMAT A18
SELECT username, created
FROM all_users
WHERE username = 'USR_CONSULTAS_PED';

-- ------------------------------------------------------------
-- Etapa 5 (USR_ADMIN_PED): conceder CREATE SESSION al usuario de consultas
PROMPT Etapa 5 - USR_ADMIN_PED concede privilegios al usuario de consultas
GRANT CREATE SESSION TO usr_consultas_ped;

-- Verificacion
COLUMN privilege FORMAT A16
SELECT privilege, admin_option
FROM user_sys_privs
ORDER BY privilege;

-- ------------------------------------------------------------
-- Etapa 5 (USR_ADMIN_PED): privilegios sobre objetos
GRANT SELECT, INSERT ON cliente TO usr_consultas_ped;
GRANT SELECT, INSERT ON producto TO usr_consultas_ped;
GRANT SELECT, INSERT ON pedido TO usr_consultas_ped;
GRANT SELECT, INSERT ON detalle_pedido TO usr_consultas_ped;

-- Verificacion
COLUMN grantee FORMAT A18
COLUMN table_name FORMAT A18
COLUMN privilege FORMAT A10
SELECT grantee, table_name, privilege
FROM user_tab_privs_made
WHERE grantee = 'USR_CONSULTAS_PED'
ORDER BY table_name, privilege;

SPOOL OFF
