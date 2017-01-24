* indicador 1  : distribución de ventas
* indicador 2  : distribución de empresas
* indicador 3  : distribución de trabajadores dependientes informados
* subpoblación : empresas
* años         : 2015
* meses        :
* por          : sub-grupo principal
* según        : sector
* agregaciones :
* fuente       : sii

* Selección
use "$datos/SII/SII - Estadísticas según subsector.dta", clear

* Mutación
drop renta
gen_sii_rama1_v1, año(2014)
forvalues i = 1(1)3 {
	local var : word `i' of nemp ventas ntrab
	bysort año _rama1_v1 : egen sum_`i' = total(`var')
	bysort año _rama1_v1 : gen    bh`i' = 100 * `var' / sum_`i'
	drop `var' sum_`i'
}
drop sector
encode2 subsector, replace
reshape long bh, i(año _rama1_v1 subsector) j(mask)
generate cmdtype = "proportion"

* Ordenación
order año _rama1_v1 subsector mask bh
gsort año _rama1_v1 subsector mask

* Etiquetado
# delimit ;
	label define mask
		1 "% de empresas"
		2 "% de ventas"
		3 "% de trabajadores dependientes informados",
		modify;
# delimit cr
label values mask mask
label variable bh   "estadístico"
label variable mask "descripción del estadístico"

* Guardado
save "$proyecto/data/tabla 03-01.dta", replace

* Exportación
keep if (año == 2014) & (_rama1_v1 == $sector)
.table = .ol_table.new
	.table.rowvar  = "subsector"
	.table.colvar  = "mask"
.table.export_excel bh, file("tabla 03-01")
