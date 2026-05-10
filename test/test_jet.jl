@testitem "JET analysis" tags=[:jet] begin
    using JET
    using IGraphs
    using Test

    JET.test_package("IGraphs";
        target_defined_modules=true,
        ignored_modules=(
            AnyFrameModule(IGraphs.LibIGraph),
        )
    )
end

