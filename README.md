# PtAu-ACE
This repository contains the data, MLIPs and the script for running the MLIP used in the paper titled: "Atomic Cluster Expansion modeling of vacancy energetics in Pt-Au alloys"

Following is a description of all the directories in this repo:

`1_installation`: Guide to install the required Julia packages for performing ACE regression and running the ACE models

`2_training_data`: Contains all the XYZ files used in the study create the ACE models

`3_ACEmodels`: Contains a figshare URL to download the ACE models (these files are too big to be uploaded onto Github)

`4_relaxation_JuLIP`: Contains a GB structure along with a Julia script to perform structural relaxation for vacancy at various sites in alloy GB structure.

`5_VASP_incar_data_generation`: provides a INCAR file to generate the energies, forces and stresses data for data generation

`6_ace_model_script`: Provides a julia script to run the ACE model regression

