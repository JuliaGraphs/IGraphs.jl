using Test
using IGraphs
import IGraphs: IGraphShims
using Graphs
#using GraphsInterfaceChecker

# Test numeric constants
@testset "Numeric Constants" begin
    @test IGraphShims.IGRAPH_INFINITY === Inf
    @test IGraphShims.IGRAPH_NEGINFINITY === -Inf
    @test IGraphShims.IGRAPH_NAN === NaN
    @test IGraphShims.IGRAPH_REAL === Float64
    @test IGraphShims.IGRAPH_VCOUNT_MAX === typemax(Int)
    @test IGraphShims.IGRAPH_ECOUNT_MAX === typemax(Int)
end

# Test iteration helpers
@testset "Iteration Helpers" begin
    vit = IGraphShims._VertexIter([1, 2, 3], 1)
    @test IGraphShims.IGRAPH_VIT_GET(vit) == 1
    IGraphShims.IGRAPH_VIT_NEXT(vit)
    @test IGraphShims.IGRAPH_VIT_GET(vit) == 2
    IGraphShims.IGRAPH_VIT_RESET(vit)
    @test IGraphShims.IGRAPH_VIT_GET(vit) == 1
    @test !IGraphShims.IGRAPH_VIT_END(vit)
    @test IGraphShims.IGRAPH_VIT_SIZE(vit) == 3

    eit = IGraphShims._EdgeIter([1, 2, 3], 1)
    @test IGraphShims.IGRAPH_EIT_GET(eit) == 1
    IGraphShims.IGRAPH_EIT_NEXT(eit)
    @test IGraphShims.IGRAPH_EIT_GET(eit) == 2
    IGraphShims.IGRAPH_EIT_RESET(eit)
    @test IGraphShims.IGRAPH_EIT_GET(eit) == 1
    @test !IGraphShims.IGRAPH_EIT_END(eit)
    @test IGraphShims.IGRAPH_EIT_SIZE(eit) == 3
end

# Test ad/inclist helpers
@testset "Ad/inclist Helpers" begin
    adj = [[1, 2], [3, 4], [5, 6]]
    @test IGraphShims.igraph_adjlist_get(adj, 1) == [1, 2]
    @test IGraphShims.igraph_adjlist_get(adj, 2) == [3, 4]
    @test IGraphShims.igraph_adjlist_get(adj, 3) == [5, 6]
    @test_throws BoundsError IGraphShims.igraph_adjlist_get(adj, 4)

    inc = [[1, 2], [3, 4], [5, 6]]
    @test IGraphShims.igraph_inclist_get(inc, 1) == [1, 2]
    @test IGraphShims.igraph_inclist_get(inc, 2) == [3, 4]
    @test IGraphShims.igraph_inclist_get(inc, 3) == [5, 6]
    @test_throws BoundsError IGraphShims.igraph_inclist_get(inc, 4)
end

# Test small graph constructors
@testset "Small Graph Constructors" begin
    g = IGraphShims.igraph_lcf(5, [1, 2], 2)
    @test g.n == 5
    @test g.shifts == [1, 2]
    @test g.reps == 2

    g = IGraphShims.igraph_small(5; edges=[0, 1, 1, 2, 2, 3, 3, 4], directed=false)
    @test g.n == 5
    @test g.edges == [(1, 2), (2, 3), (3, 4), (4, 5)]
    @test !g.directed

    vs = IGraphShims.igraph_vs_vector_small([0, 1, 2])
    @test vs == [0, 1, 2]

    es = IGraphShims.igraph_es_pairs_small([0, 1, 1, 2])
    @test es == [(0, 1), (1, 2)]

    es = IGraphShims.igraph_es_path_small([0, 1, 2])
    @test es == [0, 1, 2]
end

# Test status / progress / warning / error handlers
@testset "Status / Progress / Warning / Error Handlers" begin
    @test_logs (:info, r"\$igraph\$ \$status\$") IGraphShims.igraph_statusf("test %d", 1)
    @test_logs (:info, r"\$igraph\$ \$progress\$") IGraphShims.igraph_progressf("test %d", 1)
    @test_logs (:warn, r"\$igraph\$ \$warn\$") IGraphShims.igraph_warningf("test %d", 1)
    @test_throws ErrorException IGraphShims.igraph_fatalf("test %d", 1)
    @test_logs (:error, r"\$igraph\$ \$error\$") IGraphShims.igraph_errorf("test %d", 1)
    @test_logs (:error, r"\$igraph\$ \$error\$") IGraphShims.igraph_errorvf("test %d", 1)
end


# Test bit helpers
@testset "Bit Helpers" begin
    @test IGraphShims.IGRAPH_BIT_SLOT(0) == 0
    @test IGraphShims.IGRAPH_BIT_MASK(0) == UInt64(1)
    x = UInt64(0)
    x = IGraphShims.IGRAPH_BIT_SET(x, 0)
    @test x == UInt64(1)
    x = IGraphShims.IGRAPH_BIT_CLEAR(x, 0)
    @test x == UInt64(0)
    @test !IGraphShims.IGRAPH_BIT_TEST(x, 0)
    @test IGraphShims.IGRAPH_BIT_NSLOTS(0) == 0
    @test IGraphShims.IGRAPH_BIT_NSLOTS(64) == 1
end

# Test Graphs interface
#@testset "Graphs Interface" begin
#    g = IGraphShims.igraph_small(5; edges=[0, 1, 1, 2, 2, 3, 3, 4], directed=false)
#    graph = SimpleGraph(g.n)
#    for e in g.edges
#        add_edge!(graph, e...)
#    end
#    @test GraphsInterfaceChecker.is_valid_graph(graph)
#end


@testset "Graphs Interface" begin
    # Define the number of vertices and edge list
    num_vertices = 5
    edge_list = [0, 1, 1, 2, 2, 3, 3, 4]

    # Create an igraph object
    igraph = IGraphShims.igraph_small(num_vertices; edges=edge_list, directed=false)

    # Create a SimpleGraph object and add edges
    graph = SimpleGraph(igraph.n)
    for e in igraph.edges
        add_edge!(graph, e...)
    end

    # Test if the graph is valid
    @test !is_directed(graph)
    @test nv(graph) == num_vertices
    @test ne(graph) == length(edge_list) ÷ 2
end

