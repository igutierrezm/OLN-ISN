* Macros auxiliares
local id "01-09"
local origen  "$proyecto/data/consultas"
local destino "$proyecto/data/cuadros"

* Especificación de cuadro
.table = .ol_table.new
.table.rowvar = "año mes"
.table.colvar = "_cise_v2"

* Exportación del cuadro
forvalues i = 1(1)13 {
	forvalues j = 1(1)2 {
		* BBDD
		use "`origen'/`id'.dta", clear
		keep if inlist(_rama1_v1, `i')
    lval_ene_mes

		* Identificación del nombre del sector
		local name : label _rama1_v1 `i'
		label define _rama1_v1 `i' "Sector", modify

		* Exportación
		foreach var in bh {
			* Cuerpo
			local file "`destino'/`name'/`var' [`j'].xlsx"
			.table.export_excel `var', file("`file'") sheet("`id'")

			* Título
			putexcel set "`file'", sheet("`id'") modify
			putexcel A1 = ///
				"1.9. Distribución (%) ocupados del sector `name' según categoría ocupacional, 2010-2016", ///
				font("Times New Roman", 11) bold
		}
	}
}
