* Macros auxiliares y objetos temporales
local id "02-03"

* Especificación
.table = .ol_table.new
.table.rowvar = "temp"
.table.colvar = "año"

* Exportación
foreach i in $sectores {
	* BBDD
	use "$proyecto/data/consultas/`id'.dta", clear
  keep if inlist(_rama1_v1, `i')
	rename _tamaño_empresa temp
	replace cmd_fmt = "%15,1fc"

  * Archivo de destino
	local name : label _rama1_v1 `i'
	label define _rama1_v1 `i' "Sector", modify
  local file "$proyecto/data/cuadros/`name'/bh.xlsx"

	* Título del cuadro
  local title = ///
    "2.3. Evolución distribución de ocupados del sector " + ///
    "según tamaño de empresa, 2010-2016"

	* Exportación
	.table.export_excel bh, file("`file'") sheet("`id'")
	putexcel set "`file'", sheet("`id'") modify
	putexcel A1 = "`title'", font("Times New Roman", 11) bold
}
