# gm_dispatch.jl — tests for GraphsMatching dispatch via IGraphAlgorithm
using Test
using Graphs
using IGraphs
using IGraphs.GraphsCompat

# Only run if GraphsMatching is installed AND the method exists
if Base.find_package("GraphsMatching") !== nothing
    @info "Running GraphsMatching dispatch tests"
    import GraphsMatching

    @testset "GraphsMatching: maximum_matching dispatch" begin
        # Build a simple bipartite graph: left {1,2}, right {3,4}
        g = Graphs.SimpleGraph(4)
        add_edge!(g, 1, 3)
        add_edge!(g, 2, 4)
        types = Bool[true, true, false, false]  # partition labels (left=true)

        # Direct IG call
        ig = IGSimpleGraph(g)
        m1 = GraphsMatching.maximum_matching(ig; types=types)

        # Marker route from any AbstractGraph
        m2 = GraphsMatching.maximum_matching(g, IGraphAlgorithm(); types=types)

        @test m1 == m2
    end

    # Optional: weighted variant (only if your GraphsMatching has it)
    if isdefined(GraphsMatching, :maximum_weight_matching)
        @testset "GraphsMatching: maximum_weight_matching dispatch" begin
            g = Graphs.SimpleGraph(4)
            add_edge!(g, 1, 3)
            add_edge!(g, 2, 4)
            types = Bool[true, true, false, false]
            w = Dict((1,3)=>1.0, (2,4)=>2.0)  # minimal weight map example (adapt to your API)

            ig = IGSimpleGraph(g)
            mw1 = GraphsMatching.maximum_weight_matching(ig; weights=w, types=types)
            mw2 = GraphsMatching.maximum_weight_matching(g, IGraphAlgorithm(); weights=w, types=types)
            @test mw1 == mw2
        end
    end
else
    @info "GraphsMatching not installed; skipping GraphsMatching dispatch tests"
end
