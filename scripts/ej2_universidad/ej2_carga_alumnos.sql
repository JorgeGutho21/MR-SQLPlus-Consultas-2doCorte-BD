-- ============================================================
-- ej2_carga_alumnos.sql
-- Ruta practica Oracle - Ejercicio 2: Sistema universitario
-- 50 INSERT sobre USR_ADMIN_UNI.ALUMNOS
-- Ejecutar conectado como USR_CONSULTAS_UNI (SHOW USER) con:
--   @C:\archivosbd\ej2_carga_alumnos.sql
-- Requisito: tablas padre ya cargadas. Despues se ejecuta COMMIT.
-- ============================================================
PROMPT Cargando 50 filas en USR_ADMIN_UNI.ALUMNOS ...

INSERT INTO usr_admin_uni.alumnos (ced_alumno, primer_nombre, segundo_nombre, primer_apellido, segundo_apellido, genero, promedio, cod_carrera, id_barrio, fecha_nac)
VALUES ('1000000001', 'Ana', NULL, 'Martinez', NULL, 'F', 4.5, 'SIS', 1, DATE '2003-04-12');

INSERT INTO usr_admin_uni.alumnos (ced_alumno, primer_nombre, segundo_nombre, primer_apellido, segundo_apellido, genero, promedio, cod_carrera, id_barrio, fecha_nac)
VALUES ('1000000002', 'Carlos', NULL, 'Gomez', NULL, 'M', 3.8, 'SIS', 3, DATE '2002-09-30');

INSERT INTO usr_admin_uni.alumnos (ced_alumno, primer_nombre, segundo_nombre, primer_apellido, segundo_apellido, genero, promedio, cod_carrera, id_barrio, fecha_nac)
VALUES ('1000000003', 'Laura', NULL, 'Rodriguez', NULL, 'F', 4.2, 'MED', 2, DATE '2004-01-25');

INSERT INTO usr_admin_uni.alumnos (ced_alumno, primer_nombre, segundo_nombre, primer_apellido, segundo_apellido, genero, promedio, cod_carrera, id_barrio, fecha_nac)
VALUES ('1000000004', 'Andres', NULL, 'Lopez', NULL, 'M', 3.1, 'IND', 5, DATE '2001-11-08');

INSERT INTO usr_admin_uni.alumnos (ced_alumno, primer_nombre, segundo_nombre, primer_apellido, segundo_apellido, genero, promedio, cod_carrera, id_barrio, fecha_nac)
VALUES ('1000000005', 'Valentina', NULL, 'Garcia', NULL, 'F', 4.8, 'MED', 4, DATE '2005-06-17');

INSERT INTO usr_admin_uni.alumnos (ced_alumno, primer_nombre, segundo_nombre, primer_apellido, segundo_apellido, genero, promedio, cod_carrera, id_barrio, fecha_nac)
VALUES ('1000000006', 'Juan', NULL, 'Hernandez', NULL, 'M', 2.9, 'ADM', 6, DATE '2003-02-14');

INSERT INTO usr_admin_uni.alumnos (ced_alumno, primer_nombre, segundo_nombre, primer_apellido, segundo_apellido, genero, promedio, cod_carrera, id_barrio, fecha_nac)
VALUES ('1000000007', 'Camila', NULL, 'Torres', NULL, 'F', 3.6, 'ENF', 1, DATE '2004-08-03');

INSERT INTO usr_admin_uni.alumnos (ced_alumno, primer_nombre, segundo_nombre, primer_apellido, segundo_apellido, genero, promedio, cod_carrera, id_barrio, fecha_nac)
VALUES ('1000000008', 'Santiago', NULL, 'Ramirez', NULL, 'M', 4, 'SIS', 7, DATE '2002-12-21');

