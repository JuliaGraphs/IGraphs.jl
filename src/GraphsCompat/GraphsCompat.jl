module GraphsCompat

# Low-level wrapper (already in this package)
using ..IGraphs
# We will extend Graphs.jl (and optionally GraphsMatching)
import Graphs

# Optional: only if the dependency is available at load time.
# This won't throw if GraphsMatching isn't installed.
let ok = true
    try
        @eval import GraphsMatching
    catch
        ok = false
    end
end

# ------------------------------------------------------------
# Public exports
# ------------------------------------------------------------
"Explicitly request the igraph backend for Graphs.jl algorithms"
struct IGraphAlgorithm end
export IGraphAlgorithm

export IGSimpleGraph, IGSimpleDiGraph

# ------------------------------------------------------------
# Types
# ------------------------------------------------------------
"Undirected igraph-backed graph"
struct IGSimpleGraph
    g::IGraphs.igraph_t_ptr   # pointer/handle to igraph_t (owned/managed by IGraphs)
    n::Int                    # cached vcount
end

"Directed igraph-backed graph"
struct IGSimpleDiGraph
    g::IGraphs.igraph_t_ptr
    n::Int
end

# 0-based <-> 1-based helpers (igraph is 0-based)
@inline _to0(i::Int) = i - 1
@inline _to1(i::Int) = i + 1

# ------------------------------------------------------------
# Fast constructors from Graphs.jl types
# (Require a thin low-level helper IGraphs.create_from_edgelist)
# ------------------------------------------------------------
function IGSimpleGraph(sg::Graphs.SimpleGraph)
    n  = Graphs.nv(sg)
    el = collect(Graphs.edges(sg))
    edgelist0 = Vector{Int}(undef, 2*length(el))
    @inbounds for (k,e) in enumerate(el)
        edgelist0[2k-1] = Graphs.src(e) - 1
        edgelist0[2k]   = Graphs.dst(e) - 1
    end
    gptr = IGraphs.create_from_edgelist(n, edgelist0; directed=false)
    return IGSimpleGraph(gptr, n)
end

function IGSimpleDiGraph(sd::Graphs.SimpleDiGraph)
    n  = Graphs.nv(sd)
    el = collect(Graphs.edges(sd))
    edgelist0 = Vector{Int}(undef, 2*length(el))
    @inbounds for (k,e) in enumerate(el)
        edgelist0[2k-1] = Graphs.src(e) - 1
        edgelist0[2k]   = Graphs.dst(e) - 1
    end
    gptr = IGraphs.create_from_edgelist(n, edgelist0; directed=true)
    return IGSimpleDiGraph(gptr, n)
end

# ------------------------------------------------------------
# Core Graphs.jl interface (makes IG* usable with Graphs’ API)
# ------------------------------------------------------------
Graphs.nv(G::IGSimpleGraph)    = G.n
Graphs.nv(G::IGSimpleDiGraph)  = G.n
Graphs.ne(G::IGSimpleGraph)    = IGraphs.ecount(G.g)
Graphs.ne(G::IGSimpleDiGraph)  = IGraphs.ecount(G.g)

# Vertex iteration
Graphs.vertices(G::IGSimpleGraph)   = Base.OneTo(Graphs.nv(G))
Graphs.vertices(G::IGSimpleDiGraph) = Base.OneTo(Graphs.nv(G))

# Neighborhoods
Graphs.neighbors(G::IGSimpleGraph, u::Int) =
    _to1.(IGraphs.neighbors(G.g, _to0(u)) |> collect)

Graphs.outneighbors(G::IGSimpleDiGraph, u::Int) =
    _to1.(IGraphs.successors(G.g, _to0(u)) |> collect)

Graphs.inneighbors(G::IGSimpleDiGraph, u::Int)  =
    _to1.(IGraphs.predecessors(G.g, _to0(u)) |> collect)

# Degrees
Graphs.degree(G::IGSimpleGraph, u::Int)        = IGraphs.degree(G.g, _to0(u))
Graphs.outdegree(G::IGSimpleDiGraph, u::Int)   = IGraphs.outdegree(G.g, _to0(u))
Graphs.indegree(G::IGSimpleDiGraph,  u::Int)   = IGraphs.indegree(G.g, _to0(u))

