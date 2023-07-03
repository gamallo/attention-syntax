#!/bin/bash

ROTA="scripts"
frase=$1
echo $frase

python3 $ROTA/attention.py "${frase}" > __temp

more __temp |$ROTA/cleaning.perl |$ROTA/extraction.perl |$ROTA/selection_number.perl "${frase}" 
