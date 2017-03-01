/* * Macros auxiliares y objetos temporales
local id "05-03"

* Especificación de cuadro
.table = .ol_table.new
.table.rowvar = "cmd_lb"
.table.colvar = "_rama1_v1 año"

* Exportación
forvalues i = 1(1)13 {
	* BBDD
	use "$proyecto/data/consultas/`id'.dta", clear
	keep if inlist(_rama1_v1, `i', 1e6)

	* Archivo de destino
	local name : label _rama1_v1 `i'
	label define _rama1_v1 `i' "Sector", modify
  local file "$proyecto/data/cuadros/`name'/bh.xlsx"

	* Título del cuadro
  local title =  ///
    "5.3. Indicadores de seguridad social de trabajadores dependientes" + ///
		"del sector `name' según género, 2010 y 2016"

	* Exportación
	.table.export_excel bh, file("`file'") sheet("`id'")
	putexcel set "`file'", sheet("`id'") modify
	putexcel A1 = "`title'", font("Times New Roman", 11) bold
} */
