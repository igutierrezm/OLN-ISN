* indicadores  : ingreso promedio de la ocupación principal
* subpoblación : ocupados
* años         : 2010 y 2015
* meses        :
* por          : nivel educacional (educ)
* según        : sector
* agregaciones : "educ", "sector", "educ x sector"
* fuente       : esi

* Especificación (init)
.table = .ol_table.new
  * Estadísticas
  .table.cmds      = `""mean _yprincipal""'
  .table.masks     = "promedio yopr (M$)"
	* Dominios
  .table.years     = "2010 2015"
  .table.months    = ""
  .table.subpop    = "if (_ocupado == 1) & (_mantuvo_empleo == 1)"
	.table.by        = "_educ"
  .table.along     = "_rama1_v1"
  .table.aggregate = `""_educ" "_rama1_v1" "_educ _rama1_v1""'
  * Estructura
  .table.rowvar    = "_educ"
  .table.colvar    = "_rama1_v1 año"
  * I-O
  .table.src       = "esi"
	.table.varlist0  = "_educ _mantuvo_empleo _ocupado _rama1_v1 _yprincipal"

* Estimación
.table.create
save "$proyecto/data/tabla 05-05", replace

* Exportación
keep if inlist(_rama1_v1, $sector, 1e6)
.table.export_excel bh, file("tabla 05-05")
.table.export_excel cv, file("tabla 05-05")
