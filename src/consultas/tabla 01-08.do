* indicadores  : Variación (%) anual de ocupados
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
  .table.masks     = `""variación (%)""'
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
sort año mes _rama1_v1
by _rama1 : generate _bh = 100 * (bh[_n] - bh[_n - 12]) / bh[_n - 12]
replace cmdtype = ""
replace bh = _bh
replace o2 = .
replace cv = .
drop _bh
save "$proyecto/data/tabla 01-08", replace

* Exportación
.table.export_excel bh, file("tabla 01-08")
.table.export_excel cv, file("tabla 01-08")
