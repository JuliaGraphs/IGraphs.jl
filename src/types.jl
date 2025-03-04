for (ptr_ctype, jtype) in pairs(wrappedtypes)
    ctype = ptr_ctype.args[2]
    expr = quote
        struct $jtype
            objref::Ref{LibIGraph.$ctype}
        end
        function $jtype()
            cinstance = Ref{LibIGraph.$ctype}()
            finalizer(cinstance) do cinstance
                LibIGraph.$(Symbol(string(ctype)[1:end-1],"destroy"))(cinstance)
                cinstance
            end
            return $jtype(cinstance)
        end
    end
    #println(expr)
    eval(expr)
end
