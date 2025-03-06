module IGraphs

import Graphs

"""Modifies each binding in the LibIGraph module"""
function modifybinding(x)
    x
end

function is_single_ccall(expr)
    ccalls = sum(expr.args) do x; x isa Expr && x.head==:call && x.args[1]==:ccall end
    codelines = sum(expr.args) do x; x isa Expr || x isa Symbol end
    return ccalls==codelines==1
end

const cenums = Set{Symbol}()

function modifybinding(x::Expr)
    if x.head == :function
        callhead, body = x.args
        if is_single_ccall(body)
            return quote
                $x
                $(wrapccall(x))
            end
        end
    end
    if x.head == :macrocall && x.args[1] == Symbol("@cenum")
        enumname = [y.args[1] for y in x.args[2:end] if y isa Expr && y.head == :(::)][1]
        if string(enumname)[1:7] == "igraph_"
            push!(cenums, enumname)
        end
    end
    return x
end

function modifymodule(mod)
    module_entries = mod.args[3].args
    module_entries .= modifybinding.(module_entries)
    mod
end

include("wrapccall.jl")

include(modifymodule, "LibIGraph.jl")

include("types.jl")
include("graph_api.jl")

end

##
