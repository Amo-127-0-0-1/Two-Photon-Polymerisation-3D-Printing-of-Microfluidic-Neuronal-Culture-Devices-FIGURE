# Two-Photon Polymerisation 3D-Printing of Microfluidic Neuronal Culture Devices (Figure)


[![DOI](https://zenodo.org/badge/675653333.svg)](https://zenodo.org/badge/latestdoi/675653333)


This repository contains data and scripts to generate figure panels of JoVe publication **"Two-Photon Polymerisation 3D Printing of Microfluidic Neuronal Culture Devices"**. The followings demonstrates installation and generation of figures, using Julia scripting language.
 

## Example installation for \*nix system:

- [Download](https://julialang-s3.julialang.org/bin/linux/x64/1.8/julia-1.8.5-linux-x86_64.tar.gz) Julia (v 1.8.5).

- Unpack it at preferred location.

- Installation of dependencies has been made easy through a bash script, directing to `Project.toml` file. Provide the absolute path to `julia` binary i.e. `/bin/julia`, through the command-line for `INSTALL.sh`. Open a terminal in parent directory that contains `INSTALL.sh` and `INSTALL` directory:
	
		
		bash INSTALL.sh path/to/julia
		

- The script will exit upon successful installation.


## Generating Figure

- Provide the absolute path to `julia` binary i.e. `/bin/julia`, to `RUN.sh`. Open a terminal in parent directory that contains `Run.sh`, `DATA` and `INSTALL` directories:

		
		bash RUN.sh path/to/julia
		

- Figures will be generated under `FIGUREs` directory.


### Authors

- [Ali Hosseini](https://github.com/Amo-127-0-0-1) Aug 2023 amo\.iso\@tuta\.io 


### Support

- open an issue and/or contact amo.iso@tuta.io