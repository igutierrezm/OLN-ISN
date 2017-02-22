* Macros auxiliares
local id "05-05"
local origen  "$proyecto/data/consultas"
local destino "$proyecto/data/cuadros"
local inflacion = 110.89 / 92.79
tempfile df1

* Especificación
.table = .ol_table.new
.table.rowvar = "_educ"
.table.colvar = "_rama1_v1 año"

* Preparación de la BBDD
use "`origen'/`id'.dta", clear
replace bh = `inflacion' * bh if (año == 2010)
.table.add_asterisks
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

	* Título
	putexcel set "`file'", sheet("`id'") modify
	putexcel A1 = ///
		"5.5. Ingresos de la ocupación principal de los ocupados del sector `name' según nivel educacional, 2010 y 2015", ///
		font("Times New Roman", 11) bold
}
