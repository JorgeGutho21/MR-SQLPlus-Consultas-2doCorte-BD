-- ============================================================
-- ej1_03_datos_consultas.sql
-- Ruta practica Oracle - Ejercicio 1: Propietarios y vehiculos
-- 03 - Datos y consultas (usuario de consultas): INSERT, COMMIT, conteos, pruebas y consultas (etapa 6).
-- Usuario: USR_CONSULTAS_VEH  |  Servicio: localhost:1521/XEPDB1
-- Ejecutar desde SQL*Plus con:  @C:\archivosbd\ej1_03_datos_consultas.sql
-- Las contrasenas NO estan en el archivo: SQL*Plus las pide ocultas.
-- ============================================================
SET VERIFY OFF

CONNECT usr_consultas_veh@localhost:1521/XEPDB1
SHOW USER
SPOOL C:\archivosbd\evidencia_ej1_vehiculos.txt APPEND
PROMPT Etapa 6 - USR_CONSULTAS_VEH inserta, confirma y consulta
SET LINESIZE 200
SET PAGESIZE 100

-- ------------------------------------------------------------
-- Comprobar que puede hacer USR_CONSULTAS_VEH
COLUMN privilege FORMAT A16
SELECT privilege FROM session_privs;

COLUMN owner FORMAT A16
COLUMN table_name FORMAT A18
COLUMN privilege FORMAT A10
SELECT owner, table_name, privilege
FROM user_tab_privs_recd
WHERE owner = 'USR_ADMIN_VEH'
ORDER BY table_name, privilege;

-- ------------------------------------------------------------
-- Comprobar por que hace falta ESQUEMA.TABLA
-- ERRORES ESPERADOS (prueba intencional): ORA-00942
SELECT COUNT(*) FROM marca;

SELECT COUNT(*) FROM usr_admin_veh.marca;

-- ------------------------------------------------------------
-- Insertar en MARCA (6 filas)
INSERT INTO usr_admin_veh.marca (id_marca, nom_marca, pais_origen)
VALUES (1, 'Chevrolet', 'Estados Unidos');
INSERT INTO usr_admin_veh.marca (id_marca, nom_marca, pais_origen)
VALUES (2, 'Renault', 'Francia');
INSERT INTO usr_admin_veh.marca (id_marca, nom_marca, pais_origen)
VALUES (3, 'Mazda', 'Japon');
INSERT INTO usr_admin_veh.marca (id_marca, nom_marca, pais_origen)
VALUES (4, 'Toyota', 'Japon');
INSERT INTO usr_admin_veh.marca (id_marca, nom_marca, pais_origen)
VALUES (5, 'Kia', 'Corea del Sur');
INSERT INTO usr_admin_veh.marca (id_marca, nom_marca, pais_origen)
VALUES (6, 'Volkswagen', 'Alemania');

-- ------------------------------------------------------------
-- Insertar en PROPIETARIO (8 filas)
INSERT INTO usr_admin_veh.propietario (id_propietario, nombre, apellido, telefono, correo)
VALUES ('1001234567', 'Carlos', 'Restrepo', '3001112233', 'carlos.restrepo@correo.com');
INSERT INTO usr_admin_veh.propietario (id_propietario, nombre, apellido, telefono, correo)
VALUES ('1002345678', 'Laura', 'Gomez', '3012223344', NULL);
INSERT INTO usr_admin_veh.propietario (id_propietario, nombre, apellido, telefono, correo)
VALUES ('1003456789', 'Andres', 'Ramirez', '3023334455', 'andres.ramirez@correo.com');
INSERT INTO usr_admin_veh.propietario (id_propietario, nombre, apellido, telefono, correo)
VALUES ('1004567890', 'Natalia', 'Herrera', '3034445566', 'natalia.herrera@correo.com');
INSERT INTO usr_admin_veh.propietario (id_propietario, nombre, apellido, telefono, correo)
VALUES ('1005678901', 'Julian', 'Moreno', '3045556677', NULL);
INSERT INTO usr_admin_veh.propietario (id_propietario, nombre, apellido, telefono, correo)
VALUES ('1006789012', 'Paola', 'Castro', '3056667788', 'paola.castro@correo.com');
INSERT INTO usr_admin_veh.propietario (id_propietario, nombre, apellido, telefono, correo)
VALUES ('1007890123', 'Felipe', 'Rojas', NULL, 'felipe.rojas@correo.com');
INSERT INTO usr_admin_veh.propietario (id_propietario, nombre, apellido, telefono, correo)
VALUES ('1008901234', 'Diana', 'Vargas', '3078889900', NULL);

