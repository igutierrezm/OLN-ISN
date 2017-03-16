* Macros auxiliares y objetos temporales
local id "02-04"
tempfile df

* Loop sobre sectores
drop _all
save `df', replace emptyok
forvalues i = 1(1)13 {
  * Especificación
  .table = .ol_table.new
  .table.cmds       = "{total _counter}"
  .table.cmds_lb    = "{1: N}"
  .table.cmds_fmt   = "{%15,0fc}"
  .table.years      = "2016"
  .table.months     = "2 5 8 11"
  .table.subpops    = "{if (_ocupado == 1) & (_rama1_v1 == `i')}"
  .table.subpops_lb = "{1: Ocupados}"
  .table.by         = "_tamano_empresa"
  .table.along      = "_rama1_v1 _region_re_v1"
  .table.margins    = "{_region_re_v1} {_tamano_empresa}"
  .table.margins_lb = "{Nacional} {Total}"
  .table.src        = "ene"
  .table.from       = "$datos"
  .table.varlist0   = "_ocupado _rama1_v1 _region_re_v1 _tamano_empresa"

  * Estimación
  .table.create
  .table.annualize
  .table.add_proportions, cmd_lb("2: %") cmd_fmt("%15,1fc")
  .table.add_asterisks
  keep if (cmd_lb == 2)
  append2 using `df'
  save `df', replace
}
save "$proyecto/data/consultas/`id'.dta", replace
* El cuadro tiene demasiadas categoría para hacerlo de una pasada en mi PC
