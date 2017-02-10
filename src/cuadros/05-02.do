* Macros auxiliares
local id "05-02"
local origen  "$proyecto/data/consultas"
local destino "$proyecto/data/cuadros"

* Especificación
.table = .ol_table.new
.table.rowvar = "_cise_v3"
.table.colvar = "año _rama1_v1"

* Exportación
forvalues i = 1(1)13 {
	forvalues j = 1(1)2 {
		* Preparación de la BBDD
		use "`origen'/`id'.dta", clear
		keep if (cmd_type != "proportion")
		keep if inlist(_rama1_v1, `i', 1e6)
		drop if (_cise_v3 == 6)

		* Identificación del nombre del sector
		local name : label _rama1_v1 `i'
		label define _rama1_v1 `i' "Sector", modify

		* Exportación
		foreach var in bh cv {
			* Cuerpo
			local file "`destino'/`name'/`var' [`j'].xlsx"
			.table.export_excel `var', file("`file'") sheet("`id'")

			* Título
			putexcel set "`file'", sheet("`id'") modify
			putexcel A1 = ///
				"5.2. Ingresos de la ocupación principal del sector `name' según categoría ocupacional y tipo de contrato, 2010 y 2015", ///
				font("Times New Roman", 11) bold
		}
	}
}
