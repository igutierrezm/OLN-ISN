* Macros auxiliares
local id "05-07"
local origen  "$proyecto/data/consultas"
local destino "$proyecto/data/cuadros"
tempfile df1

* Especificación
.table = .ol_table.new
.table.rowvar = "_oficio1"
.table.colvar = "_rama1_v1 año"

* Preparación de la BBDD
use "`origen'/`id'.dta", clear
.table.annualize_v2, over("_rama1_v1 _oficio1")
.table.as_proportion, by("_oficio1") along("_rama1_v1")
.table.add_asterisks, add_over("_oficio1")
save `df1', replace

* Exportación
save "$proyecto/data/cuadros/`id'", replace
forvalues i = 1(1)13 {
	* Preparación de la BBDD
	use `df1', clear
	keep if inlist(_rama1_v1, `i', 1e6)

	* Identificación del archivo de destino
	local name : label _rama1_v1 `i'
	label define _rama1_v1 `i' "Sector", modify
	local file "`destino'/`name'/bh.xlsx"

	* Exportación
	.table.export_excel bh, file("`file'") sheet("`id'")
	putexcel set "`file'", sheet("`id'") modify
	putexcel A1 = ///
		"5.7. Distribución de ocupados del sector `name' por tipo de ocupación, 2010 y 2016", ///
		font("Times New Roman", 11) bold
}
