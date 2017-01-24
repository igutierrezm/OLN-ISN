* indicadores  : Indicadores de formalidad del trabajo
*								(7 indicadores en total)
* subpoblación : ocupados independientes (empleadores y cta propia)
* años         : 2010 y 2015
* meses        :
* por          :
* según        : sector
* agregaciones : sector"
* fuente       : CASEN

* Preparativos
drop _all
tempfile df
save `df', emptyok

* Especificación
.table = .ol_table.new
  * Estadísticas
  .table.cmds      = ""
  .table.masks     = ""
  * Dominios
  .table.years     = "2015"
  .table.months    = "11"
  .table.subpop    = "if (_ocupado == 1) & inlist(_cise_v1, 1, 2)"
	.table.by        = ""
  .table.along     = "_rama1_v1 _cise_v1"
  .table.aggregate = "_rama1_v1"
  * Estructura
  .table.rowvar    = ""
  .table.colvar    = ""
  * I-O
  .table.src       = "casen"
	.table.varlist0  = ""

* Estimación
forvalues i = 1(1)3 {
  * Especificación
	local var : word `i' of _boleta _cotiza_pension _cotiza_salud
  .table.by       = "`var'"
  .table.cmds     = `""proportion `var'""'
	.table.varlist0 = "_cise_v1 _ocupado _rama1_v1 `var'"
	* Estimación
	.table.create
  .table.annualize
  * Anexión
	rename `var' categoria
	generate panel = `i'
  append using `df'
  save `df', replace
}

* Etiquetado
label define panel 1 "Formalidad de la unidad económica", modify
label define panel 2 "Cotización previsional", modify
label define panel 3 "Cotización de salud", modify
label values panel panel

* GUardado
save "$proyecto/data/tabla 05-04", replace

* Exportación
keep if inlist(_rama1_v1, $sector, 1e6) & (categoria == 1)
* Estructura
.table.rowvar = "panel"
.table.colvar = "_rama1_v1 _cise_v1"
.table.export_excel bh, file("tabla 05-04")
.table.export_excel cv, file("tabla 05-04")
