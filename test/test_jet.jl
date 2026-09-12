@testitem "JET analysis" tags=[:jet] begin

using JET
using Test
using IGraphs

# Generated pointer accessors use getfield to reject unknown properties.
JET.test_package(IGraphs, target_modules = (IGraphs,), ignored_modules = (IGraphs.LibIGraph,))

end
