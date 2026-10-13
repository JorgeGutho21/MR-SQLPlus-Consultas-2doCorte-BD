-- ============================================================
-- ej2_03_datos_consultas.sql
-- Ruta practica Oracle - Ejercicio 2: Sistema universitario
-- 03 - Datos y consultas (usuario de consultas): INSERT, COMMIT, conteos, pruebas y consultas (etapa 6).
-- Usuario: USR_CONSULTAS_UNI  |  Servicio: localhost:1521/XEPDB1
-- Ejecutar desde SQL*Plus con:  @C:\archivosbd\ej2_03_datos_consultas.sql
-- Las contrasenas NO estan en el archivo: SQL*Plus las pide ocultas.
-- ============================================================
SET VERIFY OFF

CONNECT usr_consultas_uni@localhost:1521/XEPDB1
SHOW USER
SPOOL C:\archivosbd\evidencia_ej2_universidad.txt APPEND
PROMPT Etapa 6 - USR_CONSULTAS_UNI inserta, confirma y consulta
SET LINESIZE 200
SET PAGESIZE 100

-- ------------------------------------------------------------
-- Comprobar que puede hacer USR_CONSULTAS_UNI
COLUMN privilege FORMAT A16
SELECT privilege FROM session_privs;

COLUMN owner FORMAT A16
COLUMN table_name FORMAT A18
COLUMN privilege FORMAT A10
SELECT owner, table_name, privilege
FROM user_tab_privs_recd
WHERE owner = 'USR_ADMIN_UNI'
ORDER BY table_name, privilege;

-- ------------------------------------------------------------
-- Comprobar por que hace falta ESQUEMA.TABLA
-- ERRORES ESPERADOS (prueba intencional): ORA-00942
SELECT COUNT(*) FROM facultad;

SELECT COUNT(*) FROM usr_admin_uni.facultad;

-- ------------------------------------------------------------
-- Insertar en FACULTAD (5 filas)
INSERT INTO usr_admin_uni.facultad (cod_fac, nom_facultad)
VALUES ('ING', 'Ingenieria');
INSERT INTO usr_admin_uni.facultad (cod_fac, nom_facultad)
VALUES ('SAL', 'Ciencias de la Salud');
INSERT INTO usr_admin_uni.facultad (cod_fac, nom_facultad)
VALUES ('ECO', 'Ciencias Economicas');
INSERT INTO usr_admin_uni.facultad (cod_fac, nom_facultad)
VALUES ('JUR', 'Ciencias Juridicas');
INSERT INTO usr_admin_uni.facultad (cod_fac, nom_facultad)
VALUES ('HUM', 'Humanidades');

-- ------------------------------------------------------------
-- Insertar en CARRERA (8 filas)
INSERT INTO usr_admin_uni.carrera (cod_carrera, nom_carrera, cod_fac)
VALUES ('SIS', 'Ingenieria de Sistemas', 'ING');
INSERT INTO usr_admin_uni.carrera (cod_carrera, nom_carrera, cod_fac)
VALUES ('IND', 'Ingenieria Industrial', 'ING');
INSERT INTO usr_admin_uni.carrera (cod_carrera, nom_carrera, cod_fac)
VALUES ('MED', 'Medicina', 'SAL');
INSERT INTO usr_admin_uni.carrera (cod_carrera, nom_carrera, cod_fac)
VALUES ('ENF', 'Enfermeria', 'SAL');
INSERT INTO usr_admin_uni.carrera (cod_carrera, nom_carrera, cod_fac)
VALUES ('ADM', 'Administracion de Empresas', 'ECO');
INSERT INTO usr_admin_uni.carrera (cod_carrera, nom_carrera, cod_fac)
VALUES ('CON', 'Contaduria Publica', 'ECO');
INSERT INTO usr_admin_uni.carrera (cod_carrera, nom_carrera, cod_fac)
VALUES ('DER', 'Derecho', 'JUR');
INSERT INTO usr_admin_uni.carrera (cod_carrera, nom_carrera, cod_fac)
VALUES ('PSI', 'Psicologia', 'HUM');

-- ------------------------------------------------------------
-- Insertar en BARRIOS (8 filas)
INSERT INTO usr_admin_uni.barrios (id_barrio, nom_barrio)
VALUES (1, 'El Prado');
INSERT INTO usr_admin_uni.barrios (id_barrio, nom_barrio)
VALUES (2, 'Los Alpes');
INSERT INTO usr_admin_uni.barrios (id_barrio, nom_barrio)
VALUES (3, 'Centro');
INSERT INTO usr_admin_uni.barrios (id_barrio, nom_barrio)
VALUES (4, 'La Floresta');
INSERT INTO usr_admin_uni.barrios (id_barrio, nom_barrio)
VALUES (5, 'El Bosque');
INSERT INTO usr_admin_uni.barrios (id_barrio, nom_barrio)
VALUES (6, 'San Fernando');
INSERT INTO usr_admin_uni.barrios (id_barrio, nom_barrio)
VALUES (7, 'Villa Country');
INSERT INTO usr_admin_uni.barrios (id_barrio, nom_barrio)
VALUES (8, 'Las Palmas');

