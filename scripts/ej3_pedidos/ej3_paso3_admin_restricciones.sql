-- ============================================================
-- ej3_paso3_admin_restricciones.sql
-- Ruta practica Oracle - Ejercicio 3: Clientes y pedidos
-- Paso 3 de 7. Etapa 3 (administrador): PRIMARY KEY, FOREIGN KEY, UNIQUE y CHECK con ALTER TABLE.
-- Usuario: USR_ADMIN_PED  |  Servicio: localhost:1521/XEPDB1
-- Ejecutar desde SQL*Plus con:  @C:\archivosbd\ej3_paso3_admin_restricciones.sql
-- Las contrasenas NO estan en el archivo: SQL*Plus las pide ocultas.
-- ============================================================
SET VERIFY OFF

CONNECT usr_admin_ped@localhost:1521/XEPDB1
SHOW USER
SPOOL C:\archivosbd\evidencia_ej3_pedidos.txt APPEND

-- ------------------------------------------------------------
-- Agregar las PRIMARY KEY
PROMPT Etapa 3 - PRIMARY KEY
ALTER TABLE cliente
  ADD CONSTRAINT pk_cliente PRIMARY KEY (id_cliente);

ALTER TABLE producto
  ADD CONSTRAINT pk_producto PRIMARY KEY (id_producto);

ALTER TABLE pedido
  ADD CONSTRAINT pk_pedido PRIMARY KEY (id_pedido);

ALTER TABLE detalle_pedido
  ADD CONSTRAINT pk_detalle_pedido PRIMARY KEY (id_pedido, id_producto);

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
ALTER TABLE pedido
  ADD CONSTRAINT fk_pedido_cliente
  FOREIGN KEY (id_cliente) REFERENCES cliente (id_cliente);

ALTER TABLE detalle_pedido
  ADD CONSTRAINT fk_detalle_pedido
  FOREIGN KEY (id_pedido) REFERENCES pedido (id_pedido);

ALTER TABLE detalle_pedido
  ADD CONSTRAINT fk_detalle_producto
  FOREIGN KEY (id_producto) REFERENCES producto (id_producto);

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
ALTER TABLE cliente
  ADD CONSTRAINT uq_cliente_correo UNIQUE (correo);

ALTER TABLE producto
  ADD CONSTRAINT uq_producto_nombre UNIQUE (nom_producto);

ALTER TABLE producto
  ADD CONSTRAINT chk_producto_precio CHECK (precio_lista > 0);

ALTER TABLE pedido
  ADD CONSTRAINT chk_pedido_estado CHECK (estado IN ('PENDIENTE', 'ENVIADO', 'ENTREGADO', 'ANULADO'));

ALTER TABLE detalle_pedido
  ADD CONSTRAINT chk_detalle_cantidad CHECK (cantidad > 0);

ALTER TABLE detalle_pedido
  ADD CONSTRAINT chk_detalle_precio CHECK (precio_venta >= 0);

-- Verificacion
COLUMN constraint_name FORMAT A24
COLUMN table_name FORMAT A18
COLUMN r_constraint_name FORMAT A20
SELECT constraint_name, constraint_type, table_name
FROM user_constraints
WHERE constraint_name NOT LIKE 'SYS%'
ORDER BY table_name, constraint_type, constraint_name;

SPOOL OFF
