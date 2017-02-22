* Macros auxiliares
local id "04-02"
local origen  "$proyecto/data/consultas"
local destino "$proyecto/data/cuadros"
tempfile df1

* Especificación
.table = .ol_table.new
.table.rowvar = "_tramo_edad_v1"
.table.colvar = "año _mujer"

* Preparación de la BBDD
use "`origen'/`id'.dta", clear
.table.annualize_v2, over("_rama1_v1 _mujer _tramo_edad_v1")
.table.as_proportion, by("_tramo_edad_v1") along("_rama1_v1 _mujer")
.table.add_asterisks, add_over("_tramo_edad_v1")

* Guardado
save `df1', replace

* Exportación
save "$proyecto/data/cuadros/`id'", replace
forvalues i = 1(1)13 {
	* Preparación de la BBDD
	use `df1', clear
	keep if inlist(_rama1_v1, `i')

	* Identificación del archivo de destino
	local name : label _rama1_v1 `i'
	label define _rama1_v1 `i' "Sector", modify
  local file "`destino'/`name'/bh.xlsx"

  * Exportación
	.table.export_excel bh, file("`file'") sheet("`id'")
	putexcel set "`file'", sheet("`id'") modify
	putexcel A1 = ///
		"4.2. Ocupados del sector `name' por tramo de edad y sexo, 2010 y 2016", ///
		font("Times New Roman", 11) bold
}
