* Macros auxiliares y objetos temporales
local id "01-03"

* Especificación
.table = .ol_table.new
.table.cmds       = "{proportion _cesante}"
.table.cmds_lb    = "{1: %}"
.table.cmds_fmt   = "{%15,1fc}"
.table.years      = "2010(1)2016"
.table.months     = "1(1)12"
.table.subpops    = "{if inrange(cae_general, 1, 4)}"
.table.subpops_lb = "{1: pea}"
.table.by         = "_cesante"
.table.along      = "_rama1_v1"
.table.margins    = "{_rama1_v1}"
.table.margins_lb = "{Nacional}"
.table.src        = "ene"
.table.from       = "$datos"
.table.varlist0   = "cae_general _cesante _rama1_v1"

* Estimación
.table.create
.table.add_asterisks
keep if (_cesante == 1)
save "$proyecto/data/consultas/`id'", replace
