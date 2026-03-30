# test/interface.jl

@testitem "GraphsInterfaceChecker" begin

using IGraphs
using Graphs
using GraphsInterfaceChecker
using Interfaces
using Test

# Build a few representative graphs for testing (undirected)
undirected_graphs = IGraph[
    IGraph(cycle_graph(5)),
    IGraph(path_graph(4)),
    IGraph(complete_graph(6)),
    IGraph(star_graph(5)),
]

# Build a few representative graphs for testing (directed)
directed_graphs = IGraph[
    IGraph(cycle_digraph(5)),
    IGraph(path_digraph(4)),
    IGraph(complete_digraph(6)),
    IGraph(star_digraph(5)),
]

all_graphs = vcat(undirected_graphs, directed_graphs)

# Test the mandatory part of the AbstractGraph interface
@test Interfaces.test(AbstractGraphInterface, IGraph, all_graphs; show=false)

# Test the optional mutation interface
@test Interfaces.test(AbstractGraphInterface{(:mutation,)}, IGraph, all_graphs; show=false)

@testset "consistency" begin
    for g in undirected_graphs
        @test !is_directed(g)
        @test !is_directed(typeof(g))
    end
    for g in directed_graphs
        @test is_directed(g)
        @test is_directed(typeof(g))
    end
end

@testset "edges roundtrip" begin
    for g in all_graphs
        sg = is_directed(g) ? SimpleDiGraph(g) : SimpleGraph(g)
        # Test conversion back and forth
        ig = IGraph(sg)
        @test Set(collect(edges(ig))) == Set(collect(edges(sg)))
        @test nv(ig) == nv(sg)
        @test ne(ig) == ne(sg)
        @test is_directed(ig) == is_directed(sg)
    end
end

@testset "neighbors" begin
    g = IGraph(cycle_graph(5))
    @test sort(outneighbors(g, 1)) == [2, 5]
    @test sort(outneighbors(g, 3)) == [2, 4]
    @test sort(inneighbors(g, 1)) == [2, 5]
    
    # Directed neighbors
    dg = IGraph(cycle_digraph(5))
    @test outneighbors(dg, 1) == [2]
    @test inneighbors(dg, 1) == [5]
end

@testset "has_edge" begin
    g = IGraph(path_graph(4))
    @test has_edge(g, 1, 2)
    @test has_edge(g, 2, 1)
    @test has_edge(g, 2, 3)
    @test !has_edge(g, 1, 3)
    @test !has_edge(g, 1, 4)
    
    # Directed has_edge
    dg = IGraph(path_digraph(4))
    @test has_edge(dg, 1, 2)
    @test !has_edge(dg, 2, 1)
end

@testset "mutation" begin
    # Test mutation for both directed and undirected
    for directed in [false, true]
        g = directed ? IGraph(path_digraph(3)) : IGraph(path_graph(3))
        @test nv(g) == 3
        @test ne(g) == 2

        @test add_vertex!(g)
        @test nv(g) == 4
        @test add_edge!(g, 3, 4)
        @test ne(g) == 3
        @test has_edge(g, 3, 4)

        # Note: igraph supports multigraphs by default, but we can verify 
        # that basic vertex removal and edge additions work as expected.
        
        g2 = copy(g)
        @test nv(g2) == nv(g)
        @test ne(g2) == ne(g)
        add_vertex!(g2)
        @test nv(g2) == nv(g) + 1

        @test rem_vertex!(g, 4)
        @test nv(g) == 3
        # In a directed path_digraph(3) + edge(3,4) - vertex(4), we should be back to 2 edges
        @test ne(g) == 2
        @test !rem_vertex!(g, 10)
    end
end

end
