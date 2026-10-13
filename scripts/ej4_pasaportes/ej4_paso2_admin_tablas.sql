-- ============================================================
-- ej4_paso2_admin_tablas.sql
-- Ruta practica Oracle - Ejercicio 4: Personas y pasaportes vigentes
-- Paso 2 de 7. Etapa 3 (administrador): CREATE TABLE de todas las tablas, sin restricciones.
-- Usuario: USR_ADMIN_PAS  |  Servicio: localhost:1521/XEPDB1
-- Ejecutar desde SQL*Plus con:  @C:\archivosbd\ej4_paso2_admin_tablas.sql
-- Las contrasenas NO estan en el archivo: SQL*Plus las pide ocultas.
-- ============================================================
SET VERIFY OFF

CONNECT usr_admin_pas@localhost:1521/XEPDB1
SHOW USER
SPOOL C:\archivosbd\evidencia_ej4_pasaportes.txt APPEND
PROMPT Etapa 3 - USR_ADMIN_PAS crea las tablas

-- ------------------------------------------------------------
-- Crear la tabla PAIS
CREATE TABLE pais (
  cod_pais CHAR(3),
  nom_pais VARCHAR2(40 CHAR) NOT NULL
);

-- Verificacion
DESC pais

-- ------------------------------------------------------------
-- Crear la tabla PERSONA
CREATE TABLE persona (
  id_persona VARCHAR2(10 CHAR),
  nombre     VARCHAR2(15 CHAR) NOT NULL,
  apellido   VARCHAR2(20 CHAR) NOT NULL,
  fecha_nac  DATE NOT NULL
);

-- Verificacion
DESC persona

-- ------------------------------------------------------------
-- Crear la tabla PASAPORTE_VIGENTE
CREATE TABLE pasaporte_vigente (
  num_pasaporte     VARCHAR2(9 CHAR),
  id_persona        VARCHAR2(10 CHAR) NOT NULL,
  cod_pais          CHAR(3) NOT NULL,
  fecha_expedicion  DATE NOT NULL,
  fecha_vencimiento DATE NOT NULL
);

-- Verificacion
DESC pasaporte_vigente

SPOOL OFF
