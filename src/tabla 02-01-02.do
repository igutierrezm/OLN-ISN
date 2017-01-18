*! 1.0.0 Iván Gutiérrez 23nov2016
* Variación (%) anual del PIB encadenado (desestacionalizado),
* según año, trimestre y sector.
* CCNN

*===============================================================================
* Prólogo
*===============================================================================

* Housekeeping:
set more off
clear
cls

* Objetos temporales:
tempfile df

*===============================================================================
* Cuerpo
*===============================================================================

* Selección:
use "$data/PIB/PIB NSED.dta", clear
describe
label list

* Mutación I:
rc_pib_rama1, version(1)

* Agregación:
collapse (sum) pib, by(rama1_rc fecha)

* Mutación II:
by rama1_rc : gen pc = 100 * (pib[_n] - pib[_n-4]) / pib[_n-4]
drop pib

* Filtración:
by rama1_rc : drop if (_n <= 4)

* Guardado:
save "$project/data/chart 02-01-02.dta", replace
beep

* Filtración/Selección I:
*xtset sector fecha
*keep if tin(01jan2008, 01oct2015)
