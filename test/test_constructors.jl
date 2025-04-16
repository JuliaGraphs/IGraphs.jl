@testitem "Error handler" begin
using Test
using IGraphs

wrappers = values(IGraphs.wrappedtypes)

[eval(:($v(;_uninitialized=Val(false)))) for v in wrappers]

#[eval(:($v(;_uninitialized=Val(true)))) for v in wrappers] # these crash, as destroy on uninitialized instances is not defined

GC.gc()

end
