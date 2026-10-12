-- ============================================================
-- ej1_00_completo.sql
-- Ruta practica Oracle - Ejercicio 1: Propietarios y vehiculos
-- Script completo: las seis etapas en orden, con cambios de usuario y evidencia SPOOL.
-- Usuario: SYSTEM -> USR_ADMIN_VEH -> SYSTEM -> USR_ADMIN_VEH -> USR_CONSULTAS_VEH  |  Servicio: localhost:1521/XEPDB1
-- Ejecutar desde SQL*Plus con:  @C:\archivosbd\ej1_00_completo.sql
-- Las contrasenas NO estan en el archivo: SQL*Plus las pide ocultas.
-- ============================================================
-- Abrir antes:  cd /d C:\archivosbd   y   sqlplus /nolog
SET VERIFY OFF

-- ------------------------------------------------------------
-- [Etapa 1] Conectarte como SYSTEM a XEPDB1
CONNECT system@localhost:1521/XEPDB1

-- ------------------------------------------------------------
-- [Etapa 1] Iniciar la evidencia con SPOOL y confirmar la sesion
SPOOL C:\archivosbd\evidencia_ej1_vehiculos.txt
PROMPT ==== EJERCICIO 1: PROPIETARIOS Y VEHICULOS ====
PROMPT Etapa 1 - SYSTEM crea el TABLESPACE y su DATAFILE
SHOW USER
SHOW CON_NAME

-- ------------------------------------------------------------
-- [Etapa 1] Crear el TABLESPACE y su DATAFILE
CREATE TABLESPACE ts_vehiculos
  DATAFILE 'C:\ORACLE_EXE\ORADATA\XE\XEPDB1\TS_VEHICULOS01.DBF'
  SIZE 20M
  AUTOEXTEND ON NEXT 5M
  MAXSIZE 100M;

-- Verificacion
COLUMN tablespace_name FORMAT A15
COLUMN file_name FORMAT A55
SELECT tablespace_name, status, contents
FROM dba_tablespaces
WHERE tablespace_name = 'TS_VEHICULOS';

SELECT file_name, bytes/1024/1024 AS mb, autoextensible
FROM dba_data_files
WHERE tablespace_name = 'TS_VEHICULOS';

-- ------------------------------------------------------------
-- [Etapa 2] Crear el usuario administrador USR_ADMIN_VEH
ACCEPT clave_admin CHAR PROMPT 'Clave para USR_ADMIN_VEH: ' HIDE
CREATE USER usr_admin_veh
  IDENTIFIED BY "&clave_admin"
  DEFAULT TABLESPACE ts_vehiculos
  TEMPORARY TABLESPACE temp
  QUOTA 20M ON ts_vehiculos;
UNDEFINE clave_admin
PROMPT Etapa 2 - SYSTEM creo el usuario administrador USR_ADMIN_VEH

-- Verificacion
COLUMN username FORMAT A18
COLUMN default_tablespace FORMAT A16
COLUMN temporary_tablespace FORMAT A10
COLUMN account_status FORMAT A14
SELECT username, default_tablespace, temporary_tablespace, account_status
FROM dba_users
WHERE username = 'USR_ADMIN_VEH';

SELECT tablespace_name, max_bytes/1024/1024 AS cuota_mb
FROM dba_ts_quotas
WHERE username = 'USR_ADMIN_VEH';

-- ------------------------------------------------------------
-- [Etapa 3] Etapa 3 (SYSTEM): privilegios del sistema para USR_ADMIN_VEH
PROMPT Etapa 3 - SYSTEM otorga privilegios a USR_ADMIN_VEH
GRANT CREATE SESSION, CREATE TABLE TO usr_admin_veh;

-- Verificacion
COLUMN grantee FORMAT A18
COLUMN privilege FORMAT A16
SELECT grantee, privilege
FROM dba_sys_privs
WHERE grantee = 'USR_ADMIN_VEH'
ORDER BY privilege;

-- ------------------------------------------------------------
-- [Etapa 3] Conectarte como USR_ADMIN_VEH
CONNECT usr_admin_veh@localhost:1521/XEPDB1
SHOW USER
PROMPT Etapa 3 - USR_ADMIN_VEH crea las tablas

