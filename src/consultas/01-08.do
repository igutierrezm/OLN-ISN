* Macros auxiliares y objetos temporales
local id "01-08"

* Especificación
.table = .ol_table.new
.table.cmds       = "{total _counter}"
.table.cmds_lb    = "{1: %}"
.table.cmds_fmt   = "{%15,1fc}"
.table.years      = "2010(1)2016"
.table.months     = "1(1)12"
.table.subpops    = "{if (_ocupado == 1)}"
.table.subpops_lb = "{1: Ocupados}"
.table.by         = ""
.table.along      = "_rama1_v1"
.table.margins    = "{_rama1_v1}"
.table.margins_lb = "{Nacional}"
.table.src        = "ene"
.table.from       = "$datos"
.table.varlist0   = "_ocupado _rama1_v1"

* Estimación
.table.create
.table.add_asterisks
sort _rama1_v1 año mes
by _rama1_v1 : generate delta = 100 * (bh[_n] - bh[_n - 12]) / bh[_n - 12]
replace bh = delta

* Guardado
drop delta
keep if (bh != .)
save "$proyecto/data/consultas/`id'.dta", replace
