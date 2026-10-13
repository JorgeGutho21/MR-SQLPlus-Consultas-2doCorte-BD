-- ============================================================
-- ej3_00_completo.sql
-- Ruta practica Oracle - Ejercicio 3: Clientes y pedidos
-- Script completo: las seis etapas en orden, con cambios de usuario y evidencia SPOOL.
-- Usuario: SYSTEM -> USR_ADMIN_PED -> USR_CONSULTAS_PED  |  Servicio: localhost:1521/XEPDB1
-- Ejecutar desde SQL*Plus con:  @C:\archivosbd\ej3_00_completo.sql
-- Las contrasenas NO estan en el archivo: SQL*Plus las pide ocultas.
-- ============================================================
-- Abrir antes:  cd /d C:\archivosbd   y   sqlplus /nolog
SET VERIFY OFF

-- ------------------------------------------------------------
-- [Etapa 1] Conectarte como SYSTEM a XEPDB1
CONNECT system@localhost:1521/XEPDB1

-- ------------------------------------------------------------
-- [Etapa 1] Iniciar la evidencia con SPOOL y confirmar la sesion
SPOOL C:\archivosbd\evidencia_ej3_pedidos.txt
PROMPT ==== EJERCICIO 3: CLIENTES Y PEDIDOS ====
PROMPT Etapa 1 - SYSTEM crea el TABLESPACE y su DATAFILE
SHOW USER
SHOW CON_NAME

-- ------------------------------------------------------------
-- [Etapa 1] Crear el TABLESPACE y su DATAFILE
CREATE TABLESPACE ts_pedidos
  DATAFILE 'C:\ORACLE_EXE\ORADATA\XE\XEPDB1\TS_PEDIDOS01.DBF'
  SIZE 20M
  AUTOEXTEND ON NEXT 5M
  MAXSIZE 100M;

-- Verificacion
COLUMN tablespace_name FORMAT A15
COLUMN file_name FORMAT A55
SELECT tablespace_name, status, contents
FROM dba_tablespaces
WHERE tablespace_name = 'TS_PEDIDOS';

SELECT file_name, bytes/1024/1024 AS mb, autoextensible
FROM dba_data_files
WHERE tablespace_name = 'TS_PEDIDOS';

-- ------------------------------------------------------------
-- [Etapa 2] Crear el usuario administrador USR_ADMIN_PED
SPOOL OFF
ACCEPT clave_admin CHAR PROMPT 'Clave para USR_ADMIN_PED: ' HIDE
CREATE USER usr_admin_ped
  IDENTIFIED BY "&clave_admin"
  DEFAULT TABLESPACE ts_pedidos
  TEMPORARY TABLESPACE temp
  QUOTA 20M ON ts_pedidos;
UNDEFINE clave_admin
SPOOL C:\archivosbd\evidencia_ej3_pedidos.txt APPEND
PROMPT Etapa 2 - SYSTEM creo el usuario administrador USR_ADMIN_PED

-- Verificacion
COLUMN username FORMAT A18
COLUMN default_tablespace FORMAT A16
COLUMN temporary_tablespace FORMAT A10
COLUMN account_status FORMAT A14
SELECT username, default_tablespace, temporary_tablespace, account_status
FROM dba_users
WHERE username = 'USR_ADMIN_PED';

SELECT tablespace_name, max_bytes/1024/1024 AS cuota_mb
FROM dba_ts_quotas
WHERE username = 'USR_ADMIN_PED';

-- ------------------------------------------------------------
-- [Etapa 3] Etapa 3 (SYSTEM): privilegios del sistema para USR_ADMIN_PED
PROMPT Etapa 3 - SYSTEM otorga privilegios a USR_ADMIN_PED
GRANT CREATE SESSION, CREATE TABLE, CREATE USER TO usr_admin_ped;
GRANT CREATE SESSION TO usr_admin_ped WITH ADMIN OPTION;

-- Verificacion
COLUMN grantee FORMAT A18
COLUMN privilege FORMAT A16
SELECT grantee, privilege, admin_option
FROM dba_sys_privs
WHERE grantee = 'USR_ADMIN_PED'
ORDER BY privilege;

-- ------------------------------------------------------------
-- [Etapa 3] Conectarte como USR_ADMIN_PED
CONNECT usr_admin_ped@localhost:1521/XEPDB1
SHOW USER
PROMPT Etapa 3 - USR_ADMIN_PED crea las tablas

