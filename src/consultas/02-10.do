/* * Macros auxiliares y objetos temporales
local id "02-10"
local varlist "_rama1_v1 _educ _tamano_empresa"

* Especificación
.table = .ol_table.new
.table.cmds       = "{mean _yprincipal}"
.table.cmds_lb    = "{1: $}"
.table.cmds_fmt   = "{%15,1fc}"
.table.years      = "2016"
.table.months     = "0"
.table.subpops    = "{if (_asalariado == 1) & (_mantuvo_empleo == 1)}"
.table.subpops_lb = "{1: Asalariados}"
.table.by         = ""
.table.along      = "`varlist' _mujer"
.table.margins    = "{_educ}"
.table.margins_lb = "{Total}"
.table.src        = "esi"
.table.from       = "$datos"
.table.varlist0   = "_asalariado _mantuvo_empleo _mujer _yprincipal `varlist'"

* Estimación
.table.create
.table.add_asterisks
*bysort `varlist' : replace bh = 100 * (bh[_n] - bh[_n - 1]) / bh[_n - 1]
save "$proyecto/data/consultas/`id'.dta", replace */
