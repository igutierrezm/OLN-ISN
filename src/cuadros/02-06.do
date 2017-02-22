* Macros auxiliares
local id "02-06"
local temp    "_tamaño_empresa_v1"
local origen  "$proyecto/data/consultas"
local destino "$proyecto/data/cuadros"
tempfile df1

* Especificación
.table = .ol_table.new
.table.rowvar = "`temp'"
.table.colvar = "_cise_v3"

* Preparación de la BBDD
use "`origen'/`id'.dta", clear
.table.annualize_v2, over("_rama1_v1 `temp' _cise_v3")
.table.as_proportion, by("_cise_v3") along("_rama1_v1 `temp'")
.table.add_asterisks, add_over("_cise_v3")
save `df1', replace

* Exportación
save "$proyecto/data/cuadros/`id'", replace
forvalues i = 1(1)13 {
	* Preparación de la BBDD
	use `df1', clear
	keep if inlist(_rama1_v1, `i')

	* Identificación del archivo de destino
	local name : label _rama1_v1 `i'
	label define _rama1_v1 `i' "Sector", modify
	local file "`destino'/`name'/bh.xlsx"

	* Exportación
	.table.export_excel bh, file("`file'") sheet("`id'")
	putexcel set "`file'", sheet("`id'") modify
	putexcel A1 = ///
		"2.6. Distribución de ocupados por tamaño de empresa según categoría ocupacional, 2016", ///
		font("Times New Roman", 11) bold
}
