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

#=
function community_leiden(g::IGraph; resolution=1.0, beta=0.01)
    membership = IGVectorInt()
    nb_clusters, quality = LibIGraph.community_leiden_simple(g, IGNull(), LibIGraph.IGRAPH_LEIDEN_OBJECTIVE_MODULARITY, resolution, beta, false, 2, membership)
    sz = LibIGraph.vector_int_size(membership)
    return [LibIGraph.vector_int_get(membership, i-1) for i in 1:sz]
end

function community_leiden(g::Graphs.AbstractGraph, ::IGraphAlg; kwargs...)
    return community_leiden(IGraph(g); kwargs...)
end

function modularity_matrix(g::IGraph)
    modmat = IGMatrixFloat()
    LibIGraph.modularity_matrix(g, IGNull(), 1.0, modmat, Graphs.is_directed(g))
    nrow = LibIGraph.matrix_nrow(modmat)
    ncol = LibIGraph.matrix_ncol(modmat)
    return [LibIGraph.matrix_get(modmat, r-1, c-1) for r in 1:nrow, c in 1:ncol]
end

function modularity_matrix(g::Graphs.AbstractGraph, ::IGraphAlg)
    return modularity_matrix(IGraph(g))
end

function layout_kamada_kawai(g::IGraph)
    res = IGMatrixFloat()
    LibIGraph.layout_kamada_kawai(g, res, false, 1000, 0.0, 0.0, IGNull(), IGNull(), IGNull(), IGNull(), IGNull())
    nrow = LibIGraph.matrix_nrow(res)
    return [LibIGraph.matrix_get(res, r-1, 0) => LibIGraph.matrix_get(res, r-1, 1) for r in 1:nrow]
end

function layout_kamada_kawai(g::Graphs.AbstractGraph, ::IGraphAlg)
    return layout_kamada_kawai(IGraph(g))
end

function layout_fruchterman_reingold(g::IGraph)
    res = IGMatrixFloat()
    LibIGraph.layout_fruchterman_reingold(g, res, false, 500, 0.0, LibIGraph.IGRAPH_LAYOUT_AUTOGRID, IGNull(), IGNull(), IGNull(), IGNull(), IGNull())
    nrow = LibIGraph.matrix_nrow(res)
    return [LibIGraph.matrix_get(res, r-1, 0) => LibIGraph.matrix_get(res, r-1, 1) for r in 1:nrow]
end

function layout_fruchterman_reingold(g::Graphs.AbstractGraph, ::IGraphAlg)
    return layout_fruchterman_reingold(IGraph(g))
end

function sir_model(g::IGraph, beta, gamma; no_sim=100)
    result = IGVectorPtr()
    LibIGraph.igraph_sir(g.objref, beta, gamma, no_sim, result.objref)
    
    sz = LibIGraph.igraph_vector_ptr_size(result.objref)
    
    sims = []
    for i in 1:sz
        ptr = LibIGraph.igraph_vector_ptr_get(result.objref, i-1)
        sir_ptr = Ptr{LibIGraph.igraph_sir_t}(ptr)
        sir_obj = unsafe_load(sir_ptr)
        
        times_sz = LibIGraph.igraph_vector_size(Ref(sir_obj.times))
        times = [LibIGraph.igraph_vector_get(Ref(sir_obj.times), j-1) for j in 1:times_sz]
        
        s_sz = LibIGraph.igraph_vector_int_size(Ref(sir_obj.no_s))
        s_count = [LibIGraph.igraph_vector_int_get(Ref(sir_obj.no_s), j-1) for j in 1:s_sz]
        
        i_sz = LibIGraph.igraph_vector_int_size(Ref(sir_obj.no_i))
        i_count = [LibIGraph.igraph_vector_int_get(Ref(sir_obj.no_i), j-1) for j in 1:i_sz]
        
        r_sz = LibIGraph.igraph_vector_int_size(Ref(sir_obj.no_r))
        r_count = [LibIGraph.igraph_vector_int_get(Ref(sir_obj.no_r), j-1) for j in 1:r_sz]
        
        push!(sims, (times=times, S=s_count, I=i_count, R=r_count))
        
        # Destroy the sir object
        LibIGraph.igraph_sir_destroy(sir_ptr)
        # Free the sir pointer memory itself (igraph_sir allocates them with malloc)
        LibIGraph.igraph_free(sir_ptr)
    end
    # The result container (IGVectorPtr) will be destroyed by its finalizer.
    return sims
end

function sir_model(g::Graphs.AbstractGraph, beta, gamma, ::IGraphAlg; kwargs...)
    return sir_model(IGraph(g), beta, gamma; kwargs...)
end
=#
