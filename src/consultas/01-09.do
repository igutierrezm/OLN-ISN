* Macros auxiliares
local id "01-09"

* Especificación
.table = .ol_table.new
.table.cmds       = "{total _counter}"
.table.cmds_lb    = "{N}"
.table.years      = "2010 2011 2012 2013 2014 2015 2016"
.table.months     = "1 2 3 4 5 6 7 8 9 10 11 12"
.table.subpops    = "{if (_ocupado == 1)}"
.table.subpops_lb = "{Ocupados}"
.table.by         = "_cise_v2"
.table.along      = "_rama1_v1"
.table.aggregate  = ""
.table.src        = "ene"
.table.from       = "$datos"
.table.varlist0   = "_cise_v2 _ocupado _rama1_v1"

* Estimación
.table.create
save "$proyecto/data/consultas/`id'", replace
