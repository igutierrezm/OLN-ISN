* indicadores  : distribución de ocupados
* subpoblación : ocupados
* años         : 2010 y 2015
* meses        :
* por          : nivel educacional (educ)
* según        : oficio, sector
* agregaciones : "educ", "oficio", "educ x oficio"
* fuente       : ene

* Especificación
.table = .ol_table.new
  * Estadísticas
  .table.cmds      = `""proportion _educ""'
  .table.masks     = `""%""'
	* Dominios
  .table.years     = "2015"
  .table.months    = "2 5 8 11"
  .table.subpop    = "if _ocupado == 1"
	.table.by        = "_educ"
  .table.along     = "_oficio1 _rama1_v1"
  .table.aggregate = `""_educ" "_oficio1" "_educ _oficio1""'
  * Estructura
  .table.rowvar    = "_oficio1"
  .table.colvar    = "_educ"
  * I-O
  .table.src       = "ene"
	.table.varlist0  = "_educ _ocupado _oficio1 _rama1_v1"

* Estimación
drop _all
tempfile df
save `df', emptyok
forvalues i = 1(1)13 {
    * Especificación (act)
    .table.subpop = "if (_ocupado == 1) & (_rama1_v1 == `i')"
    * Estimación
    .table.create
    .table.annualize
    * Anexión
    append using `df'
    save `df', replace
}
save "$proyecto/data/tabla 05-09", replace

* Exportación
keep if inlist(_rama1_v1, $sector)
.table.export_excel bh, file("tabla 05-09")
.table.export_excel cv, file("tabla 05-09")