INSERT INTO usr_admin_uni.alumnos (ced_alumno, primer_nombre, segundo_nombre, primer_apellido, segundo_apellido, genero, promedio, cod_carrera, id_barrio, fecha_nac)
VALUES ('1000000009', 'Sofia', NULL, 'Vargas', NULL, 'F', NULL, 'SIS', 2, DATE '2005-03-09');

INSERT INTO usr_admin_uni.alumnos (ced_alumno, primer_nombre, segundo_nombre, primer_apellido, segundo_apellido, genero, promedio, cod_carrera, id_barrio, fecha_nac)
VALUES ('1000000010', 'Mateo', NULL, 'Castro', NULL, 'M', 3.4, 'CON', 3, DATE '2003-07-27');

INSERT INTO usr_admin_uni.alumnos (ced_alumno, primer_nombre, segundo_nombre, primer_apellido, segundo_apellido, genero, promedio, cod_carrera, id_barrio, fecha_nac)
VALUES ('1000000011', 'Isabella', NULL, 'Rojas', NULL, 'F', 4.1, 'DER', 5, DATE '2004-10-11');

INSERT INTO usr_admin_uni.alumnos (ced_alumno, primer_nombre, segundo_nombre, primer_apellido, segundo_apellido, genero, promedio, cod_carrera, id_barrio, fecha_nac)
VALUES ('1000000012', 'Sebastian', NULL, 'Moreno', NULL, 'M', 2.7, 'IND', 8, DATE '2001-05-19');

INSERT INTO usr_admin_uni.alumnos (ced_alumno, primer_nombre, segundo_nombre, primer_apellido, segundo_apellido, genero, promedio, cod_carrera, id_barrio, fecha_nac)
VALUES ('1000000013', 'Mariana', NULL, 'Jimenez', NULL, 'F', 3.9, 'ADM', 4, DATE '2003-12-02');

INSERT INTO usr_admin_uni.alumnos (ced_alumno, primer_nombre, segundo_nombre, primer_apellido, segundo_apellido, genero, promedio, cod_carrera, id_barrio, fecha_nac)
VALUES ('1000000014', 'Daniel', NULL, 'Ortiz', NULL, 'M', NULL, 'MED', 6, DATE '2005-09-14');

INSERT INTO usr_admin_uni.alumnos (ced_alumno, primer_nombre, segundo_nombre, primer_apellido, segundo_apellido, genero, promedio, cod_carrera, id_barrio, fecha_nac)
VALUES ('1000000015', 'Gabriela', NULL, 'Ruiz', NULL, 'F', 4.6, 'CON', 7, DATE '2002-03-28');

INSERT INTO usr_admin_uni.alumnos (ced_alumno, primer_nombre, segundo_nombre, primer_apellido, segundo_apellido, genero, promedio, cod_carrera, id_barrio, fecha_nac)
VALUES ('1000000016', 'Nicolas', NULL, 'Gutierrez', NULL, 'M', 3.3, 'SIS', 1, DATE '2004-06-06');

INSERT INTO usr_admin_uni.alumnos (ced_alumno, primer_nombre, segundo_nombre, primer_apellido, segundo_apellido, genero, promedio, cod_carrera, id_barrio, fecha_nac)
VALUES ('1000000017', 'Paula', NULL, 'Mendoza', NULL, 'F', 3.7, 'DER', 2, DATE '2003-09-22');

INSERT INTO usr_admin_uni.alumnos (ced_alumno, primer_nombre, segundo_nombre, primer_apellido, segundo_apellido, genero, promedio, cod_carrera, id_barrio, fecha_nac)
VALUES ('1000000018', 'Felipe', NULL, 'Silva', NULL, 'M', 4.3, 'ENF', 3, DATE '2002-01-15');

INSERT INTO usr_admin_uni.alumnos (ced_alumno, primer_nombre, segundo_nombre, primer_apellido, segundo_apellido, genero, promedio, cod_carrera, id_barrio, fecha_nac)
VALUES ('1000000019', 'Daniela', NULL, 'Rios', NULL, 'F', NULL, 'ADM', NULL, DATE '2005-11-30');

