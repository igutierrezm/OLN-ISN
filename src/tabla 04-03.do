* indicadores  : distribución de ocupados
* subpoblación : ocupados
* años         : 2010 y 2015
* meses        :
* por          : nivel educacional (educ)
* según        : sector
* agregaciones : "educ", "sector", "educ x sector"
* fuente       : ene

* Especificación
.table = .ol_table.new
  * Estadísticas
  .table.cmds      = "(proportion _educ)"
  .table.masks     = "%"
  * Dominios
  .table.years     = "2010 2015"
  .table.months    = "2 5 8 11"
  .table.subpop    = "if _ocupado == 1"
  .table.by        = "_educ"
  .table.along     = "_rama1_v1"
  .table.aggregate = "(_educ) (_rama1_v1) (_educ _rama1_v1)"
  * Estructura
  .table.rowvar    = "_educ"
  .table.colvar    = "_rama1_v1 año"
  * I-O
  .table.src       = "ene"
  .table.varlist0  = "_educ _ocupado _rama1_v1"

* Estimación
.table.create
.table.annualize
save "$proyecto/data/tabla 04-03.dta", replace

* Exportación
keep if inlist(_rama1_v1, $sector, 1e6)
.table.export_excel bh, file("$proyecto/data/tabla 04-03.xlsx")
.table.export_excel cv, file("$proyecto/data/tabla 04-03.xlsx")
