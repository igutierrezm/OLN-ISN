* indicadores  : distribución de ocupados
* subpoblación : ocupados
* años         : 2010-2015
* meses        :
* por          : TEM¹ (incluyendo TCCU²)
* según        :
* agregaciones : TEM
* fuente       : ENE

* Especificación
.table = .ol_table.new
  * Estadísticas
  .table.cmds      = "{proportion _tamaño_empresa}"
  .table.cmds_lb   = "{%}"
  * Dominios
  .table.years     = "2010 2011 2012 2013 2014 2015"
  .table.months    = "2 5 8 11"
  .table.subpops   = "{if (_ocupado == 1)}"
  .table.by        = "_tamaño_empresa"
  .table.along     = "_rama1_v1"
  .table.aggregate = "{_tamaño_empresa}"
  * Estructura
  .table.rowvar    = "_tamano_empresa"
  .table.colvar    = "año"
  * I-O
  .table.src       = "ene"
  .table.from      = "$datos"
  .table.varlist0  = "_ocupado _tamaño_empresa _rama1_v1"

* Estimación
.table.create
.table.annualize
save "$proyecto/data/tabla 02-03.dta", replace

* Exportación
keep if _rama1_v1 == $sector
rename _tamaño_empresa _tamano_empresa
.table.export_excel bh, file("$proyecto/data/tabla 02-03.xlsx")
.table.export_excel cv, file("$proyecto/data/tabla 02-03.xlsx")

* Notas al pie
* ¹ Tamaño de empresa (de acuerdo al número de trabajadores)
* ² Trabajadores por Cuenta Propia Unipersonales
