function IGraph(n::Integer, directed::Bool=false)
    g = IGraph(_uninitialized=Val(true), directed=directed)
    LibIGraph.empty(g, n, directed)
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
    directed = Graphs.is_directed(g)
    edges_vec = LibIGraph.igraph_int_t[]
    sizehint!(edges_vec, 2 * Graphs.ne(g))
    for e in Graphs.edges(g)
        push!(edges_vec, Graphs.src(e) - 1)
        push!(edges_vec, Graphs.dst(e) - 1)
    end
    vint = IGVectorInt(edges_vec)
    ig = IGraph(_uninitialized=Val(true), directed=directed)
    LibIGraph.igraph_create(ig.objref, vint.objref, n, directed)
    return ig
end


Base.eltype(::IGraph) = LibIGraph.igraph_int_t
Base.zero(::Type{IGraph}) = IGraph(0)
struct IGraphEdgeIterator
    g::IGraph
end
Base.length(it::IGraphEdgeIterator) = Graphs.ne(it.g)
Base.eltype(::Type{IGraphEdgeIterator}) = Graphs.SimpleGraphs.SimpleEdge{Int}
function Base.iterate(it::IGraphEdgeIterator, state=0)
    state >= Graphs.ne(it.g) && return nothing
    from, to = LibIGraph.edge(it.g, state)
    return (Graphs.SimpleGraphs.SimpleEdge(from + 1, to + 1), state + 1)
end
Graphs.edges(g::IGraph) = IGraphEdgeIterator(g)
Graphs.edgetype(g::IGraph) = Graphs.SimpleGraphs.SimpleEdge{eltype(g)} # TODO maybe expose the edge id information from IGraph
function Graphs.has_edge(g::IGraph, s::Integer, d::Integer)
    (s < 1 || s > Graphs.nv(g) || d < 1 || d > Graphs.nv(g)) && return false
    eid = Ref{Int}(-1)
    LibIGraph.igraph_get_eid(g.objref, eid, s-1, d-1, Graphs.is_directed(g), false)
    return eid[] != -1
end
Graphs.has_vertex(g::IGraph,n::Integer) = 1≤n≤Graphs.nv(g)
function Graphs.inneighbors(g::IGraph, v::Integer)
    neis = IGVectorInt()
    LibIGraph.neighbors(g, neis, v-1, LibIGraph.IGRAPH_IN, LibIGraph.IGRAPH_LOOPS, true)
    return [LibIGraph.vector_int_get(neis, i-1) + 1 for i in 1:LibIGraph.vector_int_size(neis)]
end

Graphs.is_directed(g::IGraph{Directed}) where Directed = Directed
Graphs.is_directed(::Type{<:IGraph{Directed}}) where Directed = Directed

Graphs.ne(g::IGraph) = LibIGraph.ecount(g)
Graphs.nv(g::IGraph) = LibIGraph.vcount(g)

function Graphs.outneighbors(g::IGraph, v::Integer)
    neis = IGVectorInt()
    LibIGraph.neighbors(g, neis, v-1, LibIGraph.IGRAPH_OUT, LibIGraph.IGRAPH_LOOPS, true)
    return [LibIGraph.vector_int_get(neis, i-1) + 1 for i in 1:LibIGraph.vector_int_size(neis)]
end
Graphs.vertices(g::IGraph) = 1:Graphs.nv(g)

Graphs.add_edge!(g::IGraph, e::Graphs.AbstractEdge) = Graphs.add_edge!(g, Graphs.src(e), Graphs.dst(e))
Graphs.add_edge!(g::IGraph, s::Integer, d::Integer) = (LibIGraph.igraph_add_edge(g.objref, s-1, d-1) == 0)

function Graphs.rem_edge!(g::IGraph, s::Integer, d::Integer)
    eid = Ref{Int}(-1)
    LibIGraph.igraph_get_eid(g.objref, eid, s-1, d-1, Graphs.is_directed(g), false)
    eid[] == -1 && return false
    es = Ref{LibIGraph.igraph_es_t}()
    LibIGraph.igraph_es_1(es, eid[])
    return LibIGraph.igraph_delete_edges(g.objref, es[]) == 0
end
Graphs.rem_edge!(g::IGraph, e::Graphs.AbstractEdge) = Graphs.rem_edge!(g, Graphs.src(e), Graphs.dst(e))

function Graphs.add_vertex!(g::IGraph)
    LibIGraph.igraph_add_vertices(g.objref, 1, C_NULL)
    return true
end

function Graphs.add_vertices!(g::IGraph, n::Integer)
    LibIGraph.igraph_add_vertices(g.objref, n, C_NULL)
    return n
end

function Graphs.rem_vertex!(g::IGraph, v::Integer)
    (v < 1 || v > Graphs.nv(g)) && return false
    vs = Ref{LibIGraph.igraph_vs_t}()
    LibIGraph.igraph_vs_1(vs, v-1)
    return LibIGraph.igraph_delete_vertices(g.objref, vs[]) == 0
end

function Graphs.rem_vertices!(g::IGraph, vs::AbstractVector)
    # Convert Julia 1-based indices to 0-based
    vint = IGVectorInt([Int(v-1) for v in vs])
    igraph_vs = Ref{LibIGraph.igraph_vs_t}()
    LibIGraph.igraph_vs_vector(igraph_vs, vint.objref)
    res = LibIGraph.igraph_delete_vertices(g.objref, igraph_vs[])
    return res == 0
end

Graphs.neighbors(g::IGraph, v::Integer) = Graphs.outneighbors(g, v)

function Graphs.all_neighbors(g::IGraph, v::Integer)
    neis = IGVectorInt()
    LibIGraph.neighbors(g, neis, v-1, LibIGraph.IGRAPH_ALL, LibIGraph.IGRAPH_LOOPS, true)
    return [LibIGraph.vector_int_get(neis, i-1) + 1 for i in 1:LibIGraph.vector_int_size(neis)]
end

function Graphs.degree(g::IGraph, v::Integer)
    return LibIGraph.degree(g, v-1, LibIGraph.IGRAPH_ALL, LibIGraph.IGRAPH_LOOPS)[1]
end

function Graphs.indegree(g::IGraph, v::Integer)
    return LibIGraph.degree(g, v-1, LibIGraph.IGRAPH_IN, LibIGraph.IGRAPH_LOOPS)[1]
end

function Graphs.outdegree(g::IGraph, v::Integer)
    return LibIGraph.degree(g, v-1, LibIGraph.IGRAPH_OUT, LibIGraph.IGRAPH_LOOPS)[1]
end

function Graphs.has_self_loops(g::IGraph)
    res = Ref{LibIGraph.igraph_bool_t}()
    LibIGraph.igraph_has_loop(g.objref, res)
    return Bool(res[])
end

function Graphs.num_self_loops(g::IGraph)
    count = 0
    # This is slow, but correct for now. igraph might have a better way but it's not obvious.
    for e in Graphs.edges(g)
        if Graphs.src(e) == Graphs.dst(e)
            count += 1
        end
    end
    return count
end

function Base.copy(g::IGraph{Directed}) where Directed
    # igraph_copy is not wrapped in LibIGraph.jl in a high-level way usually, 
    # but we can use the raw one and wrap it.
    new_g = IGraph(_uninitialized=Val(true), directed=Directed)
    LibIGraph.igraph_copy(new_g.objref, g.objref)
    return new_g
end
