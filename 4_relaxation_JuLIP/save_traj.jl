using Pkg
Pkg.activate(".") ## your julia Pkg file


using JuLIP
using ACEpotentials
using ExtXYZ
using Statistics
using CSV
using DataFrames

# Load model
mdl = read_dict(load_dict("../3_ACEmodels/ITER0/model.json")["IP"])

# Read initial structure
struct1 = read_extxyz("gb.xyz")[1]

# Set the calculator for the structure
set_calculator!(struct1, mdl)

# Define gtol values and corresponding labels
gtols = [5e-1, 3e-1, 1e-1, 5e-2, 2e-2]
labels = ["pos_relaxed_5e-1", "pos_relaxed_3e-1", "pos_relaxed_1e-1", "pos_relaxed_5e-2", "pos_relaxed_2e-2"]

# Perform vacancy creation, minimization, and save the structures
for site in 1:length(struct1)
    # Create a vacancy by removing the atom at the current site
    struct_vac = deepcopy(struct1)
    deleteat!(struct_vac, site)
    
    # Set the calculator for the structure with a vacancy
    set_calculator!(struct_vac, mdl)
    
    # Initialize dataframe to store stddev, filenames, and energies for each site
    df = DataFrame(Filename=String[], StdDev=Float64[], Energy=Float64[])
    structures = JuLIP.Atoms{Float64}[]  # Ensure correct type

    # Perform the minimization and save the structures using a loop
    for (i, gtol) in enumerate(gtols)
        minimise!(struct_vac, gtol=gtol)
        energy = ACE1.co_energy(mdl, struct_vac)[1]
        stddev = std(ACE1.co_energy(mdl, struct_vac)[2])
        push!(df, (Filename=labels[i], StdDev=stddev, Energy=energy))
        push!(structures, deepcopy(struct_vac))
    end

    # Create a directory for the current site
    dir_name = "site_$site"
    mkdir(dir_name)

    # Convert structures to an Array of JuLIP.Atoms{Float64}
    structures_array = Array{JuLIP.Atoms{Float64}, 1}(structures)

    # Save all the structures to a single file in the directory
    write_extxyz("$dir_name/iter1.extxyz", structures_array)

    # Save the stddev, filenames, and energies to a CSV file in the directory
    CSV.write("$dir_name/stddevs.csv", df)
end
