* Macros auxiliares y objetos temporales
local id "05-04"
local cmd_lb1 "Formalidad de la unidad económica"
local cmd_lb2 "Cotización previsional"
local cmd_lb3 "Cotización de salud"
tempfile df

* Loop principal
drop _all
local i = 1
save `df', emptyok
foreach var in "_boleta" "_cotiza_pension" "_cotiza_salud" {
  * Especificación
  .table = .ol_table.new
  .table.cmds       = "{proportion `var'}"
  .table.cmds_lb    = "{`i': `cmd_lb`i''}"
  .table.cmds_fmt   = "{%15,1fc}"
  .table.years      = "2010(1)2016"
  .table.months     = "2(3)11"
  .table.subpops    = "{if inlist(_cise_v1, 1, 2)}"
  .table.subpops_lb = "{1: Trabajadores Independientes}"
  .table.by         = "`var'"
  .table.along      = "_rama1_v1 _cise_v1"
  .table.margins    = "{_rama1_v1}"
  .table.margins_lb = "{Nacional}"
  .table.src        = "casen"
  .table.from       = "$datos"
	.table.varlist0   = "_cise_v1 _rama1_v1 `var'"

  * Estimación
	.table.create
  .table.add_asterisks
  keep if (`var' == 1)
  drop `var'
  append2 using `df'
  save `df', replace
  local ++i
}
save "$proyecto/data/consultas/`id'.dta", replace
