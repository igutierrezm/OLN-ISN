* indicadores  : ingreso promedio de la ocupación principal
* subpoblación : ocupados
* años         : 2010 y 2015
* meses        :
* por          : nivel educacional (educ)
* según        : rama1
* agregaciones : educ, rama1, educ x rama1
* fuente       : esi

* Especificación (init)
.table = .ol_table.new
  * Estadísticas
  .table.cmds      = "(mean _yprincipal)"
  .table.masks     = "M$"
	* Dominios
  .table.years     = "2010 2015"
  .table.months    = ""
  .table.subpop    = "if (_ocupado == 1)"
	.table.by        = "_educ"
  .table.along     = "_rama1_v1"
  .table.aggregate = "(_educ) (_rama1_v1) (_educ _rama1_v1)"
  * Estructura
  .table.rowvar    = "_educ"
  .table.colvar    = "_rama1_v1 año"
  * I-O
  .table.src       = "esi"
	.table.varlist0  = "_educ _mantuvo_empleo _ocupado _rama1_v1 _yprincipal"

* Estimación
.table.create
save "$proyecto/data/tabla 05-05.dta", replace

* Exportación
keep if inlist(_rama1_v1, $sector, 1e6)
.table.export_excel bh, file("$proyecto/data/tabla 05-05.xlsx")
.table.export_excel cv, file("$proyecto/data/tabla 05-05.xlsx")
