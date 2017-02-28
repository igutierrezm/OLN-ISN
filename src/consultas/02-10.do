/* * Macros auxiliares y objetos temporales
local id "02-10"
local temp "_tamaño_empresa"

* Especificación
.table = .ol_table.new
.table.cmds       = "{mean _yprincipal}"
.table.cmds_lb    = "{1: $}"
.table.cmds_fmt   = "{%15,0fc}"
.table.years      = "2015"
.table.months     = ""
.table.subpops    = "{if _asalariado == 1}"
.table.subpops_lb = "{1: Asalariados}"
.table.by         = ""
.table.along      = "_rama1_v1 `temp' _educ _mujer"
.table.margins    = "{_educ}"
.table.margins_lb = "{Total}"
.table.src        = "esi"
.table.from       = "$datos"
.table.varlist0   = "_asalariado _educ _mujer _rama1_v1 `temp' _yprincipal"

* Estimación
.table.create
.table.add_asterisks
save "$proyecto/data/consultas/`id'.dta", replace */
