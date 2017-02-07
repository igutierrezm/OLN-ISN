* indicadores  : ingreso promedio de la ocupación principal
* subpoblación : ocupados que mantuvieron su empleo
* años         : 2015
* meses        :
* por          : CISE
* según        : TEM¹ (incluyendo TCCU²)
* agregaciones : "TEM", "CISE", "TEM, CISE"
* fuente       : esi

* Especificación
.table = .ol_table.new
  * Abreviaciones
  local tem "_tamaño_empresa"
  * Estadísticas
  .table.cmds      = "{mean _yprincipal}"
  .table.cmds_lb   = "{M$}"
  * Dominios
  .table.years     = "2015"
  .table.months    = ""
  .table.subpops   = "{if (_rama1_v1 == $sector) & (_mantuvo_empleo == 1)}"
  .table.by        = "_cise_v3"
  .table.along     = "`tem'"
  .table.aggregate = "{_cise_v3} {`tem'} {_cise_v3 `tem'}"
  * Estructura
  .table.rowvar    = "_cise_v3"
  .table.colvar    = "`tem'"
  * I-O
  .table.src       = "esi"
  .table.from      = "$datos"
  .table.varlist0  = "_cise_v3 _mantuvo_empleo _rama1_v1 `tem' _yprincipal"

* Estimación
.table.create
save "$proyecto/data/tabla 02-07.dta", replace

* Exportación
.table.export_excel bh, file("$proyecto/data/tabla 02-07.xlsx")
.table.export_excel cv, file("$proyecto/data/tabla 02-07.xlsx")

* Notas al pie
* ¹ Tamaño de empresa (de acuerdo al número de trabajadores)
* ² Trabajadores por Cuenta Propia Unipersonales
