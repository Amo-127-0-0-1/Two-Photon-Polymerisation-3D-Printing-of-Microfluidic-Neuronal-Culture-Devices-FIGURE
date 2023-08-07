#!/bin/bash

JULIA=$1
BASE=$(pwd)
INSTALL=$BASE/INSTALL
SCRIPTs=$BASE/SCRIPTs
DATA=$BASE/DATA

$JULIA --project=$INSTALL/Project.toml $SCRIPTs/GenerateFigures.jl $DATA 
mkdir -p $BASE/FIGUREs
mv $DATA/*.pdf $BASE/FIGUREs && exit 0
