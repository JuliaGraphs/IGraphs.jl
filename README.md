A thin Julia wrapper around the C graphs library [`igraph`](https://igraph.org/).

### Wrapper types

Most C types (like `igraph_vector_int_t`) are directly available in `IGraphs.LibIGraph` and also have Julian wrappers (like `IGVectorInt`). There is also `IGNull` as a convenient placeholder for whenever the `igraph` C function expects a `NULL` argument.

### High-level Julian interfaces

The Julian `IGraph` wrapper of the C `igraph_t` follows the `Graphs.jl` interface. Similarly the (`IGVector*` which wrap `igraph_vector_*_t`) and `IGMatrix*` (which wrap `igraph_matrix_*_t`) follow the Julia array interface. Other Julian interfaces are not implemented yet.

By default, all of these types are initialized, but empty. If you want to create unsafe uninitialized types (i.e. wrappers around uninitialized C structs) use `T(;_uninitialized=Var(true))` -- but be careful, uninitialized structs can cause segfaults on garbage collection.

### Conversions between Julia types from elsewhere in the ecosystem and IGraph Julian wrapper types

A (currently slow) convertor between `Graphs.Graph` and `IGraphs.IGraph` is available (simply by calling the constructors of one type on instances of the other type).

### Raw C bindings

The raw bindings for `igraph` are provided in `IGraphs.LibIGraph`. E.g. the following C function

```c
igraph_error_t igraph_get_eid(const igraph_t *graph, igraph_integer_t *eid,
                   igraph_integer_t from, igraph_integer_t to,
                   igraph_bool_t directed, igraph_bool_t error);
```

is available as the following Julia call

```julia
function igraph_get_eid(graph, eid, from, to, directed, error)
    ccall((:igraph_get_eid, libigraph), igraph_error_t, (Ptr{igraph_t}, Ptr{igraph_integer_t}, igraph_integer_t, igraph_integer_t, igraph_bool_t, igraph_bool_t), graph, eid, from, to, directed, error)
end
```

### Low-level Julian bindings

For each C function `igraph_functionname` there is a higher-level Julian `functionname` (also in `IGraphs.LibIGraph`), but modified as follows:

- errors are raised instead of just returned
- pointers to primitive types are hidden and the modified values of these primitive types are returned
- pointers to non-primitive C types are turned into Julian wrapper types
- the `igraph_` prefix is dropped from the function name

E.g. the C `igraph_get_eid` from above becomes

```julia
function get_eid(graph, from, to, directed, error)
    eid = fill(igraph_integer_t(0), ())
    res = igraph_get_eid(graph.objref, pointer(eid), igraph_integer_t(from), igraph_integer_t(to), igraph_bool_t(directed), igraph_bool_t(error))
    res == 0 || error("igraph's C library reports error ", res)
    return (Int(eid[]),)
end
```

### Version number

IGraphs.jl v`X.Y.Z` will always wrap a v`x.y.z` of the C library igraph where `X=x` and `Y=y`. `Z` and `z` might not match.

### Details and Wrapper stats

```julia-repl
# how many functions exist in the C library that are now accessible through `LibIGraph.igraph_functionname`
julia> IGraphs.allbindings |> length
2057

# how many functions are wrapped in a more Julian call interface and accessible through `LibIGraph.functionname`
julia> IGraphs.translatedbindings |> length
1243

# the difference between those two numbers
julia> IGraphs.untranslatedbindings |> length
814

# the number of C types with Julian wrappers
julia> IGraphs.wrappedtypes |> length
17

# the mapping between a C type and the wrapper with a Julian API
julia> IGraphs.wrappedtypes
Dict{Expr, Symbol} with 18 entries:
  :(Ptr{igraph_matrix_bool_t})     => :IGMatrixBool
  :(Ptr{igraph_matrix_char_t})     => :IGMatrixChar
  :(Ptr{igraph_vector_char_t})     => :IGVectorChar
  :(Ptr{igraph_vector_int_list_t}) => :IGVectorIntList
  :(Ptr{igraph_matrix_list_t})     => :IGMatrixFloatList
  :(Ptr{igraph_vector_list_t})     => :IGVectorFloatList
  :(Ptr{igraph_vector_complex_t})  => :IGVectorComplex
  :(Ptr{igraph_adjlist_t})         => :IGAdjList
  :(Ptr{igraph_matrix_complex_t})  => :IGMatrixComplex
  :(Ptr{igraph_bitset_list_t})     => :IGBitSetList
  :(Ptr{igraph_t})                 => :IGraph
  :(Ptr{igraph_bitset_t})          => :IGBitSet
  :(Ptr{igraph_matrix_int_t})      => :IGMatrixInt
  :(Ptr{igraph_vector_t})          => :IGVectorFloat
  :(Ptr{igraph_vector_int_t})      => :IGVectorInt
  :(Ptr{igraph_vector_bool_t})     => :IGVectorBool
  :(Ptr{igraph_matrix_t})          => :IGMatrixFloat
```