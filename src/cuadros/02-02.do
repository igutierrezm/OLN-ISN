* Macros auxiliares
local id "02-02"
local origen  "$proyecto/data/consultas"
local destino "$proyecto/data/cuadros"
tempfile df1

* Especificación
.table = .ol_table.new
.table.rowvar = "_tamaño_empresa_v1"
.table.colvar = "_rama1_v1 subpop_lb cmd_lb"

* Preparación de la BBDD de Ocupados
use "`origen'/`id' [1].dta", clear
.table.annualize_v2, over("_rama1_v1 _tamaño_empresa_v1")
.table.add_asterisks, add_over("_tamaño_empresa_v1")
replace cmd_lb = 1
save `df1', replace
.table.as_proportion, by("_tamaño_empresa_v1") along("_rama1_v1")
replace cmd_lb = 2
append using `df1'
save `df1', replace

* Preparación de la BBDD de Empresas
use "`origen'/`id' [2].dta", clear
replace subpop_lb = 2
label define subpop_lb 1 "Ocupados" 2 "Empresas", modify
append using `df1'
save `df1', replace

* Exportación
save "$proyecto/data/cuadros/`id'", replace
forvalues i = 1(1)13 {
		* Preparación de la BBDD
		use `df1', clear
		keep if inlist(_rama1_v1, `i', 1e6)

		* Identificación del nombre del sector
		local name : label _rama1_v1 `i'
		label define _rama1_v1 `i' "Sector", modify
    local file "`destino'/`name'/bh.xlsx"

    * Exportación
		.table.export_excel bh, file("`file'") sheet("`id'")
		putexcel set "`file'", sheet("`id'") modify
		putexcel A1 = ///
			"2.2. Número de empresas y ocupados por tamaño de empresa según número de trabajadores, incluyendo empresas unipersonales (cuenta propia), 2014", ///
			font("Times New Roman", 11) bold
}