INSERT INTO usr_admin_uni.alumnos (ced_alumno, primer_nombre, segundo_nombre, primer_apellido, segundo_apellido, genero, promedio, cod_carrera, id_barrio, fecha_nac)
VALUES ('1000000020', 'Alejandro', NULL, 'Pardo', NULL, 'M', 2.5, 'IND', 5, DATE '2004-02-10');

INSERT INTO usr_admin_uni.alumnos (ced_alumno, primer_nombre, segundo_nombre, primer_apellido, segundo_apellido, genero, promedio, cod_carrera, id_barrio, fecha_nac)
VALUES ('1000000021', 'Natalia', NULL, 'Cardenas', NULL, 'F', 4.9, 'MED', 6, DATE '2001-08-18');

INSERT INTO usr_admin_uni.alumnos (ced_alumno, primer_nombre, segundo_nombre, primer_apellido, segundo_apellido, genero, promedio, cod_carrera, id_barrio, fecha_nac)
VALUES ('1000000022', 'David', NULL, 'Guerrero', NULL, 'M', 3.5, 'DER', 4, DATE '2003-03-05');

INSERT INTO usr_admin_uni.alumnos (ced_alumno, primer_nombre, segundo_nombre, primer_apellido, segundo_apellido, genero, promedio, cod_carrera, id_barrio, fecha_nac)
VALUES ('1000000023', 'Juliana', NULL, 'Herrera', NULL, 'F', 3.2, 'SIS', 7, DATE '2004-05-23');

INSERT INTO usr_admin_uni.alumnos (ced_alumno, primer_nombre, segundo_nombre, primer_apellido, segundo_apellido, genero, promedio, cod_carrera, id_barrio, fecha_nac)
VALUES ('1000000024', 'Miguel', NULL, 'Navarro', NULL, 'M', 4.4, 'CON', 1, DATE '2002-07-07');

INSERT INTO usr_admin_uni.alumnos (ced_alumno, primer_nombre, segundo_nombre, primer_apellido, segundo_apellido, genero, promedio, cod_carrera, id_barrio, fecha_nac)
VALUES ('1000000025', 'Carolina', NULL, 'Medina', NULL, 'F', 3, 'IND', 2, DATE '2003-11-13');

INSERT INTO usr_admin_uni.alumnos (ced_alumno, primer_nombre, segundo_nombre, primer_apellido, segundo_apellido, genero, promedio, cod_carrera, id_barrio, fecha_nac)
VALUES ('1000000026', 'Diego', NULL, 'Aguilar', NULL, 'M', 3.6, 'ENF', 3, DATE '2005-01-20');

INSERT INTO usr_admin_uni.alumnos (ced_alumno, primer_nombre, segundo_nombre, primer_apellido, segundo_apellido, genero, promedio, cod_carrera, id_barrio, fecha_nac)
VALUES ('1000000027', 'Andrea', NULL, 'Castillo', NULL, 'F', 4, 'CON', 4, DATE '2002-10-01');

INSERT INTO usr_admin_uni.alumnos (ced_alumno, primer_nombre, segundo_nombre, primer_apellido, segundo_apellido, genero, promedio, cod_carrera, id_barrio, fecha_nac)
VALUES ('1000000028', 'Jorge', NULL, 'Pineda', NULL, 'M', 2.8, 'ADM', 5, DATE '2004-04-16');

INSERT INTO usr_admin_uni.alumnos (ced_alumno, primer_nombre, segundo_nombre, primer_apellido, segundo_apellido, genero, promedio, cod_carrera, id_barrio, fecha_nac)
VALUES ('1000000029', 'Manuela', NULL, 'Suarez', NULL, 'F', 4.7, 'SIS', 6, DATE '2003-06-29');

