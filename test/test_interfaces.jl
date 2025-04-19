@testitem "Interface tests" begin

import Interfaces, BaseInterfaces
using IGraphs
using Test

for (VTs, ET, _) in IGraphs.vtypes
    VT = eval(VTs)
    Interfaces.test(BaseInterfaces.IterationInterface, VT, [VT(rand(ET,10))])
    Interfaces.test(BaseInterfaces.IterationInterface{(:indexing)}, VT, [VT(rand(ET,10))])

    Interfaces.test(BaseInterfaces.ArrayInterface, VT, [VT(rand(ET,10))])
    Interfaces.test(BaseInterfaces.ArrayInterface{(:logical,:setindex!)}, VT, [VT(rand(ET,10))])

    v = VT(rand(ET,10))
    @test Vector(VT(Vector(v))) == Vector(v)
    @test VT(Vector(v)) == v
end

for (MTs, ET, _) in IGraphs.mtypes
    MT = eval(MTs)
    Interfaces.test(BaseInterfaces.IterationInterface, MT, [MT(rand(ET,10,5))])
    Interfaces.test(BaseInterfaces.IterationInterface{(:indexing)}, MT, [MT(rand(ET,10,5))])


    Interfaces.test(BaseInterfaces.ArrayInterface, MT, [MT(rand(ET,10,5))])
    Interfaces.test(BaseInterfaces.ArrayInterface{(:logical,:setindex!)}, MT, [MT(rand(ET,10,5))])

    m = MT(rand(ET,10,5))
    @test Matrix(MT(Matrix(m))) == Matrix(m)
    @test MT(Matrix(m)) == m
end

end
