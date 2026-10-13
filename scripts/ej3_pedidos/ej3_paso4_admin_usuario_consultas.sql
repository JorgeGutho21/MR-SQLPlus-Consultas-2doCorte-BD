-- ============================================================
-- ej3_paso4_admin_usuario_consultas.sql
-- Ruta practica Oracle - Ejercicio 3: Clientes y pedidos
-- Paso 4 de 7. Etapa 4 (administrador): CREATE USER del usuario de consultas.
-- Usuario: USR_ADMIN_PED  |  Servicio: localhost:1521/XEPDB1
-- Ejecutar desde SQL*Plus con:  @C:\archivosbd\ej3_paso4_admin_usuario_consultas.sql
-- Las contrasenas NO estan en el archivo: SQL*Plus las pide ocultas.
-- ============================================================
SET VERIFY OFF

CONNECT usr_admin_ped@localhost:1521/XEPDB1
SHOW USER
SPOOL C:\archivosbd\evidencia_ej3_pedidos.txt APPEND

-- ------------------------------------------------------------
-- Etapa 4 (USR_ADMIN_PED): crear el usuario de consultas USR_CONSULTAS_PED
PROMPT Etapa 4 - USR_ADMIN_PED crea el usuario de consultas
SPOOL OFF
ACCEPT clave_cons CHAR PROMPT 'Clave para USR_CONSULTAS_PED: ' HIDE
CREATE USER usr_consultas_ped
  IDENTIFIED BY "&clave_cons"
  DEFAULT TABLESPACE ts_pedidos
  TEMPORARY TABLESPACE temp;
UNDEFINE clave_cons
SPOOL C:\archivosbd\evidencia_ej3_pedidos.txt APPEND
PROMPT Etapa 4 - USR_ADMIN_PED creo el usuario USR_CONSULTAS_PED

-- Verificacion
COLUMN username FORMAT A18
SELECT username, created
FROM all_users
WHERE username = 'USR_CONSULTAS_PED';

SPOOL OFF