-- ------------------------------------------------------------
-- [Etapa 3] Crear la tabla PROPIETARIO
CREATE TABLE propietario (
  id_propietario VARCHAR2(10 CHAR),
  nombre         VARCHAR2(15 CHAR) NOT NULL,
  apellido       VARCHAR2(20 CHAR) NOT NULL,
  telefono       VARCHAR2(10 CHAR),
  correo         VARCHAR2(100 CHAR)
);

-- Verificacion
DESC propietario

-- ------------------------------------------------------------
-- [Etapa 3] Crear la tabla MARCA
CREATE TABLE marca (
  id_marca    NUMBER(3),
  nom_marca   VARCHAR2(20 CHAR) NOT NULL,
  pais_origen VARCHAR2(20 CHAR)
);

-- Verificacion
DESC marca

-- ------------------------------------------------------------
-- [Etapa 3] Crear la tabla VEHICULO
CREATE TABLE vehiculo (
  placa    VARCHAR2(6 CHAR),
  linea    VARCHAR2(20 CHAR) NOT NULL,
  modelo   NUMBER(4) NOT NULL,
  color    VARCHAR2(15 CHAR),
  id_marca NUMBER(3) NOT NULL
);

-- Verificacion
DESC vehiculo

-- ------------------------------------------------------------
-- [Etapa 3] Crear la tabla PROP_VEH
CREATE TABLE prop_veh (
  id_propietario    VARCHAR2(10 CHAR),
  placa             VARCHAR2(6 CHAR),
  fecha_adquisicion DATE NOT NULL
);

-- Verificacion
DESC prop_veh

-- ------------------------------------------------------------
-- [Etapa 3] Agregar las PRIMARY KEY
PROMPT Etapa 3 - PRIMARY KEY
ALTER TABLE propietario
  ADD CONSTRAINT pk_propietario PRIMARY KEY (id_propietario);

ALTER TABLE marca
  ADD CONSTRAINT pk_marca PRIMARY KEY (id_marca);

ALTER TABLE vehiculo
  ADD CONSTRAINT pk_vehiculo PRIMARY KEY (placa);

ALTER TABLE prop_veh
  ADD CONSTRAINT pk_prop_veh PRIMARY KEY (id_propietario, placa);

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
ALTER TABLE vehiculo
  ADD CONSTRAINT fk_vehiculo_marca
  FOREIGN KEY (id_marca) REFERENCES marca (id_marca);

ALTER TABLE prop_veh
  ADD CONSTRAINT fk_propveh_propietario
  FOREIGN KEY (id_propietario) REFERENCES propietario (id_propietario);

ALTER TABLE prop_veh
  ADD CONSTRAINT fk_propveh_vehiculo
  FOREIGN KEY (placa) REFERENCES vehiculo (placa);

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
ALTER TABLE marca
  ADD CONSTRAINT uq_marca_nombre UNIQUE (nom_marca);

ALTER TABLE vehiculo
  ADD CONSTRAINT chk_vehiculo_modelo CHECK (modelo >= 1950);

-- Verificacion
COLUMN constraint_name FORMAT A24
COLUMN table_name FORMAT A18
COLUMN r_constraint_name FORMAT A20
SELECT constraint_name, constraint_type, table_name
FROM user_constraints
WHERE constraint_name NOT LIKE 'SYS%'
ORDER BY table_name, constraint_type, constraint_name;

-- ------------------------------------------------------------
-- [Etapa 4] Etapa 4: volver a SYSTEM
CONNECT system@localhost:1521/XEPDB1
PROMPT Etapa 4 - SYSTEM crea el usuario de consultas

-- ------------------------------------------------------------
-- [Etapa 4] Crear el usuario de consultas USR_CONSULTAS_VEH
ACCEPT clave_cons CHAR PROMPT 'Clave para USR_CONSULTAS_VEH: ' HIDE
CREATE USER usr_consultas_veh
  IDENTIFIED BY "&clave_cons"
  DEFAULT TABLESPACE ts_vehiculos
  TEMPORARY TABLESPACE temp;
UNDEFINE clave_cons
PROMPT Etapa 4 - SYSTEM creo el usuario USR_CONSULTAS_VEH

