* indicadores  : % de personas con beneficios de seguridad social
*								(7 indicadores en total)
* subpoblación : ocupados
* años         : 2010 y 2015
* meses        :
* por          :
* según        : sector
* agregaciones : sector"
* fuente       : ENE

* Especificación
.table = .ol_table.new
  * Estadísticas
  .table.cmds      = ""  // (init)
  .table.masks     = "%"
  * Dominios
  .table.years     = "2010 2015"
  .table.months    = "2 5 8 11"
  .table.subpop    = "if _ocupado == 1"
  .table.by        = ""  // (init)
  .table.along     = "_rama1_v1"
  .table.aggregate = "_rama1_v1"
  * Estructura
  .table.rowvar    = ""  // (init)
  .table.colvar    = ""  // (init)
  * I-O
  .table.src       = "ene"
  .table.varlist0  = ""  // (init)

* Estimación
drop _all
tempfile df
save `df', emptyok
forvalues v = 1(1)7 {
  * Estimación
  .table.cmds     = `""proportion _b7_v`v'""'
  .table.by       = "_b7_v`v'"
  .table.varlist0 = `""_ocupado" "_rama1_v1" "_b7, v(`v')""'
	.table.create
  .table.annualize
  * Homologación
  rename _b7_v`v' _b7
  generate v = `v'
  * Anexión
  append using `df'
  save `df', replace
}

* Etiquetado
# delimit ;
label variable v "Indicador de seguridad social";
label define v
  1 "... vacaciones pagadas"
  2 "... días pagados por enfermedad"
  3 "... cotización previsional o de pensión"
  4 "... cotización por previsión de salud"
  5 "... cotización por seguro de desempleo"
  6 "... permiso por maternidad o paternidad"
  7 "... servicio de guarderías infantiles",
  modify;
# delimit cr
label values v v

* Guardado
save "$proyecto/data/tabla 05-03", replace

* Exportación
keep if (_b7 == 1) & inlist(_rama1_v1, $sector, 1e6)
label variable v "% de trabajadores con ..."
.table.rowvar = "v"
.table.colvar = "año _rama1_v1"
.table.export_excel bh, file("tabla 05-03")
.table.export_excel cv, file("tabla 05-03")
