@testitem "JET analysis" tags=[:jet] begin

using JET
using Test
using IGraphs

rep = report_package("IGraphs";
    ignored_modules=(
        LastFrameModule(Base),
    )
)
@show rep
@test_broken length(JET.get_reports(rep)) == 0 # TODO JET does not work too great with the autogenerated methods we have

end
