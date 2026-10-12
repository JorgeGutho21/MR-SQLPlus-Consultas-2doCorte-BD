-- ============================================================
-- ej1_06_consultas_datos.sql
-- Ruta practica Oracle - Ejercicio 1: Propietarios y vehiculos
-- Etapa 6 (consultas): INSERT con ESQUEMA.TABLA, COMMIT, conteos y pruebas de integridad.
-- Usuario: USR_CONSULTAS_VEH  |  Servicio: localhost:1521/XEPDB1
-- Ejecutar desde SQL*Plus con:  @C:\archivosbd\ej1_06_consultas_datos.sql
-- Las contrasenas NO estan en el archivo: SQL*Plus las pide ocultas.
-- ============================================================
SET VERIFY OFF

CONNECT usr_consultas_veh@localhost:1521/XEPDB1
SHOW USER
SPOOL C:\archivosbd\evidencia_ej1_vehiculos.txt APPEND
SET LINESIZE 200
SET PAGESIZE 100

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

SPOOL OFF
