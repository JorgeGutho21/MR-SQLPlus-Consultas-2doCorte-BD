-- ============================================================
-- ej2_05_admin_permisos_objetos.sql
-- Ruta practica Oracle - Ejercicio 2: Sistema universitario
-- Etapa 5 (administrador): GRANT SELECT, INSERT sobre cada tabla.
-- Usuario: USR_ADMIN_UNI  |  Servicio: localhost:1521/XEPDB1
-- Ejecutar desde SQL*Plus con:  @C:\archivosbd\ej2_05_admin_permisos_objetos.sql
-- Las contrasenas NO estan en el archivo: SQL*Plus las pide ocultas.
-- ============================================================
SET VERIFY OFF

CONNECT usr_admin_uni@localhost:1521/XEPDB1
SHOW USER
SPOOL C:\archivosbd\evidencia_ej2_universidad.txt APPEND

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
