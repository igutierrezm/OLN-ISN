* Macros auxiliares y objetos temporales
local id "01-05"

* Especificación
.table = .ol_table.new
.table.rowvar = "_region_tr_v1"
.table.colvar = "cmd_lb"

* Exportación
forvalues i = 1(1)13 {
	* BBDD
	use "$proyecto/data/consultas/`id'", clear
	keep if inlist(_rama1_v2, `i')

	* Archivo de destino
	local name : label _rama1_v2 `i'
	local file "$proyecto/data/cuadros/`name'/bh.xlsx"
	label define _rama1_v2 `i' "Sector", modify

  * Título del cuadro
  local title =  ///
    "1.5. Distribución regional del PIB y de los ocupados del sector, 2014."

	* Exportación
	.table.export_excel bh, file("`file'") sheet("`id'")
	putexcel set "`file'", sheet("`id'") modify
	putexcel A1 = "`title'", font("Times New Roman", 11) bold
}
