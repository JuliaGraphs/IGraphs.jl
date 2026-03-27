@testitem "GraphsInterfaceChecker" begin
    using Graphs
    using IGraphs
    using Interfaces
    using GraphsInterfaceChecker

    g = IGraph(5)
    Graphs.add_edge!(g, 1, 2)
    Graphs.add_edge!(g, 2, 3)

    @test Interfaces.test(AbstractGraphInterface, IGraph, [g])

    # Directed graph test
    dg = IGraph(5)
    LibIGraph.empty(dg, 5, true) # Directed
    Graphs.add_edge!(dg, 1, 2)
    Graphs.add_edge!(dg, 2, 3)
    @test Graphs.is_directed(dg)
    @test Interfaces.test(AbstractGraphInterface, IGraph, [dg])
end
