* Macros auxiliares y objetos temporales
local id "01-01"

* PIB sectorial según sector, año y mes
use "$datos/PIB/PIB NSED", clear
collapse (sum) pib, by(_rama1_v1 año mes)
generate cmd_lb   = 1
generate cmd_fmt  = "%15,0fc"
generate cmd_type = "total"
generate asterisk = ""
rename pib bh

* Etiquetado
label variable bh "PIB (MM$)"

* Guardado
save "$proyecto/data/consultas/`id'.dta", replace
