* Macros auxiliares y objetos temporales
local id "02-04"

* Especificación
.table = .ol_table.new
.table.rowvar = "_region_re_v1"
.table.colvar = "temp"

* Exportación
forvalues i = 1(1)13 {
	* BBDD
	use "$proyecto/data/consultas/`id'.dta", clear
  rename _tamaño_empresa_v1 temp
	keep if inlist(_rama1_v1, `i')

	* Nombre del sector
	local name : label _rama1_v1 `i'
	label define _rama1_v1 `i' "Sector", modify
  local file "$proyecto/data/cuadros/`name'/bh.xlsx"

  * Exportación
	.table.export_excel bh, file("`file'") sheet("`id'")
	putexcel set "`file'", sheet("`id'") modify
	putexcel A1 = ///
		"2.4. Distribución de ocupados por región según tamaño de empresa, 2015", ///
		font("Times New Roman", 11) bold
}