-- ------------------------------------------------------------
-- [Etapa 3] Crear la tabla CLIENTE
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
-- [Etapa 3] Crear la tabla PRODUCTO
CREATE TABLE producto (
  id_producto  NUMBER(5),
  nom_producto VARCHAR2(40 CHAR) NOT NULL,
  precio_lista NUMBER(10,2) NOT NULL
);

-- Verificacion
DESC producto

-- ------------------------------------------------------------
-- [Etapa 3] Crear la tabla PEDIDO
CREATE TABLE pedido (
  id_pedido    NUMBER(8),
  fecha_pedido DATE DEFAULT SYSDATE NOT NULL,
  estado       VARCHAR2(10 CHAR) DEFAULT 'PENDIENTE' NOT NULL,
  id_cliente   NUMBER(6) NOT NULL
);

-- Verificacion
DESC pedido

-- ------------------------------------------------------------
-- [Etapa 3] Crear la tabla DETALLE_PEDIDO
CREATE TABLE detalle_pedido (
  id_pedido    NUMBER(8),
  id_producto  NUMBER(5),
  cantidad     NUMBER(4) NOT NULL,
  precio_venta NUMBER(10,2) NOT NULL
);

-- Verificacion
DESC detalle_pedido

-- ------------------------------------------------------------
-- [Etapa 3] Agregar las PRIMARY KEY
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
-- [Etapa 3] Agregar las FOREIGN KEY
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
-- [Etapa 3] Agregar UNIQUE y CHECK
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
-- [Etapa 4] Etapa 4 (USR_ADMIN_PED): crear el usuario de consultas USR_CONSULTAS_PED
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
-- [Etapa 5] Etapa 5 (USR_ADMIN_PED): conceder CREATE SESSION al usuario de consultas
PROMPT Etapa 5 - USR_ADMIN_PED concede privilegios al usuario de consultas
GRANT CREATE SESSION TO usr_consultas_ped;

-- Verificacion
COLUMN privilege FORMAT A16
SELECT privilege, admin_option
FROM user_sys_privs
ORDER BY privilege;

-- ------------------------------------------------------------
-- [Etapa 5] Etapa 5 (USR_ADMIN_PED): privilegios sobre objetos
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

-- ------------------------------------------------------------
-- [Etapa 6] Etapa 6: conectarte como USR_CONSULTAS_PED y preparar la pantalla
CONNECT usr_consultas_ped@localhost:1521/XEPDB1
SHOW USER
PROMPT Etapa 6 - USR_CONSULTAS_PED inserta, confirma y consulta
SET LINESIZE 200
SET PAGESIZE 100

-- ------------------------------------------------------------
-- [Etapa 6] Comprobar que puede hacer USR_CONSULTAS_PED
COLUMN privilege FORMAT A16
SELECT privilege FROM session_privs;

COLUMN owner FORMAT A16
COLUMN table_name FORMAT A18
COLUMN privilege FORMAT A10
SELECT owner, table_name, privilege
FROM user_tab_privs_recd
WHERE owner = 'USR_ADMIN_PED'
ORDER BY table_name, privilege;

-- ------------------------------------------------------------
-- [Etapa 6] Comprobar por que hace falta ESQUEMA.TABLA
-- ERRORES ESPERADOS (prueba intencional): ORA-00942
SELECT COUNT(*) FROM cliente;

SELECT COUNT(*) FROM usr_admin_ped.cliente;

-- ------------------------------------------------------------
-- [Etapa 6] Insertar en CLIENTE (6 filas)
INSERT INTO usr_admin_ped.cliente (id_cliente, primer_nombre, segundo_nombre, primer_apellido, segundo_apellido, correo, ciudad)
VALUES (1, 'Mariana', NULL, 'Lopez', NULL, 'mariana.lopez@correo.com', 'Cali');
INSERT INTO usr_admin_ped.cliente (id_cliente, primer_nombre, segundo_nombre, primer_apellido, segundo_apellido, correo, ciudad)
VALUES (2, 'Jorge', NULL, 'Mendez', NULL, 'jorge.mendez@correo.com', 'Bogota');
INSERT INTO usr_admin_ped.cliente (id_cliente, primer_nombre, segundo_nombre, primer_apellido, segundo_apellido, correo, ciudad)
VALUES (3, 'Sofia', NULL, 'Arango', NULL, 'sofia.arango@correo.com', 'Medellin');
INSERT INTO usr_admin_ped.cliente (id_cliente, primer_nombre, segundo_nombre, primer_apellido, segundo_apellido, correo, ciudad)
VALUES (4, 'Ricardo', NULL, 'Pineda', NULL, 'ricardo.pineda@correo.com', 'Cali');
INSERT INTO usr_admin_ped.cliente (id_cliente, primer_nombre, segundo_nombre, primer_apellido, segundo_apellido, correo, ciudad)
VALUES (5, 'Valeria', NULL, 'Ortiz', NULL, 'valeria.ortiz@correo.com', 'Barranquilla');
INSERT INTO usr_admin_ped.cliente (id_cliente, primer_nombre, segundo_nombre, primer_apellido, segundo_apellido, correo, ciudad)
VALUES (6, 'Tomas', NULL, 'Galvis', NULL, 'tomas.galvis@correo.com', 'Bogota');

