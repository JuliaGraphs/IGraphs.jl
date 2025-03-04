module LibIGraph

using igraph_jll
export igraph_jll

using CEnum

@cenum igraph_error_type_t::UInt32 begin
    IGRAPH_SUCCESS = 0
    IGRAPH_FAILURE = 1
    IGRAPH_ENOMEM = 2
    IGRAPH_PARSEERROR = 3
    IGRAPH_EINVAL = 4
    IGRAPH_EXISTS = 5
    IGRAPH_EINVEVECTOR = 6
    IGRAPH_EINVVID = 7
    IGRAPH_NONSQUARE = 8
    IGRAPH_EINVMODE = 9
    IGRAPH_EFILE = 10
    IGRAPH_UNIMPLEMENTED = 12
    IGRAPH_INTERRUPTED = 13
    IGRAPH_DIVERGED = 14
    IGRAPH_ARPACK_PROD = 15
    IGRAPH_ARPACK_NPOS = 16
    IGRAPH_ARPACK_NEVNPOS = 17
    IGRAPH_ARPACK_NCVSMALL = 18
    IGRAPH_ARPACK_NONPOSI = 19
    IGRAPH_ARPACK_WHICHINV = 20
    IGRAPH_ARPACK_BMATINV = 21
    IGRAPH_ARPACK_WORKLSMALL = 22
    IGRAPH_ARPACK_TRIDERR = 23
    IGRAPH_ARPACK_ZEROSTART = 24
    IGRAPH_ARPACK_MODEINV = 25
    IGRAPH_ARPACK_MODEBMAT = 26
    IGRAPH_ARPACK_ISHIFT = 27
    IGRAPH_ARPACK_NEVBE = 28
    IGRAPH_ARPACK_NOFACT = 29
    IGRAPH_ARPACK_FAILED = 30
    IGRAPH_ARPACK_HOWMNY = 31
    IGRAPH_ARPACK_HOWMNYS = 32
    IGRAPH_ARPACK_EVDIFF = 33
    IGRAPH_ARPACK_SHUR = 34
    IGRAPH_ARPACK_LAPACK = 35
    IGRAPH_ARPACK_UNKNOWN = 36
    IGRAPH_ENEGLOOP = 37
    IGRAPH_EINTERNAL = 38
    IGRAPH_ARPACK_MAXIT = 39
    IGRAPH_ARPACK_NOSHIFT = 40
    IGRAPH_ARPACK_REORDER = 41
    IGRAPH_EDIVZERO = 42
    IGRAPH_GLP_EBOUND = 43
    IGRAPH_GLP_EROOT = 44
    IGRAPH_GLP_ENOPFS = 45
    IGRAPH_GLP_ENODFS = 46
    IGRAPH_GLP_EFAIL = 47
    IGRAPH_GLP_EMIPGAP = 48
    IGRAPH_GLP_ETMLIM = 49
    IGRAPH_GLP_ESTOP = 50
    IGRAPH_EATTRIBUTES = 51
    IGRAPH_EATTRCOMBINE = 52
    IGRAPH_ELAPACK = 53
    IGRAPH_EDRL = 54
    IGRAPH_EOVERFLOW = 55
    IGRAPH_EGLP = 56
    IGRAPH_CPUTIME = 57
    IGRAPH_EUNDERFLOW = 58
    IGRAPH_ERWSTUCK = 59
    IGRAPH_STOP = 60
    IGRAPH_ERANGE = 61
    IGRAPH_ENOSOL = 62
end

const igraph_error_t = igraph_error_type_t

function igraph_error(reason, file, line, igraph_errno)
    ccall((:igraph_error, libigraph), igraph_error_t, (Ptr{Cchar}, Ptr{Cchar}, Cint, igraph_error_t), reason, file, line, igraph_errno)
end

function IGRAPH_FINALLY_STACK_SIZE()
    ccall((:IGRAPH_FINALLY_STACK_SIZE, libigraph), Cint, ())
end

# typedef void igraph_finally_func_t ( void * )
const igraph_finally_func_t = Cvoid

function IGRAPH_FINALLY_REAL(func, ptr)
    ccall((:IGRAPH_FINALLY_REAL, libigraph), Cvoid, (Ptr{igraph_finally_func_t}, Ptr{Cvoid}), func, ptr)
end

function igraph_warning(reason, file, line)
    ccall((:igraph_warning, libigraph), Cvoid, (Ptr{Cchar}, Ptr{Cchar}, Cint), reason, file, line)
end

function igraph_fatal(reason, file, line)
    ccall((:igraph_fatal, libigraph), Cvoid, (Ptr{Cchar}, Ptr{Cchar}, Cint), reason, file, line)
end

function igraph_finite(x)
    ccall((:igraph_finite, libigraph), Cint, (Cdouble,), x)
end

const igraph_real_t = Cdouble

struct igraph_vector_t
    stor_begin::Ptr{igraph_real_t}
    stor_end::Ptr{igraph_real_t}
    _end::Ptr{igraph_real_t}
end

const igraph_integer_t = Int64

struct igraph_matrix_t
    data::igraph_vector_t
    nrow::igraph_integer_t
    ncol::igraph_integer_t
end

function igraph_real_printf(val)
    ccall((:igraph_real_printf, libigraph), Cint, (igraph_real_t,), val)
end

function igraph_real_snprintf(str, size, val)
    ccall((:igraph_real_snprintf, libigraph), Cint, (Ptr{Cchar}, Csize_t, igraph_real_t), str, size, val)
end

function igraph_real_fprintf_aligned(file, width, val)
    ccall((:igraph_real_fprintf_aligned, libigraph), Cint, (Ptr{Libc.FILE}, Cint, igraph_real_t), file, width, val)
end

function igraph_real_fprintf(file, val)
    ccall((:igraph_real_fprintf, libigraph), Cint, (Ptr{Libc.FILE}, igraph_real_t), file, val)
end

struct igraph_vector_char_t
    stor_begin::Ptr{Cchar}
    stor_end::Ptr{Cchar}
    _end::Ptr{Cchar}
end

mutable struct igraph_matrix_char_t
    data::igraph_vector_char_t
    nrow::igraph_integer_t
    ncol::igraph_integer_t
    igraph_matrix_char_t() = new()
end

const igraph_bool_t = Bool

struct igraph_vector_bool_t
    stor_begin::Ptr{igraph_bool_t}
    stor_end::Ptr{igraph_bool_t}
    _end::Ptr{igraph_bool_t}
end

mutable struct igraph_matrix_bool_t
    data::igraph_vector_bool_t
    nrow::igraph_integer_t
    ncol::igraph_integer_t
    igraph_matrix_bool_t() = new()
end

struct igraph_vector_int_t
    stor_begin::Ptr{igraph_integer_t}
    stor_end::Ptr{igraph_integer_t}
    _end::Ptr{igraph_integer_t}
end

mutable struct igraph_matrix_int_t
    data::igraph_vector_int_t
    nrow::igraph_integer_t
    ncol::igraph_integer_t
    igraph_matrix_int_t() = new()
end

struct igraph_complex_t
    dat::NTuple{2, igraph_real_t}
end

struct igraph_vector_complex_t
    stor_begin::Ptr{igraph_complex_t}
    stor_end::Ptr{igraph_complex_t}
    _end::Ptr{igraph_complex_t}
end

struct igraph_matrix_complex_t
    data::igraph_vector_complex_t
    nrow::igraph_integer_t
    ncol::igraph_integer_t
end

function igraph_complex_printf(val)
    ccall((:igraph_complex_printf, libigraph), Cint, (igraph_complex_t,), val)
end

function igraph_complex_snprintf(str, size, val)
    ccall((:igraph_complex_snprintf, libigraph), Cint, (Ptr{Cchar}, Csize_t, igraph_complex_t), str, size, val)
end

function igraph_complex_fprintf_aligned(file, width, val)
    ccall((:igraph_complex_fprintf_aligned, libigraph), Cint, (Ptr{Libc.FILE}, Cint, igraph_complex_t), file, width, val)
end

function igraph_complex_fprintf(file, val)
    ccall((:igraph_complex_fprintf, libigraph), Cint, (Ptr{Libc.FILE}, igraph_complex_t), file, val)
end

function igraph_complex_add(z1, z2)
    ccall((:igraph_complex_add, libigraph), igraph_complex_t, (igraph_complex_t, igraph_complex_t), z1, z2)
end

function igraph_complex_sub(z1, z2)
    ccall((:igraph_complex_sub, libigraph), igraph_complex_t, (igraph_complex_t, igraph_complex_t), z1, z2)
end

function igraph_complex_mul(z1, z2)
    ccall((:igraph_complex_mul, libigraph), igraph_complex_t, (igraph_complex_t, igraph_complex_t), z1, z2)
end

function igraph_complex_div(z1, z2)
    ccall((:igraph_complex_div, libigraph), igraph_complex_t, (igraph_complex_t, igraph_complex_t), z1, z2)
end

function igraph_vector_init(v, size)
    ccall((:igraph_vector_init, libigraph), igraph_error_t, (Ptr{igraph_vector_t}, igraph_integer_t), v, size)
end

function igraph_vector_destroy(v)
    ccall((:igraph_vector_destroy, libigraph), Cvoid, (Ptr{igraph_vector_t},), v)
end

function igraph_vector_bool_init(v, size)
    ccall((:igraph_vector_bool_init, libigraph), igraph_error_t, (Ptr{igraph_vector_bool_t}, igraph_integer_t), v, size)
end

function igraph_vector_bool_destroy(v)
    ccall((:igraph_vector_bool_destroy, libigraph), Cvoid, (Ptr{igraph_vector_bool_t},), v)
end

function igraph_vector_char_init(v, size)
    ccall((:igraph_vector_char_init, libigraph), igraph_error_t, (Ptr{igraph_vector_char_t}, igraph_integer_t), v, size)
end

function igraph_vector_char_destroy(v)
    ccall((:igraph_vector_char_destroy, libigraph), Cvoid, (Ptr{igraph_vector_char_t},), v)
end

function igraph_vector_int_init(v, size)
    ccall((:igraph_vector_int_init, libigraph), igraph_error_t, (Ptr{igraph_vector_int_t}, igraph_integer_t), v, size)
end

function igraph_vector_int_destroy(v)
    ccall((:igraph_vector_int_destroy, libigraph), Cvoid, (Ptr{igraph_vector_int_t},), v)
end

struct igraph_rng_type_t
    name::Ptr{Cchar}
    bits::UInt8
    init::Ptr{Cvoid}
    destroy::Ptr{Cvoid}
    seed::Ptr{Cvoid}
    get::Ptr{Cvoid}
    get_int::Ptr{Cvoid}
    get_real::Ptr{Cvoid}
    get_norm::Ptr{Cvoid}
    get_geom::Ptr{Cvoid}
    get_binom::Ptr{Cvoid}
    get_exp::Ptr{Cvoid}
    get_gamma::Ptr{Cvoid}
    get_pois::Ptr{Cvoid}
end

mutable struct igraph_rng_t
    type::Ptr{igraph_rng_type_t}
    state::Ptr{Cvoid}
    is_seeded::igraph_bool_t
    igraph_rng_t() = new()
end

function igraph_rng_default()
    ccall((:igraph_rng_default, libigraph), Ptr{igraph_rng_t}, ())
end

const igraph_uint_t = UInt64

function igraph_rng_seed(rng, seed)
    ccall((:igraph_rng_seed, libigraph), igraph_error_t, (Ptr{igraph_rng_t}, igraph_uint_t), rng, seed)
end

function igraph_rng_get_integer(rng, l, h)
    ccall((:igraph_rng_get_integer, libigraph), igraph_integer_t, (Ptr{igraph_rng_t}, igraph_integer_t, igraph_integer_t), rng, l, h)
end

function igraph_rng_get_normal(rng, m, s)
    ccall((:igraph_rng_get_normal, libigraph), igraph_real_t, (Ptr{igraph_rng_t}, igraph_real_t, igraph_real_t), rng, m, s)
end

function igraph_rng_get_unif(rng, l, h)
    ccall((:igraph_rng_get_unif, libigraph), igraph_real_t, (Ptr{igraph_rng_t}, igraph_real_t, igraph_real_t), rng, l, h)
end

function igraph_rng_get_unif01(rng)
    ccall((:igraph_rng_get_unif01, libigraph), igraph_real_t, (Ptr{igraph_rng_t},), rng)
end

function igraph_rng_get_geom(rng, p)
    ccall((:igraph_rng_get_geom, libigraph), igraph_real_t, (Ptr{igraph_rng_t}, igraph_real_t), rng, p)
end

function igraph_rng_get_binom(rng, n, p)
    ccall((:igraph_rng_get_binom, libigraph), igraph_real_t, (Ptr{igraph_rng_t}, igraph_integer_t, igraph_real_t), rng, n, p)
end

function igraph_rng_get_exp(rng, rate)
    ccall((:igraph_rng_get_exp, libigraph), igraph_real_t, (Ptr{igraph_rng_t}, igraph_real_t), rng, rate)
end

function igraph_rng_get_pois(rng, rate)
    ccall((:igraph_rng_get_pois, libigraph), igraph_real_t, (Ptr{igraph_rng_t}, igraph_real_t), rng, rate)
end

function igraph_rng_get_gamma(rng, shape, scale)
    ccall((:igraph_rng_get_gamma, libigraph), igraph_real_t, (Ptr{igraph_rng_t}, igraph_real_t, igraph_real_t), rng, shape, scale)
end

function igraph_progress(message, percent, data)
    ccall((:igraph_progress, libigraph), igraph_error_t, (Ptr{Cchar}, igraph_real_t, Ptr{Cvoid}), message, percent, data)
end

function IGRAPH_FINALLY_FREE()
    ccall((:IGRAPH_FINALLY_FREE, libigraph), Cvoid, ())
end

function igraph_status(message, data)
    ccall((:igraph_status, libigraph), igraph_error_t, (Ptr{Cchar}, Ptr{Cvoid}), message, data)
end

function igraph_matrix_init(m, nrow, ncol)
    ccall((:igraph_matrix_init, libigraph), igraph_error_t, (Ptr{igraph_matrix_t}, igraph_integer_t, igraph_integer_t), m, nrow, ncol)
end

function igraph_matrix_destroy(m)
    ccall((:igraph_matrix_destroy, libigraph), Cvoid, (Ptr{igraph_matrix_t},), m)
end

function igraph_matrix_int_init(m, nrow, ncol)
    ccall((:igraph_matrix_int_init, libigraph), igraph_error_t, (Ptr{igraph_matrix_int_t}, igraph_integer_t, igraph_integer_t), m, nrow, ncol)
end

function igraph_matrix_int_destroy(m)
    ccall((:igraph_matrix_int_destroy, libigraph), Cvoid, (Ptr{igraph_matrix_int_t},), m)
end

mutable struct igraph_array3_t
    data::igraph_vector_t
    n1::igraph_integer_t
    n2::igraph_integer_t
    n3::igraph_integer_t
    n1n2::igraph_integer_t
    igraph_array3_t() = new()
end

function igraph_array3_init(a, n1, n2, n3)
    ccall((:igraph_array3_init, libigraph), igraph_error_t, (Ptr{igraph_array3_t}, igraph_integer_t, igraph_integer_t, igraph_integer_t), a, n1, n2, n3)
end

function igraph_array3_destroy(a)
    ccall((:igraph_array3_destroy, libigraph), Cvoid, (Ptr{igraph_array3_t},), a)
end

struct igraph_bitset_t
    size::igraph_integer_t
    stor_begin::Ptr{igraph_uint_t}
    stor_end::Ptr{igraph_uint_t}
end

function igraph_bitset_init(bitset, size)
    ccall((:igraph_bitset_init, libigraph), igraph_error_t, (Ptr{igraph_bitset_t}, igraph_integer_t), bitset, size)
end

function igraph_bitset_destroy(bitset)
    ccall((:igraph_bitset_destroy, libigraph), Cvoid, (Ptr{igraph_bitset_t},), bitset)
end

mutable struct igraph_dqueue_t
    _begin::Ptr{igraph_real_t}
    _end::Ptr{igraph_real_t}
    stor_begin::Ptr{igraph_real_t}
    stor_end::Ptr{igraph_real_t}
    igraph_dqueue_t() = new()
end

function igraph_dqueue_init(q, capacity)
    ccall((:igraph_dqueue_init, libigraph), igraph_error_t, (Ptr{igraph_dqueue_t}, igraph_integer_t), q, capacity)
end

function igraph_dqueue_destroy(q)
    ccall((:igraph_dqueue_destroy, libigraph), Cvoid, (Ptr{igraph_dqueue_t},), q)
end

mutable struct igraph_dqueue_int_t
    _begin::Ptr{igraph_integer_t}
    _end::Ptr{igraph_integer_t}
    stor_begin::Ptr{igraph_integer_t}
    stor_end::Ptr{igraph_integer_t}
    igraph_dqueue_int_t() = new()
end

function igraph_dqueue_int_init(q, capacity)
    ccall((:igraph_dqueue_int_init, libigraph), igraph_error_t, (Ptr{igraph_dqueue_int_t}, igraph_integer_t), q, capacity)
end

function igraph_dqueue_int_destroy(q)
    ccall((:igraph_dqueue_int_destroy, libigraph), Cvoid, (Ptr{igraph_dqueue_int_t},), q)
end

mutable struct igraph_stack_t
    stor_begin::Ptr{igraph_real_t}
    stor_end::Ptr{igraph_real_t}
    _end::Ptr{igraph_real_t}
    igraph_stack_t() = new()
end

function igraph_stack_init(s, capacity)
    ccall((:igraph_stack_init, libigraph), igraph_error_t, (Ptr{igraph_stack_t}, igraph_integer_t), s, capacity)
end

function igraph_stack_destroy(s)
    ccall((:igraph_stack_destroy, libigraph), Cvoid, (Ptr{igraph_stack_t},), s)
end

mutable struct igraph_stack_int_t
    stor_begin::Ptr{igraph_integer_t}
    stor_end::Ptr{igraph_integer_t}
    _end::Ptr{igraph_integer_t}
    igraph_stack_int_t() = new()
end

function igraph_stack_int_init(s, capacity)
    ccall((:igraph_stack_int_init, libigraph), igraph_error_t, (Ptr{igraph_stack_int_t}, igraph_integer_t), s, capacity)
end

function igraph_stack_int_destroy(s)
    ccall((:igraph_stack_int_destroy, libigraph), Cvoid, (Ptr{igraph_stack_int_t},), s)
end

mutable struct s_igraph_strvector
    stor_begin::Ptr{Ptr{Cchar}}
    stor_end::Ptr{Ptr{Cchar}}
    _end::Ptr{Ptr{Cchar}}
    s_igraph_strvector() = new()
end

const igraph_strvector_t = s_igraph_strvector

function igraph_strvector_get(sv, idx)
    ccall((:igraph_strvector_get, libigraph), Ptr{Cchar}, (Ptr{igraph_strvector_t}, igraph_integer_t), sv, idx)
end

function igraph_strvector_init(sv, len)
    ccall((:igraph_strvector_init, libigraph), igraph_error_t, (Ptr{igraph_strvector_t}, igraph_integer_t), sv, len)
end

function igraph_strvector_destroy(sv)
    ccall((:igraph_strvector_destroy, libigraph), Cvoid, (Ptr{igraph_strvector_t},), sv)
end

mutable struct igraph_vector_list_t
    stor_begin::Ptr{igraph_vector_t}
    stor_end::Ptr{igraph_vector_t}
    _end::Ptr{igraph_vector_t}
    igraph_vector_list_t() = new()
end

function igraph_vector_list_init(v, size)
    ccall((:igraph_vector_list_init, libigraph), igraph_error_t, (Ptr{igraph_vector_list_t}, igraph_integer_t), v, size)
end

function igraph_vector_list_destroy(v)
    ccall((:igraph_vector_list_destroy, libigraph), Cvoid, (Ptr{igraph_vector_list_t},), v)
end

mutable struct igraph_vector_int_list_t
    stor_begin::Ptr{igraph_vector_int_t}
    stor_end::Ptr{igraph_vector_int_t}
    _end::Ptr{igraph_vector_int_t}
    igraph_vector_int_list_t() = new()
end

function igraph_vector_int_list_init(v, size)
    ccall((:igraph_vector_int_list_init, libigraph), igraph_error_t, (Ptr{igraph_vector_int_list_t}, igraph_integer_t), v, size)
end

function igraph_vector_int_list_destroy(v)
    ccall((:igraph_vector_int_list_destroy, libigraph), Cvoid, (Ptr{igraph_vector_int_list_t},), v)
end

struct s_vector_ptr
    stor_begin::Ptr{Ptr{Cvoid}}
    stor_end::Ptr{Ptr{Cvoid}}
    _end::Ptr{Ptr{Cvoid}}
    item_destructor::Ptr{igraph_finally_func_t}
end

const igraph_vector_ptr_t = s_vector_ptr

function igraph_vector_ptr_init(v, size)
    ccall((:igraph_vector_ptr_init, libigraph), igraph_error_t, (Ptr{igraph_vector_ptr_t}, igraph_integer_t), v, size)
end

function igraph_vector_ptr_destroy(v)
    ccall((:igraph_vector_ptr_destroy, libigraph), Cvoid, (Ptr{igraph_vector_ptr_t},), v)
end

function igraph_vector_ptr_set_item_destructor(v, func)
    ccall((:igraph_vector_ptr_set_item_destructor, libigraph), Ptr{igraph_finally_func_t}, (Ptr{igraph_vector_ptr_t}, Ptr{igraph_finally_func_t}), v, func)
end

mutable struct igraph_i_property_cache_t end

struct igraph_s
    n::igraph_integer_t
    directed::igraph_bool_t
    from::igraph_vector_int_t
    to::igraph_vector_int_t
    oi::igraph_vector_int_t
    ii::igraph_vector_int_t
    os::igraph_vector_int_t
    is::igraph_vector_int_t
    attr::Ptr{Cvoid}
    cache::Ptr{igraph_i_property_cache_t}
end

const igraph_t = igraph_s

mutable struct igraph_graph_list_t
    stor_begin::Ptr{igraph_t}
    stor_end::Ptr{igraph_t}
    _end::Ptr{igraph_t}
    directed::igraph_bool_t
    igraph_graph_list_t() = new()
end

function igraph_graph_list_init(v, size)
    ccall((:igraph_graph_list_init, libigraph), igraph_error_t, (Ptr{igraph_graph_list_t}, igraph_integer_t), v, size)
end

function igraph_graph_list_destroy(v)
    ccall((:igraph_graph_list_destroy, libigraph), Cvoid, (Ptr{igraph_graph_list_t},), v)
end

@cenum igraph_cached_property_t::UInt32 begin
    IGRAPH_PROP_HAS_LOOP = 0
    IGRAPH_PROP_HAS_MULTI = 1
    IGRAPH_PROP_HAS_MUTUAL = 2
    IGRAPH_PROP_IS_WEAKLY_CONNECTED = 3
    IGRAPH_PROP_IS_STRONGLY_CONNECTED = 4
    IGRAPH_PROP_IS_DAG = 5
    IGRAPH_PROP_IS_FOREST = 6
    IGRAPH_PROP_I_SIZE = 7
end

function igraph_i_property_cache_has(graph, prop)
    ccall((:igraph_i_property_cache_has, libigraph), igraph_bool_t, (Ptr{igraph_t}, igraph_cached_property_t), graph, prop)
end

function igraph_i_property_cache_get_bool(graph, prop)
    ccall((:igraph_i_property_cache_get_bool, libigraph), igraph_bool_t, (Ptr{igraph_t}, igraph_cached_property_t), graph, prop)
end

mutable struct igraph_matrix_list_t
    stor_begin::Ptr{igraph_matrix_t}
    stor_end::Ptr{igraph_matrix_t}
    _end::Ptr{igraph_matrix_t}
    igraph_matrix_list_t() = new()
end

function igraph_matrix_list_init(v, size)
    ccall((:igraph_matrix_list_init, libigraph), igraph_error_t, (Ptr{igraph_matrix_list_t}, igraph_integer_t), v, size)
end

function igraph_matrix_list_destroy(v)
    ccall((:igraph_matrix_list_destroy, libigraph), Cvoid, (Ptr{igraph_matrix_list_t},), v)
end

function igraph_cattribute_GAN(graph, name)
    ccall((:igraph_cattribute_GAN, libigraph), igraph_real_t, (Ptr{igraph_t}, Ptr{Cchar}), graph, name)
end

function igraph_cattribute_GAB(graph, name)
    ccall((:igraph_cattribute_GAB, libigraph), igraph_bool_t, (Ptr{igraph_t}, Ptr{Cchar}), graph, name)
end

function igraph_cattribute_GAS(graph, name)
    ccall((:igraph_cattribute_GAS, libigraph), Ptr{Cchar}, (Ptr{igraph_t}, Ptr{Cchar}), graph, name)
end

function igraph_cattribute_VAN(graph, name, vid)
    ccall((:igraph_cattribute_VAN, libigraph), igraph_real_t, (Ptr{igraph_t}, Ptr{Cchar}, igraph_integer_t), graph, name, vid)
end

function igraph_cattribute_VAB(graph, name, vid)
    ccall((:igraph_cattribute_VAB, libigraph), igraph_bool_t, (Ptr{igraph_t}, Ptr{Cchar}, igraph_integer_t), graph, name, vid)
end

function igraph_cattribute_VAS(graph, name, vid)
    ccall((:igraph_cattribute_VAS, libigraph), Ptr{Cchar}, (Ptr{igraph_t}, Ptr{Cchar}, igraph_integer_t), graph, name, vid)
end

@cenum igraph_vs_type_t::UInt32 begin
    IGRAPH_VS_ALL = 0
    IGRAPH_VS_ADJ = 1
    IGRAPH_VS_NONE = 2
    IGRAPH_VS_1 = 3
    IGRAPH_VS_VECTORPTR = 4
    IGRAPH_VS_VECTOR = 5
    IGRAPH_VS_RANGE = 6
    IGRAPH_VS_NONADJ = 7
end

struct var"union (unnamed at /home/stefan/.julia/artifacts/d7abc8767e8a099d5939fead030cd46916c2c387/include/igraph/igraph_iterators.h:53:5)"
    data::NTuple{16, UInt8}
end

function Base.getproperty(x::Ptr{var"union (unnamed at /home/stefan/.julia/artifacts/d7abc8767e8a099d5939fead030cd46916c2c387/include/igraph/igraph_iterators.h:53:5)"}, f::Symbol)
    f === :vid && return Ptr{igraph_integer_t}(x + 0)
    f === :vecptr && return Ptr{Ptr{igraph_vector_int_t}}(x + 0)
    f === :adj && return Ptr{var"struct (unnamed at /home/stefan/.julia/artifacts/d7abc8767e8a099d5939fead030cd46916c2c387/include/igraph/igraph_iterators.h:56:9)"}(x + 0)
    f === :range && return Ptr{var"struct (unnamed at /home/stefan/.julia/artifacts/d7abc8767e8a099d5939fead030cd46916c2c387/include/igraph/igraph_iterators.h:60:9)"}(x + 0)
    return getfield(x, f)
end

function Base.getproperty(x::var"union (unnamed at /home/stefan/.julia/artifacts/d7abc8767e8a099d5939fead030cd46916c2c387/include/igraph/igraph_iterators.h:53:5)", f::Symbol)
    r = Ref{var"union (unnamed at /home/stefan/.julia/artifacts/d7abc8767e8a099d5939fead030cd46916c2c387/include/igraph/igraph_iterators.h:53:5)"}(x)
    ptr = Base.unsafe_convert(Ptr{var"union (unnamed at /home/stefan/.julia/artifacts/d7abc8767e8a099d5939fead030cd46916c2c387/include/igraph/igraph_iterators.h:53:5)"}, r)
    fptr = getproperty(ptr, f)
    GC.@preserve r unsafe_load(fptr)
end

function Base.setproperty!(x::Ptr{var"union (unnamed at /home/stefan/.julia/artifacts/d7abc8767e8a099d5939fead030cd46916c2c387/include/igraph/igraph_iterators.h:53:5)"}, f::Symbol, v)
    unsafe_store!(getproperty(x, f), v)
end

struct igraph_vs_t
    data::NTuple{24, UInt8}
end

function Base.getproperty(x::Ptr{igraph_vs_t}, f::Symbol)
    f === :type && return Ptr{igraph_vs_type_t}(x + 0)
    f === :data && return Ptr{var"union (unnamed at /home/stefan/.julia/artifacts/d7abc8767e8a099d5939fead030cd46916c2c387/include/igraph/igraph_iterators.h:53:5)"}(x + 8)
    return getfield(x, f)
end

function Base.getproperty(x::igraph_vs_t, f::Symbol)
    r = Ref{igraph_vs_t}(x)
    ptr = Base.unsafe_convert(Ptr{igraph_vs_t}, r)
    fptr = getproperty(ptr, f)
    GC.@preserve r unsafe_load(fptr)
end

function Base.setproperty!(x::Ptr{igraph_vs_t}, f::Symbol, v)
    unsafe_store!(getproperty(x, f), v)
end

function igraph_cattribute_VANV(graph, name, vids, result)
    ccall((:igraph_cattribute_VANV, libigraph), igraph_error_t, (Ptr{igraph_t}, Ptr{Cchar}, igraph_vs_t, Ptr{igraph_vector_t}), graph, name, vids, result)
end

function igraph_vss_all()
    ccall((:igraph_vss_all, libigraph), igraph_vs_t, ())
end

function igraph_cattribute_VABV(graph, name, vids, result)
    ccall((:igraph_cattribute_VABV, libigraph), igraph_error_t, (Ptr{igraph_t}, Ptr{Cchar}, igraph_vs_t, Ptr{igraph_vector_bool_t}), graph, name, vids, result)
end

function igraph_cattribute_VASV(graph, name, vids, result)
    ccall((:igraph_cattribute_VASV, libigraph), igraph_error_t, (Ptr{igraph_t}, Ptr{Cchar}, igraph_vs_t, Ptr{igraph_strvector_t}), graph, name, vids, result)
end

function igraph_cattribute_EAN(graph, name, eid)
    ccall((:igraph_cattribute_EAN, libigraph), igraph_real_t, (Ptr{igraph_t}, Ptr{Cchar}, igraph_integer_t), graph, name, eid)
end

function igraph_cattribute_EAB(graph, name, eid)
    ccall((:igraph_cattribute_EAB, libigraph), igraph_bool_t, (Ptr{igraph_t}, Ptr{Cchar}, igraph_integer_t), graph, name, eid)
end

function igraph_cattribute_EAS(graph, name, eid)
    ccall((:igraph_cattribute_EAS, libigraph), Ptr{Cchar}, (Ptr{igraph_t}, Ptr{Cchar}, igraph_integer_t), graph, name, eid)
end

@cenum igraph_es_type_t::UInt32 begin
    IGRAPH_ES_ALL = 0
    IGRAPH_ES_ALLFROM = 1
    IGRAPH_ES_ALLTO = 2
    IGRAPH_ES_INCIDENT = 3
    IGRAPH_ES_NONE = 4
    IGRAPH_ES_1 = 5
    IGRAPH_ES_VECTORPTR = 6
    IGRAPH_ES_VECTOR = 7
    IGRAPH_ES_RANGE = 8
    IGRAPH_ES_PAIRS = 9
    IGRAPH_ES_PATH = 10
    IGRAPH_ES_UNUSED_WAS_MULTIPAIRS = 11
    IGRAPH_ES_ALL_BETWEEN = 12
end

struct var"union (unnamed at /home/stefan/.julia/artifacts/d7abc8767e8a099d5939fead030cd46916c2c387/include/igraph/igraph_iterators.h:249:5)"
    data::NTuple{24, UInt8}
end

function Base.getproperty(x::Ptr{var"union (unnamed at /home/stefan/.julia/artifacts/d7abc8767e8a099d5939fead030cd46916c2c387/include/igraph/igraph_iterators.h:249:5)"}, f::Symbol)
    f === :vid && return Ptr{igraph_integer_t}(x + 0)
    f === :eid && return Ptr{igraph_integer_t}(x + 0)
    f === :vecptr && return Ptr{Ptr{igraph_vector_int_t}}(x + 0)
    f === :incident && return Ptr{var"struct (unnamed at /home/stefan/.julia/artifacts/d7abc8767e8a099d5939fead030cd46916c2c387/include/igraph/igraph_iterators.h:253:9)"}(x + 0)
    f === :range && return Ptr{var"struct (unnamed at /home/stefan/.julia/artifacts/d7abc8767e8a099d5939fead030cd46916c2c387/include/igraph/igraph_iterators.h:257:9)"}(x + 0)
    f === :path && return Ptr{var"struct (unnamed at /home/stefan/.julia/artifacts/d7abc8767e8a099d5939fead030cd46916c2c387/include/igraph/igraph_iterators.h:261:9)"}(x + 0)
    f === :between && return Ptr{var"struct (unnamed at /home/stefan/.julia/artifacts/d7abc8767e8a099d5939fead030cd46916c2c387/include/igraph/igraph_iterators.h:265:9)"}(x + 0)
    return getfield(x, f)
end

function Base.getproperty(x::var"union (unnamed at /home/stefan/.julia/artifacts/d7abc8767e8a099d5939fead030cd46916c2c387/include/igraph/igraph_iterators.h:249:5)", f::Symbol)
    r = Ref{var"union (unnamed at /home/stefan/.julia/artifacts/d7abc8767e8a099d5939fead030cd46916c2c387/include/igraph/igraph_iterators.h:249:5)"}(x)
    ptr = Base.unsafe_convert(Ptr{var"union (unnamed at /home/stefan/.julia/artifacts/d7abc8767e8a099d5939fead030cd46916c2c387/include/igraph/igraph_iterators.h:249:5)"}, r)
    fptr = getproperty(ptr, f)
    GC.@preserve r unsafe_load(fptr)
end

function Base.setproperty!(x::Ptr{var"union (unnamed at /home/stefan/.julia/artifacts/d7abc8767e8a099d5939fead030cd46916c2c387/include/igraph/igraph_iterators.h:249:5)"}, f::Symbol, v)
    unsafe_store!(getproperty(x, f), v)
end

struct igraph_es_t
    data::NTuple{32, UInt8}
end

function Base.getproperty(x::Ptr{igraph_es_t}, f::Symbol)
    f === :type && return Ptr{igraph_es_type_t}(x + 0)
    f === :data && return Ptr{var"union (unnamed at /home/stefan/.julia/artifacts/d7abc8767e8a099d5939fead030cd46916c2c387/include/igraph/igraph_iterators.h:249:5)"}(x + 8)
    return getfield(x, f)
end

function Base.getproperty(x::igraph_es_t, f::Symbol)
    r = Ref{igraph_es_t}(x)
    ptr = Base.unsafe_convert(Ptr{igraph_es_t}, r)
    fptr = getproperty(ptr, f)
    GC.@preserve r unsafe_load(fptr)
end

function Base.setproperty!(x::Ptr{igraph_es_t}, f::Symbol, v)
    unsafe_store!(getproperty(x, f), v)
end

function igraph_cattribute_EANV(graph, name, eids, result)
    ccall((:igraph_cattribute_EANV, libigraph), igraph_error_t, (Ptr{igraph_t}, Ptr{Cchar}, igraph_es_t, Ptr{igraph_vector_t}), graph, name, eids, result)
end

@cenum igraph_edgeorder_type_t::UInt32 begin
    IGRAPH_EDGEORDER_ID = 0
    IGRAPH_EDGEORDER_FROM = 1
    IGRAPH_EDGEORDER_TO = 2
end

function igraph_ess_all(order)
    ccall((:igraph_ess_all, libigraph), igraph_es_t, (igraph_edgeorder_type_t,), order)
end

function igraph_cattribute_EABV(graph, name, eids, result)
    ccall((:igraph_cattribute_EABV, libigraph), igraph_error_t, (Ptr{igraph_t}, Ptr{Cchar}, igraph_es_t, Ptr{igraph_vector_bool_t}), graph, name, eids, result)
end

function igraph_cattribute_EASV(graph, name, eids, result)
    ccall((:igraph_cattribute_EASV, libigraph), igraph_error_t, (Ptr{igraph_t}, Ptr{Cchar}, igraph_es_t, Ptr{igraph_strvector_t}), graph, name, eids, result)
end

function igraph_cattribute_GAN_set(graph, name, value)
    ccall((:igraph_cattribute_GAN_set, libigraph), igraph_error_t, (Ptr{igraph_t}, Ptr{Cchar}, igraph_real_t), graph, name, value)
end

function igraph_cattribute_GAB_set(graph, name, value)
    ccall((:igraph_cattribute_GAB_set, libigraph), igraph_error_t, (Ptr{igraph_t}, Ptr{Cchar}, igraph_bool_t), graph, name, value)
end

function igraph_cattribute_GAS_set(graph, name, value)
    ccall((:igraph_cattribute_GAS_set, libigraph), igraph_error_t, (Ptr{igraph_t}, Ptr{Cchar}, Ptr{Cchar}), graph, name, value)
end

function igraph_cattribute_VAN_set(graph, name, vid, value)
    ccall((:igraph_cattribute_VAN_set, libigraph), igraph_error_t, (Ptr{igraph_t}, Ptr{Cchar}, igraph_integer_t, igraph_real_t), graph, name, vid, value)
end

function igraph_cattribute_VAB_set(graph, name, vid, value)
    ccall((:igraph_cattribute_VAB_set, libigraph), igraph_error_t, (Ptr{igraph_t}, Ptr{Cchar}, igraph_integer_t, igraph_bool_t), graph, name, vid, value)
end

function igraph_cattribute_VAS_set(graph, name, vid, value)
    ccall((:igraph_cattribute_VAS_set, libigraph), igraph_error_t, (Ptr{igraph_t}, Ptr{Cchar}, igraph_integer_t, Ptr{Cchar}), graph, name, vid, value)
end

function igraph_cattribute_EAN_set(graph, name, eid, value)
    ccall((:igraph_cattribute_EAN_set, libigraph), igraph_error_t, (Ptr{igraph_t}, Ptr{Cchar}, igraph_integer_t, igraph_real_t), graph, name, eid, value)
end

function igraph_cattribute_EAB_set(graph, name, eid, value)
    ccall((:igraph_cattribute_EAB_set, libigraph), igraph_error_t, (Ptr{igraph_t}, Ptr{Cchar}, igraph_integer_t, igraph_bool_t), graph, name, eid, value)
end

function igraph_cattribute_EAS_set(graph, name, eid, value)
    ccall((:igraph_cattribute_EAS_set, libigraph), igraph_error_t, (Ptr{igraph_t}, Ptr{Cchar}, igraph_integer_t, Ptr{Cchar}), graph, name, eid, value)
end

function igraph_cattribute_VAN_setv(graph, name, v)
    ccall((:igraph_cattribute_VAN_setv, libigraph), igraph_error_t, (Ptr{igraph_t}, Ptr{Cchar}, Ptr{igraph_vector_t}), graph, name, v)
end

function igraph_cattribute_VAB_setv(graph, name, v)
    ccall((:igraph_cattribute_VAB_setv, libigraph), igraph_error_t, (Ptr{igraph_t}, Ptr{Cchar}, Ptr{igraph_vector_bool_t}), graph, name, v)
end

function igraph_cattribute_VAS_setv(graph, name, sv)
    ccall((:igraph_cattribute_VAS_setv, libigraph), igraph_error_t, (Ptr{igraph_t}, Ptr{Cchar}, Ptr{igraph_strvector_t}), graph, name, sv)
end

function igraph_cattribute_EAN_setv(graph, name, v)
    ccall((:igraph_cattribute_EAN_setv, libigraph), igraph_error_t, (Ptr{igraph_t}, Ptr{Cchar}, Ptr{igraph_vector_t}), graph, name, v)
end

function igraph_cattribute_EAB_setv(graph, name, v)
    ccall((:igraph_cattribute_EAB_setv, libigraph), igraph_error_t, (Ptr{igraph_t}, Ptr{Cchar}, Ptr{igraph_vector_bool_t}), graph, name, v)
end

function igraph_cattribute_EAS_setv(graph, name, sv)
    ccall((:igraph_cattribute_EAS_setv, libigraph), igraph_error_t, (Ptr{igraph_t}, Ptr{Cchar}, Ptr{igraph_strvector_t}), graph, name, sv)
end

function igraph_cattribute_remove_g(graph, name)
    ccall((:igraph_cattribute_remove_g, libigraph), Cvoid, (Ptr{igraph_t}, Ptr{Cchar}), graph, name)
end

function igraph_cattribute_remove_v(graph, name)
    ccall((:igraph_cattribute_remove_v, libigraph), Cvoid, (Ptr{igraph_t}, Ptr{Cchar}), graph, name)
end

function igraph_cattribute_remove_e(graph, name)
    ccall((:igraph_cattribute_remove_e, libigraph), Cvoid, (Ptr{igraph_t}, Ptr{Cchar}), graph, name)
end

function igraph_cattribute_remove_all(graph, g, v, e)
    ccall((:igraph_cattribute_remove_all, libigraph), Cvoid, (Ptr{igraph_t}, igraph_bool_t, igraph_bool_t, igraph_bool_t), graph, g, v, e)
end

@cenum igraph_neimode_t::UInt32 begin
    IGRAPH_OUT = 1
    IGRAPH_IN = 2
    IGRAPH_ALL = 3
end

@cenum igraph_loops_t::UInt32 begin
    IGRAPH_NO_LOOPS = 0
    IGRAPH_LOOPS = 1
    IGRAPH_LOOPS_TWICE = 1
    IGRAPH_LOOPS_ONCE = 2
end

@cenum igraph_multiple_t::UInt32 begin
    IGRAPH_NO_MULTIPLE = 0
    IGRAPH_MULTIPLE = 1
end

mutable struct igraph_lazy_adjlist_t
    graph::Ptr{igraph_t}
    length::igraph_integer_t
    adjs::Ptr{Ptr{igraph_vector_int_t}}
    mode::igraph_neimode_t
    loops::igraph_loops_t
    multiple::igraph_multiple_t
    igraph_lazy_adjlist_t() = new()
end

function igraph_i_lazy_adjlist_get_real(al, no)
    ccall((:igraph_i_lazy_adjlist_get_real, libigraph), Ptr{igraph_vector_int_t}, (Ptr{igraph_lazy_adjlist_t}, igraph_integer_t), al, no)
end

mutable struct igraph_lazy_inclist_t
    graph::Ptr{igraph_t}
    length::igraph_integer_t
    incs::Ptr{Ptr{igraph_vector_int_t}}
    mode::igraph_neimode_t
    loops::igraph_loops_t
    igraph_lazy_inclist_t() = new()
end

function igraph_i_lazy_inclist_get_real(il, no)
    ccall((:igraph_i_lazy_inclist_get_real, libigraph), Ptr{igraph_vector_int_t}, (Ptr{igraph_lazy_inclist_t}, igraph_integer_t), il, no)
end

mutable struct igraph_bitset_list_t
    stor_begin::Ptr{igraph_bitset_t}
    stor_end::Ptr{igraph_bitset_t}
    _end::Ptr{igraph_bitset_t}
    igraph_bitset_list_t() = new()
end

function igraph_bitset_list_init(v, size)
    ccall((:igraph_bitset_list_init, libigraph), igraph_error_t, (Ptr{igraph_bitset_list_t}, igraph_integer_t), v, size)
end

function igraph_bitset_list_destroy(v)
    ccall((:igraph_bitset_list_destroy, libigraph), Cvoid, (Ptr{igraph_bitset_list_t},), v)
end

function igraph_version(version_string, major, minor, subminor)
    ccall((:igraph_version, libigraph), Cvoid, (Ptr{Ptr{Cchar}}, Ptr{Cint}, Ptr{Cint}, Ptr{Cint}), version_string, major, minor, subminor)
end

function igraph_calloc(count, size)
    ccall((:igraph_calloc, libigraph), Ptr{Cvoid}, (Csize_t, Csize_t), count, size)
end

function igraph_malloc(size)
    ccall((:igraph_malloc, libigraph), Ptr{Cvoid}, (Csize_t,), size)
end

function igraph_realloc(ptr, size)
    ccall((:igraph_realloc, libigraph), Ptr{Cvoid}, (Ptr{Cvoid}, Csize_t), ptr, size)
end

function igraph_free(ptr)
    ccall((:igraph_free, libigraph), Cvoid, (Ptr{Cvoid},), ptr)
end

# typedef void igraph_error_handler_t ( const char * reason , const char * file , int line , igraph_error_t igraph_errno )
const igraph_error_handler_t = Cvoid

function igraph_error_handler_abort(arg1, arg2, arg3, arg4)
    ccall((:igraph_error_handler_abort, libigraph), Cvoid, (Ptr{Cchar}, Ptr{Cchar}, Cint, igraph_error_t), arg1, arg2, arg3, arg4)
end

function igraph_set_error_handler(new_handler)
    ccall((:igraph_set_error_handler, libigraph), Ptr{igraph_error_handler_t}, (Ptr{igraph_error_handler_t},), new_handler)
end

function igraph_strerror(igraph_errno)
    ccall((:igraph_strerror, libigraph), Ptr{Cchar}, (igraph_error_t,), igraph_errno)
end

mutable struct igraph_i_protectedPtr
    level::Cint
    ptr::Ptr{Cvoid}
    func::Ptr{Cvoid}
    igraph_i_protectedPtr() = new()
end

function IGRAPH_FINALLY_CLEAN(num)
    ccall((:IGRAPH_FINALLY_CLEAN, libigraph), Cvoid, (Cint,), num)
end

function IGRAPH_FINALLY_ENTER()
    ccall((:IGRAPH_FINALLY_ENTER, libigraph), Cvoid, ())
end

function IGRAPH_FINALLY_EXIT()
    ccall((:IGRAPH_FINALLY_EXIT, libigraph), Cvoid, ())
end

# typedef void igraph_warning_handler_t ( const char * reason , const char * file , int line )
const igraph_warning_handler_t = Cvoid

function igraph_set_warning_handler(new_handler)
    ccall((:igraph_set_warning_handler, libigraph), Ptr{igraph_warning_handler_t}, (Ptr{igraph_warning_handler_t},), new_handler)
end

# typedef void igraph_fatal_handler_t ( const char * reason , const char * file , int line )
const igraph_fatal_handler_t = Cvoid

function igraph_set_fatal_handler(new_handler)
    ccall((:igraph_set_fatal_handler, libigraph), Ptr{igraph_fatal_handler_t}, (Ptr{igraph_fatal_handler_t},), new_handler)
end

function igraph_fatal_handler_abort(arg1, arg2, arg3)
    ccall((:igraph_fatal_handler_abort, libigraph), Cvoid, (Ptr{Cchar}, Ptr{Cchar}, Cint), arg1, arg2, arg3)
end

function igraph_real_printf_aligned(width, val)
    ccall((:igraph_real_printf_aligned, libigraph), Cint, (Cint, igraph_real_t), width, val)
end

function igraph_real_printf_precise(val)
    ccall((:igraph_real_printf_precise, libigraph), Cint, (igraph_real_t,), val)
end

function igraph_real_fprintf_precise(file, val)
    ccall((:igraph_real_fprintf_precise, libigraph), Cint, (Ptr{Libc.FILE}, igraph_real_t), file, val)
end

function igraph_real_snprintf_precise(str, size, val)
    ccall((:igraph_real_snprintf_precise, libigraph), Cint, (Ptr{Cchar}, Csize_t, igraph_real_t), str, size, val)
end

function igraph_is_nan(x)
    ccall((:igraph_is_nan, libigraph), Cint, (Cdouble,), x)
end

function igraph_is_inf(x)
    ccall((:igraph_is_inf, libigraph), Cint, (Cdouble,), x)
end

function igraph_is_posinf(x)
    ccall((:igraph_is_posinf, libigraph), Cint, (Cdouble,), x)
end

function igraph_is_neginf(x)
    ccall((:igraph_is_neginf, libigraph), Cint, (Cdouble,), x)
end

function igraph_complex(x, y)
    ccall((:igraph_complex, libigraph), igraph_complex_t, (igraph_real_t, igraph_real_t), x, y)
end

function igraph_complex_polar(r, theta)
    ccall((:igraph_complex_polar, libigraph), igraph_complex_t, (igraph_real_t, igraph_real_t), r, theta)
end

function igraph_complex_eq_tol(z1, z2, tol)
    ccall((:igraph_complex_eq_tol, libigraph), igraph_bool_t, (igraph_complex_t, igraph_complex_t, igraph_real_t), z1, z2, tol)
end

function igraph_complex_almost_equals(z1, z2, eps)
    ccall((:igraph_complex_almost_equals, libigraph), igraph_bool_t, (igraph_complex_t, igraph_complex_t, igraph_real_t), z1, z2, eps)
end

function igraph_complex_arg(z)
    ccall((:igraph_complex_arg, libigraph), igraph_real_t, (igraph_complex_t,), z)
end

function igraph_complex_abs(z)
    ccall((:igraph_complex_abs, libigraph), igraph_real_t, (igraph_complex_t,), z)
end

function igraph_complex_logabs(z)
    ccall((:igraph_complex_logabs, libigraph), igraph_real_t, (igraph_complex_t,), z)
end

function igraph_complex_add_real(z, x)
    ccall((:igraph_complex_add_real, libigraph), igraph_complex_t, (igraph_complex_t, igraph_real_t), z, x)
end

function igraph_complex_add_imag(z, y)
    ccall((:igraph_complex_add_imag, libigraph), igraph_complex_t, (igraph_complex_t, igraph_real_t), z, y)
end

function igraph_complex_sub_real(z, x)
    ccall((:igraph_complex_sub_real, libigraph), igraph_complex_t, (igraph_complex_t, igraph_real_t), z, x)
end

function igraph_complex_sub_imag(z, y)
    ccall((:igraph_complex_sub_imag, libigraph), igraph_complex_t, (igraph_complex_t, igraph_real_t), z, y)
end

function igraph_complex_mul_real(z, x)
    ccall((:igraph_complex_mul_real, libigraph), igraph_complex_t, (igraph_complex_t, igraph_real_t), z, x)
end

function igraph_complex_mul_imag(z, y)
    ccall((:igraph_complex_mul_imag, libigraph), igraph_complex_t, (igraph_complex_t, igraph_real_t), z, y)
end

function igraph_complex_div_real(z, x)
    ccall((:igraph_complex_div_real, libigraph), igraph_complex_t, (igraph_complex_t, igraph_real_t), z, x)
end

function igraph_complex_div_imag(z, y)
    ccall((:igraph_complex_div_imag, libigraph), igraph_complex_t, (igraph_complex_t, igraph_real_t), z, y)
end

function igraph_complex_conj(z)
    ccall((:igraph_complex_conj, libigraph), igraph_complex_t, (igraph_complex_t,), z)
end

function igraph_complex_neg(z)
    ccall((:igraph_complex_neg, libigraph), igraph_complex_t, (igraph_complex_t,), z)
end

function igraph_complex_inv(z)
    ccall((:igraph_complex_inv, libigraph), igraph_complex_t, (igraph_complex_t,), z)
end

function igraph_complex_sqrt(z)
    ccall((:igraph_complex_sqrt, libigraph), igraph_complex_t, (igraph_complex_t,), z)
end

function igraph_complex_sqrt_real(x)
    ccall((:igraph_complex_sqrt_real, libigraph), igraph_complex_t, (igraph_real_t,), x)
end

function igraph_complex_exp(z)
    ccall((:igraph_complex_exp, libigraph), igraph_complex_t, (igraph_complex_t,), z)
end

function igraph_complex_pow(z1, z2)
    ccall((:igraph_complex_pow, libigraph), igraph_complex_t, (igraph_complex_t, igraph_complex_t), z1, z2)
end

function igraph_complex_pow_real(z, x)
    ccall((:igraph_complex_pow_real, libigraph), igraph_complex_t, (igraph_complex_t, igraph_real_t), z, x)
end

function igraph_complex_log(z)
    ccall((:igraph_complex_log, libigraph), igraph_complex_t, (igraph_complex_t,), z)
end

function igraph_complex_log10(z)
    ccall((:igraph_complex_log10, libigraph), igraph_complex_t, (igraph_complex_t,), z)
end

function igraph_complex_log_b(z, b)
    ccall((:igraph_complex_log_b, libigraph), igraph_complex_t, (igraph_complex_t, igraph_complex_t), z, b)
end

function igraph_complex_sin(z)
    ccall((:igraph_complex_sin, libigraph), igraph_complex_t, (igraph_complex_t,), z)
end

function igraph_complex_cos(z)
    ccall((:igraph_complex_cos, libigraph), igraph_complex_t, (igraph_complex_t,), z)
end

function igraph_complex_tan(z)
    ccall((:igraph_complex_tan, libigraph), igraph_complex_t, (igraph_complex_t,), z)
end

function igraph_complex_sec(z)
    ccall((:igraph_complex_sec, libigraph), igraph_complex_t, (igraph_complex_t,), z)
end

function igraph_complex_csc(z)
    ccall((:igraph_complex_csc, libigraph), igraph_complex_t, (igraph_complex_t,), z)
end

function igraph_complex_cot(z)
    ccall((:igraph_complex_cot, libigraph), igraph_complex_t, (igraph_complex_t,), z)
end

function igraph_complex_printf_aligned(width, val)
    ccall((:igraph_complex_printf_aligned, libigraph), Cint, (Cint, igraph_complex_t), width, val)
end

@cenum igraph_i_directed_t::UInt32 begin
    IGRAPH_UNDIRECTED = 0
    IGRAPH_DIRECTED = 1
end

@cenum igraph_order_t::UInt32 begin
    IGRAPH_ASCENDING = 0
    IGRAPH_DESCENDING = 1
end

@cenum igraph_optimal_t::UInt32 begin
    IGRAPH_MINIMUM = 0
    IGRAPH_MAXIMUM = 1
end

@cenum igraph_connectedness_t::UInt32 begin
    IGRAPH_WEAK = 1
    IGRAPH_STRONG = 2
end

@cenum igraph_reciprocity_t::UInt32 begin
    IGRAPH_RECIPROCITY_DEFAULT = 0
    IGRAPH_RECIPROCITY_RATIO = 1
end

@cenum igraph_adjacency_t::UInt32 begin
    IGRAPH_ADJ_DIRECTED = 0
    IGRAPH_ADJ_UNDIRECTED = 1
    IGRAPH_ADJ_UPPER = 2
    IGRAPH_ADJ_LOWER = 3
    IGRAPH_ADJ_MIN = 4
    IGRAPH_ADJ_PLUS = 5
    IGRAPH_ADJ_MAX = 6
end

@cenum igraph_star_mode_t::UInt32 begin
    IGRAPH_STAR_OUT = 0
    IGRAPH_STAR_IN = 1
    IGRAPH_STAR_UNDIRECTED = 2
    IGRAPH_STAR_MUTUAL = 3
end

@cenum igraph_wheel_mode_t::UInt32 begin
    IGRAPH_WHEEL_OUT = 0
    IGRAPH_WHEEL_IN = 1
    IGRAPH_WHEEL_UNDIRECTED = 2
    IGRAPH_WHEEL_MUTUAL = 3
end

@cenum igraph_tree_mode_t::UInt32 begin
    IGRAPH_TREE_OUT = 0
    IGRAPH_TREE_IN = 1
    IGRAPH_TREE_UNDIRECTED = 2
end

@cenum igraph_erdos_renyi_t::UInt32 begin
    IGRAPH_ERDOS_RENYI_GNP = 0
    IGRAPH_ERDOS_RENYI_GNM = 1
end

@cenum igraph_get_adjacency_t::UInt32 begin
    IGRAPH_GET_ADJACENCY_UPPER = 0
    IGRAPH_GET_ADJACENCY_LOWER = 1
    IGRAPH_GET_ADJACENCY_BOTH = 2
end

@cenum igraph_degseq_t::UInt32 begin
    IGRAPH_DEGSEQ_CONFIGURATION = 0
    IGRAPH_DEGSEQ_VL = 1
    IGRAPH_DEGSEQ_FAST_HEUR_SIMPLE = 2
    IGRAPH_DEGSEQ_CONFIGURATION_SIMPLE = 3
    IGRAPH_DEGSEQ_EDGE_SWITCHING_SIMPLE = 4
    IGRAPH_DEGSEQ_SIMPLE = 0
    IGRAPH_DEGSEQ_SIMPLE_NO_MULTIPLE = 2
    IGRAPH_DEGSEQ_SIMPLE_NO_MULTIPLE_UNIFORM = 3
end

@cenum igraph_realize_degseq_t::UInt32 begin
    IGRAPH_REALIZE_DEGSEQ_SMALLEST = 0
    IGRAPH_REALIZE_DEGSEQ_LARGEST = 1
    IGRAPH_REALIZE_DEGSEQ_INDEX = 2
end

@cenum igraph_random_tree_t::UInt32 begin
    IGRAPH_RANDOM_TREE_PRUFER = 0
    IGRAPH_RANDOM_TREE_LERW = 1
end

@cenum igraph_fileformat_type_t::UInt32 begin
    IGRAPH_FILEFORMAT_EDGELIST = 0
    IGRAPH_FILEFORMAT_NCOL = 1
    IGRAPH_FILEFORMAT_PAJEK = 2
    IGRAPH_FILEFORMAT_LGL = 3
    IGRAPH_FILEFORMAT_GRAPHML = 4
end

@cenum igraph_rewiring_t::UInt32 begin
    IGRAPH_REWIRING_SIMPLE = 0
    IGRAPH_REWIRING_SIMPLE_LOOPS = 1
end

@cenum igraph_to_directed_t::UInt32 begin
    IGRAPH_TO_DIRECTED_ARBITRARY = 0
    IGRAPH_TO_DIRECTED_MUTUAL = 1
    IGRAPH_TO_DIRECTED_RANDOM = 2
    IGRAPH_TO_DIRECTED_ACYCLIC = 3
end

@cenum igraph_to_undirected_t::UInt32 begin
    IGRAPH_TO_UNDIRECTED_EACH = 0
    IGRAPH_TO_UNDIRECTED_COLLAPSE = 1
    IGRAPH_TO_UNDIRECTED_MUTUAL = 2
end

@cenum igraph_vconn_nei_t::UInt32 begin
    IGRAPH_VCONN_NEI_ERROR = 0
    IGRAPH_VCONN_NEI_NUMBER_OF_NODES = 1
    IGRAPH_VCONN_NEI_IGNORE = 2
    IGRAPH_VCONN_NEI_NEGATIVE = 3
end

@cenum igraph_spincomm_update_t::UInt32 begin
    IGRAPH_SPINCOMM_UPDATE_SIMPLE = 0
    IGRAPH_SPINCOMM_UPDATE_CONFIG = 1
end

@cenum igraph_lazy_adlist_simplify_t::UInt32 begin
    IGRAPH_DONT_SIMPLIFY = 0
    IGRAPH_SIMPLIFY = 1
end

@cenum igraph_transitivity_mode_t::UInt32 begin
    IGRAPH_TRANSITIVITY_NAN = 0
    IGRAPH_TRANSITIVITY_ZERO = 1
end

@cenum igraph_spinglass_implementation_t::UInt32 begin
    IGRAPH_SPINCOMM_IMP_ORIG = 0
    IGRAPH_SPINCOMM_IMP_NEG = 1
end

@cenum igraph_community_comparison_t::UInt32 begin
    IGRAPH_COMMCMP_VI = 0
    IGRAPH_COMMCMP_NMI = 1
    IGRAPH_COMMCMP_SPLIT_JOIN = 2
    IGRAPH_COMMCMP_RAND = 3
    IGRAPH_COMMCMP_ADJUSTED_RAND = 4
end

@cenum igraph_add_weights_t::UInt32 begin
    IGRAPH_ADD_WEIGHTS_NO = 0
    IGRAPH_ADD_WEIGHTS_YES = 1
    IGRAPH_ADD_WEIGHTS_IF_PRESENT = 2
end

@cenum igraph_barabasi_algorithm_t::UInt32 begin
    IGRAPH_BARABASI_BAG = 0
    IGRAPH_BARABASI_PSUMTREE = 1
    IGRAPH_BARABASI_PSUMTREE_MULTIPLE = 2
end

@cenum igraph_fas_algorithm_t::UInt32 begin
    IGRAPH_FAS_EXACT_IP = 0
    IGRAPH_FAS_APPROX_EADES = 1
    IGRAPH_FAS_EXACT_IP_CG = 2
    IGRAPH_FAS_EXACT_IP_TI = 3
end

@cenum igraph_fvs_algorithm_t::UInt32 begin
    IGRAPH_FVS_EXACT_IP = 0
end

@cenum igraph_subgraph_implementation_t::UInt32 begin
    IGRAPH_SUBGRAPH_AUTO = 0
    IGRAPH_SUBGRAPH_COPY_AND_DELETE = 1
    IGRAPH_SUBGRAPH_CREATE_FROM_SCRATCH = 2
end

@cenum igraph_imitate_algorithm_t::UInt32 begin
    IGRAPH_IMITATE_AUGMENTED = 0
    IGRAPH_IMITATE_BLIND = 1
    IGRAPH_IMITATE_CONTRACTED = 2
end

@cenum igraph_layout_grid_t::UInt32 begin
    IGRAPH_LAYOUT_GRID = 0
    IGRAPH_LAYOUT_NOGRID = 1
    IGRAPH_LAYOUT_AUTOGRID = 2
end

@cenum igraph_random_walk_stuck_t::UInt32 begin
    IGRAPH_RANDOM_WALK_STUCK_ERROR = 0
    IGRAPH_RANDOM_WALK_STUCK_RETURN = 1
end

@cenum igraph_voronoi_tiebreaker_t::UInt32 begin
    IGRAPH_VORONOI_FIRST = 0
    IGRAPH_VORONOI_LAST = 1
    IGRAPH_VORONOI_RANDOM = 2
end

@cenum igraph_chung_lu_t::UInt32 begin
    IGRAPH_CHUNG_LU_ORIGINAL = 0
    IGRAPH_CHUNG_LU_MAXENT = 1
    IGRAPH_CHUNG_LU_NR = 2
end

@cenum igraph_matrix_storage_t::UInt32 begin
    IGRAPH_ROW_MAJOR = 0
    IGRAPH_COLUMN_MAJOR = 1
end

function igraph_vector_init_array(v, data, length)
    ccall((:igraph_vector_init_array, libigraph), igraph_error_t, (Ptr{igraph_vector_t}, Ptr{igraph_real_t}, igraph_integer_t), v, data, length)
end

function igraph_vector_init_copy(to, from)
    ccall((:igraph_vector_init_copy, libigraph), igraph_error_t, (Ptr{igraph_vector_t}, Ptr{igraph_vector_t}), to, from)
end

function igraph_vector_init_range(v, start, _end)
    ccall((:igraph_vector_init_range, libigraph), igraph_error_t, (Ptr{igraph_vector_t}, igraph_real_t, igraph_real_t), v, start, _end)
end

function igraph_vector_init_seq(v, from, to)
    ccall((:igraph_vector_init_seq, libigraph), igraph_error_t, (Ptr{igraph_vector_t}, igraph_real_t, igraph_real_t), v, from, to)
end

function igraph_vector_copy(to, from)
    ccall((:igraph_vector_copy, libigraph), igraph_error_t, (Ptr{igraph_vector_t}, Ptr{igraph_vector_t}), to, from)
end

function igraph_vector_capacity(v)
    ccall((:igraph_vector_capacity, libigraph), igraph_integer_t, (Ptr{igraph_vector_t},), v)
end

function igraph_vector_e(v, pos)
    ccall((:igraph_vector_e, libigraph), igraph_real_t, (Ptr{igraph_vector_t}, igraph_integer_t), v, pos)
end

function igraph_vector_e_ptr(v, pos)
    ccall((:igraph_vector_e_ptr, libigraph), Ptr{igraph_real_t}, (Ptr{igraph_vector_t}, igraph_integer_t), v, pos)
end

function igraph_vector_get(v, pos)
    ccall((:igraph_vector_get, libigraph), igraph_real_t, (Ptr{igraph_vector_t}, igraph_integer_t), v, pos)
end

function igraph_vector_get_ptr(v, pos)
    ccall((:igraph_vector_get_ptr, libigraph), Ptr{igraph_real_t}, (Ptr{igraph_vector_t}, igraph_integer_t), v, pos)
end

function igraph_vector_set(v, pos, value)
    ccall((:igraph_vector_set, libigraph), Cvoid, (Ptr{igraph_vector_t}, igraph_integer_t, igraph_real_t), v, pos, value)
end

function igraph_vector_tail(v)
    ccall((:igraph_vector_tail, libigraph), igraph_real_t, (Ptr{igraph_vector_t},), v)
end

function igraph_vector_null(v)
    ccall((:igraph_vector_null, libigraph), Cvoid, (Ptr{igraph_vector_t},), v)
end

function igraph_vector_fill(v, e)
    ccall((:igraph_vector_fill, libigraph), Cvoid, (Ptr{igraph_vector_t}, igraph_real_t), v, e)
end

function igraph_vector_range(v, start, _end)
    ccall((:igraph_vector_range, libigraph), igraph_error_t, (Ptr{igraph_vector_t}, igraph_real_t, igraph_real_t), v, start, _end)
end

function igraph_vector_view(v, data, length)
    ccall((:igraph_vector_view, libigraph), Ptr{igraph_vector_t}, (Ptr{igraph_vector_t}, Ptr{igraph_real_t}, igraph_integer_t), v, data, length)
end

function igraph_vector_copy_to(v, to)
    ccall((:igraph_vector_copy_to, libigraph), Cvoid, (Ptr{igraph_vector_t}, Ptr{igraph_real_t}), v, to)
end

function igraph_vector_update(to, from)
    ccall((:igraph_vector_update, libigraph), igraph_error_t, (Ptr{igraph_vector_t}, Ptr{igraph_vector_t}), to, from)
end

function igraph_vector_append(to, from)
    ccall((:igraph_vector_append, libigraph), igraph_error_t, (Ptr{igraph_vector_t}, Ptr{igraph_vector_t}), to, from)
end

function igraph_vector_swap(v1, v2)
    ccall((:igraph_vector_swap, libigraph), igraph_error_t, (Ptr{igraph_vector_t}, Ptr{igraph_vector_t}), v1, v2)
end

function igraph_vector_swap_elements(v, i, j)
    ccall((:igraph_vector_swap_elements, libigraph), igraph_error_t, (Ptr{igraph_vector_t}, igraph_integer_t, igraph_integer_t), v, i, j)
end

function igraph_vector_reverse(v)
    ccall((:igraph_vector_reverse, libigraph), igraph_error_t, (Ptr{igraph_vector_t},), v)
end

function igraph_vector_reverse_section(v, from, to)
    ccall((:igraph_vector_reverse_section, libigraph), Cvoid, (Ptr{igraph_vector_t}, igraph_integer_t, igraph_integer_t), v, from, to)
end

function igraph_vector_rotate_left(v, n)
    ccall((:igraph_vector_rotate_left, libigraph), Cvoid, (Ptr{igraph_vector_t}, igraph_integer_t), v, n)
end

function igraph_vector_permute(v, ind)
    ccall((:igraph_vector_permute, libigraph), igraph_error_t, (Ptr{igraph_vector_t}, Ptr{igraph_vector_int_t}), v, ind)
end

function igraph_vector_shuffle(v)
    ccall((:igraph_vector_shuffle, libigraph), igraph_error_t, (Ptr{igraph_vector_t},), v)
end

function igraph_vector_add_constant(v, plus)
    ccall((:igraph_vector_add_constant, libigraph), Cvoid, (Ptr{igraph_vector_t}, igraph_real_t), v, plus)
end

function igraph_vector_scale(v, by)
    ccall((:igraph_vector_scale, libigraph), Cvoid, (Ptr{igraph_vector_t}, igraph_real_t), v, by)
end

function igraph_vector_add(v1, v2)
    ccall((:igraph_vector_add, libigraph), igraph_error_t, (Ptr{igraph_vector_t}, Ptr{igraph_vector_t}), v1, v2)
end

function igraph_vector_sub(v1, v2)
    ccall((:igraph_vector_sub, libigraph), igraph_error_t, (Ptr{igraph_vector_t}, Ptr{igraph_vector_t}), v1, v2)
end

function igraph_vector_mul(v1, v2)
    ccall((:igraph_vector_mul, libigraph), igraph_error_t, (Ptr{igraph_vector_t}, Ptr{igraph_vector_t}), v1, v2)
end

function igraph_vector_div(v1, v2)
    ccall((:igraph_vector_div, libigraph), igraph_error_t, (Ptr{igraph_vector_t}, Ptr{igraph_vector_t}), v1, v2)
end

function igraph_vector_cumsum(to, from)
    ccall((:igraph_vector_cumsum, libigraph), igraph_error_t, (Ptr{igraph_vector_t}, Ptr{igraph_vector_t}), to, from)
end

function igraph_vector_abs(v)
    ccall((:igraph_vector_abs, libigraph), igraph_error_t, (Ptr{igraph_vector_t},), v)
end

function igraph_vector_all_e(lhs, rhs)
    ccall((:igraph_vector_all_e, libigraph), igraph_bool_t, (Ptr{igraph_vector_t}, Ptr{igraph_vector_t}), lhs, rhs)
end

function igraph_vector_all_l(lhs, rhs)
    ccall((:igraph_vector_all_l, libigraph), igraph_bool_t, (Ptr{igraph_vector_t}, Ptr{igraph_vector_t}), lhs, rhs)
end

function igraph_vector_all_g(lhs, rhs)
    ccall((:igraph_vector_all_g, libigraph), igraph_bool_t, (Ptr{igraph_vector_t}, Ptr{igraph_vector_t}), lhs, rhs)
end

function igraph_vector_all_le(lhs, rhs)
    ccall((:igraph_vector_all_le, libigraph), igraph_bool_t, (Ptr{igraph_vector_t}, Ptr{igraph_vector_t}), lhs, rhs)
end

function igraph_vector_all_ge(lhs, rhs)
    ccall((:igraph_vector_all_ge, libigraph), igraph_bool_t, (Ptr{igraph_vector_t}, Ptr{igraph_vector_t}), lhs, rhs)
end

function igraph_vector_lex_cmp(lhs, rhs)
    ccall((:igraph_vector_lex_cmp, libigraph), Cint, (Ptr{igraph_vector_t}, Ptr{igraph_vector_t}), lhs, rhs)
end

function igraph_vector_colex_cmp(lhs, rhs)
    ccall((:igraph_vector_colex_cmp, libigraph), Cint, (Ptr{igraph_vector_t}, Ptr{igraph_vector_t}), lhs, rhs)
end

function igraph_vector_lex_cmp_untyped(lhs, rhs)
    ccall((:igraph_vector_lex_cmp_untyped, libigraph), Cint, (Ptr{Cvoid}, Ptr{Cvoid}), lhs, rhs)
end

function igraph_vector_colex_cmp_untyped(lhs, rhs)
    ccall((:igraph_vector_colex_cmp_untyped, libigraph), Cint, (Ptr{Cvoid}, Ptr{Cvoid}), lhs, rhs)
end

function igraph_vector_min(v)
    ccall((:igraph_vector_min, libigraph), igraph_real_t, (Ptr{igraph_vector_t},), v)
end

function igraph_vector_max(v)
    ccall((:igraph_vector_max, libigraph), igraph_real_t, (Ptr{igraph_vector_t},), v)
end

function igraph_vector_which_min(v)
    ccall((:igraph_vector_which_min, libigraph), igraph_integer_t, (Ptr{igraph_vector_t},), v)
end

function igraph_vector_which_max(v)
    ccall((:igraph_vector_which_max, libigraph), igraph_integer_t, (Ptr{igraph_vector_t},), v)
end

function igraph_vector_minmax(v, min, max)
    ccall((:igraph_vector_minmax, libigraph), Cvoid, (Ptr{igraph_vector_t}, Ptr{igraph_real_t}, Ptr{igraph_real_t}), v, min, max)
end

function igraph_vector_which_minmax(v, which_min, which_max)
    ccall((:igraph_vector_which_minmax, libigraph), Cvoid, (Ptr{igraph_vector_t}, Ptr{igraph_integer_t}, Ptr{igraph_integer_t}), v, which_min, which_max)
end

function igraph_vector_empty(v)
    ccall((:igraph_vector_empty, libigraph), igraph_bool_t, (Ptr{igraph_vector_t},), v)
end

function igraph_vector_size(v)
    ccall((:igraph_vector_size, libigraph), igraph_integer_t, (Ptr{igraph_vector_t},), v)
end

function igraph_vector_isnull(v)
    ccall((:igraph_vector_isnull, libigraph), igraph_bool_t, (Ptr{igraph_vector_t},), v)
end

function igraph_vector_sum(v)
    ccall((:igraph_vector_sum, libigraph), igraph_real_t, (Ptr{igraph_vector_t},), v)
end

function igraph_vector_sumsq(v)
    ccall((:igraph_vector_sumsq, libigraph), igraph_real_t, (Ptr{igraph_vector_t},), v)
end

function igraph_vector_prod(v)
    ccall((:igraph_vector_prod, libigraph), igraph_real_t, (Ptr{igraph_vector_t},), v)
end

function igraph_vector_isininterval(v, low, high)
    ccall((:igraph_vector_isininterval, libigraph), igraph_bool_t, (Ptr{igraph_vector_t}, igraph_real_t, igraph_real_t), v, low, high)
end

function igraph_vector_any_smaller(v, limit)
    ccall((:igraph_vector_any_smaller, libigraph), igraph_bool_t, (Ptr{igraph_vector_t}, igraph_real_t), v, limit)
end

function igraph_vector_is_equal(lhs, rhs)
    ccall((:igraph_vector_is_equal, libigraph), igraph_bool_t, (Ptr{igraph_vector_t}, Ptr{igraph_vector_t}), lhs, rhs)
end

function igraph_vector_maxdifference(m1, m2)
    ccall((:igraph_vector_maxdifference, libigraph), igraph_real_t, (Ptr{igraph_vector_t}, Ptr{igraph_vector_t}), m1, m2)
end

function igraph_vector_contains(v, e)
    ccall((:igraph_vector_contains, libigraph), igraph_bool_t, (Ptr{igraph_vector_t}, igraph_real_t), v, e)
end

function igraph_vector_search(v, from, what, pos)
    ccall((:igraph_vector_search, libigraph), igraph_bool_t, (Ptr{igraph_vector_t}, igraph_integer_t, igraph_real_t, Ptr{igraph_integer_t}), v, from, what, pos)
end

function igraph_vector_binsearch_slice(v, what, pos, start, _end)
    ccall((:igraph_vector_binsearch_slice, libigraph), igraph_bool_t, (Ptr{igraph_vector_t}, igraph_real_t, Ptr{igraph_integer_t}, igraph_integer_t, igraph_integer_t), v, what, pos, start, _end)
end

function igraph_vector_binsearch(v, what, pos)
    ccall((:igraph_vector_binsearch, libigraph), igraph_bool_t, (Ptr{igraph_vector_t}, igraph_real_t, Ptr{igraph_integer_t}), v, what, pos)
end

function igraph_vector_contains_sorted(v, what)
    ccall((:igraph_vector_contains_sorted, libigraph), igraph_bool_t, (Ptr{igraph_vector_t}, igraph_real_t), v, what)
end

function igraph_vector_binsearch2(v, what)
    ccall((:igraph_vector_binsearch2, libigraph), igraph_bool_t, (Ptr{igraph_vector_t}, igraph_real_t), v, what)
end

function igraph_vector_clear(v)
    ccall((:igraph_vector_clear, libigraph), Cvoid, (Ptr{igraph_vector_t},), v)
end

function igraph_vector_resize(v, new_size)
    ccall((:igraph_vector_resize, libigraph), igraph_error_t, (Ptr{igraph_vector_t}, igraph_integer_t), v, new_size)
end

function igraph_vector_resize_min(v)
    ccall((:igraph_vector_resize_min, libigraph), Cvoid, (Ptr{igraph_vector_t},), v)
end

function igraph_vector_reserve(v, capacity)
    ccall((:igraph_vector_reserve, libigraph), igraph_error_t, (Ptr{igraph_vector_t}, igraph_integer_t), v, capacity)
end

function igraph_vector_push_back(v, e)
    ccall((:igraph_vector_push_back, libigraph), igraph_error_t, (Ptr{igraph_vector_t}, igraph_real_t), v, e)
end

function igraph_vector_pop_back(v)
    ccall((:igraph_vector_pop_back, libigraph), igraph_real_t, (Ptr{igraph_vector_t},), v)
end

function igraph_vector_insert(v, pos, value)
    ccall((:igraph_vector_insert, libigraph), igraph_error_t, (Ptr{igraph_vector_t}, igraph_integer_t, igraph_real_t), v, pos, value)
end

function igraph_vector_remove(v, elem)
    ccall((:igraph_vector_remove, libigraph), Cvoid, (Ptr{igraph_vector_t}, igraph_integer_t), v, elem)
end

function igraph_vector_remove_fast(v, elem)
    ccall((:igraph_vector_remove_fast, libigraph), Cvoid, (Ptr{igraph_vector_t}, igraph_integer_t), v, elem)
end

function igraph_vector_remove_section(v, from, to)
    ccall((:igraph_vector_remove_section, libigraph), Cvoid, (Ptr{igraph_vector_t}, igraph_integer_t, igraph_integer_t), v, from, to)
end

function igraph_vector_sort(v)
    ccall((:igraph_vector_sort, libigraph), Cvoid, (Ptr{igraph_vector_t},), v)
end

function igraph_vector_reverse_sort(v)
    ccall((:igraph_vector_reverse_sort, libigraph), Cvoid, (Ptr{igraph_vector_t},), v)
end

function igraph_vector_sort_ind(v, inds, order)
    ccall((:igraph_vector_sort_ind, libigraph), igraph_error_t, (Ptr{igraph_vector_t}, Ptr{igraph_vector_int_t}, igraph_order_t), v, inds, order)
end

function igraph_vector_qsort_ind(v, inds, order)
    ccall((:igraph_vector_qsort_ind, libigraph), igraph_error_t, (Ptr{igraph_vector_t}, Ptr{igraph_vector_int_t}, igraph_order_t), v, inds, order)
end

function igraph_vector_print(v)
    ccall((:igraph_vector_print, libigraph), igraph_error_t, (Ptr{igraph_vector_t},), v)
end

function igraph_vector_fprint(v, file)
    ccall((:igraph_vector_fprint, libigraph), igraph_error_t, (Ptr{igraph_vector_t}, Ptr{Libc.FILE}), v, file)
end

function igraph_vector_printf(v, format)
    ccall((:igraph_vector_printf, libigraph), igraph_error_t, (Ptr{igraph_vector_t}, Ptr{Cchar}), v, format)
end

function igraph_vector_move_interval(v, _begin, _end, to)
    ccall((:igraph_vector_move_interval, libigraph), igraph_error_t, (Ptr{igraph_vector_t}, igraph_integer_t, igraph_integer_t, igraph_integer_t), v, _begin, _end, to)
end

function igraph_vector_move_interval2(v, _begin, _end, to)
    ccall((:igraph_vector_move_interval2, libigraph), igraph_error_t, (Ptr{igraph_vector_t}, igraph_integer_t, igraph_integer_t, igraph_integer_t), v, _begin, _end, to)
end

function igraph_vector_filter_smaller(v, elem)
    ccall((:igraph_vector_filter_smaller, libigraph), igraph_error_t, (Ptr{igraph_vector_t}, igraph_real_t), v, elem)
end

function igraph_vector_get_interval(v, res, from, to)
    ccall((:igraph_vector_get_interval, libigraph), igraph_error_t, (Ptr{igraph_vector_t}, Ptr{igraph_vector_t}, igraph_integer_t, igraph_integer_t), v, res, from, to)
end

function igraph_vector_difference_sorted(v1, v2, result)
    ccall((:igraph_vector_difference_sorted, libigraph), igraph_error_t, (Ptr{igraph_vector_t}, Ptr{igraph_vector_t}, Ptr{igraph_vector_t}), v1, v2, result)
end

function igraph_vector_intersect_sorted(v1, v2, result)
    ccall((:igraph_vector_intersect_sorted, libigraph), igraph_error_t, (Ptr{igraph_vector_t}, Ptr{igraph_vector_t}, Ptr{igraph_vector_t}), v1, v2, result)
end

function igraph_vector_intersection_size_sorted(v1, v2)
    ccall((:igraph_vector_intersection_size_sorted, libigraph), igraph_integer_t, (Ptr{igraph_vector_t}, Ptr{igraph_vector_t}), v1, v2)
end

function igraph_vector_index(v, newv, idx)
    ccall((:igraph_vector_index, libigraph), igraph_error_t, (Ptr{igraph_vector_t}, Ptr{igraph_vector_t}, Ptr{igraph_vector_int_t}), v, newv, idx)
end

function igraph_vector_index_int(v, idx)
    ccall((:igraph_vector_index_int, libigraph), igraph_error_t, (Ptr{igraph_vector_t}, Ptr{igraph_vector_int_t}), v, idx)
end

function igraph_vector_char_init_array(v, data, length)
    ccall((:igraph_vector_char_init_array, libigraph), igraph_error_t, (Ptr{igraph_vector_char_t}, Ptr{Cchar}, igraph_integer_t), v, data, length)
end

function igraph_vector_char_init_copy(to, from)
    ccall((:igraph_vector_char_init_copy, libigraph), igraph_error_t, (Ptr{igraph_vector_char_t}, Ptr{igraph_vector_char_t}), to, from)
end

function igraph_vector_char_init_range(v, start, _end)
    ccall((:igraph_vector_char_init_range, libigraph), igraph_error_t, (Ptr{igraph_vector_char_t}, Cchar, Cchar), v, start, _end)
end

function igraph_vector_char_init_seq(v, from, to)
    ccall((:igraph_vector_char_init_seq, libigraph), igraph_error_t, (Ptr{igraph_vector_char_t}, Cchar, Cchar), v, from, to)
end

function igraph_vector_char_copy(to, from)
    ccall((:igraph_vector_char_copy, libigraph), igraph_error_t, (Ptr{igraph_vector_char_t}, Ptr{igraph_vector_char_t}), to, from)
end

function igraph_vector_char_capacity(v)
    ccall((:igraph_vector_char_capacity, libigraph), igraph_integer_t, (Ptr{igraph_vector_char_t},), v)
end

function igraph_vector_char_e(v, pos)
    ccall((:igraph_vector_char_e, libigraph), Cchar, (Ptr{igraph_vector_char_t}, igraph_integer_t), v, pos)
end

function igraph_vector_char_e_ptr(v, pos)
    ccall((:igraph_vector_char_e_ptr, libigraph), Ptr{Cchar}, (Ptr{igraph_vector_char_t}, igraph_integer_t), v, pos)
end

function igraph_vector_char_get(v, pos)
    ccall((:igraph_vector_char_get, libigraph), Cchar, (Ptr{igraph_vector_char_t}, igraph_integer_t), v, pos)
end

function igraph_vector_char_get_ptr(v, pos)
    ccall((:igraph_vector_char_get_ptr, libigraph), Ptr{Cchar}, (Ptr{igraph_vector_char_t}, igraph_integer_t), v, pos)
end

function igraph_vector_char_set(v, pos, value)
    ccall((:igraph_vector_char_set, libigraph), Cvoid, (Ptr{igraph_vector_char_t}, igraph_integer_t, Cchar), v, pos, value)
end

function igraph_vector_char_tail(v)
    ccall((:igraph_vector_char_tail, libigraph), Cchar, (Ptr{igraph_vector_char_t},), v)
end

function igraph_vector_char_null(v)
    ccall((:igraph_vector_char_null, libigraph), Cvoid, (Ptr{igraph_vector_char_t},), v)
end

function igraph_vector_char_fill(v, e)
    ccall((:igraph_vector_char_fill, libigraph), Cvoid, (Ptr{igraph_vector_char_t}, Cchar), v, e)
end

function igraph_vector_char_range(v, start, _end)
    ccall((:igraph_vector_char_range, libigraph), igraph_error_t, (Ptr{igraph_vector_char_t}, Cchar, Cchar), v, start, _end)
end

function igraph_vector_char_view(v, data, length)
    ccall((:igraph_vector_char_view, libigraph), Ptr{igraph_vector_char_t}, (Ptr{igraph_vector_char_t}, Ptr{Cchar}, igraph_integer_t), v, data, length)
end

function igraph_vector_char_copy_to(v, to)
    ccall((:igraph_vector_char_copy_to, libigraph), Cvoid, (Ptr{igraph_vector_char_t}, Ptr{Cchar}), v, to)
end

function igraph_vector_char_update(to, from)
    ccall((:igraph_vector_char_update, libigraph), igraph_error_t, (Ptr{igraph_vector_char_t}, Ptr{igraph_vector_char_t}), to, from)
end

function igraph_vector_char_append(to, from)
    ccall((:igraph_vector_char_append, libigraph), igraph_error_t, (Ptr{igraph_vector_char_t}, Ptr{igraph_vector_char_t}), to, from)
end

function igraph_vector_char_swap(v1, v2)
    ccall((:igraph_vector_char_swap, libigraph), igraph_error_t, (Ptr{igraph_vector_char_t}, Ptr{igraph_vector_char_t}), v1, v2)
end

function igraph_vector_char_swap_elements(v, i, j)
    ccall((:igraph_vector_char_swap_elements, libigraph), igraph_error_t, (Ptr{igraph_vector_char_t}, igraph_integer_t, igraph_integer_t), v, i, j)
end

function igraph_vector_char_reverse(v)
    ccall((:igraph_vector_char_reverse, libigraph), igraph_error_t, (Ptr{igraph_vector_char_t},), v)
end

function igraph_vector_char_reverse_section(v, from, to)
    ccall((:igraph_vector_char_reverse_section, libigraph), Cvoid, (Ptr{igraph_vector_char_t}, igraph_integer_t, igraph_integer_t), v, from, to)
end

function igraph_vector_char_rotate_left(v, n)
    ccall((:igraph_vector_char_rotate_left, libigraph), Cvoid, (Ptr{igraph_vector_char_t}, igraph_integer_t), v, n)
end

function igraph_vector_char_permute(v, ind)
    ccall((:igraph_vector_char_permute, libigraph), igraph_error_t, (Ptr{igraph_vector_char_t}, Ptr{igraph_vector_int_t}), v, ind)
end

function igraph_vector_char_shuffle(v)
    ccall((:igraph_vector_char_shuffle, libigraph), igraph_error_t, (Ptr{igraph_vector_char_t},), v)
end

function igraph_vector_char_add_constant(v, plus)
    ccall((:igraph_vector_char_add_constant, libigraph), Cvoid, (Ptr{igraph_vector_char_t}, Cchar), v, plus)
end

function igraph_vector_char_scale(v, by)
    ccall((:igraph_vector_char_scale, libigraph), Cvoid, (Ptr{igraph_vector_char_t}, Cchar), v, by)
end

function igraph_vector_char_add(v1, v2)
    ccall((:igraph_vector_char_add, libigraph), igraph_error_t, (Ptr{igraph_vector_char_t}, Ptr{igraph_vector_char_t}), v1, v2)
end

function igraph_vector_char_sub(v1, v2)
    ccall((:igraph_vector_char_sub, libigraph), igraph_error_t, (Ptr{igraph_vector_char_t}, Ptr{igraph_vector_char_t}), v1, v2)
end

function igraph_vector_char_mul(v1, v2)
    ccall((:igraph_vector_char_mul, libigraph), igraph_error_t, (Ptr{igraph_vector_char_t}, Ptr{igraph_vector_char_t}), v1, v2)
end

function igraph_vector_char_div(v1, v2)
    ccall((:igraph_vector_char_div, libigraph), igraph_error_t, (Ptr{igraph_vector_char_t}, Ptr{igraph_vector_char_t}), v1, v2)
end

function igraph_vector_char_cumsum(to, from)
    ccall((:igraph_vector_char_cumsum, libigraph), igraph_error_t, (Ptr{igraph_vector_char_t}, Ptr{igraph_vector_char_t}), to, from)
end

function igraph_vector_char_abs(v)
    ccall((:igraph_vector_char_abs, libigraph), igraph_error_t, (Ptr{igraph_vector_char_t},), v)
end

function igraph_vector_char_all_e(lhs, rhs)
    ccall((:igraph_vector_char_all_e, libigraph), igraph_bool_t, (Ptr{igraph_vector_char_t}, Ptr{igraph_vector_char_t}), lhs, rhs)
end

function igraph_vector_char_all_l(lhs, rhs)
    ccall((:igraph_vector_char_all_l, libigraph), igraph_bool_t, (Ptr{igraph_vector_char_t}, Ptr{igraph_vector_char_t}), lhs, rhs)
end

function igraph_vector_char_all_g(lhs, rhs)
    ccall((:igraph_vector_char_all_g, libigraph), igraph_bool_t, (Ptr{igraph_vector_char_t}, Ptr{igraph_vector_char_t}), lhs, rhs)
end

function igraph_vector_char_all_le(lhs, rhs)
    ccall((:igraph_vector_char_all_le, libigraph), igraph_bool_t, (Ptr{igraph_vector_char_t}, Ptr{igraph_vector_char_t}), lhs, rhs)
end

function igraph_vector_char_all_ge(lhs, rhs)
    ccall((:igraph_vector_char_all_ge, libigraph), igraph_bool_t, (Ptr{igraph_vector_char_t}, Ptr{igraph_vector_char_t}), lhs, rhs)
end

function igraph_vector_char_lex_cmp(lhs, rhs)
    ccall((:igraph_vector_char_lex_cmp, libigraph), Cint, (Ptr{igraph_vector_char_t}, Ptr{igraph_vector_char_t}), lhs, rhs)
end

function igraph_vector_char_colex_cmp(lhs, rhs)
    ccall((:igraph_vector_char_colex_cmp, libigraph), Cint, (Ptr{igraph_vector_char_t}, Ptr{igraph_vector_char_t}), lhs, rhs)
end

function igraph_vector_char_lex_cmp_untyped(lhs, rhs)
    ccall((:igraph_vector_char_lex_cmp_untyped, libigraph), Cint, (Ptr{Cvoid}, Ptr{Cvoid}), lhs, rhs)
end

function igraph_vector_char_colex_cmp_untyped(lhs, rhs)
    ccall((:igraph_vector_char_colex_cmp_untyped, libigraph), Cint, (Ptr{Cvoid}, Ptr{Cvoid}), lhs, rhs)
end

function igraph_vector_char_min(v)
    ccall((:igraph_vector_char_min, libigraph), Cchar, (Ptr{igraph_vector_char_t},), v)
end

function igraph_vector_char_max(v)
    ccall((:igraph_vector_char_max, libigraph), Cchar, (Ptr{igraph_vector_char_t},), v)
end

function igraph_vector_char_which_min(v)
    ccall((:igraph_vector_char_which_min, libigraph), igraph_integer_t, (Ptr{igraph_vector_char_t},), v)
end

function igraph_vector_char_which_max(v)
    ccall((:igraph_vector_char_which_max, libigraph), igraph_integer_t, (Ptr{igraph_vector_char_t},), v)
end

function igraph_vector_char_minmax(v, min, max)
    ccall((:igraph_vector_char_minmax, libigraph), Cvoid, (Ptr{igraph_vector_char_t}, Ptr{Cchar}, Ptr{Cchar}), v, min, max)
end

function igraph_vector_char_which_minmax(v, which_min, which_max)
    ccall((:igraph_vector_char_which_minmax, libigraph), Cvoid, (Ptr{igraph_vector_char_t}, Ptr{igraph_integer_t}, Ptr{igraph_integer_t}), v, which_min, which_max)
end

function igraph_vector_char_empty(v)
    ccall((:igraph_vector_char_empty, libigraph), igraph_bool_t, (Ptr{igraph_vector_char_t},), v)
end

function igraph_vector_char_size(v)
    ccall((:igraph_vector_char_size, libigraph), igraph_integer_t, (Ptr{igraph_vector_char_t},), v)
end

function igraph_vector_char_isnull(v)
    ccall((:igraph_vector_char_isnull, libigraph), igraph_bool_t, (Ptr{igraph_vector_char_t},), v)
end

function igraph_vector_char_sum(v)
    ccall((:igraph_vector_char_sum, libigraph), Cchar, (Ptr{igraph_vector_char_t},), v)
end

function igraph_vector_char_sumsq(v)
    ccall((:igraph_vector_char_sumsq, libigraph), igraph_real_t, (Ptr{igraph_vector_char_t},), v)
end

function igraph_vector_char_prod(v)
    ccall((:igraph_vector_char_prod, libigraph), Cchar, (Ptr{igraph_vector_char_t},), v)
end

function igraph_vector_char_isininterval(v, low, high)
    ccall((:igraph_vector_char_isininterval, libigraph), igraph_bool_t, (Ptr{igraph_vector_char_t}, Cchar, Cchar), v, low, high)
end

function igraph_vector_char_any_smaller(v, limit)
    ccall((:igraph_vector_char_any_smaller, libigraph), igraph_bool_t, (Ptr{igraph_vector_char_t}, Cchar), v, limit)
end

function igraph_vector_char_is_equal(lhs, rhs)
    ccall((:igraph_vector_char_is_equal, libigraph), igraph_bool_t, (Ptr{igraph_vector_char_t}, Ptr{igraph_vector_char_t}), lhs, rhs)
end

function igraph_vector_char_maxdifference(m1, m2)
    ccall((:igraph_vector_char_maxdifference, libigraph), igraph_real_t, (Ptr{igraph_vector_char_t}, Ptr{igraph_vector_char_t}), m1, m2)
end

function igraph_vector_char_contains(v, e)
    ccall((:igraph_vector_char_contains, libigraph), igraph_bool_t, (Ptr{igraph_vector_char_t}, Cchar), v, e)
end

function igraph_vector_char_search(v, from, what, pos)
    ccall((:igraph_vector_char_search, libigraph), igraph_bool_t, (Ptr{igraph_vector_char_t}, igraph_integer_t, Cchar, Ptr{igraph_integer_t}), v, from, what, pos)
end

function igraph_vector_char_binsearch_slice(v, what, pos, start, _end)
    ccall((:igraph_vector_char_binsearch_slice, libigraph), igraph_bool_t, (Ptr{igraph_vector_char_t}, Cchar, Ptr{igraph_integer_t}, igraph_integer_t, igraph_integer_t), v, what, pos, start, _end)
end

function igraph_vector_char_binsearch(v, what, pos)
    ccall((:igraph_vector_char_binsearch, libigraph), igraph_bool_t, (Ptr{igraph_vector_char_t}, Cchar, Ptr{igraph_integer_t}), v, what, pos)
end

function igraph_vector_char_contains_sorted(v, what)
    ccall((:igraph_vector_char_contains_sorted, libigraph), igraph_bool_t, (Ptr{igraph_vector_char_t}, Cchar), v, what)
end

function igraph_vector_char_binsearch2(v, what)
    ccall((:igraph_vector_char_binsearch2, libigraph), igraph_bool_t, (Ptr{igraph_vector_char_t}, Cchar), v, what)
end

function igraph_vector_char_clear(v)
    ccall((:igraph_vector_char_clear, libigraph), Cvoid, (Ptr{igraph_vector_char_t},), v)
end

function igraph_vector_char_resize(v, new_size)
    ccall((:igraph_vector_char_resize, libigraph), igraph_error_t, (Ptr{igraph_vector_char_t}, igraph_integer_t), v, new_size)
end

function igraph_vector_char_resize_min(v)
    ccall((:igraph_vector_char_resize_min, libigraph), Cvoid, (Ptr{igraph_vector_char_t},), v)
end

function igraph_vector_char_reserve(v, capacity)
    ccall((:igraph_vector_char_reserve, libigraph), igraph_error_t, (Ptr{igraph_vector_char_t}, igraph_integer_t), v, capacity)
end

function igraph_vector_char_push_back(v, e)
    ccall((:igraph_vector_char_push_back, libigraph), igraph_error_t, (Ptr{igraph_vector_char_t}, Cchar), v, e)
end

function igraph_vector_char_pop_back(v)
    ccall((:igraph_vector_char_pop_back, libigraph), Cchar, (Ptr{igraph_vector_char_t},), v)
end

function igraph_vector_char_insert(v, pos, value)
    ccall((:igraph_vector_char_insert, libigraph), igraph_error_t, (Ptr{igraph_vector_char_t}, igraph_integer_t, Cchar), v, pos, value)
end

function igraph_vector_char_remove(v, elem)
    ccall((:igraph_vector_char_remove, libigraph), Cvoid, (Ptr{igraph_vector_char_t}, igraph_integer_t), v, elem)
end

function igraph_vector_char_remove_fast(v, elem)
    ccall((:igraph_vector_char_remove_fast, libigraph), Cvoid, (Ptr{igraph_vector_char_t}, igraph_integer_t), v, elem)
end

function igraph_vector_char_remove_section(v, from, to)
    ccall((:igraph_vector_char_remove_section, libigraph), Cvoid, (Ptr{igraph_vector_char_t}, igraph_integer_t, igraph_integer_t), v, from, to)
end

function igraph_vector_char_sort(v)
    ccall((:igraph_vector_char_sort, libigraph), Cvoid, (Ptr{igraph_vector_char_t},), v)
end

function igraph_vector_char_reverse_sort(v)
    ccall((:igraph_vector_char_reverse_sort, libigraph), Cvoid, (Ptr{igraph_vector_char_t},), v)
end

function igraph_vector_char_sort_ind(v, inds, order)
    ccall((:igraph_vector_char_sort_ind, libigraph), igraph_error_t, (Ptr{igraph_vector_char_t}, Ptr{igraph_vector_int_t}, igraph_order_t), v, inds, order)
end

function igraph_vector_char_qsort_ind(v, inds, order)
    ccall((:igraph_vector_char_qsort_ind, libigraph), igraph_error_t, (Ptr{igraph_vector_char_t}, Ptr{igraph_vector_int_t}, igraph_order_t), v, inds, order)
end

function igraph_vector_char_print(v)
    ccall((:igraph_vector_char_print, libigraph), igraph_error_t, (Ptr{igraph_vector_char_t},), v)
end

function igraph_vector_char_fprint(v, file)
    ccall((:igraph_vector_char_fprint, libigraph), igraph_error_t, (Ptr{igraph_vector_char_t}, Ptr{Libc.FILE}), v, file)
end

function igraph_vector_char_printf(v, format)
    ccall((:igraph_vector_char_printf, libigraph), igraph_error_t, (Ptr{igraph_vector_char_t}, Ptr{Cchar}), v, format)
end

function igraph_vector_char_move_interval(v, _begin, _end, to)
    ccall((:igraph_vector_char_move_interval, libigraph), igraph_error_t, (Ptr{igraph_vector_char_t}, igraph_integer_t, igraph_integer_t, igraph_integer_t), v, _begin, _end, to)
end

function igraph_vector_char_move_interval2(v, _begin, _end, to)
    ccall((:igraph_vector_char_move_interval2, libigraph), igraph_error_t, (Ptr{igraph_vector_char_t}, igraph_integer_t, igraph_integer_t, igraph_integer_t), v, _begin, _end, to)
end

function igraph_vector_char_filter_smaller(v, elem)
    ccall((:igraph_vector_char_filter_smaller, libigraph), igraph_error_t, (Ptr{igraph_vector_char_t}, Cchar), v, elem)
end

function igraph_vector_char_get_interval(v, res, from, to)
    ccall((:igraph_vector_char_get_interval, libigraph), igraph_error_t, (Ptr{igraph_vector_char_t}, Ptr{igraph_vector_char_t}, igraph_integer_t, igraph_integer_t), v, res, from, to)
end

function igraph_vector_char_difference_sorted(v1, v2, result)
    ccall((:igraph_vector_char_difference_sorted, libigraph), igraph_error_t, (Ptr{igraph_vector_char_t}, Ptr{igraph_vector_char_t}, Ptr{igraph_vector_char_t}), v1, v2, result)
end

function igraph_vector_char_intersect_sorted(v1, v2, result)
    ccall((:igraph_vector_char_intersect_sorted, libigraph), igraph_error_t, (Ptr{igraph_vector_char_t}, Ptr{igraph_vector_char_t}, Ptr{igraph_vector_char_t}), v1, v2, result)
end

function igraph_vector_char_intersection_size_sorted(v1, v2)
    ccall((:igraph_vector_char_intersection_size_sorted, libigraph), igraph_integer_t, (Ptr{igraph_vector_char_t}, Ptr{igraph_vector_char_t}), v1, v2)
end

function igraph_vector_char_index(v, newv, idx)
    ccall((:igraph_vector_char_index, libigraph), igraph_error_t, (Ptr{igraph_vector_char_t}, Ptr{igraph_vector_char_t}, Ptr{igraph_vector_int_t}), v, newv, idx)
end

function igraph_vector_char_index_int(v, idx)
    ccall((:igraph_vector_char_index_int, libigraph), igraph_error_t, (Ptr{igraph_vector_char_t}, Ptr{igraph_vector_int_t}), v, idx)
end

function igraph_vector_bool_init_array(v, data, length)
    ccall((:igraph_vector_bool_init_array, libigraph), igraph_error_t, (Ptr{igraph_vector_bool_t}, Ptr{igraph_bool_t}, igraph_integer_t), v, data, length)
end

function igraph_vector_bool_init_copy(to, from)
    ccall((:igraph_vector_bool_init_copy, libigraph), igraph_error_t, (Ptr{igraph_vector_bool_t}, Ptr{igraph_vector_bool_t}), to, from)
end

function igraph_vector_bool_copy(to, from)
    ccall((:igraph_vector_bool_copy, libigraph), igraph_error_t, (Ptr{igraph_vector_bool_t}, Ptr{igraph_vector_bool_t}), to, from)
end

function igraph_vector_bool_capacity(v)
    ccall((:igraph_vector_bool_capacity, libigraph), igraph_integer_t, (Ptr{igraph_vector_bool_t},), v)
end

function igraph_vector_bool_e(v, pos)
    ccall((:igraph_vector_bool_e, libigraph), igraph_bool_t, (Ptr{igraph_vector_bool_t}, igraph_integer_t), v, pos)
end

function igraph_vector_bool_e_ptr(v, pos)
    ccall((:igraph_vector_bool_e_ptr, libigraph), Ptr{igraph_bool_t}, (Ptr{igraph_vector_bool_t}, igraph_integer_t), v, pos)
end

function igraph_vector_bool_get(v, pos)
    ccall((:igraph_vector_bool_get, libigraph), igraph_bool_t, (Ptr{igraph_vector_bool_t}, igraph_integer_t), v, pos)
end

function igraph_vector_bool_get_ptr(v, pos)
    ccall((:igraph_vector_bool_get_ptr, libigraph), Ptr{igraph_bool_t}, (Ptr{igraph_vector_bool_t}, igraph_integer_t), v, pos)
end

function igraph_vector_bool_set(v, pos, value)
    ccall((:igraph_vector_bool_set, libigraph), Cvoid, (Ptr{igraph_vector_bool_t}, igraph_integer_t, igraph_bool_t), v, pos, value)
end

function igraph_vector_bool_tail(v)
    ccall((:igraph_vector_bool_tail, libigraph), igraph_bool_t, (Ptr{igraph_vector_bool_t},), v)
end

function igraph_vector_bool_null(v)
    ccall((:igraph_vector_bool_null, libigraph), Cvoid, (Ptr{igraph_vector_bool_t},), v)
end

function igraph_vector_bool_fill(v, e)
    ccall((:igraph_vector_bool_fill, libigraph), Cvoid, (Ptr{igraph_vector_bool_t}, igraph_bool_t), v, e)
end

function igraph_vector_bool_view(v, data, length)
    ccall((:igraph_vector_bool_view, libigraph), Ptr{igraph_vector_bool_t}, (Ptr{igraph_vector_bool_t}, Ptr{igraph_bool_t}, igraph_integer_t), v, data, length)
end

function igraph_vector_bool_copy_to(v, to)
    ccall((:igraph_vector_bool_copy_to, libigraph), Cvoid, (Ptr{igraph_vector_bool_t}, Ptr{igraph_bool_t}), v, to)
end

function igraph_vector_bool_update(to, from)
    ccall((:igraph_vector_bool_update, libigraph), igraph_error_t, (Ptr{igraph_vector_bool_t}, Ptr{igraph_vector_bool_t}), to, from)
end

function igraph_vector_bool_append(to, from)
    ccall((:igraph_vector_bool_append, libigraph), igraph_error_t, (Ptr{igraph_vector_bool_t}, Ptr{igraph_vector_bool_t}), to, from)
end

function igraph_vector_bool_swap(v1, v2)
    ccall((:igraph_vector_bool_swap, libigraph), igraph_error_t, (Ptr{igraph_vector_bool_t}, Ptr{igraph_vector_bool_t}), v1, v2)
end

function igraph_vector_bool_swap_elements(v, i, j)
    ccall((:igraph_vector_bool_swap_elements, libigraph), igraph_error_t, (Ptr{igraph_vector_bool_t}, igraph_integer_t, igraph_integer_t), v, i, j)
end

function igraph_vector_bool_reverse(v)
    ccall((:igraph_vector_bool_reverse, libigraph), igraph_error_t, (Ptr{igraph_vector_bool_t},), v)
end

function igraph_vector_bool_reverse_section(v, from, to)
    ccall((:igraph_vector_bool_reverse_section, libigraph), Cvoid, (Ptr{igraph_vector_bool_t}, igraph_integer_t, igraph_integer_t), v, from, to)
end

function igraph_vector_bool_rotate_left(v, n)
    ccall((:igraph_vector_bool_rotate_left, libigraph), Cvoid, (Ptr{igraph_vector_bool_t}, igraph_integer_t), v, n)
end

function igraph_vector_bool_permute(v, ind)
    ccall((:igraph_vector_bool_permute, libigraph), igraph_error_t, (Ptr{igraph_vector_bool_t}, Ptr{igraph_vector_int_t}), v, ind)
end

function igraph_vector_bool_shuffle(v)
    ccall((:igraph_vector_bool_shuffle, libigraph), igraph_error_t, (Ptr{igraph_vector_bool_t},), v)
end

function igraph_vector_bool_add_constant(v, plus)
    ccall((:igraph_vector_bool_add_constant, libigraph), Cvoid, (Ptr{igraph_vector_bool_t}, igraph_bool_t), v, plus)
end

function igraph_vector_bool_scale(v, by)
    ccall((:igraph_vector_bool_scale, libigraph), Cvoid, (Ptr{igraph_vector_bool_t}, igraph_bool_t), v, by)
end

function igraph_vector_bool_add(v1, v2)
    ccall((:igraph_vector_bool_add, libigraph), igraph_error_t, (Ptr{igraph_vector_bool_t}, Ptr{igraph_vector_bool_t}), v1, v2)
end

function igraph_vector_bool_sub(v1, v2)
    ccall((:igraph_vector_bool_sub, libigraph), igraph_error_t, (Ptr{igraph_vector_bool_t}, Ptr{igraph_vector_bool_t}), v1, v2)
end

function igraph_vector_bool_mul(v1, v2)
    ccall((:igraph_vector_bool_mul, libigraph), igraph_error_t, (Ptr{igraph_vector_bool_t}, Ptr{igraph_vector_bool_t}), v1, v2)
end

function igraph_vector_bool_div(v1, v2)
    ccall((:igraph_vector_bool_div, libigraph), igraph_error_t, (Ptr{igraph_vector_bool_t}, Ptr{igraph_vector_bool_t}), v1, v2)
end

function igraph_vector_bool_cumsum(to, from)
    ccall((:igraph_vector_bool_cumsum, libigraph), igraph_error_t, (Ptr{igraph_vector_bool_t}, Ptr{igraph_vector_bool_t}), to, from)
end

function igraph_vector_bool_all_e(lhs, rhs)
    ccall((:igraph_vector_bool_all_e, libigraph), igraph_bool_t, (Ptr{igraph_vector_bool_t}, Ptr{igraph_vector_bool_t}), lhs, rhs)
end

function igraph_vector_bool_empty(v)
    ccall((:igraph_vector_bool_empty, libigraph), igraph_bool_t, (Ptr{igraph_vector_bool_t},), v)
end

function igraph_vector_bool_size(v)
    ccall((:igraph_vector_bool_size, libigraph), igraph_integer_t, (Ptr{igraph_vector_bool_t},), v)
end

function igraph_vector_bool_isnull(v)
    ccall((:igraph_vector_bool_isnull, libigraph), igraph_bool_t, (Ptr{igraph_vector_bool_t},), v)
end

function igraph_vector_bool_sum(v)
    ccall((:igraph_vector_bool_sum, libigraph), igraph_bool_t, (Ptr{igraph_vector_bool_t},), v)
end

function igraph_vector_bool_sumsq(v)
    ccall((:igraph_vector_bool_sumsq, libigraph), igraph_real_t, (Ptr{igraph_vector_bool_t},), v)
end

function igraph_vector_bool_prod(v)
    ccall((:igraph_vector_bool_prod, libigraph), igraph_bool_t, (Ptr{igraph_vector_bool_t},), v)
end

function igraph_vector_bool_is_equal(lhs, rhs)
    ccall((:igraph_vector_bool_is_equal, libigraph), igraph_bool_t, (Ptr{igraph_vector_bool_t}, Ptr{igraph_vector_bool_t}), lhs, rhs)
end

function igraph_vector_bool_contains(v, e)
    ccall((:igraph_vector_bool_contains, libigraph), igraph_bool_t, (Ptr{igraph_vector_bool_t}, igraph_bool_t), v, e)
end

function igraph_vector_bool_search(v, from, what, pos)
    ccall((:igraph_vector_bool_search, libigraph), igraph_bool_t, (Ptr{igraph_vector_bool_t}, igraph_integer_t, igraph_bool_t, Ptr{igraph_integer_t}), v, from, what, pos)
end

function igraph_vector_bool_clear(v)
    ccall((:igraph_vector_bool_clear, libigraph), Cvoid, (Ptr{igraph_vector_bool_t},), v)
end

function igraph_vector_bool_resize(v, new_size)
    ccall((:igraph_vector_bool_resize, libigraph), igraph_error_t, (Ptr{igraph_vector_bool_t}, igraph_integer_t), v, new_size)
end

function igraph_vector_bool_resize_min(v)
    ccall((:igraph_vector_bool_resize_min, libigraph), Cvoid, (Ptr{igraph_vector_bool_t},), v)
end

function igraph_vector_bool_reserve(v, capacity)
    ccall((:igraph_vector_bool_reserve, libigraph), igraph_error_t, (Ptr{igraph_vector_bool_t}, igraph_integer_t), v, capacity)
end

function igraph_vector_bool_push_back(v, e)
    ccall((:igraph_vector_bool_push_back, libigraph), igraph_error_t, (Ptr{igraph_vector_bool_t}, igraph_bool_t), v, e)
end

function igraph_vector_bool_pop_back(v)
    ccall((:igraph_vector_bool_pop_back, libigraph), igraph_bool_t, (Ptr{igraph_vector_bool_t},), v)
end

function igraph_vector_bool_insert(v, pos, value)
    ccall((:igraph_vector_bool_insert, libigraph), igraph_error_t, (Ptr{igraph_vector_bool_t}, igraph_integer_t, igraph_bool_t), v, pos, value)
end

function igraph_vector_bool_remove(v, elem)
    ccall((:igraph_vector_bool_remove, libigraph), Cvoid, (Ptr{igraph_vector_bool_t}, igraph_integer_t), v, elem)
end

function igraph_vector_bool_remove_fast(v, elem)
    ccall((:igraph_vector_bool_remove_fast, libigraph), Cvoid, (Ptr{igraph_vector_bool_t}, igraph_integer_t), v, elem)
end

function igraph_vector_bool_remove_section(v, from, to)
    ccall((:igraph_vector_bool_remove_section, libigraph), Cvoid, (Ptr{igraph_vector_bool_t}, igraph_integer_t, igraph_integer_t), v, from, to)
end

function igraph_vector_bool_print(v)
    ccall((:igraph_vector_bool_print, libigraph), igraph_error_t, (Ptr{igraph_vector_bool_t},), v)
end

function igraph_vector_bool_fprint(v, file)
    ccall((:igraph_vector_bool_fprint, libigraph), igraph_error_t, (Ptr{igraph_vector_bool_t}, Ptr{Libc.FILE}), v, file)
end

function igraph_vector_bool_printf(v, format)
    ccall((:igraph_vector_bool_printf, libigraph), igraph_error_t, (Ptr{igraph_vector_bool_t}, Ptr{Cchar}), v, format)
end

function igraph_vector_bool_move_interval(v, _begin, _end, to)
    ccall((:igraph_vector_bool_move_interval, libigraph), igraph_error_t, (Ptr{igraph_vector_bool_t}, igraph_integer_t, igraph_integer_t, igraph_integer_t), v, _begin, _end, to)
end

function igraph_vector_bool_move_interval2(v, _begin, _end, to)
    ccall((:igraph_vector_bool_move_interval2, libigraph), igraph_error_t, (Ptr{igraph_vector_bool_t}, igraph_integer_t, igraph_integer_t, igraph_integer_t), v, _begin, _end, to)
end

function igraph_vector_bool_get_interval(v, res, from, to)
    ccall((:igraph_vector_bool_get_interval, libigraph), igraph_error_t, (Ptr{igraph_vector_bool_t}, Ptr{igraph_vector_bool_t}, igraph_integer_t, igraph_integer_t), v, res, from, to)
end

function igraph_vector_bool_index(v, newv, idx)
    ccall((:igraph_vector_bool_index, libigraph), igraph_error_t, (Ptr{igraph_vector_bool_t}, Ptr{igraph_vector_bool_t}, Ptr{igraph_vector_int_t}), v, newv, idx)
end

function igraph_vector_bool_index_int(v, idx)
    ccall((:igraph_vector_bool_index_int, libigraph), igraph_error_t, (Ptr{igraph_vector_bool_t}, Ptr{igraph_vector_int_t}), v, idx)
end

function igraph_vector_int_init_array(v, data, length)
    ccall((:igraph_vector_int_init_array, libigraph), igraph_error_t, (Ptr{igraph_vector_int_t}, Ptr{igraph_integer_t}, igraph_integer_t), v, data, length)
end

function igraph_vector_int_init_copy(to, from)
    ccall((:igraph_vector_int_init_copy, libigraph), igraph_error_t, (Ptr{igraph_vector_int_t}, Ptr{igraph_vector_int_t}), to, from)
end

function igraph_vector_int_init_range(v, start, _end)
    ccall((:igraph_vector_int_init_range, libigraph), igraph_error_t, (Ptr{igraph_vector_int_t}, igraph_integer_t, igraph_integer_t), v, start, _end)
end

function igraph_vector_int_init_seq(v, from, to)
    ccall((:igraph_vector_int_init_seq, libigraph), igraph_error_t, (Ptr{igraph_vector_int_t}, igraph_integer_t, igraph_integer_t), v, from, to)
end

function igraph_vector_int_copy(to, from)
    ccall((:igraph_vector_int_copy, libigraph), igraph_error_t, (Ptr{igraph_vector_int_t}, Ptr{igraph_vector_int_t}), to, from)
end

function igraph_vector_int_capacity(v)
    ccall((:igraph_vector_int_capacity, libigraph), igraph_integer_t, (Ptr{igraph_vector_int_t},), v)
end

function igraph_vector_int_e(v, pos)
    ccall((:igraph_vector_int_e, libigraph), igraph_integer_t, (Ptr{igraph_vector_int_t}, igraph_integer_t), v, pos)
end

function igraph_vector_int_e_ptr(v, pos)
    ccall((:igraph_vector_int_e_ptr, libigraph), Ptr{igraph_integer_t}, (Ptr{igraph_vector_int_t}, igraph_integer_t), v, pos)
end

function igraph_vector_int_get(v, pos)
    ccall((:igraph_vector_int_get, libigraph), igraph_integer_t, (Ptr{igraph_vector_int_t}, igraph_integer_t), v, pos)
end

function igraph_vector_int_get_ptr(v, pos)
    ccall((:igraph_vector_int_get_ptr, libigraph), Ptr{igraph_integer_t}, (Ptr{igraph_vector_int_t}, igraph_integer_t), v, pos)
end

function igraph_vector_int_set(v, pos, value)
    ccall((:igraph_vector_int_set, libigraph), Cvoid, (Ptr{igraph_vector_int_t}, igraph_integer_t, igraph_integer_t), v, pos, value)
end

function igraph_vector_int_tail(v)
    ccall((:igraph_vector_int_tail, libigraph), igraph_integer_t, (Ptr{igraph_vector_int_t},), v)
end

function igraph_vector_int_null(v)
    ccall((:igraph_vector_int_null, libigraph), Cvoid, (Ptr{igraph_vector_int_t},), v)
end

function igraph_vector_int_fill(v, e)
    ccall((:igraph_vector_int_fill, libigraph), Cvoid, (Ptr{igraph_vector_int_t}, igraph_integer_t), v, e)
end

function igraph_vector_int_range(v, start, _end)
    ccall((:igraph_vector_int_range, libigraph), igraph_error_t, (Ptr{igraph_vector_int_t}, igraph_integer_t, igraph_integer_t), v, start, _end)
end

function igraph_vector_int_view(v, data, length)
    ccall((:igraph_vector_int_view, libigraph), Ptr{igraph_vector_int_t}, (Ptr{igraph_vector_int_t}, Ptr{igraph_integer_t}, igraph_integer_t), v, data, length)
end

function igraph_vector_int_copy_to(v, to)
    ccall((:igraph_vector_int_copy_to, libigraph), Cvoid, (Ptr{igraph_vector_int_t}, Ptr{igraph_integer_t}), v, to)
end

function igraph_vector_int_update(to, from)
    ccall((:igraph_vector_int_update, libigraph), igraph_error_t, (Ptr{igraph_vector_int_t}, Ptr{igraph_vector_int_t}), to, from)
end

function igraph_vector_int_append(to, from)
    ccall((:igraph_vector_int_append, libigraph), igraph_error_t, (Ptr{igraph_vector_int_t}, Ptr{igraph_vector_int_t}), to, from)
end

function igraph_vector_int_swap(v1, v2)
    ccall((:igraph_vector_int_swap, libigraph), igraph_error_t, (Ptr{igraph_vector_int_t}, Ptr{igraph_vector_int_t}), v1, v2)
end

function igraph_vector_int_swap_elements(v, i, j)
    ccall((:igraph_vector_int_swap_elements, libigraph), igraph_error_t, (Ptr{igraph_vector_int_t}, igraph_integer_t, igraph_integer_t), v, i, j)
end

function igraph_vector_int_reverse(v)
    ccall((:igraph_vector_int_reverse, libigraph), igraph_error_t, (Ptr{igraph_vector_int_t},), v)
end

function igraph_vector_int_reverse_section(v, from, to)
    ccall((:igraph_vector_int_reverse_section, libigraph), Cvoid, (Ptr{igraph_vector_int_t}, igraph_integer_t, igraph_integer_t), v, from, to)
end

function igraph_vector_int_rotate_left(v, n)
    ccall((:igraph_vector_int_rotate_left, libigraph), Cvoid, (Ptr{igraph_vector_int_t}, igraph_integer_t), v, n)
end

function igraph_vector_int_permute(v, ind)
    ccall((:igraph_vector_int_permute, libigraph), igraph_error_t, (Ptr{igraph_vector_int_t}, Ptr{igraph_vector_int_t}), v, ind)
end

function igraph_vector_int_shuffle(v)
    ccall((:igraph_vector_int_shuffle, libigraph), igraph_error_t, (Ptr{igraph_vector_int_t},), v)
end

function igraph_vector_int_add_constant(v, plus)
    ccall((:igraph_vector_int_add_constant, libigraph), Cvoid, (Ptr{igraph_vector_int_t}, igraph_integer_t), v, plus)
end

function igraph_vector_int_scale(v, by)
    ccall((:igraph_vector_int_scale, libigraph), Cvoid, (Ptr{igraph_vector_int_t}, igraph_integer_t), v, by)
end

function igraph_vector_int_add(v1, v2)
    ccall((:igraph_vector_int_add, libigraph), igraph_error_t, (Ptr{igraph_vector_int_t}, Ptr{igraph_vector_int_t}), v1, v2)
end

function igraph_vector_int_sub(v1, v2)
    ccall((:igraph_vector_int_sub, libigraph), igraph_error_t, (Ptr{igraph_vector_int_t}, Ptr{igraph_vector_int_t}), v1, v2)
end

function igraph_vector_int_mul(v1, v2)
    ccall((:igraph_vector_int_mul, libigraph), igraph_error_t, (Ptr{igraph_vector_int_t}, Ptr{igraph_vector_int_t}), v1, v2)
end

function igraph_vector_int_div(v1, v2)
    ccall((:igraph_vector_int_div, libigraph), igraph_error_t, (Ptr{igraph_vector_int_t}, Ptr{igraph_vector_int_t}), v1, v2)
end

function igraph_vector_int_cumsum(to, from)
    ccall((:igraph_vector_int_cumsum, libigraph), igraph_error_t, (Ptr{igraph_vector_int_t}, Ptr{igraph_vector_int_t}), to, from)
end

function igraph_vector_int_abs(v)
    ccall((:igraph_vector_int_abs, libigraph), igraph_error_t, (Ptr{igraph_vector_int_t},), v)
end

function igraph_vector_int_all_e(lhs, rhs)
    ccall((:igraph_vector_int_all_e, libigraph), igraph_bool_t, (Ptr{igraph_vector_int_t}, Ptr{igraph_vector_int_t}), lhs, rhs)
end

function igraph_vector_int_all_l(lhs, rhs)
    ccall((:igraph_vector_int_all_l, libigraph), igraph_bool_t, (Ptr{igraph_vector_int_t}, Ptr{igraph_vector_int_t}), lhs, rhs)
end

function igraph_vector_int_all_g(lhs, rhs)
    ccall((:igraph_vector_int_all_g, libigraph), igraph_bool_t, (Ptr{igraph_vector_int_t}, Ptr{igraph_vector_int_t}), lhs, rhs)
end

function igraph_vector_int_all_le(lhs, rhs)
    ccall((:igraph_vector_int_all_le, libigraph), igraph_bool_t, (Ptr{igraph_vector_int_t}, Ptr{igraph_vector_int_t}), lhs, rhs)
end

function igraph_vector_int_all_ge(lhs, rhs)
    ccall((:igraph_vector_int_all_ge, libigraph), igraph_bool_t, (Ptr{igraph_vector_int_t}, Ptr{igraph_vector_int_t}), lhs, rhs)
end

function igraph_vector_int_lex_cmp(lhs, rhs)
    ccall((:igraph_vector_int_lex_cmp, libigraph), Cint, (Ptr{igraph_vector_int_t}, Ptr{igraph_vector_int_t}), lhs, rhs)
end

function igraph_vector_int_colex_cmp(lhs, rhs)
    ccall((:igraph_vector_int_colex_cmp, libigraph), Cint, (Ptr{igraph_vector_int_t}, Ptr{igraph_vector_int_t}), lhs, rhs)
end

function igraph_vector_int_lex_cmp_untyped(lhs, rhs)
    ccall((:igraph_vector_int_lex_cmp_untyped, libigraph), Cint, (Ptr{Cvoid}, Ptr{Cvoid}), lhs, rhs)
end

function igraph_vector_int_colex_cmp_untyped(lhs, rhs)
    ccall((:igraph_vector_int_colex_cmp_untyped, libigraph), Cint, (Ptr{Cvoid}, Ptr{Cvoid}), lhs, rhs)
end

function igraph_vector_int_min(v)
    ccall((:igraph_vector_int_min, libigraph), igraph_integer_t, (Ptr{igraph_vector_int_t},), v)
end

function igraph_vector_int_max(v)
    ccall((:igraph_vector_int_max, libigraph), igraph_integer_t, (Ptr{igraph_vector_int_t},), v)
end

function igraph_vector_int_which_min(v)
    ccall((:igraph_vector_int_which_min, libigraph), igraph_integer_t, (Ptr{igraph_vector_int_t},), v)
end

function igraph_vector_int_which_max(v)
    ccall((:igraph_vector_int_which_max, libigraph), igraph_integer_t, (Ptr{igraph_vector_int_t},), v)
end

function igraph_vector_int_minmax(v, min, max)
    ccall((:igraph_vector_int_minmax, libigraph), Cvoid, (Ptr{igraph_vector_int_t}, Ptr{igraph_integer_t}, Ptr{igraph_integer_t}), v, min, max)
end

function igraph_vector_int_which_minmax(v, which_min, which_max)
    ccall((:igraph_vector_int_which_minmax, libigraph), Cvoid, (Ptr{igraph_vector_int_t}, Ptr{igraph_integer_t}, Ptr{igraph_integer_t}), v, which_min, which_max)
end

function igraph_vector_int_empty(v)
    ccall((:igraph_vector_int_empty, libigraph), igraph_bool_t, (Ptr{igraph_vector_int_t},), v)
end

function igraph_vector_int_size(v)
    ccall((:igraph_vector_int_size, libigraph), igraph_integer_t, (Ptr{igraph_vector_int_t},), v)
end

function igraph_vector_int_isnull(v)
    ccall((:igraph_vector_int_isnull, libigraph), igraph_bool_t, (Ptr{igraph_vector_int_t},), v)
end

function igraph_vector_int_sum(v)
    ccall((:igraph_vector_int_sum, libigraph), igraph_integer_t, (Ptr{igraph_vector_int_t},), v)
end

function igraph_vector_int_sumsq(v)
    ccall((:igraph_vector_int_sumsq, libigraph), igraph_real_t, (Ptr{igraph_vector_int_t},), v)
end

function igraph_vector_int_prod(v)
    ccall((:igraph_vector_int_prod, libigraph), igraph_integer_t, (Ptr{igraph_vector_int_t},), v)
end

function igraph_vector_int_isininterval(v, low, high)
    ccall((:igraph_vector_int_isininterval, libigraph), igraph_bool_t, (Ptr{igraph_vector_int_t}, igraph_integer_t, igraph_integer_t), v, low, high)
end

function igraph_vector_int_any_smaller(v, limit)
    ccall((:igraph_vector_int_any_smaller, libigraph), igraph_bool_t, (Ptr{igraph_vector_int_t}, igraph_integer_t), v, limit)
end

function igraph_vector_int_is_equal(lhs, rhs)
    ccall((:igraph_vector_int_is_equal, libigraph), igraph_bool_t, (Ptr{igraph_vector_int_t}, Ptr{igraph_vector_int_t}), lhs, rhs)
end

function igraph_vector_int_maxdifference(m1, m2)
    ccall((:igraph_vector_int_maxdifference, libigraph), igraph_real_t, (Ptr{igraph_vector_int_t}, Ptr{igraph_vector_int_t}), m1, m2)
end

function igraph_vector_int_contains(v, e)
    ccall((:igraph_vector_int_contains, libigraph), igraph_bool_t, (Ptr{igraph_vector_int_t}, igraph_integer_t), v, e)
end

function igraph_vector_int_search(v, from, what, pos)
    ccall((:igraph_vector_int_search, libigraph), igraph_bool_t, (Ptr{igraph_vector_int_t}, igraph_integer_t, igraph_integer_t, Ptr{igraph_integer_t}), v, from, what, pos)
end

function igraph_vector_int_binsearch_slice(v, what, pos, start, _end)
    ccall((:igraph_vector_int_binsearch_slice, libigraph), igraph_bool_t, (Ptr{igraph_vector_int_t}, igraph_integer_t, Ptr{igraph_integer_t}, igraph_integer_t, igraph_integer_t), v, what, pos, start, _end)
end

function igraph_vector_int_binsearch(v, what, pos)
    ccall((:igraph_vector_int_binsearch, libigraph), igraph_bool_t, (Ptr{igraph_vector_int_t}, igraph_integer_t, Ptr{igraph_integer_t}), v, what, pos)
end

function igraph_vector_int_contains_sorted(v, what)
    ccall((:igraph_vector_int_contains_sorted, libigraph), igraph_bool_t, (Ptr{igraph_vector_int_t}, igraph_integer_t), v, what)
end

function igraph_vector_int_binsearch2(v, what)
    ccall((:igraph_vector_int_binsearch2, libigraph), igraph_bool_t, (Ptr{igraph_vector_int_t}, igraph_integer_t), v, what)
end

function igraph_vector_int_clear(v)
    ccall((:igraph_vector_int_clear, libigraph), Cvoid, (Ptr{igraph_vector_int_t},), v)
end

function igraph_vector_int_resize(v, new_size)
    ccall((:igraph_vector_int_resize, libigraph), igraph_error_t, (Ptr{igraph_vector_int_t}, igraph_integer_t), v, new_size)
end

function igraph_vector_int_resize_min(v)
    ccall((:igraph_vector_int_resize_min, libigraph), Cvoid, (Ptr{igraph_vector_int_t},), v)
end

function igraph_vector_int_reserve(v, capacity)
    ccall((:igraph_vector_int_reserve, libigraph), igraph_error_t, (Ptr{igraph_vector_int_t}, igraph_integer_t), v, capacity)
end

function igraph_vector_int_push_back(v, e)
    ccall((:igraph_vector_int_push_back, libigraph), igraph_error_t, (Ptr{igraph_vector_int_t}, igraph_integer_t), v, e)
end

function igraph_vector_int_pop_back(v)
    ccall((:igraph_vector_int_pop_back, libigraph), igraph_integer_t, (Ptr{igraph_vector_int_t},), v)
end

function igraph_vector_int_insert(v, pos, value)
    ccall((:igraph_vector_int_insert, libigraph), igraph_error_t, (Ptr{igraph_vector_int_t}, igraph_integer_t, igraph_integer_t), v, pos, value)
end

function igraph_vector_int_remove(v, elem)
    ccall((:igraph_vector_int_remove, libigraph), Cvoid, (Ptr{igraph_vector_int_t}, igraph_integer_t), v, elem)
end

function igraph_vector_int_remove_fast(v, elem)
    ccall((:igraph_vector_int_remove_fast, libigraph), Cvoid, (Ptr{igraph_vector_int_t}, igraph_integer_t), v, elem)
end

function igraph_vector_int_remove_section(v, from, to)
    ccall((:igraph_vector_int_remove_section, libigraph), Cvoid, (Ptr{igraph_vector_int_t}, igraph_integer_t, igraph_integer_t), v, from, to)
end

function igraph_vector_int_sort(v)
    ccall((:igraph_vector_int_sort, libigraph), Cvoid, (Ptr{igraph_vector_int_t},), v)
end

function igraph_vector_int_reverse_sort(v)
    ccall((:igraph_vector_int_reverse_sort, libigraph), Cvoid, (Ptr{igraph_vector_int_t},), v)
end

function igraph_vector_int_sort_ind(v, inds, order)
    ccall((:igraph_vector_int_sort_ind, libigraph), igraph_error_t, (Ptr{igraph_vector_int_t}, Ptr{igraph_vector_int_t}, igraph_order_t), v, inds, order)
end

function igraph_vector_int_qsort_ind(v, inds, order)
    ccall((:igraph_vector_int_qsort_ind, libigraph), igraph_error_t, (Ptr{igraph_vector_int_t}, Ptr{igraph_vector_int_t}, igraph_order_t), v, inds, order)
end

function igraph_vector_int_print(v)
    ccall((:igraph_vector_int_print, libigraph), igraph_error_t, (Ptr{igraph_vector_int_t},), v)
end

function igraph_vector_int_fprint(v, file)
    ccall((:igraph_vector_int_fprint, libigraph), igraph_error_t, (Ptr{igraph_vector_int_t}, Ptr{Libc.FILE}), v, file)
end

function igraph_vector_int_printf(v, format)
    ccall((:igraph_vector_int_printf, libigraph), igraph_error_t, (Ptr{igraph_vector_int_t}, Ptr{Cchar}), v, format)
end

function igraph_vector_int_move_interval(v, _begin, _end, to)
    ccall((:igraph_vector_int_move_interval, libigraph), igraph_error_t, (Ptr{igraph_vector_int_t}, igraph_integer_t, igraph_integer_t, igraph_integer_t), v, _begin, _end, to)
end

function igraph_vector_int_move_interval2(v, _begin, _end, to)
    ccall((:igraph_vector_int_move_interval2, libigraph), igraph_error_t, (Ptr{igraph_vector_int_t}, igraph_integer_t, igraph_integer_t, igraph_integer_t), v, _begin, _end, to)
end

function igraph_vector_int_filter_smaller(v, elem)
    ccall((:igraph_vector_int_filter_smaller, libigraph), igraph_error_t, (Ptr{igraph_vector_int_t}, igraph_integer_t), v, elem)
end

function igraph_vector_int_get_interval(v, res, from, to)
    ccall((:igraph_vector_int_get_interval, libigraph), igraph_error_t, (Ptr{igraph_vector_int_t}, Ptr{igraph_vector_int_t}, igraph_integer_t, igraph_integer_t), v, res, from, to)
end

function igraph_vector_int_difference_sorted(v1, v2, result)
    ccall((:igraph_vector_int_difference_sorted, libigraph), igraph_error_t, (Ptr{igraph_vector_int_t}, Ptr{igraph_vector_int_t}, Ptr{igraph_vector_int_t}), v1, v2, result)
end

function igraph_vector_int_intersect_sorted(v1, v2, result)
    ccall((:igraph_vector_int_intersect_sorted, libigraph), igraph_error_t, (Ptr{igraph_vector_int_t}, Ptr{igraph_vector_int_t}, Ptr{igraph_vector_int_t}), v1, v2, result)
end

function igraph_vector_int_intersection_size_sorted(v1, v2)
    ccall((:igraph_vector_int_intersection_size_sorted, libigraph), igraph_integer_t, (Ptr{igraph_vector_int_t}, Ptr{igraph_vector_int_t}), v1, v2)
end

function igraph_vector_int_index(v, newv, idx)
    ccall((:igraph_vector_int_index, libigraph), igraph_error_t, (Ptr{igraph_vector_int_t}, Ptr{igraph_vector_int_t}, Ptr{igraph_vector_int_t}), v, newv, idx)
end

function igraph_vector_int_index_int(v, idx)
    ccall((:igraph_vector_int_index_int, libigraph), igraph_error_t, (Ptr{igraph_vector_int_t}, Ptr{igraph_vector_int_t}), v, idx)
end

function igraph_vector_complex_init(v, size)
    ccall((:igraph_vector_complex_init, libigraph), igraph_error_t, (Ptr{igraph_vector_complex_t}, igraph_integer_t), v, size)
end

function igraph_vector_complex_init_array(v, data, length)
    ccall((:igraph_vector_complex_init_array, libigraph), igraph_error_t, (Ptr{igraph_vector_complex_t}, Ptr{igraph_complex_t}, igraph_integer_t), v, data, length)
end

function igraph_vector_complex_init_copy(to, from)
    ccall((:igraph_vector_complex_init_copy, libigraph), igraph_error_t, (Ptr{igraph_vector_complex_t}, Ptr{igraph_vector_complex_t}), to, from)
end

function igraph_vector_complex_copy(to, from)
    ccall((:igraph_vector_complex_copy, libigraph), igraph_error_t, (Ptr{igraph_vector_complex_t}, Ptr{igraph_vector_complex_t}), to, from)
end

function igraph_vector_complex_destroy(v)
    ccall((:igraph_vector_complex_destroy, libigraph), Cvoid, (Ptr{igraph_vector_complex_t},), v)
end

function igraph_vector_complex_capacity(v)
    ccall((:igraph_vector_complex_capacity, libigraph), igraph_integer_t, (Ptr{igraph_vector_complex_t},), v)
end

function igraph_vector_complex_e(v, pos)
    ccall((:igraph_vector_complex_e, libigraph), igraph_complex_t, (Ptr{igraph_vector_complex_t}, igraph_integer_t), v, pos)
end

function igraph_vector_complex_e_ptr(v, pos)
    ccall((:igraph_vector_complex_e_ptr, libigraph), Ptr{igraph_complex_t}, (Ptr{igraph_vector_complex_t}, igraph_integer_t), v, pos)
end

function igraph_vector_complex_get(v, pos)
    ccall((:igraph_vector_complex_get, libigraph), igraph_complex_t, (Ptr{igraph_vector_complex_t}, igraph_integer_t), v, pos)
end

function igraph_vector_complex_get_ptr(v, pos)
    ccall((:igraph_vector_complex_get_ptr, libigraph), Ptr{igraph_complex_t}, (Ptr{igraph_vector_complex_t}, igraph_integer_t), v, pos)
end

function igraph_vector_complex_set(v, pos, value)
    ccall((:igraph_vector_complex_set, libigraph), Cvoid, (Ptr{igraph_vector_complex_t}, igraph_integer_t, igraph_complex_t), v, pos, value)
end

function igraph_vector_complex_tail(v)
    ccall((:igraph_vector_complex_tail, libigraph), igraph_complex_t, (Ptr{igraph_vector_complex_t},), v)
end

function igraph_vector_complex_null(v)
    ccall((:igraph_vector_complex_null, libigraph), Cvoid, (Ptr{igraph_vector_complex_t},), v)
end

function igraph_vector_complex_fill(v, e)
    ccall((:igraph_vector_complex_fill, libigraph), Cvoid, (Ptr{igraph_vector_complex_t}, igraph_complex_t), v, e)
end

function igraph_vector_complex_view(v, data, length)
    ccall((:igraph_vector_complex_view, libigraph), Ptr{igraph_vector_complex_t}, (Ptr{igraph_vector_complex_t}, Ptr{igraph_complex_t}, igraph_integer_t), v, data, length)
end

function igraph_vector_complex_copy_to(v, to)
    ccall((:igraph_vector_complex_copy_to, libigraph), Cvoid, (Ptr{igraph_vector_complex_t}, Ptr{igraph_complex_t}), v, to)
end

function igraph_vector_complex_update(to, from)
    ccall((:igraph_vector_complex_update, libigraph), igraph_error_t, (Ptr{igraph_vector_complex_t}, Ptr{igraph_vector_complex_t}), to, from)
end

function igraph_vector_complex_append(to, from)
    ccall((:igraph_vector_complex_append, libigraph), igraph_error_t, (Ptr{igraph_vector_complex_t}, Ptr{igraph_vector_complex_t}), to, from)
end

function igraph_vector_complex_swap(v1, v2)
    ccall((:igraph_vector_complex_swap, libigraph), igraph_error_t, (Ptr{igraph_vector_complex_t}, Ptr{igraph_vector_complex_t}), v1, v2)
end

function igraph_vector_complex_swap_elements(v, i, j)
    ccall((:igraph_vector_complex_swap_elements, libigraph), igraph_error_t, (Ptr{igraph_vector_complex_t}, igraph_integer_t, igraph_integer_t), v, i, j)
end

function igraph_vector_complex_reverse(v)
    ccall((:igraph_vector_complex_reverse, libigraph), igraph_error_t, (Ptr{igraph_vector_complex_t},), v)
end

function igraph_vector_complex_reverse_section(v, from, to)
    ccall((:igraph_vector_complex_reverse_section, libigraph), Cvoid, (Ptr{igraph_vector_complex_t}, igraph_integer_t, igraph_integer_t), v, from, to)
end

function igraph_vector_complex_rotate_left(v, n)
    ccall((:igraph_vector_complex_rotate_left, libigraph), Cvoid, (Ptr{igraph_vector_complex_t}, igraph_integer_t), v, n)
end

function igraph_vector_complex_permute(v, ind)
    ccall((:igraph_vector_complex_permute, libigraph), igraph_error_t, (Ptr{igraph_vector_complex_t}, Ptr{igraph_vector_int_t}), v, ind)
end

function igraph_vector_complex_shuffle(v)
    ccall((:igraph_vector_complex_shuffle, libigraph), igraph_error_t, (Ptr{igraph_vector_complex_t},), v)
end

function igraph_vector_complex_add_constant(v, plus)
    ccall((:igraph_vector_complex_add_constant, libigraph), Cvoid, (Ptr{igraph_vector_complex_t}, igraph_complex_t), v, plus)
end

function igraph_vector_complex_scale(v, by)
    ccall((:igraph_vector_complex_scale, libigraph), Cvoid, (Ptr{igraph_vector_complex_t}, igraph_complex_t), v, by)
end

function igraph_vector_complex_add(v1, v2)
    ccall((:igraph_vector_complex_add, libigraph), igraph_error_t, (Ptr{igraph_vector_complex_t}, Ptr{igraph_vector_complex_t}), v1, v2)
end

function igraph_vector_complex_sub(v1, v2)
    ccall((:igraph_vector_complex_sub, libigraph), igraph_error_t, (Ptr{igraph_vector_complex_t}, Ptr{igraph_vector_complex_t}), v1, v2)
end

function igraph_vector_complex_mul(v1, v2)
    ccall((:igraph_vector_complex_mul, libigraph), igraph_error_t, (Ptr{igraph_vector_complex_t}, Ptr{igraph_vector_complex_t}), v1, v2)
end

function igraph_vector_complex_div(v1, v2)
    ccall((:igraph_vector_complex_div, libigraph), igraph_error_t, (Ptr{igraph_vector_complex_t}, Ptr{igraph_vector_complex_t}), v1, v2)
end

function igraph_vector_complex_cumsum(to, from)
    ccall((:igraph_vector_complex_cumsum, libigraph), igraph_error_t, (Ptr{igraph_vector_complex_t}, Ptr{igraph_vector_complex_t}), to, from)
end

function igraph_vector_complex_all_e(lhs, rhs)
    ccall((:igraph_vector_complex_all_e, libigraph), igraph_bool_t, (Ptr{igraph_vector_complex_t}, Ptr{igraph_vector_complex_t}), lhs, rhs)
end

function igraph_vector_complex_empty(v)
    ccall((:igraph_vector_complex_empty, libigraph), igraph_bool_t, (Ptr{igraph_vector_complex_t},), v)
end

function igraph_vector_complex_size(v)
    ccall((:igraph_vector_complex_size, libigraph), igraph_integer_t, (Ptr{igraph_vector_complex_t},), v)
end

function igraph_vector_complex_isnull(v)
    ccall((:igraph_vector_complex_isnull, libigraph), igraph_bool_t, (Ptr{igraph_vector_complex_t},), v)
end

function igraph_vector_complex_sum(v)
    ccall((:igraph_vector_complex_sum, libigraph), igraph_complex_t, (Ptr{igraph_vector_complex_t},), v)
end

function igraph_vector_complex_sumsq(v)
    ccall((:igraph_vector_complex_sumsq, libigraph), igraph_real_t, (Ptr{igraph_vector_complex_t},), v)
end

function igraph_vector_complex_prod(v)
    ccall((:igraph_vector_complex_prod, libigraph), igraph_complex_t, (Ptr{igraph_vector_complex_t},), v)
end

function igraph_vector_complex_is_equal(lhs, rhs)
    ccall((:igraph_vector_complex_is_equal, libigraph), igraph_bool_t, (Ptr{igraph_vector_complex_t}, Ptr{igraph_vector_complex_t}), lhs, rhs)
end

function igraph_vector_complex_contains(v, e)
    ccall((:igraph_vector_complex_contains, libigraph), igraph_bool_t, (Ptr{igraph_vector_complex_t}, igraph_complex_t), v, e)
end

function igraph_vector_complex_search(v, from, what, pos)
    ccall((:igraph_vector_complex_search, libigraph), igraph_bool_t, (Ptr{igraph_vector_complex_t}, igraph_integer_t, igraph_complex_t, Ptr{igraph_integer_t}), v, from, what, pos)
end

function igraph_vector_complex_clear(v)
    ccall((:igraph_vector_complex_clear, libigraph), Cvoid, (Ptr{igraph_vector_complex_t},), v)
end

function igraph_vector_complex_resize(v, new_size)
    ccall((:igraph_vector_complex_resize, libigraph), igraph_error_t, (Ptr{igraph_vector_complex_t}, igraph_integer_t), v, new_size)
end

function igraph_vector_complex_resize_min(v)
    ccall((:igraph_vector_complex_resize_min, libigraph), Cvoid, (Ptr{igraph_vector_complex_t},), v)
end

function igraph_vector_complex_reserve(v, capacity)
    ccall((:igraph_vector_complex_reserve, libigraph), igraph_error_t, (Ptr{igraph_vector_complex_t}, igraph_integer_t), v, capacity)
end

function igraph_vector_complex_push_back(v, e)
    ccall((:igraph_vector_complex_push_back, libigraph), igraph_error_t, (Ptr{igraph_vector_complex_t}, igraph_complex_t), v, e)
end

function igraph_vector_complex_pop_back(v)
    ccall((:igraph_vector_complex_pop_back, libigraph), igraph_complex_t, (Ptr{igraph_vector_complex_t},), v)
end

function igraph_vector_complex_insert(v, pos, value)
    ccall((:igraph_vector_complex_insert, libigraph), igraph_error_t, (Ptr{igraph_vector_complex_t}, igraph_integer_t, igraph_complex_t), v, pos, value)
end

function igraph_vector_complex_remove(v, elem)
    ccall((:igraph_vector_complex_remove, libigraph), Cvoid, (Ptr{igraph_vector_complex_t}, igraph_integer_t), v, elem)
end

function igraph_vector_complex_remove_fast(v, elem)
    ccall((:igraph_vector_complex_remove_fast, libigraph), Cvoid, (Ptr{igraph_vector_complex_t}, igraph_integer_t), v, elem)
end

function igraph_vector_complex_remove_section(v, from, to)
    ccall((:igraph_vector_complex_remove_section, libigraph), Cvoid, (Ptr{igraph_vector_complex_t}, igraph_integer_t, igraph_integer_t), v, from, to)
end

function igraph_vector_complex_print(v)
    ccall((:igraph_vector_complex_print, libigraph), igraph_error_t, (Ptr{igraph_vector_complex_t},), v)
end

function igraph_vector_complex_fprint(v, file)
    ccall((:igraph_vector_complex_fprint, libigraph), igraph_error_t, (Ptr{igraph_vector_complex_t}, Ptr{Libc.FILE}), v, file)
end

function igraph_vector_complex_real(v, real)
    ccall((:igraph_vector_complex_real, libigraph), igraph_error_t, (Ptr{igraph_vector_complex_t}, Ptr{igraph_vector_t}), v, real)
end

function igraph_vector_complex_imag(v, imag)
    ccall((:igraph_vector_complex_imag, libigraph), igraph_error_t, (Ptr{igraph_vector_complex_t}, Ptr{igraph_vector_t}), v, imag)
end

function igraph_vector_complex_realimag(v, real, imag)
    ccall((:igraph_vector_complex_realimag, libigraph), igraph_error_t, (Ptr{igraph_vector_complex_t}, Ptr{igraph_vector_t}, Ptr{igraph_vector_t}), v, real, imag)
end

function igraph_vector_complex_create(v, real, imag)
    ccall((:igraph_vector_complex_create, libigraph), igraph_error_t, (Ptr{igraph_vector_complex_t}, Ptr{igraph_vector_t}, Ptr{igraph_vector_t}), v, real, imag)
end

function igraph_vector_complex_create_polar(v, r, theta)
    ccall((:igraph_vector_complex_create_polar, libigraph), igraph_error_t, (Ptr{igraph_vector_complex_t}, Ptr{igraph_vector_t}, Ptr{igraph_vector_t}), v, r, theta)
end

function igraph_vector_complex_all_almost_e(lhs, rhs, eps)
    ccall((:igraph_vector_complex_all_almost_e, libigraph), igraph_bool_t, (Ptr{igraph_vector_complex_t}, Ptr{igraph_vector_complex_t}, igraph_real_t), lhs, rhs, eps)
end

function igraph_vector_complex_move_interval(v, _begin, _end, to)
    ccall((:igraph_vector_complex_move_interval, libigraph), igraph_error_t, (Ptr{igraph_vector_complex_t}, igraph_integer_t, igraph_integer_t, igraph_integer_t), v, _begin, _end, to)
end

function igraph_vector_complex_move_interval2(v, _begin, _end, to)
    ccall((:igraph_vector_complex_move_interval2, libigraph), igraph_error_t, (Ptr{igraph_vector_complex_t}, igraph_integer_t, igraph_integer_t, igraph_integer_t), v, _begin, _end, to)
end

function igraph_vector_complex_get_interval(v, res, from, to)
    ccall((:igraph_vector_complex_get_interval, libigraph), igraph_error_t, (Ptr{igraph_vector_complex_t}, Ptr{igraph_vector_complex_t}, igraph_integer_t, igraph_integer_t), v, res, from, to)
end

function igraph_vector_complex_index(v, newv, idx)
    ccall((:igraph_vector_complex_index, libigraph), igraph_error_t, (Ptr{igraph_vector_complex_t}, Ptr{igraph_vector_complex_t}, Ptr{igraph_vector_int_t}), v, newv, idx)
end

function igraph_vector_complex_index_int(v, idx)
    ccall((:igraph_vector_complex_index_int, libigraph), igraph_error_t, (Ptr{igraph_vector_complex_t}, Ptr{igraph_vector_int_t}), v, idx)
end

function igraph_vector_floor(from, to)
    ccall((:igraph_vector_floor, libigraph), igraph_error_t, (Ptr{igraph_vector_t}, Ptr{igraph_vector_int_t}), from, to)
end

function igraph_vector_round(from, to)
    ccall((:igraph_vector_round, libigraph), igraph_error_t, (Ptr{igraph_vector_t}, Ptr{igraph_vector_int_t}), from, to)
end

function igraph_vector_e_tol(lhs, rhs, tol)
    ccall((:igraph_vector_e_tol, libigraph), igraph_bool_t, (Ptr{igraph_vector_t}, Ptr{igraph_vector_t}, igraph_real_t), lhs, rhs, tol)
end

function igraph_vector_all_almost_e(lhs, rhs, eps)
    ccall((:igraph_vector_all_almost_e, libigraph), igraph_bool_t, (Ptr{igraph_vector_t}, Ptr{igraph_vector_t}, igraph_real_t), lhs, rhs, eps)
end

function igraph_vector_zapsmall(v, tol)
    ccall((:igraph_vector_zapsmall, libigraph), igraph_error_t, (Ptr{igraph_vector_t}, igraph_real_t), v, tol)
end

function igraph_vector_complex_zapsmall(v, tol)
    ccall((:igraph_vector_complex_zapsmall, libigraph), igraph_error_t, (Ptr{igraph_vector_complex_t}, igraph_real_t), v, tol)
end

function igraph_vector_is_nan(v, is_nan)
    ccall((:igraph_vector_is_nan, libigraph), igraph_error_t, (Ptr{igraph_vector_t}, Ptr{igraph_vector_bool_t}), v, is_nan)
end

function igraph_vector_is_any_nan(v)
    ccall((:igraph_vector_is_any_nan, libigraph), igraph_bool_t, (Ptr{igraph_vector_t},), v)
end

function igraph_vector_is_all_finite(v)
    ccall((:igraph_vector_is_all_finite, libigraph), igraph_bool_t, (Ptr{igraph_vector_t},), v)
end

function igraph_vector_order2(v)
    ccall((:igraph_vector_order2, libigraph), igraph_error_t, (Ptr{igraph_vector_t},), v)
end

function igraph_vector_rank(v, res, nodes)
    ccall((:igraph_vector_rank, libigraph), igraph_error_t, (Ptr{igraph_vector_t}, Ptr{igraph_vector_int_t}, igraph_integer_t), v, res, nodes)
end

function igraph_vector_int_pair_order(v, v2, res, maxval)
    ccall((:igraph_vector_int_pair_order, libigraph), igraph_error_t, (Ptr{igraph_vector_int_t}, Ptr{igraph_vector_int_t}, Ptr{igraph_vector_int_t}, igraph_integer_t), v, v2, res, maxval)
end

function igraph_vector_int_order1(v, res, maxval)
    ccall((:igraph_vector_int_order1, libigraph), igraph_error_t, (Ptr{igraph_vector_int_t}, Ptr{igraph_vector_int_t}, igraph_integer_t), v, res, maxval)
end

function igraph_vector_int_rank(v, res, nodes)
    ccall((:igraph_vector_int_rank, libigraph), igraph_error_t, (Ptr{igraph_vector_int_t}, Ptr{igraph_vector_int_t}, igraph_integer_t), v, res, nodes)
end

function igraph_rng_init(rng, type)
    ccall((:igraph_rng_init, libigraph), igraph_error_t, (Ptr{igraph_rng_t}, Ptr{igraph_rng_type_t}), rng, type)
end

function igraph_rng_destroy(rng)
    ccall((:igraph_rng_destroy, libigraph), Cvoid, (Ptr{igraph_rng_t},), rng)
end

function igraph_rng_bits(rng)
    ccall((:igraph_rng_bits, libigraph), igraph_integer_t, (Ptr{igraph_rng_t},), rng)
end

function igraph_rng_max(rng)
    ccall((:igraph_rng_max, libigraph), igraph_uint_t, (Ptr{igraph_rng_t},), rng)
end

function igraph_rng_name(rng)
    ccall((:igraph_rng_name, libigraph), Ptr{Cchar}, (Ptr{igraph_rng_t},), rng)
end

function igraph_rng_get_dirichlet(rng, alpha, result)
    ccall((:igraph_rng_get_dirichlet, libigraph), igraph_error_t, (Ptr{igraph_rng_t}, Ptr{igraph_vector_t}, Ptr{igraph_vector_t}), rng, alpha, result)
end

function igraph_rng_set_default(rng)
    ccall((:igraph_rng_set_default, libigraph), Cvoid, (Ptr{igraph_rng_t},), rng)
end

# typedef igraph_error_t igraph_progress_handler_t ( const char * message , igraph_real_t percent , void * data )
const igraph_progress_handler_t = Cvoid

function igraph_set_progress_handler(new_handler)
    ccall((:igraph_set_progress_handler, libigraph), Ptr{igraph_progress_handler_t}, (igraph_progress_handler_t,), new_handler)
end

# typedef igraph_error_t igraph_status_handler_t ( const char * message , void * data )
const igraph_status_handler_t = Cvoid

function igraph_set_status_handler(new_handler)
    ccall((:igraph_set_status_handler, libigraph), Ptr{igraph_status_handler_t}, (igraph_status_handler_t,), new_handler)
end

function igraph_matrix_init_array(m, data, nrow, ncol, storage)
    ccall((:igraph_matrix_init_array, libigraph), igraph_error_t, (Ptr{igraph_matrix_t}, Ptr{igraph_real_t}, igraph_integer_t, igraph_integer_t, igraph_matrix_storage_t), m, data, nrow, ncol, storage)
end

function igraph_matrix_init_copy(to, from)
    ccall((:igraph_matrix_init_copy, libigraph), igraph_error_t, (Ptr{igraph_matrix_t}, Ptr{igraph_matrix_t}), to, from)
end

function igraph_matrix_capacity(m)
    ccall((:igraph_matrix_capacity, libigraph), igraph_integer_t, (Ptr{igraph_matrix_t},), m)
end

function igraph_matrix_copy(to, from)
    ccall((:igraph_matrix_copy, libigraph), igraph_error_t, (Ptr{igraph_matrix_t}, Ptr{igraph_matrix_t}), to, from)
end

function igraph_matrix_e(m, row, col)
    ccall((:igraph_matrix_e, libigraph), igraph_real_t, (Ptr{igraph_matrix_t}, igraph_integer_t, igraph_integer_t), m, row, col)
end

function igraph_matrix_e_ptr(m, row, col)
    ccall((:igraph_matrix_e_ptr, libigraph), Ptr{igraph_real_t}, (Ptr{igraph_matrix_t}, igraph_integer_t, igraph_integer_t), m, row, col)
end

function igraph_matrix_get(m, row, col)
    ccall((:igraph_matrix_get, libigraph), igraph_real_t, (Ptr{igraph_matrix_t}, igraph_integer_t, igraph_integer_t), m, row, col)
end

function igraph_matrix_get_ptr(m, row, col)
    ccall((:igraph_matrix_get_ptr, libigraph), Ptr{igraph_real_t}, (Ptr{igraph_matrix_t}, igraph_integer_t, igraph_integer_t), m, row, col)
end

function igraph_matrix_set(m, row, col, value)
    ccall((:igraph_matrix_set, libigraph), Cvoid, (Ptr{igraph_matrix_t}, igraph_integer_t, igraph_integer_t, igraph_real_t), m, row, col, value)
end

function igraph_matrix_null(m)
    ccall((:igraph_matrix_null, libigraph), Cvoid, (Ptr{igraph_matrix_t},), m)
end

function igraph_matrix_fill(m, e)
    ccall((:igraph_matrix_fill, libigraph), Cvoid, (Ptr{igraph_matrix_t}, igraph_real_t), m, e)
end

function igraph_matrix_view(m, data, nrow, ncol)
    ccall((:igraph_matrix_view, libigraph), Ptr{igraph_matrix_t}, (Ptr{igraph_matrix_t}, Ptr{igraph_real_t}, igraph_integer_t, igraph_integer_t), m, data, nrow, ncol)
end

function igraph_matrix_view_from_vector(m, v, ncol)
    ccall((:igraph_matrix_view_from_vector, libigraph), Ptr{igraph_matrix_t}, (Ptr{igraph_matrix_t}, Ptr{igraph_vector_t}, igraph_integer_t), m, v, ncol)
end

function igraph_matrix_copy_to(m, to)
    ccall((:igraph_matrix_copy_to, libigraph), Cvoid, (Ptr{igraph_matrix_t}, Ptr{igraph_real_t}), m, to)
end

function igraph_matrix_update(to, from)
    ccall((:igraph_matrix_update, libigraph), igraph_error_t, (Ptr{igraph_matrix_t}, Ptr{igraph_matrix_t}), to, from)
end

function igraph_matrix_rbind(to, from)
    ccall((:igraph_matrix_rbind, libigraph), igraph_error_t, (Ptr{igraph_matrix_t}, Ptr{igraph_matrix_t}), to, from)
end

function igraph_matrix_cbind(to, from)
    ccall((:igraph_matrix_cbind, libigraph), igraph_error_t, (Ptr{igraph_matrix_t}, Ptr{igraph_matrix_t}), to, from)
end

function igraph_matrix_swap(m1, m2)
    ccall((:igraph_matrix_swap, libigraph), igraph_error_t, (Ptr{igraph_matrix_t}, Ptr{igraph_matrix_t}), m1, m2)
end

function igraph_matrix_get_row(m, res, index)
    ccall((:igraph_matrix_get_row, libigraph), igraph_error_t, (Ptr{igraph_matrix_t}, Ptr{igraph_vector_t}, igraph_integer_t), m, res, index)
end

function igraph_matrix_get_col(m, res, index)
    ccall((:igraph_matrix_get_col, libigraph), igraph_error_t, (Ptr{igraph_matrix_t}, Ptr{igraph_vector_t}, igraph_integer_t), m, res, index)
end

function igraph_matrix_set_row(m, v, index)
    ccall((:igraph_matrix_set_row, libigraph), igraph_error_t, (Ptr{igraph_matrix_t}, Ptr{igraph_vector_t}, igraph_integer_t), m, v, index)
end

function igraph_matrix_set_col(m, v, index)
    ccall((:igraph_matrix_set_col, libigraph), igraph_error_t, (Ptr{igraph_matrix_t}, Ptr{igraph_vector_t}, igraph_integer_t), m, v, index)
end

function igraph_matrix_select_rows(m, res, rows)
    ccall((:igraph_matrix_select_rows, libigraph), igraph_error_t, (Ptr{igraph_matrix_t}, Ptr{igraph_matrix_t}, Ptr{igraph_vector_int_t}), m, res, rows)
end

function igraph_matrix_select_cols(m, res, cols)
    ccall((:igraph_matrix_select_cols, libigraph), igraph_error_t, (Ptr{igraph_matrix_t}, Ptr{igraph_matrix_t}, Ptr{igraph_vector_int_t}), m, res, cols)
end

function igraph_matrix_select_rows_cols(m, res, rows, cols)
    ccall((:igraph_matrix_select_rows_cols, libigraph), igraph_error_t, (Ptr{igraph_matrix_t}, Ptr{igraph_matrix_t}, Ptr{igraph_vector_int_t}, Ptr{igraph_vector_int_t}), m, res, rows, cols)
end

function igraph_matrix_swap_rows(m, i, j)
    ccall((:igraph_matrix_swap_rows, libigraph), igraph_error_t, (Ptr{igraph_matrix_t}, igraph_integer_t, igraph_integer_t), m, i, j)
end

function igraph_matrix_swap_cols(m, i, j)
    ccall((:igraph_matrix_swap_cols, libigraph), igraph_error_t, (Ptr{igraph_matrix_t}, igraph_integer_t, igraph_integer_t), m, i, j)
end

function igraph_matrix_swap_rowcol(m, i, j)
    ccall((:igraph_matrix_swap_rowcol, libigraph), igraph_error_t, (Ptr{igraph_matrix_t}, igraph_integer_t, igraph_integer_t), m, i, j)
end

function igraph_matrix_transpose(m)
    ccall((:igraph_matrix_transpose, libigraph), igraph_error_t, (Ptr{igraph_matrix_t},), m)
end

function igraph_matrix_add(m1, m2)
    ccall((:igraph_matrix_add, libigraph), igraph_error_t, (Ptr{igraph_matrix_t}, Ptr{igraph_matrix_t}), m1, m2)
end

function igraph_matrix_sub(m1, m2)
    ccall((:igraph_matrix_sub, libigraph), igraph_error_t, (Ptr{igraph_matrix_t}, Ptr{igraph_matrix_t}), m1, m2)
end

function igraph_matrix_mul_elements(m1, m2)
    ccall((:igraph_matrix_mul_elements, libigraph), igraph_error_t, (Ptr{igraph_matrix_t}, Ptr{igraph_matrix_t}), m1, m2)
end

function igraph_matrix_div_elements(m1, m2)
    ccall((:igraph_matrix_div_elements, libigraph), igraph_error_t, (Ptr{igraph_matrix_t}, Ptr{igraph_matrix_t}), m1, m2)
end

function igraph_matrix_scale(m, by)
    ccall((:igraph_matrix_scale, libigraph), Cvoid, (Ptr{igraph_matrix_t}, igraph_real_t), m, by)
end

function igraph_matrix_add_constant(m, plus)
    ccall((:igraph_matrix_add_constant, libigraph), Cvoid, (Ptr{igraph_matrix_t}, igraph_real_t), m, plus)
end

function igraph_matrix_min(m)
    ccall((:igraph_matrix_min, libigraph), igraph_real_t, (Ptr{igraph_matrix_t},), m)
end

function igraph_matrix_max(m)
    ccall((:igraph_matrix_max, libigraph), igraph_real_t, (Ptr{igraph_matrix_t},), m)
end

function igraph_matrix_which_min(m, i, j)
    ccall((:igraph_matrix_which_min, libigraph), Cvoid, (Ptr{igraph_matrix_t}, Ptr{igraph_integer_t}, Ptr{igraph_integer_t}), m, i, j)
end

function igraph_matrix_which_max(m, i, j)
    ccall((:igraph_matrix_which_max, libigraph), Cvoid, (Ptr{igraph_matrix_t}, Ptr{igraph_integer_t}, Ptr{igraph_integer_t}), m, i, j)
end

function igraph_matrix_minmax(m, min, max)
    ccall((:igraph_matrix_minmax, libigraph), Cvoid, (Ptr{igraph_matrix_t}, Ptr{igraph_real_t}, Ptr{igraph_real_t}), m, min, max)
end

function igraph_matrix_which_minmax(m, imin, jmin, imax, jmax)
    ccall((:igraph_matrix_which_minmax, libigraph), Cvoid, (Ptr{igraph_matrix_t}, Ptr{igraph_integer_t}, Ptr{igraph_integer_t}, Ptr{igraph_integer_t}, Ptr{igraph_integer_t}), m, imin, jmin, imax, jmax)
end

function igraph_matrix_all_e(lhs, rhs)
    ccall((:igraph_matrix_all_e, libigraph), igraph_bool_t, (Ptr{igraph_matrix_t}, Ptr{igraph_matrix_t}), lhs, rhs)
end

function igraph_matrix_all_l(lhs, rhs)
    ccall((:igraph_matrix_all_l, libigraph), igraph_bool_t, (Ptr{igraph_matrix_t}, Ptr{igraph_matrix_t}), lhs, rhs)
end

function igraph_matrix_all_g(lhs, rhs)
    ccall((:igraph_matrix_all_g, libigraph), igraph_bool_t, (Ptr{igraph_matrix_t}, Ptr{igraph_matrix_t}), lhs, rhs)
end

function igraph_matrix_all_le(lhs, rhs)
    ccall((:igraph_matrix_all_le, libigraph), igraph_bool_t, (Ptr{igraph_matrix_t}, Ptr{igraph_matrix_t}), lhs, rhs)
end

function igraph_matrix_all_ge(lhs, rhs)
    ccall((:igraph_matrix_all_ge, libigraph), igraph_bool_t, (Ptr{igraph_matrix_t}, Ptr{igraph_matrix_t}), lhs, rhs)
end

function igraph_matrix_isnull(m)
    ccall((:igraph_matrix_isnull, libigraph), igraph_bool_t, (Ptr{igraph_matrix_t},), m)
end

function igraph_matrix_empty(m)
    ccall((:igraph_matrix_empty, libigraph), igraph_bool_t, (Ptr{igraph_matrix_t},), m)
end

function igraph_matrix_size(m)
    ccall((:igraph_matrix_size, libigraph), igraph_integer_t, (Ptr{igraph_matrix_t},), m)
end

function igraph_matrix_nrow(m)
    ccall((:igraph_matrix_nrow, libigraph), igraph_integer_t, (Ptr{igraph_matrix_t},), m)
end

function igraph_matrix_ncol(m)
    ccall((:igraph_matrix_ncol, libigraph), igraph_integer_t, (Ptr{igraph_matrix_t},), m)
end

function igraph_matrix_is_symmetric(m)
    ccall((:igraph_matrix_is_symmetric, libigraph), igraph_bool_t, (Ptr{igraph_matrix_t},), m)
end

function igraph_matrix_sum(m)
    ccall((:igraph_matrix_sum, libigraph), igraph_real_t, (Ptr{igraph_matrix_t},), m)
end

function igraph_matrix_prod(m)
    ccall((:igraph_matrix_prod, libigraph), igraph_real_t, (Ptr{igraph_matrix_t},), m)
end

function igraph_matrix_rowsum(m, res)
    ccall((:igraph_matrix_rowsum, libigraph), igraph_error_t, (Ptr{igraph_matrix_t}, Ptr{igraph_vector_t}), m, res)
end

function igraph_matrix_colsum(m, res)
    ccall((:igraph_matrix_colsum, libigraph), igraph_error_t, (Ptr{igraph_matrix_t}, Ptr{igraph_vector_t}), m, res)
end

function igraph_matrix_is_equal(m1, m2)
    ccall((:igraph_matrix_is_equal, libigraph), igraph_bool_t, (Ptr{igraph_matrix_t}, Ptr{igraph_matrix_t}), m1, m2)
end

function igraph_matrix_maxdifference(m1, m2)
    ccall((:igraph_matrix_maxdifference, libigraph), igraph_real_t, (Ptr{igraph_matrix_t}, Ptr{igraph_matrix_t}), m1, m2)
end

function igraph_matrix_contains(m, e)
    ccall((:igraph_matrix_contains, libigraph), igraph_bool_t, (Ptr{igraph_matrix_t}, igraph_real_t), m, e)
end

function igraph_matrix_search(m, from, what, pos, row, col)
    ccall((:igraph_matrix_search, libigraph), igraph_bool_t, (Ptr{igraph_matrix_t}, igraph_integer_t, igraph_real_t, Ptr{igraph_integer_t}, Ptr{igraph_integer_t}, Ptr{igraph_integer_t}), m, from, what, pos, row, col)
end

function igraph_matrix_resize(m, nrow, ncol)
    ccall((:igraph_matrix_resize, libigraph), igraph_error_t, (Ptr{igraph_matrix_t}, igraph_integer_t, igraph_integer_t), m, nrow, ncol)
end

function igraph_matrix_resize_min(m)
    ccall((:igraph_matrix_resize_min, libigraph), Cvoid, (Ptr{igraph_matrix_t},), m)
end

function igraph_matrix_add_cols(m, n)
    ccall((:igraph_matrix_add_cols, libigraph), igraph_error_t, (Ptr{igraph_matrix_t}, igraph_integer_t), m, n)
end

function igraph_matrix_add_rows(m, n)
    ccall((:igraph_matrix_add_rows, libigraph), igraph_error_t, (Ptr{igraph_matrix_t}, igraph_integer_t), m, n)
end

function igraph_matrix_remove_col(m, col)
    ccall((:igraph_matrix_remove_col, libigraph), igraph_error_t, (Ptr{igraph_matrix_t}, igraph_integer_t), m, col)
end

function igraph_matrix_remove_row(m, row)
    ccall((:igraph_matrix_remove_row, libigraph), igraph_error_t, (Ptr{igraph_matrix_t}, igraph_integer_t), m, row)
end

function igraph_matrix_print(m)
    ccall((:igraph_matrix_print, libigraph), igraph_error_t, (Ptr{igraph_matrix_t},), m)
end

function igraph_matrix_fprint(m, file)
    ccall((:igraph_matrix_fprint, libigraph), igraph_error_t, (Ptr{igraph_matrix_t}, Ptr{Libc.FILE}), m, file)
end

function igraph_matrix_printf(m, format)
    ccall((:igraph_matrix_printf, libigraph), igraph_error_t, (Ptr{igraph_matrix_t}, Ptr{Cchar}), m, format)
end

function igraph_matrix_permdelete_rows(m, index, nremove)
    ccall((:igraph_matrix_permdelete_rows, libigraph), igraph_error_t, (Ptr{igraph_matrix_t}, Ptr{igraph_integer_t}, igraph_integer_t), m, index, nremove)
end

function igraph_matrix_int_init_array(m, data, nrow, ncol, storage)
    ccall((:igraph_matrix_int_init_array, libigraph), igraph_error_t, (Ptr{igraph_matrix_int_t}, Ptr{igraph_integer_t}, igraph_integer_t, igraph_integer_t, igraph_matrix_storage_t), m, data, nrow, ncol, storage)
end

function igraph_matrix_int_init_copy(to, from)
    ccall((:igraph_matrix_int_init_copy, libigraph), igraph_error_t, (Ptr{igraph_matrix_int_t}, Ptr{igraph_matrix_int_t}), to, from)
end

function igraph_matrix_int_capacity(m)
    ccall((:igraph_matrix_int_capacity, libigraph), igraph_integer_t, (Ptr{igraph_matrix_int_t},), m)
end

function igraph_matrix_int_copy(to, from)
    ccall((:igraph_matrix_int_copy, libigraph), igraph_error_t, (Ptr{igraph_matrix_int_t}, Ptr{igraph_matrix_int_t}), to, from)
end

function igraph_matrix_int_e(m, row, col)
    ccall((:igraph_matrix_int_e, libigraph), igraph_integer_t, (Ptr{igraph_matrix_int_t}, igraph_integer_t, igraph_integer_t), m, row, col)
end

function igraph_matrix_int_e_ptr(m, row, col)
    ccall((:igraph_matrix_int_e_ptr, libigraph), Ptr{igraph_integer_t}, (Ptr{igraph_matrix_int_t}, igraph_integer_t, igraph_integer_t), m, row, col)
end

function igraph_matrix_int_get(m, row, col)
    ccall((:igraph_matrix_int_get, libigraph), igraph_integer_t, (Ptr{igraph_matrix_int_t}, igraph_integer_t, igraph_integer_t), m, row, col)
end

function igraph_matrix_int_get_ptr(m, row, col)
    ccall((:igraph_matrix_int_get_ptr, libigraph), Ptr{igraph_integer_t}, (Ptr{igraph_matrix_int_t}, igraph_integer_t, igraph_integer_t), m, row, col)
end

function igraph_matrix_int_set(m, row, col, value)
    ccall((:igraph_matrix_int_set, libigraph), Cvoid, (Ptr{igraph_matrix_int_t}, igraph_integer_t, igraph_integer_t, igraph_integer_t), m, row, col, value)
end

function igraph_matrix_int_null(m)
    ccall((:igraph_matrix_int_null, libigraph), Cvoid, (Ptr{igraph_matrix_int_t},), m)
end

function igraph_matrix_int_fill(m, e)
    ccall((:igraph_matrix_int_fill, libigraph), Cvoid, (Ptr{igraph_matrix_int_t}, igraph_integer_t), m, e)
end

function igraph_matrix_int_view(m, data, nrow, ncol)
    ccall((:igraph_matrix_int_view, libigraph), Ptr{igraph_matrix_int_t}, (Ptr{igraph_matrix_int_t}, Ptr{igraph_integer_t}, igraph_integer_t, igraph_integer_t), m, data, nrow, ncol)
end

function igraph_matrix_int_view_from_vector(m, v, ncol)
    ccall((:igraph_matrix_int_view_from_vector, libigraph), Ptr{igraph_matrix_int_t}, (Ptr{igraph_matrix_int_t}, Ptr{igraph_vector_int_t}, igraph_integer_t), m, v, ncol)
end

function igraph_matrix_int_copy_to(m, to)
    ccall((:igraph_matrix_int_copy_to, libigraph), Cvoid, (Ptr{igraph_matrix_int_t}, Ptr{igraph_integer_t}), m, to)
end

function igraph_matrix_int_update(to, from)
    ccall((:igraph_matrix_int_update, libigraph), igraph_error_t, (Ptr{igraph_matrix_int_t}, Ptr{igraph_matrix_int_t}), to, from)
end

function igraph_matrix_int_rbind(to, from)
    ccall((:igraph_matrix_int_rbind, libigraph), igraph_error_t, (Ptr{igraph_matrix_int_t}, Ptr{igraph_matrix_int_t}), to, from)
end

function igraph_matrix_int_cbind(to, from)
    ccall((:igraph_matrix_int_cbind, libigraph), igraph_error_t, (Ptr{igraph_matrix_int_t}, Ptr{igraph_matrix_int_t}), to, from)
end

function igraph_matrix_int_swap(m1, m2)
    ccall((:igraph_matrix_int_swap, libigraph), igraph_error_t, (Ptr{igraph_matrix_int_t}, Ptr{igraph_matrix_int_t}), m1, m2)
end

function igraph_matrix_int_get_row(m, res, index)
    ccall((:igraph_matrix_int_get_row, libigraph), igraph_error_t, (Ptr{igraph_matrix_int_t}, Ptr{igraph_vector_int_t}, igraph_integer_t), m, res, index)
end

function igraph_matrix_int_get_col(m, res, index)
    ccall((:igraph_matrix_int_get_col, libigraph), igraph_error_t, (Ptr{igraph_matrix_int_t}, Ptr{igraph_vector_int_t}, igraph_integer_t), m, res, index)
end

function igraph_matrix_int_set_row(m, v, index)
    ccall((:igraph_matrix_int_set_row, libigraph), igraph_error_t, (Ptr{igraph_matrix_int_t}, Ptr{igraph_vector_int_t}, igraph_integer_t), m, v, index)
end

function igraph_matrix_int_set_col(m, v, index)
    ccall((:igraph_matrix_int_set_col, libigraph), igraph_error_t, (Ptr{igraph_matrix_int_t}, Ptr{igraph_vector_int_t}, igraph_integer_t), m, v, index)
end

function igraph_matrix_int_select_rows(m, res, rows)
    ccall((:igraph_matrix_int_select_rows, libigraph), igraph_error_t, (Ptr{igraph_matrix_int_t}, Ptr{igraph_matrix_int_t}, Ptr{igraph_vector_int_t}), m, res, rows)
end

function igraph_matrix_int_select_cols(m, res, cols)
    ccall((:igraph_matrix_int_select_cols, libigraph), igraph_error_t, (Ptr{igraph_matrix_int_t}, Ptr{igraph_matrix_int_t}, Ptr{igraph_vector_int_t}), m, res, cols)
end

function igraph_matrix_int_select_rows_cols(m, res, rows, cols)
    ccall((:igraph_matrix_int_select_rows_cols, libigraph), igraph_error_t, (Ptr{igraph_matrix_int_t}, Ptr{igraph_matrix_int_t}, Ptr{igraph_vector_int_t}, Ptr{igraph_vector_int_t}), m, res, rows, cols)
end

function igraph_matrix_int_swap_rows(m, i, j)
    ccall((:igraph_matrix_int_swap_rows, libigraph), igraph_error_t, (Ptr{igraph_matrix_int_t}, igraph_integer_t, igraph_integer_t), m, i, j)
end

function igraph_matrix_int_swap_cols(m, i, j)
    ccall((:igraph_matrix_int_swap_cols, libigraph), igraph_error_t, (Ptr{igraph_matrix_int_t}, igraph_integer_t, igraph_integer_t), m, i, j)
end

function igraph_matrix_int_swap_rowcol(m, i, j)
    ccall((:igraph_matrix_int_swap_rowcol, libigraph), igraph_error_t, (Ptr{igraph_matrix_int_t}, igraph_integer_t, igraph_integer_t), m, i, j)
end

function igraph_matrix_int_transpose(m)
    ccall((:igraph_matrix_int_transpose, libigraph), igraph_error_t, (Ptr{igraph_matrix_int_t},), m)
end

function igraph_matrix_int_add(m1, m2)
    ccall((:igraph_matrix_int_add, libigraph), igraph_error_t, (Ptr{igraph_matrix_int_t}, Ptr{igraph_matrix_int_t}), m1, m2)
end

function igraph_matrix_int_sub(m1, m2)
    ccall((:igraph_matrix_int_sub, libigraph), igraph_error_t, (Ptr{igraph_matrix_int_t}, Ptr{igraph_matrix_int_t}), m1, m2)
end

function igraph_matrix_int_mul_elements(m1, m2)
    ccall((:igraph_matrix_int_mul_elements, libigraph), igraph_error_t, (Ptr{igraph_matrix_int_t}, Ptr{igraph_matrix_int_t}), m1, m2)
end

function igraph_matrix_int_div_elements(m1, m2)
    ccall((:igraph_matrix_int_div_elements, libigraph), igraph_error_t, (Ptr{igraph_matrix_int_t}, Ptr{igraph_matrix_int_t}), m1, m2)
end

function igraph_matrix_int_scale(m, by)
    ccall((:igraph_matrix_int_scale, libigraph), Cvoid, (Ptr{igraph_matrix_int_t}, igraph_integer_t), m, by)
end

function igraph_matrix_int_add_constant(m, plus)
    ccall((:igraph_matrix_int_add_constant, libigraph), Cvoid, (Ptr{igraph_matrix_int_t}, igraph_integer_t), m, plus)
end

function igraph_matrix_int_min(m)
    ccall((:igraph_matrix_int_min, libigraph), igraph_real_t, (Ptr{igraph_matrix_int_t},), m)
end

function igraph_matrix_int_max(m)
    ccall((:igraph_matrix_int_max, libigraph), igraph_real_t, (Ptr{igraph_matrix_int_t},), m)
end

function igraph_matrix_int_which_min(m, i, j)
    ccall((:igraph_matrix_int_which_min, libigraph), Cvoid, (Ptr{igraph_matrix_int_t}, Ptr{igraph_integer_t}, Ptr{igraph_integer_t}), m, i, j)
end

function igraph_matrix_int_which_max(m, i, j)
    ccall((:igraph_matrix_int_which_max, libigraph), Cvoid, (Ptr{igraph_matrix_int_t}, Ptr{igraph_integer_t}, Ptr{igraph_integer_t}), m, i, j)
end

function igraph_matrix_int_minmax(m, min, max)
    ccall((:igraph_matrix_int_minmax, libigraph), Cvoid, (Ptr{igraph_matrix_int_t}, Ptr{igraph_integer_t}, Ptr{igraph_integer_t}), m, min, max)
end

function igraph_matrix_int_which_minmax(m, imin, jmin, imax, jmax)
    ccall((:igraph_matrix_int_which_minmax, libigraph), Cvoid, (Ptr{igraph_matrix_int_t}, Ptr{igraph_integer_t}, Ptr{igraph_integer_t}, Ptr{igraph_integer_t}, Ptr{igraph_integer_t}), m, imin, jmin, imax, jmax)
end

function igraph_matrix_int_all_e(lhs, rhs)
    ccall((:igraph_matrix_int_all_e, libigraph), igraph_bool_t, (Ptr{igraph_matrix_int_t}, Ptr{igraph_matrix_int_t}), lhs, rhs)
end

function igraph_matrix_int_all_l(lhs, rhs)
    ccall((:igraph_matrix_int_all_l, libigraph), igraph_bool_t, (Ptr{igraph_matrix_int_t}, Ptr{igraph_matrix_int_t}), lhs, rhs)
end

function igraph_matrix_int_all_g(lhs, rhs)
    ccall((:igraph_matrix_int_all_g, libigraph), igraph_bool_t, (Ptr{igraph_matrix_int_t}, Ptr{igraph_matrix_int_t}), lhs, rhs)
end

function igraph_matrix_int_all_le(lhs, rhs)
    ccall((:igraph_matrix_int_all_le, libigraph), igraph_bool_t, (Ptr{igraph_matrix_int_t}, Ptr{igraph_matrix_int_t}), lhs, rhs)
end

function igraph_matrix_int_all_ge(lhs, rhs)
    ccall((:igraph_matrix_int_all_ge, libigraph), igraph_bool_t, (Ptr{igraph_matrix_int_t}, Ptr{igraph_matrix_int_t}), lhs, rhs)
end

function igraph_matrix_int_isnull(m)
    ccall((:igraph_matrix_int_isnull, libigraph), igraph_bool_t, (Ptr{igraph_matrix_int_t},), m)
end

function igraph_matrix_int_empty(m)
    ccall((:igraph_matrix_int_empty, libigraph), igraph_bool_t, (Ptr{igraph_matrix_int_t},), m)
end

function igraph_matrix_int_size(m)
    ccall((:igraph_matrix_int_size, libigraph), igraph_integer_t, (Ptr{igraph_matrix_int_t},), m)
end

function igraph_matrix_int_nrow(m)
    ccall((:igraph_matrix_int_nrow, libigraph), igraph_integer_t, (Ptr{igraph_matrix_int_t},), m)
end

function igraph_matrix_int_ncol(m)
    ccall((:igraph_matrix_int_ncol, libigraph), igraph_integer_t, (Ptr{igraph_matrix_int_t},), m)
end

function igraph_matrix_int_is_symmetric(m)
    ccall((:igraph_matrix_int_is_symmetric, libigraph), igraph_bool_t, (Ptr{igraph_matrix_int_t},), m)
end

function igraph_matrix_int_sum(m)
    ccall((:igraph_matrix_int_sum, libigraph), igraph_integer_t, (Ptr{igraph_matrix_int_t},), m)
end

function igraph_matrix_int_prod(m)
    ccall((:igraph_matrix_int_prod, libigraph), igraph_integer_t, (Ptr{igraph_matrix_int_t},), m)
end

function igraph_matrix_int_rowsum(m, res)
    ccall((:igraph_matrix_int_rowsum, libigraph), igraph_error_t, (Ptr{igraph_matrix_int_t}, Ptr{igraph_vector_int_t}), m, res)
end

function igraph_matrix_int_colsum(m, res)
    ccall((:igraph_matrix_int_colsum, libigraph), igraph_error_t, (Ptr{igraph_matrix_int_t}, Ptr{igraph_vector_int_t}), m, res)
end

function igraph_matrix_int_is_equal(m1, m2)
    ccall((:igraph_matrix_int_is_equal, libigraph), igraph_bool_t, (Ptr{igraph_matrix_int_t}, Ptr{igraph_matrix_int_t}), m1, m2)
end

function igraph_matrix_int_maxdifference(m1, m2)
    ccall((:igraph_matrix_int_maxdifference, libigraph), igraph_real_t, (Ptr{igraph_matrix_int_t}, Ptr{igraph_matrix_int_t}), m1, m2)
end

function igraph_matrix_int_contains(m, e)
    ccall((:igraph_matrix_int_contains, libigraph), igraph_bool_t, (Ptr{igraph_matrix_int_t}, igraph_integer_t), m, e)
end

function igraph_matrix_int_search(m, from, what, pos, row, col)
    ccall((:igraph_matrix_int_search, libigraph), igraph_bool_t, (Ptr{igraph_matrix_int_t}, igraph_integer_t, igraph_integer_t, Ptr{igraph_integer_t}, Ptr{igraph_integer_t}, Ptr{igraph_integer_t}), m, from, what, pos, row, col)
end

function igraph_matrix_int_resize(m, nrow, ncol)
    ccall((:igraph_matrix_int_resize, libigraph), igraph_error_t, (Ptr{igraph_matrix_int_t}, igraph_integer_t, igraph_integer_t), m, nrow, ncol)
end

function igraph_matrix_int_resize_min(m)
    ccall((:igraph_matrix_int_resize_min, libigraph), Cvoid, (Ptr{igraph_matrix_int_t},), m)
end

function igraph_matrix_int_add_cols(m, n)
    ccall((:igraph_matrix_int_add_cols, libigraph), igraph_error_t, (Ptr{igraph_matrix_int_t}, igraph_integer_t), m, n)
end

function igraph_matrix_int_add_rows(m, n)
    ccall((:igraph_matrix_int_add_rows, libigraph), igraph_error_t, (Ptr{igraph_matrix_int_t}, igraph_integer_t), m, n)
end

function igraph_matrix_int_remove_col(m, col)
    ccall((:igraph_matrix_int_remove_col, libigraph), igraph_error_t, (Ptr{igraph_matrix_int_t}, igraph_integer_t), m, col)
end

function igraph_matrix_int_remove_row(m, row)
    ccall((:igraph_matrix_int_remove_row, libigraph), igraph_error_t, (Ptr{igraph_matrix_int_t}, igraph_integer_t), m, row)
end

function igraph_matrix_int_print(m)
    ccall((:igraph_matrix_int_print, libigraph), igraph_error_t, (Ptr{igraph_matrix_int_t},), m)
end

function igraph_matrix_int_fprint(m, file)
    ccall((:igraph_matrix_int_fprint, libigraph), igraph_error_t, (Ptr{igraph_matrix_int_t}, Ptr{Libc.FILE}), m, file)
end

function igraph_matrix_int_printf(m, format)
    ccall((:igraph_matrix_int_printf, libigraph), igraph_error_t, (Ptr{igraph_matrix_int_t}, Ptr{Cchar}), m, format)
end

function igraph_matrix_int_permdelete_rows(m, index, nremove)
    ccall((:igraph_matrix_int_permdelete_rows, libigraph), igraph_error_t, (Ptr{igraph_matrix_int_t}, Ptr{igraph_integer_t}, igraph_integer_t), m, index, nremove)
end

function igraph_matrix_char_init(m, nrow, ncol)
    ccall((:igraph_matrix_char_init, libigraph), igraph_error_t, (Ptr{igraph_matrix_char_t}, igraph_integer_t, igraph_integer_t), m, nrow, ncol)
end

function igraph_matrix_char_init_array(m, data, nrow, ncol, storage)
    ccall((:igraph_matrix_char_init_array, libigraph), igraph_error_t, (Ptr{igraph_matrix_char_t}, Ptr{Cchar}, igraph_integer_t, igraph_integer_t, igraph_matrix_storage_t), m, data, nrow, ncol, storage)
end

function igraph_matrix_char_init_copy(to, from)
    ccall((:igraph_matrix_char_init_copy, libigraph), igraph_error_t, (Ptr{igraph_matrix_char_t}, Ptr{igraph_matrix_char_t}), to, from)
end

function igraph_matrix_char_destroy(m)
    ccall((:igraph_matrix_char_destroy, libigraph), Cvoid, (Ptr{igraph_matrix_char_t},), m)
end

function igraph_matrix_char_capacity(m)
    ccall((:igraph_matrix_char_capacity, libigraph), igraph_integer_t, (Ptr{igraph_matrix_char_t},), m)
end

function igraph_matrix_char_copy(to, from)
    ccall((:igraph_matrix_char_copy, libigraph), igraph_error_t, (Ptr{igraph_matrix_char_t}, Ptr{igraph_matrix_char_t}), to, from)
end

function igraph_matrix_char_e(m, row, col)
    ccall((:igraph_matrix_char_e, libigraph), Cchar, (Ptr{igraph_matrix_char_t}, igraph_integer_t, igraph_integer_t), m, row, col)
end

function igraph_matrix_char_e_ptr(m, row, col)
    ccall((:igraph_matrix_char_e_ptr, libigraph), Ptr{Cchar}, (Ptr{igraph_matrix_char_t}, igraph_integer_t, igraph_integer_t), m, row, col)
end

function igraph_matrix_char_get(m, row, col)
    ccall((:igraph_matrix_char_get, libigraph), Cchar, (Ptr{igraph_matrix_char_t}, igraph_integer_t, igraph_integer_t), m, row, col)
end

function igraph_matrix_char_get_ptr(m, row, col)
    ccall((:igraph_matrix_char_get_ptr, libigraph), Ptr{Cchar}, (Ptr{igraph_matrix_char_t}, igraph_integer_t, igraph_integer_t), m, row, col)
end

function igraph_matrix_char_set(m, row, col, value)
    ccall((:igraph_matrix_char_set, libigraph), Cvoid, (Ptr{igraph_matrix_char_t}, igraph_integer_t, igraph_integer_t, Cchar), m, row, col, value)
end

function igraph_matrix_char_null(m)
    ccall((:igraph_matrix_char_null, libigraph), Cvoid, (Ptr{igraph_matrix_char_t},), m)
end

function igraph_matrix_char_fill(m, e)
    ccall((:igraph_matrix_char_fill, libigraph), Cvoid, (Ptr{igraph_matrix_char_t}, Cchar), m, e)
end

function igraph_matrix_char_view(m, data, nrow, ncol)
    ccall((:igraph_matrix_char_view, libigraph), Ptr{igraph_matrix_char_t}, (Ptr{igraph_matrix_char_t}, Ptr{Cchar}, igraph_integer_t, igraph_integer_t), m, data, nrow, ncol)
end

function igraph_matrix_char_view_from_vector(m, v, ncol)
    ccall((:igraph_matrix_char_view_from_vector, libigraph), Ptr{igraph_matrix_char_t}, (Ptr{igraph_matrix_char_t}, Ptr{igraph_vector_char_t}, igraph_integer_t), m, v, ncol)
end

function igraph_matrix_char_copy_to(m, to)
    ccall((:igraph_matrix_char_copy_to, libigraph), Cvoid, (Ptr{igraph_matrix_char_t}, Ptr{Cchar}), m, to)
end

function igraph_matrix_char_update(to, from)
    ccall((:igraph_matrix_char_update, libigraph), igraph_error_t, (Ptr{igraph_matrix_char_t}, Ptr{igraph_matrix_char_t}), to, from)
end

function igraph_matrix_char_rbind(to, from)
    ccall((:igraph_matrix_char_rbind, libigraph), igraph_error_t, (Ptr{igraph_matrix_char_t}, Ptr{igraph_matrix_char_t}), to, from)
end

function igraph_matrix_char_cbind(to, from)
    ccall((:igraph_matrix_char_cbind, libigraph), igraph_error_t, (Ptr{igraph_matrix_char_t}, Ptr{igraph_matrix_char_t}), to, from)
end

function igraph_matrix_char_swap(m1, m2)
    ccall((:igraph_matrix_char_swap, libigraph), igraph_error_t, (Ptr{igraph_matrix_char_t}, Ptr{igraph_matrix_char_t}), m1, m2)
end

function igraph_matrix_char_get_row(m, res, index)
    ccall((:igraph_matrix_char_get_row, libigraph), igraph_error_t, (Ptr{igraph_matrix_char_t}, Ptr{igraph_vector_char_t}, igraph_integer_t), m, res, index)
end

function igraph_matrix_char_get_col(m, res, index)
    ccall((:igraph_matrix_char_get_col, libigraph), igraph_error_t, (Ptr{igraph_matrix_char_t}, Ptr{igraph_vector_char_t}, igraph_integer_t), m, res, index)
end

function igraph_matrix_char_set_row(m, v, index)
    ccall((:igraph_matrix_char_set_row, libigraph), igraph_error_t, (Ptr{igraph_matrix_char_t}, Ptr{igraph_vector_char_t}, igraph_integer_t), m, v, index)
end

function igraph_matrix_char_set_col(m, v, index)
    ccall((:igraph_matrix_char_set_col, libigraph), igraph_error_t, (Ptr{igraph_matrix_char_t}, Ptr{igraph_vector_char_t}, igraph_integer_t), m, v, index)
end

function igraph_matrix_char_select_rows(m, res, rows)
    ccall((:igraph_matrix_char_select_rows, libigraph), igraph_error_t, (Ptr{igraph_matrix_char_t}, Ptr{igraph_matrix_char_t}, Ptr{igraph_vector_int_t}), m, res, rows)
end

function igraph_matrix_char_select_cols(m, res, cols)
    ccall((:igraph_matrix_char_select_cols, libigraph), igraph_error_t, (Ptr{igraph_matrix_char_t}, Ptr{igraph_matrix_char_t}, Ptr{igraph_vector_int_t}), m, res, cols)
end

function igraph_matrix_char_select_rows_cols(m, res, rows, cols)
    ccall((:igraph_matrix_char_select_rows_cols, libigraph), igraph_error_t, (Ptr{igraph_matrix_char_t}, Ptr{igraph_matrix_char_t}, Ptr{igraph_vector_int_t}, Ptr{igraph_vector_int_t}), m, res, rows, cols)
end

function igraph_matrix_char_swap_rows(m, i, j)
    ccall((:igraph_matrix_char_swap_rows, libigraph), igraph_error_t, (Ptr{igraph_matrix_char_t}, igraph_integer_t, igraph_integer_t), m, i, j)
end

function igraph_matrix_char_swap_cols(m, i, j)
    ccall((:igraph_matrix_char_swap_cols, libigraph), igraph_error_t, (Ptr{igraph_matrix_char_t}, igraph_integer_t, igraph_integer_t), m, i, j)
end

function igraph_matrix_char_swap_rowcol(m, i, j)
    ccall((:igraph_matrix_char_swap_rowcol, libigraph), igraph_error_t, (Ptr{igraph_matrix_char_t}, igraph_integer_t, igraph_integer_t), m, i, j)
end

function igraph_matrix_char_transpose(m)
    ccall((:igraph_matrix_char_transpose, libigraph), igraph_error_t, (Ptr{igraph_matrix_char_t},), m)
end

function igraph_matrix_char_add(m1, m2)
    ccall((:igraph_matrix_char_add, libigraph), igraph_error_t, (Ptr{igraph_matrix_char_t}, Ptr{igraph_matrix_char_t}), m1, m2)
end

function igraph_matrix_char_sub(m1, m2)
    ccall((:igraph_matrix_char_sub, libigraph), igraph_error_t, (Ptr{igraph_matrix_char_t}, Ptr{igraph_matrix_char_t}), m1, m2)
end

function igraph_matrix_char_mul_elements(m1, m2)
    ccall((:igraph_matrix_char_mul_elements, libigraph), igraph_error_t, (Ptr{igraph_matrix_char_t}, Ptr{igraph_matrix_char_t}), m1, m2)
end

function igraph_matrix_char_div_elements(m1, m2)
    ccall((:igraph_matrix_char_div_elements, libigraph), igraph_error_t, (Ptr{igraph_matrix_char_t}, Ptr{igraph_matrix_char_t}), m1, m2)
end

function igraph_matrix_char_scale(m, by)
    ccall((:igraph_matrix_char_scale, libigraph), Cvoid, (Ptr{igraph_matrix_char_t}, Cchar), m, by)
end

function igraph_matrix_char_add_constant(m, plus)
    ccall((:igraph_matrix_char_add_constant, libigraph), Cvoid, (Ptr{igraph_matrix_char_t}, Cchar), m, plus)
end

function igraph_matrix_char_min(m)
    ccall((:igraph_matrix_char_min, libigraph), igraph_real_t, (Ptr{igraph_matrix_char_t},), m)
end

function igraph_matrix_char_max(m)
    ccall((:igraph_matrix_char_max, libigraph), igraph_real_t, (Ptr{igraph_matrix_char_t},), m)
end

function igraph_matrix_char_which_min(m, i, j)
    ccall((:igraph_matrix_char_which_min, libigraph), Cvoid, (Ptr{igraph_matrix_char_t}, Ptr{igraph_integer_t}, Ptr{igraph_integer_t}), m, i, j)
end

function igraph_matrix_char_which_max(m, i, j)
    ccall((:igraph_matrix_char_which_max, libigraph), Cvoid, (Ptr{igraph_matrix_char_t}, Ptr{igraph_integer_t}, Ptr{igraph_integer_t}), m, i, j)
end

function igraph_matrix_char_minmax(m, min, max)
    ccall((:igraph_matrix_char_minmax, libigraph), Cvoid, (Ptr{igraph_matrix_char_t}, Ptr{Cchar}, Ptr{Cchar}), m, min, max)
end

function igraph_matrix_char_which_minmax(m, imin, jmin, imax, jmax)
    ccall((:igraph_matrix_char_which_minmax, libigraph), Cvoid, (Ptr{igraph_matrix_char_t}, Ptr{igraph_integer_t}, Ptr{igraph_integer_t}, Ptr{igraph_integer_t}, Ptr{igraph_integer_t}), m, imin, jmin, imax, jmax)
end

function igraph_matrix_char_all_e(lhs, rhs)
    ccall((:igraph_matrix_char_all_e, libigraph), igraph_bool_t, (Ptr{igraph_matrix_char_t}, Ptr{igraph_matrix_char_t}), lhs, rhs)
end

function igraph_matrix_char_all_l(lhs, rhs)
    ccall((:igraph_matrix_char_all_l, libigraph), igraph_bool_t, (Ptr{igraph_matrix_char_t}, Ptr{igraph_matrix_char_t}), lhs, rhs)
end

function igraph_matrix_char_all_g(lhs, rhs)
    ccall((:igraph_matrix_char_all_g, libigraph), igraph_bool_t, (Ptr{igraph_matrix_char_t}, Ptr{igraph_matrix_char_t}), lhs, rhs)
end

function igraph_matrix_char_all_le(lhs, rhs)
    ccall((:igraph_matrix_char_all_le, libigraph), igraph_bool_t, (Ptr{igraph_matrix_char_t}, Ptr{igraph_matrix_char_t}), lhs, rhs)
end

function igraph_matrix_char_all_ge(lhs, rhs)
    ccall((:igraph_matrix_char_all_ge, libigraph), igraph_bool_t, (Ptr{igraph_matrix_char_t}, Ptr{igraph_matrix_char_t}), lhs, rhs)
end

function igraph_matrix_char_isnull(m)
    ccall((:igraph_matrix_char_isnull, libigraph), igraph_bool_t, (Ptr{igraph_matrix_char_t},), m)
end

function igraph_matrix_char_empty(m)
    ccall((:igraph_matrix_char_empty, libigraph), igraph_bool_t, (Ptr{igraph_matrix_char_t},), m)
end

function igraph_matrix_char_size(m)
    ccall((:igraph_matrix_char_size, libigraph), igraph_integer_t, (Ptr{igraph_matrix_char_t},), m)
end

function igraph_matrix_char_nrow(m)
    ccall((:igraph_matrix_char_nrow, libigraph), igraph_integer_t, (Ptr{igraph_matrix_char_t},), m)
end

function igraph_matrix_char_ncol(m)
    ccall((:igraph_matrix_char_ncol, libigraph), igraph_integer_t, (Ptr{igraph_matrix_char_t},), m)
end

function igraph_matrix_char_is_symmetric(m)
    ccall((:igraph_matrix_char_is_symmetric, libigraph), igraph_bool_t, (Ptr{igraph_matrix_char_t},), m)
end

function igraph_matrix_char_sum(m)
    ccall((:igraph_matrix_char_sum, libigraph), Cchar, (Ptr{igraph_matrix_char_t},), m)
end

function igraph_matrix_char_prod(m)
    ccall((:igraph_matrix_char_prod, libigraph), Cchar, (Ptr{igraph_matrix_char_t},), m)
end

function igraph_matrix_char_rowsum(m, res)
    ccall((:igraph_matrix_char_rowsum, libigraph), igraph_error_t, (Ptr{igraph_matrix_char_t}, Ptr{igraph_vector_char_t}), m, res)
end

function igraph_matrix_char_colsum(m, res)
    ccall((:igraph_matrix_char_colsum, libigraph), igraph_error_t, (Ptr{igraph_matrix_char_t}, Ptr{igraph_vector_char_t}), m, res)
end

function igraph_matrix_char_is_equal(m1, m2)
    ccall((:igraph_matrix_char_is_equal, libigraph), igraph_bool_t, (Ptr{igraph_matrix_char_t}, Ptr{igraph_matrix_char_t}), m1, m2)
end

function igraph_matrix_char_maxdifference(m1, m2)
    ccall((:igraph_matrix_char_maxdifference, libigraph), igraph_real_t, (Ptr{igraph_matrix_char_t}, Ptr{igraph_matrix_char_t}), m1, m2)
end

function igraph_matrix_char_contains(m, e)
    ccall((:igraph_matrix_char_contains, libigraph), igraph_bool_t, (Ptr{igraph_matrix_char_t}, Cchar), m, e)
end

function igraph_matrix_char_search(m, from, what, pos, row, col)
    ccall((:igraph_matrix_char_search, libigraph), igraph_bool_t, (Ptr{igraph_matrix_char_t}, igraph_integer_t, Cchar, Ptr{igraph_integer_t}, Ptr{igraph_integer_t}, Ptr{igraph_integer_t}), m, from, what, pos, row, col)
end

function igraph_matrix_char_resize(m, nrow, ncol)
    ccall((:igraph_matrix_char_resize, libigraph), igraph_error_t, (Ptr{igraph_matrix_char_t}, igraph_integer_t, igraph_integer_t), m, nrow, ncol)
end

function igraph_matrix_char_resize_min(m)
    ccall((:igraph_matrix_char_resize_min, libigraph), Cvoid, (Ptr{igraph_matrix_char_t},), m)
end

function igraph_matrix_char_add_cols(m, n)
    ccall((:igraph_matrix_char_add_cols, libigraph), igraph_error_t, (Ptr{igraph_matrix_char_t}, igraph_integer_t), m, n)
end

function igraph_matrix_char_add_rows(m, n)
    ccall((:igraph_matrix_char_add_rows, libigraph), igraph_error_t, (Ptr{igraph_matrix_char_t}, igraph_integer_t), m, n)
end

function igraph_matrix_char_remove_col(m, col)
    ccall((:igraph_matrix_char_remove_col, libigraph), igraph_error_t, (Ptr{igraph_matrix_char_t}, igraph_integer_t), m, col)
end

function igraph_matrix_char_remove_row(m, row)
    ccall((:igraph_matrix_char_remove_row, libigraph), igraph_error_t, (Ptr{igraph_matrix_char_t}, igraph_integer_t), m, row)
end

function igraph_matrix_char_print(m)
    ccall((:igraph_matrix_char_print, libigraph), igraph_error_t, (Ptr{igraph_matrix_char_t},), m)
end

function igraph_matrix_char_fprint(m, file)
    ccall((:igraph_matrix_char_fprint, libigraph), igraph_error_t, (Ptr{igraph_matrix_char_t}, Ptr{Libc.FILE}), m, file)
end

function igraph_matrix_char_printf(m, format)
    ccall((:igraph_matrix_char_printf, libigraph), igraph_error_t, (Ptr{igraph_matrix_char_t}, Ptr{Cchar}), m, format)
end

function igraph_matrix_char_permdelete_rows(m, index, nremove)
    ccall((:igraph_matrix_char_permdelete_rows, libigraph), igraph_error_t, (Ptr{igraph_matrix_char_t}, Ptr{igraph_integer_t}, igraph_integer_t), m, index, nremove)
end

function igraph_matrix_bool_init(m, nrow, ncol)
    ccall((:igraph_matrix_bool_init, libigraph), igraph_error_t, (Ptr{igraph_matrix_bool_t}, igraph_integer_t, igraph_integer_t), m, nrow, ncol)
end

function igraph_matrix_bool_init_array(m, data, nrow, ncol, storage)
    ccall((:igraph_matrix_bool_init_array, libigraph), igraph_error_t, (Ptr{igraph_matrix_bool_t}, Ptr{igraph_bool_t}, igraph_integer_t, igraph_integer_t, igraph_matrix_storage_t), m, data, nrow, ncol, storage)
end

function igraph_matrix_bool_init_copy(to, from)
    ccall((:igraph_matrix_bool_init_copy, libigraph), igraph_error_t, (Ptr{igraph_matrix_bool_t}, Ptr{igraph_matrix_bool_t}), to, from)
end

function igraph_matrix_bool_destroy(m)
    ccall((:igraph_matrix_bool_destroy, libigraph), Cvoid, (Ptr{igraph_matrix_bool_t},), m)
end

function igraph_matrix_bool_capacity(m)
    ccall((:igraph_matrix_bool_capacity, libigraph), igraph_integer_t, (Ptr{igraph_matrix_bool_t},), m)
end

function igraph_matrix_bool_copy(to, from)
    ccall((:igraph_matrix_bool_copy, libigraph), igraph_error_t, (Ptr{igraph_matrix_bool_t}, Ptr{igraph_matrix_bool_t}), to, from)
end

function igraph_matrix_bool_e(m, row, col)
    ccall((:igraph_matrix_bool_e, libigraph), igraph_bool_t, (Ptr{igraph_matrix_bool_t}, igraph_integer_t, igraph_integer_t), m, row, col)
end

function igraph_matrix_bool_e_ptr(m, row, col)
    ccall((:igraph_matrix_bool_e_ptr, libigraph), Ptr{igraph_bool_t}, (Ptr{igraph_matrix_bool_t}, igraph_integer_t, igraph_integer_t), m, row, col)
end

function igraph_matrix_bool_get(m, row, col)
    ccall((:igraph_matrix_bool_get, libigraph), igraph_bool_t, (Ptr{igraph_matrix_bool_t}, igraph_integer_t, igraph_integer_t), m, row, col)
end

function igraph_matrix_bool_get_ptr(m, row, col)
    ccall((:igraph_matrix_bool_get_ptr, libigraph), Ptr{igraph_bool_t}, (Ptr{igraph_matrix_bool_t}, igraph_integer_t, igraph_integer_t), m, row, col)
end

function igraph_matrix_bool_set(m, row, col, value)
    ccall((:igraph_matrix_bool_set, libigraph), Cvoid, (Ptr{igraph_matrix_bool_t}, igraph_integer_t, igraph_integer_t, igraph_bool_t), m, row, col, value)
end

function igraph_matrix_bool_null(m)
    ccall((:igraph_matrix_bool_null, libigraph), Cvoid, (Ptr{igraph_matrix_bool_t},), m)
end

function igraph_matrix_bool_fill(m, e)
    ccall((:igraph_matrix_bool_fill, libigraph), Cvoid, (Ptr{igraph_matrix_bool_t}, igraph_bool_t), m, e)
end

function igraph_matrix_bool_view(m, data, nrow, ncol)
    ccall((:igraph_matrix_bool_view, libigraph), Ptr{igraph_matrix_bool_t}, (Ptr{igraph_matrix_bool_t}, Ptr{igraph_bool_t}, igraph_integer_t, igraph_integer_t), m, data, nrow, ncol)
end

function igraph_matrix_bool_view_from_vector(m, v, ncol)
    ccall((:igraph_matrix_bool_view_from_vector, libigraph), Ptr{igraph_matrix_bool_t}, (Ptr{igraph_matrix_bool_t}, Ptr{igraph_vector_bool_t}, igraph_integer_t), m, v, ncol)
end

function igraph_matrix_bool_copy_to(m, to)
    ccall((:igraph_matrix_bool_copy_to, libigraph), Cvoid, (Ptr{igraph_matrix_bool_t}, Ptr{igraph_bool_t}), m, to)
end

function igraph_matrix_bool_update(to, from)
    ccall((:igraph_matrix_bool_update, libigraph), igraph_error_t, (Ptr{igraph_matrix_bool_t}, Ptr{igraph_matrix_bool_t}), to, from)
end

function igraph_matrix_bool_rbind(to, from)
    ccall((:igraph_matrix_bool_rbind, libigraph), igraph_error_t, (Ptr{igraph_matrix_bool_t}, Ptr{igraph_matrix_bool_t}), to, from)
end

function igraph_matrix_bool_cbind(to, from)
    ccall((:igraph_matrix_bool_cbind, libigraph), igraph_error_t, (Ptr{igraph_matrix_bool_t}, Ptr{igraph_matrix_bool_t}), to, from)
end

function igraph_matrix_bool_swap(m1, m2)
    ccall((:igraph_matrix_bool_swap, libigraph), igraph_error_t, (Ptr{igraph_matrix_bool_t}, Ptr{igraph_matrix_bool_t}), m1, m2)
end

function igraph_matrix_bool_get_row(m, res, index)
    ccall((:igraph_matrix_bool_get_row, libigraph), igraph_error_t, (Ptr{igraph_matrix_bool_t}, Ptr{igraph_vector_bool_t}, igraph_integer_t), m, res, index)
end

function igraph_matrix_bool_get_col(m, res, index)
    ccall((:igraph_matrix_bool_get_col, libigraph), igraph_error_t, (Ptr{igraph_matrix_bool_t}, Ptr{igraph_vector_bool_t}, igraph_integer_t), m, res, index)
end

function igraph_matrix_bool_set_row(m, v, index)
    ccall((:igraph_matrix_bool_set_row, libigraph), igraph_error_t, (Ptr{igraph_matrix_bool_t}, Ptr{igraph_vector_bool_t}, igraph_integer_t), m, v, index)
end

function igraph_matrix_bool_set_col(m, v, index)
    ccall((:igraph_matrix_bool_set_col, libigraph), igraph_error_t, (Ptr{igraph_matrix_bool_t}, Ptr{igraph_vector_bool_t}, igraph_integer_t), m, v, index)
end

function igraph_matrix_bool_select_rows(m, res, rows)
    ccall((:igraph_matrix_bool_select_rows, libigraph), igraph_error_t, (Ptr{igraph_matrix_bool_t}, Ptr{igraph_matrix_bool_t}, Ptr{igraph_vector_int_t}), m, res, rows)
end

function igraph_matrix_bool_select_cols(m, res, cols)
    ccall((:igraph_matrix_bool_select_cols, libigraph), igraph_error_t, (Ptr{igraph_matrix_bool_t}, Ptr{igraph_matrix_bool_t}, Ptr{igraph_vector_int_t}), m, res, cols)
end

function igraph_matrix_bool_select_rows_cols(m, res, rows, cols)
    ccall((:igraph_matrix_bool_select_rows_cols, libigraph), igraph_error_t, (Ptr{igraph_matrix_bool_t}, Ptr{igraph_matrix_bool_t}, Ptr{igraph_vector_int_t}, Ptr{igraph_vector_int_t}), m, res, rows, cols)
end

function igraph_matrix_bool_swap_rows(m, i, j)
    ccall((:igraph_matrix_bool_swap_rows, libigraph), igraph_error_t, (Ptr{igraph_matrix_bool_t}, igraph_integer_t, igraph_integer_t), m, i, j)
end

function igraph_matrix_bool_swap_cols(m, i, j)
    ccall((:igraph_matrix_bool_swap_cols, libigraph), igraph_error_t, (Ptr{igraph_matrix_bool_t}, igraph_integer_t, igraph_integer_t), m, i, j)
end

function igraph_matrix_bool_swap_rowcol(m, i, j)
    ccall((:igraph_matrix_bool_swap_rowcol, libigraph), igraph_error_t, (Ptr{igraph_matrix_bool_t}, igraph_integer_t, igraph_integer_t), m, i, j)
end

function igraph_matrix_bool_transpose(m)
    ccall((:igraph_matrix_bool_transpose, libigraph), igraph_error_t, (Ptr{igraph_matrix_bool_t},), m)
end

function igraph_matrix_bool_add(m1, m2)
    ccall((:igraph_matrix_bool_add, libigraph), igraph_error_t, (Ptr{igraph_matrix_bool_t}, Ptr{igraph_matrix_bool_t}), m1, m2)
end

function igraph_matrix_bool_sub(m1, m2)
    ccall((:igraph_matrix_bool_sub, libigraph), igraph_error_t, (Ptr{igraph_matrix_bool_t}, Ptr{igraph_matrix_bool_t}), m1, m2)
end

function igraph_matrix_bool_mul_elements(m1, m2)
    ccall((:igraph_matrix_bool_mul_elements, libigraph), igraph_error_t, (Ptr{igraph_matrix_bool_t}, Ptr{igraph_matrix_bool_t}), m1, m2)
end

function igraph_matrix_bool_div_elements(m1, m2)
    ccall((:igraph_matrix_bool_div_elements, libigraph), igraph_error_t, (Ptr{igraph_matrix_bool_t}, Ptr{igraph_matrix_bool_t}), m1, m2)
end

function igraph_matrix_bool_scale(m, by)
    ccall((:igraph_matrix_bool_scale, libigraph), Cvoid, (Ptr{igraph_matrix_bool_t}, igraph_bool_t), m, by)
end

function igraph_matrix_bool_add_constant(m, plus)
    ccall((:igraph_matrix_bool_add_constant, libigraph), Cvoid, (Ptr{igraph_matrix_bool_t}, igraph_bool_t), m, plus)
end

function igraph_matrix_bool_all_e(lhs, rhs)
    ccall((:igraph_matrix_bool_all_e, libigraph), igraph_bool_t, (Ptr{igraph_matrix_bool_t}, Ptr{igraph_matrix_bool_t}), lhs, rhs)
end

function igraph_matrix_bool_isnull(m)
    ccall((:igraph_matrix_bool_isnull, libigraph), igraph_bool_t, (Ptr{igraph_matrix_bool_t},), m)
end

function igraph_matrix_bool_empty(m)
    ccall((:igraph_matrix_bool_empty, libigraph), igraph_bool_t, (Ptr{igraph_matrix_bool_t},), m)
end

function igraph_matrix_bool_size(m)
    ccall((:igraph_matrix_bool_size, libigraph), igraph_integer_t, (Ptr{igraph_matrix_bool_t},), m)
end

function igraph_matrix_bool_nrow(m)
    ccall((:igraph_matrix_bool_nrow, libigraph), igraph_integer_t, (Ptr{igraph_matrix_bool_t},), m)
end

function igraph_matrix_bool_ncol(m)
    ccall((:igraph_matrix_bool_ncol, libigraph), igraph_integer_t, (Ptr{igraph_matrix_bool_t},), m)
end

function igraph_matrix_bool_is_symmetric(m)
    ccall((:igraph_matrix_bool_is_symmetric, libigraph), igraph_bool_t, (Ptr{igraph_matrix_bool_t},), m)
end

function igraph_matrix_bool_sum(m)
    ccall((:igraph_matrix_bool_sum, libigraph), igraph_bool_t, (Ptr{igraph_matrix_bool_t},), m)
end

function igraph_matrix_bool_prod(m)
    ccall((:igraph_matrix_bool_prod, libigraph), igraph_bool_t, (Ptr{igraph_matrix_bool_t},), m)
end

function igraph_matrix_bool_rowsum(m, res)
    ccall((:igraph_matrix_bool_rowsum, libigraph), igraph_error_t, (Ptr{igraph_matrix_bool_t}, Ptr{igraph_vector_bool_t}), m, res)
end

function igraph_matrix_bool_colsum(m, res)
    ccall((:igraph_matrix_bool_colsum, libigraph), igraph_error_t, (Ptr{igraph_matrix_bool_t}, Ptr{igraph_vector_bool_t}), m, res)
end

function igraph_matrix_bool_is_equal(m1, m2)
    ccall((:igraph_matrix_bool_is_equal, libigraph), igraph_bool_t, (Ptr{igraph_matrix_bool_t}, Ptr{igraph_matrix_bool_t}), m1, m2)
end

function igraph_matrix_bool_contains(m, e)
    ccall((:igraph_matrix_bool_contains, libigraph), igraph_bool_t, (Ptr{igraph_matrix_bool_t}, igraph_bool_t), m, e)
end

function igraph_matrix_bool_search(m, from, what, pos, row, col)
    ccall((:igraph_matrix_bool_search, libigraph), igraph_bool_t, (Ptr{igraph_matrix_bool_t}, igraph_integer_t, igraph_bool_t, Ptr{igraph_integer_t}, Ptr{igraph_integer_t}, Ptr{igraph_integer_t}), m, from, what, pos, row, col)
end

function igraph_matrix_bool_resize(m, nrow, ncol)
    ccall((:igraph_matrix_bool_resize, libigraph), igraph_error_t, (Ptr{igraph_matrix_bool_t}, igraph_integer_t, igraph_integer_t), m, nrow, ncol)
end

function igraph_matrix_bool_resize_min(m)
    ccall((:igraph_matrix_bool_resize_min, libigraph), Cvoid, (Ptr{igraph_matrix_bool_t},), m)
end

function igraph_matrix_bool_add_cols(m, n)
    ccall((:igraph_matrix_bool_add_cols, libigraph), igraph_error_t, (Ptr{igraph_matrix_bool_t}, igraph_integer_t), m, n)
end

function igraph_matrix_bool_add_rows(m, n)
    ccall((:igraph_matrix_bool_add_rows, libigraph), igraph_error_t, (Ptr{igraph_matrix_bool_t}, igraph_integer_t), m, n)
end

function igraph_matrix_bool_remove_col(m, col)
    ccall((:igraph_matrix_bool_remove_col, libigraph), igraph_error_t, (Ptr{igraph_matrix_bool_t}, igraph_integer_t), m, col)
end

function igraph_matrix_bool_remove_row(m, row)
    ccall((:igraph_matrix_bool_remove_row, libigraph), igraph_error_t, (Ptr{igraph_matrix_bool_t}, igraph_integer_t), m, row)
end

function igraph_matrix_bool_print(m)
    ccall((:igraph_matrix_bool_print, libigraph), igraph_error_t, (Ptr{igraph_matrix_bool_t},), m)
end

function igraph_matrix_bool_fprint(m, file)
    ccall((:igraph_matrix_bool_fprint, libigraph), igraph_error_t, (Ptr{igraph_matrix_bool_t}, Ptr{Libc.FILE}), m, file)
end

function igraph_matrix_bool_printf(m, format)
    ccall((:igraph_matrix_bool_printf, libigraph), igraph_error_t, (Ptr{igraph_matrix_bool_t}, Ptr{Cchar}), m, format)
end

function igraph_matrix_bool_permdelete_rows(m, index, nremove)
    ccall((:igraph_matrix_bool_permdelete_rows, libigraph), igraph_error_t, (Ptr{igraph_matrix_bool_t}, Ptr{igraph_integer_t}, igraph_integer_t), m, index, nremove)
end

function igraph_matrix_complex_init(m, nrow, ncol)
    ccall((:igraph_matrix_complex_init, libigraph), igraph_error_t, (Ptr{igraph_matrix_complex_t}, igraph_integer_t, igraph_integer_t), m, nrow, ncol)
end

function igraph_matrix_complex_init_array(m, data, nrow, ncol, storage)
    ccall((:igraph_matrix_complex_init_array, libigraph), igraph_error_t, (Ptr{igraph_matrix_complex_t}, Ptr{igraph_complex_t}, igraph_integer_t, igraph_integer_t, igraph_matrix_storage_t), m, data, nrow, ncol, storage)
end

function igraph_matrix_complex_init_copy(to, from)
    ccall((:igraph_matrix_complex_init_copy, libigraph), igraph_error_t, (Ptr{igraph_matrix_complex_t}, Ptr{igraph_matrix_complex_t}), to, from)
end

function igraph_matrix_complex_destroy(m)
    ccall((:igraph_matrix_complex_destroy, libigraph), Cvoid, (Ptr{igraph_matrix_complex_t},), m)
end

function igraph_matrix_complex_capacity(m)
    ccall((:igraph_matrix_complex_capacity, libigraph), igraph_integer_t, (Ptr{igraph_matrix_complex_t},), m)
end

function igraph_matrix_complex_copy(to, from)
    ccall((:igraph_matrix_complex_copy, libigraph), igraph_error_t, (Ptr{igraph_matrix_complex_t}, Ptr{igraph_matrix_complex_t}), to, from)
end

function igraph_matrix_complex_e(m, row, col)
    ccall((:igraph_matrix_complex_e, libigraph), igraph_complex_t, (Ptr{igraph_matrix_complex_t}, igraph_integer_t, igraph_integer_t), m, row, col)
end

function igraph_matrix_complex_e_ptr(m, row, col)
    ccall((:igraph_matrix_complex_e_ptr, libigraph), Ptr{igraph_complex_t}, (Ptr{igraph_matrix_complex_t}, igraph_integer_t, igraph_integer_t), m, row, col)
end

function igraph_matrix_complex_get(m, row, col)
    ccall((:igraph_matrix_complex_get, libigraph), igraph_complex_t, (Ptr{igraph_matrix_complex_t}, igraph_integer_t, igraph_integer_t), m, row, col)
end

function igraph_matrix_complex_get_ptr(m, row, col)
    ccall((:igraph_matrix_complex_get_ptr, libigraph), Ptr{igraph_complex_t}, (Ptr{igraph_matrix_complex_t}, igraph_integer_t, igraph_integer_t), m, row, col)
end

function igraph_matrix_complex_set(m, row, col, value)
    ccall((:igraph_matrix_complex_set, libigraph), Cvoid, (Ptr{igraph_matrix_complex_t}, igraph_integer_t, igraph_integer_t, igraph_complex_t), m, row, col, value)
end

function igraph_matrix_complex_null(m)
    ccall((:igraph_matrix_complex_null, libigraph), Cvoid, (Ptr{igraph_matrix_complex_t},), m)
end

function igraph_matrix_complex_fill(m, e)
    ccall((:igraph_matrix_complex_fill, libigraph), Cvoid, (Ptr{igraph_matrix_complex_t}, igraph_complex_t), m, e)
end

function igraph_matrix_complex_view(m, data, nrow, ncol)
    ccall((:igraph_matrix_complex_view, libigraph), Ptr{igraph_matrix_complex_t}, (Ptr{igraph_matrix_complex_t}, Ptr{igraph_complex_t}, igraph_integer_t, igraph_integer_t), m, data, nrow, ncol)
end

function igraph_matrix_complex_view_from_vector(m, v, ncol)
    ccall((:igraph_matrix_complex_view_from_vector, libigraph), Ptr{igraph_matrix_complex_t}, (Ptr{igraph_matrix_complex_t}, Ptr{igraph_vector_complex_t}, igraph_integer_t), m, v, ncol)
end

function igraph_matrix_complex_copy_to(m, to)
    ccall((:igraph_matrix_complex_copy_to, libigraph), Cvoid, (Ptr{igraph_matrix_complex_t}, Ptr{igraph_complex_t}), m, to)
end

function igraph_matrix_complex_update(to, from)
    ccall((:igraph_matrix_complex_update, libigraph), igraph_error_t, (Ptr{igraph_matrix_complex_t}, Ptr{igraph_matrix_complex_t}), to, from)
end

function igraph_matrix_complex_rbind(to, from)
    ccall((:igraph_matrix_complex_rbind, libigraph), igraph_error_t, (Ptr{igraph_matrix_complex_t}, Ptr{igraph_matrix_complex_t}), to, from)
end

function igraph_matrix_complex_cbind(to, from)
    ccall((:igraph_matrix_complex_cbind, libigraph), igraph_error_t, (Ptr{igraph_matrix_complex_t}, Ptr{igraph_matrix_complex_t}), to, from)
end

function igraph_matrix_complex_swap(m1, m2)
    ccall((:igraph_matrix_complex_swap, libigraph), igraph_error_t, (Ptr{igraph_matrix_complex_t}, Ptr{igraph_matrix_complex_t}), m1, m2)
end

function igraph_matrix_complex_get_row(m, res, index)
    ccall((:igraph_matrix_complex_get_row, libigraph), igraph_error_t, (Ptr{igraph_matrix_complex_t}, Ptr{igraph_vector_complex_t}, igraph_integer_t), m, res, index)
end

function igraph_matrix_complex_get_col(m, res, index)
    ccall((:igraph_matrix_complex_get_col, libigraph), igraph_error_t, (Ptr{igraph_matrix_complex_t}, Ptr{igraph_vector_complex_t}, igraph_integer_t), m, res, index)
end

function igraph_matrix_complex_set_row(m, v, index)
    ccall((:igraph_matrix_complex_set_row, libigraph), igraph_error_t, (Ptr{igraph_matrix_complex_t}, Ptr{igraph_vector_complex_t}, igraph_integer_t), m, v, index)
end

function igraph_matrix_complex_set_col(m, v, index)
    ccall((:igraph_matrix_complex_set_col, libigraph), igraph_error_t, (Ptr{igraph_matrix_complex_t}, Ptr{igraph_vector_complex_t}, igraph_integer_t), m, v, index)
end

function igraph_matrix_complex_select_rows(m, res, rows)
    ccall((:igraph_matrix_complex_select_rows, libigraph), igraph_error_t, (Ptr{igraph_matrix_complex_t}, Ptr{igraph_matrix_complex_t}, Ptr{igraph_vector_int_t}), m, res, rows)
end

function igraph_matrix_complex_select_cols(m, res, cols)
    ccall((:igraph_matrix_complex_select_cols, libigraph), igraph_error_t, (Ptr{igraph_matrix_complex_t}, Ptr{igraph_matrix_complex_t}, Ptr{igraph_vector_int_t}), m, res, cols)
end

function igraph_matrix_complex_select_rows_cols(m, res, rows, cols)
    ccall((:igraph_matrix_complex_select_rows_cols, libigraph), igraph_error_t, (Ptr{igraph_matrix_complex_t}, Ptr{igraph_matrix_complex_t}, Ptr{igraph_vector_int_t}, Ptr{igraph_vector_int_t}), m, res, rows, cols)
end

function igraph_matrix_complex_swap_rows(m, i, j)
    ccall((:igraph_matrix_complex_swap_rows, libigraph), igraph_error_t, (Ptr{igraph_matrix_complex_t}, igraph_integer_t, igraph_integer_t), m, i, j)
end

function igraph_matrix_complex_swap_cols(m, i, j)
    ccall((:igraph_matrix_complex_swap_cols, libigraph), igraph_error_t, (Ptr{igraph_matrix_complex_t}, igraph_integer_t, igraph_integer_t), m, i, j)
end

function igraph_matrix_complex_swap_rowcol(m, i, j)
    ccall((:igraph_matrix_complex_swap_rowcol, libigraph), igraph_error_t, (Ptr{igraph_matrix_complex_t}, igraph_integer_t, igraph_integer_t), m, i, j)
end

function igraph_matrix_complex_transpose(m)
    ccall((:igraph_matrix_complex_transpose, libigraph), igraph_error_t, (Ptr{igraph_matrix_complex_t},), m)
end

function igraph_matrix_complex_add(m1, m2)
    ccall((:igraph_matrix_complex_add, libigraph), igraph_error_t, (Ptr{igraph_matrix_complex_t}, Ptr{igraph_matrix_complex_t}), m1, m2)
end

function igraph_matrix_complex_sub(m1, m2)
    ccall((:igraph_matrix_complex_sub, libigraph), igraph_error_t, (Ptr{igraph_matrix_complex_t}, Ptr{igraph_matrix_complex_t}), m1, m2)
end

function igraph_matrix_complex_mul_elements(m1, m2)
    ccall((:igraph_matrix_complex_mul_elements, libigraph), igraph_error_t, (Ptr{igraph_matrix_complex_t}, Ptr{igraph_matrix_complex_t}), m1, m2)
end

function igraph_matrix_complex_div_elements(m1, m2)
    ccall((:igraph_matrix_complex_div_elements, libigraph), igraph_error_t, (Ptr{igraph_matrix_complex_t}, Ptr{igraph_matrix_complex_t}), m1, m2)
end

function igraph_matrix_complex_scale(m, by)
    ccall((:igraph_matrix_complex_scale, libigraph), Cvoid, (Ptr{igraph_matrix_complex_t}, igraph_complex_t), m, by)
end

function igraph_matrix_complex_add_constant(m, plus)
    ccall((:igraph_matrix_complex_add_constant, libigraph), Cvoid, (Ptr{igraph_matrix_complex_t}, igraph_complex_t), m, plus)
end

function igraph_matrix_complex_all_e(lhs, rhs)
    ccall((:igraph_matrix_complex_all_e, libigraph), igraph_bool_t, (Ptr{igraph_matrix_complex_t}, Ptr{igraph_matrix_complex_t}), lhs, rhs)
end

function igraph_matrix_complex_isnull(m)
    ccall((:igraph_matrix_complex_isnull, libigraph), igraph_bool_t, (Ptr{igraph_matrix_complex_t},), m)
end

function igraph_matrix_complex_empty(m)
    ccall((:igraph_matrix_complex_empty, libigraph), igraph_bool_t, (Ptr{igraph_matrix_complex_t},), m)
end

function igraph_matrix_complex_size(m)
    ccall((:igraph_matrix_complex_size, libigraph), igraph_integer_t, (Ptr{igraph_matrix_complex_t},), m)
end

function igraph_matrix_complex_nrow(m)
    ccall((:igraph_matrix_complex_nrow, libigraph), igraph_integer_t, (Ptr{igraph_matrix_complex_t},), m)
end

function igraph_matrix_complex_ncol(m)
    ccall((:igraph_matrix_complex_ncol, libigraph), igraph_integer_t, (Ptr{igraph_matrix_complex_t},), m)
end

function igraph_matrix_complex_is_symmetric(m)
    ccall((:igraph_matrix_complex_is_symmetric, libigraph), igraph_bool_t, (Ptr{igraph_matrix_complex_t},), m)
end

function igraph_matrix_complex_sum(m)
    ccall((:igraph_matrix_complex_sum, libigraph), igraph_complex_t, (Ptr{igraph_matrix_complex_t},), m)
end

function igraph_matrix_complex_prod(m)
    ccall((:igraph_matrix_complex_prod, libigraph), igraph_complex_t, (Ptr{igraph_matrix_complex_t},), m)
end

function igraph_matrix_complex_rowsum(m, res)
    ccall((:igraph_matrix_complex_rowsum, libigraph), igraph_error_t, (Ptr{igraph_matrix_complex_t}, Ptr{igraph_vector_complex_t}), m, res)
end

function igraph_matrix_complex_colsum(m, res)
    ccall((:igraph_matrix_complex_colsum, libigraph), igraph_error_t, (Ptr{igraph_matrix_complex_t}, Ptr{igraph_vector_complex_t}), m, res)
end

function igraph_matrix_complex_is_equal(m1, m2)
    ccall((:igraph_matrix_complex_is_equal, libigraph), igraph_bool_t, (Ptr{igraph_matrix_complex_t}, Ptr{igraph_matrix_complex_t}), m1, m2)
end

function igraph_matrix_complex_contains(m, e)
    ccall((:igraph_matrix_complex_contains, libigraph), igraph_bool_t, (Ptr{igraph_matrix_complex_t}, igraph_complex_t), m, e)
end

function igraph_matrix_complex_search(m, from, what, pos, row, col)
    ccall((:igraph_matrix_complex_search, libigraph), igraph_bool_t, (Ptr{igraph_matrix_complex_t}, igraph_integer_t, igraph_complex_t, Ptr{igraph_integer_t}, Ptr{igraph_integer_t}, Ptr{igraph_integer_t}), m, from, what, pos, row, col)
end

function igraph_matrix_complex_resize(m, nrow, ncol)
    ccall((:igraph_matrix_complex_resize, libigraph), igraph_error_t, (Ptr{igraph_matrix_complex_t}, igraph_integer_t, igraph_integer_t), m, nrow, ncol)
end

function igraph_matrix_complex_resize_min(m)
    ccall((:igraph_matrix_complex_resize_min, libigraph), Cvoid, (Ptr{igraph_matrix_complex_t},), m)
end

function igraph_matrix_complex_add_cols(m, n)
    ccall((:igraph_matrix_complex_add_cols, libigraph), igraph_error_t, (Ptr{igraph_matrix_complex_t}, igraph_integer_t), m, n)
end

function igraph_matrix_complex_add_rows(m, n)
    ccall((:igraph_matrix_complex_add_rows, libigraph), igraph_error_t, (Ptr{igraph_matrix_complex_t}, igraph_integer_t), m, n)
end

function igraph_matrix_complex_remove_col(m, col)
    ccall((:igraph_matrix_complex_remove_col, libigraph), igraph_error_t, (Ptr{igraph_matrix_complex_t}, igraph_integer_t), m, col)
end

function igraph_matrix_complex_remove_row(m, row)
    ccall((:igraph_matrix_complex_remove_row, libigraph), igraph_error_t, (Ptr{igraph_matrix_complex_t}, igraph_integer_t), m, row)
end

function igraph_matrix_complex_print(m)
    ccall((:igraph_matrix_complex_print, libigraph), igraph_error_t, (Ptr{igraph_matrix_complex_t},), m)
end

function igraph_matrix_complex_fprint(m, file)
    ccall((:igraph_matrix_complex_fprint, libigraph), igraph_error_t, (Ptr{igraph_matrix_complex_t}, Ptr{Libc.FILE}), m, file)
end

function igraph_matrix_complex_real(v, real)
    ccall((:igraph_matrix_complex_real, libigraph), igraph_error_t, (Ptr{igraph_matrix_complex_t}, Ptr{igraph_matrix_t}), v, real)
end

function igraph_matrix_complex_imag(v, imag)
    ccall((:igraph_matrix_complex_imag, libigraph), igraph_error_t, (Ptr{igraph_matrix_complex_t}, Ptr{igraph_matrix_t}), v, imag)
end

function igraph_matrix_complex_realimag(v, real, imag)
    ccall((:igraph_matrix_complex_realimag, libigraph), igraph_error_t, (Ptr{igraph_matrix_complex_t}, Ptr{igraph_matrix_t}, Ptr{igraph_matrix_t}), v, real, imag)
end

function igraph_matrix_complex_create(v, real, imag)
    ccall((:igraph_matrix_complex_create, libigraph), igraph_error_t, (Ptr{igraph_matrix_complex_t}, Ptr{igraph_matrix_t}, Ptr{igraph_matrix_t}), v, real, imag)
end

function igraph_matrix_complex_create_polar(v, r, theta)
    ccall((:igraph_matrix_complex_create_polar, libigraph), igraph_error_t, (Ptr{igraph_matrix_complex_t}, Ptr{igraph_matrix_t}, Ptr{igraph_matrix_t}), v, r, theta)
end

function igraph_matrix_complex_all_almost_e(lhs, rhs, eps)
    ccall((:igraph_matrix_complex_all_almost_e, libigraph), igraph_bool_t, (Ptr{igraph_matrix_complex_t}, Ptr{igraph_matrix_complex_t}, igraph_real_t), lhs, rhs, eps)
end

function igraph_matrix_complex_permdelete_rows(m, index, nremove)
    ccall((:igraph_matrix_complex_permdelete_rows, libigraph), igraph_error_t, (Ptr{igraph_matrix_complex_t}, Ptr{igraph_integer_t}, igraph_integer_t), m, index, nremove)
end

function igraph_matrix_all_e_tol(lhs, rhs, tol)
    ccall((:igraph_matrix_all_e_tol, libigraph), igraph_bool_t, (Ptr{igraph_matrix_t}, Ptr{igraph_matrix_t}, igraph_real_t), lhs, rhs, tol)
end

function igraph_matrix_all_almost_e(lhs, rhs, eps)
    ccall((:igraph_matrix_all_almost_e, libigraph), igraph_bool_t, (Ptr{igraph_matrix_t}, Ptr{igraph_matrix_t}, igraph_real_t), lhs, rhs, eps)
end

function igraph_matrix_zapsmall(m, tol)
    ccall((:igraph_matrix_zapsmall, libigraph), igraph_error_t, (Ptr{igraph_matrix_t}, igraph_real_t), m, tol)
end

function igraph_matrix_complex_zapsmall(m, tol)
    ccall((:igraph_matrix_complex_zapsmall, libigraph), igraph_error_t, (Ptr{igraph_matrix_complex_t}, igraph_real_t), m, tol)
end

function igraph_array3_size(a)
    ccall((:igraph_array3_size, libigraph), igraph_integer_t, (Ptr{igraph_array3_t},), a)
end

function igraph_array3_n(a, idx)
    ccall((:igraph_array3_n, libigraph), igraph_integer_t, (Ptr{igraph_array3_t}, igraph_integer_t), a, idx)
end

function igraph_array3_resize(a, n1, n2, n3)
    ccall((:igraph_array3_resize, libigraph), igraph_error_t, (Ptr{igraph_array3_t}, igraph_integer_t, igraph_integer_t, igraph_integer_t), a, n1, n2, n3)
end

function igraph_array3_null(a)
    ccall((:igraph_array3_null, libigraph), Cvoid, (Ptr{igraph_array3_t},), a)
end

function igraph_array3_sum(a)
    ccall((:igraph_array3_sum, libigraph), igraph_real_t, (Ptr{igraph_array3_t},), a)
end

function igraph_array3_scale(a, by)
    ccall((:igraph_array3_scale, libigraph), Cvoid, (Ptr{igraph_array3_t}, igraph_real_t), a, by)
end

function igraph_array3_fill(a, e)
    ccall((:igraph_array3_fill, libigraph), Cvoid, (Ptr{igraph_array3_t}, igraph_real_t), a, e)
end

function igraph_array3_update(to, from)
    ccall((:igraph_array3_update, libigraph), igraph_error_t, (Ptr{igraph_array3_t}, Ptr{igraph_array3_t}), to, from)
end

mutable struct igraph_array3_int_t
    data::igraph_vector_int_t
    n1::igraph_integer_t
    n2::igraph_integer_t
    n3::igraph_integer_t
    n1n2::igraph_integer_t
    igraph_array3_int_t() = new()
end

function igraph_array3_int_init(a, n1, n2, n3)
    ccall((:igraph_array3_int_init, libigraph), igraph_error_t, (Ptr{igraph_array3_int_t}, igraph_integer_t, igraph_integer_t, igraph_integer_t), a, n1, n2, n3)
end

function igraph_array3_int_destroy(a)
    ccall((:igraph_array3_int_destroy, libigraph), Cvoid, (Ptr{igraph_array3_int_t},), a)
end

function igraph_array3_int_size(a)
    ccall((:igraph_array3_int_size, libigraph), igraph_integer_t, (Ptr{igraph_array3_int_t},), a)
end

function igraph_array3_int_n(a, idx)
    ccall((:igraph_array3_int_n, libigraph), igraph_integer_t, (Ptr{igraph_array3_int_t}, igraph_integer_t), a, idx)
end

function igraph_array3_int_resize(a, n1, n2, n3)
    ccall((:igraph_array3_int_resize, libigraph), igraph_error_t, (Ptr{igraph_array3_int_t}, igraph_integer_t, igraph_integer_t, igraph_integer_t), a, n1, n2, n3)
end

function igraph_array3_int_null(a)
    ccall((:igraph_array3_int_null, libigraph), Cvoid, (Ptr{igraph_array3_int_t},), a)
end

function igraph_array3_int_sum(a)
    ccall((:igraph_array3_int_sum, libigraph), igraph_integer_t, (Ptr{igraph_array3_int_t},), a)
end

function igraph_array3_int_scale(a, by)
    ccall((:igraph_array3_int_scale, libigraph), Cvoid, (Ptr{igraph_array3_int_t}, igraph_integer_t), a, by)
end

function igraph_array3_int_fill(a, e)
    ccall((:igraph_array3_int_fill, libigraph), Cvoid, (Ptr{igraph_array3_int_t}, igraph_integer_t), a, e)
end

function igraph_array3_int_update(to, from)
    ccall((:igraph_array3_int_update, libigraph), igraph_error_t, (Ptr{igraph_array3_int_t}, Ptr{igraph_array3_int_t}), to, from)
end

mutable struct igraph_array3_char_t
    data::igraph_vector_char_t
    n1::igraph_integer_t
    n2::igraph_integer_t
    n3::igraph_integer_t
    n1n2::igraph_integer_t
    igraph_array3_char_t() = new()
end

function igraph_array3_char_init(a, n1, n2, n3)
    ccall((:igraph_array3_char_init, libigraph), igraph_error_t, (Ptr{igraph_array3_char_t}, igraph_integer_t, igraph_integer_t, igraph_integer_t), a, n1, n2, n3)
end

function igraph_array3_char_destroy(a)
    ccall((:igraph_array3_char_destroy, libigraph), Cvoid, (Ptr{igraph_array3_char_t},), a)
end

function igraph_array3_char_size(a)
    ccall((:igraph_array3_char_size, libigraph), igraph_integer_t, (Ptr{igraph_array3_char_t},), a)
end

function igraph_array3_char_n(a, idx)
    ccall((:igraph_array3_char_n, libigraph), igraph_integer_t, (Ptr{igraph_array3_char_t}, igraph_integer_t), a, idx)
end

function igraph_array3_char_resize(a, n1, n2, n3)
    ccall((:igraph_array3_char_resize, libigraph), igraph_error_t, (Ptr{igraph_array3_char_t}, igraph_integer_t, igraph_integer_t, igraph_integer_t), a, n1, n2, n3)
end

function igraph_array3_char_null(a)
    ccall((:igraph_array3_char_null, libigraph), Cvoid, (Ptr{igraph_array3_char_t},), a)
end

function igraph_array3_char_sum(a)
    ccall((:igraph_array3_char_sum, libigraph), Cchar, (Ptr{igraph_array3_char_t},), a)
end

function igraph_array3_char_scale(a, by)
    ccall((:igraph_array3_char_scale, libigraph), Cvoid, (Ptr{igraph_array3_char_t}, Cchar), a, by)
end

function igraph_array3_char_fill(a, e)
    ccall((:igraph_array3_char_fill, libigraph), Cvoid, (Ptr{igraph_array3_char_t}, Cchar), a, e)
end

function igraph_array3_char_update(to, from)
    ccall((:igraph_array3_char_update, libigraph), igraph_error_t, (Ptr{igraph_array3_char_t}, Ptr{igraph_array3_char_t}), to, from)
end

mutable struct igraph_array3_bool_t
    data::igraph_vector_bool_t
    n1::igraph_integer_t
    n2::igraph_integer_t
    n3::igraph_integer_t
    n1n2::igraph_integer_t
    igraph_array3_bool_t() = new()
end

function igraph_array3_bool_init(a, n1, n2, n3)
    ccall((:igraph_array3_bool_init, libigraph), igraph_error_t, (Ptr{igraph_array3_bool_t}, igraph_integer_t, igraph_integer_t, igraph_integer_t), a, n1, n2, n3)
end

function igraph_array3_bool_destroy(a)
    ccall((:igraph_array3_bool_destroy, libigraph), Cvoid, (Ptr{igraph_array3_bool_t},), a)
end

function igraph_array3_bool_size(a)
    ccall((:igraph_array3_bool_size, libigraph), igraph_integer_t, (Ptr{igraph_array3_bool_t},), a)
end

function igraph_array3_bool_n(a, idx)
    ccall((:igraph_array3_bool_n, libigraph), igraph_integer_t, (Ptr{igraph_array3_bool_t}, igraph_integer_t), a, idx)
end

function igraph_array3_bool_resize(a, n1, n2, n3)
    ccall((:igraph_array3_bool_resize, libigraph), igraph_error_t, (Ptr{igraph_array3_bool_t}, igraph_integer_t, igraph_integer_t, igraph_integer_t), a, n1, n2, n3)
end

function igraph_array3_bool_null(a)
    ccall((:igraph_array3_bool_null, libigraph), Cvoid, (Ptr{igraph_array3_bool_t},), a)
end

function igraph_array3_bool_sum(a)
    ccall((:igraph_array3_bool_sum, libigraph), igraph_bool_t, (Ptr{igraph_array3_bool_t},), a)
end

function igraph_array3_bool_scale(a, by)
    ccall((:igraph_array3_bool_scale, libigraph), Cvoid, (Ptr{igraph_array3_bool_t}, igraph_bool_t), a, by)
end

function igraph_array3_bool_fill(a, e)
    ccall((:igraph_array3_bool_fill, libigraph), Cvoid, (Ptr{igraph_array3_bool_t}, igraph_bool_t), a, e)
end

function igraph_array3_bool_update(to, from)
    ccall((:igraph_array3_bool_update, libigraph), igraph_error_t, (Ptr{igraph_array3_bool_t}, Ptr{igraph_array3_bool_t}), to, from)
end

function igraph_bitset_init_copy(dest, src)
    ccall((:igraph_bitset_init_copy, libigraph), igraph_error_t, (Ptr{igraph_bitset_t}, Ptr{igraph_bitset_t}), dest, src)
end

function igraph_bitset_update(dest, src)
    ccall((:igraph_bitset_update, libigraph), igraph_error_t, (Ptr{igraph_bitset_t}, Ptr{igraph_bitset_t}), dest, src)
end

function igraph_bitset_capacity(bitset)
    ccall((:igraph_bitset_capacity, libigraph), igraph_integer_t, (Ptr{igraph_bitset_t},), bitset)
end

function igraph_bitset_size(bitset)
    ccall((:igraph_bitset_size, libigraph), igraph_integer_t, (Ptr{igraph_bitset_t},), bitset)
end

function igraph_bitset_reserve(bitset, capacity)
    ccall((:igraph_bitset_reserve, libigraph), igraph_error_t, (Ptr{igraph_bitset_t}, igraph_integer_t), bitset, capacity)
end

function igraph_bitset_resize(bitset, new_size)
    ccall((:igraph_bitset_resize, libigraph), igraph_error_t, (Ptr{igraph_bitset_t}, igraph_integer_t), bitset, new_size)
end

function igraph_bitset_popcount(bitset)
    ccall((:igraph_bitset_popcount, libigraph), igraph_integer_t, (Ptr{igraph_bitset_t},), bitset)
end

function igraph_bitset_countl_zero(bitset)
    ccall((:igraph_bitset_countl_zero, libigraph), igraph_integer_t, (Ptr{igraph_bitset_t},), bitset)
end

function igraph_bitset_countl_one(bitset)
    ccall((:igraph_bitset_countl_one, libigraph), igraph_integer_t, (Ptr{igraph_bitset_t},), bitset)
end

function igraph_bitset_countr_zero(bitset)
    ccall((:igraph_bitset_countr_zero, libigraph), igraph_integer_t, (Ptr{igraph_bitset_t},), bitset)
end

function igraph_bitset_countr_one(bitset)
    ccall((:igraph_bitset_countr_one, libigraph), igraph_integer_t, (Ptr{igraph_bitset_t},), bitset)
end

function igraph_bitset_is_all_zero(bitset)
    ccall((:igraph_bitset_is_all_zero, libigraph), igraph_bool_t, (Ptr{igraph_bitset_t},), bitset)
end

function igraph_bitset_is_all_one(bitset)
    ccall((:igraph_bitset_is_all_one, libigraph), igraph_bool_t, (Ptr{igraph_bitset_t},), bitset)
end

function igraph_bitset_is_any_zero(bitset)
    ccall((:igraph_bitset_is_any_zero, libigraph), igraph_bool_t, (Ptr{igraph_bitset_t},), bitset)
end

function igraph_bitset_is_any_one(bitset)
    ccall((:igraph_bitset_is_any_one, libigraph), igraph_bool_t, (Ptr{igraph_bitset_t},), bitset)
end

function igraph_bitset_or(dest, src1, src2)
    ccall((:igraph_bitset_or, libigraph), Cvoid, (Ptr{igraph_bitset_t}, Ptr{igraph_bitset_t}, Ptr{igraph_bitset_t}), dest, src1, src2)
end

function igraph_bitset_and(dest, src1, src2)
    ccall((:igraph_bitset_and, libigraph), Cvoid, (Ptr{igraph_bitset_t}, Ptr{igraph_bitset_t}, Ptr{igraph_bitset_t}), dest, src1, src2)
end

function igraph_bitset_xor(dest, src1, src2)
    ccall((:igraph_bitset_xor, libigraph), Cvoid, (Ptr{igraph_bitset_t}, Ptr{igraph_bitset_t}, Ptr{igraph_bitset_t}), dest, src1, src2)
end

function igraph_bitset_not(dest, src)
    ccall((:igraph_bitset_not, libigraph), Cvoid, (Ptr{igraph_bitset_t}, Ptr{igraph_bitset_t}), dest, src)
end

function igraph_bitset_fill(bitset, value)
    ccall((:igraph_bitset_fill, libigraph), Cvoid, (Ptr{igraph_bitset_t}, igraph_bool_t), bitset, value)
end

function igraph_bitset_null(bitset)
    ccall((:igraph_bitset_null, libigraph), Cvoid, (Ptr{igraph_bitset_t},), bitset)
end

function igraph_bitset_fprint(bitset, file)
    ccall((:igraph_bitset_fprint, libigraph), igraph_error_t, (Ptr{igraph_bitset_t}, Ptr{Libc.FILE}), bitset, file)
end

function igraph_bitset_print(bitset)
    ccall((:igraph_bitset_print, libigraph), igraph_error_t, (Ptr{igraph_bitset_t},), bitset)
end

function igraph_dqueue_empty(q)
    ccall((:igraph_dqueue_empty, libigraph), igraph_bool_t, (Ptr{igraph_dqueue_t},), q)
end

function igraph_dqueue_clear(q)
    ccall((:igraph_dqueue_clear, libigraph), Cvoid, (Ptr{igraph_dqueue_t},), q)
end

function igraph_dqueue_full(q)
    ccall((:igraph_dqueue_full, libigraph), igraph_bool_t, (Ptr{igraph_dqueue_t},), q)
end

function igraph_dqueue_size(q)
    ccall((:igraph_dqueue_size, libigraph), igraph_integer_t, (Ptr{igraph_dqueue_t},), q)
end

function igraph_dqueue_pop(q)
    ccall((:igraph_dqueue_pop, libigraph), igraph_real_t, (Ptr{igraph_dqueue_t},), q)
end

function igraph_dqueue_pop_back(q)
    ccall((:igraph_dqueue_pop_back, libigraph), igraph_real_t, (Ptr{igraph_dqueue_t},), q)
end

function igraph_dqueue_head(q)
    ccall((:igraph_dqueue_head, libigraph), igraph_real_t, (Ptr{igraph_dqueue_t},), q)
end

function igraph_dqueue_back(q)
    ccall((:igraph_dqueue_back, libigraph), igraph_real_t, (Ptr{igraph_dqueue_t},), q)
end

function igraph_dqueue_push(q, elem)
    ccall((:igraph_dqueue_push, libigraph), igraph_error_t, (Ptr{igraph_dqueue_t}, igraph_real_t), q, elem)
end

function igraph_dqueue_print(q)
    ccall((:igraph_dqueue_print, libigraph), igraph_error_t, (Ptr{igraph_dqueue_t},), q)
end

function igraph_dqueue_fprint(q, file)
    ccall((:igraph_dqueue_fprint, libigraph), igraph_error_t, (Ptr{igraph_dqueue_t}, Ptr{Libc.FILE}), q, file)
end

function igraph_dqueue_get(q, idx)
    ccall((:igraph_dqueue_get, libigraph), igraph_real_t, (Ptr{igraph_dqueue_t}, igraph_integer_t), q, idx)
end

function igraph_dqueue_e(q, idx)
    ccall((:igraph_dqueue_e, libigraph), igraph_real_t, (Ptr{igraph_dqueue_t}, igraph_integer_t), q, idx)
end

mutable struct igraph_dqueue_char_t
    _begin::Ptr{Cchar}
    _end::Ptr{Cchar}
    stor_begin::Ptr{Cchar}
    stor_end::Ptr{Cchar}
    igraph_dqueue_char_t() = new()
end

function igraph_dqueue_char_init(q, capacity)
    ccall((:igraph_dqueue_char_init, libigraph), igraph_error_t, (Ptr{igraph_dqueue_char_t}, igraph_integer_t), q, capacity)
end

function igraph_dqueue_char_destroy(q)
    ccall((:igraph_dqueue_char_destroy, libigraph), Cvoid, (Ptr{igraph_dqueue_char_t},), q)
end

function igraph_dqueue_char_empty(q)
    ccall((:igraph_dqueue_char_empty, libigraph), igraph_bool_t, (Ptr{igraph_dqueue_char_t},), q)
end

function igraph_dqueue_char_clear(q)
    ccall((:igraph_dqueue_char_clear, libigraph), Cvoid, (Ptr{igraph_dqueue_char_t},), q)
end

function igraph_dqueue_char_full(q)
    ccall((:igraph_dqueue_char_full, libigraph), igraph_bool_t, (Ptr{igraph_dqueue_char_t},), q)
end

function igraph_dqueue_char_size(q)
    ccall((:igraph_dqueue_char_size, libigraph), igraph_integer_t, (Ptr{igraph_dqueue_char_t},), q)
end

function igraph_dqueue_char_pop(q)
    ccall((:igraph_dqueue_char_pop, libigraph), Cchar, (Ptr{igraph_dqueue_char_t},), q)
end

function igraph_dqueue_char_pop_back(q)
    ccall((:igraph_dqueue_char_pop_back, libigraph), Cchar, (Ptr{igraph_dqueue_char_t},), q)
end

function igraph_dqueue_char_head(q)
    ccall((:igraph_dqueue_char_head, libigraph), Cchar, (Ptr{igraph_dqueue_char_t},), q)
end

function igraph_dqueue_char_back(q)
    ccall((:igraph_dqueue_char_back, libigraph), Cchar, (Ptr{igraph_dqueue_char_t},), q)
end

function igraph_dqueue_char_push(q, elem)
    ccall((:igraph_dqueue_char_push, libigraph), igraph_error_t, (Ptr{igraph_dqueue_char_t}, Cchar), q, elem)
end

function igraph_dqueue_char_print(q)
    ccall((:igraph_dqueue_char_print, libigraph), igraph_error_t, (Ptr{igraph_dqueue_char_t},), q)
end

function igraph_dqueue_char_fprint(q, file)
    ccall((:igraph_dqueue_char_fprint, libigraph), igraph_error_t, (Ptr{igraph_dqueue_char_t}, Ptr{Libc.FILE}), q, file)
end

function igraph_dqueue_char_get(q, idx)
    ccall((:igraph_dqueue_char_get, libigraph), Cchar, (Ptr{igraph_dqueue_char_t}, igraph_integer_t), q, idx)
end

function igraph_dqueue_char_e(q, idx)
    ccall((:igraph_dqueue_char_e, libigraph), Cchar, (Ptr{igraph_dqueue_char_t}, igraph_integer_t), q, idx)
end

mutable struct igraph_dqueue_bool_t
    _begin::Ptr{igraph_bool_t}
    _end::Ptr{igraph_bool_t}
    stor_begin::Ptr{igraph_bool_t}
    stor_end::Ptr{igraph_bool_t}
    igraph_dqueue_bool_t() = new()
end

function igraph_dqueue_bool_init(q, capacity)
    ccall((:igraph_dqueue_bool_init, libigraph), igraph_error_t, (Ptr{igraph_dqueue_bool_t}, igraph_integer_t), q, capacity)
end

function igraph_dqueue_bool_destroy(q)
    ccall((:igraph_dqueue_bool_destroy, libigraph), Cvoid, (Ptr{igraph_dqueue_bool_t},), q)
end

function igraph_dqueue_bool_empty(q)
    ccall((:igraph_dqueue_bool_empty, libigraph), igraph_bool_t, (Ptr{igraph_dqueue_bool_t},), q)
end

function igraph_dqueue_bool_clear(q)
    ccall((:igraph_dqueue_bool_clear, libigraph), Cvoid, (Ptr{igraph_dqueue_bool_t},), q)
end

function igraph_dqueue_bool_full(q)
    ccall((:igraph_dqueue_bool_full, libigraph), igraph_bool_t, (Ptr{igraph_dqueue_bool_t},), q)
end

function igraph_dqueue_bool_size(q)
    ccall((:igraph_dqueue_bool_size, libigraph), igraph_integer_t, (Ptr{igraph_dqueue_bool_t},), q)
end

function igraph_dqueue_bool_pop(q)
    ccall((:igraph_dqueue_bool_pop, libigraph), igraph_bool_t, (Ptr{igraph_dqueue_bool_t},), q)
end

function igraph_dqueue_bool_pop_back(q)
    ccall((:igraph_dqueue_bool_pop_back, libigraph), igraph_bool_t, (Ptr{igraph_dqueue_bool_t},), q)
end

function igraph_dqueue_bool_head(q)
    ccall((:igraph_dqueue_bool_head, libigraph), igraph_bool_t, (Ptr{igraph_dqueue_bool_t},), q)
end

function igraph_dqueue_bool_back(q)
    ccall((:igraph_dqueue_bool_back, libigraph), igraph_bool_t, (Ptr{igraph_dqueue_bool_t},), q)
end

function igraph_dqueue_bool_push(q, elem)
    ccall((:igraph_dqueue_bool_push, libigraph), igraph_error_t, (Ptr{igraph_dqueue_bool_t}, igraph_bool_t), q, elem)
end

function igraph_dqueue_bool_print(q)
    ccall((:igraph_dqueue_bool_print, libigraph), igraph_error_t, (Ptr{igraph_dqueue_bool_t},), q)
end

function igraph_dqueue_bool_fprint(q, file)
    ccall((:igraph_dqueue_bool_fprint, libigraph), igraph_error_t, (Ptr{igraph_dqueue_bool_t}, Ptr{Libc.FILE}), q, file)
end

function igraph_dqueue_bool_get(q, idx)
    ccall((:igraph_dqueue_bool_get, libigraph), igraph_bool_t, (Ptr{igraph_dqueue_bool_t}, igraph_integer_t), q, idx)
end

function igraph_dqueue_bool_e(q, idx)
    ccall((:igraph_dqueue_bool_e, libigraph), igraph_bool_t, (Ptr{igraph_dqueue_bool_t}, igraph_integer_t), q, idx)
end

function igraph_dqueue_int_empty(q)
    ccall((:igraph_dqueue_int_empty, libigraph), igraph_bool_t, (Ptr{igraph_dqueue_int_t},), q)
end

function igraph_dqueue_int_clear(q)
    ccall((:igraph_dqueue_int_clear, libigraph), Cvoid, (Ptr{igraph_dqueue_int_t},), q)
end

function igraph_dqueue_int_full(q)
    ccall((:igraph_dqueue_int_full, libigraph), igraph_bool_t, (Ptr{igraph_dqueue_int_t},), q)
end

function igraph_dqueue_int_size(q)
    ccall((:igraph_dqueue_int_size, libigraph), igraph_integer_t, (Ptr{igraph_dqueue_int_t},), q)
end

function igraph_dqueue_int_pop(q)
    ccall((:igraph_dqueue_int_pop, libigraph), igraph_integer_t, (Ptr{igraph_dqueue_int_t},), q)
end

function igraph_dqueue_int_pop_back(q)
    ccall((:igraph_dqueue_int_pop_back, libigraph), igraph_integer_t, (Ptr{igraph_dqueue_int_t},), q)
end

function igraph_dqueue_int_head(q)
    ccall((:igraph_dqueue_int_head, libigraph), igraph_integer_t, (Ptr{igraph_dqueue_int_t},), q)
end

function igraph_dqueue_int_back(q)
    ccall((:igraph_dqueue_int_back, libigraph), igraph_integer_t, (Ptr{igraph_dqueue_int_t},), q)
end

function igraph_dqueue_int_push(q, elem)
    ccall((:igraph_dqueue_int_push, libigraph), igraph_error_t, (Ptr{igraph_dqueue_int_t}, igraph_integer_t), q, elem)
end

function igraph_dqueue_int_print(q)
    ccall((:igraph_dqueue_int_print, libigraph), igraph_error_t, (Ptr{igraph_dqueue_int_t},), q)
end

function igraph_dqueue_int_fprint(q, file)
    ccall((:igraph_dqueue_int_fprint, libigraph), igraph_error_t, (Ptr{igraph_dqueue_int_t}, Ptr{Libc.FILE}), q, file)
end

function igraph_dqueue_int_get(q, idx)
    ccall((:igraph_dqueue_int_get, libigraph), igraph_integer_t, (Ptr{igraph_dqueue_int_t}, igraph_integer_t), q, idx)
end

function igraph_dqueue_int_e(q, idx)
    ccall((:igraph_dqueue_int_e, libigraph), igraph_integer_t, (Ptr{igraph_dqueue_int_t}, igraph_integer_t), q, idx)
end

function igraph_stack_reserve(s, capacity)
    ccall((:igraph_stack_reserve, libigraph), igraph_error_t, (Ptr{igraph_stack_t}, igraph_integer_t), s, capacity)
end

function igraph_stack_empty(s)
    ccall((:igraph_stack_empty, libigraph), igraph_bool_t, (Ptr{igraph_stack_t},), s)
end

function igraph_stack_size(s)
    ccall((:igraph_stack_size, libigraph), igraph_integer_t, (Ptr{igraph_stack_t},), s)
end

function igraph_stack_capacity(s)
    ccall((:igraph_stack_capacity, libigraph), igraph_integer_t, (Ptr{igraph_stack_t},), s)
end

function igraph_stack_clear(s)
    ccall((:igraph_stack_clear, libigraph), Cvoid, (Ptr{igraph_stack_t},), s)
end

function igraph_stack_push(s, elem)
    ccall((:igraph_stack_push, libigraph), igraph_error_t, (Ptr{igraph_stack_t}, igraph_real_t), s, elem)
end

function igraph_stack_pop(s)
    ccall((:igraph_stack_pop, libigraph), igraph_real_t, (Ptr{igraph_stack_t},), s)
end

function igraph_stack_top(s)
    ccall((:igraph_stack_top, libigraph), igraph_real_t, (Ptr{igraph_stack_t},), s)
end

function igraph_stack_print(s)
    ccall((:igraph_stack_print, libigraph), igraph_error_t, (Ptr{igraph_stack_t},), s)
end

function igraph_stack_fprint(s, file)
    ccall((:igraph_stack_fprint, libigraph), igraph_error_t, (Ptr{igraph_stack_t}, Ptr{Libc.FILE}), s, file)
end

function igraph_stack_int_reserve(s, capacity)
    ccall((:igraph_stack_int_reserve, libigraph), igraph_error_t, (Ptr{igraph_stack_int_t}, igraph_integer_t), s, capacity)
end

function igraph_stack_int_empty(s)
    ccall((:igraph_stack_int_empty, libigraph), igraph_bool_t, (Ptr{igraph_stack_int_t},), s)
end

function igraph_stack_int_size(s)
    ccall((:igraph_stack_int_size, libigraph), igraph_integer_t, (Ptr{igraph_stack_int_t},), s)
end

function igraph_stack_int_capacity(s)
    ccall((:igraph_stack_int_capacity, libigraph), igraph_integer_t, (Ptr{igraph_stack_int_t},), s)
end

function igraph_stack_int_clear(s)
    ccall((:igraph_stack_int_clear, libigraph), Cvoid, (Ptr{igraph_stack_int_t},), s)
end

function igraph_stack_int_push(s, elem)
    ccall((:igraph_stack_int_push, libigraph), igraph_error_t, (Ptr{igraph_stack_int_t}, igraph_integer_t), s, elem)
end

function igraph_stack_int_pop(s)
    ccall((:igraph_stack_int_pop, libigraph), igraph_integer_t, (Ptr{igraph_stack_int_t},), s)
end

function igraph_stack_int_top(s)
    ccall((:igraph_stack_int_top, libigraph), igraph_integer_t, (Ptr{igraph_stack_int_t},), s)
end

function igraph_stack_int_print(s)
    ccall((:igraph_stack_int_print, libigraph), igraph_error_t, (Ptr{igraph_stack_int_t},), s)
end

function igraph_stack_int_fprint(s, file)
    ccall((:igraph_stack_int_fprint, libigraph), igraph_error_t, (Ptr{igraph_stack_int_t}, Ptr{Libc.FILE}), s, file)
end

mutable struct igraph_stack_char_t
    stor_begin::Ptr{Cchar}
    stor_end::Ptr{Cchar}
    _end::Ptr{Cchar}
    igraph_stack_char_t() = new()
end

function igraph_stack_char_init(s, capacity)
    ccall((:igraph_stack_char_init, libigraph), igraph_error_t, (Ptr{igraph_stack_char_t}, igraph_integer_t), s, capacity)
end

function igraph_stack_char_destroy(s)
    ccall((:igraph_stack_char_destroy, libigraph), Cvoid, (Ptr{igraph_stack_char_t},), s)
end

function igraph_stack_char_reserve(s, capacity)
    ccall((:igraph_stack_char_reserve, libigraph), igraph_error_t, (Ptr{igraph_stack_char_t}, igraph_integer_t), s, capacity)
end

function igraph_stack_char_empty(s)
    ccall((:igraph_stack_char_empty, libigraph), igraph_bool_t, (Ptr{igraph_stack_char_t},), s)
end

function igraph_stack_char_size(s)
    ccall((:igraph_stack_char_size, libigraph), igraph_integer_t, (Ptr{igraph_stack_char_t},), s)
end

function igraph_stack_char_capacity(s)
    ccall((:igraph_stack_char_capacity, libigraph), igraph_integer_t, (Ptr{igraph_stack_char_t},), s)
end

function igraph_stack_char_clear(s)
    ccall((:igraph_stack_char_clear, libigraph), Cvoid, (Ptr{igraph_stack_char_t},), s)
end

function igraph_stack_char_push(s, elem)
    ccall((:igraph_stack_char_push, libigraph), igraph_error_t, (Ptr{igraph_stack_char_t}, Cchar), s, elem)
end

function igraph_stack_char_pop(s)
    ccall((:igraph_stack_char_pop, libigraph), Cchar, (Ptr{igraph_stack_char_t},), s)
end

function igraph_stack_char_top(s)
    ccall((:igraph_stack_char_top, libigraph), Cchar, (Ptr{igraph_stack_char_t},), s)
end

function igraph_stack_char_print(s)
    ccall((:igraph_stack_char_print, libigraph), igraph_error_t, (Ptr{igraph_stack_char_t},), s)
end

function igraph_stack_char_fprint(s, file)
    ccall((:igraph_stack_char_fprint, libigraph), igraph_error_t, (Ptr{igraph_stack_char_t}, Ptr{Libc.FILE}), s, file)
end

mutable struct igraph_stack_bool_t
    stor_begin::Ptr{igraph_bool_t}
    stor_end::Ptr{igraph_bool_t}
    _end::Ptr{igraph_bool_t}
    igraph_stack_bool_t() = new()
end

function igraph_stack_bool_init(s, capacity)
    ccall((:igraph_stack_bool_init, libigraph), igraph_error_t, (Ptr{igraph_stack_bool_t}, igraph_integer_t), s, capacity)
end

function igraph_stack_bool_destroy(s)
    ccall((:igraph_stack_bool_destroy, libigraph), Cvoid, (Ptr{igraph_stack_bool_t},), s)
end

function igraph_stack_bool_reserve(s, capacity)
    ccall((:igraph_stack_bool_reserve, libigraph), igraph_error_t, (Ptr{igraph_stack_bool_t}, igraph_integer_t), s, capacity)
end

function igraph_stack_bool_empty(s)
    ccall((:igraph_stack_bool_empty, libigraph), igraph_bool_t, (Ptr{igraph_stack_bool_t},), s)
end

function igraph_stack_bool_size(s)
    ccall((:igraph_stack_bool_size, libigraph), igraph_integer_t, (Ptr{igraph_stack_bool_t},), s)
end

function igraph_stack_bool_capacity(s)
    ccall((:igraph_stack_bool_capacity, libigraph), igraph_integer_t, (Ptr{igraph_stack_bool_t},), s)
end

function igraph_stack_bool_clear(s)
    ccall((:igraph_stack_bool_clear, libigraph), Cvoid, (Ptr{igraph_stack_bool_t},), s)
end

function igraph_stack_bool_push(s, elem)
    ccall((:igraph_stack_bool_push, libigraph), igraph_error_t, (Ptr{igraph_stack_bool_t}, igraph_bool_t), s, elem)
end

function igraph_stack_bool_pop(s)
    ccall((:igraph_stack_bool_pop, libigraph), igraph_bool_t, (Ptr{igraph_stack_bool_t},), s)
end

function igraph_stack_bool_top(s)
    ccall((:igraph_stack_bool_top, libigraph), igraph_bool_t, (Ptr{igraph_stack_bool_t},), s)
end

function igraph_stack_bool_print(s)
    ccall((:igraph_stack_bool_print, libigraph), igraph_error_t, (Ptr{igraph_stack_bool_t},), s)
end

function igraph_stack_bool_fprint(s, file)
    ccall((:igraph_stack_bool_fprint, libigraph), igraph_error_t, (Ptr{igraph_stack_bool_t}, Ptr{Libc.FILE}), s, file)
end

mutable struct igraph_heap_t
    stor_begin::Ptr{igraph_real_t}
    stor_end::Ptr{igraph_real_t}
    _end::Ptr{igraph_real_t}
    destroy::igraph_bool_t
    igraph_heap_t() = new()
end

function igraph_heap_init(h, capacity)
    ccall((:igraph_heap_init, libigraph), igraph_error_t, (Ptr{igraph_heap_t}, igraph_integer_t), h, capacity)
end

function igraph_heap_init_array(t, data, len)
    ccall((:igraph_heap_init_array, libigraph), igraph_error_t, (Ptr{igraph_heap_t}, Ptr{igraph_real_t}, igraph_integer_t), t, data, len)
end

function igraph_heap_destroy(h)
    ccall((:igraph_heap_destroy, libigraph), Cvoid, (Ptr{igraph_heap_t},), h)
end

function igraph_heap_clear(h)
    ccall((:igraph_heap_clear, libigraph), Cvoid, (Ptr{igraph_heap_t},), h)
end

function igraph_heap_empty(h)
    ccall((:igraph_heap_empty, libigraph), igraph_bool_t, (Ptr{igraph_heap_t},), h)
end

function igraph_heap_push(h, elem)
    ccall((:igraph_heap_push, libigraph), igraph_error_t, (Ptr{igraph_heap_t}, igraph_real_t), h, elem)
end

function igraph_heap_top(h)
    ccall((:igraph_heap_top, libigraph), igraph_real_t, (Ptr{igraph_heap_t},), h)
end

function igraph_heap_delete_top(h)
    ccall((:igraph_heap_delete_top, libigraph), igraph_real_t, (Ptr{igraph_heap_t},), h)
end

function igraph_heap_size(h)
    ccall((:igraph_heap_size, libigraph), igraph_integer_t, (Ptr{igraph_heap_t},), h)
end

function igraph_heap_reserve(h, capacity)
    ccall((:igraph_heap_reserve, libigraph), igraph_error_t, (Ptr{igraph_heap_t}, igraph_integer_t), h, capacity)
end

mutable struct igraph_heap_min_t
    stor_begin::Ptr{igraph_real_t}
    stor_end::Ptr{igraph_real_t}
    _end::Ptr{igraph_real_t}
    destroy::igraph_bool_t
    igraph_heap_min_t() = new()
end

function igraph_heap_min_init(h, capacity)
    ccall((:igraph_heap_min_init, libigraph), igraph_error_t, (Ptr{igraph_heap_min_t}, igraph_integer_t), h, capacity)
end

function igraph_heap_min_init_array(t, data, len)
    ccall((:igraph_heap_min_init_array, libigraph), igraph_error_t, (Ptr{igraph_heap_min_t}, Ptr{igraph_real_t}, igraph_integer_t), t, data, len)
end

function igraph_heap_min_destroy(h)
    ccall((:igraph_heap_min_destroy, libigraph), Cvoid, (Ptr{igraph_heap_min_t},), h)
end

function igraph_heap_min_clear(h)
    ccall((:igraph_heap_min_clear, libigraph), Cvoid, (Ptr{igraph_heap_min_t},), h)
end

function igraph_heap_min_empty(h)
    ccall((:igraph_heap_min_empty, libigraph), igraph_bool_t, (Ptr{igraph_heap_min_t},), h)
end

function igraph_heap_min_push(h, elem)
    ccall((:igraph_heap_min_push, libigraph), igraph_error_t, (Ptr{igraph_heap_min_t}, igraph_real_t), h, elem)
end

function igraph_heap_min_top(h)
    ccall((:igraph_heap_min_top, libigraph), igraph_real_t, (Ptr{igraph_heap_min_t},), h)
end

function igraph_heap_min_delete_top(h)
    ccall((:igraph_heap_min_delete_top, libigraph), igraph_real_t, (Ptr{igraph_heap_min_t},), h)
end

function igraph_heap_min_size(h)
    ccall((:igraph_heap_min_size, libigraph), igraph_integer_t, (Ptr{igraph_heap_min_t},), h)
end

function igraph_heap_min_reserve(h, capacity)
    ccall((:igraph_heap_min_reserve, libigraph), igraph_error_t, (Ptr{igraph_heap_min_t}, igraph_integer_t), h, capacity)
end

mutable struct igraph_heap_int_t
    stor_begin::Ptr{igraph_integer_t}
    stor_end::Ptr{igraph_integer_t}
    _end::Ptr{igraph_integer_t}
    destroy::igraph_bool_t
    igraph_heap_int_t() = new()
end

function igraph_heap_int_init(h, capacity)
    ccall((:igraph_heap_int_init, libigraph), igraph_error_t, (Ptr{igraph_heap_int_t}, igraph_integer_t), h, capacity)
end

function igraph_heap_int_init_array(t, data, len)
    ccall((:igraph_heap_int_init_array, libigraph), igraph_error_t, (Ptr{igraph_heap_int_t}, Ptr{igraph_integer_t}, igraph_integer_t), t, data, len)
end

function igraph_heap_int_destroy(h)
    ccall((:igraph_heap_int_destroy, libigraph), Cvoid, (Ptr{igraph_heap_int_t},), h)
end

function igraph_heap_int_clear(h)
    ccall((:igraph_heap_int_clear, libigraph), Cvoid, (Ptr{igraph_heap_int_t},), h)
end

function igraph_heap_int_empty(h)
    ccall((:igraph_heap_int_empty, libigraph), igraph_bool_t, (Ptr{igraph_heap_int_t},), h)
end

function igraph_heap_int_push(h, elem)
    ccall((:igraph_heap_int_push, libigraph), igraph_error_t, (Ptr{igraph_heap_int_t}, igraph_integer_t), h, elem)
end

function igraph_heap_int_top(h)
    ccall((:igraph_heap_int_top, libigraph), igraph_integer_t, (Ptr{igraph_heap_int_t},), h)
end

function igraph_heap_int_delete_top(h)
    ccall((:igraph_heap_int_delete_top, libigraph), igraph_integer_t, (Ptr{igraph_heap_int_t},), h)
end

function igraph_heap_int_size(h)
    ccall((:igraph_heap_int_size, libigraph), igraph_integer_t, (Ptr{igraph_heap_int_t},), h)
end

function igraph_heap_int_reserve(h, capacity)
    ccall((:igraph_heap_int_reserve, libigraph), igraph_error_t, (Ptr{igraph_heap_int_t}, igraph_integer_t), h, capacity)
end

mutable struct igraph_heap_min_int_t
    stor_begin::Ptr{igraph_integer_t}
    stor_end::Ptr{igraph_integer_t}
    _end::Ptr{igraph_integer_t}
    destroy::igraph_bool_t
    igraph_heap_min_int_t() = new()
end

function igraph_heap_min_int_init(h, capacity)
    ccall((:igraph_heap_min_int_init, libigraph), igraph_error_t, (Ptr{igraph_heap_min_int_t}, igraph_integer_t), h, capacity)
end

function igraph_heap_min_int_init_array(t, data, len)
    ccall((:igraph_heap_min_int_init_array, libigraph), igraph_error_t, (Ptr{igraph_heap_min_int_t}, Ptr{igraph_integer_t}, igraph_integer_t), t, data, len)
end

function igraph_heap_min_int_destroy(h)
    ccall((:igraph_heap_min_int_destroy, libigraph), Cvoid, (Ptr{igraph_heap_min_int_t},), h)
end

function igraph_heap_min_int_clear(h)
    ccall((:igraph_heap_min_int_clear, libigraph), Cvoid, (Ptr{igraph_heap_min_int_t},), h)
end

function igraph_heap_min_int_empty(h)
    ccall((:igraph_heap_min_int_empty, libigraph), igraph_bool_t, (Ptr{igraph_heap_min_int_t},), h)
end

function igraph_heap_min_int_push(h, elem)
    ccall((:igraph_heap_min_int_push, libigraph), igraph_error_t, (Ptr{igraph_heap_min_int_t}, igraph_integer_t), h, elem)
end

function igraph_heap_min_int_top(h)
    ccall((:igraph_heap_min_int_top, libigraph), igraph_integer_t, (Ptr{igraph_heap_min_int_t},), h)
end

function igraph_heap_min_int_delete_top(h)
    ccall((:igraph_heap_min_int_delete_top, libigraph), igraph_integer_t, (Ptr{igraph_heap_min_int_t},), h)
end

function igraph_heap_min_int_size(h)
    ccall((:igraph_heap_min_int_size, libigraph), igraph_integer_t, (Ptr{igraph_heap_min_int_t},), h)
end

function igraph_heap_min_int_reserve(h, capacity)
    ccall((:igraph_heap_min_int_reserve, libigraph), igraph_error_t, (Ptr{igraph_heap_min_int_t}, igraph_integer_t), h, capacity)
end

mutable struct igraph_heap_char_t
    stor_begin::Ptr{Cchar}
    stor_end::Ptr{Cchar}
    _end::Ptr{Cchar}
    destroy::igraph_bool_t
    igraph_heap_char_t() = new()
end

function igraph_heap_char_init(h, capacity)
    ccall((:igraph_heap_char_init, libigraph), igraph_error_t, (Ptr{igraph_heap_char_t}, igraph_integer_t), h, capacity)
end

function igraph_heap_char_init_array(t, data, len)
    ccall((:igraph_heap_char_init_array, libigraph), igraph_error_t, (Ptr{igraph_heap_char_t}, Ptr{Cchar}, igraph_integer_t), t, data, len)
end

function igraph_heap_char_destroy(h)
    ccall((:igraph_heap_char_destroy, libigraph), Cvoid, (Ptr{igraph_heap_char_t},), h)
end

function igraph_heap_char_clear(h)
    ccall((:igraph_heap_char_clear, libigraph), Cvoid, (Ptr{igraph_heap_char_t},), h)
end

function igraph_heap_char_empty(h)
    ccall((:igraph_heap_char_empty, libigraph), igraph_bool_t, (Ptr{igraph_heap_char_t},), h)
end

function igraph_heap_char_push(h, elem)
    ccall((:igraph_heap_char_push, libigraph), igraph_error_t, (Ptr{igraph_heap_char_t}, Cchar), h, elem)
end

function igraph_heap_char_top(h)
    ccall((:igraph_heap_char_top, libigraph), Cchar, (Ptr{igraph_heap_char_t},), h)
end

function igraph_heap_char_delete_top(h)
    ccall((:igraph_heap_char_delete_top, libigraph), Cchar, (Ptr{igraph_heap_char_t},), h)
end

function igraph_heap_char_size(h)
    ccall((:igraph_heap_char_size, libigraph), igraph_integer_t, (Ptr{igraph_heap_char_t},), h)
end

function igraph_heap_char_reserve(h, capacity)
    ccall((:igraph_heap_char_reserve, libigraph), igraph_error_t, (Ptr{igraph_heap_char_t}, igraph_integer_t), h, capacity)
end

mutable struct igraph_heap_min_char_t
    stor_begin::Ptr{Cchar}
    stor_end::Ptr{Cchar}
    _end::Ptr{Cchar}
    destroy::igraph_bool_t
    igraph_heap_min_char_t() = new()
end

function igraph_heap_min_char_init(h, capacity)
    ccall((:igraph_heap_min_char_init, libigraph), igraph_error_t, (Ptr{igraph_heap_min_char_t}, igraph_integer_t), h, capacity)
end

function igraph_heap_min_char_init_array(t, data, len)
    ccall((:igraph_heap_min_char_init_array, libigraph), igraph_error_t, (Ptr{igraph_heap_min_char_t}, Ptr{Cchar}, igraph_integer_t), t, data, len)
end

function igraph_heap_min_char_destroy(h)
    ccall((:igraph_heap_min_char_destroy, libigraph), Cvoid, (Ptr{igraph_heap_min_char_t},), h)
end

function igraph_heap_min_char_clear(h)
    ccall((:igraph_heap_min_char_clear, libigraph), Cvoid, (Ptr{igraph_heap_min_char_t},), h)
end

function igraph_heap_min_char_empty(h)
    ccall((:igraph_heap_min_char_empty, libigraph), igraph_bool_t, (Ptr{igraph_heap_min_char_t},), h)
end

function igraph_heap_min_char_push(h, elem)
    ccall((:igraph_heap_min_char_push, libigraph), igraph_error_t, (Ptr{igraph_heap_min_char_t}, Cchar), h, elem)
end

function igraph_heap_min_char_top(h)
    ccall((:igraph_heap_min_char_top, libigraph), Cchar, (Ptr{igraph_heap_min_char_t},), h)
end

function igraph_heap_min_char_delete_top(h)
    ccall((:igraph_heap_min_char_delete_top, libigraph), Cchar, (Ptr{igraph_heap_min_char_t},), h)
end

function igraph_heap_min_char_size(h)
    ccall((:igraph_heap_min_char_size, libigraph), igraph_integer_t, (Ptr{igraph_heap_min_char_t},), h)
end

function igraph_heap_min_char_reserve(h, capacity)
    ccall((:igraph_heap_min_char_reserve, libigraph), igraph_error_t, (Ptr{igraph_heap_min_char_t}, igraph_integer_t), h, capacity)
end

mutable struct igraph_psumtree_t
    v::igraph_vector_t
    size::igraph_integer_t
    offset::igraph_integer_t
    igraph_psumtree_t() = new()
end

function igraph_psumtree_init(t, size)
    ccall((:igraph_psumtree_init, libigraph), igraph_error_t, (Ptr{igraph_psumtree_t}, igraph_integer_t), t, size)
end

function igraph_psumtree_reset(t)
    ccall((:igraph_psumtree_reset, libigraph), Cvoid, (Ptr{igraph_psumtree_t},), t)
end

function igraph_psumtree_destroy(t)
    ccall((:igraph_psumtree_destroy, libigraph), Cvoid, (Ptr{igraph_psumtree_t},), t)
end

function igraph_psumtree_get(t, idx)
    ccall((:igraph_psumtree_get, libigraph), igraph_real_t, (Ptr{igraph_psumtree_t}, igraph_integer_t), t, idx)
end

function igraph_psumtree_size(t)
    ccall((:igraph_psumtree_size, libigraph), igraph_integer_t, (Ptr{igraph_psumtree_t},), t)
end

function igraph_psumtree_search(t, idx, elem)
    ccall((:igraph_psumtree_search, libigraph), igraph_error_t, (Ptr{igraph_psumtree_t}, Ptr{igraph_integer_t}, igraph_real_t), t, idx, elem)
end

function igraph_psumtree_update(t, idx, new_value)
    ccall((:igraph_psumtree_update, libigraph), igraph_error_t, (Ptr{igraph_psumtree_t}, igraph_integer_t, igraph_real_t), t, idx, new_value)
end

function igraph_psumtree_sum(t)
    ccall((:igraph_psumtree_sum, libigraph), igraph_real_t, (Ptr{igraph_psumtree_t},), t)
end

function igraph_strvector_size(sv)
    ccall((:igraph_strvector_size, libigraph), igraph_integer_t, (Ptr{igraph_strvector_t},), sv)
end

function igraph_strvector_capacity(sv)
    ccall((:igraph_strvector_capacity, libigraph), igraph_integer_t, (Ptr{igraph_strvector_t},), sv)
end

function igraph_strvector_set(sv, idx, value)
    ccall((:igraph_strvector_set, libigraph), igraph_error_t, (Ptr{igraph_strvector_t}, igraph_integer_t, Ptr{Cchar}), sv, idx, value)
end

function igraph_strvector_set_len(sv, idx, value, len)
    ccall((:igraph_strvector_set_len, libigraph), igraph_error_t, (Ptr{igraph_strvector_t}, igraph_integer_t, Ptr{Cchar}, Csize_t), sv, idx, value, len)
end

function igraph_strvector_clear(sv)
    ccall((:igraph_strvector_clear, libigraph), Cvoid, (Ptr{igraph_strvector_t},), sv)
end

function igraph_strvector_remove_section(v, from, to)
    ccall((:igraph_strvector_remove_section, libigraph), Cvoid, (Ptr{igraph_strvector_t}, igraph_integer_t, igraph_integer_t), v, from, to)
end

function igraph_strvector_remove(v, elem)
    ccall((:igraph_strvector_remove, libigraph), Cvoid, (Ptr{igraph_strvector_t}, igraph_integer_t), v, elem)
end

function igraph_strvector_init_copy(to, from)
    ccall((:igraph_strvector_init_copy, libigraph), igraph_error_t, (Ptr{igraph_strvector_t}, Ptr{igraph_strvector_t}), to, from)
end

function igraph_strvector_append(to, from)
    ccall((:igraph_strvector_append, libigraph), igraph_error_t, (Ptr{igraph_strvector_t}, Ptr{igraph_strvector_t}), to, from)
end

function igraph_strvector_merge(to, from)
    ccall((:igraph_strvector_merge, libigraph), igraph_error_t, (Ptr{igraph_strvector_t}, Ptr{igraph_strvector_t}), to, from)
end

function igraph_strvector_resize(v, newsize)
    ccall((:igraph_strvector_resize, libigraph), igraph_error_t, (Ptr{igraph_strvector_t}, igraph_integer_t), v, newsize)
end

function igraph_strvector_resize_min(sv)
    ccall((:igraph_strvector_resize_min, libigraph), Cvoid, (Ptr{igraph_strvector_t},), sv)
end

function igraph_strvector_push_back(v, value)
    ccall((:igraph_strvector_push_back, libigraph), igraph_error_t, (Ptr{igraph_strvector_t}, Ptr{Cchar}), v, value)
end

function igraph_strvector_push_back_len(v, value, len)
    ccall((:igraph_strvector_push_back_len, libigraph), igraph_error_t, (Ptr{igraph_strvector_t}, Ptr{Cchar}, igraph_integer_t), v, value, len)
end

function igraph_strvector_print(v, file, sep)
    ccall((:igraph_strvector_print, libigraph), igraph_error_t, (Ptr{igraph_strvector_t}, Ptr{Libc.FILE}, Ptr{Cchar}), v, file, sep)
end

function igraph_strvector_index(v, newv, idx)
    ccall((:igraph_strvector_index, libigraph), igraph_error_t, (Ptr{igraph_strvector_t}, Ptr{igraph_strvector_t}, Ptr{igraph_vector_int_t}), v, newv, idx)
end

function igraph_strvector_reserve(sv, capacity)
    ccall((:igraph_strvector_reserve, libigraph), igraph_error_t, (Ptr{igraph_strvector_t}, igraph_integer_t), sv, capacity)
end

function igraph_strvector_swap_elements(sv, i, j)
    ccall((:igraph_strvector_swap_elements, libigraph), Cvoid, (Ptr{igraph_strvector_t}, igraph_integer_t, igraph_integer_t), sv, i, j)
end

function igraph_strvector_add(v, value)
    ccall((:igraph_strvector_add, libigraph), igraph_error_t, (Ptr{igraph_strvector_t}, Ptr{Cchar}), v, value)
end

function igraph_strvector_copy(to, from)
    ccall((:igraph_strvector_copy, libigraph), igraph_error_t, (Ptr{igraph_strvector_t}, Ptr{igraph_strvector_t}), to, from)
end

function igraph_strvector_set2(sv, idx, value, len)
    ccall((:igraph_strvector_set2, libigraph), igraph_error_t, (Ptr{igraph_strvector_t}, igraph_integer_t, Ptr{Cchar}, Csize_t), sv, idx, value, len)
end

function igraph_vector_list_get_ptr(v, pos)
    ccall((:igraph_vector_list_get_ptr, libigraph), Ptr{igraph_vector_t}, (Ptr{igraph_vector_list_t}, igraph_integer_t), v, pos)
end

function igraph_vector_list_set(v, pos, e)
    ccall((:igraph_vector_list_set, libigraph), Cvoid, (Ptr{igraph_vector_list_t}, igraph_integer_t, Ptr{igraph_vector_t}), v, pos, e)
end

function igraph_vector_list_tail_ptr(v)
    ccall((:igraph_vector_list_tail_ptr, libigraph), Ptr{igraph_vector_t}, (Ptr{igraph_vector_list_t},), v)
end

function igraph_vector_list_capacity(v)
    ccall((:igraph_vector_list_capacity, libigraph), igraph_integer_t, (Ptr{igraph_vector_list_t},), v)
end

function igraph_vector_list_empty(v)
    ccall((:igraph_vector_list_empty, libigraph), igraph_bool_t, (Ptr{igraph_vector_list_t},), v)
end

function igraph_vector_list_size(v)
    ccall((:igraph_vector_list_size, libigraph), igraph_integer_t, (Ptr{igraph_vector_list_t},), v)
end

function igraph_vector_list_clear(v)
    ccall((:igraph_vector_list_clear, libigraph), Cvoid, (Ptr{igraph_vector_list_t},), v)
end

function igraph_vector_list_reserve(v, capacity)
    ccall((:igraph_vector_list_reserve, libigraph), igraph_error_t, (Ptr{igraph_vector_list_t}, igraph_integer_t), v, capacity)
end

function igraph_vector_list_resize(v, new_size)
    ccall((:igraph_vector_list_resize, libigraph), igraph_error_t, (Ptr{igraph_vector_list_t}, igraph_integer_t), v, new_size)
end

function igraph_vector_list_discard(v, index)
    ccall((:igraph_vector_list_discard, libigraph), Cvoid, (Ptr{igraph_vector_list_t}, igraph_integer_t), v, index)
end

function igraph_vector_list_discard_back(v)
    ccall((:igraph_vector_list_discard_back, libigraph), Cvoid, (Ptr{igraph_vector_list_t},), v)
end

function igraph_vector_list_discard_fast(v, index)
    ccall((:igraph_vector_list_discard_fast, libigraph), Cvoid, (Ptr{igraph_vector_list_t}, igraph_integer_t), v, index)
end

function igraph_vector_list_insert(v, pos, e)
    ccall((:igraph_vector_list_insert, libigraph), igraph_error_t, (Ptr{igraph_vector_list_t}, igraph_integer_t, Ptr{igraph_vector_t}), v, pos, e)
end

function igraph_vector_list_insert_copy(v, pos, e)
    ccall((:igraph_vector_list_insert_copy, libigraph), igraph_error_t, (Ptr{igraph_vector_list_t}, igraph_integer_t, Ptr{igraph_vector_t}), v, pos, e)
end

function igraph_vector_list_insert_new(v, pos, result)
    ccall((:igraph_vector_list_insert_new, libigraph), igraph_error_t, (Ptr{igraph_vector_list_t}, igraph_integer_t, Ptr{Ptr{igraph_vector_t}}), v, pos, result)
end

function igraph_vector_list_push_back(v, e)
    ccall((:igraph_vector_list_push_back, libigraph), igraph_error_t, (Ptr{igraph_vector_list_t}, Ptr{igraph_vector_t}), v, e)
end

function igraph_vector_list_push_back_copy(v, e)
    ccall((:igraph_vector_list_push_back_copy, libigraph), igraph_error_t, (Ptr{igraph_vector_list_t}, Ptr{igraph_vector_t}), v, e)
end

function igraph_vector_list_push_back_new(v, result)
    ccall((:igraph_vector_list_push_back_new, libigraph), igraph_error_t, (Ptr{igraph_vector_list_t}, Ptr{Ptr{igraph_vector_t}}), v, result)
end

function igraph_vector_list_pop_back(v)
    ccall((:igraph_vector_list_pop_back, libigraph), igraph_vector_t, (Ptr{igraph_vector_list_t},), v)
end

function igraph_vector_list_remove(v, index, e)
    ccall((:igraph_vector_list_remove, libigraph), igraph_error_t, (Ptr{igraph_vector_list_t}, igraph_integer_t, Ptr{igraph_vector_t}), v, index, e)
end

function igraph_vector_list_remove_fast(v, index, e)
    ccall((:igraph_vector_list_remove_fast, libigraph), igraph_error_t, (Ptr{igraph_vector_list_t}, igraph_integer_t, Ptr{igraph_vector_t}), v, index, e)
end

function igraph_vector_list_replace(v, pos, e)
    ccall((:igraph_vector_list_replace, libigraph), Cvoid, (Ptr{igraph_vector_list_t}, igraph_integer_t, Ptr{igraph_vector_t}), v, pos, e)
end

function igraph_vector_list_remove_consecutive_duplicates(v, eq)
    ccall((:igraph_vector_list_remove_consecutive_duplicates, libigraph), Cvoid, (Ptr{igraph_vector_list_t}, Ptr{Cvoid}), v, eq)
end

function igraph_vector_list_permute(v, index)
    ccall((:igraph_vector_list_permute, libigraph), igraph_error_t, (Ptr{igraph_vector_list_t}, Ptr{igraph_vector_int_t}), v, index)
end

function igraph_vector_list_reverse(v)
    ccall((:igraph_vector_list_reverse, libigraph), igraph_error_t, (Ptr{igraph_vector_list_t},), v)
end

function igraph_vector_list_swap(v1, v2)
    ccall((:igraph_vector_list_swap, libigraph), igraph_error_t, (Ptr{igraph_vector_list_t}, Ptr{igraph_vector_list_t}), v1, v2)
end

function igraph_vector_list_swap_elements(v, i, j)
    ccall((:igraph_vector_list_swap_elements, libigraph), igraph_error_t, (Ptr{igraph_vector_list_t}, igraph_integer_t, igraph_integer_t), v, i, j)
end

function igraph_vector_list_sort(v, cmp)
    ccall((:igraph_vector_list_sort, libigraph), Cvoid, (Ptr{igraph_vector_list_t}, Ptr{Cvoid}), v, cmp)
end

function igraph_vector_list_sort_ind(v, ind, cmp)
    ccall((:igraph_vector_list_sort_ind, libigraph), igraph_error_t, (Ptr{igraph_vector_list_t}, Ptr{igraph_vector_int_t}, Ptr{Cvoid}), v, ind, cmp)
end

function igraph_vector_int_list_get_ptr(v, pos)
    ccall((:igraph_vector_int_list_get_ptr, libigraph), Ptr{igraph_vector_int_t}, (Ptr{igraph_vector_int_list_t}, igraph_integer_t), v, pos)
end

function igraph_vector_int_list_set(v, pos, e)
    ccall((:igraph_vector_int_list_set, libigraph), Cvoid, (Ptr{igraph_vector_int_list_t}, igraph_integer_t, Ptr{igraph_vector_int_t}), v, pos, e)
end

function igraph_vector_int_list_tail_ptr(v)
    ccall((:igraph_vector_int_list_tail_ptr, libigraph), Ptr{igraph_vector_int_t}, (Ptr{igraph_vector_int_list_t},), v)
end

function igraph_vector_int_list_capacity(v)
    ccall((:igraph_vector_int_list_capacity, libigraph), igraph_integer_t, (Ptr{igraph_vector_int_list_t},), v)
end

function igraph_vector_int_list_empty(v)
    ccall((:igraph_vector_int_list_empty, libigraph), igraph_bool_t, (Ptr{igraph_vector_int_list_t},), v)
end

function igraph_vector_int_list_size(v)
    ccall((:igraph_vector_int_list_size, libigraph), igraph_integer_t, (Ptr{igraph_vector_int_list_t},), v)
end

function igraph_vector_int_list_clear(v)
    ccall((:igraph_vector_int_list_clear, libigraph), Cvoid, (Ptr{igraph_vector_int_list_t},), v)
end

function igraph_vector_int_list_reserve(v, capacity)
    ccall((:igraph_vector_int_list_reserve, libigraph), igraph_error_t, (Ptr{igraph_vector_int_list_t}, igraph_integer_t), v, capacity)
end

function igraph_vector_int_list_resize(v, new_size)
    ccall((:igraph_vector_int_list_resize, libigraph), igraph_error_t, (Ptr{igraph_vector_int_list_t}, igraph_integer_t), v, new_size)
end

function igraph_vector_int_list_discard(v, index)
    ccall((:igraph_vector_int_list_discard, libigraph), Cvoid, (Ptr{igraph_vector_int_list_t}, igraph_integer_t), v, index)
end

function igraph_vector_int_list_discard_back(v)
    ccall((:igraph_vector_int_list_discard_back, libigraph), Cvoid, (Ptr{igraph_vector_int_list_t},), v)
end

function igraph_vector_int_list_discard_fast(v, index)
    ccall((:igraph_vector_int_list_discard_fast, libigraph), Cvoid, (Ptr{igraph_vector_int_list_t}, igraph_integer_t), v, index)
end

function igraph_vector_int_list_insert(v, pos, e)
    ccall((:igraph_vector_int_list_insert, libigraph), igraph_error_t, (Ptr{igraph_vector_int_list_t}, igraph_integer_t, Ptr{igraph_vector_int_t}), v, pos, e)
end

function igraph_vector_int_list_insert_copy(v, pos, e)
    ccall((:igraph_vector_int_list_insert_copy, libigraph), igraph_error_t, (Ptr{igraph_vector_int_list_t}, igraph_integer_t, Ptr{igraph_vector_int_t}), v, pos, e)
end

function igraph_vector_int_list_insert_new(v, pos, result)
    ccall((:igraph_vector_int_list_insert_new, libigraph), igraph_error_t, (Ptr{igraph_vector_int_list_t}, igraph_integer_t, Ptr{Ptr{igraph_vector_int_t}}), v, pos, result)
end

function igraph_vector_int_list_push_back(v, e)
    ccall((:igraph_vector_int_list_push_back, libigraph), igraph_error_t, (Ptr{igraph_vector_int_list_t}, Ptr{igraph_vector_int_t}), v, e)
end

function igraph_vector_int_list_push_back_copy(v, e)
    ccall((:igraph_vector_int_list_push_back_copy, libigraph), igraph_error_t, (Ptr{igraph_vector_int_list_t}, Ptr{igraph_vector_int_t}), v, e)
end

function igraph_vector_int_list_push_back_new(v, result)
    ccall((:igraph_vector_int_list_push_back_new, libigraph), igraph_error_t, (Ptr{igraph_vector_int_list_t}, Ptr{Ptr{igraph_vector_int_t}}), v, result)
end

function igraph_vector_int_list_pop_back(v)
    ccall((:igraph_vector_int_list_pop_back, libigraph), igraph_vector_int_t, (Ptr{igraph_vector_int_list_t},), v)
end

function igraph_vector_int_list_remove(v, index, e)
    ccall((:igraph_vector_int_list_remove, libigraph), igraph_error_t, (Ptr{igraph_vector_int_list_t}, igraph_integer_t, Ptr{igraph_vector_int_t}), v, index, e)
end

function igraph_vector_int_list_remove_fast(v, index, e)
    ccall((:igraph_vector_int_list_remove_fast, libigraph), igraph_error_t, (Ptr{igraph_vector_int_list_t}, igraph_integer_t, Ptr{igraph_vector_int_t}), v, index, e)
end

function igraph_vector_int_list_replace(v, pos, e)
    ccall((:igraph_vector_int_list_replace, libigraph), Cvoid, (Ptr{igraph_vector_int_list_t}, igraph_integer_t, Ptr{igraph_vector_int_t}), v, pos, e)
end

function igraph_vector_int_list_remove_consecutive_duplicates(v, eq)
    ccall((:igraph_vector_int_list_remove_consecutive_duplicates, libigraph), Cvoid, (Ptr{igraph_vector_int_list_t}, Ptr{Cvoid}), v, eq)
end

function igraph_vector_int_list_permute(v, index)
    ccall((:igraph_vector_int_list_permute, libigraph), igraph_error_t, (Ptr{igraph_vector_int_list_t}, Ptr{igraph_vector_int_t}), v, index)
end

function igraph_vector_int_list_reverse(v)
    ccall((:igraph_vector_int_list_reverse, libigraph), igraph_error_t, (Ptr{igraph_vector_int_list_t},), v)
end

function igraph_vector_int_list_swap(v1, v2)
    ccall((:igraph_vector_int_list_swap, libigraph), igraph_error_t, (Ptr{igraph_vector_int_list_t}, Ptr{igraph_vector_int_list_t}), v1, v2)
end

function igraph_vector_int_list_swap_elements(v, i, j)
    ccall((:igraph_vector_int_list_swap_elements, libigraph), igraph_error_t, (Ptr{igraph_vector_int_list_t}, igraph_integer_t, igraph_integer_t), v, i, j)
end

function igraph_vector_int_list_sort(v, cmp)
    ccall((:igraph_vector_int_list_sort, libigraph), Cvoid, (Ptr{igraph_vector_int_list_t}, Ptr{Cvoid}), v, cmp)
end

function igraph_vector_int_list_sort_ind(v, ind, cmp)
    ccall((:igraph_vector_int_list_sort_ind, libigraph), igraph_error_t, (Ptr{igraph_vector_int_list_t}, Ptr{igraph_vector_int_t}, Ptr{Cvoid}), v, ind, cmp)
end

function igraph_vector_ptr_init_array(v, data, length)
    ccall((:igraph_vector_ptr_init_array, libigraph), igraph_error_t, (Ptr{igraph_vector_ptr_t}, Ptr{Ptr{Cvoid}}, igraph_integer_t), v, data, length)
end

function igraph_vector_ptr_init_copy(to, from)
    ccall((:igraph_vector_ptr_init_copy, libigraph), igraph_error_t, (Ptr{igraph_vector_ptr_t}, Ptr{igraph_vector_ptr_t}), to, from)
end

function igraph_vector_ptr_view(v, data, length)
    ccall((:igraph_vector_ptr_view, libigraph), Ptr{igraph_vector_ptr_t}, (Ptr{igraph_vector_ptr_t}, Ptr{Ptr{Cvoid}}, igraph_integer_t), v, data, length)
end

function igraph_vector_ptr_free_all(v)
    ccall((:igraph_vector_ptr_free_all, libigraph), Cvoid, (Ptr{igraph_vector_ptr_t},), v)
end

function igraph_vector_ptr_destroy_all(v)
    ccall((:igraph_vector_ptr_destroy_all, libigraph), Cvoid, (Ptr{igraph_vector_ptr_t},), v)
end

function igraph_vector_ptr_reserve(v, capacity)
    ccall((:igraph_vector_ptr_reserve, libigraph), igraph_error_t, (Ptr{igraph_vector_ptr_t}, igraph_integer_t), v, capacity)
end

function igraph_vector_ptr_empty(v)
    ccall((:igraph_vector_ptr_empty, libigraph), igraph_bool_t, (Ptr{igraph_vector_ptr_t},), v)
end

function igraph_vector_ptr_size(v)
    ccall((:igraph_vector_ptr_size, libigraph), igraph_integer_t, (Ptr{igraph_vector_ptr_t},), v)
end

function igraph_vector_ptr_clear(v)
    ccall((:igraph_vector_ptr_clear, libigraph), Cvoid, (Ptr{igraph_vector_ptr_t},), v)
end

function igraph_vector_ptr_null(v)
    ccall((:igraph_vector_ptr_null, libigraph), Cvoid, (Ptr{igraph_vector_ptr_t},), v)
end

function igraph_vector_ptr_push_back(v, e)
    ccall((:igraph_vector_ptr_push_back, libigraph), igraph_error_t, (Ptr{igraph_vector_ptr_t}, Ptr{Cvoid}), v, e)
end

function igraph_vector_ptr_append(to, from)
    ccall((:igraph_vector_ptr_append, libigraph), igraph_error_t, (Ptr{igraph_vector_ptr_t}, Ptr{igraph_vector_ptr_t}), to, from)
end

function igraph_vector_ptr_pop_back(v)
    ccall((:igraph_vector_ptr_pop_back, libigraph), Ptr{Cvoid}, (Ptr{igraph_vector_ptr_t},), v)
end

function igraph_vector_ptr_insert(v, pos, e)
    ccall((:igraph_vector_ptr_insert, libigraph), igraph_error_t, (Ptr{igraph_vector_ptr_t}, igraph_integer_t, Ptr{Cvoid}), v, pos, e)
end

function igraph_vector_ptr_e(v, pos)
    ccall((:igraph_vector_ptr_e, libigraph), Ptr{Cvoid}, (Ptr{igraph_vector_ptr_t}, igraph_integer_t), v, pos)
end

function igraph_vector_ptr_get(v, pos)
    ccall((:igraph_vector_ptr_get, libigraph), Ptr{Cvoid}, (Ptr{igraph_vector_ptr_t}, igraph_integer_t), v, pos)
end

function igraph_vector_ptr_set(v, pos, value)
    ccall((:igraph_vector_ptr_set, libigraph), Cvoid, (Ptr{igraph_vector_ptr_t}, igraph_integer_t, Ptr{Cvoid}), v, pos, value)
end

function igraph_vector_ptr_resize(v, newsize)
    ccall((:igraph_vector_ptr_resize, libigraph), igraph_error_t, (Ptr{igraph_vector_ptr_t}, igraph_integer_t), v, newsize)
end

function igraph_vector_ptr_copy_to(v, to)
    ccall((:igraph_vector_ptr_copy_to, libigraph), Cvoid, (Ptr{igraph_vector_ptr_t}, Ptr{Ptr{Cvoid}}), v, to)
end

function igraph_vector_ptr_permute(v, index)
    ccall((:igraph_vector_ptr_permute, libigraph), igraph_error_t, (Ptr{igraph_vector_ptr_t}, Ptr{igraph_vector_int_t}), v, index)
end

function igraph_vector_ptr_remove(v, pos)
    ccall((:igraph_vector_ptr_remove, libigraph), Cvoid, (Ptr{igraph_vector_ptr_t}, igraph_integer_t), v, pos)
end

function igraph_vector_ptr_sort(v, compar)
    ccall((:igraph_vector_ptr_sort, libigraph), Cvoid, (Ptr{igraph_vector_ptr_t}, Ptr{Cvoid}), v, compar)
end

function igraph_vector_ptr_sort_ind(v, inds, compar)
    ccall((:igraph_vector_ptr_sort_ind, libigraph), igraph_error_t, (Ptr{igraph_vector_ptr_t}, Ptr{igraph_vector_int_t}, Ptr{Cvoid}), v, inds, compar)
end

function igraph_vector_ptr_get_item_destructor(v)
    ccall((:igraph_vector_ptr_get_item_destructor, libigraph), Ptr{igraph_finally_func_t}, (Ptr{igraph_vector_ptr_t},), v)
end

function igraph_vector_ptr_copy(to, from)
    ccall((:igraph_vector_ptr_copy, libigraph), igraph_error_t, (Ptr{igraph_vector_ptr_t}, Ptr{igraph_vector_ptr_t}), to, from)
end

function igraph_invalidate_cache(graph)
    ccall((:igraph_invalidate_cache, libigraph), Cvoid, (Ptr{igraph_t},), graph)
end

struct igraph_arpack_options_t
    bmat::NTuple{1, Cchar}
    n::Cint
    which::NTuple{2, Cchar}
    nev::Cint
    tol::igraph_real_t
    ncv::Cint
    ldv::Cint
    ishift::Cint
    mxiter::Cint
    nb::Cint
    mode::Cint
    start::Cint
    lworkl::Cint
    sigma::igraph_real_t
    sigmai::igraph_real_t
    info::Cint
    ierr::Cint
    noiter::Cint
    nconv::Cint
    numop::Cint
    numopb::Cint
    numreo::Cint
    iparam::NTuple{11, Cint}
    ipntr::NTuple{14, Cint}
end

struct igraph_arpack_storage_t
    maxn::Cint
    maxncv::Cint
    maxldv::Cint
    v::Ptr{igraph_real_t}
    workl::Ptr{igraph_real_t}
    workd::Ptr{igraph_real_t}
    d::Ptr{igraph_real_t}
    resid::Ptr{igraph_real_t}
    ax::Ptr{igraph_real_t}
    select::Ptr{Cint}
    di::Ptr{igraph_real_t}
    workev::Ptr{igraph_real_t}
end

function igraph_arpack_options_init(o)
    ccall((:igraph_arpack_options_init, libigraph), Cvoid, (Ptr{igraph_arpack_options_t},), o)
end

function igraph_arpack_options_get_default()
    ccall((:igraph_arpack_options_get_default, libigraph), Ptr{igraph_arpack_options_t}, ())
end

function igraph_arpack_storage_init(s, maxn, maxncv, maxldv, symm)
    ccall((:igraph_arpack_storage_init, libigraph), igraph_error_t, (Ptr{igraph_arpack_storage_t}, igraph_integer_t, igraph_integer_t, igraph_integer_t, igraph_bool_t), s, maxn, maxncv, maxldv, symm)
end

function igraph_arpack_storage_destroy(s)
    ccall((:igraph_arpack_storage_destroy, libigraph), Cvoid, (Ptr{igraph_arpack_storage_t},), s)
end

# typedef igraph_error_t igraph_arpack_function_t ( igraph_real_t * to , const igraph_real_t * from , int n , void * extra )
const igraph_arpack_function_t = Cvoid

function igraph_arpack_rssolve(fun, extra, options, storage, values, vectors)
    ccall((:igraph_arpack_rssolve, libigraph), igraph_error_t, (Ptr{igraph_arpack_function_t}, Ptr{Cvoid}, Ptr{igraph_arpack_options_t}, Ptr{igraph_arpack_storage_t}, Ptr{igraph_vector_t}, Ptr{igraph_matrix_t}), fun, extra, options, storage, values, vectors)
end

function igraph_arpack_rnsolve(fun, extra, options, storage, values, vectors)
    ccall((:igraph_arpack_rnsolve, libigraph), igraph_error_t, (Ptr{igraph_arpack_function_t}, Ptr{Cvoid}, Ptr{igraph_arpack_options_t}, Ptr{igraph_arpack_storage_t}, Ptr{igraph_matrix_t}, Ptr{igraph_matrix_t}), fun, extra, options, storage, values, vectors)
end

function igraph_arpack_unpack_complex(vectors, values, nev)
    ccall((:igraph_arpack_unpack_complex, libigraph), igraph_error_t, (Ptr{igraph_matrix_t}, Ptr{igraph_matrix_t}, igraph_integer_t), vectors, values, nev)
end

mutable struct cs_igraph_sparse end

struct igraph_sparsemat_t
    cs::Ptr{cs_igraph_sparse}
end

mutable struct cs_igraph_symbolic end

mutable struct igraph_sparsemat_symbolic_t
    symbolic::Ptr{cs_igraph_symbolic}
    igraph_sparsemat_symbolic_t() = new()
end

mutable struct cs_igraph_numeric end

mutable struct igraph_sparsemat_numeric_t
    numeric::Ptr{cs_igraph_numeric}
    igraph_sparsemat_numeric_t() = new()
end

@cenum igraph_sparsemat_type_t::UInt32 begin
    IGRAPH_SPARSEMAT_TRIPLET = 0
    IGRAPH_SPARSEMAT_CC = 1
end

mutable struct igraph_sparsemat_iterator_t
    mat::Ptr{igraph_sparsemat_t}
    pos::igraph_integer_t
    col::igraph_integer_t
    igraph_sparsemat_iterator_t() = new()
end

function igraph_sparsemat_init(A, rows, cols, nzmax)
    ccall((:igraph_sparsemat_init, libigraph), igraph_error_t, (Ptr{igraph_sparsemat_t}, igraph_integer_t, igraph_integer_t, igraph_integer_t), A, rows, cols, nzmax)
end

function igraph_sparsemat_init_copy(to, from)
    ccall((:igraph_sparsemat_init_copy, libigraph), igraph_error_t, (Ptr{igraph_sparsemat_t}, Ptr{igraph_sparsemat_t}), to, from)
end

function igraph_sparsemat_destroy(A)
    ccall((:igraph_sparsemat_destroy, libigraph), Cvoid, (Ptr{igraph_sparsemat_t},), A)
end

function igraph_sparsemat_realloc(A, nzmax)
    ccall((:igraph_sparsemat_realloc, libigraph), igraph_error_t, (Ptr{igraph_sparsemat_t}, igraph_integer_t), A, nzmax)
end

function igraph_sparsemat_init_eye(A, n, nzmax, value, compress)
    ccall((:igraph_sparsemat_init_eye, libigraph), igraph_error_t, (Ptr{igraph_sparsemat_t}, igraph_integer_t, igraph_integer_t, igraph_real_t, igraph_bool_t), A, n, nzmax, value, compress)
end

function igraph_sparsemat_init_diag(A, nzmax, values, compress)
    ccall((:igraph_sparsemat_init_diag, libigraph), igraph_error_t, (Ptr{igraph_sparsemat_t}, igraph_integer_t, Ptr{igraph_vector_t}, igraph_bool_t), A, nzmax, values, compress)
end

function igraph_sparsemat_nrow(A)
    ccall((:igraph_sparsemat_nrow, libigraph), igraph_integer_t, (Ptr{igraph_sparsemat_t},), A)
end

function igraph_sparsemat_ncol(B)
    ccall((:igraph_sparsemat_ncol, libigraph), igraph_integer_t, (Ptr{igraph_sparsemat_t},), B)
end

function igraph_sparsemat_type(A)
    ccall((:igraph_sparsemat_type, libigraph), igraph_sparsemat_type_t, (Ptr{igraph_sparsemat_t},), A)
end

function igraph_sparsemat_is_triplet(A)
    ccall((:igraph_sparsemat_is_triplet, libigraph), igraph_bool_t, (Ptr{igraph_sparsemat_t},), A)
end

function igraph_sparsemat_is_cc(A)
    ccall((:igraph_sparsemat_is_cc, libigraph), igraph_bool_t, (Ptr{igraph_sparsemat_t},), A)
end

function igraph_sparsemat_permute(A, p, q, res)
    ccall((:igraph_sparsemat_permute, libigraph), igraph_error_t, (Ptr{igraph_sparsemat_t}, Ptr{igraph_vector_int_t}, Ptr{igraph_vector_int_t}, Ptr{igraph_sparsemat_t}), A, p, q, res)
end

function igraph_sparsemat_get(A, row, col)
    ccall((:igraph_sparsemat_get, libigraph), igraph_real_t, (Ptr{igraph_sparsemat_t}, igraph_integer_t, igraph_integer_t), A, row, col)
end

function igraph_sparsemat_index(A, p, q, res, constres)
    ccall((:igraph_sparsemat_index, libigraph), igraph_error_t, (Ptr{igraph_sparsemat_t}, Ptr{igraph_vector_int_t}, Ptr{igraph_vector_int_t}, Ptr{igraph_sparsemat_t}, Ptr{igraph_real_t}), A, p, q, res, constres)
end

function igraph_sparsemat_entry(A, row, col, elem)
    ccall((:igraph_sparsemat_entry, libigraph), igraph_error_t, (Ptr{igraph_sparsemat_t}, igraph_integer_t, igraph_integer_t, igraph_real_t), A, row, col, elem)
end

function igraph_sparsemat_compress(A, res)
    ccall((:igraph_sparsemat_compress, libigraph), igraph_error_t, (Ptr{igraph_sparsemat_t}, Ptr{igraph_sparsemat_t}), A, res)
end

function igraph_sparsemat_transpose(A, res)
    ccall((:igraph_sparsemat_transpose, libigraph), igraph_error_t, (Ptr{igraph_sparsemat_t}, Ptr{igraph_sparsemat_t}), A, res)
end

function igraph_sparsemat_is_symmetric(A, result)
    ccall((:igraph_sparsemat_is_symmetric, libigraph), igraph_error_t, (Ptr{igraph_sparsemat_t}, Ptr{igraph_bool_t}), A, result)
end

function igraph_sparsemat_dupl(A)
    ccall((:igraph_sparsemat_dupl, libigraph), igraph_error_t, (Ptr{igraph_sparsemat_t},), A)
end

function igraph_sparsemat_fkeep(A, fkeep, other)
    ccall((:igraph_sparsemat_fkeep, libigraph), igraph_error_t, (Ptr{igraph_sparsemat_t}, Ptr{Cvoid}, Ptr{Cvoid}), A, fkeep, other)
end

function igraph_sparsemat_dropzeros(A)
    ccall((:igraph_sparsemat_dropzeros, libigraph), igraph_error_t, (Ptr{igraph_sparsemat_t},), A)
end

function igraph_sparsemat_droptol(A, tol)
    ccall((:igraph_sparsemat_droptol, libigraph), igraph_error_t, (Ptr{igraph_sparsemat_t}, igraph_real_t), A, tol)
end

function igraph_sparsemat_multiply(A, B, res)
    ccall((:igraph_sparsemat_multiply, libigraph), igraph_error_t, (Ptr{igraph_sparsemat_t}, Ptr{igraph_sparsemat_t}, Ptr{igraph_sparsemat_t}), A, B, res)
end

function igraph_sparsemat_add(A, B, alpha, beta, res)
    ccall((:igraph_sparsemat_add, libigraph), igraph_error_t, (Ptr{igraph_sparsemat_t}, Ptr{igraph_sparsemat_t}, igraph_real_t, igraph_real_t, Ptr{igraph_sparsemat_t}), A, B, alpha, beta, res)
end

function igraph_sparsemat_gaxpy(A, x, res)
    ccall((:igraph_sparsemat_gaxpy, libigraph), igraph_error_t, (Ptr{igraph_sparsemat_t}, Ptr{igraph_vector_t}, Ptr{igraph_vector_t}), A, x, res)
end

function igraph_sparsemat_lsolve(A, b, res)
    ccall((:igraph_sparsemat_lsolve, libigraph), igraph_error_t, (Ptr{igraph_sparsemat_t}, Ptr{igraph_vector_t}, Ptr{igraph_vector_t}), A, b, res)
end

function igraph_sparsemat_ltsolve(A, b, res)
    ccall((:igraph_sparsemat_ltsolve, libigraph), igraph_error_t, (Ptr{igraph_sparsemat_t}, Ptr{igraph_vector_t}, Ptr{igraph_vector_t}), A, b, res)
end

function igraph_sparsemat_usolve(A, b, res)
    ccall((:igraph_sparsemat_usolve, libigraph), igraph_error_t, (Ptr{igraph_sparsemat_t}, Ptr{igraph_vector_t}, Ptr{igraph_vector_t}), A, b, res)
end

function igraph_sparsemat_utsolve(A, b, res)
    ccall((:igraph_sparsemat_utsolve, libigraph), igraph_error_t, (Ptr{igraph_sparsemat_t}, Ptr{igraph_vector_t}, Ptr{igraph_vector_t}), A, b, res)
end

function igraph_sparsemat_cholsol(A, b, res, order)
    ccall((:igraph_sparsemat_cholsol, libigraph), igraph_error_t, (Ptr{igraph_sparsemat_t}, Ptr{igraph_vector_t}, Ptr{igraph_vector_t}, igraph_integer_t), A, b, res, order)
end

function igraph_sparsemat_lusol(A, b, res, order, tol)
    ccall((:igraph_sparsemat_lusol, libigraph), igraph_error_t, (Ptr{igraph_sparsemat_t}, Ptr{igraph_vector_t}, Ptr{igraph_vector_t}, igraph_integer_t, igraph_real_t), A, b, res, order, tol)
end

function igraph_sparsemat_print(A, outstream)
    ccall((:igraph_sparsemat_print, libigraph), igraph_error_t, (Ptr{igraph_sparsemat_t}, Ptr{Libc.FILE}), A, outstream)
end

function igraph_sparsemat(graph, A, directed)
    ccall((:igraph_sparsemat, libigraph), igraph_error_t, (Ptr{igraph_t}, Ptr{igraph_sparsemat_t}, igraph_bool_t), graph, A, directed)
end

function igraph_weighted_sparsemat(graph, A, directed, attr, loops)
    ccall((:igraph_weighted_sparsemat, libigraph), igraph_error_t, (Ptr{igraph_t}, Ptr{igraph_sparsemat_t}, igraph_bool_t, Ptr{Cchar}, igraph_bool_t), graph, A, directed, attr, loops)
end

function igraph_matrix_as_sparsemat(res, mat, tol)
    ccall((:igraph_matrix_as_sparsemat, libigraph), igraph_error_t, (Ptr{igraph_sparsemat_t}, Ptr{igraph_matrix_t}, igraph_real_t), res, mat, tol)
end

function igraph_sparsemat_as_matrix(res, spmat)
    ccall((:igraph_sparsemat_as_matrix, libigraph), igraph_error_t, (Ptr{igraph_matrix_t}, Ptr{igraph_sparsemat_t}), res, spmat)
end

@cenum igraph_sparsemat_solve_t::UInt32 begin
    IGRAPH_SPARSEMAT_SOLVE_LU = 0
    IGRAPH_SPARSEMAT_SOLVE_QR = 1
end

function igraph_sparsemat_arpack_rssolve(A, options, storage, values, vectors, solvemethod)
    ccall((:igraph_sparsemat_arpack_rssolve, libigraph), igraph_error_t, (Ptr{igraph_sparsemat_t}, Ptr{igraph_arpack_options_t}, Ptr{igraph_arpack_storage_t}, Ptr{igraph_vector_t}, Ptr{igraph_matrix_t}, igraph_sparsemat_solve_t), A, options, storage, values, vectors, solvemethod)
end

function igraph_sparsemat_arpack_rnsolve(A, options, storage, values, vectors)
    ccall((:igraph_sparsemat_arpack_rnsolve, libigraph), igraph_error_t, (Ptr{igraph_sparsemat_t}, Ptr{igraph_arpack_options_t}, Ptr{igraph_arpack_storage_t}, Ptr{igraph_matrix_t}, Ptr{igraph_matrix_t}), A, options, storage, values, vectors)
end

function igraph_sparsemat_lu(A, dis, din, tol)
    ccall((:igraph_sparsemat_lu, libigraph), igraph_error_t, (Ptr{igraph_sparsemat_t}, Ptr{igraph_sparsemat_symbolic_t}, Ptr{igraph_sparsemat_numeric_t}, Cdouble), A, dis, din, tol)
end

function igraph_sparsemat_qr(A, dis, din)
    ccall((:igraph_sparsemat_qr, libigraph), igraph_error_t, (Ptr{igraph_sparsemat_t}, Ptr{igraph_sparsemat_symbolic_t}, Ptr{igraph_sparsemat_numeric_t}), A, dis, din)
end

function igraph_sparsemat_luresol(dis, din, b, res)
    ccall((:igraph_sparsemat_luresol, libigraph), igraph_error_t, (Ptr{igraph_sparsemat_symbolic_t}, Ptr{igraph_sparsemat_numeric_t}, Ptr{igraph_vector_t}, Ptr{igraph_vector_t}), dis, din, b, res)
end

function igraph_sparsemat_qrresol(dis, din, b, res)
    ccall((:igraph_sparsemat_qrresol, libigraph), igraph_error_t, (Ptr{igraph_sparsemat_symbolic_t}, Ptr{igraph_sparsemat_numeric_t}, Ptr{igraph_vector_t}, Ptr{igraph_vector_t}), dis, din, b, res)
end

function igraph_sparsemat_symbqr(order, A, dis)
    ccall((:igraph_sparsemat_symbqr, libigraph), igraph_error_t, (igraph_integer_t, Ptr{igraph_sparsemat_t}, Ptr{igraph_sparsemat_symbolic_t}), order, A, dis)
end

function igraph_sparsemat_symblu(order, A, dis)
    ccall((:igraph_sparsemat_symblu, libigraph), igraph_error_t, (igraph_integer_t, Ptr{igraph_sparsemat_t}, Ptr{igraph_sparsemat_symbolic_t}), order, A, dis)
end

function igraph_sparsemat_symbolic_destroy(dis)
    ccall((:igraph_sparsemat_symbolic_destroy, libigraph), Cvoid, (Ptr{igraph_sparsemat_symbolic_t},), dis)
end

function igraph_sparsemat_numeric_destroy(din)
    ccall((:igraph_sparsemat_numeric_destroy, libigraph), Cvoid, (Ptr{igraph_sparsemat_numeric_t},), din)
end

function igraph_sparsemat_max(A)
    ccall((:igraph_sparsemat_max, libigraph), igraph_real_t, (Ptr{igraph_sparsemat_t},), A)
end

function igraph_sparsemat_min(A)
    ccall((:igraph_sparsemat_min, libigraph), igraph_real_t, (Ptr{igraph_sparsemat_t},), A)
end

function igraph_sparsemat_minmax(A, min, max)
    ccall((:igraph_sparsemat_minmax, libigraph), igraph_error_t, (Ptr{igraph_sparsemat_t}, Ptr{igraph_real_t}, Ptr{igraph_real_t}), A, min, max)
end

function igraph_sparsemat_count_nonzero(A)
    ccall((:igraph_sparsemat_count_nonzero, libigraph), igraph_integer_t, (Ptr{igraph_sparsemat_t},), A)
end

function igraph_sparsemat_count_nonzerotol(A, tol)
    ccall((:igraph_sparsemat_count_nonzerotol, libigraph), igraph_integer_t, (Ptr{igraph_sparsemat_t}, igraph_real_t), A, tol)
end

function igraph_sparsemat_rowsums(A, res)
    ccall((:igraph_sparsemat_rowsums, libigraph), igraph_error_t, (Ptr{igraph_sparsemat_t}, Ptr{igraph_vector_t}), A, res)
end

function igraph_sparsemat_colsums(A, res)
    ccall((:igraph_sparsemat_colsums, libigraph), igraph_error_t, (Ptr{igraph_sparsemat_t}, Ptr{igraph_vector_t}), A, res)
end

function igraph_sparsemat_rowmins(A, res)
    ccall((:igraph_sparsemat_rowmins, libigraph), igraph_error_t, (Ptr{igraph_sparsemat_t}, Ptr{igraph_vector_t}), A, res)
end

function igraph_sparsemat_colmins(A, res)
    ccall((:igraph_sparsemat_colmins, libigraph), igraph_error_t, (Ptr{igraph_sparsemat_t}, Ptr{igraph_vector_t}), A, res)
end

function igraph_sparsemat_rowmaxs(A, res)
    ccall((:igraph_sparsemat_rowmaxs, libigraph), igraph_error_t, (Ptr{igraph_sparsemat_t}, Ptr{igraph_vector_t}), A, res)
end

function igraph_sparsemat_colmaxs(A, res)
    ccall((:igraph_sparsemat_colmaxs, libigraph), igraph_error_t, (Ptr{igraph_sparsemat_t}, Ptr{igraph_vector_t}), A, res)
end

function igraph_sparsemat_which_min_rows(A, res, pos)
    ccall((:igraph_sparsemat_which_min_rows, libigraph), igraph_error_t, (Ptr{igraph_sparsemat_t}, Ptr{igraph_vector_t}, Ptr{igraph_vector_int_t}), A, res, pos)
end

function igraph_sparsemat_which_min_cols(A, res, pos)
    ccall((:igraph_sparsemat_which_min_cols, libigraph), igraph_error_t, (Ptr{igraph_sparsemat_t}, Ptr{igraph_vector_t}, Ptr{igraph_vector_int_t}), A, res, pos)
end

function igraph_sparsemat_scale(A, by)
    ccall((:igraph_sparsemat_scale, libigraph), igraph_error_t, (Ptr{igraph_sparsemat_t}, igraph_real_t), A, by)
end

function igraph_sparsemat_add_rows(A, n)
    ccall((:igraph_sparsemat_add_rows, libigraph), igraph_error_t, (Ptr{igraph_sparsemat_t}, igraph_integer_t), A, n)
end

function igraph_sparsemat_add_cols(A, n)
    ccall((:igraph_sparsemat_add_cols, libigraph), igraph_error_t, (Ptr{igraph_sparsemat_t}, igraph_integer_t), A, n)
end

function igraph_sparsemat_resize(A, nrow, ncol, nzmax)
    ccall((:igraph_sparsemat_resize, libigraph), igraph_error_t, (Ptr{igraph_sparsemat_t}, igraph_integer_t, igraph_integer_t, igraph_integer_t), A, nrow, ncol, nzmax)
end

function igraph_sparsemat_nonzero_storage(A)
    ccall((:igraph_sparsemat_nonzero_storage, libigraph), igraph_integer_t, (Ptr{igraph_sparsemat_t},), A)
end

function igraph_sparsemat_getelements(A, i, j, x)
    ccall((:igraph_sparsemat_getelements, libigraph), igraph_error_t, (Ptr{igraph_sparsemat_t}, Ptr{igraph_vector_int_t}, Ptr{igraph_vector_int_t}, Ptr{igraph_vector_t}), A, i, j, x)
end

function igraph_sparsemat_getelements_sorted(A, i, j, x)
    ccall((:igraph_sparsemat_getelements_sorted, libigraph), igraph_error_t, (Ptr{igraph_sparsemat_t}, Ptr{igraph_vector_int_t}, Ptr{igraph_vector_int_t}, Ptr{igraph_vector_t}), A, i, j, x)
end

function igraph_sparsemat_scale_rows(A, fact)
    ccall((:igraph_sparsemat_scale_rows, libigraph), igraph_error_t, (Ptr{igraph_sparsemat_t}, Ptr{igraph_vector_t}), A, fact)
end

function igraph_sparsemat_scale_cols(A, fact)
    ccall((:igraph_sparsemat_scale_cols, libigraph), igraph_error_t, (Ptr{igraph_sparsemat_t}, Ptr{igraph_vector_t}), A, fact)
end

function igraph_sparsemat_multiply_by_dense(A, B, res)
    ccall((:igraph_sparsemat_multiply_by_dense, libigraph), igraph_error_t, (Ptr{igraph_sparsemat_t}, Ptr{igraph_matrix_t}, Ptr{igraph_matrix_t}), A, B, res)
end

function igraph_sparsemat_dense_multiply(A, B, res)
    ccall((:igraph_sparsemat_dense_multiply, libigraph), igraph_error_t, (Ptr{igraph_matrix_t}, Ptr{igraph_sparsemat_t}, Ptr{igraph_matrix_t}), A, B, res)
end

function igraph_sparsemat_view(A, nzmax, m, n, p, i, x, nz)
    ccall((:igraph_sparsemat_view, libigraph), igraph_error_t, (Ptr{igraph_sparsemat_t}, igraph_integer_t, igraph_integer_t, igraph_integer_t, Ptr{igraph_integer_t}, Ptr{igraph_integer_t}, Ptr{igraph_real_t}, igraph_integer_t), A, nzmax, m, n, p, i, x, nz)
end

function igraph_sparsemat_sort(A, sorted)
    ccall((:igraph_sparsemat_sort, libigraph), igraph_error_t, (Ptr{igraph_sparsemat_t}, Ptr{igraph_sparsemat_t}), A, sorted)
end

function igraph_sparsemat_nzmax(A)
    ccall((:igraph_sparsemat_nzmax, libigraph), igraph_integer_t, (Ptr{igraph_sparsemat_t},), A)
end

function igraph_sparsemat_neg(A)
    ccall((:igraph_sparsemat_neg, libigraph), igraph_error_t, (Ptr{igraph_sparsemat_t},), A)
end

function igraph_sparsemat_normalize_cols(sparsemat, allow_zeros)
    ccall((:igraph_sparsemat_normalize_cols, libigraph), igraph_error_t, (Ptr{igraph_sparsemat_t}, igraph_bool_t), sparsemat, allow_zeros)
end

function igraph_sparsemat_normalize_rows(sparsemat, allow_zeros)
    ccall((:igraph_sparsemat_normalize_rows, libigraph), igraph_error_t, (Ptr{igraph_sparsemat_t}, igraph_bool_t), sparsemat, allow_zeros)
end

function igraph_sparsemat_iterator_init(it, sparsemat)
    ccall((:igraph_sparsemat_iterator_init, libigraph), igraph_error_t, (Ptr{igraph_sparsemat_iterator_t}, Ptr{igraph_sparsemat_t}), it, sparsemat)
end

function igraph_sparsemat_iterator_reset(it)
    ccall((:igraph_sparsemat_iterator_reset, libigraph), igraph_error_t, (Ptr{igraph_sparsemat_iterator_t},), it)
end

function igraph_sparsemat_iterator_end(it)
    ccall((:igraph_sparsemat_iterator_end, libigraph), igraph_bool_t, (Ptr{igraph_sparsemat_iterator_t},), it)
end

function igraph_sparsemat_iterator_row(it)
    ccall((:igraph_sparsemat_iterator_row, libigraph), igraph_integer_t, (Ptr{igraph_sparsemat_iterator_t},), it)
end

function igraph_sparsemat_iterator_col(it)
    ccall((:igraph_sparsemat_iterator_col, libigraph), igraph_integer_t, (Ptr{igraph_sparsemat_iterator_t},), it)
end

function igraph_sparsemat_iterator_idx(it)
    ccall((:igraph_sparsemat_iterator_idx, libigraph), igraph_integer_t, (Ptr{igraph_sparsemat_iterator_t},), it)
end

function igraph_sparsemat_iterator_get(it)
    ccall((:igraph_sparsemat_iterator_get, libigraph), igraph_real_t, (Ptr{igraph_sparsemat_iterator_t},), it)
end

function igraph_sparsemat_iterator_next(it)
    ccall((:igraph_sparsemat_iterator_next, libigraph), igraph_integer_t, (Ptr{igraph_sparsemat_iterator_t},), it)
end

function igraph_sparsemat_copy(to, from)
    ccall((:igraph_sparsemat_copy, libigraph), igraph_error_t, (Ptr{igraph_sparsemat_t}, Ptr{igraph_sparsemat_t}), to, from)
end

function igraph_sparsemat_diag(A, nzmax, values, compress)
    ccall((:igraph_sparsemat_diag, libigraph), igraph_error_t, (Ptr{igraph_sparsemat_t}, igraph_integer_t, Ptr{igraph_vector_t}, igraph_bool_t), A, nzmax, values, compress)
end

function igraph_sparsemat_eye(A, n, nzmax, value, compress)
    ccall((:igraph_sparsemat_eye, libigraph), igraph_error_t, (Ptr{igraph_sparsemat_t}, igraph_integer_t, igraph_integer_t, igraph_real_t, igraph_bool_t), A, n, nzmax, value, compress)
end

function igraph_qsort(base, nel, width, compar)
    ccall((:igraph_qsort, libigraph), Cvoid, (Ptr{Cvoid}, Csize_t, Csize_t, Ptr{Cvoid}), base, nel, width, compar)
end

function igraph_qsort_r(base, nel, width, thunk, compar)
    ccall((:igraph_qsort_r, libigraph), Cvoid, (Ptr{Cvoid}, Csize_t, Csize_t, Ptr{Cvoid}, Ptr{Cvoid}), base, nel, width, thunk, compar)
end

function igraph_graph_list_get_ptr(v, pos)
    ccall((:igraph_graph_list_get_ptr, libigraph), Ptr{igraph_t}, (Ptr{igraph_graph_list_t}, igraph_integer_t), v, pos)
end

function igraph_graph_list_set(v, pos, e)
    ccall((:igraph_graph_list_set, libigraph), Cvoid, (Ptr{igraph_graph_list_t}, igraph_integer_t, Ptr{igraph_t}), v, pos, e)
end

function igraph_graph_list_tail_ptr(v)
    ccall((:igraph_graph_list_tail_ptr, libigraph), Ptr{igraph_t}, (Ptr{igraph_graph_list_t},), v)
end

function igraph_graph_list_capacity(v)
    ccall((:igraph_graph_list_capacity, libigraph), igraph_integer_t, (Ptr{igraph_graph_list_t},), v)
end

function igraph_graph_list_empty(v)
    ccall((:igraph_graph_list_empty, libigraph), igraph_bool_t, (Ptr{igraph_graph_list_t},), v)
end

function igraph_graph_list_size(v)
    ccall((:igraph_graph_list_size, libigraph), igraph_integer_t, (Ptr{igraph_graph_list_t},), v)
end

function igraph_graph_list_clear(v)
    ccall((:igraph_graph_list_clear, libigraph), Cvoid, (Ptr{igraph_graph_list_t},), v)
end

function igraph_graph_list_reserve(v, capacity)
    ccall((:igraph_graph_list_reserve, libigraph), igraph_error_t, (Ptr{igraph_graph_list_t}, igraph_integer_t), v, capacity)
end

function igraph_graph_list_resize(v, new_size)
    ccall((:igraph_graph_list_resize, libigraph), igraph_error_t, (Ptr{igraph_graph_list_t}, igraph_integer_t), v, new_size)
end

function igraph_graph_list_discard(v, index)
    ccall((:igraph_graph_list_discard, libigraph), Cvoid, (Ptr{igraph_graph_list_t}, igraph_integer_t), v, index)
end

function igraph_graph_list_discard_back(v)
    ccall((:igraph_graph_list_discard_back, libigraph), Cvoid, (Ptr{igraph_graph_list_t},), v)
end

function igraph_graph_list_discard_fast(v, index)
    ccall((:igraph_graph_list_discard_fast, libigraph), Cvoid, (Ptr{igraph_graph_list_t}, igraph_integer_t), v, index)
end

function igraph_graph_list_insert(v, pos, e)
    ccall((:igraph_graph_list_insert, libigraph), igraph_error_t, (Ptr{igraph_graph_list_t}, igraph_integer_t, Ptr{igraph_t}), v, pos, e)
end

function igraph_graph_list_insert_copy(v, pos, e)
    ccall((:igraph_graph_list_insert_copy, libigraph), igraph_error_t, (Ptr{igraph_graph_list_t}, igraph_integer_t, Ptr{igraph_t}), v, pos, e)
end

function igraph_graph_list_insert_new(v, pos, result)
    ccall((:igraph_graph_list_insert_new, libigraph), igraph_error_t, (Ptr{igraph_graph_list_t}, igraph_integer_t, Ptr{Ptr{igraph_t}}), v, pos, result)
end

function igraph_graph_list_push_back(v, e)
    ccall((:igraph_graph_list_push_back, libigraph), igraph_error_t, (Ptr{igraph_graph_list_t}, Ptr{igraph_t}), v, e)
end

function igraph_graph_list_push_back_copy(v, e)
    ccall((:igraph_graph_list_push_back_copy, libigraph), igraph_error_t, (Ptr{igraph_graph_list_t}, Ptr{igraph_t}), v, e)
end

function igraph_graph_list_push_back_new(v, result)
    ccall((:igraph_graph_list_push_back_new, libigraph), igraph_error_t, (Ptr{igraph_graph_list_t}, Ptr{Ptr{igraph_t}}), v, result)
end

function igraph_graph_list_pop_back(v)
    ccall((:igraph_graph_list_pop_back, libigraph), igraph_t, (Ptr{igraph_graph_list_t},), v)
end

function igraph_graph_list_remove(v, index, e)
    ccall((:igraph_graph_list_remove, libigraph), igraph_error_t, (Ptr{igraph_graph_list_t}, igraph_integer_t, Ptr{igraph_t}), v, index, e)
end

function igraph_graph_list_remove_fast(v, index, e)
    ccall((:igraph_graph_list_remove_fast, libigraph), igraph_error_t, (Ptr{igraph_graph_list_t}, igraph_integer_t, Ptr{igraph_t}), v, index, e)
end

function igraph_graph_list_replace(v, pos, e)
    ccall((:igraph_graph_list_replace, libigraph), Cvoid, (Ptr{igraph_graph_list_t}, igraph_integer_t, Ptr{igraph_t}), v, pos, e)
end

function igraph_graph_list_remove_consecutive_duplicates(v, eq)
    ccall((:igraph_graph_list_remove_consecutive_duplicates, libigraph), Cvoid, (Ptr{igraph_graph_list_t}, Ptr{Cvoid}), v, eq)
end

function igraph_graph_list_permute(v, index)
    ccall((:igraph_graph_list_permute, libigraph), igraph_error_t, (Ptr{igraph_graph_list_t}, Ptr{igraph_vector_int_t}), v, index)
end

function igraph_graph_list_reverse(v)
    ccall((:igraph_graph_list_reverse, libigraph), igraph_error_t, (Ptr{igraph_graph_list_t},), v)
end

function igraph_graph_list_swap(v1, v2)
    ccall((:igraph_graph_list_swap, libigraph), igraph_error_t, (Ptr{igraph_graph_list_t}, Ptr{igraph_graph_list_t}), v1, v2)
end

function igraph_graph_list_swap_elements(v, i, j)
    ccall((:igraph_graph_list_swap_elements, libigraph), igraph_error_t, (Ptr{igraph_graph_list_t}, igraph_integer_t, igraph_integer_t), v, i, j)
end

function igraph_graph_list_sort(v, cmp)
    ccall((:igraph_graph_list_sort, libigraph), Cvoid, (Ptr{igraph_graph_list_t}, Ptr{Cvoid}), v, cmp)
end

function igraph_graph_list_sort_ind(v, ind, cmp)
    ccall((:igraph_graph_list_sort_ind, libigraph), igraph_error_t, (Ptr{igraph_graph_list_t}, Ptr{igraph_vector_int_t}, Ptr{Cvoid}), v, ind, cmp)
end

function igraph_graph_list_set_directed(list, directed)
    ccall((:igraph_graph_list_set_directed, libigraph), Cvoid, (Ptr{igraph_graph_list_t}, igraph_bool_t), list, directed)
end

function igraph_vs_all(vs)
    ccall((:igraph_vs_all, libigraph), igraph_error_t, (Ptr{igraph_vs_t},), vs)
end

function igraph_vs_adj(vs, vid, mode)
    ccall((:igraph_vs_adj, libigraph), igraph_error_t, (Ptr{igraph_vs_t}, igraph_integer_t, igraph_neimode_t), vs, vid, mode)
end

function igraph_vs_nonadj(vs, vid, mode)
    ccall((:igraph_vs_nonadj, libigraph), igraph_error_t, (Ptr{igraph_vs_t}, igraph_integer_t, igraph_neimode_t), vs, vid, mode)
end

function igraph_vs_none(vs)
    ccall((:igraph_vs_none, libigraph), igraph_error_t, (Ptr{igraph_vs_t},), vs)
end

function igraph_vss_none()
    ccall((:igraph_vss_none, libigraph), igraph_vs_t, ())
end

function igraph_vs_1(vs, vid)
    ccall((:igraph_vs_1, libigraph), igraph_error_t, (Ptr{igraph_vs_t}, igraph_integer_t), vs, vid)
end

function igraph_vss_1(vid)
    ccall((:igraph_vss_1, libigraph), igraph_vs_t, (igraph_integer_t,), vid)
end

function igraph_vs_vector(vs, v)
    ccall((:igraph_vs_vector, libigraph), igraph_error_t, (Ptr{igraph_vs_t}, Ptr{igraph_vector_int_t}), vs, v)
end

function igraph_vss_vector(v)
    ccall((:igraph_vss_vector, libigraph), igraph_vs_t, (Ptr{igraph_vector_int_t},), v)
end

function igraph_vs_vector_copy(vs, v)
    ccall((:igraph_vs_vector_copy, libigraph), igraph_error_t, (Ptr{igraph_vs_t}, Ptr{igraph_vector_int_t}), vs, v)
end

function igraph_vs_seq(vs, from, to)
    ccall((:igraph_vs_seq, libigraph), igraph_error_t, (Ptr{igraph_vs_t}, igraph_integer_t, igraph_integer_t), vs, from, to)
end

function igraph_vss_seq(from, to)
    ccall((:igraph_vss_seq, libigraph), igraph_vs_t, (igraph_integer_t, igraph_integer_t), from, to)
end

function igraph_vs_range(vs, start, _end)
    ccall((:igraph_vs_range, libigraph), igraph_error_t, (Ptr{igraph_vs_t}, igraph_integer_t, igraph_integer_t), vs, start, _end)
end

function igraph_vss_range(start, _end)
    ccall((:igraph_vss_range, libigraph), igraph_vs_t, (igraph_integer_t, igraph_integer_t), start, _end)
end

function igraph_vs_destroy(vs)
    ccall((:igraph_vs_destroy, libigraph), Cvoid, (Ptr{igraph_vs_t},), vs)
end

function igraph_vs_is_all(vs)
    ccall((:igraph_vs_is_all, libigraph), igraph_bool_t, (Ptr{igraph_vs_t},), vs)
end

function igraph_vs_copy(dest, src)
    ccall((:igraph_vs_copy, libigraph), igraph_error_t, (Ptr{igraph_vs_t}, Ptr{igraph_vs_t}), dest, src)
end

function igraph_vs_as_vector(graph, vs, v)
    ccall((:igraph_vs_as_vector, libigraph), igraph_error_t, (Ptr{igraph_t}, igraph_vs_t, Ptr{igraph_vector_int_t}), graph, vs, v)
end

function igraph_vs_size(graph, vs, result)
    ccall((:igraph_vs_size, libigraph), igraph_error_t, (Ptr{igraph_t}, Ptr{igraph_vs_t}, Ptr{igraph_integer_t}), graph, vs, result)
end

function igraph_vs_type(vs)
    ccall((:igraph_vs_type, libigraph), igraph_vs_type_t, (Ptr{igraph_vs_t},), vs)
end

@cenum igraph_vit_type_t::UInt32 begin
    IGRAPH_VIT_RANGE = 0
    IGRAPH_VIT_VECTOR = 1
    IGRAPH_VIT_VECTORPTR = 2
end

mutable struct igraph_vit_t
    type::igraph_vit_type_t
    pos::igraph_integer_t
    start::igraph_integer_t
    _end::igraph_integer_t
    vec::Ptr{igraph_vector_int_t}
    igraph_vit_t() = new()
end

function igraph_vit_create(graph, vs, vit)
    ccall((:igraph_vit_create, libigraph), igraph_error_t, (Ptr{igraph_t}, igraph_vs_t, Ptr{igraph_vit_t}), graph, vs, vit)
end

function igraph_vit_destroy(vit)
    ccall((:igraph_vit_destroy, libigraph), Cvoid, (Ptr{igraph_vit_t},), vit)
end

function igraph_vit_as_vector(vit, v)
    ccall((:igraph_vit_as_vector, libigraph), igraph_error_t, (Ptr{igraph_vit_t}, Ptr{igraph_vector_int_t}), vit, v)
end

function igraph_es_all(es, order)
    ccall((:igraph_es_all, libigraph), igraph_error_t, (Ptr{igraph_es_t}, igraph_edgeorder_type_t), es, order)
end

function igraph_es_incident(es, vid, mode)
    ccall((:igraph_es_incident, libigraph), igraph_error_t, (Ptr{igraph_es_t}, igraph_integer_t, igraph_neimode_t), es, vid, mode)
end

function igraph_es_none(es)
    ccall((:igraph_es_none, libigraph), igraph_error_t, (Ptr{igraph_es_t},), es)
end

function igraph_ess_none()
    ccall((:igraph_ess_none, libigraph), igraph_es_t, ())
end

function igraph_es_1(es, eid)
    ccall((:igraph_es_1, libigraph), igraph_error_t, (Ptr{igraph_es_t}, igraph_integer_t), es, eid)
end

function igraph_ess_1(eid)
    ccall((:igraph_ess_1, libigraph), igraph_es_t, (igraph_integer_t,), eid)
end

function igraph_es_vector(es, v)
    ccall((:igraph_es_vector, libigraph), igraph_error_t, (Ptr{igraph_es_t}, Ptr{igraph_vector_int_t}), es, v)
end

function igraph_ess_vector(v)
    ccall((:igraph_ess_vector, libigraph), igraph_es_t, (Ptr{igraph_vector_int_t},), v)
end

function igraph_es_range(es, from, to)
    ccall((:igraph_es_range, libigraph), igraph_error_t, (Ptr{igraph_es_t}, igraph_integer_t, igraph_integer_t), es, from, to)
end

function igraph_ess_range(from, to)
    ccall((:igraph_ess_range, libigraph), igraph_es_t, (igraph_integer_t, igraph_integer_t), from, to)
end

function igraph_es_seq(es, from, to)
    ccall((:igraph_es_seq, libigraph), igraph_error_t, (Ptr{igraph_es_t}, igraph_integer_t, igraph_integer_t), es, from, to)
end

function igraph_ess_seq(from, to)
    ccall((:igraph_ess_seq, libigraph), igraph_es_t, (igraph_integer_t, igraph_integer_t), from, to)
end

function igraph_es_vector_copy(es, v)
    ccall((:igraph_es_vector_copy, libigraph), igraph_error_t, (Ptr{igraph_es_t}, Ptr{igraph_vector_int_t}), es, v)
end

function igraph_es_pairs(es, v, directed)
    ccall((:igraph_es_pairs, libigraph), igraph_error_t, (Ptr{igraph_es_t}, Ptr{igraph_vector_int_t}, igraph_bool_t), es, v, directed)
end

function igraph_es_path(es, v, directed)
    ccall((:igraph_es_path, libigraph), igraph_error_t, (Ptr{igraph_es_t}, Ptr{igraph_vector_int_t}, igraph_bool_t), es, v, directed)
end

function igraph_es_all_between(es, from, to, directed)
    ccall((:igraph_es_all_between, libigraph), igraph_error_t, (Ptr{igraph_es_t}, igraph_integer_t, igraph_integer_t, igraph_bool_t), es, from, to, directed)
end

function igraph_es_destroy(es)
    ccall((:igraph_es_destroy, libigraph), Cvoid, (Ptr{igraph_es_t},), es)
end

function igraph_es_is_all(es)
    ccall((:igraph_es_is_all, libigraph), igraph_bool_t, (Ptr{igraph_es_t},), es)
end

function igraph_es_copy(dest, src)
    ccall((:igraph_es_copy, libigraph), igraph_error_t, (Ptr{igraph_es_t}, Ptr{igraph_es_t}), dest, src)
end

function igraph_es_as_vector(graph, es, v)
    ccall((:igraph_es_as_vector, libigraph), igraph_error_t, (Ptr{igraph_t}, igraph_es_t, Ptr{igraph_vector_int_t}), graph, es, v)
end

function igraph_es_size(graph, es, result)
    ccall((:igraph_es_size, libigraph), igraph_error_t, (Ptr{igraph_t}, Ptr{igraph_es_t}, Ptr{igraph_integer_t}), graph, es, result)
end

function igraph_es_type(es)
    ccall((:igraph_es_type, libigraph), igraph_es_type_t, (Ptr{igraph_es_t},), es)
end

@cenum igraph_eit_type_t::UInt32 begin
    IGRAPH_EIT_RANGE = 0
    IGRAPH_EIT_VECTOR = 1
    IGRAPH_EIT_VECTORPTR = 2
end

mutable struct igraph_eit_t
    type::igraph_eit_type_t
    pos::igraph_integer_t
    start::igraph_integer_t
    _end::igraph_integer_t
    vec::Ptr{igraph_vector_int_t}
    igraph_eit_t() = new()
end

function igraph_eit_create(graph, es, eit)
    ccall((:igraph_eit_create, libigraph), igraph_error_t, (Ptr{igraph_t}, igraph_es_t, Ptr{igraph_eit_t}), graph, es, eit)
end

function igraph_eit_destroy(eit)
    ccall((:igraph_eit_destroy, libigraph), Cvoid, (Ptr{igraph_eit_t},), eit)
end

function igraph_eit_as_vector(eit, v)
    ccall((:igraph_eit_as_vector, libigraph), igraph_error_t, (Ptr{igraph_eit_t}, Ptr{igraph_vector_int_t}), eit, v)
end

function igraph_empty(graph, n, directed)
    ccall((:igraph_empty, libigraph), igraph_error_t, (Ptr{igraph_t}, igraph_integer_t, igraph_bool_t), graph, n, directed)
end

function igraph_empty_attrs(graph, n, directed, attr)
    ccall((:igraph_empty_attrs, libigraph), igraph_error_t, (Ptr{igraph_t}, igraph_integer_t, igraph_bool_t, Ptr{Cvoid}), graph, n, directed, attr)
end

function igraph_destroy(graph)
    ccall((:igraph_destroy, libigraph), Cvoid, (Ptr{igraph_t},), graph)
end

function igraph_copy(to, from)
    ccall((:igraph_copy, libigraph), igraph_error_t, (Ptr{igraph_t}, Ptr{igraph_t}), to, from)
end

function igraph_add_edges(graph, edges, attr)
    ccall((:igraph_add_edges, libigraph), igraph_error_t, (Ptr{igraph_t}, Ptr{igraph_vector_int_t}, Ptr{Cvoid}), graph, edges, attr)
end

function igraph_add_vertices(graph, nv, attr)
    ccall((:igraph_add_vertices, libigraph), igraph_error_t, (Ptr{igraph_t}, igraph_integer_t, Ptr{Cvoid}), graph, nv, attr)
end

function igraph_delete_edges(graph, edges)
    ccall((:igraph_delete_edges, libigraph), igraph_error_t, (Ptr{igraph_t}, igraph_es_t), graph, edges)
end

function igraph_delete_vertices(graph, vertices)
    ccall((:igraph_delete_vertices, libigraph), igraph_error_t, (Ptr{igraph_t}, igraph_vs_t), graph, vertices)
end

function igraph_delete_vertices_idx(graph, vertices, idx, invidx)
    ccall((:igraph_delete_vertices_idx, libigraph), igraph_error_t, (Ptr{igraph_t}, igraph_vs_t, Ptr{igraph_vector_int_t}, Ptr{igraph_vector_int_t}), graph, vertices, idx, invidx)
end

function igraph_vcount(graph)
    ccall((:igraph_vcount, libigraph), igraph_integer_t, (Ptr{igraph_t},), graph)
end

function igraph_ecount(graph)
    ccall((:igraph_ecount, libigraph), igraph_integer_t, (Ptr{igraph_t},), graph)
end

function igraph_neighbors(graph, neis, vid, mode)
    ccall((:igraph_neighbors, libigraph), igraph_error_t, (Ptr{igraph_t}, Ptr{igraph_vector_int_t}, igraph_integer_t, igraph_neimode_t), graph, neis, vid, mode)
end

function igraph_is_directed(graph)
    ccall((:igraph_is_directed, libigraph), igraph_bool_t, (Ptr{igraph_t},), graph)
end

function igraph_degree_1(graph, deg, vid, mode, loops)
    ccall((:igraph_degree_1, libigraph), igraph_error_t, (Ptr{igraph_t}, Ptr{igraph_integer_t}, igraph_integer_t, igraph_neimode_t, igraph_bool_t), graph, deg, vid, mode, loops)
end

function igraph_degree(graph, res, vids, mode, loops)
    ccall((:igraph_degree, libigraph), igraph_error_t, (Ptr{igraph_t}, Ptr{igraph_vector_int_t}, igraph_vs_t, igraph_neimode_t, igraph_bool_t), graph, res, vids, mode, loops)
end

function igraph_edge(graph, eid, from, to)
    ccall((:igraph_edge, libigraph), igraph_error_t, (Ptr{igraph_t}, igraph_integer_t, Ptr{igraph_integer_t}, Ptr{igraph_integer_t}), graph, eid, from, to)
end

function igraph_edges(graph, eids, edges)
    ccall((:igraph_edges, libigraph), igraph_error_t, (Ptr{igraph_t}, igraph_es_t, Ptr{igraph_vector_int_t}), graph, eids, edges)
end

function igraph_get_eid(graph, eid, from, to, directed, error)
    ccall((:igraph_get_eid, libigraph), igraph_error_t, (Ptr{igraph_t}, Ptr{igraph_integer_t}, igraph_integer_t, igraph_integer_t, igraph_bool_t, igraph_bool_t), graph, eid, from, to, directed, error)
end

function igraph_get_eids(graph, eids, pairs, directed, error)
    ccall((:igraph_get_eids, libigraph), igraph_error_t, (Ptr{igraph_t}, Ptr{igraph_vector_int_t}, Ptr{igraph_vector_int_t}, igraph_bool_t, igraph_bool_t), graph, eids, pairs, directed, error)
end

function igraph_get_all_eids_between(graph, eids, source, target, directed)
    ccall((:igraph_get_all_eids_between, libigraph), igraph_error_t, (Ptr{igraph_t}, Ptr{igraph_vector_int_t}, igraph_integer_t, igraph_integer_t, igraph_bool_t), graph, eids, source, target, directed)
end

function igraph_incident(graph, eids, vid, mode)
    ccall((:igraph_incident, libigraph), igraph_error_t, (Ptr{igraph_t}, Ptr{igraph_vector_int_t}, igraph_integer_t, igraph_neimode_t), graph, eids, vid, mode)
end

function igraph_is_same_graph(graph1, graph2, res)
    ccall((:igraph_is_same_graph, libigraph), igraph_error_t, (Ptr{igraph_t}, Ptr{igraph_t}, Ptr{igraph_bool_t}), graph1, graph2, res)
end

function igraph_i_property_cache_set_bool(graph, prop, value)
    ccall((:igraph_i_property_cache_set_bool, libigraph), Cvoid, (Ptr{igraph_t}, igraph_cached_property_t, igraph_bool_t), graph, prop, value)
end

function igraph_i_property_cache_set_bool_checked(graph, prop, value)
    ccall((:igraph_i_property_cache_set_bool_checked, libigraph), Cvoid, (Ptr{igraph_t}, igraph_cached_property_t, igraph_bool_t), graph, prop, value)
end

function igraph_i_property_cache_invalidate(graph, prop)
    ccall((:igraph_i_property_cache_invalidate, libigraph), Cvoid, (Ptr{igraph_t}, igraph_cached_property_t), graph, prop)
end

function igraph_i_property_cache_invalidate_all(graph)
    ccall((:igraph_i_property_cache_invalidate_all, libigraph), Cvoid, (Ptr{igraph_t},), graph)
end

const igraph_edge_type_sw_t = Cuint

@cenum var"##Ctag#231"::UInt32 begin
    IGRAPH_SIMPLE_SW = 0
    IGRAPH_LOOPS_SW = 1
    IGRAPH_MULTI_SW = 6
end

function igraph_is_graphical(out_degrees, in_degrees, allowed_edge_types, res)
    ccall((:igraph_is_graphical, libigraph), igraph_error_t, (Ptr{igraph_vector_int_t}, Ptr{igraph_vector_int_t}, igraph_edge_type_sw_t, Ptr{igraph_bool_t}), out_degrees, in_degrees, allowed_edge_types, res)
end

function igraph_is_bigraphical(degrees1, degrees2, allowed_edge_types, res)
    ccall((:igraph_is_bigraphical, libigraph), igraph_error_t, (Ptr{igraph_vector_int_t}, Ptr{igraph_vector_int_t}, igraph_edge_type_sw_t, Ptr{igraph_bool_t}), degrees1, degrees2, allowed_edge_types, res)
end

function igraph_create(graph, edges, n, directed)
    ccall((:igraph_create, libigraph), igraph_error_t, (Ptr{igraph_t}, Ptr{igraph_vector_int_t}, igraph_integer_t, igraph_bool_t), graph, edges, n, directed)
end

function igraph_adjacency(graph, adjmatrix, mode, loops)
    ccall((:igraph_adjacency, libigraph), igraph_error_t, (Ptr{igraph_t}, Ptr{igraph_matrix_t}, igraph_adjacency_t, igraph_loops_t), graph, adjmatrix, mode, loops)
end

function igraph_weighted_adjacency(graph, adjmatrix, mode, weights, loops)
    ccall((:igraph_weighted_adjacency, libigraph), igraph_error_t, (Ptr{igraph_t}, Ptr{igraph_matrix_t}, igraph_adjacency_t, Ptr{igraph_vector_t}, igraph_loops_t), graph, adjmatrix, mode, weights, loops)
end

function igraph_sparse_adjacency(graph, adjmatrix, mode, loops)
    ccall((:igraph_sparse_adjacency, libigraph), igraph_error_t, (Ptr{igraph_t}, Ptr{igraph_sparsemat_t}, igraph_adjacency_t, igraph_loops_t), graph, adjmatrix, mode, loops)
end

function igraph_sparse_weighted_adjacency(graph, adjmatrix, mode, weights, loops)
    ccall((:igraph_sparse_weighted_adjacency, libigraph), igraph_error_t, (Ptr{igraph_t}, Ptr{igraph_sparsemat_t}, igraph_adjacency_t, Ptr{igraph_vector_t}, igraph_loops_t), graph, adjmatrix, mode, weights, loops)
end

function igraph_star(graph, n, mode, center)
    ccall((:igraph_star, libigraph), igraph_error_t, (Ptr{igraph_t}, igraph_integer_t, igraph_star_mode_t, igraph_integer_t), graph, n, mode, center)
end

function igraph_wheel(graph, n, mode, center)
    ccall((:igraph_wheel, libigraph), igraph_error_t, (Ptr{igraph_t}, igraph_integer_t, igraph_wheel_mode_t, igraph_integer_t), graph, n, mode, center)
end

function igraph_hypercube(graph, n, directed)
    ccall((:igraph_hypercube, libigraph), igraph_error_t, (Ptr{igraph_t}, igraph_integer_t, igraph_bool_t), graph, n, directed)
end

function igraph_lattice(graph, dimvector, nei, directed, mutual, circular)
    ccall((:igraph_lattice, libigraph), igraph_error_t, (Ptr{igraph_t}, Ptr{igraph_vector_int_t}, igraph_integer_t, igraph_bool_t, igraph_bool_t, igraph_bool_t), graph, dimvector, nei, directed, mutual, circular)
end

function igraph_square_lattice(graph, dimvector, nei, directed, mutual, circular)
    ccall((:igraph_square_lattice, libigraph), igraph_error_t, (Ptr{igraph_t}, Ptr{igraph_vector_int_t}, igraph_integer_t, igraph_bool_t, igraph_bool_t, Ptr{igraph_vector_bool_t}), graph, dimvector, nei, directed, mutual, circular)
end

function igraph_ring(graph, n, directed, mutual, circular)
    ccall((:igraph_ring, libigraph), igraph_error_t, (Ptr{igraph_t}, igraph_integer_t, igraph_bool_t, igraph_bool_t, igraph_bool_t), graph, n, directed, mutual, circular)
end

function igraph_tree(graph, n, children, type)
    ccall((:igraph_tree, libigraph), igraph_error_t, (Ptr{igraph_t}, igraph_integer_t, igraph_integer_t, igraph_tree_mode_t), graph, n, children, type)
end

function igraph_kary_tree(graph, n, children, type)
    ccall((:igraph_kary_tree, libigraph), igraph_error_t, (Ptr{igraph_t}, igraph_integer_t, igraph_integer_t, igraph_tree_mode_t), graph, n, children, type)
end

function igraph_symmetric_tree(graph, branches, type)
    ccall((:igraph_symmetric_tree, libigraph), igraph_error_t, (Ptr{igraph_t}, Ptr{igraph_vector_int_t}, igraph_tree_mode_t), graph, branches, type)
end

function igraph_regular_tree(graph, h, k, type)
    ccall((:igraph_regular_tree, libigraph), igraph_error_t, (Ptr{igraph_t}, igraph_integer_t, igraph_integer_t, igraph_tree_mode_t), graph, h, k, type)
end

function igraph_tree_from_parent_vector(graph, parents, mode)
    ccall((:igraph_tree_from_parent_vector, libigraph), igraph_error_t, (Ptr{igraph_t}, Ptr{igraph_vector_int_t}, igraph_tree_mode_t), graph, parents, mode)
end

function igraph_from_prufer(graph, prufer)
    ccall((:igraph_from_prufer, libigraph), igraph_error_t, (Ptr{igraph_t}, Ptr{igraph_vector_int_t}), graph, prufer)
end

function igraph_full(graph, n, directed, loops)
    ccall((:igraph_full, libigraph), igraph_error_t, (Ptr{igraph_t}, igraph_integer_t, igraph_bool_t, igraph_bool_t), graph, n, directed, loops)
end

function igraph_full_multipartite(graph, types, n, directed, mode)
    ccall((:igraph_full_multipartite, libigraph), igraph_error_t, (Ptr{igraph_t}, Ptr{igraph_vector_int_t}, Ptr{igraph_vector_int_t}, igraph_bool_t, igraph_neimode_t), graph, types, n, directed, mode)
end

function igraph_turan(graph, types, n, r)
    ccall((:igraph_turan, libigraph), igraph_error_t, (Ptr{igraph_t}, Ptr{igraph_vector_int_t}, igraph_integer_t, igraph_integer_t), graph, types, n, r)
end

function igraph_full_citation(graph, n, directed)
    ccall((:igraph_full_citation, libigraph), igraph_error_t, (Ptr{igraph_t}, igraph_integer_t, igraph_bool_t), graph, n, directed)
end

function igraph_atlas(graph, number)
    ccall((:igraph_atlas, libigraph), igraph_error_t, (Ptr{igraph_t}, igraph_integer_t), graph, number)
end

function igraph_extended_chordal_ring(graph, nodes, W, directed)
    ccall((:igraph_extended_chordal_ring, libigraph), igraph_error_t, (Ptr{igraph_t}, igraph_integer_t, Ptr{igraph_matrix_int_t}, igraph_bool_t), graph, nodes, W, directed)
end

function igraph_linegraph(graph, linegraph)
    ccall((:igraph_linegraph, libigraph), igraph_error_t, (Ptr{igraph_t}, Ptr{igraph_t}), graph, linegraph)
end

function igraph_de_bruijn(graph, m, n)
    ccall((:igraph_de_bruijn, libigraph), igraph_error_t, (Ptr{igraph_t}, igraph_integer_t, igraph_integer_t), graph, m, n)
end

function igraph_circulant(graph, n, l, directed)
    ccall((:igraph_circulant, libigraph), igraph_error_t, (Ptr{igraph_t}, igraph_integer_t, Ptr{igraph_vector_int_t}, igraph_bool_t), graph, n, l, directed)
end

function igraph_generalized_petersen(graph, n, k)
    ccall((:igraph_generalized_petersen, libigraph), igraph_error_t, (Ptr{igraph_t}, igraph_integer_t, igraph_integer_t), graph, n, k)
end

function igraph_kautz(graph, m, n)
    ccall((:igraph_kautz, libigraph), igraph_error_t, (Ptr{igraph_t}, igraph_integer_t, igraph_integer_t), graph, m, n)
end

function igraph_famous(graph, name)
    ccall((:igraph_famous, libigraph), igraph_error_t, (Ptr{igraph_t}, Ptr{Cchar}), graph, name)
end

function igraph_lcf_vector(graph, n, shifts, repeats)
    ccall((:igraph_lcf_vector, libigraph), igraph_error_t, (Ptr{igraph_t}, igraph_integer_t, Ptr{igraph_vector_int_t}, igraph_integer_t), graph, n, shifts, repeats)
end

function igraph_realize_degree_sequence(graph, outdeg, indeg, allowed_edge_types, method)
    ccall((:igraph_realize_degree_sequence, libigraph), igraph_error_t, (Ptr{igraph_t}, Ptr{igraph_vector_int_t}, Ptr{igraph_vector_int_t}, igraph_edge_type_sw_t, igraph_realize_degseq_t), graph, outdeg, indeg, allowed_edge_types, method)
end

function igraph_triangular_lattice(graph, dims, directed, mutual)
    ccall((:igraph_triangular_lattice, libigraph), igraph_error_t, (Ptr{igraph_t}, Ptr{igraph_vector_int_t}, igraph_bool_t, igraph_bool_t), graph, dims, directed, mutual)
end

function igraph_hexagonal_lattice(graph, dims, directed, mutual)
    ccall((:igraph_hexagonal_lattice, libigraph), igraph_error_t, (Ptr{igraph_t}, Ptr{igraph_vector_int_t}, igraph_bool_t, igraph_bool_t), graph, dims, directed, mutual)
end

function igraph_realize_bipartite_degree_sequence(graph, deg1, deg2, allowed_edge_types, method)
    ccall((:igraph_realize_bipartite_degree_sequence, libigraph), igraph_error_t, (Ptr{igraph_t}, Ptr{igraph_vector_int_t}, Ptr{igraph_vector_int_t}, igraph_edge_type_sw_t, igraph_realize_degseq_t), graph, deg1, deg2, allowed_edge_types, method)
end

function igraph_matrix_list_get_ptr(v, pos)
    ccall((:igraph_matrix_list_get_ptr, libigraph), Ptr{igraph_matrix_t}, (Ptr{igraph_matrix_list_t}, igraph_integer_t), v, pos)
end

function igraph_matrix_list_set(v, pos, e)
    ccall((:igraph_matrix_list_set, libigraph), Cvoid, (Ptr{igraph_matrix_list_t}, igraph_integer_t, Ptr{igraph_matrix_t}), v, pos, e)
end

function igraph_matrix_list_tail_ptr(v)
    ccall((:igraph_matrix_list_tail_ptr, libigraph), Ptr{igraph_matrix_t}, (Ptr{igraph_matrix_list_t},), v)
end

function igraph_matrix_list_capacity(v)
    ccall((:igraph_matrix_list_capacity, libigraph), igraph_integer_t, (Ptr{igraph_matrix_list_t},), v)
end

function igraph_matrix_list_empty(v)
    ccall((:igraph_matrix_list_empty, libigraph), igraph_bool_t, (Ptr{igraph_matrix_list_t},), v)
end

function igraph_matrix_list_size(v)
    ccall((:igraph_matrix_list_size, libigraph), igraph_integer_t, (Ptr{igraph_matrix_list_t},), v)
end

function igraph_matrix_list_clear(v)
    ccall((:igraph_matrix_list_clear, libigraph), Cvoid, (Ptr{igraph_matrix_list_t},), v)
end

function igraph_matrix_list_reserve(v, capacity)
    ccall((:igraph_matrix_list_reserve, libigraph), igraph_error_t, (Ptr{igraph_matrix_list_t}, igraph_integer_t), v, capacity)
end

function igraph_matrix_list_resize(v, new_size)
    ccall((:igraph_matrix_list_resize, libigraph), igraph_error_t, (Ptr{igraph_matrix_list_t}, igraph_integer_t), v, new_size)
end

function igraph_matrix_list_discard(v, index)
    ccall((:igraph_matrix_list_discard, libigraph), Cvoid, (Ptr{igraph_matrix_list_t}, igraph_integer_t), v, index)
end

function igraph_matrix_list_discard_back(v)
    ccall((:igraph_matrix_list_discard_back, libigraph), Cvoid, (Ptr{igraph_matrix_list_t},), v)
end

function igraph_matrix_list_discard_fast(v, index)
    ccall((:igraph_matrix_list_discard_fast, libigraph), Cvoid, (Ptr{igraph_matrix_list_t}, igraph_integer_t), v, index)
end

function igraph_matrix_list_insert(v, pos, e)
    ccall((:igraph_matrix_list_insert, libigraph), igraph_error_t, (Ptr{igraph_matrix_list_t}, igraph_integer_t, Ptr{igraph_matrix_t}), v, pos, e)
end

function igraph_matrix_list_insert_copy(v, pos, e)
    ccall((:igraph_matrix_list_insert_copy, libigraph), igraph_error_t, (Ptr{igraph_matrix_list_t}, igraph_integer_t, Ptr{igraph_matrix_t}), v, pos, e)
end

function igraph_matrix_list_insert_new(v, pos, result)
    ccall((:igraph_matrix_list_insert_new, libigraph), igraph_error_t, (Ptr{igraph_matrix_list_t}, igraph_integer_t, Ptr{Ptr{igraph_matrix_t}}), v, pos, result)
end

function igraph_matrix_list_push_back(v, e)
    ccall((:igraph_matrix_list_push_back, libigraph), igraph_error_t, (Ptr{igraph_matrix_list_t}, Ptr{igraph_matrix_t}), v, e)
end

function igraph_matrix_list_push_back_copy(v, e)
    ccall((:igraph_matrix_list_push_back_copy, libigraph), igraph_error_t, (Ptr{igraph_matrix_list_t}, Ptr{igraph_matrix_t}), v, e)
end

function igraph_matrix_list_push_back_new(v, result)
    ccall((:igraph_matrix_list_push_back_new, libigraph), igraph_error_t, (Ptr{igraph_matrix_list_t}, Ptr{Ptr{igraph_matrix_t}}), v, result)
end

function igraph_matrix_list_pop_back(v)
    ccall((:igraph_matrix_list_pop_back, libigraph), igraph_matrix_t, (Ptr{igraph_matrix_list_t},), v)
end

function igraph_matrix_list_remove(v, index, e)
    ccall((:igraph_matrix_list_remove, libigraph), igraph_error_t, (Ptr{igraph_matrix_list_t}, igraph_integer_t, Ptr{igraph_matrix_t}), v, index, e)
end

function igraph_matrix_list_remove_fast(v, index, e)
    ccall((:igraph_matrix_list_remove_fast, libigraph), igraph_error_t, (Ptr{igraph_matrix_list_t}, igraph_integer_t, Ptr{igraph_matrix_t}), v, index, e)
end

function igraph_matrix_list_replace(v, pos, e)
    ccall((:igraph_matrix_list_replace, libigraph), Cvoid, (Ptr{igraph_matrix_list_t}, igraph_integer_t, Ptr{igraph_matrix_t}), v, pos, e)
end

function igraph_matrix_list_remove_consecutive_duplicates(v, eq)
    ccall((:igraph_matrix_list_remove_consecutive_duplicates, libigraph), Cvoid, (Ptr{igraph_matrix_list_t}, Ptr{Cvoid}), v, eq)
end

function igraph_matrix_list_permute(v, index)
    ccall((:igraph_matrix_list_permute, libigraph), igraph_error_t, (Ptr{igraph_matrix_list_t}, Ptr{igraph_vector_int_t}), v, index)
end

function igraph_matrix_list_reverse(v)
    ccall((:igraph_matrix_list_reverse, libigraph), igraph_error_t, (Ptr{igraph_matrix_list_t},), v)
end

function igraph_matrix_list_swap(v1, v2)
    ccall((:igraph_matrix_list_swap, libigraph), igraph_error_t, (Ptr{igraph_matrix_list_t}, Ptr{igraph_matrix_list_t}), v1, v2)
end

function igraph_matrix_list_swap_elements(v, i, j)
    ccall((:igraph_matrix_list_swap_elements, libigraph), igraph_error_t, (Ptr{igraph_matrix_list_t}, igraph_integer_t, igraph_integer_t), v, i, j)
end

function igraph_matrix_list_sort(v, cmp)
    ccall((:igraph_matrix_list_sort, libigraph), Cvoid, (Ptr{igraph_matrix_list_t}, Ptr{Cvoid}), v, cmp)
end

function igraph_matrix_list_sort_ind(v, ind, cmp)
    ccall((:igraph_matrix_list_sort_ind, libigraph), igraph_error_t, (Ptr{igraph_matrix_list_t}, Ptr{igraph_vector_int_t}, Ptr{Cvoid}), v, ind, cmp)
end

function igraph_barabasi_game(graph, n, power, m, outseq, outpref, A, directed, algo, start_from)
    ccall((:igraph_barabasi_game, libigraph), igraph_error_t, (Ptr{igraph_t}, igraph_integer_t, igraph_real_t, igraph_integer_t, Ptr{igraph_vector_int_t}, igraph_bool_t, igraph_real_t, igraph_bool_t, igraph_barabasi_algorithm_t, Ptr{igraph_t}), graph, n, power, m, outseq, outpref, A, directed, algo, start_from)
end

function igraph_erdos_renyi_game_gnp(graph, n, p, directed, loops)
    ccall((:igraph_erdos_renyi_game_gnp, libigraph), igraph_error_t, (Ptr{igraph_t}, igraph_integer_t, igraph_real_t, igraph_bool_t, igraph_bool_t), graph, n, p, directed, loops)
end

function igraph_erdos_renyi_game_gnm(graph, n, m, directed, loops)
    ccall((:igraph_erdos_renyi_game_gnm, libigraph), igraph_error_t, (Ptr{igraph_t}, igraph_integer_t, igraph_integer_t, igraph_bool_t, igraph_bool_t), graph, n, m, directed, loops)
end

function igraph_degree_sequence_game(graph, out_deg, in_deg, method)
    ccall((:igraph_degree_sequence_game, libigraph), igraph_error_t, (Ptr{igraph_t}, Ptr{igraph_vector_int_t}, Ptr{igraph_vector_int_t}, igraph_degseq_t), graph, out_deg, in_deg, method)
end

function igraph_growing_random_game(graph, n, m, directed, citation)
    ccall((:igraph_growing_random_game, libigraph), igraph_error_t, (Ptr{igraph_t}, igraph_integer_t, igraph_integer_t, igraph_bool_t, igraph_bool_t), graph, n, m, directed, citation)
end

function igraph_barabasi_aging_game(graph, nodes, m, outseq, outpref, pa_exp, aging_exp, aging_bin, zero_deg_appeal, zero_age_appeal, deg_coef, age_coef, directed)
    ccall((:igraph_barabasi_aging_game, libigraph), igraph_error_t, (Ptr{igraph_t}, igraph_integer_t, igraph_integer_t, Ptr{igraph_vector_int_t}, igraph_bool_t, igraph_real_t, igraph_real_t, igraph_integer_t, igraph_real_t, igraph_real_t, igraph_real_t, igraph_real_t, igraph_bool_t), graph, nodes, m, outseq, outpref, pa_exp, aging_exp, aging_bin, zero_deg_appeal, zero_age_appeal, deg_coef, age_coef, directed)
end

function igraph_recent_degree_game(graph, n, power, window, m, outseq, outpref, zero_appeal, directed)
    ccall((:igraph_recent_degree_game, libigraph), igraph_error_t, (Ptr{igraph_t}, igraph_integer_t, igraph_real_t, igraph_integer_t, igraph_integer_t, Ptr{igraph_vector_int_t}, igraph_bool_t, igraph_real_t, igraph_bool_t), graph, n, power, window, m, outseq, outpref, zero_appeal, directed)
end

function igraph_recent_degree_aging_game(graph, nodes, m, outseq, outpref, pa_exp, aging_exp, aging_bin, window, zero_appeal, directed)
    ccall((:igraph_recent_degree_aging_game, libigraph), igraph_error_t, (Ptr{igraph_t}, igraph_integer_t, igraph_integer_t, Ptr{igraph_vector_int_t}, igraph_bool_t, igraph_real_t, igraph_real_t, igraph_integer_t, igraph_integer_t, igraph_real_t, igraph_bool_t), graph, nodes, m, outseq, outpref, pa_exp, aging_exp, aging_bin, window, zero_appeal, directed)
end

function igraph_callaway_traits_game(graph, nodes, types, edges_per_step, type_dist, pref_matrix, directed, node_type_vec)
    ccall((:igraph_callaway_traits_game, libigraph), igraph_error_t, (Ptr{igraph_t}, igraph_integer_t, igraph_integer_t, igraph_integer_t, Ptr{igraph_vector_t}, Ptr{igraph_matrix_t}, igraph_bool_t, Ptr{igraph_vector_int_t}), graph, nodes, types, edges_per_step, type_dist, pref_matrix, directed, node_type_vec)
end

function igraph_establishment_game(graph, nodes, types, k, type_dist, pref_matrix, directed, node_type_vec)
    ccall((:igraph_establishment_game, libigraph), igraph_error_t, (Ptr{igraph_t}, igraph_integer_t, igraph_integer_t, igraph_integer_t, Ptr{igraph_vector_t}, Ptr{igraph_matrix_t}, igraph_bool_t, Ptr{igraph_vector_int_t}), graph, nodes, types, k, type_dist, pref_matrix, directed, node_type_vec)
end

function igraph_grg_game(graph, nodes, radius, torus, x, y)
    ccall((:igraph_grg_game, libigraph), igraph_error_t, (Ptr{igraph_t}, igraph_integer_t, igraph_real_t, igraph_bool_t, Ptr{igraph_vector_t}, Ptr{igraph_vector_t}), graph, nodes, radius, torus, x, y)
end

function igraph_preference_game(graph, nodes, types, type_dist, fixed_sizes, pref_matrix, node_type_vec, directed, loops)
    ccall((:igraph_preference_game, libigraph), igraph_error_t, (Ptr{igraph_t}, igraph_integer_t, igraph_integer_t, Ptr{igraph_vector_t}, igraph_bool_t, Ptr{igraph_matrix_t}, Ptr{igraph_vector_int_t}, igraph_bool_t, igraph_bool_t), graph, nodes, types, type_dist, fixed_sizes, pref_matrix, node_type_vec, directed, loops)
end

function igraph_asymmetric_preference_game(graph, nodes, out_types, in_types, type_dist_matrix, pref_matrix, node_type_out_vec, node_type_in_vec, loops)
    ccall((:igraph_asymmetric_preference_game, libigraph), igraph_error_t, (Ptr{igraph_t}, igraph_integer_t, igraph_integer_t, igraph_integer_t, Ptr{igraph_matrix_t}, Ptr{igraph_matrix_t}, Ptr{igraph_vector_int_t}, Ptr{igraph_vector_int_t}, igraph_bool_t), graph, nodes, out_types, in_types, type_dist_matrix, pref_matrix, node_type_out_vec, node_type_in_vec, loops)
end

function igraph_rewire_edges(graph, prob, loops, multiple)
    ccall((:igraph_rewire_edges, libigraph), igraph_error_t, (Ptr{igraph_t}, igraph_real_t, igraph_bool_t, igraph_bool_t), graph, prob, loops, multiple)
end

function igraph_rewire_directed_edges(graph, prob, loops, mode)
    ccall((:igraph_rewire_directed_edges, libigraph), igraph_error_t, (Ptr{igraph_t}, igraph_real_t, igraph_bool_t, igraph_neimode_t), graph, prob, loops, mode)
end

function igraph_watts_strogatz_game(graph, dim, size, nei, p, loops, multiple)
    ccall((:igraph_watts_strogatz_game, libigraph), igraph_error_t, (Ptr{igraph_t}, igraph_integer_t, igraph_integer_t, igraph_integer_t, igraph_real_t, igraph_bool_t, igraph_bool_t), graph, dim, size, nei, p, loops, multiple)
end

function igraph_lastcit_game(graph, nodes, edges_per_node, agebins, preference, directed)
    ccall((:igraph_lastcit_game, libigraph), igraph_error_t, (Ptr{igraph_t}, igraph_integer_t, igraph_integer_t, igraph_integer_t, Ptr{igraph_vector_t}, igraph_bool_t), graph, nodes, edges_per_node, agebins, preference, directed)
end

function igraph_cited_type_game(graph, nodes, types, pref, edges_per_step, directed)
    ccall((:igraph_cited_type_game, libigraph), igraph_error_t, (Ptr{igraph_t}, igraph_integer_t, Ptr{igraph_vector_int_t}, Ptr{igraph_vector_t}, igraph_integer_t, igraph_bool_t), graph, nodes, types, pref, edges_per_step, directed)
end

function igraph_citing_cited_type_game(graph, nodes, types, pref, edges_per_step, directed)
    ccall((:igraph_citing_cited_type_game, libigraph), igraph_error_t, (Ptr{igraph_t}, igraph_integer_t, Ptr{igraph_vector_int_t}, Ptr{igraph_matrix_t}, igraph_integer_t, igraph_bool_t), graph, nodes, types, pref, edges_per_step, directed)
end

function igraph_forest_fire_game(graph, nodes, fw_prob, bw_factor, ambs, directed)
    ccall((:igraph_forest_fire_game, libigraph), igraph_error_t, (Ptr{igraph_t}, igraph_integer_t, igraph_real_t, igraph_real_t, igraph_integer_t, igraph_bool_t), graph, nodes, fw_prob, bw_factor, ambs, directed)
end

function igraph_simple_interconnected_islands_game(graph, islands_n, islands_size, islands_pin, n_inter)
    ccall((:igraph_simple_interconnected_islands_game, libigraph), igraph_error_t, (Ptr{igraph_t}, igraph_integer_t, igraph_integer_t, igraph_real_t, igraph_integer_t), graph, islands_n, islands_size, islands_pin, n_inter)
end

function igraph_static_fitness_game(graph, no_of_edges, fitness_out, fitness_in, loops, multiple)
    ccall((:igraph_static_fitness_game, libigraph), igraph_error_t, (Ptr{igraph_t}, igraph_integer_t, Ptr{igraph_vector_t}, Ptr{igraph_vector_t}, igraph_bool_t, igraph_bool_t), graph, no_of_edges, fitness_out, fitness_in, loops, multiple)
end

function igraph_static_power_law_game(graph, no_of_nodes, no_of_edges, exponent_out, exponent_in, loops, multiple, finite_size_correction)
    ccall((:igraph_static_power_law_game, libigraph), igraph_error_t, (Ptr{igraph_t}, igraph_integer_t, igraph_integer_t, igraph_real_t, igraph_real_t, igraph_bool_t, igraph_bool_t, igraph_bool_t), graph, no_of_nodes, no_of_edges, exponent_out, exponent_in, loops, multiple, finite_size_correction)
end

function igraph_chung_lu_game(graph, expected_out_deg, expected_in_deg, loops, variant)
    ccall((:igraph_chung_lu_game, libigraph), igraph_error_t, (Ptr{igraph_t}, Ptr{igraph_vector_t}, Ptr{igraph_vector_t}, igraph_bool_t, igraph_chung_lu_t), graph, expected_out_deg, expected_in_deg, loops, variant)
end

function igraph_k_regular_game(graph, no_of_nodes, k, directed, multiple)
    ccall((:igraph_k_regular_game, libigraph), igraph_error_t, (Ptr{igraph_t}, igraph_integer_t, igraph_integer_t, igraph_bool_t, igraph_bool_t), graph, no_of_nodes, k, directed, multiple)
end

function igraph_sbm_game(graph, n, pref_matrix, block_sizes, directed, loops)
    ccall((:igraph_sbm_game, libigraph), igraph_error_t, (Ptr{igraph_t}, igraph_integer_t, Ptr{igraph_matrix_t}, Ptr{igraph_vector_int_t}, igraph_bool_t, igraph_bool_t), graph, n, pref_matrix, block_sizes, directed, loops)
end

function igraph_hsbm_game(graph, n, m, rho, C, p)
    ccall((:igraph_hsbm_game, libigraph), igraph_error_t, (Ptr{igraph_t}, igraph_integer_t, igraph_integer_t, Ptr{igraph_vector_t}, Ptr{igraph_matrix_t}, igraph_real_t), graph, n, m, rho, C, p)
end

function igraph_hsbm_list_game(graph, n, mlist, rholist, Clist, p)
    ccall((:igraph_hsbm_list_game, libigraph), igraph_error_t, (Ptr{igraph_t}, igraph_integer_t, Ptr{igraph_vector_int_t}, Ptr{igraph_vector_list_t}, Ptr{igraph_matrix_list_t}, igraph_real_t), graph, n, mlist, rholist, Clist, p)
end

function igraph_correlated_game(old_graph, new_graph, corr, p, permutation)
    ccall((:igraph_correlated_game, libigraph), igraph_error_t, (Ptr{igraph_t}, Ptr{igraph_t}, igraph_real_t, igraph_real_t, Ptr{igraph_vector_int_t}), old_graph, new_graph, corr, p, permutation)
end

function igraph_correlated_pair_game(graph1, graph2, n, corr, p, directed, permutation)
    ccall((:igraph_correlated_pair_game, libigraph), igraph_error_t, (Ptr{igraph_t}, Ptr{igraph_t}, igraph_integer_t, igraph_real_t, igraph_real_t, igraph_bool_t, Ptr{igraph_vector_int_t}), graph1, graph2, n, corr, p, directed, permutation)
end

function igraph_tree_game(graph, n, directed, method)
    ccall((:igraph_tree_game, libigraph), igraph_error_t, (Ptr{igraph_t}, igraph_integer_t, igraph_bool_t, igraph_random_tree_t), graph, n, directed, method)
end

function igraph_dot_product_game(graph, vecs, directed)
    ccall((:igraph_dot_product_game, libigraph), igraph_error_t, (Ptr{igraph_t}, Ptr{igraph_matrix_t}, igraph_bool_t), graph, vecs, directed)
end

function igraph_sample_sphere_surface(dim, n, radius, positive, res)
    ccall((:igraph_sample_sphere_surface, libigraph), igraph_error_t, (igraph_integer_t, igraph_integer_t, igraph_real_t, igraph_bool_t, Ptr{igraph_matrix_t}), dim, n, radius, positive, res)
end

function igraph_sample_sphere_volume(dim, n, radius, positive, res)
    ccall((:igraph_sample_sphere_volume, libigraph), igraph_error_t, (igraph_integer_t, igraph_integer_t, igraph_real_t, igraph_bool_t, Ptr{igraph_matrix_t}), dim, n, radius, positive, res)
end

function igraph_sample_dirichlet(n, alpha, res)
    ccall((:igraph_sample_dirichlet, libigraph), igraph_error_t, (igraph_integer_t, Ptr{igraph_vector_t}, Ptr{igraph_matrix_t}), n, alpha, res)
end

function igraph_erdos_renyi_game(graph, type, n, p_or_m, directed, loops)
    ccall((:igraph_erdos_renyi_game, libigraph), igraph_error_t, (Ptr{igraph_t}, igraph_erdos_renyi_t, igraph_integer_t, igraph_real_t, igraph_bool_t, igraph_bool_t), graph, type, n, p_or_m, directed, loops)
end

function igraph_deterministic_optimal_imitation(graph, vid, optimality, quantities, strategies, mode)
    ccall((:igraph_deterministic_optimal_imitation, libigraph), igraph_error_t, (Ptr{igraph_t}, igraph_integer_t, igraph_optimal_t, Ptr{igraph_vector_t}, Ptr{igraph_vector_int_t}, igraph_neimode_t), graph, vid, optimality, quantities, strategies, mode)
end

function igraph_moran_process(graph, weights, quantities, strategies, mode)
    ccall((:igraph_moran_process, libigraph), igraph_error_t, (Ptr{igraph_t}, Ptr{igraph_vector_t}, Ptr{igraph_vector_t}, Ptr{igraph_vector_int_t}, igraph_neimode_t), graph, weights, quantities, strategies, mode)
end

function igraph_roulette_wheel_imitation(graph, vid, islocal, quantities, strategies, mode)
    ccall((:igraph_roulette_wheel_imitation, libigraph), igraph_error_t, (Ptr{igraph_t}, igraph_integer_t, igraph_bool_t, Ptr{igraph_vector_t}, Ptr{igraph_vector_int_t}, igraph_neimode_t), graph, vid, islocal, quantities, strategies, mode)
end

function igraph_stochastic_imitation(graph, vid, algo, quantities, strategies, mode)
    ccall((:igraph_stochastic_imitation, libigraph), igraph_error_t, (Ptr{igraph_t}, igraph_integer_t, igraph_imitate_algorithm_t, Ptr{igraph_vector_t}, Ptr{igraph_vector_int_t}, igraph_neimode_t), graph, vid, algo, quantities, strategies, mode)
end

function igraph_closeness(graph, res, reachable_count, all_reachable, vids, mode, weights, normalized)
    ccall((:igraph_closeness, libigraph), igraph_error_t, (Ptr{igraph_t}, Ptr{igraph_vector_t}, Ptr{igraph_vector_int_t}, Ptr{igraph_bool_t}, igraph_vs_t, igraph_neimode_t, Ptr{igraph_vector_t}, igraph_bool_t), graph, res, reachable_count, all_reachable, vids, mode, weights, normalized)
end

function igraph_closeness_cutoff(graph, res, reachable_count, all_reachable, vids, mode, weights, normalized, cutoff)
    ccall((:igraph_closeness_cutoff, libigraph), igraph_error_t, (Ptr{igraph_t}, Ptr{igraph_vector_t}, Ptr{igraph_vector_int_t}, Ptr{igraph_bool_t}, igraph_vs_t, igraph_neimode_t, Ptr{igraph_vector_t}, igraph_bool_t, igraph_real_t), graph, res, reachable_count, all_reachable, vids, mode, weights, normalized, cutoff)
end

function igraph_harmonic_centrality(graph, res, vids, mode, weights, normalized)
    ccall((:igraph_harmonic_centrality, libigraph), igraph_error_t, (Ptr{igraph_t}, Ptr{igraph_vector_t}, igraph_vs_t, igraph_neimode_t, Ptr{igraph_vector_t}, igraph_bool_t), graph, res, vids, mode, weights, normalized)
end

function igraph_harmonic_centrality_cutoff(graph, res, vids, mode, weights, normalized, cutoff)
    ccall((:igraph_harmonic_centrality_cutoff, libigraph), igraph_error_t, (Ptr{igraph_t}, Ptr{igraph_vector_t}, igraph_vs_t, igraph_neimode_t, Ptr{igraph_vector_t}, igraph_bool_t, igraph_real_t), graph, res, vids, mode, weights, normalized, cutoff)
end

function igraph_betweenness(graph, res, vids, directed, weights)
    ccall((:igraph_betweenness, libigraph), igraph_error_t, (Ptr{igraph_t}, Ptr{igraph_vector_t}, igraph_vs_t, igraph_bool_t, Ptr{igraph_vector_t}), graph, res, vids, directed, weights)
end

function igraph_betweenness_cutoff(graph, res, vids, directed, weights, cutoff)
    ccall((:igraph_betweenness_cutoff, libigraph), igraph_error_t, (Ptr{igraph_t}, Ptr{igraph_vector_t}, igraph_vs_t, igraph_bool_t, Ptr{igraph_vector_t}, igraph_real_t), graph, res, vids, directed, weights, cutoff)
end

function igraph_edge_betweenness(graph, result, directed, weights)
    ccall((:igraph_edge_betweenness, libigraph), igraph_error_t, (Ptr{igraph_t}, Ptr{igraph_vector_t}, igraph_bool_t, Ptr{igraph_vector_t}), graph, result, directed, weights)
end

function igraph_edge_betweenness_cutoff(graph, result, directed, weights, cutoff)
    ccall((:igraph_edge_betweenness_cutoff, libigraph), igraph_error_t, (Ptr{igraph_t}, Ptr{igraph_vector_t}, igraph_bool_t, Ptr{igraph_vector_t}, igraph_real_t), graph, result, directed, weights, cutoff)
end

function igraph_betweenness_subset(graph, res, vids, directed, sources, targets, weights)
    ccall((:igraph_betweenness_subset, libigraph), igraph_error_t, (Ptr{igraph_t}, Ptr{igraph_vector_t}, igraph_vs_t, igraph_bool_t, igraph_vs_t, igraph_vs_t, Ptr{igraph_vector_t}), graph, res, vids, directed, sources, targets, weights)
end

function igraph_edge_betweenness_subset(graph, res, eids, directed, sources, targets, weights)
    ccall((:igraph_edge_betweenness_subset, libigraph), igraph_error_t, (Ptr{igraph_t}, Ptr{igraph_vector_t}, igraph_es_t, igraph_bool_t, igraph_vs_t, igraph_vs_t, Ptr{igraph_vector_t}), graph, res, eids, directed, sources, targets, weights)
end

@cenum igraph_pagerank_algo_t::UInt32 begin
    IGRAPH_PAGERANK_ALGO_ARPACK = 1
    IGRAPH_PAGERANK_ALGO_PRPACK = 2
end

function igraph_pagerank(graph, algo, vector, value, vids, directed, damping, weights, options)
    ccall((:igraph_pagerank, libigraph), igraph_error_t, (Ptr{igraph_t}, igraph_pagerank_algo_t, Ptr{igraph_vector_t}, Ptr{igraph_real_t}, igraph_vs_t, igraph_bool_t, igraph_real_t, Ptr{igraph_vector_t}, Ptr{igraph_arpack_options_t}), graph, algo, vector, value, vids, directed, damping, weights, options)
end

function igraph_personalized_pagerank(graph, algo, vector, value, vids, directed, damping, reset, weights, options)
    ccall((:igraph_personalized_pagerank, libigraph), igraph_error_t, (Ptr{igraph_t}, igraph_pagerank_algo_t, Ptr{igraph_vector_t}, Ptr{igraph_real_t}, igraph_vs_t, igraph_bool_t, igraph_real_t, Ptr{igraph_vector_t}, Ptr{igraph_vector_t}, Ptr{igraph_arpack_options_t}), graph, algo, vector, value, vids, directed, damping, reset, weights, options)
end

function igraph_personalized_pagerank_vs(graph, algo, vector, value, vids, directed, damping, reset_vids, weights, options)
    ccall((:igraph_personalized_pagerank_vs, libigraph), igraph_error_t, (Ptr{igraph_t}, igraph_pagerank_algo_t, Ptr{igraph_vector_t}, Ptr{igraph_real_t}, igraph_vs_t, igraph_bool_t, igraph_real_t, igraph_vs_t, Ptr{igraph_vector_t}, Ptr{igraph_arpack_options_t}), graph, algo, vector, value, vids, directed, damping, reset_vids, weights, options)
end

function igraph_eigenvector_centrality(graph, vector, value, directed, scale, weights, options)
    ccall((:igraph_eigenvector_centrality, libigraph), igraph_error_t, (Ptr{igraph_t}, Ptr{igraph_vector_t}, Ptr{igraph_real_t}, igraph_bool_t, igraph_bool_t, Ptr{igraph_vector_t}, Ptr{igraph_arpack_options_t}), graph, vector, value, directed, scale, weights, options)
end

function igraph_hub_and_authority_scores(graph, hub_vector, authority_vector, value, scale, weights, options)
    ccall((:igraph_hub_and_authority_scores, libigraph), igraph_error_t, (Ptr{igraph_t}, Ptr{igraph_vector_t}, Ptr{igraph_vector_t}, Ptr{igraph_real_t}, igraph_bool_t, Ptr{igraph_vector_t}, Ptr{igraph_arpack_options_t}), graph, hub_vector, authority_vector, value, scale, weights, options)
end

function igraph_constraint(graph, res, vids, weights)
    ccall((:igraph_constraint, libigraph), igraph_error_t, (Ptr{igraph_t}, Ptr{igraph_vector_t}, igraph_vs_t, Ptr{igraph_vector_t}), graph, res, vids, weights)
end

function igraph_convergence_degree(graph, result, ins, outs)
    ccall((:igraph_convergence_degree, libigraph), igraph_error_t, (Ptr{igraph_t}, Ptr{igraph_vector_t}, Ptr{igraph_vector_t}, Ptr{igraph_vector_t}), graph, result, ins, outs)
end

function igraph_centralization(scores, theoretical_max, normalized)
    ccall((:igraph_centralization, libigraph), igraph_real_t, (Ptr{igraph_vector_t}, igraph_real_t, igraph_bool_t), scores, theoretical_max, normalized)
end

function igraph_centralization_degree(graph, res, mode, loops, centralization, theoretical_max, normalized)
    ccall((:igraph_centralization_degree, libigraph), igraph_error_t, (Ptr{igraph_t}, Ptr{igraph_vector_t}, igraph_neimode_t, igraph_bool_t, Ptr{igraph_real_t}, Ptr{igraph_real_t}, igraph_bool_t), graph, res, mode, loops, centralization, theoretical_max, normalized)
end

function igraph_centralization_degree_tmax(graph, nodes, mode, loops, res)
    ccall((:igraph_centralization_degree_tmax, libigraph), igraph_error_t, (Ptr{igraph_t}, igraph_integer_t, igraph_neimode_t, igraph_bool_t, Ptr{igraph_real_t}), graph, nodes, mode, loops, res)
end

function igraph_centralization_betweenness(graph, res, directed, centralization, theoretical_max, normalized)
    ccall((:igraph_centralization_betweenness, libigraph), igraph_error_t, (Ptr{igraph_t}, Ptr{igraph_vector_t}, igraph_bool_t, Ptr{igraph_real_t}, Ptr{igraph_real_t}, igraph_bool_t), graph, res, directed, centralization, theoretical_max, normalized)
end

function igraph_centralization_betweenness_tmax(graph, nodes, directed, res)
    ccall((:igraph_centralization_betweenness_tmax, libigraph), igraph_error_t, (Ptr{igraph_t}, igraph_integer_t, igraph_bool_t, Ptr{igraph_real_t}), graph, nodes, directed, res)
end

function igraph_centralization_closeness(graph, res, mode, centralization, theoretical_max, normalized)
    ccall((:igraph_centralization_closeness, libigraph), igraph_error_t, (Ptr{igraph_t}, Ptr{igraph_vector_t}, igraph_neimode_t, Ptr{igraph_real_t}, Ptr{igraph_real_t}, igraph_bool_t), graph, res, mode, centralization, theoretical_max, normalized)
end

function igraph_centralization_closeness_tmax(graph, nodes, mode, res)
    ccall((:igraph_centralization_closeness_tmax, libigraph), igraph_error_t, (Ptr{igraph_t}, igraph_integer_t, igraph_neimode_t, Ptr{igraph_real_t}), graph, nodes, mode, res)
end

function igraph_centralization_eigenvector_centrality(graph, vector, value, directed, scale, options, centralization, theoretical_max, normalized)
    ccall((:igraph_centralization_eigenvector_centrality, libigraph), igraph_error_t, (Ptr{igraph_t}, Ptr{igraph_vector_t}, Ptr{igraph_real_t}, igraph_bool_t, igraph_bool_t, Ptr{igraph_arpack_options_t}, Ptr{igraph_real_t}, Ptr{igraph_real_t}, igraph_bool_t), graph, vector, value, directed, scale, options, centralization, theoretical_max, normalized)
end

function igraph_centralization_eigenvector_centrality_tmax(graph, nodes, directed, scale, res)
    ccall((:igraph_centralization_eigenvector_centrality_tmax, libigraph), igraph_error_t, (Ptr{igraph_t}, igraph_integer_t, igraph_bool_t, igraph_bool_t, Ptr{igraph_real_t}), graph, nodes, directed, scale, res)
end

function igraph_hub_score(graph, vector, value, scale, weights, options)
    ccall((:igraph_hub_score, libigraph), igraph_error_t, (Ptr{igraph_t}, Ptr{igraph_vector_t}, Ptr{igraph_real_t}, igraph_bool_t, Ptr{igraph_vector_t}, Ptr{igraph_arpack_options_t}), graph, vector, value, scale, weights, options)
end

function igraph_authority_score(graph, vector, value, scale, weights, options)
    ccall((:igraph_authority_score, libigraph), igraph_error_t, (Ptr{igraph_t}, Ptr{igraph_vector_t}, Ptr{igraph_real_t}, igraph_bool_t, Ptr{igraph_vector_t}, Ptr{igraph_arpack_options_t}), graph, vector, value, scale, weights, options)
end

# typedef igraph_error_t igraph_astar_heuristic_func_t ( igraph_real_t * result , igraph_integer_t from , igraph_integer_t to , void * extra )
const igraph_astar_heuristic_func_t = Cvoid

@cenum igraph_floyd_warshall_algorithm_t::UInt32 begin
    IGRAPH_FLOYD_WARSHALL_AUTOMATIC = 0
    IGRAPH_FLOYD_WARSHALL_ORIGINAL = 1
    IGRAPH_FLOYD_WARSHALL_TREE = 2
end

function igraph_diameter(graph, res, from, to, vertex_path, edge_path, directed, unconn)
    ccall((:igraph_diameter, libigraph), igraph_error_t, (Ptr{igraph_t}, Ptr{igraph_real_t}, Ptr{igraph_integer_t}, Ptr{igraph_integer_t}, Ptr{igraph_vector_int_t}, Ptr{igraph_vector_int_t}, igraph_bool_t, igraph_bool_t), graph, res, from, to, vertex_path, edge_path, directed, unconn)
end

function igraph_diameter_dijkstra(graph, weights, res, from, to, vertex_path, edge_path, directed, unconn)
    ccall((:igraph_diameter_dijkstra, libigraph), igraph_error_t, (Ptr{igraph_t}, Ptr{igraph_vector_t}, Ptr{igraph_real_t}, Ptr{igraph_integer_t}, Ptr{igraph_integer_t}, Ptr{igraph_vector_int_t}, Ptr{igraph_vector_int_t}, igraph_bool_t, igraph_bool_t), graph, weights, res, from, to, vertex_path, edge_path, directed, unconn)
end

function igraph_distances_cutoff(graph, res, from, to, mode, cutoff)
    ccall((:igraph_distances_cutoff, libigraph), igraph_error_t, (Ptr{igraph_t}, Ptr{igraph_matrix_t}, igraph_vs_t, igraph_vs_t, igraph_neimode_t, igraph_real_t), graph, res, from, to, mode, cutoff)
end

function igraph_distances(graph, res, from, to, mode)
    ccall((:igraph_distances, libigraph), igraph_error_t, (Ptr{igraph_t}, Ptr{igraph_matrix_t}, igraph_vs_t, igraph_vs_t, igraph_neimode_t), graph, res, from, to, mode)
end

function igraph_distances_bellman_ford(graph, res, from, to, weights, mode)
    ccall((:igraph_distances_bellman_ford, libigraph), igraph_error_t, (Ptr{igraph_t}, Ptr{igraph_matrix_t}, igraph_vs_t, igraph_vs_t, Ptr{igraph_vector_t}, igraph_neimode_t), graph, res, from, to, weights, mode)
end

function igraph_distances_dijkstra_cutoff(graph, res, from, to, weights, mode, cutoff)
    ccall((:igraph_distances_dijkstra_cutoff, libigraph), igraph_error_t, (Ptr{igraph_t}, Ptr{igraph_matrix_t}, igraph_vs_t, igraph_vs_t, Ptr{igraph_vector_t}, igraph_neimode_t, igraph_real_t), graph, res, from, to, weights, mode, cutoff)
end

function igraph_distances_dijkstra(graph, res, from, to, weights, mode)
    ccall((:igraph_distances_dijkstra, libigraph), igraph_error_t, (Ptr{igraph_t}, Ptr{igraph_matrix_t}, igraph_vs_t, igraph_vs_t, Ptr{igraph_vector_t}, igraph_neimode_t), graph, res, from, to, weights, mode)
end

function igraph_distances_johnson(graph, res, from, to, weights)
    ccall((:igraph_distances_johnson, libigraph), igraph_error_t, (Ptr{igraph_t}, Ptr{igraph_matrix_t}, igraph_vs_t, igraph_vs_t, Ptr{igraph_vector_t}), graph, res, from, to, weights)
end

function igraph_distances_floyd_warshall(graph, res, from, to, weights, mode, method)
    ccall((:igraph_distances_floyd_warshall, libigraph), igraph_error_t, (Ptr{igraph_t}, Ptr{igraph_matrix_t}, igraph_vs_t, igraph_vs_t, Ptr{igraph_vector_t}, igraph_neimode_t, igraph_floyd_warshall_algorithm_t), graph, res, from, to, weights, mode, method)
end

function igraph_shortest_paths(graph, res, from, to, mode)
    ccall((:igraph_shortest_paths, libigraph), igraph_error_t, (Ptr{igraph_t}, Ptr{igraph_matrix_t}, igraph_vs_t, igraph_vs_t, igraph_neimode_t), graph, res, from, to, mode)
end

function igraph_shortest_paths_bellman_ford(graph, res, from, to, weights, mode)
    ccall((:igraph_shortest_paths_bellman_ford, libigraph), igraph_error_t, (Ptr{igraph_t}, Ptr{igraph_matrix_t}, igraph_vs_t, igraph_vs_t, Ptr{igraph_vector_t}, igraph_neimode_t), graph, res, from, to, weights, mode)
end

function igraph_shortest_paths_dijkstra(graph, res, from, to, weights, mode)
    ccall((:igraph_shortest_paths_dijkstra, libigraph), igraph_error_t, (Ptr{igraph_t}, Ptr{igraph_matrix_t}, igraph_vs_t, igraph_vs_t, Ptr{igraph_vector_t}, igraph_neimode_t), graph, res, from, to, weights, mode)
end

function igraph_shortest_paths_johnson(graph, res, from, to, weights)
    ccall((:igraph_shortest_paths_johnson, libigraph), igraph_error_t, (Ptr{igraph_t}, Ptr{igraph_matrix_t}, igraph_vs_t, igraph_vs_t, Ptr{igraph_vector_t}), graph, res, from, to, weights)
end

function igraph_get_shortest_paths(graph, vertices, edges, from, to, mode, parents, inbound_edges)
    ccall((:igraph_get_shortest_paths, libigraph), igraph_error_t, (Ptr{igraph_t}, Ptr{igraph_vector_int_list_t}, Ptr{igraph_vector_int_list_t}, igraph_integer_t, igraph_vs_t, igraph_neimode_t, Ptr{igraph_vector_int_t}, Ptr{igraph_vector_int_t}), graph, vertices, edges, from, to, mode, parents, inbound_edges)
end

function igraph_get_shortest_paths_bellman_ford(graph, vertices, edges, from, to, weights, mode, parents, inbound_edges)
    ccall((:igraph_get_shortest_paths_bellman_ford, libigraph), igraph_error_t, (Ptr{igraph_t}, Ptr{igraph_vector_int_list_t}, Ptr{igraph_vector_int_list_t}, igraph_integer_t, igraph_vs_t, Ptr{igraph_vector_t}, igraph_neimode_t, Ptr{igraph_vector_int_t}, Ptr{igraph_vector_int_t}), graph, vertices, edges, from, to, weights, mode, parents, inbound_edges)
end

function igraph_get_shortest_paths_dijkstra(graph, vertices, edges, from, to, weights, mode, parents, inbound_edges)
    ccall((:igraph_get_shortest_paths_dijkstra, libigraph), igraph_error_t, (Ptr{igraph_t}, Ptr{igraph_vector_int_list_t}, Ptr{igraph_vector_int_list_t}, igraph_integer_t, igraph_vs_t, Ptr{igraph_vector_t}, igraph_neimode_t, Ptr{igraph_vector_int_t}, Ptr{igraph_vector_int_t}), graph, vertices, edges, from, to, weights, mode, parents, inbound_edges)
end

function igraph_get_shortest_path(graph, vertices, edges, from, to, mode)
    ccall((:igraph_get_shortest_path, libigraph), igraph_error_t, (Ptr{igraph_t}, Ptr{igraph_vector_int_t}, Ptr{igraph_vector_int_t}, igraph_integer_t, igraph_integer_t, igraph_neimode_t), graph, vertices, edges, from, to, mode)
end

function igraph_get_shortest_path_bellman_ford(graph, vertices, edges, from, to, weights, mode)
    ccall((:igraph_get_shortest_path_bellman_ford, libigraph), igraph_error_t, (Ptr{igraph_t}, Ptr{igraph_vector_int_t}, Ptr{igraph_vector_int_t}, igraph_integer_t, igraph_integer_t, Ptr{igraph_vector_t}, igraph_neimode_t), graph, vertices, edges, from, to, weights, mode)
end

function igraph_get_shortest_path_dijkstra(graph, vertices, edges, from, to, weights, mode)
    ccall((:igraph_get_shortest_path_dijkstra, libigraph), igraph_error_t, (Ptr{igraph_t}, Ptr{igraph_vector_int_t}, Ptr{igraph_vector_int_t}, igraph_integer_t, igraph_integer_t, Ptr{igraph_vector_t}, igraph_neimode_t), graph, vertices, edges, from, to, weights, mode)
end

function igraph_get_shortest_path_astar(graph, vertices, edges, from, to, weights, mode, heuristic, extra)
    ccall((:igraph_get_shortest_path_astar, libigraph), igraph_error_t, (Ptr{igraph_t}, Ptr{igraph_vector_int_t}, Ptr{igraph_vector_int_t}, igraph_integer_t, igraph_integer_t, Ptr{igraph_vector_t}, igraph_neimode_t, Ptr{igraph_astar_heuristic_func_t}, Ptr{Cvoid}), graph, vertices, edges, from, to, weights, mode, heuristic, extra)
end

function igraph_get_all_shortest_paths(graph, vertices, edges, nrgeo, from, to, mode)
    ccall((:igraph_get_all_shortest_paths, libigraph), igraph_error_t, (Ptr{igraph_t}, Ptr{igraph_vector_int_list_t}, Ptr{igraph_vector_int_list_t}, Ptr{igraph_vector_int_t}, igraph_integer_t, igraph_vs_t, igraph_neimode_t), graph, vertices, edges, nrgeo, from, to, mode)
end

function igraph_get_all_shortest_paths_dijkstra(graph, vertices, edges, nrgeo, from, to, weights, mode)
    ccall((:igraph_get_all_shortest_paths_dijkstra, libigraph), igraph_error_t, (Ptr{igraph_t}, Ptr{igraph_vector_int_list_t}, Ptr{igraph_vector_int_list_t}, Ptr{igraph_vector_int_t}, igraph_integer_t, igraph_vs_t, Ptr{igraph_vector_t}, igraph_neimode_t), graph, vertices, edges, nrgeo, from, to, weights, mode)
end

function igraph_average_path_length(graph, res, unconn_pairs, directed, unconn)
    ccall((:igraph_average_path_length, libigraph), igraph_error_t, (Ptr{igraph_t}, Ptr{igraph_real_t}, Ptr{igraph_real_t}, igraph_bool_t, igraph_bool_t), graph, res, unconn_pairs, directed, unconn)
end

function igraph_average_path_length_dijkstra(graph, res, unconn_pairs, weights, directed, unconn)
    ccall((:igraph_average_path_length_dijkstra, libigraph), igraph_error_t, (Ptr{igraph_t}, Ptr{igraph_real_t}, Ptr{igraph_real_t}, Ptr{igraph_vector_t}, igraph_bool_t, igraph_bool_t), graph, res, unconn_pairs, weights, directed, unconn)
end

function igraph_path_length_hist(graph, res, unconnected, directed)
    ccall((:igraph_path_length_hist, libigraph), igraph_error_t, (Ptr{igraph_t}, Ptr{igraph_vector_t}, Ptr{igraph_real_t}, igraph_bool_t), graph, res, unconnected, directed)
end

function igraph_global_efficiency(graph, res, weights, directed)
    ccall((:igraph_global_efficiency, libigraph), igraph_error_t, (Ptr{igraph_t}, Ptr{igraph_real_t}, Ptr{igraph_vector_t}, igraph_bool_t), graph, res, weights, directed)
end

function igraph_local_efficiency(graph, res, vids, weights, directed, mode)
    ccall((:igraph_local_efficiency, libigraph), igraph_error_t, (Ptr{igraph_t}, Ptr{igraph_vector_t}, igraph_vs_t, Ptr{igraph_vector_t}, igraph_bool_t, igraph_neimode_t), graph, res, vids, weights, directed, mode)
end

function igraph_average_local_efficiency(graph, res, weights, directed, mode)
    ccall((:igraph_average_local_efficiency, libigraph), igraph_error_t, (Ptr{igraph_t}, Ptr{igraph_real_t}, Ptr{igraph_vector_t}, igraph_bool_t, igraph_neimode_t), graph, res, weights, directed, mode)
end

function igraph_eccentricity(graph, res, vids, mode)
    ccall((:igraph_eccentricity, libigraph), igraph_error_t, (Ptr{igraph_t}, Ptr{igraph_vector_t}, igraph_vs_t, igraph_neimode_t), graph, res, vids, mode)
end

function igraph_eccentricity_dijkstra(graph, weights, res, vids, mode)
    ccall((:igraph_eccentricity_dijkstra, libigraph), igraph_error_t, (Ptr{igraph_t}, Ptr{igraph_vector_t}, Ptr{igraph_vector_t}, igraph_vs_t, igraph_neimode_t), graph, weights, res, vids, mode)
end

function igraph_radius(graph, radius, mode)
    ccall((:igraph_radius, libigraph), igraph_error_t, (Ptr{igraph_t}, Ptr{igraph_real_t}, igraph_neimode_t), graph, radius, mode)
end

function igraph_radius_dijkstra(graph, weights, radius, mode)
    ccall((:igraph_radius_dijkstra, libigraph), igraph_error_t, (Ptr{igraph_t}, Ptr{igraph_vector_t}, Ptr{igraph_real_t}, igraph_neimode_t), graph, weights, radius, mode)
end

function igraph_graph_center(graph, res, mode)
    ccall((:igraph_graph_center, libigraph), igraph_error_t, (Ptr{igraph_t}, Ptr{igraph_vector_int_t}, igraph_neimode_t), graph, res, mode)
end

function igraph_graph_center_dijkstra(graph, weights, res, mode)
    ccall((:igraph_graph_center_dijkstra, libigraph), igraph_error_t, (Ptr{igraph_t}, Ptr{igraph_vector_t}, Ptr{igraph_vector_int_t}, igraph_neimode_t), graph, weights, res, mode)
end

function igraph_pseudo_diameter(graph, diameter, vid_start, from, to, directed, unconn)
    ccall((:igraph_pseudo_diameter, libigraph), igraph_error_t, (Ptr{igraph_t}, Ptr{igraph_real_t}, igraph_integer_t, Ptr{igraph_integer_t}, Ptr{igraph_integer_t}, igraph_bool_t, igraph_bool_t), graph, diameter, vid_start, from, to, directed, unconn)
end

function igraph_pseudo_diameter_dijkstra(graph, weights, diameter, vid_start, from, to, directed, unconn)
    ccall((:igraph_pseudo_diameter_dijkstra, libigraph), igraph_error_t, (Ptr{igraph_t}, Ptr{igraph_vector_t}, Ptr{igraph_real_t}, igraph_integer_t, Ptr{igraph_integer_t}, Ptr{igraph_integer_t}, igraph_bool_t, igraph_bool_t), graph, weights, diameter, vid_start, from, to, directed, unconn)
end

function igraph_get_all_simple_paths(graph, res, from, to, cutoff, mode)
    ccall((:igraph_get_all_simple_paths, libigraph), igraph_error_t, (Ptr{igraph_t}, Ptr{igraph_vector_int_t}, igraph_integer_t, igraph_vs_t, igraph_integer_t, igraph_neimode_t), graph, res, from, to, cutoff, mode)
end

function igraph_random_walk(graph, weights, vertices, edges, start, mode, steps, stuck)
    ccall((:igraph_random_walk, libigraph), igraph_error_t, (Ptr{igraph_t}, Ptr{igraph_vector_t}, Ptr{igraph_vector_int_t}, Ptr{igraph_vector_int_t}, igraph_integer_t, igraph_neimode_t, igraph_integer_t, igraph_random_walk_stuck_t), graph, weights, vertices, edges, start, mode, steps, stuck)
end

function igraph_get_k_shortest_paths(graph, weights, vertex_paths, edge_paths, k, from, to, mode)
    ccall((:igraph_get_k_shortest_paths, libigraph), igraph_error_t, (Ptr{igraph_t}, Ptr{igraph_vector_t}, Ptr{igraph_vector_int_list_t}, Ptr{igraph_vector_int_list_t}, igraph_integer_t, igraph_integer_t, igraph_integer_t, igraph_neimode_t), graph, weights, vertex_paths, edge_paths, k, from, to, mode)
end

function igraph_spanner(graph, spanner, stretch, weights)
    ccall((:igraph_spanner, libigraph), igraph_error_t, (Ptr{igraph_t}, Ptr{igraph_vector_int_t}, igraph_real_t, Ptr{igraph_vector_t}), graph, spanner, stretch, weights)
end

function igraph_get_widest_paths(graph, vertices, edges, from, to, weights, mode, parents, inbound_edges)
    ccall((:igraph_get_widest_paths, libigraph), igraph_error_t, (Ptr{igraph_t}, Ptr{igraph_vector_int_list_t}, Ptr{igraph_vector_int_list_t}, igraph_integer_t, igraph_vs_t, Ptr{igraph_vector_t}, igraph_neimode_t, Ptr{igraph_vector_int_t}, Ptr{igraph_vector_int_t}), graph, vertices, edges, from, to, weights, mode, parents, inbound_edges)
end

function igraph_get_widest_path(graph, vertices, edges, from, to, weights, mode)
    ccall((:igraph_get_widest_path, libigraph), igraph_error_t, (Ptr{igraph_t}, Ptr{igraph_vector_int_t}, Ptr{igraph_vector_int_t}, igraph_integer_t, igraph_integer_t, Ptr{igraph_vector_t}, igraph_neimode_t), graph, vertices, edges, from, to, weights, mode)
end

function igraph_widest_path_widths_floyd_warshall(graph, res, from, to, weights, mode)
    ccall((:igraph_widest_path_widths_floyd_warshall, libigraph), igraph_error_t, (Ptr{igraph_t}, Ptr{igraph_matrix_t}, igraph_vs_t, igraph_vs_t, Ptr{igraph_vector_t}, igraph_neimode_t), graph, res, from, to, weights, mode)
end

function igraph_widest_path_widths_dijkstra(graph, res, from, to, weights, mode)
    ccall((:igraph_widest_path_widths_dijkstra, libigraph), igraph_error_t, (Ptr{igraph_t}, Ptr{igraph_matrix_t}, igraph_vs_t, igraph_vs_t, Ptr{igraph_vector_t}, igraph_neimode_t), graph, res, from, to, weights, mode)
end

function igraph_voronoi(graph, membership, distances, generators, weights, mode, tiebreaker)
    ccall((:igraph_voronoi, libigraph), igraph_error_t, (Ptr{igraph_t}, Ptr{igraph_vector_int_t}, Ptr{igraph_vector_t}, Ptr{igraph_vector_int_t}, Ptr{igraph_vector_t}, igraph_neimode_t, igraph_voronoi_tiebreaker_t), graph, membership, distances, generators, weights, mode, tiebreaker)
end

function igraph_expand_path_to_pairs(path)
    ccall((:igraph_expand_path_to_pairs, libigraph), igraph_error_t, (Ptr{igraph_vector_int_t},), path)
end

function igraph_vertex_path_from_edge_path(graph, start, edge_path, vertex_path, mode)
    ccall((:igraph_vertex_path_from_edge_path, libigraph), igraph_error_t, (Ptr{igraph_t}, igraph_integer_t, Ptr{igraph_vector_int_t}, Ptr{igraph_vector_int_t}, igraph_neimode_t), graph, start, edge_path, vertex_path, mode)
end

function igraph_random_edge_walk(graph, weights, edgewalk, start, mode, steps, stuck)
    ccall((:igraph_random_edge_walk, libigraph), igraph_error_t, (Ptr{igraph_t}, Ptr{igraph_vector_t}, Ptr{igraph_vector_int_t}, igraph_integer_t, igraph_neimode_t, igraph_integer_t, igraph_random_walk_stuck_t), graph, weights, edgewalk, start, mode, steps, stuck)
end

function igraph_clusters(graph, membership, csize, no, mode)
    ccall((:igraph_clusters, libigraph), igraph_error_t, (Ptr{igraph_t}, Ptr{igraph_vector_int_t}, Ptr{igraph_vector_int_t}, Ptr{igraph_integer_t}, igraph_connectedness_t), graph, membership, csize, no, mode)
end

function igraph_connected_components(graph, membership, csize, no, mode)
    ccall((:igraph_connected_components, libigraph), igraph_error_t, (Ptr{igraph_t}, Ptr{igraph_vector_int_t}, Ptr{igraph_vector_int_t}, Ptr{igraph_integer_t}, igraph_connectedness_t), graph, membership, csize, no, mode)
end

function igraph_is_connected(graph, res, mode)
    ccall((:igraph_is_connected, libigraph), igraph_error_t, (Ptr{igraph_t}, Ptr{igraph_bool_t}, igraph_connectedness_t), graph, res, mode)
end

function igraph_decompose(graph, components, mode, maxcompno, minelements)
    ccall((:igraph_decompose, libigraph), igraph_error_t, (Ptr{igraph_t}, Ptr{igraph_graph_list_t}, igraph_connectedness_t, igraph_integer_t, igraph_integer_t), graph, components, mode, maxcompno, minelements)
end

function igraph_articulation_points(graph, res)
    ccall((:igraph_articulation_points, libigraph), igraph_error_t, (Ptr{igraph_t}, Ptr{igraph_vector_int_t}), graph, res)
end

function igraph_biconnected_components(graph, no, tree_edges, component_edges, components, articulation_points)
    ccall((:igraph_biconnected_components, libigraph), igraph_error_t, (Ptr{igraph_t}, Ptr{igraph_integer_t}, Ptr{igraph_vector_int_list_t}, Ptr{igraph_vector_int_list_t}, Ptr{igraph_vector_int_list_t}, Ptr{igraph_vector_int_t}), graph, no, tree_edges, component_edges, components, articulation_points)
end

function igraph_is_biconnected(graph, result)
    ccall((:igraph_is_biconnected, libigraph), igraph_error_t, (Ptr{igraph_t}, Ptr{igraph_bool_t}), graph, result)
end

function igraph_bridges(graph, bridges)
    ccall((:igraph_bridges, libigraph), igraph_error_t, (Ptr{igraph_t}, Ptr{igraph_vector_int_t}), graph, bridges)
end

function igraph_decompose_destroy(complist)
    ccall((:igraph_decompose_destroy, libigraph), Cvoid, (Ptr{igraph_vector_ptr_t},), complist)
end

function igraph_are_adjacent(graph, v1, v2, res)
    ccall((:igraph_are_adjacent, libigraph), igraph_error_t, (Ptr{igraph_t}, igraph_integer_t, igraph_integer_t, Ptr{igraph_bool_t}), graph, v1, v2, res)
end

function igraph_are_connected(graph, v1, v2, res)
    ccall((:igraph_are_connected, libigraph), igraph_error_t, (Ptr{igraph_t}, igraph_integer_t, igraph_integer_t, Ptr{igraph_bool_t}), graph, v1, v2, res)
end

function igraph_count_multiple(graph, res, es)
    ccall((:igraph_count_multiple, libigraph), igraph_error_t, (Ptr{igraph_t}, Ptr{igraph_vector_int_t}, igraph_es_t), graph, res, es)
end

function igraph_count_multiple_1(graph, res, eid)
    ccall((:igraph_count_multiple_1, libigraph), igraph_error_t, (Ptr{igraph_t}, Ptr{igraph_integer_t}, igraph_integer_t), graph, res, eid)
end

function igraph_density(graph, res, loops)
    ccall((:igraph_density, libigraph), igraph_error_t, (Ptr{igraph_t}, Ptr{igraph_real_t}, igraph_bool_t), graph, res, loops)
end

function igraph_diversity(graph, weights, res, vs)
    ccall((:igraph_diversity, libigraph), igraph_error_t, (Ptr{igraph_t}, Ptr{igraph_vector_t}, Ptr{igraph_vector_t}, igraph_vs_t), graph, weights, res, vs)
end

function igraph_girth(graph, girth, circle)
    ccall((:igraph_girth, libigraph), igraph_error_t, (Ptr{igraph_t}, Ptr{igraph_real_t}, Ptr{igraph_vector_int_t}), graph, girth, circle)
end

function igraph_has_loop(graph, res)
    ccall((:igraph_has_loop, libigraph), igraph_error_t, (Ptr{igraph_t}, Ptr{igraph_bool_t}), graph, res)
end

function igraph_has_multiple(graph, res)
    ccall((:igraph_has_multiple, libigraph), igraph_error_t, (Ptr{igraph_t}, Ptr{igraph_bool_t}), graph, res)
end

function igraph_count_loops(graph, loop_count)
    ccall((:igraph_count_loops, libigraph), igraph_error_t, (Ptr{igraph_t}, Ptr{igraph_integer_t}), graph, loop_count)
end

function igraph_is_loop(graph, res, es)
    ccall((:igraph_is_loop, libigraph), igraph_error_t, (Ptr{igraph_t}, Ptr{igraph_vector_bool_t}, igraph_es_t), graph, res, es)
end

function igraph_is_multiple(graph, res, es)
    ccall((:igraph_is_multiple, libigraph), igraph_error_t, (Ptr{igraph_t}, Ptr{igraph_vector_bool_t}, igraph_es_t), graph, res, es)
end

function igraph_is_mutual(graph, res, es, loops)
    ccall((:igraph_is_mutual, libigraph), igraph_error_t, (Ptr{igraph_t}, Ptr{igraph_vector_bool_t}, igraph_es_t, igraph_bool_t), graph, res, es, loops)
end

function igraph_has_mutual(graph, res, loops)
    ccall((:igraph_has_mutual, libigraph), igraph_error_t, (Ptr{igraph_t}, Ptr{igraph_bool_t}, igraph_bool_t), graph, res, loops)
end

function igraph_is_simple(graph, res)
    ccall((:igraph_is_simple, libigraph), igraph_error_t, (Ptr{igraph_t}, Ptr{igraph_bool_t}), graph, res)
end

function igraph_is_tree(graph, res, root, mode)
    ccall((:igraph_is_tree, libigraph), igraph_error_t, (Ptr{igraph_t}, Ptr{igraph_bool_t}, Ptr{igraph_integer_t}, igraph_neimode_t), graph, res, root, mode)
end

function igraph_is_acyclic(graph, res)
    ccall((:igraph_is_acyclic, libigraph), igraph_error_t, (Ptr{igraph_t}, Ptr{igraph_bool_t}), graph, res)
end

function igraph_is_forest(graph, res, roots, mode)
    ccall((:igraph_is_forest, libigraph), igraph_error_t, (Ptr{igraph_t}, Ptr{igraph_bool_t}, Ptr{igraph_vector_int_t}, igraph_neimode_t), graph, res, roots, mode)
end

function igraph_maxdegree(graph, res, vids, mode, loops)
    ccall((:igraph_maxdegree, libigraph), igraph_error_t, (Ptr{igraph_t}, Ptr{igraph_integer_t}, igraph_vs_t, igraph_neimode_t, igraph_bool_t), graph, res, vids, mode, loops)
end

function igraph_mean_degree(graph, res, loops)
    ccall((:igraph_mean_degree, libigraph), igraph_error_t, (Ptr{igraph_t}, Ptr{igraph_real_t}, igraph_bool_t), graph, res, loops)
end

function igraph_reciprocity(graph, res, ignore_loops, mode)
    ccall((:igraph_reciprocity, libigraph), igraph_error_t, (Ptr{igraph_t}, Ptr{igraph_real_t}, igraph_bool_t, igraph_reciprocity_t), graph, res, ignore_loops, mode)
end

function igraph_strength(graph, res, vids, mode, loops, weights)
    ccall((:igraph_strength, libigraph), igraph_error_t, (Ptr{igraph_t}, Ptr{igraph_vector_t}, igraph_vs_t, igraph_neimode_t, igraph_bool_t, Ptr{igraph_vector_t}), graph, res, vids, mode, loops, weights)
end

function igraph_sort_vertex_ids_by_degree(graph, outvids, vids, mode, loops, order, only_indices)
    ccall((:igraph_sort_vertex_ids_by_degree, libigraph), igraph_error_t, (Ptr{igraph_t}, Ptr{igraph_vector_int_t}, igraph_vs_t, igraph_neimode_t, igraph_bool_t, igraph_order_t, igraph_bool_t), graph, outvids, vids, mode, loops, order, only_indices)
end

function igraph_is_perfect(graph, perfect)
    ccall((:igraph_is_perfect, libigraph), igraph_error_t, (Ptr{igraph_t}, Ptr{igraph_bool_t}), graph, perfect)
end

function igraph_is_complete(graph, res)
    ccall((:igraph_is_complete, libigraph), igraph_error_t, (Ptr{igraph_t}, Ptr{igraph_bool_t}), graph, res)
end

function igraph_is_clique(graph, candidate, directed, res)
    ccall((:igraph_is_clique, libigraph), igraph_error_t, (Ptr{igraph_t}, igraph_vs_t, igraph_bool_t, Ptr{igraph_bool_t}), graph, candidate, directed, res)
end

function igraph_is_independent_vertex_set(graph, candidate, res)
    ccall((:igraph_is_independent_vertex_set, libigraph), igraph_error_t, (Ptr{igraph_t}, igraph_vs_t, Ptr{igraph_bool_t}), graph, candidate, res)
end

function igraph_minimum_spanning_tree(graph, res, weights)
    ccall((:igraph_minimum_spanning_tree, libigraph), igraph_error_t, (Ptr{igraph_t}, Ptr{igraph_vector_int_t}, Ptr{igraph_vector_t}), graph, res, weights)
end

function igraph_minimum_spanning_tree_unweighted(graph, mst)
    ccall((:igraph_minimum_spanning_tree_unweighted, libigraph), igraph_error_t, (Ptr{igraph_t}, Ptr{igraph_t}), graph, mst)
end

function igraph_minimum_spanning_tree_prim(graph, mst, weights)
    ccall((:igraph_minimum_spanning_tree_prim, libigraph), igraph_error_t, (Ptr{igraph_t}, Ptr{igraph_t}, Ptr{igraph_vector_t}), graph, mst, weights)
end

function igraph_random_spanning_tree(graph, res, vid)
    ccall((:igraph_random_spanning_tree, libigraph), igraph_error_t, (Ptr{igraph_t}, Ptr{igraph_vector_int_t}, igraph_integer_t), graph, res, vid)
end

function igraph_subcomponent(graph, res, vid, mode)
    ccall((:igraph_subcomponent, libigraph), igraph_error_t, (Ptr{igraph_t}, Ptr{igraph_vector_int_t}, igraph_integer_t, igraph_neimode_t), graph, res, vid, mode)
end

function igraph_unfold_tree(graph, tree, mode, roots, vertex_index)
    ccall((:igraph_unfold_tree, libigraph), igraph_error_t, (Ptr{igraph_t}, Ptr{igraph_t}, igraph_neimode_t, Ptr{igraph_vector_int_t}, Ptr{igraph_vector_int_t}), graph, tree, mode, roots, vertex_index)
end

function igraph_maximum_cardinality_search(graph, alpha, alpham1)
    ccall((:igraph_maximum_cardinality_search, libigraph), igraph_error_t, (Ptr{igraph_t}, Ptr{igraph_vector_int_t}, Ptr{igraph_vector_int_t}), graph, alpha, alpham1)
end

function igraph_is_chordal(graph, alpha, alpham1, chordal, fill_in, newgraph)
    ccall((:igraph_is_chordal, libigraph), igraph_error_t, (Ptr{igraph_t}, Ptr{igraph_vector_int_t}, Ptr{igraph_vector_int_t}, Ptr{igraph_bool_t}, Ptr{igraph_vector_int_t}, Ptr{igraph_t}), graph, alpha, alpham1, chordal, fill_in, newgraph)
end

function igraph_avg_nearest_neighbor_degree(graph, vids, mode, neighbor_degree_mode, knn, knnk, weights)
    ccall((:igraph_avg_nearest_neighbor_degree, libigraph), igraph_error_t, (Ptr{igraph_t}, igraph_vs_t, igraph_neimode_t, igraph_neimode_t, Ptr{igraph_vector_t}, Ptr{igraph_vector_t}, Ptr{igraph_vector_t}), graph, vids, mode, neighbor_degree_mode, knn, knnk, weights)
end

function igraph_degree_correlation_vector(graph, weights, knnk, from_mode, to_mode, directed_neighbors)
    ccall((:igraph_degree_correlation_vector, libigraph), igraph_error_t, (Ptr{igraph_t}, Ptr{igraph_vector_t}, Ptr{igraph_vector_t}, igraph_neimode_t, igraph_neimode_t, igraph_bool_t), graph, weights, knnk, from_mode, to_mode, directed_neighbors)
end

function igraph_feedback_arc_set(graph, result, weights, algo)
    ccall((:igraph_feedback_arc_set, libigraph), igraph_error_t, (Ptr{igraph_t}, Ptr{igraph_vector_int_t}, Ptr{igraph_vector_t}, igraph_fas_algorithm_t), graph, result, weights, algo)
end

function igraph_feedback_vertex_set(graph, result, vertex_weights, algo)
    ccall((:igraph_feedback_vertex_set, libigraph), igraph_error_t, (Ptr{igraph_t}, Ptr{igraph_vector_int_t}, Ptr{igraph_vector_t}, igraph_fvs_algorithm_t), graph, result, vertex_weights, algo)
end

@cenum igraph_laplacian_normalization_t::UInt32 begin
    IGRAPH_LAPLACIAN_UNNORMALIZED = 0
    IGRAPH_LAPLACIAN_SYMMETRIC = 1
    IGRAPH_LAPLACIAN_LEFT = 2
    IGRAPH_LAPLACIAN_RIGHT = 3
end

function igraph_get_laplacian(graph, res, mode, normalization, weights)
    ccall((:igraph_get_laplacian, libigraph), igraph_error_t, (Ptr{igraph_t}, Ptr{igraph_matrix_t}, igraph_neimode_t, igraph_laplacian_normalization_t, Ptr{igraph_vector_t}), graph, res, mode, normalization, weights)
end

function igraph_get_laplacian_sparse(graph, sparseres, mode, normalization, weights)
    ccall((:igraph_get_laplacian_sparse, libigraph), igraph_error_t, (Ptr{igraph_t}, Ptr{igraph_sparsemat_t}, igraph_neimode_t, igraph_laplacian_normalization_t, Ptr{igraph_vector_t}), graph, sparseres, mode, normalization, weights)
end

function igraph_laplacian(graph, res, sparseres, normalized, weights)
    ccall((:igraph_laplacian, libigraph), igraph_error_t, (Ptr{igraph_t}, Ptr{igraph_matrix_t}, Ptr{igraph_sparsemat_t}, igraph_bool_t, Ptr{igraph_vector_t}), graph, res, sparseres, normalized, weights)
end

function igraph_transitivity_undirected(graph, res, mode)
    ccall((:igraph_transitivity_undirected, libigraph), igraph_error_t, (Ptr{igraph_t}, Ptr{igraph_real_t}, igraph_transitivity_mode_t), graph, res, mode)
end

function igraph_transitivity_local_undirected(graph, res, vids, mode)
    ccall((:igraph_transitivity_local_undirected, libigraph), igraph_error_t, (Ptr{igraph_t}, Ptr{igraph_vector_t}, igraph_vs_t, igraph_transitivity_mode_t), graph, res, vids, mode)
end

function igraph_transitivity_avglocal_undirected(graph, res, mode)
    ccall((:igraph_transitivity_avglocal_undirected, libigraph), igraph_error_t, (Ptr{igraph_t}, Ptr{igraph_real_t}, igraph_transitivity_mode_t), graph, res, mode)
end

function igraph_transitivity_barrat(graph, res, vids, weights, mode)
    ccall((:igraph_transitivity_barrat, libigraph), igraph_error_t, (Ptr{igraph_t}, Ptr{igraph_vector_t}, igraph_vs_t, Ptr{igraph_vector_t}, igraph_transitivity_mode_t), graph, res, vids, weights, mode)
end

function igraph_ecc(graph, res, eids, k, offset, normalize)
    ccall((:igraph_ecc, libigraph), igraph_error_t, (Ptr{igraph_t}, Ptr{igraph_vector_t}, igraph_es_t, igraph_integer_t, igraph_bool_t, igraph_bool_t), graph, res, eids, k, offset, normalize)
end

function igraph_neighborhood_size(graph, res, vids, order, mode, mindist)
    ccall((:igraph_neighborhood_size, libigraph), igraph_error_t, (Ptr{igraph_t}, Ptr{igraph_vector_int_t}, igraph_vs_t, igraph_integer_t, igraph_neimode_t, igraph_integer_t), graph, res, vids, order, mode, mindist)
end

function igraph_neighborhood(graph, res, vids, order, mode, mindist)
    ccall((:igraph_neighborhood, libigraph), igraph_error_t, (Ptr{igraph_t}, Ptr{igraph_vector_int_list_t}, igraph_vs_t, igraph_integer_t, igraph_neimode_t, igraph_integer_t), graph, res, vids, order, mode, mindist)
end

function igraph_neighborhood_graphs(graph, res, vids, order, mode, mindist)
    ccall((:igraph_neighborhood_graphs, libigraph), igraph_error_t, (Ptr{igraph_t}, Ptr{igraph_graph_list_t}, igraph_vs_t, igraph_integer_t, igraph_neimode_t, igraph_integer_t), graph, res, vids, order, mode, mindist)
end

function igraph_topological_sorting(graph, res, mode)
    ccall((:igraph_topological_sorting, libigraph), igraph_error_t, (Ptr{igraph_t}, Ptr{igraph_vector_int_t}, igraph_neimode_t), graph, res, mode)
end

function igraph_is_dag(graph, res)
    ccall((:igraph_is_dag, libigraph), igraph_error_t, (Ptr{igraph_t}, Ptr{igraph_bool_t}), graph, res)
end

function igraph_transitive_closure_dag(graph, closure)
    ccall((:igraph_transitive_closure_dag, libigraph), igraph_error_t, (Ptr{igraph_t}, Ptr{igraph_t}), graph, closure)
end

function igraph_simplify_and_colorize(graph, res, vertex_color, edge_color)
    ccall((:igraph_simplify_and_colorize, libigraph), igraph_error_t, (Ptr{igraph_t}, Ptr{igraph_t}, Ptr{igraph_vector_int_t}, Ptr{igraph_vector_int_t}), graph, res, vertex_color, edge_color)
end

function igraph_isomorphic(graph1, graph2, iso)
    ccall((:igraph_isomorphic, libigraph), igraph_error_t, (Ptr{igraph_t}, Ptr{igraph_t}, Ptr{igraph_bool_t}), graph1, graph2, iso)
end

function igraph_subisomorphic(graph1, graph2, iso)
    ccall((:igraph_subisomorphic, libigraph), igraph_error_t, (Ptr{igraph_t}, Ptr{igraph_t}, Ptr{igraph_bool_t}), graph1, graph2, iso)
end

function igraph_subisomorphic_lad(pattern, target, domains, iso, map, maps, induced, time_limit)
    ccall((:igraph_subisomorphic_lad, libigraph), igraph_error_t, (Ptr{igraph_t}, Ptr{igraph_t}, Ptr{igraph_vector_int_list_t}, Ptr{igraph_bool_t}, Ptr{igraph_vector_int_t}, Ptr{igraph_vector_int_list_t}, igraph_bool_t, igraph_integer_t), pattern, target, domains, iso, map, maps, induced, time_limit)
end

# typedef igraph_error_t igraph_isohandler_t ( const igraph_vector_int_t * map12 , const igraph_vector_int_t * map21 , void * arg )
const igraph_isohandler_t = Cvoid

# typedef igraph_bool_t igraph_isocompat_t ( const igraph_t * graph1 , const igraph_t * graph2 , const igraph_integer_t g1_num , const igraph_integer_t g2_num , void * arg )
const igraph_isocompat_t = Cvoid

function igraph_isomorphic_vf2(graph1, graph2, vertex_color1, vertex_color2, edge_color1, edge_color2, iso, map12, map21, node_compat_fn, edge_compat_fn, arg)
    ccall((:igraph_isomorphic_vf2, libigraph), igraph_error_t, (Ptr{igraph_t}, Ptr{igraph_t}, Ptr{igraph_vector_int_t}, Ptr{igraph_vector_int_t}, Ptr{igraph_vector_int_t}, Ptr{igraph_vector_int_t}, Ptr{igraph_bool_t}, Ptr{igraph_vector_int_t}, Ptr{igraph_vector_int_t}, Ptr{igraph_isocompat_t}, Ptr{igraph_isocompat_t}, Ptr{Cvoid}), graph1, graph2, vertex_color1, vertex_color2, edge_color1, edge_color2, iso, map12, map21, node_compat_fn, edge_compat_fn, arg)
end

function igraph_count_isomorphisms_vf2(graph1, graph2, vertex_color1, vertex_color2, edge_color1, edge_color2, count, node_compat_fn, edge_compat_fn, arg)
    ccall((:igraph_count_isomorphisms_vf2, libigraph), igraph_error_t, (Ptr{igraph_t}, Ptr{igraph_t}, Ptr{igraph_vector_int_t}, Ptr{igraph_vector_int_t}, Ptr{igraph_vector_int_t}, Ptr{igraph_vector_int_t}, Ptr{igraph_integer_t}, Ptr{igraph_isocompat_t}, Ptr{igraph_isocompat_t}, Ptr{Cvoid}), graph1, graph2, vertex_color1, vertex_color2, edge_color1, edge_color2, count, node_compat_fn, edge_compat_fn, arg)
end

function igraph_get_isomorphisms_vf2(graph1, graph2, vertex_color1, vertex_color2, edge_color1, edge_color2, maps, node_compat_fn, edge_compat_fn, arg)
    ccall((:igraph_get_isomorphisms_vf2, libigraph), igraph_error_t, (Ptr{igraph_t}, Ptr{igraph_t}, Ptr{igraph_vector_int_t}, Ptr{igraph_vector_int_t}, Ptr{igraph_vector_int_t}, Ptr{igraph_vector_int_t}, Ptr{igraph_vector_int_list_t}, Ptr{igraph_isocompat_t}, Ptr{igraph_isocompat_t}, Ptr{Cvoid}), graph1, graph2, vertex_color1, vertex_color2, edge_color1, edge_color2, maps, node_compat_fn, edge_compat_fn, arg)
end

function igraph_get_isomorphisms_vf2_callback(graph1, graph2, vertex_color1, vertex_color2, edge_color1, edge_color2, map12, map21, isohandler_fn, node_compat_fn, edge_compat_fn, arg)
    ccall((:igraph_get_isomorphisms_vf2_callback, libigraph), igraph_error_t, (Ptr{igraph_t}, Ptr{igraph_t}, Ptr{igraph_vector_int_t}, Ptr{igraph_vector_int_t}, Ptr{igraph_vector_int_t}, Ptr{igraph_vector_int_t}, Ptr{igraph_vector_int_t}, Ptr{igraph_vector_int_t}, Ptr{igraph_isohandler_t}, Ptr{igraph_isocompat_t}, Ptr{igraph_isocompat_t}, Ptr{Cvoid}), graph1, graph2, vertex_color1, vertex_color2, edge_color1, edge_color2, map12, map21, isohandler_fn, node_compat_fn, edge_compat_fn, arg)
end

function igraph_isomorphic_function_vf2(graph1, graph2, vertex_color1, vertex_color2, edge_color1, edge_color2, map12, map21, isohandler_fn, node_compat_fn, edge_compat_fn, arg)
    ccall((:igraph_isomorphic_function_vf2, libigraph), igraph_error_t, (Ptr{igraph_t}, Ptr{igraph_t}, Ptr{igraph_vector_int_t}, Ptr{igraph_vector_int_t}, Ptr{igraph_vector_int_t}, Ptr{igraph_vector_int_t}, Ptr{igraph_vector_int_t}, Ptr{igraph_vector_int_t}, Ptr{igraph_isohandler_t}, Ptr{igraph_isocompat_t}, Ptr{igraph_isocompat_t}, Ptr{Cvoid}), graph1, graph2, vertex_color1, vertex_color2, edge_color1, edge_color2, map12, map21, isohandler_fn, node_compat_fn, edge_compat_fn, arg)
end

function igraph_subisomorphic_vf2(graph1, graph2, vertex_color1, vertex_color2, edge_color1, edge_color2, iso, map12, map21, node_compat_fn, edge_compat_fn, arg)
    ccall((:igraph_subisomorphic_vf2, libigraph), igraph_error_t, (Ptr{igraph_t}, Ptr{igraph_t}, Ptr{igraph_vector_int_t}, Ptr{igraph_vector_int_t}, Ptr{igraph_vector_int_t}, Ptr{igraph_vector_int_t}, Ptr{igraph_bool_t}, Ptr{igraph_vector_int_t}, Ptr{igraph_vector_int_t}, Ptr{igraph_isocompat_t}, Ptr{igraph_isocompat_t}, Ptr{Cvoid}), graph1, graph2, vertex_color1, vertex_color2, edge_color1, edge_color2, iso, map12, map21, node_compat_fn, edge_compat_fn, arg)
end

function igraph_count_subisomorphisms_vf2(graph1, graph2, vertex_color1, vertex_color2, edge_color1, edge_color2, count, node_compat_fn, edge_compat_fn, arg)
    ccall((:igraph_count_subisomorphisms_vf2, libigraph), igraph_error_t, (Ptr{igraph_t}, Ptr{igraph_t}, Ptr{igraph_vector_int_t}, Ptr{igraph_vector_int_t}, Ptr{igraph_vector_int_t}, Ptr{igraph_vector_int_t}, Ptr{igraph_integer_t}, Ptr{igraph_isocompat_t}, Ptr{igraph_isocompat_t}, Ptr{Cvoid}), graph1, graph2, vertex_color1, vertex_color2, edge_color1, edge_color2, count, node_compat_fn, edge_compat_fn, arg)
end

function igraph_get_subisomorphisms_vf2(graph1, graph2, vertex_color1, vertex_color2, edge_color1, edge_color2, maps, node_compat_fn, edge_compat_fn, arg)
    ccall((:igraph_get_subisomorphisms_vf2, libigraph), igraph_error_t, (Ptr{igraph_t}, Ptr{igraph_t}, Ptr{igraph_vector_int_t}, Ptr{igraph_vector_int_t}, Ptr{igraph_vector_int_t}, Ptr{igraph_vector_int_t}, Ptr{igraph_vector_int_list_t}, Ptr{igraph_isocompat_t}, Ptr{igraph_isocompat_t}, Ptr{Cvoid}), graph1, graph2, vertex_color1, vertex_color2, edge_color1, edge_color2, maps, node_compat_fn, edge_compat_fn, arg)
end

function igraph_get_subisomorphisms_vf2_callback(graph1, graph2, vertex_color1, vertex_color2, edge_color1, edge_color2, map12, map21, isohandler_fn, node_compat_fn, edge_compat_fn, arg)
    ccall((:igraph_get_subisomorphisms_vf2_callback, libigraph), igraph_error_t, (Ptr{igraph_t}, Ptr{igraph_t}, Ptr{igraph_vector_int_t}, Ptr{igraph_vector_int_t}, Ptr{igraph_vector_int_t}, Ptr{igraph_vector_int_t}, Ptr{igraph_vector_int_t}, Ptr{igraph_vector_int_t}, Ptr{igraph_isohandler_t}, Ptr{igraph_isocompat_t}, Ptr{igraph_isocompat_t}, Ptr{Cvoid}), graph1, graph2, vertex_color1, vertex_color2, edge_color1, edge_color2, map12, map21, isohandler_fn, node_compat_fn, edge_compat_fn, arg)
end

function igraph_subisomorphic_function_vf2(graph1, graph2, vertex_color1, vertex_color2, edge_color1, edge_color2, map12, map21, isohandler_fn, node_compat_fn, edge_compat_fn, arg)
    ccall((:igraph_subisomorphic_function_vf2, libigraph), igraph_error_t, (Ptr{igraph_t}, Ptr{igraph_t}, Ptr{igraph_vector_int_t}, Ptr{igraph_vector_int_t}, Ptr{igraph_vector_int_t}, Ptr{igraph_vector_int_t}, Ptr{igraph_vector_int_t}, Ptr{igraph_vector_int_t}, Ptr{igraph_isohandler_t}, Ptr{igraph_isocompat_t}, Ptr{igraph_isocompat_t}, Ptr{Cvoid}), graph1, graph2, vertex_color1, vertex_color2, edge_color1, edge_color2, map12, map21, isohandler_fn, node_compat_fn, edge_compat_fn, arg)
end

mutable struct igraph_bliss_info_t
    nof_nodes::Culong
    nof_leaf_nodes::Culong
    nof_bad_nodes::Culong
    nof_canupdates::Culong
    nof_generators::Culong
    max_level::Culong
    group_size::Ptr{Cchar}
    igraph_bliss_info_t() = new()
end

@cenum igraph_bliss_sh_t::UInt32 begin
    IGRAPH_BLISS_F = 0
    IGRAPH_BLISS_FL = 1
    IGRAPH_BLISS_FS = 2
    IGRAPH_BLISS_FM = 3
    IGRAPH_BLISS_FLM = 4
    IGRAPH_BLISS_FSM = 5
end

function igraph_canonical_permutation(graph, colors, labeling, sh, info)
    ccall((:igraph_canonical_permutation, libigraph), igraph_error_t, (Ptr{igraph_t}, Ptr{igraph_vector_int_t}, Ptr{igraph_vector_int_t}, igraph_bliss_sh_t, Ptr{igraph_bliss_info_t}), graph, colors, labeling, sh, info)
end

function igraph_isomorphic_bliss(graph1, graph2, colors1, colors2, iso, map12, map21, sh, info1, info2)
    ccall((:igraph_isomorphic_bliss, libigraph), igraph_error_t, (Ptr{igraph_t}, Ptr{igraph_t}, Ptr{igraph_vector_int_t}, Ptr{igraph_vector_int_t}, Ptr{igraph_bool_t}, Ptr{igraph_vector_int_t}, Ptr{igraph_vector_int_t}, igraph_bliss_sh_t, Ptr{igraph_bliss_info_t}, Ptr{igraph_bliss_info_t}), graph1, graph2, colors1, colors2, iso, map12, map21, sh, info1, info2)
end

function igraph_count_automorphisms(graph, colors, sh, info)
    ccall((:igraph_count_automorphisms, libigraph), igraph_error_t, (Ptr{igraph_t}, Ptr{igraph_vector_int_t}, igraph_bliss_sh_t, Ptr{igraph_bliss_info_t}), graph, colors, sh, info)
end

function igraph_automorphisms(graph, colors, sh, info)
    ccall((:igraph_automorphisms, libigraph), igraph_error_t, (Ptr{igraph_t}, Ptr{igraph_vector_int_t}, igraph_bliss_sh_t, Ptr{igraph_bliss_info_t}), graph, colors, sh, info)
end

function igraph_automorphism_group(graph, colors, generators, sh, info)
    ccall((:igraph_automorphism_group, libigraph), igraph_error_t, (Ptr{igraph_t}, Ptr{igraph_vector_int_t}, Ptr{igraph_vector_int_list_t}, igraph_bliss_sh_t, Ptr{igraph_bliss_info_t}), graph, colors, generators, sh, info)
end

function igraph_isoclass(graph, isoclass)
    ccall((:igraph_isoclass, libigraph), igraph_error_t, (Ptr{igraph_t}, Ptr{igraph_integer_t}), graph, isoclass)
end

function igraph_isoclass_subgraph(graph, vids, isoclass)
    ccall((:igraph_isoclass_subgraph, libigraph), igraph_error_t, (Ptr{igraph_t}, Ptr{igraph_vector_int_t}, Ptr{igraph_integer_t}), graph, vids, isoclass)
end

function igraph_isoclass_create(graph, size, number, directed)
    ccall((:igraph_isoclass_create, libigraph), igraph_error_t, (Ptr{igraph_t}, igraph_integer_t, igraph_integer_t, igraph_bool_t), graph, size, number, directed)
end

function igraph_graph_count(n, directed, count)
    ccall((:igraph_graph_count, libigraph), igraph_error_t, (igraph_integer_t, igraph_bool_t, Ptr{igraph_integer_t}), n, directed, count)
end

function igraph_isomorphic_34(graph1, graph2, iso)
    ccall((:igraph_isomorphic_34, libigraph), igraph_error_t, (Ptr{igraph_t}, Ptr{igraph_t}, Ptr{igraph_bool_t}), graph1, graph2, iso)
end

function igraph_full_bipartite(graph, types, n1, n2, directed, mode)
    ccall((:igraph_full_bipartite, libigraph), igraph_error_t, (Ptr{igraph_t}, Ptr{igraph_vector_bool_t}, igraph_integer_t, igraph_integer_t, igraph_bool_t, igraph_neimode_t), graph, types, n1, n2, directed, mode)
end

function igraph_create_bipartite(g, types, edges, directed)
    ccall((:igraph_create_bipartite, libigraph), igraph_error_t, (Ptr{igraph_t}, Ptr{igraph_vector_bool_t}, Ptr{igraph_vector_int_t}, igraph_bool_t), g, types, edges, directed)
end

function igraph_bipartite_projection_size(graph, types, vcount1, ecount1, vcount2, ecount2)
    ccall((:igraph_bipartite_projection_size, libigraph), igraph_error_t, (Ptr{igraph_t}, Ptr{igraph_vector_bool_t}, Ptr{igraph_integer_t}, Ptr{igraph_integer_t}, Ptr{igraph_integer_t}, Ptr{igraph_integer_t}), graph, types, vcount1, ecount1, vcount2, ecount2)
end

function igraph_bipartite_projection(graph, types, proj1, proj2, multiplicity1, multiplicity2, probe1)
    ccall((:igraph_bipartite_projection, libigraph), igraph_error_t, (Ptr{igraph_t}, Ptr{igraph_vector_bool_t}, Ptr{igraph_t}, Ptr{igraph_t}, Ptr{igraph_vector_int_t}, Ptr{igraph_vector_int_t}, igraph_integer_t), graph, types, proj1, proj2, multiplicity1, multiplicity2, probe1)
end

function igraph_biadjacency(graph, types, input, directed, mode, multiple)
    ccall((:igraph_biadjacency, libigraph), igraph_error_t, (Ptr{igraph_t}, Ptr{igraph_vector_bool_t}, Ptr{igraph_matrix_t}, igraph_bool_t, igraph_neimode_t, igraph_bool_t), graph, types, input, directed, mode, multiple)
end

function igraph_get_biadjacency(graph, types, res, row_ids, col_ids)
    ccall((:igraph_get_biadjacency, libigraph), igraph_error_t, (Ptr{igraph_t}, Ptr{igraph_vector_bool_t}, Ptr{igraph_matrix_t}, Ptr{igraph_vector_int_t}, Ptr{igraph_vector_int_t}), graph, types, res, row_ids, col_ids)
end

function igraph_is_bipartite(graph, res, types)
    ccall((:igraph_is_bipartite, libigraph), igraph_error_t, (Ptr{igraph_t}, Ptr{igraph_bool_t}, Ptr{igraph_vector_bool_t}), graph, res, types)
end

function igraph_bipartite_game_gnp(graph, types, n1, n2, p, directed, mode)
    ccall((:igraph_bipartite_game_gnp, libigraph), igraph_error_t, (Ptr{igraph_t}, Ptr{igraph_vector_bool_t}, igraph_integer_t, igraph_integer_t, igraph_real_t, igraph_bool_t, igraph_neimode_t), graph, types, n1, n2, p, directed, mode)
end

function igraph_bipartite_game_gnm(graph, types, n1, n2, m, directed, mode)
    ccall((:igraph_bipartite_game_gnm, libigraph), igraph_error_t, (Ptr{igraph_t}, Ptr{igraph_vector_bool_t}, igraph_integer_t, igraph_integer_t, igraph_integer_t, igraph_bool_t, igraph_neimode_t), graph, types, n1, n2, m, directed, mode)
end

function igraph_incidence(graph, types, incidence, directed, mode, multiple)
    ccall((:igraph_incidence, libigraph), igraph_error_t, (Ptr{igraph_t}, Ptr{igraph_vector_bool_t}, Ptr{igraph_matrix_t}, igraph_bool_t, igraph_neimode_t, igraph_bool_t), graph, types, incidence, directed, mode, multiple)
end

function igraph_get_incidence(graph, types, res, row_ids, col_ids)
    ccall((:igraph_get_incidence, libigraph), igraph_error_t, (Ptr{igraph_t}, Ptr{igraph_vector_bool_t}, Ptr{igraph_matrix_t}, Ptr{igraph_vector_int_t}, Ptr{igraph_vector_int_t}), graph, types, res, row_ids, col_ids)
end

function igraph_bipartite_game(graph, types, type, n1, n2, p, m, directed, mode)
    ccall((:igraph_bipartite_game, libigraph), igraph_error_t, (Ptr{igraph_t}, Ptr{igraph_vector_bool_t}, igraph_erdos_renyi_t, igraph_integer_t, igraph_integer_t, igraph_real_t, igraph_integer_t, igraph_bool_t, igraph_neimode_t), graph, types, type, n1, n2, p, m, directed, mode)
end

function igraph_maximal_cliques(graph, res, min_size, max_size)
    ccall((:igraph_maximal_cliques, libigraph), igraph_error_t, (Ptr{igraph_t}, Ptr{igraph_vector_int_list_t}, igraph_integer_t, igraph_integer_t), graph, res, min_size, max_size)
end

function igraph_maximal_cliques_file(graph, outfile, min_size, max_size)
    ccall((:igraph_maximal_cliques_file, libigraph), igraph_error_t, (Ptr{igraph_t}, Ptr{Libc.FILE}, igraph_integer_t, igraph_integer_t), graph, outfile, min_size, max_size)
end

function igraph_maximal_cliques_count(graph, res, min_size, max_size)
    ccall((:igraph_maximal_cliques_count, libigraph), igraph_error_t, (Ptr{igraph_t}, Ptr{igraph_integer_t}, igraph_integer_t, igraph_integer_t), graph, res, min_size, max_size)
end

function igraph_maximal_cliques_subset(graph, subset, res, no, outfile, min_size, max_size)
    ccall((:igraph_maximal_cliques_subset, libigraph), igraph_error_t, (Ptr{igraph_t}, Ptr{igraph_vector_int_t}, Ptr{igraph_vector_int_list_t}, Ptr{igraph_integer_t}, Ptr{Libc.FILE}, igraph_integer_t, igraph_integer_t), graph, subset, res, no, outfile, min_size, max_size)
end

function igraph_maximal_cliques_hist(graph, hist, min_size, max_size)
    ccall((:igraph_maximal_cliques_hist, libigraph), igraph_error_t, (Ptr{igraph_t}, Ptr{igraph_vector_t}, igraph_integer_t, igraph_integer_t), graph, hist, min_size, max_size)
end

function igraph_cliques(graph, res, min_size, max_size)
    ccall((:igraph_cliques, libigraph), igraph_error_t, (Ptr{igraph_t}, Ptr{igraph_vector_int_list_t}, igraph_integer_t, igraph_integer_t), graph, res, min_size, max_size)
end

function igraph_clique_size_hist(graph, hist, min_size, max_size)
    ccall((:igraph_clique_size_hist, libigraph), igraph_error_t, (Ptr{igraph_t}, Ptr{igraph_vector_t}, igraph_integer_t, igraph_integer_t), graph, hist, min_size, max_size)
end

function igraph_largest_cliques(graph, cliques)
    ccall((:igraph_largest_cliques, libigraph), igraph_error_t, (Ptr{igraph_t}, Ptr{igraph_vector_int_list_t}), graph, cliques)
end

function igraph_clique_number(graph, no)
    ccall((:igraph_clique_number, libigraph), igraph_error_t, (Ptr{igraph_t}, Ptr{igraph_integer_t}), graph, no)
end

function igraph_weighted_cliques(graph, vertex_weights, res, min_weight, max_weight, maximal)
    ccall((:igraph_weighted_cliques, libigraph), igraph_error_t, (Ptr{igraph_t}, Ptr{igraph_vector_t}, Ptr{igraph_vector_int_list_t}, igraph_real_t, igraph_real_t, igraph_bool_t), graph, vertex_weights, res, min_weight, max_weight, maximal)
end

function igraph_largest_weighted_cliques(graph, vertex_weights, res)
    ccall((:igraph_largest_weighted_cliques, libigraph), igraph_error_t, (Ptr{igraph_t}, Ptr{igraph_vector_t}, Ptr{igraph_vector_int_list_t}), graph, vertex_weights, res)
end

function igraph_weighted_clique_number(graph, vertex_weights, res)
    ccall((:igraph_weighted_clique_number, libigraph), igraph_error_t, (Ptr{igraph_t}, Ptr{igraph_vector_t}, Ptr{igraph_real_t}), graph, vertex_weights, res)
end

function igraph_independent_vertex_sets(graph, res, min_size, max_size)
    ccall((:igraph_independent_vertex_sets, libigraph), igraph_error_t, (Ptr{igraph_t}, Ptr{igraph_vector_int_list_t}, igraph_integer_t, igraph_integer_t), graph, res, min_size, max_size)
end

function igraph_largest_independent_vertex_sets(graph, res)
    ccall((:igraph_largest_independent_vertex_sets, libigraph), igraph_error_t, (Ptr{igraph_t}, Ptr{igraph_vector_int_list_t}), graph, res)
end

function igraph_maximal_independent_vertex_sets(graph, res)
    ccall((:igraph_maximal_independent_vertex_sets, libigraph), igraph_error_t, (Ptr{igraph_t}, Ptr{igraph_vector_int_list_t}), graph, res)
end

function igraph_independence_number(graph, no)
    ccall((:igraph_independence_number, libigraph), igraph_error_t, (Ptr{igraph_t}, Ptr{igraph_integer_t}), graph, no)
end

# typedef igraph_error_t igraph_clique_handler_t ( const igraph_vector_int_t * clique , void * arg )
const igraph_clique_handler_t = Cvoid

function igraph_cliques_callback(graph, min_size, max_size, cliquehandler_fn, arg)
    ccall((:igraph_cliques_callback, libigraph), igraph_error_t, (Ptr{igraph_t}, igraph_integer_t, igraph_integer_t, Ptr{igraph_clique_handler_t}, Ptr{Cvoid}), graph, min_size, max_size, cliquehandler_fn, arg)
end

function igraph_maximal_cliques_callback(graph, cliquehandler_fn, arg, min_size, max_size)
    ccall((:igraph_maximal_cliques_callback, libigraph), igraph_error_t, (Ptr{igraph_t}, Ptr{igraph_clique_handler_t}, Ptr{Cvoid}, igraph_integer_t, igraph_integer_t), graph, cliquehandler_fn, arg, min_size, max_size)
end

function igraph_layout_random(graph, res)
    ccall((:igraph_layout_random, libigraph), igraph_error_t, (Ptr{igraph_t}, Ptr{igraph_matrix_t}), graph, res)
end

function igraph_layout_circle(graph, res, order)
    ccall((:igraph_layout_circle, libigraph), igraph_error_t, (Ptr{igraph_t}, Ptr{igraph_matrix_t}, igraph_vs_t), graph, res, order)
end

function igraph_layout_star(graph, res, center, order)
    ccall((:igraph_layout_star, libigraph), igraph_error_t, (Ptr{igraph_t}, Ptr{igraph_matrix_t}, igraph_integer_t, Ptr{igraph_vector_int_t}), graph, res, center, order)
end

function igraph_layout_grid(graph, res, width)
    ccall((:igraph_layout_grid, libigraph), igraph_error_t, (Ptr{igraph_t}, Ptr{igraph_matrix_t}, igraph_integer_t), graph, res, width)
end

function igraph_layout_fruchterman_reingold(graph, res, use_seed, niter, start_temp, grid, weights, minx, maxx, miny, maxy)
    ccall((:igraph_layout_fruchterman_reingold, libigraph), igraph_error_t, (Ptr{igraph_t}, Ptr{igraph_matrix_t}, igraph_bool_t, igraph_integer_t, igraph_real_t, igraph_layout_grid_t, Ptr{igraph_vector_t}, Ptr{igraph_vector_t}, Ptr{igraph_vector_t}, Ptr{igraph_vector_t}, Ptr{igraph_vector_t}), graph, res, use_seed, niter, start_temp, grid, weights, minx, maxx, miny, maxy)
end

function igraph_layout_kamada_kawai(graph, res, use_seed, maxiter, epsilon, kkconst, weights, minx, maxx, miny, maxy)
    ccall((:igraph_layout_kamada_kawai, libigraph), igraph_error_t, (Ptr{igraph_t}, Ptr{igraph_matrix_t}, igraph_bool_t, igraph_integer_t, igraph_real_t, igraph_real_t, Ptr{igraph_vector_t}, Ptr{igraph_vector_t}, Ptr{igraph_vector_t}, Ptr{igraph_vector_t}, Ptr{igraph_vector_t}), graph, res, use_seed, maxiter, epsilon, kkconst, weights, minx, maxx, miny, maxy)
end

function igraph_layout_lgl(graph, res, maxiter, maxdelta, area, coolexp, repulserad, cellsize, root)
    ccall((:igraph_layout_lgl, libigraph), igraph_error_t, (Ptr{igraph_t}, Ptr{igraph_matrix_t}, igraph_integer_t, igraph_real_t, igraph_real_t, igraph_real_t, igraph_real_t, igraph_real_t, igraph_integer_t), graph, res, maxiter, maxdelta, area, coolexp, repulserad, cellsize, root)
end

function igraph_layout_reingold_tilford(graph, res, mode, roots, rootlevel)
    ccall((:igraph_layout_reingold_tilford, libigraph), igraph_error_t, (Ptr{igraph_t}, Ptr{igraph_matrix_t}, igraph_neimode_t, Ptr{igraph_vector_int_t}, Ptr{igraph_vector_int_t}), graph, res, mode, roots, rootlevel)
end

function igraph_layout_reingold_tilford_circular(graph, res, mode, roots, rootlevel)
    ccall((:igraph_layout_reingold_tilford_circular, libigraph), igraph_error_t, (Ptr{igraph_t}, Ptr{igraph_matrix_t}, igraph_neimode_t, Ptr{igraph_vector_int_t}, Ptr{igraph_vector_int_t}), graph, res, mode, roots, rootlevel)
end

function igraph_layout_sugiyama(graph, res, extd_graph, extd_to_orig_eids, layers, hgap, vgap, maxiter, weights)
    ccall((:igraph_layout_sugiyama, libigraph), igraph_error_t, (Ptr{igraph_t}, Ptr{igraph_matrix_t}, Ptr{igraph_t}, Ptr{igraph_vector_int_t}, Ptr{igraph_vector_int_t}, igraph_real_t, igraph_real_t, igraph_integer_t, Ptr{igraph_vector_t}), graph, res, extd_graph, extd_to_orig_eids, layers, hgap, vgap, maxiter, weights)
end

function igraph_layout_random_3d(graph, res)
    ccall((:igraph_layout_random_3d, libigraph), igraph_error_t, (Ptr{igraph_t}, Ptr{igraph_matrix_t}), graph, res)
end

function igraph_layout_sphere(graph, res)
    ccall((:igraph_layout_sphere, libigraph), igraph_error_t, (Ptr{igraph_t}, Ptr{igraph_matrix_t}), graph, res)
end

function igraph_layout_grid_3d(graph, res, width, height)
    ccall((:igraph_layout_grid_3d, libigraph), igraph_error_t, (Ptr{igraph_t}, Ptr{igraph_matrix_t}, igraph_integer_t, igraph_integer_t), graph, res, width, height)
end

function igraph_layout_fruchterman_reingold_3d(graph, res, use_seed, niter, start_temp, weights, minx, maxx, miny, maxy, minz, maxz)
    ccall((:igraph_layout_fruchterman_reingold_3d, libigraph), igraph_error_t, (Ptr{igraph_t}, Ptr{igraph_matrix_t}, igraph_bool_t, igraph_integer_t, igraph_real_t, Ptr{igraph_vector_t}, Ptr{igraph_vector_t}, Ptr{igraph_vector_t}, Ptr{igraph_vector_t}, Ptr{igraph_vector_t}, Ptr{igraph_vector_t}, Ptr{igraph_vector_t}), graph, res, use_seed, niter, start_temp, weights, minx, maxx, miny, maxy, minz, maxz)
end

function igraph_layout_kamada_kawai_3d(graph, res, use_seed, maxiter, epsilon, kkconst, weights, minx, maxx, miny, maxy, minz, maxz)
    ccall((:igraph_layout_kamada_kawai_3d, libigraph), igraph_error_t, (Ptr{igraph_t}, Ptr{igraph_matrix_t}, igraph_bool_t, igraph_integer_t, igraph_real_t, igraph_real_t, Ptr{igraph_vector_t}, Ptr{igraph_vector_t}, Ptr{igraph_vector_t}, Ptr{igraph_vector_t}, Ptr{igraph_vector_t}, Ptr{igraph_vector_t}, Ptr{igraph_vector_t}), graph, res, use_seed, maxiter, epsilon, kkconst, weights, minx, maxx, miny, maxy, minz, maxz)
end

function igraph_layout_graphopt(graph, res, niter, node_charge, node_mass, spring_length, spring_constant, max_sa_movement, use_seed)
    ccall((:igraph_layout_graphopt, libigraph), igraph_error_t, (Ptr{igraph_t}, Ptr{igraph_matrix_t}, igraph_integer_t, igraph_real_t, igraph_real_t, igraph_real_t, igraph_real_t, igraph_real_t, igraph_bool_t), graph, res, niter, node_charge, node_mass, spring_length, spring_constant, max_sa_movement, use_seed)
end

function igraph_layout_mds(graph, res, dist, dim)
    ccall((:igraph_layout_mds, libigraph), igraph_error_t, (Ptr{igraph_t}, Ptr{igraph_matrix_t}, Ptr{igraph_matrix_t}, igraph_integer_t), graph, res, dist, dim)
end

function igraph_layout_bipartite(graph, types, res, hgap, vgap, maxiter)
    ccall((:igraph_layout_bipartite, libigraph), igraph_error_t, (Ptr{igraph_t}, Ptr{igraph_vector_bool_t}, Ptr{igraph_matrix_t}, igraph_real_t, igraph_real_t, igraph_integer_t), graph, types, res, hgap, vgap, maxiter)
end

function igraph_layout_umap(graph, res, use_seed, distances, min_dist, epochs, distances_are_weights)
    ccall((:igraph_layout_umap, libigraph), igraph_error_t, (Ptr{igraph_t}, Ptr{igraph_matrix_t}, igraph_bool_t, Ptr{igraph_vector_t}, igraph_real_t, igraph_integer_t, igraph_bool_t), graph, res, use_seed, distances, min_dist, epochs, distances_are_weights)
end

function igraph_layout_umap_3d(graph, res, use_seed, distances, min_dist, epochs, distances_are_weights)
    ccall((:igraph_layout_umap_3d, libigraph), igraph_error_t, (Ptr{igraph_t}, Ptr{igraph_matrix_t}, igraph_bool_t, Ptr{igraph_vector_t}, igraph_real_t, igraph_integer_t, igraph_bool_t), graph, res, use_seed, distances, min_dist, epochs, distances_are_weights)
end

function igraph_layout_umap_compute_weights(graph, distances, weights)
    ccall((:igraph_layout_umap_compute_weights, libigraph), igraph_error_t, (Ptr{igraph_t}, Ptr{igraph_vector_t}, Ptr{igraph_vector_t}), graph, distances, weights)
end

mutable struct igraph_layout_drl_options_t
    edge_cut::igraph_real_t
    init_iterations::igraph_integer_t
    init_temperature::igraph_real_t
    init_attraction::igraph_real_t
    init_damping_mult::igraph_real_t
    liquid_iterations::igraph_integer_t
    liquid_temperature::igraph_real_t
    liquid_attraction::igraph_real_t
    liquid_damping_mult::igraph_real_t
    expansion_iterations::igraph_integer_t
    expansion_temperature::igraph_real_t
    expansion_attraction::igraph_real_t
    expansion_damping_mult::igraph_real_t
    cooldown_iterations::igraph_integer_t
    cooldown_temperature::igraph_real_t
    cooldown_attraction::igraph_real_t
    cooldown_damping_mult::igraph_real_t
    crunch_iterations::igraph_integer_t
    crunch_temperature::igraph_real_t
    crunch_attraction::igraph_real_t
    crunch_damping_mult::igraph_real_t
    simmer_iterations::igraph_integer_t
    simmer_temperature::igraph_real_t
    simmer_attraction::igraph_real_t
    simmer_damping_mult::igraph_real_t
    igraph_layout_drl_options_t() = new()
end

@cenum igraph_layout_drl_default_t::UInt32 begin
    IGRAPH_LAYOUT_DRL_DEFAULT = 0
    IGRAPH_LAYOUT_DRL_COARSEN = 1
    IGRAPH_LAYOUT_DRL_COARSEST = 2
    IGRAPH_LAYOUT_DRL_REFINE = 3
    IGRAPH_LAYOUT_DRL_FINAL = 4
end

function igraph_layout_drl_options_init(options, templ)
    ccall((:igraph_layout_drl_options_init, libigraph), igraph_error_t, (Ptr{igraph_layout_drl_options_t}, igraph_layout_drl_default_t), options, templ)
end

function igraph_layout_drl(graph, res, use_seed, options, weights)
    ccall((:igraph_layout_drl, libigraph), igraph_error_t, (Ptr{igraph_t}, Ptr{igraph_matrix_t}, igraph_bool_t, Ptr{igraph_layout_drl_options_t}, Ptr{igraph_vector_t}), graph, res, use_seed, options, weights)
end

function igraph_layout_drl_3d(graph, res, use_seed, options, weights)
    ccall((:igraph_layout_drl_3d, libigraph), igraph_error_t, (Ptr{igraph_t}, Ptr{igraph_matrix_t}, igraph_bool_t, Ptr{igraph_layout_drl_options_t}, Ptr{igraph_vector_t}), graph, res, use_seed, options, weights)
end

function igraph_layout_merge_dla(graphs, coords, res)
    ccall((:igraph_layout_merge_dla, libigraph), igraph_error_t, (Ptr{igraph_vector_ptr_t}, Ptr{igraph_matrix_list_t}, Ptr{igraph_matrix_t}), graphs, coords, res)
end

function igraph_layout_gem(graph, res, use_seed, maxiter, temp_max, temp_min, temp_init)
    ccall((:igraph_layout_gem, libigraph), igraph_error_t, (Ptr{igraph_t}, Ptr{igraph_matrix_t}, igraph_bool_t, igraph_integer_t, igraph_real_t, igraph_real_t, igraph_real_t), graph, res, use_seed, maxiter, temp_max, temp_min, temp_init)
end

function igraph_layout_davidson_harel(graph, res, use_seed, maxiter, fineiter, cool_fact, weight_node_dist, weight_border, weight_edge_lengths, weight_edge_crossings, weight_node_edge_dist)
    ccall((:igraph_layout_davidson_harel, libigraph), igraph_error_t, (Ptr{igraph_t}, Ptr{igraph_matrix_t}, igraph_bool_t, igraph_integer_t, igraph_integer_t, igraph_real_t, igraph_real_t, igraph_real_t, igraph_real_t, igraph_real_t, igraph_real_t), graph, res, use_seed, maxiter, fineiter, cool_fact, weight_node_dist, weight_border, weight_edge_lengths, weight_edge_crossings, weight_node_edge_dist)
end

@cenum igraph_root_choice_t::UInt32 begin
    IGRAPH_ROOT_CHOICE_DEGREE = 0
    IGRAPH_ROOT_CHOICE_ECCENTRICITY = 1
end

function igraph_roots_for_tree_layout(graph, mode, roots, use_eccentricity)
    ccall((:igraph_roots_for_tree_layout, libigraph), igraph_error_t, (Ptr{igraph_t}, igraph_neimode_t, Ptr{igraph_vector_int_t}, igraph_root_choice_t), graph, mode, roots, use_eccentricity)
end

# typedef igraph_error_t igraph_bfshandler_t ( const igraph_t * graph , igraph_integer_t vid , igraph_integer_t pred , igraph_integer_t succ , igraph_integer_t rank , igraph_integer_t dist , void * extra )
const igraph_bfshandler_t = Cvoid

function igraph_bfs(graph, root, roots, mode, unreachable, restricted, order, rank, parents, pred, succ, dist, callback, extra)
    ccall((:igraph_bfs, libigraph), igraph_error_t, (Ptr{igraph_t}, igraph_integer_t, Ptr{igraph_vector_int_t}, igraph_neimode_t, igraph_bool_t, Ptr{igraph_vector_int_t}, Ptr{igraph_vector_int_t}, Ptr{igraph_vector_int_t}, Ptr{igraph_vector_int_t}, Ptr{igraph_vector_int_t}, Ptr{igraph_vector_int_t}, Ptr{igraph_vector_int_t}, Ptr{igraph_bfshandler_t}, Ptr{Cvoid}), graph, root, roots, mode, unreachable, restricted, order, rank, parents, pred, succ, dist, callback, extra)
end

function igraph_bfs_simple(graph, root, mode, order, layers, parents)
    ccall((:igraph_bfs_simple, libigraph), igraph_error_t, (Ptr{igraph_t}, igraph_integer_t, igraph_neimode_t, Ptr{igraph_vector_int_t}, Ptr{igraph_vector_int_t}, Ptr{igraph_vector_int_t}), graph, root, mode, order, layers, parents)
end

# typedef igraph_error_t igraph_dfshandler_t ( const igraph_t * graph , igraph_integer_t vid , igraph_integer_t dist , void * extra )
const igraph_dfshandler_t = Cvoid

function igraph_dfs(graph, root, mode, unreachable, order, order_out, parents, dist, in_callback, out_callback, extra)
    ccall((:igraph_dfs, libigraph), igraph_error_t, (Ptr{igraph_t}, igraph_integer_t, igraph_neimode_t, igraph_bool_t, Ptr{igraph_vector_int_t}, Ptr{igraph_vector_int_t}, Ptr{igraph_vector_int_t}, Ptr{igraph_vector_int_t}, Ptr{igraph_dfshandler_t}, Ptr{igraph_dfshandler_t}, Ptr{Cvoid}), graph, root, mode, unreachable, order, order_out, parents, dist, in_callback, out_callback, extra)
end

function igraph_coreness(graph, cores, mode)
    ccall((:igraph_coreness, libigraph), igraph_error_t, (Ptr{igraph_t}, Ptr{igraph_vector_int_t}, igraph_neimode_t), graph, cores, mode)
end

function igraph_trussness(graph, trussness)
    ccall((:igraph_trussness, libigraph), igraph_error_t, (Ptr{igraph_t}, Ptr{igraph_vector_int_t}), graph, trussness)
end

function igraph_community_optimal_modularity(graph, modularity, membership, weights)
    ccall((:igraph_community_optimal_modularity, libigraph), igraph_error_t, (Ptr{igraph_t}, Ptr{igraph_real_t}, Ptr{igraph_vector_int_t}, Ptr{igraph_vector_t}), graph, modularity, membership, weights)
end

function igraph_community_spinglass(graph, weights, modularity, temperature, membership, csize, spins, parupdate, starttemp, stoptemp, coolfact, update_rule, gamma, implementation, gamma_minus)
    ccall((:igraph_community_spinglass, libigraph), igraph_error_t, (Ptr{igraph_t}, Ptr{igraph_vector_t}, Ptr{igraph_real_t}, Ptr{igraph_real_t}, Ptr{igraph_vector_int_t}, Ptr{igraph_vector_int_t}, igraph_integer_t, igraph_bool_t, igraph_real_t, igraph_real_t, igraph_real_t, igraph_spincomm_update_t, igraph_real_t, igraph_spinglass_implementation_t, igraph_real_t), graph, weights, modularity, temperature, membership, csize, spins, parupdate, starttemp, stoptemp, coolfact, update_rule, gamma, implementation, gamma_minus)
end

function igraph_community_spinglass_single(graph, weights, vertex, community, cohesion, adhesion, inner_links, outer_links, spins, update_rule, gamma)
    ccall((:igraph_community_spinglass_single, libigraph), igraph_error_t, (Ptr{igraph_t}, Ptr{igraph_vector_t}, igraph_integer_t, Ptr{igraph_vector_int_t}, Ptr{igraph_real_t}, Ptr{igraph_real_t}, Ptr{igraph_integer_t}, Ptr{igraph_integer_t}, igraph_integer_t, igraph_spincomm_update_t, igraph_real_t), graph, weights, vertex, community, cohesion, adhesion, inner_links, outer_links, spins, update_rule, gamma)
end

function igraph_community_walktrap(graph, weights, steps, merges, modularity, membership)
    ccall((:igraph_community_walktrap, libigraph), igraph_error_t, (Ptr{igraph_t}, Ptr{igraph_vector_t}, igraph_integer_t, Ptr{igraph_matrix_int_t}, Ptr{igraph_vector_t}, Ptr{igraph_vector_int_t}), graph, weights, steps, merges, modularity, membership)
end

function igraph_community_infomap(graph, e_weights, v_weights, nb_trials, membership, codelength)
    ccall((:igraph_community_infomap, libigraph), igraph_error_t, (Ptr{igraph_t}, Ptr{igraph_vector_t}, Ptr{igraph_vector_t}, igraph_integer_t, Ptr{igraph_vector_int_t}, Ptr{igraph_real_t}), graph, e_weights, v_weights, nb_trials, membership, codelength)
end

function igraph_community_edge_betweenness(graph, removed_edges, edge_betweenness, merges, bridges, modularity, membership, directed, weights)
    ccall((:igraph_community_edge_betweenness, libigraph), igraph_error_t, (Ptr{igraph_t}, Ptr{igraph_vector_int_t}, Ptr{igraph_vector_t}, Ptr{igraph_matrix_int_t}, Ptr{igraph_vector_int_t}, Ptr{igraph_vector_t}, Ptr{igraph_vector_int_t}, igraph_bool_t, Ptr{igraph_vector_t}), graph, removed_edges, edge_betweenness, merges, bridges, modularity, membership, directed, weights)
end

function igraph_community_eb_get_merges(graph, directed, edges, weights, merges, bridges, modularity, membership)
    ccall((:igraph_community_eb_get_merges, libigraph), igraph_error_t, (Ptr{igraph_t}, igraph_bool_t, Ptr{igraph_vector_int_t}, Ptr{igraph_vector_t}, Ptr{igraph_matrix_int_t}, Ptr{igraph_vector_int_t}, Ptr{igraph_vector_t}, Ptr{igraph_vector_int_t}), graph, directed, edges, weights, merges, bridges, modularity, membership)
end

function igraph_community_fastgreedy(graph, weights, merges, modularity, membership)
    ccall((:igraph_community_fastgreedy, libigraph), igraph_error_t, (Ptr{igraph_t}, Ptr{igraph_vector_t}, Ptr{igraph_matrix_int_t}, Ptr{igraph_vector_t}, Ptr{igraph_vector_int_t}), graph, weights, merges, modularity, membership)
end

function igraph_community_to_membership(merges, nodes, steps, membership, csize)
    ccall((:igraph_community_to_membership, libigraph), igraph_error_t, (Ptr{igraph_matrix_int_t}, igraph_integer_t, igraph_integer_t, Ptr{igraph_vector_int_t}, Ptr{igraph_vector_int_t}), merges, nodes, steps, membership, csize)
end

function igraph_le_community_to_membership(merges, steps, membership, csize)
    ccall((:igraph_le_community_to_membership, libigraph), igraph_error_t, (Ptr{igraph_matrix_int_t}, igraph_integer_t, Ptr{igraph_vector_int_t}, Ptr{igraph_vector_int_t}), merges, steps, membership, csize)
end

function igraph_community_voronoi(graph, membership, generators, modularity, lengths, weights, mode, r)
    ccall((:igraph_community_voronoi, libigraph), igraph_error_t, (Ptr{igraph_t}, Ptr{igraph_vector_int_t}, Ptr{igraph_vector_int_t}, Ptr{igraph_real_t}, Ptr{igraph_vector_t}, Ptr{igraph_vector_t}, igraph_neimode_t, igraph_real_t), graph, membership, generators, modularity, lengths, weights, mode, r)
end

function igraph_modularity(graph, membership, weights, resolution, directed, modularity)
    ccall((:igraph_modularity, libigraph), igraph_error_t, (Ptr{igraph_t}, Ptr{igraph_vector_int_t}, Ptr{igraph_vector_t}, igraph_real_t, igraph_bool_t, Ptr{igraph_real_t}), graph, membership, weights, resolution, directed, modularity)
end

function igraph_modularity_matrix(graph, weights, resolution, modmat, directed)
    ccall((:igraph_modularity_matrix, libigraph), igraph_error_t, (Ptr{igraph_t}, Ptr{igraph_vector_t}, igraph_real_t, Ptr{igraph_matrix_t}, igraph_bool_t), graph, weights, resolution, modmat, directed)
end

function igraph_reindex_membership(membership, new_to_old, nb_clusters)
    ccall((:igraph_reindex_membership, libigraph), igraph_error_t, (Ptr{igraph_vector_int_t}, Ptr{igraph_vector_int_t}, Ptr{igraph_integer_t}), membership, new_to_old, nb_clusters)
end

@cenum igraph_leading_eigenvector_community_history_t::UInt32 begin
    IGRAPH_LEVC_HIST_SPLIT = 1
    IGRAPH_LEVC_HIST_FAILED = 2
    IGRAPH_LEVC_HIST_START_FULL = 3
    IGRAPH_LEVC_HIST_START_GIVEN = 4
end

# typedef igraph_error_t igraph_community_leading_eigenvector_callback_t ( const igraph_vector_int_t * membership , igraph_integer_t comm , igraph_real_t eigenvalue , const igraph_vector_t * eigenvector , igraph_arpack_function_t * arpack_multiplier , void * arpack_extra , void * extra )
const igraph_community_leading_eigenvector_callback_t = Cvoid

function igraph_community_leading_eigenvector(graph, weights, merges, membership, steps, options, modularity, start, eigenvalues, eigenvectors, history, callback, callback_extra)
    ccall((:igraph_community_leading_eigenvector, libigraph), igraph_error_t, (Ptr{igraph_t}, Ptr{igraph_vector_t}, Ptr{igraph_matrix_int_t}, Ptr{igraph_vector_int_t}, igraph_integer_t, Ptr{igraph_arpack_options_t}, Ptr{igraph_real_t}, igraph_bool_t, Ptr{igraph_vector_t}, Ptr{igraph_vector_list_t}, Ptr{igraph_vector_t}, Ptr{igraph_community_leading_eigenvector_callback_t}, Ptr{Cvoid}), graph, weights, merges, membership, steps, options, modularity, start, eigenvalues, eigenvectors, history, callback, callback_extra)
end

function igraph_community_fluid_communities(graph, no_of_communities, membership)
    ccall((:igraph_community_fluid_communities, libigraph), igraph_error_t, (Ptr{igraph_t}, igraph_integer_t, Ptr{igraph_vector_int_t}), graph, no_of_communities, membership)
end

function igraph_community_label_propagation(graph, membership, mode, weights, initial, fixed)
    ccall((:igraph_community_label_propagation, libigraph), igraph_error_t, (Ptr{igraph_t}, Ptr{igraph_vector_int_t}, igraph_neimode_t, Ptr{igraph_vector_t}, Ptr{igraph_vector_int_t}, Ptr{igraph_vector_bool_t}), graph, membership, mode, weights, initial, fixed)
end

function igraph_community_multilevel(graph, weights, resolution, membership, memberships, modularity)
    ccall((:igraph_community_multilevel, libigraph), igraph_error_t, (Ptr{igraph_t}, Ptr{igraph_vector_t}, igraph_real_t, Ptr{igraph_vector_int_t}, Ptr{igraph_matrix_int_t}, Ptr{igraph_vector_t}), graph, weights, resolution, membership, memberships, modularity)
end

function igraph_community_leiden(graph, edge_weights, node_weights, resolution_parameter, beta, start, n_iterations, membership, nb_clusters, quality)
    ccall((:igraph_community_leiden, libigraph), igraph_error_t, (Ptr{igraph_t}, Ptr{igraph_vector_t}, Ptr{igraph_vector_t}, igraph_real_t, igraph_real_t, igraph_bool_t, igraph_integer_t, Ptr{igraph_vector_int_t}, Ptr{igraph_integer_t}, Ptr{igraph_real_t}), graph, edge_weights, node_weights, resolution_parameter, beta, start, n_iterations, membership, nb_clusters, quality)
end

function igraph_compare_communities(comm1, comm2, result, method)
    ccall((:igraph_compare_communities, libigraph), igraph_error_t, (Ptr{igraph_vector_int_t}, Ptr{igraph_vector_int_t}, Ptr{igraph_real_t}, igraph_community_comparison_t), comm1, comm2, result, method)
end

function igraph_split_join_distance(comm1, comm2, distance12, distance21)
    ccall((:igraph_split_join_distance, libigraph), igraph_error_t, (Ptr{igraph_vector_int_t}, Ptr{igraph_vector_int_t}, Ptr{igraph_integer_t}, Ptr{igraph_integer_t}), comm1, comm2, distance12, distance21)
end

@cenum igraph_attribute_type_t::UInt32 begin
    IGRAPH_ATTRIBUTE_UNSPECIFIED = 0
    IGRAPH_ATTRIBUTE_DEFAULT = 0
    IGRAPH_ATTRIBUTE_NUMERIC = 1
    IGRAPH_ATTRIBUTE_BOOLEAN = 2
    IGRAPH_ATTRIBUTE_STRING = 3
    IGRAPH_ATTRIBUTE_OBJECT = 127
end

mutable struct igraph_attribute_record_t
    name::Ptr{Cchar}
    type::igraph_attribute_type_t
    value::Ptr{Cvoid}
    igraph_attribute_record_t() = new()
end

@cenum igraph_attribute_elemtype_t::UInt32 begin
    IGRAPH_ATTRIBUTE_GRAPH = 0
    IGRAPH_ATTRIBUTE_VERTEX = 1
    IGRAPH_ATTRIBUTE_EDGE = 2
end

@cenum igraph_attribute_combination_type_t::UInt32 begin
    IGRAPH_ATTRIBUTE_COMBINE_IGNORE = 0
    IGRAPH_ATTRIBUTE_COMBINE_DEFAULT = 1
    IGRAPH_ATTRIBUTE_COMBINE_FUNCTION = 2
    IGRAPH_ATTRIBUTE_COMBINE_SUM = 3
    IGRAPH_ATTRIBUTE_COMBINE_PROD = 4
    IGRAPH_ATTRIBUTE_COMBINE_MIN = 5
    IGRAPH_ATTRIBUTE_COMBINE_MAX = 6
    IGRAPH_ATTRIBUTE_COMBINE_RANDOM = 7
    IGRAPH_ATTRIBUTE_COMBINE_FIRST = 8
    IGRAPH_ATTRIBUTE_COMBINE_LAST = 9
    IGRAPH_ATTRIBUTE_COMBINE_MEAN = 10
    IGRAPH_ATTRIBUTE_COMBINE_MEDIAN = 11
    IGRAPH_ATTRIBUTE_COMBINE_CONCAT = 12
end

# typedef void ( * igraph_function_pointer_t ) ( void )
const igraph_function_pointer_t = Ptr{Cvoid}

mutable struct igraph_attribute_combination_record_t
    name::Ptr{Cchar}
    type::igraph_attribute_combination_type_t
    func::igraph_function_pointer_t
    igraph_attribute_combination_record_t() = new()
end

mutable struct igraph_attribute_combination_t
    list::igraph_vector_ptr_t
    igraph_attribute_combination_t() = new()
end

function igraph_attribute_combination_init(comb)
    ccall((:igraph_attribute_combination_init, libigraph), igraph_error_t, (Ptr{igraph_attribute_combination_t},), comb)
end

function igraph_attribute_combination_destroy(comb)
    ccall((:igraph_attribute_combination_destroy, libigraph), Cvoid, (Ptr{igraph_attribute_combination_t},), comb)
end

function igraph_attribute_combination_add(comb, name, type, func)
    ccall((:igraph_attribute_combination_add, libigraph), igraph_error_t, (Ptr{igraph_attribute_combination_t}, Ptr{Cchar}, igraph_attribute_combination_type_t, igraph_function_pointer_t), comb, name, type, func)
end

function igraph_attribute_combination_remove(comb, name)
    ccall((:igraph_attribute_combination_remove, libigraph), igraph_error_t, (Ptr{igraph_attribute_combination_t}, Ptr{Cchar}), comb, name)
end

function igraph_attribute_combination_query(comb, name, type, func)
    ccall((:igraph_attribute_combination_query, libigraph), igraph_error_t, (Ptr{igraph_attribute_combination_t}, Ptr{Cchar}, Ptr{igraph_attribute_combination_type_t}, Ptr{igraph_function_pointer_t}), comb, name, type, func)
end

mutable struct igraph_attribute_table_t
    init::Ptr{Cvoid}
    destroy::Ptr{Cvoid}
    copy::Ptr{Cvoid}
    add_vertices::Ptr{Cvoid}
    permute_vertices::Ptr{Cvoid}
    combine_vertices::Ptr{Cvoid}
    add_edges::Ptr{Cvoid}
    permute_edges::Ptr{Cvoid}
    combine_edges::Ptr{Cvoid}
    get_info::Ptr{Cvoid}
    has_attr::Ptr{Cvoid}
    gettype::Ptr{Cvoid}
    get_numeric_graph_attr::Ptr{Cvoid}
    get_string_graph_attr::Ptr{Cvoid}
    get_bool_graph_attr::Ptr{Cvoid}
    get_numeric_vertex_attr::Ptr{Cvoid}
    get_string_vertex_attr::Ptr{Cvoid}
    get_bool_vertex_attr::Ptr{Cvoid}
    get_numeric_edge_attr::Ptr{Cvoid}
    get_string_edge_attr::Ptr{Cvoid}
    get_bool_edge_attr::Ptr{Cvoid}
    igraph_attribute_table_t() = new()
end

function igraph_i_set_attribute_table(table)
    ccall((:igraph_i_set_attribute_table, libigraph), Ptr{igraph_attribute_table_t}, (Ptr{igraph_attribute_table_t},), table)
end

function igraph_set_attribute_table(table)
    ccall((:igraph_set_attribute_table, libigraph), Ptr{igraph_attribute_table_t}, (Ptr{igraph_attribute_table_t},), table)
end

function igraph_has_attribute_table()
    ccall((:igraph_has_attribute_table, libigraph), igraph_bool_t, ())
end

function igraph_cattribute_list(graph, gnames, gtypes, vnames, vtypes, enames, etypes)
    ccall((:igraph_cattribute_list, libigraph), igraph_error_t, (Ptr{igraph_t}, Ptr{igraph_strvector_t}, Ptr{igraph_vector_int_t}, Ptr{igraph_strvector_t}, Ptr{igraph_vector_int_t}, Ptr{igraph_strvector_t}, Ptr{igraph_vector_int_t}), graph, gnames, gtypes, vnames, vtypes, enames, etypes)
end

function igraph_cattribute_has_attr(graph, type, name)
    ccall((:igraph_cattribute_has_attr, libigraph), igraph_bool_t, (Ptr{igraph_t}, igraph_attribute_elemtype_t, Ptr{Cchar}), graph, type, name)
end

function igraph_get_adjacency(graph, res, type, weights, loops)
    ccall((:igraph_get_adjacency, libigraph), igraph_error_t, (Ptr{igraph_t}, Ptr{igraph_matrix_t}, igraph_get_adjacency_t, Ptr{igraph_vector_t}, igraph_loops_t), graph, res, type, weights, loops)
end

function igraph_get_adjacency_sparse(graph, res, type, weights, loops)
    ccall((:igraph_get_adjacency_sparse, libigraph), igraph_error_t, (Ptr{igraph_t}, Ptr{igraph_sparsemat_t}, igraph_get_adjacency_t, Ptr{igraph_vector_t}, igraph_loops_t), graph, res, type, weights, loops)
end

function igraph_get_stochastic(graph, matrix, column_wise, weights)
    ccall((:igraph_get_stochastic, libigraph), igraph_error_t, (Ptr{igraph_t}, Ptr{igraph_matrix_t}, igraph_bool_t, Ptr{igraph_vector_t}), graph, matrix, column_wise, weights)
end

function igraph_get_stochastic_sparse(graph, res, column_wise, weights)
    ccall((:igraph_get_stochastic_sparse, libigraph), igraph_error_t, (Ptr{igraph_t}, Ptr{igraph_sparsemat_t}, igraph_bool_t, Ptr{igraph_vector_t}), graph, res, column_wise, weights)
end

function igraph_get_sparsemat(graph, res)
    ccall((:igraph_get_sparsemat, libigraph), igraph_error_t, (Ptr{igraph_t}, Ptr{igraph_sparsemat_t}), graph, res)
end

function igraph_get_stochastic_sparsemat(graph, res, column_wise)
    ccall((:igraph_get_stochastic_sparsemat, libigraph), igraph_error_t, (Ptr{igraph_t}, Ptr{igraph_sparsemat_t}, igraph_bool_t), graph, res, column_wise)
end

function igraph_get_edgelist(graph, res, bycol)
    ccall((:igraph_get_edgelist, libigraph), igraph_error_t, (Ptr{igraph_t}, Ptr{igraph_vector_int_t}, igraph_bool_t), graph, res, bycol)
end

function igraph_to_directed(graph, flags)
    ccall((:igraph_to_directed, libigraph), igraph_error_t, (Ptr{igraph_t}, igraph_to_directed_t), graph, flags)
end

function igraph_to_undirected(graph, mode, edge_comb)
    ccall((:igraph_to_undirected, libigraph), igraph_error_t, (Ptr{igraph_t}, igraph_to_undirected_t, Ptr{igraph_attribute_combination_t}), graph, mode, edge_comb)
end

function igraph_to_prufer(graph, prufer)
    ccall((:igraph_to_prufer, libigraph), igraph_error_t, (Ptr{igraph_t}, Ptr{igraph_vector_int_t}), graph, prufer)
end

function igraph_read_graph_edgelist(graph, instream, n, directed)
    ccall((:igraph_read_graph_edgelist, libigraph), igraph_error_t, (Ptr{igraph_t}, Ptr{Libc.FILE}, igraph_integer_t, igraph_bool_t), graph, instream, n, directed)
end

function igraph_read_graph_ncol(graph, instream, predefnames, names, weights, directed)
    ccall((:igraph_read_graph_ncol, libigraph), igraph_error_t, (Ptr{igraph_t}, Ptr{Libc.FILE}, Ptr{igraph_strvector_t}, igraph_bool_t, igraph_add_weights_t, igraph_bool_t), graph, instream, predefnames, names, weights, directed)
end

function igraph_read_graph_lgl(graph, instream, names, weights, directed)
    ccall((:igraph_read_graph_lgl, libigraph), igraph_error_t, (Ptr{igraph_t}, Ptr{Libc.FILE}, igraph_bool_t, igraph_add_weights_t, igraph_bool_t), graph, instream, names, weights, directed)
end

function igraph_read_graph_pajek(graph, instream)
    ccall((:igraph_read_graph_pajek, libigraph), igraph_error_t, (Ptr{igraph_t}, Ptr{Libc.FILE}), graph, instream)
end

function igraph_read_graph_graphml(graph, instream, index)
    ccall((:igraph_read_graph_graphml, libigraph), igraph_error_t, (Ptr{igraph_t}, Ptr{Libc.FILE}, igraph_integer_t), graph, instream, index)
end

function igraph_read_graph_dimacs(graph, instream, problem, label, source, target, capacity, directed)
    ccall((:igraph_read_graph_dimacs, libigraph), igraph_error_t, (Ptr{igraph_t}, Ptr{Libc.FILE}, Ptr{igraph_strvector_t}, Ptr{igraph_vector_int_t}, Ptr{igraph_integer_t}, Ptr{igraph_integer_t}, Ptr{igraph_vector_t}, igraph_bool_t), graph, instream, problem, label, source, target, capacity, directed)
end

function igraph_read_graph_dimacs_flow(graph, instream, problem, label, source, target, capacity, directed)
    ccall((:igraph_read_graph_dimacs_flow, libigraph), igraph_error_t, (Ptr{igraph_t}, Ptr{Libc.FILE}, Ptr{igraph_strvector_t}, Ptr{igraph_vector_int_t}, Ptr{igraph_integer_t}, Ptr{igraph_integer_t}, Ptr{igraph_vector_t}, igraph_bool_t), graph, instream, problem, label, source, target, capacity, directed)
end

function igraph_read_graph_graphdb(graph, instream, directed)
    ccall((:igraph_read_graph_graphdb, libigraph), igraph_error_t, (Ptr{igraph_t}, Ptr{Libc.FILE}, igraph_bool_t), graph, instream, directed)
end

function igraph_read_graph_gml(graph, instream)
    ccall((:igraph_read_graph_gml, libigraph), igraph_error_t, (Ptr{igraph_t}, Ptr{Libc.FILE}), graph, instream)
end

function igraph_read_graph_dl(graph, instream, directed)
    ccall((:igraph_read_graph_dl, libigraph), igraph_error_t, (Ptr{igraph_t}, Ptr{Libc.FILE}, igraph_bool_t), graph, instream, directed)
end

const igraph_write_gml_sw_t = Cuint

@cenum var"##Ctag#232"::UInt32 begin
    IGRAPH_WRITE_GML_DEFAULT_SW = 0
    IGRAPH_WRITE_GML_ENCODE_ONLY_QUOT_SW = 1
end

function igraph_write_graph_edgelist(graph, outstream)
    ccall((:igraph_write_graph_edgelist, libigraph), igraph_error_t, (Ptr{igraph_t}, Ptr{Libc.FILE}), graph, outstream)
end

function igraph_write_graph_ncol(graph, outstream, names, weights)
    ccall((:igraph_write_graph_ncol, libigraph), igraph_error_t, (Ptr{igraph_t}, Ptr{Libc.FILE}, Ptr{Cchar}, Ptr{Cchar}), graph, outstream, names, weights)
end

function igraph_write_graph_lgl(graph, outstream, names, weights, isolates)
    ccall((:igraph_write_graph_lgl, libigraph), igraph_error_t, (Ptr{igraph_t}, Ptr{Libc.FILE}, Ptr{Cchar}, Ptr{Cchar}, igraph_bool_t), graph, outstream, names, weights, isolates)
end

function igraph_write_graph_graphml(graph, outstream, prefixattr)
    ccall((:igraph_write_graph_graphml, libigraph), igraph_error_t, (Ptr{igraph_t}, Ptr{Libc.FILE}, igraph_bool_t), graph, outstream, prefixattr)
end

function igraph_write_graph_pajek(graph, outstream)
    ccall((:igraph_write_graph_pajek, libigraph), igraph_error_t, (Ptr{igraph_t}, Ptr{Libc.FILE}), graph, outstream)
end

function igraph_write_graph_dimacs(graph, outstream, source, target, capacity)
    ccall((:igraph_write_graph_dimacs, libigraph), igraph_error_t, (Ptr{igraph_t}, Ptr{Libc.FILE}, igraph_integer_t, igraph_integer_t, Ptr{igraph_vector_t}), graph, outstream, source, target, capacity)
end

function igraph_write_graph_dimacs_flow(graph, outstream, source, target, capacity)
    ccall((:igraph_write_graph_dimacs_flow, libigraph), igraph_error_t, (Ptr{igraph_t}, Ptr{Libc.FILE}, igraph_integer_t, igraph_integer_t, Ptr{igraph_vector_t}), graph, outstream, source, target, capacity)
end

function igraph_write_graph_gml(graph, outstream, options, id, creator)
    ccall((:igraph_write_graph_gml, libigraph), igraph_error_t, (Ptr{igraph_t}, Ptr{Libc.FILE}, igraph_write_gml_sw_t, Ptr{igraph_vector_t}, Ptr{Cchar}), graph, outstream, options, id, creator)
end

function igraph_write_graph_dot(graph, outstream)
    ccall((:igraph_write_graph_dot, libigraph), igraph_error_t, (Ptr{igraph_t}, Ptr{Libc.FILE}), graph, outstream)
end

function igraph_write_graph_leda(graph, outstream, vertex_attr_name, edge_attr_name)
    ccall((:igraph_write_graph_leda, libigraph), igraph_error_t, (Ptr{igraph_t}, Ptr{Libc.FILE}, Ptr{Cchar}, Ptr{Cchar}), graph, outstream, vertex_attr_name, edge_attr_name)
end

mutable struct igraph_safelocale_s end

const igraph_safelocale_t = Ptr{igraph_safelocale_s}

function igraph_enter_safelocale(loc)
    ccall((:igraph_enter_safelocale, libigraph), igraph_error_t, (Ptr{igraph_safelocale_t},), loc)
end

function igraph_exit_safelocale(loc)
    ccall((:igraph_exit_safelocale, libigraph), Cvoid, (Ptr{igraph_safelocale_t},), loc)
end

# typedef igraph_error_t igraph_motifs_handler_t ( const igraph_t * graph , igraph_vector_int_t * vids , igraph_integer_t isoclass , void * extra )
const igraph_motifs_handler_t = Cvoid

function igraph_motifs_randesu(graph, hist, size, cut_prob)
    ccall((:igraph_motifs_randesu, libigraph), igraph_error_t, (Ptr{igraph_t}, Ptr{igraph_vector_t}, igraph_integer_t, Ptr{igraph_vector_t}), graph, hist, size, cut_prob)
end

function igraph_motifs_randesu_callback(graph, size, cut_prob, callback, extra)
    ccall((:igraph_motifs_randesu_callback, libigraph), igraph_error_t, (Ptr{igraph_t}, igraph_integer_t, Ptr{igraph_vector_t}, Ptr{igraph_motifs_handler_t}, Ptr{Cvoid}), graph, size, cut_prob, callback, extra)
end

function igraph_motifs_randesu_estimate(graph, est, size, cut_prob, sample_size, sample)
    ccall((:igraph_motifs_randesu_estimate, libigraph), igraph_error_t, (Ptr{igraph_t}, Ptr{igraph_integer_t}, igraph_integer_t, Ptr{igraph_vector_t}, igraph_integer_t, Ptr{igraph_vector_int_t}), graph, est, size, cut_prob, sample_size, sample)
end

function igraph_motifs_randesu_no(graph, no, size, cut_prob)
    ccall((:igraph_motifs_randesu_no, libigraph), igraph_error_t, (Ptr{igraph_t}, Ptr{igraph_integer_t}, igraph_integer_t, Ptr{igraph_vector_t}), graph, no, size, cut_prob)
end

function igraph_dyad_census(graph, mut, asym, null)
    ccall((:igraph_dyad_census, libigraph), igraph_error_t, (Ptr{igraph_t}, Ptr{igraph_real_t}, Ptr{igraph_real_t}, Ptr{igraph_real_t}), graph, mut, asym, null)
end

function igraph_triad_census(igraph, res)
    ccall((:igraph_triad_census, libigraph), igraph_error_t, (Ptr{igraph_t}, Ptr{igraph_vector_t}), igraph, res)
end

function igraph_adjacent_triangles(graph, res, vids)
    ccall((:igraph_adjacent_triangles, libigraph), igraph_error_t, (Ptr{igraph_t}, Ptr{igraph_vector_t}, igraph_vs_t), graph, res, vids)
end

function igraph_list_triangles(graph, res)
    ccall((:igraph_list_triangles, libigraph), igraph_error_t, (Ptr{igraph_t}, Ptr{igraph_vector_int_t}), graph, res)
end

function igraph_add_edge(graph, from, to)
    ccall((:igraph_add_edge, libigraph), igraph_error_t, (Ptr{igraph_t}, igraph_integer_t, igraph_integer_t), graph, from, to)
end

function igraph_disjoint_union(res, left, right)
    ccall((:igraph_disjoint_union, libigraph), igraph_error_t, (Ptr{igraph_t}, Ptr{igraph_t}, Ptr{igraph_t}), res, left, right)
end

function igraph_disjoint_union_many(res, graphs)
    ccall((:igraph_disjoint_union_many, libigraph), igraph_error_t, (Ptr{igraph_t}, Ptr{igraph_vector_ptr_t}), res, graphs)
end

function igraph_union(res, left, right, edge_map1, edge_map2)
    ccall((:igraph_union, libigraph), igraph_error_t, (Ptr{igraph_t}, Ptr{igraph_t}, Ptr{igraph_t}, Ptr{igraph_vector_int_t}, Ptr{igraph_vector_int_t}), res, left, right, edge_map1, edge_map2)
end

function igraph_union_many(res, graphs, edgemaps)
    ccall((:igraph_union_many, libigraph), igraph_error_t, (Ptr{igraph_t}, Ptr{igraph_vector_ptr_t}, Ptr{igraph_vector_int_list_t}), res, graphs, edgemaps)
end

function igraph_join(res, left, right)
    ccall((:igraph_join, libigraph), igraph_error_t, (Ptr{igraph_t}, Ptr{igraph_t}, Ptr{igraph_t}), res, left, right)
end

function igraph_intersection(res, left, right, edge_map1, edge_map2)
    ccall((:igraph_intersection, libigraph), igraph_error_t, (Ptr{igraph_t}, Ptr{igraph_t}, Ptr{igraph_t}, Ptr{igraph_vector_int_t}, Ptr{igraph_vector_int_t}), res, left, right, edge_map1, edge_map2)
end

function igraph_intersection_many(res, graphs, edgemaps)
    ccall((:igraph_intersection_many, libigraph), igraph_error_t, (Ptr{igraph_t}, Ptr{igraph_vector_ptr_t}, Ptr{igraph_vector_int_list_t}), res, graphs, edgemaps)
end

function igraph_difference(res, orig, sub)
    ccall((:igraph_difference, libigraph), igraph_error_t, (Ptr{igraph_t}, Ptr{igraph_t}, Ptr{igraph_t}), res, orig, sub)
end

function igraph_complementer(res, graph, loops)
    ccall((:igraph_complementer, libigraph), igraph_error_t, (Ptr{igraph_t}, Ptr{igraph_t}, igraph_bool_t), res, graph, loops)
end

function igraph_compose(res, g1, g2, edge_map1, edge_map2)
    ccall((:igraph_compose, libigraph), igraph_error_t, (Ptr{igraph_t}, Ptr{igraph_t}, Ptr{igraph_t}, Ptr{igraph_vector_int_t}, Ptr{igraph_vector_int_t}), res, g1, g2, edge_map1, edge_map2)
end

function igraph_contract_vertices(graph, mapping, vertex_comb)
    ccall((:igraph_contract_vertices, libigraph), igraph_error_t, (Ptr{igraph_t}, Ptr{igraph_vector_int_t}, Ptr{igraph_attribute_combination_t}), graph, mapping, vertex_comb)
end

function igraph_permute_vertices(graph, res, permutation)
    ccall((:igraph_permute_vertices, libigraph), igraph_error_t, (Ptr{igraph_t}, Ptr{igraph_t}, Ptr{igraph_vector_int_t}), graph, res, permutation)
end

function igraph_connect_neighborhood(graph, order, mode)
    ccall((:igraph_connect_neighborhood, libigraph), igraph_error_t, (Ptr{igraph_t}, igraph_integer_t, igraph_neimode_t), graph, order, mode)
end

function igraph_graph_power(graph, res, order, directed)
    ccall((:igraph_graph_power, libigraph), igraph_error_t, (Ptr{igraph_t}, Ptr{igraph_t}, igraph_integer_t, igraph_bool_t), graph, res, order, directed)
end

function igraph_rewire(graph, n, mode)
    ccall((:igraph_rewire, libigraph), igraph_error_t, (Ptr{igraph_t}, igraph_integer_t, igraph_rewiring_t), graph, n, mode)
end

function igraph_simplify(graph, remove_multiple, remove_loops, edge_comb)
    ccall((:igraph_simplify, libigraph), igraph_error_t, (Ptr{igraph_t}, igraph_bool_t, igraph_bool_t, Ptr{igraph_attribute_combination_t}), graph, remove_multiple, remove_loops, edge_comb)
end

function igraph_induced_subgraph_map(graph, res, vids, impl, map, invmap)
    ccall((:igraph_induced_subgraph_map, libigraph), igraph_error_t, (Ptr{igraph_t}, Ptr{igraph_t}, igraph_vs_t, igraph_subgraph_implementation_t, Ptr{igraph_vector_int_t}, Ptr{igraph_vector_int_t}), graph, res, vids, impl, map, invmap)
end

function igraph_induced_subgraph(graph, res, vids, impl)
    ccall((:igraph_induced_subgraph, libigraph), igraph_error_t, (Ptr{igraph_t}, Ptr{igraph_t}, igraph_vs_t, igraph_subgraph_implementation_t), graph, res, vids, impl)
end

function igraph_induced_subgraph_edges(graph, vids, edges)
    ccall((:igraph_induced_subgraph_edges, libigraph), igraph_error_t, (Ptr{igraph_t}, igraph_vs_t, Ptr{igraph_vector_int_t}), graph, vids, edges)
end

function igraph_subgraph_from_edges(graph, res, eids, delete_vertices)
    ccall((:igraph_subgraph_from_edges, libigraph), igraph_error_t, (Ptr{igraph_t}, Ptr{igraph_t}, igraph_es_t, igraph_bool_t), graph, res, eids, delete_vertices)
end

function igraph_reverse_edges(graph, eids)
    ccall((:igraph_reverse_edges, libigraph), igraph_error_t, (Ptr{igraph_t}, igraph_es_t), graph, eids)
end

function igraph_subgraph_edges(graph, res, eids, delete_vertices)
    ccall((:igraph_subgraph_edges, libigraph), igraph_error_t, (Ptr{igraph_t}, Ptr{igraph_t}, igraph_es_t, igraph_bool_t), graph, res, eids, delete_vertices)
end

mutable struct igraph_maxflow_stats_t
    nopush::igraph_integer_t
    norelabel::igraph_integer_t
    nogap::igraph_integer_t
    nogapnodes::igraph_integer_t
    nobfs::igraph_integer_t
    igraph_maxflow_stats_t() = new()
end

function igraph_maxflow(graph, value, flow, cut, partition, partition2, source, target, capacity, stats)
    ccall((:igraph_maxflow, libigraph), igraph_error_t, (Ptr{igraph_t}, Ptr{igraph_real_t}, Ptr{igraph_vector_t}, Ptr{igraph_vector_int_t}, Ptr{igraph_vector_int_t}, Ptr{igraph_vector_int_t}, igraph_integer_t, igraph_integer_t, Ptr{igraph_vector_t}, Ptr{igraph_maxflow_stats_t}), graph, value, flow, cut, partition, partition2, source, target, capacity, stats)
end

function igraph_maxflow_value(graph, value, source, target, capacity, stats)
    ccall((:igraph_maxflow_value, libigraph), igraph_error_t, (Ptr{igraph_t}, Ptr{igraph_real_t}, igraph_integer_t, igraph_integer_t, Ptr{igraph_vector_t}, Ptr{igraph_maxflow_stats_t}), graph, value, source, target, capacity, stats)
end

function igraph_st_mincut(graph, value, cut, partition, partition2, source, target, capacity)
    ccall((:igraph_st_mincut, libigraph), igraph_error_t, (Ptr{igraph_t}, Ptr{igraph_real_t}, Ptr{igraph_vector_int_t}, Ptr{igraph_vector_int_t}, Ptr{igraph_vector_int_t}, igraph_integer_t, igraph_integer_t, Ptr{igraph_vector_t}), graph, value, cut, partition, partition2, source, target, capacity)
end

function igraph_st_mincut_value(graph, res, source, target, capacity)
    ccall((:igraph_st_mincut_value, libigraph), igraph_error_t, (Ptr{igraph_t}, Ptr{igraph_real_t}, igraph_integer_t, igraph_integer_t, Ptr{igraph_vector_t}), graph, res, source, target, capacity)
end

function igraph_mincut_value(graph, res, capacity)
    ccall((:igraph_mincut_value, libigraph), igraph_error_t, (Ptr{igraph_t}, Ptr{igraph_real_t}, Ptr{igraph_vector_t}), graph, res, capacity)
end

function igraph_mincut(graph, value, partition, partition2, cut, capacity)
    ccall((:igraph_mincut, libigraph), igraph_error_t, (Ptr{igraph_t}, Ptr{igraph_real_t}, Ptr{igraph_vector_int_t}, Ptr{igraph_vector_int_t}, Ptr{igraph_vector_int_t}, Ptr{igraph_vector_t}), graph, value, partition, partition2, cut, capacity)
end

function igraph_st_vertex_connectivity(graph, res, source, target, neighbors)
    ccall((:igraph_st_vertex_connectivity, libigraph), igraph_error_t, (Ptr{igraph_t}, Ptr{igraph_integer_t}, igraph_integer_t, igraph_integer_t, igraph_vconn_nei_t), graph, res, source, target, neighbors)
end

function igraph_vertex_connectivity(graph, res, checks)
    ccall((:igraph_vertex_connectivity, libigraph), igraph_error_t, (Ptr{igraph_t}, Ptr{igraph_integer_t}, igraph_bool_t), graph, res, checks)
end

function igraph_st_edge_connectivity(graph, res, source, target)
    ccall((:igraph_st_edge_connectivity, libigraph), igraph_error_t, (Ptr{igraph_t}, Ptr{igraph_integer_t}, igraph_integer_t, igraph_integer_t), graph, res, source, target)
end

function igraph_edge_connectivity(graph, res, checks)
    ccall((:igraph_edge_connectivity, libigraph), igraph_error_t, (Ptr{igraph_t}, Ptr{igraph_integer_t}, igraph_bool_t), graph, res, checks)
end

function igraph_edge_disjoint_paths(graph, res, source, target)
    ccall((:igraph_edge_disjoint_paths, libigraph), igraph_error_t, (Ptr{igraph_t}, Ptr{igraph_integer_t}, igraph_integer_t, igraph_integer_t), graph, res, source, target)
end

function igraph_vertex_disjoint_paths(graph, res, source, target)
    ccall((:igraph_vertex_disjoint_paths, libigraph), igraph_error_t, (Ptr{igraph_t}, Ptr{igraph_integer_t}, igraph_integer_t, igraph_integer_t), graph, res, source, target)
end

function igraph_adhesion(graph, res, checks)
    ccall((:igraph_adhesion, libigraph), igraph_error_t, (Ptr{igraph_t}, Ptr{igraph_integer_t}, igraph_bool_t), graph, res, checks)
end

function igraph_cohesion(graph, res, checks)
    ccall((:igraph_cohesion, libigraph), igraph_error_t, (Ptr{igraph_t}, Ptr{igraph_integer_t}, igraph_bool_t), graph, res, checks)
end

function igraph_even_tarjan_reduction(graph, graphbar, capacity)
    ccall((:igraph_even_tarjan_reduction, libigraph), igraph_error_t, (Ptr{igraph_t}, Ptr{igraph_t}, Ptr{igraph_vector_t}), graph, graphbar, capacity)
end

function igraph_residual_graph(graph, capacity, residual, residual_capacity, flow)
    ccall((:igraph_residual_graph, libigraph), igraph_error_t, (Ptr{igraph_t}, Ptr{igraph_vector_t}, Ptr{igraph_t}, Ptr{igraph_vector_t}, Ptr{igraph_vector_t}), graph, capacity, residual, residual_capacity, flow)
end

function igraph_reverse_residual_graph(graph, capacity, residual, flow)
    ccall((:igraph_reverse_residual_graph, libigraph), igraph_error_t, (Ptr{igraph_t}, Ptr{igraph_vector_t}, Ptr{igraph_t}, Ptr{igraph_vector_t}), graph, capacity, residual, flow)
end

function igraph_dominator_tree(graph, root, dom, domtree, leftout, mode)
    ccall((:igraph_dominator_tree, libigraph), igraph_error_t, (Ptr{igraph_t}, igraph_integer_t, Ptr{igraph_vector_int_t}, Ptr{igraph_t}, Ptr{igraph_vector_int_t}, igraph_neimode_t), graph, root, dom, domtree, leftout, mode)
end

function igraph_all_st_cuts(graph, cuts, partition1s, source, target)
    ccall((:igraph_all_st_cuts, libigraph), igraph_error_t, (Ptr{igraph_t}, Ptr{igraph_vector_int_list_t}, Ptr{igraph_vector_int_list_t}, igraph_integer_t, igraph_integer_t), graph, cuts, partition1s, source, target)
end

function igraph_all_st_mincuts(graph, value, cuts, partition1s, source, target, capacity)
    ccall((:igraph_all_st_mincuts, libigraph), igraph_error_t, (Ptr{igraph_t}, Ptr{igraph_real_t}, Ptr{igraph_vector_int_list_t}, Ptr{igraph_vector_int_list_t}, igraph_integer_t, igraph_integer_t, Ptr{igraph_vector_t}), graph, value, cuts, partition1s, source, target, capacity)
end

function igraph_gomory_hu_tree(graph, tree, flows, capacity)
    ccall((:igraph_gomory_hu_tree, libigraph), igraph_error_t, (Ptr{igraph_t}, Ptr{igraph_t}, Ptr{igraph_vector_t}, Ptr{igraph_vector_t}), graph, tree, flows, capacity)
end

# typedef igraph_real_t igraph_scalar_function_t ( const igraph_vector_t * var , const igraph_vector_t * par , void * extra )
const igraph_scalar_function_t = Cvoid

# typedef void igraph_vector_function_t ( const igraph_vector_t * var , const igraph_vector_t * par , igraph_vector_t * res , void * extra )
const igraph_vector_function_t = Cvoid

mutable struct igraph_plfit_result_t
    continuous::igraph_bool_t
    alpha::igraph_real_t
    xmin::igraph_real_t
    L::igraph_real_t
    D::igraph_real_t
    data::Ptr{igraph_vector_t}
    igraph_plfit_result_t() = new()
end

function igraph_running_mean(data, res, binwidth)
    ccall((:igraph_running_mean, libigraph), igraph_error_t, (Ptr{igraph_vector_t}, Ptr{igraph_vector_t}, igraph_integer_t), data, res, binwidth)
end

function igraph_random_sample(res, l, h, length)
    ccall((:igraph_random_sample, libigraph), igraph_error_t, (Ptr{igraph_vector_int_t}, igraph_integer_t, igraph_integer_t, igraph_integer_t), res, l, h, length)
end

function igraph_convex_hull(data, resverts, rescoords)
    ccall((:igraph_convex_hull, libigraph), igraph_error_t, (Ptr{igraph_matrix_t}, Ptr{igraph_vector_int_t}, Ptr{igraph_matrix_t}), data, resverts, rescoords)
end

function igraph_almost_equals(a, b, eps)
    ccall((:igraph_almost_equals, libigraph), igraph_bool_t, (Cdouble, Cdouble, Cdouble), a, b, eps)
end

function igraph_cmp_epsilon(a, b, eps)
    ccall((:igraph_cmp_epsilon, libigraph), Cint, (Cdouble, Cdouble, Cdouble), a, b, eps)
end

function igraph_power_law_fit(vector, result, xmin, force_continuous)
    ccall((:igraph_power_law_fit, libigraph), igraph_error_t, (Ptr{igraph_vector_t}, Ptr{igraph_plfit_result_t}, igraph_real_t, igraph_bool_t), vector, result, xmin, force_continuous)
end

function igraph_plfit_result_calculate_p_value(model, result, precision)
    ccall((:igraph_plfit_result_calculate_p_value, libigraph), igraph_error_t, (Ptr{igraph_plfit_result_t}, Ptr{igraph_real_t}, igraph_real_t), model, result, precision)
end

function igraph_zeroin(ax, bx, f, info, Tol, Maxit, res)
    ccall((:igraph_zeroin, libigraph), igraph_error_t, (Ptr{igraph_real_t}, Ptr{igraph_real_t}, Ptr{Cvoid}, Ptr{Cvoid}, Ptr{igraph_real_t}, Ptr{Cint}, Ptr{igraph_real_t}), ax, bx, f, info, Tol, Maxit, res)
end

function igraph_cocitation(graph, res, vids)
    ccall((:igraph_cocitation, libigraph), igraph_error_t, (Ptr{igraph_t}, Ptr{igraph_matrix_t}, igraph_vs_t), graph, res, vids)
end

function igraph_bibcoupling(graph, res, vids)
    ccall((:igraph_bibcoupling, libigraph), igraph_error_t, (Ptr{igraph_t}, Ptr{igraph_matrix_t}, igraph_vs_t), graph, res, vids)
end

function igraph_similarity_jaccard(graph, res, vids, mode, loops)
    ccall((:igraph_similarity_jaccard, libigraph), igraph_error_t, (Ptr{igraph_t}, Ptr{igraph_matrix_t}, igraph_vs_t, igraph_neimode_t, igraph_bool_t), graph, res, vids, mode, loops)
end

function igraph_similarity_jaccard_pairs(graph, res, pairs, mode, loops)
    ccall((:igraph_similarity_jaccard_pairs, libigraph), igraph_error_t, (Ptr{igraph_t}, Ptr{igraph_vector_t}, Ptr{igraph_vector_int_t}, igraph_neimode_t, igraph_bool_t), graph, res, pairs, mode, loops)
end

function igraph_similarity_jaccard_es(graph, res, es, mode, loops)
    ccall((:igraph_similarity_jaccard_es, libigraph), igraph_error_t, (Ptr{igraph_t}, Ptr{igraph_vector_t}, igraph_es_t, igraph_neimode_t, igraph_bool_t), graph, res, es, mode, loops)
end

function igraph_similarity_dice(graph, res, vids, mode, loops)
    ccall((:igraph_similarity_dice, libigraph), igraph_error_t, (Ptr{igraph_t}, Ptr{igraph_matrix_t}, igraph_vs_t, igraph_neimode_t, igraph_bool_t), graph, res, vids, mode, loops)
end

function igraph_similarity_dice_pairs(graph, res, pairs, mode, loops)
    ccall((:igraph_similarity_dice_pairs, libigraph), igraph_error_t, (Ptr{igraph_t}, Ptr{igraph_vector_t}, Ptr{igraph_vector_int_t}, igraph_neimode_t, igraph_bool_t), graph, res, pairs, mode, loops)
end

function igraph_similarity_dice_es(graph, res, es, mode, loops)
    ccall((:igraph_similarity_dice_es, libigraph), igraph_error_t, (Ptr{igraph_t}, Ptr{igraph_vector_t}, igraph_es_t, igraph_neimode_t, igraph_bool_t), graph, res, es, mode, loops)
end

function igraph_similarity_inverse_log_weighted(graph, res, vids, mode)
    ccall((:igraph_similarity_inverse_log_weighted, libigraph), igraph_error_t, (Ptr{igraph_t}, Ptr{igraph_matrix_t}, igraph_vs_t, igraph_neimode_t), graph, res, vids, mode)
end

mutable struct igraph_adjlist_t
    length::igraph_integer_t
    adjs::Ptr{igraph_vector_int_t}
    igraph_adjlist_t() = new()
end

mutable struct igraph_inclist_t
    length::igraph_integer_t
    incs::Ptr{igraph_vector_int_t}
    igraph_inclist_t() = new()
end

function igraph_adjlist_init(graph, al, mode, loops, multiple)
    ccall((:igraph_adjlist_init, libigraph), igraph_error_t, (Ptr{igraph_t}, Ptr{igraph_adjlist_t}, igraph_neimode_t, igraph_loops_t, igraph_multiple_t), graph, al, mode, loops, multiple)
end

function igraph_adjlist_init_empty(al, no_of_nodes)
    ccall((:igraph_adjlist_init_empty, libigraph), igraph_error_t, (Ptr{igraph_adjlist_t}, igraph_integer_t), al, no_of_nodes)
end

function igraph_adjlist_size(al)
    ccall((:igraph_adjlist_size, libigraph), igraph_integer_t, (Ptr{igraph_adjlist_t},), al)
end

function igraph_adjlist_init_complementer(graph, al, mode, loops)
    ccall((:igraph_adjlist_init_complementer, libigraph), igraph_error_t, (Ptr{igraph_t}, Ptr{igraph_adjlist_t}, igraph_neimode_t, igraph_bool_t), graph, al, mode, loops)
end

function igraph_adjlist_init_from_inclist(graph, al, il)
    ccall((:igraph_adjlist_init_from_inclist, libigraph), igraph_error_t, (Ptr{igraph_t}, Ptr{igraph_adjlist_t}, Ptr{igraph_inclist_t}), graph, al, il)
end

function igraph_adjlist_destroy(al)
    ccall((:igraph_adjlist_destroy, libigraph), Cvoid, (Ptr{igraph_adjlist_t},), al)
end

function igraph_adjlist_clear(al)
    ccall((:igraph_adjlist_clear, libigraph), Cvoid, (Ptr{igraph_adjlist_t},), al)
end

function igraph_adjlist_sort(al)
    ccall((:igraph_adjlist_sort, libigraph), Cvoid, (Ptr{igraph_adjlist_t},), al)
end

function igraph_adjlist_simplify(al)
    ccall((:igraph_adjlist_simplify, libigraph), igraph_error_t, (Ptr{igraph_adjlist_t},), al)
end

function igraph_adjlist_print(al)
    ccall((:igraph_adjlist_print, libigraph), igraph_error_t, (Ptr{igraph_adjlist_t},), al)
end

function igraph_adjlist_fprint(al, outfile)
    ccall((:igraph_adjlist_fprint, libigraph), igraph_error_t, (Ptr{igraph_adjlist_t}, Ptr{Libc.FILE}), al, outfile)
end

function igraph_adjlist_has_edge(al, from, to, directed)
    ccall((:igraph_adjlist_has_edge, libigraph), igraph_bool_t, (Ptr{igraph_adjlist_t}, igraph_integer_t, igraph_integer_t, igraph_bool_t), al, from, to, directed)
end

function igraph_adjlist_replace_edge(al, from, oldto, newto, directed)
    ccall((:igraph_adjlist_replace_edge, libigraph), igraph_error_t, (Ptr{igraph_adjlist_t}, igraph_integer_t, igraph_integer_t, igraph_integer_t, igraph_bool_t), al, from, oldto, newto, directed)
end

function igraph_adjlist(graph, adjlist, mode, duplicate)
    ccall((:igraph_adjlist, libigraph), igraph_error_t, (Ptr{igraph_t}, Ptr{igraph_adjlist_t}, igraph_neimode_t, igraph_bool_t), graph, adjlist, mode, duplicate)
end

function igraph_inclist_init(graph, il, mode, loops)
    ccall((:igraph_inclist_init, libigraph), igraph_error_t, (Ptr{igraph_t}, Ptr{igraph_inclist_t}, igraph_neimode_t, igraph_loops_t), graph, il, mode, loops)
end

function igraph_inclist_init_empty(il, n)
    ccall((:igraph_inclist_init_empty, libigraph), igraph_error_t, (Ptr{igraph_inclist_t}, igraph_integer_t), il, n)
end

function igraph_inclist_size(al)
    ccall((:igraph_inclist_size, libigraph), igraph_integer_t, (Ptr{igraph_inclist_t},), al)
end

function igraph_inclist_destroy(il)
    ccall((:igraph_inclist_destroy, libigraph), Cvoid, (Ptr{igraph_inclist_t},), il)
end

function igraph_inclist_clear(il)
    ccall((:igraph_inclist_clear, libigraph), Cvoid, (Ptr{igraph_inclist_t},), il)
end

function igraph_inclist_print(il)
    ccall((:igraph_inclist_print, libigraph), igraph_error_t, (Ptr{igraph_inclist_t},), il)
end

function igraph_inclist_fprint(il, outfile)
    ccall((:igraph_inclist_fprint, libigraph), igraph_error_t, (Ptr{igraph_inclist_t}, Ptr{Libc.FILE}), il, outfile)
end

function igraph_lazy_adjlist_init(graph, al, mode, loops, multiple)
    ccall((:igraph_lazy_adjlist_init, libigraph), igraph_error_t, (Ptr{igraph_t}, Ptr{igraph_lazy_adjlist_t}, igraph_neimode_t, igraph_loops_t, igraph_multiple_t), graph, al, mode, loops, multiple)
end

function igraph_lazy_adjlist_destroy(al)
    ccall((:igraph_lazy_adjlist_destroy, libigraph), Cvoid, (Ptr{igraph_lazy_adjlist_t},), al)
end

function igraph_lazy_adjlist_clear(al)
    ccall((:igraph_lazy_adjlist_clear, libigraph), Cvoid, (Ptr{igraph_lazy_adjlist_t},), al)
end

function igraph_lazy_adjlist_size(al)
    ccall((:igraph_lazy_adjlist_size, libigraph), igraph_integer_t, (Ptr{igraph_lazy_adjlist_t},), al)
end

function igraph_lazy_inclist_init(graph, il, mode, loops)
    ccall((:igraph_lazy_inclist_init, libigraph), igraph_error_t, (Ptr{igraph_t}, Ptr{igraph_lazy_inclist_t}, igraph_neimode_t, igraph_loops_t), graph, il, mode, loops)
end

function igraph_lazy_inclist_destroy(il)
    ccall((:igraph_lazy_inclist_destroy, libigraph), Cvoid, (Ptr{igraph_lazy_inclist_t},), il)
end

function igraph_lazy_inclist_clear(il)
    ccall((:igraph_lazy_inclist_clear, libigraph), Cvoid, (Ptr{igraph_lazy_inclist_t},), il)
end

function igraph_lazy_inclist_size(il)
    ccall((:igraph_lazy_inclist_size, libigraph), igraph_integer_t, (Ptr{igraph_lazy_inclist_t},), il)
end

function igraph_blas_dgemv(transpose, alpha, a, x, beta, y)
    ccall((:igraph_blas_dgemv, libigraph), igraph_error_t, (igraph_bool_t, igraph_real_t, Ptr{igraph_matrix_t}, Ptr{igraph_vector_t}, igraph_real_t, Ptr{igraph_vector_t}), transpose, alpha, a, x, beta, y)
end

function igraph_blas_dgemm(transpose_a, transpose_b, alpha, a, b, beta, c)
    ccall((:igraph_blas_dgemm, libigraph), igraph_error_t, (igraph_bool_t, igraph_bool_t, igraph_real_t, Ptr{igraph_matrix_t}, Ptr{igraph_matrix_t}, igraph_real_t, Ptr{igraph_matrix_t}), transpose_a, transpose_b, alpha, a, b, beta, c)
end

function igraph_blas_dgemv_array(transpose, alpha, a, x, beta, y)
    ccall((:igraph_blas_dgemv_array, libigraph), igraph_error_t, (igraph_bool_t, igraph_real_t, Ptr{igraph_matrix_t}, Ptr{igraph_real_t}, igraph_real_t, Ptr{igraph_real_t}), transpose, alpha, a, x, beta, y)
end

function igraph_blas_dnrm2(v)
    ccall((:igraph_blas_dnrm2, libigraph), igraph_real_t, (Ptr{igraph_vector_t},), v)
end

function igraph_blas_ddot(v1, v2, res)
    ccall((:igraph_blas_ddot, libigraph), igraph_error_t, (Ptr{igraph_vector_t}, Ptr{igraph_vector_t}, Ptr{igraph_real_t}), v1, v2, res)
end

function igraph_lapack_dgetrf(a, ipiv, info)
    ccall((:igraph_lapack_dgetrf, libigraph), igraph_error_t, (Ptr{igraph_matrix_t}, Ptr{igraph_vector_int_t}, Ptr{Cint}), a, ipiv, info)
end

function igraph_lapack_dgetrs(transpose, a, ipiv, b)
    ccall((:igraph_lapack_dgetrs, libigraph), igraph_error_t, (igraph_bool_t, Ptr{igraph_matrix_t}, Ptr{igraph_vector_int_t}, Ptr{igraph_matrix_t}), transpose, a, ipiv, b)
end

function igraph_lapack_dgesv(a, ipiv, b, info)
    ccall((:igraph_lapack_dgesv, libigraph), igraph_error_t, (Ptr{igraph_matrix_t}, Ptr{igraph_vector_int_t}, Ptr{igraph_matrix_t}, Ptr{Cint}), a, ipiv, b, info)
end

@cenum igraph_lapack_dsyev_which_t::UInt32 begin
    IGRAPH_LAPACK_DSYEV_ALL = 0
    IGRAPH_LAPACK_DSYEV_INTERVAL = 1
    IGRAPH_LAPACK_DSYEV_SELECT = 2
end

function igraph_lapack_dsyevr(A, which, vl, vu, vestimate, il, iu, abstol, values, vectors, support)
    ccall((:igraph_lapack_dsyevr, libigraph), igraph_error_t, (Ptr{igraph_matrix_t}, igraph_lapack_dsyev_which_t, igraph_real_t, igraph_real_t, Cint, Cint, Cint, igraph_real_t, Ptr{igraph_vector_t}, Ptr{igraph_matrix_t}, Ptr{igraph_vector_int_t}), A, which, vl, vu, vestimate, il, iu, abstol, values, vectors, support)
end

function igraph_lapack_dgeev(A, valuesreal, valuesimag, vectorsleft, vectorsright, info)
    ccall((:igraph_lapack_dgeev, libigraph), igraph_error_t, (Ptr{igraph_matrix_t}, Ptr{igraph_vector_t}, Ptr{igraph_vector_t}, Ptr{igraph_matrix_t}, Ptr{igraph_matrix_t}, Ptr{Cint}), A, valuesreal, valuesimag, vectorsleft, vectorsright, info)
end

@cenum igraph_lapack_dgeevx_balance_t::UInt32 begin
    IGRAPH_LAPACK_DGEEVX_BALANCE_NONE = 0
    IGRAPH_LAPACK_DGEEVX_BALANCE_PERM = 1
    IGRAPH_LAPACK_DGEEVX_BALANCE_SCALE = 2
    IGRAPH_LAPACK_DGEEVX_BALANCE_BOTH = 3
end

function igraph_lapack_dgeevx(balance, A, valuesreal, valuesimag, vectorsleft, vectorsright, ilo, ihi, scale, abnrm, rconde, rcondv, info)
    ccall((:igraph_lapack_dgeevx, libigraph), igraph_error_t, (igraph_lapack_dgeevx_balance_t, Ptr{igraph_matrix_t}, Ptr{igraph_vector_t}, Ptr{igraph_vector_t}, Ptr{igraph_matrix_t}, Ptr{igraph_matrix_t}, Ptr{Cint}, Ptr{Cint}, Ptr{igraph_vector_t}, Ptr{igraph_real_t}, Ptr{igraph_vector_t}, Ptr{igraph_vector_t}, Ptr{Cint}), balance, A, valuesreal, valuesimag, vectorsleft, vectorsright, ilo, ihi, scale, abnrm, rconde, rcondv, info)
end

function igraph_lapack_dgehrd(A, ilo, ihi, result)
    ccall((:igraph_lapack_dgehrd, libigraph), igraph_error_t, (Ptr{igraph_matrix_t}, Cint, Cint, Ptr{igraph_matrix_t}), A, ilo, ihi, result)
end

function igraph_assortativity_nominal(graph, types, res, directed, normalized)
    ccall((:igraph_assortativity_nominal, libigraph), igraph_error_t, (Ptr{igraph_t}, Ptr{igraph_vector_int_t}, Ptr{igraph_real_t}, igraph_bool_t, igraph_bool_t), graph, types, res, directed, normalized)
end

function igraph_assortativity(graph, values, values_in, res, directed, normalized)
    ccall((:igraph_assortativity, libigraph), igraph_error_t, (Ptr{igraph_t}, Ptr{igraph_vector_t}, Ptr{igraph_vector_t}, Ptr{igraph_real_t}, igraph_bool_t, igraph_bool_t), graph, values, values_in, res, directed, normalized)
end

function igraph_assortativity_degree(graph, res, directed)
    ccall((:igraph_assortativity_degree, libigraph), igraph_error_t, (Ptr{igraph_t}, Ptr{igraph_real_t}, igraph_bool_t), graph, res, directed)
end

function igraph_joint_degree_matrix(graph, weights, jdm, dout, din)
    ccall((:igraph_joint_degree_matrix, libigraph), igraph_error_t, (Ptr{igraph_t}, Ptr{igraph_vector_t}, Ptr{igraph_matrix_t}, igraph_integer_t, igraph_integer_t), graph, weights, jdm, dout, din)
end

function igraph_joint_degree_distribution(graph, weights, p, from_mode, to_mode, directed_neighbors, normalized, max_from_degree, max_to_degree)
    ccall((:igraph_joint_degree_distribution, libigraph), igraph_error_t, (Ptr{igraph_t}, Ptr{igraph_vector_t}, Ptr{igraph_matrix_t}, igraph_neimode_t, igraph_neimode_t, igraph_bool_t, igraph_bool_t, igraph_integer_t, igraph_integer_t), graph, weights, p, from_mode, to_mode, directed_neighbors, normalized, max_from_degree, max_to_degree)
end

function igraph_joint_type_distribution(graph, weights, p, from_types, to_types, directed, normalized)
    ccall((:igraph_joint_type_distribution, libigraph), igraph_error_t, (Ptr{igraph_t}, Ptr{igraph_vector_t}, Ptr{igraph_matrix_t}, Ptr{igraph_vector_int_t}, Ptr{igraph_vector_int_t}, igraph_bool_t, igraph_bool_t), graph, weights, p, from_types, to_types, directed, normalized)
end

function igraph_is_separator(graph, candidate, res)
    ccall((:igraph_is_separator, libigraph), igraph_error_t, (Ptr{igraph_t}, igraph_vs_t, Ptr{igraph_bool_t}), graph, candidate, res)
end

function igraph_all_minimal_st_separators(graph, separators)
    ccall((:igraph_all_minimal_st_separators, libigraph), igraph_error_t, (Ptr{igraph_t}, Ptr{igraph_vector_int_list_t}), graph, separators)
end

function igraph_is_minimal_separator(graph, candidate, res)
    ccall((:igraph_is_minimal_separator, libigraph), igraph_error_t, (Ptr{igraph_t}, igraph_vs_t, Ptr{igraph_bool_t}), graph, candidate, res)
end

function igraph_minimum_size_separators(graph, separators)
    ccall((:igraph_minimum_size_separators, libigraph), igraph_error_t, (Ptr{igraph_t}, Ptr{igraph_vector_int_list_t}), graph, separators)
end

function igraph_cohesive_blocks(graph, blocks, cohesion, parent, block_tree)
    ccall((:igraph_cohesive_blocks, libigraph), igraph_error_t, (Ptr{igraph_t}, Ptr{igraph_vector_int_list_t}, Ptr{igraph_vector_int_t}, Ptr{igraph_vector_int_t}, Ptr{igraph_t}), graph, blocks, cohesion, parent, block_tree)
end

@cenum igraph_eigen_algorithm_t::UInt32 begin
    IGRAPH_EIGEN_AUTO = 0
    IGRAPH_EIGEN_LAPACK = 1
    IGRAPH_EIGEN_ARPACK = 2
    IGRAPH_EIGEN_COMP_AUTO = 3
    IGRAPH_EIGEN_COMP_LAPACK = 4
    IGRAPH_EIGEN_COMP_ARPACK = 5
end

@cenum igraph_eigen_which_position_t::UInt32 begin
    IGRAPH_EIGEN_LM = 0
    IGRAPH_EIGEN_SM = 1
    IGRAPH_EIGEN_LA = 2
    IGRAPH_EIGEN_SA = 3
    IGRAPH_EIGEN_BE = 4
    IGRAPH_EIGEN_LR = 5
    IGRAPH_EIGEN_SR = 6
    IGRAPH_EIGEN_LI = 7
    IGRAPH_EIGEN_SI = 8
    IGRAPH_EIGEN_ALL = 9
    IGRAPH_EIGEN_INTERVAL = 10
    IGRAPH_EIGEN_SELECT = 11
end

struct igraph_eigen_which_t
    pos::igraph_eigen_which_position_t
    howmany::Cint
    il::Cint
    iu::Cint
    vl::igraph_real_t
    vu::igraph_real_t
    vestimate::Cint
    balance::igraph_lapack_dgeevx_balance_t
end

function igraph_eigen_matrix_symmetric(A, sA, fun, n, extra, algorithm, which, options, storage, values, vectors)
    ccall((:igraph_eigen_matrix_symmetric, libigraph), igraph_error_t, (Ptr{igraph_matrix_t}, Ptr{igraph_sparsemat_t}, Ptr{igraph_arpack_function_t}, Cint, Ptr{Cvoid}, igraph_eigen_algorithm_t, Ptr{igraph_eigen_which_t}, Ptr{igraph_arpack_options_t}, Ptr{igraph_arpack_storage_t}, Ptr{igraph_vector_t}, Ptr{igraph_matrix_t}), A, sA, fun, n, extra, algorithm, which, options, storage, values, vectors)
end

function igraph_eigen_matrix(A, sA, fun, n, extra, algorithm, which, options, storage, values, vectors)
    ccall((:igraph_eigen_matrix, libigraph), igraph_error_t, (Ptr{igraph_matrix_t}, Ptr{igraph_sparsemat_t}, Ptr{igraph_arpack_function_t}, Cint, Ptr{Cvoid}, igraph_eigen_algorithm_t, Ptr{igraph_eigen_which_t}, Ptr{igraph_arpack_options_t}, Ptr{igraph_arpack_storage_t}, Ptr{igraph_vector_complex_t}, Ptr{igraph_matrix_complex_t}), A, sA, fun, n, extra, algorithm, which, options, storage, values, vectors)
end

function igraph_eigen_adjacency(graph, algorithm, which, options, storage, values, vectors, cmplxvalues, cmplxvectors)
    ccall((:igraph_eigen_adjacency, libigraph), igraph_error_t, (Ptr{igraph_t}, igraph_eigen_algorithm_t, Ptr{igraph_eigen_which_t}, Ptr{igraph_arpack_options_t}, Ptr{igraph_arpack_storage_t}, Ptr{igraph_vector_t}, Ptr{igraph_matrix_t}, Ptr{igraph_vector_complex_t}, Ptr{igraph_matrix_complex_t}), graph, algorithm, which, options, storage, values, vectors, cmplxvalues, cmplxvectors)
end

mutable struct igraph_hrg_t
    left::igraph_vector_int_t
    right::igraph_vector_int_t
    prob::igraph_vector_t
    vertices::igraph_vector_int_t
    edges::igraph_vector_int_t
    igraph_hrg_t() = new()
end

function igraph_hrg_init(hrg, n)
    ccall((:igraph_hrg_init, libigraph), igraph_error_t, (Ptr{igraph_hrg_t}, igraph_integer_t), hrg, n)
end

function igraph_hrg_destroy(hrg)
    ccall((:igraph_hrg_destroy, libigraph), Cvoid, (Ptr{igraph_hrg_t},), hrg)
end

function igraph_hrg_size(hrg)
    ccall((:igraph_hrg_size, libigraph), igraph_integer_t, (Ptr{igraph_hrg_t},), hrg)
end

function igraph_hrg_resize(hrg, newsize)
    ccall((:igraph_hrg_resize, libigraph), igraph_error_t, (Ptr{igraph_hrg_t}, igraph_integer_t), hrg, newsize)
end

function igraph_hrg_fit(graph, hrg, start, steps)
    ccall((:igraph_hrg_fit, libigraph), igraph_error_t, (Ptr{igraph_t}, Ptr{igraph_hrg_t}, igraph_bool_t, igraph_integer_t), graph, hrg, start, steps)
end

function igraph_hrg_sample(hrg, sample)
    ccall((:igraph_hrg_sample, libigraph), igraph_error_t, (Ptr{igraph_hrg_t}, Ptr{igraph_t}), hrg, sample)
end

function igraph_hrg_sample_many(hrg, samples, num_samples)
    ccall((:igraph_hrg_sample_many, libigraph), igraph_error_t, (Ptr{igraph_hrg_t}, Ptr{igraph_graph_list_t}, igraph_integer_t), hrg, samples, num_samples)
end

function igraph_hrg_game(graph, hrg)
    ccall((:igraph_hrg_game, libigraph), igraph_error_t, (Ptr{igraph_t}, Ptr{igraph_hrg_t}), graph, hrg)
end

function igraph_from_hrg_dendrogram(graph, hrg, prob)
    ccall((:igraph_from_hrg_dendrogram, libigraph), igraph_error_t, (Ptr{igraph_t}, Ptr{igraph_hrg_t}, Ptr{igraph_vector_t}), graph, hrg, prob)
end

function igraph_hrg_consensus(graph, parents, weights, hrg, start, num_samples)
    ccall((:igraph_hrg_consensus, libigraph), igraph_error_t, (Ptr{igraph_t}, Ptr{igraph_vector_int_t}, Ptr{igraph_vector_t}, Ptr{igraph_hrg_t}, igraph_bool_t, igraph_integer_t), graph, parents, weights, hrg, start, num_samples)
end

function igraph_hrg_predict(graph, edges, prob, hrg, start, num_samples, num_bins)
    ccall((:igraph_hrg_predict, libigraph), igraph_error_t, (Ptr{igraph_t}, Ptr{igraph_vector_int_t}, Ptr{igraph_vector_t}, Ptr{igraph_hrg_t}, igraph_bool_t, igraph_integer_t, igraph_integer_t), graph, edges, prob, hrg, start, num_samples, num_bins)
end

function igraph_hrg_create(hrg, graph, prob)
    ccall((:igraph_hrg_create, libigraph), igraph_error_t, (Ptr{igraph_hrg_t}, Ptr{igraph_t}, Ptr{igraph_vector_t}), hrg, graph, prob)
end

function igraph_hrg_dendrogram(graph, hrg)
    ccall((:igraph_hrg_dendrogram, libigraph), igraph_error_t, (Ptr{igraph_t}, Ptr{igraph_hrg_t}), graph, hrg)
end

# typedef igraph_error_t igraph_interruption_handler_t ( void * data )
const igraph_interruption_handler_t = Cvoid

function igraph_allow_interruption(data)
    ccall((:igraph_allow_interruption, libigraph), igraph_error_t, (Ptr{Cvoid},), data)
end

function igraph_set_interruption_handler(new_handler)
    ccall((:igraph_set_interruption_handler, libigraph), Ptr{igraph_interruption_handler_t}, (Ptr{igraph_interruption_handler_t},), new_handler)
end

function igraph_is_matching(graph, types, matching, result)
    ccall((:igraph_is_matching, libigraph), igraph_error_t, (Ptr{igraph_t}, Ptr{igraph_vector_bool_t}, Ptr{igraph_vector_int_t}, Ptr{igraph_bool_t}), graph, types, matching, result)
end

function igraph_is_maximal_matching(graph, types, matching, result)
    ccall((:igraph_is_maximal_matching, libigraph), igraph_error_t, (Ptr{igraph_t}, Ptr{igraph_vector_bool_t}, Ptr{igraph_vector_int_t}, Ptr{igraph_bool_t}), graph, types, matching, result)
end

function igraph_maximum_bipartite_matching(graph, types, matching_size, matching_weight, matching, weights, eps)
    ccall((:igraph_maximum_bipartite_matching, libigraph), igraph_error_t, (Ptr{igraph_t}, Ptr{igraph_vector_bool_t}, Ptr{igraph_integer_t}, Ptr{igraph_real_t}, Ptr{igraph_vector_int_t}, Ptr{igraph_vector_t}, igraph_real_t), graph, types, matching_size, matching_weight, matching, weights, eps)
end

function igraph_adjacency_spectral_embedding(graph, no, weights, which, scaled, X, Y, D, cvec, options)
    ccall((:igraph_adjacency_spectral_embedding, libigraph), igraph_error_t, (Ptr{igraph_t}, igraph_integer_t, Ptr{igraph_vector_t}, igraph_eigen_which_position_t, igraph_bool_t, Ptr{igraph_matrix_t}, Ptr{igraph_matrix_t}, Ptr{igraph_vector_t}, Ptr{igraph_vector_t}, Ptr{igraph_arpack_options_t}), graph, no, weights, which, scaled, X, Y, D, cvec, options)
end

@cenum igraph_laplacian_spectral_embedding_type_t::UInt32 begin
    IGRAPH_EMBEDDING_D_A = 0
    IGRAPH_EMBEDDING_I_DAD = 1
    IGRAPH_EMBEDDING_DAD = 2
    IGRAPH_EMBEDDING_OAP = 3
end

function igraph_laplacian_spectral_embedding(graph, no, weights, which, type, scaled, X, Y, D, options)
    ccall((:igraph_laplacian_spectral_embedding, libigraph), igraph_error_t, (Ptr{igraph_t}, igraph_integer_t, Ptr{igraph_vector_t}, igraph_eigen_which_position_t, igraph_laplacian_spectral_embedding_type_t, igraph_bool_t, Ptr{igraph_matrix_t}, Ptr{igraph_matrix_t}, Ptr{igraph_vector_t}, Ptr{igraph_arpack_options_t}), graph, no, weights, which, type, scaled, X, Y, D, options)
end

function igraph_dim_select(sv, dim)
    ccall((:igraph_dim_select, libigraph), igraph_error_t, (Ptr{igraph_vector_t}, Ptr{igraph_integer_t}), sv, dim)
end

function igraph_local_scan_0(graph, res, weights, mode)
    ccall((:igraph_local_scan_0, libigraph), igraph_error_t, (Ptr{igraph_t}, Ptr{igraph_vector_t}, Ptr{igraph_vector_t}, igraph_neimode_t), graph, res, weights, mode)
end

function igraph_local_scan_0_them(us, them, res, weights_them, mode)
    ccall((:igraph_local_scan_0_them, libigraph), igraph_error_t, (Ptr{igraph_t}, Ptr{igraph_t}, Ptr{igraph_vector_t}, Ptr{igraph_vector_t}, igraph_neimode_t), us, them, res, weights_them, mode)
end

function igraph_local_scan_1_ecount(graph, res, weights, mode)
    ccall((:igraph_local_scan_1_ecount, libigraph), igraph_error_t, (Ptr{igraph_t}, Ptr{igraph_vector_t}, Ptr{igraph_vector_t}, igraph_neimode_t), graph, res, weights, mode)
end

function igraph_local_scan_1_ecount_them(us, them, res, weights, mode)
    ccall((:igraph_local_scan_1_ecount_them, libigraph), igraph_error_t, (Ptr{igraph_t}, Ptr{igraph_t}, Ptr{igraph_vector_t}, Ptr{igraph_vector_t}, igraph_neimode_t), us, them, res, weights, mode)
end

function igraph_local_scan_k_ecount(graph, k, res, weights, mode)
    ccall((:igraph_local_scan_k_ecount, libigraph), igraph_error_t, (Ptr{igraph_t}, igraph_integer_t, Ptr{igraph_vector_t}, Ptr{igraph_vector_t}, igraph_neimode_t), graph, k, res, weights, mode)
end

function igraph_local_scan_k_ecount_them(us, them, k, res, weights_them, mode)
    ccall((:igraph_local_scan_k_ecount_them, libigraph), igraph_error_t, (Ptr{igraph_t}, Ptr{igraph_t}, igraph_integer_t, Ptr{igraph_vector_t}, Ptr{igraph_vector_t}, igraph_neimode_t), us, them, k, res, weights_them, mode)
end

function igraph_local_scan_neighborhood_ecount(graph, res, weights, neighborhoods)
    ccall((:igraph_local_scan_neighborhood_ecount, libigraph), igraph_error_t, (Ptr{igraph_t}, Ptr{igraph_vector_t}, Ptr{igraph_vector_t}, Ptr{igraph_vector_int_list_t}), graph, res, weights, neighborhoods)
end

function igraph_local_scan_subset_ecount(graph, res, weights, neighborhoods)
    ccall((:igraph_local_scan_subset_ecount, libigraph), igraph_error_t, (Ptr{igraph_t}, Ptr{igraph_vector_t}, Ptr{igraph_vector_t}, Ptr{igraph_vector_int_list_t}), graph, res, weights, neighborhoods)
end

function igraph_graphlets_candidate_basis(graph, weights, cliques, thresholds)
    ccall((:igraph_graphlets_candidate_basis, libigraph), igraph_error_t, (Ptr{igraph_t}, Ptr{igraph_vector_t}, Ptr{igraph_vector_int_list_t}, Ptr{igraph_vector_t}), graph, weights, cliques, thresholds)
end

function igraph_graphlets_project(graph, weights, cliques, Mu, startMu, niter)
    ccall((:igraph_graphlets_project, libigraph), igraph_error_t, (Ptr{igraph_t}, Ptr{igraph_vector_t}, Ptr{igraph_vector_int_list_t}, Ptr{igraph_vector_t}, igraph_bool_t, igraph_integer_t), graph, weights, cliques, Mu, startMu, niter)
end

function igraph_graphlets(graph, weights, cliques, Mu, niter)
    ccall((:igraph_graphlets, libigraph), igraph_error_t, (Ptr{igraph_t}, Ptr{igraph_vector_t}, Ptr{igraph_vector_int_list_t}, Ptr{igraph_vector_t}, igraph_integer_t), graph, weights, cliques, Mu, niter)
end

mutable struct igraph_sir_t
    times::igraph_vector_t
    no_s::igraph_vector_int_t
    no_i::igraph_vector_int_t
    no_r::igraph_vector_int_t
    igraph_sir_t() = new()
end

function igraph_sir_init(sir)
    ccall((:igraph_sir_init, libigraph), igraph_error_t, (Ptr{igraph_sir_t},), sir)
end

function igraph_sir_destroy(sir)
    ccall((:igraph_sir_destroy, libigraph), Cvoid, (Ptr{igraph_sir_t},), sir)
end

function igraph_sir(graph, beta, gamma, no_sim, result)
    ccall((:igraph_sir, libigraph), igraph_error_t, (Ptr{igraph_t}, igraph_real_t, igraph_real_t, igraph_integer_t, Ptr{igraph_vector_ptr_t}), graph, beta, gamma, no_sim, result)
end

function igraph_solve_lsap(c, n, p)
    ccall((:igraph_solve_lsap, libigraph), igraph_error_t, (Ptr{igraph_matrix_t}, igraph_integer_t, Ptr{igraph_vector_int_t}), c, n, p)
end

@cenum igraph_coloring_greedy_t::UInt32 begin
    IGRAPH_COLORING_GREEDY_COLORED_NEIGHBORS = 0
    IGRAPH_COLORING_GREEDY_DSATUR = 1
end

function igraph_vertex_coloring_greedy(graph, colors, heuristic)
    ccall((:igraph_vertex_coloring_greedy, libigraph), igraph_error_t, (Ptr{igraph_t}, Ptr{igraph_vector_int_t}, igraph_coloring_greedy_t), graph, colors, heuristic)
end

function igraph_is_eulerian(graph, has_path, has_cycle)
    ccall((:igraph_is_eulerian, libigraph), igraph_error_t, (Ptr{igraph_t}, Ptr{igraph_bool_t}, Ptr{igraph_bool_t}), graph, has_path, has_cycle)
end

function igraph_eulerian_path(graph, edge_res, vertex_res)
    ccall((:igraph_eulerian_path, libigraph), igraph_error_t, (Ptr{igraph_t}, Ptr{igraph_vector_int_t}, Ptr{igraph_vector_int_t}), graph, edge_res, vertex_res)
end

function igraph_eulerian_cycle(graph, edge_res, vertex_res)
    ccall((:igraph_eulerian_cycle, libigraph), igraph_error_t, (Ptr{igraph_t}, Ptr{igraph_vector_int_t}, Ptr{igraph_vector_int_t}), graph, edge_res, vertex_res)
end

function igraph_fundamental_cycles(graph, result, start_vid, bfs_cutoff, weights)
    ccall((:igraph_fundamental_cycles, libigraph), igraph_error_t, (Ptr{igraph_t}, Ptr{igraph_vector_int_list_t}, igraph_integer_t, igraph_integer_t, Ptr{igraph_vector_t}), graph, result, start_vid, bfs_cutoff, weights)
end

function igraph_minimum_cycle_basis(graph, result, bfs_cutoff, complete, use_cycle_order, weights)
    ccall((:igraph_minimum_cycle_basis, libigraph), igraph_error_t, (Ptr{igraph_t}, Ptr{igraph_vector_int_list_t}, igraph_integer_t, igraph_bool_t, igraph_bool_t, Ptr{igraph_vector_t}), graph, result, bfs_cutoff, complete, use_cycle_order, weights)
end

function igraph_find_cycle(graph, vertices, edges, mode)
    ccall((:igraph_find_cycle, libigraph), igraph_error_t, (Ptr{igraph_t}, Ptr{igraph_vector_int_t}, Ptr{igraph_vector_int_t}, igraph_neimode_t), graph, vertices, edges, mode)
end

# typedef igraph_error_t igraph_cycle_handler_t ( const igraph_vector_int_t * vertices , const igraph_vector_int_t * edges , void * arg )
const igraph_cycle_handler_t = Cvoid

function igraph_simple_cycles_callback(graph, mode, min_cycle_length, max_cycle_length, callback, arg)
    ccall((:igraph_simple_cycles_callback, libigraph), igraph_error_t, (Ptr{igraph_t}, igraph_neimode_t, igraph_integer_t, igraph_integer_t, Ptr{igraph_cycle_handler_t}, Ptr{Cvoid}), graph, mode, min_cycle_length, max_cycle_length, callback, arg)
end

function igraph_simple_cycles(graph, vertices, edges, mode, min_cycle_length, max_cycle_length)
    ccall((:igraph_simple_cycles, libigraph), igraph_error_t, (Ptr{igraph_t}, Ptr{igraph_vector_int_list_t}, Ptr{igraph_vector_int_list_t}, igraph_neimode_t, igraph_integer_t, igraph_integer_t), graph, vertices, edges, mode, min_cycle_length, max_cycle_length)
end

function igraph_bitset_list_get_ptr(v, pos)
    ccall((:igraph_bitset_list_get_ptr, libigraph), Ptr{igraph_bitset_t}, (Ptr{igraph_bitset_list_t}, igraph_integer_t), v, pos)
end

function igraph_bitset_list_set(v, pos, e)
    ccall((:igraph_bitset_list_set, libigraph), Cvoid, (Ptr{igraph_bitset_list_t}, igraph_integer_t, Ptr{igraph_bitset_t}), v, pos, e)
end

function igraph_bitset_list_tail_ptr(v)
    ccall((:igraph_bitset_list_tail_ptr, libigraph), Ptr{igraph_bitset_t}, (Ptr{igraph_bitset_list_t},), v)
end

function igraph_bitset_list_capacity(v)
    ccall((:igraph_bitset_list_capacity, libigraph), igraph_integer_t, (Ptr{igraph_bitset_list_t},), v)
end

function igraph_bitset_list_empty(v)
    ccall((:igraph_bitset_list_empty, libigraph), igraph_bool_t, (Ptr{igraph_bitset_list_t},), v)
end

function igraph_bitset_list_size(v)
    ccall((:igraph_bitset_list_size, libigraph), igraph_integer_t, (Ptr{igraph_bitset_list_t},), v)
end

function igraph_bitset_list_clear(v)
    ccall((:igraph_bitset_list_clear, libigraph), Cvoid, (Ptr{igraph_bitset_list_t},), v)
end

function igraph_bitset_list_reserve(v, capacity)
    ccall((:igraph_bitset_list_reserve, libigraph), igraph_error_t, (Ptr{igraph_bitset_list_t}, igraph_integer_t), v, capacity)
end

function igraph_bitset_list_resize(v, new_size)
    ccall((:igraph_bitset_list_resize, libigraph), igraph_error_t, (Ptr{igraph_bitset_list_t}, igraph_integer_t), v, new_size)
end

function igraph_bitset_list_discard(v, index)
    ccall((:igraph_bitset_list_discard, libigraph), Cvoid, (Ptr{igraph_bitset_list_t}, igraph_integer_t), v, index)
end

function igraph_bitset_list_discard_back(v)
    ccall((:igraph_bitset_list_discard_back, libigraph), Cvoid, (Ptr{igraph_bitset_list_t},), v)
end

function igraph_bitset_list_discard_fast(v, index)
    ccall((:igraph_bitset_list_discard_fast, libigraph), Cvoid, (Ptr{igraph_bitset_list_t}, igraph_integer_t), v, index)
end

function igraph_bitset_list_insert(v, pos, e)
    ccall((:igraph_bitset_list_insert, libigraph), igraph_error_t, (Ptr{igraph_bitset_list_t}, igraph_integer_t, Ptr{igraph_bitset_t}), v, pos, e)
end

function igraph_bitset_list_insert_copy(v, pos, e)
    ccall((:igraph_bitset_list_insert_copy, libigraph), igraph_error_t, (Ptr{igraph_bitset_list_t}, igraph_integer_t, Ptr{igraph_bitset_t}), v, pos, e)
end

function igraph_bitset_list_insert_new(v, pos, result)
    ccall((:igraph_bitset_list_insert_new, libigraph), igraph_error_t, (Ptr{igraph_bitset_list_t}, igraph_integer_t, Ptr{Ptr{igraph_bitset_t}}), v, pos, result)
end

function igraph_bitset_list_push_back(v, e)
    ccall((:igraph_bitset_list_push_back, libigraph), igraph_error_t, (Ptr{igraph_bitset_list_t}, Ptr{igraph_bitset_t}), v, e)
end

function igraph_bitset_list_push_back_copy(v, e)
    ccall((:igraph_bitset_list_push_back_copy, libigraph), igraph_error_t, (Ptr{igraph_bitset_list_t}, Ptr{igraph_bitset_t}), v, e)
end

function igraph_bitset_list_push_back_new(v, result)
    ccall((:igraph_bitset_list_push_back_new, libigraph), igraph_error_t, (Ptr{igraph_bitset_list_t}, Ptr{Ptr{igraph_bitset_t}}), v, result)
end

function igraph_bitset_list_pop_back(v)
    ccall((:igraph_bitset_list_pop_back, libigraph), igraph_bitset_t, (Ptr{igraph_bitset_list_t},), v)
end

function igraph_bitset_list_remove(v, index, e)
    ccall((:igraph_bitset_list_remove, libigraph), igraph_error_t, (Ptr{igraph_bitset_list_t}, igraph_integer_t, Ptr{igraph_bitset_t}), v, index, e)
end

function igraph_bitset_list_remove_fast(v, index, e)
    ccall((:igraph_bitset_list_remove_fast, libigraph), igraph_error_t, (Ptr{igraph_bitset_list_t}, igraph_integer_t, Ptr{igraph_bitset_t}), v, index, e)
end

function igraph_bitset_list_replace(v, pos, e)
    ccall((:igraph_bitset_list_replace, libigraph), Cvoid, (Ptr{igraph_bitset_list_t}, igraph_integer_t, Ptr{igraph_bitset_t}), v, pos, e)
end

function igraph_bitset_list_remove_consecutive_duplicates(v, eq)
    ccall((:igraph_bitset_list_remove_consecutive_duplicates, libigraph), Cvoid, (Ptr{igraph_bitset_list_t}, Ptr{Cvoid}), v, eq)
end

function igraph_bitset_list_permute(v, index)
    ccall((:igraph_bitset_list_permute, libigraph), igraph_error_t, (Ptr{igraph_bitset_list_t}, Ptr{igraph_vector_int_t}), v, index)
end

function igraph_bitset_list_reverse(v)
    ccall((:igraph_bitset_list_reverse, libigraph), igraph_error_t, (Ptr{igraph_bitset_list_t},), v)
end

function igraph_bitset_list_swap(v1, v2)
    ccall((:igraph_bitset_list_swap, libigraph), igraph_error_t, (Ptr{igraph_bitset_list_t}, Ptr{igraph_bitset_list_t}), v1, v2)
end

function igraph_bitset_list_swap_elements(v, i, j)
    ccall((:igraph_bitset_list_swap_elements, libigraph), igraph_error_t, (Ptr{igraph_bitset_list_t}, igraph_integer_t, igraph_integer_t), v, i, j)
end

function igraph_bitset_list_sort(v, cmp)
    ccall((:igraph_bitset_list_sort, libigraph), Cvoid, (Ptr{igraph_bitset_list_t}, Ptr{Cvoid}), v, cmp)
end

function igraph_bitset_list_sort_ind(v, ind, cmp)
    ccall((:igraph_bitset_list_sort_ind, libigraph), igraph_error_t, (Ptr{igraph_bitset_list_t}, Ptr{igraph_vector_int_t}, Ptr{Cvoid}), v, ind, cmp)
end

function igraph_reachability(graph, membership, csize, no_of_components, reach, mode)
    ccall((:igraph_reachability, libigraph), igraph_error_t, (Ptr{igraph_t}, Ptr{igraph_vector_int_t}, Ptr{igraph_vector_int_t}, Ptr{igraph_integer_t}, Ptr{igraph_bitset_list_t}, igraph_neimode_t), graph, membership, csize, no_of_components, reach, mode)
end

function igraph_count_reachable(graph, counts, mode)
    ccall((:igraph_count_reachable, libigraph), igraph_error_t, (Ptr{igraph_t}, Ptr{igraph_vector_int_t}, igraph_neimode_t), graph, counts, mode)
end

function igraph_transitive_closure(graph, closure)
    ccall((:igraph_transitive_closure, libigraph), igraph_error_t, (Ptr{igraph_t}, Ptr{igraph_t}), graph, closure)
end

mutable struct var"struct (unnamed at /home/stefan/.julia/artifacts/d7abc8767e8a099d5939fead030cd46916c2c387/include/igraph/igraph_iterators.h:253:9)"
    vid::igraph_integer_t
    mode::igraph_neimode_t
    var"struct (unnamed at /home/stefan/.julia/artifacts/d7abc8767e8a099d5939fead030cd46916c2c387/include/igraph/igraph_iterators.h:253:9)"() = new()
end

mutable struct var"struct (unnamed at /home/stefan/.julia/artifacts/d7abc8767e8a099d5939fead030cd46916c2c387/include/igraph/igraph_iterators.h:257:9)"
    start::igraph_integer_t
    _end::igraph_integer_t
    var"struct (unnamed at /home/stefan/.julia/artifacts/d7abc8767e8a099d5939fead030cd46916c2c387/include/igraph/igraph_iterators.h:257:9)"() = new()
end

mutable struct var"struct (unnamed at /home/stefan/.julia/artifacts/d7abc8767e8a099d5939fead030cd46916c2c387/include/igraph/igraph_iterators.h:261:9)"
    ptr::Ptr{igraph_vector_int_t}
    mode::igraph_bool_t
    var"struct (unnamed at /home/stefan/.julia/artifacts/d7abc8767e8a099d5939fead030cd46916c2c387/include/igraph/igraph_iterators.h:261:9)"() = new()
end

mutable struct var"struct (unnamed at /home/stefan/.julia/artifacts/d7abc8767e8a099d5939fead030cd46916c2c387/include/igraph/igraph_iterators.h:265:9)"
    from::igraph_integer_t
    to::igraph_integer_t
    directed::igraph_bool_t
    var"struct (unnamed at /home/stefan/.julia/artifacts/d7abc8767e8a099d5939fead030cd46916c2c387/include/igraph/igraph_iterators.h:265:9)"() = new()
end

mutable struct var"struct (unnamed at /home/stefan/.julia/artifacts/d7abc8767e8a099d5939fead030cd46916c2c387/include/igraph/igraph_iterators.h:56:9)"
    vid::igraph_integer_t
    mode::igraph_neimode_t
    var"struct (unnamed at /home/stefan/.julia/artifacts/d7abc8767e8a099d5939fead030cd46916c2c387/include/igraph/igraph_iterators.h:56:9)"() = new()
end

mutable struct var"struct (unnamed at /home/stefan/.julia/artifacts/d7abc8767e8a099d5939fead030cd46916c2c387/include/igraph/igraph_iterators.h:60:9)"
    start::igraph_integer_t
    _end::igraph_integer_t
    var"struct (unnamed at /home/stefan/.julia/artifacts/d7abc8767e8a099d5939fead030cd46916c2c387/include/igraph/igraph_iterators.h:60:9)"() = new()
end

# Skipping MacroDefinition: IGRAPH_FUNCATTR_PURE __attribute__ ( ( __pure__ ) )

# Skipping MacroDefinition: IGRAPH_FUNCATTR_CONST __attribute__ ( ( __const__ ) )

# Skipping MacroDefinition: IGRAPH_EXPORT __attribute__ ( ( visibility ( "default" ) ) )

# Skipping MacroDefinition: IGRAPH_NO_EXPORT __attribute__ ( ( visibility ( "hidden" ) ) )

# Skipping MacroDefinition: IGRAPH_DEPRECATED __attribute__ ( ( __deprecated__ ) )

const IGRAPH_VERSION = "0.10.15"

const IGRAPH_VERSION_MAJOR = 0

const IGRAPH_VERSION_MINOR = 10

const IGRAPH_VERSION_PATCH = 15

const IGRAPH_VERSION_PRERELEASE = "cmake-experimental"

const IGRAPH_INTEGER_SIZE = 64

# Skipping MacroDefinition: IGRAPH_DEPRECATED_ENUMVAL __attribute__ ( ( deprecated ) )

# Skipping MacroDefinition: IGRAPH_FUNCATTR_NORETURN __attribute__ ( ( __noreturn__ ) )

const IGRAPH_FINALLY_STACK_EMPTY = IGRAPH_FINALLY_STACK_SIZE() == 0

# Skipping MacroDefinition: CONCAT2x ( a , b ) a ## _ ## b

# Skipping MacroDefinition: CONCAT3x ( a , b , c ) a ## _ ## b ## _ ## c

# Skipping MacroDefinition: CONCAT4x ( a , b , c , d ) a ## _ ## b ## _ ## c ## _ ## d

# Skipping MacroDefinition: CONCAT5x ( a , b , c , d , e ) a ## _ ## b ## _ ## c ## _ ## d ## _ ## e

const BASE = igraph_real_t

const BASE_VECTOR = igraph_vector_t

const BASE_MATRIX = igraph_matrix_t

const OUT_FORMAT = "%g"

const ZERO = 0.0

const ONE = 1.0

const MULTIPLICITY = 1

const NOTORDERED = 1

const NOABS = 1

const HEAPMORE = (>)

const HEAPMOREEQ = (>=)

const HEAPLESS = (<)

const HEAPLESSEQ = (<=)

const ITEM_TYPE = BASE_VECTOR

# Skipping MacroDefinition: IGRAPH_NO_MORE_ATTRIBUTES ( ( const char * ) 0 )

const IGRAPH_SHORTEST_PATH_EPSILON = 1.0e-10

const IGRAPH_THREAD_SAFE = 1

# exports
const PREFIXES = ["igraph"]
for name in names(@__MODULE__; all=true), prefix in PREFIXES
    if startswith(string(name), prefix)
        @eval export $name
    end
end

end # module
