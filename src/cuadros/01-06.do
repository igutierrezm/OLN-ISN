/* * Macros auxiliares y objetos temporales
local id "01-06"

* Especificación
.table = .ol_table.new
.table.rowvar = "_region_tr_v1"
.table.colvar = "cmd_lb"

* Exportación
forvalues i = 1(1)11 {
	* BBDD
	use "$proyecto/data/consultas/`id'", clear
	keep if inlist(_rama1_v2, `i')

	* Archivo de destino
	local name : label _rama1_v2 `i'
	local file "$proyecto/data/cuadros/`name'/bh.xlsx"
	label define _rama1_v2 `i' "Sector", modify

  * Título del cuadro
  local title =                                                         ///
    "1.6. Participación del PIB del sector `name' en el PIB regional" + ///
    "y participación del sector en el empleo regional, 2014."         + ///
    "Por región de trabajo."

	* Exportación
	.table.export_excel bh, file("`file'") sheet("`id'")
	putexcel set "`file'", sheet("`id'") modify
	putexcel A1 = "`title'", font("Times New Roman", 11) bold
} */
