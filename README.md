# Ruta práctica Oracle

Laboratorio universitario interactivo: del **enunciado** al **modelo relacional** y a la **práctica completa en Oracle Database XE 18c con SQL*Plus**.

**Abrir la plataforma:** https://jorgegutho21.github.io/practica-oracle-amilkar/

## Contenido
1. **Fundamentos**: enunciado y reglas de negocio, entidades y atributos, niveles de modelo, relaciones y cardinalidades, claves y restricciones, árbol de decisión (¿intersección o FK?), normalización hasta 3FN y tipos de datos.
2. **Laboratorio relacional**: cuatro ejercicios con construcción progresiva en cinco vistas (enunciado analizado, modelo conceptual, cardinalidades, transformación y modelo relacional final, con elementos seleccionables), enunciado, clasificación de términos, predicción de cardinalidades, justificación de PK/FK, diagrama, modelo correcto frente a incorrecto, errores típicos, solución razonada y preguntas tipo parcial.
3. **Laboratorio SQL*Plus**: cada ejercicio completo con la Ruta práctica Oracle (SYSTEM: tablespace → usuario administrador → privilegios y tablas, PK, FK, UNIQUE/CHECK → usuario de consultas → privilegios del sistema y sobre objetos → INSERT con ESQUEMA.TABLA, COMMIT y consultas), con SPOOL sin capturar contraseñas.
4. **Consultas**: SELECT, filtros, JOIN, GROUP BY, HAVING y preguntas tipo parcial con resultados verificados.
5. **Repaso**: laboratorio de diagnóstico de errores ORA/SP2, retos de modelado, glosario, evaluación y descargas.

| Ejercicio | Tema | Esquema |
|---|---|---|
| 1 | Propietarios y vehículos | USR_ADMIN_VEH / USR_CONSULTAS_VEH |
| 2 | Sistema universitario | USR_ADMIN_UNI / USR_CONSULTAS_UNI |
| 3 | Clientes y pedidos | USR_ADMIN_PED / USR_CONSULTAS_PED |
| 4 | Personas y pasaportes vigentes | USR_ADMIN_PAS / USR_CONSULTAS_PAS |

## Scripts SQL
Carpeta [`scripts/`](scripts/): por ejercicio, un script completo (`_00_completo.sql`), uno por etapa (`_01` a `_07`), el archivo de carga cuando aplica, uno de limpieza (`_99`) y un resumen. No contienen contraseñas: SQL*Plus las pide ocultas.

## Verificación
Todos los scripts se ejecutaron en Oracle Database XE 18c (servicio XEPDB1): completos, por etapas y paso a paso. Las salidas que la página muestra como «salida real» son las obtenidas en esa ejecución, y los errores del laboratorio de diagnóstico se reprodujeron allí.

Página estática (HTML, CSS y JavaScript sin dependencias). El progreso se guarda en el navegador.
