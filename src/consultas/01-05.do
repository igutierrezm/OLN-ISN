/* * Macros auxiliares y objetos temporales
local id "01-05"
local cmd_lb1 "Distribución regional del PIB"
local cmd_lb2 "Distribución regional de los ocupados"

*===============================================================================
* Panel N°1 - PIB
*===============================================================================

* BBDD
use "$datos/PIB/PIB RSCO.dta", clear
keep if (año == 2014) & !inlist(_rama1_v2, ., 1e6)

* Distribución del PIB por sector, para cada región
collapse (sum) pib, by(_region_tr_v1 _rama1_v2)
bysort _rama1_v2 : egen total_pib = total(pib)
generate bh = 100 * pib / total_pib
drop pib total_pib

* Variables auxiliares
generate cmd_type = "proportion"
generate cmd_fmt  = "%15,0fc"
generate cmd_lb   = 1

* Etiquetado
label define cmd_lb 1 "`cmd_lb1'", modify
label values cmd_lb cmd_lb

* Guardado
save `df', replace

*===============================================================================
* Panel N°2 - Ocupados
*===============================================================================

* Especificación
.table = .ol_table.new
.table.cmds       = "{total _counter}"
.table.cmds_lb    = "{0: N}"
.table.cmds_fmt   = "{%15,0fc}"
.table.years      = "2014"
.table.months     = "2 5 8 11"
.table.subpops    = "{if _ocupado == 1}"
.table.subpops_lb = "{1: Ocupados}"
.table.by         = "_region_tr_v1"
.table.along      = "_rama1_v2"
.table.margins    = ""
.table.margins_lb = ""
.table.src        = "ene"
.table.from       = "$datos"
.table.varlist0   = "_ocupado _rama1_v2 _region_tr_v1"

* Estimación
.table.create
.table.annualize
.table.add_proportions, cmd_lb("2: `cmd_lb2'") cmd_fmt("%15,0fc")
.table.add_asterisks
keep if (cmd_lb == 2)

save "$proyecto/data/consultas/`id' [2].dta", replace */
