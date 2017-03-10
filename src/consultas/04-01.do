* Macros auxiliares y objetos temporales
local id "04-01"
local lb1 "1: Edad promedio"
local lb2 "2: Escolaridad promedio"
local lb3 "3: Educación superior completa (%)"
local lb4 "4: Mujeres (%)"
local lb5 "5: Ingreso promedio oc. principal"
tempfile df

* Loop principal
drop _all
local i = 1
save `df', emptyok
foreach var in "_edad" "_esc" "_superior_completa" "_mujer" "_yprincipal" {
  * Especificación
  .table = .ol_table.new
  .table.cmds       = "{mean `var'}"
  .table.cmds_lb    = "{`lb`i''}"
  .table.cmds_fmt   = "{%15,1fc}"
  .table.years      = "2016"
  .table.months     = "2 5 8 11"
  .table.subpops    = "{if _ocupado == 1}"
  .table.subpops_lb = "{1: Ocupados}"
  .table.by         = ""
  .table.along      = "_rama1_v1"
  .table.margins    = "{_rama1_v1}"
  .table.margins_lb = "{Nacional}"
  .table.src        = "ene"
  .table.from       = "$datos"
  .table.varlist0   = "_ocupado _rama1_v1 `var'"
  if inlist(`i', 3, 4) {
    .table.cmds = "{total _counter}"
    .table.by   = "`var'"
  }
  if (`i' == 5) {
    .table.cmds_fmt   = "{%15,0fc}"
    .table.years      = "2015"
    .table.months     = ""
    .table.subpops    = "{if _mantuvo_empleo == 1}"
    .table.subpops_lb = "{2: Ocupados que mantuvieron su empleo}"
    .table.varlist0   = "_mantuvo_empleo _rama1_v1 `var'"
    .table.src        = "esi"
  }

  * Estimación
  .table.create
  if (`i' != 5) .table.annualize
  if inlist(`i', 3, 4) .table.add_proportions, cmd_fmt("%15,1fc") replace
  if inlist(`i', 3, 4) keep if (`var' == 1)
  if inlist(`i', 3, 4) drop `var'
  .table.add_asterisks
  append2 using `df'
  save `df', replace
  local ++i
}
save "$proyecto/data/consultas/`id'.dta", replace
