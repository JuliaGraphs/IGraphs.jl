using IGraphs
using TestItemRunner

# filter for the test
testfilter = ti -> begin
  exclude = Symbol[]
  if get(ENV,"JET_TEST","")!="true"
    push!(exclude, :jet)
  end
  if !(VERSION >= v"1.10")
    push!(exclude, :doctests)
    push!(exclude, :aqua)
  end

  return all(!in(exclude), ti.tags)
end


println("Starting tests with $(Threads.nthreads()) threads out of `Sys.CPU_THREADS = $(Sys.CPU_THREADS)`...")

@run_package_tests filter=testfilter


# --- GraphsCompat tests ---
try
    @info "Running GraphsCompat tests"
    include("gc_interface.jl")
    include("gc_conversions.jl")
catch err
    @error "GraphsCompat test files failed to load" exception=err
    rethrow()
end

# --- igraph backend dispatch tests for optional deps ---
include("gm_dispatch.jl")
include("go_dispatch.jl")
