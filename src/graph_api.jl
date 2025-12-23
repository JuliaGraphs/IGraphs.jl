function IGraph(n::Integer)
    g = IGraph(_uninitialized=Val(true))
    LibIGraph.empty(g,n,false)
    return g
end


function Graphs.SimpleGraphs.SimpleGraph(ig::IGraph)
    n = LibIGraph.vcount(ig)
    g = Graphs.SimpleGraphs.SimpleGraph{Int}(n)
    adjlist = IGAdjList()
    LibIGraph.adjlist_init(ig,adjlist,LibIGraph.IGRAPH_ALL,LibIGraph.IGRAPH_LOOPS_TWICE,LibIGraph.IGRAPH_MULTIPLE)
    for i in 1:n
        neigh = IGVectorInt(Ref(unsafe_load(adjlist.objref[].adjs,i)))
        for k in 1:LibIGraph.vector_int_size(neigh)
            j = LibIGraph.vector_int_get(neigh,k-1)+1
            i<j && Graphs.add_edge!(g,i,j)
        end
    end
    return g
end


function IGraph(g::Graphs.AbstractSimpleGraph)
    n = Graphs.nv(g)
    ig = IGraph(n)
    for (;src,dst) in Graphs.edges(g)
        LibIGraph.add_edge(ig, src-1, dst-1)
    end
    return ig
end


Base.eltype(::IGraph) = LibIGraph.igraph_int_t
Base.zero(::Type{IGraph}) = IGraph(0)
# Graphs.edges # TODO
function Graphs.edges(g::IGraph)
    edge_list = Vector{Graphs.edgetype(g)}()
    adjlist = IGAdjList()
    LibIGraph.adjlist_init(g,adjlist,LibIGraph.IGRAPH_ALL,LibIGraph.IGRAPH_LOOPS_TWICE,LibIGraph.IGRAPH_MULTIPLE)
    for i in Graphs.vertices(g)
        neigh = IGVectorInt(Ref(unsafe_load(adjlist.objref[].adjs,i)))
        for k in 1:LibIGraph.vector_int_size(neigh)
            j = LibIGraph.vector_int_get(neigh,k-1)+1
            if i < j
                push!(edge_list,Graphs.SimpleGraphs.SimpleEdge(i,j))
            end
        end
    end
    return edge_list
end
Graphs.edgetype(g::IGraph) = Graphs.SimpleGraphs.SimpleEdge{eltype(g)} # TODO maybe expose the edge id information from IGraph
Graphs.has_edge(g::IGraph,s,d) = LibIGraph.get_eid(g,s,d,false,false)[1]!=-1
Graphs.has_vertex(g::IGraph,n::Integer) = 1≤n≤Graphs.nv(g)
# Graphs.inneighbors # TODO
Graphs.is_directed(::Type{IGraph}) = false # TODO support directed graphs
Graphs.ne(g::IGraph) = LibIGraph.ecount(g)
Graphs.nv(g::IGraph) = LibIGraph.vcount(g)
# Graphs.outneighbors # TODO
Graphs.vertices(g::IGraph) = 1:Graphs.nv(g)

Graphs.add_edge!(g::IGraph, e::Graphs.SimpleGraphEdge) = LibIGraph.add_edge(g,e.src-1,e.dst-1)
