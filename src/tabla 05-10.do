* indicadores  : distribución de ocupados
* subpoblación : ocupados (exceptuado a los fnr)
* años         : 2010 y 2015
* meses        :
* por          : cise_v3
* según        : oficio1, sector
* agregaciones : cise_v3, oficio1, cise_v3 x oficio1
* fuente       : ene

* Preparativos
drop _all
tempfile df
save `df', emptyok

* Especificación
.table = .ol_table.new
  * Estadísticas
  .table.cmds      = "(proportion _cise_v3)"
  .table.masks     = "%"
	* Dominios
  .table.years     = "2015"
  .table.months    = "2 5 8 11"
  .table.subpop    = "[delayed]"
	.table.by        = "_cise_v3"
  .table.along     = "_oficio1 _rama1_v1"
  .table.aggregate = "(_cise_v3) (_oficio1) (_cise_v3 _oficio1)"
  * Estructura
  .table.rowvar    = "_oficio1"
  .table.colvar    = "_cise_v3"
  * I-O
  .table.src       = "ene"
	.table.varlist0  = "_cise_v3 _ocupado _oficio1 _rama1_v1"

* Estimación
forvalues i = 1(1)13 {
    * Especificación
    .table.subpop = "if (_ocupado == 1) & (_cise_v3 != 3) & (_rama1_v1 == `i')"
    * Estimación
    .table.create
    .table.annualize
    * Anexión
    append using `df'
    save `df', replace
}
save "$proyecto/data/tabla 05-10.dta", replace

* Exportación
keep if inlist(_rama1_v1, $sector)
.table.export_excel bh, file("$proyecto/data/tabla 05-10.xlsx")
.table.export_excel cv, file("$proyecto/data/tabla 05-10.xlsx")
