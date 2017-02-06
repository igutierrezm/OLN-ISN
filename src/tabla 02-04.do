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
  .table.cmds      = "{proportion `tem'}"
  .table.masks     = "{%}"
  * Dominios
  .table.years     = "2015"
  .table.months    = "11"
  .table.subpops   = "{if _rama1_v1 == $sector}"
  .table.by        = "`tem'"
  .table.along     = "_region_re_v1"
  .table.aggregate = "{_region_re_v1} {`tem'} {`tem' _region_re_v1}"
  * Estructura
  .table.rowvar    = "_region_re_v1"
  .table.colvar    = "`tem'"
  * I-O
  .table.src       = "ene"
  .table.from      = "$datos"
  .table.varlist0  = "_ocupado _rama1_v1 _region_re_v1 `tem'"
  cls

* Estimación
.table.create
.table.annualize
save "$proyecto/data/tabla 02-04.dta", replace

* Exportación
.table.export_excel bh, file("$proyecto/data/tabla 02-04.xlsx")
.table.export_excel cv, file("$proyecto/data/tabla 02-04.xlsx")

* Notas al pie
* ¹ Tamaño de empresa (de acuerdo al número de trabajadores)
* ² Trabajadores por Cuenta Propia Unipersonales
