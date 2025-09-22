for (VT, ET, suffix) in vtypes
    api = quote
        # iteration
        #Base.iterate(v::$VT) # default
        #Base.iterate(v::$VT, state) # default
        #Base.eltype(v::$VT) # default
        # indexing
        Base.getindex(v::$VT, i::Number) = LibIGraph.$(Symbol(:vector,suffix,:_get))(v,i[1]-1)::$ET
        function Base.setindex!(v::$VT, x, i::Number)
            LibIGraph.$(Symbol(:vector,suffix,:_set))(v,i-1,x)
            x
        end
        #Base.firstindex(v::$VT) # default
        #Base.lastindex(v::$VT) # default
        # abstract arrays
        Base.size(v::$VT) = (LibIGraph.$(Symbol(:vector,suffix,:_size))(v), )
        Base.IndexStyle(::Type{$VT}) = Base.IndexLinear()
        # other
        Base.push!(v::$VT, x) = LibIGraph.$(Symbol(:vector,suffix,:_push_back))(v, x)
        # constructor conversion
        function $VT(v::Vector)
            vout = $VT(_uninitialized=Val(false))
            LibIGraph.$(Symbol(:vector,suffix,:_init))(vout, length(v))
            for (i,x) in enumerate(v)
                vout[i]=x
            end
            return vout
        end
        Base.Vector(v::$VT) = v[begin:end]::Vector{$ET}
    end
    eval(api)
end


for (MT, ET, suffix) in mtypes
    api = quote
        # iteration
        #Base.iterate(m::$MT) # default
        #Base.iterate(m::$MT, state) # default
        #Base.eltype(m::$MT) # default
        # indexing
        function Base.getindex(m::$MT, i::Number, j::Number)
            LibIGraph.$(Symbol(:matrix,suffix,:_get))(m,(i-1),(j-1))::$ET
        end
        function Base.setindex!(m::$MT, x, i::Number, j::Number)
            LibIGraph.$(Symbol(:matrix,suffix,:_set))(m,i-1,j-1,x)
            x
        end
        #Base.firstindex(m::$MT) # default
        #Base.lastindex(m::$MT) # default
        # abstract arrays
        Base.size(m::$MT) = (LibIGraph.$(Symbol(:matrix,suffix,:_nrow))(m), LibIGraph.$(Symbol(:matrix,suffix,:_ncol))(m))
        Base.IndexStyle(::Type{$MT}) = Base.IndexCartesian()
        # constructor conversion
        function $MT(m::Matrix)
            mout = $MT(_uninitialized=Val(false))
            LibIGraph.$(Symbol(:matrix,suffix,:_init))(mout, size(m,1), size(m,2))
            for (i,x) in enumerate(m)
                mout[i]=x
            end
            return mout
        end
        Base.Matrix(m::$MT) = m[begin:end, begin:end]::Matrix{$ET}
    end
    eval(api)
end
