OLN-ISN
=======

Informe Sectorial Nacional.


Installation
############

Within Stata, type::

  net from "https://rawgit.com/igutierrezm/blopmatching/master"


Usage
############

::

   blopmatching [if] [in] , outcome(varname) treatment(varname) controls(varlist) [options]

where the ``outcome()`` must contain the outcome variable, ``treatment()`` must contain the treatment variable, and ``varlist`` must contain the covariates. Type::

   help blopmatching

for aditional details and examples.
