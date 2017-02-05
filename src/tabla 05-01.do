* indicadores  : distribución de personas
* subpoblación : ocupados (exceptuando fnr)
* años         : 2010 y 2015
* meses        :
* por          : cise (distinguiendo el tipo de contrato)
* según        : rama1
* agregaciones : cise, rama1, cise x rama1
* fuente       : ene

* Especificación
.table = .ol_table.new
  * Estadísticas
  .table.cmds      = "(proportion _cise_v3)"
  .table.masks     = "%"
  * Dominios
  .table.years     = "2010 2015"
  .table.months    = "2 5 8 11"
  .table.subpop    = "if (_ocupado == 1) & (_cise_v3 != 3)"
  .table.by        = "_cise_v3"
  .table.along     = "_rama1_v1"
  .table.aggregate = "(_cise_v3) (_rama1_v1) (_cise_v3 _rama1_v1)"
  * Estructura
  .table.rowvar    = "_cise_v3"
  .table.colvar    = "año _rama1_v1"
  * I-O
  .table.src       = "ene"
  .table.varlist0  = "_cise_v3 _ocupado _rama1_v1"

* Estimación
.table.create
.table.annualize
drop if (_cise_v3 == 3)
save "$proyecto/data/tabla 05-01.dta", replace

* Exportación
keep if inlist(_rama1_v1, $sector, 1e6)
.table.export_excel bh, file("$proyecto/data/tabla 05-01.xlsx")
.table.export_excel cv, file("$proyecto/data/tabla 05-01.xlsx")
