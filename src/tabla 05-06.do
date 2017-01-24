* indicador 1  : % de ocupados con subempleo involuntario
* indicador 2  : % de ocupados que trabajan horas excesivas
* subpoblación : ocupados del sector
* años         : 2010 y 2015
* meses        :
* por          :
* según        : TEM¹ (incluyendo TCCU²)
* agregaciones : "sector"
* fuente       : ene

* Preparativos
drop _all
tempfile df
save "`df'", emptyok

* Especificación (init)
.table = .ol_table.new
  * Estadísticas
  .table.cmds      = `""'
  .table.masks     = `""'
	* Dominios
  .table.years     = "2010 2015"
  .table.months    = "2 5 8 11"
  .table.subpop    = "if (_ocupado == 1) & inlist(_rama1_v1, $sector, 1e6)"
	.table.by        = ""
  .table.along     = "_cise_v4 _rama1_v1"
  .table.aggregate = `""_cise_v4" "_rama1_v1" "_cise_v4 _rama1_v1""'
  * Estructura
  .table.rowvar    = "_cise_v4"
  .table.colvar    = "_rama1_v1 año panel"
  * I-O
  .table.src       = "ene"
	.table.varlist0  = "_cise_v4 _exceso_hr_int _jparcial_inv _ocupado _rama1_v1"

* Estimación
forvalues i = 1(1)2 {
  local var : word `i' of _jparcial_inv _exceso_hr_int
  * Especificación
  .table.cmds      = `""proportion `var'""'
  .table.by        = "`var'"
  .table.masks     = "%"
  * Estimación
  .table.create
  .table.annualize
  * Anexsión
  rename `var' categoria
  generate panel = `i'
  append using "`df'"
  save "`df'", replace
}

* Etiquetado
label define panel 1 "Subempleo",       modify
label define panel 2 "Horas excesivas", modify
label values panel panel

* GUardado
save "$proyecto/data/tabla 05-04", replace

* Exportación
keep if categoria == 1
.table.export_excel bh, file("tabla 05-06")
.table.export_excel cv, file("tabla 05-06")
