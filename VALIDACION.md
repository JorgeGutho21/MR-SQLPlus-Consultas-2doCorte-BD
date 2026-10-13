# Validación de la revisión — 13 de octubre de 2026

La plataforma existente se conservó y se corrigió sobre el commit b4ce59d. La carpeta anterior estaba limpia y en ese mismo commit; los temporales p4_ex.js, p4_sql.js, p3_core.js y patch_v8.js no estaban en el proyecto recuperado.

## Modelo y SQL

- Cuatro ejercicios y 39 módulos conservados.
- 165 filas: tipos y longitudes, cantidad de columnas, PK simples/compuestas, UNIQUE y referencias FK comprobadas.
- 53 archivos SQL/resúmenes regenerados desde los generadores de index.html y contrastados exactamente.
- 42 preguntas de consulta, con 43 SELECT en total, ejecutadas sobre los datos en SQLite, adaptando DATE y TO_CHAR de Oracle.
- 14 INSERT inválidos rechazados por restricciones de integridad. Los DELETE del laboratorio se explican como denegados por privilegios; SQLite no certifica esos permisos de Oracle.
- Secuencia de tablas, PK, FK, restricciones, usuarios, permisos y datos revisada en los scripts completos.
- COLOR y PAIS_ORIGEN ausentes de los scripts principales de Vehículos. Las ampliaciones quedan únicamente en la explicación.
- Contraseñas solicitadas con ACCEPT HIDE; SPOOL en pausa, VERIFY OFF y UNDEFINE. Las entradas de la interfaz solo viven en memoria.

## Navegador

Pruebas en Chrome con Playwright:

- Navegación de los 39 módulos; ocho pestañas y cinco vistas de cada ejercicio.
- 32 diagramas inspeccionados con comprobación de límites SVG, sin textos fuera de su viewBox.
- 16 estados de intersección y seis comparaciones de diseños.
- Selección de FK por teclado: origen, ambas tablas y relación resaltados. Ampliar y reducir comprobados.
- Evaluación, cambio de tema y persistencia tras recargar.
- Anchos de 1440, 1024, 768 y 390 px; navegación móvil y ausencia de desbordamiento horizontal de la página. Los diagramas y tablas grandes disponen de desplazamiento interno.
- 53 descargas obtenidas con sus nombres y contrastadas con los archivos generados.
- Sin errores JavaScript en las pruebas.
- html-validate con configuración recommended: sin errores en el documento HTML estático. El JavaScript inline se compiló con Node vm.Script.

## Límite de las pruebas

**No se ejecutó Oracle Database 18c ni se tocó una instalación Oracle.** La revisión de sintaxis y permisos es estática, contrastada con las referencias oficiales de CREATE TABLE y restricciones. SQLite comprueba los datos y la lógica de consultas, pero no certifica los comandos de SQL*Plus, tablespaces, administración de usuarios ni privilegios Oracle.

Las salidas actualizadas de ejercicios se identifican como resultados esperados, calculados con los datos. Las capturas históricas de consultas HR se conservan como ejemplos históricos, sin afirmar que se volvieron a ejecutar en esta revisión.

## Repetir las comprobaciones

```shell
node tools/build-scripts.cjs --check
node tools/validate.cjs models.json
python tools/validate-data.py models.json expected.json
node tools/update-results.cjs expected.json --check
npx --yes --package html-validate html-validate index.html
```

Para actualizar resultados después de cambiar los datos, ejecutar update-results sin --check y repetir las pruebas.
