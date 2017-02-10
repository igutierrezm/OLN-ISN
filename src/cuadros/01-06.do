* Macros auxiliares
local id "01-06"
local origen  "$proyecto/data/consultas"
local destino "$proyecto/data/cuadros"

* Especificación
.table = .ol_table.new
.table.rowvar = "_region_tr_v1"
.table.colvar = "cmd_lb"

* Preparación de la BBDD de Ocupados
tempfile df1 df2
forvalues j = 1(1)2 {
	* Ajustes preliminares
  use "`origen'/`id' [1].dta", clear
  keep if (cmd_type != "proportion")

	* Agregación (recordar que hay dos métodos)
	.table.annualize_v`j', over("_rama1_v2 _region_tr_v1")

  * Conversión de totales a proporciones
  .table.as_proportion, by("_rama1_v2") along("_region_tr_v1")

  * Anexión
	replace cmd_lb = 1
	save `df`j'', replace
}

* Preparación de la BBDD del PIB
forvalues j = 1(1)2 {
	* Lectura
	use "`origen'/`id' [2].dta", clear

	* Etiquetado
	label define cmd_lb ///
		1 "Participación del empleo del sector en la región" ///
		2 "Participación del PIB del sector en la región", ///
		modify
		
	* Anexión
	append using `df`j''
	save `df`j'', replace
}

* Exportación
forvalues i = 1(1)11 {
	forvalues j = 1(1)1 {
		* Preparación de la BBDD
		use `df`j'', clear
		keep if inlist(_rama1_v2, `i')

		* Identificación del nombre del sector
		local name : label _rama1_v2 `i'
		label define _rama1_v2 `i' "Sector", modify

    * Exportación
		foreach var in bh cv {
			* Cuerpo
			local file "`destino'/`name'/`var' [`j'].xlsx"
			.table.export_excel `var', file("`file'") sheet("`id'")

			* Título
			putexcel set "`file'", sheet("`id'") modify
			putexcel A1 = ///
				"1.6. Participación del PIB del sector `name' en el PIB regional y participación del sector en el empleo regional, 2014. Por región de trabajo.", ///
				font("Times New Roman", 11) bold
		}
	}
}
