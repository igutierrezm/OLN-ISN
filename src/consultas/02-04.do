* Macros auxiliares y objetos temporales
local id "02-04"
tempfile df

* Especificación
.table = .ol_table.new
.table.cmds       = "{total _counter}"
.table.cmds_lb    = "{1: N}"
.table.cmds_fmt   = "{%15,1fc}"
.table.years      = "2016"
.table.months     = "2(3)11"
.table.subpops    = "{if (_ocupado == 1)}"
.table.subpops_lb = "{1: Ocupados}"
.table.by         = "_tamano_empresa"
.table.along      = "_rama1_v1 _region_tr_v1"
.table.margins    = "{_region_tr_v1} {_tamano_empresa}"
.table.margins_lb = "{Sector} {Total}"
.table.src        = "ene"
.table.from       = "$datos"
.table.varlist0   = "_ocupado _rama1_v1 _region_tr_v1 _tamano_empresa"

* Estimación
.table.create
.table.annualize
.table.add_proportions, cmd_lb("2: %") cmd_fmt("%15,1fc")
.table.add_asterisks
keep if (cmd_lb == 2)

save "$proyecto/data/consultas/`id'.dta", replace
* El cuadro tiene demasiadas categorías para hacerlo de una pasada en mi PC
