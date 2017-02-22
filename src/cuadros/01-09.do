* Macros auxiliares
local id "01-09"
local origen  "$proyecto/data/consultas"
local destino "$proyecto/data/cuadros"
tempfile df1

* Especificación de cuadro
.table = .ol_table.new
.table.rowvar = "año mes"
.table.colvar = "_cise_v2"

* Preparación de la BBDD
use "`origen'/`id'.dta", clear
.table.add_asterisks, add_over("_cise_v2")
save `df1', replace

* Exportación del cuadro
save "$proyecto/data/cuadros/`id'", replace
forvalues i = 1(1)13 {
	* BBDD
	use `df1', clear
	keep if inlist(_rama1_v1, `i')
  lval_ene_mes

	* Identificación del archivo de destino
	local name : label _rama1_v1 `i'
	label define _rama1_v1 `i' "Sector", modify
	local file "`destino'/`name'/bh.xlsx"

	* Exportación
	.table.export_excel bh, file("`file'") sheet("`id'")
	putexcel set "`file'", sheet("`id'") modify
	putexcel A1 = ///
		"1.9. Distribución (%) ocupados del sector `name' según categoría ocupacional, 2010-2016", ///
		font("Times New Roman", 11) bold
}
