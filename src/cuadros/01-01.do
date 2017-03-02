* Macros auxiliares y objetos temporales
local id "01-01"

* Especificación
.table = .ol_table.new
.table.rowvar = "año mes"
.table.colvar = "_rama1_v1"

* Exportación
foreach i in $sectores {
	* BBDD
	use "$proyecto/data/consultas/`id'.dta", clear
	keep if inlist(_rama1_v1, `i', 1e6)
	replace cmd_fmt = "%15,0fc"

	* Archivo de destino
	local name : label _rama1_v1 `i'
	local file "$proyecto/data/cuadros/`name'/bh.xlsx"
	label define _rama1_v1 `i' "Sector", modify

  * Título del cuadro
  local title =  ///
    "1.1. Evolución PIB del sector `name' (desestacionalizado), " + ///
    "trimestres 2008-2016."

	* Exportación
	.table.export_excel bh, file("`file'") sheet("`id'")
	putexcel set "`file'", sheet("`id'") modify
	putexcel A1 = "`title'", font("Times New Roman", 11) bold
}
