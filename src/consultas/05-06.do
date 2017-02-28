* Macros auxiliares y objetos temporales
local id "05-06"
local cmd_lb1 "Subempleo"
local cmd_lb2 "Horas Excesivas"
tempfile df

* Loop principal
drop _all
local i = 1
save `df', emptyok
foreach var in "_jparcial_inv" "_exceso_hr_int" {
  * Especificación
  .table = .ol_table.new
  .table.cmds       = "{total _counter}"
  .table.cmds_lb    = "{0: N}"
  .table.cmds_fmt   = "{%15,0fc}"
  .table.years      = "2010 2016"
  .table.months     = "2 5 8 11"
  .table.subpops    = "{if (_ocupado == 1) & inlist(_cise_v1, 2, 3, 1e6)}"
  .table.subpops_lb = "{1: Cuenta Propia}"
  .table.by         = "`var'"
  .table.along      = "_rama1_v1 _cise_v1"
  .table.margins    = "{_cise_v1} {_rama1_v1}"
  .table.margins_lb = "{Total} {Nacional}"
  .table.src        = "ene"
  .table.from       = "$datos"
  .table.varlist0   = "_cise_v1 _ocupado _rama1_v1 `var'"

  * Estimación
  .table.create
  .table.annualize
  .table.add_proportions, cmd_lb("`i': `cmd_lb`i''") cmd_fmt("%15,0fc")
  .table.add_asterisks
  keep if (cmd_lb == `i') & (`var' == 1)
  append2 using `df'
  save `df', replace
  local ++i
}
drop _jparcial_inv _exceso_hr_int
save "$proyecto/data/consultas/`id'.dta", replace
