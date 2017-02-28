* Macros auxiliares y objetos temporales
local id "01-09"

* Especificación
.table = .ol_table.new
.table.cmds       = "{proportion _cise_v2}"
.table.cmds_lb    = "{1: %}"
.table.cmds_fmt   = "{%15,0fc}"
.table.years      = "2010 2011 2012 2013 2014 2015 2016"
.table.months     = "1 2 3 4 5 6 7 8 9 10 11 12"
.table.subpops    = "{if (_ocupado == 1)}"
.table.subpops_lb = "{1: Ocupados}"
.table.by         = "_cise_v2"
.table.along      = "_rama1_v1"
.table.margins    = ""
.table.margins_lb = ""
.table.src        = "ene"
.table.from       = "$datos"
.table.varlist0   = "_cise_v2 _ocupado _rama1_v1"

* Estimación
.table.create
.table.add_asterisks
save "$proyecto/data/consultas/`id'", replace
