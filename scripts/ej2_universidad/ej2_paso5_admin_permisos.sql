-- ============================================================
-- ej2_paso5_admin_permisos.sql
-- Ruta practica Oracle - Ejercicio 2: Sistema universitario
-- Paso 5 de 7. Etapa 5 (administrador): GRANT CREATE SESSION y GRANT SELECT, INSERT sobre cada tabla.
-- Usuario: USR_ADMIN_UNI  |  Servicio: localhost:1521/XEPDB1
-- Ejecutar desde SQL*Plus con:  @C:\archivosbd\ej2_paso5_admin_permisos.sql
-- Las contrasenas NO estan en el archivo: SQL*Plus las pide ocultas.
-- ============================================================
SET VERIFY OFF

CONNECT usr_admin_uni@localhost:1521/XEPDB1
SHOW USER
SPOOL C:\archivosbd\evidencia_ej2_universidad.txt APPEND

-- ------------------------------------------------------------
-- Etapa 5 (USR_ADMIN_UNI): conceder CREATE SESSION al usuario de consultas
PROMPT Etapa 5 - USR_ADMIN_UNI concede privilegios al usuario de consultas
GRANT CREATE SESSION TO usr_consultas_uni;

-- Verificacion
COLUMN privilege FORMAT A16
SELECT privilege, admin_option
FROM user_sys_privs
ORDER BY privilege;

-- ------------------------------------------------------------
-- Etapa 5 (USR_ADMIN_UNI): privilegios sobre objetos
GRANT SELECT, INSERT ON facultad TO usr_consultas_uni;
GRANT SELECT, INSERT ON carrera TO usr_consultas_uni;
GRANT SELECT, INSERT ON barrios TO usr_consultas_uni;
GRANT SELECT, INSERT ON alumnos TO usr_consultas_uni;

-- Verificacion
COLUMN grantee FORMAT A18
COLUMN table_name FORMAT A18
COLUMN privilege FORMAT A10
SELECT grantee, table_name, privilege
FROM user_tab_privs_made
WHERE grantee = 'USR_CONSULTAS_UNI'
ORDER BY table_name, privilege;

SPOOL OFF
