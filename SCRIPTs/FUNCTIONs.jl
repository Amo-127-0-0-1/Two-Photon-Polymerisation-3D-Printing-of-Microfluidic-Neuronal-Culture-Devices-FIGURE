




######### Packages #############
################################
using DelimitedFiles, StatsBase, Printf
using PyPlot
const plt = PyPlot


######### Helper Functions #####
################################
function READ_DIR_TXT(directory)
    # read all (first columns of) txt files under `directory` path
    col = Float64[]
    for file in readdir(directory)
        lines = readlines(joinpath(directory, file))
        col = vcat(col, parse.(Float64, [split(line, '\t')[1] for line in lines]))
    end
    return col
end

function READ_PARAMs(directory)
    params = READ_DIR_TXT(directory)
    return params[1], params[2], params[3], params[4]
end

function GEN_LIST(directory)
    num_files = length(readdir(directory))
    list_of_arrays = Vector{Vector{Float64}}(undef, num_files)  # Pre-allocate the vector of vectors
    for (idx, file) in enumerate(readdir(directory))
        lines = readlines(joinpath(directory, file))
        col = parse.(Float64, [split(line, '\t')[1] for line in lines])
        list_of_arrays[idx] = col  # Assign the current col array to its position in the list_of_arrays
    end
    return list_of_arrays
end

function HIST_ARRAY(array, edges)
    wbin = fit(Histogram, array[:, 1], edges).weights;
    return wbin
end

function HIST_MATRIX(array_list, edges)
    n_arrays    = length(array_list)
    n_edges     = length(edges) - 1
    hist_matrix = zeros(Float64, n_arrays, n_edges)
    for i in 1:n_arrays
        hist_matrix[i, :] = HIST_ARRAY(array_list[i], edges)
    end
    return hist_matrix
end

function MATRIX_M_STD_SUM(matrix)
    m     = mean(matrix, dims=1)
    std_  = std(matrix, dims=1)
    sum_  = sum(matrix, dims=1)
    return m, std_, sum_
end


######### Plotting #############
################################
function PLOT_RATEs(m_S, SEM_S, m_T, SEM_T, edges, fn)
    # Calculate upper and lower bounds for source and target responses
    upper_S = m_S .+ SEM_S
    lower_S = m_S .- SEM_S
    upper_T = m_T .+ SEM_T
    lower_T = m_T .- SEM_T
    # Modify the edges array to shift the time axis
    shifted_edges = edges .- 300  # Subtract 300 from all x-values
    # Plot mean and mean ± std 
    fig, ax = plt.subplots()
    ax.plot(shifted_edges[1:end-1], m_S[1, :], color="crimson", label="Source", lw=3)
    ax.fill_between(shifted_edges[1:end-1], lower_S[1, :], upper_S[1, :], alpha=0.65, color="lightcoral")
    ax.plot(shifted_edges[1:end-1], m_T[1, :], color="blue", label="Target", lw=3)
    ax.fill_between(shifted_edges[1:end-1], lower_T[1, :], upper_T[1, :], alpha=0.65, color="lightblue")
    # ax.axvline(300, linestyle="--", linewidth=2.3, dashes=(3, 3), color="black", label="Stimulation")
    ax.set_ylabel("PeriStimulus Spike-Times Histogram", fontsize=24)
    ax.set_xlabel("Time (ms)", fontsize=24)
    # ax.set_title(fn, fontsize=20)
    plt.xticks(fontsize=21, rotation=45)
    plt.yticks(fontsize=21)
    ax.set_ylim(0, 90)
    # ax.legend(loc="upper right", ncol=1, fontsize=16)
    fig.set_size_inches(10, 8)
    plt.tight_layout()
    plt.savefig(string("./", "instFR_$(fn).pdf"), format="pdf")
end


######### Main #################
################################
function FIRING_RATE_PLOTs(rootpath::AbstractString)
    base = pwd()
    cd(rootpath)
    ExpDirs = readdir()
    # loop over output sub-directories 
    for dir in ExpDirs
        # extract spiketimes
        SourceSpiketimes = GEN_LIST("$dir/spiketimes/SRC")
        TargetSpiketimes = GEN_LIST("$dir/spiketimes/TRG")
        # read params from disk
        T, D, SS, TS = READ_PARAMs("$dir/parameters/")
        # matrix of histograms
        edges = 0:D:T+D
        Source_histmat = HIST_MATRIX(SourceSpiketimes, edges)
        Target_histmat = HIST_MATRIX(TargetSpiketimes, edges)
        # normalization and firing frequency in Hz
        Source_histmat /= (SS*D*1/1000)
        Target_histmat /= (TS*D*1/1000)
        # Compute the mean,std, sum values
        m_S, std_S, sum_S = MATRIX_M_STD_SUM(Source_histmat)
        m_T, std_T, sum_T = MATRIX_M_STD_SUM(Target_histmat)
        # standard error of the mean
        REP_S, _ = size(Source_histmat)  # n repetitions of the stimulus for Source
        REP_T, _ = size(Target_histmat)  # n repetitions of the stimulus for Target
        SEM_S = std_S/sqrt(REP_S)
        SEM_T = std_T/sqrt(REP_T)
        # Plot mean response and standard error of the mean
        PLOT_RATEs(m_S, SEM_S, m_T, SEM_T, edges, dir)
    end
end
