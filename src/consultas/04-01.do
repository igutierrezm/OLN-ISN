* Macros auxiliares y objetos temporales
local id          "04-01"
local lb1v1 "{1: Edad promedio}"
local lb2v1 "{2: Escolaridad promedio}"
local lb3v1 "{0: Educación superior completa (%)}"
local lb4v1 "{0: Mujeres (%)}"
local lb3v2 "3: Educación superior completa (%)"
local lb4v2 "4: Mujeres (%)"
tempfile df

* Loop principal
drop _all
local i = 1
save `df', emptyok
foreach var in "_edad" "_esc" "_superior_completa" "_mujer" {
  * Especificación
  .table = .ol_table.new
  .table.cmds       = "{total _counter}"
  .table.cmds_lb    = "`lb`i'v1'"
  .table.cmds_fmt   = "{%15,0fc}"
  .table.years      = "2016"
  .table.months     = "2 5 8 11"
  .table.subpops    = "{if _ocupado == 1}"
  .table.subpops_lb = "{1: Ocupados}"
  .table.by         = "`var'"
  .table.along      = "_rama1_v1"
  .table.margins    = "{_rama1_v1}"
  .table.margins_lb = "{Nacional}"
  .table.src        = "ene"
  .table.from       = "$datos"
  .table.varlist0   = "_ocupado _rama1_v1 `var'"
  if (`i' == 2) .table.cmds_fmt = "{%15,1fc}"
  if (`i' <= 2) .table.cmds     = "{mean `var'}"
  if (`i' <= 2) .table.by       = ""

  * Estimación
  .table.create
  .table.annualize
  if (`i' >= 3) .table.add_proportions, cmd_lb("`lb`i'v2'") cmd_fmt("%15,0fc")
  if (`i' >= 3) keep if (cmd_lb == `i') & (`var' == 1)
  if (`i' >= 3) drop `var'
  .table.add_asterisks
  append2 using `df'
  save `df', replace
  local ++i
}
save "$proyecto/data/consultas/`id'.dta", replace
