Base.ComplexF64(v::LibIGraph.igraph_complex_t) = ComplexF64(v.dat[1], v.dat[2])

LibIGraph.igraph_complex_t(z::Complex) = LibIGraph.igraph_complex_t((LibIGraph.igraph_real_t(z.re), LibIGraph.igraph_real_t(z.im)))
LibIGraph.igraph_complex_t(z::Number) = LibIGraph.igraph_complex_t(complex(z))
