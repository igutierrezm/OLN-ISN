* indicadores  : distribución de ocupados
* subpoblación : ocupados del sector
* años         : 2010-2015
* meses        : 1-12
* por          : cise (distinguiendo entre asalariados con y sin contrato)
* según        :
* agregaciones : cise
* fuente       : ENE

* Especificación
.table = .ol_table.new
  * Estadísticas
  .table.cmds      = `""proportion _cise_v2""'
  .table.masks     = `""%""'
  * Dominios
  .table.years     = "2010 2011 2012 2013 2014 2015"
  .table.months    = "1 2 3 4 5 6 7 8 9 10 11 12"
  .table.subpop    = "if (_ocupado == 1) & (_rama1_v1 == $sector)"
  .table.by        = "_cise_v2"
  .table.along     = ""
  .table.aggregate = "_cise_v2"
  * Estructura
  .table.rowvar    = "año mes"
  .table.colvar    = "_cise_v2"
  * I-O
  .table.src       = "ene"
  .table.varlist0  = "_cise_v2 _ocupado _rama1_v1"

* Estimación
.table.create
save "$proyecto/data/tabla 01-09", replace

* Exportación
.table.export_excel bh, file("tabla 01-09")
.table.export_excel cv, file("tabla 01-09")
