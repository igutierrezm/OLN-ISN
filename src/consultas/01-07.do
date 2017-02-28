* Macros auxiliares y objetos temporales
local id "01-07"

* Especificación
.table = .ol_table.new
.table.cmds       = "{total _counter}"
.table.cmds_lb    = "{1: n. (en miles)}"
.table.cmds_fmt   = "{%15,0fc}"
.table.years      = "2010 2011 2012 2013 2014 2015 2016"
.table.months     = "1 2 3 4 5 6 7 8 9 10 11 12"
.table.subpops    = "{if (_ocupado == 1)}"
.table.subpops_lb = "{1: Ocupados}"
.table.by         = ""
.table.along      = "_rama1_v1"
.table.margins    = "{_rama1_v1}"
.table.margins_lb = "{Nacional}"
.table.src        = "ene"
.table.from       = "$datos"
.table.varlist0   = "_ocupado _rama1_v1"

* Estimación
.table.create
.table.add_asterisks
replace bh = bh / 1000^1
replace o2 = o2 / 1000^2
save "$proyecto/data/consultas/`id'", replace