-- Verificacion
COLUMN username FORMAT A18
COLUMN default_tablespace FORMAT A16
COLUMN temporary_tablespace FORMAT A10
COLUMN account_status FORMAT A14
SELECT username, default_tablespace, temporary_tablespace, account_status
FROM dba_users
WHERE username = 'USR_CONSULTAS_VEH';

-- ------------------------------------------------------------
-- [Etapa 5] Etapa 5 (SYSTEM): privilegio del sistema CREATE SESSION
PROMPT Etapa 5 - Privilegios del usuario de consultas
GRANT CREATE SESSION TO usr_consultas_veh;

-- Verificacion
COLUMN grantee FORMAT A18
COLUMN privilege FORMAT A16
SELECT grantee, privilege
FROM dba_sys_privs
WHERE grantee = 'USR_CONSULTAS_VEH'
ORDER BY privilege;

-- ------------------------------------------------------------
-- [Etapa 5] Volver a USR_ADMIN_VEH, dueno de las tablas
CONNECT usr_admin_veh@localhost:1521/XEPDB1

-- ------------------------------------------------------------
-- [Etapa 5] Etapa 5 (USR_ADMIN_VEH): privilegios sobre objetos
GRANT SELECT, INSERT ON propietario TO usr_consultas_veh;
GRANT SELECT, INSERT ON marca TO usr_consultas_veh;
GRANT SELECT, INSERT ON vehiculo TO usr_consultas_veh;
GRANT SELECT, INSERT ON prop_veh TO usr_consultas_veh;

-- Verificacion
COLUMN grantee FORMAT A18
COLUMN table_name FORMAT A18
COLUMN privilege FORMAT A10
SELECT grantee, table_name, privilege
FROM user_tab_privs_made
WHERE grantee = 'USR_CONSULTAS_VEH'
ORDER BY table_name, privilege;

-- ------------------------------------------------------------
-- [Etapa 6] Etapa 6: conectarte como USR_CONSULTAS_VEH y preparar la pantalla
CONNECT usr_consultas_veh@localhost:1521/XEPDB1
SHOW USER
PROMPT Etapa 6 - USR_CONSULTAS_VEH inserta, confirma y consulta
SET LINESIZE 200
SET PAGESIZE 100

-- ------------------------------------------------------------
-- [Etapa 6] Comprobar por que hace falta ESQUEMA.TABLA
-- ERRORES ESPERADOS (prueba intencional): ORA-00942
SELECT COUNT(*) FROM marca;

SELECT COUNT(*) FROM usr_admin_veh.marca;

-- ------------------------------------------------------------
-- [Etapa 6] Insertar en MARCA (6 filas)
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
-- [Etapa 6] Insertar en PROPIETARIO (8 filas)
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
-- [Etapa 6] Insertar en VEHICULO (10 filas)
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
-- [Etapa 6] Insertar en PROP_VEH (12 filas)
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
-- [Etapa 6] Confirmar con COMMIT y contar las filas
COMMIT;

SELECT 'MARCA' AS tabla, COUNT(*) AS filas FROM usr_admin_veh.marca
UNION ALL
SELECT 'PROPIETARIO' AS tabla, COUNT(*) AS filas FROM usr_admin_veh.propietario
UNION ALL
SELECT 'VEHICULO' AS tabla, COUNT(*) AS filas FROM usr_admin_veh.vehiculo
UNION ALL
SELECT 'PROP_VEH' AS tabla, COUNT(*) AS filas FROM usr_admin_veh.prop_veh;

-- ------------------------------------------------------------
-- [Etapa 6] Pruebas de integridad: errores esperados
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
-- [Etapa 6] Consulta: Que propietarios estan registrados?
SELECT id_propietario, nombre, apellido, telefono
FROM usr_admin_veh.propietario
ORDER BY apellido, nombre;

-- ------------------------------------------------------------
-- [Etapa 6] Consulta: Que vehiculos tiene (o ha tenido) cada propietario?
SELECT p.nombre, p.apellido, v.placa, m.nom_marca, v.linea,
       TO_CHAR(pv.fecha_adquisicion, 'YYYY-MM-DD') AS fecha_adq
FROM usr_admin_veh.propietario p
JOIN usr_admin_veh.prop_veh pv ON pv.id_propietario = p.id_propietario
JOIN usr_admin_veh.vehiculo v ON v.placa = pv.placa
JOIN usr_admin_veh.marca m ON m.id_marca = v.id_marca
ORDER BY p.apellido, pv.fecha_adquisicion;

