@testitem "JET analysis" tags=[:jet] begin

using JET
using Test
using IGraphs

rep = report_package("IGraphs";
    ignored_modules=(
        LastFrameModule(Base),
        AnyFrameModule(IGraphs.LibIGraph)
    )
)
@show rep
@test length(JET.get_reports(rep)) == 0

end
