# Explicit import/export of the functions
# that are getting new methods,
# so that `igraphalg_methods` can pick them up.
import Graphs: diameter, radius, pagerank, betweenness_centrality,
    core_number, closeness_centrality, eigenvector_centrality, modularity,
    connected_components, strongly_connected_components
import Graphs.Experimental
import Graphs.Experimental: has_isomorph

export diameter, radius, has_isomorph, pagerank, betweenness_centrality,
    core_number, closeness_centrality, eigenvector_centrality, modularity,
    connected_components, strongly_connected_components

struct IGraphAlg end

"""Lists all functions for which an IGraphAlg method is defined"""
function igraphalg_methods()
    filter(names(@__MODULE__)) do s
        f = getproperty(@__MODULE__, s)
        f isa Function || return false
        any(methods(f)) do m
            sig = m.sig isa UnionAll ? m.sig.body : m.sig
            any(t -> t isa Type && t <: IGraphAlg, sig.parameters)
        end
    end
end

function diameter(g, ::IGraphAlg)
    return LibIGraph.diameter(IGraph(g), IGNull(), IGNull(), IGNull(), false, false)[1]
end

function radius(g, ::IGraphAlg)
    return LibIGraph.radius(IGraph(g), IGNull(), LibIGraph.IGRAPH_ALL)[1]
end

function has_isomorph(g1, g2, ::IGraphAlg)
    return LibIGraph.isomorphic(IGraph(g1), IGraph(g2))[1]
end

function pagerank(g::Graphs.AbstractGraph{U}, ::IGraphAlg; damping=0.85) where U<:Integer
    ig = IGraph(g)
    res = IGVectorFloat()
    val = Ref{Float64}()
    err = LibIGraph.igraph_pagerank(ig.objref[], LibIGraph.IGRAPH_PAGERANK_ALGO_PRPACK, res.objref[], val, LibIGraph.igraph_vss_all(), Graphs.is_directed(g), damping, C_NULL, C_NULL)
    if err != 0
        error("igraph_pagerank failed with code $err")
    end
    sz = LibIGraph.vector_size(res)
    return [LibIGraph.vector_get(res, i-1) for i in 1:sz]
end

function betweenness_centrality(g::Graphs.AbstractGraph, ::IGraphAlg)
    ig = IGraph(g)
    res = IGVectorFloat()
    err = LibIGraph.igraph_betweenness(ig.objref[], C_NULL, res.objref[], LibIGraph.igraph_vss_all(), Graphs.is_directed(g), false)
    if err != 0
        error("igraph_betweenness failed with code $err")
    end
    sz = LibIGraph.vector_size(res)
    return [LibIGraph.vector_get(res, i-1) for i in 1:sz]
end


function core_number(g::Graphs.AbstractGraph, ::IGraphAlg)
    ig = IGraph(g)
    res = IGVectorInt()
    mode = Graphs.is_directed(g) ? LibIGraph.IGRAPH_OUT : LibIGraph.IGRAPH_ALL
    LibIGraph.igraph_coreness(ig.objref, res.objref, mode)
    return collect(res)
end

function closeness_centrality(g::Graphs.AbstractGraph, ::IGraphAlg)
    ig = IGraph(g)
    res = IGVectorFloat()
    mode = Graphs.is_directed(g) ? LibIGraph.IGRAPH_OUT : LibIGraph.IGRAPH_ALL
    # reachable_count and all_reachable can be NULL if not needed
    LibIGraph.igraph_closeness(ig.objref, res.objref, C_NULL, C_NULL, 
        LibIGraph.igraph_vss_all(), 
        mode, C_NULL, true)
    return collect(res)
end

function eigenvector_centrality(g::Graphs.AbstractGraph, ::IGraphAlg)
    ig = IGraph(g)
    res = IGVectorFloat()
    mode = Graphs.is_directed(g) ? LibIGraph.IGRAPH_OUT : LibIGraph.IGRAPH_ALL
    val = Ref{Float64}(0.0)
    LibIGraph.igraph_eigenvector_centrality(ig.objref, res.objref, val, mode, C_NULL, C_NULL)
    return collect(res)
end

function modularity(g::Graphs.AbstractGraph, c::AbstractVector{<:Integer}, ::IGraphAlg)
    ig = IGraph(g)
    membership = IGVectorInt([Int(x-1) for x in c])
    res = Ref{Float64}(0.0)
    LibIGraph.igraph_modularity(ig.objref, membership.objref, C_NULL, 1.0, Graphs.is_directed(g), res)
    return res[]
end

function connected_components(g::Graphs.AbstractGraph, ::IGraphAlg)
    ig = IGraph(g)
    membership = IGVectorInt()
    csize = IGVectorInt()
    no = Ref{LibIGraph.igraph_int_t}(0)
    LibIGraph.igraph_connected_components(ig.objref, membership.objref, csize.objref, no, LibIGraph.IGRAPH_WEAK)
    
    n_comp = Int(no[])
    mem = collect(membership)
    comps = [Int[] for _ in 1:n_comp]
    for (i, m_val) in enumerate(mem)
        push!(comps[m_val + 1], i)
    end
    return comps
end

function strongly_connected_components(g::Graphs.AbstractGraph, ::IGraphAlg)
    ig = IGraph(g)
    membership = IGVectorInt()
    csize = IGVectorInt()
    no = Ref{LibIGraph.igraph_int_t}(0)
    LibIGraph.igraph_connected_components(ig.objref, membership.objref, csize.objref, no, LibIGraph.IGRAPH_STRONG)
    
    n_comp = Int(no[])
    mem = collect(membership)
    comps = [Int[] for _ in 1:n_comp]
    for (i, m_val) in enumerate(mem)
        push!(comps[m_val + 1], i)
    end
    return comps
end



