* Variables relevantes para la tabla
use "$datos/PIB/PIB NSED", clear
gen_pib_rama1_v1
gen_pib_año
gen_pib_mes

* Cálculo principal
keep if inrange(año, 2010, 2015)
keep if inlist(_rama1_v1, $sector, 1e6)
collapse (sum) pib, by(año mes _rama1_v1)
sort _rama1_v1 año mes
bysort _rama1_v1 : generate delta = 100 * (pib[_n] - pib[_n - 4])/ pib[_n - 4]
generate cmdtype = "proportion"
keep if delta != .

* Guardado
save "$proyecto/data/tabla 01-02", replace

* Exportación
.table = .ol_table.new
.table.rowvar = "año mes"
.table.colvar = "_rama1_v1"
.table.export_excel delta, file("tabla 01-02")
