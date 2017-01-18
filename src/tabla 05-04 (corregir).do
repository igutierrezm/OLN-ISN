* indicadores  : Indicadores de formalidad del trabajo
*								(7 indicadores en total)
* subpoblación : ocupados independientes (empleadores y cta propia)
* años         : 2010 y 2015
* meses        :
* por          :
* según        : sector
* agregaciones : sector"
* fuente       : CASEN

* Especificación (init)
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
  .table.rowvar    = "mask"
  .table.colvar    = "_rama1_v1 _cise_v1"
  * I-O
  .table.src       = "casen"
	.table.varlist0  = ""

* Estimación
drop _all
tempfile df
save `df', emptyok
forvalues i = 1(1)3 {
  * Especificación (act)
	local var : word `i' of _boleta _cotiza_pension _cotiza_salud
  .table.cmds     = `""proportion `var'""'
  .table.by       = "`var'"
	.table.varlist0 = "_cise_v1 _ocupado _rama1_v1 `var'"
	* Estimación
	.table.create
  .table.annualize
  * Anexión
	drop `var'
	replace mask = `i'
  append using `df'
  save `df', replace
}

* Etiquetado
label define mask 1 "Formalidad de la unidad económica", modify
label define mask 2 "Cotización previsional", modify
label define mask 3 "Cotización de salud", modify

* GUardado
save "$proyecto/data/tabla 05-04", replace

* Exportación
keep if inlist(_rama1_v1, $sector, 1e6)
.table.export_excel bh, file("tabla 05-04")
.table.export_excel cv, file("tabla 05-04")
