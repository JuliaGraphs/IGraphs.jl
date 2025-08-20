module IGraphs

import Graphs

export LibIGraph, IGraph, IGraphException,
    IGVectorInt, IGVectorFloat, IGVectorComplex, IGVectorBool, IGVectorChar,
    IGMatrixInt, IGMatrixFloat, IGMatrixComplex, IGMatrixBool, IGMatrixChar,
    IGBitSet,
    #IGraphList,
    IGVectorIntList, IGVectorFloatList, IGMatrixFloatList, IGBitSetList,
    IGAdjList,
    IGNull,
    IGraphAlg,
    igraphalg_methods

const last_thrown_error_ref = Ref{Any}() # TODO make this thread safe

include("wrapccall.jl")

include(modifymodule, "LibIGraph.jl")

include("scalar_types.jl")
include("types.jl")
include("graph_api.jl")
include("array_api.jl")

include("init.jl")

include("graph_api_extensions.jl")
include("igraph_shims.jl")
#include("gaps_from_headers.jl")

end

##
