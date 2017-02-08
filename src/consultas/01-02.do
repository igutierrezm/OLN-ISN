* Preparación de la BBDD
use "$datos/PIB/PIB NSED", clear
gen_pib_rama1_v1
gen_pib_año
gen_pib_mes
replace _mes = mod(_mes + 1, 12)

* Variación (%) del PIB sectorial según sector, año y mes
collapse (sum) pib, by(_rama1_v1 _año _mes)
bysort _rama1_v1 : generate _delta = 100 * (pib[_n] - pib[_n - 4])/ pib[_n - 4]
drop if (_delta == .) | (_rama1_v1 == .)

* Guardado
save "$proyecto/data/consultas/01-02.dta", replace






/*
generate cmdtype = "proportion"
keep if delta != .

* Guardado
save "$proyecto/data/tabla 01-02", replace



* Exportación
.table = .ol_table.new
.table.rowvar = "año mes"
.table.colvar = "_rama1_v1"
.table.export_excel delta, file("tabla 01-02")
*/
