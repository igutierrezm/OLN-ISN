* Macros auxiliares
local id "01-07"

* Especificación
.table = .ol_table.new
.table.cmds       = "{total _counter}"
.table.cmds_lb    = "{n. (en miles)}"
.table.years      = "2010 2011 2012 2013 2014 2015"
.table.months     = "1 2 3 4 5 6 7 8 9 10 11 12"
.table.subpops    = "{if (_ocupado == 1)}"
.table.subpops_lb = "{Ocupados}"
.table.by         = ""
.table.along      = "_rama1_v1"
.table.aggregate  = "{_rama1_v1}"
.table.src        = "ene"
.table.from       = "$datos"
.table.varlist0   = "_ocupado _rama1_v1"

* Estimación
.table.create
replace bh = bh / 1000^1
replace o2 = bh / 1000^2
save "$proyecto/data/consultas/`id'", replace


















/*
* Estructura
.table.rowvar    = "año mes"
.table.colvar    = "_rama1_v1"


* Exportación
.table.export_excel bh, file("tabla 01-07")
.table.export_excel cv, file("tabla 01-07")
*/
