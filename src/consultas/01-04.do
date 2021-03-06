* Macros auxiliares y objetos temporales
local id "01-04"
tempfile df

*===============================================================================
* Panel N°1 - PIB
*===============================================================================

* PIB, según sector
use if (serie == "nscoo2008") using "$datos/pib", clear
ol_generate, varlist("_rama1_v1 _año _mes") db("pib")
collapse (sum) pib, by(_rama1_v1 _año)
keep if (_rama1_v1 != 1e5)
keep if (_año == 2015) 
egen sum_pib = total(pib)
generate bh = 100 * pib / sum_pib
drop sum_pib

* Variables auxiliares
generate cmd_type  = "proportion"
generate cmd_fmt   = "%15,1fc"
generate cmd_lb    = 1

* Etiquetado
label define cmd_lb 1 "% PIB", modify
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
.table.cmds_fmt   = "{%15,1fc}"
.table.years      = "2015"
.table.months     = "2(3)11"
.table.subpops    = "{if _ocupado == 1}"
.table.subpops_lb = "{1: Ocupados}"
.table.by         = "_rama1_v1"
.table.along      = ""
.table.margins    = ""
.table.margins_lb = ""
.table.src        = "ene"
.table.from       = "$datos"
.table.varlist0   = "_ocupado _rama1_v1"

* Estimación
.table.create
.table.annualize
.table.add_proportions, cmd_lb("2: % Ocupados") cmd_fmt("%15,1fc")
.table.add_asterisks
keep if (cmd_lb == 2)

* Consolidación
append2 using `df'
save "$proyecto/data/consultas/`id'.dta", replace
