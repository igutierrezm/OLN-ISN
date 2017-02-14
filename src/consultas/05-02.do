* Macros auxiliares
local id "05-02"

* Especificación
.table = .ol_table.new
.table.cmds       = "{mean _yprincipal}"
.table.cmds_lb    = "{M$}"
.table.years      = "2010 2015"
.table.months     = ""
.table.subpops    = "{if (_mantuvo_empleo == 1)}"
.table.subpops_lb = "{Ocupados que mantuvieron su empleo}"
.table.by         = ""
.table.along      = "_rama1_v1 _cise_v3"
.table.aggregate  = "{_cise_v3} {_rama1_v1} {_cise_v3 _rama1_v1}"
.table.src        = "esi"
.table.from       = "$datos"
.table.varlist0   = "_cise_v3 _mantuvo_empleo _rama1_v1 _yprincipal"

* Estimación
.table.create
save "$proyecto/data/consultas/`id'.dta", replace
