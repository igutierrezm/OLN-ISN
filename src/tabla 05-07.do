* indicadores  : distribución de ocupados
* subpoblación : ocupados
* años         : 2010 y 2015
* meses        :
* por          : oficio
* según        : rama1
* agregaciones : oficio, rama1, oficio x rama1
* fuente       : esi

* Especificación
.table = .ol_table.new
  * Estadísticas
  .table.cmds      = "(proportion _oficio1)"
  .table.masks     = "%"
	* Dominios
  .table.years     = "2010 2015"
  .table.months    = "2 5 8 11"
  .table.subpop    = "if _ocupado == 1"
	.table.by        = "_oficio1"
  .table.along     = "_rama1_v1"
  .table.aggregate = "(_oficio1) (_rama1_v1) (_oficio1 _rama1_v1)"
  * Estructura
  .table.rowvar    = "_oficio1"
  .table.colvar    = "_rama1_v1 año"
  * I-O
  .table.src       = "ene"
	.table.varlist0  = "_ocupado _oficio1 _rama1_v1"

* Estimación
.table.create
.table.annualize
save "$proyecto/data/tabla 05-07.dta", replace

* Exportación
keep if inlist(_rama1_v1, $sector, 1e6)
.table.export_excel bh, file("$proyecto/data/tabla 05-07.xlsx")
.table.export_excel cv, file("$proyecto/data/tabla 05-07.xlsx")
