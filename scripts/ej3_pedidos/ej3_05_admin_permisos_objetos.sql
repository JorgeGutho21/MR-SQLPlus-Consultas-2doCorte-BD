-- ============================================================
-- ej3_05_admin_permisos_objetos.sql
-- Ruta practica Oracle - Ejercicio 3: Clientes y pedidos
-- Etapa 5 (administrador): GRANT SELECT, INSERT sobre cada tabla.
-- Usuario: USR_ADMIN_PED  |  Servicio: localhost:1521/XEPDB1
-- Ejecutar desde SQL*Plus con:  @C:\archivosbd\ej3_05_admin_permisos_objetos.sql
-- Las contrasenas NO estan en el archivo: SQL*Plus las pide ocultas.
-- ============================================================
SET VERIFY OFF

CONNECT usr_admin_ped@localhost:1521/XEPDB1
SHOW USER
SPOOL C:\archivosbd\evidencia_ej3_pedidos.txt APPEND

-- ------------------------------------------------------------
-- Etapa 5 (USR_ADMIN_PED): privilegios sobre objetos
GRANT SELECT, INSERT ON cliente TO usr_consultas_ped;
GRANT SELECT, INSERT ON producto TO usr_consultas_ped;
GRANT SELECT, INSERT ON pedido TO usr_consultas_ped;
GRANT SELECT, INSERT ON detalle_pedido TO usr_consultas_ped;

-- Verificacion
COLUMN grantee FORMAT A18
COLUMN table_name FORMAT A18
COLUMN privilege FORMAT A10
SELECT grantee, table_name, privilege
FROM user_tab_privs_made
WHERE grantee = 'USR_CONSULTAS_PED'
ORDER BY table_name, privilege;

SPOOL OFF
