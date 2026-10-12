-- ============================================================
-- ej2_03_admin_restricciones.sql
-- Ruta practica Oracle - Ejercicio 2: Sistema universitario
-- Etapa 3 (administrador): PRIMARY KEY, FOREIGN KEY, UNIQUE y CHECK con ALTER TABLE.
-- Usuario: USR_ADMIN_UNI  |  Servicio: localhost:1521/XEPDB1
-- Ejecutar desde SQL*Plus con:  @C:\archivosbd\ej2_03_admin_restricciones.sql
-- Las contrasenas NO estan en el archivo: SQL*Plus las pide ocultas.
-- ============================================================
SET VERIFY OFF

CONNECT usr_admin_uni@localhost:1521/XEPDB1
SHOW USER
SPOOL C:\archivosbd\evidencia_ej2_universidad.txt APPEND

-- ------------------------------------------------------------
-- Agregar las PRIMARY KEY
PROMPT Etapa 3 - PRIMARY KEY
ALTER TABLE facultad
  ADD CONSTRAINT pk_facultad PRIMARY KEY (cod_fac);

ALTER TABLE carrera
  ADD CONSTRAINT pk_carrera PRIMARY KEY (cod_carrera);

ALTER TABLE barrios
  ADD CONSTRAINT pk_barrios PRIMARY KEY (id_barrio);

ALTER TABLE alumnos
  ADD CONSTRAINT pk_alumnos PRIMARY KEY (ced_alumno);

-- Verificacion
COLUMN constraint_name FORMAT A24
COLUMN table_name FORMAT A18
COLUMN r_constraint_name FORMAT A20
SELECT constraint_name, table_name
FROM user_constraints
WHERE constraint_type = 'P'
ORDER BY table_name;

-- ------------------------------------------------------------
-- Agregar las FOREIGN KEY
PROMPT Etapa 3 - FOREIGN KEY
ALTER TABLE carrera
  ADD CONSTRAINT fk_carrera_facultad
  FOREIGN KEY (cod_fac) REFERENCES facultad (cod_fac);

ALTER TABLE alumnos
  ADD CONSTRAINT fk_alumnos_carrera
  FOREIGN KEY (cod_carrera) REFERENCES carrera (cod_carrera);

ALTER TABLE alumnos
  ADD CONSTRAINT fk_alumnos_barrios
  FOREIGN KEY (id_barrio) REFERENCES barrios (id_barrio);

-- Verificacion
COLUMN constraint_name FORMAT A24
COLUMN table_name FORMAT A18
COLUMN r_constraint_name FORMAT A20
SELECT constraint_name, table_name, r_constraint_name
FROM user_constraints
WHERE constraint_type = 'R'
ORDER BY table_name, constraint_name;

-- ------------------------------------------------------------
-- Agregar CHECK
PROMPT Etapa 3 - CHECK
ALTER TABLE alumnos
  ADD CONSTRAINT chk_alumnos_genero CHECK (genero IN ('M', 'F'));

ALTER TABLE alumnos
  ADD CONSTRAINT chk_alumnos_promedio CHECK (promedio BETWEEN 0 AND 5);

-- Verificacion
COLUMN constraint_name FORMAT A24
COLUMN table_name FORMAT A18
COLUMN r_constraint_name FORMAT A20
SELECT constraint_name, constraint_type, table_name
FROM user_constraints
WHERE constraint_name NOT LIKE 'SYS%'
ORDER BY table_name, constraint_type, constraint_name;

-- ------------------------------------------------------------
-- Requisito nuevo: agregar fecha_nac con ALTER TABLE
PROMPT Etapa 3 - Cambio de requisitos: fecha de nacimiento
ALTER TABLE alumnos
  ADD fecha_nac DATE;

-- Verificacion
DESC alumnos

SPOOL OFF
