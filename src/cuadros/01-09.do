* Macros auxiliares y objetos temporales
local id "01-09"

* Especificación de cuadro
.table = .ol_table.new
.table.rowvar = "año mes"
.table.colvar = "_cise_v3"

* Exportación
foreach i of numlist $sectores {
	* BBDD
	use "$proyecto/data/consultas/`id'.dta", clear
	keep if inlist(_rama1_v1, `i')

	* Archivo de destino
	local name : label _rama1_v1 `i'
	local file "$proyecto/data/cuadros/`name'/bh.xlsx"
	label define _rama1_v1 `i' "Sector", modify

	* Título del cuadro
	.table.title =  ///
		"1.9. Distribución (%) ocupados del sector `name' " +  ///
		"según categoría ocupacional, 2010-2016"

	* Exportación
	.table.export_excel bh, file("`file'") sheet("`id'")
}
