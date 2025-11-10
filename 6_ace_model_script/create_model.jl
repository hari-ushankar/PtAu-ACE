using Pkg
Pkg.activate(".") ## add the path to your julia pkg file
Pkg.instantiate()
using Distributed
addprocs(31, exeflags="--project=$(Base.active_project())")
@everywhere using ACEpotentials
using ACEpotentials
using ExtXYZ
output_filename = read_extxyz("ALL_modified.xyz") ## training data file
at = output_filename
train = at
weights = Dict("default" => Dict("E" => 20.0, "F" => 4.0, "V" => 1.0))
c_size = 100
tdeg = 16
data_keys = (energy_key = "free_energy", force_key = "force", virial_key = "virial")
au_single =  -.15106143E-01
pt_single =  -.32912649E+00

model = acemodel(elements=[:Pt, :Au],
                 order = 3,
                 totaldegree=tdeg,
                 rcut=6.0,
                 #Eref=[:Pt => 0E+0,:Au => 0E+0])
                 Eref=[:Pt => pt_single, :Au => au_single])
P = smoothness_prior(model; p = 4) 
solver = ACEfit.BLR(committee_size = c_size, factorization=:svd); # 21 is previous choice; now 100
acefit!(model, train, prior=P; solver=solver, weights=weights, data_keys...);

# save potential using export2json function
export2json("./model.json",model)
# save potential using save_potential function

save_potential("./model_save.json",model)
# save potential using export2lammps function

export2lammps("PtAu.yace",model)
# compute training error
error_tab = ACEpotentials.linear_errors(train, model,weights=weights);
# Open a file in write mode
open("training_errors.txt", "w") do file
    # Use println or print with the file as the first argument
    println(file, "Training Error Table")
    println(file, "$error_tab.")
end

