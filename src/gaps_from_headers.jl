# src/gaps_from_headers.jl
# Thin wrappers for C API functions present in libigraph but missing in IGraphs.jl.
# These are low-level helpers intended to live inside module IGraphs.

const _lib = LibIGraph.libigraph

# Type aliases
const _igraph_t              = LibIGraph.igraph_t
const _igraph_adjlist_t      = LibIGraph.igraph_adjlist_t
const _igraph_inclist_t      = LibIGraph.igraph_inclist_t
const _igraph_lazy_adjlist_t = LibIGraph.igraph_lazy_adjlist_t
const _igraph_lazy_inclist_t = LibIGraph.igraph_lazy_inclist_t
const _igraph_vector_int_t   = LibIGraph.igraph_vector_int_t
const _igraph_es_t           = LibIGraph.igraph_es_t
const _igraph_vs_t           = LibIGraph.igraph_vs_t
const _bool                  = LibIGraph.igraph_bool_t   # C bool (Cint-compatible)
const _err_t                 = Cint
const _cint                  = Cint
const _clong = Clong   # igraph_integer_t


@inline function _chk(code::Integer, name::Symbol)
    if code != 0
        # Map common igraph error codes to descriptive messages
        error_msg = if code == 1
            "Out of memory"
        elseif code == 2
            "Invalid value"
        elseif code == 3
            "Already exists"
        elseif code == 4
            "Does not exist"
        elseif code == 5
            "Invalid edge vector"
        else
            "Unknown error (code: $code)"
        end
        error("$(name) failed with code $code: $error_msg")
    end
end

# -----------------------------------------------------------------------------
# A) ADJ/INC LIST ACCESSORS
# -----------------------------------------------------------------------------

function adjlist_get(adj::Ptr{_igraph_adjlist_t}, v::Integer)
    @ccall _lib.igraph_adjlist_get(adj::Ptr{_igraph_adjlist_t}, Cint(v - 1)::_cint)::Ptr{_igraph_vector_int_t}
end

function inclist_get(inc::Ptr{_igraph_inclist_t}, v::Integer)
    @ccall _lib.igraph_inclist_get(inc::Ptr{_igraph_inclist_t}, Cint(v - 1)::_cint)::Ptr{_igraph_vector_int_t}
end

function lazy_adjlist_get(ladj::Ptr{_igraph_lazy_adjlist_t}, v::Integer)
    @ccall _lib.igraph_lazy_adjlist_get(ladj::Ptr{_igraph_lazy_adjlist_t}, Cint(v - 1)::_cint)::Ptr{_igraph_vector_int_t}
end

function lazy_adjlist_has(ladj::Ptr{_igraph_lazy_adjlist_t}, v::Integer)::Bool
    (@ccall _lib.igraph_lazy_adjlist_has(ladj::Ptr{_igraph_lazy_adjlist_t}, Cint(v - 1)::_cint)::_bool) != 0
end

function lazy_inclist_get(linc::Ptr{_igraph_lazy_inclist_t}, v::Integer)
    @ccall _lib.igraph_lazy_inclist_get(linc::Ptr{_igraph_lazy_inclist_t}, Cint(v - 1)::_cint)::Ptr{_igraph_vector_int_t}
end

function lazy_inclist_has(linc::Ptr{_igraph_lazy_inclist_t}, v::Integer)::Bool
    (@ccall _lib.igraph_lazy_inclist_has(linc::Ptr{_igraph_lazy_inclist_t}, Cint(v - 1)::_cint)::_bool) != 0
end

# -----------------------------------------------------------------------------
# B) EDGE & VERTEX SELECTORS
# -----------------------------------------------------------------------------

function es_pairs_small(pairs::Vector{Tuple{Int,Int}}; directed::Bool=false)
    n = length(pairs) * 2
    buf = Vector{_cint}(undef, n)
    @inbounds for (i,(s,t)) in enumerate(pairs)
        buf[2i-1] = Cint(s - 1)
        buf[2i]   = Cint(t - 1)
    end
    es = Ref{_igraph_es_t}()
    _chk((@ccall _lib.igraph_es_pairs_small(es::Ref{_igraph_es_t},
                                            buf::Ptr{_cint},
                                            Cint(n)::_cint,
                                            Cint(directed ? 1 : 0)::_bool)::_err_t),
         :igraph_es_pairs_small)
    return es[]
end

function es_path_small(path::AbstractVector{Int})
    n = length(path)
    buf = Vector{_cint}(undef, n)
    @inbounds for i in 1:n
        buf[i] = Cint(path[i] - 1)
    end
    es = Ref{_igraph_es_t}()
    _chk((@ccall _lib.igraph_es_path_small(es::Ref{_igraph_es_t},
                                           buf::Ptr{_cint},
                                           Cint(n)::_cint)::_err_t),
         :igraph_es_path_small)
    return es[]
end

function vs_vector_small(verts::AbstractVector{Int})
    n = length(verts)
    buf = Vector{_cint}(undef, n)
    @inbounds for i in 1:n
        buf[i] = Cint(verts[i] - 1)
    end
    vs = Ref{_igraph_vs_t}()
    _chk((@ccall _lib.igraph_vs_vector_small(vs::Ref{_igraph_vs_t},
                                             buf::Ptr{_cint},
                                             Cint(n)::_cint)::_err_t),
         :igraph_vs_vector_small)
    return vs[]
