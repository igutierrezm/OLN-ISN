* Macros auxiliares
local id "02-02"
local origen  "$proyecto/data/consultas"
local destino "$proyecto/data/cuadros"

* Especificación
.table = .ol_table.new
.table.rowvar = "_tamaño_empresa_v1"
.table.colvar = "_rama1_v1 subpop_lb cmd_lb"

* Preparación de la BBDD de Ocupados
tempfile df1 df2
forvalues j = 1(1)2 {
	* Ajustes preliminares
  use "`origen'/`id' [1].dta", clear
  keep if (cmd_type != "proportion")

	* Agregación (recordar que hay dos métodos)
	.table.annualize_v`j', over("_rama1_v1 _tamaño_empresa_v1")
	
	* Anexión N°1
	replace cmd_lb = 1
  save `df`j'', replace

  * Conversiones de totales a proporciones 
  .table.as_proportion, by("_tamaño_empresa_v1") along("_rama1_v1")
	
  * Anexión N°2
	replace cmd_lb = 2
  append using `df`j''
	save `df`j'', replace
}

* Preparación de la BBDD de Empresas
forvalues j = 1(1)2 {
	* Lectura
	use "`origen'/`id' [2].dta", clear
	
	* Corrección de la subpoblación
	replace subpop_lb = 2
	
	* Anexión
	append using `df`j''
	save `df`j'', replace
	
	* Etiquetado
	label define subpop_lb 1 "Ocupados" 2 "Empresas", modify
}	

* Exportación
forvalues i = 1(1)13 {
	forvalues j = 1(1)2 {
		* Preparación de la BBDD
		use `df`j'', clear
		keep if inlist(_rama1_v1, `i', 1e6)

		* Identificación del nombre del sector
		local name : label _rama1_v1 `i'
		label define _rama1_v1 `i' "Sector", modify

    * Exportación
		foreach var in bh cv {
			* Cuerpo
			local file "`destino'/`name'/`var' [`j'].xlsx"
			.table.export_excel `var', file("`file'") sheet("`id'")

			* Título
			putexcel set "`file'", sheet("`id'") modify
			putexcel A1 = ///
				"2.2. Número de empresas y ocupados por tamaño de empresa según número de trabajadores, incluyendo empresas unipersonales (cuenta propia), 2016", ///
				font("Times New Roman", 11) bold
		}
	}
}
