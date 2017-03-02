* Macros auxiliares y objetos temporales
local id "05-08"
local lb1v1 "{1: Escolaridad promedio}"
local lb2v1 "{2: Edad promedio}"
local lb3v1 "{3: Ingreso promedio de la ocupación principal}"
local lb4v1 "{0: N}"
local lb5v1 "{0: N}"
local lb4v2 "4: % mujeres"
local lb5v2 "5: % capacitados"
tempfile df1 df2 df3 df4 df5

*===============================================================================
* Panel N°1 - Escolaridad promedio
*===============================================================================

* Especificación
.table = .ol_table.new
.table.cmds       = "{mean _esc}"
.table.cmds_lb    = "{1: Escolaridad promedio}"
.table.cmds_fmt   = "{%15,1fc}"
.table.years      = "2016"
.table.months     = "2 5 8 11"
.table.subpops    = "{if _ocupado == 1}"
.table.subpops_lb = "{1: Ocupados}"
.table.by         = ""
.table.along      = "_rama1_v1 _oficio1"
.table.margins    = "{_oficio1}"
.table.margins_lb = "{Sector}"
.table.src        = "ene"
.table.from       = "$datos"
.table.varlist0   = "_esc _ocupado _oficio1 _rama1_v1"

* Estimación
.table.create
.table.annualize
.table.add_asterisks
save `df1', replace

*===============================================================================
* Panel N°2 - Edad promedio
*===============================================================================

* Especificación
.table = .ol_table.new
.table.cmds       = "{mean _edad}"
.table.cmds_lb    = "{2: Edad promedio}"
.table.cmds_fmt   = "{%15,1fc}"
.table.years      = "2016"
.table.months     = "2 5 8 11"
.table.subpops    = "{if _ocupado == 1}"
.table.subpops_lb = "{1: Ocupados}"
.table.by         = ""
.table.along      = "_rama1_v1 _oficio1"
.table.margins    = "{_oficio1}"
.table.margins_lb = "{Sector}"
.table.src        = "ene"
.table.from       = "$datos"
.table.varlist0   = "_edad _ocupado _oficio1 _rama1_v1"

* Estimación
.table.create
.table.annualize
.table.add_asterisks
save `df2', replace

*===============================================================================
* Panel N°3 - Ingreso promedio de la ocupación principal
*===============================================================================

* Especificación
.table = .ol_table.new
.table.cmds       = "{mean _yprincipal}"
.table.cmds_lb    = "{3: Ingreso promedio de la ocupación principal}"
.table.cmds_fmt   = "{%15,1fc}"
.table.years      = "2015"
.table.months     = ""
.table.subpops    = "{if _mantuvo_empleo == 1}"
.table.subpops_lb = "{1: Ocupados}"
.table.by         = ""
.table.along      = "_rama1_v1 _oficio1"
.table.margins    = "{_oficio1}"
.table.margins_lb = "{Sector}"
.table.src        = "esi"
.table.from       = "$datos"
.table.varlist0   = "_mantuvo_empleo _oficio1 _rama1_v1 _yprincipal"

* Estimación
.table.create
.table.add_asterisks
save `df3', replace

*===============================================================================
* Panel N°4 - Porcentaje de mujeres
*===============================================================================

* Especificación
.table = .ol_table.new
.table.cmds       = "{total _counter}"
.table.cmds_lb    = "{0: N}"
.table.cmds_fmt   = "{%15,1fc}"
.table.years      = "2016"
.table.months     = "2 5 8 11"
.table.subpops    = "{if _ocupado == 1}"
.table.subpops_lb = "{1: Ocupados}"
.table.by         = "_mujer"
.table.along      = "_rama1_v1 _oficio1"
.table.margins    = "{_oficio1}"
.table.margins_lb = "{Sector}"
.table.src        = "ene"
.table.from       = "$datos"
.table.varlist0   = "_mujer _ocupado _oficio1 _rama1_v1"

* Estimación
.table.create
.table.annualize
.table.add_proportions, cmd_lb("4: % de mujeres") cmd_fmt("%15,1fc")
.table.add_asterisks
keep if (cmd_lb == 4) & (_mujer == 1)
save `df4', replace

*===============================================================================
* Panel N°5 - Porcentaje de capacitados
*===============================================================================

* Especificación
.table = .ol_table.new
.table.cmds       = "{proportion _capacitado}"
.table.cmds_lb    = "{5: % de capacitados}"
.table.cmds_fmt   = "{%15,1fc}"
.table.years      = "2015"
.table.months     = ""
.table.subpops    = "{if _ocupado == 1}"
.table.subpops_lb = "{1: Ocupados}"
.table.by         = "_capacitado"
.table.along      = "_rama1_v1 _oficio1"
.table.margins    = "{_oficio1}"
.table.margins_lb = "{Sector}"
.table.src        = "casen"
.table.from       = "$datos"
.table.varlist0   = "_capacitado _ocupado _oficio1 _rama1_v1"

* Estimación
.table.create
.table.add_asterisks
keep if (_capacitado == 1)
save `df5', replace

*===============================================================================
* Consulta final
*===============================================================================

* Consolidado
use `df5', clear
forvalues i = 4(-1)1 {
  append2 using `df`i''
}
drop _mujer _capacitado
save "$proyecto/data/consultas/`id'.dta", replace
