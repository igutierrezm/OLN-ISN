* Macros auxiliares
local id "05-09"

* Especificación
.table = .ol_table.new
.table.cmds       = "{total _counter} {proportion _educ}"
.table.cmds_lb    = "{N} {%}"
.table.years      = "2016"
.table.months     = "2 5 8 11"
.table.subpops    = "."
.table.subpops_lb = "{Ocupados}"
.table.by         = "_educ"
.table.along      = "_rama1_v1 _oficio1"
.table.aggregate  = "{_educ} {_oficio1} {_educ _oficio1}"
.table.src        = "ene"
.table.from       = "$datos"
.table.varlist0   = "_educ _ocupado _oficio1 _rama1_v1"

* Estimación
drop _all
tempfile df
save `df', emptyok
forvalues i = 1(1)13 {
  .table.subpops = "{if (_ocupado == 1) & (_rama1_v1 == `i')}"
  .table.create
  append using `df'
  save `df', replace
}
save "$proyecto/data/consultas/`id'.dta", replace
