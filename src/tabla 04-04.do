* indicadores  : distribución de ocupados
* subpoblación : ocupados
* años         : 2010 y 2015
* meses        :
* por          : nivel educacional (educ)
* según        : sector
* agregaciones : "educ", "sector", "educ x sector"
* fuente       : ene

* Especificación
.table = .ol_table.new
  * Estadísticas
  .table.cmds      = `""proportion _conmutante_v1""'
  .table.masks     = `""%""'
  * Dominios
  .table.years     = "2010 2015"
  .table.months    = "2 5 8 11"
  .table.subpop    = "if _ocupado == 1"
  .table.by        = "_conmutante_v1"
  .table.along     = "_rama1_v1"
  .table.aggregate = `""_rama1_v1""'
  * Estructura
  .table.rowvar    = "_rama1_v1"
  .table.colvar    = "año"
  * I-O
  .table.src       = "ene"
  .table.varlist0  = "_conmutante_v1 _ocupado _rama1_v1"

* Estimación
.table.create
.table.annualize
save "$proyecto/data/tabla 04-04", replace

* Exportación
keep if (_conmutante_v1 == 1)
.table.export_excel bh, file("tabla 04-04")
.table.export_excel cv, file("tabla 04-04")
