* indicadores  :
*   1. % de asalariados con vacaciones pagadas
*   2. % de asalariados con días pagados por enfermedad
*   3. % de asalariados con cotización previsional o de pensión
*   4. % de asalariados con cotización por previsión de salud
*   5. % de asalariados con cotización por seguro de desempleo
*   6. % de asalariados con permiso por maternidad o paternidad
*   7. % de asalariados con servicio de guarderías infantiles
* subpoblación : ocupados
* años         : 2010 y 2015
* meses        :
* por          :
* según        : rama1
* agregaciones : rama1
* fuente       : ENE

* Preparativos
drop _all
tempfile df
save `df', emptyok

* Especificación
.table = .ol_table.new
  * Estadísticas
  .table.cmds      = "[delayed]"
  .table.cmds_lb   = "{%}"
  * Dominios
  .table.years     = "2010 2015"
  .table.months    = "2 5 8 11"
  .table.subpops   = "{if _asalariado == 1}"
  .table.by        = "[delayed]"
  .table.along     = "_rama1_v1"
  .table.aggregate = "{_rama1_v1}"
  * Estructura
  .table.rowvar    = "cmd_lb"
  .table.colvar    = "año _rama1_v1"
  * I-O
  .table.src       = "ene"
  .table.from      = "$datos"
  .table.varlist0  = "_asalariado _rama1_v1 _b7"

* Estimación
forvalues i = 1(1)7 {
  * Especificación
  .table.by       = "_b7_`i'"
  .table.cmds     = "{proportion _b7_`i'}"
  * Estimación
  .table.create
  .table.annualize
  * Homologación
  rename _b7_`i' _b7
  * Anexión
  replace cmd_lb = `i'
  append using "`df'"
  save "`df'", replace
}

* Etiquetado
label variable cmd_lb "Indicador de seguridad social"
# delimit ;
  label define cmd_lb
    1 "... vacaciones pagadas"
    2 "... días pagados por enfermedad"
    3 "... cotización previsional o de pensión"
    4 "... cotización por previsión de salud"
    5 "... cotización por seguro de desempleo"
    6 "... permiso por maternidad o paternidad"
    7 "... servicio de guarderías infantiles",
    modify;
# delimit cr
label values cmd_lb cmd_lb

* Guardado
save "$proyecto/data/tabla 05-03.dta", replace

* Exportación
keep if (_b7 == 1) & inlist(_rama1_v1, $sector, 1e6)
label variable cmd_lb "% de trabajadores dependientes con ..."
.table.export_excel bh, file("$proyecto/data/tabla 05-03.xlsx")
.table.export_excel cv, file("$proyecto/data/tabla 05-03.xlsx")
