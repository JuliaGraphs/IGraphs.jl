@testitem "JET analysis" tags=[:jet] begin

using Test
using IGraphs
using Pkg

# JET is not compatible with all Julia versions (e.g., Julia 1.13-beta).
# Install it conditionally and skip if unavailable.
jet_available = try
    Pkg.add("JET")
    @eval using JET
    true
catch e
    @info "JET.jl not available on Julia $VERSION: $e"
    false
end

if jet_available
    rep = report_package("IGraphs";
        ignored_modules=(
            LastFrameModule(Base),
            AnyFrameModule(IGraphs.LibIGraph)
        )
    )
    @show rep
    @test length(JET.get_reports(rep)) == 0
else
    @test true  # placeholder pass
end

end