-- ------------------------------------------------------------
-- [Etapa 6] Insertar en PRODUCTO (8 filas)
INSERT INTO usr_admin_ped.producto (id_producto, nom_producto, precio_lista)
VALUES (101, 'Teclado mecanico', 180000);
INSERT INTO usr_admin_ped.producto (id_producto, nom_producto, precio_lista)
VALUES (102, 'Mouse inalambrico', 65000);
INSERT INTO usr_admin_ped.producto (id_producto, nom_producto, precio_lista)
VALUES (103, 'Monitor 24 pulgadas', 720000);
INSERT INTO usr_admin_ped.producto (id_producto, nom_producto, precio_lista)
VALUES (104, 'Audifonos USB', 95000);
INSERT INTO usr_admin_ped.producto (id_producto, nom_producto, precio_lista)
VALUES (105, 'Memoria USB 64 GB', 38000);
INSERT INTO usr_admin_ped.producto (id_producto, nom_producto, precio_lista)
VALUES (106, 'Disco SSD 1 TB', 310000);
INSERT INTO usr_admin_ped.producto (id_producto, nom_producto, precio_lista)
VALUES (107, 'Camara web HD', 140000);
INSERT INTO usr_admin_ped.producto (id_producto, nom_producto, precio_lista)
VALUES (108, 'Base para portatil', 75000);

-- ------------------------------------------------------------
-- [Etapa 6] Insertar en PEDIDO (9 filas)
INSERT INTO usr_admin_ped.pedido (id_pedido, fecha_pedido, estado, id_cliente)
VALUES (5001, DATE '2026-08-03', 'ENTREGADO', 1);
INSERT INTO usr_admin_ped.pedido (id_pedido, fecha_pedido, estado, id_cliente)
VALUES (5002, DATE '2026-08-05', 'ENTREGADO', 2);
INSERT INTO usr_admin_ped.pedido (id_pedido, fecha_pedido, estado, id_cliente)
VALUES (5003, DATE '2026-08-12', 'ENTREGADO', 1);
INSERT INTO usr_admin_ped.pedido (id_pedido, fecha_pedido, estado, id_cliente)
VALUES (5004, DATE '2026-08-20', 'ENVIADO', 3);
INSERT INTO usr_admin_ped.pedido (id_pedido, fecha_pedido, estado, id_cliente)
VALUES (5005, DATE '2026-08-28', 'ENTREGADO', 4);
INSERT INTO usr_admin_ped.pedido (id_pedido, fecha_pedido, estado, id_cliente)
VALUES (5006, DATE '2026-09-02', 'ENVIADO', 2);
INSERT INTO usr_admin_ped.pedido (id_pedido, fecha_pedido, estado, id_cliente)
VALUES (5007, DATE '2026-09-10', 'PENDIENTE', 5);
INSERT INTO usr_admin_ped.pedido (id_pedido, fecha_pedido, estado, id_cliente)
VALUES (5008, DATE '2026-09-15', 'ANULADO', 3);
INSERT INTO usr_admin_ped.pedido (id_pedido, fecha_pedido, estado, id_cliente)
VALUES (5009, DATE '2026-09-21', 'PENDIENTE', 1);

