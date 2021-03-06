* Macros auxiliares y objetos temporales
local id "01-09"

* Especificación
.table = .ol_table.new
.table.cmds       = "{total _counter}"
.table.cmds_lb    = "{1: N (en miles)}"
.table.cmds_fmt   = "{%15,1fc}"
.table.years      = "2010(1)2016"
.table.months     = "1(1)12"
.table.subpops    = "{if (_ocupado == 1)}"
.table.subpops_lb = "{1: Ocupados}"
.table.by         = "_cise_v3"
.table.along      = "_rama1_v1"
.table.margins    = ""
.table.margins_lb = ""
.table.src        = "ene"
.table.from       = "$datos"
.table.varlist0   = "_cise_v3 _ocupado _rama1_v1"

* Estimación
.table.create
.table.add_asterisks

* Otros ajustes
replace bh = bh / 1000
keep if inrange(_cise_v3, 2, 5)

* BBDD final
save "$proyecto/data/consultas/`id'", replace
