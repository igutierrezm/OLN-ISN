/* * Macros auxiliares y objetos temporales
local id "01-04"

* Especificación
.table = .ol_table.new
.table.rowvar = "_rama1_v1"
.table.colvar = "cmd_lb"

* Exportación
forvalues i = 1(1)1 {
	* BBDD
	use "$proyecto/data/consultas/`id'", clear
	keep if inlist(_rama1_v1, `i', 1e6)

	* Archivo de destino
	local name : label _rama1_v1 `i'
	local file "$proyecto/data/cuadros/`name'/bh.xlsx"
	label define _rama1_v1 `i' "Sector", modify

  * Título del cuadro
  local title =  ///
    "1.4. Distribución del PIB y de los ocupados por sector económico, 2015."

	* Exportación
	.table.export_excel bh, file("`file'") sheet("`id'")
	putexcel set "`file'", sheet("`id'") modify
	putexcel A1 = "`title'", font("Times New Roman", 11) bold
} */
