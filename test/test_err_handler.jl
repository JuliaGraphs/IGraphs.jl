@testitem "Error handler" begin
using Test
using IGraphs

g = IGraph()
LibIGraph.empty(g, 4, false)
@test_throws IGraphException LibIGraph.get_eid(g, 1, 2, false, true)

end
