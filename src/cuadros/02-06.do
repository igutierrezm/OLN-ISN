* Macros auxiliares y objetos temporales
local id "02-06"

* Especificación
.table = .ol_table.new
.table.rowvar = "_tamano_empresa"
.table.colvar = "_cise_v3"

* Exportación
foreach i of numlist $sectores {
	* BBDD
	use "$proyecto/data/consultas/`id'.dta", clear
	keep if inlist(_rama1_v1, `i')

	* Archivo de destino
	local name : label _rama1_v1 `i'
	label define _rama1_v1 `i' "Sector", modify
  local file "$proyecto/data/cuadros/`name'/bh.xlsx"

	* Título del cuadro
  .table.title =  ///
    "2.6. Distribución de ocupados por tamaño de empresa " +  ///
		"según categoría ocupacional, 2016"

	* Exportación
	.table.export_excel bh, file("`file'") sheet("`id'")
}
