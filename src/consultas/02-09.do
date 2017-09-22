* Macros auxiliares y objetos temporales
local id "02-09"

* Especificación
.table = .ol_table.new
.table.cmds       = "{total _counter}"
.table.cmds_lb    = "{1: N}"
.table.cmds_fmt   = "{%15,1fc}"
.table.years      = "2016"
.table.months     = "2(3)11"
.table.subpops    = "{if (_ocupado == 1)}"
.table.subpops_lb = "{1: Ocupados}"
.table.by         = "_exceso_hr_int"
.table.along      = "_tamano_empresa _rama1_v1"
.table.margins    = "{_rama1_v1} {_tamano_empresa}"
.table.margins_lb = "{Nacional} {Total}"
.table.src        = "ene"
.table.from       = "$datos"
.table.varlist0   = "_exceso_hr_int _ocupado _rama1_v1 _tamano_empresa"

* Estimación
.table.create
.table.annualize
.table.add_proportions, cmd_lb("2: %") cmd_fmt("%15,1fc")
.table.add_asterisks
keep if (cmd_lb == 2) & (_exceso_hr_int == 1)
save "$proyecto/data/consultas/`id'.dta", replace
