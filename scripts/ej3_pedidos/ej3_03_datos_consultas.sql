-- ============================================================
-- ej3_03_datos_consultas.sql
-- Ruta practica Oracle - Ejercicio 3: Clientes y pedidos
-- 03 - Datos y consultas (usuario de consultas): INSERT, COMMIT, conteos, pruebas y consultas (etapa 6).
-- Usuario: USR_CONSULTAS_PED  |  Servicio: localhost:1521/XEPDB1
-- Ejecutar desde SQL*Plus con:  @C:\archivosbd\ej3_03_datos_consultas.sql
-- Las contrasenas NO estan en el archivo: SQL*Plus las pide ocultas.
-- ============================================================
SET VERIFY OFF

CONNECT usr_consultas_ped@localhost:1521/XEPDB1
SHOW USER
SPOOL C:\archivosbd\evidencia_ej3_pedidos.txt APPEND
PROMPT Etapa 6 - USR_CONSULTAS_PED inserta, confirma y consulta
SET LINESIZE 200
SET PAGESIZE 100

-- ------------------------------------------------------------
-- Comprobar que puede hacer USR_CONSULTAS_PED
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
-- Comprobar por que hace falta ESQUEMA.TABLA
-- ERRORES ESPERADOS (prueba intencional): ORA-00942
SELECT COUNT(*) FROM cliente;

SELECT COUNT(*) FROM usr_admin_ped.cliente;

-- ------------------------------------------------------------
-- Insertar en CLIENTE (6 filas)
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
-- Insertar en PRODUCTO (8 filas)
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
-- Insertar en PEDIDO (9 filas)
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
-- Insertar en DETALLE_PEDIDO (17 filas)
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
-- Confirmar con COMMIT y contar las filas
COMMIT;

SELECT 'CLIENTE' AS tabla, COUNT(*) AS filas FROM usr_admin_ped.cliente
UNION ALL
SELECT 'PRODUCTO' AS tabla, COUNT(*) AS filas FROM usr_admin_ped.producto
UNION ALL
SELECT 'PEDIDO' AS tabla, COUNT(*) AS filas FROM usr_admin_ped.pedido
UNION ALL
SELECT 'DETALLE_PEDIDO' AS tabla, COUNT(*) AS filas FROM usr_admin_ped.detalle_pedido;

-- ------------------------------------------------------------
-- Probar los DEFAULT y deshacer con ROLLBACK
INSERT INTO usr_admin_ped.pedido (id_pedido, id_cliente)
VALUES (5999, 6);

SELECT id_pedido, estado,
       CASE WHEN TRUNC(fecha_pedido) = TRUNC(SYSDATE) THEN 'FECHA DE HOY' ELSE 'OTRA FECHA' END AS fecha
FROM usr_admin_ped.pedido
WHERE id_pedido = 5999;

ROLLBACK;

-- ------------------------------------------------------------
-- Pruebas de integridad: errores esperados
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
-- Consulta: Cual es el total de cada pedido?
SELECT p.id_pedido, c.primer_nombre || ' ' || c.primer_apellido AS cliente, p.estado,
       SUM(d.cantidad * d.precio_venta) AS total
FROM usr_admin_ped.pedido p
JOIN usr_admin_ped.cliente c ON c.id_cliente = p.id_cliente
JOIN usr_admin_ped.detalle_pedido d ON d.id_pedido = p.id_pedido
GROUP BY p.id_pedido, c.primer_nombre, c.primer_apellido, p.estado
ORDER BY p.id_pedido;

-- ------------------------------------------------------------
-- Consulta: Cuanto ha comprado cada cliente (sin pedidos anulados)?
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
-- Consulta: Cuales son los productos mas vendidos (en unidades)?
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
-- Consulta: Que productos nunca se han vendido?
SELECT pr.id_producto, pr.nom_producto
FROM usr_admin_ped.producto pr
LEFT JOIN usr_admin_ped.detalle_pedido d ON d.id_producto = pr.id_producto
WHERE d.id_pedido IS NULL;

-- ------------------------------------------------------------
-- Consulta: Que pedidos superan 1.000.000?
SELECT d.id_pedido, SUM(d.cantidad * d.precio_venta) AS total
FROM usr_admin_ped.detalle_pedido d
GROUP BY d.id_pedido
HAVING SUM(d.cantidad * d.precio_venta) > 1000000
ORDER BY total DESC;

-- ------------------------------------------------------------
-- Consulta: Que clientes no han hecho pedidos?
SELECT c.id_cliente, c.primer_nombre, c.primer_apellido
FROM usr_admin_ped.cliente c
LEFT JOIN usr_admin_ped.pedido p ON p.id_cliente = c.id_cliente
WHERE p.id_pedido IS NULL;

-- ------------------------------------------------------------
-- Consulta: Cuantos pedidos hay en cada estado?
SELECT estado, COUNT(*) AS pedidos
FROM usr_admin_ped.pedido
GROUP BY estado
ORDER BY pedidos DESC, estado;

-- ------------------------------------------------------------
-- Consulta: Cual es el precio minimo, maximo y promedio del catalogo?
SELECT MIN(precio_lista) AS minimo,
       MAX(precio_lista) AS maximo,
       ROUND(AVG(precio_lista), 2) AS promedio,
       COUNT(*) AS productos
FROM usr_admin_ped.producto;

-- ------------------------------------------------------------
-- Consulta: En que lineas se vendio por debajo del precio de lista?
SELECT d.id_pedido, pr.nom_producto, pr.precio_lista, d.precio_venta
FROM usr_admin_ped.detalle_pedido d
JOIN usr_admin_ped.producto pr ON pr.id_producto = d.id_producto
WHERE d.precio_venta < pr.precio_lista
ORDER BY d.id_pedido, pr.nom_producto;

-- ------------------------------------------------------------
-- Consulta: Que pedidos se hicieron en agosto de 2026?
SELECT id_pedido, TO_CHAR(fecha_pedido, 'YYYY-MM-DD') AS fecha, estado
FROM usr_admin_ped.pedido
WHERE fecha_pedido BETWEEN DATE '2026-08-01' AND DATE '2026-08-31'
ORDER BY fecha_pedido;

SPOOL OFF
