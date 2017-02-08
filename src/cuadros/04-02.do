* Macros auxiliares
local id "04-02"
local origen  "$proyecto/data/consultas"
local destino "$proyecto/data/cuadros"

* Especificación
.table = .ol_table.new
.table.rowvar = "_tramo_edad_v1"
.table.colvar = "año _mujer"

* Preparación de la BBDD
tempfile df1 df2
forvalues j = 1(1)2 {
  * Ajustes preliminares
  use "`origen'/`id'.dta", clear
  keep if (cmd_type != "proportion")

  * Agregación y creación de proporciones (hay dos métodos)
  .table.annualize_v`j', over("_rama1_v1 _mujer _tramo_edad_v1")
  .table.as_proportion, by("_tramo_edad_v1") along("_rama1_v1 _mujer")

  * Guardado
  save `df`j'', replace
}

* Exportación
forvalues i = 1(1)1 {
	forvalues j = 1(1)1 {
		* Preparación de la BBDD
		use `df`j'', clear
		keep if inlist(_rama1_v1, `i')

		* Identificación del nombre del sector
		local name : label _rama1_v1 `i'
		label define _rama1_v1 `i' "Sector", modify

		* Exportación (cuerpo)
		local file "`destino'/`name'/bh [`j'].xlsx"
		.table.export_excel bh, file("`file'") sheet("`id'")
		*.table.export_excel cv, file("`file'") sheet("`id'")

		* Título
		local msg = "4.2. Ocupados del sector `name' por tramo de edad y sexo, 2010 y 2016"
		putexcel set "`file'", sheet("`id'") modify
		putexcel A1 = "`msg'", font("Times New Roman", 11) bold
	}
}
