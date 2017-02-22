* Macros auxiliares
local id "04-04"

* Especificación
.table = .ol_table.new
.table.cmds       = "{total _counter} {proportion _conmutante_v1}"
.table.cmds_lb    = "{N} {%}"
.table.years      = "2010 2016"
.table.months     = "2 5 8 11"
.table.subpops    = "{if _ocupado == 1}"
.table.subpops_lb = "{Ocupados}"
.table.by         = "_conmutante_v1"
.table.along      = "_rama1_v1"
.table.aggregate  = "{_rama1_v1}"
.table.src        = "ene"
.table.from       = "$datos"
.table.varlist0   = "_conmutante_v1 _ocupado _rama1_v1"

* Estimación
.table.create
save "$proyecto/data/consultas/`id'.dta", replace
