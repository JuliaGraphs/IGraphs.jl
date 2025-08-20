using IGraphs
using TestItemRunner
using Test

# Run classic @testset-based file(s)
#include("test_igraph_shims.jl")   # <- adds your file

# Keep existing TestItemRunner flow
println("Starting tests with $(Threads.nthreads()) threads out of `Sys.CPU_THREADS = $(Sys.CPU_THREADS)`...")

testfilter = ti -> begin
    exclude = Symbol[]
    if get(ENV,"JET_TEST","") != "true"
        push!(exclude, :jet)
    end
    if !(VERSION >= v"1.10")
        push!(exclude, :doctests)
        push!(exclude, :aqua)
    end
    all(!in(exclude), ti.tags)
end

@run_package_tests filter=testfilter
