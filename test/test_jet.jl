@testitem "JET analysis" tags=[:jet] begin

using JET
using Test
using VNGraphs

rep = report_package("VNGraphs";
    ignored_modules=(
        LastFrameModule(Base),
    )
)
@show rep
@test length(JET.get_reports(rep)) == 0

end
