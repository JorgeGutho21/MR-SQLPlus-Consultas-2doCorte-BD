-- ============================================================
-- ej2_carga_alumnos.sql
-- Ruta practica Oracle - Ejercicio 2: Sistema universitario
-- 50 INSERT sobre USR_ADMIN_UNI.ALUMNOS
-- Ejecutar conectado como USR_CONSULTAS_UNI (SHOW USER) con:
--   @C:\archivosbd\ej2_carga_alumnos.sql
-- Requisito: tablas padre ya cargadas. Despues se ejecuta COMMIT.
-- ============================================================
PROMPT Cargando 50 filas en USR_ADMIN_UNI.ALUMNOS ...

INSERT INTO usr_admin_uni.alumnos (ced_alumno, nombre, apellido, genero, promedio, cod_carrera, id_barrio, fecha_nac)
VALUES ('1000000001', 'Ana', 'Martinez', 'F', 4.5, 'SIS', 1, DATE '2003-04-12');

INSERT INTO usr_admin_uni.alumnos (ced_alumno, nombre, apellido, genero, promedio, cod_carrera, id_barrio, fecha_nac)
VALUES ('1000000002', 'Carlos', 'Gomez', 'M', 3.8, 'SIS', 3, DATE '2002-09-30');

INSERT INTO usr_admin_uni.alumnos (ced_alumno, nombre, apellido, genero, promedio, cod_carrera, id_barrio, fecha_nac)
VALUES ('1000000003', 'Laura', 'Rodriguez', 'F', 4.2, 'MED', 2, DATE '2004-01-25');

INSERT INTO usr_admin_uni.alumnos (ced_alumno, nombre, apellido, genero, promedio, cod_carrera, id_barrio, fecha_nac)
VALUES ('1000000004', 'Andres', 'Lopez', 'M', 3.1, 'IND', 5, DATE '2001-11-08');

INSERT INTO usr_admin_uni.alumnos (ced_alumno, nombre, apellido, genero, promedio, cod_carrera, id_barrio, fecha_nac)
VALUES ('1000000005', 'Valentina', 'Garcia', 'F', 4.8, 'MED', 4, DATE '2005-06-17');

INSERT INTO usr_admin_uni.alumnos (ced_alumno, nombre, apellido, genero, promedio, cod_carrera, id_barrio, fecha_nac)
VALUES ('1000000006', 'Juan', 'Hernandez', 'M', 2.9, 'ADM', 6, DATE '2003-02-14');

INSERT INTO usr_admin_uni.alumnos (ced_alumno, nombre, apellido, genero, promedio, cod_carrera, id_barrio, fecha_nac)
VALUES ('1000000007', 'Camila', 'Torres', 'F', 3.6, 'ENF', 1, DATE '2004-08-03');

INSERT INTO usr_admin_uni.alumnos (ced_alumno, nombre, apellido, genero, promedio, cod_carrera, id_barrio, fecha_nac)
VALUES ('1000000008', 'Santiago', 'Ramirez', 'M', 4, 'SIS', 7, DATE '2002-12-21');

INSERT INTO usr_admin_uni.alumnos (ced_alumno, nombre, apellido, genero, promedio, cod_carrera, id_barrio, fecha_nac)
VALUES ('1000000009', 'Sofia', 'Vargas', 'F', NULL, 'SIS', 2, DATE '2005-03-09');

INSERT INTO usr_admin_uni.alumnos (ced_alumno, nombre, apellido, genero, promedio, cod_carrera, id_barrio, fecha_nac)
VALUES ('1000000010', 'Mateo', 'Castro', 'M', 3.4, 'CON', 3, DATE '2003-07-27');

INSERT INTO usr_admin_uni.alumnos (ced_alumno, nombre, apellido, genero, promedio, cod_carrera, id_barrio, fecha_nac)
VALUES ('1000000011', 'Isabella', 'Rojas', 'F', 4.1, 'DER', 5, DATE '2004-10-11');

