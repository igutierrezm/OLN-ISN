/* * Macros auxiliares y objetos temporales
local id "04-04"

* Especificación
.table = .ol_table.new
.table.rowvar = "_rama1_v1"
.table.colvar = "año"

* Exportación
forvalues i = 1(1)13 {
	* BBDD
	use "$proyecto/data/consultas/`id'.dta", clear
	* keep if inlist(_rama1_v1, `i')
	replace cmd_fmt = "%15,1fc"

  * Archivo de destino
	local name : label _rama1_v1 `i'
	*label define _rama1_v1 `i' "Sector", modify
  local file "$proyecto/data/cuadros/`name'/bh.xlsx"

  * Título del cuadro
  local title =  ///
    "4.4. Porcentaje de conmutantes según sectores productivos, 2010-2016"

	* Exportación
	.table.export_excel bh, file("`file'") sheet("`id'")
	putexcel set "`file'", sheet("`id'") modify
	putexcel A1 = "`title'", font("Times New Roman", 11) bold
} */
