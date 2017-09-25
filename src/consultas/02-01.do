* Macros auxiliares y objetos temporales
local id "02-01"
tempfile df

*===============================================================================
* Panel N°1 - Empresas
*===============================================================================

* Especificación
.table = .ol_table.new
.table.cmds       = "{total _counter} {proportion _tamano_empresa}"
.table.cmds_lb    = "{1: N} {2: %}"
.table.cmds_fmt   = "{%15,0fc} {%15,1fc}"
.table.years      = "2015"
.table.months     = "0"
.table.subpops    = "{}"
.table.subpops_lb = "{1: Empresas}"
.table.by         = "_tamano_empresa"
.table.along      = "_rama1_v1"
.table.margins    = "{_rama1_v1} {_tamano_empresa}"
.table.margins_lb = "{Nacional} {Total}"
.table.src        = "sii"
.table.from       = "$datos"
.table.varlist0   = "_rama1_v1 _tamano_empresa"

* Estimación
.table.create
save `df', replace

*===============================================================================
* Panel N°2 - Ocupados
*===============================================================================

* Especificación
.table = .ol_table.new
.table.cmds       = "{total _counter}"
.table.cmds_lb    = "{1: N}"
.table.cmds_fmt   = "{%15,1fc}"
.table.years      = "2015"
.table.months     = "2(3)11"
.table.subpops    = "{if (_ocupado == 1) & (_tamano_empresa != 0)}"
.table.subpops_lb = "{2: Ocupados}"
.table.by         = "_tamano_empresa"
.table.along      = "_rama1_v1"
.table.margins    = "{_tamano_empresa} {_rama1_v1}"
.table.margins_lb = "{Total} {Nacional}"
.table.src        = "ene"
.table.from       = "$datos"
.table.varlist0   = "_ocupado _rama1_v1 _tamano_empresa"

* Estimación
.table.create
.table.annualize
.table.add_proportions, cmd_lb("2: %") cmd_fmt("%15,1fc")
.table.add_asterisks

* Consolidación
append2 using `df'
save "$proyecto/data/consultas/`id'.dta", replace
