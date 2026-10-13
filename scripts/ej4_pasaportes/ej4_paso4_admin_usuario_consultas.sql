-- ============================================================
-- ej4_paso4_admin_usuario_consultas.sql
-- Ruta practica Oracle - Ejercicio 4: Personas y pasaportes vigentes
-- Paso 4 de 7. Etapa 4 (administrador): CREATE USER del usuario de consultas.
-- Usuario: USR_ADMIN_PAS  |  Servicio: localhost:1521/XEPDB1
-- Ejecutar desde SQL*Plus con:  @C:\archivosbd\ej4_paso4_admin_usuario_consultas.sql
-- Las contrasenas NO estan en el archivo: SQL*Plus las pide ocultas.
-- ============================================================
SET VERIFY OFF

CONNECT usr_admin_pas@localhost:1521/XEPDB1
SHOW USER
SPOOL C:\archivosbd\evidencia_ej4_pasaportes.txt APPEND

-- ------------------------------------------------------------
-- Etapa 4 (USR_ADMIN_PAS): crear el usuario de consultas USR_CONSULTAS_PAS
PROMPT Etapa 4 - USR_ADMIN_PAS crea el usuario de consultas
SPOOL OFF
ACCEPT clave_cons CHAR PROMPT 'Clave para USR_CONSULTAS_PAS: ' HIDE
CREATE USER usr_consultas_pas
  IDENTIFIED BY "&clave_cons"
  DEFAULT TABLESPACE ts_pasaportes
  TEMPORARY TABLESPACE temp;
UNDEFINE clave_cons
SPOOL C:\archivosbd\evidencia_ej4_pasaportes.txt APPEND
PROMPT Etapa 4 - USR_ADMIN_PAS creo el usuario USR_CONSULTAS_PAS

-- Verificacion
COLUMN username FORMAT A18
SELECT username, created
FROM all_users
WHERE username = 'USR_CONSULTAS_PAS';

SPOOL OFF
