-- ============================================================
-- ej4_05_admin_permisos_objetos.sql
-- Ruta practica Oracle - Ejercicio 4: Personas y pasaportes vigentes
-- Etapa 5 (administrador): GRANT SELECT, INSERT sobre cada tabla.
-- Usuario: USR_ADMIN_PAS  |  Servicio: localhost:1521/XEPDB1
-- Ejecutar desde SQL*Plus con:  @C:\archivosbd\ej4_05_admin_permisos_objetos.sql
-- Las contrasenas NO estan en el archivo: SQL*Plus las pide ocultas.
-- ============================================================
SET VERIFY OFF

CONNECT usr_admin_pas@localhost:1521/XEPDB1
SHOW USER
SPOOL C:\archivosbd\evidencia_ej4_pasaportes.txt APPEND

-- ------------------------------------------------------------
-- Etapa 5 (USR_ADMIN_PAS): privilegios sobre objetos
GRANT SELECT, INSERT ON pais TO usr_consultas_pas;
GRANT SELECT, INSERT ON persona TO usr_consultas_pas;
GRANT SELECT, INSERT ON pasaporte_vigente TO usr_consultas_pas;

-- Verificacion
COLUMN grantee FORMAT A18
COLUMN table_name FORMAT A18
COLUMN privilege FORMAT A10
SELECT grantee, table_name, privilege
FROM user_tab_privs_made
WHERE grantee = 'USR_CONSULTAS_PAS'
ORDER BY table_name, privilege;

SPOOL OFF
