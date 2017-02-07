* indicadores  : exportaciones
* subpoblación : sector
* años         : 2010-2015
* meses        : 1-12
* por          :
* según        :
* agregaciones :
* fuente       : ccnn

* Selección
use "$datos/Exportaciones/Exportaciones", clear

* Mutación
gen_pib_año
gen_pib_mes
gen_pib_rama1_v1

* Selección
keep if inrange(año, 2010, 2015)

* Agregación
collapse (sum) exp, by(año mes _rama1_v1)
bysort año mes : egen exp$nacion = total(exp)
keep if inlist(_rama1_v1, $sector, $nacion)
rename exp exp$sector
drop _rama1_v1

* Ordenación
order año mes exp*
order año mes

* Etiquetado
label variable exp$sector "Sectorial"
label variable exp$nacion "Nacional"

* Guardado
save "$proyecto/data/tabla 01-10", replace

* Exportación
local file "$proyecto/data/tabla 01-10.xlsx"
export excel using "`file'", sheet("01") sheetmodify cell("A2") firstrow(varlabels)
putexcel set "`file'", sheet("01", replace) modify
