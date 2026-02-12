# Explicit import/export of the functions
# that are getting new methods,
# so that `igraphalg_methods` can pick them up.
import Graphs: diameter, radius, connected_components, is_connected, articulation, bridges
import Graphs.Experimental
import Graphs.Experimental: has_isomorph

export diameter, radius, has_isomorph,
    connected_components, is_connected, articulation, bridges

struct IGraphAlg end

"""Lists all functions for which an IGraphAlg method is defined"""
function igraphalg_methods()
    filter(names(@__MODULE__)) do s
        f = getproperty(@__MODULE__, s)
        f isa Function || return false
        any(methods(f)) do m
            IGraphAlg ∈ m.sig.parameters
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

function connected_components(g, ::IGraphAlg)
    ig = IGraph(g)
    membership = IGVectorInt()
    csize = IGVectorInt()
    ncomp = LibIGraph.connected_components(ig, membership, csize, LibIGraph.IGRAPH_WEAK)[1]
    # Convert igraph 0-based component IDs to Graphs.jl format:
    # Vector of vectors, each containing 1-based vertex IDs
    components = [Int[] for _ in 1:ncomp]
    for (v, c) in enumerate(membership)
        push!(components[c+1], v)
    end
    return components
end

function is_connected(g, ::IGraphAlg)
    return LibIGraph.is_connected(IGraph(g), LibIGraph.IGRAPH_WEAK)[1]
end

function articulation(g, ::IGraphAlg)
    ig = IGraph(g)
    res = IGVectorInt()
    LibIGraph.articulation_points(ig, res)
    return sort!([v + 1 for v in res])
end

function bridges(g, ::IGraphAlg)
    ig = IGraph(g)
    res = IGVectorInt()
    LibIGraph.bridges(ig, res)
    # Convert edge IDs to SimpleEdge pairs
    return [begin
        (from, to) = LibIGraph.edge(ig, eid)
        Graphs.SimpleGraphs.SimpleEdge(from+1, to+1)
    end for eid in res]
end
