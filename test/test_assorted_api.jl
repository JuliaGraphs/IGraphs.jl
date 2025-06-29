@testitem "Assorted API checks" begin

import Graphs
using Graphs: ne, nv
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

@testset "NULL input arguments" begin
    g = Graphs.smallgraph(:karate)
    ig = IGraph(g)

    membership = IGVectorInt(zeros(nv(ig)))
    membership_null = IGVectorInt(zeros(nv(ig)))
    edge_weights = IGVectorFloat(ones(ne(ig)))
    node_weights = IGVectorFloat(ones(nv(ig)))

    res = LibIGraph.community_leiden(ig, edge_weights, node_weights, 0.05, 0.01, 0, 1, membership)
    res_null = LibIGraph.community_leiden(ig, IGNull(), IGNull(), 0.05, 0.01, 0, 1, membership_null)
    @test membership == membership_null
    @test res == res_null
end

end
