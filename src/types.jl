struct IGraph
    objref::LibIGraph.igraph_t
end
IGraph() = IGraph(LibIGraph.igraph_t())



struct IGVectorInt
    objref::LibIGraph.igraph_vector_int_t
end
IGVectorInt() = IGVectorInt(LibIGraph.igraph_vector_int_t())

struct IGVectorFloat
    objref::LibIGraph.igraph_vector_t
end
IGVectorFloat() = IGVectorFloat(LibIGraph.igraph_vector_t())

struct IGVectorComplex
    objref::LibIGraph.igraph_vector_complex_t
end
IGVectorComplex() = IGVectorComplex(LibIGraph.igraph_vector_complex_t())

struct IGVectorBool
    objref::LibIGraph.igraph_vector_bool_t
end
IGVectorBool() = IGVectorBool(LibIGraph.igraph_vector_bool_t())

struct IGVectorChar
    objref::LibIGraph.igraph_vector_char_t
end
IGVectorChar() = IGVectorChar(LibIGraph.igraph_vector_char_t())



struct IGMatrixInt
    objref::LibIGraph.igraph_matrix_int_t
end
IGMatrixInt() = IGMatrixInt(LibIGraph.igraph_matrix_int_t())

struct IGMatrixFloat
    objref::LibIGraph.igraph_matrix_t
end
IGMatrixFloat() = IGMatrixFloat(LibIGraph.igraph_matrix_t())

struct IGMatrixComplex
    objref::LibIGraph.igraph_matrix_complex_t
end
IGMatrixComplex() = IGMatrixComplex(LibIGraph.igraph_matrix_complex_t())

struct IGMatrixBool
    objref::LibIGraph.igraph_matrix_bool_t
end
IGMatrixBool() = IGMatrixBool(LibIGraph.igraph_matrix_bool_t())

struct IGMatrixChar
    objref::LibIGraph.igraph_matrix_char_t
end
IGMatrixChar() = IGMatrixChar(LibIGraph.igraph_matrix_char_t())



struct IGBitSet
    objref::LibIGraph.igraph_bitset_t
end
IGBitSet() = IGBitSet(LibIGraph.igraph_bitset_t())



struct IGraphList
    objref::LibIGraph.igraph_graph_list_t
end
IGraphList() = IGraphList(LibIGraph.igraph_graph_list_t())

struct IGVectorIntList
    objref::LibIGraph.igraph_vector_int_list_t
end
IGVectorIntList() = IGVectorIntList(LibIGraph.igraph_vector_int_list_t())

struct IGVectorFloatList
    objref::LibIGraph.igraph_vector_list_t
end
IGVectorFloatList() = IGVectorFloatList(LibIGraph.igraph_vector_list_t())

struct IGMatrixFloatList
    objref::LibIGraph.igraph_matrix_list_t
end
IGMatrixFloatList() = IGMatrixFloatList(LibIGraph.igraph_matrix_list_t())

struct IGBitSetList
    objref::LibIGraph.igraph_bitset_list_t
end
IGBitSetList() = IGBitSetList(LibIGraph.igraph_bitset_list_t())
