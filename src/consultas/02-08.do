* Macros auxiliares y objetos temporales
local id "02-08"
local cmd_lb1 "% de trabajadores con vacaciones pagadas"
local cmd_lb2 "% de trabajadores con días pagados por enfermedad"
local cmd_lb3 "% de trabajadores con cotización previsional o de pensión"
local cmd_lb4 "% de trabajadores con cotización por previsión de salud"
local cmd_lb5 "% de trabajadores con cotización por seguro de desempleo"
local cmd_lb6 "% de trabajadores con permiso por maternidad o paternidad"
local cmd_lb7 "% de trabajadores con servicio de guarderías infantiles"
tempfile df

* Loop principal
drop _all
save `df', emptyok
forvalues i = 1(1)7 {
  * Especificación
  .table = .ol_table.new
  .table.cmds       = "{total _counter}"
  .table.cmds_lb    = "{0: N}"
  .table.cmds_fmt   = "{%15,0fc}"
  .table.years      = "2016"
  .table.months     = "2 5 8 11"
  .table.subpops    = "{if _asalariado == 1}"
  .table.subpops_lb = "{1: Asalariados}"
  .table.by         = "_b7_`i'"
  .table.along      = "_rama1_v1 _tamano_empresa"
  .table.margins    = "{_tamano_empresa}"
  .table.margins_lb = "{Sector}"
  .table.src        = "ene"
  .table.from       = "$datos"
  .table.varlist0   = "_asalariado _b7 _rama1_v1 _tamano_empresa"

  * Estimación
  .table.create
  .table.annualize
  .table.add_proportions, cmd_lb("`i': `cmd_lb`i''") cmd_fmt("%15,1fc")
  .table.add_asterisks
  keep if (cmd_lb == `i') & (_b7_`i' == 1)
  append2 using `df'
  save `df', replace
}
drop _b7*
save "$proyecto/data/consultas/`id'.dta", replace