INSERT INTO usr_admin_uni.alumnos (ced_alumno, nombre, apellido, genero, promedio, cod_carrera, id_barrio, fecha_nac)
VALUES ('1000000012', 'Sebastian', 'Moreno', 'M', 2.7, 'IND', 8, DATE '2001-05-19');

INSERT INTO usr_admin_uni.alumnos (ced_alumno, nombre, apellido, genero, promedio, cod_carrera, id_barrio, fecha_nac)
VALUES ('1000000013', 'Mariana', 'Jimenez', 'F', 3.9, 'ADM', 4, DATE '2003-12-02');

INSERT INTO usr_admin_uni.alumnos (ced_alumno, nombre, apellido, genero, promedio, cod_carrera, id_barrio, fecha_nac)
VALUES ('1000000014', 'Daniel', 'Ortiz', 'M', NULL, 'MED', 6, DATE '2005-09-14');

INSERT INTO usr_admin_uni.alumnos (ced_alumno, nombre, apellido, genero, promedio, cod_carrera, id_barrio, fecha_nac)
VALUES ('1000000015', 'Gabriela', 'Ruiz', 'F', 4.6, 'CON', 7, DATE '2002-03-28');

INSERT INTO usr_admin_uni.alumnos (ced_alumno, nombre, apellido, genero, promedio, cod_carrera, id_barrio, fecha_nac)
VALUES ('1000000016', 'Nicolas', 'Gutierrez', 'M', 3.3, 'SIS', 1, DATE '2004-06-06');

INSERT INTO usr_admin_uni.alumnos (ced_alumno, nombre, apellido, genero, promedio, cod_carrera, id_barrio, fecha_nac)
VALUES ('1000000017', 'Paula', 'Mendoza', 'F', 3.7, 'DER', 2, DATE '2003-09-22');

INSERT INTO usr_admin_uni.alumnos (ced_alumno, nombre, apellido, genero, promedio, cod_carrera, id_barrio, fecha_nac)
VALUES ('1000000018', 'Felipe', 'Silva', 'M', 4.3, 'ENF', 3, DATE '2002-01-15');

INSERT INTO usr_admin_uni.alumnos (ced_alumno, nombre, apellido, genero, promedio, cod_carrera, id_barrio, fecha_nac)
VALUES ('1000000019', 'Daniela', 'Rios', 'F', NULL, 'ADM', NULL, DATE '2005-11-30');

INSERT INTO usr_admin_uni.alumnos (ced_alumno, nombre, apellido, genero, promedio, cod_carrera, id_barrio, fecha_nac)
VALUES ('1000000020', 'Alejandro', 'Pardo', 'M', 2.5, 'IND', 5, DATE '2004-02-10');

INSERT INTO usr_admin_uni.alumnos (ced_alumno, nombre, apellido, genero, promedio, cod_carrera, id_barrio, fecha_nac)
VALUES ('1000000021', 'Natalia', 'Cardenas', 'F', 4.9, 'MED', 6, DATE '2001-08-18');

INSERT INTO usr_admin_uni.alumnos (ced_alumno, nombre, apellido, genero, promedio, cod_carrera, id_barrio, fecha_nac)
VALUES ('1000000022', 'David', 'Guerrero', 'M', 3.5, 'DER', 4, DATE '2003-03-05');

INSERT INTO usr_admin_uni.alumnos (ced_alumno, nombre, apellido, genero, promedio, cod_carrera, id_barrio, fecha_nac)
VALUES ('1000000023', 'Juliana', 'Herrera', 'F', 3.2, 'SIS', 7, DATE '2004-05-23');

INSERT INTO usr_admin_uni.alumnos (ced_alumno, nombre, apellido, genero, promedio, cod_carrera, id_barrio, fecha_nac)
VALUES ('1000000024', 'Miguel', 'Navarro', 'M', 4.4, 'CON', 1, DATE '2002-07-07');

