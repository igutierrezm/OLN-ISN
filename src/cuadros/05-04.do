* Macros auxiliares y objetos temporales
local id "05-04"

* Especificación
.table = .ol_table.new
.table.rowvar = "cmd_lb"
.table.colvar = "_rama1_v1 _cise_v1"

* Exportación
foreach i of numlist $sectores {
	* BBDD
	use "$proyecto/data/consultas/`id'.dta", clear
	keep if inlist(_rama1_v1, `i', .z)

  * Archivo de destino
	local name : label _rama1_v1 `i'
	label define _rama1_v1 `i' "Sector", modify
  local file "$proyecto/data/cuadros/`name'/bh.xlsx"

  * Título del cuadro
  .table.title =  ///
    "5.4. Formalidad del trabajo independiente del sector `name' " +  ///
    "según categoría ocupacional, 2015"

	* Exportación
	.table.export_excel bh, file("`file'") sheet("`id'")
}
