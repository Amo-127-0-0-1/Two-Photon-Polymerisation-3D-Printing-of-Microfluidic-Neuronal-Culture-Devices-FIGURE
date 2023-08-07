#!/bin/bash
 
JULIA=$1
cd INSTALL

$JULIA --project=Project.toml install_precompile.jl && exit 0
