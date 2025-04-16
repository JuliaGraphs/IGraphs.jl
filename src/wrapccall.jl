#= A quick way to check the types most in need of wrappers
julia> a = reduce(vcat, wrapccall.(IGraphs.placeholder)); # when it returns csignature.args
julia> b = counter(a)
julia> sort(collect(pairs(b)),by= x->x.second)[end-45:end]
46-element Vector{Pair{Any, Int64}}:
                         :Csize_t => 13
         :(Ptr{igraph_adjlist_t}) => 14
     :(Ptr{igraph_dqueue_char_t}) => 15
          :(Ptr{igraph_dqueue_t}) => 15
      :(Ptr{igraph_dqueue_int_t}) => 15
              :(Ptr{igraph_vs_t}) => 15
     :(Ptr{igraph_dqueue_bool_t}) => 15
             :(Ptr{igraph_rng_t}) => 17
              :(Ptr{igraph_es_t}) => 17
                            :Cint => 17
                     :igraph_es_t => 18
  :(Ptr{igraph_arpack_options_t}) => 19
       :(Ptr{igraph_isocompat_t}) => 20
     :(Ptr{igraph_bitset_list_t}) => 33
                           :Cchar => 34
     :(Ptr{igraph_matrix_list_t}) => 34
     :(Ptr{igraph_vector_list_t}) => 34
      :(Ptr{igraph_graph_list_t}) => 36
      :(Ptr{igraph_vector_ptr_t}) => 37
       :(Ptr{igraph_strvector_t}) => 39
          :(Ptr{igraph_bitset_t}) => 42
            :(Ptr{igraph_bool_t}) => 43
                :(Ptr{Libc.FILE}) => 50
                :igraph_complex_t => 60
                    :(Ptr{Cvoid}) => 72
     :(Ptr{igraph_matrix_bool_t}) => 76
 :(Ptr{igraph_vector_int_list_t}) => 82
                     :igraph_vs_t => 84
  :(Ptr{igraph_matrix_complex_t}) => 85
  :(Ptr{igraph_vector_complex_t}) => 90
            :(Ptr{igraph_real_t}) => 90
                    :(Ptr{Cchar}) => 91
     :(Ptr{igraph_matrix_char_t}) => 92
       :(Ptr{igraph_sparsemat_t}) => 97
      :(Ptr{igraph_matrix_int_t}) => 101
     :(Ptr{igraph_vector_bool_t}) => 107
                :igraph_neimode_t => 117
     :(Ptr{igraph_vector_char_t}) => 124
         :(Ptr{igraph_integer_t}) => 133
                   :igraph_real_t => 198
          :(Ptr{igraph_matrix_t}) => 228
                   :igraph_bool_t => 272
          :(Ptr{igraph_vector_t}) => 471
      :(Ptr{igraph_vector_int_t}) => 523
                 :(Ptr{igraph_t}) => 593
                :igraph_integer_t => 902
=#

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
    new_entries = Any[:(using IGraphs: last_thrown_error_ref)]
    append!(new_entries, modifybinding.(module_entries))
    mod.args[3].args = new_entries
    mod
end

const nativetypes = Set([ # cenums are elsewhere, because we are dynamically gathering them (and because we want to exclude them from nativepointertypes)
    :igraph_integer_t, :igraph_bool_t, :igraph_real_t
])
const nativepointertypes = Set([:(Ptr{$t}) for t in nativetypes])
const wrappedtypes = Dict(
    :(Ptr{igraph_t})=>:IGraph,
    :(Ptr{igraph_vector_int_t})=>:IGVectorInt,
    :(Ptr{igraph_vector_t})=>:IGVectorFloat,
    :(Ptr{igraph_vector_complex_t})=>:IGVectorComplex,
    :(Ptr{igraph_vector_bool_t})=>:IGVectorBool,
    :(Ptr{igraph_vector_char_t})=>:IGVectorChar,
    :(Ptr{igraph_matrix_int_t})=>:IGMatrixInt,
    :(Ptr{igraph_matrix_t})=>:IGMatrixFloat,
    :(Ptr{igraph_matrix_complex_t})=>:IGMatrixComplex,
    :(Ptr{igraph_matrix_bool_t})=>:IGMatrixBool,
    :(Ptr{igraph_matrix_char_t})=>:IGMatrixChar,
    :(Ptr{igraph_bitset_t})=>:IGBitSet,
    #:(Ptr{igraph_graph_list_t})=>:IGraphList,
    :(Ptr{igraph_vector_int_list_t})=>:IGVectorIntList,
    :(Ptr{igraph_vector_list_t})=>:IGVectorFloatList,
    :(Ptr{igraph_matrix_list_t})=>:IGMatrixFloatList,
    :(Ptr{igraph_bitset_list_t})=>:IGBitSetList,
    :(Ptr{igraph_adjlist_t})=>:IGAdjList,
)
const permittedinputtypes = nativetypes ∪ keys(wrappedtypes)
const permittedtypes = permittedinputtypes ∪ nativepointertypes

