* Macros auxiliares y objetos temporales
local id "01-02"

* Especificación
.table = .ol_table.new
.table.rowvar = "año mes"
.table.colvar = "_rama1_v1"

* Exportación
forvalues i = 1(1)13 {
	* BBDD
	use "$proyecto/data/consultas/`id'.dta", clear
	keep if inlist(_rama1_v1, `i', 1e6)

	* Archivo de destino
	local name : label _rama1_v1 `i'
	local file "$proyecto/data/cuadros/`name'/bh.xlsx"
  label define _rama1_v1 `i' "Sector", modify

	* Exportación
	.table.export_excel bh, file("`file'") sheet("`id'")
	putexcel set "`file'", sheet("`id'") modify
	putexcel A1 = ///
		"1.2. Variación (%) PIB `name' con respecto al mismo periodo del año anterior, 2009-2015.", ///
		font("Times New Roman", 11) bold
}