* indicadores  :
*   1. % de trabajadores independientes que dan boleta.
*   2. % de trabajadores independientes que cotiza en el sistema previsional
*   3. % de trabajadores independientes que cotiza en el sistema de salud
* subpoblación : ocupados independientes
* años         : 2010 y 2015
* meses        :
* por          :
* según        : rama1
* agregaciones : rama1
* fuente       : CASEN

* Preparativos
drop _all
tempfile df
save `df', emptyok

* Especificación
.table = .ol_table.new
  * Estadísticas
  .table.cmds      = "[delayed]"
  .table.cmds_lb   = "{%}"
  * Dominios
  .table.years     = "2015"
  .table.months    = "11"
  .table.subpops   = "{if inlist(_cise_v1, 1, 2)}"
	.table.by        = "[delayed]"
  .table.along     = "_rama1_v1 _cise_v1"
  .table.aggregate = "{_rama1_v1}"
  * Estructura
  .table.rowvar    = "cmd_lb"
  .table.colvar    = "_rama1_v1 _cise_v1"
  * I-O
  .table.src       = "casen"
  .table.from      = "$datos"
	.table.varlist0  = "[delayed]"

* Estimación
local i = 1
foreach var in _boleta _cotiza_pension _cotiza_salud {
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
