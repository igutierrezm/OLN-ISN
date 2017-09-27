* Macros auxiliares y objetos temporales
local id "01-02"

* Variación (%) del PIB sectorial según sector, año y mes
use if (serie == "nsedo2008") using "$datos/pib", clear
ol_generate, varlist("_rama1_v1 _año _mes") db("pib")
collapse (sum) pib, by(_rama1_v1 _año _mes)
keep if (_rama1_v1 != 1e5)
by _rama1_v1 : generate bh = 100 * (pib[_n] - pib[_n - 4]) / pib[_n - 4]
generate cmd_lb   = 1
generate cmd_fmt  = "%15,1fc"
generate cmd_type = "total"
generate asterisk = ""

* Etiquetado
label variable bh "Variación PIB (%)"

* Guardado
drop pib
drop if (bh == .) | (_rama1_v1 == .)
save "$proyecto/data/consultas/`id'.dta", replace
