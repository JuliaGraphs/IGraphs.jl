@testitem "GraphsInterfaceChecker" begin
    using Graphs
    using IGraphs
    using Interfaces
    using GraphsInterfaceChecker

    g = IGraph(5)
    Graphs.add_edge!(g, 1, 2)
    Graphs.add_edge!(g, 2, 3)

    # Broken because `is_directed(typeof(g))` cannot know directedness
    # without `IGraph` being a parametric type `IGraph{Directed}`.
    @test_broken Interfaces.test(AbstractGraphInterface, IGraph, [g])
end
