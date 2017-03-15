* ISN - Infome Sectorial Nacional (script principal)

* Directorios (editar) 
global OLNTools "C:/Users/observatorio02/Documents/GitHub/OLN-Tools"
global proyecto "C:/Users/observatorio02/Documents/GitHub/OLN-ISN"
global datos    "C:/Users/observatorio02/Documents/BBDD/Stata"

* Solicitudes (editar)
global sectores "1"        // un numlist
global folders  "cuadros"  // "cuadros" y/o "consultas"
global cuadros  ".*"       // un regex

* Preámbulo
cls
clear all
set more off
set matsize 5000
foreach pkg in "" "_casen" "_ene" "_esi" "_pib" "_sii" {
	net install ol_tools`pkg', all force from("$OLNTools/src")  
}

* Cuerpo
foreach folder in $folders {
	noisily : display as text "`folder'/"
	local files : dir "$proyecto/src/`folder'" files "*.do", respectcase
	foreach file of local files {
		if regexm("`file'", "$cuadros.do") {
			run "$proyecto/src/`folder'/`file'"
			noisily : display as text _skip(4) "`file' completado"
		}
	}
}
beep
