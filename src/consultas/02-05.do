* Macros auxiliares y objetos temporales
local id "02-05"

* Especificación
.table = .ol_table.new
.table.cmds       = "{total _counter}"
.table.cmds_lb    = "{0: N}"
.table.cmds_fmt   = "{%15,0fc}"
.table.years      = "2016"
.table.months     = "2 5 8 11"
.table.subpops    = "{if _ocupado == 1}"
.table.subpops_lb = "{1: Ocupados}"
.table.by         = "_educ"
.table.along      = "_rama1_v1 _tamano_empresa"
.table.margins    = "{_tamano_empresa} {_educ} {_rama1_v1}"
.table.margins_lb = "{Total} {Total} {Nacional}"
.table.src        = "ene"
.table.from       = "$datos"
.table.varlist0   = "_educ _ocupado _rama1_v1 _tamano_empresa"

* Estimación
.table.create
.table.annualize
.table.add_proportions, cmd_lb("1: %") cmd_fmt("%15,1fc") replace
.table.add_asterisks

* Otros ajustes
drop if (_rama1_v1 == .z) & (_tamano_empresa != .z)

* BBDD final
save "$proyecto/data/consultas/`id'.dta", replace
