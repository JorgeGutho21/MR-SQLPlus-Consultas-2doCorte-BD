-- ============================================================
-- ej4_04_system_usuario_consultas.sql
-- Ruta practica Oracle - Ejercicio 4: Personas y pasaportes vigentes
-- Etapas 4 y 5 (SYSTEM): usuario de consultas y CREATE SESSION.
-- Usuario: SYSTEM  |  Servicio: localhost:1521/XEPDB1
-- Ejecutar desde SQL*Plus con:  @C:\archivosbd\ej4_04_system_usuario_consultas.sql
-- Las contrasenas NO estan en el archivo: SQL*Plus las pide ocultas.
-- ============================================================
SET VERIFY OFF

CONNECT system@localhost:1521/XEPDB1
SHOW USER
SPOOL C:\archivosbd\evidencia_ej4_pasaportes.txt APPEND

-- ------------------------------------------------------------
-- Crear el usuario de consultas USR_CONSULTAS_PAS
ACCEPT clave_cons CHAR PROMPT 'Clave para USR_CONSULTAS_PAS: ' HIDE
CREATE USER usr_consultas_pas
  IDENTIFIED BY "&clave_cons"
  DEFAULT TABLESPACE ts_pasaportes
  TEMPORARY TABLESPACE temp;
UNDEFINE clave_cons
PROMPT Etapa 4 - SYSTEM creo el usuario USR_CONSULTAS_PAS

-- Verificacion
COLUMN username FORMAT A18
COLUMN default_tablespace FORMAT A16
COLUMN temporary_tablespace FORMAT A10
COLUMN account_status FORMAT A14
SELECT username, default_tablespace, temporary_tablespace, account_status
FROM dba_users
WHERE username = 'USR_CONSULTAS_PAS';

-- ------------------------------------------------------------
-- Etapa 5 (SYSTEM): privilegio del sistema CREATE SESSION
PROMPT Etapa 5 - Privilegios del usuario de consultas
GRANT CREATE SESSION TO usr_consultas_pas;

-- Verificacion
COLUMN grantee FORMAT A18
COLUMN privilege FORMAT A16
SELECT grantee, privilege
FROM dba_sys_privs
WHERE grantee = 'USR_CONSULTAS_PAS'
ORDER BY privilege;

SPOOL OFF