INSERT INTO usr_admin_uni.alumnos (ced_alumno, primer_nombre, segundo_nombre, primer_apellido, segundo_apellido, genero, promedio, cod_carrera, id_barrio, fecha_nac)
VALUES ('1000000030', 'Samuel', NULL, 'Galvis', NULL, 'M', 3.9, 'MED', 8, DATE '2001-12-24');

INSERT INTO usr_admin_uni.alumnos (ced_alumno, primer_nombre, segundo_nombre, primer_apellido, segundo_apellido, genero, promedio, cod_carrera, id_barrio, fecha_nac)
VALUES ('1000000031', 'Luisa', NULL, 'Florez', NULL, 'F', 3.4, 'DER', 1, DATE '2004-09-08');

INSERT INTO usr_admin_uni.alumnos (ced_alumno, primer_nombre, segundo_nombre, primer_apellido, segundo_apellido, genero, promedio, cod_carrera, id_barrio, fecha_nac)
VALUES ('1000000032', 'Esteban', NULL, 'Acosta', NULL, 'M', 4.1, 'IND', 7, DATE '2003-01-31');

INSERT INTO usr_admin_uni.alumnos (ced_alumno, primer_nombre, segundo_nombre, primer_apellido, segundo_apellido, genero, promedio, cod_carrera, id_barrio, fecha_nac)
VALUES ('1000000033', 'Sara', NULL, 'Restrepo', NULL, 'F', NULL, 'ENF', 2, DATE '2005-04-04');

INSERT INTO usr_admin_uni.alumnos (ced_alumno, primer_nombre, segundo_nombre, primer_apellido, segundo_apellido, genero, promedio, cod_carrera, id_barrio, fecha_nac)
VALUES ('1000000034', 'Tomas', NULL, 'Velez', NULL, 'M', 3.2, 'SIS', 3, DATE '2002-05-12');

INSERT INTO usr_admin_uni.alumnos (ced_alumno, primer_nombre, segundo_nombre, primer_apellido, segundo_apellido, genero, promedio, cod_carrera, id_barrio, fecha_nac)
VALUES ('1000000035', 'Antonia', NULL, 'Cruz', NULL, 'F', 4.3, 'ADM', 4, DATE '2003-08-19');

INSERT INTO usr_admin_uni.alumnos (ced_alumno, primer_nombre, segundo_nombre, primer_apellido, segundo_apellido, genero, promedio, cod_carrera, id_barrio, fecha_nac)
VALUES ('1000000036', 'Julian', NULL, 'Zapata', NULL, 'M', 3.8, 'CON', 5, DATE '2004-11-27');

INSERT INTO usr_admin_uni.alumnos (ced_alumno, primer_nombre, segundo_nombre, primer_apellido, segundo_apellido, genero, promedio, cod_carrera, id_barrio, fecha_nac)
VALUES ('1000000037', 'Melissa', NULL, 'Ospina', NULL, 'F', 2.6, 'IND', 6, DATE '2002-02-22');

INSERT INTO usr_admin_uni.alumnos (ced_alumno, primer_nombre, segundo_nombre, primer_apellido, segundo_apellido, genero, promedio, cod_carrera, id_barrio, fecha_nac)
VALUES ('1000000038', 'Kevin', NULL, 'Arango', NULL, 'M', 4.5, 'MED', 1, DATE '2003-10-15');

INSERT INTO usr_admin_uni.alumnos (ced_alumno, primer_nombre, segundo_nombre, primer_apellido, segundo_apellido, genero, promedio, cod_carrera, id_barrio, fecha_nac)
VALUES ('1000000039', 'Veronica', NULL, 'Duarte', NULL, 'F', 3.5, 'SIS', 8, DATE '2004-03-18');

INSERT INTO usr_admin_uni.alumnos (ced_alumno, primer_nombre, segundo_nombre, primer_apellido, segundo_apellido, genero, promedio, cod_carrera, id_barrio, fecha_nac)
VALUES ('1000000040', 'Ricardo', NULL, 'Mejia', NULL, 'M', 3, 'DER', 2, DATE '2001-09-09');