INSERT INTO usr_admin_uni.alumnos (ced_alumno, nombre, apellido, genero, promedio, cod_carrera, id_barrio, fecha_nac)
VALUES ('1000000025', 'Carolina', 'Medina', 'F', 3, 'IND', 2, DATE '2003-11-13');

INSERT INTO usr_admin_uni.alumnos (ced_alumno, nombre, apellido, genero, promedio, cod_carrera, id_barrio, fecha_nac)
VALUES ('1000000026', 'Diego', 'Aguilar', 'M', 3.6, 'ENF', 3, DATE '2005-01-20');

INSERT INTO usr_admin_uni.alumnos (ced_alumno, nombre, apellido, genero, promedio, cod_carrera, id_barrio, fecha_nac)
VALUES ('1000000027', 'Andrea', 'Castillo', 'F', 4, 'CON', 4, DATE '2002-10-01');

INSERT INTO usr_admin_uni.alumnos (ced_alumno, nombre, apellido, genero, promedio, cod_carrera, id_barrio, fecha_nac)
VALUES ('1000000028', 'Jorge', 'Pineda', 'M', 2.8, 'ADM', 5, DATE '2004-04-16');

INSERT INTO usr_admin_uni.alumnos (ced_alumno, nombre, apellido, genero, promedio, cod_carrera, id_barrio, fecha_nac)
VALUES ('1000000029', 'Manuela', 'Suarez', 'F', 4.7, 'SIS', 6, DATE '2003-06-29');

INSERT INTO usr_admin_uni.alumnos (ced_alumno, nombre, apellido, genero, promedio, cod_carrera, id_barrio, fecha_nac)
VALUES ('1000000030', 'Samuel', 'Galvis', 'M', 3.9, 'MED', 8, DATE '2001-12-24');

INSERT INTO usr_admin_uni.alumnos (ced_alumno, nombre, apellido, genero, promedio, cod_carrera, id_barrio, fecha_nac)
VALUES ('1000000031', 'Luisa', 'Florez', 'F', 3.4, 'DER', 1, DATE '2004-09-08');

INSERT INTO usr_admin_uni.alumnos (ced_alumno, nombre, apellido, genero, promedio, cod_carrera, id_barrio, fecha_nac)
VALUES ('1000000032', 'Esteban', 'Acosta', 'M', 4.1, 'IND', 7, DATE '2003-01-31');

INSERT INTO usr_admin_uni.alumnos (ced_alumno, nombre, apellido, genero, promedio, cod_carrera, id_barrio, fecha_nac)
VALUES ('1000000033', 'Sara', 'Restrepo', 'F', NULL, 'ENF', 2, DATE '2005-04-04');

INSERT INTO usr_admin_uni.alumnos (ced_alumno, nombre, apellido, genero, promedio, cod_carrera, id_barrio, fecha_nac)
VALUES ('1000000034', 'Tomas', 'Velez', 'M', 3.2, 'SIS', 3, DATE '2002-05-12');

INSERT INTO usr_admin_uni.alumnos (ced_alumno, nombre, apellido, genero, promedio, cod_carrera, id_barrio, fecha_nac)
VALUES ('1000000035', 'Antonia', 'Cruz', 'F', 4.3, 'ADM', 4, DATE '2003-08-19');

INSERT INTO usr_admin_uni.alumnos (ced_alumno, nombre, apellido, genero, promedio, cod_carrera, id_barrio, fecha_nac)
VALUES ('1000000036', 'Julian', 'Zapata', 'M', 3.8, 'CON', 5, DATE '2004-11-27');

INSERT INTO usr_admin_uni.alumnos (ced_alumno, nombre, apellido, genero, promedio, cod_carrera, id_barrio, fecha_nac)
VALUES ('1000000037', 'Melissa', 'Ospina', 'F', 2.6, 'IND', 6, DATE '2002-02-22');

