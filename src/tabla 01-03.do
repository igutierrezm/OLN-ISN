* indicadores  : porcentaje de cesantes
* subpoblación : pea
* años         : 2010 y 2015
* meses        : 1-12
* por          : nivel educacional (educ)
* según        : sector
* agregaciones : "educ", "sector", "educ x sector"
* fuente       : ene

* Especificación
.table = .ol_table.new
  * Estadísticas
  .table.cmds      = "{proportion _cesante}"
  .table.masks     = "{%}"
  * Dominios
  .table.years     = "2010 2011 2012 2013 2014 2015"
  .table.months    = "1 2 3 4 5 6 7 8 9 10 11 12"
  .table.subpops   = "{if (_pea == 1) & inlist(_rama1_v1, $sector, 1e6)}"
  .table.by        = "_cesante"
  .table.along     = "_rama1_v1"
  .table.aggregate = "{_rama1_v1}"
  * Estructura
  .table.rowvar    = "año mes"
  .table.colvar    = "_rama1_v1"
  * I-O
  .table.src       = "ene"
  .table.varlist0  = "_cesante _pea _rama1_v1"

* Estimación
.table.create
lval_ene_mes
save "$proyecto/data/tabla 01-03", replace

* Exportación
keep if _cesante == 1
.table.export_excel bh, file("tabla 01-03")
.table.export_excel cv, file("tabla 01-03")
