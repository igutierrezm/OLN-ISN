* Macros auxiliares
local id "01-03"

* Especificación
.table = .ol_table.new
.table.cmds       = "{proportion _cesante}"
.table.cmds_lb    = "{%}"
.table.years      = "2010 2011 2012 2013 2014 2015 2016"
.table.months     = "1 2 3 4 5 6 7 8 9 10 11 12"
.table.subpops    = "{if (_pea == 1)}"
.table.subpops_lb = "{pea}"
.table.by         = "_cesante"
.table.along      = "_rama1_v1"
.table.aggregate  = "{_rama1_v1}"
.table.src        = "ene"
.table.from       = "$datos"
.table.varlist0   = "_cesante _pea _rama1_v1"

* Estimación
.table.create
save "$proyecto/data/consultas/`id'", replace













/*
* Estructura
.table.rowvar    = "año mes"
.table.colvar    = "_rama1_v1"

* Exportación
keep if _cesante == 1
.table.export_excel bh, file("tabla 01-03")
.table.export_excel cv, file("tabla 01-03")
*/
