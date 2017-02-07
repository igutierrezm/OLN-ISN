* Panel N°1
* indicadores  : distribución de ocupados
* subpoblación : ocupados
* años         : 2015
* meses        :
* por          : región de residencia (region)
* según        :
* agregaciones : "region"
* fuente       : ene

* Preparativos
drop _all
tempfile df
save `df', emptyok

* Especificación
.table = .ol_table.new
  * Estadísticas
  .table.cmds      = `""proportion _region_re_v1""'
  .table.masks     = `""""'
  * Dominios
  .table.years     = "2014"
  .table.months    = "2 5 8 11"
  .table.subpop    = "if _rama1_v2 == $sector"
  .table.by        = "_region_re_v1"
  .table.along     = ""
  .table.aggregate = "_region_re_v1"
  * Estructura
  .table.rowvar    = "_region_re_v1"
  .table.colvar    = "mask"
  * I-O
  .table.src       = "ene"
  .table.varlist0  = "_ocupado _rama1_v2 _region_re_v1"

* Estimación
.table.create
.table.annualize
save "`df'", replace

* Panel N°2
* indicadores  : distribución del pib
* subpoblación : ocupados
* años         : 2015
* meses        :
* por          : región
* según        :
* agregaciones : "región"
* fuente       : ccnn

* Selección
use "$datos/PIB/PIB RSCO", clear

* Mutación
gen_pib_año
gen_pib_mes
gen_pib_rama1_v2
gen_pib_region_re_v1

* Selección
keep if (año == 2014) & (_rama1_v2 == $sector)

* Agregación
collapse (sum) pib, by(año _region_re_v1)
quietly : summarize pib
generate bh = 100 * pib / r(sum)
local M = r(N) + 1
set obs `M'
replace bh = 100 in `M'
replace _region_re_v1 = 1e6 in `M'
drop pib

* Ordenación
order año _region_re_v1 bh
gsort año _region_re_v1

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
save "$proyecto/data/tabla 01-05", replace

* Exportación
.table.export_excel bh, file("tabla 01-05")
.table.export_excel cv, file("tabla 01-05")
