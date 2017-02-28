* Macros auxiliares y objetos temporales
local id "05-08"

* Especificación
.table = .ol_table.new
.table.rowvar = "_oficio1"
.table.colvar = "cmd_lb"

* Exportación
forvalues i = 1(1)13 {
	* BBDD
	use "$proyecto/data/consultas/`id'.dta", clear
	keep if inlist(_rama1_v1, `i')

	* Nombre del sector
	local name : label _rama1_v1 `i'
	label define _rama1_v1 `i' "Sector", modify
  local file "$proyecto/data/cuadros/`name'/bh.xlsx"

  * Exportación
	.table.export_excel bh, file("`file'") sheet("`id'")
	putexcel set "`file'", sheet("`id'") modify
	putexcel A1 = ///
    "5.8. Características generales de los ocupados del sector `name' por tipo de ocupación, 2015.", ///
		font("Times New Roman", 11) bold
}
