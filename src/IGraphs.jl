module IGraphs

import Graphs

export LibIGraph, IGraph

include("wrapccall.jl")

include(modifymodule, "LibIGraph.jl")

include("types.jl")
include("graph_api.jl")

end

##
