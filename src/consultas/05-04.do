* Macros auxiliares
local id "05-04"

* Especificación
.table = .ol_table.new
.table.cmds       = "."
.table.cmds_lb    = "{N} {%}"
.table.years      = "2015"
.table.months     = ""
.table.subpops    = "{if inlist(_cise_v1, 1, 2)}"
.table.subpops_lb = "{Trabajadores Independientes}"
.table.by         = "."
.table.along      = "_rama1_v1 _cise_v1"
.table.aggregate  = "{_rama1_v1}"
.table.src        = "casen"
.table.from       = "$datos"
.table.varlist0   = "."

* Estimación
forvalues i = 1(1)3 {
  local var : word `i' of "_boleta" "_cotiza_pension" "_cotiza_salud"
  .table.by       = "`var'"
  .table.cmds     = "{total _counter} {proportion `var'}"
	.table.varlist0 = "_cise_v1 _rama1_v1 `var'"
	.table.create
  save "$proyecto/data/consultas/`id' [`i'].dta", replace
}
















/*

.table.rowvar     = "cmd_lb"
.table.colvar     = "_rama1_v1 _cise_v1"



clear all
save `df', emptyok
foreach var in "_boleta" "_cotiza_pension" "_cotiza_salud" {
  * Especificación
  .table.by       = "`var'"
  .table.cmds     = "{proportion `var'}"
	.table.varlist0 = "_cise_v1 _rama1_v1 `var'"
	* Estimación
	.table.create
  .table.annualize
  * Homologación
  rename `var' categoria
  replace cmd_lb = `i'
  * Anexión
  local ++i
  append using `df'
  save `df', replace
}

* Etiquetado
label variable cmd_lb "% de trabajadores independientes que ..."
label define cmd_lb                                    ///
  1 "... están entregando boleta o factura"          ///
  2 "... están cotizando en el sistema previsional"  ///
  3 "... están cotizando en el sistema de salud",    ///
  modify
label values cmd_lb cmd_lb

* GUardado
save "$proyecto/data/tabla 05-04.dta", replace

* Exportación
keep if inlist(_rama1_v1, $sector, 1e6) & (categoria == 1)
.table.export_excel bh, file("$proyecto/data/tabla 05-04.xlsx")
.table.export_excel cv, file("$proyecto/data/tabla 05-04.xlsx")
*/
