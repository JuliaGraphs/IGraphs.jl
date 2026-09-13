@testitem "Consistency checks" begin

import Graphs
using IGraphs
using Test

for i in 1:100
    g = Graphs.random_regular_graph(10, 8)
    ig = IGraph(g)
    g2 = Graphs.Graph(ig)
    @test g2 == g

    @test LibIGraph.radius(ig,IGNull(),LibIGraph.IGRAPH_ALL)[1] == Graphs.radius(g) == Graphs.radius(g2)
    @test all(Graphs.has_edge(ig,s,d) == Graphs.has_edge(g,s,d) for s in 1:10, d in 1:10)
end

end
