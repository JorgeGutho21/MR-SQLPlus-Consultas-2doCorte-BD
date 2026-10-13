-- ============================================================
-- ej4_paso7_consultas_select.sql
-- Ruta practica Oracle - Ejercicio 4: Personas y pasaportes vigentes
-- Paso 7 de 7. Etapa 6 (consultas): todas las consultas del ejercicio.
-- Usuario: USR_CONSULTAS_PAS  |  Servicio: localhost:1521/XEPDB1
-- Ejecutar desde SQL*Plus con:  @C:\archivosbd\ej4_paso7_consultas_select.sql
-- Las contrasenas NO estan en el archivo: SQL*Plus las pide ocultas.
-- ============================================================
SET VERIFY OFF

CONNECT usr_consultas_pas@localhost:1521/XEPDB1
SHOW USER
SPOOL C:\archivosbd\evidencia_ej4_pasaportes.txt APPEND
PROMPT Etapa 6 - USR_CONSULTAS_PAS inserta, confirma y consulta
SET LINESIZE 200
SET PAGESIZE 100

-- ------------------------------------------------------------
-- Consulta: Que pasaporte tiene cada persona?
SELECT pe.primer_nombre, pe.primer_apellido, pa.num_pasaporte, pa.cod_pais
FROM usr_admin_pas.persona pe
LEFT JOIN usr_admin_pas.pasaporte_vigente pa ON pa.id_persona = pe.id_persona
ORDER BY pe.primer_apellido;

-- ------------------------------------------------------------
-- Consulta: Que personas no tienen pasaporte vigente?
SELECT pe.id_persona, pe.primer_nombre, pe.primer_apellido
FROM usr_admin_pas.persona pe
LEFT JOIN usr_admin_pas.pasaporte_vigente pa ON pa.id_persona = pe.id_persona
WHERE pa.num_pasaporte IS NULL
ORDER BY pe.primer_apellido;

-- ------------------------------------------------------------
-- Consulta: Cuantos pasaportes registrados expidio cada pais?
SELECT pi.cod_pais, pi.nom_pais, COUNT(pa.num_pasaporte) AS pasaportes
FROM usr_admin_pas.pais pi
LEFT JOIN usr_admin_pas.pasaporte_vigente pa ON pa.cod_pais = pi.cod_pais
GROUP BY pi.cod_pais, pi.nom_pais
ORDER BY pasaportes DESC, pi.cod_pais;

-- ------------------------------------------------------------
-- Consulta: Que pasaportes vencen antes de 2030?
SELECT pa.num_pasaporte, pe.primer_nombre, pe.primer_apellido,
       TO_CHAR(pa.fecha_vencimiento, 'YYYY-MM-DD') AS vence
FROM usr_admin_pas.pasaporte_vigente pa
JOIN usr_admin_pas.persona pe ON pe.id_persona = pa.id_persona
WHERE pa.fecha_vencimiento < DATE '2030-01-01'
ORDER BY pa.fecha_vencimiento;

-- ------------------------------------------------------------
-- Consulta: Que personas nacidas antes de 1995 tienen pasaporte?
SELECT pe.primer_nombre, pe.primer_apellido, TO_CHAR(pe.fecha_nac, 'YYYY-MM-DD') AS nacimiento, pa.cod_pais
FROM usr_admin_pas.persona pe
JOIN usr_admin_pas.pasaporte_vigente pa ON pa.id_persona = pe.id_persona
WHERE pe.fecha_nac < DATE '1995-01-01'
ORDER BY pe.fecha_nac;

-- ------------------------------------------------------------
-- Consulta: Alguien tiene mas de un pasaporte vigente?
SELECT id_persona, COUNT(*) AS pasaportes
FROM usr_admin_pas.pasaporte_vigente
GROUP BY id_persona
HAVING COUNT(*) > 1;

SPOOL OFF
