// Copia el doc del programa
copy "man/oln_savelabels.smcl" "man/oln_savelabels.sthlp", replace

// cmdlog using "man/oln_savelabels.sthlp", append
log using "man/example", replace
sysuse auto
regress price mpg
log close

tempname fh
file open  `fh' using "man/example.smcl", read  text
file read  `fh' line
local linenum = 0
cls
while r(eof)==0 {
	local linenum = `linenum' + 1
	local str `"`macval(line)'"'
	file read `fh' line
	if (`linenum' < 8) continue
	if regexm(`"`str'"', "log close") exit
	display `"`str'"'
}

file close `fh'
