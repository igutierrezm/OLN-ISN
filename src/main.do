* ISN - Informe Sectorial Nacional (script principal)

* Housekeeping
set scrollbufsize 2000000
set matsize 10000
set more off
clear all
cls

* Macros globales
global sectores = "1 4 6 7"
global proyecto "C:/Users/Pedro/Documents/GitHub/OLN-ISN"
global datos    "C:/Users/Pedro/Documents/Oficina OLN/Datos/Stata"
global pkg      "C:/Users/Pedro/Documents/GitHub/OLN-Tools"

* Paquetes externos
foreach pkg in "" "_casen" "_ene" "_esi" "_pib" "_sii" {
	net install ol_tools`pkg', all force from("$pkg/src")
}

* Consultas y cuadros
foreach folder in "cuadros" {
	local files : dir "$proyecto/src/`folder'" files "*.do", respectcase
	foreach file of local files {
		* Active esto para ignorar todos los cuadros salvo una selección
		if !inlist("`file'", "05-11.do") continue
		* Mantenga esto siempre activado
		display as error "`file'"
		do "$proyecto/src/`folder'/`file'"
	}
}
beep
* Me faltan las secciones 4 y 5.
