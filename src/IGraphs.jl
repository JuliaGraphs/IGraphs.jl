module IGraphs

import Graphs

export LibIGraph, IGraph, IGraphException

const last_thrown_error_ref = Ref{Any}() # TODO make this thread safe

include("wrapccall.jl")

include(modifymodule, "LibIGraph.jl")

include("types.jl")
include("graph_api.jl")

include("init.jl")

end

##
