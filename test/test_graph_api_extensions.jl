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

@testset "connected_components" begin
    # Connected graph
    g = cycle_graph(5)
    cc = connected_components(g, IGraphAlg())
    @test length(cc) == 1
    @test sort(cc[1]) == [1, 2, 3, 4, 5]

    # Disconnected graph: path(3) + isolated vertices
    g2 = Graph(5)
    add_edge!(g2, 1, 2)
    add_edge!(g2, 2, 3)
    add_edge!(g2, 4, 5)
    cc2 = connected_components(g2, IGraphAlg())
    @test length(cc2) == 2
    cc2_sorted = sort(cc2; by=first)
    @test sort(cc2_sorted[1]) == [1, 2, 3]
    @test sort(cc2_sorted[2]) == [4, 5]

    # Match Graphs.jl result (same component grouping)
    cc_ref = connected_components(g2)
    @test length(cc2) == length(cc_ref)
    @test Set(Set.(cc2)) == Set(Set.(cc_ref))
end

@testset "is_connected" begin
    @test is_connected(cycle_graph(5), IGraphAlg()) == true
    g = Graph(4)
    add_edge!(g, 1, 2)
    add_edge!(g, 3, 4)
    @test is_connected(g, IGraphAlg()) == false
    @test is_connected(g, IGraphAlg()) == is_connected(g)
end

@testset "articulation" begin
    g = path_graph(5)
    art = articulation(g, IGraphAlg())
    art_ref = sort(articulation(g))
    @test art == art_ref

    g2 = cycle_graph(5)
    @test isempty(articulation(g2, IGraphAlg()))
end

@testset "bridges" begin
    g = path_graph(5)
    br = bridges(g, IGraphAlg())
    br_ref = bridges(g)
    @test Set(br) == Set(br_ref)

    g2 = cycle_graph(5)
    @test isempty(bridges(g2, IGraphAlg()))
end

end