INSERT INTO usr_admin_uni.alumnos (ced_alumno, primer_nombre, segundo_nombre, primer_apellido, segundo_apellido, genero, promedio, cod_carrera, id_barrio, fecha_nac)
VALUES ('1000000041', 'Diana', NULL, 'Quintero', NULL, 'F', 4.2, 'ENF', 7, DATE '2005-07-26');

INSERT INTO usr_admin_uni.alumnos (ced_alumno, primer_nombre, segundo_nombre, primer_apellido, segundo_apellido, genero, promedio, cod_carrera, id_barrio, fecha_nac)
VALUES ('1000000042', 'Oscar', NULL, 'Salazar', NULL, 'M', 3.7, 'ADM', 3, DATE '2003-05-03');

INSERT INTO usr_admin_uni.alumnos (ced_alumno, primer_nombre, segundo_nombre, primer_apellido, segundo_apellido, genero, promedio, cod_carrera, id_barrio, fecha_nac)
VALUES ('1000000043', 'Lina', NULL, 'Gonzalez', NULL, 'F', 4.4, 'IND', 4, DATE '2002-11-11');

INSERT INTO usr_admin_uni.alumnos (ced_alumno, primer_nombre, segundo_nombre, primer_apellido, segundo_apellido, genero, promedio, cod_carrera, id_barrio, fecha_nac)
VALUES ('1000000044', 'Hector', NULL, 'Beltran', NULL, 'M', 2.9, 'SIS', 5, DATE '2004-12-05');

INSERT INTO usr_admin_uni.alumnos (ced_alumno, primer_nombre, segundo_nombre, primer_apellido, segundo_apellido, genero, promedio, cod_carrera, id_barrio, fecha_nac)
VALUES ('1000000045', 'Paola', NULL, 'Cifuentes', NULL, 'F', 3.9, 'MED', 6, DATE '2003-02-27');

INSERT INTO usr_admin_uni.alumnos (ced_alumno, primer_nombre, segundo_nombre, primer_apellido, segundo_apellido, genero, promedio, cod_carrera, id_barrio, fecha_nac)
VALUES ('1000000046', 'Fabian', NULL, 'Rincon', NULL, 'M', 4, 'CON', 1, DATE '2002-08-14');

INSERT INTO usr_admin_uni.alumnos (ced_alumno, primer_nombre, segundo_nombre, primer_apellido, segundo_apellido, genero, promedio, cod_carrera, id_barrio, fecha_nac)
VALUES ('1000000047', 'Monica', NULL, 'Escobar', NULL, 'F', 3.3, 'DER', NULL, DATE '2004-07-21');

INSERT INTO usr_admin_uni.alumnos (ced_alumno, primer_nombre, segundo_nombre, primer_apellido, segundo_apellido, genero, promedio, cod_carrera, id_barrio, fecha_nac)
VALUES ('1000000048', 'Cristian', NULL, 'Mora', NULL, 'M', 4.6, 'ENF', 2, DATE '2005-10-02');

INSERT INTO usr_admin_uni.alumnos (ced_alumno, primer_nombre, segundo_nombre, primer_apellido, segundo_apellido, genero, promedio, cod_carrera, id_barrio, fecha_nac)
VALUES ('1000000049', 'Adriana', NULL, 'Bermudez', NULL, 'F', 3.1, 'ADM', 7, DATE '2003-04-30');

INSERT INTO usr_admin_uni.alumnos (ced_alumno, primer_nombre, segundo_nombre, primer_apellido, segundo_apellido, genero, promedio, cod_carrera, id_barrio, fecha_nac)
VALUES ('1000000050', 'Ivan', NULL, 'Sanchez', NULL, 'M', 4.2, 'IND', 3, DATE '2002-06-18');
