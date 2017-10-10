* Macros auxiliares y objetos temporales
local id "caja de arena"
tempfile df

* Especificación
.table = .ol_table.new
.table.cmds       = "{total _counter}"
.table.cmds_lb    = "{0: N}"
.table.cmds_fmt   = "{%15,1fc}"
.table.years      = "2016"
.table.months     = "2(3)11"
.table.subpops    = "{if _region_tr_v1 == 10}"
.table.subpops_lb = "{1: Ocupados de la region}"
.table.by         = "b14"
.table.along      = ""
.table.margins    = ""
.table.margins_lb = ""
.table.src        = "ene"
.table.from       = "$datos"
.table.varlist0   = "_ocupado b14 _region_tr_v1"

* Estimación
.table.create
.table.annualize
.table.add_proportions, cmd_lb("2: %") cmd_fmt("%15,1fc")
.table.add_asterisks
keep if (cmd_lb == 2)

* Consolidación
save "$proyecto/data/consultas/`id'.dta", replace
