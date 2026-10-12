-- ============================================================
-- ej1_02_admin_tablas.sql
-- Ruta practica Oracle - Ejercicio 1: Propietarios y vehiculos
-- Etapa 3 (administrador): CREATE TABLE de todas las tablas, sin restricciones.
-- Usuario: USR_ADMIN_VEH  |  Servicio: localhost:1521/XEPDB1
-- Ejecutar desde SQL*Plus con:  @C:\archivosbd\ej1_02_admin_tablas.sql
-- Las contrasenas NO estan en el archivo: SQL*Plus las pide ocultas.
-- ============================================================
SET VERIFY OFF

CONNECT usr_admin_veh@localhost:1521/XEPDB1
SHOW USER
SPOOL C:\archivosbd\evidencia_ej1_vehiculos.txt APPEND

-- ------------------------------------------------------------
-- Crear la tabla PROPIETARIO
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
-- Crear la tabla MARCA
CREATE TABLE marca (
  id_marca    NUMBER(3),
  nom_marca   VARCHAR2(20 CHAR) NOT NULL,
  pais_origen VARCHAR2(20 CHAR)
);

-- Verificacion
DESC marca

-- ------------------------------------------------------------
-- Crear la tabla VEHICULO
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
-- Crear la tabla PROP_VEH
CREATE TABLE prop_veh (
  id_propietario    VARCHAR2(10 CHAR),
  placa             VARCHAR2(6 CHAR),
  fecha_adquisicion DATE NOT NULL
);

-- Verificacion
DESC prop_veh

SPOOL OFF