-- ------------------------------------------------------------
-- Insertar en ALUMNOS desde un archivo (50 filas)
-- (requiere ej2_carga_alumnos.sql en C:\archivosbd)
@C:\archivosbd\ej2_carga_alumnos.sql

-- ------------------------------------------------------------
-- Confirmar con COMMIT y contar las filas
COMMIT;

SELECT 'FACULTAD' AS tabla, COUNT(*) AS filas FROM usr_admin_uni.facultad
UNION ALL
SELECT 'CARRERA' AS tabla, COUNT(*) AS filas FROM usr_admin_uni.carrera
UNION ALL
SELECT 'BARRIOS' AS tabla, COUNT(*) AS filas FROM usr_admin_uni.barrios
UNION ALL
SELECT 'ALUMNOS' AS tabla, COUNT(*) AS filas FROM usr_admin_uni.alumnos;

-- ------------------------------------------------------------
-- Pruebas de integridad: errores esperados
-- ERRORES ESPERADOS (prueba intencional): ORA-02290, ORA-02291, ORA-02290, ORA-00001
PROMPT Pruebas intencionales: cada sentencia debe fallar
INSERT INTO usr_admin_uni.alumnos (ced_alumno, primer_nombre, segundo_nombre, primer_apellido, segundo_apellido, genero, promedio, cod_carrera, id_barrio, fecha_nac)
VALUES ('1000000060', 'Mario', NULL, 'Diaz', 'Leon', 'X', 3.5, 'SIS', 1, DATE '2003-02-02');

INSERT INTO usr_admin_uni.alumnos (ced_alumno, primer_nombre, segundo_nombre, primer_apellido, segundo_apellido, genero, promedio, cod_carrera, id_barrio, fecha_nac)
VALUES ('1000000061', 'Ana', 'Maria', 'Soto', NULL, 'F', 3.0, 'XYZ', 1, DATE '2004-01-01');

INSERT INTO usr_admin_uni.alumnos (ced_alumno, primer_nombre, segundo_nombre, primer_apellido, segundo_apellido, genero, promedio, cod_carrera, id_barrio, fecha_nac)
VALUES ('1000000062', 'Luis', NULL, 'Paz', 'Rios', 'M', 6, 'SIS', 1, DATE '2003-05-05');

INSERT INTO usr_admin_uni.alumnos (ced_alumno, primer_nombre, segundo_nombre, primer_apellido, segundo_apellido, genero, promedio, cod_carrera, id_barrio, fecha_nac)
VALUES ('1000000001', 'Pedro', NULL, 'Lozano', NULL, 'M', 3.5, 'SIS', 2, DATE '2003-08-08');

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
SELECT ced_alumno, primer_nombre, primer_apellido
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
SELECT primer_nombre, primer_apellido, promedio
FROM usr_admin_uni.alumnos
WHERE genero = 'F'
  AND cod_carrera = 'SIS'
ORDER BY primer_apellido;

-- ------------------------------------------------------------
-- Consulta: Que alumnos todavia no tienen promedio?
SELECT primer_nombre, primer_apellido, cod_carrera
FROM usr_admin_uni.alumnos
WHERE promedio IS NULL
ORDER BY primer_apellido;

-- ------------------------------------------------------------
-- Consulta: Que alumnos tienen un apellido que empieza por M?
SELECT primer_nombre, primer_apellido
FROM usr_admin_uni.alumnos
WHERE primer_apellido LIKE 'M%'
ORDER BY primer_apellido, primer_nombre;

-- ------------------------------------------------------------
-- Consulta: Que alumnos nacieron en 2004?
SELECT primer_nombre, primer_apellido, TO_CHAR(fecha_nac, 'YYYY-MM-DD') AS nacimiento
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
SELECT primer_nombre, primer_apellido, cod_carrera, promedio
FROM usr_admin_uni.alumnos
WHERE cod_carrera IN ('MED', 'ENF')
  AND promedio >= 4
ORDER BY promedio DESC, primer_apellido;

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
SELECT a.primer_nombre, a.primer_apellido, c.nom_carrera
FROM usr_admin_uni.alumnos a
JOIN usr_admin_uni.carrera c ON c.cod_carrera = a.cod_carrera
JOIN usr_admin_uni.facultad f ON f.cod_fac = c.cod_fac
WHERE f.cod_fac = 'SAL'
ORDER BY c.nom_carrera, a.primer_apellido;

SPOOL OFF
