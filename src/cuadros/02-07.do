* Macros auxiliares y objetos temporales
local id "02-07"

* Especificación
.table = .ol_table.new
.table.rowvar = "temp"
.table.colvar = "_cise_v3"

* Exportación
forvalues i = 1(1)13 {
	* BBDD
	use "$proyecto/data/consultas/`id'.dta", clear
	keep if inlist(_rama1_v1, `i')
	rename _tamaño_empresa temp

  * Archivo de destino
	local name : label _rama1_v1 `i'
	label define _rama1_v1 `i' "Sector", modify
  local file "$proyecto/data/cuadros/`name'/bh.xlsx"

  * Título del cuadro
  local title = ///
    "2.7. Ingresos de la ocupación principal del sector " + ///
    "por categoría ocupacional y tamaño de empresa, 2015"

	* Exportación
	.table.export_excel bh, file("`file'") sheet("`id'")
	putexcel set "`file'", sheet("`id'") modify
	putexcel A1 = "`title'", font("Times New Roman", 11) bold
}
