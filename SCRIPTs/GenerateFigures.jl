"""
Generates PSTH of the source and target spiketimes, found under the given path, i.e. ARG[1],
and generates plots. It assumes that the following packages are available for installation of Julia
that is called:
	- DelimitedFiles
	- StatsBase
	- Printf
	- PyPlot
see `FUNCTIONs.jl` for more details.

# Arguments
- `DATAPATH::String`: path to parent directory containing subdirectories of experiments

# Authors
- Ali Hosseini amo.iso@tuta.io Aug 2023
"""

DATAPATH = ARGS[1]          # path to data
include("./FUNCTIONs.jl")   # loads functions
FIRING_RATE_PLOTs(DATAPATH)
