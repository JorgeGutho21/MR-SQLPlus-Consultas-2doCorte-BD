-- ============================================================
-- ej2_07_consultas_select.sql
-- Ruta practica Oracle - Ejercicio 2: Sistema universitario
-- Etapa 6 (consultas): todas las consultas del ejercicio.
-- Usuario: USR_CONSULTAS_UNI  |  Servicio: localhost:1521/XEPDB1
-- Ejecutar desde SQL*Plus con:  @C:\archivosbd\ej2_07_consultas_select.sql
-- Las contrasenas NO estan en el archivo: SQL*Plus las pide ocultas.
-- ============================================================
SET VERIFY OFF

CONNECT usr_consultas_uni@localhost:1521/XEPDB1
SHOW USER
SPOOL C:\archivosbd\evidencia_ej2_universidad.txt APPEND
SET LINESIZE 200
SET PAGESIZE 100

-- ------------------------------------------------------------
-- Consulta: Cuantos alumnos hay en cada carrera?
SELECT c.cod_carrera, c.nom_carrera, COUNT(a.ced_alumno) AS alumnos
FROM usr_admin_uni.carrera c
LEFT JOIN usr_admin_uni.alumnos a ON a.cod_carrera = c.cod_carrera
GROUP BY c.cod_carrera, c.nom_carrera
ORDER BY alumnos DESC, c.cod_carrera;

-- ------------------------------------------------------------
-- Consulta: Cuantos alumnos tiene cada facultad?
SELECT f.nom_facultad, COUNT(a.ced_alumno) AS alumnos
FROM usr_admin_uni.facultad f
LEFT JOIN usr_admin_uni.carrera c ON c.cod_fac = f.cod_fac
LEFT JOIN usr_admin_uni.alumnos a ON a.cod_carrera = c.cod_carrera
GROUP BY f.nom_facultad
ORDER BY alumnos DESC, f.nom_facultad;

-- ------------------------------------------------------------
-- Consulta: Cuantos alumnos viven en cada barrio?
SELECT b.nom_barrio, COUNT(a.ced_alumno) AS alumnos
FROM usr_admin_uni.barrios b
LEFT JOIN usr_admin_uni.alumnos a ON a.id_barrio = b.id_barrio
GROUP BY b.nom_barrio
ORDER BY alumnos DESC, b.nom_barrio;

-- ------------------------------------------------------------
-- Consulta: Que alumnos no informaron su barrio?
SELECT ced_alumno, nombre, apellido
FROM usr_admin_uni.alumnos
WHERE id_barrio IS NULL;

-- ------------------------------------------------------------
-- Consulta: Cual es el promedio, el minimo y el maximo por carrera?
SELECT c.nom_carrera,
       COUNT(a.promedio) AS con_promedio,
       ROUND(AVG(a.promedio), 2) AS promedio,
       MIN(a.promedio) AS minimo,
       MAX(a.promedio) AS maximo
FROM usr_admin_uni.carrera c
JOIN usr_admin_uni.alumnos a ON a.cod_carrera = c.cod_carrera
GROUP BY c.nom_carrera
ORDER BY promedio DESC;

-- ------------------------------------------------------------
-- Consulta: Que alumnas estudian Ingenieria de Sistemas?
SELECT nombre, apellido, promedio
FROM usr_admin_uni.alumnos
WHERE genero = 'F'
  AND cod_carrera = 'SIS'
ORDER BY apellido;

-- ------------------------------------------------------------
-- Consulta: Que alumnos todavia no tienen promedio?
SELECT nombre, apellido, cod_carrera
FROM usr_admin_uni.alumnos
WHERE promedio IS NULL
ORDER BY apellido;

-- ------------------------------------------------------------
-- Consulta: Que alumnos tienen un apellido que empieza por M?
SELECT nombre, apellido
FROM usr_admin_uni.alumnos
WHERE apellido LIKE 'M%'
ORDER BY apellido, nombre;

-- ------------------------------------------------------------
-- Consulta: Que alumnos nacieron en 2004?
SELECT nombre, apellido, TO_CHAR(fecha_nac, 'YYYY-MM-DD') AS nacimiento
FROM usr_admin_uni.alumnos
WHERE fecha_nac BETWEEN DATE '2004-01-01' AND DATE '2004-12-31'
ORDER BY fecha_nac;

-- ------------------------------------------------------------
-- Consulta: Que carreras tienen mas de 6 alumnos?
SELECT cod_carrera, COUNT(*) AS alumnos
FROM usr_admin_uni.alumnos
GROUP BY cod_carrera
HAVING COUNT(*) > 6
ORDER BY alumnos DESC, cod_carrera;

-- ------------------------------------------------------------
-- Consulta: Que alumnos de Medicina o Enfermeria tienen promedio de 4.0 o mas?
SELECT nombre, apellido, cod_carrera, promedio
FROM usr_admin_uni.alumnos
WHERE cod_carrera IN ('MED', 'ENF')
  AND promedio >= 4
ORDER BY promedio DESC, apellido;

-- ------------------------------------------------------------
-- Consulta: AND se evalua antes que OR: cuantas filas devuelve cada version?
SELECT COUNT(*) AS sin_parentesis
FROM usr_admin_uni.alumnos
WHERE cod_carrera = 'SIS' OR cod_carrera = 'IND' AND genero = 'F';

SELECT COUNT(*) AS con_parentesis
FROM usr_admin_uni.alumnos
WHERE (cod_carrera = 'SIS' OR cod_carrera = 'IND') AND genero = 'F';

-- ------------------------------------------------------------
-- Consulta: En que barrios viven los alumnos de Sistemas? (sin repetir)
SELECT DISTINCT b.nom_barrio
FROM usr_admin_uni.alumnos a
JOIN usr_admin_uni.barrios b ON b.id_barrio = a.id_barrio
WHERE a.cod_carrera = 'SIS'
ORDER BY b.nom_barrio;

-- ------------------------------------------------------------
-- Consulta: Que alumnos pertenecen a la facultad de Ciencias de la Salud?
SELECT a.nombre, a.apellido, c.nom_carrera
FROM usr_admin_uni.alumnos a
JOIN usr_admin_uni.carrera c ON c.cod_carrera = a.cod_carrera
JOIN usr_admin_uni.facultad f ON f.cod_fac = c.cod_fac
WHERE f.cod_fac = 'SAL'
ORDER BY c.nom_carrera, a.apellido;

SPOOL OFF
