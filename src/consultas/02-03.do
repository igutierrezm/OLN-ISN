* Macros auxiliares
local id   "02-03"
local temp "_tamaño_empresa_v1"

* Especificación
.table = .ol_table.new
.table.cmds       = "{total _counter}"
.table.cmds_lb    = "{N}"
.table.years      = "2010 2011 2012 2013 2014 2015 2016"
.table.months     = "2 5 8 11"
.table.subpops    = "{if _ocupado == 1}"
.table.subpops_lb = "{Ocupados}"
.table.by         = ""
.table.along      = "_rama1_v1 `temp'"
.table.aggregate  = "{_rama1_v1} {`temp'} {_rama1_v1 `temp'}"
.table.src        = "ene"
.table.from       = "$datos"
.table.varlist0   = "_ocupado _rama1_v1 `temp'"

* Estimación
.table.create
save "$proyecto/data/consultas/`id'.dta", replace