INSERT INTO usr_admin_uni.alumnos (ced_alumno, nombre, apellido, genero, promedio, cod_carrera, id_barrio, fecha_nac)
VALUES ('1000000038', 'Kevin', 'Arango', 'M', 4.5, 'MED', 1, DATE '2003-10-15');

INSERT INTO usr_admin_uni.alumnos (ced_alumno, nombre, apellido, genero, promedio, cod_carrera, id_barrio, fecha_nac)
VALUES ('1000000039', 'Veronica', 'Duarte', 'F', 3.5, 'SIS', 8, DATE '2004-03-18');

INSERT INTO usr_admin_uni.alumnos (ced_alumno, nombre, apellido, genero, promedio, cod_carrera, id_barrio, fecha_nac)
VALUES ('1000000040', 'Ricardo', 'Mejia', 'M', 3, 'DER', 2, DATE '2001-09-09');

INSERT INTO usr_admin_uni.alumnos (ced_alumno, nombre, apellido, genero, promedio, cod_carrera, id_barrio, fecha_nac)
VALUES ('1000000041', 'Diana', 'Quintero', 'F', 4.2, 'ENF', 7, DATE '2005-07-26');

INSERT INTO usr_admin_uni.alumnos (ced_alumno, nombre, apellido, genero, promedio, cod_carrera, id_barrio, fecha_nac)
VALUES ('1000000042', 'Oscar', 'Salazar', 'M', 3.7, 'ADM', 3, DATE '2003-05-03');

INSERT INTO usr_admin_uni.alumnos (ced_alumno, nombre, apellido, genero, promedio, cod_carrera, id_barrio, fecha_nac)
VALUES ('1000000043', 'Lina', 'Gonzalez', 'F', 4.4, 'IND', 4, DATE '2002-11-11');

INSERT INTO usr_admin_uni.alumnos (ced_alumno, nombre, apellido, genero, promedio, cod_carrera, id_barrio, fecha_nac)
VALUES ('1000000044', 'Hector', 'Beltran', 'M', 2.9, 'SIS', 5, DATE '2004-12-05');

INSERT INTO usr_admin_uni.alumnos (ced_alumno, nombre, apellido, genero, promedio, cod_carrera, id_barrio, fecha_nac)
VALUES ('1000000045', 'Paola', 'Cifuentes', 'F', 3.9, 'MED', 6, DATE '2003-02-27');

INSERT INTO usr_admin_uni.alumnos (ced_alumno, nombre, apellido, genero, promedio, cod_carrera, id_barrio, fecha_nac)
VALUES ('1000000046', 'Fabian', 'Rincon', 'M', 4, 'CON', 1, DATE '2002-08-14');

INSERT INTO usr_admin_uni.alumnos (ced_alumno, nombre, apellido, genero, promedio, cod_carrera, id_barrio, fecha_nac)
VALUES ('1000000047', 'Monica', 'Escobar', 'F', 3.3, 'DER', NULL, DATE '2004-07-21');

INSERT INTO usr_admin_uni.alumnos (ced_alumno, nombre, apellido, genero, promedio, cod_carrera, id_barrio, fecha_nac)
VALUES ('1000000048', 'Cristian', 'Mora', 'M', 4.6, 'ENF', 2, DATE '2005-10-02');

INSERT INTO usr_admin_uni.alumnos (ced_alumno, nombre, apellido, genero, promedio, cod_carrera, id_barrio, fecha_nac)
VALUES ('1000000049', 'Adriana', 'Bermudez', 'F', 3.1, 'ADM', 7, DATE '2003-04-30');

INSERT INTO usr_admin_uni.alumnos (ced_alumno, nombre, apellido, genero, promedio, cod_carrera, id_barrio, fecha_nac)
VALUES ('1000000050', 'Ivan', 'Sanchez', 'M', 4.2, 'IND', 3, DATE '2002-06-18');
