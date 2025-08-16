# Graphs <-> igraph conversions (start with simplest cases)
import Graphs

# Construct from a Graphs.jl SimpleGraph
function GraphsCompat.IGSimpleGraph(gG::Graphs.SimpleGraph)
    n  = Graphs.nv(gG)
    el = collect(Graphs.edges(gG))             # edge objects
    # Build a 0-based edge list as a flat vector: [u0, v0, u0, v0, ...]
    edgelist0 = Vector{Int}(undef, 2*length(el))
    @inbounds for (k,e) in enumerate(el)
        edgelist0[2k-1] = src(e)-1
        edgelist0[2k]   = dst(e)-1
    end
    gptr = IGraphs.create_from_edgelist(n, edgelist0)  # helper provided by IGraphs
    return GraphsCompat.IGSimpleGraph(gptr, n)
end

# Back to Graphs.jl
function Base.convert(::Type{Graphs.SimpleGraph}, G::GraphsCompat.IGSimpleGraph)
    # pull igraph edge list and rebuild a SimpleGraph
    edgelist0 = IGraphs.get_edgelist(G.g)      # Vector{Int} like [u0,v0,u0,v0,...]
    n = G.n
    sg = Graphs.SimpleGraph(n)
    @inbounds for i in 1:2:length(edgelist0)
        Graphs.add_edge!(sg, edgelist0[i]+1, edgelist0[i+1]+1)
    end
    return sg
end
