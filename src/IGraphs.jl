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

# NOTE: We avoid `include(modifymodule, "LibIGraph.jl")` because Revise.jl
# (used by JET.jl) does not support the two-argument `include(mapexpr, path)` form
# and throws a "Bad include call" error during static analysis.
let _path = joinpath(@__DIR__, "LibIGraph.jl")
    _code = read(_path, String)
    _expr = Meta.parse("begin $(_code) end")
    _mod_expr = modifymodule(_expr.args[2]) # The module expression is inside the begin-end block
    Core.eval(@__MODULE__, _mod_expr)
end

include("scalar_types.jl")
include("types.jl")
include("graph_api.jl")
include("array_api.jl")

include("init.jl")

include("graph_api_extensions.jl")

end

##
