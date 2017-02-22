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
