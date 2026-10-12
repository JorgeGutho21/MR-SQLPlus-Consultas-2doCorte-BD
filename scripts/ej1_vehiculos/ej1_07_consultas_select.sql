-- ============================================================
-- ej1_07_consultas_select.sql
-- Ruta practica Oracle - Ejercicio 1: Propietarios y vehiculos
-- Etapa 6 (consultas): todas las consultas del ejercicio.
-- Usuario: USR_CONSULTAS_VEH  |  Servicio: localhost:1521/XEPDB1
-- Ejecutar desde SQL*Plus con:  @C:\archivosbd\ej1_07_consultas_select.sql
-- Las contrasenas NO estan en el archivo: SQL*Plus las pide ocultas.
-- ============================================================
SET VERIFY OFF

CONNECT usr_consultas_veh@localhost:1521/XEPDB1
SHOW USER
SPOOL C:\archivosbd\evidencia_ej1_vehiculos.txt APPEND
SET LINESIZE 200
SET PAGESIZE 100

-- ------------------------------------------------------------
-- Consulta: Que propietarios estan registrados?
SELECT id_propietario, nombre, apellido, telefono
FROM usr_admin_veh.propietario
ORDER BY apellido, nombre;

-- ------------------------------------------------------------
-- Consulta: Que vehiculos tiene (o ha tenido) cada propietario?
SELECT p.nombre, p.apellido, v.placa, m.nom_marca, v.linea,
       TO_CHAR(pv.fecha_adquisicion, 'YYYY-MM-DD') AS fecha_adq
FROM usr_admin_veh.propietario p
JOIN usr_admin_veh.prop_veh pv ON pv.id_propietario = p.id_propietario
JOIN usr_admin_veh.vehiculo v ON v.placa = pv.placa
JOIN usr_admin_veh.marca m ON m.id_marca = v.id_marca
ORDER BY p.apellido, pv.fecha_adquisicion;

-- ------------------------------------------------------------
-- Consulta: Que marcas estan registradas?
SELECT id_marca, nom_marca, pais_origen
FROM usr_admin_veh.marca
ORDER BY nom_marca;

-- ------------------------------------------------------------
-- Consulta: Cuantos vehiculos hay por marca?
SELECT m.nom_marca, COUNT(v.placa) AS cantidad
FROM usr_admin_veh.marca m
LEFT JOIN usr_admin_veh.vehiculo v ON v.id_marca = m.id_marca
GROUP BY m.nom_marca
ORDER BY cantidad DESC, m.nom_marca;

-- ------------------------------------------------------------
-- Consulta: Que propietarios estan relacionados con mas de un vehiculo?
SELECT p.id_propietario, p.nombre, p.apellido,
       COUNT(DISTINCT pv.placa) AS vehiculos
FROM usr_admin_veh.propietario p
JOIN usr_admin_veh.prop_veh pv ON pv.id_propietario = p.id_propietario
GROUP BY p.id_propietario, p.nombre, p.apellido
HAVING COUNT(DISTINCT pv.placa) > 1
ORDER BY vehiculos DESC, p.apellido;

-- ------------------------------------------------------------
-- Consulta: Que propietarios no tienen ningun vehiculo?
SELECT p.id_propietario, p.nombre, p.apellido
FROM usr_admin_veh.propietario p
LEFT JOIN usr_admin_veh.prop_veh pv ON pv.id_propietario = p.id_propietario
WHERE pv.placa IS NULL;

-- ------------------------------------------------------------
-- Consulta: Quienes han sido propietarios del vehiculo ABC123?
SELECT pv.placa, p.nombre, p.apellido,
       TO_CHAR(pv.fecha_adquisicion, 'YYYY-MM-DD') AS fecha_adq
FROM usr_admin_veh.prop_veh pv
JOIN usr_admin_veh.propietario p ON p.id_propietario = pv.id_propietario
WHERE pv.placa = 'ABC123'
ORDER BY pv.fecha_adquisicion;

-- ------------------------------------------------------------
-- Consulta: Por que no se cuentan los vehiculos pasando por PROP_VEH?
SELECT m.nom_marca,
       COUNT(*) AS filas_join,
       COUNT(DISTINCT v.placa) AS vehiculos
FROM usr_admin_veh.marca m
JOIN usr_admin_veh.vehiculo v ON v.id_marca = m.id_marca
JOIN usr_admin_veh.prop_veh pv ON pv.placa = v.placa
GROUP BY m.nom_marca
ORDER BY m.nom_marca;

-- ------------------------------------------------------------
-- Consulta: Que vehiculos son modelo 2018 a 2022?
SELECT placa, linea, modelo
FROM usr_admin_veh.vehiculo
WHERE modelo BETWEEN 2018 AND 2022
ORDER BY modelo, placa;

-- ------------------------------------------------------------
-- Consulta: Que propietarios no registraron correo?
SELECT nombre, apellido
FROM usr_admin_veh.propietario
WHERE correo IS NULL
ORDER BY apellido;

-- ------------------------------------------------------------
-- Consulta: Que colores distintos hay?
SELECT DISTINCT color
FROM usr_admin_veh.vehiculo
ORDER BY color;

-- ------------------------------------------------------------
-- Consulta: Que vehiculos son de marcas japonesas o coreanas?
SELECT v.placa, v.linea, m.nom_marca, m.pais_origen
FROM usr_admin_veh.vehiculo v
JOIN usr_admin_veh.marca m ON m.id_marca = v.id_marca
WHERE m.pais_origen IN ('Japon', 'Corea del Sur')
ORDER BY m.nom_marca, v.placa;

SPOOL OFF