# Edge ops
Graphs.has_edge(G::IGSimpleGraph, u::Int, v::Int) =
    IGraphs.has_edge(G.g, _to0(u), _to0(v)) != 0
Graphs.add_edge!(G::IGSimpleGraph, u::Int, v::Int) =
    (IGraphs.add_edge!(G.g, _to0(u), _to0(v)); G)

# ------------------------------------------------------------
# Direct algorithm dispatches to igraph (Undirected)
# ------------------------------------------------------------

# Distances / shortest paths
Graphs.distances(g::IGSimpleGraph; weights=nothing) =
    IGraphs.distances(g.g; weights=weights)

# Centrality
Graphs.betweenness_centrality(g::IGSimpleGraph; normalized=true) =
    IGraphs.betweenness(g.g; normalized=normalized)
Graphs.closeness_centrality(g::IGSimpleGraph; normalized=true) =
    IGraphs.closeness(g.g; normalized=normalized)
Graphs.pagerank(g::IGSimpleGraph; damping=0.85) =
    IGraphs.pagerank(g.g; damping=damping)
Graphs.eigenvector_centrality(g::IGSimpleGraph) =
    IGraphs.eigenvector_centrality(g.g)

# Components / connectivity
Graphs.connected_components(g::IGSimpleGraph) =
    IGraphs.components(g.g)

# Communities (commonly undirected)
Graphs.louvain_communities(g::IGSimpleGraph) =
    IGraphs.community_multilevel(g.g)     # Louvain
Graphs.walktrap_communities(g::IGSimpleGraph) =
    IGraphs.community_walktrap(g.g)
Graphs.edge_betweenness_communities(g::IGSimpleGraph) =
    IGraphs.community_edge_betweenness(g.g)
Graphs.label_propagation_communities(g::IGSimpleGraph) =
    IGraphs.community_label_propagation(g.g)

# Flows & cuts
Graphs.maximum_flow(g::IGSimpleGraph, s::Int, t::Int; capacity=:weight) =
    IGraphs.max_flow(g.g, s, t; capacity=capacity)
Graphs.minimum_cut(g::IGSimpleGraph; capacity=:weight) =
    IGraphs.min_cut(g.g; capacity=capacity)
Graphs.gomory_hu_tree(g::IGSimpleGraph; capacity=:weight) =
    IGraphs.gomory_hu_tree(g.g; capacity=capacity)

# Matching (bipartite)
if Base.find_package("GraphsMatching") !== nothing
    import GraphsMatching
    GraphsMatching.maximum_matching(g::IGSimpleGraph; bipartite=true, types=nothing) =
        IGraphs.max_bipartite_matching(g.g; types=types)
end

# MST / spanning forest
Graphs.minimum_spanning_tree(g::IGSimpleGraph; weights=:weight) =
    IGraphs.mst(g.g; weights=weights)

# Cliques, cores, triangles
Graphs.k_core(g::IGSimpleGraph, k::Int) = IGraphs.k_core(g.g, k)
Graphs.max_clique(g::IGSimpleGraph)     = IGraphs.max_clique(g.g)
Graphs.triangles(g::IGSimpleGraph)      = IGraphs.triangles(g.g)

# Bipartite tools
Graphs.bipartite_projection(g::IGSimpleGraph) =
    IGraphs.bipartite_projection(g.g)

# ------------------------------------------------------------
# Direct algorithm dispatches to igraph (Directed)
# Remove kwarg `directed=true` if your low-level wrappers infer it from g
# ------------------------------------------------------------

Graphs.distances(g::IGSimpleDiGraph; weights=nothing) =
    IGraphs.distances(g.g; weights=weights, directed=true)

Graphs.betweenness_centrality(g::IGSimpleDiGraph; normalized=true) =
    IGraphs.betweenness(g.g; normalized=normalized, directed=true)
Graphs.closeness_centrality(g::IGSimpleDiGraph; normalized=true) =
    IGraphs.closeness(g.g; normalized=normalized, directed=true)
Graphs.pagerank(g::IGSimpleDiGraph; damping=0.85) =
    IGraphs.pagerank(g.g; damping=damping, directed=true)
Graphs.eigenvector_centrality(g::IGSimpleDiGraph) =
    IGraphs.eigenvector_centrality(g.g; directed=true)

# Components on directed graphs
Graphs.strongly_connected_components(g::IGSimpleDiGraph) =
    IGraphs.strong_components(g.g)
