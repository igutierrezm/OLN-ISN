* Macros auxiliares
local id "05-06"

* Especificación
.table = .ol_table.new
.table.cmds       = "."
.table.cmds_lb    = "{N} {%}"
.table.years      = "2010 2016"
.table.months     = "2 5 8 11"
.table.subpops    = "{if (_ocupado == 1)}"
.table.subpops_lb = "{Ocupados}"
.table.by         = "."
.table.along      = "_rama1_v1 _cise_v1"
.table.aggregate  = "{_cise_v1} {_rama1_v1} {_cise_v1 _rama1_v1}"
.table.src        = "ene"
.table.from       = "$datos"
.table.varlist0   = "."

* Estimación
forvalues i = 1(1)2 {
  local var : word `i' of "_jparcial_inv" "_exceso_hr_int"
  .table.varlist0 = "_cise_v1 _ocupado _rama1_v1 `var'"
  .table.cmds     = "{total _counter} {proportion `var'}"
  .table.by       = "`var'"
  .table.create
  save "$proyecto/data/consultas/`id' [`i'].dta", replace
}
