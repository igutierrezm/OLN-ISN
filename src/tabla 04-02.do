* indicadores  : distribución de ocupados
* subpoblación : ocupados
* años         : 2010 y 2015
* meses        :
* por          : tramo de edad (tem)
* según        : sector
* agregaciones : "tem", "sector", "tem x sector"
* fuente       : ene

* Especificación
.table = .ol_table.new
  * Estadísticas
  .table.cmds      = "(proportion _tramo_edad_v1)"
  .table.masks     = "%"
  * Dominios
  .table.years     = "2010 2015"
  .table.months    = "2 5 8 11"
  .table.subpop    = "if _ocupado == 1"
  .table.by        = "_tramo_edad_v1"
  .table.along     = "_rama1_v1"
  .table.aggregate = "(_tramo_edad_v1) (_rama1_v1) (_tramo_edad_v1 _rama1_v1)"
  * Estructura
  .table.rowvar    = "_tramo_edad_v1"
  .table.colvar    = "_rama1_v1 año"
  * I-O
  .table.src       = "ene"
  .table.varlist0  = "_ocupado _rama1_v1 _tramo_edad_v1"

* Estimación
.table.create
.table.annualize
save "$proyecto/data/tabla 04-02.dta", replace

* Exportación
keep if inlist(_rama1_v1, $sector, 1e6)
.table.export_excel bh, file("$proyecto/data/tabla 04-02.xlsx")
.table.export_excel cv, file("$proyecto/data/tabla 04-02.xlsx")
