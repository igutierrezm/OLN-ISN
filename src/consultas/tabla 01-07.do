* indicadores  : n. de ocupados (en miles)
* subpoblación : ocupados del sector
* años         : 2010-2015
* meses        : 1-12
* por          :
* según        :
* agregaciones : sector
* fuente       : ENE

* Especificación
.table = .ol_table.new
  * Estadísticas
  .table.cmds      = `""total _counter""'
  .table.masks     = `""n. (en miles)""'
  * Dominios
  .table.years     = "2010 2011 2012 2013 2014 2015"
  .table.months    = "1 2 3 4 5 6 7 8 9 10 11 12"
  .table.subpop    = "if (_ocupado == 1) & inlist(_rama1_v1, $sector, $nacion)"
  .table.by        = "_rama1_v1"
  .table.along     = ""
  .table.aggregate = "_rama1_v1"
  * Estructura
  .table.rowvar    = "año mes"
  .table.colvar    = "_rama1_v1"
  * I-O
  .table.src       = "ene"
  .table.varlist0  = "_ocupado _rama1_v1"

* Estimación
.table.create
replace bh = bh / 1000^1
replace o2 = bh / 1000^2
replace cmdtype = ""
save "$proyecto/data/tabla 01-07", replace

* Exportación
.table.export_excel bh, file("tabla 01-07")
.table.export_excel cv, file("tabla 01-07")
