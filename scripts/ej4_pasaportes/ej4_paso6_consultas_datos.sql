-- ============================================================
-- ej4_paso6_consultas_datos.sql
-- Ruta practica Oracle - Ejercicio 4: Personas y pasaportes vigentes
-- Paso 6 de 7. Etapa 6 (consultas): privilegios recibidos, INSERT con ESQUEMA.TABLA, COMMIT, conteos y pruebas de integridad.
-- Usuario: USR_CONSULTAS_PAS  |  Servicio: localhost:1521/XEPDB1
-- Ejecutar desde SQL*Plus con:  @C:\archivosbd\ej4_paso6_consultas_datos.sql
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
-- Comprobar que puede hacer USR_CONSULTAS_PAS
COLUMN privilege FORMAT A16
SELECT privilege FROM session_privs;

COLUMN owner FORMAT A16
COLUMN table_name FORMAT A18
COLUMN privilege FORMAT A10
SELECT owner, table_name, privilege
FROM user_tab_privs_recd
WHERE owner = 'USR_ADMIN_PAS'
ORDER BY table_name, privilege;

-- ------------------------------------------------------------
-- Comprobar por que hace falta ESQUEMA.TABLA
-- ERRORES ESPERADOS (prueba intencional): ORA-00942
SELECT COUNT(*) FROM pais;

SELECT COUNT(*) FROM usr_admin_pas.pais;

-- ------------------------------------------------------------
-- Insertar en PAIS (5 filas)
INSERT INTO usr_admin_pas.pais (cod_pais, nom_pais)
VALUES ('COL', 'Colombia');
INSERT INTO usr_admin_pas.pais (cod_pais, nom_pais)
VALUES ('ECU', 'Ecuador');
INSERT INTO usr_admin_pas.pais (cod_pais, nom_pais)
VALUES ('PER', 'Peru');
INSERT INTO usr_admin_pas.pais (cod_pais, nom_pais)
VALUES ('MEX', 'Mexico');
INSERT INTO usr_admin_pas.pais (cod_pais, nom_pais)
VALUES ('ESP', 'Espana');

-- ------------------------------------------------------------
-- Insertar en PERSONA (8 filas)
INSERT INTO usr_admin_pas.persona (id_persona, primer_nombre, segundo_nombre, primer_apellido, segundo_apellido, fecha_nac)
VALUES ('52123456', 'Camila', NULL, 'Ruiz', NULL, DATE '1995-04-18');
INSERT INTO usr_admin_pas.persona (id_persona, primer_nombre, segundo_nombre, primer_apellido, segundo_apellido, fecha_nac)
VALUES ('79234567', 'Andres', NULL, 'Salazar', NULL, DATE '1988-11-02');
INSERT INTO usr_admin_pas.persona (id_persona, primer_nombre, segundo_nombre, primer_apellido, segundo_apellido, fecha_nac)
VALUES ('1010345678', 'Lucia', NULL, 'Mejia', NULL, DATE '2001-07-25');
INSERT INTO usr_admin_pas.persona (id_persona, primer_nombre, segundo_nombre, primer_apellido, segundo_apellido, fecha_nac)
VALUES ('1020456789', 'Mateo', NULL, 'Cardenas', NULL, DATE '1999-01-09');
INSERT INTO usr_admin_pas.persona (id_persona, primer_nombre, segundo_nombre, primer_apellido, segundo_apellido, fecha_nac)
VALUES ('1030567890', 'Isabel', NULL, 'Torres', NULL, DATE '1992-09-30');
INSERT INTO usr_admin_pas.persona (id_persona, primer_nombre, segundo_nombre, primer_apellido, segundo_apellido, fecha_nac)
VALUES ('1040678901', 'Santiago', NULL, 'Rincon', NULL, DATE '2003-03-14');
INSERT INTO usr_admin_pas.persona (id_persona, primer_nombre, segundo_nombre, primer_apellido, segundo_apellido, fecha_nac)
VALUES ('1050789012', 'Valentina', NULL, 'Ospina', NULL, DATE '1997-12-05');
INSERT INTO usr_admin_pas.persona (id_persona, primer_nombre, segundo_nombre, primer_apellido, segundo_apellido, fecha_nac)
VALUES ('1060890123', 'Diego', NULL, 'Navarro', NULL, DATE '1985-06-21');

-- ------------------------------------------------------------
-- Insertar en PASAPORTE_VIGENTE (5 filas)
INSERT INTO usr_admin_pas.pasaporte_vigente (num_pasaporte, id_persona, cod_pais, fecha_expedicion, fecha_vencimiento)
VALUES ('AT1234567', '52123456', 'COL', DATE '2022-02-10', DATE '2032-02-09');
INSERT INTO usr_admin_pas.pasaporte_vigente (num_pasaporte, id_persona, cod_pais, fecha_expedicion, fecha_vencimiento)
VALUES ('AU2345678', '79234567', 'COL', DATE '2019-08-15', DATE '2029-08-14');
INSERT INTO usr_admin_pas.pasaporte_vigente (num_pasaporte, id_persona, cod_pais, fecha_expedicion, fecha_vencimiento)
VALUES ('A45678901', '1020456789', 'ECU', DATE '2021-05-03', DATE '2027-05-02');
INSERT INTO usr_admin_pas.pasaporte_vigente (num_pasaporte, id_persona, cod_pais, fecha_expedicion, fecha_vencimiento)
VALUES ('PE7654321', '1030567890', 'PER', DATE '2024-10-20', DATE '2029-10-19');
INSERT INTO usr_admin_pas.pasaporte_vigente (num_pasaporte, id_persona, cod_pais, fecha_expedicion, fecha_vencimiento)
VALUES ('G12345678', '1060890123', 'MEX', DATE '2023-01-12', DATE '2029-01-11');

-- ------------------------------------------------------------
-- Confirmar con COMMIT y contar las filas
COMMIT;

SELECT 'PAIS' AS tabla, COUNT(*) AS filas FROM usr_admin_pas.pais
UNION ALL
SELECT 'PERSONA' AS tabla, COUNT(*) AS filas FROM usr_admin_pas.persona
UNION ALL
SELECT 'PASAPORTE_VIGENTE' AS tabla, COUNT(*) AS filas FROM usr_admin_pas.pasaporte_vigente;

-- ------------------------------------------------------------
-- Pruebas de integridad: errores esperados
-- ERRORES ESPERADOS (prueba intencional): ORA-00001, ORA-02290, ORA-02291, ORA-01400
PROMPT Pruebas intencionales: cada sentencia debe fallar
INSERT INTO usr_admin_pas.pasaporte_vigente (num_pasaporte, id_persona, cod_pais, fecha_expedicion, fecha_vencimiento)
VALUES ('AT9999999', '52123456', 'COL', DATE '2025-01-10', DATE '2035-01-09');

INSERT INTO usr_admin_pas.pasaporte_vigente (num_pasaporte, id_persona, cod_pais, fecha_expedicion, fecha_vencimiento)
VALUES ('AX1111111', '1010345678', 'COL', DATE '2025-03-01', DATE '2024-03-01');

INSERT INTO usr_admin_pas.pasaporte_vigente (num_pasaporte, id_persona, cod_pais, fecha_expedicion, fecha_vencimiento)
VALUES ('ZZ2222222', '1040678901', 'XXX', DATE '2025-03-01', DATE '2035-03-01');

INSERT INTO usr_admin_pas.persona (id_persona, primer_nombre, primer_apellido, fecha_nac)
VALUES ('1070901234', NULL, 'Prieto', DATE '2000-02-02');

SPOOL OFF