-- ------------------------------------------------------------
-- [Etapa 6] Insertar en DETALLE_PEDIDO (17 filas)
INSERT INTO usr_admin_ped.detalle_pedido (id_pedido, id_producto, cantidad, precio_venta)
VALUES (5001, 101, 1, 180000);
INSERT INTO usr_admin_ped.detalle_pedido (id_pedido, id_producto, cantidad, precio_venta)
VALUES (5001, 102, 1, 65000);
INSERT INTO usr_admin_ped.detalle_pedido (id_pedido, id_producto, cantidad, precio_venta)
VALUES (5002, 103, 2, 699000);
INSERT INTO usr_admin_ped.detalle_pedido (id_pedido, id_producto, cantidad, precio_venta)
VALUES (5002, 104, 1, 95000);
INSERT INTO usr_admin_ped.detalle_pedido (id_pedido, id_producto, cantidad, precio_venta)
VALUES (5003, 105, 3, 38000);
INSERT INTO usr_admin_ped.detalle_pedido (id_pedido, id_producto, cantidad, precio_venta)
VALUES (5004, 106, 1, 310000);
INSERT INTO usr_admin_ped.detalle_pedido (id_pedido, id_producto, cantidad, precio_venta)
VALUES (5004, 101, 1, 175000);
INSERT INTO usr_admin_ped.detalle_pedido (id_pedido, id_producto, cantidad, precio_venta)
VALUES (5005, 103, 1, 720000);
INSERT INTO usr_admin_ped.detalle_pedido (id_pedido, id_producto, cantidad, precio_venta)
VALUES (5005, 102, 3, 65000);
INSERT INTO usr_admin_ped.detalle_pedido (id_pedido, id_producto, cantidad, precio_venta)
VALUES (5005, 107, 1, 140000);
INSERT INTO usr_admin_ped.detalle_pedido (id_pedido, id_producto, cantidad, precio_venta)
VALUES (5006, 104, 2, 90000);
INSERT INTO usr_admin_ped.detalle_pedido (id_pedido, id_producto, cantidad, precio_venta)
VALUES (5006, 105, 5, 35000);
INSERT INTO usr_admin_ped.detalle_pedido (id_pedido, id_producto, cantidad, precio_venta)
VALUES (5007, 106, 2, 299000);
INSERT INTO usr_admin_ped.detalle_pedido (id_pedido, id_producto, cantidad, precio_venta)
VALUES (5008, 107, 1, 140000);
INSERT INTO usr_admin_ped.detalle_pedido (id_pedido, id_producto, cantidad, precio_venta)
VALUES (5009, 101, 2, 180000);
INSERT INTO usr_admin_ped.detalle_pedido (id_pedido, id_producto, cantidad, precio_venta)
VALUES (5009, 102, 1, 60000);
INSERT INTO usr_admin_ped.detalle_pedido (id_pedido, id_producto, cantidad, precio_venta)
VALUES (5009, 105, 2, 38000);

-- ------------------------------------------------------------
-- [Etapa 6] Confirmar con COMMIT y contar las filas
COMMIT;

SELECT 'CLIENTE' AS tabla, COUNT(*) AS filas FROM usr_admin_ped.cliente
UNION ALL
SELECT 'PRODUCTO' AS tabla, COUNT(*) AS filas FROM usr_admin_ped.producto
UNION ALL
SELECT 'PEDIDO' AS tabla, COUNT(*) AS filas FROM usr_admin_ped.pedido
UNION ALL
SELECT 'DETALLE_PEDIDO' AS tabla, COUNT(*) AS filas FROM usr_admin_ped.detalle_pedido;

-- ------------------------------------------------------------
-- [Etapa 6] Probar los DEFAULT y deshacer con ROLLBACK
INSERT INTO usr_admin_ped.pedido (id_pedido, id_cliente)
VALUES (5999, 6);

SELECT id_pedido, estado,
       CASE WHEN TRUNC(fecha_pedido) = TRUNC(SYSDATE) THEN 'FECHA DE HOY' ELSE 'OTRA FECHA' END AS fecha
FROM usr_admin_ped.pedido
WHERE id_pedido = 5999;

ROLLBACK;

-- ------------------------------------------------------------
-- [Etapa 6] Pruebas de integridad: errores esperados
-- ERRORES ESPERADOS (prueba intencional): ORA-02290, ORA-02290, ORA-00001, ORA-01031
PROMPT Pruebas intencionales: cada sentencia debe fallar
INSERT INTO usr_admin_ped.detalle_pedido (id_pedido, id_producto, cantidad, precio_venta)
VALUES (5007, 101, 0, 180000);

INSERT INTO usr_admin_ped.pedido (id_pedido, fecha_pedido, estado, id_cliente)
VALUES (5010, DATE '2026-09-25', 'PERDIDO', 2);

INSERT INTO usr_admin_ped.cliente (id_cliente, primer_nombre, primer_apellido, correo, ciudad)
VALUES (7, 'Mario', 'Lopez', 'mariana.lopez@correo.com', 'Cali');

DELETE FROM usr_admin_ped.cliente
WHERE id_cliente = 6;

-- ------------------------------------------------------------
-- [Etapa 6] Consulta: Cual es el total de cada pedido?
SELECT p.id_pedido, c.primer_nombre || ' ' || c.primer_apellido AS cliente, p.estado,
       SUM(d.cantidad * d.precio_venta) AS total
