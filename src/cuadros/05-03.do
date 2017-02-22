* Macros auxiliares
local id "05-03"
local origen  "$proyecto/data/consultas"
local destino "$proyecto/data/cuadros"
local bylist  `""" "" "" "_mujer" "_capacitado""'
tempfile df1

* Especificación de cuadro
.table = .ol_table.new
.table.rowvar = "cmd_lb"
.table.colvar = "_rama1_v1 año"

* Preparación de la BBDD
drop _all
save `df1', emptyok
forvalues k = 1(1)7 {
	* BBDD
	use "`origen'/`id' [`k'].dta", clear

	* Agregación y creación de proporciones (hay dos métodos)
	.table.annualize_v2, over("_rama1_v1 _b7_`k'")
	.table.as_proportion, by("_b7_`k'") along("_rama1_v1")
	.table.add_asterisks, add_over("_b7_`k'")
	keep if (_b7_`k' == 1)
	drop _b7_`k'

	* Anexión
	replace cmd_lb = `k'
	append using `df1'
	save `df1', replace
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
save `df1', replace

* Exportación del cuadro
save "$proyecto/data/cuadros/`id'", replace
forvalues i = 1(1)13 {
	* BBDD
	use `df1', clear
	keep if inlist(_rama1_v1, `i', 1e6)

	* Identificación del archivo de destino
	local name : label _rama1_v1 `i'
	label define _rama1_v1 `i' "Sector", modify
	local file "`destino'/`name'/bh.xlsx"

	* Exportación
	.table.export_excel bh, file("`file'") sheet("`id'")
	putexcel set "`file'", sheet("`id'") modify
	putexcel A1 = ///
		"5.3. Indicadores de seguridad social de trabajadores dependientes del sector `name' según género, 2010 y 2016", ///
		font("Times New Roman", 11) bold
}
