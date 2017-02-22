* Macros auxiliares
local id "01-06"
local origen  "$proyecto/data/consultas"
local destino "$proyecto/data/cuadros"
tempfile df1

* Especificación
.table = .ol_table.new
.table.rowvar = "_region_tr_v1"
.table.colvar = "cmd_lb"

* Preparación de la BBDD de Ocupados
use "`origen'/`id' [1].dta", clear
.table.annualize_v2, over("_rama1_v2 _region_tr_v1")
.table.as_proportion, by("_rama1_v2") along("_region_tr_v1")
replace cmd_lb = 1
save `df1', replace

* Preparación de la BBDD del PIB
use "`origen'/`id' [2].dta", clear
label define cmd_lb                                     ///
	1 "Participación del empleo del sector en la región"  ///
	2 "Participación del PIB del sector en la región",    ///
	modify
append using `df1'
generate asterisk = ""
save `df1', replace

* Exportación
save "$proyecto/data/cuadros/`id'", replace
forvalues i = 1(1)11 {
	* Preparación de la BBDD
	use `df1', clear
	keep if inlist(_rama1_v2, `i')

	* Archivo de destino
	local name : label _rama1_v2 `i'
	label define _rama1_v2 `i' "Sector", modify
  local file "`destino'/`name'/bh.xlsx"

  * Exportación
	.table.export_excel bh, file("`file'") sheet("`id'")
	putexcel set "`file'", sheet("`id'") modify
	putexcel A1 = ///
		"1.6. Participación del PIB del sector `name' en el PIB regional y participación del sector en el empleo regional, 2014. Por región de trabajo.", ///
		font("Times New Roman", 11) bold
}
