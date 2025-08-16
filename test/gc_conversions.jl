# Round-tripping between Graphs.SimpleGraph and our IG wrapper
using Test
using Graphs
using IGraphs
using IGraphs.GraphsCompat

@testset "GraphsCompat: conversions" begin
    sg  = Graphs.star_graph(10)
    ig  = GraphsCompat.IGSimpleGraph(sg)
    sg2 = convert(Graphs.SimpleGraph, ig)

    @test Graphs.nv(sg2) == Graphs.nv(sg)
    @test Graphs.ne(sg2) == Graphs.ne(sg)
end
