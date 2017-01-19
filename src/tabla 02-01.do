* indicadores  : número y distribución de ocupados y empresas
* subpoblación :
* años         : 2014
* meses        :
* por          : TEM¹ (excluyendo TCCU²)
* según        : sector
* agregaciones : "TEM", "sector", "TEM x sector"
* fuente       : ENE/SII

* Preparativos
drop _all
tempfile df
save `df', emptyok

*===============================================================================
* Panel 1. Ocupados
*===============================================================================

* Especificación
.table = .ol_table.new
  * Abreviaciones
  local tem "_tamaño_empresa"
  * Estadísticas
  .table.cmds      = `""total _counter" "proportion `tem'""'
  .table.masks     = `""n" "%""'
  * Dominios
  .table.years     = "2014"
  .table.months    = "2 5 8 11"
  .table.subpop    = "if (_ocupado == 1) & (`tem' != 0)"
  .table.by        = "`tem'"
  .table.along     = "_rama1_v1"
  .table.aggregate = `""`tem'" "_rama1_v1" "`tem' _rama1_v1""'
  * I-O
  .table.src       = "ene"
  .table.varlist0  = "_ocupado _rama1_v1 `tem'"

* Estimación
.table.create
.table.annualize
drop if (_tamaño_empresa == 0)

* Guardado
generate panel = "ocupados"
append using "`df'"
save "`df'", replace

*===============================================================================
* Panel 2. Empresas
*===============================================================================

* Especificación
.table = .ol_table.new
  * Abreviaciones
  local tem "_tamaño_empresa"
  * Estadísticas
  .table.cmds      = `""total _counter" "proportion `tem'""'
  .table.masks     = `""n" "%""'
  * Dominios
  .table.years     = "2014"
  .table.months    = ""
  .table.subpop    = ""
  .table.by        = "`tem'"
  .table.along     = "_rama1_v1"
  .table.aggregate = `""`tem'" "_rama1_v1" "`tem' _rama1_v1""'
  * I-O
  .table.src       = "sii"
  .table.varlist0  = "_rama1_v1 `tem'"

* Estimación
.table.create

* Guardado
generate panel = "empresas"
append using "`df'"
save "`df'", replace

*===============================================================================
* Exportación
*===============================================================================

* Exportación
keep if inlist(_rama1_v1, $sector, 1e6)
encode2 panel, replace
.table.rowvar = "_tamaño_empresa"
.table.colvar = "_rama1_v1 panel mask"
.table.export_excel bh, file("tabla 02-01")
.table.export_excel cv, file("tabla 02-01")

* Notas al pie
* ¹ Tamaño de empresa (de acuerdo al número de trabajadores)
* ² Trabajadores por Cuenta Propia Unipersonales
