* indicadores  : ingreso promedio (ocupación principal)
* subpoblación : ocupados
* años         : 2010 y 2015
* meses        :
* por          : cise (distinguiendo el tipo de contrato)
* según        : sector
* agregaciones : "cise", "sector", "cise x sector"
* fuente       : ESI

* Especificación
.table = .ol_table.new
  * Estadísticas
  .table.cmds      = `""mean _yprincipal""'
  .table.masks     = `""%""'
  * Dominios
  .table.years     = "2010 2015"
  .table.months    = ""
  .table.subpop    = "if _ocupado == 1"
  .table.by        = "_cise_v3"
  .table.along     = "_rama1_v1"
  .table.aggregate = `""_cise_v3" "_rama1_v1" "_cise_v3 _rama1_v1""'
  * Estructura
  .table.rowvar    = "_cise_v3"
  .table.colvar    = "año _rama1_v1"
  * I-O
  .table.src       = "esi"
  .table.varlist0  = "_cise_v3 _ocupado _rama1_v1 _yprincipal"

* Estimación
.table.create
save "$proyecto/data/tabla 05-02", replace

* Exportación
keep if inlist(_rama1_v1, $sector, 1e6)
.table.export_excel bh, file("tabla 05-02")
.table.export_excel cv, file("tabla 05-02")
