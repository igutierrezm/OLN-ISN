* indicadores  : distribución de ocupados
* subpoblación : ocupados
* años         : 2010 y 2015
* meses        :
* por          : nivel educacional (educ)
* según        : oficio1, rama1
* agregaciones : educ, oficio1, educ x oficio1
* fuente       : ene

* Especificación
.table = .ol_table.new
  * Estadísticas
  .table.cmds      = "{proportion _educ}"
  .table.cmds_lb   = "{%}"
	* Dominios
  .table.years     = "2015"
  .table.months    = "2 5 8 11"
  .table.subpops   = "[delayed]"
	.table.by        = "_educ"
  .table.along     = "_oficio1 _rama1_v1"
  .table.aggregate = "{_educ} {_oficio1} {_educ _oficio1}"
  * Estructura
  .table.rowvar    = "_oficio1"
  .table.colvar    = "_educ"
  * I-O
  .table.src       = "ene"
  .table.from      = "$datos"
	.table.varlist0  = "_educ _ocupado _oficio1 _rama1_v1"

* Estimación
drop _all
tempfile df
save `df', emptyok
forvalues i = 1(1)13 {
    * Especificación (act)
    .table.subpops = "{if (_ocupado == 1) & (_rama1_v1 == `i')}"
    * Estimación
    .table.create
    .table.annualize
    * Anexión
    append using `df'
    save `df', replace
}
save "$proyecto/data/tabla 05-09.dta", replace

* Exportación
keep if inlist(_rama1_v1, $sector)
.table.export_excel bh, file("$proyecto/data/tabla 05-09.xlsx")
.table.export_excel cv, file("$proyecto/data/tabla 05-09.xlsx")
