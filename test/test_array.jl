@testitem "Array API checks" begin

import Graphs
using IGraphs
using Test

v = IGVectorComplex()
push!(v, 1+2im)
push!(v, 3+4im)
push!(v, 5+6im)
push!(v, 1)
push!(v, (1,1))
@test collect(v) == [1+2im, 3+4im, 5+6im, 1, 1+1im]


end
