-- ============================================================
-- ej4_paso5_admin_permisos.sql
-- Ruta practica Oracle - Ejercicio 4: Personas y pasaportes vigentes
-- Paso 5 de 7. Etapa 5 (administrador): GRANT CREATE SESSION y GRANT SELECT, INSERT sobre cada tabla.
-- Usuario: USR_ADMIN_PAS  |  Servicio: localhost:1521/XEPDB1
-- Ejecutar desde SQL*Plus con:  @C:\archivosbd\ej4_paso5_admin_permisos.sql
-- Las contrasenas NO estan en el archivo: SQL*Plus las pide ocultas.
-- ============================================================
SET VERIFY OFF

CONNECT usr_admin_pas@localhost:1521/XEPDB1
SHOW USER
SPOOL C:\archivosbd\evidencia_ej4_pasaportes.txt APPEND

-- ------------------------------------------------------------
-- Etapa 5 (USR_ADMIN_PAS): conceder CREATE SESSION al usuario de consultas
PROMPT Etapa 5 - USR_ADMIN_PAS concede privilegios al usuario de consultas
GRANT CREATE SESSION TO usr_consultas_pas;

-- Verificacion
COLUMN privilege FORMAT A16
SELECT privilege, admin_option
FROM user_sys_privs
ORDER BY privilege;

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
