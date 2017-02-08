* Macros auxiliares
local id "05-01"

* Especificación
.table = .ol_table.new
.table.cmds       = "{total _counter} {proportion _cise_v3}"
.table.cmds_lb    = "{N} {%}"
.table.years      = "2010 2016"
.table.months     = "2 5 8 11"
.table.subpops    = "{if (_ocupado == 1)}"
.table.subpops_lb = "{Ocupados}"
.table.by         = "_cise_v3"
.table.along      = "_rama1_v1"
.table.aggregate  = "{_cise_v3} {_rama1_v1} {_cise_v3 _rama1_v1}"
.table.src        = "ene"
.table.from       = "$datos"
.table.varlist0   = "_cise_v3 _ocupado _rama1_v1"

* Estimación
.table.create
save "$proyecto/data/consultas/`id'.dta", replace
