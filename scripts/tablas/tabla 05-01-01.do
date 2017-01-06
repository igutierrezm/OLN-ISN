** Descripción de la Tabla (verbal)
  * indicadores  : número y distribución
  * subpoblación : ocupados
  * por          : cise (distinguiendo el tipo de contrato)
  * según        : año (2010 vs 2015), sector, tipo de jornada
  * agregaciones : "cise", "sector", "cise y sector"
  * fuente       : ENE

** Especificación de la Tabla (Stata)
.tabla = .ol_table.new
  * Estadísticas
  .tabla.cmds      = `""total _counter" "proportion _cise_v3""'
  .tabla.masks     = `""n" "%""'
  * Dominios
  .tabla.years     = "2015"
  .tabla.months    = "2 5 8 11"
  .tabla.subpop    = "if _ocupado == 1"
  .tabla.over      = "_rama1_v1 _jparcial _cise_v3"
  .tabla.aggregate = `""_cise_v3" "_rama1_v1" "_cise_v3 _rama1_v1""'
  * I-O
  .tabla.src       = "ene"
  .tabla.path      = "$datos/ENE"
  .tabla.pattern   = "ENE <año> <mes>.dta"
  .tabla.varlist0  = "_cise_v3 _counter _jparcial _ocupado _rama1_v1"

** Creación:
.tabla.create
.tabla.annualize
