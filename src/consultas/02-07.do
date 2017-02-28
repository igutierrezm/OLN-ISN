* Macros auxiliares y objetos temporales
local id "02-07"

* Especificación
.table = .ol_table.new
.table.cmds       = "{mean _yprincipal}"
.table.cmds_lb    = "{1: $}"
.table.cmds_fmt   = "{%15,0fc}"
.table.years      = "2015"
.table.months     = ""
.table.subpops    = "{if _ocupado == 1}"
.table.subpops_lb = "{1: Ocupados}"
.table.by         = ""
.table.along      = "_rama1_v1 _tamaño_empresa _cise_v3"
.table.margins    = "{_tamaño_empresa} {_cise_v3}"
.table.margins_lb = "{Total} {Total}"
.table.src        = "esi"
.table.from       = "$datos"
.table.varlist0   = "_cise_v3 _ocupado _rama1_v1 _tamaño_empresa _yprincipal"

* Estimación
.table.create
.table.add_asterisks
save "$proyecto/data/consultas/`id'.dta", replace
