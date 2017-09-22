* Macros auxiliares y objetos temporales
local id "02-07"

* Especificación
.table = .ol_table.new
.table.cmds       = "{mean _yprincipal}"
.table.cmds_lb    = "{1: $}"
.table.cmds_fmt   = "{%15,1fc}"
.table.years      = "2016"
.table.months     = "0"
.table.subpops    = "{if (_mantuvo_empleo == 1)}"
.table.subpops_lb = "{1: Ocupados que mantuvieron su empleo}"
.table.by         = ""
.table.along      = "_rama1_v1 _tamano_empresa _cise_v3"
.table.margins    = "{_tamano_empresa} {_cise_v3}"
.table.margins_lb = "{Total} {Total}"
.table.src        = "esi"
.table.from       = "$datos"
.table.varlist0   = "_cise_v3 _mantuvo_empleo _rama1_v1 _tamano_empresa _yprincipal"

* Estimación
.table.create
.table.add_asterisks
save "$proyecto/data/consultas/`id'.dta", replace
