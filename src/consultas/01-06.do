* Macros auxiliares
local id "01-06"

*===============================================================================
* Panel N°1 - Ocupados
*===============================================================================

* Especificación
.table = .ol_table.new
.table.cmds       = "{total _counter} {proportion _rama1_v2}"
.table.cmds_lb    = "{N} {%}"
.table.years      = "2014"
.table.months     = "2 5 8 11"
.table.subpops    = "{if _ocupado == 1}"
.table.subpops_lb = "{Ocupados}"
.table.by         = "_rama1_v2"
.table.along      = "_region_re_v1"
.table.aggregate  = ""
.table.src        = "ene"
.table.from       = "$datos"
.table.varlist0   = "_ocupado _rama1_v2 _region_re_v1"

* Estimación
.table.create
save "$proyecto/data/consultas/`id' [1].dta", replace

*===============================================================================
* Panel N°2 - PIB
*===============================================================================

* Preparación de la BBDD
use "$datos/PIB/PIB RSCO.dta", clear
gen_pib_año
gen_pib_mes
gen_pib_rama1_v2
gen_pib_region_re_v1
replace _mes = mod(_mes + 1, 12)
keep if (_año == 2014) & !inlist(_rama1_v2, ., 1e6)

* Distribución del PIB por sector, para cada región
collapse (sum) pib if (_año == 2014), by(_region_re_v1 _rama1_v2)
bysort _region_re_v1 : egen total_pib = total(pib)
generate bh = 100 * pib / total_pib
generate cmd_type = "proportion"
generate cmd_lb = 2
drop pib total_pib

* Etiquetado
label define cmd_lb 2 "Participación del PIB del sector en la región"
label values cmd_lb cmd_lb

* Guardado
save "$proyecto/data/consultas/`id' [2].dta", replace



/*
.table.rowvar    = "_region_re_v1"
.table.colvar    = "mask"

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

*/
