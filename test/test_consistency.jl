@testitem "Consistency checks" begin

import Graphs
using IGraphs
using Test

for i in 1:100
    g = Graphs.random_regular_graph(10, 8)
    ig = IGraph(g)
    g2 = Graphs.Graph(ig)
    @test g2 == g

    @test LibIGraph.radius(ig,LibIGraph.IGRAPH_ALL)[1] == Graphs.radius(g) == Graphs.radius(g2)
end

end