end

# -----------------------------------------------------------------------------
# C) GRAPH CONSTRUCTORS
# -----------------------------------------------------------------------------
# keep your existing aliases above; ensure this is present:
const _clong = Clong   # igraph_integer_t

# (1) Tuple edge-list version
function small(nv::Integer, edges::Vector{Tuple{Int,Int}}; directed::Bool=false)
    # Validate vertex indices
    for (i, (s, t)) in enumerate(edges)
        if s < 1 || s > nv || t < 1 || t > nv
            error("Invalid vertex index in edge $i: ($s, $t). Vertices must be between 1 and $nv.")
        end
    end

    # Handle empty edge list case
    if isempty(edges)
        # Create empty graph
        g = Ref{_igraph_t}()
        _chk((@ccall _lib.igraph_empty(g::Ref{_igraph_t}, _clong(nv)::_clong, Cint(directed)::_bool)::_err_t), :igraph_empty)
        return g[]
    end

    m = length(edges) * 2
    buf = Vector{_clong}(undef, m)
    @inbounds for (i,(s,t)) in enumerate(edges)
        buf[2i-1] = _clong(s - 1)
        buf[2i]   = _clong(t - 1)
    end

    v = Ref{_igraph_vector_int_t}()
    result = @ccall _lib.igraph_vector_int_init_array(
            v::Ref{_igraph_vector_int_t},
            buf::Ptr{_clong},
            _clong(m)::_clong
        )::Cint
    _chk(result, :igraph_vector_int_init_array)

    g = Ref{_igraph_t}()
    result = @ccall _lib.igraph_create(
            g::Ref{_igraph_t},
            v::Ref{_igraph_vector_int_t},
            _clong(nv)::_clong,
            Cint(directed ? 1 : 0)::_bool
        )::Cint
    _chk(result, :igraph_create)

    @ccall _lib.igraph_vector_int_destroy(v::Ref{_igraph_vector_int_t})::Cvoid
    return g[]
end

# (2) Flat 1-based edge list version (u1,v1,u2,v2,...) used by your tests
function small(nv::Integer, edges::Vector{Int}; directed::Bool=false)
    @assert iseven(length(edges)) "edges must have even length (u1,v1,u2,v2,...)"
    
    # Handle empty edge list case
    if isempty(edges)
        # Create empty graph
        g = Ref{_igraph_t}()
        _chk((@ccall _lib.igraph_empty(g::Ref{_igraph_t}, _clong(nv)::_clong, Cint(directed)::_bool)::_err_t), :igraph_empty)
        return g[]
    end
    
    # Validate vertex indices
    for i in 1:2:length(edges)
        s = edges[i]
        t = edges[i+1]
        if s < 1 || s > nv || t < 1 || t > nv
            error("Invalid vertex index in edge: ($s, $t). Vertices must be between 1 and $nv.")
        end
    end

    m = length(edges)
    buf = Vector{_clong}(undef, m)
    @inbounds for i in 1:m
        buf[i] = _clong(edges[i] - 1)
    end

    v = Ref{_igraph_vector_int_t}()
    result = @ccall _lib.igraph_vector_int_init_array(
            v::Ref{_igraph_vector_int_t},
            buf::Ptr{_clong},
            _clong(m)::_clong
        )::Cint
    _chk(result, :igraph_vector_int_init_array)

    g = Ref{_igraph_t}()
    result = @ccall _lib.igraph_create(
            g::Ref{_igraph_t},
            v::Ref{_igraph_vector_int_t},
            _clong(nv)::_clong,
            Cint(directed ? 1 : 0)::_bool
        )::Cint
    _chk(result, :igraph_create)

    @ccall _lib.igraph_vector_int_destroy(v::Ref{_igraph_vector_int_t})::Cvoid
    return g[]
end

function lcf(nv::Integer, shifts::AbstractVector{Int}, repeat::Integer; directed::Bool=false)
    n = length(shifts)
    buf = Vector{_cint}(undef, n)
    @inbounds for i in 1:n
        buf[i] = Cint(shifts[i])
    end
    g = Ref{_igraph_t}()
    _chk((@ccall _lib.igraph_lcf(g::Ref{_igraph_t},
                                 Cint(nv)::_cint,
                                 buf::Ptr{_cint},
                                 Cint(n)::_cint,
                                 Cint(repeat)::_cint,
                                 Cint(directed ? 1 : 0)::_bool)::_err_t),
         :igraph_lcf)
    return g[]
end

# -----------------------------------------------------------------------------
# D) LAYOUTS
# -----------------------------------------------------------------------------

function layout_grid(g::Ref{_igraph_t}, width::Integer)
    nv = Int((@ccall _lib.igraph_vcount(g::Ref{_igraph_t})::Clong))
    coords = Matrix{Float64}(undef, nv, 2)
    _chk((@ccall _lib.igraph_layout_grid(g::Ref{_igraph_t},
                                         Cint(width)::_cint,
                                         coords::Ptr{Float64},
                                         Cint(2)::_cint)::_err_t),
         :igraph_layout_grid)
    return coords
end

export adjlist_get, inclist_get, lazy_adjlist_get, lazy_adjlist_has,
       lazy_inclist_get, lazy_inclist_has,
       es_pairs_small, es_path_small, vs_vector_small,
       small, lcf, layout_grid
