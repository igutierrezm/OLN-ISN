* Selección
use "$datos/PIB/PIB NSED", clear

* Mutación
gen_pib_año
gen_pib_mes
gen_pib_rama1_v1

* Selección
keep if inrange(_año, 2010, 2015) & inlist(_rama1_v1, $sector, 1e6)

* Agregación
collapse (sum) pib, by(_año _mes _rama1_v1)

* Ordenación
reshape wide pib, i(_año _mes) j(_rama1_v1)
order _año _mes pib*
order _año _mes

* Etiquetado
label variable pib$sector "Sectorial"
label variable pib$nacion "Nacional"

* Guardado
save "$proyecto/data/tabla 01-01", replace

* Exportación
local file "$proyecto/data/tabla 01-01.xlsx"
export excel using "`file'", sheet("01") sheetmodify cell("A2") firstrow(varlabels)
putexcel set "`file'", sheet("01", replace) modify
