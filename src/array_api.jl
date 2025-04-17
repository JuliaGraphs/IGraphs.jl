const vtypes = [
    (:IGVectorInt, LibIGraph.igraph_integer_t, "_int"),
    (:IGVectorFloat, LibIGraph.igraph_real_t, ""),
    (:IGVectorComplex, Complex{LibIGraph.igraph_real_t}, "_complex"),
    (:IGVectorBool, LibIGraph.igraph_bool_t, "_bool"),
    (:IGVectorChar, Cchar, "_char")
]

for (VT, ET, suffix) in vtypes
    api = quote
        # iteration
        Base.iterate(v::$VT) = length(v)==0 ? nothing : (v[1], 1)
        Base.iterate(v::$VT, state) = length(v)==state ? nothing : (v[state+1], state+1)
        # iteration (optional)
        Base.eltype(v::$VT) = $ET
        # indexing
        Base.getindex(v::$VT, i::Number) = LibIGraph.$(Symbol(:vector,suffix,:_get))(v,i-1)::$ET
        Base.getindex(v::$VT, I) = [S[i] for i in I]
        function Base.setindex!(v::$VT, x, i::Number)
            LibIGraph.$(Symbol(:vector,suffix,:_set))(v,i-1,x)
            x
        end
        function Base.setindex!(v::$VT, X, I)
            for (x,i) in zip(X,I)
                v[i] = x
            end
            X
        end
        Base.firstindex(v::$VT) = 1
        Base.lastindex(v::$VT) = length(v)
        # abstract arrays
        Base.size(v::$VT) = (length(v), )
        #Base.getindex(v::$VT, I::Vararg{Int, 1})
        # abstract arrays (optional)
        Base.length(v::$VT) = LibIGraph.$(Symbol(:vector,suffix,:_size))(v)

        # other
        Base.push!(v::$VT, x) = LibIGraph.$(Symbol(:vector,suffix,:_push_back))(v, x)

        # constructor conversion
        Vector(v::$VT) = v[begin:end]
        function $VT(v::Vector)
            vout = $VT(_uninitialized=Val(false))
            LibIGraph.$(Symbol(:vector,suffix,:_init))(vout, length(v))
            for (i,x) in enumerate(v)
                vout[i]=x
            end
            return vout
        end
    end
    eval(api)
end
