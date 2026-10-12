-- ============================================================
-- ej4_03_admin_restricciones.sql
-- Ruta practica Oracle - Ejercicio 4: Personas y pasaportes vigentes
-- Etapa 3 (administrador): PRIMARY KEY, FOREIGN KEY, UNIQUE y CHECK con ALTER TABLE.
-- Usuario: USR_ADMIN_PAS  |  Servicio: localhost:1521/XEPDB1
-- Ejecutar desde SQL*Plus con:  @C:\archivosbd\ej4_03_admin_restricciones.sql
-- Las contrasenas NO estan en el archivo: SQL*Plus las pide ocultas.
-- ============================================================
SET VERIFY OFF

CONNECT usr_admin_pas@localhost:1521/XEPDB1
SHOW USER
SPOOL C:\archivosbd\evidencia_ej4_pasaportes.txt APPEND

-- ------------------------------------------------------------
-- Agregar las PRIMARY KEY
PROMPT Etapa 3 - PRIMARY KEY
ALTER TABLE pais
  ADD CONSTRAINT pk_pais PRIMARY KEY (cod_pais);

ALTER TABLE persona
  ADD CONSTRAINT pk_persona PRIMARY KEY (id_persona);

ALTER TABLE pasaporte_vigente
  ADD CONSTRAINT pk_pasaporte PRIMARY KEY (num_pasaporte);

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
ALTER TABLE pasaporte_vigente
  ADD CONSTRAINT fk_pasaporte_persona
  FOREIGN KEY (id_persona) REFERENCES persona (id_persona);

ALTER TABLE pasaporte_vigente
  ADD CONSTRAINT fk_pasaporte_pais
  FOREIGN KEY (cod_pais) REFERENCES pais (cod_pais);

-- Verificacion
COLUMN constraint_name FORMAT A24
COLUMN table_name FORMAT A18
COLUMN r_constraint_name FORMAT A20
SELECT constraint_name, table_name, r_constraint_name
FROM user_constraints
WHERE constraint_type = 'R'
ORDER BY table_name, constraint_name;

-- ------------------------------------------------------------
-- Agregar UNIQUE y CHECK
PROMPT Etapa 3 - UNIQUE y CHECK
ALTER TABLE pasaporte_vigente
  ADD CONSTRAINT uq_pasaporte_persona UNIQUE (id_persona);

ALTER TABLE pasaporte_vigente
  ADD CONSTRAINT chk_pasaporte_fechas CHECK (fecha_vencimiento > fecha_expedicion);

-- Verificacion
COLUMN constraint_name FORMAT A24
COLUMN table_name FORMAT A18
COLUMN r_constraint_name FORMAT A20
SELECT constraint_name, constraint_type, table_name
FROM user_constraints
WHERE constraint_name NOT LIKE 'SYS%'
ORDER BY table_name, constraint_type, constraint_name;

SPOOL OFF
