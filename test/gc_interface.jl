# GraphsCompat interface smoke tests + checker
using Test
using Graphs
using IGraphs
using IGraphs.GraphsCompat

@testset "GraphsCompat: basic interface" begin
    g = Graphs.grid([3,3])                 # a tiny undirected graph
    ig = GraphsCompat.IGSimpleGraph(g)

    @test Graphs.nv(ig) == 9
    @test Graphs.ne(ig) > 0
    @test !isempty(Graphs.neighbors(ig, 1))
end

# Optional: run the full interface checker if available
const _HAS_GIC = let ok = true
    try
        @eval using GraphsInterfaceChecker
    catch
        ok = false
        @warn "GraphsInterfaceChecker not available; skipping full interface checks"
    end
    ok
end

if _HAS_GIC
    @testset "GraphsCompat: GraphsInterfaceChecker" begin
        # helper: build an IG graph with n vertices and a simple chain
        make_ig(n) = begin
            sg = Graphs.SimpleGraph(n)
            for i in 1:n-1
                Graphs.add_edge!(sg, i, i+1)
            end
            GraphsCompat.IGSimpleGraph(sg)
        end
        @test GraphsInterfaceChecker.check_abstractgraph_interface(() -> make_ig(10); undirected=true)
    end
end
