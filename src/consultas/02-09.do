* Macros auxiliares
local id   "02-09"
local temp "_tamaño_empresa_v1"

* Panel N°1 - Especificación
.table = .ol_table.new
.table.cmds       = "{total _counter}"
.table.cmds_lb    = "{N}"
.table.years      = "2010 2015"
.table.months     = "2 5 8 11"
.table.subpops    = "{if (_ocupado == 1)}"
.table.subpops_lb = "{Ocupados}"
.table.by         = "_exceso_hr_int"
.table.along      = "`temp' _rama1_v1"
.table.aggregate  = "{_rama1_v1} {`temp'} {_rama1_v1 `temp'}"
.table.src        = "ene"
.table.from       = "$datos"
.table.varlist0   = "_exceso_hr_int _ocupado _rama1_v1 `temp'"

* Panel N°1 - Estimación
.table.create
save "$proyecto/data/consultas/`id'.dta", replace
