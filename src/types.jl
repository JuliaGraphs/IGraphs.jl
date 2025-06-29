function initializer(ctype)
    sname = string(ctype)
    if startswith(sname, r"igraph_graph_list")
    elseif startswith(sname, r"igraph_vector_list|igraph_vector_int_list")
        :(LibIGraph.$(Symbol(sname[1:end-1],"init"))(cinstance, 0))
    elseif startswith(sname, "igraph_matrix_list")
        :(LibIGraph.$(Symbol(sname[1:end-1],"init"))(cinstance, 0))
    elseif startswith(sname, "igraph_bitset_list")
        :(LibIGraph.$(Symbol(sname[1:end-1],"init"))(cinstance, 0))
    elseif startswith(sname, "igraph_adjlist")
        :(LibIGraph.$(Symbol(sname[1:end-1],"init_empty"))(cinstance, 0))
    elseif startswith(sname, "igraph_vector")
        :(LibIGraph.$(Symbol(sname[1:end-1],"init"))(cinstance, 0))
    elseif startswith(sname, "igraph_matrix")
        :(LibIGraph.$(Symbol(sname[1:end-1],"init"))(cinstance, 0, 0))
    elseif startswith(sname, "igraph_bitset")
        :(LibIGraph.$(Symbol(sname[1:end-1],"init"))(cinstance, 0))
    elseif startswith(sname, "igraph_t")
        :(LibIGraph.$(Symbol(sname[1:end-1],"empty"))(cinstance, 0, false))
    end
end

const vtypes = [
    (:IGVectorInt, LibIGraph.igraph_integer_t, "_int"),
    (:IGVectorFloat, LibIGraph.igraph_real_t, ""),
    (:IGVectorComplex, Complex{LibIGraph.igraph_real_t}, "_complex"),
    (:IGVectorBool, LibIGraph.igraph_bool_t, "_bool"),
    (:IGVectorChar, Cchar, "_char")
]
const mtypes = [
    (:IGMatrixInt, LibIGraph.igraph_integer_t, "_int"),
    (:IGMatrixFloat, LibIGraph.igraph_real_t, ""),
    (:IGMatrixComplex, Complex{LibIGraph.igraph_real_t}, "_complex"),
    (:IGMatrixBool, LibIGraph.igraph_bool_t, "_bool"),
    (:IGMatrixChar, Cchar, "_char")
]

const parent_types = Dict(
    :IGraph=>:(Graphs.AbstractGraph{Int}),
    [jtype=>:(AbstractVector{$eltype}) for (jtype, eltype, _) in vtypes]...,
    [jtype=>:(AbstractMatrix{$eltype}) for (jtype, eltype, _) in mtypes]...
)

for (ptr_ctype, jtype) in pairs(wrappedtypes)
    ctype = ptr_ctype.args[2]
    ptype = get(parent_types, jtype, Any)
    expr = quote
        struct $jtype <: $ptype
            objref::Ref{LibIGraph.$ctype}
        end
        function $jtype(;_uninitialized::Val{B}=Val(false)) where {B}
            cinstance = Ref{LibIGraph.$ctype}()
            finalizer(cinstance) do cinstance
                LibIGraph.$(Symbol(string(ctype)[1:end-1],"destroy"))(cinstance)
                cinstance
            end
            if !B
                $(initializer(ctype))
            end
            return $jtype(cinstance)
        end
    end
    eval(expr)
end

"""Convenient wrapper for `C_NULL` to be used when `LibIGraph` functions need a `NULL` argument."""
struct IGNull
    objref
    function IGNull()
        return new(C_NULL)
    end
end
