OLN-ISN
=======

Informe Sectorial Nacional.

Intrucciones de Uso
-------------------

1. Clone los repositorios OLN-ISN y OLN-Tools.
2. Abra ``main.do`` (ubicado dentro de ``src/``) y edite las siguientes
macros globales:
  * ``$pkg``, el directorio en el cual clonó OLN-Tools.
  * ``$datos``, el directorio principal de sus BBDD (vea más abajo).
  * ``$proyecto``, el directorio en el cual clonó OLN-ISN.
  
Una vez hecho aquello, podrá replicar cualquier tabla ejecutando el _do-file_
homónimo contenido en ``src/``.

Importante
----------

Este paquete asume que las BBDD dentro de ``$datos`` se organizan como sigue:
```
$datos/
  CASEN/CASEN <año>.dta        // CASEN genérica
  ENE/ENE <año> <mes>.dta      // ENE genérica
  ESI/ESI <año> Personas.dta   // ESI genérica (Base Personas)
  PIB/
    PIB NSCO.dta     // PIB Nacional Sectorial Corriente  Original
    PIB NSEO.dta     // PIB Nacional Sectorial Encadenado Original
    PIB NSED.dta     // PIB Nacional Sectorial Encadenado Desestacionalizado
    PIB RSCO.dta     // PIB Regional Sectorial Corriente  Original
    PIB RSEO.dta     // PIB Regional Sectorial Encadenado Original
  SII/
    SII - Base empresas 2014.dta
    SII - Estadísticas según sector.dta
    SII - Estadísticas según subsector.dta
```
en donde:
- ``<año>`` representa a un año en formato ``%4d`` (por ejemplo, ``2015``).
- ``<mes>`` representa a un mes en formato ``%2d`` (por ejemplo, ``01``).
