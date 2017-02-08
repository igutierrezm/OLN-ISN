* Macros auxiliares
local id "01-01"
local origen  "$proyecto/data/consultas"
local destino "$proyecto/data/cuadros"

* Especificación de cuadro
.table = .ol_table.new
.table.rowvar = "_año _mes"
.table.colvar = "_rama1_v1"

* Exportación del cuadro
forvalues i = 1(1)1 {
	forvalues j = 1(1)1 {
		* BBDD
		use "`origen'/`id'.dta", clear
		keep if inlist(_rama1_v1, `i', 1e6)

		* Identificación del nombre del sector
		local name : label _rama1_v1 `i'
		label define _rama1_v1 `i' "Sector", modify

		* Exportación (cuerpo)
		local file "`destino'/`name'/bh [`j'].xlsx"
		.table.export_excel pib, file("`file'") sheet("`id'")

		* Título
		local msg = "1.1. Evolución PIB del sector `name' (desestacionalizado), trimestres 2008-2015."
		putexcel set "`file'", sheet("`id'") modify
		putexcel A1 = "`msg'", font("Times New Roman", 11) bold
	}
}
