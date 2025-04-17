@testitem "Assorted API checks" begin

import Graphs
using IGraphs
using Test

@testset "vertex_coloring_greedy" begin
    g = IGraph(5)
    v = IGVectorInt()
    LibIGraph.vertex_coloring_greedy(g,v,LibIGraph.IGRAPH_COLORING_GREEDY_COLORED_NEIGHBORS)
    @test collect(v) == [0,0,0,0,0]

    g = IGraph(5)
    LibIGraph.ring(g, 5, false, false, true);
    v = IGVectorInt()
    LibIGraph.vertex_coloring_greedy(g,v,LibIGraph.IGRAPH_COLORING_GREEDY_COLORED_NEIGHBORS)
    @test collect(v) == [0,2,1,0,1]
end

end
