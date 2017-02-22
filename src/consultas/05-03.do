* Macros auxiliares
local id "05-03"

* Especificación
.table = .ol_table.new
.table.cmds       = "."
.table.cmds_lb    = "{N}"
.table.years      = "2010 2016"
.table.months     = "2 5 8 11"
.table.subpops    = "{if _asalariado == 1}"
.table.subpops_lb = "{Asalariados}"
.table.by         = "."
.table.along      = "_rama1_v1"
.table.aggregate  = "{_rama1_v1}"
.table.src        = "ene"
.table.from       = "$datos"
.table.varlist0   = "_asalariado _rama1_v1 _b7"

* Estimación
forvalues i = 1(1)7 {
  .table.by   = "_b7_`i'"
  .table.cmds = "{total _counter}"
  .table.create
  save "$proyecto/data/consultas/`id' [`i'].dta", replace
}
