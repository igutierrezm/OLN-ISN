* indicadores  : número y distribución de ocupados
* subpoblación : ocupados del sector
* años         : 2015
* meses        :
* por          : nivel educacional (educ)
* según        : TEM¹ (incluyendo TCCU²)
* agregaciones : "educ", "TEM", "educ x TEM"
* fuente       : ENE

* Especificación
.table = .ol_table.new
  * Abreviaciones
  local tem "_tamaño_empresa"
  * Estadísticas
  .table.cmds      = "{proportion _educ}"
  .table.cmds_lb   = "{%}"
  * Dominios
  .table.years     = "2015"
  .table.months    = "2 5 8 11"
  .table.subpops   = "{if _rama1_v1 == $sector}"
  .table.by        = "_educ"
  .table.along     = "`tem'"
  .table.aggregate = "{_educ} {`tem'} {`tem' _educ}"
  * Estructura
  .table.rowvar    = "_educ"
  .table.colvar    = "`tem'"
  * I-O
  .table.src       = "ene"
  .table.from      = "$datos"
  .table.varlist0  = "_educ _ocupado _rama1_v1 `tem'"
  cls

* Estimación
.table.create
.table.annualize
save "$proyecto/data/tabla 02-05.dta", replace

* Exportación
.table.export_excel bh, file("$proyecto/data/tabla 02-05.xlsx")
.table.export_excel cv, file("$proyecto/data/tabla 02-05.xlsx")

* Notas al pie
* ¹ Tamaño de empresa (de acuerdo al número de trabajadores)
* ² Trabajadores por Cuenta Propia Unipersonales