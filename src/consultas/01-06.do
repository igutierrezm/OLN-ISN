* Macros auxiliares
local id "01-06"

*===============================================================================
* Panel N°1 - Ocupados
*===============================================================================

* Especificación
.table = .ol_table.new
.table.cmds       = "{total _counter}"
.table.cmds_lb    = "{N}"
.table.years      = "2014"
.table.months     = "2 5 8 11"
.table.subpops    = "{if _ocupado == 1}"
.table.subpops_lb = "{Ocupados}"
.table.by         = "_rama1_v2"
.table.along      = "_region_tr_v1"
.table.aggregate  = ""
.table.src        = "ene"
.table.from       = "$datos"
.table.varlist0   = "_ocupado _rama1_v2 _region_tr_v1"

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
gen_pib_region_tr_v1
replace _mes = mod(_mes + 1, 12)
keep if (_año == 2014) & !inlist(_rama1_v2, ., 1e6)

* Distribución del PIB por sector, para cada región
collapse (sum) pib if (_año == 2014), by(_region_tr_v1 _rama1_v2)
bysort _region_tr_v1 : egen total_pib = total(pib)
generate bh = 100 * pib / total_pib
generate cmd_type = "proportion"
generate cmd_lb = 2
drop pib total_pib

* Etiquetado
label define cmd_lb 2 "%"
label values cmd_lb cmd_lb

* Guardado
save "$proyecto/data/consultas/`id' [2].dta", replace
