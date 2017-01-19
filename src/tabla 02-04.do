* indicadores  : distribución de ocupados
* subpoblación : ocupados del sector
* años         : 2015
* meses        :
* por          : TEM¹ (incluyendo TCCU²)
* según        : region
* agregaciones : "TEM", "region", "region, TEM"
* fuente       : ENE

* Preparativos
drop _all
tempfile df
save `df', emptyok

* Especificación
.table = .ol_table.new
  * Abreviaciones
  local tem "_tamaño_empresa"
  * Estadísticas
  .table.cmds      = `""proportion `tem'""'
  .table.masks     = `""%""'
  * Dominios
  .table.years     = "2015"
  .table.months    = "2 5 8 11"
  .table.subpop    = "if _rama1_v1 == $sector"
  .table.by        = "`tem'"
  .table.along     = "_region_re_v1"
  .table.aggregate = `""_region_re_v1" "`tem'" "`tem' _region_re_v1""'
  * Estructura
  .table.rowvar    = "_region_re_v1"
  .table.colvar    = "`tem'"
  * I-O
  .table.src       = "ene"
  .table.varlist0  = "_ocupado _rama1_v1 _region_re_v1 `tem'"
  cls

* Estimación
.table.create
.table.annualize
save "$proyecto/data/tabla 02-04", replace

* Exportación
.table.export_excel bh, file("tabla 02-04")
.table.export_excel cv, file("tabla 02-04")

* Notas al pie
* ¹ Tamaño de empresa (de acuerdo al número de trabajadores)
* ² Trabajadores por Cuenta Propia Unipersonales
