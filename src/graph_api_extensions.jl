# Explicit import/export of the functions
# that are getting new methods,
# so that `igraphalg_methods` can pick them up.
import Graphs: diameter, radius
import Graphs.Experimental
import Graphs.Experimental: has_isomorph

export diameter, radius, has_isomorph

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
    return LibIGraph.diameter(IGraph(g), IGNull(), IGNull(), false, false)[1]
end

function radius(g, ::IGraphAlg)
    return LibIGraph.radius(IGraph(g), LibIGraph.IGRAPH_ALL)[1]
end

function has_isomorph(g1, g2, ::IGraphAlg)
    return LibIGraph.isomorphic(IGraph(g1), IGraph(g2))[1]
end
