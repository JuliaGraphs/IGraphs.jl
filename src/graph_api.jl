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
Graphs.edgetype(g::IGraph) = Graphs.SimpleGraphs.SimpleEdge{eltype(g)} # TODO maybe expose the edge id information from IGraph
Graphs.has_edge(g::IGraph,s,d) = LibIGraph.get_eid(g,s-1,d-1,false,false)[1]!=-1
Graphs.has_vertex(g::IGraph,n::Integer) = 1≤n≤Graphs.nv(g)
Graphs.is_directed(::Type{IGraph}) = false # TODO support directed graphs
Graphs.ne(g::IGraph) = LibIGraph.ecount(g)
Graphs.nv(g::IGraph) = LibIGraph.vcount(g)
Graphs.vertices(g::IGraph) = 1:Graphs.nv(g)

struct IGraphEdgeIterator
    graph::IGraph
end

Base.length(it::IGraphEdgeIterator) = Graphs.ne(it.graph)
Base.eltype(::Type{IGraphEdgeIterator}) = Graphs.SimpleGraphs.SimpleEdge{LibIGraph.igraph_int_t}

function Base.iterate(it::IGraphEdgeIterator, eid=0)
    eid ≥ Graphs.ne(it.graph) && return nothing
    (from, to) = LibIGraph.edge(it.graph, eid)
    return (Graphs.SimpleGraphs.SimpleEdge(from+1, to+1), eid+1)
end

Graphs.edges(g::IGraph) = IGraphEdgeIterator(g)

function Graphs.outneighbors(g::IGraph, v::Integer)
    neis = IGVectorInt()
    LibIGraph.neighbors(g, neis, v-1, LibIGraph.IGRAPH_ALL, LibIGraph.IGRAPH_NO_LOOPS, LibIGraph.IGRAPH_NO_MULTIPLE)
    result = Vector{LibIGraph.igraph_int_t}(undef, length(neis))
    for i in eachindex(result)
        result[i] = neis[i] + 1
    end
    return sort!(result)
end

Graphs.inneighbors(g::IGraph, v::Integer) = Graphs.outneighbors(g, v)

function Graphs.add_edge!(g::IGraph, s::Integer, d::Integer)
    s == d && return false  # no self-loops for simple graphs
    Graphs.has_edge(g, s, d) && return false
    LibIGraph.add_edge(g, s-1, d-1)
    return true
end
Graphs.add_edge!(g::IGraph, e::Graphs.SimpleGraphEdge) = Graphs.add_edge!(g, e.src, e.dst)

function Graphs.add_vertex!(g::IGraph)
    LibIGraph.igraph_add_vertices(g.objref, LibIGraph.igraph_int_t(1), C_NULL)
    return true
end

function Graphs.rem_vertex!(g::IGraph, v::Integer)
    Graphs.has_vertex(g, v) || return false
    vs = LibIGraph.igraph_vss_1(LibIGraph.igraph_int_t(v-1))
    LibIGraph.igraph_delete_vertices(g.objref, vs)
    return true
end

function Base.copy(g::IGraph)
    g2 = IGraph(;_uninitialized=Val(true))
    LibIGraph.copy(g2, g)
    return g2
end
