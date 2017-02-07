* Macros auxiliares
local id "05-05"

* Especificación
.table = .ol_table.new
.table.cmds       = "{mean _yprincipal}"
.table.cmds_lb    = "{M$}"
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















/*
* Estructura
.table.rowvar    = "_educ"
.table.colvar    = "_rama1_v1 año"

* Exportación
keep if inlist(_rama1_v1, $sector, 1e6)
.table.export_excel bh, file("$proyecto/data/tabla 05-05.xlsx")
.table.export_excel cv, file("$proyecto/data/tabla 05-05.xlsx")
*/
