-- ============================================================
-- ej3_paso7_consultas_select.sql
-- Ruta practica Oracle - Ejercicio 3: Clientes y pedidos
-- Paso 7 de 7. Etapa 6 (consultas): todas las consultas del ejercicio.
-- Usuario: USR_CONSULTAS_PED  |  Servicio: localhost:1521/XEPDB1
-- Ejecutar desde SQL*Plus con:  @C:\archivosbd\ej3_paso7_consultas_select.sql
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
-- Consulta: Cual es el total de cada pedido?
SELECT p.id_pedido, c.nombre || ' ' || c.apellido AS cliente, p.estado,
       SUM(d.cantidad * d.precio_venta) AS total
FROM usr_admin_ped.pedido p
JOIN usr_admin_ped.cliente c ON c.id_cliente = p.id_cliente
JOIN usr_admin_ped.detalle_pedido d ON d.id_pedido = p.id_pedido
GROUP BY p.id_pedido, c.nombre, c.apellido, p.estado
ORDER BY p.id_pedido;

-- ------------------------------------------------------------
-- Consulta: Cuanto ha comprado cada cliente (sin pedidos anulados)?
SELECT c.nombre, c.apellido,
       COUNT(DISTINCT p.id_pedido) AS pedidos,
       SUM(d.cantidad * d.precio_venta) AS total_comprado
FROM usr_admin_ped.cliente c
JOIN usr_admin_ped.pedido p ON p.id_cliente = c.id_cliente
JOIN usr_admin_ped.detalle_pedido d ON d.id_pedido = p.id_pedido
WHERE p.estado <> 'ANULADO'
GROUP BY c.nombre, c.apellido
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
SELECT c.id_cliente, c.nombre, c.apellido
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
