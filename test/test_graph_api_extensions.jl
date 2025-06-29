@testitem "Additions to the wider Graph Algorithms API" begin

using Graphs
using Graphs.Experimental
using IGraphs
using Test
using Random

@testset "tests with isomorphic graphs" begin
    for repetition in 1:10
        g = random_regular_graph(10, 8)
        m = adjacency_matrix(g)
        p = randperm(nv(g))
        m = m[p,p]
        gp = Graph(m)

        @test has_isomorph(g, gp) == has_isomorph(g, gp, IGraphAlg()) == true
        @test diameter(g) == diameter(gp, IGraphAlg())
        @test radius(g) == radius(gp, IGraphAlg())
    end
end

end
