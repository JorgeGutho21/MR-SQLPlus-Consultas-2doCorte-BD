-- ============================================================
-- ej1_05_admin_permisos_objetos.sql
-- Ruta practica Oracle - Ejercicio 1: Propietarios y vehiculos
-- Etapa 5 (administrador): GRANT SELECT, INSERT sobre cada tabla.
-- Usuario: USR_ADMIN_VEH  |  Servicio: localhost:1521/XEPDB1
-- Ejecutar desde SQL*Plus con:  @C:\archivosbd\ej1_05_admin_permisos_objetos.sql
-- Las contrasenas NO estan en el archivo: SQL*Plus las pide ocultas.
-- ============================================================
SET VERIFY OFF

CONNECT usr_admin_veh@localhost:1521/XEPDB1
SHOW USER
SPOOL C:\archivosbd\evidencia_ej1_vehiculos.txt APPEND

-- ------------------------------------------------------------
-- Etapa 5 (USR_ADMIN_VEH): privilegios sobre objetos
GRANT SELECT, INSERT ON propietario TO usr_consultas_veh;
GRANT SELECT, INSERT ON marca TO usr_consultas_veh;
GRANT SELECT, INSERT ON vehiculo TO usr_consultas_veh;
GRANT SELECT, INSERT ON prop_veh TO usr_consultas_veh;

-- Verificacion
COLUMN grantee FORMAT A18
COLUMN table_name FORMAT A18
COLUMN privilege FORMAT A10
SELECT grantee, table_name, privilege
FROM user_tab_privs_made
WHERE grantee = 'USR_CONSULTAS_VEH'
ORDER BY table_name, privilege;

SPOOL OFF
