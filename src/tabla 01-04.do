* Panel N°1
* indicadores  : distribución de ocupados
* subpoblación : ocupados
* años         : 2015
* meses        :
* por          : sector
* según        :
* agregaciones : "sector"
* fuente       : ene

* Especificación
.table = .ol_table.new
  * Estadísticas
  .table.cmds      = `""proportion _rama1_v1""'
  .table.masks     = `""% de ocupados""'
  * Dominios
  .table.years     = "2015"
  .table.months    = "2 5 8 11"
  .table.subpop    = "if _ocupado == 1"
  .table.by        = "_rama1_v1"
  .table.along     = ""
  .table.aggregate = "_rama1_v1"
  * Estructura
  .table.rowvar    = "_rama1_v1"
  .table.colvar    = "mask"
  * I-O
  .table.src       = "ene"
  .table.varlist0  = "_ocupado _rama1_v1"

* Estimación
tempfile df
.table.create
.table.annualize
save "`df'", replace

* Panel N°2
* indicadores  : distribución del pib
* subpoblación : ocupados
* años         : 2015
* meses        :
* por          : sector
* según        :
* agregaciones : "sector"
* fuente       : ene

* Selección
use "$datos/PIB/PIB NSCO", clear

* Mutación
gen_pib_año
gen_pib_mes
gen_pib_rama1_v1

* Selección
keep if (año == 2015) & (_rama1_v1 != .)

* Agregación
collapse (sum) pib, by(año _rama1_v1)
egen max = max(pib)
generate bh = 100 * pib / max
drop pib max

* Ordenación
order año _rama1_v1 bh
gsort año _rama1_v1

* Anexión
generate cmdtype = "proportion"
generate mask = 2
append using "`df'"

* Etiquetado
# delimit ;
  label define mask
    1 "% de ocupados"
    2 "% del PIB",
    modify;
# delimit cr
label values mask mask

* Guardado
save "$proyecto/data/tabla 01-04", replace

* Exportación
.table.export_excel bh, file("tabla 01-04")
.table.export_excel cv, file("tabla 01-04")
