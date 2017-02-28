* Macros auxiliares y objetos temporales
local id "01-02"

* Variación (%) del PIB sectorial según sector, año y mes
use "$datos/PIB/PIB NSED", clear
collapse (sum) pib, by(_rama1_v1 año mes)
bysort _rama1_v1 : generate bh = 100 * (pib[_n] - pib[_n - 4]) / pib[_n - 4]
generate cmd_fmt  = "%15,0fc"
generate cmd_type = "total"
generate asterisk = ""

* Etiquetado
label variable bh "Variación PIB (%)"

* Guardado
drop if (bh == .) | (_rama1_v1 == .)
save "$proyecto/data/consultas/`id'.dta", replace
