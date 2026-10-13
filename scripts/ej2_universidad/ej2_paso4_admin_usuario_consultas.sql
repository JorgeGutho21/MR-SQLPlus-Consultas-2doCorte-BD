-- ============================================================
-- ej2_paso4_admin_usuario_consultas.sql
-- Ruta practica Oracle - Ejercicio 2: Sistema universitario
-- Paso 4 de 7. Etapa 4 (administrador): CREATE USER del usuario de consultas.
-- Usuario: USR_ADMIN_UNI  |  Servicio: localhost:1521/XEPDB1
-- Ejecutar desde SQL*Plus con:  @C:\archivosbd\ej2_paso4_admin_usuario_consultas.sql
-- Las contrasenas NO estan en el archivo: SQL*Plus las pide ocultas.
-- ============================================================
SET VERIFY OFF

CONNECT usr_admin_uni@localhost:1521/XEPDB1
SHOW USER
SPOOL C:\archivosbd\evidencia_ej2_universidad.txt APPEND

-- ------------------------------------------------------------
-- Etapa 4 (USR_ADMIN_UNI): crear el usuario de consultas USR_CONSULTAS_UNI
PROMPT Etapa 4 - USR_ADMIN_UNI crea el usuario de consultas
SPOOL OFF
ACCEPT clave_cons CHAR PROMPT 'Clave para USR_CONSULTAS_UNI: ' HIDE
CREATE USER usr_consultas_uni
  IDENTIFIED BY "&clave_cons"
  DEFAULT TABLESPACE ts_universidad
  TEMPORARY TABLESPACE temp;
UNDEFINE clave_cons
SPOOL C:\archivosbd\evidencia_ej2_universidad.txt APPEND
PROMPT Etapa 4 - USR_ADMIN_UNI creo el usuario USR_CONSULTAS_UNI

-- Verificacion
COLUMN username FORMAT A18
SELECT username, created
FROM all_users
WHERE username = 'USR_CONSULTAS_UNI';

SPOOL OFF