FROM usr_admin_ped.pedido p
JOIN usr_admin_ped.cliente c ON c.id_cliente = p.id_cliente
JOIN usr_admin_ped.detalle_pedido d ON d.id_pedido = p.id_pedido
GROUP BY p.id_pedido, c.primer_nombre, c.primer_apellido, p.estado
ORDER BY p.id_pedido;

-- ------------------------------------------------------------
-- [Etapa 6] Consulta: Cuanto ha comprado cada cliente (sin pedidos anulados)?
SELECT c.primer_nombre, c.primer_apellido,
       COUNT(DISTINCT p.id_pedido) AS pedidos,
       SUM(d.cantidad * d.precio_venta) AS total_comprado
FROM usr_admin_ped.cliente c
JOIN usr_admin_ped.pedido p ON p.id_cliente = c.id_cliente
JOIN usr_admin_ped.detalle_pedido d ON d.id_pedido = p.id_pedido
WHERE p.estado <> 'ANULADO'
GROUP BY c.primer_nombre, c.primer_apellido
ORDER BY total_comprado DESC;

-- ------------------------------------------------------------
-- [Etapa 6] Consulta: Cuales son los productos mas vendidos (en unidades)?
SELECT pr.nom_producto,
       SUM(d.cantidad) AS unidades,
       COUNT(*) AS lineas
FROM usr_admin_ped.producto pr
JOIN usr_admin_ped.detalle_pedido d ON d.id_producto = pr.id_producto
JOIN usr_admin_ped.pedido p ON p.id_pedido = d.id_pedido
WHERE p.estado <> 'ANULADO'
GROUP BY pr.nom_producto
ORDER BY unidades DESC, pr.nom_producto;

-- ------------------------------------------------------------
-- [Etapa 6] Consulta: Que productos nunca se han vendido?
SELECT pr.id_producto, pr.nom_producto
FROM usr_admin_ped.producto pr
LEFT JOIN usr_admin_ped.detalle_pedido d ON d.id_producto = pr.id_producto
WHERE d.id_pedido IS NULL;

-- ------------------------------------------------------------
-- [Etapa 6] Consulta: Que pedidos superan 1.000.000?
SELECT d.id_pedido, SUM(d.cantidad * d.precio_venta) AS total
FROM usr_admin_ped.detalle_pedido d
GROUP BY d.id_pedido
HAVING SUM(d.cantidad * d.precio_venta) > 1000000
ORDER BY total DESC;

-- ------------------------------------------------------------
-- [Etapa 6] Consulta: Que clientes no han hecho pedidos?
SELECT c.id_cliente, c.primer_nombre, c.primer_apellido
FROM usr_admin_ped.cliente c
LEFT JOIN usr_admin_ped.pedido p ON p.id_cliente = c.id_cliente
WHERE p.id_pedido IS NULL;

-- ------------------------------------------------------------
-- [Etapa 6] Consulta: Cuantos pedidos hay en cada estado?
SELECT estado, COUNT(*) AS pedidos
FROM usr_admin_ped.pedido
GROUP BY estado
ORDER BY pedidos DESC, estado;

-- ------------------------------------------------------------
-- [Etapa 6] Consulta: Cual es el precio minimo, maximo y promedio del catalogo?
SELECT MIN(precio_lista) AS minimo,
       MAX(precio_lista) AS maximo,
       ROUND(AVG(precio_lista), 2) AS promedio,
       COUNT(*) AS productos
FROM usr_admin_ped.producto;

-- ------------------------------------------------------------
-- [Etapa 6] Consulta: En que lineas se vendio por debajo del precio de lista?
SELECT d.id_pedido, pr.nom_producto, pr.precio_lista, d.precio_venta
FROM usr_admin_ped.detalle_pedido d
JOIN usr_admin_ped.producto pr ON pr.id_producto = d.id_producto
WHERE d.precio_venta < pr.precio_lista
ORDER BY d.id_pedido, pr.nom_producto;

-- ------------------------------------------------------------
-- [Etapa 6] Consulta: Que pedidos se hicieron en agosto de 2026?
SELECT id_pedido, TO_CHAR(fecha_pedido, 'YYYY-MM-DD') AS fecha, estado
FROM usr_admin_ped.pedido
WHERE fecha_pedido BETWEEN DATE '2026-08-01' AND DATE '2026-08-31'
ORDER BY fecha_pedido;

-- ------------------------------------------------------------
-- [Etapa 6] Cerrar la evidencia y revisarla
PROMPT ==== FIN DEL EJERCICIO 3 ====
SPOOL OFF