-- ------------------------------------------------------------
-- [Etapa 6] Consulta: Que marcas estan registradas?
SELECT id_marca, nom_marca, pais_origen
FROM usr_admin_veh.marca
ORDER BY nom_marca;

-- ------------------------------------------------------------
-- [Etapa 6] Consulta: Cuantos vehiculos hay por marca?
SELECT m.nom_marca, COUNT(v.placa) AS cantidad
FROM usr_admin_veh.marca m
LEFT JOIN usr_admin_veh.vehiculo v ON v.id_marca = m.id_marca
GROUP BY m.nom_marca
ORDER BY cantidad DESC, m.nom_marca;

-- ------------------------------------------------------------
-- [Etapa 6] Consulta: Que propietarios estan relacionados con mas de un vehiculo?
SELECT p.id_propietario, p.nombre, p.apellido,
       COUNT(DISTINCT pv.placa) AS vehiculos
FROM usr_admin_veh.propietario p
JOIN usr_admin_veh.prop_veh pv ON pv.id_propietario = p.id_propietario
GROUP BY p.id_propietario, p.nombre, p.apellido
HAVING COUNT(DISTINCT pv.placa) > 1
ORDER BY vehiculos DESC, p.apellido;

-- ------------------------------------------------------------
-- [Etapa 6] Consulta: Que propietarios no tienen ningun vehiculo?
SELECT p.id_propietario, p.nombre, p.apellido
FROM usr_admin_veh.propietario p
LEFT JOIN usr_admin_veh.prop_veh pv ON pv.id_propietario = p.id_propietario
WHERE pv.placa IS NULL;

-- ------------------------------------------------------------
-- [Etapa 6] Consulta: Quienes han sido propietarios del vehiculo ABC123?
SELECT pv.placa, p.nombre, p.apellido,
       TO_CHAR(pv.fecha_adquisicion, 'YYYY-MM-DD') AS fecha_adq
FROM usr_admin_veh.prop_veh pv
JOIN usr_admin_veh.propietario p ON p.id_propietario = pv.id_propietario
WHERE pv.placa = 'ABC123'
ORDER BY pv.fecha_adquisicion;

-- ------------------------------------------------------------
-- [Etapa 6] Consulta: Por que no se cuentan los vehiculos pasando por PROP_VEH?
SELECT m.nom_marca,
       COUNT(*) AS filas_join,
       COUNT(DISTINCT v.placa) AS vehiculos
FROM usr_admin_veh.marca m
JOIN usr_admin_veh.vehiculo v ON v.id_marca = m.id_marca
JOIN usr_admin_veh.prop_veh pv ON pv.placa = v.placa
GROUP BY m.nom_marca
ORDER BY m.nom_marca;

-- ------------------------------------------------------------
-- [Etapa 6] Consulta: Que vehiculos son modelo 2018 a 2022?
SELECT placa, linea, modelo
FROM usr_admin_veh.vehiculo
WHERE modelo BETWEEN 2018 AND 2022
ORDER BY modelo, placa;

-- ------------------------------------------------------------
-- [Etapa 6] Consulta: Que propietarios no registraron correo?
SELECT nombre, apellido
FROM usr_admin_veh.propietario
WHERE correo IS NULL
ORDER BY apellido;

-- ------------------------------------------------------------
-- [Etapa 6] Consulta: Que colores distintos hay?
SELECT DISTINCT color
FROM usr_admin_veh.vehiculo
ORDER BY color;

-- ------------------------------------------------------------
-- [Etapa 6] Consulta: Que vehiculos son de marcas japonesas o coreanas?
SELECT v.placa, v.linea, m.nom_marca, m.pais_origen
FROM usr_admin_veh.vehiculo v
JOIN usr_admin_veh.marca m ON m.id_marca = v.id_marca
WHERE m.pais_origen IN ('Japon', 'Corea del Sur')
ORDER BY m.nom_marca, v.placa;

-- ------------------------------------------------------------
-- [Etapa 6] Cerrar la evidencia y revisarla
PROMPT ==== FIN DEL EJERCICIO 1 ====
SPOOL OFF
