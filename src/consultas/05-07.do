* Macros auxiliares
local id "05-07"

* Especificación
.table = .ol_table.new
.table.cmds       = "{total _counter} {proportion _oficio1}"
.table.cmds_lb    = "{N} {%}"
.table.years      = "2010 2016"
.table.months     = "2 5 8 11"
.table.subpops    = "{if _ocupado == 1}"
.table.subpops_lb = "{Ocupados}"
.table.by         = "_oficio1"
.table.along      = "_rama1_v1"
.table.aggregate  = "{_oficio1} {_rama1_v1} {_oficio1 _rama1_v1}"
.table.src        = "ene"
.table.from       = "$datos"
.table.varlist0   = "_ocupado _oficio1 _rama1_v1"

* Estimación
.table.create
save "$proyecto/data/consultas/`id'.dta", replace
