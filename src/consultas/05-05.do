* Macros auxiliares
local id "05-05"

* Especificación
.table = .ol_table.new
.table.cmds       = "{mean _yprincipal}"
.table.cmds_lb    = "{Ingreso promedio ocupación principal (M$)}"
.table.years      = "2010 2015"
.table.months     = ""
.table.subpops    = "{if (_ocupado == 1)}"
.table.subpops_lb = "{Ocupados}"
.table.by         = ""
.table.along      = "_educ _rama1_v1"
.table.aggregate  = "{_educ} {_rama1_v1} {_educ _rama1_v1}"
.table.src        = "esi"
.table.from       = "$datos"
.table.varlist0   = "_educ _mantuvo_empleo _ocupado _rama1_v1 _yprincipal"

* Estimación
.table.create
save "$proyecto/data/consultas/`id'.dta", replace
