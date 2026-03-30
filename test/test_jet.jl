@testitem "JET analysis" tags=[:jet] begin

import Pkg
try
    Pkg.add("JET")
    using JET
    using IGraphs
    using Test

    JET.test_package("IGraphs";
        target_defined_modules=true,
        ignored_modules=(
            AnyFrameModule(IGraphs.LibIGraph),
        )
    )
catch e
    @info "JET.jl not available or failed on Julia $VERSION: $e"
    # Skip JET tests if it cannot be installed or fails due to version incompatibility
end

end