-- ------------------------------------------------------------
-- Insertar en VEHICULO (10 filas)
INSERT INTO usr_admin_veh.vehiculo (placa, linea, modelo, color, id_marca)
VALUES ('ABC123', 'Spark', 2015, 'Rojo', 1);
INSERT INTO usr_admin_veh.vehiculo (placa, linea, modelo, color, id_marca)
VALUES ('BCD234', 'Onix', 2021, 'Gris', 1);
INSERT INTO usr_admin_veh.vehiculo (placa, linea, modelo, color, id_marca)
VALUES ('CDE345', 'Tracker', 2022, 'Azul', 1);
INSERT INTO usr_admin_veh.vehiculo (placa, linea, modelo, color, id_marca)
VALUES ('DEF456', 'Logan', 2018, 'Blanco', 2);
INSERT INTO usr_admin_veh.vehiculo (placa, linea, modelo, color, id_marca)
VALUES ('EFG567', 'Duster', 2022, 'Negro', 2);
INSERT INTO usr_admin_veh.vehiculo (placa, linea, modelo, color, id_marca)
VALUES ('FGH678', 'Mazda 3', 2020, 'Azul', 3);
INSERT INTO usr_admin_veh.vehiculo (placa, linea, modelo, color, id_marca)
VALUES ('GHI789', 'CX-5', 2023, 'Blanco', 3);
INSERT INTO usr_admin_veh.vehiculo (placa, linea, modelo, color, id_marca)
VALUES ('HIJ890', 'Corolla', 2019, 'Plata', 4);
INSERT INTO usr_admin_veh.vehiculo (placa, linea, modelo, color, id_marca)
VALUES ('IJK901', 'Hilux', 2016, 'Blanco', 4);
INSERT INTO usr_admin_veh.vehiculo (placa, linea, modelo, color, id_marca)
VALUES ('JKL012', 'Picanto', 2017, 'Rojo', 5);

-- ------------------------------------------------------------
-- Insertar en PROP_VEH (12 filas)
INSERT INTO usr_admin_veh.prop_veh (id_propietario, placa, fecha_adquisicion)
VALUES ('1001234567', 'ABC123', DATE '2016-03-10');
INSERT INTO usr_admin_veh.prop_veh (id_propietario, placa, fecha_adquisicion)
VALUES ('1001234567', 'DEF456', DATE '2019-07-22');
INSERT INTO usr_admin_veh.prop_veh (id_propietario, placa, fecha_adquisicion)
VALUES ('1002345678', 'BCD234', DATE '2021-05-14');
INSERT INTO usr_admin_veh.prop_veh (id_propietario, placa, fecha_adquisicion)
VALUES ('1003456789', 'EFG567', DATE '2022-09-01');
INSERT INTO usr_admin_veh.prop_veh (id_propietario, placa, fecha_adquisicion)
VALUES ('1003456789', 'FGH678', DATE '2020-11-30');
INSERT INTO usr_admin_veh.prop_veh (id_propietario, placa, fecha_adquisicion)
VALUES ('1003456789', 'JKL012', DATE '2023-02-17');
INSERT INTO usr_admin_veh.prop_veh (id_propietario, placa, fecha_adquisicion)
VALUES ('1004567890', 'GHI789', DATE '2023-06-05');
INSERT INTO usr_admin_veh.prop_veh (id_propietario, placa, fecha_adquisicion)
VALUES ('1004567890', 'ABC123', DATE '2020-10-03');
INSERT INTO usr_admin_veh.prop_veh (id_propietario, placa, fecha_adquisicion)
VALUES ('1005678901', 'HIJ890', DATE '2019-12-12');
INSERT INTO usr_admin_veh.prop_veh (id_propietario, placa, fecha_adquisicion)
VALUES ('1006789012', 'IJK901', DATE '2016-08-19');
INSERT INTO usr_admin_veh.prop_veh (id_propietario, placa, fecha_adquisicion)
VALUES ('1006789012', 'JKL012', DATE '2017-01-25');
INSERT INTO usr_admin_veh.prop_veh (id_propietario, placa, fecha_adquisicion)
VALUES ('1007890123', 'CDE345', DATE '2022-04-08');

-- ------------------------------------------------------------
-- Confirmar con COMMIT y contar las filas
COMMIT;

SELECT 'MARCA' AS tabla, COUNT(*) AS filas FROM usr_admin_veh.marca
UNION ALL
SELECT 'PROPIETARIO' AS tabla, COUNT(*) AS filas FROM usr_admin_veh.propietario
UNION ALL
SELECT 'VEHICULO' AS tabla, COUNT(*) AS filas FROM usr_admin_veh.vehiculo
UNION ALL
SELECT 'PROP_VEH' AS tabla, COUNT(*) AS filas FROM usr_admin_veh.prop_veh;

-- ------------------------------------------------------------
-- Pruebas de integridad: errores esperados
-- ERRORES ESPERADOS (prueba intencional): ORA-02291, ORA-02290, ORA-00001, ORA-01031
PROMPT Pruebas intencionales: cada sentencia debe fallar
INSERT INTO usr_admin_veh.prop_veh (id_propietario, placa, fecha_adquisicion)
VALUES ('1002345678', 'ZZZ999', DATE '2024-01-15');

INSERT INTO usr_admin_veh.vehiculo (placa, linea, modelo, color, id_marca)
VALUES ('XYZ987', 'Renault 4', 1940, 'Blanco', 2);

INSERT INTO usr_admin_veh.marca (id_marca, nom_marca, pais_origen)
VALUES (7, 'Mazda', 'Japon');

DELETE FROM usr_admin_veh.marca
WHERE id_marca = 6;

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
