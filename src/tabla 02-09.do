* indicadores  : % de ocupados que trabajan horas excesivas
* subpoblación : ocupados del sector
* años         : 2010 y 2015
* meses        :
* por          :
* según        : TEM¹ (incluyendo TCCU²)
* agregaciones : "sector"
* fuente       : ene

* Especificación (init)
.table = .ol_table.new
  * Abreviaciones
  local tem "_tamaño_empresa"
  * Estadísticas
  .table.cmds      = "(proportion _exceso_hr_int)"
  .table.masks     = "%"
	* Dominios
  .table.years     = "2010 2015"
  .table.months    = "2 5 8 11"
  .table.subpop    = "if (_ocupado == 1) & inlist(_rama1_v1, $sector, 1e6)"
	.table.by        = "_exceso_hr_int"
  .table.along     = "`tem' _rama1_v1"
  .table.aggregate = "(_rama1_v1) (`tem') (`tem' _rama1_v1)"
  * Estructura
  .table.rowvar    = "_tamano_empresa"
  .table.colvar    = "_rama1_v1 año"
  * I-O
  .table.src       = "ene"
	.table.varlist0  = "_exceso_hr_int _ocupado _rama1_v1 `tem'"

* Estimación
.table.create
.table.annualize
save "$proyecto/data/tabla 02-09.dta", replace

* Exportación
keep if _exceso_hr_int == 1
rename _tamaño_empresa _tamano_empresa
.table.export_excel bh, file("$proyecto/data/tabla 02-09.xlsx")
.table.export_excel cv, file("$proyecto/data/tabla 02-09.xlsx")
