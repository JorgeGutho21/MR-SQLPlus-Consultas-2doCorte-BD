-- ============================================================
-- ej1_paso3_admin_restricciones.sql
-- Ruta practica Oracle - Ejercicio 1: Propietarios y vehiculos
-- Paso 3 de 7. Etapa 3 (administrador): PRIMARY KEY, FOREIGN KEY, UNIQUE y CHECK con ALTER TABLE.
-- Usuario: USR_ADMIN_VEH  |  Servicio: localhost:1521/XEPDB1
-- Ejecutar desde SQL*Plus con:  @C:\archivosbd\ej1_paso3_admin_restricciones.sql
-- Las contrasenas NO estan en el archivo: SQL*Plus las pide ocultas.
-- ============================================================
SET VERIFY OFF

CONNECT usr_admin_veh@localhost:1521/XEPDB1
SHOW USER
SPOOL C:\archivosbd\evidencia_ej1_vehiculos.txt APPEND

-- ------------------------------------------------------------
-- Agregar las PRIMARY KEY
PROMPT Etapa 3 - PRIMARY KEY
ALTER TABLE propietario
  ADD CONSTRAINT pk_propietario PRIMARY KEY (id_propietario);

ALTER TABLE marca
  ADD CONSTRAINT pk_marca PRIMARY KEY (id_marca);

ALTER TABLE vehiculo
  ADD CONSTRAINT pk_vehiculo PRIMARY KEY (placa);

ALTER TABLE prop_veh
  ADD CONSTRAINT pk_prop_veh PRIMARY KEY (id_propietario, placa);

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
ALTER TABLE vehiculo
  ADD CONSTRAINT fk_vehiculo_marca
  FOREIGN KEY (id_marca) REFERENCES marca (id_marca);

ALTER TABLE prop_veh
  ADD CONSTRAINT fk_propveh_propietario
  FOREIGN KEY (id_propietario) REFERENCES propietario (id_propietario);

ALTER TABLE prop_veh
  ADD CONSTRAINT fk_propveh_vehiculo
  FOREIGN KEY (placa) REFERENCES vehiculo (placa);

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
ALTER TABLE marca
  ADD CONSTRAINT uq_marca_nombre UNIQUE (nom_marca);

ALTER TABLE vehiculo
  ADD CONSTRAINT chk_vehiculo_modelo CHECK (modelo >= 1950);

ALTER TABLE propietario
  ADD CONSTRAINT chk_propietario_sexo CHECK (sexo IN ('M', 'F'));

-- Verificacion
COLUMN constraint_name FORMAT A24
COLUMN table_name FORMAT A18
COLUMN r_constraint_name FORMAT A20
SELECT constraint_name, constraint_type, table_name
FROM user_constraints
WHERE constraint_name NOT LIKE 'SYS%'
ORDER BY table_name, constraint_type, constraint_name;

SPOOL OFF
