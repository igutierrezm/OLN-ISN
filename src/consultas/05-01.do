* Macros auxiliares y objetos temporales
local id "05-01"

* Especificación
.table = .ol_table.new
.table.cmds       = "{total _counter}"
.table.cmds_lb    = "{1: N}"
.table.cmds_fmt   = "{%15,0fc}"
.table.years      = "2010 2016"
.table.months     = "2(3)11"
.table.subpops    = "{if (_ocupado == 1)}"
.table.subpops_lb = "{1: Ocupados}"
.table.by         = "_cise_v3"
.table.along      = "_rama1_v1"
.table.margins    = "{_cise_v3} {_rama1_v1}"
.table.margins_lb = "{Total} {Nacional}"
.table.src        = "ene"
.table.from       = "$datos"
.table.varlist0   = "_cise_v3 _ocupado _rama1_v1"

* Estimación
.table.create
.table.annualize
.table.add_proportions, cmd_lb("2: %") cmd_fmt("%15,1fc")
.table.add_asterisks
keep if (cmd_lb == 2)
save "$proyecto/data/consultas/`id'.dta", replace
