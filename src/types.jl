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

for (ptr_ctype, jtype) in pairs(wrappedtypes)
    ctype = ptr_ctype.args[2]
    expr = quote
        struct $jtype
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
    #println(expr)
    eval(expr)
end
