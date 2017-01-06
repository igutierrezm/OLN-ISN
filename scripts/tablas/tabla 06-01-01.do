** Especificación de la tabla (verbal)
  * indicadores  : número y distribución
  * subpoblación : ocupados del sector
  * por          : oficio
  * según        : año (2011-2015)
  * agregaciones : "oficio"
  * fuente       : CASEN

** Especificación de la Tabla (Stata)
  .tabla = .table.new
  * Estadísticas
  .tabla.cmds      = `""total _counter" "proportion _oficio1""'
  .tabla.masks     = `""n" "%""'
  * Dominios
  .tabla.years     = "2011 2013 2015"
  .tabla.months    = "0"
  .tabla.subpop    = "if (_rama1_v1 == $sector)"
  .tabla.over      = "_oficio1"
  .tabla.aggregate = `""_oficio1""'
  * I-O
  .tabla.src       = "casen"
  .tabla.path      = "$datos/CASEN"
  .tabla.pattern   = "CASEN <año>.dta"
  .tabla.varlist0  = "_ocupado _oficio1 _rama1_v1"

** Creación:
.tabla.create
