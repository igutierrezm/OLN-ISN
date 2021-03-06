* Macros auxiliares y objetos temporales
local id "02-05"

* Especificación
.table = .ol_table.new
.table.rowvar = "_rama1_v1 _tamano_empresa"
.table.colvar = "_educ"

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
    "2.5. Distribución de ocupados por tamaño de empresa " +  ///
		"según nivel educacional (%), 2016"

	* Exportación
	.table.export_excel bh, file("`file'") sheet("`id'")
}
