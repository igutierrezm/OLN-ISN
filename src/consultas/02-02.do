* Macros auxiliares
local id   "02-02"
local temp "_tamaño_empresa_v1"

* Panel N°1 - Especificación
.table = .ol_table.new
.table.cmds       = "{total _counter}"
.table.cmds_lb    = "{N}"
.table.years      = "2014"
.table.months     = "2 5 8 11"
.table.subpops    = "{if _ocupado == 1}"
.table.subpops_lb = "{Ocupados}"
.table.by         = "`temp'"
.table.along      = "_rama1_v1"
.table.aggregate  = "{`temp'} {_rama1_v1} {`temp' _rama1_v1}"
.table.src        = "ene"
.table.from       = "$datos"
.table.varlist0   = "_ocupado _rama1_v1 `temp'"

* Panel N°1 - Estimación
.table.create
save "$proyecto/data/consultas/`id' [1].dta", replace

* Panel N°2 - Especificación
.table = .ol_table.new
.table.cmds       = "{total _counter} {proportion `temp'}"
.table.cmds_lb    = "{N} {%}"
.table.years      = "2014"
.table.months     = ""
.table.subpops    = "{}"
.table.subpops_lb = "{Empresas}"
.table.by         = "`temp'"
.table.along      = "_rama1_v1"
.table.aggregate  = "{`temp'} {_rama1_v1} {`temp' _rama1_v1}"
.table.src        = "sii"
.table.from       = "$datos"
.table.varlist0   = "_rama1_v1 `temp'"

* Panel N°2 - Estimación
.table.create
save "$proyecto/data/consultas/`id' [2].dta", replace