function convertedargs(args, csignature)
    passed_args = [ # the arguments sent to the c-binding
        if t ∈ nativetypes # just cast native isbits types
            :(($t)($a))
        elseif t ∈ cenums # just forward with a typeassert
            :(($a)::($t))
        elseif t ∈ nativepointertypes # if the c-binding requests pointer to isbits types, extract such a pointer from a 0D julia array of the necessary type
            :(pointer($a))
        elseif haskey(wrappedtypes,t) # if the c-binding requests pointer to sophisticated structure, permit that only if we have a wrapper type for such structures
            :(($a).objref)
        else
            a
        end
        for (a,t) in zip(args,csignature)
    ]
    new_pointer_args = [ # arguments that are sent as pointers to the c-binding but we are simply returning from the julian function
        :($a = fill($(t.args[2])(0),())) # prepare a 0D array for that argument in order to be able to provide pointers to the c-binding
        for (a,t) in zip(args,csignature)
        if t ∈ nativepointertypes
    ]
    in_args = [ # the input arguments for the julian function (i.e. the c-binding arguments after excluding the pointers to isbits types)
        a
        for (a,t) in zip(args,csignature)
        if t ∈ permittedinputtypes || t ∈ cenums
    ]
    return passed_args, new_pointer_args, in_args
end

const returntypes = Dict(
    :igraph_bool_t => :Bool,
    :igraph_integer_t => :Int,
    :igraph_real_t => :Float64,
    :igraph_complex_t => :ComplexF64,
    :Cint => :Int,
    :Cchar => :Char,
)
allreturntypes = union(Set([:igraph_error_t,:Cvoid]), keys(returntypes))

function convertedreturn(creturntype, args, csignature)
    new_pointer_args = [ # arguments that are sent as pointers to the c-binding but we are simply returning from the julian function
        :($(returntypes[t.args[2]])($(a)[])) # they are stored in a 0D array, but we just want to return the content isbits object
        for (a,t) in zip(args,csignature)
        if t ∈ nativepointertypes
    ]
    ret = isempty(new_pointer_args) ? :(nothing) : :($(new_pointer_args...),)
    if creturntype == :igraph_error_t
        quote
            if res!=0
                throw(last_thrown_error_ref[])
                last_thrown_error_ref[] = nothing
            end
            return $ret
        end
    elseif creturntype == :Cvoid
        :(return $ret)
    elseif haskey(returntypes, creturntype)
        :(return $(returntypes[creturntype])(res))
    else
        :(return res)
    end
end

allbindings = Vector{Any}()
translatedbindings = Vector{Any}()
untranslatedbindings = Vector{Any}()

function wrapccall(binding_func)
    push!(allbindings, binding_func)
    callhead, body = binding_func.args
    name = callhead.args[1]
    @assert string(name)[1:7]=="igraph_" || string(name)[1:7]=="IGRAPH_"
    wrapper_name = Symbol(string(name)[8:end])
    args = callhead.args[2:end]
    theccall = body.args[findfirst(a->!(a isa LineNumberNode), body.args)]
    creturntype = theccall.args[3]
    csignature = theccall.args[4]
    #return csignature.args
    #return creturntype
    if all(x->x∈permittedtypes || x∈cenums, csignature.args) && !isempty(csignature.args) && creturntype ∈ allreturntypes
        push!(translatedbindings, wrapper_name)
        passed_args, new_pointer_args, in_args = convertedargs(args, csignature.args)
        new_return = convertedreturn(creturntype, args, csignature.args)
        wrapper = quote
            function $(wrapper_name)($(in_args...))
                $(new_pointer_args...)
                res =
                #GC.@preserve $(args...) begin
                    $(name)($(passed_args...))
                #end
                $(new_return)
            end
        end
        #if name==:igraph_get_eid
        #    println(wrapper)
        #end
        return wrapper
    else
        push!(untranslatedbindings, binding_func)
    end
    nothing
end
