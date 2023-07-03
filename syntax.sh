#!/bin/bash

ROTA="scripts"

sh attention.sh "a nena que xoga no parque é linda" > __temp2
cat __temp2 | $ROTA/parsing.perl ./dep/gold.txt |$ROTA/ranking.perl 
