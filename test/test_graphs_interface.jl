@testitem "GraphsInterfaceChecker" begin

using IGraphs
using Graphs
using GraphsInterfaceChecker
using Interfaces
using Test

# Build a few representative graphs for testing
graphs = IGraph[
    IGraph(cycle_graph(5)),
    IGraph(path_graph(4)),
    IGraph(complete_graph(6)),
    IGraph(star_graph(5)),
]

# Test the mandatory part of the AbstractGraph interface
@test Interfaces.test(AbstractGraphInterface, IGraph, graphs; show=false)

# Test the optional mutation interface
@test Interfaces.test(AbstractGraphInterface{(:mutation,)}, IGraph, graphs; show=false)

@testset "edges roundtrip" begin
    for g in graphs
        sg = SimpleGraph(g)
        ig = IGraph(sg)
        @test Set(collect(edges(ig))) == Set(collect(edges(sg)))
        @test nv(ig) == nv(sg)
        @test ne(ig) == ne(sg)
    end
end

@testset "neighbors" begin
    g = IGraph(cycle_graph(5))
    @test sort(outneighbors(g, 1)) == [2, 5]
    @test sort(outneighbors(g, 3)) == [2, 4]
    @test inneighbors(g, 1) == outneighbors(g, 1)
end

@testset "has_edge" begin
    g = IGraph(path_graph(4))
    @test has_edge(g, 1, 2)
    @test has_edge(g, 2, 1)
    @test has_edge(g, 2, 3)
    @test !has_edge(g, 1, 3)
    @test !has_edge(g, 1, 4)
end

@testset "mutation" begin
    g = IGraph(path_graph(3))
    @test nv(g) == 3
    @test ne(g) == 2

    @test add_vertex!(g)
    @test nv(g) == 4
    @test add_edge!(g, 3, 4)
    @test ne(g) == 3
    @test has_edge(g, 3, 4)

    # Duplicate edge
    @test !add_edge!(g, 3, 4)
    # Self-loop
    @test !add_edge!(g, 1, 1)

    g2 = copy(g)
    @test nv(g2) == nv(g)
    @test ne(g2) == ne(g)
    add_vertex!(g2)
    @test nv(g2) == nv(g) + 1

    @test rem_vertex!(g, 4)
    @test nv(g) == 3
    @test ne(g) == 2
    @test !rem_vertex!(g, 10)
end

end