Graphs.connected_components(g::IGSimpleDiGraph) =
    IGraphs.weak_components(g.g)

# Flows & cuts (valid on digraphs too)
Graphs.maximum_flow(g::IGSimpleDiGraph, s::Int, t::Int; capacity=:weight) =
    IGraphs.max_flow(g.g, s, t; capacity=capacity)
Graphs.minimum_cut(g::IGSimpleDiGraph; capacity=:weight) =
    IGraphs.min_cut(g.g; capacity=capacity)
Graphs.gomory_hu_tree(g::IGSimpleDiGraph; capacity=:weight) =
    IGraphs.gomory_hu_tree(g.g; capacity=capacity)

# ------------------------------------------------------------
# Marker overloads: run igraph backend on ANY AbstractGraph
# (auto-pick IGSimpleGraph vs IGSimpleDiGraph)
# ------------------------------------------------------------

_as_ig(g::Graphs.AbstractGraph) =
    Graphs.is_directed(g) ? IGSimpleDiGraph(g) : IGSimpleGraph(g)

# Distances
Graphs.distances(g::Graphs.AbstractGraph, ::IGraphAlgorithm; weights=nothing) =
    Graphs.distances(_as_ig(g); weights=weights)

# Centralities
Graphs.betweenness_centrality(g::Graphs.AbstractGraph, ::IGraphAlgorithm; normalized=true) =
    Graphs.betweenness_centrality(_as_ig(g); normalized=normalized)
Graphs.closeness_centrality(g::Graphs.AbstractGraph, ::IGraphAlgorithm; normalized=true) =
    Graphs.closeness_centrality(_as_ig(g); normalized=normalized)
Graphs.eigenvector_centrality(g::Graphs.AbstractGraph, ::IGraphAlgorithm) =
    Graphs.eigenvector_centrality(_as_ig(g))
Graphs.pagerank(g::Graphs.AbstractGraph, ::IGraphAlgorithm; kwargs...) =
    Graphs.pagerank(_as_ig(g); kwargs...)

# Components
Graphs.connected_components(g::Graphs.AbstractGraph, ::IGraphAlgorithm) =
    Graphs.connected_components(_as_ig(g))
Graphs.strongly_connected_components(g::Graphs.AbstractGraph, ::IGraphAlgorithm) =
    Graphs.strongly_connected_components(_as_ig(g))

# MST / Spanning trees
Graphs.minimum_spanning_tree(g::Graphs.AbstractGraph, ::IGraphAlgorithm; kwargs...) =
    Graphs.minimum_spanning_tree(_as_ig(g); kwargs...)

# Flows / Cuts
Graphs.maximum_flow(g::Graphs.AbstractGraph, ::IGraphAlgorithm, s::Int, t::Int; kwargs...) =
    Graphs.maximum_flow(_as_ig(g), s, t; kwargs...)
Graphs.minimum_cut(g::Graphs.AbstractGraph, ::IGraphAlgorithm; kwargs...) =
    Graphs.minimum_cut(_as_ig(g); kwargs...)
Graphs.gomory_hu_tree(g::Graphs.AbstractGraph, ::IGraphAlgorithm; kwargs...) =
    Graphs.gomory_hu_tree(_as_ig(g); kwargs...)

# Communities (mostly for undirected graphs)
Graphs.louvain_communities(g::Graphs.AbstractGraph, ::IGraphAlgorithm) =
    Graphs.louvain_communities(_as_ig(g))
Graphs.walktrap_communities(g::Graphs.AbstractGraph, ::IGraphAlgorithm) =
    Graphs.walktrap_communities(_as_ig(g))
Graphs.edge_betweenness_communities(g::Graphs.AbstractGraph, ::IGraphAlgorithm) =
    Graphs.edge_betweenness_communities(_as_ig(g))
Graphs.label_propagation_communities(g::Graphs.AbstractGraph, ::IGraphAlgorithm) =
    Graphs.label_propagation_communities(_as_ig(g))

# Matchings (if GraphsMatching is available)
if Base.find_package("GraphsMatching") !== nothing
    GraphsMatching.maximum_matching(g::Graphs.AbstractGraph, ::IGraphAlgorithm; kwargs...) =
        GraphsMatching.maximum_matching(_as_ig(g); kwargs...)
end

