* Macros auxiliares y objetos temporales
local id "04-05"

* Especificación
.table = .ol_table.new
.table.cmds       = "{mean _edad}"
.table.cmds_lb    = "{1: Edad promedio}"
.table.cmds_fmt   = "{%15,1fc}"
.table.years      = "2010(1)2016"
.table.months     = "1(1)12"
.table.subpops    = "{if (_ocupado == 1)}"
.table.subpops_lb = "{1: Ocupados}"
.table.by         = ""
.table.along      = "_mujer _rama1_v1"
.table.margins    = "{_mujer} {_rama1_v1}"
.table.margins_lb = "{Total} {Nacional}"
.table.src        = "ene"
.table.from       = "$datos"
.table.varlist0   = "_edad _mujer _ocupado _rama1_v1"

* Estimación
.table.create
.table.add_asterisks
save "$proyecto/data/consultas/`id'", replace
