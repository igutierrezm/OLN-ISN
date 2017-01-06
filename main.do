* ISN - Informe Sectorial Nacional (script principal)

*===============================================================================
* Intrucciones
*===============================================================================

* 1. Visite https://github.com/igutierrezm.
* 2. Clone el repo OLN-Tools y guárdelo en, digamos, `github'.

* Housekeeping
set more off
clear all
cls

* Directorios principales (ajustar)
global datos    "C:/Users/Pedro/Documents/Oficina OLN/Datos/Stata"
global proyecto "C:/Users/Pedro/Documents/GitHub/OLN-ISN"

* Paquetes externos
local github "C:/Users/Pedro/Documents/GitHub/OLN-Tools/src"
net install ol_tools_casen, all force from("`github'")
net install ol_tools_ene,   all force from("`github'")
net install ol_tools_esi,   all force from("`github'")
net install ol_tools,       all force from("`github'")

* Instalación vía internet (experimental - no usar)
* local url "https://rawgit.com/igutierrezm/OLN-Tools/master/src"
* net install ol_tools_casen, all from("`url'")
* net install ol_tools_ene,   all from("`url'")
* net install ol_tools_esi,   all from("`url'")
* net install ol_tools,       all from("`url'")

*===============================================================================
* Cuerpo
*===============================================================================

* Tablas:
local files : dir "$proyecto/scripts/tablas" files "tabla 06-01-01.do"
foreach file of local files {
	do "$proyecto/scripts/tablas/`file'"
}
beep