# ------------------------------------------------------------
# GraphsMatching (optional): bipartite maximum matching
# ------------------------------------------------------------
if Base.find_package("GraphsMatching") !== nothing
    import GraphsMatching

    # ---- direct IG implementations ----
    # NOTE: igraph core provides *bipartite* maximum matching.
    # `types` is a Vector{Bool}/BitVector marking the partitions (e.g., left=true, right=false).
    GraphsMatching.maximum_matching(g::IGSimpleGraph; bipartite::Bool=true, types=nothing, kwargs...) =
        IGraphs.max_bipartite_matching(g.g; types=types, kwargs...)

    # (optional) directed graphs: treat as bipartite only if your workflow defines `types`
    GraphsMatching.maximum_matching(g::IGSimpleDiGraph; bipartite::Bool=true, types=nothing, kwargs...) =
        IGraphs.max_bipartite_matching(g.g; types=types, kwargs...)

    # ---- marker overloads (ANY AbstractGraph) ----
    GraphsMatching.maximum_matching(g::Graphs.AbstractGraph, ::IGraphAlgorithm; kwargs...) =
        GraphsMatching.maximum_matching(_as_ig(g); kwargs...)

    # If GraphsMatching also exports a weighted variant in your version,
    # we only add the method when it exists to avoid load errors:
    if isdefined(GraphsMatching, :maximum_weight_matching)
        GraphsMatching.maximum_weight_matching(g::IGSimpleGraph; weights, types=nothing, kwargs...) =
            IGraphs.max_bipartite_matching(g.g; weights=weights, types=types, kwargs...)

        GraphsMatching.maximum_weight_matching(g::Graphs.AbstractGraph, ::IGraphAlgorithm; kwargs...) =
            GraphsMatching.maximum_weight_matching(_as_ig(g); kwargs...)
    end
end


# ------------------------------------------------------------
# GraphsOptim (optional): flows, cuts, cut tree
# ------------------------------------------------------------
if Base.find_package("GraphsOptim") !== nothing
    import GraphsOptim

    # ---- direct IG implementations ----
    if isdefined(GraphsOptim, :maximum_flow)
        GraphsOptim.maximum_flow(g::IGSimpleGraph, s::Int, t::Int; capacity=:weight, kwargs...) =
            IGraphs.max_flow(g.g, s, t; capacity=capacity, kwargs...)
        GraphsOptim.maximum_flow(g::IGSimpleDiGraph, s::Int, t::Int; capacity=:weight, kwargs...) =
            IGraphs.max_flow(g.g, s, t; capacity=capacity, kwargs...)
    end

    if isdefined(GraphsOptim, :minimum_cut)
        GraphsOptim.minimum_cut(g::IGSimpleGraph; capacity=:weight, kwargs...) =
            IGraphs.min_cut(g.g; capacity=capacity, kwargs...)
        GraphsOptim.minimum_cut(g::IGSimpleDiGraph; capacity=:weight, kwargs...) =
            IGraphs.min_cut(g.g; capacity=capacity, kwargs...)
    end

    if isdefined(GraphsOptim, :gomory_hu_tree)
        GraphsOptim.gomory_hu_tree(g::IGSimpleGraph; capacity=:weight, kwargs...) =
            IGraphs.gomory_hu_tree(g.g; capacity=capacity, kwargs...)
        # (GH tree is defined for undirected graphs; provide DiGraph method only if your wrapper supports it)
    end

    # ---- marker overloads (ANY AbstractGraph) ----
    if isdefined(GraphsOptim, :maximum_flow)
        GraphsOptim.maximum_flow(g::Graphs.AbstractGraph, ::IGraphAlgorithm, s::Int, t::Int; kwargs...) =
            GraphsOptim.maximum_flow(_as_ig(g), s, t; kwargs...)
    end
    if isdefined(GraphsOptim, :minimum_cut)
        GraphsOptim.minimum_cut(g::Graphs.AbstractGraph, ::IGraphAlgorithm; kwargs...) =
            GraphsOptim.minimum_cut(_as_ig(g); kwargs...)
    end
    if isdefined(GraphsOptim, :gomory_hu_tree)
        GraphsOptim.gomory_hu_tree(g::Graphs.AbstractGraph, ::IGraphAlgorithm; kwargs...) =
            GraphsOptim.gomory_hu_tree(_as_ig(g); kwargs...)
    end
end

end # module
