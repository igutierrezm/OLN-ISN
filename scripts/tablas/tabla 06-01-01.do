** Especificación de la tabla (verbal)
  * indicadores  : número y distribución
  * subpoblación : ocupados
  * por          : oficio
  * según        : año (2011-2015), sector
  * agregaciones : "oficio", "sector", "oficio sector"
  * fuente       : CASEN

** Especificación de la Tabla (Stata)
  .tabla = .ol_table.new
  * Estadísticas
  .tabla.cmds      = `""total _counter" "proportion _oficio1""'
  .tabla.masks     = `""n" "%""'
  * Dominios
  .tabla.years     = "2011 2013 2015"
  .tabla.months    = "0"
  .tabla.subpop    = "if _ocupado == 1"
  .tabla.over      = "_rama1_v1 _oficio1"
  .tabla.aggregate = `""_oficio1" "_rama1_v1" "_oficio1 _rama1_v1""'
  * I-O
  .tabla.src       = "casen"
  .tabla.path      = "$datos/CASEN"
  .tabla.pattern   = "CASEN <año>.dta"
  .tabla.varlist0  = "_ocupado _oficio1 _rama1_v1"

** Creación:
.tabla.create
