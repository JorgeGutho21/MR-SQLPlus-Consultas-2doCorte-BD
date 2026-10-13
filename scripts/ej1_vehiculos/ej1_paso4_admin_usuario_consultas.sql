-- ============================================================
-- ej1_paso4_admin_usuario_consultas.sql
-- Ruta practica Oracle - Ejercicio 1: Propietarios y vehiculos
-- Paso 4 de 7. Etapa 4 (administrador): CREATE USER del usuario de consultas.
-- Usuario: USR_ADMIN_VEH  |  Servicio: localhost:1521/XEPDB1
-- Ejecutar desde SQL*Plus con:  @C:\archivosbd\ej1_paso4_admin_usuario_consultas.sql
-- Las contrasenas NO estan en el archivo: SQL*Plus las pide ocultas.
-- ============================================================
SET VERIFY OFF

CONNECT usr_admin_veh@localhost:1521/XEPDB1
SHOW USER
SPOOL C:\archivosbd\evidencia_ej1_vehiculos.txt APPEND

-- ------------------------------------------------------------
-- Etapa 4 (USR_ADMIN_VEH): crear el usuario de consultas USR_CONSULTAS_VEH
PROMPT Etapa 4 - USR_ADMIN_VEH crea el usuario de consultas
SPOOL OFF
ACCEPT clave_cons CHAR PROMPT 'Clave para USR_CONSULTAS_VEH: ' HIDE
CREATE USER usr_consultas_veh
  IDENTIFIED BY "&clave_cons"
  DEFAULT TABLESPACE ts_vehiculos
  TEMPORARY TABLESPACE temp;
UNDEFINE clave_cons
SPOOL C:\archivosbd\evidencia_ej1_vehiculos.txt APPEND
PROMPT Etapa 4 - USR_ADMIN_VEH creo el usuario USR_CONSULTAS_VEH

-- Verificacion
COLUMN username FORMAT A18
SELECT username, created
FROM all_users
WHERE username = 'USR_CONSULTAS_VEH';

SPOOL OFF
