-- ============================================================
-- ej2_paso2_admin_tablas.sql
-- Ruta practica Oracle - Ejercicio 2: Sistema universitario
-- Paso 2 de 7. Etapa 3 (administrador): CREATE TABLE de todas las tablas, sin restricciones.
-- Usuario: USR_ADMIN_UNI  |  Servicio: localhost:1521/XEPDB1
-- Ejecutar desde SQL*Plus con:  @C:\archivosbd\ej2_paso2_admin_tablas.sql
-- Las contrasenas NO estan en el archivo: SQL*Plus las pide ocultas.
-- ============================================================
SET VERIFY OFF

CONNECT usr_admin_uni@localhost:1521/XEPDB1
SHOW USER
SPOOL C:\archivosbd\evidencia_ej2_universidad.txt APPEND
PROMPT Etapa 3 - USR_ADMIN_UNI crea las tablas

-- ------------------------------------------------------------
-- Crear la tabla FACULTAD
CREATE TABLE facultad (
  cod_fac      VARCHAR2(3 CHAR),
  nom_facultad VARCHAR2(30 CHAR) NOT NULL
);

-- Verificacion
DESC facultad

-- ------------------------------------------------------------
-- Crear la tabla CARRERA
CREATE TABLE carrera (
  cod_carrera VARCHAR2(3 CHAR),
  nom_carrera VARCHAR2(30 CHAR) NOT NULL,
  cod_fac     VARCHAR2(3 CHAR) NOT NULL
);

-- Verificacion
DESC carrera

-- ------------------------------------------------------------
-- Crear la tabla BARRIOS
CREATE TABLE barrios (
  id_barrio  NUMBER(3),
  nom_barrio VARCHAR2(30 CHAR) NOT NULL
);

-- Verificacion
DESC barrios

-- ------------------------------------------------------------
-- Crear la tabla ALUMNOS
CREATE TABLE alumnos (
  ced_alumno  VARCHAR2(10 CHAR),
  nombre      VARCHAR2(15 CHAR) NOT NULL,
  apellido    VARCHAR2(20 CHAR) NOT NULL,
  genero      CHAR(1) NOT NULL,
  promedio    NUMBER(2,1),
  cod_carrera VARCHAR2(3 CHAR) NOT NULL,
  id_barrio   NUMBER(3)
);

-- Verificacion
DESC alumnos

SPOOL OFF
