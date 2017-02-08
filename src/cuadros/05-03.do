* Macros auxiliares
local id "05-03"
local origen  "$proyecto/data/consultas"
local destino "$proyecto/data/cuadros"
local bylist  `""" "" "" "_mujer" "_capacitado""'

* Especificación de cuadro
.table = .ol_table.new
.table.rowvar = "cmd_lb"
.table.colvar = "_rama1_v1 año"

* Preparación de la BBDD
tempfile df1 df2
forvalues j = 1(1)2 {
	drop _all
	save `df`j'', emptyok
	forvalues k = 1(1)7 {
		* Ajustes preliminares
		use "`origen'/`id' [`k'].dta", clear
		drop if (cmd_type == "proportion")
		
		* Agregación y creación de proporciones (hay dos métodos)
		.table.annualize_v`j', over("_rama1_v1 _b7_`k'")
		.table.as_proportion, by("_b7_`k'") along("_rama1_v1")
		keep if (_b7_`k' == 1)
		drop _b7_`k'
		
		* Anexión
		replace cmd_lb = `k' 
		append using `df`j''
		save `df`j'', replace
	}
	* Etiquetado
	label variable cmd_lb "Indicador de seguridad social"
	# delimit ;
		label define cmd_lb
			1 "% de trabajadores con vacaciones pagadas"
			2 "% de trabajadores con días pagados por enfermedad"
			3 "% de trabajadores con cotización previsional o de pensión"
			4 "% de trabajadores con cotización por previsión de salud"
			5 "% de trabajadores con cotización por seguro de desempleo"
			6 "% de trabajadores con permiso por maternidad o paternidad"
			7 "% de trabajadores con servicio de guarderías infantiles",
			modify;
	# delimit cr
	label values cmd_lb cmd_lb
	
	* Guardado
	save `df`j'', replace
}

* Exportación del cuadro
forvalues i = 1(1)1 {
	forvalues j = 1(1)1 {
		* BBDD
		use `df`j'', clear
		keep if inlist(_rama1_v1, `i', 1e6)

		* Identificación del nombre del sector
		local name : label _rama1_v1 `i'
		label define _rama1_v1 `i' "Sector", modify

		* Exportación (cuerpo)
		local file "`destino'/`name'/bh [`j'].xlsx"
		.table.export_excel bh, file("`file'") sheet("`id'")
		*.table.export_excel cv, file("`file'") sheet("`id'")

		* Título
		local msg = "5.3. Indicadores de seguridad social de trabajadores dependientes del sector `name', 2010 y 2016."
		putexcel set "`file'", sheet("`id'") modify
		putexcel A1 = "`msg'", font("Times New Roman", 11) bold
	}
}
