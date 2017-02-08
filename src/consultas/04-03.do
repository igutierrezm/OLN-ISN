* Macros auxiliares
local id "04-03"

* Especificación
.table = .ol_table.new
.table.cmds       = "{total _counter} {proportion _educ}"
.table.cmds_lb    = "{N} {%}"
.table.years      = "2010 2016"
.table.months     = "2 5 8 11"
.table.subpops    = "{if _ocupado == 1}"
.table.subpops_lb = "{Ocupados}"
.table.by         = "_educ"
.table.along      = "_rama1_v1"
.table.aggregate  = "{_educ} {_rama1_v1} {_educ _rama1_v1}"
.table.src        = "ene"
.table.from       = "$datos"
.table.varlist0   = "_educ _ocupado _rama1_v1"

* Estimación
.table.create
save "$proyecto/data/consultas/`id'.dta", replace











/*

* Estructura
.table.rowvar    = "_educ"
.table.colvar    = "_rama1_v1 año"

* Estimación
.table.create
.table.annualize
save "$proyecto/data/tabla 04-03.dta", replace

* Exportación
keep if inlist(_rama1_v1, $sector, 1e6)
.table.export_excel bh, file("$proyecto/data/tabla 04-03.xlsx")
.table.export_excel cv, file("$proyecto/data/tabla 04-03.xlsx")
*/
