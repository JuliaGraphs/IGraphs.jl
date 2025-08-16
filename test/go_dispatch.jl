# go_dispatch.jl — tests for GraphsOptim dispatch via IGraphAlgorithm
using Test
using Graphs
using IGraphs
using IGraphs.GraphsCompat

if Base.find_package("GraphsOptim") !== nothing
    @info "Running GraphsOptim dispatch tests"
    import GraphsOptim

    @testset "GraphsOptim: minimum_cut / maximum_flow dispatch" begin
        # Small undirected graph for cut/flow sanity
        g = Graphs.SimpleGraph(4)
        add_edge!(g, 1, 2)
        add_edge!(g, 2, 3)
        add_edge!(g, 3, 4)

        # Direct IG
        ig = IGSimpleGraph(g)
        # Guard in case a function is not present in your GraphsOptim version
        if isdefined(GraphsOptim, :minimum_cut)
            c1 = GraphsOptim.minimum_cut(ig)
            c2 = GraphsOptim.minimum_cut(g, IGraphAlgorithm())
            @test c1 == c2
        end

        if isdefined(GraphsOptim, :maximum_flow)
            # Build a simple digraph s=1, t=4: 1→2→3→4
            d = Graphs.SimpleDiGraph(4)
            add_edge!(d, 1, 2); add_edge!(d, 2, 3); add_edge!(d, 3, 4)

            id = IGSimpleDiGraph(d)
            f1 = GraphsOptim.maximum_flow(id, 1, 4)
            f2 = GraphsOptim.maximum_flow(d, IGraphAlgorithm(), 1, 4)
            @test f1 == f2
        end

        if isdefined(GraphsOptim, :gomory_hu_tree)
            # GH-tree is typically for undirected graphs
            gh1 = GraphsOptim.gomory_hu_tree(ig)
            gh2 = GraphsOptim.gomory_hu_tree(g, IGraphAlgorithm())
            @test gh1 == gh2
        end
    end
else
    @info "GraphsOptim not installed; skipping GraphsOptim dispatch tests"
end
