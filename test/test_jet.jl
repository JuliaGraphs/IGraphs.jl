@testitem "JET analysis" tags=[:jet] begin

using JET
using Test
using IGraphs

JET.test_package(IGraphs, target_defined_modules = true)

end
