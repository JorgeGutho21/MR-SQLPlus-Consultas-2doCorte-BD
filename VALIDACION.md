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

## Ejecución real en Oracle XE 18c

La versión publicada después de esta revisión se ejecutó en Oracle Database XE 18c (PDB XEPDB1, SQL*Plus), con objetos de prueba propios y limpieza al final. No se modificaron usuarios, tablas ni tablespaces preexistentes de la instalación; HR solo se consultó.

- Los cuatro ejercicios completos, en sus seis etapas: tablespace, administrador, tablas, PK/FK/UNIQUE/CHECK, usuario de consultas, permisos, INSERT, COMMIT y consultas. Resultado: sin problemas.
- Los 53 archivos descargables en sus tres formas: `_00_completo`, el trío `_01`/`_02`/`_03` y `_paso1` a `_paso7`. Ninguna contraseña aparece en la salida ni en la evidencia del SPOOL.
- Vehículos: pruebas intencionales ORA-02291, ORA-02290 (modelo), ORA-02290 (sexo), ORA-00001 y ORA-01031. Consultas: 8 cilindrajes distintos, 4 propietarios F y 4 M, 3 vehículos de 2000 cc o más.
- Laboratorio de errores: 64 casos, cada uno con su código ORA o SP2 esperado.
- Laboratorios de privilegios, sentencias SQL (tabla de demostración propia), IDENTITY/SK y HR (solo lectura).

Las salidas de consultas y errores que muestra la página son las capturadas en esa ejecución. El comando `node tools/build-scripts.cjs --check` confirma que los 53 archivos de `scripts/` coinciden con los generadores de index.html.

## Límite de las pruebas

SQLite (sección anterior) comprueba datos y lógica de consultas, pero no certifica SQL*Plus, tablespaces, usuarios ni privilegios. Esos puntos quedan cubiertos por la ejecución en Oracle descrita arriba.

## Repetir las comprobaciones

```shell
node tools/build-scripts.cjs --check
node tools/validate.cjs models.json
python tools/validate-data.py models.json expected.json
node tools/update-results.cjs expected.json --check
npx --yes --package html-validate html-validate index.html
```

Para actualizar resultados después de cambiar los datos, ejecutar update-results sin --check y repetir las pruebas.
