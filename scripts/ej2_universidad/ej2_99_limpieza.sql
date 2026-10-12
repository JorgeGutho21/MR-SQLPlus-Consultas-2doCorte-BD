-- ============================================================
-- ej2_99_limpieza.sql
-- Ruta practica Oracle - Ejercicio 2: Sistema universitario
-- OPCIONAL: borra todo lo del ejercicio para repetirlo desde cero.
-- Usuario: SYSTEM  |  Servicio: localhost:1521/XEPDB1
-- Ejecutar desde SQL*Plus con:  @C:\archivosbd\ej2_99_limpieza.sql
-- Las contrasenas NO estan en el archivo: SQL*Plus las pide ocultas.
-- ============================================================
SET VERIFY OFF

-- CUIDADO: elimina usuarios, tablas, datos y el datafile de este ejercicio.
CONNECT system@localhost:1521/XEPDB1
DROP USER usr_consultas_uni CASCADE;
DROP USER usr_admin_uni CASCADE;
DROP TABLESPACE ts_universidad INCLUDING CONTENTS AND DATAFILES;
