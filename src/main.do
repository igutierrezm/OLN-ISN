* ISN - Informe Sectorial Nacional (script principal)

* Housekeeping
set scrollbufsize 2000000
set more off
clear all
cls

* Macros globales
global sector    = 3
global sector_lb = "Minería" 
global proyecto "C:/Users/Pedro/Documents/GitHub/OLN-ISN"
global datos    "C:/Users/Pedro/Documents/Oficina OLN/Datos/Stata"
global pkg      "C:/Users/Pedro/Documents/GitHub/OLN-Tools"

* Paquetes externos
foreach pkg in "" "_casen" "_ene" "_esi" "_pib" "_sii" {
	net install ol_tools`pkg', all force from("$pkg/src")
}

/***
* Ejecución de una consulta/tabla específica
local folder "cuadros"
local file   "02-06.do"
do "$proyecto/src/`folder'/`file'"
beep
***/

/***/
* Ejecución completa
foreach folder in "cuadros" {
	local files : dir "$proyecto/src/`folder'" files "05-*.do"
	foreach file of local files {
	display as error "`file'"
		do "$proyecto/src/`folder'/`file'"
	}
}
beep
/***/
