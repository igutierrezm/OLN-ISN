* Macros auxiliares y objetos temporales
local id "04-02"

* Especificación
.table = .ol_table.new
.table.cmds       = "{total _counter}"
.table.cmds_lb    = "{1: N}"
.table.cmds_fmt   = "{%15,0fc}"
.table.years      = "2016"
.table.months     = "2(3)11"
.table.subpops    = "{if _ocupado == 1}"
.table.subpops_lb = "{1: Ocupados}"
.table.by         = "_tramo_edad_v1"
.table.along      = "_rama1_v1 _mujer"
.table.margins    = "{_mujer} {_rama1_v1} {_tramo_edad_v1}"
.table.margins_lb = "{Total} {Nacional} {Total}"
.table.src        = "ene"
.table.from       = "$datos"
.table.varlist0   = "_mujer _ocupado _rama1_v1 _tramo_edad_v1"

* Estimación
.table.create
.table.annualize
.table.add_proportions, cmd_lb("2: %") cmd_fmt("%15,1fc")
.table.add_asterisks
keep if (cmd_lb == 2)
save "$proyecto/data/consultas/`id'.dta", replace
