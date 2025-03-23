struct IGraphException <: Exception
    reason::String
    file::String
    line::Cint
    errno::Cint
end

function Base.showerror(io::IO, err::IGraphException)
    print(io, "IGraphException $(LibIGraph.igraph_error_t(err.errno)): $(err.reason) @ igraph $(err.file):$(err.line)")
end

function julia_error_handler(reason, file, line, errno)::Cvoid # TODO verify that there are no problems with nested exceptions or that we are not potentially masking any other julia exceptions
    last_thrown_error_ref[] = IGraphException(unsafe_string(reason), unsafe_string(file), line, errno)
    LibIGraph.IGRAPH_FINALLY_FREE()
    return
end

const c_error_handler_ref = Ref{Any}()

function __init__()
    c_error_handler = @cfunction(julia_error_handler, Cvoid, (Cstring, Cstring, Cint, Cint))
    c_error_handler_ref[] = c_error_handler
    LibIGraph.igraph_set_error_handler(c_error_handler)
end
