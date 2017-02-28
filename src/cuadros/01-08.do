/* * Macros auxiliares y objetos temporales
local id "01-08"

* Especificación
.table = .ol_table.new
.table.rowvar = "año mes"
.table.colvar = "_rama1_v1"

* Exportación
forvalues i = 1(1)13 {
	* BBDD
	use "$proyecto/data/consultas/`id'", clear
  keep if inlist(_rama1_v1, `i', 1e6)
  replace bh = 100 * (bh[_n] - bh[_n - 12]) / bh[_n - 12]

	* Archivo de destino
	local name : label _rama1_v1 `i'
	local file "$proyecto/data/cuadros/`name'/bh.xlsx"
	label define _rama1_v1 `i' "Sector", modify

  * Título del cuadro
  local title =  ///
    "1.8. Variación (%) ocupados del sector `name'" +  ///
    "con respecto al mismo período del año anterior, 2010-2016."

	* Exportación
	.table.export_excel bh, file("`file'") sheet("`id'")
	putexcel set "`file'", sheet("`id'") modify
	putexcel A1 = "`title'", font("Times New Roman", 11) bold
} */
